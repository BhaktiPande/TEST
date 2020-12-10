IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_Job_GenerateBulkEvents_PolicyDocument')
DROP PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_PolicyDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure will populate the eventlog table with events for 'Policy Document Created' and 'Policy Docyment Expiry' 
based on the Policy Document applicability for ongoing policy documents
and for all Active CO users, regarding when the ongoing policy documents are to expire 
				
Created by:		Ashashree
Created on:		09-Jul-2015
Modification History:
Modified By		Modified On		Description
Ashashree		11-Jul-2015		Changed query for adding event to eventlog for 'Policy Docyment Expiry' - event will be added if not already added OR if event logged for an event date lesser than policy's ApplicabltTo date
Ashashree		04-Aug-2015		Added the UPDATE query to update the latest Policy Document Expiry date to be same as the Policy.ApplicableTo when Policy.ApplicableTo < MAX(EventLog.EventDate)
Ashashree		06-Aug-2015		Changed the INSERT and UPDATE to EventLog table such that 
								new record is inserted when no records already exists OR when record exists with EventDate <> Policy.ApplicableTo date
								after inserting new records, all other existing records having  EventDate <> Policy.ApplicableTo date, are updated to eventcode Invalid event. 
								Thus at any time instance, only one set of eventlog entries against Active CO Users is valid, with EventCode = PolicyDocumentExpiry. 
