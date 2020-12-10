/*-------------------------------------------------------------------------------------------------
Description:	Save the MCQ Question  details

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		06-May-2019

-------------------------------------------------------------------------------------------------*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_QuestionDetails')
	DROP PROCEDURE st_MCQ_QuestionDetails
GO

CREATE PROCEDURE st_MCQ_QuestionDetails
	 @inp_tblMCQQuestionType       MCQQuestionType READONLY,
	 @QuestionId					int=0,
	 @UserInfoID					int=0,
	 @Question						VARCHAR(MAX)=NULL,
	 @AnswerType					INT=2 ,--1-Redio button 2-Check box
	 @OptionNumber					INT=0,
	 @inp_iOperation				VARCHAR(50)=null,
	 @AttemptNo						INT=0,
	 @out_nReturnValue				INT = 0 OUTPUT,
	 @out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	
AS
BEGIN

					DECLARE @ERR_MCQQuestion_SAVE	INT = 54139 -- Error occured while saving question details
					DECLARE @ERR_MCQQuestion_Delete	INT = 54153
					DECLARE @ISDELETE_ERROR			BIT=0
					DECLARE @inp_iUserInfoId		INT =@UserInfoID
					DECLARE @FrequencyOfMCQs		CHAR(5)
					DECLARE @AttemptNos				INT
					DECLARE @FalseAnswer			INT  
					DECLARE @CorrectAnswer			INT 
					DECLARE @ResultDuringFrequency	CHAR(10)
					DECLARE @UserMessage			VARCHAR(MAX)
					DECLARE @AttemptMessage			VARCHAR(MAX)
					DECLARE @BlockedUserMessage		VARCHAR(MAX)
					DECLARE @TotalAttempts			INT

					DECLARE @FirstTimeLogin bit
					DECLARE @IsSpecificPeriodWise bit
					DECLARE @FrequencyOfMCQ int
					DECLARE @IsDatewise bit
					DECLARE @FrequencyDate datetime
					DECLARE @FrequencyDuration int
					DECLARE @BlockUserAfterDuration int
					DECLARE @AccessTOApplicationForWriteAnswer int
					DECLARE @DisplayNoOfQuestions int
					DECLARE @NoOfAttempts int
					DECLARE @BlockuserAfterExceedAtempts bit
					DECLARE @UnblockForNextFrequency bit
					DECLARE @currentAttempt int
					DECLARE @MCQDateExpMessage VARCHAR(MAX)
					DECLARE @MaxAttemptMessage VARCHAR(MAX)
					DECLARE @RemainingAttemptMessage VARCHAR(MAX)
					DECLARE @SuccessMessage VARCHAR(MAX)
					DECLARE @FailMessage VARCHAR(MAX)
					DECLARE @BlockedMessage VARCHAR(MAX)

					SELECT @MaxAttemptMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54116'
					SELECT @RemainingAttemptMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54117'
					SELECT @SuccessMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54118'
					SELECT @FailMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54119'
					SELECT @BlockedMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54120'
					SELECT @MCQDateExpMessage=ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54123'

							
					SELECT @FirstTimeLogin=FirstTimeLogin,
						   @IsSpecificPeriodWise=IsSpecificPeriodWise,
						   @FrequencyOfMCQ=  CASE 
							WHEN FrequencyOfMCQ = 137001 THEN 123001 -- Yearly
							WHEN FrequencyOfMCQ = 137002 THEN 123003 -- Quarterly
							WHEN FrequencyOfMCQ = 137003 THEN 123004 -- Monthly
							WHEN FrequencyOfMCQ = 137004 THEN 123002 -- half yearly
							ELSE FrequencyOfMCQ
							END			 ,
						   @IsDatewise=IsDatewise,
						   @FrequencyDate=FrequencyDate,
						   @FrequencyDuration=(FrequencyDuration),
						   @BlockUserAfterDuration=BlockUserAfterDuration,
						   @NoOfAttempts=NoOfAttempts,
						   @BlockuserAfterExceedAtempts=BlockuserAfterExceedAtempts,
						   @UnblockForNextFrequency=UnblockForNextFrequency,
						   @DisplayNoOfQuestions=NoOfQuestionForDisplay,
						   @AccessTOApplicationForWriteAnswer=AccessTOApplicationForWriteAnswer
					FROM MCQ_MasterSettings
							
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		DECLARE @inp_iQuestionId INT=0
		
		IF(@inp_iOperation='INSERT')
		 BEGIN
		 
		
			    INSERT INTO MCQ_QuestionBank
					(
						Question,
						AnswerTypes	,
						OptionNumbers,
						CreatedBy,	
						CreatedOn	,
						UpdatedBy,	
						UpdatedOn
					)
					VALUES
					(
						@Question,
						@AnswerType,
						@OptionNumber,
						@UserInfoID,
						GETDATE(),
						@UserInfoID,
						GETDATE()
					
					)
				SET @inp_iQuestionId = SCOPE_IDENTITY()
				print @inp_iQuestionId
				IF(@inp_iQuestionId!=0)
				BEGIN
					INSERT INTO MCQ_QuestionBankDetails
					(
						OptionNo,
						QuestionID,
						QuestionsAnswer,
						CorrectAnswer,
						CreatedBy,	
						CreatedOn	,
						UpdatedBy,	
						UpdatedOn
					)
					SELECT OptionNo,
						@inp_iQuestionId,
						QuestionsAnswer,
						CorrectAnswer,
						@UserInfoID,
						GETDATE(),
						@UserInfoID,
						GETDATE() FROM @inp_tblMCQQuestionType
				END
			END
		 if(@inp_iOperation='UPDATE')
		 BEGIN
				UPDATE MCQ_QuestionBank SET
						Question=@Question,
						AnswerTypes	=@AnswerType,
						OptionNumbers=@OptionNumber,
						UpdatedBy=@UserInfoID,
						UpdatedOn= GETDATE()
						WHERE QuestionID=@QuestionId
						
										
				UPDATE MCQ_QuestionBankDetails 
								SET MCQ_QuestionBankDetails.QuestionsAnswer=tblType.QuestionsAnswer ,
									MCQ_QuestionBankDetails.CorrectAnswer=tblType.CorrectAnswer, 
									MCQ_QuestionBankDetails.UpdatedBy = @UserInfoID,
									MCQ_QuestionBankDetails.UpdatedON=GetDate()
				FROM MCQ_QuestionBank MQB 
				inner join MCQ_QuestionBankDetails as MQBD on MQBD.QuestionID=MQB.QuestionId 
				inner join @inp_tblMCQQuestionType as tblType on tblType.QuestionBankDetailsID=MQBD.QuestionBankDetailsID
				WHERE mqbd.questionid=@QuestionId  
						
						
		 END
		IF(@inp_iOperation='SELECT')
		 BEGIN
				SELECT MQB.QuestionId,
						Question,
						AnswerTypes	,
						OptionNumbers,
						(SELECT OptionNo +'.'+QuestionsAnswer +'~' FROM MCQ_QuestionBankDetails MQBD  WHERE MQB.QuestionId=MQBD.QuestionId ORDER BY OptionNo FOR XML PATH('')) QuestionAnswer,
						(SELECT convert(VARCHAR, QuestionBankDetailsID) +'~'   from MCQ_QuestionBankDetails MQBD  WHERE MQB.QuestionId=MQBD.QuestionId ORDER BY OptionNo FOR XML PATH('')) QuestionAnswerWithID,
						(SELECT CASE WHEN CorrectAnswer=1 THEN QuestionsAnswer+'~' ELSE '' END FROM MCQ_QuestionBankDetails MQBD  WHERE MQB.QuestionId=MQBD.QuestionId  FOR XML PATH('')) CorrectAnswer
						FROM MCQ_QuestionBank as MQB WHERE QuestionId=@QuestionId
		 end
		 IF(@inp_iOperation='SELECT_MCQ_QUESTIONS')
		 BEGIN
			DECLARE @count int = (select NoOfQuestionForDisplay from MCQ_MasterSettings)

			SELECT   RowNum,Question,QuestionAnswer,AnswerTypes,QuestionID from 
			(
			SELECT  dense_rank() OVER (ORDER BY  NEWID()) AS RowNum, NEWID() as OptionNumbers, 
			MQB.Question,
			(SELECT convert(VARCHAR, QuestionBankDetailsID ) +'.'+QuestionsAnswer +'~' FROM MCQ_QuestionBankDetails MQBD  WHERE MQB.QuestionId=MQBD.QuestionId ORDER by OptionNo FOR XML PATH('')) QuestionAnswer,
			MQB.AnswerTypes,
			QuestionID
			 FROM MCQ_QuestionBank as MQB 
			) tb1 WHERE RowNum <=@count
			
		 END
		 IF(@inp_iOperation='DELETE')
		 BEGIN
				SET @ISDELETE_ERROR=1
				delete from MCQ_QuestionBankDetails where QuestionId=@QuestionId
				delete from MCQ_QuestionBank where QuestionId=@QuestionId
		 END
		 IF(@inp_iOperation='ValidateUserSettings')
		 BEGIN 
							declare @FrequencyDateForNewUser DATETIME =  @FrequencyDate;
							 IF((SELECT FREQUENCYDATE FROM MCQ_MASTERSETTINGS)< DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) and @FrequencyOfMCQ=123004 and @IsDatewise=1 )
							 BEGIN													 
									 set @FrequencyDate = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
							 END
							 ELSE IF( @FrequencyOfMCQ=123004 and @IsDatewise=0)
							 BEGIN								
									 set @FrequencyDate = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
							 END
							 ELSE IF (@FrequencyOfMCQ=123001 or  @FrequencyOfMCQ =123003 or  @FrequencyOfMCQ =123002)
							 BEGIN							 	
									set @FrequencyDate =GETDATE()
							 END
							
							    DECLARE @CurrentFrequencyOfMCQ VARCHAR(50)=NULL

									  DECLARE @nYearCodeId int=null
									  DECLARE @nPeriodCodeId int=null
									  DECLARE @dtStartDate datetime=getdate()
									  DECLARE @dtEndDate datetime
									  
						
									DECLARE @UnBlocked_Date datetime
									 set @UnBlocked_Date =(select UnBlocked_Date from usr_userinfo where userinfoid=@inp_iUserInfoId and   convert(dateTIME,getdate(),103) between convert(dateTIME,UnBlocked_Date,103) and  (CONVERT(DATETIME, UnBlocked_Date)+ @FrequencyDuration) )
								
									 EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
												@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@FrequencyDate,@FrequencyOfMCQ, 0, 
												@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
												@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
								
						print('@FrequencyDate sh')
						print (@FrequencyDate)
						print('@FrequencyDateForNewUser')
						print(@FrequencyDateForNewUser)
						set @FrequencyDuration=@FrequencyDuration-1
								IF (@FrequencyOfMCQ=123001 or  @FrequencyOfMCQ =123003 or  @FrequencyOfMCQ =123002)
								BEGIN
								print('@dtStartDate+@FrequencyDuration')
								print(@dtStartDate+@FrequencyDuration)
									if((@dtStartDate+@FrequencyDuration)<= @FrequencyDateForNewUser)
									begin
									print 'sh'
									--set @FrequencyDate =@FrequencyDateForNewUser-1
									set @FrequencyDate =@FrequencyDateForNewUser
									end
									else
									begin
									print 'sh1'
									set @FrequencyDate =@dtStartDate
									end
								END
							
									if exists (select userinfoid from usr_userinfo where userinfoid=@inp_iUserInfoId and  convert(date,getdate()) between convert(date,UnBlocked_Date,103) and  (CONVERT(DATETIME, UnBlocked_Date)+ @FrequencyDuration)) -- if user unblocked by co/admin then set frequency date from user infomation 
									begin
									
										set @FrequencyDate=@UnBlocked_Date
										set @dtStartDate=@FrequencyDate
									end
									IF(@FirstTimeLogin=1 and @IsSpecificPeriodWise=0 and @IsDatewise=0)
									BEGIN
										
											IF EXISTS( SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)
											BEGIN
												IF(@UnBlocked_Date !=NULL)
												BEGIN
													 SET @dtStartDate =@UnBlocked_Date
												END
												ELSE
												BEGIN
													SET @dtStartDate= (SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)
												
												END
											END
											ELSE
											BEGIN
																	
													set @dtStartDate= (select convert(date ,getdate(),103))
											END
										
									END
									ELSE IF(@FirstTimeLogin=1 and( @IsSpecificPeriodWise=1 or @IsDatewise=1))
									BEGIN
										if (@BlockUserAfterDuration !=1 or  @BlockuserAfterExceedAtempts !=1)
										begin
													IF EXISTS( SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)
													BEGIN
														IF(@UnBlocked_Date !=NULL)
														BEGIN
															 SET @dtStartDate =@UnBlocked_Date
															 
														END
														ELSE
														BEGIN
															SET @dtStartDate= (SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)
														
														END
													END
													ELSE
													BEGIN
															set @dtStartDate= (select convert(date ,getdate(),103))
												     END
										end
										else if (@BlockUserAfterDuration =1 and @BlockuserAfterExceedAtempts =1)
										begin
												IF EXISTS( SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)
													BEGIN
														IF(@UnBlocked_Date !=NULL)
														BEGIN
															 SET @dtStartDate =@UnBlocked_Date
															 
														END
														ELSE
														BEGIN
														
															 if(@IsSpecificPeriodWise=0 and @IsDatewise=0)
															 begin
																SET @dtStartDate= (SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  ORDER BY MCQ_EXAMDATE ASC)---this is used when Frequency of MCQs to be displayed: both false
															 end
															 else if( ( (select convert(date ,getdate(),103))>= convert(date ,@FrequencyDate,103) and (select convert(date ,getdate(),103)) < @dtEndDate) and  @IsSpecificPeriodWise=1  and @IsDatewise=1  )--first time login yes , user pass MCQ before frequency date 
															 begin
																	print 111111
															 end
															 else if( (select convert(date ,getdate(),103))>= convert(date ,@FrequencyDate,103) and  @IsSpecificPeriodWise=0  and @IsDatewise=1)--first time login yes , user pass MCQ before frequency date & Scheduled Frequency(e.g. Monthly) not set
															 begin
																	set @dtStartDate=@FrequencyDate
															 end
														END
													END
													ELSE
													BEGIN
															set @dtStartDate= (select convert(date ,getdate(),103))
												     END
										end
									END
									IF(@dtEndDate is null and @FirstTimeLogin!=1)
									BEGIN
										IF EXISTS (SELECT userinfoid FROM usr_userinfo WHERE userinfoid=@inp_iUserInfoId and  convert(date,getdate()) between convert(date,UnBlocked_Date,103) and  (CONVERT(DATETIME, UnBlocked_Date)+ @FrequencyDuration)) 
										BEGIN
										SET @dtEndDate=( select @UnBlocked_Date+ @FrequencyDuration); 
										END
										ELSE
										BEGIN
										
										set @dtStartDate= @FrequencyDate
										SET @dtEndDate=(  select @FrequencyDate+ @FrequencyDuration);
										END
									
									END
																		
									print('@dtStartDate')
									print @dtStartDate
									print 'CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration'
									print CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration
									print '@FrequencyDate'
									print @FrequencyDate
									print 'CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration'
									print CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration
									
									IF(@UnBlocked_Date IS NULL OR @UnBlocked_Date=' ')
									BEGIN									
										SELECT @currentAttempt=ISNULL(MAX(AttemptNo),0),@CurrentFrequencyOfMCQ= ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @dtStartDate) and CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration+'23:59:00')) ,
										 ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @FrequencyDate) and CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration+'23:59:00'))  ,'False'))
									 FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId 
																	  and ( MCQ_ExamDate between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration+'23:59:00') or 
																			MCQ_ExamDate between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @dtEndDate)+'23:59:00' ) )
									END
									ELSE
									BEGIN	
										
										SELECT @currentAttempt=ISNULL(MAX(AttemptNo),0),@CurrentFrequencyOfMCQ= ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @dtStartDate,103) and CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration+'23:59:00')) ,
										 ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @FrequencyDate,103) and CONVERT(DATETIME, @FrequencyDate,103)+ @FrequencyDuration+'23:59:00'))  ,'False'))
									 FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId 
																	  and ( MCQ_ExamDate between CONVERT(DATETIME, @dtStartDate,103) and (CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration) or 
																			MCQ_ExamDate between CONVERT(DATETIME, @FrequencyDate,103) and (CONVERT(DATETIME, @dtEndDate,103)+'23:59:00' ) )
																			AND MCQ_ExamDate>CONVERT(DATETIME,@UnBlocked_Date,103)																						  
																												   
									END					
									  
									
									print '@currentAttempt'
									print @currentAttempt			
								
							IF EXISTS( SELECT UserInfoId FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId 
																	   AND AttemptNo= @currentAttempt 
																	   AND ( MCQ_ExamDate between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration+'23:59:00') or 
																			 MCQ_ExamDate between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @dtEndDate+'23:59:00')) 
																		   ))
							BEGIN
							
														SELECT	UserinfoID,
																@CurrentFrequencyOfMCQ as FrequencyOfMCQs ,
																(@currentAttempt+1)as AttemptNo ,
																FalseAnswer,
																CorrectAnswer,
																ResultDuringFrequency, 
																case when @CurrentFrequencyOfMCQ='True' Then (CASE WHEN CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@SuccessMessage,'$1',CorrectAnswer) 
																				ELSE  REPLACE( REPLACE(@FailMessage,'$1',CorrectAnswer),'$2',@DisplayNoOfQuestions ) 
																				 END) 
																 else @MCQDateExpMessage end as UserMessage,
																 REPLACE(@RemainingAttemptMessage,'$1',@NoOfAttempts-@currentAttempt) as AttemptMessage,
																@NoOfAttempts as TotalAttempts,
																CASE WHEN CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@BlockedMessage,'$1',CorrectAnswer) 
																ELSE REPLACE( REPLACE(@BlockedMessage,'$1',CorrectAnswer),'$2',@DisplayNoOfQuestions ) END 
																 as BlockedUserMessage,
																(SELECT  ISNULL(IsBlocked,0) FROM Usr_UserInfo uu WHERE uu.UserInfoId=@inp_iUserInfoId) as IsBlocked, 
																@BlockuserAfterExceedAtempts as BlockuserAfterExceedAtempts ,
																@FirstTimeLogin as FirstTimeLogin,
																@BlockUserAfterDuration AS BlockUserAfterDuration
														 FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId 
																						   AND AttemptNo= @currentAttempt 
																						   AND ( MCQ_ExamDate between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration+'23:59:00') or 
																								 MCQ_ExamDate between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @dtEndDate)+'23:59:00') 
																							   )
							END
							ELSE
							BEGIN
									DECLARE @LastLogin datetime
									DECLARE @CreatedOn datetime
									DECLARE @FirstTimeLoginForNewUSer BIT
									SELECT @LastLogin=LastLoginTime,@CreatedOn=CreatedOn from  usr_authentication where userinfoid=@inp_iUserInfoId
									SELECT @FirstTimeLoginForNewUSer=FirstTimeLogin FROM MCQ_MasterSettings
									
									 
									DECLARE @result int=0;
									IF NOT EXISTS (select userinfoid from MCQ_UserResultDetails where userinfoid=@inp_iUserInfoId)
									BEGIN
												IF(@FrequencyDateForNewUser IS NULL)
												BEGIN 
												SET @FrequencyDateForNewUser=@dtStartDate
												END						
											PRINT '@LastLogin'
													PRINT @LastLogin
											IF(@FirstTimeLoginForNewUSer=1 AND EXISTS(SELECT * FROM MCQ_CheckUsrStatus WHERE MCQStatus=1 AND userinfoid=@inp_iUserInfoId))
											BEGIN
											print(1)
												SET @result= 0
												UPDATE MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
											END											
											ELSE
											BEGIN
											 IF(@FirstTimeLoginForNewUSer=1)
											 begin
											 print(2)
											 SET @result= 0
											 end																					
												else IF ((@LastLogin between @dtStartDate and ( @dtStartDate+@FrequencyDuration)+'23:59:00' ) and @CreatedOn <  @dtStartDate+@FrequencyDuration +'23:59:00')
												BEGIN
													print(3)										
													SET @result= 0
													UPDATE MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
													
												END
												ELSE IF(@CreatedOn < @FrequencyDateForNewUser and CONVERT(DATE,@LastLogin) > CONVERT(DATE,@FrequencyDateForNewUser+@FrequencyDuration))
												BEGIN													
													IF(@BlockUserAfterDuration=1)
													BEGIN
														SET @result= 0
														update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
													END
													ELSE														
													BEGIN
														SET @result= 1
													END												
												END
												ELSE IF(@LastLogin < @FrequencyDateForNewUser )
												BEGIN
												print(5)
												
													IF(@CreatedOn not between ( @dtStartDate+@FrequencyDuration) +'23:59:00' AND @FrequencyDateForNewUser)
													BEGIN
													----Case For old user who are already present in system before MCQ Frequency
													
													---Case if we set future frequency date and Scheduled frequeny as Select and logged in to the system today then all user(existing and new) will go to the dashboard
													
													IF(@IsSpecificPeriodWise=0 AND @CreatedOn<@FrequencyDateForNewUser)
													BEGIN												
														SET @result= 1
													END
													ELSE IF (@IsSpecificPeriodWise=1 AND @IsDatewise=1 AND @BlockUserAfterDuration=0 AND @CreatedOn<@FrequencyDateForNewUser)
													BEGIN
														print(32424)
														SET @result= 1
													END
													ELSE
													BEGIN
														SET @result= 0
														update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
													END
														
													END
													ELSE
													BEGIN
													PRINT(1234)
													--Case Example when we set frequency as Quarterly and frequency Duration as 8 and set frequency date as 16 july 2019 and if user is created between period Start date and the frequency date then allow the user to login to dashboard 
														SET @result= 1
													END
												END
												ELSE IF(@LastLogin > (@FrequencyDateForNewUser+@FrequencyDuration)+'23:59:00' and @BlockUserAfterDuration!=1)
												BEGIN
												print(6)
												print('@FrequencyDateForNewUser+@FrequencyDuration')
												print(@FrequencyDateForNewUser+@FrequencyDuration)
												print('@LastLogin')
												print(@LastLogin)
													SET @result= 1
												END
												ELSE IF(@LastLogin > (@FrequencyDateForNewUser+@FrequencyDuration)and @BlockUserAfterDuration=1 and @CreatedOn <  @dtStartDate+@FrequencyDuration)
												begin
												print(7)
												SET @result= 0
													update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
												end
												ELSE IF(@LastLogin > (@FrequencyDateForNewUser+@FrequencyDuration)+'23:59:00'  and @CreatedOn > @dtStartDate+@FrequencyDuration +'23:59:00')
												begin
												print(8)
												PRINT(@FrequencyDateForNewUser+@FrequencyDuration)
												SET @result= 1											
												end
												ELSE IF(@LastLogin > (@dtStartDate+@FrequencyDuration)+'23:59:00'  and @CreatedOn > @dtStartDate+@FrequencyDuration +'23:59:00')
												begin
												
												IF(@LastLogin < (@FrequencyDateForNewUser+@FrequencyDuration)+'23:59:00'  and @CreatedOn < @FrequencyDateForNewUser+@FrequencyDuration +'23:59:00')
												BEGIN
												SET @result= 0
													update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@inp_iUserInfoId
												END
												ELSE												
												BEGIN
													SET @result= 1	
												END									
												end
											END
											
											
									END

									IF(@CurrentFrequencyOfMCQ='False' and @result= 0)
									BEGIN

										UPDATE usr_UserInfo set IsBlocked=1,ReasonForBlocking=(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124'),Blocked_Date=getdate() where userinfoid=@UserInfoID 
			
										insert into MCQ_UserBlockedDetails
										(
										UserInfoId	,IsBlocked , Blocked_Date,Blocked_UnBlock_Reason,
										UnBlocked_Date,	FrequencyDateBYAdmin,ReasonForBlocking,	MCQ_ExamDate,			
										CreatedBy , CreatedOn  , UpdatedBy ,UpdatedOn               
										)
										select Top 1 
										@UserInfoID,1,getdate() as Blocked_Date,null,
										null as UnBlocked_Date,	null as FrequencyDateBYAdmin,
										(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124') as ReasonForBlocking,
										NULL,@UserInfoID,GETDATE(),@UserInfoID,GETDATE()
									END
					
									
									 select  @inp_iUserInfoId as UserinfoID ,
											 @CurrentFrequencyOfMCQ  as FrequencyOfMCQs,
											(@currentAttempt+1)as AttemptNo,
											 0 as FalseAnswer,
											 0 as CorrectAnswer,
											 case when  @result= 1 then '522002' else '522003' end as ResultDuringFrequency, 
											 case when  isnull((select isblocked from usr_userinfo where isblocked=1 and UserInfoId=@inp_iUserInfoId),0)=1 then @MCQDateExpMessage end   as UserMessage,
											 '' as AttemptMessage,
											 @NoOfAttempts as TotalAttempts,
											 CASE WHEN @CurrentFrequencyOfMCQ='False' THEN  
											 @MCQDateExpMessage  ELSE case when  isnull((select isblocked from usr_userinfo where isblocked=1 and UserInfoId=@inp_iUserInfoId),0)=1 then @MCQDateExpMessage else '' end   END
																 as  BlockedUserMessage,
											 ISNULL((select IsBlocked from Usr_UserInfo uu where uu.UserInfoId=@inp_iUserInfoId),0) as IsBlocked, 
											 @BlockuserAfterExceedAtempts as BlockuserAfterExceedAtempts ,
											 @FirstTimeLogin as FirstTimeLogin,
											 @BlockUserAfterDuration AS BlockUserAfterDuration
						 END  
						 
						 
		 END
		  if(@inp_iOperation='SAVE_EXAM_RESULT')
		  BEGIN
			DECLARE @UAD_ID int =0
			IF(EXISTS(SELECT UserInfoID FROM usr_UserInfo WHERE UserInfoID=@UserInfoID AND isnull(IsBlocked,0)=0))
			BEGIN
			 INSERT INTO MCQ_UserAnswerDetails
			  (
				UserInfoID,	QuestionID,	QuestionBankDetailsID,AttemptNo,
				CorrectAnswer,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn
			  )
			  SELECT       
					@UserInfoID,tmp.QuestionBankDetailsID AS QuestionId,tmp.QuestionsAnswer As QuestionBankDetailsID,
					@AttemptNo,	mqbd.CorrectAnswer,	@UserInfoID,GETDATE(),@UserInfoID,GETDATE()		
			 FROM @inp_tblMCQQuestionType as tmp inner join MCQ_QuestionBankDetails as mqbd on tmp.QuestionsAnswer=mqbd.QuestionBankDetailsID
			END	
			SET @UAD_ID = SCOPE_IDENTITY()
			print @UAD_ID
			 EXEC st_MCQ_UserInterface_Validation  @inp_iUserInfoId	OUTPUT,@FrequencyOfMCQs	OUTPUT,@AttemptNos OUTPUT,@FalseAnswer OUTPUT,@CorrectAnswer	OUTPUT,
				 @ResultDuringFrequency	OUTPUT,@UserMessage	OUTPUT,@AttemptMessage OUTPUT,@BlockedUserMessage OUTPUT,@TotalAttempts OUTPUT ,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
				
				
				INSERT INTO MCQ_UserResultDetails
				(
					UserInfoId	,AttemptNo  ,FalseAnswer,CorrectAnswer,			
					ResultDuringFrequency,MCQ_ExamDate,	CreatedBy ,              
					CreatedOn  , UpdatedBy ,UpdatedOn               
				 )
				 values
				 (
					 @UserInfoID, @AttemptNo, @FalseAnswer, @CorrectAnswer,
					 (case when Ltrim(Rtrim(@ResultDuringFrequency))='Success' Then 522002 else 522003 end),
					 (select MUA.CreatedON from MCQ_UserAnswerDetails as MUA where MUA.UAD_ID= @UAD_ID),
					 @UserInfoID, getdate(), @UserInfoID,getdate()
				 )
				 
		
			select @BlockuserAfterExceedAtempts=BlockuserAfterExceedAtempts from MCQ_MasterSettings
			print '@ResultDuringFrequency'
			print @ResultDuringFrequency
				print '@BlockuserAfterExceedAtempts'
			print @BlockuserAfterExceedAtempts
			print '@TotalAttempts'
			print @TotalAttempts
			print '@AttemptNos'
			print @AttemptNos
			IF(	@TotalAttempts <@AttemptNos and @ResultDuringFrequency='Fail' and @BlockuserAfterExceedAtempts=1)
			BEGIN				
				UPDATE usr_UserInfo set IsBlocked=1,ReasonForBlocking=(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124'),Blocked_Date=getdate() where userinfoid=@UserInfoID 
			
			 	insert into MCQ_UserBlockedDetails
				(
					UserInfoId	,IsBlocked , Blocked_Date,Blocked_UnBlock_Reason,
					UnBlocked_Date,	FrequencyDateBYAdmin,ReasonForBlocking,	MCQ_ExamDate,			
					CreatedBy , CreatedOn  , UpdatedBy ,UpdatedOn               
				)
			   select Top 1 
						@UserInfoID,1,getdate() as Blocked_Date,null,
						null as UnBlocked_Date,	null as FrequencyDateBYAdmin,
						(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124') as ReasonForBlocking,
						mua.CreatedOn as MCQExamDate, @UserInfoID,getdate() as CreatedOn,@UserInfoID as UpdatedBy , getdate() as UpdatedOn 
				from MCQ_UserAnswerDetails as mua inner join usr_userinfo as ur on mua.userInfoid=ur.userInfoid where mua.userinfoid=@UserInfoID order by mua.CreatedOn desc
			
			END
			--ELSE IF(@TotalAttempts <=@AttemptNos and @ResultDuringFrequency='Fail' and (@BlockuserAfterExceedAtempts=1 or @BlockUserAfterDuration=1))
			--BEGIN		
			--	UPDATE usr_UserInfo set IsBlocked=1,ReasonForBlocking=(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124'),Blocked_Date=getdate() where userinfoid=@UserInfoID 
			
			-- 	insert into MCQ_UserBlockedDetails
			--	(
			--		UserInfoId	,			
			--		IsBlocked , 
			--		Blocked_Date,				
			--		Blocked_UnBlock_Reason	,
			--		UnBlocked_Date,			
			--		FrequencyDateBYAdmin,	
			--		ReasonForBlocking,		
			--		MCQ_ExamDate,			
			--		CreatedBy ,              
			--		CreatedOn  ,             
			--		UpdatedBy ,              
			--		UpdatedOn               
			--	)
			--   select Top 1 
			--			@UserInfoID,
			--			1,
			--			getdate() as Blocked_Date,
			--			null,
			--			null as UnBlocked_Date,
			--			null as FrequencyDateBYAdmin,
			--			(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='usr_msg_54124') as ReasonForBlocking,
			--			mua.CreatedOn as MCQExamDate, 
			--			@UserInfoID,
			--			getdate() as CreatedOn,  
			--			@UserInfoID as UpdatedBy , 
			--			getdate() as UpdatedOn 
			--	from MCQ_UserAnswerDetails as mua inner join usr_userinfo as ur on mua.userInfoid=ur.userInfoid where mua.userinfoid=@UserInfoID order by mua.CreatedOn desc
			
			--END
			
		  END
			
		
		SET @out_nReturnValue = 0	
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.	
		IF(@ISDELETE_ERROR=1)
		BEGIN
			SET @out_nReturnValue = @ERR_MCQQuestion_Delete
			RETURN @out_nReturnValue		
		END
		ELSE
		BEGIN	
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_MCQQuestion_SAVE, ERROR_NUMBER())
		END
		
	END CATCH
END
