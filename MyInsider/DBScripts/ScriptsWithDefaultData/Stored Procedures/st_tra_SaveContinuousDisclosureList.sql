IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_SaveContinuousDisclosureList')
DROP PROCEDURE dbo.st_tra_SaveContinuousDisclosureList
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used to insert CD records in tra_ContinuousDisc
Returns:		
				
Created by:		Shubhangi
Created on:		23-October-2018

Usage:
EXEC st_tra_SaveContinuousDisclosureList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_SaveContinuousDisclosureList] 
     @out_nReturnValue						INT = 0				OUTPUT
	,@out_nSQLErrCode						INT = 0				OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @ERR_CONTINOUS_DISCLOSURE_LIST	INT = 17097			-- Error occurred while fetching list of documents for user.
	
	--Declare Constant Variable
	DECLARE @nContinousDisclosureType											INT,
			@nOneValue															INT,
			@nZeroValue															INT,
			
			@nTradingPolicyMapToType											INT,
			@nPreclearanceRequestMapToType										INT,
			@nDisclosureMapToType												INT,
			
			
			@nEventPreclearanceRequested										INT,
			@nEventPreclearanceApproved											INT,
			@nEventPreclearanceRejected											INT,
			@nEventContinuousDisclosureDetailsEntered							INT,
			@nEventContinuousDisclosureUploaded									INT,
			@nEventContinuousDisclosureSubmittedSoftcopy						INT,
			@nEventContinuousDisclosureSubmittedHardcopy						INT,
			@nEventContinuousDisclosureCOSubmittedHardcopyToStockExchange		INT,
			
			@nPreclearanceRequested												INT,
			@nPreclearanceApproved												INT,
			@nPreclearanceRejected												INT,
			
			@nApproveStatus														INT,
			@nPendingStatus														INT,
			@nInProgressStatus													INT,
			@nPartiallyTradedStatus												INT,
			@nNotTradedStatus													INT,
			@nUploadedStatus													INT,
			@nPendingTransType													INT,
			
			@sPrceclearanceCodePrefixText										VARCHAR(3),
			@sNonPrceclearanceCodePrefixText									VARCHAR(3),
			@sPendingButtonText													VARCHAR(10),
			@sInProgressButtonText													VARCHAR(20),
			@sApproveButtonText													VARCHAR(10),
			@sRejectedButtonText												VARCHAR(10),
			@sNotTradedButtonText												VARCHAR(10),
			@sUploadedButtonText												VARCHAR(10),
			@sPartiallyTradedButtonText											VARCHAR(20),
			@sDayLeftText													    VARCHAR(200),
			@sDayOverdueText													VARCHAR(200),
			@sNotRequiredText													VARCHAR(30),
			@nNotTradedStatusButtonText1										VARCHAR(200),
			@nAutoApproveButtonText												VARCHAR(200),
			@nEmployeeStatusLive                                                VARCHAR(100),
			@nEmployeeStatusSeparated                                           VARCHAR(100),
			@nEmployeeStatusInactive                                            VARCHAR(100),
			@nEmpStatusLiveCode                                                 INT = 510001,
			@nEmpStatusSeparatedCode                                            INT = 510002,
			@nEmpStatusInactiveCode                                             INT = 510003,
			@nEmployeeActive                                                    INT = 102001,
			@nEmployeeInActive                                                  INT = 102002,
			@UpdateInProgressStatus												VARCHAR(100)
			
		--	select  @inp_sEmployeeName,@inp_sDesignation, @inp_dtSoftCopySubmissionFromDate,@inp_dtSoftCopySubmissionToDate
			
			--Pending Button Text
			SELECT @sPendingButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'	   
			
		   
			SELECT @sInProgressButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_50443'
			--ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
			
			--Approve Button Text
			SELECT @sApproveButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17023'
			--Reject Button Text
			SELECT @sRejectedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17024'
			--Not Traded Button Text
			SELECT @sNotTradedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17074'
			--Uploaded Button Text
			SELECT @sUploadedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17075'
			--Partially Traded Button Text
			SELECT @sPartiallyTradedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17073'
			-- Days Left Text
			SELECT @sDayLeftText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_lbl_17306'
			-- Days Overdue Text
			SELECT @sDayOverdueText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_lbl_17305'
			-- Not Required Text
			SELECT @sNotRequiredText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17334'
			
			SELECT @nNotTradedStatusButtonText1 = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17349'
			
			SELECT @nAutoApproveButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17386'
			
			SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
			
			SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
			
			SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
			
			
			SET	@nContinousDisclosureType											= 147002
			SET	@nOneValue															= 1
			SET	@nZeroValue															= 0
			
			SET @nTradingPolicyMapToType											= 132002
			SET @nPreclearanceRequestMapToType										= 132004
			SET @nDisclosureMapToType												= 132005
			
			SET @nEventPreclearanceRequested										= 153015
			SET @nEventPreclearanceApproved											= 153016
			SET @nEventPreclearanceRejected											= 153017
			
			SET @nEventContinuousDisclosureDetailsEntered							= 153019
			SET @nEventContinuousDisclosureUploaded									= 153020
			
			SET @nEventContinuousDisclosureSubmittedSoftcopy						= 153021
			SET @nEventContinuousDisclosureSubmittedHardcopy						= 153022
			SET @nEventContinuousDisclosureCOSubmittedHardcopyToStockExchange		= 153024
			
			SET @nPreclearanceRequested												= 144001
			SET @nPreclearanceApproved												= 144002
			SET @nPreclearanceRejected												= 144003
			
			SET @nApproveStatus														 = 154001
			SET @nPendingStatus														 = 154002
			SET @nInProgressStatus													 =154008	
			SET @nPartiallyTradedStatus												 = 154004
			SET @nNotTradedStatus													 = 154005
			SET @nUploadedStatus												     = 154006
			SET @UpdateInProgressStatus												 =0	
			SET @nPendingTransType													 = 148002
			
			DECLARE @nPreclearanceTakenCase INT = 176001
			DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
			DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
			
			SET	@sPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
			SET @sNonPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
			DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)
			DECLARE @nPreclearanceExpire INT = 153018 
			DECLARE @IsDuplicate INT = 0

			DECLARE @nIsPreClearanceEditable INT = 0
			
	BEGIN TRY
		
			SET NOCOUNT ON;
			-- Declare variables
			IF @out_nReturnValue IS NULL
				SET @out_nReturnValue = 0
			IF @out_nSQLErrCode IS NULL
				SET @out_nSQLErrCode = 0
			IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @nIsPreClearanceEditable = IsPreClearanceEditable
		FROM mst_Company WHERE IsImplementing = 1
	