Usage:
DECLARE @RC int
EXEC st_cmu_Job_GenerateBulkEvents_PolicyDocument
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_Job_GenerateBulkEvents_PolicyDocument] 
AS
BEGIN
	DECLARE @nPolicyDocumentCreatedEventCodeID				INT = 153039 
	DECLARE @nPolicyDocumentExpiryEventCodeID				INT = 153040
	DECLARE @nMapToTypeCodeId_PolicyDocument				INT = 132001
	DECLARE @nCOUserUserTypeCodeID							INT = 101002
	DECLARE @nActiveUserStatusCodeID						INT = 102001
	DECLARE @nInvalidEventCodeID							INT = 153042

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		/*Log events for 'Policy Document Created (153039)':
		Fetch all such users based on Policy Document applicability such that for the users the event 'Policy Document Created (153039)' is not yet logged in eventlog table. 
		For all such users, inert eventlog entries for eventcode (153039). Do this for all ongoing Policy Documents
		*/	
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		SELECT @nPolicyDocumentCreatedEventCodeID AS EventCodeId, PD.ApplicableFrom AS EventDate, UserPD.UserInfoId AS UserInfoId, 
		@nMapToTypeCodeId_PolicyDocument AS MapToTypeCodeId, UserPD.MapToId AS MapToId, 1 AS CreatedBy
		FROM vw_ApplicablePolicyDocumentForUser_ForNotification UserPD 
		INNER JOIN rul_PolicyDocument PD ON UserPD.MapToId = PD.PolicyDocumentId
		LEFT JOIN eve_EventLog EL 
		ON EL.MapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument AND UserPD.MapToId = EL.MapToId AND PD.PolicyDocumentId = EL.MapToId AND UserPD.UserInfoId = EL.UserInfoId 
		AND EL.EventCodeId = @nPolicyDocumentCreatedEventCodeID
		WHERE EL.UserInfoId IS NULL
		ORDER BY UserPD.UserInfoId, PD.PolicyDocumentId
		
		/*Log events for 'Policy Document Expiry (153040)':
		Generate post dated events in eventlog for 'Policy Document Expiry (153040)' for CO User for ongoing policy documents, 
		if event not already logged against the CO user for the Policy document OR if event is already logged for CO user but with eventdate which is less than the policy document's ApplicableTo date
		In both cases - event not logged OR event logged for lesser date, add new eventlog entry for 'Policy Document Expiry (153040)' for that Co user*/
		
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		SELECT @nPolicyDocumentExpiryEventCodeID  AS EventCodeId, PD.ApplicableTo AS EventDate, UI.UserInfoId AS UserInfoId, 
		@nMapToTypeCodeId_PolicyDocument AS MapToTypeCodeId, PD.PolicyDocumentId AS MapToId, 1 AS CreatedBy
		FROM vw_ApplicabilityMasterCurrentPolicyDocument_ForNotification CurrentPD
		INNER JOIN rul_PolicyDocument PD ON CurrentPD.PolicyDocumentId = PD.PolicyDocumentId
		INNER JOIN usr_UserInfo UI ON UI.UserTypeCodeId = @nCOUserUserTypeCodeID AND UI.StatusCodeId = @nActiveUserStatusCodeID
		LEFT JOIN 
		(
			SELECT EVE.EventLogId, EVE.EventCodeId, T.EventDate, T.UserInfoId, T.MapToTypeCodeId, T.MapToId 
			FROM
			(
				SELECT EVLTriggerEvents1.EventCodeId, MAX(EVLTriggerEvents1.EventDate) AS EventDate, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
				FROM eve_EventLog EVLTriggerEvents1 
				INNER JOIN usr_UserInfo UI ON EVLTriggerEvents1.UserInfoId = UI.UserInfoId AND UI.UserTypeCodeId = @nCOUserUserTypeCodeID
				WHERE EventCodeId = @nPolicyDocumentExpiryEventCodeID
				GROUP BY EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.EventCodeId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
			) T
			INNER JOIN eve_EventLog EVE 
			ON T.UserInfoId = EVE.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND T.EventDate = EVE.EventDate AND T.EventCodeId = EVE.EventCodeId
			AND EVE.EventCodeId = @nPolicyDocumentExpiryEventCodeID AND EVE.MapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument
		) EL 
		ON EL.MapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument AND CurrentPD.PolicyDocumentId = EL.MapToId AND PD.PolicyDocumentId = EL.MapToId AND UI.UserInfoId = EL.UserInfoId 
		AND EL.EventCodeId = @nPolicyDocumentExpiryEventCodeID
		WHERE (EL.UserInfoId IS NULL OR (EL.UserInfoId IS NOT NULL AND PD.ApplicableTo <> EL.EventDate) ) -- Add new event log entry if the policy's ApplicableTo date is extended. So that the event log entry of same policy with earlier ApplicableTo date becomes invalid.
		ORDER BY UI.UserInfoId, PD.PolicyDocumentId
		
		
		/* Update eventdate for existing events 'Policy Document Expiry (153041)':
		Whenever this procedure executes, it might make eventlog entry for Policy Document Expiry for EventLog.EventDate = PolicyDocument.ApplicableTo using above INSERT query.
		At same time, the eventlog table should get updated for earlier existing eventlog entries so that for all "Policy Document Expiry" eventlogs corresponding to MapToId = PolicyDocumentId and having EventDate <> PolicyDocument.ApplicableTo, 
		the EventCodeId gets updated to "InvalidEventCodeId". This will indicate that any given time instance, only one set of eventdate as valid as "Policy Document Expiry" date for the active CO users for ongoing Policy Documents */

		UPDATE eve_EventLog
		SET EventCodeId = @nInvalidEventCodeID
		--SELECT *
		FROM eve_EventLog ELog 
		INNER JOIN vw_ApplicabilityMasterCurrentPolicyDocument_ForNotification CurrentPD 
		ON ELog.MapToId = CurrentPD.PolicyDocumentId AND ELog.MapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument AND ELog.EventCodeId = @nPolicyDocumentExpiryEventCodeID
		INNER JOIN rul_PolicyDocument PD 
		ON CurrentPD.PolicyDocumentId = PD.PolicyDocumentId AND ELog.MapToId = PD.PolicyDocumentId AND ELog.MapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument 
		AND ELog.EventCodeId = @nPolicyDocumentExpiryEventCodeID AND ELog.EventDate <> PD.ApplicableTo

	END TRY
	
	BEGIN CATCH	
		print 'error when saving the event log entries for Policy Document Created (153039) and Policy Document Expiry (153040) and marking events as Invalid Event (153042)'
	END CATCH
END