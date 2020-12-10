IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ContinuousDisclosureListByCO')
DROP PROCEDURE [dbo].[st_tra_ContinuousDisclosureListByCO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Preclearance Request/Continuous Disclosure list for CO.

Returns:		0, if Success.
				
Created by:		Tushar Tekawade	
Created on:		06-May-2015

Modification History:
Modified By		Modified On		Description
Tushar			04-Jun-2015		Change the EmployeeID/EmployeeName Search and sorting logic
Tushar			08-Jun-2015     return HardCopySubmitCOToExchangeWithinText and HardCopySubmitWithinText
Tushar			09-Jun-2015		Resource code add for days left and days overdue.
Tushar			09-Jun-2015     return ContinuousDisclosureSubmitWithinText for Days left and Days Overdue case
Tushar			09-Jun-2015		While status updating if softcopy is not required and hardcopy required show link in Hardcopy column also for
								Submission to stock exchange if trade details entered and Softcopy and Hardcopy not required sho link in stock exchange column.
Tushar          10-Jun-2015		Change logic for PNT case doesnot update ContinuousDisclosureSubmitWithin and @inp_bContinuousDisclosureRequiredFlag for filter.								
Tushar			24-Jun-2015		Change condtion for Days Left and Days Overdue & change for count of  days remaining in Trading Details Submitted section
Tushar			26-Jun-2015		If Corporate Insider then Insider Name column shows Company Name Text
Tushar			09-Jul-2015		Change for Not Required case handle in procedure.
Tushar			31-Jul-2015		When trading details Uploaded Status doesnot evaluate softcopy/hardcopy submisiion check.
Tushar			11-Aug-2015		Changes related to the partial trading
Tushar			14-Aug-2015		bugs fixes related to the partial trading
Tushar			04-Sep-2015		Return is Auto approve flag
Tushar			04-Sep-2015		Pre-Clearance status column: for 'Pending' status, valid till date should appear.
Tushar			07-Sep-2015		Return IsAutoApprovedText
Tushar			31-Oct-2015		Doesnot show records for CO those are PNT are in pending status
Tushar			22-Jan-2015		Change for Non Trading days count.
Parag			25-Jan-2016		Made change to fix issue of "Arithmetic overflow error converting expression to data type int." occured when input quantity is 10 digit
Tushar			28-Jan-2016		Change for Non Trading days count HardCopy and submit to CO stock exchange.
Tushar			28-Jan-2016		Change for Non Trading days count is
								1. For CO Prclerance approve then show Valid till date (consider Pre-clearance approval validity field)
								1. For CO Prclerance Pending then show Take action before date(consider Pre-clearance approval to be give within field)
								2. softcopy/hardcopy doesnot need show days remaining for submission.
								3. Submisson to Stock Exchange withinn based on 
								   if Softcopy required HardCopy Not Required 
									  then after Softcopy submisson used for calculate remaining days.
								   else if Softcopy required HardCopy Required 
									then after HardCopy submisson used for calculate remaining days.
								4. Trade details submisson within calculate for PCL records. 
									after Preclearance approved then calculate remainng days. (consider Trade (Continous) Disclosure to be submitted by 
												Insider/Employee to CO after preclearance approval transaction within field)
Tushar			29-Jan-2016		Comment change and add PCL pending status quary change.
Tushar			17-Feb-2016		Show PNT pending status record for C0
Tushar			23-Mar-2016		After submitting the trade details in Continuous Disclosures of Non-Insider Employee, 
								system is giving an ID is "PNR<no.>". 
								& Insider Employee its shows "PNT<no.>". & Preclearance case show "PCL<no.>".
								all text fetch from com code table.
Parag			22-Apr-2016		Made change to show latest transaction record top of list 
Tushar			29-Apr-2016		Total quantity of shares to be displayed on Pre-clearance Continous Disclosure page for which 
								the stock exchange submission row is required.
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			12-Sep-2016		Changes for FORM E generation and showing download link on page.
Tushar			16-Sep-2016     Change Initial Disclosure, Continuous Disclosure and Period End Disclosure List pages for showing new icons for Entered/Uploaded.


Usage:
EXEC st_tra_ContinuousDisclosureListByCO
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_ContinuousDisclosureListByCO]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)
	,@inp_iUserInfoID						INT
	,@inp_iPreclearanceCodeID				NVARCHAR(MAX)
	,@inp_iPreclearanceRequestStatus		INT
	,@inp_iTransactionType					INT
	,@inp_dtSubmissionDateFrom				DATETIME
	,@inp_dtSubmissionDateTo				DATETIME
	,@inp_iTradeDetailsStatus				INT
	,@inp_iDisclosureDetailsSoftcopyStatus	INT
	,@inp_iDisclosureDetailsHardcopyStatus	INT
	,@inp_sEmployeeID						NVARCHAR(50)
	,@inp_sEmployeeName						NVARCHAR(MAX)
	,@inp_sDesignation						NVARCHAR(MAX)
	,@inp_dtSoftCopySubmissionFromDate		DATETIME
	,@inp_dtSoftCopySubmissionToDate		DATETIME
	,@inp_dtHardCopySubmissionFromDate		DATETIME
	,@inp_dtHardCopySubmissionToDate		DATETIME
	,@inp_dtStockExchangeSubmissionFromDate	DATETIME
	,@inp_dtStockExchangeSubmissionToDate	DATETIME
	,@inp_iStockExchangeSubmissionStatus	INT
	,@inp_bContinuousDisclosureRequiredFlag BIT
	,@out_nReturnValue						INT = 0				OUTPUT
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
			@nPartiallyTradedStatus												INT,
			@nNotTradedStatus													INT,
			@nUploadedStatus													INT,
			
			@sPrceclearanceCodePrefixText										VARCHAR(3),
			@sNonPrceclearanceCodePrefixText									VARCHAR(3),
			@sPendingButtonText													VARCHAR(10),
			@sApproveButtonText													VARCHAR(10),
			@sRejectedButtonText												VARCHAR(10),
			@sNotTradedButtonText												VARCHAR(10),
			@sUploadedButtonText												VARCHAR(10),
			@sPartiallyTradedButtonText											VARCHAR(20),
			@sDayLeftText													    VARCHAR(200),
			@sDayOverdueText													VARCHAR(200),
			@sNotRequiredText													VARCHAR(30),
			@nNotTradedStatusButtonText1										VARCHAR(200),
			@nAutoApproveButtonText												VARCHAR(200)
			
		--	select  @inp_sEmployeeName,@inp_sDesignation, @inp_dtSoftCopySubmissionFromDate,@inp_dtSoftCopySubmissionToDate
			
			--Pending Button Text
			SELECT @sPendingButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
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
			SET @nPartiallyTradedStatus												 = 154004
			SET @nNotTradedStatus													 = 154005
			SET @nUploadedStatus												     = 154006
			
			DECLARE @nPreclearanceTakenCase INT = 176001
			DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
			DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
			
			SET	@sPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
			SET @sNonPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
			DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)

	BEGIN TRY
		
			SET NOCOUNT ON;
			-- Declare variables
			IF @out_nReturnValue IS NULL
				SET @out_nReturnValue = 0
			IF @out_nSQLErrCode IS NULL
				SET @out_nSQLErrCode = 0
			IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
			
			
		   IF @inp_iPreclearanceRequestStatus = 144001
			BEGIN
				SET @inp_iPreclearanceRequestStatus = 153015
			END
			ELSE IF @inp_iPreclearanceRequestStatus = 144002
			BEGIN
				SET @inp_iPreclearanceRequestStatus = 153016
			END
			ELSE IF @inp_iPreclearanceRequestStatus = 144003
			BEGIN
				SET @inp_iPreclearanceRequestStatus = 153017
			END
		
		/*
			Create Temp Table for evaluation data
		*/
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
						TradedQty DECIMAL(10,0),DisplayNumber INT, TMIdForOrder BIGINT,StockExchangeSubmissionTotalQty DECIMAL(10,0),IsEnterAndUploadEvent INT DEFAULT 0)
		
			/*
				Insert Value in Temporary Table.
				UserInfoId,TransactionMasterID,TradingPolicyId,PreClearanceRequestID,PreClearanceRequestCode
			*/
			INSERT INTO #tmpUsers(UserInfoId,--EmployeeID,EmployeeName,
			TransactionMasterID,TradingPolicyId,PreClearanceRequestID,PreClearanceRequestCode, TMIdForOrder)  
			SELECT TM.UserInfoId,--EmployeeId,UF.FirstName + ' ' + UF.LastName,
			 TransactionMasterId,TradingPolicyId,PR.PreclearanceRequestId,
					CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
					CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN
					   CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sNonPrceclearanceCodePrefixText ELSE @sNonPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END  
					 ELSE
						CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceNotRequiredPrefixText ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END
					ELSE 
					  CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceCodePrefixText ELSE  @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END,
					ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId)
					--'PNT' + CONVERT(VARCHAR,TM.TransactionMasterId)  ELSE 'PCL' + CONVERT(VARCHAR,ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId)) END
			FROM tra_TransactionMaster TM
			LEFT JOIN	tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
			JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			WHERE ((@inp_iUserInfoID IS NULL OR @inp_iUserInfoID = 0) OR (TM.UserInfoId = @inp_iUserInfoID)) 
				   AND DisclosureTypeCodeId = @nContinousDisclosureType
		
		UPDATE tmpUser
		SET TradedQty = TD.Qty
		FROM #tmpUsers tmpUser JOIN 
			(SELECT TM.TransactionMasterId, SUM(TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) Qty
				FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				--WHERE UserInfoId = @inp_iUserInfoID
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
		where EventCodeId in (@nEventPreclearanceRequested, @nEventPreclearanceApproved, @nEventPreclearanceRejected)
		GROUP BY MapToId
		) ELI ON t.PreClearanceRequestID = ELI.MapToId
		JOIN eve_EventLog EL ON ELI.EventLogId = EL.EventLogId
		
		/*
		-- Update Preclearance Valid Till Date its defined in applicable Trading Policy Table.
		-- PreClrApprovalValidityLimit check that column in trading policy table if Preclearance Request is approved.
		*/
		
		UPDATE T
		SET PreclearanceValidTill = (select dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,PreClrApprovalValidityLimit,null,0,1,0,116001))  --DATEADD(DAY,TP.PreClrApprovalValidityLimit+PreClrCOApprovalLimit,PR.CreatedOn) < dbo.uf_com_GetServerDate() THEN NULL 
										 --ELSE (select dbo.uf_tra_GetNextTradingDateOrNoOfDays(PR.CreatedOn,TP.PreClrApprovalValidityLimit+PreClrCOApprovalLimit,null,1,1,0,116001)) END
		FROM #tmpUsers T 
		JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
		JOIN tra_PreclearanceRequest PR ON T.PreClearanceRequestID = PR.PreclearanceRequestId
		JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE   t.PreClearanceRequestID = EL.MapToId 
		     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		     AND EL.EventCodeId IN(@nEventPreclearanceApproved)
		
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
		
		/*
			1. ContinuousDisclosureStatus :- In case Insider Not Traded Then set status @nNotTradedStatus
		*/	
		UPDATE T
		SET	ContinuousDisclosureStatus = @nNotTradedStatus
		FROM #tmpUsers T
		LEFT JOIN tra_PreclearanceRequest PR ON t.PreClearanceRequestID = PR.PreclearanceRequestId
		WHERE --PR.ReasonForNotTradingCodeId IS NOT NULL	 
		PR.IsPartiallyTraded = 2
		
	
		
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
		SET ContinuousDisclosureSubmitWithin =  TP.PreClrTradeDiscloLimit - (select dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,null,dbo.uf_com_GetServerDate(),1,0,0,116001))--DATEDIFF(day,EL.EventDate,dbo.uf_com_GetServerDate())  
		FROM #tmpUsers T 
		JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId
		JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE ContinuousDisclousureCompletion = 0 AND ContinuousDisclousureToBeSubmit = 1 
		 AND  t.PreClearanceRequestID = EL.MapToId 
		     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		     AND EL.EventCodeId = @nEventPreclearanceApproved
			 AND t.PreClearanceRequestID IS NOT NULL
				
		-- Update flag for soft copy to be submitted as per set in the trading policy applicable to user
		update t
		SET SoftCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrSoftcopyFlag
		FROM #tmpUsers t JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
		
		-- Update Soft Copy submission status flag based on Event Log
		update t
		--SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END,
		SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL 
		                          THEN CASE  WHEN tm.SoftCopyReq  = 0 THEN 2 ELSE 0 END ELSE 1 END,
			SoftcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedSoftcopy) 
		AND MapToTypeCodeId = @nDisclosureMapToType
		JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE SoftCopyToBeSubmitFlag = 1 AND ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 1
		 WHERE ((ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 1) 
		      OR (ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 0))
		
		-- Update Flag If HardCopy is required as per the policy applicable
		-- for user
		update t
		SET HardCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrHardcopyFlag
		FROM #tmpUsers t JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
		
		-- Update Hard Copy submission status flag based on Event Log	
		update t
		--SET HardCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END,
		SET HardCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN CASE WHEN TM.HardCopyReq = 0 THEN 2 ELSE 0 END ELSE 1 END,
			HardcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedHardcopy) AND MapToTypeCodeId = @nDisclosureMapToType
		JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE (HardCopyToBeSubmitFlag = 1 AND SoftCopySubmissionFlag = 1 AND TM.HardCopyReq = 1) 
		--OR (HardCopyToBeSubmitFlag = 1 AND TM.HardCopyReq = 1 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
		--AND ContinuousDisclousureCompletion = 1)
		WHERE (SoftCopySubmissionFlag = 1 AND TM.HardCopyReq = 1) 
		OR (TM.HardCopyReq = 1 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
		AND ContinuousDisclousureCompletion = 1)
		OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 1)
		OR (TM.HardCopyReq = 0 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
		AND ContinuousDisclousureCompletion = 1)
		OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 2 
		AND ContinuousDisclousureCompletion = 1)
		
		--/*
		--	HardcopySubmissionwithin :- Used for check how many days remaining for submissin to Hard Copy
		--*/
		--UPDATE T
		--SET HardcopySubmissionwithin = TP.PreClrTradeDiscloLimit - (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(EL.EventDate,null,dbo.uf_com_GetServerDate(),1,0,0,116001))--DATEDIFF(day,EL.EventDate,dbo.uf_com_GetServerDate())
		--FROM #tmpUsers t 
		--LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		--JOIN rul_TradingPolicy TP ON T.TradingPolicyId = TP.TradingPolicyId 
		--AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedSoftcopy) 
		--AND MapToTypeCodeId = @nDisclosureMapToType
		--JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE HardCopyToBeSubmitFlag = 1 AND SoftCopySubmissionFlag = 1 AND TM.HardCopyReq = 1
		
		
		
		-- This is used for CO case
		UPDATE t
		SET HardCopySubmitCOToExchangeFlag = TP.StExSubmitDiscloToStExByCOHardcopyFlag  
		FROM #tmpUsers t JOIN rul_TradingPolicy TP ON t.TradingPolicyId = TP.TradingPolicyId
	
	--SELECT 
	--	  CASE WHEN EL.EventLogId IS NULL THEN 
	--		CASE WHEN HardCopySubmitCOToExchangeFlag = 0 OR HardCopySubmitCOToExchangeFlag IS NULL THEN 2 ELSE 0 END ELSE 1 END,
	--		 TM.HardCopyByCOSubmissionDate--EL.EventDate
	--		 ,TM.TransactionMasterId
	--	FROM #tmpUsers t 
	--	LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
	--	AND EL.EventCodeId IN (@nEventContinuousDisclosureCOSubmittedHardcopyToStockExchange) 
	--	AND MapToTypeCodeId = @nDisclosureMapToType
	--	JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
	--	WHERE ((HardCopySubmitCOToExchangeFlag = 1 AND HardCopySubmissionFlag = 1)
	--	OR (ContinuousDisclousureCompletion = 1 AND ( HardCopySubmitCOToExchangeFlag = 0 OR HardCopySubmitCOToExchangeFlag IS NULL))
	--	OR (SoftCopyToBeSubmitFlag =  1 AND SoftCopySubmissionFlag = 1 AND HardCopySubmissionFlag = 2))
		
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
		--OR (HardCopySubmitCOToExchangeFlag = 1 AND (HardCopyToBeSubmitFlag IS NULL OR HardCopyToBeSubmitFlag = 0) 
		--AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) AND ContinuousDisclousureCompletion = 1)
		--OR (HardCopySubmitCOToExchangeFlag = 1 AND (HardCopyToBeSubmitFlag IS NULL OR HardCopyToBeSubmitFlag = 0) AND SoftCopySubmissionFlag = 1 
		--AND SoftCopyToBeSubmitFlag = 1)
		
		UPDATE tmpUser
		SET StockExchangeSubmissionTotalQty = (SELECT dbo.uf_tra_GetTotalQuantityForCreateLetter(tmpUser.TransactionMasterID))
		FROM #tmpUsers tmpUser 
		WHERE SoftCopyToBeSubmitFlag = 1 AND ContinuousDisclousureCompletion = 1 AND (SoftCopySubmissionFlag = 0 OR SoftCopySubmissionFlag = 1)
		
		--select * from #tmpUsers	
		
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
		
		--HardCopySubmitCOToExchangeFlag = 1 AND HardCopySubmissionFlag = 1
		--OR (HardCopySubmitCOToExchangeFlag = 1 AND (HardCopyToBeSubmitFlag IS NULL OR HardCopyToBeSubmitFlag = 0) 
		--AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) AND ContinuousDisclousureCompletion = 1)
		--OR (HardCopySubmitCOToExchangeFlag = 1 AND (HardCopyToBeSubmitFlag IS NULL OR HardCopyToBeSubmitFlag = 0) AND SoftCopySubmissionFlag = 1 
		--AND SoftCopyToBeSubmitFlag = 1)
		
		INSERT INTO #tmpUsers(UserInfoId,PreClearanceRequestID, PreClearanceRequestCode, TransactionMasterID,TradingPolicyId, IsAddButtonRow,PreclearanceStatus,ContinuousDisclosureStatus, TMIdForOrder)
		SELECT  PR.UserInfoId
		        ,PR.PreclearanceRequestId,
				--CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
				--CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN @sNonPrceclearanceCodePrefixText + CONVERT(VARCHAR,TM.TransactionMasterId)  
				--	 ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(VARCHAR,TM.TransactionMasterId) END
				--	ELSE @sPrceclearanceCodePrefixText + CONVERT(VARCHAR,ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId)) END,
				--'PNT' + CONVERT(VARCHAR,TM.TransactionMasterId)  ELSE 'PCL' + CONVERT(VARCHAR,ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId)) END,
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
				154004, TM.TransactionMasterId
		FROM tra_PreclearanceRequest PR 
		JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId AND ParentTransactionMasterId IS NULL
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		WHERE IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = 144002  AND (ShowAddButton = 1 OR ReasonForNotTradingCodeId IS NOT NULL) 
		
	
		
		UPDATE  #tmpUsers
		SET DisplayNumber = 1 
		FROM #tmpUsers t
		WHERE t.Id = ( select TOP 1 Id from #tmpUsers t1 
		      WHERE t1.PreClearanceRequestCode = t.PreClearanceRequestCode 
		      and t.PreClearanceRequestID is not null order by IsAddButtonRow DESC,Id ASC)
		      
		UPDATE  #tmpUsers
		SET DisplayNumber = 1 
		FROM #tmpUsers t
		WHERE t.Id = ( select TOP 1 Id from #tmpUsers t1 
		      WHERE t1.TransactionMasterID = t.TransactionMasterID 
		      and t.PreClearanceRequestID is null order by IsAddButtonRow DESC,Id ASC)
		
			--select * from #tmpUsers
			
		UPDATE #tmpUsers
		SET PreclearanceValidTill =( SELECT TOP 1 PreclearanceValidTill FROM #tmpUsers t1 WHERE t1.PreClearanceRequestID = t.PreClearanceRequestID)
		FROM #tmpUsers t 
		WHERE TransactionMasterID = 0 AND IsAddButtonRow  = 1 
		AND DisplayNumber = 1
		
		
	  -- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'Temp.TMIdForOrder '
		END 
		
		IF @inp_sSortField  = 'dis_grd_17254'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.PreClearanceRequestCode '
		END
		
		IF @inp_sSortField  = 'dis_grd_17255'
		BEGIN 
			SELECT @inp_sSortField = 'UF.EmployeeId '
		END
		
		IF @inp_sSortField  = 'dis_grd_17256'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.PreClearanceRequestCode '
		END
		
		IF @inp_sSortField  = 'dis_grd_17257'
		BEGIN 
			SELECT @inp_sSortField = 'PR.CreatedOn '
		END
		
		IF @inp_sSortField  = 'dis_grd_17258'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.PreclearanceStatus '
		END
		
		IF @inp_sSortField  = 'dis_grd_17259'
		BEGIN 
			SELECT @inp_sSortField = 'PR.TransactionTypeCodeId '
		END
		
		IF @inp_sSortField  = 'dis_grd_17260'
		BEGIN 
			SELECT @inp_sSortField = 'PR.SecurityTypeCodeId '
		END
		
		IF @inp_sSortField  = 'dis_grd_17261'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.ContinuousDisclosureStatus '
		END
		
		IF @inp_sSortField  = 'dis_grd_17262'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.SoftCopySubmissionFlag '
		END
		
		IF @inp_sSortField  = 'dis_grd_17263'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.HardCopySubmissionFlag '
		END
		
		IF @inp_sSortField  = 'dis_grd_17264'
		BEGIN 
			SELECT @inp_sSortField = 'Temp.HardCopySubmissionCOToExchangeFlag  '
		END
		
		
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +', IsAddButtonRow DESC,Temp.TMIdForOrder),Temp.Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpUsers Temp '
		SELECT @sSQL = @sSQL + ' LEFT JOIN tra_TransactionMaster TM ON Temp.TransactionMasterID = TM.TransactionMasterID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN tra_PreclearanceRequest PR ON Temp.PreClearanceRequestID = PR.PreclearanceRequestId '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UF ON UF.UserInfoId = Temp.UserInfoId '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code code ON code.CodeID = UF.DesignationId '
		SELECT @sSQL = @sSQL + ' LEFT JOIN mst_Company company ON UF.CompanyId = company.CompanyId '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '--AND (Temp.PreClearanceRequestID IS NOT NULL OR (Temp.PreClearanceRequestID IS NULL AND Temp.ContinuousDisclosureStatus <>  ' + CONVERT(VARCHAR,@nPendingStatus) + '))'
		
		IF(@inp_sEmployeeID IS NOT NULL OR @inp_sEmployeeID <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like ''%' + CONVERT(VARCHAR,@inp_sEmployeeID) + '%'''
		END
		IF(@inp_sEmployeeName IS NOT NULL OR @inp_sEmployeeName <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (UF.FirstName like ''%' + CONVERT(VARCHAR,@inp_sEmployeeName) + '%'''
				SELECT @sSQL = @sSQL + ' OR UF.LastName like ''%' + CONVERT(VARCHAR,@inp_sEmployeeName) + '%'''
				SELECT @sSQL = @sSQL + ' OR company.CompanyName like ''%' + CONVERT(VARCHAR,@inp_sEmployeeName) + '%'')'
		END
		
		IF(@inp_sDesignation IS NOT NULL OR @inp_sDesignation <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (code.CodeName like ''%' + CONVERT(VARCHAR,@inp_sDesignation) + '%'''
				SELECT @sSQL = @sSQL + ' OR UF.DesignationText like ''%' + CONVERT(VARCHAR,@inp_sDesignation) + '%'')'
		END
		
		IF(@inp_iPreclearanceCodeID IS NOT NULL OR @inp_iPreclearanceCodeID <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.PreClearanceRequestCode like ''%' + CONVERT(VARCHAR,@inp_iPreclearanceCodeID) + '%'''
		END
		IF(@inp_iPreclearanceRequestStatus IS NOT NULL OR @inp_iPreclearanceRequestStatus <> 0)
		BEGIN
			--PreclearanceStatus
			SELECT @sSQL = @sSQL + ' AND Temp.PreclearanceStatus = ' + CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus)
		END
		IF(@inp_iTransactionType IS NOT NULL OR @inp_iTransactionType <> 0)
		BEGIN
			--PreclearanceStatus
			SELECT @sSQL = @sSQL + ' AND PR.TransactionTypeCodeId = ' + CONVERT(VARCHAR,@inp_iTransactionType)
		END
		IF(@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.ContinuousDisclosureSubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.ContinuousDisclosureSubmissionDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.ContinuousDisclosureSubmissionDate IS NULL OR Temp.ContinuousDisclosureSubmissionDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.ContinuousDisclosureSubmissionDate IS NOT NULL AND Temp.ContinuousDisclosureSubmissionDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.ContinuousDisclosureSubmissionDate IS NOT NULL AND Temp.ContinuousDisclosureSubmissionDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END		
			
		IF(@inp_iTradeDetailsStatus IS NOT NULL AND @inp_iTradeDetailsStatus <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.ContinuousDisclosureStatus = ' + CONVERT(VARCHAR,@inp_iTradeDetailsStatus)
		END
		
		IF(@inp_iDisclosureDetailsSoftcopyStatus IS NOT NULL AND @inp_iDisclosureDetailsSoftcopyStatus <> 0)
		BEGIN
			IF(@inp_iDisclosureDetailsSoftcopyStatus = 154001)
			BEGIN
				SET @inp_iDisclosureDetailsSoftcopyStatus = 1
			END
			ELSE
			BEGIN
				SET @inp_iDisclosureDetailsSoftcopyStatus = 0
			END
			SELECT @sSQL = @sSQL + ' AND Temp.SoftCopySubmissionFlag = ' + CONVERT(VARCHAR,@inp_iDisclosureDetailsSoftcopyStatus)
		END
		
		IF(@inp_dtSoftCopySubmissionFromDate IS NOT NULL AND @inp_dtSoftCopySubmissionToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.SoftcopySubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.SoftcopySubmissionDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.SoftcopySubmissionDate IS NULL OR Temp.SoftcopySubmissionDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSoftCopySubmissionFromDate IS NOT NULL AND @inp_dtSoftCopySubmissionToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.SoftcopySubmissionDate IS NOT NULL AND Temp.SoftcopySubmissionDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSoftCopySubmissionFromDate IS NULL AND @inp_dtSoftCopySubmissionToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.SoftcopySubmissionDate IS NOT NULL AND Temp.SoftcopySubmissionDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		
		
		IF(@inp_iDisclosureDetailsHardcopyStatus IS NOT NULL AND @inp_iDisclosureDetailsHardcopyStatus <> 0)
		BEGIN
			IF(@inp_iDisclosureDetailsHardcopyStatus=154001)
			BEGIN
				SET @inp_iDisclosureDetailsHardcopyStatus = 1
			END
			ELSE
			BEGIN
				SET @inp_iDisclosureDetailsHardcopyStatus = 0
			END
			SELECT @sSQL = @sSQL + ' AND Temp.HardCopySubmissionFlag = ' + CONVERT(VARCHAR,@inp_iDisclosureDetailsHardcopyStatus)
		END
		
		
		IF(@inp_dtHardCopySubmissionFromDate IS NOT NULL AND @inp_dtHardCopySubmissionToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.HardcopySubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.HardcopySubmissionDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.HardcopySubmissionDate IS NULL OR Temp.HardcopySubmissionDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtHardCopySubmissionFromDate IS NOT NULL AND @inp_dtHardCopySubmissionToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.HardcopySubmissionDate IS NOT NULL AND Temp.HardcopySubmissionDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtHardCopySubmissionFromDate IS NULL AND @inp_dtHardCopySubmissionToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.HardcopySubmissionDate IS NOT NULL AND Temp.HardcopySubmissionDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		IF(@inp_iStockExchangeSubmissionStatus IS NOT NULL AND @inp_iStockExchangeSubmissionStatus <> 0)
		BEGIN
			IF(@inp_iStockExchangeSubmissionStatus=154001)
			BEGIN
				SET @inp_iStockExchangeSubmissionStatus = 1
			END
			ELSE
			BEGIN
				SET @inp_iStockExchangeSubmissionStatus = 0
			END
			SELECT @sSQL = @sSQL + ' AND Temp.HardCopySubmissionCOToExchangeFlag = ' + CONVERT(VARCHAR,@inp_iStockExchangeSubmissionStatus)
		END
		
		IF(@inp_dtStockExchangeSubmissionFromDate IS NOT NULL AND @inp_dtStockExchangeSubmissionToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.HardCopySubmitCOToExchangeDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.HardCopySubmitCOToExchangeDate >= CAST('''  + CAST(@inp_dtStockExchangeSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.HardCopySubmitCOToExchangeDate IS NULL OR Temp.HardCopySubmitCOToExchangeDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtStockExchangeSubmissionFromDate IS NOT NULL AND @inp_dtStockExchangeSubmissionToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.HardCopySubmitCOToExchangeDate IS NOT NULL AND Temp.HardCopySubmitCOToExchangeDate >= CAST('''  + CAST(@inp_dtStockExchangeSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtStockExchangeSubmissionFromDate IS NULL AND @inp_dtStockExchangeSubmissionToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.HardCopySubmitCOToExchangeDate IS NOT NULL AND Temp.HardCopySubmitCOToExchangeDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		IF(@inp_bContinuousDisclosureRequiredFlag = 1)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (Temp.SoftCopySubmissionFlag = 0 OR Temp.SoftCopySubmissionFlag = 0 OR Temp.HardCopySubmissionFlag = 0 OR Temp.HardCopySubmissionFlag = 1)'
		END
		
	--	PRINT(@sSQL)
		EXEC(@sSQL)

	  
	   SELECT Temp.TransactionMasterID,
				PR.PreclearanceRequestId,
				TM.TradingPolicyId,
				CASE WHEN DisplayNumber = 1  THEN PreClearanceRequestCode ELSE '' END AS dis_grd_17256,
				CASE WHEN DisplayNumber = 1  THEN PR.CreatedOn ELSE NULL END AS dis_grd_17257,
				CASE WHEN DisplayNumber = 1  THEN code.CodeID ELSE '' END AS dis_grd_17258,
				Temp.PreclearanceValidTill AS PreclearanceValidTill,
			    CASE WHEN DisplayNumber = 1  THEN code2.CodeName ELSE '' END AS dis_grd_17260,
			    CASE WHEN DisplayNumber = 1  THEN code1.CodeName ELSE '' END AS dis_grd_17259 ,
				Temp.ContinuousDisclosureStatus AS dis_grd_17261,
				CASE WHEN Temp.ContinuousDisclosureSubmitWithin < 0 THEN ABS(ContinuousDisclosureSubmitWithin) ELSE Temp.ContinuousDisclosureSubmitWithin END AS SubmmisonWithin,
				CASE WHEN Temp.ContinuousDisclosureSubmitWithin < 0 THEN @sDayOverdueText WHEN Temp.ContinuousDisclosureSubmitWithin >= 0 
				THEN @sDayLeftText ELSE NULL END AS ContinuousDisclosureSubmitWithinText  ,
				Temp.SoftCopySubmissionFlag AS dis_grd_17262,
				Temp.HardCopySubmissionFlag AS dis_grd_17263
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
					  END AS HardCopySubmitCOToExchangeButtonText		  
				,CASE WHEN Temp.HardCopySubmitCOToExchangeWithin < 0 THEN ABS(HardCopySubmitCOToExchangeWithin) ELSE Temp.HardCopySubmitCOToExchangeWithin END AS HardCopySubmitCOToExchangeWithin  
				,CASE WHEN Temp.HardCopySubmitCOToExchangeWithin < 0 THEN @sDayOverdueText WHEN Temp.HardCopySubmitCOToExchangeWithin >= 0 
					THEN  @sDayLeftText ELSE NULL END AS HardCopySubmitCOToExchangeWithinText  	  
				,CASE WHEN DisplayNumber = 1  THEN EmployeeId ELSE '' END AS dis_grd_17255
				,CASE WHEN DisplayNumber = 1  THEN 
						CASE WHEN UF.UserTypeCodeId = 101004 THEN company.CompanyName ELSE UF.FirstName + ' ' + UF.LastName END
						ELSE '' END AS dis_grd_17254
				,CASE WHEN DisplayNumber = 1  THEN ROUND(PR.SecuritiesToBeTradedQty,0) ELSE null END AS dis_grd_17354
				,IsAddButtonRow 
				,Temp.UserInfoId,
				PR.IsPartiallyTraded
				,PR.ShowAddButton	 
				,PR.ReasonForNotTradingCodeId
				,Temp.TradedQty AS dis_grd_17355,
				@nNotTradedStatusButtonText1 AS  	NotTradedStatus1
				,PR.IsAutoApproved AS IsAutoApproved
				,CASE WHEN PR.IsAutoApproved  = 1 THEN @nAutoApproveButtonText ELSE '' END AS IsAutoApprovedText
				,StockExchangeSubmissionTotalQty AS dis_grd_17448
				,TP.IsPreclearanceFormForImplementingCompany AS IsPreclearanceFormForImplementingCompany
				,CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated
				,IsEnterAndUploadEvent
		FROM #tmpList T 
		INNER JOIN #tmpUsers Temp ON Temp.Id = T.EntityID
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
		WHERE   Temp.TransactionMasterId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUS_DISCLOSURE_LIST
	END CATCH
END

