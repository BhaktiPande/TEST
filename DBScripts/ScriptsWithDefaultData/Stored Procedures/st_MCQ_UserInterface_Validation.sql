/*
Auther : Samadha Kadam
Createdon : 30 May 2019
Description : All configuration setting validate
*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_UserInterface_Validation')
	DROP PROCEDURE [dbo].[st_MCQ_UserInterface_Validation]
GO
CREATE PROCEDURE [dbo].[st_MCQ_UserInterface_Validation]
	@inp_iUserInfoId		INT OUTPUT,	
	@FrequencyOfMCQs		CHAR(10) =NULL OUTPUT,
	@AttemptNos				INT =0  OUTPUT ,
	@FalseAnswer			INT =0  OUTPUT ,
	@CorrectAnswer			INT =0 OUTPUT ,
	@ResultDuringFrequency	CHAR(10)=NULL  OUTPUT ,
	@UserMessage			VARCHAR(MAX)=NULL  OUTPUT,
	@AttemptMessage			VARCHAR(MAX)=NULL  OUTPUT,
	@BlockedUserMessage		VARCHAR(MAX)=NULL  OUTPUT,
	@TotalAttempts			INT=0 OUTPUT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
DECLARE @UserInfoId int =@inp_iUserInfoId

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
select @FirstTimeLogin=FirstTimeLogin,
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
	   from MCQ_MasterSettings
	   
	   DECLARE @nYearCodeId int=null
	   DECLARE @nPeriodCodeId int=null
	   
	   
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
		DECLARE @dtStartDate datetime=getdate()
		
		DECLARE @dtEndDate datetime
		DECLARE @out_sPeriodEnddate datetime
		--DECLARE @out_nReturnValue int
	    --DECLARE @out_nSQLErrCode int
		--DECLARE @out_sSQLErrMessage varchar(max)
		DECLARE @UnBlocked_Date datetime
		 set @UnBlocked_Date =(select UnBlocked_Date from usr_userinfo where userinfoid=@inp_iUserInfoId and   convert(datetime,getdate(),103) between convert(datetime,UnBlocked_Date,103) and  (CONVERT(DATETIME, UnBlocked_Date)+ @FrequencyDuration) )
		
	   EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
	@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@FrequencyDate,@FrequencyOfMCQ, 0, 
	@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
	@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	
	IF (@FrequencyOfMCQ=123001 or  @FrequencyOfMCQ =123003 or  @FrequencyOfMCQ =123002)
	 BEGIN
		 set @FrequencyDate =@dtStartDate
	 END
								
	if exists (select userinfoid from usr_userinfo where userinfoid=@inp_iUserInfoId and  convert(datetime,getdate(),103) between convert(datetime,UnBlocked_Date,103) and  (CONVERT(DATETIME, UnBlocked_Date)+ @FrequencyDuration)) -- if user unblocked by co/admin then set frequency date from user infomation 
	begin
	  
		set @FrequencyDate=@UnBlocked_Date
	    set @dtStartDate=@FrequencyDate
	end
	IF(@FirstTimeLogin=1 and @IsSpecificPeriodWise=0 and @IsDatewise=0)
	BEGIN
			IF EXISTS( SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  AND MCQ_EXAMDATE IS NOT NULL  ORDER BY MCQ_EXAMDATE ASC)
			BEGIN
				   IF(@UnBlocked_Date !=NULL)
					BEGIN
						 SET @dtStartDate =@UnBlocked_Date
					 END
					 ELSE
					 BEGIN
						 SET @dtStartDate= (SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId  AND MCQ_EXAMDATE IS NOT NULL  ORDER BY MCQ_EXAMDATE ASC)
					END
			END
			ELSE
			BEGIN
				set @dtStartDate= (select convert(datetime ,getdate(),103))
			END
	END
	ELSE IF(@FirstTimeLogin=1 and( @IsSpecificPeriodWise=1 or @IsDatewise=1))
   BEGIN
   PRINT '@BlockUserAfterDuration'
   PRINT @BlockUserAfterDuration
   PRINT '@BlockuserAfterExceedAtempts'
   PRINT @BlockuserAfterExceedAtempts
    --IF (@BlockUserAfterDuration !=1 or  @BlockuserAfterExceedAtempts !=1)
    --BEGIN    
	 IF EXISTS( SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId AND MCQ_EXAMDATE IS NOT NULL  ORDER BY MCQ_EXAMDATE ASC)
	 BEGIN
			 IF(@UnBlocked_Date !=NULL)
			 BEGIN			
				SET @dtStartDate =@UnBlocked_Date
			 END
			 ELSE
			BEGIN
				SET @dtStartDate= (SELECT TOP 1  MCQ_EXAMDATE FROM MCQ_UserResultDetails WHERE  UserInfoId=@inp_iUserInfoId AND MCQ_EXAMDATE IS NOT NULL  ORDER BY MCQ_EXAMDATE ASC)
		    END
	  END
	  ELSE
	  BEGIN																			
		 set @dtStartDate= (select convert(date ,getdate(),103))
	  END
	--END
	
  END
	
	print('@@UnBlocked_Date')
	print @UnBlocked_Date

--current Attempt number
print '@dtStartDate'
print @dtStartDate
print '@FrequencyDate'
print @FrequencyDate
print 'CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration'
print CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration
print 'CONVERT(DATETIME, @FrequencyDate,103)+ @FrequencyDuration'
print CONVERT(DATETIME, @FrequencyDate,103)+ @FrequencyDuration


	IF(@UnBlocked_Date IS NULL OR @UnBlocked_Date=' ')
	BEGIN	
		SELECT @currentAttempt=ISNULL(MAX(AttemptNo),0)
	       FROM MCQ_UserAnswerDetails WHERE  UserInfoId=@inp_iUserInfoId and (CreatedOn between CONVERT(DATETIME, @dtStartDate,103) and (CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration) or 
	                                                                               CreatedOn between CONVERT(DATETIME, @FrequencyDate,103) and (CONVERT(DATETIME, @FrequencyDate,103)+ @FrequencyDuration) )
	END
	ELSE
	BEGIN	
		SELECT @currentAttempt=ISNULL(MAX(AttemptNo),0)
	       FROM MCQ_UserAnswerDetails WHERE  UserInfoId=@inp_iUserInfoId and (CreatedOn between CONVERT(DATETIME, @dtStartDate,103) and (CONVERT(DATETIME, @dtStartDate,103)+ @FrequencyDuration) or 
	                                                                               CreatedOn between CONVERT(DATETIME, @FrequencyDate,103) and (CONVERT(DATETIME, @FrequencyDate,103)+ @FrequencyDuration) )
	                                                                               AND CreatedOn>CONVERT(DATETIME,@UnBlocked_Date,103)
	END
		
		
	CREATE TABLE #tmpFinalResult
	(
	ID INT IDENTITY(1,1),
	UserInfoId INT,
	FrequencyOfMCQs VARCHAR(10),
	AttemptNo INT
	)	

	IF(@UnBlocked_Date IS NULL OR @UnBlocked_Date=' ')
	BEGIN
		INSERT INTO #tmpFinalResult
		SELECT @UserInfoId as UserInfoId, ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @dtStartDate) and CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration)) ,
			   ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @FrequencyDate) and CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration))  ,'False')) As FrequencyOfMCQs, 
			   ISNULL(MAX(AttemptNo),0)+1 as AttemptNo 
	       
			   FROM MCQ_UserAnswerDetails WHERE  UserInfoId=@inp_iUserInfoId and( CreatedOn between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration) or 
			   CreatedOn between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration) )
     END
	 ELSE
	 BEGIN
		INSERT INTO #tmpFinalResult
		SELECT @UserInfoId as UserInfoId, ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @dtStartDate) and CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration)) ,
			   ISNULL(convert(varchar(10),(SELECT 'True' WHERE GETDATE() between CONVERT(DATETIME, @FrequencyDate) and CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration))  ,'False')) As FrequencyOfMCQs, 
			   ISNULL(MAX(AttemptNo),0)+1 as AttemptNo 
	       
			   FROM MCQ_UserAnswerDetails WHERE  UserInfoId=@inp_iUserInfoId and( CreatedOn between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration) or 
			   CreatedOn between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration) )
			   AND CreatedOn>CONVERT(DATETIME,@UnBlocked_Date,103)

	 END


;	
 with FrequencySetting
 As
 (
	SELECT * FROM #tmpFinalResult
 )
,
UserAnserResult
As
( 
	SELECT UserInfoId ,   
			[0] as FalseAnswer, [1] As CorrectAnswer 
			FROM  
			( 

						select  RadioResult.UserInfoId,RadioResult.ResultType,isnull(RadioResult.UserChoice,0) +CheckBoxResult.UserChoice  As UserResult from 
						(
								select UserInfoId,ResultType, sum(UserChoice) as UserChoice from 
								(
								select UserInfoId ,correctAnswer as ResultType,count(*) UserChoice  from  MCQ_UserAnswerDetails  as MUAD inner join MCQ_QuestionBank as MQB on MUAD.QuestionId=MQB.QuestionID and MUAD.AttemptNo=@currentAttempt
																												 where  UserInfoId=@inp_iUserInfoId and  (MUAD .CreatedOn between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration) or 
																												        MUAD .CreatedOn between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration) )
																												    group by UserInfoId,AnswerTypes,correctAnswer having AnswerTypes=1  
								union
								select @UserInfoId, 1 as ResultType,0 as UserChoice
								union
								select @UserInfoId, 0 as ResultType,0 as UserChoice
								) InnerRadioResult group by  UserInfoId,ResultType
						) as RadioResult
						left join 
							(
								select UserInfoId,AnswerTypes,ResultType,sum(UserChoice) as UserChoice 
								from (
										
										select tb1.QuestionId, UserInfoId,AnswerTypes,case when tb1.correctAns=tb2.UserChoice then 1 else 0 end as ResultType, count(tb2.UserChoice) As UserChoice from
										(
											select QuestionID,CorrectAnswer,count(*) as correctAns from MCQ_QuestionBankDetails as MQBD   group by questionid,CorrectAnswer having CorrectAnswer=1
										)tb1
										inner join
										(
											select UserInfoId ,QuestionId,AnswerTypes,   count(*) as UserChoice from 
											(
											select UserInfoId ,MUAD.QuestionId,AnswerTypes,   MUAD.CorrectAnswer ,MUAD.QuestionBankDetailsID
													from MCQ_QuestionBankDetails as MQBD left join  MCQ_UserAnswerDetails  as MUAD on MQBD.QuestionBankDetailsID=MUAD.QuestionBankDetailsID
													 inner join MCQ_QuestionBank as MQB on MUAD.QuestionId=MQB.QuestionID and MUAD.AttemptNo=@currentAttempt
																												
													 where UserInfoId=@inp_iUserInfoId and  (MUAD .CreatedOn between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration) or 
														  MUAD .CreatedOn between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration)  )
															 group by UserInfoId,MUAD.QuestionId,AnswerTypes ,MUAD.CorrectAnswer,MUAD.QuestionBankDetailsID having AnswerTypes=2 and MUAD.CorrectAnswer=1 
												) currectAns  group by  UserInfoId , QuestionId,AnswerTypes  
												except 
												select UserInfoId ,QuestionId,AnswerTypes,   count(*) as CorrectAnswer from 
												(
													select UserInfoId ,MUAD.QuestionId,AnswerTypes,   MUAD.CorrectAnswer ,MUAD.QuestionBankDetailsID
													from MCQ_QuestionBankDetails as MQBD left join  MCQ_UserAnswerDetails  as MUAD on MQBD.QuestionBankDetailsID=MUAD.QuestionBankDetailsID
													 inner join MCQ_QuestionBank as MQB on MUAD.QuestionId=MQB.QuestionID and MUAD.AttemptNo=@currentAttempt
																												
													 where UserInfoId=@inp_iUserInfoId and  (MUAD .CreatedOn between CONVERT(DATETIME, @dtStartDate) and (CONVERT(DATETIME, @dtStartDate)+ @FrequencyDuration) or 
														  MUAD .CreatedOn between CONVERT(DATETIME, @FrequencyDate) and (CONVERT(DATETIME, @FrequencyDate)+ @FrequencyDuration)  )
															 group by UserInfoId,MUAD.QuestionId,AnswerTypes ,MUAD.CorrectAnswer,MUAD.QuestionBankDetailsID having AnswerTypes=2 and MUAD.CorrectAnswer=0 
												) currectAns  group by  UserInfoId , QuestionId,AnswerTypes  	  
																											  
																											     
										) tb2 on tb1.QuestionID=tb2.QuestionID
										group by tb1.QuestionId ,UserInfoId,tb2.QuestionId,AnswerTypes,case when tb1.correctAns=tb2.UserChoice then 1 else 0 end 
										
										
										union
										select 0 as QuestionId, @UserInfoId as UserInfoId,2 as 	AnswerTypes,	0 as ResultType,0 as UserChoice
										union
										select 0 as QuestionId, @UserInfoId as UserInfoId,2 as 	AnswerTypes,	1 as ResultType,0 as UserChoice
								 ) OuterResult
							  group by UserInfoId,AnswerTypes,ResultType
							) as CheckBoxResult on RadioResult.UserInfoid=CheckBoxResult.UserInfoid and RadioResult.ResultType=CheckBoxResult.ResultType
							

						    
			  ) AS SourceTable  
			PIVOT  
			(  
			sum(UserResult)  
			FOR ResultType IN ([0], [1])  
			) AS PivotTable  
  
)
--select @inp_iUserInfoId= FS.UserInfoID,@FrequencyOfMCQs=FS.FrequencyOfMCQs,@AttemptNos= FS.AttemptNo,@FalseAnswer= UAR.FalseAnswer,@CorrectAnswer=UAR.CorrectAnswer,@ResultDuringFrequency= (CASE WHEN convert(int, UAR.CorrectAnswer)  >=  @AccessTOApplicationForWriteAnswer THEN 'Success' ELSE 'Fail' END ) ,@UserMessage=CASE WHEN UAR.CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@SuccessMessage,'<>',UAR.CorrectAnswer) ELSE REPLACE( STUFF(STUFF(@FailMessage, LEN(@FailMessage) - CHARINDEX('<', REVERSE(@FailMessage))+1, 1, @DisplayNoOfQuestions), CHARINDEX('<', @FailMessage), 1, UAR.CorrectAnswer),'>','') END ,@AttemptMessage=REPLACE( STUFF(STUFF(@RemainingAttemptMessage, LEN(@RemainingAttemptMessage) - CHARINDEX('<', REVERSE(@RemainingAttemptMessage))+1, 1, @NoOfAttempts), CHARINDEX('<', @RemainingAttemptMessage), 1, (@NoOfAttempts- (case when @NoOfAttempts= @currentAttempt then @currentAttempt-1 else @currentAttempt end)  )),'>','') , @BlockedUserMessage=CASE WHEN UAR.CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@BlockedMessage,'<',UAR.CorrectAnswer) ELSE REPLACE( STUFF(STUFF(@BlockedMessage, LEN(@BlockedMessage) - CHARINDEX('<', REVERSE(@BlockedMessage))+1, 1, @DisplayNoOfQuestions), CHARINDEX('<', @BlockedMessage), 1, UAR.CorrectAnswer),'>','') END  from FrequencySetting as FS inner join UserAnserResult as  UAR on FS.UserInfoId=UAR.UserInfoId
select  @inp_iUserInfoId= FS.UserInfoID,
		@FrequencyOfMCQs=FS.FrequencyOfMCQs,
		@AttemptNos= FS.AttemptNo,
		@FalseAnswer= UAR.FalseAnswer,
		@CorrectAnswer=UAR.CorrectAnswer,
		@ResultDuringFrequency= (CASE WHEN convert(int, UAR.CorrectAnswer)  >=  @AccessTOApplicationForWriteAnswer THEN 'Success' ELSE 'Fail' END ) ,
		@UserMessage= '',--case when @FrequencyOfMCQs='True' Then (CASE WHEN UAR.CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@SuccessMessage,'<>',UAR.CorrectAnswer) ELSE REPLACE( STUFF(STUFF(@FailMessage, LEN(@FailMessage) - CHARINDEX('<', REVERSE(@FailMessage))+1, 1, @DisplayNoOfQuestions), CHARINDEX('<', @FailMessage), 1, UAR.CorrectAnswer),'>','') END) 
											   --else @MCQDateExpMessage end,
		@AttemptMessage='',--REPLACE( STUFF(STUFF(@RemainingAttemptMessage, LEN(@RemainingAttemptMessage) - CHARINDEX('<', REVERSE(@RemainingAttemptMessage))+1, 1, @NoOfAttempts), CHARINDEX('<', @RemainingAttemptMessage), 1, (@NoOfAttempts- (case when @NoOfAttempts= @currentAttempt then @currentAttempt-1 else @currentAttempt end)  )),'>','') , 
		@BlockedUserMessage= '' --CASE WHEN UAR.CorrectAnswer>= @AccessTOApplicationForWriteAnswer THEN REPLACE(@BlockedMessage,'<',UAR.CorrectAnswer) ELSE REPLACE( STUFF(STUFF(@BlockedMessage, LEN(@BlockedMessage) - CHARINDEX('<', REVERSE(@BlockedMessage))+1, 1, @DisplayNoOfQuestions), CHARINDEX('<', @BlockedMessage), 1, UAR.CorrectAnswer),'>','') END 
		
		 from FrequencySetting as FS inner join UserAnserResult as  UAR on FS.UserInfoId=UAR.UserInfoId

set @TotalAttempts=@NoOfAttempts
DROP TABLE #tmpFinalResult
END