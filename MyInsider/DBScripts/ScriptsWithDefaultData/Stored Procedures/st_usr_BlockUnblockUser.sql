

/*-------------------------------------------------------------------------------------------------
Description:	Block / unblock user

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		13-May-2019

-------------------------------------------------------------------------------------------------*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_BlockUnblockUser')
	DROP PROCEDURE st_usr_BlockUnblockUser
GO

CREATE PROCEDURE st_usr_BlockUnblockUser
	 @UserInfoID					int=0,
	 @IsBlocked						bit =false,
	 @Blocked_UnBlock_Reason		VARCHAR(MAX)=null,
	 @CreatedBy						INT =0,
	 @out_nReturnValue				INT = 0 OUTPUT,
	 @out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	
AS
BEGIN

	DECLARE @ERR_User_UPDATE	INT = 54141 -- Error occured while updatting user 
		
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			Declare @inp_iQuestionId int=0
			Declare @MCQExamDate datetime
			
			update  usr_UserInfo set
					isblocked=@IsBlocked,
					Blocked_UnBlock_Reason=@Blocked_UnBlock_Reason,
					UnBlocked_Date=case when @IsBlocked=1 then null else getdate() end,
					FrequencyDateBYAdmin=case when @IsBlocked=1 then null else getdate() end,
					ModifiedBY=@CreatedBy,
					ModifiedOn=getdate() where userInfoid=@UserInfoID
			
			
			 select Top 1 
					@MCQExamDate=mua.CreatedOn    
			from MCQ_UserAnswerDetails as mua inner join usr_userinfo as ur on mua.userInfoid=ur.userInfoid where mua.userinfoid=@UserInfoID order by mua.CreatedOn desc
			
			update  MCQ_UserBlockedDetails
				set 	
				Blocked_UnBlock_Reason=@Blocked_UnBlock_Reason	,
				UnBlocked_Date=getdate(),		
				FrequencyDateBYAdmin=getdate(),	
				MCQ_ExamDate=@MCQExamDate,			
				UpdatedBy=@CreatedBy ,              
				UpdatedOn     =getdate()          
				where userInfoid=@UserInfoID and  MCQ_ExamDate=@MCQExamDate
			RETURN @out_nReturnValue
		
		SET @out_nReturnValue = 0	
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_User_UPDATE, ERROR_NUMBER())
		
	END CATCH
END
