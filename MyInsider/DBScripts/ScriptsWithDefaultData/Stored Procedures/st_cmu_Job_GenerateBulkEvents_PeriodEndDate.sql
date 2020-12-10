IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_Job_GenerateBulkEvents_PeriodEndDate')
DROP PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_PeriodEndDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure will populate the eventlog table with events for 'Period End Date'(153033) for furute date only if the future date belongs to the same year-month on which this procedures exectues as a job.
The events will be generated only for all Active Insiders based on the Trading Policy applicable to the users at the time when the job executes to generate the eventlog entries.
Events for Period End Date are generated based upon the Period End Frequency associated with the Trading Policy applicable per active insider user.
				
Created by:		Ashashree
Created on:		28-Jul-2015

Modification History:
Modified By		Modified On		Description
Ashashree		03-Nov-2015		Fetching Period end dates (Yearly/ Half yearly/ Quarterly/ Monthly) based on CodeID instead of CodeName from com_Code table and storing the actual PE date within temporary table instead of calculating it everytime within queries. 
Parag			30-Mar-2016		Made change to use correct date for period end disclosure
								in case trading policy is change then compare dates and add applicable date into event log table
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_cmu_Job_GenerateBulkEvents_PeriodEndDate
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_PeriodEndDate] 
AS
BEGIN
	
	DECLARE @dtCurrentDate DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
	DECLARE @dtCurMonthEndDate DATETIME
	
	DECLARE @nPeriodEndDateEventCodeID INT = 153033
	DECLARE @nUserMapToTypeCodeId INT = 132003
	
	DECLARE @nEvent_InitialDisclosureConfirm INT = 153035
	DECLARE @nMapToType_DisclosureTransaction INT = 132005
	
	DECLARE @nUserStatus_Active INT = 102001
	DECLARE @nUserStatus_Inactive INT = 102002
	
	DECLARE @tmpPeriodMap TABLE(UserInfoId INT, PEStartDate DATETIME, PEEndDate DATETIME, TradingPolicyId INT)
	
	DECLARE @tmpEventLog TABLE(
		tmpEventLogId int IDENTITY(1,1), EventCodeId INT, EventDate DATETIME, UserInfoId INT, MapToTypeCodeId INT, MapToId INT,
		CurMonthEndDate DATETIME,
		EventLogId BIGINT , EvePeriodEndDate DATETIME, EveTradingPolicyId INT, 
		MapPeriodStartDate DATETIME, MapPeriodEndDate DATETIME, MapTradingPoliycId INT,
		UserStatus INT, IsDeleteFrmEventLog BIT DEFAULT 0, IsUPEMapRecord BIT DEFAULT 0)
	
	DECLARE @RC INT
	DECLARE @nUserInfoId INT
	DECLARE @nTradingPolicyId INT
	DECLARE @nActinFlag		 		INT
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME
	DECLARE @out_nReturnValue		INT = 0
	DECLARE @out_nSQLErrCode		INT = 0
	DECLARE @out_sSQLErrMessage		VARCHAR(500)
	
	DECLARE @sPeriodEndMonths VARCHAR(2000) = '124008,124009,124010,124011,124012,124013,124014,124015,124016,124017,124018,124019'
	
	DECLARE @tmpPeriodEndDates_Monthly TABLE (PEDate Datetime)
	
	DECLARE @nPeriodYear INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		SELECT @nPeriodYear = YEAR(@dtCurrentDate)
		DECLARE @nDatabaseName NVARCHAR(50)
		SELECT @nDatabaseName = db_name()

		IF(@nDatabaseName = 'Vigilante_AccelyaSolutions')
		BEGIN
			IF(MONTH(@dtCurrentDate) < 7)
			BEGIN
				SET @nPeriodYear = @nPeriodYear - 1
			END
		END
		ELSE
		BEGIN
			IF(MONTH(@dtCurrentDate) < 4)
			BEGIN
				SET @nPeriodYear = @nPeriodYear - 1
			END
		END
		
		INSERT INTO @tmpPeriodEndDates_Monthly(PEDate)
		SELECT DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970, CONVERT(DATETIME,Description)) ) AS PEDate FROM com_Code 
		WHERE CodeID IN (SELECT items FROM dbo.uf_com_Split(@sPeriodEndMonths)) AND CodeGroupId = 124 ORDER BY PEDate
		
		SELECT @dtCurMonthEndDate = PEMonthly.PEDate
		FROM @tmpPeriodEndDates_Monthly PEMonthly 
		WHERE YEAR(PEMonthly.PEDate) = YEAR(@dtCurrentDate) AND MONTH(PEMonthly.PEDate) = MONTH(@dtCurrentDate)

		/*
			Newly impletemeted logic is as follows 
			This procedure will genereate PE records for current months only 
			any future records from event log will be deleted or updated to current month date if needed
			step as follows 
			1 get PE for all user into temp table as per there current TP 
			2 get laster PE date record from event log table for each user
			3 get laster PE record from user period end mapping table
			4 compare current PE, event log PE and user mapping PE dates and update temp table 
			5 delete records from temp table which are not needed 
			5 delete records from event log and temp table which are not needed 
			6 insert records from temp table into event log for whom PE is required in current month
		*/
		
		-- Get the users which have done initial discloser
		INSERT INTO @tmpEventLog (UserInfoId, UserStatus, CurMonthEndDate) 
		SELECT UF.UserInfoId, UF.StatusCodeId, @dtCurMonthEndDate FROM usr_UserInfo UF 
		LEFT JOIN eve_EventLog EL ON EventCodeId = @nEvent_InitialDisclosureConfirm 
		AND MapToTypeCodeId = @nMapToType_DisclosureTransaction AND EL.UserInfoId = UF.UserInfoId
		WHERE EventCodeId IS NOT NULL
		
		-- add applicable TP for each user 
		UPDATE t SET t.MapToId  = vwAppTP.MapToId
		FROM @tmpEventLog t LEFT JOIN 
		(SELECT UserInfoId, MAX(MapToId) as MapToId FROM vw_ApplicableTradingPolicyForUser GROUP BY UserInfoId) vwAppTP ON 
		t.UserInfoId = vwAppTP.UserInfoId
		
		
		
		DECLARE TmpUser_Cursor CURSOR FOR 
			SELECT t.UserInfoId, t.MapToId as TradingPolicyId FROM @tmpEventLog t WHERE t.MapToId IS NOT NULL
			
		OPEN TmpUser_Cursor

		FETCH NEXT FROM TmpUser_Cursor INTO @nUserInfoId, @nTradingPolicyId
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
								@nUserInfoId, 
								@nTradingPolicyId, 
								@dtCurrentDate,
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
			
			UPDATE t SET 
				t.EventCodeId = @nPeriodEndDateEventCodeID, 
				t.EventDate = @dtPEEndDate,
				t.MapToTypeCodeId = @nUserMapToTypeCodeId
			FROM @tmpEventLog t WHERE t.UserInfoId = @nUserInfoId
			
			FETCH NEXT FROM TmpUser_Cursor INTO @nUserInfoId, @nTradingPolicyId
		END
		CLOSE TmpUser_Cursor
		DEALLOCATE TmpUser_Cursor;
		
		-- update temp table with event log data for each user
		UPDATE t SET t.EventLogId = evt.EventLogId
		FROM  @tmpEventLog t  LEFT JOIN (select max(EventLogId) as EventLogId, UserInfoId  from eve_EventLog 
		where EventCodeId = @nPeriodEndDateEventCodeID and MapToTypeCodeId = @nUserMapToTypeCodeId
		group by UserInfoId) evt ON t.UserInfoId = evt.UserInfoId
		
		UPDATE t SET t.EvePeriodEndDate = EL.EventDate, t.EveTradingPolicyId = EL.MapToId
		FROM  @tmpEventLog t LEFT JOIN eve_EventLog EL on t.EventLogId = EL.EventLogId
		
		-- get latest applicable period end date for user into temp table
		insert into @tmpPeriodMap 
			(UserInfoId, PEStartDate, PEEndDate, TradingPolicyId)
		SELECT 
			UPEM.UserInfoId, UPEM.PEStartDate, UPEM.PEEndDate, UPEM.TradingPolicyId 
		FROM tra_UserPeriodEndMapping UPEM 
		INNER JOIN 
		(SELECT UserInfoId, MAX(CreatedOn) as CreatedOn FROM tra_UserPeriodEndMapping GROUP BY UserInfoId) t 
			ON UPEM.UserInfoId = t.UserInfoId AND UPEM.CreatedOn = t.CreatedOn
		
		-- Update applicable period end date as per period end mapping 
		UPDATE tmp SET 
			MapPeriodStartDate = Map.PEStartDate, 
			MapPeriodEndDate = Map.PEEndDate,
			MapTradingPoliycId = Map.TradingPolicyId,
			IsUPEMapRecord = CASE WHEN Map.UserInfoId IS NOT NULL THEN 1 ELSE 0 END
		FROM @tmpEventLog tmp LEFT JOIN @tmpPeriodMap Map ON tmp.UserInfoId = Map.UserInfoId
		
		
		
		-- delete records from temp table which are not need
		-- 1. when PE date is not available (either TP no applicable or PE no applicable)
		--		1.1 delete records from temp table for 
		--			a. when event log PE date is null and PE mapping date is future OR null
		--			b. when event log PE date is current month and PE mapping date is current month too 
		--			c. when event log PE date is past month date and PE mapping date is null, OR in future OR past month
		
		--		1.2 delete records from event log and temp table for 
		--			a. when event log PE date is current month end date and PE mapping date is null, OR in future OR past month
		
		
		-- 2. when PE date is in current month
		--		2.1 delete records from temp table for 
		--			a. when event log PE date is null and PE mapping date is future OR null
		--			b. when event log PE date is current month and PE mapping date is current month OR past month
		--			c. when event log PE date is past month date and PE mapping date is null, OR in future
		
		--		2.2 delete records from event log and temp table for 
		--			a. when event log PE date is current month end date and PE mapping date is null, OR in future
		
		
		-- 3. when PE date in future 
		--		3.1 delete records from temp table for 
		--			a. when event log PE date is null and PE mapping date is future OR null
		--			b. when event log PE date is current month and PE mapping date is current month
		--			c. when event log PE date is past month date and PE mapping date is null, OR in future OR past month
		
		--		3.2 delete records from event log and temp table for 
		--			a. when event log PE date is current month end date and PE mapping date is null, OR in future OR past month
		
		print 'start processing temp table to update/remove records which not required for current month PE'
		
		-- case 1.2
		UPDATE t SET t.IsDeleteFrmEventLog = 1 FROM @tmpEventLog t 
		WHERE t.EventDate IS NULL AND t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate
		AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate)
		
		-- case 1.1
		DELETE t FROM @tmpEventLog t 
		WHERE t.EventDate IS NULL 
		AND 
		(
			(t.EvePeriodEndDate IS NULL AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate))
			OR 
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate AND t.MapPeriodEndDate IS NOT NULL AND t.MapPeriodEndDate = t.CurMonthEndDate)
			OR 
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate < t.CurMonthEndDate AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate))
			OR 
			(t.UserStatus = @nUserStatus_Inactive AND t.IsDeleteFrmEventLog = 0)
		)
		
		-- case 2.2
		UPDATE t SET t.IsDeleteFrmEventLog = 1 FROM @tmpEventLog t 
		WHERE t.EventDate IS NOT NULL AND t.EventDate = t.CurMonthEndDate
		AND t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate
		AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate)
		
		-- case 2.1
		DELETE t FROM @tmpEventLog t 
		WHERE t.EventDate IS NOT NULL AND t.EventDate = t.CurMonthEndDate
		AND 
		(
			(t.EvePeriodEndDate IS NULL AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate))
			OR 
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate AND t.MapPeriodEndDate IS NOT NULL AND (t.MapPeriodEndDate = t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate))
			OR
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate < t.CurMonthEndDate AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate))
			OR 
			(t.UserStatus = @nUserStatus_Inactive AND t.IsDeleteFrmEventLog = 0)
		)
		
		-- case 3.2
		UPDATE t SET t.IsDeleteFrmEventLog = 1 FROM @tmpEventLog t 
		WHERE t.EventDate IS NOT NULL AND t.EventDate > t.CurMonthEndDate
		AND t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate
		AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate)
		
		-- case 3.1
		DELETE t FROM @tmpEventLog t 
		WHERE t.EventDate IS NOT NULL AND t.EventDate > t.CurMonthEndDate
		AND 
		(
			(t.EvePeriodEndDate IS NULL AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate))
			OR
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.CurMonthEndDate AND t.MapPeriodEndDate IS NOT NULL AND t.EvePeriodEndDate = t.MapPeriodEndDate)
			OR
			(t.EvePeriodEndDate IS NOT NULL AND t.EvePeriodEndDate < t.CurMonthEndDate AND (t.MapPeriodEndDate IS NULL OR t.MapPeriodEndDate > t.CurMonthEndDate OR t.MapPeriodEndDate < t.CurMonthEndDate))
			OR 
			(t.UserStatus = @nUserStatus_Inactive AND t.IsDeleteFrmEventLog = 0)
		)
		
		print 'delete records from event log and temp table which not required for current month PE'
		
		-- delete period end date(153033) records from event log table
		DELETE el FROM eve_EventLog el INNER JOIN @tmpEventLog t ON el.EventLogId = t.EventLogId AND t.IsDeleteFrmEventLog = 1
		
		-- delete records from temp table which are already deleted from event log table 
		DELETE t FROM @tmpEventLog t WHERE t.IsDeleteFrmEventLog = 1
		
		print 'insert records from temp table which need  for current month PE'
		
		-- remaining records from temp table will be added into event log table 
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		SELECT t.EventCodeId, t.EventDate, t.UserInfoId, t.MapToTypeCodeId, t.MapToId, 1 AS CreatedBy 
		FROM @tmpEventLog t WHERE t.UserStatus = @nUserStatus_Active AND t.EventDate IS NOT NULL
		
		select * from @tmpEventLog
		
	END TRY
	
	BEGIN CATCH	
		print 'error when saving the event log entries for Period End Date(153033)'
	END CATCH

END