CREATE TABLE #tmpUsers(Id INT IDENTITY(1,1), IsAddButtonRow INT DEFAULT 0,UserInfoId INT,
					   	TransactionMasterID INT,TradingPolicyId INT, PreClearanceRequestID INT,PreclearanceStatus INT,
					   	PreclearanceValidTill DATETIME,PreClearanceRequestCode NVARCHAR(MAX),
					   	ContinuousDisclousureToBeSubmit INT,ContinuousDisclousureCompletion INT default 0,
					   	ContinuousDisclosureSubmissionDate DATETIME, ContinuousDisclosureSubmitWithin	INT,ContinuousDisclosureStatus INT,
					   	SoftCopyToBeSubmitFlag INT, SoftCopySubmissionFlag INT DEFAULT NULL, SoftcopySubmissionDate DATETIME,
					   	HardCopyToBeSubmitFlag INT, HardCopySubmissionFlag INT DEFAULT NULL,HardcopySubmissionDate DATETIME,
					   	HardcopySubmissionwithin INT DEFAULT NULL,
					   	HardCopySubmitCOToExchangeFlag INT,HardCopySubmissionCOToExchangeFlag INT DEFAULT NULL,
					   	HardCopySubmitCOToExchangeDate DATETIME NULL,HardCopySubmitCOToExchangeWithin INT DEFAULT NULL,
					   	TradedQty DECIMAL(10,0),DisplayNumber INT, TMIdForOrder BIGINT,StockExchangeSubmissionTotalQty DECIMAL(10,0),IsEnterAndUploadEvent INT DEFAULT 0, IndividualTradedValue INT)					
