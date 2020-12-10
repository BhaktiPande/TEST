IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQSettingSave')
DROP PROCEDURE [dbo].[st_MCQSettingSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the  MCQSetting  details

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		24-April-2019

M
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_MCQSettingSave]
	 @MCQS_ID							INT	=0 OUTPUT		    		
   	,@inp_FirstTimeLogin              		BIT
	,@inp_IsSpecificPeriodWise				BIT
	,@inp_FrequencyOfMCQ					INT	
	,@inp_IsDatewise						BIT	
	,@inp_FrequencyDate 		        	DATETIME	
	,@inp_FrequencyDuration           		INT
	,@inp_BlockUserAfterDuration			BIT	
	,@inp_NoOfQuestionForDisplay      		INT
	,@inp_AccessTOApplicationForWriteAnswer	INT
	,@inp_NoOfAttempts                      INT 
	,@inp_BlockuserAfterExceedAtempts 		BIT
	,@inp_UnblockForNextFrequency			BIT	
	,@inp_iOperation					varchar(50)
	,@inp_CreatedBy							INT
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	AS
AS
BEGIN

	DECLARE @ERR_MCQINFO_SAVE INT = 54093 -- Error occurred while saving MCQ details .
	
		DECLARE @nRetValue INT = 0

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Save the UserEducation details
		DECLARE @nPeriodType								INT
	    DECLARE @dtPEStartDate								DATETIME
	    DECLARE @dtPEEndDate								DATETIME
	    DECLARE @nYearCodeId								INT, 
		@nPeriodCodeId										INT 
		DECLARE @dtToday									DATETIME = dbo.uf_com_GetServerDate()
		
		BEGIN
			IF(@inp_iOperation='INSERT')
			BEGIN
			
					IF NOT EXISTS(SELECT MCQS_ID FROM MCQ_MasterSettings)
					BEGIN
							INSERT INTO MCQ_MasterSettings
							(
									FirstTimeLogin  ,            		
									IsSpecificPeriodWise,				
									FrequencyOfMCQ	,					
									IsDatewise,							
									FrequencyDate 	,	        		
									FrequencyDuration,           		
									BlockUserAfterDuration	,			
									NoOfQuestionForDisplay,      		
									AccessTOApplicationForWriteAnswer,	
									NoOfAttempts,                        
									BlockuserAfterExceedAtempts ,		
									UnblockForNextFrequency	,			
									CreatedBy,
									CreatedOn ,               
									UpdatedBy ,                  		
									UpdatedOn   
							 ) 
							 VALUES
							 (
								 @inp_FirstTimeLogin              		
								,@inp_IsSpecificPeriodWise				
								,@inp_FrequencyOfMCQ					
								,@inp_IsDatewise						
								,@inp_FrequencyDate 		        	
								,@inp_FrequencyDuration           		
								,@inp_BlockUserAfterDuration			
								,@inp_NoOfQuestionForDisplay      		
								,@inp_AccessTOApplicationForWriteAnswer	
								,@inp_NoOfAttempts                      
								,@inp_BlockuserAfterExceedAtempts 		
								,@inp_UnblockForNextFrequency			
								,@inp_CreatedBy	
								,GETDATE()	
								,@inp_CreatedBy	
								,GETDATE()		 
							 
							 )
					END
			END
					
			IF(@inp_iOperation='UPDATE')
			BEGIN
							
							UPDATE MCQ_MasterSettings SET
									FirstTimeLogin              	  	=@inp_FirstTimeLogin					,	
									IsSpecificPeriodWise				=@inp_IsSpecificPeriodWise				,
									FrequencyOfMCQ						=@inp_FrequencyOfMCQ					,
									IsDatewise							=@inp_IsDatewise						,
									FrequencyDate 		        		=@inp_FrequencyDate 		        	,
									FrequencyDuration           		=@inp_FrequencyDuration           		,
									BlockUserAfterDuration				=@inp_BlockUserAfterDuration			,
									NoOfQuestionForDisplay      		=@inp_NoOfQuestionForDisplay      		,
									AccessTOApplicationForWriteAnswer	=@inp_AccessTOApplicationForWriteAnswer	,
									NoOfAttempts                        =@inp_NoOfAttempts                      ,
									BlockuserAfterExceedAtempts 		=@inp_BlockuserAfterExceedAtempts 		,
									UnblockForNextFrequency				=@inp_UnblockForNextFrequency			,
									UpdatedBy                   		=@inp_CreatedBy							,
									UpdatedOn							=GETDATE()	
									WHERE MCQS_ID=@MCQS_ID

									
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
						
							UPDATE MCQ_CheckUsrStatus SET MCQPerioEndDate=@dtPEEndDate
						END

						DECLARE @FrequencyDuration INT=0
						DECLARE @dFrequencyDate DATETIME=NULL

						SELECT @FrequencyDuration=FrequencyDuration,@dFrequencyDate=ISNULL(FrequencyDate,NULL) FROM MCQ_MasterSettings
						
						IF(@FrequencyDuration IS NOT NULL)
						BEGIN
								DECLARE @nCount INT=0
								DECLARE @nTotCount INT=0						

								CREATE TABLE #tmpFrequencyChange
								(
								ID INT IDENTITY(1,1) ,
								UserInfoID INT
								)
								INSERT INTO #tmpFrequencyChange
								select userinfoid from usr_userinfo where UserTypeCodeId=101003 and  userinfoid not in (select userinfoid from MCQ_UserResultDetails) 
								SELECT @nTotCount=COUNT(userinfoid) FROM #tmpFrequencyChange
								WHILE @nCount<@nTotCount
								BEGIN
								DECLARE @inp_iUserInfoId INT=0
								SELECT @inp_iUserInfoId=UserInfoID FROM #tmpFrequencyChange WHERE ID=@nCount+1

								DECLARE @LastLogin datetime
								SELECT @LastLogin=LastLoginTime from  usr_authentication where userinfoid=@inp_iUserInfoId
								DECLARE @result int=0;
										IF NOT EXISTS (select userinfoid from MCQ_UserResultDetails where userinfoid=@inp_iUserInfoId)
										BEGIN	
														IF(@dFrequencyDate IS NULL OR @dFrequencyDate=' ')
														BEGIN
														   SET @dFrequencyDate=@dtPEStartDate
														END
														
														IF (@LastLogin between @dtPEStartDate and ( @dtPEStartDate+@FrequencyDuration))
														BEGIN												
															update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId												
														END
														ELSE IF(@LastLogin between @dFrequencyDate and ( @dFrequencyDate+@FrequencyDuration))
														BEGIN
															update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId	
														END
																								
										END
								SET @nCount=@nCount+1
								END
								DROP TABLE #tmpFrequencyChange
						 END
			END	
			IF(@inp_iOperation='SELECT')
			begin
					select MCQS_ID,
							FirstTimeLogin,	
							IsSpecificPeriodWise,	
							FrequencyOfMCQ,	
							IsDatewise,	
							FrequencyDate,	
							FrequencyDuration,
							BlockUserAfterDuration,	
							NoOfQuestionForDisplay,	
							AccessTOApplicationForWriteAnswer,	
							NoOfAttempts,	
							BlockuserAfterExceedAtempts,	
							UnblockForNextFrequency,	
							CreatedBy,	
							CreatedOn,	
							UpdatedBy,	
							UpdatedOn
					from MCQ_MasterSettings 
			end
		END
		
		
						
		IF @out_nReturnValue <> 0
		BEGIN
			RETURN @out_nReturnValue
		END

		SET @out_nReturnValue = 0
		
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_MCQINFO_SAVE, ERROR_NUMBER())
	END CATCH
END
GO


