/*-------------------------------------------------------------------------------------------------
This procedure populates notification queue table cmu_NotificationQueue, with notifications to be sent to users based on communication rule and the their communication modes (Email/SMS/Popup alert).

Notifications are generated based on events logged within the table eve_EventLog, depending on the actions taken / not-yet-taken by system users.
Communication Rules are stored in table cmu_CommunicationRuleMaster. Their corresponding communication modes are stored in table cmu_CommunicationRuleModeMaster.
Procedure queries different tables and generates the notification content within table cmu_NotificationQueue. 

Notifications stored in cmu_NotificationQueue are to be sent on immediate basis. Notifications of future date are NOT generated in advance.
If notification is generated for a CO user, for a list of Insiders then this list of Insiders is stored in table cmu_NotificationQueueParameters, corresponding to the notification for CO user which is stored in cmu_NotificationQueue.
If there are any attachments to be sent along with the email notification, these are stored in table cmu_NotificationDocReference, along with reference of corresponding notification from table cmu_NotificationQueue.

Notification is sent N number of times, to a user where N is less/equal the max-notification count defined against the notifiction mode of a communication rule.
When notifying CO user about Insiders, count of notifications already sent to CO user is considered on a CO user -Insider user basis, for pair of CO user - Insider user. Count of notifications already sent is considered using tables cmu_NotificationQueue and cmu_NotificationQueueParameters together.
When sending notification to CO user, that is not related to any Insider, count of already sent notifications is obtained using entries from cmu_NotificationQueue.
When sending notification to Insider user, count of already sent notification is obtained using entries from table cmu_NotificationQueue.

This procedure is scheduled as a SQL Server Agent job, to run every 15 minutes. This job scheduling is done using script within procedure - st_cmu_CreateJob_NotificationQueueGenerator.


Created by:		Rutuja, Priyanka
Created on:		16-Jan-2017


Usage:
DECLARE @RC int
EXEC st_cmu_Job_NotificationQueueGenerator
-------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_Job_NotificationQueueGenerator_NonImplComp]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[st_cmu_Job_NotificationQueueGenerator_NonImplComp]
GO

CREATE PROCEDURE [dbo].[st_cmu_Job_NotificationQueueGenerator_NonImplComp] 
AS
BEGIN
	-------------- TO REMOVE AFTER PROCEDURE GETS SCHEDULED AS A JOB-----------
	--begin tran
	-------------- TO REMOVE AFTER PROCEDURE GETS SCHEDULED AS A JOB-----------
	-----------------Start - Notification Queue Generator
	DECLARE @nSQLErrCode INT = 0 -- Output SQL Error Number, if error occurred.
	DECLARE @sSQLErrMessage VARCHAR(500) = '' -- Output SQL Error Message, if error occurred.

	DECLARE @nRulesCnt	INT
	DECLARE @nCounter	INT = 0
	DECLARE @nRuleId	INT = 0
	DECLARE @sRuleTriggerEventCodeIds VARCHAR(500)
	DECLARE @sRuleOffsetEventCodeIds VARCHAR(500)
	DECLARE @sRuleForCodeIds	VARCHAR(50)
	DECLARE @nRuleCategoryCodeId INT 
	DECLARE @nRuleEventsApplyToCodeId INT
	
	DECLARE @nRuleForInsiderCodeId		INT = 159001
	DECLARE @nRuleForCOCodeId			INT = 159002
	DECLARE @nRuleCategoryCodeIdAuto	INT = 157001
	DECLARE @nRuleCategoryCodeIdManual	INT = 157002
	DECLARE @nRuleEventsApplyToCodeIdInsider INT = 163001
	DECLARE @nRuleEventsApplyToCodeIdCO INT = 163002
	
	DECLARE @nModeExecFreqHalt	INT = 158001
	DECLARE @nModeExecFreqOnce	INT = 158002
	DECLARE @nModeExecFreqDaily	INT = 158003
	
	DECLARE @nUserTypeCodeIdCOUser	INT = 101002
	DECLARE @nUserTypeCodeIdRelative INT = 101007
	
	DECLARE @nModeCodeIdLetter INT = 156001
	DECLARE @nModeCodeIdEmail INT = 156002
	DECLARE @nModeCodeIdSMS	INT = 156003
	DECLARE @nModeCodeIdTextAlert INT = 156004
	DECLARE @nModeCodeIdPopupAlert INT = 156005
	
	DECLARE @nAppURLCodeId INT = 128004 -- CodeId for which the CodeName will store the system startup URL to be sent to users in the welcome user email notification
	DECLARE @sAppURLCodeValue NVARCHAR(512) = ''
	DECLARE @sPlaceholderLoginId VARCHAR(50) = '|~|LOGIN_ID|~|'
	DECLARE @sPlaceholderFirstName VARCHAR(50) = '|~|FIRST_NAME|~|'
	DECLARE @sPlaceholderMiddleName VARCHAR(50) = '|~|MIDDLE_NAME|~|'
	DECLARE @sPlaceholderLastName VARCHAR(50) = '|~|LAST_NAME|~|'
	DECLARE @sPlaceholderUserID VARCHAR(50) = '|~|USER_ID|~|'
	DECLARE @sPlaceholderCompanyName VARCHAR(50) = '|~|COMPANY_NAME|~|'
	DECLARE @sPlaceholderEmailID VARCHAR(50) = '|~|EMAIL_ID|~|'
	DECLARE @sPlaceholderMobileNumber VARCHAR(50) = '|~|MOBILE_NUMBER|~|'
	DECLARE @sPlaceholderGrade VARCHAR(50) = '|~|GRADE|~|'
	DECLARE @sPlaceholderCountry VARCHAR(50) = '|~|COUNTRY|~|'
	DECLARE @sPlaceholderAddress VARCHAR(512) = '|~|ADDRESS|~|'
	DECLARE @sPlaceholderPinCode VARCHAR(15) = '|~|PIN_CODE|~|'
	DECLARE @sPlaceholderPan VARCHAR(15) = '|~|PAN|~|'
	DECLARE @sPlaceholderDateOfJoining VARCHAR(50) = '|~|DATE_OF_JOINING|~|'
	DECLARE @sPlaceholderDateOfBecomingInsider VARCHAR(50) = '|~|DATE_OF_BECOMING_INSIDER|~|'
	DECLARE @sPlaceholderCategory VARCHAR(50) = '|~|CATEGORY|~|'
	DECLARE @sPlaceholderSubCategory VARCHAR(50) = '|~|SUB_CATEGORY|~|'
	DECLARE @sPlaceholderDesignation VARCHAR(50) = '|~|DESIGNATION|~|'
	DECLARE @sPlaceholderSubDesignation VARCHAR(50) = '|~|SUB_DESIGNATION|~|'
	DECLARE @sPlaceholderLocation VARCHAR(50) = '|~|LOCATION|~|'
	DECLARE @sPlaceholderDepartment VARCHAR(50) = '|~|DEPARTMENT|~|'
	
	DECLARE @sPlaceholderAppURL VARCHAR(50) = '|~|APP_URL|~|'
	DECLARE @sPlaceholderAppURLAnchorTag VARCHAR(50) = '|~|APP_URL_ANCHOR|~|'
	DECLARE @sPlaceholderAppURLAnchorText VARCHAR(50) = 'Click Here'
	
	DECLARE @sPlaceholderPolicyDocumentName VARCHAR(50) = '|~|POLICY_DOC_NAME|~|'
	DECLARE @sPlaceholderPolicyDocumentExpiryDate VARCHAR(50) = '|~|POLICY_DOC_EXPIRY_DATE|~|'
	DECLARE @sPlaceHolderPolicyDocumentCreateDate VARCHAR(50) = '|~|POLICY_DOC_CREATE_DATE|~|'
	DECLARE @sPlaceHolderPolicyDocumentStartDate VARCHAR(50) = '|~|POLICY_DOC_START_DATE|~|'
	
	--Placeholders to replace in template for notifying insiders when pre-clearance gets Approved/Rejected.
	DECLARE @sPlaceholderPreClearanceCreateDate VARCHAR(50) = '|~|PRE_CLEAR_DATE|~|'
	DECLARE @sPlaceholderPreClearanceStatus VARCHAR(50) = '|~|PRE_CLEAR_APPROVE_REJECT|~|'
	DECLARE @sPlaceholderPreClearanceExpiryDate VARCHAR(50) = '|~|PRE_CLEAR_EXPIRY_DATE|~|'
	
	--Placeholders to replace in template for notifying insiders for pre-clearance.
	DECLARE @sPlaceholderPreClearanceID VARCHAR(500) = '|~|PRE_CLEAR_ID|~|'
	DECLARE @sPlaceholderPreClearanceRequestFor VARCHAR(50) = '|~|PRE_CLEAR_REQUEST_FOR|~|'
	DECLARE @sPlaceholderPreClearanceDEMATAccNo VARCHAR(50) = '|~|PRE_CLEAR_DEMAT_ACC|~|'
	DECLARE @sPlaceholderPreClearanceTransactionType VARCHAR(50) = '|~|PRE_CLEAR_TRANSACTION_TYPE|~|'
	DECLARE @sPlaceholderPreClearanceSecurityType VARCHAR(50) = '|~|PRE_CLEAR_SECURITY_TYPE|~|'
	DECLARE @sPlaceholderPreClearanceSecurityToBeTradeQty VARCHAR(50) = '|~|PRE_CLEAR_SECURITY_TO_BE_TRADE_QTY|~|'
	DECLARE @sPlaceholderPreClearanceValueOfPropseTrade VARCHAR(50) = '|~|PRE_CLEAR_VALUE_OF_PROPOSE_TRADE|~|'
	
	--Placeholders for Trading Window Close/Open notifications
	DECLARE @sPlaceholderTradingWindowEventType VARCHAR(50) = '|~|TRADING_WINDOW_EVENT_TYPE|~|'
	DECLARE @sPlaceholderTradingWindowId VARCHAR(50) = '|~|TRADING_WINDOW_ID|~|'
	DECLARE @sPlaceholderTradingWindowFinancialYear VARCHAR(50) = '|~|FINANCIAL_YEAR_CODE|~|'
	DECLARE @sPlaceholderTradingWindowFinancialPeriod VARCHAR(50) = '|~|FINANCIAL_PERIOD_CODE|~|'
	DECLARE @sPlaceholderTradingWindowCloseDate VARCHAR(50) = '|~|WINDOW_CLOSE_DATE|~|'
	DECLARE @sPlaceholderTradingWindowOpenDate VARCHAR(50) = '|~|WINDOW_OPEN_DATE|~|'
	DECLARE @sPlaceholderTradingWindowOpenTime VARCHAR(50) = '|~|WINDOW_OPEN_TIME|~|'
	DECLARE @sPlaceholderTradingWindowCloseTime VARCHAR(50) = '|~|WINDOW_CLOSE_TIME|~|'
	
	--Placeholders for Trading Policy Expiry notification
	DECLARE @sPlaceholderTradingPolicyName VARCHAR(50) = '|~|TRADING_POLICY_NAME|~|'
	DECLARE @sPlaceholderTradingPolicyExpiryDate VARCHAR(50) = '|~|TRADING_POLICY_EXPIRY_DATE|~|'
	DECLARE @sPlaceHolderTradingPolicyCreateDate VARCHAR(50) = '|~|TRADING_POLICY_CREATE_DATE|~|'
	DECLARE @sPlaceHolderTradingPolicyStartDate VARCHAR(50) = '|~|TRADING_POLICY_START_DATE|~|'
	
	--Placeholders to replace in template for notifying insiders for last date of submission of initail disclosure and period end disclosure.
	DECLARE @sPlaceholderDisclosureLastSubmissionDate VARCHAR(50) = '|~|DISCLOSURE_LAST_SUBMIT_DATE|~|'
	
	DECLARE @sPlaceholderPeriodEndDisclosureDaysToSubmit VARCHAR(50) = '|~|PERIOD_END_DISCLOSURE_DAYS_TO_SUBMIT|~|'
	
	--When trigger/offset events are both specified for a rule then, make conditional JOIN on MapToId if TriggerMapToType = OffsetMapToType for trigger and offset event codes, else omit this JOIN condition
	DECLARE @nTriggerMapToType INT 
	DECLARE @nOffSetMapToType INT
	DECLARE @nMapToTypeCodeIdUser INT = 132003
	DECLARE @sSQLInsertToTempTable VARCHAR(MAX)
	DECLARE @sMaxTriggerEventTableQuery VARCHAR(4000)
		
	DECLARE @nInsidersWithoutOffset INT
	
	DECLARE @nCOUserToNotifyCount INT
	DECLARE @nCOUserToNotifyCounter	INT = 0
	DECLARE @nModeCodeId INT
	DECLARE @nCOUserInfoId INT
	DECLARE @nNotificationQueueId BIGINT
	
	DECLARE @sTemplateContents NVARCHAR(MAX)
	DECLARE @sHTMLContent NVARCHAR(MAX) --To store the template contents + HTMLContent (user list) as Email contents, if ModeCode for Rule is Email. Otherwise this will store only the template contents. User-list HTMLContent is appliable only for Email type of Communication Mode
	DECLARE @sTempHTMLContent NVARCHAR(MAX) --Temporary storage for appended string
	DECLARE @sNotificationContents NVARCHAR(MAX)
	
	DECLARE @nNotificationParamCount INT
	DECLARE @nNotificationParamCounter INT = 0
	
	DECLARE @nUserInfoId INT
	DECLARE @sEmployeeId NVARCHAR(50)
	DECLARE @sUsername NVARCHAR(150)
	DECLARE @sEmailId NVARCHAR(250)
	DECLARE @sMobileNumber NVARCHAR(15)
	DECLARE @nCountOfOccurences INT
	
	DECLARE @bRuleForContinuousDiscloHardCopySubmitToStkEx BIT = 0
	DECLARE @nContinuousDisclosureConfirmedCodeId INT = 153036
	DECLARE @nContinuousDisclosureCOSubmittedHardcopyToStkEx INT = 153024
	DECLARE @nMapToTypeCodeIdDisclosureTransaction INT = 132005
	
	DECLARE @nPolicyDocumentCreatedEventCodeID	INT = 153039
	DECLARE @nPolicyDocumentExpiryEventCodeID	INT = 153040
	DECLARE @nMapToTypeCodeIdPolicyDocument INT = 132001
	DECLARE @DocumentPurposeCodeIdEmailAttachment INT = 133001
	
	DECLARE @nPreClearanceRequestedEventCodeID INT = 153015
	DECLARE @nPreClearanceApprovedEventCodeID INT = 153016
	DECLARE @nPreClearanceRejectedEventCodeID INT = 153017
	DECLARE @nPreClearanceExpiryEventCodeID INT = 153018
	DECLARE @nPreClearanceTradeDetailsSubmittedEventCodeId INT = 153038
	DECLARE @nMapToTypeCodeIdPreClearance INT = 132004
	
	DECLARE @nMapToTypeCodeIdPreClearanceNonImplementing INT = 132015
	
	DECLARE @nTradingWindowCloseEventCodeID INT = 153025
	DECLARE @nTradingWindowOpenEventCodeID INT = 153026
	DECLARE @nMapToTypeCodeIdTradingWindow INT = 132009 /*This MapToType code (132009) is used for identifying "Trading Window Other" for defining Applicability for Trading Window. In case of notification generation and eventlogs for eventcodeid (153025, 153026), this MapToType is commly used to identify eventlogs for both Trading Window "other" and "financial results"*/
	DECLARE @nActiveUserCodeID	INT = 102001 /*Code for Active user status in table usr_UserInfo*/
	
	DECLARE @nPeriodEndDateEventCodeID INT = 153033
	DECLARE @nPeriodEndDisclosureEnteredEventCodeID INT = 153029
	DECLARE @nPeriodEndDisclosureTypeCodeID INT = 147003
	
	DECLARE @nTradingPolicyExpiryEventCodeID	INT = 153041
	DECLARE @nMapToTypeCodeIdTradingPolicy	INT = 132002
	
	DECLARE @nUserCreatedEventCodeID INT = 153001
	DECLARE @nEmployeeBecomeInsiderEventCodeID INT = 153003
	DECLARE @nInitialDisclosureDetailsEnterEventCodeID INT = 153007
	DECLARE @nInitialDisclosureDocumentUploadEventCodeID INT = 153008
	DECLARE @nInitialDisclosureSoftCopySubmitEventCodeID INT = 153009
	DECLARE @nInitialDisclosureHardCopySubmitEventCodeID INT = 153010
	DECLARE @nInitialDisclosureConfirmEventCodeID INT = 153035
	
	
	BEGIN TRY
		
		CREATE TABLE #tmpErrorMessages (ID INT IDENTITY(1,1), 
										RuleId INT NOT NULL,
										COUserInfoId INT,
										UserInfoId INT,
										SQLErrCode INT,
										SQLErrMessage VARCHAR(500)
										)
		
		CREATE TABLE #tmpCommRule (ID INT IDENTITY(1,1), 
									RuleId INT NOT NULL
								  )
		
		CREATE TABLE #tmpUserWithoutOffset(ID INT IDENTITY(1,1),
											RuleId	INT,
											ModeCodeId INT,
											UserInfoId	INT,
											TriggerEventLogId INT,
											TriggerEventCodeId INT, 
											TriggerEventDate DATETIME,
											PreClearDate DATETIME NULL,
											PreClearStatus NVARCHAR(100) NULL,
											PreClearExpiryDate DATETIME NULL,
											TradingWindowEventType NVARCHAR(100) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											TradingWindowId VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											TradingWindowFinancialYearValue VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											TradingWindowFinancialPeriodValue VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											TradingWindowCloseDate DATETIME NULL, /*Will get filled only for Trigger event code 153025*/
											TradingWindowOpenDate DATETIME NULL, /*Will get filled only for Trigger event code 153026*/
											LastSubmitDate DATETIME NULL, /*Will get filled in case of initail and period end disclosure event*/
											PreClearID VARCHAR(500), /*Will get filled for preclearance related events */
											PreClearRequestFor VARCHAR(50), /*Will get filled for preclearance related events */
											PreClearDEMATAccNo VARCHAR(50), /*Will get filled for preclearance related events */
											PreClearTransactionType VARCHAR(50), /*Will get filled for preclearance related events */
											PreClearSecurityType VARCHAR(50), /*Will get filled for preclearance related events */
											PreClearSecurityToBeTradeQty DECIMAL(15,2), /*Will get filled for preclearance related events */
											PreClearValueOfProposeTrade DECIMAL(20,2), /*Will get filled for preclearance related events */
											PeriodEndDaysRemain INT, /*will get filled only for trigger event code - period end date - 153033 */
											NotifyUserFlag	BIT DEFAULT 1,
											CompanyId INT
											)
		
		/*Table to store insiders for whom the policy document related trigger event has occured for sending notification about policy created*/
		CREATE TABLE #tmpUserPolicyDocumentNotify(	ID INT IDENTITY(1,1),
													RuleId	INT,
													ModeCodeId INT,
													UserInfoId	INT,
													TriggerEventLogId INT,
													TriggerEventCodeId INT, 
													TriggerMapToTypeCodeId INT, 
													TriggerMapToId INT,
													TriggerEventDate DATETIME,
													NotifyUserFlag	BIT DEFAULT 1
												)
									
		-----Start : Tables used for CO rule processing-----
		CREATE TABLE #tmpInsiderWithoutOffset( ID INT IDENTITY(1,1),
												RuleId INT,
												ModeCodeId INT,
												UserInfoId	INT,
												TriggerEventLogId INT,
												TriggerEventCodeId INT,
												TriggerMapToTypeCodeId INT, 
												TriggerMapToId INT, 
												TriggerEventDate DATETIME,
												)
												
		CREATE TABLE #tmpCOUserToNotify( ID INT IDENTITY(1,1),
										 RuleId	INT,
										 ModeCodeId INT,
										 COUserInfoId INT,
										 NotifyUserFlag	BIT DEFAULT 1
										)
										
		CREATE TABLE #tmpCOUserToNotifyEventBased( ID INT IDENTITY(1,1),
												   RuleId	INT,
												   ModeCodeId INT,
												   COUserInfoId INT,
												   UserInfoId INT,
												   TriggerEventLogId INT,
												   TriggerMapToTypeCodeId INT, 
												   TriggerMapToId INT,
												   NotifyUserFlag BIT DEFAULT 1
												 )
												 
		CREATE TABLE #tmpCOUserWithoutOffset(ID INT IDENTITY(1,1),
											 RuleId	INT,
											 ModeCodeId INT,
											 CoUserInfoId	INT,
											 TriggerEventLogId INT,
											 TriggerEventCodeId INT, 
											 TriggerEventDate DATETIME,
											 TriggerMapToTypeCodeId INT, 
											 TriggerMapToId INT,
	 										 TradingWindowEventType NVARCHAR(100) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											 TradingWindowId VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											 TradingWindowFinancialYearValue VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											 TradingWindowFinancialPeriodValue VARCHAR(50) NULL, /*Will get filled only for Trigger event code 153025, 153026*/
											 TradingWindowCloseDate DATETIME NULL, /*Will get filled only for Trigger event code 153025*/
											 TradingWindowOpenDate DATETIME NULL, /*Will get filled only for Trigger event code 153026*/
											 NotifyUserFlag	BIT DEFAULT 1,
											 PreClearDate DATETIME NULL,
											 PreClearStatus NVARCHAR(100) NULL,
											 PreClearExpiryDate DATETIME NULL,
											 PreClearID VARCHAR(500), /*Will get filled for preclearance related events */
											 PreClearRequestFor VARCHAR(50), /*Will get filled for preclearance related events */
											 PreClearDEMATAccNo VARCHAR(50), /*Will get filled for preclearance related events */
											 PreClearTransactionType VARCHAR(50), /*Will get filled for preclearance related events */
											 PreClearSecurityType VARCHAR(50), /*Will get filled for preclearance related events */
											 PreClearSecurityToBeTradeQty DECIMAL(15,2), /*Will get filled for preclearance related events */
											 PreClearValueOfProposeTrade DECIMAL(20,2), /*Will get filled for preclearance related events */
											 PeriodEndDaysRemain INT, /*will get filled only for trigger event code - period end date - 153033 */
											 CompanyId INT
											)									
		
		-----End : Tables used for CO rule processing----- 
		
		--Get all Active Rules, both Auto and Manual
		INSERT INTO #tmpCommRule
		SELECT RuleId FROM cmu_CommunicationRuleMaster WHERE RuleStatusCodeId = 160001 -- Fetch all Active rules only for processing 
		--AND RuleId in (9,12,17,19,24,39) -- Policy doc expiry / TP expiry / Pre-clearance expiry.
		--AND RuleId in (2)
		ORDER BY RuleId

		--Fetch the system startup URL to be sent in welcome user email notification contents
		SELECT @sAppURLCodeValue = CodeName from com_Code where CodeID = @nAppURLCodeId

		--SELECT * FROM #tmpCommRule
		SELECT @nRulesCnt = COUNT(ID) FROM #tmpCommRule
		--print @nRulesCnt
		
		WHILE(@nCounter < @nRulesCnt)
		BEGIN
			BEGIN TRY
			
				SELECT @nCounter = @nCounter + 1
				
				--Fetch the details of the Automatic Rule
				SELECT @nRuleId=RuleId , @sRuleTriggerEventCodeIds=TriggerEventCodeId, @sRuleOffsetEventCodeIds=OffsetEventCodeId, @sRuleForCodeIds=RuleForCodeId, @nRuleCategoryCodeId = RuleCategoryCodeId, @nRuleEventsApplyToCodeId = EventsApplyToCodeId
				FROM cmu_CommunicationRuleMaster 
				WHERE RuleId = (SELECT RuleId FROM #tmpCommRule WHERE ID = @nCounter)
				
				print ' RuleId = ' + cast(@nRuleId AS VARCHAR) + ' trigger events = ' + ISNULL(@sRuleTriggerEventCodeIds,'NULL') + ' offset events = ' + ISNULL(@sRuleOffsetEventCodeIds,'NULL') + ' Ruleforcodeid= ' + ISNULL(@sRuleForCodeIds,'NULL') + ' EventsApplyToCode= ' + CAST(@nRuleEventsApplyToCodeId AS VARCHAR(20))
				
				--Initialize the trigger and offset MaptoTypeCodeIds
				SELECT @nTriggerMapToType = 0, @nOffSetMapToType = 0
				
				---------------------Start - Generate SQL Error----------------------
				--IF(@nRuleId = 1)
				--BEGIN
				--	print 'RULE WITH ERROR:' + CAST(@nRuleId AS VARCHAR(10))
				--	INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId, EventLogId, UserId, UserContactInfo, Subject, Contents, Signature, CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				--	VALUES(NULL,0,0,0,0,'ashashree@S-C.com','test generate err-subj','test generate err-contents', 'test generate err-signt','test err generation-comm from' ,1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())
				--END
				
				--SELECT @sRuleTriggerEventCodeIds = NULL
				--SELECT @sRuleOffsetEventCodeIds = NULL
				---------------------End - Generate SQL Error----------------------
				
				
				--Process user notification list for Rule defined for Insider users		
				IF(CHARINDEX(CAST(@nRuleForInsiderCodeId AS VARCHAR), @sRuleForCodeIds) > 0)
				BEGIN
					print ' position for nRuleForInsiderCodeId= ' + CAST(CHARINDEX(CAST(@nRuleForInsiderCodeId AS VARCHAR), @sRuleForCodeIds) AS VARCHAR) + ' PROCESS RULE FOR INSIDER USER.... '
					
					IF(@nRuleCategoryCodeId = @nRuleCategoryCodeIdAuto)
					BEGIN
						IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdInsider)--When the Rule is defined for Insider users (defined within applicability of rule) and when the trigger/offset event-logs are to be checked against same Insider users
						BEGIN
							/*--------------------------------Start - Process Rule for Insider, where events are to be checked for Insider, of category - Auto-----------------------------------*/
							--Rule has both TriggerEventCodeId and OffsetEventCodeId specified 
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND @sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '')
							BEGIN
								print 'Rule has both TriggerEventCodeId and OffsetEventCodeId specified'
								--Select the MapToType corresponding to Trigger events list
								SELECT DISTINCT @nTriggerMapToType = ISNULL(MapToTypeCodeId, @nMapToTypeCodeIdUser) 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId <> @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleTriggerEventCodeIds))
								
								--Select the MapToType corresponding to Offset events list
								SELECT DISTINCT @nOffSetMapToType = MapToTypeCodeId 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId <> @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds))

								--SELECT @nTriggerMapToType, @nOffSetMapToType
								
								--Check for trigger and offset events to be Period End Date(153033) and Period End Disclosure details entered(153029) respectively
								IF((CHARINDEX(CAST(@nPeriodEndDateEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) AND 
									(CHARINDEX(CAST(@nPeriodEndDisclosureEnteredEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0))
								BEGIN
									SELECT * INTO #TEMPTabl1 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split('' + @sRuleOffsetEventCodeIds + '')) ) AND EventDate <= CONVERT(date, dbo.uf_com_GetServerDate())
									
									SELECT @sSQLInsertToTempTable = ''
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
									'INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, PeriodEndDaysRemain, LastSubmitDate) 
									 SELECT UsersWithTriggerEvent.RuleId, UsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate
									 , PeriodEndDaysRemain, LastSubmitDate
									 --, EVLOffsetEvents.UserInfoId AS OffsetEventUserId, EVLOffsetEvents.EventCodeId AS OffsetEventCodeId, TM.TransactionMasterId
									 FROM
									 (	
											--Select users for whom the trigger events specified in Rule have occurred
											SELECT CRM.RuleId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
											, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
											, TP.DiscloPeriodEndToCOByInsdrLimit AS PeriodEndDaysRemain
											, CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(EVLTriggerEvents.EventDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, 116001)) AS LastSubmitDate
											FROM cmu_CommunicationRuleMaster CRM
											INNER JOIN 
											(
												--Get the eventlog details for most recently occurred trigger event per user
												SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
												FROM
												(
													--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
													SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId , MapToTypeCodeId, EVLTriggerEvents1.MapToId, MAX(EventDate) AS EventDate
													FROM cmu_CommunicationRuleMaster CRM
													INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(''' + @sRuleTriggerEventCodeIds + ''')) ) AND CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20))
													SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
													' INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND EVLTriggerEvents1.UserInfoId = CRForUser.UserInfoId AND EVLTriggerEvents1.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdUser AS VARCHAR(20)) + ' AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20))
													SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
													' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
												) T
												INNER JOIN eve_EventLog EVE 
												ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate  
											) EVLTriggerEvents ON (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) AND CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + '
											INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
											LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = EVLTriggerEvents.UserInfoId -- Get personalized modes for rule 
											INNER JOIN rul_TradingPolicy TP ON EVLTriggerEvents.MapToId = TP.TradingPolicyId
									 ) UsersWithTriggerEvent
									 LEFT JOIN tra_TransactionMaster TM 
									 ON TM.UserInfoId = UsersWithTriggerEvent.TriggerEventUserId AND TM.DisclosureTypeCodeId = ' + CAST(@nPeriodEndDisclosureTypeCodeID AS VARCHAR(20)) + ' AND TM.PeriodEndDate = UsersWithTriggerEvent.TriggerEventDate
									 LEFT JOIN #TEMPTabl1 EVLOffsetEvents ON TriggerEventUserId = EVLOffsetEvents.UserInfoId AND TM.TransactionMasterId = EVLOffsetEvents.MapToId AND EVLOffsetEvents.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdDisclosureTransaction AS VARCHAR(20))
									
									 IF(@nTriggerMapToType = @nOffSetMapToType)	
									 BEGIN
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND TriggerMapToType = EVLOffsetEvents.MapToTypeCodeId AND TriggerMapToId = EVLOffsetEvents.MapToId ' 
									 END
									
									 SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' WHERE EVLOffsetEvents.UserInfoId IS NULL --All those users for whom trigger event(s) has occurred but offset event(s) has not occurred for the latest period-end-date under consideration '
									EXEC(@sSQLInsertToTempTable)
									
									DROP TABLE #TEMPTabl1
								END
								ELSE /*Handle condition when both trigger and offset event(s) are specified and they are events other than Period End Date(153033) and Period End Disclosure details entered(153029)*/
								BEGIN
									/*Handle condition when both trigger and offset event(s) are specified and they are events other than Period End Date(153033) and Period End Disclosure details entered(153029)*/
									--Store users who have applicable rule, have trigger event logged in eventlog but do not have corresponding offset event logged in eventlog
									SELECT * INTO #Temptabl12 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split('' + @sRuleOffsetEventCodeIds + '')) ) AND EventDate <= dbo.uf_com_GetServerDate() 
									
									SELECT @sSQLInsertToTempTable = ''
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
									'INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, PreClearDate, PreClearStatus, PreClearExpiryDate, LastSubmitDate, 
																		PreClearID, PreClearRequestFor, PreClearDEMATAccNo, PreClearTransactionType, PreClearSecurityType, PreClearSecurityToBeTradeQty, PreClearValueOfProposeTrade,CompanyName) 
									 SELECT UsersWithTriggerEvent.RuleId, UsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, PreClearDate, PreClearStatus, PreClearExpiryDate, DiscLastSubmitDate, 
											PreClearID, PreClearRequestFor, PreClearDEMATAccNo, PreClearTransactionType, PreClearSecurityType, PreClearSecurityToBeTradeQty, PreClearValueOfProposeTrade, CompanyID
										FROM
										(
											--Select users for whom the trigger events specified in Rule have occurred
											SELECT CRM.RuleId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
											,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
											, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EVLTriggerEvents.EventCodeId AS TriggerEventCodeId, EVLTriggerEvents.EventLogId AS TriggerEventLogId, EVLTriggerEvents.EventDate AS TriggerEventDate, EVLTriggerEvents.MapToTypeCodeId AS TriggerMapToType, EVLTriggerEvents.MapToId AS TriggerMapToId
											'
											--If Communication Rule being processed is for PreClearance Expiry Reminder notification then, add the PreClearance Expiry Date to #tmpUserWithoutOffset.PreClearExpiryDate 
											IF( (
													(CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
												) AND
												(
													(CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) 
												)
											  )
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,PCLR.CreatedOn AS PreClearDate '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,CCPreClearStatus.CodeName AS PreClearStatus '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,EL_PCLRExpiry.EventDate AS PreClearExpiryDate '
												
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , ''PCL'' + CAST(PCLR.PreclearanceRequestId AS VARCHAR(50)) AS PreClearID '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearRquestFor.CodeName AS PreClearRequestFor '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR_Dmat.DEMATAccountNumber AS PreClearDEMATAccNo '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearTranType.CodeName AS PreClearTransactionType '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearSecuType.CodeName AS PreClearSecurityType '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedQty AS PreClearSecurityToBeTradeQty '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedValue AS PreClearValueOfProposeTrade '
												
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.CompanyId AS CompanyID '
											END
											ELSE
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,PCLR.CreatedOn AS PreClearDate '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,CCPreClearStatus.CodeName AS PreClearStatus '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,EL_PCLRExpiry.EventDate AS PreClearExpiryDate '
												
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , ''PCL'' + CAST(PCLR.PreclearanceRequestId AS VARCHAR(50)) AS PreClearID '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearRquestFor.CodeName AS PreClearRequestFor '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR_Dmat.DEMATAccountNumber AS PreClearDEMATAccNo '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearTranType.CodeName AS PreClearTransactionType '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearSecuType.CodeName AS PreClearSecurityType '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedQty AS PreClearSecurityToBeTradeQty '
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedValue AS PreClearValueOfProposeTrade '
												
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.CompanyId AS CompanyID '

											END
											
											-- if communication rule being processed for initial disclosure then add last date of submission of initial disclosure
											IF( (
													(CHARINDEX(CAST(@nUserCreatedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureDetailsEnterEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureDocumentUploadEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureSoftCopySubmitEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureConfirmEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
												) AND 
												(
													(CHARINDEX(CAST(@nInitialDisclosureDetailsEnterEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureDocumentUploadEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR 
													(CHARINDEX(CAST(@nInitialDisclosureSoftCopySubmitEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureHardCopySubmitEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureConfirmEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) 
												)
											  )
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + '
												, CASE 
													WHEN UI.DateOfBecomingInsider IS NOT NULL THEN
														CASE 
															WHEN TM.TransactionMasterId IS NOT NULL THEN
																CASE 
																	WHEN UI.DateOfBecomingInsider <= TM_TP.DiscloInitDateLimit THEN TM_TP.DiscloInitDateLimit
																	ELSE DATEADD(DAY, TM_TP.DiscloInitLimit, UI.DateOfBecomingInsider)
																END 
															WHEN TM.TransactionMasterId IS NULL AND ATP.MapToId IS NOT NULL THEN 
																CASE 
																	WHEN UI.DateOfBecomingInsider <= ATP_TP.DiscloInitDateLimit THEN ATP_TP.DiscloInitDateLimit
																	ELSE DATEADD(DAY, ATP_TP.DiscloInitLimit, UI.DateOfBecomingInsider)
																END 
															ELSE NULL
														END
													WHEN UI.DateOfJoining IS NOT NULL THEN
														CASE
															WHEN TM.TransactionMasterId IS NOT NULL THEN
																CASE 
																	WHEN UI.DateOfJoining <= TM_TP.DiscloInitDateLimit THEN TM_TP.DiscloInitDateLimit
																	ELSE DATEADD(DAY, TM_TP.DiscloInitLimit, UI.DateOfJoining)
																END 
															WHEN TM.TransactionMasterId IS NULL AND ATP.MapToId IS NOT NULL THEN 
																CASE 
																	WHEN UI.DateOfJoining <= ATP_TP.DiscloInitDateLimit THEN ATP_TP.DiscloInitDateLimit
																	ELSE DATEADD(DAY, ATP_TP.DiscloInitLimit, UI.DateOfJoining)
																END 
															ELSE NULL
														END
													ELSE NULL
												END as DiscLastSubmitDate '
											END
											ELSE
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , NULL AS DiscLastSubmitDate '	
											END
											
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' FROM cmu_CommunicationRuleMaster CRM
											INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId <> ' 
											+ CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) + ' ' +
											' INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
											LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
											ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
											INNER JOIN ' 
											
											SELECT @sMaxTriggerEventTableQuery = '( '
											SELECT @sMaxTriggerEventTableQuery = @sMaxTriggerEventTableQuery  + 
												'
												--Get the eventlog details for most recently occurred trigger event per user
												SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
												FROM
												(
													--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
													SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
													, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
													FROM cmu_CommunicationRuleMaster CRM
													INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(''' + @sRuleTriggerEventCodeIds + ''')) )
													INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
													ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) + 
													' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + 
													' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
												) T
												INNER JOIN eve_EventLog EVE 
												ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate  '
											
											SELECT @sMaxTriggerEventTableQuery = @sMaxTriggerEventTableQuery  + ') EVLTriggerEvents '
											
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + @sMaxTriggerEventTableQuery
											 
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ON CRForUser.UserInfoId = EVLTriggerEvents.UserInfoId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) ' 
											
											IF( (
													(CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
												) AND
												(
													(CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) 
												)
											  )
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
												' INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR 
												  ON EVLTriggerEvents.UserInfoId = PCLR.UserInfoId AND EVLTriggerEvents.MapToId = PCLR.PreclearanceRequestId AND EVLTriggerEvents.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) +
												' INNER JOIN com_Code CCPreClearStatus ON PCLR.PreclearanceStatusCodeId = CCPreClearStatus.CodeId '	+ 
												' INNER JOIN com_Code CCPreClearRquestFor ON PCLR.PreclearanceRequestForCodeId = CCPreClearRquestFor.CodeId ' + -- requested for
												' INNER JOIN com_Code CCPreClearTranType ON PCLR.TransactionTypeCodeId = CCPreClearTranType.CodeId ' + -- transcation type
												' INNER JOIN com_Code CCPreClearSecuType ON PCLR.SecurityTypeCodeId = CCPreClearSecuType.CodeId ' + -- security type
												' INNER JOIN usr_DMATDetails PCLR_Dmat ON PCLR.DMATDetailsID = PCLR_Dmat.DMATDetailsID ' + -- pre-clearance dmat account
												
												' LEFT JOIN eve_EventLog EL_PCLRExpiry ON EL_PCLRExpiry.UserInfoId = EVLTriggerEvents.UserInfoId AND EL_PCLRExpiry.EventCodeId = ' + CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR(20)) + ' AND EL_PCLRExpiry.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) + ' AND EL_PCLRExpiry.MapToId = EVLTriggerEvents.MapToId '
											END
											ELSE
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
												' INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR 
												  ON EVLTriggerEvents.UserInfoId = PCLR.UserInfoId AND EVLTriggerEvents.MapToId = PCLR.PreclearanceRequestId  ' +
												' INNER JOIN com_Code CCPreClearStatus ON PCLR.PreclearanceStatusCodeId = CCPreClearStatus.CodeId '	+ 
												' INNER JOIN com_Code CCPreClearRquestFor ON PCLR.PreclearanceRequestForCodeId = CCPreClearRquestFor.CodeId ' + -- requested for
												' INNER JOIN com_Code CCPreClearTranType ON PCLR.TransactionTypeCodeId = CCPreClearTranType.CodeId ' + -- transcation type
												' INNER JOIN com_Code CCPreClearSecuType ON PCLR.SecurityTypeCodeId = CCPreClearSecuType.CodeId ' + -- security type
												' INNER JOIN usr_DMATDetails PCLR_Dmat ON PCLR.DMATDetailsID = PCLR_Dmat.DMATDetailsID ' + -- pre-clearance dmat account
												' LEFT JOIN eve_EventLog EL_PCLRExpiry ON EL_PCLRExpiry.UserInfoId = EVLTriggerEvents.UserInfoId  AND EL_PCLRExpiry.EventCodeId = ' + CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR(20)) + '  AND EL_PCLRExpiry.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) + ' AND EL_PCLRExpiry.MapToId = EVLTriggerEvents.MapToId '
											END
	
											-- add condition to get intial disclosure last submission date
											IF( (
													(CHARINDEX(CAST(@nUserCreatedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureDetailsEnterEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureDocumentUploadEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureSoftCopySubmitEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureConfirmEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
												) AND 
												(
													(CHARINDEX(CAST(@nInitialDisclosureDetailsEnterEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureDocumentUploadEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR 
													(CHARINDEX(CAST(@nInitialDisclosureSoftCopySubmitEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR
													(CHARINDEX(CAST(@nInitialDisclosureHardCopySubmitEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) OR (CHARINDEX(CAST(@nInitialDisclosureConfirmEventCodeID AS VARCHAR),@sRuleOffsetEventCodeIds) > 0) 
												)
											  )
											BEGIN
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
												' LEFT JOIN tra_TransactionMaster TM ON EVLTriggerEvents.UserInfoId = TM.UserInfoId and TM.DisclosureTypeCodeId = 147001
												  LEFT JOIN rul_TradingPolicy TM_TP ON TM.TransactionMasterId IS NOT NULL AND TM.TradingPolicyId = TM_TP.TradingPolicyId
												  LEFT JOIN vw_ApplicableTradingPolicyForUser ATP ON EVLTriggerEvents.UserInfoId = ATP.UserInfoId
												  LEFT JOIN rul_TradingPolicy ATP_TP ON ATP.MapToId IS NOT NULL AND ATP.MapToId = ATP_TP.TradingPolicyId
												  LEFT JOIN usr_UserInfo UI ON EVLTriggerEvents.UserInfoId = UI.UserInfoId '
											END
											
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) +
										' ) UsersWithTriggerEvent LEFT JOIN #Temptabl12 EVLOffsetEvents ON TriggerEventUserId = EVLOffsetEvents.UserInfoId '
									IF(@nTriggerMapToType = @nOffSetMapToType)	
									BEGIN
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND TriggerMapToType = EVLOffsetEvents.MapToTypeCodeId AND TriggerMapToId = EVLOffsetEvents.MapToId ' 
									END
									
									
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' AND EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleOffsetEventCodeIds + ''' ))
										WHERE EVLOffsetEvents.UserInfoId IS NULL --All those users for whom trigger event(s) has occurred but offset event(s) has not occurred '
									
									--print @sMaxTriggerEventTableQuery
									EXEC(@sSQLInsertToTempTable)
									
									DROP TABLE #Temptabl12 
								END
							END
							ELSE
							--Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND (@sRuleOffsetEventCodeIds IS NULL OR @sRuleOffsetEventCodeIds = '') )
							BEGIN 
								print 'Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified'

								IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 ) OR (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 ) )
								BEGIN
									print 'Rule has TriggerEventCodeId specified for Trading Window Close/Open events'
									PRINT 'PROCESS INSIDER RULE FOR TRADING WINDOW CLOSE/OPEN.....'
									/*If the rule has TriggerEvent defined as : (153025) 'Trading Window Close' or (153026) 'Trading Window Open' then, there are corresponding eventlog entries done to eventlog table for the window open/close dates for both insiders and CO users
									For Insider users, the entries are done as 'All Insiders' for 'Trading Window Financial Results' and 'Applicability based Insiders' for 'Trading Window Other' 
									For CO users, the entry is done for all CO users for both 'Trading Window Financial Results' and 'Trading Window Other'.
									Hence, when generating the notification queue entries, make use of the eventlog-table + user-table + trading-window-table, since eventlog-table already has events defined for valid users based on whether Trading Window is 'Other'/'Financial Results' 
									When generating notifiactions into notification queue, generate them as per applicability defined for both communication-rule and trading-window. 
								    Applicability of communication rule handles both CO user and Insiders. Applicability of trading window, handles only Insider users. Trading Window Other has associated applicability while Trading Window Financial Results does not have its own applicability but applies to all Insider users.
								    Events 153025/153026 get logged into event-log table based on applicability of Trading Window (Trading Window Other) - using stored procedure st_cmu_Job_GenerateBulkEvents_TradingWindow.
								    So, when generating notification queue data below, applicability only of Communication Rule is considered (INNER JOIN vw_ApplicableCommunicationRuleForUser) to get intersection of users specified within trading window applicability and communication rule applicability.
									*/
									SELECT @sSQLInsertToTempTable = ''
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
									'INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TradingWindowEventType, TradingWindowId, TradingWindowFinancialYearValue, TradingWindowFinancialPeriodValue, TradingWindowCloseDate, TradingWindowOpenDate)
									SELECT UsersWithTriggerEvent.RuleId, UsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TradingWindowEventType, TradingWindowId, TradingWindowFinancialYearValue, TradingWindowFinancialPeriodValue, TradingWindowCloseDate, TradingWindowOpenDate
									FROM
									(
										--Select users for whom the trigger events specified in Rule have occurred
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										,EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId 
										,EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
										, CCTWEventType.CodeName AS TradingWindowEventType	
										, TradingWindowId AS TradingWindowId 
										, ISNULL(CCTWFinancialYear.CodeName,'''') AS TradingWindowFinancialYearValue
										, ISNULL(CCTWFinancialPeriod.CodeName,'''') AS TradingWindowFinancialPeriodValue '
										IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowCloseDate AS TradingWindowCloseDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowOpenDate AS TradingWindowOpenDate '
										END
										ELSE IF( (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowCloseDate AS TradingWindowCloseDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowOpenDate AS TradingWindowOpenDate '
										END
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN 
										(
											--Get the eventlog details for most recently occurred trigger event per user
											SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
											FROM
											(
												--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate, for future 30 days
												SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
												, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
												FROM cmu_CommunicationRuleMaster CRM
												--Added 5 days prior to current date as DATEADD(DAY, -5, dbo.uf_com_GetServerDate()) so that notification can be sent N days before as well as one day after window open date 
												INNER JOIN eve_EventLog EVLTriggerEvents1 ON EVLTriggerEvents1.EventDate >= DATEADD(DAY, -5, dbo.uf_com_GetServerDate()) AND EVLTriggerEvents1.EventDate <= (DATEADD(DAY, 30, dbo.uf_com_GetServerDate())) AND (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) )
												INNER JOIN usr_UserInfo UI ON UI.UserInfoId = EVLTriggerEvents1.UserInfoId AND UI.StatusCodeId = ' + CAST(@nActiveUserCodeID AS VARCHAR(20)) + ' AND UI.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20))  +
												' INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON UI.UserInfoId = CRForUser.UserInfoId AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) +' AND CRForUser.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) 
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
												' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + 
												' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
											) T
											INNER JOIN eve_EventLog EVE 
											ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate
										)EVLTriggerEvents 
										ON CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + ' AND CRM.RuleId = EVLTriggerEvents.RuleId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) '
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = EVLTriggerEvents.UserInfoId -- Get personalized modes for rule 
										INNER JOIN rul_TradingWindowEvent TWE ON EVLTriggerEvents.MapToId = TWE.TradingWindowEventId AND EVLTriggerEvents.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdTradingWindow AS VARCHAR(20)) + ' '
										IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND EVLTriggerEvents.EventDate = TWE.WindowCloseDate '
										END
										ELSE IF( (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND EVLTriggerEvents.EventDate = TWE.WindowOpenDate '
										END 
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' INNER JOIN com_Code CCTWEventType ON TWE.EventTypeCodeId = CCTWEventType.CodeId 
										 LEFT JOIN com_Code CCTWFinancialYear ON TWE.FinancialYearCodeId = CCTWFinancialYear.CodeId 
										 LEFT JOIN com_Code CCTWFinancialPeriod ON TWE.FinancialPeriodCodeId = CCTWFinancialPeriod.CodeId '
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) +
									' )UsersWithTriggerEvent '

									EXEC(@sSQLInsertToTempTable)
									
								END
								ELSE IF(CHARINDEX(CAST(@nPolicyDocumentCreatedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 )
								BEGIN
									print 'Rule has TriggerEventCodeId specified for Policy Document Created events'
									/*If the rule has TriggerEvent defined as : (153039) 'Policy Document Created' then, for all users who have the ongoing policy documents applicable based on applicability of each ongoing Policy Documents,
									first generate evenlog entries for all such users for eventcode (153039) as per the latest Applicability for all ongoing Policy Documents. Generate the event log entries only if they are not already generated for a user-for a policy document.
									After eventlog entries are generated for users who have ongoing policy applicable then use these eventlog entries as the TriggerEvents for each of the users and send Notification if not already sent*/
									--Store users to separate temp table because these could be users to whom email attachment of policy document if to be sent, per policydocumentId (MapToId)
									INSERT INTO #tmpUserPolicyDocumentNotify(RuleId, ModeCodeId, UserInfoId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToTypeCodeId, TriggerMapToId)
									SELECT UsersWithTriggerEvent.RuleId, UsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToType, TriggerMapToId
									FROM
									(
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EVLTriggerEvents.EventCodeId AS TriggerEventCodeId
										, EVLTriggerEvents.EventLogId AS TriggerEventLogId, EVLTriggerEvents.EventDate AS TriggerEventDate
										, EVLTriggerEvents.MapToTypeCodeId AS TriggerMapToType, EVLTriggerEvents.MapToId AS TriggerMapToId
										FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN vw_ApplicablePolicyDocumentForUser_ForNotification UserPD ON CRM.RuleId = @nRuleId
										INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON UserPD.UserInfoId = CRForUser.UserInfoId AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser AND CRForUser.RuleId = @nRuleId 
										INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = UserPD.UserInfoId -- Get personalized modes for rule
										INNER JOIN 
										(
											SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
											FROM
											(
												SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
												, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId, MAX(EVLTriggerEvents1.EventDate) AS EventDate
												FROM cmu_CommunicationRuleMaster CRM
												INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds)) )
												INNER JOIN vw_ApplicablePolicyDocumentForUser_ForNotification UserPD
												ON EVLTriggerEvents1.UserInfoId = UserPD.UserInfoId AND EVLTriggerEvents1.MapToId = UserPD.MapToId AND EVLTriggerEvents1.MapToTypeCodeId = @nMapToTypeCodeIdPolicyDocument
												INNER JOIN rul_PolicyDocument PD ON PD.PolicyDocumentId = UserPD.MapToId AND PD.PolicyDocumentId = EVLTriggerEvents1.MapToId AND PD.SendEmailUpdateFlag = 1 /* Get only those policy documents to send notification for which SendEmailUpdateFlag = 1 */
												WHERE CRM.RuleId = @nRuleId
												GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
											) T
											INNER JOIN eve_EventLog EVE 
											ON T.UserInfoId = EVE.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND EVE.MapToTypeCodeId = @nMapToTypeCodeIdPolicyDocument AND T.MapToId = EVE.MapToId AND T.EventDate = EVE.EventDate 
										)EVLTriggerEvents 
										ON UserPD.UserInfoId = EVLTriggerEvents.UserInfoId AND UserPD.MapToId = EVLTriggerEvents.MapToId AND EVLTriggerEvents.MapToTypeCodeId = @nMapToTypeCodeIdPolicyDocument AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds )) )  
										WHERE CRM.RuleId = @nRuleId
									)UsersWithTriggerEvent
								END
								ELSE /*All other cases with Communication Rule having only Trigger Event, other than Rule for Trading Window Close/Open and Policy Document Created*/
								BEGIN
									print 'Rule has TriggerEventCodeId specified for other events'
									--Store users who have applicable rule, have trigger event and rule does not have any offset event defined to check for users without offset events
									SELECT @sSQLInsertToTempTable = ''
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
									'INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, PreClearDate, PreClearStatus, PreClearExpiryDate
																			, PreClearID, PreClearRequestFor, PreClearDEMATAccNo, PreClearTransactionType, PreClearSecurityType, PreClearSecurityToBeTradeQty, PreClearValueOfProposeTrade
																			, PeriodEndDaysRemain, LastSubmitDate, CompanyId)
									SELECT UsersWithTriggerEvent.RuleId, UsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, PreClearDate, PreClearStatus, PreClearExpiryDate
											, PreClearID, PreClearRequestFor, PreClearDEMATAccNo, PreClearTransactionType, PreClearSecurityType, PreClearSecurityToBeTradeQty, PreClearValueOfProposeTrade
											, PeriodEndDaysRemain, LastSubmitDate, CompanyId
									FROM
									(
										--Select users for whom the trigger events specified in Rule have occurred
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										,EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EVLTriggerEvents.EventCodeId AS TriggerEventCodeId, EVLTriggerEvents.EventLogId AS TriggerEventLogId 
										,EVLTriggerEvents.EventDate AS TriggerEventDate, EVLTriggerEvents.MapToTypeCodeId AS TriggerMapToType, EVLTriggerEvents.MapToId AS TriggerMapToId '
										
										IF( (CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
											(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
											(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
										  )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,PCLR.CreatedOn AS PreClearDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,CCPreClearStatus.CodeName AS PreClearStatus '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,EL_PCLRExpiry.EventDate AS PreClearExpiryDate '
												
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , ''PCL'' + CAST(PCLR.PreclearanceRequestId AS VARCHAR(50)) AS PreClearID '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearRquestFor.CodeName AS PreClearRequestFor '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR_Dmat.DEMATAccountNumber AS PreClearDEMATAccNo '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearTranType.CodeName AS PreClearTransactionType '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearSecuType.CodeName AS PreClearSecurityType '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedQty AS PreClearSecurityToBeTradeQty '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedValue AS PreClearValueOfProposeTrade '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.CompanyID AS CompanyId '
										END
										ELSE
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,PCLR.CreatedOn AS PreClearDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,CCPreClearStatus.CodeName AS PreClearStatus '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ,EL_PCLRExpiry.EventDate AS PreClearExpiryDate '
												
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , ''PCL'' + CAST(PCLR.PreclearanceRequestId AS VARCHAR(50)) AS PreClearID '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearRquestFor.CodeName AS PreClearRequestFor '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR_Dmat.DEMATAccountNumber AS PreClearDEMATAccNo '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearTranType.CodeName AS PreClearTransactionType '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CCPreClearSecuType.CodeName AS PreClearSecurityType '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedQty AS PreClearSecurityToBeTradeQty '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.SecuritiesToBeTradedValue AS PreClearValueOfProposeTrade '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , PCLR.CompanyID AS CompanyId '
										END
										
										IF (CHARINDEX(CAST(@nPeriodEndDateEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0)
										BEGIN 
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TP.DiscloPeriodEndToCOByInsdrLimit AS PeriodEndDaysRemain '	
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(EVLTriggerEvents.EventDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, 116001)) AS LastSubmitDate '
										END
										ELSE 
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , NULL AS PeriodEndDaysRemain '	
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , NULL AS LastSubmitDate '
										END
										
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) 
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
										INNER JOIN 
										(
												--Get the eventlog details for most recently occurred trigger event per user
												SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
												FROM
												(
													--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
													SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
													, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
													FROM cmu_CommunicationRuleMaster CRM
													INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) )
													INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
													ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20))  
													SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
													' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + 
													' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
												) T
												INNER JOIN eve_EventLog EVE 
												ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate
										)EVLTriggerEvents 
										ON CRForUser.UserInfoId = EVLTriggerEvents.UserInfoId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) '
										
										
										
										
										IF( (CHARINDEX(CAST(@nPreClearanceApprovedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceRejectedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
											(CHARINDEX(CAST(@nPreClearanceRequestedEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR (CHARINDEX(CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) OR
											(CHARINDEX(CAST(@nPreClearanceTradeDetailsSubmittedEventCodeId AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) 
										  )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR 
											  ON EVLTriggerEvents.UserInfoId = PCLR.UserInfoId AND EVLTriggerEvents.MapToId = PCLR.PreclearanceRequestId AND EVLTriggerEvents.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) +
											' INNER JOIN com_Code CCPreClearStatus ON PCLR.PreclearanceStatusCodeId = CCPreClearStatus.CodeId '	+ 
											' INNER JOIN com_Code CCPreClearRquestFor ON PCLR.PreclearanceRequestForCodeId = CCPreClearRquestFor.CodeId ' + -- requested for
											' INNER JOIN com_Code CCPreClearTranType ON PCLR.TransactionTypeCodeId = CCPreClearTranType.CodeId ' + -- transcation type
											' INNER JOIN com_Code CCPreClearSecuType ON PCLR.SecurityTypeCodeId = CCPreClearSecuType.CodeId ' + -- security type
											' INNER JOIN usr_DMATDetails PCLR_Dmat ON PCLR.DMATDetailsID = PCLR_Dmat.DMATDetailsID ' + -- pre-clearance dmat account
											' LEFT JOIN eve_EventLog EL_PCLRExpiry ON EL_PCLRExpiry.UserInfoId = EVLTriggerEvents.UserInfoId  AND EL_PCLRExpiry.EventCodeId = ' + CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR(20)) + '  AND EL_PCLRExpiry.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) + ' AND EL_PCLRExpiry.MapToId = EVLTriggerEvents.MapToId ' 
										END
										ELSE
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR 
											  ON EVLTriggerEvents.UserInfoId = PCLR.UserInfoId AND EVLTriggerEvents.MapToId = PCLR.PreclearanceRequestId  ' +
											' INNER JOIN com_Code CCPreClearStatus ON PCLR.PreclearanceStatusCodeId = CCPreClearStatus.CodeId '	+ 
											' INNER JOIN com_Code CCPreClearRquestFor ON PCLR.PreclearanceRequestForCodeId = CCPreClearRquestFor.CodeId ' + -- requested for
											' INNER JOIN com_Code CCPreClearTranType ON PCLR.TransactionTypeCodeId = CCPreClearTranType.CodeId ' + -- transcation type
											' INNER JOIN com_Code CCPreClearSecuType ON PCLR.SecurityTypeCodeId = CCPreClearSecuType.CodeId ' + -- security type
											' INNER JOIN usr_DMATDetails PCLR_Dmat ON PCLR.DMATDetailsID = PCLR_Dmat.DMATDetailsID ' + -- pre-clearance dmat account
											' LEFT JOIN eve_EventLog EL_PCLRExpiry ON EL_PCLRExpiry.UserInfoId = EVLTriggerEvents.UserInfoId  AND EL_PCLRExpiry.EventCodeId = ' + CAST(@nPreClearanceExpiryEventCodeID AS VARCHAR(20)) + '  AND EL_PCLRExpiry.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdPreClearanceNonImplementing AS VARCHAR(20)) + ' AND EL_PCLRExpiry.MapToId = EVLTriggerEvents.MapToId ' 
										END
										
										IF (CHARINDEX(CAST(@nPeriodEndDateEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0)
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' INNER JOIN rul_TradingPolicy TP ON EVLTriggerEvents.MapToId = TP.TradingPolicyId  '
										END
										
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) +
									' )UsersWithTriggerEvent '

									EXEC(@sSQLInsertToTempTable)
								END
							END
							ELSE
							--Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified
							IF( (@sRuleTriggerEventCodeIds IS NULL OR @sRuleTriggerEventCodeIds = '') AND (@sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '') )
							BEGIN
								print 'Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified'
								
								SELECT * INTO #TempTable7 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) ) AND EventDate <= dbo.uf_com_GetServerDate() 
								
								INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate)
								SELECT UsersWithoutOffsetEvent.RuleId, UsersWithoutOffsetEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate
								--, EVLOffsetEvents.UserInfoId AS OffsetEventUserId, EVLOffsetEvents.EventCodeId AS OffsetEventCodeId
								FROM
								(
									--Select users for whom the offset events specified in Rule have NOT occurred
									SELECT CRM.RuleId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
									, CRForUser.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
									FROM cmu_CommunicationRuleMaster CRM
									INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser
									INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
									LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
									ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
									LEFT JOIN #TempTable7 EVLOffsetEvents 
									ON CRForUser.UserInfoId = EVLOffsetEvents.UserInfoId AND (EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) )
									WHERE CRM.RuleId = @nRuleId
									AND EVLOffsetEvents.UserInfoId IS NULL --All those users for whom offset event(s) has not occurred
								)UsersWithoutOffsetEvent
								DROP TABLE #TempTable7
							END
							
							--SELECT @nRuleId AS ForRuleIdBeforeUpdate
							--SELECT * FROM #tmpUserWithoutOffset
							--SELECT * FROM #tmpUserPolicyDocumentNotify
							
							
							--Update NotifyUserFlag for users if notification is not to be sent, by default this flag will be 1 for all users for whom trigger event has occured and offset event has not occured
							UPDATE #tmpUserWithoutOffset
							SET NotifyUserFlag = 0
							--SELECT 
							--UsrWOOffset.UserInfoId, UsrWOOffset.ModeCodeId,
							--CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) AS CURR_DATE, 
							--CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AS TRIGGER_DATE,
							--(DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) AS DATE_DIFF,
							--FinalNotificationParams.WaitDaysAfterTriggerEvent,
							--DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS HOUR_DIFFERENCE,
							--FinalNotificationParams.* , UsrWOOffset.* 
							FROM 
							(
								SELECT CRM.RuleId, UserWOOffset.ModeCodeId, UserWOOffset.UserInfoId
								,CASE WHEN CRMMPersonal.ExecFrequencyCodeId IS NULL THEN CRMMGlobal.ExecFrequencyCodeId ELSE CRMMPersonal.ExecFrequencyCodeId END AS ExecFrequencyCodeId 
								,CASE WHEN CRMMPersonal.WaitDaysAfterTriggerEvent IS NULL THEN CRMMGlobal.WaitDaysAfterTriggerEvent ELSE CRMMPersonal.WaitDaysAfterTriggerEvent END AS WaitDaysAfterTriggerEvent
								,CASE WHEN CRMMPersonal.NotificationLimit IS NULL THEN CRMMGlobal.NotificationLimit ELSE CRMMPersonal.NotificationLimit END AS NotificationLimit 
								,NotificationSentCount, LastNotificationSentTS
								,UserWOOffset.TriggerEventLogId, UserWOOffset.TriggerEventDate, UserWOOffset.NotifyUserFlag
								FROM
								(	
									SELECT CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId AS UserWOOffsetModeCodeId, 
									UserWOOffset.TriggerEventLogId, COUNT(NQ.NotificationQueueId) AS NotificationSentCount /*,CRMM.ModeCodeId AS CRMMModeCodeId, NQ.RuleModeId, CRMM.RuleModeId*/ ,
									MAX(NQ.ModifiedOn) AS LastNotificationSentTS
									FROM #tmpUserWithoutOffset UserWOOffset 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = UserWOOffset.RuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId
									LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = UserWOOffset.UserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId = UserWOOffset.TriggerEventLogId
									GROUP BY CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId, UserWOOffset.TriggerEventLogId
								) UserWOOffsetNotifySentCount
								INNER JOIN #tmpUserWithoutOffset UserWOOffset 
								ON UserWOOffsetNotifySentCount.UserInfoId = UserWOOffset.UserInfoId AND UserWOOffsetNotifySentCount.UserWOOffsetModeCodeId = UserWOOffset.ModeCodeId AND UserWOOffsetNotifySentCount.RuleId = UserWOOffset.RuleId AND UserWOOffsetNotifySentCount.TriggerEventLogId = UserWOOffset.TriggerEventLogId
								INNER JOIN cmu_CommunicationRuleMaster CRM ON UserWOOffsetNotifySentCount.RuleId = CRM.RuleId AND CRM.RuleId = @nRuleId
								INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND UserWOOffset.RuleId = CRMMGlobal.RuleId AND UserWOOffset.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
								LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = UserWOOffsetNotifySentCount.UserInfoId -- Get personalized modes for rule
								WHERE CRM.RuleId = @nRuleId
							) FinalNotificationParams
							INNER JOIN #tmpUserWithoutOffset UsrWOOffset 
							ON FinalNotificationParams.UserInfoId = UsrWOOffset.UserInfoId AND UsrWOOffset.ModeCodeId = FinalNotificationParams.ModeCodeId 
							AND UsrWOOffset.RuleId = FinalNotificationParams.RuleId AND UsrWOOffset.TriggerEventLogId = FinalNotificationParams.TriggerEventLogId
							WHERE 1=1
							AND FinalNotificationParams.RuleId = @nRuleId
							AND (
									--When days' difference between TriggerEventDate and CurrentDate has not crossed WaitDaysAfterTriggerEvent, for the notification to be sent
									( 
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) < CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) OR --If current-date < trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent -N days before trigger-event-date)
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) = CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND FinalNotificationParams.WaitDaysAfterTriggerEvent > 0) OR --If current-date=trigger-event-date and waitdaysaftertrigger > 0 then DO NOT send notification, so update the NotifyUserFlag =0. If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then DO send notification. (cases (A)when notification is to be sent -N days before trigger-event-date until current-date approaches trigger-event-date and (B)when notification is to be sent N days after trigger-event-date)
										( (CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) > CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME)) AND
										  ( (FinalNotificationParams.WaitDaysAfterTriggerEvent < 0) OR --When current-date > trigger-date then DO NOT send notification in case when waitdaysaftertrigger indicate that event-date is post-dated and notification is to be sent from -N days before event-date and till event-date is reached. Notification should NOT be sent when current-date > event-date
											((FinalNotificationParams.WaitDaysAfterTriggerEvent >= 0) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) --If current-date > trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent N days after trigger-event-date)
										  )
										)
									) OR
									--When RuleModeNotification is Halted either at global level or at personal level
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
									--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
									(FinalNotificationParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
									--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1) OR
									--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
									--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
								)
							
							--print 'Update NotifyUserFlag for users if notification is not to be sent'	
						
							--Update NotifyUserFlag for users if notification for event 'policy document created' is to be sent. This flag is by default=1 for all users for whom the trigger event is logged in eventlog. When sending the notification, there may also be email attachment to send for this event notification.
							UPDATE #tmpUserPolicyDocumentNotify
							SET NotifyUserFlag = 0
							--SELECT 
							--UsrWOOffset.UserInfoId, UsrWOOffset.ModeCodeId,
							--CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) AS CURR_DATE, 
							--CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AS TRIGGER_DATE,
							--(DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) AS DATE_DIFF,
							--FinalNotificationParams.WaitDaysAfterTriggerEvent,
							--DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS HOUR_DIFFERENCE,
							--FinalNotificationParams.* , UsrWOOffset.* 
							FROM 
							(						
								SELECT CRM.RuleId, UserWOOffset.ModeCodeId, UserWOOffset.UserInfoId
								,CASE WHEN CRMMPersonal.ExecFrequencyCodeId IS NULL THEN CRMMGlobal.ExecFrequencyCodeId ELSE CRMMPersonal.ExecFrequencyCodeId END AS ExecFrequencyCodeId 
								,CASE WHEN CRMMPersonal.WaitDaysAfterTriggerEvent IS NULL THEN CRMMGlobal.WaitDaysAfterTriggerEvent ELSE CRMMPersonal.WaitDaysAfterTriggerEvent END AS WaitDaysAfterTriggerEvent
								,CASE WHEN CRMMPersonal.NotificationLimit IS NULL THEN CRMMGlobal.NotificationLimit ELSE CRMMPersonal.NotificationLimit END AS NotificationLimit 
								,NotificationSentCount, LastNotificationSentTS
								,UserWOOffset.TriggerEventLogId, UserWOOffset.TriggerEventDate, UserWOOffset.NotifyUserFlag
								FROM
								(
									SELECT CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId AS UserWOOffsetModeCodeId, 
									UserWOOffset.TriggerEventLogId, COUNT(NQ.NotificationQueueId) AS NotificationSentCount ,
									MAX(NQ.ModifiedOn) AS LastNotificationSentTS
									FROM #tmpUserPolicyDocumentNotify UserWOOffset 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = UserWOOffset.RuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId AND CRMM.RuleId = UserWOOffset.RuleId
									LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = UserWOOffset.UserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId = UserWOOffset.TriggerEventLogId AND NQ.ModeCodeId = UserWOOffset.ModeCodeId
									GROUP BY CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId, UserWOOffset.TriggerEventLogId
								) UserWOOffsetNotifySentCount
								INNER JOIN #tmpUserPolicyDocumentNotify UserWOOffset 
								ON UserWOOffsetNotifySentCount.UserInfoId = UserWOOffset.UserInfoId AND UserWOOffsetNotifySentCount.UserWOOffsetModeCodeId = UserWOOffset.ModeCodeId AND UserWOOffsetNotifySentCount.RuleId = UserWOOffset.RuleId AND UserWOOffsetNotifySentCount.TriggerEventLogId = UserWOOffset.TriggerEventLogId
								INNER JOIN cmu_CommunicationRuleMaster CRM ON UserWOOffsetNotifySentCount.RuleId = CRM.RuleId AND CRM.RuleId = @nRuleId
								INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND UserWOOffset.RuleId = CRMMGlobal.RuleId AND UserWOOffset.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
								LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = UserWOOffsetNotifySentCount.UserInfoId -- Get personalized modes for rule
								WHERE CRM.RuleId = @nRuleId
							) FinalNotificationParams
							INNER JOIN #tmpUserPolicyDocumentNotify UsrWOOffset 
							ON FinalNotificationParams.UserInfoId = UsrWOOffset.UserInfoId AND UsrWOOffset.ModeCodeId = FinalNotificationParams.ModeCodeId 
							AND FinalNotificationParams.TriggerEventLogId = UsrWOOffset.TriggerEventLogId AND FinalNotificationParams.RuleId = UsrWOOffset.RuleId
							WHERE 1=1
							AND FinalNotificationParams.RuleId = @nRuleId
							AND (
									--When days' difference between TriggerEventDate and CurrentDate has not crossed WaitDaysAfterTriggerEvent, for the notification to be sent
									( 
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) < CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) OR --If current-date < trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent -N days before trigger-event-date)
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) = CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND FinalNotificationParams.WaitDaysAfterTriggerEvent > 0) OR --If current-date=trigger-event-date and waitdaysaftertrigger > 0 then DO NOT send notification, so update the NotifyUserFlag =0. If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then DO send notification. (cases (A)when notification is to be sent -N days before trigger-event-date until current-date approaches trigger-event-date and (B)when notification is to be sent N days after trigger-event-date)
										( (CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) > CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME)) AND
										  ( (FinalNotificationParams.WaitDaysAfterTriggerEvent < 0) OR --When current-date > trigger-date then DO NOT send notification in case when waitdaysaftertrigger indicate that event-date is post-dated and notification is to be sent from -N days before event-date and till event-date is reached. Notification should NOT be sent when current-date > event-date
											((FinalNotificationParams.WaitDaysAfterTriggerEvent >= 0) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) --If current-date > trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent N days after trigger-event-date)
										  )
										)
									) OR
									--When RuleModeNotification is Halted either at global level or at personal level
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
									--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
									(FinalNotificationParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
									--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1) OR
									--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
									--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
								)
							
							--print 'Update NotifyUserFlag for users if notification for event "policy document created" is to be sent'
						
							--SELECT @nRuleId AS ForRuleIdAfterUpdate	
							--SELECT * FROM #tmpUserWithoutOffset
							--SELECT * FROM #tmpUserPolicyDocumentNotify
							/*--------------------------------End - Process Rule for Insider, where events are to be checked for Insider, of category - Auto-----------------------------------*/
						END /*IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdInsider)*/
						ELSE IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdCO)--When the Rule is defined for Insider users (defined within applicability of rule) and when the trigger/offset event-logs are to be checked against CO users (defined within applicability of rule)
						BEGIN
							/*--------------------------------Start - Process Rule for Insider, where events are to be checked for CO, of category - Auto-----------------------------------*/
							print 'THIS CASE IS NOT CONSIDERED TO OCCUR - Process Rule for Insider, where events are to be checked for CO, of category - Auto'
							/*--------------------------------End - Process Rule for Insider, where events are to be checked for CO, of category - Auto-----------------------------------*/
						END
					END
					ELSE 
					IF(@nRuleCategoryCodeId = @nRuleCategoryCodeIdManual)
					BEGIN
						/*--------------------------------Start - Process Rule for Insider of category - Manual-----------------------------------*/
						print 'Process manual rule for insider here'
						
						--Store users for whom the current manual rule is applicable
						INSERT INTO #tmpUserWithoutOffset (RuleId, ModeCodeId, UserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate)
						SELECT CRM.RuleId, CRMMGlobal.ModeCodeId ,CRForUser.UserInfoId, NULL AS TriggerEventLogId, NULL AS TriggerEventCodeId, NULL AS TriggerEventDate
						FROM cmu_CommunicationRuleMaster CRM
						INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId
						INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
						WHERE CRM.RuleId = @nRuleId
						AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser
						ORDER BY CRM.RuleId, CRMMGlobal.ModeCodeId, CRForUser.UserInfoId
						
						--SELECT @nRuleId AS ForRuleIdBeforeUpdate
						--SELECT * FROM #tmpUserWithoutOffset
						
						--For those users to whom current manual rule applies, update the NotifyUserFlag = 0 if the filter conditions match such that the notification are NOT to be sent
						UPDATE #tmpUserWithoutOffset
						SET NotifyUserFlag = 0
						--SELECT 
						--UsrWOOffset.UserInfoId, UsrWOOffset.ModeCodeId, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate() AS CurrDate,
						--DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS HOUR_DIFFERENCE--,
						----FinalNotificationParams.* , UsrWOOffset.* 
						FROM
						(
							SELECT CRM.RuleId AS RuleId, UserWOOffset.ModeCodeId AS ModeCodeId, UserWOOffset.UserInfoId AS UserInfoId
							   ,CRMM.ExecFrequencyCodeId AS ExecFrequencyCodeId, /*CRMM.WaitDaysAfterTriggerEvent,*/ CRMM.NotificationLimit AS NotificationLimit,
							   UserNotifySentCount.NotificationSentCount AS NotificationSentCount, UserNotifySentCount.LastNotificationSentTS AS LastNotificationSentTS,
							   UserWOOffset.NotifyUserFlag
							FROM
							(
									SELECT CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId AS UserWOOffsetModeCodeId, 
									COUNT(NQ.NotificationQueueId) AS NotificationSentCount,
									MAX(NQ.ModifiedOn) AS LastNotificationSentTS
									FROM #tmpUserWithoutOffset UserWOOffset 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND UserWOOffset.RuleId = CRM.RuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND UserWOOffset.RuleId = CRM.RuleId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId
									LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = UserWOOffset.UserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId IS NULL
									WHERE CRMM.ModeCodeId IS NULL OR UserWOOffset.ModeCodeId = CRMM.ModeCodeId
									GROUP BY CRM.RuleId, UserWOOffset.UserInfoId, UserWOOffset.ModeCodeId
							)UserNotifySentCount
							INNER JOIN #tmpUserWithoutOffset UserWOOffset
							ON UserWOOffset.UserInfoId = UserNotifySentCount.UserInfoId AND UserWOOffset.RuleId = UserNotifySentCount.RuleId AND UserWOOffset.ModeCodeId = UserNotifySentCount.UserWOOffsetModeCodeId
							INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = UserWOOffset.RuleId AND CRM.RuleId = UserNotifySentCount.RuleId
							INNER JOIN cmu_CommunicationRuleModeMaster CRMM 
							ON CRMM.RuleId = CRM.RuleId AND CRMM.RuleId = UserWOOffset.RuleId AND CRMM.RuleId = UserNotifySentCount.RuleId AND CRMM.ModeCodeId = UserNotifySentCount.UserWOOffsetModeCodeId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId
						) FinalNotificationParams
						INNER JOIN #tmpUserWithoutOffset UsrWOOffset 
						ON FinalNotificationParams.UserInfoId = UsrWOOffset.UserInfoId AND UsrWOOffset.ModeCodeId = FinalNotificationParams.ModeCodeId AND FinalNotificationParams.RuleId = UsrWOOffset.RuleId
						WHERE 1=1
						AND FinalNotificationParams.RuleId = @nRuleId
						AND (
							--When RuleModeNotification is Halted either at global level or at personal level
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
							--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
							(FinalNotificationParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
							--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1) OR
							--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
							--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
						)	
							
						--SELECT @nRuleId AS ForRuleIdAfterUpdate	
						--SELECT * FROM #tmpUserWithoutOffset
						/*--------------------------------End - Process Rule for Insider of category - Manual-----------------------------------*/					
					END
					
					
				END --Process user notification list for rule defined for Insider users
				
				--Process user notification list for rule defined for CO users
				IF(CHARINDEX(CAST(@nRuleForCOCodeId AS VARCHAR), @sRuleForCodeIds) > 0)
				BEGIN
					print ' position for nRuleForCOCodeId= ' + CAST(CHARINDEX(CAST(@nRuleForCOCodeId AS VARCHAR), @sRuleForCodeIds) AS VARCHAR) + ' PROCESS RULE FOR CO USER.... '
					
					IF(@nRuleCategoryCodeId = @nRuleCategoryCodeIdAuto)
					BEGIN
						IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdInsider)--When the Rule is defined for CO users (defined within applicability of rule) and when the trigger/offset event-logs are to be checked against Insider users (defined within applicability of the rule)
						BEGIN
							--Rule has both TriggerEventCodeId and OffsetEventCodeId specified 
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND @sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '')
							BEGIN
								print 'Insider-CO Rule has both TriggerEventCodeId and OffsetEventCodeId specified'
								
								--Select the MapToType corresponding to Trigger events list
								SELECT DISTINCT @nTriggerMapToType = ISNULL(MapToTypeCodeId, @nMapToTypeCodeIdUser) 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId <> @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleTriggerEventCodeIds))
								--Select the MapToType corresponding to Offset events list
								SELECT DISTINCT @nOffSetMapToType = MapToTypeCodeId 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId <> @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds))

								--SELECT @nTriggerMapToType, @nOffSetMapToType
								
								--Set the flag to indicate that rule is defined for "Trade details submission to stock exchange(Continuous Disclosure) reminder to CO"
								--If TriggerEventCodes defined for rule contain the event code for ContinuousDisclosureDetailsEntered and 
								--OffsetEventCodes defined for rule contain the event code for ContinuousDisclosureCOSubmittedHardcopyToStkEx then, set flag indicator
								SELECT @bRuleForContinuousDiscloHardCopySubmitToStkEx = 0
								IF((CHARINDEX(CAST(@nContinuousDisclosureConfirmedCodeId AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 )
								AND (CHARINDEX(CAST(@nContinuousDisclosureCOSubmittedHardcopyToStkEx AS VARCHAR), @sRuleOffsetEventCodeIds) > 0) )
								BEGIN 
									SELECT @bRuleForContinuousDiscloHardCopySubmitToStkEx = 1
								END
								
								--Filter users with trigger but no offset and for whom the difference between triggereventdate and currentdate is within permissible waitdaysaftertriggerevent
								SELECT * INTO #TempTable3 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split('' + @sRuleOffsetEventCodeIds + '')) ) AND EventDate <= dbo.uf_com_GetServerDate()
								
								SELECT @sSQLInsertToTempTable = ''
								SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
								'INSERT INTO #tmpInsiderWithoutOffset(RuleId, ModeCodeId, UserInfoId, TriggerEventLogId, TriggerEventCodeId, TriggerMapToTypeCodeId, TriggerMapToId, TriggerEventDate)
								SELECT 
								--(DATEDIFF(DAY, CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) AS DateDiffValue,
								--CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) as curdate,
								--CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME) as trgrdate,
								--CRMM.WaitDaysAfterTriggerEvent,
								UserWthTrgrWOOffset.RuleId, CRMM.ModeCodeId, TriggerEventUserId, TriggerEventLogId, UserWthTrgrWOOffset.TriggerEventCodeId, UserWthTrgrWOOffset.TriggerMapToType, UserWthTrgrWOOffset.TriggerMapToId, TriggerEventDate --, CRMM.ModeCodeId
								FROM
								(
									--Select users for whom trigger events have occurred but offset events have not occured
									SELECT UsersWithTriggerEvent.RuleId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerMapToType, TriggerMapToId, TriggerEventDate--, EVLOffsetEvents.UserInfoId AS OffsetEventUserId, EVLOffsetEvents.EventCodeId AS OffsetEventCodeId
									FROM
									(
										--Select users for whom the trigger events specified in Rule have occurred. If multiple trigger events have occurred then select the max occurred trigger event as the one that should occur last in sequence of trigger events
										SELECT T.RuleId, T.UserInfoId AS TriggerEventUserId, T.EventDate AS TriggerEventDate, T.MapToTypeCodeId AS TriggerMapToType, T.MapToId AS TriggerMapToId, EVE.EventCodeId AS TriggerEventCodeId, EVE.EventLogId AS TriggerEventLogId
										FROM
										(
											--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
											SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
											, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
											FROM cmu_CommunicationRuleMaster CRM
											INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(''' + @sRuleTriggerEventCodeIds + ''' )) )
											INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
											ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) +
											' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) +
											' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
										) T
										INNER JOIN eve_EventLog EVE 
										ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate  
										AND (EVE.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''')) ) '
										
										/*CO Users should be sent reminder notification for submitting Hard-copy to Stock Exchange, only if there are users for whom applicable trading policy has flag StExSubmitDiscloToStExByCOHardcopyFlag = 1
										Add additional INNER JOIN here for rul_TradingPolicy.StExSubmitDiscloToStExByCOHardcopyFlag = 1*/
										IF(@bRuleForContinuousDiscloHardCopySubmitToStkEx = 1)
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' INNER JOIN tra_TransactionMaster TRM ON EVE.UserInfoId = TRM.UserInfoId AND EVE.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdDisclosureTransaction AS VARCHAR(20)) + ' AND EVE.MapToId = TRM.TransactionMasterId '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
											' INNER JOIN rul_TradingPolicy TP ON TRM.TradingPolicyId = TP.TradingPolicyId AND TP.StExSubmitDiscloToStExByCOHardcopyFlag = 1 '
										END
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable 
										+ ' )UsersWithTriggerEvent LEFT JOIN #TempTable3 EVLOffsetEvents ON TriggerEventUserId = EVLOffsetEvents.UserInfoId '
									
									IF(@nTriggerMapToType = @nOffSetMapToType)
									BEGIN
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND TriggerMapToType = EVLOffsetEvents.MapToTypeCodeId AND TriggerMapToId = EVLOffsetEvents.MapToId '
									END
									
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleOffsetEventCodeIds + ''')) '
									+ ' WHERE EVLOffsetEvents.UserInfoId IS NULL --All those users for whom trigger event(s) has occurred but offset event(s) has not occurred
								)UserWthTrgrWOOffset
								INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = UserWthTrgrWOOffset.RuleId AND CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20))
								+ ' INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRMM.RuleId = CRM.RuleId AND CRMM.UserId IS NULL
								--When days difference between TriggerEventDate and CurrentDate has not crossed WaitDaysAfterTriggerEvent, for the notification to be sent
								WHERE( 
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) < CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND (DATEDIFF(DAY, CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) >= CRMM.WaitDaysAfterTriggerEvent) OR --If current-date < trigger-event-date then send notification when difference between trigger-event-date and current-date is >= waitdaysaftertrigger (case when notification is to be sent -N days before trigger-event-date)
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) = CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND CRMM.WaitDaysAfterTriggerEvent <= 0) OR --If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then send notification. If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then DO send notification. (cases (A)when notification is to be sent -N days before trigger-event-date until current-date approaches trigger-event-date and (B)when notification is to be sent N days after trigger-event-date,where N=0)
										( (CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) > CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME)) AND
											   ((CRMM.WaitDaysAfterTriggerEvent >= 0) AND (DATEDIFF(DAY, CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) >= CRMM.WaitDaysAfterTriggerEvent) --If current-date > trigger-event-date then send notification when difference between trigger-event-date and current-date is >= waitdaysaftertrigger (case when notification is to be sent N days after trigger-event-date)
										)
									 ) 
								ORDER BY RuleId, ModeCodeId, TriggerEventUserId, TriggerEventLogId '

								EXEC(@sSQLInsertToTempTable)
								
								DROP TABLE #TempTable3 
							END
							ELSE
							--Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND (@sRuleOffsetEventCodeIds IS NULL OR @sRuleOffsetEventCodeIds = '') )
							BEGIN 
								print 'Insider-CO Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified'
								--Store users who have applicable rule, have trigger event and rule does not have any offset event defined to check for users without offset events. Users are such that the difference between triggereventdate and currentdate is within permissible waitdaysaftertriggerevent
								INSERT INTO #tmpInsiderWithoutOffset(RuleId, ModeCodeId, UserInfoId, TriggerEventLogId, TriggerEventCodeId, TriggerMapToTypeCodeId, TriggerMapToId, TriggerEventDate)
								SELECT 
								UserWthTrgrWOOffset.RuleId, CRMM.ModeCodeId, TriggerEventUserId, TriggerEventLogId, UserWthTrgrWOOffset.TriggerEventCodeId, UserWthTrgrWOOffset.TriggerMapToType, UserWthTrgrWOOffset.TriggerMapToId, TriggerEventDate --, CRMM.ModeCodeId
								FROM
								(
									--Select users for whom the trigger events specified in Rule have occurred. If multiple trigger events have occurred then select the most recently occurred trigger event as the one that should occur last in sequence of trigger events
									SELECT CRM.RuleId
									, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
									FROM cmu_CommunicationRuleMaster CRM
									INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser  
									INNER JOIN 
									(
											--Get the eventlog details for most recently occurred trigger event per user
											SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
											FROM
											(
												--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
												SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
												, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
												FROM cmu_CommunicationRuleMaster CRM
												INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds)) )
												INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
												ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser
												WHERE CRM.RuleId = @nRuleId
												GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
											) T
											INNER JOIN eve_EventLog EVE 
											ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate
									)EVLTriggerEvents 
									ON CRForUser.UserInfoId = EVLTriggerEvents.UserInfoId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds )) )  
									WHERE CRM.RuleId = @nRuleId
								)UserWthTrgrWOOffset
								INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = UserWthTrgrWOOffset.RuleId AND CRM.RuleId = @nRuleId
								INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRMM.RuleId = CRM.RuleId AND CRMM.UserId IS NULL
								--When days' difference between TriggerEventDate and CurrentDate has not crossed WaitDaysAfterTriggerEvent, for the notification to be sent
								WHERE( 
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) < CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND (DATEDIFF(DAY, CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) >= CRMM.WaitDaysAfterTriggerEvent) OR --If current-date < trigger-event-date then send notification when difference between trigger-event-date and current-date is >= waitdaysaftertrigger (case when notification is to be sent -N days before trigger-event-date)
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) = CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND CRMM.WaitDaysAfterTriggerEvent <= 0) OR --If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then send notification. If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then DO send notification. (cases (A)when notification is to be sent -N days before trigger-event-date until current-date approaches trigger-event-date and (B)when notification is to be sent N days after trigger-event-date,where N=0)
										( (CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) > CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME)) AND
											   ((CRMM.WaitDaysAfterTriggerEvent >= 0) AND (DATEDIFF(DAY, CAST(CAST(UserWthTrgrWOOffset.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) >= CRMM.WaitDaysAfterTriggerEvent) --If current-date > trigger-event-date then send notification when difference between trigger-event-date and current-date is >= waitdaysaftertrigger (case when notification is to be sent N days after trigger-event-date)
										)
									 ) 
								ORDER BY RuleId, ModeCodeId, TriggerEventUserId, TriggerEventLogId
							END
							ELSE	
							--Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified
							IF( (@sRuleTriggerEventCodeIds IS NULL OR @sRuleTriggerEventCodeIds = '') AND (@sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '') )
							BEGIN
								print 'Insider-CO Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified'
								SELECT * INTO #TempTable8 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) ) AND EventDate <= dbo.uf_com_GetServerDate()
								INSERT INTO #tmpInsiderWithoutOffset(RuleId, ModeCodeId, UserInfoId, TriggerEventLogId, TriggerEventCodeId, TriggerMapToTypeCodeId, TriggerMapToId, TriggerEventDate)
								SELECT RuleId, ModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerMapToType, TriggerMapToId, TriggerEventDate
								FROM
								(
									--Select users for whom the offset events specified in Rule have NOT occurred
									SELECT CRM.RuleId, CRMM.RuleModeId, CRMM.ModeCodeId, CRForUser.UserInfoId AS TriggerEventUserId, 
									EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, 
									MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
									FROM cmu_CommunicationRuleMaster CRM
									INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId <> @nUserTypeCodeIdCOUser
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.UserId IS NULL --Get global modes for rule
									LEFT JOIN #TempTable8 EVLOffsetEvents 
									ON CRForUser.UserInfoId = EVLOffsetEvents.UserInfoId AND (EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) )
									WHERE CRM.RuleId = @nRuleId
									AND EVLOffsetEvents.UserInfoId IS NULL --All those users for whom offset event(s) has not occurred
								)UsersWithoutOffsetEvent
								ORDER BY RuleId, ModeCodeId, TriggerEventUserId, TriggerEventLogId
								DROP TABLE #TempTable8
							END
							
							--SELECT '#tmpInsiderWithoutOffset'
							--SELECT * FROM  #tmpInsiderWithoutOffset
							
							SELECT @nInsidersWithoutOffset = COUNT(ID) FROM #tmpInsiderWithoutOffset
							IF(@nInsidersWithoutOffset > 0) --If users with trigger and without offset events are found then fetch the CO users for whom rule is applicable
							BEGIN
									print 'process CO rule further, since users without offset event exist...'
									--Get the CO users for whom rule is applicable
									INSERT INTO #tmpCOUserToNotify(RuleId, ModeCodeId, COUserInfoId)
									SELECT CRM.RuleId,
									CASE WHEN CRMMPersonal.ModeCodeId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
									, CRForUser.UserInfoId
									FROM vw_ApplicableCommunicationRuleForUser CRForUser 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = CRForUser.RuleId AND CRM.RuleId = @nRuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRMMGlobal.RuleId = CRM.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
									LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
									ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
									WHERE CRForUser.UserTypeCodeId = @nUserTypeCodeIdCOUser
									ORDER BY RuleId, CRMMModeCodeId, CRForUser.UserInfoId
									
									--SELECT '#tmpCOUserToNotify before update'
									--SELECT * FROM #tmpCOUserToNotify
									/*--------------START - For each CO user to whom rule applies, update #tmpCOUserToNotify based upon RuleMode's ExecutionFrequency and timestamp of the last sent notification for that RuleMode-----------------*/
									UPDATE #tmpCOUserToNotify
									SET NotifyUserFlag = 0
									--SELECT *,DATEDIFF(HOUR, FinalCOLastSentNotificationTS.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS datediffvalue 
									FROM
									(
										SELECT CRM.RuleId, COUserToNotify.ModeCodeId, COUserToNotify.COUserInfoId
										--, CRMMGlobal.ExecFrequencyCodeId AS GlobalEXFR, CRMMPersonal.ExecFrequencyCodeId AS PersonalEXFR
										,CASE WHEN CRMMPersonal.ExecFrequencyCodeId IS NULL THEN CRMMGlobal.ExecFrequencyCodeId ELSE CRMMPersonal.ExecFrequencyCodeId END AS ExecFrequencyCodeId 
										,LastNotificationSentTS
										FROM
										(	
											--Get the count of notifications sent and the timestamp for last notification sent for each of the CO users for whom rule is applicable
											SELECT CRM.RuleId AS RuleId, COUserToNotify.COUserInfoId AS COUserInfoId, COUserToNotify.ModeCodeId AS ModeCodeId , 
											MAX(NQ.ModifiedOn) AS LastNotificationSentTS
											FROM #tmpCOUserToNotify COUserToNotify
											INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = COUserToNotify.RuleId
											INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.ModeCodeId = COUserToNotify.ModeCodeId
											LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = COUserToNotify.COUserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId IS NULL
											GROUP BY CRM.RuleId, COUserToNotify.COUserInfoId, COUserToNotify.ModeCodeId
										)COLastSentNotificationTS
										INNER JOIN #tmpCOUserToNotify COUserToNotify 
										ON COUserToNotify.RuleId = COLastSentNotificationTS.RuleId AND COUserToNotify.COUserInfoId = COLastSentNotificationTS.COUserInfoId AND COUserToNotify.ModeCodeId = COLastSentNotificationTS.ModeCodeId
										INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = COUserToNotify.RuleId AND CRM.RuleId = @nRuleId
										INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.RuleId = COUserToNotify.RuleId AND CRMMGlobal.ModeCodeId = COUserToNotify.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = COUserToNotify.COUserInfoId -- Get personalized modes for rule
										WHERE CRM.RuleId = @nRuleId
									)FinalCOLastSentNotificationTS
									INNER JOIN #tmpCOUserToNotify COUserToNotify 
									ON FinalCOLastSentNotificationTS.COUserInfoId = COUserToNotify.COUserInfoId AND COUserToNotify.ModeCodeId = FinalCOLastSentNotificationTS.ModeCodeId AND COUserToNotify.RuleId = FinalCOLastSentNotificationTS.RuleId
									WHERE 1=1
									AND FinalCOLastSentNotificationTS.RuleId = @nRuleId
									AND (
										--When RuleModeNotification is Halted either at global level or at personal level
										(FinalCOLastSentNotificationTS.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
										--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
										(FinalCOLastSentNotificationTS.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalCOLastSentNotificationTS.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalCOLastSentNotificationTS.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
										--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
									)
									/*--------------END - For each CO user to whom rule applies, update #tmpCOUserToNotify based upon RuleMode's ExecutionFrequency and timestamp of the last sent notification for that RuleMode-----------------*/
									--SELECT '#tmpCOUserToNotify after update'
									--SELECT * FROM #tmpCOUserToNotify
									
									/*--------------START - For all those CO user's to whom current rule being processed is applicable and for whom #tmpCOUserToNotify.NotifyUserFlag=1, update each corresponding ##tmpCOUserToNotifyEventBased based upon RuleMode's NotificationLimit and count of notification sent for that RuleMode-EventLogId-----------------*/
									--SELECT * FROM #tmpInsiderWithoutOffset WHERE RuleId = @nRuleId
									--ORDER BY RuleId, ModeCodeId, UserInfoId
									
									INSERT INTO #tmpCOUserToNotifyEventBased(RuleId, ModeCodeId, COUserInfoId, UserInfoId, TriggerEventLogId, TriggerMapToTypeCodeId, TriggerMapToId)
									SELECT @nRuleId AS RuleId, COUserToNotify.ModeCodeId, COUserToNotify.COUserInfoId, 
									UserWOOffset.UserInfoId, UserWOOffset.TriggerEventLogId, UserWOOffset.TriggerMapToTypeCodeId, UserWOOffset.TriggerMapToId
									FROM #tmpCOUserToNotify COUserToNotify INNER JOIN #tmpInsiderWithoutOffset UserWOOffset 
									ON COUserToNotify.RuleId = UserWOOffset.RuleId AND COUserToNotify.ModeCodeId = UserWOOffset.ModeCodeId AND COUserToNotify.RuleId = @nRuleId
									ORDER BY RuleId, ModeCodeId, COUserInfoId, UserInfoId
									
									--SELECT '#tmpCOUserToNotifyEventBased before update'
									--SELECT * FROM #tmpCOUserToNotifyEventBased
									
									UPDATE #tmpCOUserToNotifyEventBased
									SET NotifyUserFlag = 0
									--SELECT * 
									FROM
									(
										SELECT CONotificationSent.RuleId, CONotificationSent.ModeCodeId, CONotificationSent.COUserInfoId, CONotificationSent.UserInfoId, CONotificationSent.TriggerEventLogId, 
										CONotificationSent.NQPUserInfoId, CONotificationSent.NQPEventLogId, CONotificationSent.NotificationSentCount
										,CASE WHEN CRMMPersonal.ExecFrequencyCodeId IS NULL THEN CRMMGlobal.ExecFrequencyCodeId ELSE CRMMPersonal.ExecFrequencyCodeId END AS ExecFrequencyCodeId 
										,CASE WHEN CRMMPersonal.NotificationLimit IS NULL THEN CRMMGlobal.NotificationLimit ELSE CRMMPersonal.NotificationLimit END AS NotificationLimit 
										FROM
										(
											SELECT RuleId, ModeCodeId, COUserInfoId, UserInfoId, TriggerEventLogId, NQPUserInfoId, NQPEventLogId
											,COUNT(NQPEventLogId) AS NotificationSentCount
											FROM
											(
												SELECT CRM.RuleId, UserWOOffset.ModeCodeId AS ModeCodeId, COUserToNotify.COUserInfoId
												, UserWOOffset.UserInfoId, UserWOOffset.TriggerEventLogId
												,CRMM.ModeCodeId AS CRMMModeCodeId, CRMM.RuleModeId AS CRMMRuleModeId, CRMM.UserId AS CRMMUserId
												,NQ.NotificationQueueId, NQ.UserId,NQ.RuleModeId AS NQRuleModeId
												,NQP.EventLogId AS NQPEventLogId, NQP.UserInfoId AS NQPUserInfoId
												FROM 
												#tmpCOUserToNotify COUserToNotify 
												INNER JOIN #tmpInsiderWithoutOffset UserWOOffset ON COUserToNotify.RuleId = UserWOOffset.RuleId AND COUserToNotify.ModeCodeId = UserWOOffset.ModeCodeId
												INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = COUserToNotify.RuleId AND UserWOOffset.RuleId = CRM.RuleId
												INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.ModeCodeId = COUserToNotify.ModeCodeId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId
												AND CRMM.UserId IS NULL OR (CRMM.UserId = COUserToNotify.COUserInfoId AND CRMM.ModeCodeId = COUserToNotify.ModeCodeId AND CRMM.ModeCodeId = UserWOOffset.ModeCodeId)
												LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = COUserToNotify.COUserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId IS NULL
												LEFT JOIN cmu_NotificationQueueParameters NQP 
												ON NQ.NotificationQueueId = NQP.NotificationQueueId AND NQP.EventLogId = UserWOOffset.TriggerEventLogId AND NQP.UserInfoId = UserWOOffset.UserInfoId
												WHERE COUserToNotify.NotifyUserFlag = 1
												--ORDER BY RuleId,ModeCodeId,COUserInfoId,NQ.NotificationQueueId,NQ.RuleModeId, NQP.UserInfoId, NQP.EventLogId
											) T
											GROUP BY RuleId, ModeCodeId, COUserInfoId, UserInfoId, TriggerEventLogId, NQPUserInfoId, NQPEventLogId
										)CONotificationSent
										INNER JOIN #tmpCOUserToNotify COUserToNotify ON COUserToNotify.RuleId = CONotificationSent.RuleId AND COUserToNotify.ModeCodeId = CONotificationSent.ModeCodeId AND COUserToNotify.COUserInfoId = CONotificationSent.COUserInfoId
										INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = COUserToNotify.RuleId AND CRM.RuleId = CONotificationSent.RuleId AND CRM.RuleId = @nRuleId
										INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.RuleId = COUserToNotify.RuleId AND CRMMGlobal.ModeCodeId = COUserToNotify.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = COUserToNotify.COUserInfoId -- Get personalized modes for rule 
									)FinalParams
									INNER JOIN #tmpCOUserToNotifyEventBased COEventBased 
									ON  FinalParams.RuleId = COEventBased.RuleId AND COEventBased.ModeCodeId = FinalParams.ModeCodeId 
									AND FinalParams.COUserInfoId = COEventBased.COUserInfoId AND FinalParams.UserInfoId = COEventBased.UserInfoId 
									AND FinalParams.TriggerEventLogId = COEventBased.TriggerEventLogId
									WHERE 1=1
									AND FinalParams.RuleId = @nRuleId
									AND (
										--When RuleModeNotification is Halted either at global level or at personal level
										(FinalParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
										--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
										(FinalParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
										--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
										(FinalParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1)
									)
									
									--SELECT '#tmpCOUserToNotifyEventBased after update'
									--SELECT * FROM #tmpCOUserToNotifyEventBased
									/*--------------END - For all those CO user's to whom current rule being processed is applicable and for whom #tmpCOUserToNotify.NotifyUserFlag=1, update each corresponding ##tmpCOUserToNotifyEventBased based upon RuleMode's NotificationLimit and count of notification sent for that RuleMode-EventLogId-----------------*/
							END /*END of - IF(@nInsidersWithoutOffset > 0)*/
							
						END /*IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdInsider)*/
						
						ELSE IF(@nRuleEventsApplyToCodeId = @nRuleEventsApplyToCodeIdCO)--When the Rule is defined for CO users (defined within applicability of rule) and when the trigger/offset event-logs are to be checked against same set of CO users itself
						BEGIN
							/*--------------------------------Start - Process Rule for CO with events for CO, of category - Auto-----------------------------------*/
							print 'Process auto rule for CO here, where events are also to be checked for CO user'
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND @sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '')
							BEGIN
								print 'CO Rule has both TriggerEventCodeId and OffsetEventCodeId specified'
								
								--Select the MapToType corresponding to Trigger events list
								SELECT DISTINCT @nTriggerMapToType = ISNULL(MapToTypeCodeId, @nMapToTypeCodeIdUser) 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId = @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleTriggerEventCodeIds))
								--Select the MapToType corresponding to Offset events list
								SELECT DISTINCT @nOffSetMapToType = MapToTypeCodeId 
								FROM eve_EventLog EL INNER JOIN vw_ApplicableCommunicationRuleForUser RuleUsers 
								ON RuleUsers.RuleId = @nRuleId AND EL.UserInfoId = RuleUsers.UserInfoId AND UserTypeCodeId = @nUserTypeCodeIdCOUser
								WHERE EventCodeId in (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds))

								--SELECT @nTriggerMapToType, @nOffSetMapToType
								
								--Store CO users who have applicable rule, have trigger event logged in eventlog but do not have corresponding offset event logged in eventlog
								SELECT * INTO #TempTable4 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split('' + @sRuleOffsetEventCodeIds + '')) ) AND EventDate <= dbo.uf_com_GetServerDate() 
								
								SELECT @sSQLInsertToTempTable = ''
								SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
								'INSERT INTO #tmpCOUserWithoutOffset (RuleId, ModeCodeId, CoUserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToTypeCodeId, TriggerMapToId)
									SELECT COUsersWithTriggerEvent.RuleId, COUsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToType, TriggerMapToId
									FROM
									(
										--Select CO users for whom the trigger events specified in Rule have occurred
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
										FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) + ' ' +
										' INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
										INNER JOIN '
										
										SELECT @sMaxTriggerEventTableQuery = '( '
										SELECT @sMaxTriggerEventTableQuery = @sMaxTriggerEventTableQuery  + 
											'
											--Get the eventlog details for most recently occurred trigger event per user
											SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
											FROM
											(
												--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
												SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
												, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
												FROM cmu_CommunicationRuleMaster CRM
												INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(''' + @sRuleTriggerEventCodeIds + ''')) )
												INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
												ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) + 
												' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + 
												' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
											) T
											INNER JOIN eve_EventLog EVE 
											ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate  '
										
										SELECT @sMaxTriggerEventTableQuery = @sMaxTriggerEventTableQuery  + ') EVLTriggerEvents '
										
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + @sMaxTriggerEventTableQuery 
										
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ON CRForUser.UserInfoId = EVLTriggerEvents.UserInfoId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) ' +
										' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) 
								SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' ) COUsersWithTriggerEvent LEFT JOIN #TempTable4 EVLOffsetEvents ON TriggerEventUserId = EVLOffsetEvents.UserInfoId '
								IF(@nTriggerMapToType = @nOffSetMapToType)
								BEGIN
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND TriggerMapToType = EVLOffsetEvents.MapToTypeCodeId AND TriggerMapToId = EVLOffsetEvents.MapToId '
								END
								SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
								' AND EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleOffsetEventCodeIds + ''' )) ' +
								' WHERE EVLOffsetEvents.UserInfoId IS NULL --All those users for whom trigger event(s) has occurred but offset event(s) has not occurred '

								EXEC(@sSQLInsertToTempTable)								
								
								DROP TABLE #TempTable4 
							END	
							
							ELSE
							--Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified
							IF(@sRuleTriggerEventCodeIds IS NOT NULL AND @sRuleTriggerEventCodeIds <> '' AND (@sRuleOffsetEventCodeIds IS NULL OR @sRuleOffsetEventCodeIds = '') )
							BEGIN 
								print 'CO Rule has TriggerEventCodeId specified but does not have OffsetEventCodeId specified'
								/*If the rule has TriggerEvent defined as : (153025) 'Trading Window Close' or (153026) 'Trading Window Open' then, there are corresponding eventlog entries done to eventlog table for the window open/close dates for both insiders and CO users
								  For CO users, the entry is done for all CO users for both 'Trading Window Financial Results' and 'Trading Window Other'.
								  Hence, when generating the notification queue entries, make use of the eventlog-table + user-table + trading-window-table, since eventlog-table already has events defined for valid users based on whether Trading Window is 'Other'/'Financial Results' 
								  When generating notifiactions into notification queue, generate them as per applicability defined for both communication-rule and trading-window. 
								  Applicability of communication rule handles both CO user and Insiders. Applicability of trading window, handles only Insider users. Trading Window Other has associated applicability while Trading Window Financial Results does not have its own applicability but applies to all Insider users.
								  Events 153025/153026 get logged into event-log table based on applicability of Trading Window (Trading Window Other) - using stored procedure st_cmu_Job_GenerateBulkEvents_TradingWindow. For CO user, event gets logged for all Active CO users.
								  So, when generating notification queue data below, applicability only of Communication Rule is considered (INNER JOIN vw_ApplicableCommunicationRuleForUser) to get intersection of users specified within trading window applicability and communication rule applicability.
								*/
								IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 ) OR (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0 ) )
								BEGIN
									PRINT 'PROCESS CO RULE FOR TRADING WINDOW CLOSE/OPEN.....'
									SELECT @sSQLInsertToTempTable = ''
									SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable +
									'INSERT INTO #tmpCOUserWithoutOffset (RuleId, ModeCodeId, CoUserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TradingWindowEventType, TradingWindowId, TradingWindowFinancialYearValue, TradingWindowFinancialPeriodValue, TradingWindowCloseDate, TradingWindowOpenDate)
									SELECT COUsersWithTriggerEvent.RuleId, COUsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TradingWindowEventType, TradingWindowId, TradingWindowFinancialYearValue, TradingWindowFinancialPeriodValue, TradingWindowCloseDate, TradingWindowOpenDate
									FROM
									(
										--Select users for whom the trigger events specified in Rule have occurred
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										,EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId 
										,EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
										, CCTWEventType.CodeName AS TradingWindowEventType	
										, TradingWindowId AS TradingWindowId 
										, ISNULL(CCTWFinancialYear.CodeName,'''') AS TradingWindowFinancialYearValue
										, ISNULL(CCTWFinancialPeriod.CodeName,'''') AS TradingWindowFinancialPeriodValue '
										IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowCloseDate AS TradingWindowCloseDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowOpenDate AS TradingWindowOpenDate '
										END
										ELSE IF( (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowCloseDate AS TradingWindowCloseDate '
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' , TWE.WindowOpenDate AS TradingWindowOpenDate '
										END
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN 
										(
											--Get the eventlog details for most recently occurred trigger event per user
											SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
											FROM
											(
												--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate, for future 30 days
												SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
												, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
												FROM cmu_CommunicationRuleMaster CRM
												--Added 5 days prior to current date as DATEADD(DAY, -5, dbo.uf_com_GetServerDate()) so that notification can be sent N days before as well as one day after window open date  
												INNER JOIN eve_EventLog EVLTriggerEvents1 ON EVLTriggerEvents1.EventDate >= DATEADD(DAY, -5, dbo.uf_com_GetServerDate()) AND EVLTriggerEvents1.EventDate <= (DATEADD(DAY, 30, dbo.uf_com_GetServerDate())) AND (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) )
												INNER JOIN usr_UserInfo UI ON UI.UserInfoId = EVLTriggerEvents1.UserInfoId AND UI.StatusCodeId = ' + CAST(@nActiveUserCodeID AS VARCHAR(20)) + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) +
												' INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON UI.UserInfoId = CRForUser.UserInfoId AND CRForUser.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCOUser AS VARCHAR(20)) +' AND CRForUser.RuleId = ' + CAST(@nRuleId AS VARCHAR(20))  
												SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
												' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + 
												' GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
											) T
											INNER JOIN eve_EventLog EVE 
											ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate
										)EVLTriggerEvents 
										ON CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) + ' AND CRM.RuleId = EVLTriggerEvents.RuleId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( ''' + @sRuleTriggerEventCodeIds + ''' )) ) '
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = EVLTriggerEvents.UserInfoId -- Get personalized modes for rule 
										INNER JOIN rul_TradingWindowEvent TWE ON EVLTriggerEvents.MapToId = TWE.TradingWindowEventId AND EVLTriggerEvents.MapToTypeCodeId = ' + CAST(@nMapToTypeCodeIdTradingWindow AS VARCHAR(20)) + ' '
										IF( (CHARINDEX(CAST(@nTradingWindowCloseEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND EVLTriggerEvents.EventDate = TWE.WindowCloseDate '
										END
										ELSE IF( (CHARINDEX(CAST(@nTradingWindowOpenEventCodeID AS VARCHAR),@sRuleTriggerEventCodeIds) > 0) )
										BEGIN
											SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + ' AND EVLTriggerEvents.EventDate = TWE.WindowOpenDate '
										END 
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' INNER JOIN com_Code CCTWEventType ON TWE.EventTypeCodeId = CCTWEventType.CodeId 
										 LEFT JOIN com_Code CCTWFinancialYear ON TWE.FinancialYearCodeId = CCTWFinancialYear.CodeId 
										 LEFT JOIN com_Code CCTWFinancialPeriod ON TWE.FinancialPeriodCodeId = CCTWFinancialPeriod.CodeId '
										SELECT @sSQLInsertToTempTable = @sSQLInsertToTempTable + 
										' WHERE CRM.RuleId = ' + CAST(@nRuleId AS VARCHAR(20)) +
									' )COUsersWithTriggerEvent '

									EXEC(@sSQLInsertToTempTable)
									
								END
								ELSE
								BEGIN
									--Store users who have applicable rule, have trigger event and rule does not have any offset event defined to check for users without offset events
									INSERT INTO #tmpCOUserWithoutOffset (RuleId, ModeCodeId, CoUserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToTypeCodeId, TriggerMapToId)
									SELECT COUsersWithTriggerEvent.RuleId, COUsersWithTriggerEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToType, TriggerMapToId
									FROM
									(
										--Select CO users for whom the trigger events specified in Rule have occurred
										SELECT CRM.RuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
										,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
										, EVLTriggerEvents.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
										FROM cmu_CommunicationRuleMaster CRM
										INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId = @nUserTypeCodeIdCOUser  
										INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
										LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
										ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
										INNER JOIN 
										(
												--Get the eventlog details for most recently occurred trigger event per CO user
												SELECT T.RuleId, T.UserInfoId, T.EventDate, T.MapToTypeCodeId, T.MapToId, EVE.EventCodeId, EVE.EventLogId
												FROM
												(
													--In case when there are multiple trigger events logged for same user from the set of trigger events assigned to communication rule then, get most recently occurred event based on max eventdate
													SELECT CRM.RuleId, EVLTriggerEvents1.UserInfoId
													, MapToTypeCodeId, MapToId, MAX(EventDate) AS EventDate
													FROM cmu_CommunicationRuleMaster CRM
													INNER JOIN eve_EventLog EVLTriggerEvents1 ON (EVLTriggerEvents1.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds)) )
													INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser 
													ON CRForUser.RuleId = CRM.RuleId AND CRForUser.UserInfoId = EVLTriggerEvents1.UserInfoId AND CRForUser.UserTypeCodeId = @nUserTypeCodeIdCOUser
													WHERE CRM.RuleId = @nRuleId
													GROUP BY CRM.RuleId, EVLTriggerEvents1.UserInfoId, EVLTriggerEvents1.MapToTypeCodeId, EVLTriggerEvents1.MapToId
												) T
												INNER JOIN eve_EventLog EVE 
												ON EVE.UserInfoId = T.UserInfoId AND T.MapToTypeCodeId = EVE.MapToTypeCodeId AND T.MapToId = EVE.MapToId AND EVE.EventDate = T.EventDate
										)EVLTriggerEvents 
										ON CRForUser.UserInfoId = EVLTriggerEvents.UserInfoId AND (EVLTriggerEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split( @sRuleTriggerEventCodeIds )) )  
										WHERE CRM.RuleId = @nRuleId
									)COUsersWithTriggerEvent
								END
							END
							ELSE
							--Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified
							IF( (@sRuleTriggerEventCodeIds IS NULL OR @sRuleTriggerEventCodeIds = '') AND (@sRuleOffsetEventCodeIds IS NOT NULL AND @sRuleOffsetEventCodeIds <> '') )
							BEGIN
								print 'CO Rule has OffsetEventCodeId specified but does not have TriggerEventCodeId specified'
								
								SELECT * INTO #TempTable5 FROM eve_EventLog WHERE (EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) ) AND EventDate <= dbo.uf_com_GetServerDate()
								INSERT INTO #tmpCOUserWithoutOffset (RuleId, ModeCodeId, CoUserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToTypeCodeId, TriggerMapToId)
								SELECT COUsersWithoutOffsetEvent.RuleId, COUsersWithoutOffsetEvent.CRMMModeCodeId, TriggerEventUserId, TriggerEventLogId, TriggerEventCodeId, TriggerEventDate, TriggerMapToType, TriggerMapToId
								FROM
								(
									--Select users for whom the offset events specified in Rule have NOT occurred
									SELECT CRM.RuleId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleId ELSE CRMMPersonal.RuleId END AS CRMMRuleId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS CRMMRuleModeId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS CRMMModeCodeId
									,CASE WHEN CRMMPersonal.UserId IS NULL THEN CRMMGlobal.UserId ELSE CRMMPersonal.UserId END AS CRMMUserId
									, CRForUser.UserInfoId AS TriggerEventUserId, EventCodeId AS TriggerEventCodeId, EventLogId AS TriggerEventLogId, EventDate AS TriggerEventDate, MapToTypeCodeId AS TriggerMapToType, MapToId AS TriggerMapToId
									FROM cmu_CommunicationRuleMaster CRM
									INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId = @nUserTypeCodeIdCOUser
									INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
									LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal 
									ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = CRForUser.UserInfoId -- Get personalized modes for rule
									LEFT JOIN #TempTable5
									EVLOffsetEvents 
									ON CRForUser.UserInfoId = EVLOffsetEvents.UserInfoId AND (EVLOffsetEvents.EventCodeId IN (SELECT items FROM dbo.uf_com_Split(@sRuleOffsetEventCodeIds)) )
									WHERE CRM.RuleId = @nRuleId
									AND EVLOffsetEvents.UserInfoId IS NULL --All those users for whom offset event(s) has not occurred
								)COUsersWithoutOffsetEvent
								DROP TABLE #TempTable5
							END
							
							--SELECT @nRuleId AS ForRuleIdBeforeUpdate
							--SELECT * FROM #tmpCOUserWithoutOffset
								
										
							--Update NotifyUserFlag for CO users if notification is not to be sent, by default this flag will be 1 for all CO users for whom trigger event has occured and offset event has not occured
							UPDATE #tmpCOUserWithoutOffset
							SET NotifyUserFlag = 0
							--SELECT FinalNotificationParams.TriggerEventDate, FinalNotificationParams.TriggerEventLogId, 
							--COUsrWOOffset.CoUserInfoId, COUsrWOOffset.ModeCodeId,
							--CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) AS CURR_DATE, 
							--CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AS TRIGGER_DATE,
							--(DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) AS DATE_DIFF,
							--FinalNotificationParams.WaitDaysAfterTriggerEvent,
							--DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS HOUR_DIFFERENCE,
							--FinalNotificationParams.* , COUsrWOOffset.* 
							FROM 
							(
								SELECT CRM.RuleId, COUserWOOffset.ModeCodeId, COUserWOOffset.CoUserInfoId
								,CASE WHEN CRMMPersonal.ExecFrequencyCodeId IS NULL THEN CRMMGlobal.ExecFrequencyCodeId ELSE CRMMPersonal.ExecFrequencyCodeId END AS ExecFrequencyCodeId 
								,CASE WHEN CRMMPersonal.WaitDaysAfterTriggerEvent IS NULL THEN CRMMGlobal.WaitDaysAfterTriggerEvent ELSE CRMMPersonal.WaitDaysAfterTriggerEvent END AS WaitDaysAfterTriggerEvent
								,CASE WHEN CRMMPersonal.NotificationLimit IS NULL THEN CRMMGlobal.NotificationLimit ELSE CRMMPersonal.NotificationLimit END AS NotificationLimit 
								,NotificationSentCount, LastNotificationSentTS
								,COUserWOOffset.TriggerEventLogId, COUserWOOffset.TriggerEventDate, COUserWOOffset.NotifyUserFlag
								FROM
								(	
									SELECT CRM.RuleId, COUserWOOffset.CoUserInfoId, COUserWOOffset.ModeCodeId AS UserWOOffsetModeCodeId, 
									COUserWOOffset.TriggerEventLogId, COUNT(NQ.NotificationQueueId) AS NotificationSentCount /*,CRMM.ModeCodeId AS CRMMModeCodeId, NQ.RuleModeId, CRMM.RuleModeId*/ ,
									MAX(NQ.ModifiedOn) AS LastNotificationSentTS
									FROM #tmpCOUserWithoutOffset COUserWOOffset 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = COUserWOOffset.RuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND CRMM.ModeCodeId = COUserWOOffset.ModeCodeId
									LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = COUserWOOffset.CoUserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId = COUserWOOffset.TriggerEventLogId
									GROUP BY CRM.RuleId, COUserWOOffset.CoUserInfoId, COUserWOOffset.ModeCodeId, COUserWOOffset.TriggerEventLogId
								) COUserWOOffsetNotifySentCount
								INNER JOIN #tmpCOUserWithoutOffset COUserWOOffset 
								ON COUserWOOffsetNotifySentCount.CoUserInfoId = COUserWOOffset.CoUserInfoId AND COUserWOOffsetNotifySentCount.UserWOOffsetModeCodeId = COUserWOOffset.ModeCodeId AND COUserWOOffsetNotifySentCount.RuleId = COUserWOOffset.RuleId AND COUserWOOffsetNotifySentCount.TriggerEventLogId = COUserWOOffset.TriggerEventLogId
								INNER JOIN cmu_CommunicationRuleMaster CRM ON COUserWOOffsetNotifySentCount.RuleId = CRM.RuleId AND CRM.RuleId = @nRuleId
								INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND COUserWOOffset.RuleId = CRMMGlobal.RuleId AND COUserWOOffset.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
								LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = COUserWOOffsetNotifySentCount.CoUserInfoId -- Get personalized modes for rule
								WHERE CRM.RuleId = @nRuleId
							) FinalNotificationParams
							INNER JOIN #tmpCOUserWithoutOffset COUsrWOOffset 
							ON FinalNotificationParams.CoUserInfoId = COUsrWOOffset.CoUserInfoId AND COUsrWOOffset.ModeCodeId = FinalNotificationParams.ModeCodeId 
							AND COUsrWOOffset.RuleId = FinalNotificationParams.RuleId AND COUsrWOOffset.TriggerEventLogId = FinalNotificationParams.TriggerEventLogId
							WHERE 1=1
							AND FinalNotificationParams.RuleId = @nRuleId
							AND (
									----When days' difference between TriggerEventDate and CurrentDate has not crossed WaitDaysAfterTriggerEvent, for the notification to be sent
									( 
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) < CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) OR --If current-date < trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent -N days before trigger-event-date)
										(CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) = CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME) AND FinalNotificationParams.WaitDaysAfterTriggerEvent > 0) OR --If current-date=trigger-event-date and waitdaysaftertrigger > 0 then DO NOT send notification, so update the NotifyUserFlag =0. If current-date=trigger-event-date and waitdaysaftertrigger <= 0 then DO send notification. (cases (A)when notification is to be sent -N days before trigger-event-date until current-date approaches trigger-event-date and (B)when notification is to be sent N days after trigger-event-date)
										( (CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR (11)) AS DATETIME) > CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME)) AND
										  ( (FinalNotificationParams.WaitDaysAfterTriggerEvent < 0) OR --When current-date > trigger-date then DO NOT send notification in case when waitdaysaftertrigger indicate that event-date is post-dated and notification is to be sent from -N days before event-date and till event-date is reached. Notification should NOT be sent when current-date > event-date
											((FinalNotificationParams.WaitDaysAfterTriggerEvent >= 0) AND (DATEDIFF(DAY, CAST(CAST(FinalNotificationParams.TriggerEventDate AS VARCHAR(11)) AS DATETIME), CAST(CAST(dbo.uf_com_GetServerDate() AS VARCHAR(11)) AS DATETIME) ) ) < FinalNotificationParams.WaitDaysAfterTriggerEvent) --If current-date > trigger-event-date then DO NOT send notification when difference between trigger-event-date and current-date is < waitdaysaftertrigger (case when notification is to be sent N days after trigger-event-date)
										  )
										)
									) OR
									--When RuleModeNotification is Halted either at global level or at personal level
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
									--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
									(FinalNotificationParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
									--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1) OR
									--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
									(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
									--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
								)
							
							--SELECT @nRuleId AS ForRuleIdAfterUpdate	
							--SELECT * FROM #tmpCOUserWithoutOffset
							
							/*--------------------------------End - Process Rule for CO with events for CO, of category - Auto-----------------------------------*/					
						END
						
					END /*IF(@nRuleCategoryCodeId = @nRuleCategoryCodeIdAuto)*/
					ELSE 
					IF(@nRuleCategoryCodeId = @nRuleCategoryCodeIdManual)
					BEGIN
						/*--------------------------------Start - Process Rule for CO of category - Manual-----------------------------------*/
						print 'Process manual rule for CO here'
						
						--Store CO users for whom the current manual rule is applicable
						INSERT INTO #tmpCOUserWithoutOffset (RuleId, ModeCodeId, CoUserInfoId , TriggerEventLogId, TriggerEventCodeId, TriggerEventDate)
						SELECT CRM.RuleId, CRMMGlobal.ModeCodeId ,CRForUser.UserInfoId, NULL AS TriggerEventLogId, NULL AS TriggerEventCodeId, NULL AS TriggerEventDate
						FROM cmu_CommunicationRuleMaster CRM
						INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser ON CRM.RuleId = CRForUser.RuleId AND CRForUser.UserTypeCodeId = @nUserTypeCodeIdCOUser
						INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
						WHERE CRM.RuleId = @nRuleId
						ORDER BY CRM.RuleId, CRMMGlobal.ModeCodeId, CRForUser.UserInfoId
						
						--SELECT @nRuleId AS ForRuleIdBeforeUpdate
						--SELECT * FROM #tmpCOUserWithoutOffset
						
						--For those CO users to whom current manual rule applies, update the NotifyUserFlag = 0 if the filter conditions match such that the notification are NOT to be sent
						UPDATE #tmpCOUserWithoutOffset
						SET NotifyUserFlag = 0
						--SELECT 
						--COUsrWOOffset.CoUserInfoId, COUsrWOOffset.ModeCodeId, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate() AS CurrDate,
						--DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) AS HOUR_DIFFERENCE--,
						--,NotificationSentCount
						----FinalNotificationParams.* , UsrWOOffset.* 
						FROM
						(
							SELECT CRM.RuleId AS RuleId, COUserWOOffset.ModeCodeId AS ModeCodeId, COUserWOOffset.CoUserInfoId AS CoUserInfoId
							   ,CRMM.ExecFrequencyCodeId AS ExecFrequencyCodeId, /*CRMM.WaitDaysAfterTriggerEvent,*/ CRMM.NotificationLimit AS NotificationLimit,
							   COUserNotifySentCount.NotificationSentCount AS NotificationSentCount, COUserNotifySentCount.LastNotificationSentTS AS LastNotificationSentTS,
							 --COUserWOOffset.TriggerEventLogId, COUserWOOffset.TriggerEventDate, 
							   COUserWOOffset.NotifyUserFlag
							FROM
							(
									SELECT CRM.RuleId, COUserWOOffset.CoUserInfoId, COUserWOOffset.ModeCodeId AS UserWOOffsetModeCodeId, 
									COUNT(NQ.NotificationQueueId) AS NotificationSentCount,
									MAX(NQ.ModifiedOn) AS LastNotificationSentTS
									FROM #tmpCOUserWithoutOffset COUserWOOffset 
									INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND COUserWOOffset.RuleId = CRM.RuleId
									INNER JOIN cmu_CommunicationRuleModeMaster CRMM ON CRM.RuleId = CRMM.RuleId AND COUserWOOffset.RuleId = CRM.RuleId AND CRMM.ModeCodeId = COUserWOOffset.ModeCodeId
									LEFT JOIN cmu_NotificationQueue NQ ON NQ.UserId = COUserWOOffset.CoUserInfoId AND NQ.RuleModeId = CRMM.RuleModeId AND NQ.EventLogId IS NULL
									WHERE CRMM.ModeCodeId IS NULL OR COUserWOOffset.ModeCodeId = CRMM.ModeCodeId
									GROUP BY CRM.RuleId, COUserWOOffset.CoUserInfoId, COUserWOOffset.ModeCodeId
							)COUserNotifySentCount
							INNER JOIN #tmpCOUserWithoutOffset COUserWOOffset
							ON COUserWOOffset.CoUserInfoId = COUserNotifySentCount.CoUserInfoId AND COUserWOOffset.RuleId = COUserNotifySentCount.RuleId AND COUserWOOffset.ModeCodeId = COUserNotifySentCount.UserWOOffsetModeCodeId
							INNER JOIN cmu_CommunicationRuleMaster CRM ON CRM.RuleId = @nRuleId AND CRM.RuleId = COUserWOOffset.RuleId AND CRM.RuleId = COUserNotifySentCount.RuleId
							INNER JOIN cmu_CommunicationRuleModeMaster CRMM 
							ON CRMM.RuleId = CRM.RuleId AND CRMM.RuleId = COUserWOOffset.RuleId AND CRMM.RuleId = COUserNotifySentCount.RuleId AND CRMM.ModeCodeId = COUserNotifySentCount.UserWOOffsetModeCodeId AND CRMM.ModeCodeId = COUserWOOffset.ModeCodeId
						) FinalNotificationParams
						INNER JOIN #tmpCOUserWithoutOffset COUsrWOOffset 
						ON FinalNotificationParams.CoUserInfoId = COUsrWOOffset.CoUserInfoId AND COUsrWOOffset.ModeCodeId = FinalNotificationParams.ModeCodeId AND FinalNotificationParams.RuleId = COUsrWOOffset.RuleId
						WHERE 1=1
						AND FinalNotificationParams.RuleId = @nRuleId
						AND (
							--When RuleModeNotification is Halted either at global level or at personal level
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqHalt) OR 
							--When RuleModeNotification is to be sent Daily and #count(notifications sent) has crossed NotificationLimit (ideally this should handle the case "ExecFrequencyCodeId=Once and NotificationLimit=1")
							(FinalNotificationParams.ExecFrequencyCodeId <> @nModeExecFreqHalt AND NotificationSentCount >= NotificationLimit) OR
							--When RuleModeNotification is to be sent Once and #count(notifications sent) is already >= 1 (this clause is added in case this condition is not handled from above condition, if NotificationLimit is >= 1 when ExecFrequencyCodeId=Once)
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqOnce AND NotificationSentCount >= 1)OR
							--When RuleModeNotification is to be sent Daily and difference between current-date and date-of-last-notification-sent is < 24 hrs
							(FinalNotificationParams.ExecFrequencyCodeId = @nModeExecFreqDaily AND (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24) )
							--TODO Enhancements: Depending upon the ExecFrequencyCodeId value, add more conditions for (FinalNotificationParams.LastNotificationSentTS IS NOT NULL AND DATEDIFF(HOUR, FinalNotificationParams.LastNotificationSentTS, dbo.uf_com_GetServerDate()) < 24), where 24 gets replaced with #days/#hours as per ExecFrequencyCodeId
						)	
						
						--SELECT @nRuleId AS ForRuleIdAfterUpdate	
						--SELECT * FROM #tmpCOUserWithoutOffset
						/*--------------------------------End - Process Rule for CO of category - Manual-----------------------------------*/					
					END
				END
				
			END TRY
			BEGIN CATCH
				print 'into inner catch block : inside loop WHILE(@nCounter <= @nRulesCnt)'
				SET @nSQLErrCode    =  ERROR_NUMBER()
				SET @sSQLErrMessage =  ERROR_MESSAGE()
				INSERT INTO #tmpErrorMessages(RuleId, COUserInfoId, UserInfoId, SQLErrCode, SQLErrMessage) VALUES(@nRuleId, NULL, NULL, @nSQLErrCode, @sSQLErrMessage)
				--SELECT * FROM #tmpErrorMessages;
			END CATCH	
				
		END /*WHILE(@nCounter < @nRulesCnt)*/
		
		print 'Start Populate the Notification Queue table'
		select * from #tmpUserWithoutOffset
		/*----------------------------------------Start - Populate the Notification Queue for Auto and Manual Rules applicable to Insider ----------------------------------------------*/
		--Populate the Notification Queue table with bulk entries for Insider users with NotifyUserFlag = 1 in temporary table #tmpUserWithoutOffset
		INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId, EventLogId, UserId, UserContactInfo, [Subject], Contents, [Signature] , CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT 
		--UsrWOOffset.NotifyUserFlag, UsrWOOffset.RuleId,
		NULL AS CompanyIdentifierCodeId, --CompanyIdentifierCodeId
		CASE WHEN CRMMPersonal.RuleModeId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS RuleModeId,
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS ModeCodeId,
		UsrWOOffset.TriggerEventLogId AS EventLogId, UsrWOOffset.UserInfoId AS UserId, 
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL 
			 THEN 
				CASE WHEN (CRMMGlobal.ModeCodeId <> @nModeCodeIdEmail AND CRMMGlobal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END
			ELSE /*CRMMPersonal.ModeCodeId IS NOT NULL*/
				CASE WHEN (CRMMPersonal.ModeCodeId <> @nModeCodeIdEmail AND CRMMPersonal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END 
		END AS UserContactInfo,
		TM.Subject AS Subject,
		REPLACE(
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
				(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
					(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(REPLACE( REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(TM.Contents,'\r\n','<br />')
						, @sPlaceholderLoginId, ISNULL(UA.LoginID,'')) 
						, @sPlaceholderAppURL, @sAppURLCodeValue +'?code='+ ISNULL(URP.HashCode,''))
						, @sPlaceholderAppURLAnchorTag, '<a target="blank" href="'+@sAppURLCodeValue+'?code='+ISNULL(URP.HashCode,'')+'" >'+@sPlaceholderAppURLAnchorText+'</a>')
						, @sPlaceholderPreClearanceStatus, ISNULL(UsrWOOffset.PreClearStatus ,'') )
						, @sPlaceholderPreClearanceCreateDate, (ISNULL(REPLACE(CONVERT(VARCHAR(20), UsrWOOffset.PreClearDate, 106),' ','/'),'')))
						, @sPlaceholderPreClearanceExpiryDate, (ISNULL(REPLACE(CONVERT(VARCHAR(20), UsrWOOffset.PreClearExpiryDate, 106),' ','/'),'')))
						, @sPlaceholderTradingWindowEventType,ISNULL(UsrWOOffset.TradingWindowEventType,''))
						, @sPlaceholderTradingWindowId,ISNULL(UsrWOOffset.TradingWindowId,''))
						, @sPlaceholderTradingWindowFinancialYear,ISNULL(UsrWOOffset.TradingWindowFinancialYearValue,''))
						, @sPlaceholderTradingWindowFinancialPeriod, ISNULL(UsrWOOffset.TradingWindowFinancialPeriodValue,''))
						, @sPlaceholderTradingWindowCloseDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), UsrWOOffset.TradingWindowCloseDate, 106),' ' ,'/'),''))
						, @sPlaceholderTradingWindowOpenDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), UsrWOOffset.TradingWindowOpenDate, 106),' ','/'),'')) 
						, @sPlaceholderFirstName, ISNULL(UI.FirstName, ISNULL(UI.ContactPerson,'') ) )
						, @sPlaceholderMiddleName, ISNULL(UI.MiddleName, ''))
						, @sPlaceholderLastName, ISNULL(UI.LastName, ''))
						, @sPlaceholderUserID, ISNULL(UI.EmployeeId,'-'))
						, @sPlaceholderCompanyName, ISNULL(CMP.CompanyName, '-'))
						, @sPlaceholderEmailID, ISNULL(UI.EmailId,'-'))
						, @sPlaceholderMobileNumber, ISNULL(UI.MobileNumber, ISNULL(UI.LandLine1,ISNULL(UI.LandLine2,'-'))) )
						, @sPlaceholderGrade, (CASE WHEN UI.GradeId IS NULL THEN ISNULL(UI.GradeText,'-') ELSE (CASE WHEN CCGrade.DisplayCode IS NULL OR CCGrade.DisplayCode = '' THEN CCGrade.CodeName ELSE CCGrade.DisplayCode END) END))
				, @sPlaceholderDepartment, CASE WHEN UI.DepartmentId IS NULL THEN ISNULL(UI.DepartmentText, '-') ELSE (CASE WHEN CCDepartment.DisplayCode IS NULL OR CCDepartment.DisplayCode = '' THEN CCDepartment.CodeName ELSE CCDepartment.DisplayCode END) END)
				, @sPlaceholderLocation, ISNULL(UI.Location, '-'))
				, @sPlaceholderSubDesignation, CASE WHEN UI.SubDesignationId IS NULL THEN ISNULL(UI.SubDesignationText, '-') ELSE (CASE WHEN CCSubDesignation.DisplayCode IS NULL OR CCSubDesignation.DisplayCode = '' THEN CCSubDesignation.CodeName ELSE CCSubDesignation.DisplayCode END) END)
				, @sPlaceholderDesignation, CASE WHEN UI.DesignationId IS NULL THEN ISNULL(UI.DesignationText, '-') ELSE (CASE WHEN CCDesignation.DisplayCode IS NULL OR CCDesignation.DisplayCode = '' THEN CCDesignation.CodeName ELSE CCDesignation.DisplayCode END) END)
				, @sPlaceholderSubCategory, CASE WHEN UI.SubCategory IS NULL THEN ISNULL(UI.SubCategoryText, '-') ELSE (CASE WHEN CCSubCategory.DisplayCode IS NULL OR CCSubCategory.DisplayCode = '' THEN CCSubCategory.CodeName ELSE CCSubCategory.DisplayCode END) END)
				, @sPlaceholderCategory, CASE WHEN UI.Category IS NULL THEN ISNULL(UI.CategoryText, '-') ELSE (CASE WHEN CCCategory.DisplayCode IS NULL OR CCCategory.DisplayCode = '' THEN CCCategory.CodeName ELSE CCCategory.DisplayCode END) END)
				, @sPlaceholderDateOfBecomingInsider, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfBecomingInsider, 106), ' ', '/'), '-'))
				, @sPlaceholderDateOfJoining, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfJoining, 106), ' ', '/'), '-'))
				, @sPlaceholderPan, ISNULL(UI.PAN, '-'))
				, @sPlaceholderPinCode, ISNULL(UI.PinCode, '-'))
				, @sPlaceholderAddress, ISNULL(UI.AddressLine1, '-'))
				, @sPlaceholderCountry, CASE WHEN UI.CountryId IS NULL THEN '-' ELSE (CASE WHEN CCCountry.DisplayCode IS NULL OR CCCountry.DisplayCode = '' THEN CCCountry.CodeName ELSE CCCountry.DisplayCode END) END)
				, @sPlaceholderTradingWindowCloseTime, ISNULL(LTRIM(RIGHT(CONVERT(VARCHAR(20),UsrWOOffset.TradingWindowCloseDate,22),11)), ''))
				, @sPlaceholderTradingWindowOpenTime, ISNULL(LTRIM(RIGHT(CONVERT(VARCHAR(20),UsrWOOffset.TradingWindowOpenDate,22),11)), ''))
			, @sPlaceholderPreClearanceValueOfPropseTrade, ISNULL(CAST(UsrWOOffset.PreClearValueOfProposeTrade as VARCHAR(50)) ,''))
			, @sPlaceholderPreClearanceSecurityToBeTradeQty, ISNULL(CAST(dbo.uf_com_FormatNumberToCurrency(UsrWOOffset.PreClearSecurityToBeTradeQty ,'IND') as VARCHAR(50)) ,''))
			, @sPlaceholderPreClearanceSecurityType, ISNULL(UsrWOOffset.PreClearSecurityType ,''))
			, @sPlaceholderPreClearanceTransactionType, ISNULL(UsrWOOffset.PreClearTransactionType ,''))
			, @sPlaceholderPreClearanceDEMATAccNo, ISNULL(UsrWOOffset.PreClearDEMATAccNo ,''))
			, @sPlaceholderPreClearanceRequestFor, ISNULL(UsrWOOffset.PreClearRequestFor ,''))
			, @sPlaceholderPreClearanceID, ISNULL(UsrWOOffset.PreClearID ,''))
			, @sPlaceholderDisclosureLastSubmissionDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), UsrWOOffset.LastSubmitDate, 106),' ','/'),''))	
		, @sPlaceholderPeriodEndDisclosureDaysToSubmit, ISNULL(UsrWOOffset.PeriodEndDaysRemain, '')
		) AS Contents,
		REPLACE(TM.Signature,'\r\n','<br />') AS Signature,
		TM.CommunicationFrom AS CommunicationFrom,
		1 AS CreatedBy, --CreatedBy
		dbo.uf_com_GetServerDate() AS CreatedOn, --CreatedOn
		1 AS ModifiedBy, --ModifiedBy
		dbo.uf_com_GetServerDate() AS ModifiedOn --ModifiedOn
		FROM #tmpUserWithoutOffset UsrWOOffset
		INNER JOIN usr_UserInfo UI ON UsrWOOffset.UserInfoId = UI.UserInfoId
		INNER JOIN cmu_CommunicationRuleMaster CRM ON UsrWOOffset.RuleId = CRM.RuleId
		INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND UsrWOOffset.RuleId = CRM.RuleId AND UsrWOOffset.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
		LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = UsrWOOffset.UserInfoId -- Get personalized modes for rule
		INNER JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
		INNER JOIN usr_Authentication UA ON UsrWOOffset.UserInfoId = UA.UserInfoID
		LEFT JOIN usr_UserResetPassword URP ON UsrWOOffset.UserInfoId = URP.UserInfoId
		LEFT JOIN rl_CompanyMasterList CMP ON UsrWOOffset.CompanyId = CMP.RlCompanyId
		INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR ON PCLR.CompanyId = CMP.RlCompanyId

		LEFT JOIN com_Code CCGrade ON UI.GradeId = CCGrade.CodeID
		LEFT JOIN com_Code CCCountry ON UI.CountryId = CCCountry.CodeID
		LEFT JOIN com_Code CCCategory ON UI.Category = CCCategory.CodeID
		LEFT JOIN com_Code CCSubCategory ON UI.SubCategory = CCSubCategory.CodeID
		LEFT JOIN com_Code CCDesignation ON UI.DesignationId = CCDesignation.CodeID
		LEFT JOIN com_Code CCSubDesignation ON UI.SubDesignationId = CCSubDesignation.CodeID
		LEFT JOIN com_Code CCDepartment ON UI.DepartmentId = CCDepartment.CodeID
		WHERE NotifyUserFlag = 1 
		ORDER BY UsrWOOffset.RuleId ASC, UsrWOOffset.UserInfoId ASC, UsrWOOffset.ModeCodeId ASC
		
		print 'Added records into NotificationQueue table from temporary table tmpUserWithoutOffset'
		
		--Populate the Notification Queue table with bulk entries for Insider users with NotifyUserFlag = 1 in table #tmpUserPolicyDocumentNotify, to notify about policy document as applicable to insiders
		INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId, EventLogId, UserId, UserContactInfo, [Subject], Contents, [Signature] , CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT 
		--UsrWOOffset.NotifyUserFlag, UsrWOOffset.RuleId,
		NULL AS CompanyIdentifierCodeId,
		CASE WHEN CRMMPersonal.RuleModeId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS RuleModeId,
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS ModeCodeId,
		UserPolicyDocumentNotify.TriggerEventLogId AS EventLogId, UserPolicyDocumentNotify.UserInfoId AS UserId, 
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL 
			 THEN 
				CASE WHEN (CRMMGlobal.ModeCodeId <> @nModeCodeIdEmail AND CRMMGlobal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END
			ELSE /*CRMMPersonal.ModeCodeId IS NOT NULL*/
				CASE WHEN (CRMMPersonal.ModeCodeId <> @nModeCodeIdEmail AND CRMMPersonal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END 
		END AS UserContactInfo,
		REPLACE(TM.Subject, @sPlaceholderPolicyDocumentName, ' ''' + ISNULL(PD.PolicyDocumentName,'') + ''' ') AS Subject,
		
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
			(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TM.Contents,'\r\n','<br />')
				, @sPlaceholderPolicyDocumentName, ' ''' + ISNULL(PD.PolicyDocumentName,'') + ''' ')
				, @sPlaceholderFirstName, ISNULL(UI.FirstName, ISNULL(UI.ContactPerson,'') ))
				, @sPlaceholderMiddleName, ISNULL(UI.MiddleName, ''))
				, @sPlaceholderLastName, ISNULL(UI.LastName, ''))
				, @sPlaceholderLoginId, ISNULL(UA.LoginID,''))
				, @sPlaceholderUserID, ISNULL(UI.EmployeeId,'-'))
				, @sPlaceholderCompanyName, ISNULL('', '-'))
				, @sPlaceholderEmailID, ISNULL(UI.EmailId,'-'))
				, @sPlaceholderMobileNumber, ISNULL(UI.MobileNumber, ISNULL(UI.LandLine1,ISNULL(UI.LandLine2,'-'))) )
				, @sPlaceholderGrade, (CASE WHEN UI.GradeId IS NULL THEN ISNULL(UI.GradeText,'-') ELSE (CASE WHEN CCGrade.DisplayCode IS NULL OR CCGrade.DisplayCode = '' THEN CCGrade.CodeName ELSE CCGrade.DisplayCode END) END))
		, @sPlaceholderPolicyDocumentExpiryDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), PD.ApplicableTo, 106), ' ', '/'), '-'))
		, @sPlaceHolderPolicyDocumentStartDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), PD.ApplicableFrom, 106), ' ', '/'), '-'))
		, @sPlaceHolderPolicyDocumentCreateDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), PD.CreatedOn, 106), ' ', '/'), '-'))
		, @sPlaceholderAppURL, @sAppURLCodeValue +'?code='+ ISNULL(URP.HashCode,''))
		, @sPlaceholderAppURLAnchorTag, '<a target="blank" href="'+@sAppURLCodeValue+'?code='+ISNULL(URP.HashCode,'')+'" >'+@sPlaceholderAppURLAnchorText+'</a>')
		, @sPlaceholderDepartment, CASE WHEN UI.DepartmentId IS NULL THEN ISNULL(UI.DepartmentText, '-') ELSE (CASE WHEN CCDepartment.DisplayCode IS NULL OR CCDepartment.DisplayCode = '' THEN CCDepartment.CodeName ELSE CCDepartment.DisplayCode END) END)
		, @sPlaceholderLocation, ISNULL(UI.Location, '-'))
		, @sPlaceholderSubDesignation, CASE WHEN UI.SubDesignationId IS NULL THEN ISNULL(UI.SubDesignationText, '-') ELSE (CASE WHEN CCSubDesignation.DisplayCode IS NULL OR CCSubDesignation.DisplayCode = '' THEN CCSubDesignation.CodeName ELSE CCSubDesignation.DisplayCode END) END)
		, @sPlaceholderDesignation, CASE WHEN UI.DesignationId IS NULL THEN ISNULL(UI.DesignationText, '-') ELSE (CASE WHEN CCDesignation.DisplayCode IS NULL OR CCDesignation.DisplayCode = '' THEN CCDesignation.CodeName ELSE CCDesignation.DisplayCode END) END)
		, @sPlaceholderSubCategory, CASE WHEN UI.SubCategory IS NULL THEN ISNULL(UI.SubCategoryText, '-') ELSE (CASE WHEN CCSubCategory.DisplayCode IS NULL OR CCSubCategory.DisplayCode = '' THEN CCSubCategory.CodeName ELSE CCSubCategory.DisplayCode END) END)
		, @sPlaceholderCategory, CASE WHEN UI.Category IS NULL THEN ISNULL(UI.CategoryText, '-') ELSE (CASE WHEN CCCategory.DisplayCode IS NULL OR CCCategory.DisplayCode = '' THEN CCCategory.CodeName ELSE CCCategory.DisplayCode END) END)
		, @sPlaceholderDateOfBecomingInsider, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfBecomingInsider, 106), ' ', '/'), '-'))
		, @sPlaceholderDateOfJoining, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfJoining, 106), ' ', '/'), '-'))
		, @sPlaceholderPan, ISNULL(UI.PAN, '-'))
		, @sPlaceholderPinCode, ISNULL(UI.PinCode, '-'))
		, @sPlaceholderAddress, ISNULL(UI.AddressLine1, '-'))
		, @sPlaceholderCountry, CASE WHEN UI.CountryId IS NULL THEN '-' ELSE (CASE WHEN CCCountry.DisplayCode IS NULL OR CCCountry.DisplayCode = '' THEN CCCountry.CodeName ELSE CCCountry.DisplayCode END) END
		) AS Contents,
		REPLACE(TM.Signature,'\r\n','<br />') AS Signature,
		TM.CommunicationFrom AS CommunicationFrom,
		1 AS CreatedBy, --CreatedBy
		dbo.uf_com_GetServerDate() AS CreatedOn, --CreatedOn
		1 AS ModifiedBy, --ModifiedBy
		dbo.uf_com_GetServerDate() AS ModifiedOn --ModifiedOn
		FROM #tmpUserPolicyDocumentNotify UserPolicyDocumentNotify
		INNER JOIN usr_UserInfo UI ON UserPolicyDocumentNotify.UserInfoId = UI.UserInfoId
		INNER JOIN cmu_CommunicationRuleMaster CRM ON UserPolicyDocumentNotify.RuleId = CRM.RuleId
		INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND UserPolicyDocumentNotify.RuleId = CRM.RuleId AND UserPolicyDocumentNotify.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
		LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = UserPolicyDocumentNotify.UserInfoId -- Get personalized modes for rule
		INNER JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
		INNER JOIN rul_PolicyDocument PD ON UserPolicyDocumentNotify.TriggerMapToId = PD.PolicyDocumentId
		INNER JOIN usr_Authentication UA ON UserPolicyDocumentNotify.UserInfoId = UA.UserInfoID
		LEFT JOIN usr_UserResetPassword URP ON UI.UserInfoId = URP.UserInfoId
		--INNER JOIN rl_CompanyMasterList CMP ON UsrWOOffset.CompanyId = CMP.RlCompanyId
		LEFT JOIN com_Code CCGrade ON UI.GradeId = CCGrade.CodeID
		LEFT JOIN com_Code CCCountry ON UI.CountryId = CCCountry.CodeID
		LEFT JOIN com_Code CCCategory ON UI.Category = CCCategory.CodeID
		LEFT JOIN com_Code CCSubCategory ON UI.SubCategory = CCSubCategory.CodeID
		LEFT JOIN com_Code CCDesignation ON UI.DesignationId = CCDesignation.CodeID
		LEFT JOIN com_Code CCSubDesignation ON UI.SubDesignationId = CCSubDesignation.CodeID
		LEFT JOIN com_Code CCDepartment ON UI.DepartmentId = CCDepartment.CodeID
		WHERE NotifyUserFlag = 1 
		ORDER BY UserPolicyDocumentNotify.RuleId ASC, UserPolicyDocumentNotify.UserInfoId ASC, UserPolicyDocumentNotify.TriggerMapToId ASC, UserPolicyDocumentNotify.ModeCodeId ASC

		print 'Added records into NotificationQueue table from temporary table #tmpUserPolicyDocumentNotify'
		
		--For each policy document applicable to user in table #tmpUserPolicyDocumentNotify, if it has corresponding email attachment(s), then add those many entries into table cmu_NotificationDocReference
		IF( EXISTS(SELECT ID FROM #tmpUserPolicyDocumentNotify WHERE NotifyUserFlag = 1 AND ModeCodeId = @nModeCodeIdEmail) )
		BEGIN
			INSERT INTO cmu_NotificationDocReference(NotificationQueueId, CompanyIdentifierCodeId, DocumentName, GUID, DocumentPath, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			SELECT NQ.NotificationQueueId AS NotificationQueueId
			, NULL AS CompanyIdentifierCodeId
			, Doc.DocumentName AS DocumentName
			, Doc.GUID AS GUID
			, Doc.DocumentPath AS DocumentPath
			, 1 AS CreatedBy
			, dbo.uf_com_GetServerDate() AS CreatedOn
			, 1 AS ModifiedBy
			, dbo.uf_com_GetServerDate() AS ModifiedOn
			FROM #tmpUserPolicyDocumentNotify UserPolicyDocumentNotify
			INNER JOIN cmu_NotificationQueue NQ ON NQ.UserId = UserPolicyDocumentNotify.UserInfoId AND NQ.EventLogId = UserPolicyDocumentNotify.TriggerEventLogId AND NQ.ModeCodeId = UserPolicyDocumentNotify.ModeCodeId
			INNER JOIN com_DocumentObjectMapping DocMap ON DocMap.MapToTypeCodeId = @nMapToTypeCodeIdPolicyDocument AND UserPolicyDocumentNotify.TriggerMapToId = DocMap.MapToId AND DocMap.PurposeCodeId = @DocumentPurposeCodeIdEmailAttachment 
			INNER JOIN com_Document Doc ON DocMap.DocumentId = Doc.DocumentId
			WHERE UserPolicyDocumentNotify.NotifyUserFlag = 1 AND UserPolicyDocumentNotify.ModeCodeId = @nModeCodeIdEmail
			ORDER BY UserPolicyDocumentNotify.RuleId ASC, UserPolicyDocumentNotify.UserInfoId ASC, UserPolicyDocumentNotify.TriggerMapToId ASC, Doc.DocumentId ASC
		END
		/*----------------------------------------End - Populate the Notification Queue for Auto and Manual Rules applicable to Insider ----------------------------------------------*/
		
		/*----------------------------------------Start - Populate the Notification Queue for Auto and Manual Rules applicable to CO, where, for Auto rules of CO, the trigger-offset events are applicable to same CO users ----------------------------------------------*/
		--Populate the Notification Queue table with bulk entries for CO users with NotifyUserFlag = 1 in temporary table #tmpCOUserWithoutOffset
		INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId, EventLogId, UserId, UserContactInfo, [Subject], Contents, [Signature] , CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT 
		--UsrWOOffset.NotifyUserFlag, UsrWOOffset.RuleId,
		NULL AS CompanyIdentifierCodeId, --CompanyIdentifierCodeId
		CASE WHEN CRMMPersonal.RuleModeId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS RuleModeId,
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS ModeCodeId,
		COUsrWOOffset.TriggerEventLogId AS EventLogId, COUsrWOOffset.CoUserInfoId AS UserId, 
		CASE WHEN CRMMPersonal.ModeCodeId IS NULL 
			 THEN 
				CASE WHEN (CRMMGlobal.ModeCodeId <> @nModeCodeIdEmail AND CRMMGlobal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END
			ELSE /*CRMMPersonal.ModeCodeId IS NOT NULL*/
				CASE WHEN (CRMMPersonal.ModeCodeId <> @nModeCodeIdEmail AND CRMMPersonal.ModeCodeId <> @nModeCodeIdSMS) 
				THEN NULL ELSE 
					CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdEmail 
						 THEN UI.EmailId 
						 ELSE CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
						 END
				END 
		END AS UserContactInfo,
		REPLACE(REPLACE(TM.Subject, @sPlaceholderPolicyDocumentName, ' '''+ ISNULL(PD.PolicyDocumentName,'') + ''' ') 
				, @sPlaceholderTradingPolicyName, ' '''+ ISNULL(TP.TradingPolicyName,'') + ''' ') AS Subject,
				
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
			(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(TM.Contents,'\r\n','<br />')
				, @sPlaceholderLoginId, ISNULL(UA.LoginID,''))
				, @sPlaceholderAppURL, @sAppURLCodeValue +'?code='+ ISNULL(URP.HashCode,''))
				, @sPlaceholderAppURLAnchorTag, '<a target="blank" href="'+@sAppURLCodeValue+'?code='+ISNULL(URP.HashCode,'')+'" >'+@sPlaceholderAppURLAnchorText+'</a>')
				, @sPlaceholderPolicyDocumentName, (' ''' + ISNULL(PD.PolicyDocumentName,'') + ''' ') )
				, @sPlaceholderPolicyDocumentExpiryDate, ISNULL(REPLACE(CONVERT(NVARCHAR(20), PD.ApplicableTo, 106),' ','/'),'') )
				, @sPlaceholderTradingWindowEventType,ISNULL(COUsrWOOffset.TradingWindowEventType,''))
				, @sPlaceholderTradingWindowId,ISNULL(COUsrWOOffset.TradingWindowId,''))
				, @sPlaceholderTradingWindowFinancialYear,ISNULL(COUsrWOOffset.TradingWindowFinancialYearValue,''))
				, @sPlaceholderTradingWindowFinancialPeriod, ISNULL(COUsrWOOffset.TradingWindowFinancialPeriodValue,''))
				, @sPlaceholderTradingWindowCloseDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), COUsrWOOffset.TradingWindowCloseDate, 106),' ' ,'/'),''))
				, @sPlaceholderTradingWindowOpenDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), COUsrWOOffset.TradingWindowOpenDate, 106),' ' ,'/'),''))
				, @sPlaceholderTradingPolicyName, ' '''+ ISNULL(TP.TradingPolicyName,'') + ''' ')
				, @sPlaceholderTradingPolicyExpiryDate, ISNULL(REPLACE(CONVERT(NVARCHAR(20), TP.ApplicableToDate, 106),' ','/'),''))
				, @sPlaceholderFirstName, ISNULL(UI.FirstName, ISNULL(UI.ContactPerson,'') ))
				, @sPlaceholderMiddleName, ISNULL(UI.MiddleName, ''))
				, @sPlaceholderLastName, ISNULL(UI.LastName, ''))
				, @sPlaceholderUserID, ISNULL(UI.EmployeeId,'-'))
				, @sPlaceholderCompanyName, ISNULL(CMP.CompanyName, '-'))
				, @sPlaceholderEmailID, ISNULL(UI.EmailId,'-'))
				, @sPlaceholderMobileNumber, ISNULL(UI.MobileNumber, ISNULL(UI.LandLine1,ISNULL(UI.LandLine2,'-'))) )
				, @sPlaceholderGrade, (CASE WHEN UI.GradeId IS NULL THEN ISNULL(UI.GradeText,'-') ELSE (CASE WHEN CCGrade.DisplayCode IS NULL OR CCGrade.DisplayCode = '' THEN CCGrade.CodeName ELSE CCGrade.DisplayCode END) END))
		, @sPlaceHolderPolicyDocumentStartDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), PD.ApplicableFrom, 106), ' ', '/'), '-'))
		, @sPlaceHolderPolicyDocumentCreateDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), PD.CreatedOn, 106), ' ', '/'), '-'))
		, @sPlaceholderDepartment, CASE WHEN UI.DepartmentId IS NULL THEN ISNULL(UI.DepartmentText, '-') ELSE (CASE WHEN CCDepartment.DisplayCode IS NULL OR CCDepartment.DisplayCode = '' THEN CCDepartment.CodeName ELSE CCDepartment.DisplayCode END) END)
		, @sPlaceholderLocation, ISNULL(UI.Location, '-'))
		, @sPlaceholderSubDesignation, CASE WHEN UI.SubDesignationId IS NULL THEN ISNULL(UI.SubDesignationText, '-') ELSE (CASE WHEN CCSubDesignation.DisplayCode IS NULL OR CCSubDesignation.DisplayCode = '' THEN CCSubDesignation.CodeName ELSE CCSubDesignation.DisplayCode END) END)
		, @sPlaceholderDesignation, CASE WHEN UI.DesignationId IS NULL THEN ISNULL(UI.DesignationText, '-') ELSE (CASE WHEN CCDesignation.DisplayCode IS NULL OR CCDesignation.DisplayCode = '' THEN CCDesignation.CodeName ELSE CCDesignation.DisplayCode END) END)
		, @sPlaceholderSubCategory, CASE WHEN UI.SubCategory IS NULL THEN ISNULL(UI.SubCategoryText, '-') ELSE (CASE WHEN CCSubCategory.DisplayCode IS NULL OR CCSubCategory.DisplayCode = '' THEN CCSubCategory.CodeName ELSE CCSubCategory.DisplayCode END) END)
		, @sPlaceholderCategory, CASE WHEN UI.Category IS NULL THEN ISNULL(UI.CategoryText, '-') ELSE (CASE WHEN CCCategory.DisplayCode IS NULL OR CCCategory.DisplayCode = '' THEN CCCategory.CodeName ELSE CCCategory.DisplayCode END) END)
		, @sPlaceholderDateOfBecomingInsider, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfBecomingInsider, 106), ' ', '/'), '-'))
		, @sPlaceholderDateOfJoining, ISNULL(REPLACE(CONVERT(VARCHAR(20), UI.DateOfJoining, 106), ' ', '/'), '-'))
		, @sPlaceholderPan, ISNULL(UI.PAN, '-'))
		, @sPlaceholderPinCode, ISNULL(UI.PinCode, '-'))
		, @sPlaceholderAddress, ISNULL(UI.AddressLine1, '-'))
		, @sPlaceholderCountry, CASE WHEN UI.CountryId IS NULL THEN '-' ELSE (CASE WHEN CCCountry.DisplayCode IS NULL OR CCCountry.DisplayCode = '' THEN CCCountry.CodeName ELSE CCCountry.DisplayCode END) END)
		, @sPlaceholderTradingWindowOpenTime, ISNULL(LTRIM(RIGHT(CONVERT(VARCHAR(20),COUsrWOOffset.TradingWindowOpenDate,22),11)), ''))
		, @sPlaceholderTradingWindowCloseTime, ISNULL(LTRIM(RIGHT(CONVERT(VARCHAR(20),COUsrWOOffset.TradingWindowCloseDate,22),11)), ''))
		, @sPlaceHolderTradingPolicyStartDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), TP.ApplicableFromDate, 106), ' ', '/'), '-'))
		, @sPlaceHolderTradingPolicyCreateDate, ISNULL(REPLACE(CONVERT(VARCHAR(20), TP.CreatedOn, 106), ' ', '/'), '-')
		)
		AS Contents,
		REPLACE(TM.Signature,'\r\n','<br />') AS Signature,
		TM.CommunicationFrom AS CommunicationFrom,
		1 AS CreatedBy, --CreatedBy
		dbo.uf_com_GetServerDate() AS CreatedOn, --CreatedOn
		1 AS ModifiedBy, --ModifiedBy
		dbo.uf_com_GetServerDate() AS ModifiedOn --ModifiedOn
		FROM #tmpCOUserWithoutOffset COUsrWOOffset
		INNER JOIN usr_UserInfo UI ON COUsrWOOffset.CoUserInfoId = UI.UserInfoId
		INNER JOIN cmu_CommunicationRuleMaster CRM ON COUsrWOOffset.RuleId = CRM.RuleId
		INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND COUsrWOOffset.RuleId = CRM.RuleId AND COUsrWOOffset.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
		LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = COUsrWOOffset.CoUserInfoId -- Get personalized modes for rule
		INNER JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
		INNER JOIN usr_Authentication UA ON COUsrWOOffset.CoUserInfoId = UA.UserInfoID
		LEFT JOIN usr_UserResetPassword URP ON COUsrWOOffset.CoUserInfoId = URP.UserInfoId 
		LEFT JOIN rul_PolicyDocument PD ON PD.PolicyDocumentId = COUsrWOOffset.TriggerMapToId AND COUsrWOOffset.TriggerMapToTypeCodeId = @nMapToTypeCodeIdPolicyDocument AND COUsrWOOffset.TriggerEventCodeId = @nPolicyDocumentExpiryEventCodeID
		LEFT JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = COUsrWOOffset.TriggerMapToId AND COUsrWOOffset.TriggerMapToTypeCodeId = @nMapToTypeCodeIdTradingPolicy AND COUsrWOOffset.TriggerEventCodeId = @nTradingPolicyExpiryEventCodeID
		LEFT JOIN rl_CompanyMasterList CMP ON COUsrWOOffset.CompanyId = CMP.RlCompanyId
		INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PCLR ON PCLR.CompanyId = CMP.RlCompanyId
		LEFT JOIN com_Code CCGrade ON UI.GradeId = CCGrade.CodeID
		LEFT JOIN com_Code CCCountry ON UI.CountryId = CCCountry.CodeID
		LEFT JOIN com_Code CCCategory ON UI.Category = CCCategory.CodeID
		LEFT JOIN com_Code CCSubCategory ON UI.SubCategory = CCSubCategory.CodeID
		LEFT JOIN com_Code CCDesignation ON UI.DesignationId = CCDesignation.CodeID
		LEFT JOIN com_Code CCSubDesignation ON UI.SubDesignationId = CCSubDesignation.CodeID
		LEFT JOIN com_Code CCDepartment ON UI.DepartmentId = CCDepartment.CodeID
		WHERE NotifyUserFlag = 1 
		ORDER BY COUsrWOOffset.RuleId ASC, COUsrWOOffset.CoUserInfoId ASC, COUsrWOOffset.ModeCodeId ASC
		/*----------------------------------------End - Populate the Notification Queue for Auto and Manual Rules applicable to CO, where, for Auto rules of CO, the trigger-offset events are applicable to same CO users ----------------------------------------------*/
		
		/*----------------------------------------Start - Populate the Notification Queue and NotificationQueueParameters and for Auto Rules applicable to CO, where events are applicable to Insiders ----------------------------------------------*/
		SELECT @nCOUserToNotifyCount = COUNT(ID) FROM #tmpCOUserToNotify
		--SELECT @nCOUserToNotifyCount
		
		WHILE(@nCOUserToNotifyCounter < @nCOUserToNotifyCount)
		BEGIN
			BEGIN TRY
				SELECT @nCOUserToNotifyCounter = @nCOUserToNotifyCounter + 1
				
				--If for the combination Rule--RuleMode--COUser in #tmpCOUserToNotify, the flag NotifyUserFlag = 1 then, 
				--check if for the same combination in table #tmpCOUserToNotifyEventBased, there exist combination Rule--RuleMode--COUser--UserInfoId--EventLogId with NotifyUserFlag=1
				--If such record(s) found then, insert new record to NotificationQueue. Get the newly inserted Id of NotificationQueue. 
				--For this new NotificationQueueId, add the set with combination Rule--RuleMode--COUser--UserInfoId--EventLogId to NotificationQueueParameters
				IF(EXISTS(SELECT ID FROM #tmpCOUserToNotify WHERE ID = @nCOUserToNotifyCounter AND NotifyUserFlag = 1))
				BEGIN
					SELECT @nRuleId=RuleId, @nModeCodeId=ModeCodeId, @nCOUserInfoId=COUserInfoId FROM #tmpCOUserToNotify WHERE ID = @nCOUserToNotifyCounter AND NotifyUserFlag = 1
					--check if for the combination Rule--RuleMode--COUser in table #tmpCOUserToNotifyEventBased, there exist combination Rule--RuleMode--COUser--UserInfoId--EventLogId with NotifyUserFlag=1
					IF(EXISTS(SELECT ID FROM #tmpCOUserToNotifyEventBased WHERE RuleId =@nRuleId AND ModeCodeId=@nModeCodeId AND COUserInfoId=@nCOUserInfoId AND NotifyUserFlag = 1))
					BEGIN
					
					---------------------Start - Generate SQL Error----------------------
					--IF(@nRuleId = 4)
					--BEGIN
					--	print 'RULE WITH ERROR:' + CAST(@nRuleId AS VARCHAR(10))
					--	INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId, EventLogId, UserId, UserContactInfo, Subject, Contents, Signature, CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
					--	VALUES(NULL,0,0,0,0,'ashashree@S-C.com','test generate err-subj','test generate err-content', 'test generate err-signt', 'test generate err-comm from', 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())
					--END
					---------------------End - Generate SQL Error----------------------
					
					
						--SELECT 'Insert data for Rule -' + CAST(@nRuleId AS VARCHAR)+ '-ModeCode-'+CAST(@nModeCodeId AS VARCHAR)+ '-COUser-'+CAST(@nCOUserInfoId AS VARCHAR)
						
						--Fetch the template associated with the Global RuleMode associated with current @nRuleId and @nModeCodeId
						SELECT @sTemplateContents = ''
						SELECT @sTemplateContents = Contents
						FROM #tmpCOUserToNotify COUserToNotify
						INNER JOIN cmu_CommunicationRuleMaster CRM ON COUserToNotify.RuleId = CRM.RuleId
						INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND COUserToNotify.RuleId = CRM.RuleId AND COUserToNotify.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
						INNER JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
						WHERE COUserToNotify.RuleId = @nRuleId AND COUserToNotify.COUserInfoId = @nCOUserInfoId AND COUserToNotify.ModeCodeId = @nModeCodeId
						--SELECT @sTemplateContents AS TemplateContents

						CREATE TABLE #tmpUserListNotificationQueueParams(ID INT IDENTITY(1,1),
														 RuleId	INT,
														 ModeCodeId INT,
														 COUserInfoId INT,
														 UserInfoId INT,
														 EmployeeId NVARCHAR(50),
														 Username NVARCHAR(150),
														 EmailId NVARCHAR(250),
														 MobileNumber NVARCHAR(15),
														 CountOfOccurences INT,
														 NotifyUserFlag BIT DEFAULT 1
														)
						
						INSERT INTO #tmpUserListNotificationQueueParams(RuleId, ModeCodeId, COUserInfoId, UserInfoId
									,EmployeeId, Username, EmailId, MobileNumber , CountOfOccurences, NotifyUserFlag)
						SELECT  DISTINCT T.RuleId, T.ModeCodeId, T.COUserInfoId ,T.UserInfoId, T.EmployeeId, T.UserName, T.EmailId, T.MobileNumber ,COUNT(T.UserInfoId) AS CountOfOccurences, T.NotifyUserFlag
						FROM
						(
							SELECT  DISTINCT COUserToNotifyEventBased.RuleId, COUserToNotifyEventBased.ModeCodeId, COUserToNotifyEventBased.COUserInfoId ,COUserToNotifyEventBased.UserInfoId 
									,ISNULL(UI.EmployeeId,'') AS EmployeeId, ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS UserName
									,ISNULL(UI.EmailId,'') AS EmailId, ISNULL(UI.MobileNumber,'') AS MobileNumber ,NotifyUserFlag, COUserToNotifyEventBased.TriggerEventLogId
							FROM #tmpCOUserToNotifyEventBased COUserToNotifyEventBased
							INNER JOIN usr_UserInfo UI ON COUserToNotifyEventBased.UserInfoId = UI.UserInfoId
							WHERE RuleId = @nRuleId AND ModeCodeId = @nModeCodeId AND COUserInfoId = @nCOUserInfoId AND NotifyUserFlag = 1
							--ORDER BY COUserToNotifyEventBased.RuleId ASC, COUserToNotifyEventBased.COUserInfoId ASC, COUserToNotifyEventBased.ModeCodeId ASC, COUserToNotifyEventBased.UserInfoId ASC	
						) T
						GROUP BY T.RuleId, T.ModeCodeId, T.COUserInfoId ,T.UserInfoId, T.EmployeeId, T.UserName ,T.EmailId, T.MobileNumber ,T.NotifyUserFlag 
						ORDER BY T.RuleId ASC, T.COUserInfoId ASC, T.ModeCodeId ASC, T.UserInfoId ASC			

						--SELECT * FROM #tmpUserListNotificationQueueParams
						--Construct the HTMLContent with user list as the content, if the @nModeCodeId=156002(Email)
						SELECT @sHTMLContent = ''
						IF(@nModeCodeId = @nModeCodeIdEmail)
						BEGIN
							SELECT @sHTMLContent = '<br />'
							SELECT @sHTMLContent = @sHTMLContent + '<html><table border=''1'' cellspacing=''2'' cellpadding=''2''>'
							SELECT @sHTMLContent = @sHTMLContent + '<tr>'
							--SELECT @sHTMLContent = @sHTMLContent + '<td>UserInfoId</td>'
							SELECT @sHTMLContent = @sHTMLContent + '<td>EmployeeId</td><td>Username</td><td>Email Address</td><td>Mobile Number</td>'
							--SELECT @sHTMLContent = @sHTMLContent + '<td>Count</td>'
							SELECT @sHTMLContent = @sHTMLContent + '</tr>'
							
							--Loop over #tmpUserListNotificationQueueParams and build the HTML string
							SELECT @nNotificationParamCount = COUNT(RuleId) FROM #tmpUserListNotificationQueueParams
							SELECT @sTempHTMLContent = ''
							SELECT 
								@sTempHTMLContent = STUFF( (SELECT ''+'<tr><td>'+CONVERT(VARCHAR(MAX),ISNULL(EmployeeId,''))+'</td>'+'<td>'+CONVERT(VARCHAR(MAX),ISNULL(Username,''))+'</td>'+'<td>'+CONVERT(VARCHAR(MAX),ISNULL(EmailId,''))+'</td>'+'<td>'+CONVERT(VARCHAR(MAX),ISNULL(MobileNumber,''))+'</td></tr>'
                             FROM #tmpUserListNotificationQueueParams 
                             FOR XML PATH('')), 
                            1, 1, '')
							--Replace the XML encoded characters back
							SELECT @sHTMLContent = @sHTMLContent + REPLACE(REPLACE('&' + @sTempHTMLContent,'&gt;','>'),'&lt;','<')

							--SELECT @nNotificationParamCounter = 0
							--WHILE(@nNotificationParamCounter < @nNotificationParamCount)
							--BEGIN
							--	--print 'process looping here'
							--	SELECT @nNotificationParamCounter = @nNotificationParamCounter + 1
								
							--	SELECT @nUserInfoId=UserInfoId, @sEmployeeId=EmployeeId, @sUsername=Username, @sEmailId=EmailId, 
							--	@sMobileNumber=MobileNumber, @nCountOfOccurences=CountOfOccurences
							--	FROM #tmpUserListNotificationQueueParams 
							--	WHERE RuleId = @nRuleId AND ModeCodeId = @nModeCodeId AND COUserInfoId = @nCOUserInfoId AND ID = @nNotificationParamCounter
							--	SELECT @sHTMLContent = @sHTMLContent + '<tr>'
							--	--SELECT @sHTMLContent = @sHTMLContent + '<td>' + CAST(@nUserInfoId AS VARCHAR(20)) +'</td>'
							--	SELECT @sHTMLContent = @sHTMLContent + '<td>' + @sEmployeeId +'</td>'
							--	SELECT @sHTMLContent = @sHTMLContent + '<td>' + @sUsername +'</td>'
							--	SELECT @sHTMLContent = @sHTMLContent + '<td>' + @sEmailId +'</td>'
							--	SELECT @sHTMLContent = @sHTMLContent + '<td>' + @sMobileNumber +'</td>'
							--	--SELECT @sHTMLContent = @sHTMLContent + '<td>' + CAST(@nCountOfOccurences AS VARCHAR(20)) +'</td>'
							--	SELECT @sHTMLContent = @sHTMLContent + '</tr>'
								
							--END
							
							SELECT  @sHTMLContent = @sHTMLContent + '</table></html>'
						END
						
						--Construct the Email content as Template.Contents + HTMLContent 
						SELECT @sNotificationContents = ''
						SELECT @sNotificationContents = @sTemplateContents + @sHTMLContent
						
						--insert new record to NotificationQueue
						INSERT INTO cmu_NotificationQueue(CompanyIdentifierCodeId, RuleModeId, ModeCodeId ,EventLogId, UserId, UserContactInfo, [Subject], Contents, [Signature], CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						SELECT 
						--UsrWOOffset.NotifyUserFlag, UsrWOOffset.RuleId,
						NULL AS CompanyIdentifierCodeId
						,CASE WHEN CRMMPersonal.RuleModeId IS NULL THEN CRMMGlobal.RuleModeId ELSE CRMMPersonal.RuleModeId END AS RuleModeId
						,CASE WHEN CRMMPersonal.ModeCodeId IS NULL THEN CRMMGlobal.ModeCodeId ELSE CRMMPersonal.ModeCodeId END AS ModeCodeId
						,NULL AS EventLogId, COUserToNotify.COUserInfoId AS UserId 
						,CASE WHEN CRMMPersonal.ModeCodeId IS NULL 
							 THEN 
								CASE WHEN (CRMMGlobal.ModeCodeId <> @nModeCodeIdEmail AND CRMMGlobal.ModeCodeId <> @nModeCodeIdSMS) 
								THEN NULL ELSE 
									CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdEmail 
										 THEN UI.EmailId 
										 ELSE CASE WHEN CRMMGlobal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
										 END
								END
							ELSE /*CRMMPersonal.ModeCodeId IS NOT NULL*/
								CASE WHEN (CRMMPersonal.ModeCodeId <> @nModeCodeIdEmail AND CRMMPersonal.ModeCodeId <> @nModeCodeIdSMS) 
								THEN NULL ELSE 
									CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdEmail 
										 THEN UI.EmailId 
										 ELSE CASE WHEN CRMMPersonal.ModeCodeId = @nModeCodeIdSMS THEN UI.MobileNumber ELSE NULL END 
										 END
								END 
						END AS UserContactInfo
						,TM.Subject AS Subject
						, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@sNotificationContents,'\r\n','<br />')
						, @sPlaceholderLoginId, ISNULL(UA.LoginID,''))
						, @sPlaceholderAppURL, @sAppURLCodeValue +'?code='+ ISNULL(URP.HashCode,''))
						, @sPlaceholderAppURLAnchorTag, '<a target="blank" href="'+@sAppURLCodeValue+'?code='+ISNULL(URP.HashCode,'')+'" >'+@sPlaceholderAppURLAnchorText+'</a>')
						, @sPlaceholderFirstName, ISNULL(UI.FirstName, ISNULL(UI.ContactPerson,'') ))
						, @sPlaceholderMiddleName, ISNULL(UI.MiddleName, ''))
						, @sPlaceholderLastName, ISNULL(UI.LastName, ''))
						, @sPlaceholderUserID, ISNULL(UI.EmployeeId,'-'))
						, @sPlaceholderCompanyName, ISNULL('', '-'))
						, @sPlaceholderEmailID, ISNULL(UI.EmailId,'-'))
						, @sPlaceholderMobileNumber, ISNULL(UI.MobileNumber, ISNULL(UI.LandLine1,ISNULL(UI.LandLine2,'-'))) )
						, @sPlaceholderGrade, (CASE WHEN UI.GradeId IS NULL THEN ISNULL(UI.GradeText,'-') ELSE (CASE WHEN CCGrade.DisplayCode IS NULL OR CCGrade.DisplayCode = '' THEN CCGrade.CodeName ELSE CCGrade.DisplayCode END) END)
						) AS Contents
						,REPLACE(TM.Signature,'\r\n','<br />') AS Signature
						,TM.CommunicationFrom AS CommunicationFrom
						,1 AS CreatedBy --CreatedBy
						,dbo.uf_com_GetServerDate() AS CreatedOn --CreatedOn
						,1 AS ModifiedBy --ModifiedBy
						,dbo.uf_com_GetServerDate() AS ModifiedOn --ModifiedOn
						FROM #tmpCOUserToNotify COUserToNotify
						INNER JOIN usr_UserInfo UI ON COUserToNotify.COUserInfoId = UI.UserInfoId
						INNER JOIN cmu_CommunicationRuleMaster CRM ON COUserToNotify.RuleId = CRM.RuleId
						INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal ON CRM.RuleId = CRMMGlobal.RuleId AND COUserToNotify.RuleId = CRM.RuleId AND COUserToNotify.ModeCodeId = CRMMGlobal.ModeCodeId AND CRMMGlobal.UserId IS NULL --Get global modes for rule
						LEFT JOIN cmu_CommunicationRuleModeMaster CRMMPersonal ON CRMMGlobal.RuleId = CRMMPersonal.RuleId AND CRMMGlobal.ModeCodeId = CRMMPersonal.ModeCodeId AND CRMMPersonal.UserId = COUserToNotify.COUserInfoId -- Get personalized modes for rule
						INNER JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
						INNER JOIN usr_Authentication UA ON COUserToNotify.COUserInfoId = UA.UserInfoID
						LEFT JOIN usr_UserResetPassword URP ON COUserToNotify.COUserInfoId = URP.UserInfoId 
						--INNER JOIN rl_CompanyMasterList CMP ON COUserToNotify.CompanyId = CMP.RlCompanyId
						LEFT JOIN com_Code CCGrade ON UI.GradeId = CCGrade.CodeID
						WHERE COUserToNotify.NotifyUserFlag = 1 AND COUserToNotify.RuleId = @nRuleId AND COUserToNotify.COUserInfoId = @nCOUserInfoId AND COUserToNotify.ModeCodeId = @nModeCodeId
						ORDER BY COUserToNotify.RuleId ASC, COUserToNotify.COUserInfoId ASC, COUserToNotify.ModeCodeId ASC
						
						--Get the newly inserted Id of NotificationQueue
						SELECT @nNotificationQueueId = SCOPE_IDENTITY()
						
						--For this new NotificationQueueId, add the set with combination Rule--RuleMode--COUser--UserInfoId--EventLogId to NotificationQueueParameters
						INSERT INTO cmu_NotificationQueueParameters(NotificationQueueId, EventLogId, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						SELECT @nNotificationQueueId AS NotificationQueueId
						,TriggerEventLogId AS EventLogId
						,UserInfoId
						,TriggerMapToTypeCodeId AS MapToTypeCodeId
						,TriggerMapToId AS MapToId
						,1 AS CreatedBy--CreatedBy
						,dbo.uf_com_GetServerDate() AS CreatedOn--CreatedOn
						,1 AS ModifiedBy--ModifiedBy
						,dbo.uf_com_GetServerDate() AS ModifiedOn--ModifiedOn
						FROM #tmpCOUserToNotifyEventBased COUserToNotifyEventBased
						WHERE RuleId = @nRuleId AND ModeCodeId = @nModeCodeId AND COUserInfoId = @nCOUserInfoId AND NotifyUserFlag = 1
						ORDER BY RuleId ASC, COUserInfoId ASC, ModeCodeId ASC, UserInfoId ASC
						
						DROP TABLE #tmpUserListNotificationQueueParams --Table for rule applicable to CO
					END
				END
			END TRY
			BEGIN CATCH
				print 'into inner catch block while inserting to Notification Queue: inside loop WHILE(@nCOUserToNotifyCounter < @nCOUserToNotifyCount)'
				SET @nSQLErrCode    =  ERROR_NUMBER()
				SET @sSQLErrMessage =  ERROR_MESSAGE()
				INSERT INTO #tmpErrorMessages(RuleId, COUserInfoId, UserInfoId, SQLErrCode, SQLErrMessage) VALUES(@nRuleId, @nCOUserInfoId, NULL, @nSQLErrCode, @sSQLErrMessage)
				--SELECT * FROM #tmpErrorMessages;
			END CATCH
			
		END /*WHILE(@nCOUserToNotifyCounter < @nCOUserToNotifyCount)*/
		/*----------------------------------------End - Populate the Notification Queue and NotificationQueueParameters for Auto Rules applicable to CO, where events are applicable to Insiders ----------------------------------------------*/
		
		--SELECT * FROM cmu_NotificationQueue ORDER BY NotificationQueueId;
		--SELECT * FROM cmu_NotificationQueueParameters ORDER BY NotificationQueueId;
		--SELECT * FROM cmu_NotificationDocReference ORDER BY NotificationQueueId;
		
		--SELECT * FROM #tmpErrorMessages; -- display SQL errors
		
		--Delete the temporary tables
		DROP TABLE #tmpErrorMessages --Table used to store the error messages
		
		DROP TABLE #tmpCommRule --Table for rule applicable to Insider
		
		DROP TABLE #tmpUserWithoutOffset --Table for rule applicable to Insider
		DROP TABLE #tmpUserPolicyDocumentNotify --Table for Policy Document rule applicable to Insider as per Applicability of policy document
		DROP TABLE #tmpInsiderWithoutOffset --Table for rule applicable to CO
		DROP TABLE #tmpCOUserToNotify --Table for rule applicable to CO
		DROP TABLE #tmpCOUserToNotifyEventBased --Table for rule applicable to CO
		DROP TABLE #tmpCOUserWithoutOffset --Table for rule applicable to CO
		
	END TRY
	
	BEGIN CATCH
		print 'into final catch block'
		print 'Error code: ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' -- Error message : ' + ERROR_MESSAGE() 
				
	END CATCH
	-----------------End - Notification Queue Generator
	-------------- TO REMOVE AFTER PROCEDURE GETS SCHEDULED AS A JOB-----------
	--rollback tran
	-------------- TO REMOVE AFTER PROCEDURE GETS SCHEDULED AS A JOB-----------
END