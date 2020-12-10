/*
Auther : Samadha Kadam
Createdon : 30 May 2019
Description : MCQ st_MCQ_Reports
exec st_MCQ_Reports 0,null,null,null,null,null,'2019-05-01 00:00:00.000','2019-06-17 18:27:39.930'
exec st_MCQ_Reports 0,'TP1',null,null,null,null,'2019-05-01 00:00:00.000','2019-06-17 18:27:39.930'
*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_Reports')
	DROP PROCEDURE [dbo].[st_MCQ_Reports]
GO
CREATE PROCEDURE [dbo].[st_MCQ_Reports]
  @UserInfoId int =0,
  @EmployeeID varchar(100)=null,
  @Name		 varchar(250)=null,
  @Department varchar(250)=null,
  @Designation varchar(250)=null,
  @MCQ_Status  varchar(50)=null,
  @StartDate datetime ,
  @EndDate datetime ,
  @out_nReturnValue		INT = 0 OUTPUT,
  @out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
  @out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
set @EndDate=(select @EndDate +'23:59:00')
Declare @MCQ_StatusText varchar(50)= ( select CodeName from com_code where codeid=@MCQ_Status)
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
	   @FrequencyDuration=FrequencyDuration,
	   @BlockUserAfterDuration=BlockUserAfterDuration,
	   @NoOfAttempts=NoOfAttempts,
	   @BlockuserAfterExceedAtempts=BlockuserAfterExceedAtempts,
	   @UnblockForNextFrequency=UnblockForNextFrequency,
	   @DisplayNoOfQuestions=NoOfQuestionForDisplay,
	   @AccessTOApplicationForWriteAnswer=AccessTOApplicationForWriteAnswer
	   from MCQ_MasterSettings
	   
	   DECLARE @nYearCodeId int=null
	   DECLARE @nPeriodCodeId int=null
	   
		DECLARE @dtStartDate datetime=getdate()

		DECLARE @dtEndDate datetime
		DECLARE @out_sPeriodEnddate datetime
		  IF((SELECT FREQUENCYDATE FROM MCQ_MASTERSETTINGS)< DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) and @FrequencyOfMCQ=123004 and @IsDatewise=1 )
		  BEGIN
					  set @FrequencyDate = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
		  END
		  ELSE IF( @FrequencyOfMCQ=123004 and @IsDatewise=0)
		  BEGIN
					  set @FrequencyDate = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
		  END
		  ELSE IF( @FrequencyOfMCQ=123004 and @IsDatewise=1 and @IsSpecificPeriodWise=1)
		  BEGIN
					  set @FrequencyDate = (SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
		  END
		  ELSE IF (@FrequencyOfMCQ=123001 or  @FrequencyOfMCQ =123003 or  @FrequencyOfMCQ =123002)
		  BEGIN
			 set @FrequencyDate =GETDATE()
		  END
		  
		  
									EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
												@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@FrequencyDate,@FrequencyOfMCQ, 0, 
												@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
												@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		  
	if(@EmployeeID != null)
	begin
			set @UserInfoId=(select UserInfoId from usr_userinfo where EmployeeId=@EmployeeID)
	end
	select UserInfoID,
	   MCQ_ExamDate,
	  (case when  MCQ_ExamDate='Not Attempted' then 'Pending' else  MCQ_Status end  ) as MCQ_Status,
	  (case when  MCQ_ExamDate='Not Attempted' then null else  LastDateOfMCQ  end  ) as LastDateOfMCQ,
	  (case when  MCQ_ExamDate='Not Attempted' then null else  FrequencyOfMCQ end  ) as FrequencyOfMCQ,
	   AttemptNo,
	  (case when  MCQ_ExamDate='Not Attempted' then null else   case when @IsDatewise=1 and @IsSpecificPeriodWise=1 then  @dtStartDate 
																when @IsDatewise=0 and @IsSpecificPeriodWise=1  then  @dtStartDate 
																when  @IsDatewise=1 and @IsSpecificPeriodWise=0 then @FrequencyDate
																end
	    end  )as ActivationPeriod, 
	   EmployeeId,
	   Name,
	   DepartmentID,
	   Department,
	   DesignationID,
	   Designation,
	   Unblockdates,
	   Dateofblocking,
	   Reasonforblocking,
	   PAN_Number,
	   UnblockReason,
	   CASE WHEN  AccountBlocked =1 THEN 'Yes' ELSE 'No' END AS AccountBlocked
			 from 
			(
				select ISNULL(result.UserInfoID ,ui.UserInfoID) as  UserInfoID,	
					result.MCQ_ExamDate as Examdate,
					ISNULL( convert(varchar(50),	result.MCQ_ExamDate),'Not Attempted') as MCQ_ExamDate,	
					MCQStatus.CodeName   as MCQ_Status,	
					case when @dtStartDate<result.MCQ_ExamDate and result.MCQ_ExamDate >= @FrequencyDate then 	convert(datetime, CONVERT(VARCHAR(50),DATEADD(dd,-(DAY( @FrequencyDate)-1),@FrequencyDate),106))+(@FrequencyDuration-1 ) else 	convert(datetime, CONVERT(VARCHAR(50),DATEADD(dd,-(DAY( @dtStartDate)-1),@dtStartDate),106))+(@FrequencyDuration-1 ) end 	as LastDateOfMCQ,  
					ISNULL((select codename from com_code where codeid=(select FrequencyOfMCQ from MCQ_MasterSettings )),'Date') as  FrequencyOfMCQ,	
					result.AttemptNo,	
					 
					ui.EmployeeId,
					ui.FirstName + ' ' +ui.MiddleName	+ ' ' + ui.LastName as Name,
					Departments.CodeID   as DepartmentID,
					Departments.CodeName   as Department,
					Designations.CodeID  as DesignationID,
					Designations.CodeName  as Designation,
					MUB.Blocked_UnBlock_Reason as UnblockReason,
					MUB.UnBlocked_Date as Unblockdates,
					MUB.Blocked_Date as Dateofblocking,
					MUB.ReasonForBlocking as Reasonforblocking,
				    ISNULL (MUB.IsBlocked,UI.IsBlocked) as  AccountBlocked,
					ui.PAN as PAN_Number from 
				MCQ_UserResultDetails as result
				right join usr_userinfo as ui on result.UserInfoId=ui.UserInfoID 
					inner join  com_code as Departments on Departments.codeid=ui.DepartmentId 
								   inner join  com_code as Designations on Designations.codeid=ui.DesignationId
								   left join com_code as MCQStatus on MCQStatus.codeid=ResultDuringFrequency
								   left join MCQ_UserBlockedDetails as MUB on ui.userinfoid=MUB.userinfoid and   MUB.MCQ_ExamDate   = result.MCQ_ExamDate 
								  
				) result		 	   
			where (isnull(Examdate,getdate()) between @StartDate and  @EndDate) and (result.EmployeeId =@EmployeeID or @EmployeeID is null or @EmployeeID='')
					and ( Name=@Name or @Name is null or @Name='' )
					and (Rtrim(Ltrim(result.Department)) =@Department or @Department='' or @Department is null)
					and (Rtrim(Ltrim(result.Designation))= @Designation or  @Designation='' or @Designation is null)
					and (case when result.MCQ_ExamDate='Not Attempted' then 'Pending' else result.MCQ_Status end = @MCQ_StatusText or  @MCQ_Status='' or @MCQ_Status is null)
					order by case when  result.MCQ_ExamDate ='Not Attempted' then getdate() else  result.MCQ_ExamDate  end asc
 	
		SET @out_nReturnValue = 0	
		RETURN @out_nReturnValue	
end