/*
	Delete PNT transaction not added in transaction details
*/
DELETE TM
FROM tra_TransactionMaster TM LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToId = TM.TransactionMasterId AND PurposeCodeId = 133003 AND MapToTypeCodeId = 132005
WHERE DisclosureTypeCodeId = @nContinousDisclosureType AND TransactionStatusCodeId = @nPendingTransType 
AND PreclearanceRequestId IS NULL AND TD.TransactionMasterId IS NULL AND DOM.DocumentObjectMapId IS NULL AND TM.CDDuringPE=1

INSERT INTO #tmpUsers(UserInfoId,TransactionMasterID,TradingPolicyId,PreClearanceRequestID,
					  PreClearanceRequestCode,TMIdForOrder,StockExchangeSubmissionTotalQty)  
		  SELECT 
				TM.UserInfoId,
				TM.TransactionMasterId,TradingPolicyId,
				PR.PreclearanceRequestId,
				CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
				CASE WHEN UF1.DateOfBecomingInsider IS NOT NULL THEN
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sNonPrceclearanceCodePrefixText ELSE @sNonPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END  
				ELSE
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceNotRequiredPrefixText ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END
				ELSE 
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceCodePrefixText ELSE  @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END,
				ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId),
				TM.TotalTradeValue					
			FROM 
				tra_TransactionMaster TM
				LEFT JOIN	tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				JOIN usr_UserInfo UF1 ON TM.UserInfoId=UF1.UserInfoId
			WHERE 
			    DisclosureTypeCodeId = @nContinousDisclosureType  
		 				  
		UPDATE tmpUser
		SET TradedQty = TD.Qty
		FROM #tmpUsers tmpUser JOIN 
			(SELECT TM.TransactionMasterId, SUM(TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) Qty
			FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			GROUP BY TM.TransactionMasterId) TD ON tmpUser.TransactionMasterID = TD.TransactionMasterId
		
		UPDATE tmpUser
		SET IndividualTradedValue = TD.TradedValue
		FROM #tmpUsers tmpUser JOIN 
			(SELECT TM.TransactionMasterId, SUM(TD.Value) TradedValue
			FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			GROUP BY TM.TransactionMasterId) TD ON tmpUser.TransactionMasterID = TD.TransactionMasterId	
		     
		/*
			1. Chekck wheather PreClearance Requested/Approved/Rejected By 
			   Checking Entry in EventLog Table.
		*/
		UPDATE T
		SET PreclearanceStatus = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE EL.EventCodeId END
		FROM #tmpUsers T JOIN 
			(SELECT MapToId, MAX(EventLogId) AS EventLogId
			FROM #tmpUsers t1 JOIN eve_EventLog EL ON t1.PreClearanceRequestID = EL.MapToId AND MapToTypeCodeId = @nPreclearanceRequestMapToType
			WHERE EventCodeId in (@nEventPreclearanceRequested, @nEventPreclearanceApproved, @nEventPreclearanceRejected)
			GROUP BY MapToId
			) ELI ON t.PreClearanceRequestID = ELI.MapToId
			JOIN eve_EventLog EL ON ELI.EventLogId = EL.EventLogId
		
		/*
		-- Update Preclearance Valid Till Date its defined in applicable Trading Policy Table.
		-- PreClrApprovalValidityLimit check that column in trading policy table if Preclearance Request is approved.
		*/
		UPDATE T
		SET PreclearanceValidTill = EL.EventDate
		FROM #tmpUsers T 
			JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
			JOIN tra_PreclearanceRequest PR ON T.PreClearanceRequestID = PR.PreclearanceRequestId
			JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE t.PreClearanceRequestID = EL.MapToId 
			AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
			AND EL.EventCodeId IN(@nPreclearanceExpire)
		
		UPDATE T
		SET PreclearanceValidTill = (select dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,PreClrCOApprovalLimit,null,1,1,0,116001))
		FROM #tmpUsers T 
			JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
			JOIN tra_PreclearanceRequest PR ON T.PreClearanceRequestID = PR.PreclearanceRequestId
			JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE t.PreClearanceRequestID = EL.MapToId 
		    AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		    AND EL.EventCodeId IN(@nEventPreclearanceRequested)
		    AND EL.EventCodeId NOT IN(@nEventPreclearanceApproved,@nEventPreclearanceRejected)
		    AND PR.PreclearanceStatusCodeId = 144001
		/*
		-- Update Continuous disclosure completion flag
			This flag is used for check Trading details submissin is required or not
			If Flag = 1 Then Trading Details Required.
		*/
		UPDATE T
		SET ContinuousDisclousureToBeSubmit = 1
		FROM #tmpUsers T 
			 JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
		     AND ((T.PreClearanceRequestID IS NULL) OR t.PreClearanceRequestID = EL.MapToId 
		     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		     AND EL.EventCodeId IN (@nEventPreclearanceApproved))		     
		     
		UPDATE T
		SET ContinuousDisclousureToBeSubmit = 3
		FROM #tmpUsers T 
			JOIN tra_NSEGroupDetails NSED ON t.UserInfoId = NSED.UserInfoId and t.TransactionMasterID=NSED.TransactionMasterId
			JOIN tra_NSEGroup NSEGr on NSEGr.GroupId=NSED.GroupId
		WHERE NSEGr.SubmissionDate IS NULL		     
			
		/*
			1. ContinuousDisclousureCompletion :- This flag 1 if Trading Details Submitted by Insider
			2. ContinuousDisclosureSubmissionDate: - If Trading Details Submitted then set Submission date
			3. ContinuousDisclosureStatus :- Update Status like 153019:- Trading details Approved or
			   15320:- Trading details Uploaded
		*/			
			
		UPDATE t
		SET ContinuousDisclousureCompletion = 2,
			ContinuousDisclosureSubmissionDate = EL.EventDate,
			ContinuousDisclosureStatus =  @nUploadedStatus,
			IsEnterAndUploadEvent = 1
		FROM #tmpUsers t 
			JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		WHERE EL.EventCodeId = @nEventContinuousDisclosureUploaded   
		
		UPDATE t
		SET ContinuousDisclousureCompletion = 1,
			ContinuousDisclosureSubmissionDate = EL.EventDate,
			ContinuousDisclosureStatus = @nApproveStatus,
			IsEnterAndUploadEvent = IsEnterAndUploadEvent + 1
		FROM #tmpUsers t 
			JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		WHERE EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered
	
		/*
			1. ContinuousDisclosureStatus :- update status if Trading details entered must and insider doesnot entered trade details
												then set status Pending
		*/	
		UPDATE t
		SET ContinuousDisclosureStatus =  @nPendingStatus
		FROM #tmpUsers t 
		WHERE ContinuousDisclousureToBeSubmit = 1 AND ContinuousDisclousureCompletion = 0
		
		UPDATE t
		SET ContinuousDisclosureStatus =  @nInProgressStatus
		FROM #tmpUsers t 
		WHERE ContinuousDisclousureToBeSubmit = 3		
		
		/*
			1. ContinuousDisclosureStatus :- In case Insider Not Traded Then set status @nNotTradedStatus
		*/	
		UPDATE T
		SET	ContinuousDisclosureStatus = @nNotTradedStatus
		FROM #tmpUsers T
			 LEFT JOIN tra_PreclearanceRequest PR ON t.PreClearanceRequestID = PR.PreclearanceRequestId
		WHERE PR.IsPartiallyTraded = 2	
		
		/*
			1. ContinuousDisclosureStatus :- If Insider Traded Partially by checking PartiallyTradedFlag in TransactionMaster
			   set status Partially Traded
		*/	
		--UPDATE T
		--SET	ContinuousDisclosureStatus = @nPartiallyTradedStatus
		--FROM #tmpUsers T
		--JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE TM.PartiallyTradedFlag = 1
		
		--select * from #tmpUsers
		
		/*
			ContinuousDisclosureSubmitWithin = Used for How many day remaining submission trading details.
		*/		
		UPDATE T
		SET ContinuousDisclosureSubmitWithin =  TP.PreClrTradeDiscloLimit - (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,null,dbo.uf_com_GetServerDate(),1,0,0,116001))--DATEDIFF(day,EL.EventDate,dbo.uf_com_GetServerDate())  
		FROM #tmpUsers T 
			JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId
			JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE ContinuousDisclousureCompletion = 0 AND ContinuousDisclousureToBeSubmit = 1 
			 AND  t.PreClearanceRequestID = EL.MapToId 
		     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		     AND EL.EventCodeId = @nEventPreclearanceApproved
			 AND t.PreClearanceRequestID IS NOT NULL
				
		-- Update flag for soft copy to be submitted as per set in the trading policy applicable to user
		UPDATE t
		SET SoftCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrSoftcopyFlag
		FROM #tmpUsers t 
			JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
		
		-- Update Soft Copy submission status flag based on Event Log
		UPDATE t
		--SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END,
		SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL 
		                          THEN CASE  WHEN tm.SoftCopyReq  = 0 THEN 2 ELSE 0 END ELSE 1 END,
			SoftcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
			LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
			AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedSoftcopy) 
			AND MapToTypeCodeId = @nDisclosureMapToType 
			JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		 WHERE ((ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 1) 
		      OR (ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 0))
		
		-- Update Flag If HardCopy is required as per the policy applicable
		-- for user
		UPDATE t
		SET HardCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrHardcopyFlag
		FROM #tmpUsers t 
			JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
		
		-- Update Hard Copy submission status flag based on Event Log	
		UPDATE t	   
		SET HardCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN CASE WHEN TM.HardCopyReq = 0 THEN 2 ELSE 0 END ELSE 1 END,
			HardcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
			LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
			AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedHardcopy) AND MapToTypeCodeId = @nDisclosureMapToType
			JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE (SoftCopySubmissionFlag = 1 AND TM.HardCopyReq = 1) 
			OR (TM.HardCopyReq = 1 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
			AND ContinuousDisclousureCompletion = 1)
			OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 1)
			OR (TM.HardCopyReq = 0 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
			AND ContinuousDisclousureCompletion = 1)
			OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 2 
			AND ContinuousDisclousureCompletion = 1)	
		
		
		-- This is used for CO case
		UPDATE t
		SET HardCopySubmitCOToExchangeFlag = TP.StExSubmitDiscloToStExByCOHardcopyFlag  
		FROM #tmpUsers t 
			JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
	
		
		UPDATE t
		SET HardCopySubmissionCOToExchangeFlag = CASE WHEN EL.EventLogId IS NULL THEN 
		  	CASE WHEN HardCopySubmitCOToExchangeFlag = 0 OR HardCopySubmitCOToExchangeFlag IS NULL THEN 2 ELSE 0 END ELSE 1 END,
			HardCopySubmitCOToExchangeDate = TM.HardCopyByCOSubmissionDate--EL.EventDate
		FROM #tmpUsers t 
			LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
			AND EL.EventCodeId IN (@nEventContinuousDisclosureCOSubmittedHardcopyToStockExchange) 
			AND MapToTypeCodeId = @nDisclosureMapToType
			JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE (HardCopySubmitCOToExchangeFlag = 1 AND HardCopySubmissionFlag = 1)
			OR (ContinuousDisclousureCompletion = 1 AND ( HardCopySubmitCOToExchangeFlag = 0 OR HardCopySubmitCOToExchangeFlag IS NULL))
			OR (SoftCopyToBeSubmitFlag =  1 AND SoftCopySubmissionFlag = 1 AND HardCopySubmissionFlag = 2)
				
		UPDATE T
		SET HardCopySubmitCOToExchangeWithin = 
		TP.StExTradeDiscloSubmitLimit - 
		  (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,null,dbo.uf_com_GetServerDate(),1,0,0,116001))--DATEDIFF(day,EL.EventDate,dbo.uf_com_GetServerDate())
		FROM #tmpUsers t 
			LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
			JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
			AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedHardcopy,@nEventContinuousDisclosureSubmittedSoftcopy,@nEventContinuousDisclosureDetailsEntered) 
			AND MapToTypeCodeId = @nDisclosureMapToType
			JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE HardCopyToBeSubmitFlag = 1 AND ContinuousDisclousureCompletion = 1 
			AND ((TM.HardCopyReq = 1 AND HardCopySubmissionFlag = 1) 
		    OR (TM.HardCopyReq = 0 AND TM.SoftCopyReq = 1 AND SoftCopySubmissionFlag = 1))
				
		INSERT INTO #tmpUsers(UserInfoId,PreClearanceRequestID, PreClearanceRequestCode, TransactionMasterID,TradingPolicyId, IsAddButtonRow,PreclearanceStatus,ContinuousDisclosureStatus, TMIdForOrder,StockExchangeSubmissionTotalQty)
		SELECT  PR.UserInfoId,
		        PR.PreclearanceRequestId,				
				CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
				CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sNonPrceclearanceCodePrefixText ELSE @sNonPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END  
				ELSE
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceNotRequiredPrefixText ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END
				ELSE 
				CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceCodePrefixText ELSE  @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END,
				0,
				TM.TradingPolicyId,
				1,
				153016,
				154004, TM.TransactionMasterId,
				TM.TotalTradeValue
		FROM tra_PreclearanceRequest PR 
		JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId AND ParentTransactionMasterId IS NULL
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		WHERE IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = 144002  AND (ShowAddButton = 1 OR ReasonForNotTradingCodeId IS NOT NULL) 
				
		UPDATE  #tmpUsers
		SET DisplayNumber = 1 
		FROM #tmpUsers t
		WHERE t.Id = ( SELECT TOP 1 Id FROM #tmpUsers t1 
		      WHERE t1.PreClearanceRequestCode = t.PreClearanceRequestCode 
			  AND t.PreClearanceRequestID IS NOT NULL order by IsAddButtonRow DESC,Id ASC)
		      
		UPDATE  #tmpUsers
		SET DisplayNumber = 1 
		FROM #tmpUsers t
		WHERE t.Id = ( SELECT TOP 1 Id FROM #tmpUsers t1 
		      WHERE t1.TransactionMasterID = t.TransactionMasterID 
		      AND t.PreClearanceRequestID IS NULL order by IsAddButtonRow DESC,Id ASC)
					
		UPDATE #tmpUsers
		SET PreclearanceValidTill =( SELECT TOP 1 PreclearanceValidTill FROM #tmpUsers t1 WHERE t1.PreClearanceRequestID = t.PreClearanceRequestID)
		FROM #tmpUsers t 
		WHERE TransactionMasterID = 0 AND IsAddButtonRow  = 1 
			  AND DisplayNumber = 1	
	
		UPDATE t
		SET HardCopySubmissionCOToExchangeFlag =  3
		FROM #tmpUsers t 
		WHERE ContinuousDisclousureToBeSubmit = 3
		
	
		TRUNCATE TABLE tra_ContinuousDisc
		INSERT INTO tra_ContinuousDisc
	  
	   SELECT Temp.TransactionMasterID
				,PR.PreclearanceRequestId
				,TM.TradingPolicyId
				,PreClearanceRequestCode AS dis_grd_17256
				,PR.CreatedOn AS dis_grd_17257
				,code.CodeID AS dis_grd_17258				
				,Temp.PreclearanceValidTill AS PreclearanceValidTill
				,CASE WHEN PR.PreclearanceRequestId IS NULL 
					 THEN (SELECT CodeName from com_Code where CodeID in(SELECT TOP 1 SecurityTypeCodeId FROM tra_TransactionDetails WHERE TransactionMasterId = TM.TransactionMasterId)) 
				ELSE code2.CodeName END AS dis_grd_17260,			      
				CASE WHEN PR.PreclearanceRequestId IS NULL 
					 THEN 
				CASE WHEN (SELECT COUNT(TransactionDetailsId) FROM tra_TransactionDetails WHERE TransactionMasterId = TM.TransactionMasterId) = 1  
					 THEN (SELECT CodeName FROM com_Code WHERE CodeID IN(SELECT TransactionTypeCodeId FROM tra_TransactionDetails WHERE TransactionMasterId = TM.TransactionMasterId)) 
				ELSE '-' END
				ELSE code1.CodeName END AS dis_grd_17259						
				,Temp.ContinuousDisclosureStatus AS dis_grd_17261				
				,CASE WHEN Temp.ContinuousDisclosureSubmitWithin < 0 THEN ABS(ContinuousDisclosureSubmitWithin) ELSE Temp.ContinuousDisclosureSubmitWithin END AS SubmmisonWithin
				,CASE WHEN Temp.ContinuousDisclosureSubmitWithin < 0 THEN @sDayOverdueText WHEN Temp.ContinuousDisclosureSubmitWithin >= 0 
					THEN @sDayLeftText ELSE NULL END AS ContinuousDisclosureSubmitWithinText 				
				,Temp.SoftCopySubmissionFlag AS dis_grd_17262				
				,Temp.HardCopySubmissionFlag AS dis_grd_17263				
				,CASE WHEN Temp.HardCopySubmissionFlag = 0 THEN @sPendingButtonText 
					  WHEN Temp.HardCopySubmissionFlag = 1 THEN CONVERT(VARCHAR,HardcopySubmissionDate) 
					  WHEN Temp.HardCopySubmissionFlag = 2 THEN @sNotRequiredText					  
					  END AS HardcopySubmissionButtonText					  
				,Temp.ContinuousDisclosureSubmissionDate				
				,CASE WHEN Temp.SoftCopySubmissionFlag = 0 THEN @sPendingButtonText 
					  WHEN Temp.SoftCopySubmissionFlag = 1 THEN CONVERT(VARCHAR,SoftcopySubmissionDate) 
					  WHEN Temp.SoftCopySubmissionFlag = 2 THEN @sNotRequiredText
					  END AS SoftcopySubmissionButtonText					  
				,CASE WHEN code.CodeID  = @nEventPreclearanceRequested THEN @sPendingButtonText 
					  WHEN code.CodeID  = @nEventPreclearanceApproved THEN @sApproveButtonText
					  WHEN code.CodeID  = @nEventPreclearanceRejected THEN @sRejectedButtonText END AS PreClearanceStatusButtonText
				,CASE WHEN Temp.ContinuousDisclosureStatus = 154001 THEN CONVERT(VARCHAR,Temp.ContinuousDisclosureSubmissionDate)
					  WHEN Temp.ContinuousDisclosureStatus = 154002 THEN @sPendingButtonText
					  WHEN Temp.ContinuousDisclosureStatus = 154004 THEN @sPartiallyTradedButtonText
					  WHEN Temp.ContinuousDisclosureStatus = 154005 THEN @sNotTradedButtonText
					  WHEN Temp.ContinuousDisclosureStatus = 154008 THEN @sInProgressButtonText
					  WHEN Temp.ContinuousDisclosureStatus = 154006 THEN @sUploadedButtonText END TradingDetailsStatusButtonText
				,CASE WHEN Temp.HardcopySubmissionwithin < 0 THEN ABS(HardcopySubmissionwithin) ELSE Temp.HardcopySubmissionwithin END HardcopySubmissionwithin
			    ,CASE WHEN Temp.HardcopySubmissionwithin < 0 THEN @sDayOverdueText WHEN Temp.HardcopySubmissionwithin >= 0 THEN 
			     @sDayLeftText ELSE NULL END AS HardcopySubmissionwithinText			    
			    ,Temp.SoftcopySubmissionDate			    
			    ,Temp.HardcopySubmissionDate			
				,Temp.HardCopySubmissionCOToExchangeFlag AS dis_grd_17264			
				,Temp.HardCopySubmitCOToExchangeDate			
				,CASE WHEN Temp.HardCopySubmissionCOToExchangeFlag = 0 THEN @sPendingButtonText 
					  WHEN Temp.HardCopySubmissionCOToExchangeFlag = 1 THEN CONVERT(VARCHAR,HardCopySubmitCOToExchangeDate) 
					  WHEN Temp.HardCopySubmissionCOToExchangeFlag = 2 THEN @sNotRequiredText
					  WHEN Temp.HardCopySubmissionCOToExchangeFlag = 3 THEN @sInProgressButtonText
					  END AS HardCopySubmitCOToExchangeButtonText				
				,CASE WHEN Temp.HardCopySubmitCOToExchangeWithin < 0 THEN ABS(HardCopySubmitCOToExchangeWithin) ELSE Temp.HardCopySubmitCOToExchangeWithin END AS HardCopySubmitCOToExchangeWithin  
				,CASE WHEN Temp.HardCopySubmitCOToExchangeWithin < 0 THEN @sDayOverdueText WHEN Temp.HardCopySubmitCOToExchangeWithin >= 0 
					  THEN  @sDayLeftText ELSE NULL END AS HardCopySubmitCOToExchangeWithinText				
				,EmployeeId AS dis_grd_17255				
				,UF.PAN AS dis_grd_50597				
				,CASE WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				      WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NOT NULL THEN @nEmployeeStatusSeparated
				      WHEN UF.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusInactive
				      END AS dis_grd_50605		
				,UF.StatusCodeId AS EmployeeStatusCodeID				
				,UF.DateOfSeparation AS DateOfSeparation				
				,CASE WHEN UF.DesignationId IS NULL THEN UF.DesignationText ELSE code3.CodeName END DesignationText				
				,CASE WHEN UF.UserTypeCodeId = 101004 THEN company.CompanyName ELSE ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName,'') END AS dis_grd_17254
				,CASE WHEN DisplayNumber = 1  THEN ROUND(PR.SecuritiesToBeTradedQty,0) ELSE null END AS dis_grd_17354
				,IsAddButtonRow ,Temp.UserInfoId, PR.IsPartiallyTraded ,PR.ShowAddButton	 
				,PR.ReasonForNotTradingCodeId, Temp.TradedQty AS dis_grd_17355, @nNotTradedStatusButtonText1 AS  NotTradedStatus1				
				,PR.IsAutoApproved AS IsAutoApproved ,CASE WHEN PR.IsAutoApproved  = 1 THEN @nAutoApproveButtonText ELSE '' END AS IsAutoApprovedText				
				,StockExchangeSubmissionTotalQty AS dis_grd_17448, TP.IsPreclearanceFormForImplementingCompany AS IsPreclearanceFormForImplementingCompany
				,CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated, IsEnterAndUploadEvent			   
				,CASE WHEN UF.UserTypeCodeId = 101004 THEN company.CompanyName ELSE					
				 CASE WHEN UF.FirstName IS NULL and  UF.LastName IS NULL
				 THEN UF.MiddleName ELSE isnull(UF.FirstName,'') + ' ' + isnull(UF.LastName,'') END
				 END
				 AS Name				 
				,Temp.IndividualTradedValue AS dis_grd_50646
				,CASE WHEN DisplayNumber = 1  THEN ROUND(PR.SecuritiesToBeTradedQtyOld,0) ELSE null END AS dis_grd_52123
		FROM 
		#tmpUsers Temp 
		LEFT JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = Temp.TransactionMasterID
		LEFT JOIN tra_PreclearanceRequest PR ON Temp.PreClearanceRequestID = PR.PreclearanceRequestId
		LEFT JOIN com_Code code ON Temp.PreclearanceStatus = code.CodeID
		LEFT JOIN com_Code code1 ON PR.TransactionTypeCodeId = code1.CodeID
		LEFT JOIN com_Code code2 ON PR.SecurityTypeCodeId = code2.CodeID
		LEFT JOIN  usr_UserRelation UR ON UR.UserInfoIdRelative = PR.UserInfoIdRelative	
		LEFT JOIN com_Code coderelation ON UR.RelationTypeCodeId = coderelation.CodeID
		JOIN usr_UserInfo UF ON UF.UserInfoId = Temp.UserInfoId
		LEFT JOIN mst_Company company ON UF.CompanyId = company.CompanyId
		JOIN rul_TradingPolicy TP ON Temp.TradingPolicyId = TP.TradingPolicyId	
		LEFT JOIN tra_GeneratedFormDetails GFD ON Temp.PreClearanceRequestID = GFD.MapToId AND GFD.MapToTypeCodeId = 132004
		left JOIN com_Code code3 on UF.DesignationId=code3.CodeID
		WHERE   Temp.TransactionMasterId IS NOT NULL		
		ORDER BY Temp.TransactionMasterID asc				  	   
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUS_DISCLOSURE_LIST
	END CATCH
END
GO

