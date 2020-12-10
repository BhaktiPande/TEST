IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_Generate_PeriodEnd_OS')
DROP PROCEDURE [dbo].[st_tra_Generate_PeriodEnd_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to generate PE records on Month end date.

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		18-Jult-2019

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_Generate_PeriodEnd_OS]
	@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @nEventCodeId_PEDetailsEntered INT = 153029

	DECLARE @iCommentsId_NotSubmittedInTime INT = 169002
	DECLARE @iCommentsId_NotSubmitted INT = 169001
	DECLARE @iDisclosure_Required INT = 165001
	
	DECLARE @iNonComplianceType_PE INT = 170003
	DECLARE @iNonDisclosureType_PE INT = 147003
	
	--DECLARE @nMaxDefaulterId INT
	DECLARE @dtToday DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @dtTodayPlusMonth DATETIME = DATEADD(M, 1, @dtToday)
	DECLARE @dtMonthEndDate DATETIME

	DECLARE @tmpMapPeriod TABLE(TPPeriod INT, CodePeriod INT)
	DECLARE @tmpTPPeriod TABLE(DiscloPeriodEndFreq INT)
	DECLARE @tmpUserTPForPE TABLE(UserInfoId INT, TradingPolicyId INT, PeriodEndDate DATETIME, PEAddFlag BIT DEFAULT 1)
	
	DECLARE @nUserInfoId INT
	DECLARE @nTradingPolicyId INT
	
	DECLARE @nUserStatus_Inactive INT = 102002

	DECLARE @RC INT
	
	-- flag to indicate what action to be taken
	-- 0: NO ACTION
	-- 1: add records as per current TP for current period, 
	-- 2: record is already added into tra_UserPeriodEndMapping table
	-- 3: add next period records as per previous TP stored in tra_UserPeriodEndMapping table
	DECLARE @nActinFlag		 		INT
	
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME

	DECLARE @nEventCodeID_InitialDisclosureConfirmed INT = 153056
	DECLARE @nEventCodeID_ContinuousDisclosureConfirmed INT = 153061
	DECLARE @nEventCodeID_PEDisclosureConfirmed INT = 153066
	DECLARE @nMapToType_DisclosureTransaction INT = 132005
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	DECLARE @nDisclosureStatus_NotConfirmed INT = 148002
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
print 'in'

		INSERT INTO @tmpMapPeriod(TPPeriod, CodePeriod) VALUES(137001, 123001), (137002, 123003), (137003, 123004), (137004, 123002)

		SELECT @dtMonthEndDate = CONVERT(VARCHAR(4), YEAR(@dtTodayPlusMonth)) + '-' + CONVERT(VARCHAR(2), MONTH(@dtTodayPlusMonth)) + '-1'
		SELECT @dtMonthEndDate = DATEADD(D, -1, @dtMonthEndDate)
		print @dtMonthEndDate
		print DATEDIFF(D, @dtToday, @dtMonthEndDate)
		IF DATEDIFF(D, @dtToday, @dtMonthEndDate) > 3
		BEGIN 
			RETURN 0
		END
		
		-- Find codes for the PeriodEndFreq, which are applicable to this month end
		-- e.g. If This Month is August, then only users having TP set for PE period = Monthly are supposed to enter period end disclosure
		-- IF this is September then it is Quarter end, Month End and Half year end (assuming Fin year from Apr to Mar)
		INSERT INTO @tmpTPPeriod(DiscloPeriodEndFreq)
		SELECT TPPeriod FROM com_Code cPeriod JOIN @tmpMapPeriod tmpPeriod ON cPeriod.ParentCodeId = tmpPeriod.CodePeriod
		WHERE CodeGroupId = 124
		AND MONTH(@dtMonthEndDate) = MONTH(DATEADD(DAY, -1, CONVERT(DATETIME, Description)))
		
		-- Get the users which have done initial discloser
		INSERT INTO @tmpUserTPForPE (UserInfoId)
		SELECT UF.UserInfoId FROM usr_UserInfo UF 
		LEFT JOIN eve_EventLog EL ON EventCodeId = @nEventCodeID_InitialDisclosureConfirmed AND MapToTypeCodeId = @nMapToType_DisclosureTransaction AND EL.UserInfoId = UF.UserInfoId
		WHERE EventCodeId IS NOT NULL

		--delete User relative who is added after initial disclousre is submitted
		DELETE tmpUI FROM @tmpUserTPForPE tmpUI JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = tmpUI.UserInfoId

		-- Delete the users which are separated - after separation user stauts become inactive
		DELETE tmpUI FROM @tmpUserTPForPE tmpUI JOIN usr_UserInfo UI ON tmpUI.UserInfoId = UI.UserInfoId
		WHERE UI.StatusCodeId = @nUserStatus_Inactive
		
		-- Delete those users for which PE record is already created for this period end (to avoid duplicate entry)
		DELETE tmpUI
		FROM @tmpUserTPForPE tmpUI JOIN tra_TransactionMaster_OS TM ON TM.UserInfoId = tmpUI.UserInfoId 
		AND TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd AND CONVERT(date, TM.PeriodEndDate) = CONVERT(date,@dtMonthEndDate)
		
		-- add applicable TP for each user 
		UPDATE tmpUI SET  tmpUI.TradingPolicyId = vwAppTP.MapToId
		FROM @tmpUserTPForPE tmpUI LEFT JOIN 
		(SELECT UserInfoId, MAX(MapToId) as MapToId FROM vw_ApplicableTradingPolicyForUser_OS GROUP BY UserInfoId) vwAppTP ON 
			tmpUI.UserInfoId = vwAppTP.UserInfoId
		
		-- Delete those users which does not have TP
		DELETE tmpUI
		FROM @tmpUserTPForPE tmpUI WHERE tmpUI.TradingPolicyId IS NULL and tmpUI.PEAddFlag = 1
		
		-- update flag for user for which no need to add new PE record in user PE mapping table
		UPDATE tmpUI SET PEAddFlag = 0 FROM @tmpUserTPForPE tmpUI 
		WHERE tmpUI.UserInfoId IN (SELECT UPEMap.UserInfoId FROM tra_UserPeriodEndMapping_OS UPEMap GROUP BY UPEMap.UserInfoId)
		
		-- check if user allow for PE whos flag is 0 since these user already had record in user PE mapping 
		-- compare dates with current TP period date with stored date
		DECLARE TmpUser_Cursor CURSOR FOR 
			SELECT tmpUI.UserInfoId, tmpUI.TradingPolicyId FROM @tmpUserTPForPE tmpUI
		
		OPEN TmpUser_Cursor

		FETCH NEXT FROM TmpUser_Cursor INTO @nUserInfoId, @nTradingPolicyId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail_OS]
								@nUserInfoId, 
								@nTradingPolicyId, 
								@dtToday,
								@nActinFlag OUTPUT,
								@nApplicableTP OUTPUT, 
								@nYearCodeId OUTPUT, 
								@nPeriodCodeId OUTPUT, 
								@dtPEStartDate OUTPUT, 
								@dtPEEndDate OUTPUT, 
								@bChangePEDate OUTPUT, 
								@dtPEEndDateToUpdate OUTPUT,
								@out_nReturnValue OUTPUT,
								@out_nSQLErrCode OUTPUT,
								@out_sSQLErrMessage OUTPUT
			
			--print '@nActinFlag  id 2 '+convert(varchar, @nActinFlag)
				
			--select @RC, @out_nReturnValue, @out_nSQLErrCode, @out_sSQLErrMessage
			
			-- check flag to update record 
			IF(@nActinFlag = 1 OR @nActinFlag = 3)
			BEGIN print 'add record into table'
			PRINT '@dtPEEndDate' PRINT @dtPEEndDate PRINT 'TODAY' PRINT @dtToday
				IF ( (@dtPEEndDate IS NULL AND CONVERT(date, @dtToday) = CONVERT(date, @dtMonthEndDate)) 
					OR CONVERT(date, @dtToday) = CONVERT(date, @dtPEEndDate))
				BEGIN
					-- add record into table
					--print @nUserInfoId print @nApplicableTP print @nYearCodeId print @nPeriodCodeId print @dtPEStartDate print @dtPEEndDate
					INSERT INTO tra_UserPeriodEndMapping_OS 
						(UserInfoId, TradingPolicyId, YearCodeId, PeriodCodeId, PEStartDate, PEEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
					VALUES
						(@nUserInfoId, @nApplicableTP, @nYearCodeId, @nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())
					
					-- check flag to know if need to update period end date with new date in transaction master table 
					-- this is mainly because period type change from lower to higher 
					IF (@bChangePEDate = 1)
					BEGIN
					print'--- change PE DATE ----'
					print @dtPEEndDate
						UPDATE tra_TransactionMaster_OS SET PeriodEndDate = @dtPEEndDate 
						WHERE UserInfoId = @nUserInfoId AND PeriodEndDate = @dtPEEndDateToUpdate
					END
				END
				
				-- no ealier records in UserPEMapping
				UPDATE tmpUI SET PeriodEndDate = @dtPEEndDate FROM @tmpUserTPForPE tmpUI WHERE tmpUI.UserInfoId = @nUserInfoId
			END
			ELSE IF(@nActinFlag = 2)
			BEGIN
				print'records exists in UserPEMapping'
				-- records exists in UserPEMapping 
				UPDATE tmpUI SET PeriodEndDate = @dtPEEndDate FROM @tmpUserTPForPE tmpUI WHERE tmpUI.UserInfoId = @nUserInfoId
			END
			
			
			FETCH NEXT FROM TmpUser_Cursor INTO @nUserInfoId, @nTradingPolicyId
		END
		CLOSE TmpUser_Cursor
		DEALLOCATE TmpUser_Cursor;
		
		--select * from @tmpUserTPForPE
		print 'month date '+convert(varchar, CONVERT(date, @dtMonthEndDate))
		
		-- Delete those users which does not have period end date
		DELETE tmpUI
		FROM @tmpUserTPForPE tmpUI WHERE tmpUI.PeriodEndDate IS NULL and tmpUI.PEAddFlag = 1
		
		select * from @tmpUserTPForPE
		
		 --Insert records in TransactionMaster for applicable users
		INSERT INTO tra_TransactionMaster_OS
		(UserInfoId,DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId, PeriodEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn )
		SELECT UserInfoId, @nDisclosureType_PeriodEnd, @nDisclosureStatus_NotConfirmed, 0, TradingPolicyId, PeriodEndDate, UserInfoId, @dtToday, UserInfoId, @dtToday
		FROM @tmpUserTPForPE WHERE CONVERT(date, @dtToday) = CONVERT(date, PeriodEndDate)

		-- Insert post dated records in Defaulter Report table
		INSERT INTO rpt_DefaulterReport_OS
		(UserInfoID, InitialContinousPeriodEndDisclosureRequired, TransactionMasterId, LastSubmissionDate, NonComplainceTypeCodeId, PeriodEndDate)
		SELECT TM.UserInfoId, @iDisclosure_Required, TM.TransactionMasterId, DATEADD(D, ISNULL(DiscloPeriodEndToCOByInsdrLimit, 0), TM.PeriodEndDate), @iNonComplianceType_PE, @dtMonthEndDate
		FROM tra_TransactionMaster_OS TM JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON TM.UserInfoId = DefRpt.UserInfoID AND TM.PeriodEndDate = DefRpt.PeriodEndDate AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PE
		WHERE DisclosureTypeCodeId = @iNonDisclosureType_PE AND CONVERT(date, TM.PeriodEndDate) = CONVERT(date, @dtToday)
			AND DefRpt.DefaulterReportID IS NULL
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
