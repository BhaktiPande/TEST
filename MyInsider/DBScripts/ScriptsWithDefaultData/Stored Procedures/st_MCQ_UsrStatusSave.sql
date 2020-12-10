/*-------------------------------------------------------------------------------------------------
Description:	Save the MCQ Question  details

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		01-Jul-2019

-------------------------------------------------------------------------------------------------*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_UsrStatusSave')
	DROP PROCEDURE st_MCQ_UsrStatusSave
GO

CREATE PROCEDURE st_MCQ_UsrStatusSave	
	 @UserInfoID					INT,
	 @MCQStatus						BIT,
	 @MCQPerioEndDate				DATETIME,
	 @out_nReturnValue				INT = 0 OUTPUT,
	 @out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	
AS
BEGIN

	DECLARE @ERR_MCQQuestion_SAVE	INT = 54139 -- Error occured while saving question details			
							
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		DECLARE @inp_iQuestionId INT=0

		DECLARE @nPeriodType								INT
	    DECLARE @dtPEStartDate								DATETIME
	    DECLARE @dtPEEndDate								DATETIME=NULL
	    DECLARE @nYearCodeId								INT, 
		@nPeriodCodeId								        INT 
	    DECLARE @dtToday									DATETIME = dbo.uf_com_GetServerDate()
		DECLARE @dFrequencyDate								DATETIME=NULL	

		
		IF(@MCQPerioEndDate IS NULL)
		BEGIN		
			SELECT @nPeriodType=FrequencyOfMCQ FROM [dbo].[MCQ_MasterSettings]
			IF(@nPeriodType IS NOT NULL)
			BEGIN
					SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
									WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
									WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
									WHEN @nPeriodType = 137004	THEN 123002 -- Weekly
									ELSE @nPeriodType
									END

					EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
					   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtToday, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			 END		
		 END
		 
		 SELECT @dFrequencyDate=ISNULL(FrequencyDate,NULL) FROM [MCQ_MasterSettings]				
		
		IF(NOT EXISTS(SELECT * FROM MCQ_CheckUsrStatus WHERE UserInfoId=@UserInfoID))
		 BEGIN	
			    INSERT INTO MCQ_CheckUsrStatus
					(															
						UserInfoId,							
						MCQStatus,							
						MCQPerioEndDate,
						FrequencyDate,						
						CreatedBy ,                  		
						CreatedOn ,                  		
						UpdatedBy ,                  		
						UpdatedOn 
					)
					VALUES
					(
						@UserInfoID,
						@MCQStatus,
						@dtPEEndDate,
						@dFrequencyDate,
						@UserInfoID,
						GETDATE(),
						@UserInfoID,
						GETDATE()					
					)				
			END
		ELSE
		BEGIN
			UPDATE MCQ_CheckUsrStatus
						SET 
						UserInfoId=@UserInfoID,							
						MCQStatus=@MCQStatus,							
						MCQPerioEndDate=@dtPEEndDate,	
						FrequencyDate=	@dFrequencyDate,					
						CreatedBy= @UserInfoID,                  		
						CreatedOn=GETDATE() ,                  		
						UpdatedBy =@UserInfoID,                  		
						UpdatedOn =GETDATE()
			WHERE UserInfoId=@UserInfoID
		END		
		
		SET @out_nReturnValue = 0	
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_MCQQuestion_SAVE, ERROR_NUMBER())		
	END CATCH
END
