IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_Job_GenerateBulkEvents_TradingPolicy')
DROP PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_TradingPolicy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure will populate the eventlog table with event for 'Trading Policy Expiry (153041)' 
for all Active CO users, regarding when the ongoing trading policies are to expire 

Created by:		Ashashree
Created on:		06-Aug-2015

Modification History:
Modified By		Modified On		Description
Tushar			28-Jun-2016		Add condition AND TP.CurrentHistoryCodeId = 134001
								Send Trading policy expiry event for current trading policy.
Usage:
DECLARE @RC int
EXEC st_cmu_Job_GenerateBulkEvents_TradingPolicy
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_TradingPolicy] 
AS
BEGIN
	DECLARE @nTradingPolicyExpiryEventCodeID				INT = 153041
	DECLARE @nMapToTypeCodeId_TradingPolicy					INT = 132002
	DECLARE @nCOUserUserTypeCodeID							INT = 101002
	DECLARE @nActiveUserStatusCodeID						INT = 102001
	DECLARE @nInvalidEventCodeID							INT = 153042 

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		/*Log events for 'Trading Policy Expiry (153041)':
		Generate post dated events in eventlog for 'Trading Policy Expiry (153041)' for CO User for ongoing trading policies, 
		if event not already logged against the CO user for the Trading Policy OR 
		if event is already logged for CO user but with eventdate which is not same as the trading policy's ApplicableToDate
		In both cases - event not logged OR event logged for different ApplicableToDate, add new eventlog entry for 'Trading Policy Expiry (153041)' for that CO user*/
		
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		SELECT @nTradingPolicyExpiryEventCodeID  AS EventCodeId, TP.ApplicableToDate AS EventDate, UI.UserInfoId AS UserInfoId, 
		@nMapToTypeCodeId_TradingPolicy AS MapToTypeCodeId, TP.TradingPolicyId AS MapToId, 1 AS CreatedBy
		FROM vw_ApplicabilityMasterCurrentTradingPolicy CurrentTP
		INNER JOIN rul_TradingPolicy TP ON CurrentTP.MapToId = TP.TradingPolicyId AND CurrentTP.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy
		INNER JOIN usr_UserInfo UI ON UI.UserTypeCodeId = @nCOUserUserTypeCodeID AND UI.StatusCodeId = @nActiveUserStatusCodeID
		LEFT JOIN 
		(
			SELECT EVE.EventLogId, EVE.EventCodeId, T.EventDate, T.UserInfoId, T.MapToTypeCodeId, T.MapToId 
			FROM
			(
				SELECT EVLTriggerEvents1.EventCodeId, MAX(EVLTriggerEvents1.EventDate) AS EventDate, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
				FROM eve_EventLog EVLTriggerEvents1 
				INNER JOIN usr_UserInfo UI ON EVLTriggerEvents1.UserInfoId = UI.UserInfoId AND UI.UserTypeCodeId = @nCOUserUserTypeCodeID
				WHERE EventCodeId = @nTradingPolicyExpiryEventCodeID
				GROUP BY EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.EventCodeId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
			) T
			INNER JOIN eve_EventLog EVE 
			ON T.UserInfoId = EVE.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND T.EventDate = EVE.EventDate AND T.EventCodeId = EVE.EventCodeId 
			AND EVE.EventCodeId = @nTradingPolicyExpiryEventCodeID AND EVE.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy
		) EL 
		ON EL.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy AND CurrentTP.MapToId = EL.MapToId AND TP.TradingPolicyId = EL.MapToId AND UI.UserInfoId = EL.UserInfoId 
		AND EL.EventCodeId = @nTradingPolicyExpiryEventCodeID
		WHERE (EL.UserInfoId IS NULL OR (EL.UserInfoId IS NOT NULL AND TP.ApplicableToDate <> EL.EventDate) ) -- Add new event log entry if the trading policy's ApplicableToDate is differnt from the EventDate. So that the event log entry of same trading policy with different ApplicableToDate becomes invalid.
		AND TP.CurrentHistoryCodeId = 134001
		ORDER BY UI.UserInfoId, TP.TradingPolicyId
		
		
		/* Update eventdate for existing events 'Trading Policy Expiry (153041)':
		Whenever this procedure executes, it might make eventlog entry for Trading Policy Expiry for EventLog.EventDate = TradingPolicy.ApplicableToDate usign above INSERT query.
		At same time, the eventlog table should get updated for earlier existing eventlog entries so that for all "Trading Policy Expiry" eventlogs corresponding to MapToId = TradingPolicyId and having EventDate <> TradingPolicy.ApplicableToDate, 
		the EventCodeId gets updated to "InvalidEventCodeId". This will indicate that any given time instance, only one set of eventdate as valid as "Trading Policy Expiry" date for the active CO users for ongoing Trading Policies */

		UPDATE eve_EventLog
		SET EventCodeId = @nInvalidEventCodeID
		--SELECT *
		FROM eve_EventLog ELog
		INNER JOIN vw_ApplicabilityMasterCurrentTradingPolicy CurrentTP 
		ON ELog.MapToId = CurrentTP.MapToId AND CurrentTP.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy AND ELog.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy AND ELog.EventCodeId = @nTradingPolicyExpiryEventCodeID
		INNER JOIN rul_TradingPolicy TP 
		ON CurrentTP.MapToId = TP.TradingPolicyId AND ELog.MapToId = TP.TradingPolicyId AND ELog.MapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy 
		AND ELog.EventCodeId = @nTradingPolicyExpiryEventCodeID AND ELog.EventDate <> TP.ApplicableToDate
		
		
	END TRY
	
	BEGIN CATCH	
		print 'error when saving the event log entries for Trading Policy Expiry (153041) and marking events as Invalid Event (153042)'
	END CATCH
END