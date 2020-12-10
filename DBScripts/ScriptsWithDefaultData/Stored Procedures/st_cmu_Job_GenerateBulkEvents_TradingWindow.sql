IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_Job_GenerateBulkEvents_TradingWindow')
DROP PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_TradingWindow]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure will populate the eventlog table with events for 'Trading Window Close' and 'Trading Window Open' 
for Close and Open dates of Trading Window for furute date.
The events will be generated for all Active CO users and all Active Insiders.
Trading Window of type "Other" will have its corresponding event logs generated for "Applicability based Insider" users.
Trading Window of type "Financial Results" will have its corresponding event logs generated for "All Active Insider" users, based on DateOfBecomingInsider for insiders, during the run of this procedure.
				
Created by:		Ashashree
Created on:		22-Jul-2015
Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_cmu_Job_GenerateBulkEvents_TradingWindow
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_TradingWindow] 
AS
BEGIN
	DECLARE @nTradingWindowEventTypeFinancialResult INT = 126001
	DECLARE @nTradingWindowEventTypeOther INT = 126002
	DECLARE @nMapToTypeCodeIdTradingWindow INT = 132009
	DECLARE @nEventCodeIdTradingWindowClose INT = 153025
	DECLARE @nEventCodeIdTradingWindowOpen INT = 153026
	DECLARE @nActiveUserStatusCodeId INT = 102001
	DECLARE @nUserTypeCodeIdRelative INT = 101007
	DECLARE @nUserTypeCodeIdCOUser INT = 101002
	--DECLARE @nTradingWindowEventStatusActive INT = 131002
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
	------------Start - Generate Window Close/Open events for Insider Users--------------------
	--Trading Window "Financial Results" - Add Window Close Date events to eventlog (for future close date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowClose AS EventCodeId, WindowCloseDate AS EventDate, UI.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN usr_UserInfo UI 
	ON UI.StatusCodeId = @nActiveUserStatusCodeId 
	AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() 
	AND (UI.DateOfSeparation IS NULL OR UI.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))) 
	AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
	AND dbo.uf_com_GetServerDate() <= TWE.WindowCloseDate AND TWE.EventTypeCodeId = @nTradingWindowEventTypeFinancialResult
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON UI.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowClose
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowCloseDate, UI.UserInfoId

	--Trading Window "Other" - Add Window Close Date events to eventlog (for future close date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowClose AS EventCodeId, WindowCloseDate AS EventDate, TWOForUser.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN vw_ApplicableTradingWindowEventOtherForUser TWOForUser ON TWE.TradingWindowEventId = TWOForUser.MapToId 
	AND dbo.uf_com_GetServerDate() <= TWE.WindowCloseDate AND TWE.EventTypeCodeId = @nTradingWindowEventTypeOther
	INNER JOIN usr_UserInfo UI  ON TWOForUser.UserInfoId = UI.UserInfoId AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON TWOForUser.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowClose
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowCloseDate, TWOForUser.UserInfoId

	--Trading Window "Financial Results" - Add Window Open Date events to eventlog (for future open date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowOpen AS EventCodeId, WindowOpenDate AS EventDate, UI.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN usr_UserInfo UI 
	ON UI.StatusCodeId = @nActiveUserStatusCodeId 
	AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() 
	AND (UI.DateOfSeparation IS NULL OR UI.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))) 
	AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
	AND dbo.uf_com_GetServerDate() <= TWE.WindowOpenDate AND TWE.EventTypeCodeId = @nTradingWindowEventTypeFinancialResult
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON UI.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowOpen
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowOpenDate, UI.UserInfoId

	--Trading Window "Other" - Add Window Open Date events to eventlog (for future open date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowOpen AS EventCodeId, WindowOpenDate AS EventDate, TWOForUser.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN vw_ApplicableTradingWindowEventOtherForUser TWOForUser ON TWE.TradingWindowEventId = TWOForUser.MapToId
	AND dbo.uf_com_GetServerDate() <= TWE.WindowOpenDate AND TWE.EventTypeCodeId = @nTradingWindowEventTypeOther
	INNER JOIN usr_UserInfo UI  ON TWOForUser.UserInfoId = UI.UserInfoId AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON TWOForUser.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowOpen
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowOpenDate, TWOForUser.UserInfoId
	------------End - Generate Window Close/Open events for Insider Users--------------------

	------------Start - Generate Window Close/Open events for CO Users--------------------
	--Trading Window "Financial Results" and Trading Window "Other" - Add Window Close Date events to eventlog (for future close date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowClose AS EventCodeId, WindowCloseDate AS EventDate, UI.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN usr_UserInfo UI 
	ON UI.StatusCodeId = @nActiveUserStatusCodeId 
	AND UI.UserTypeCodeId = @nUserTypeCodeIdCOUser
	AND dbo.uf_com_GetServerDate() <= TWE.WindowCloseDate
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON UI.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowClose
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowCloseDate, UI.UserInfoId

	--Trading Window "Financial Results" and Trading Window "Other" - Add Window Open Date events to eventlog (for future close date)
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
	SELECT @nEventCodeIdTradingWindowOpen AS EventCodeId, WindowOpenDate AS EventDate, UI.UserInfoId, @nMapToTypeCodeIdTradingWindow AS MapToTypeCodeID, TradingWindowEventId AS MapToId, 1 AS CreatedBy
	FROM rul_TradingWindowEvent TWE
	INNER JOIN usr_UserInfo UI 
	ON UI.StatusCodeId = @nActiveUserStatusCodeId 
	AND UI.UserTypeCodeId = @nUserTypeCodeIdCOUser
	AND dbo.uf_com_GetServerDate() <= TWE.WindowOpenDate
	--AND TradingWindowStatusCodeId = @nTradingWindowEventStatusActive
	LEFT JOIN eve_EventLog EL ON UI.UserInfoId = EL.UserInfoId AND EL.MapToId = TWE.TradingWindowEventId AND EL.EventCodeId = @nEventCodeIdTradingWindowOpen
	WHERE EL.UserInfoId IS NULL
	ORDER BY TWE.WindowOpenDate, UI.UserInfoId
	------------End - Generate Window Close/Open events for CO Users--------------------
	
	-----------Start - UPDATE existing eventlog records of those users for whom event is already logged for Trading Window Close/Open but eventdate differes from the Trading Window's actual Close/Open date ----------------
	/*This scenario will typically occur when events are already logged and then the Window Close/Open date is changed after the event gets logged - in such a scenario the logged eventdate also needs to be updated*/
	UPDATE eve_EventLog
	SET EventDate = TWE.WindowCloseDate
	--SELECT *
	FROM eve_EventLog EL 
	INNER JOIN rul_TradingWindowEvent TWE 
	ON EL.MapToTypeCodeId = @nMapToTypeCodeIdTradingWindow AND EL.MapToId = TWE.TradingWindowEventId 
	AND EL.EventCodeId = @nEventCodeIdTradingWindowClose AND EL.EventDate <> TWE.WindowCloseDate

	UPDATE eve_EventLog
	SET EventDate = TWE.WindowOpenDate
	--SELECT *
	FROM eve_EventLog EL 
	INNER JOIN rul_TradingWindowEvent TWE 
	ON EL.MapToTypeCodeId = @nMapToTypeCodeIdTradingWindow AND EL.MapToId = TWE.TradingWindowEventId 
	AND EL.EventCodeId = @nEventCodeIdTradingWindowOpen AND EL.EventDate <> TWE.WindowOpenDate
	-----------End - UPDATE existing eventlog records of those users for whom event is already logged for Trading Window Close/Open but eventdate differes from the Trading Window's actual Close/Open date ----------------
	END TRY
	
	BEGIN CATCH	
		print 'error when saving the event log entries for Trading Window Close(153025) and Trading Window Open(153026)'
	END CATCH
END