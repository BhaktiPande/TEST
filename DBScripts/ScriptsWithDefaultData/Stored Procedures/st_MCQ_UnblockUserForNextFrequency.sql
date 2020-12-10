/*-------------------------------------------------------------------------------------------------
Description:	 Unblock User For Next Frequency

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		17-May-2019
exec st_MCQ_UnblockUserForNextFrequency
-------------------------------------------------------------------------------------------------*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_UnblockUserForNextFrequency')
	DROP PROCEDURE st_MCQ_UnblockUserForNextFrequency
GO

CREATE PROCEDURE st_MCQ_UnblockUserForNextFrequency

	 @out_nReturnValue				INT = 0 OUTPUT,
	 @out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	
AS
BEGIN
				DECLARE @UnblockForNextFrequencyMessage  VARCHAR(MAX)
				DECLARE @nYearCodeId int=null
				DECLARE @nPeriodCodeId int=null
				DECLARE @dtStartDate datetime=getdate()
				DECLARE @dtEndDate datetime
				DECLARE @FrequencyOfMCQ		int
				DECLARE @UnblockForNextFrequency bit
				DECLARE @IsSpecificPeriodWise bit
				DECLARE @IsDatewise bit
				DECLARE @FrequencyDate datetime
				SELECT 
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
						   @UnblockForNextFrequency=UnblockForNextFrequency
					FROM MCQ_MasterSettings
				
				 EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
												@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtStartDate,@FrequencyOfMCQ, 0, 
												@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
												@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
												
												print @dtStartDate
												print @dtEndDate
				/* Unblock the user for next frequency block 
					st_tra_PeriodEndDisclosureStartEndDate2 this sp is necessary for get end of scheduled frequency
				open*/
							DECLARE @dtEndDateForNextFrequency DATETIME
							SET @dtEndDateForNextFrequency =(select  @dtEndDate +'23:59:00'); --  End date which is 31 july 2019 12 00 AM add time of EOD
							DECLARE @MCQ_ExamDate DATETIME=NULL
							DECLARE @nUserInfoId INT=0			
							DECLARE @nCount INT=0
							DECLARE @nTotCount INT=0
							Declare @tempUserInfo Table
							(
								RowId int identity(1,1),
								UserInfoId INT NOT NULL
							)		
						IF(@UnblockForNextFrequency=1 and @IsSpecificPeriodWise =1 AND GETDATE() BETWEEN (select  @dtEndDate +'23:40:00') AND @dtEndDateForNextFrequency) --  this will execute if frequency of month checked and end date time between 11.50 PM to 11.59 PM
						BEGIN
								INSERT INTO @tempUserInfo
								SELECT UserInfoId FROM usr_UserInfo WHERE IsBlocked=1  --GET ALL USERINFOID THOSE ARE BLOCKED AND INSERT INTO TABLE VARIABLE

								SELECT @nTotCount=COUNT(userinfoid) FROM @tempUserInfo-- GET TOATAL RECORD COUNT FROM TABLE VARIABLE AND SET TO @nTotCount

									WHILE @nCount<@nTotCount					--CHECK @nCount IS LESS THAN @nTotCount
										BEGIN
										SELECT @nUserInfoId=UserInfoID FROM @tempUserInfo WHERE RowId=@nCount+1-- GET USERINFOID OF CURRENT ROW FROM TABLE VARIABLE AND SET TO  @nUserInfoId
														
										SELECT TOP 1 @MCQ_ExamDate= MCQ_ExamDate  FROM MCQ_UserResultDetails WHERE UserInfoId=@nUserInfoId ORDER BY MCQ_ExamDate DESC -- GET LAST MCQ_ExamDate FROM MCQ_UserResultDetails AND SET TO @MCQ_ExamDate

										UPDATE usr_UserInfo set IsBlocked=0,UnBlocked_Date=NULL,FrequencyDateBYAdmin=NULL where userinfoid=@nUserInfoId 
										update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@nUserInfoId	

										-- CHECK IF MCQ_ExamDate EXISTS IN MCQ_UserBlockedDetails THEN UPDATE RECORD INTO TABLE OTHERWISE INSERT RECORED INTO TABLE AND SET UNBLOCK REASON 
										IF EXISTS (SELECT userinfoid FROM MCQ_UserBlockedDetails WHERE   userinfoid=@nUserInfoId AND MCQ_ExamDate=@MCQ_ExamDate)
										BEGIN
											update  MCQ_UserBlockedDetails
													set 	
													Blocked_UnBlock_Reason=@UnblockForNextFrequencyMessage	,
													UnBlocked_Date=getdate(),		
													FrequencyDateBYAdmin=getdate(),	
													MCQ_ExamDate=@MCQ_ExamDate,			
													UpdatedOn     =getdate()          
													where userInfoid=@nUserInfoId and  MCQ_ExamDate=@MCQ_ExamDate
										END
														

										SET @nCount=@nCount+1
										END

						END
						
						IF(@UnblockForNextFrequency=1 and @IsDatewise =1 AND GETDATE() BETWEEN (select  (@FrequencyDate-1) +'23:40:00') AND (select  (@FrequencyDate-1) +'23:59:00')) --  this will execute if frequency of date checked and before one day of frequency  date time between 11.50 PM to 11.59 PM
						BEGIN
																		
								INSERT INTO @tempUserInfo
								SELECT UserInfoId FROM usr_UserInfo WHERE IsBlocked=1  --GET ALL USERINFOID THOSE ARE BLOCKED AND INSERT INTO TABLE VARIABLE

								SELECT @nTotCount=COUNT(userinfoid) FROM @tempUserInfo-- GET TOATAL RECORD COUNT FROM TABLE VARIABLE AND SET TO @nTotCount

									WHILE @nCount<@nTotCount					--CHECK @nCount IS LESS THAN @nTotCount
										BEGIN
										
										SELECT @nUserInfoId=UserInfoID FROM @tempUserInfo WHERE RowId=@nCount+1-- GET USERINFOID OF CURRENT ROW FROM TABLE VARIABLE AND SET TO  @nUserInfoId
														
										SELECT TOP 1 @MCQ_ExamDate= MCQ_ExamDate  FROM MCQ_UserResultDetails WHERE UserInfoId=@nUserInfoId ORDER BY MCQ_ExamDate DESC -- GET LAST MCQ_ExamDate FROM MCQ_UserResultDetails AND SET TO @MCQ_ExamDate

										UPDATE usr_UserInfo set IsBlocked=0,UnBlocked_Date=(select  (GETDATE()) +'00:15:00'),FrequencyDateBYAdmin=(select  (GETDATE()) +'00:15:00') where userinfoid=@nUserInfoId --need to update unbolck date in usr_userinfo table when first time login yes and unlock user for next frequency true
										update MCQ_CheckUsrStatus set MCQStatus=0 where userinfoid=@nUserInfoId	

										-- CHECK IF MCQ_ExamDate EXISTS IN MCQ_UserBlockedDetails THEN UPDATE RECORD INTO TABLE OTHERWISE INSERT RECORED INTO TABLE AND SET UNBLOCK REASON 
										IF EXISTS (SELECT userinfoid FROM MCQ_UserBlockedDetails WHERE   userinfoid=@nUserInfoId AND MCQ_ExamDate=@MCQ_ExamDate)
										BEGIN
											update  MCQ_UserBlockedDetails
													set 	
													Blocked_UnBlock_Reason=@UnblockForNextFrequencyMessage	,
													UnBlocked_Date=(select  (GETDATE()) +'00:15:00'),		
													FrequencyDateBYAdmin=(select  (GETDATE()) +'00:15:00'),	
													MCQ_ExamDate=@MCQ_ExamDate,			
													UpdatedOn     =getdate()          
													where userInfoid=@nUserInfoId and  MCQ_ExamDate=@MCQ_ExamDate
										END
														

										SET @nCount=@nCount+1
										END

						END
								
				/* Unblock the user for next frequency block close*/
END