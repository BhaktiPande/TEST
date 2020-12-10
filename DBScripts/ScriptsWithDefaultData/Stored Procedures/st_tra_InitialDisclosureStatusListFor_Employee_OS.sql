IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialDisclosureStatusListFor_Employee_OS')
DROP PROCEDURE [st_tra_InitialDisclosureStatusListFor_Employee_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_InitialDisclosureStatusForUser1]    Script Date: 4/12/2019 8:30:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[st_tra_InitialDisclosureStatusListFor_Employee_OS] --523
	 @inp_iUserInfoID				INT
	 ,@inp_iUserTypeID				INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_USERINITIALDISCLOSURE_LIST INT = 17008 -- Error occurred while fetching list of listing details for the company.
	DECLARE @ERR_NOPOLICYAPPLICABLE INT = 17013 -- No Policy document is applicable, please contact administrator. Initial disclosures cannot be done without it.

	DECLARE @sPolicyDocumentStatus_Pending VARCHAR(20) = 'dis_btn_17005' -- 'Pending'
	DECLARE @sPolicyDocumentStatus_Viewed VARCHAR(20) = 'dis_btn_17006' -- 'Viewed'
	DECLARE @sPolicyDocumentStatus_Agreed VARCHAR(20) = 'dis_btn_17007' -- 'Agreed'
	DECLARE @sHardCopySoftCopyStatus_Done VARCHAR(20) = 'dis_btn_17009' -- 'Done'
	DECLARE @sInitialDisclosure VARCHAR(50) = 'dis_lbl_17001' -- 'Initial Disclosure'
	DECLARE @sSoftCpByInsider VARCHAR(50) = 'dis_lbl_17002' -- 'Soft Copy Submitted'
	DECLARE @sHardCpByInsider VARCHAR(50) = 'dis_lbl_17003' -- 'Hard Copy Submitted'
	DECLARE @sHardCpByCO VARCHAR(50) = 'dis_lbl_17004' -- 'Hard Copy Submitted To Exchange'
	DECLARE @sNotRquired VARCHAR(50) = 'dis_btn_17334' -- Disclosure not required
	DECLARE @sPolicyDocumentStatus_Uploaded VARCHAR(20) = 'dis_btn_17347' -- 'Uploaded'

	DECLARE @nStatusFlag_Complete INT = 154001
	DECLARE @nStatusFlag_Pending INT = 154002
	DECLARE @nStatusFlag_DoNotShow INT = 154003
	DECLARE @nStatusFlag_NotReq INT = 154007
	
	DECLARE @nWindowStatusCodeId_Active INT = 131002

	DECLARE @nTransactionMasterID INT = 0
	DECLARE @nAllDocumentsCompleteFlag INT = 0
	DECLARE @nInitialDisclosureCompleteFlag INT = 0
	DECLARE @nTradingPolicyId INT
	DECLARE @nHardCpToSubmitFlag INT = 0
	DECLARE @nSoftCpToSubmitFlag INT = 0
	DECLARE @nSEHardCpToSubmitFlag INT = 0
	--DECLARE @nSESoftCpToSubmitFlag INT = 0
	DECLARE @tmpStatusFlag INT = 0
	DECLARE @tmpResourceKey VARCHAR(20) = null
	DECLARE @nEventCode_InitialDiscConfirm INT = 153056
	DECLARE @dtInitialDiscConfirmDate DATETIME
	
	DECLARE  @SCSubmitted INT = NULL
	DECLARE  @HCSubmitted INT = NULL
	
	DECLARE @nEventTypeDocument INT = 0
	DECLARE @nEventTypeDisclosure INT = 1
	DECLARE @nEventTypeSoftCopy INT = 2
	DECLARE @nEventTypeHardCopy INT = 3
	DECLARE @nEventTypeStockExchange INT = 4
	
	DECLARE @ntmpEventCode INT = NULL
	DECLARE @dttmpEventDate DATETIME = NULL
	DECLARE @dtTodayDate	DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
	

	DECLARE @tmpInitialDisclosureTable TABLE(SequenceNumber INT identity(1,1), PolicyDocumentId INT, DocumentId INT,
	EventName NVARCHAR(250), StatusFlag INT, ResourceKey VARCHAR(20),TransactionMasterId INT,
	EventCode INT, EventDate DATETIME, PolicyDocumentView INT, PolicyDocumentAgree INT, EventType INT,IsEnterAndUploadEvent INT DEFAULT 0,UserInfoID INT,UserTypeCodeID INT,ParentUserInfoID INT)

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			DECLARE @iParentID INT
			DECLARE @iUserTypeCodeID INT
			SELECT @iUserTypeCodeID=UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoID
			IF(@iUserTypeCodeID=101007)
			BEGIN
				SELECT @iParentID=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@inp_iUserInfoID
			END
			ELSE
			BEGIN
				SET @iParentID=@inp_iUserInfoID
			END

			SELECT @dtInitialDiscConfirmDate = EventDate 
			FROM eve_EventLog 
			WHERE UserInfoId = @iParentID AND EventCodeId = @nEventCode_InitialDiscConfirm

			DECLARE @dtDateofBecomingInsider DATETIME
			SELECT  @dtDateofBecomingInsider=DateOfBecomingInsider FROM usr_UserInfo WHERE UserInfoId=@iParentID 

		IF EXISTS (SELECT EventLogId FROM eve_EventLog WHERE UserInfoId = @iParentID AND EventCodeId = @nEventCode_InitialDiscConfirm AND @dtInitialDiscConfirmDate <= @dtDateofBecomingInsider)
		BEGIN
			SELECT @dtInitialDiscConfirmDate = EventDate 
			FROM eve_EventLog 
			WHERE UserInfoId = @iParentID AND EventCodeId = @nEventCode_InitialDiscConfirm AND EventDate<=@dtDateofBecomingInsider

			INSERT INTO @tmpInitialDisclosureTable (
				PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT PD.PolicyDocumentId, D.DocumentId, PD.PolicyDocumentName, @nStatusFlag_Complete,
				CASE WHEN EL.EventCodeId = 153028 THEN @sPolicyDocumentStatus_Agreed ELSE @sPolicyDocumentStatus_Viewed END,
				@nTransactionMasterID, EL.EventCodeId, EL.EventDate, PD.DocumentViewFlag, PD.DocumentViewAgreeFlag, @nEventTypeDocument
				
			FROM eve_EventLog EL LEFT JOIN rul_PolicyDocument PD ON EL.UserInfoId = @iParentID AND EL.MapToTypeCodeId = 132001 AND EventCodeId IN (153028, 153027)
				AND EL.EventDate <= @dtInitialDiscConfirmDate 
			    AND EventDate<=@dtDateofBecomingInsider
				AND EL.MapToId = PD.PolicyDocumentId
				JOIN com_DocumentObjectMapping DOM ON EL.MapToTypeCodeId = DOM.MapToTypeCodeId AND PD.PolicyDocumentId = DOM.MapToId AND PurposeCodeId IS NULL
				JOIN com_Document D ON D.DocumentId = DOM.DocumentId
			ORDER BY EL.EventDate DESC
		END
		ELSE
		BEGIN
	
			INSERT INTO @tmpInitialDisclosureTable (
				PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT PD.PolicyDocumentId, D.DocumentId, PD.PolicyDocumentName, 
				CASE WHEN PD.DocumentViewAgreeFlag = 0 AND PD.DocumentViewFlag = 1 THEN @nStatusFlag_Complete 
				ELSE CASE WHEN EL.EventCodeId = 153028 THEN @nStatusFlag_Complete ELSE @nStatusFlag_Pending END END,
				CASE WHEN EL.EventLogId IS NOT NULL THEN 
				CASE WHEN EL.EventCodeId = 153028 THEN @sPolicyDocumentStatus_Agreed 
				    ELSE @sPolicyDocumentStatus_Viewed END 
				ELSE CASE WHEN PD.DocumentViewAgreeFlag = 1 THEN @sPolicyDocumentStatus_Pending ELSE 'com_btn_14008' END END,
				@nTransactionMasterID, EL.EventCodeId, EL.EventDate, PD.DocumentViewFlag, PD.DocumentViewAgreeFlag, @nEventTypeDocument
			FROM vw_ApplicablePolicyDocumentForUser APD JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = APD.ApplicabilityMstId
				JOIN rul_PolicyDocument PD ON AM.MapToId = PD.PolicyDocumentId
				LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToTypeCodeId = AM.MapToTypeCodeId AND AM.MapToId = DOM.MapToId AND PurposeCodeId IS NULL
				LEFT JOIN com_Document D ON D.DocumentId = DOM.DocumentId
				LEFT JOIN eve_EventLog EL ON EL.UserInfoId = @iParentID AND EL.MapToTypeCodeId = AM.MapToTypeCodeId AND EL.MapToId = AM.MapToId
					AND ((PD.DocumentViewAgreeFlag = 1 AND EL.EventCodeId = 153028) OR (PD.DocumentViewAgreeFlag = 0 AND PD.DocumentViewFlag = 1 AND EL.EventCodeId = 153027))
			WHERE APD.UserInfoId = @iParentID
				AND WindowStatusCodeId = @nWindowStatusCodeId_Active
				AND (@dtTodayDate >= PD.ApplicableFrom AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= @dtTodayDate))
			ORDER BY EL.EventDate DESC
		END	
	
		IF NOT EXISTS(SELECT * FROM @tmpInitialDisclosureTable) AND @dtInitialDiscConfirmDate IS NULL
		BEGIN
		
			SET @out_nReturnValue = @ERR_NOPOLICYAPPLICABLE
			RETURN @out_nReturnValue
		END
	
		IF NOT EXISTS (SELECT * FROM @tmpInitialDisclosureTable WHERE PolicyDocumentId IS NOT NULL AND StatusFlag <> @nStatusFlag_Complete)
		BEGIN		
			SET @nAllDocumentsCompleteFlag = @nStatusFlag_Complete
		END

		IF EXISTS (SELECT * FROM eve_EventLog e WHERE EventCodeId IN (153052) AND UserInfoId = @iParentID AND (e.EventDate<=@dtDateofBecomingInsider OR @dtDateofBecomingInsider IS NULL))
		BEGIN
			SET @nAllDocumentsCompleteFlag = @nStatusFlag_Complete
		END

		IF(@inp_iUserTypeID=101001 OR @inp_iUserTypeID=101002)
		BEGIN	
		UPDATE @tmpInitialDisclosureTable SET ResourceKey=NULL,StatusFlag=154003 WHERE StatusFlag=154002
		SET @nAllDocumentsCompleteFlag = @nStatusFlag_Complete
		END
			
		SET @ntmpEventCode = NULL
		SET @dttmpEventDate = NULL
		-----fOR CO USER MAKE THE FLAG TRUE BY DEFAULT
		
		IF @nAllDocumentsCompleteFlag = @nStatusFlag_Complete 
		BEGIN
			IF EXISTS (SELECT * FROM eve_EventLog e WHERE EventCodeId IN (153052) AND UserInfoId = @inp_iUserInfoID AND (e.EventDate<=@dtDateofBecomingInsider OR @dtDateofBecomingInsider IS NULL))
			BEGIN
						
				SET @nInitialDisclosureCompleteFlag = @nStatusFlag_Complete
				SET @tmpResourceKey = @sHardCopySoftCopyStatus_Done
				SELECT @nTransactionMasterID = MapToId, @ntmpEventCode = EventCodeId, @dttmpEventDate = EventDate 
					FROM eve_EventLog WHERE EventCodeId = 153052 and UserInfoId = @inp_iUserInfoID AND (EventDate<=@dtDateofBecomingInsider OR @dtDateofBecomingInsider IS NULL)
			END
			ELSE
			BEGIN	
					
				SET @nInitialDisclosureCompleteFlag = @nStatusFlag_Pending
				SET @tmpResourceKey = @sPolicyDocumentStatus_Pending
				SET @nTransactionMasterID = 0
				IF EXISTS (SELECT * FROM eve_EventLog e WHERE EventCodeId IN (153053) AND UserInfoId = @inp_iUserInfoID AND (e.EventDate<=@dtDateofBecomingInsider OR @dtDateofBecomingInsider IS NULL))
				BEGIN
					SET @tmpResourceKey = @sPolicyDocumentStatus_Uploaded
				END
			END
		END
		ELSE 
		BEGIN
			SET @nInitialDisclosureCompleteFlag = @nStatusFlag_DoNotShow
			SET @tmpResourceKey = null
			SET @nTransactionMasterID = 0
		END

		--SELECT @nAllDocumentsCompleteFlag AllDocumentsCompleteFlag

		INSERT INTO @tmpInitialDisclosureTable(PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
		VALUES(NULL, NULL, @sInitialDisclosure, @nInitialDisclosureCompleteFlag, @tmpResourceKey,@nTransactionMasterID,
				@ntmpEventCode, @dttmpEventDate, NULL, NULL, @nEventTypeDisclosure)
		
		UPDATE Tmp
			SET IsEnterAndUploadEvent = 1
		FROM @tmpInitialDisclosureTable Tmp JOIN
		eve_EventLog EL ON EL.MapToId = Tmp.TransactionMasterId AND EL.MapToTypeCodeId = 132005
		WHERE StatusFlag = 154001 AND EventType = 1 AND EL.EventCodeId = 153053
		
	
		
		SET @ntmpEventCode = NULL
		SET @dttmpEventDate = NULL
		
		--SELECT @nInitialDisclosureCompleteFlag InitialDisclosureCompleteFlag, @nStatusFlag_Complete StatusFlag_Complete
		-- If Initial disclosure is complate, then only show status for hardcopy and softcopy flags
		IF @nInitialDisclosureCompleteFlag <> @nStatusFlag_Complete -- @nStatusFlag_DoNotShow
		BEGIN		  
			--print '@nInitialDisclosureCompleteFlag <> @nStatusFlag_Complete'
			INSERT INTO @tmpInitialDisclosureTable(PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT NULL, NULL, @sSoftCpByInsider, @nStatusFlag_DoNotShow, null, @nTransactionMasterID,
				@ntmpEventCode, @dttmpEventDate, NULL, NULL, @nEventTypeSoftCopy

			INSERT INTO @tmpInitialDisclosureTable(PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT NULL, NULL, @sHardCpByInsider, @nStatusFlag_DoNotShow, null,@nTransactionMasterID,
				@ntmpEventCode, @dttmpEventDate, NULL, NULL, @nEventTypeHardCopy
		END
		ELSE
		BEGIN			
			select @nTradingPolicyId = TradingPolicyId from tra_TransactionMaster where TransactionMasterId = @nTransactionMasterID
			
			SELECT 
				@nSEHardCpToSubmitFlag = DiscloInitSubmitToStExByCOHardcopyFlag,
				@nHardCpToSubmitFlag = DiscloInitReqHardcopyFlag, 
				@nSoftCpToSubmitFlag = DiscloInitReqSoftcopyFlag
			FROM rul_TradingPolicy WHERE TradingPolicyId = @nTradingPolicyId
			
			print '@nTradingPolicyId = ' + convert(varchar(10), @nTradingPolicyId)
			print 'SEHardCpToSubmitFlag = ' + convert(varchar(10), @nSEHardCpToSubmitFlag)
			print 'HardCpToSubmitFlag = ' + convert(varchar(10), @nHardCpToSubmitFlag)
			print 'SoftCpToSubmitFlag = ' + convert(varchar(10), @nSoftCpToSubmitFlag)
			
		
			
			/*********** Check for SoftCopy flag ****************/
			SET @tmpStatusFlag = @nStatusFlag_DoNotShow
			SET @tmpResourceKey = null
			SET @ntmpEventCode = NULL
			SET @dttmpEventDate = NULL
			
			IF @nSoftCpToSubmitFlag = 1
			BEGIN
				SET @tmpStatusFlag = @nStatusFlag_Pending
				SET @tmpResourceKey = @sPolicyDocumentStatus_Pending

				IF EXISTS (SELECT * FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153054 AND (EventDate<=@dtDateofBecomingInsider OR @dtDateofBecomingInsider IS NULL))
				BEGIN
					SET @tmpStatusFlag = @nStatusFlag_Complete
					SET @tmpResourceKey = @sHardCopySoftCopyStatus_Done
					SET @SCSubmitted = 1
					SELECT @ntmpEventCode = EventCodeId, @dttmpEventDate = EventDate
						FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153054
				END
			END
			ELSE
			BEGIN
				SET @tmpStatusFlag = @nStatusFlag_NotReq
				SET @tmpResourceKey = @sNotRquired
			END
			
			INSERT INTO @tmpInitialDisclosureTable(PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT NULL, NULL, @sSoftCpByInsider, @tmpStatusFlag, @tmpResourceKey, @nTransactionMasterID, 
				@ntmpEventCode, @dttmpEventDate, NULL, NULL, @nEventTypeSoftCopy
				

			/*********** Check for HardCopy flag ****************/
			SET @tmpStatusFlag = @nStatusFlag_DoNotShow
			SET @tmpResourceKey = null
			SET @ntmpEventCode = NULL
			SET @dttmpEventDate = NULL
			IF (@nHardCpToSubmitFlag = 1)
			BEGIN
				IF((@nSoftCpToSubmitFlag = 1 AND @SCSubmitted = 1) 
				 OR (@nSoftCpToSubmitFlag = NULL OR @nSoftCpToSubmitFlag = 0))
				BEGIN
					SET @tmpStatusFlag = @nStatusFlag_Pending
					SET @tmpResourceKey = @sPolicyDocumentStatus_Pending

					IF EXISTS (SELECT * FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153055)
					BEGIN
						SET @tmpStatusFlag = @nStatusFlag_Complete
						SET @tmpResourceKey = @sHardCopySoftCopyStatus_Done
						SET @HCSubmitted = 1
						SELECT @ntmpEventCode = EventCodeId, @dttmpEventDate = EventDate
							FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153055
					END
				END
			END
			ELSE
			BEGIN
				SET @tmpStatusFlag = @nStatusFlag_NotReq
				SET @tmpResourceKey = @sNotRquired			
			END

			INSERT INTO @tmpInitialDisclosureTable(PolicyDocumentId, DocumentId, EventName, StatusFlag, ResourceKey, TransactionMasterId, 
				EventCode, EventDate, PolicyDocumentView, PolicyDocumentAgree, EventType)
			SELECT NULL, NULL, @sHardCpByInsider, @tmpStatusFlag, @tmpResourceKey, @nTransactionMasterID, 
				@ntmpEventCode, @dttmpEventDate, NULL, NULL, @nEventTypeHardCopy


			/*********** Check for HardCopy by CO flag ****************/
			--SET @tmpStatusFlag = @nStatusFlag_DoNotShow
			--SET @tmpResourceKey = null
			--SET @ntmpEventCode = NULL
			--SET @dttmpEventDate = NULL
			--IF (@nSEHardCpToSubmitFlag = 1)
			--BEGIN
			--	IF ((@nHardCpToSubmitFlag = 1 AND @HCSubmitted = 1)
			--		 OR (@nHardCpToSubmitFlag = 0 AND @SCSubmitted = 1 AND @nSoftCpToSubmitFlag = 1)
			--		 OR (@nHardCpToSubmitFlag=0 AND @nSoftCpToSubmitFlag = 0))
			--	BEGIN	
			--		SET @tmpStatusFlag = @nStatusFlag_Pending
			--		SET @tmpResourceKey = @sPolicyDocumentStatus_Pending

			--		IF EXISTS (SELECT * FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153012)
			--		BEGIN
			--			SET @tmpStatusFlag = @nStatusFlag_Complete
			--			SET @tmpResourceKey = @sHardCopySoftCopyStatus_Done
			--			SELECT @ntmpEventCode = EventCodeId, @dttmpEventDate = EventDate
			--				FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = 153010
			--		END
			--	END
			--END
			--ELSE
			--BEGIN
			--	SET @tmpStatusFlag = @nStatusFlag_NotReq
			--	SET @tmpResourceKey = @sNotRquired			
			--END


		END
		UPDATE Tmp
			SET UserInfoID=@inp_iUserInfoID
		FROM @tmpInitialDisclosureTable Tmp

		UPDATE Tmp SET UserTypeCodeID=UI.UserTypeCodeId
		FROM @tmpInitialDisclosureTable Tmp JOIN usr_UserInfo UI
		ON Tmp.UserInfoID=UI.UserInfoId
		WHERE UI.UserInfoId=@inp_iUserInfoID

		UPDATE Tmp SET ParentUserInfoID=@iParentID
		FROM @tmpInitialDisclosureTable Tmp 
		
		select * from @tmpInitialDisclosureTable 
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USERINITIALDISCLOSURE_LIST
	END CATCH
END

