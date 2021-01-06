IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ContinuousDisclosureListByCOUpdated')
DROP PROCEDURE dbo.st_tra_ContinuousDisclosureListByCOUpdated
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

CREATE PROCEDURE [dbo].[st_tra_ContinuousDisclosureListByCOUpdated] 
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
	,@GroupId								INT
	,@inp_sPANNumber                        NVARCHAR(50)
	,@inp_sEmployeeStatus                   INT
	,@inp_FromDashboard						INT=0
	,@inp_iTransactionMasterId              INT = 0
	,@inp_iSecurityType                     INT = 0
	,@inp_dtTransactionDate                 DATETIME
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
		
		SET @inp_dtSubmissionDateTo	=(SELECT @inp_dtSubmissionDateTo +'23:59:00')
		SET @inp_dtSoftCopySubmissionToDate=(SELECT @inp_dtSoftCopySubmissionToDate +'23:59:00')
		SET @inp_dtHardCopySubmissionToDate=(SELECT @inp_dtHardCopySubmissionToDate +'23:59:00')
		SET @inp_dtStockExchangeSubmissionToDate=(SELECT @inp_dtStockExchangeSubmissionToDate +'23:59:00')
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
				
			CREATE TABLE #TempFinalTransactionWithSorting(TransactionMasterId INT,PreClearanceRequestID INT,TransID INT,TransactionMasterIDForSort INT)
	BEGIN TRY
		
			SET NOCOUNT ON;
			-- Declare variables
			IF @out_nReturnValue IS NULL
				SET @out_nReturnValue = 0
			IF @out_nSQLErrCode IS NULL
				SET @out_nSQLErrCode = 0
			IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			SELECT @nIsPreClearanceEditable = IsPreClearanceEditable FROM mst_Company WHERE IsImplementing = 1
			
			print(@inp_iDisclosureDetailsSoftcopyStatus)
			
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
			
			CREATE TABLE #tmpGroupWiseUser(TransactionMasterId INT,PreReq int null)

			CREATE TABLE #TempDuplicateRecords(TransactionStatus INT, TransactionType INT, SecurityType INT, DateOfAcquisition DATE, Quantity DECIMAL(10,0), Value DECIMAL(10,0)
						,DMATAccountNo NVARCHAR(500),DPID VARCHAR(500),DPName NVARCHAR(200),TMID VARCHAR(500), TransactionMasterID INT, ModeOfAcquisition INT, ExchangeCode INT,Relation VARCHAR(500))			
	
			CREATE TABLE #tmp_tra_ContinuousDisc
			(
			[ID] BIGINT,[TransactionMasterId] BIGINT  NULL,[PreclearanceRequestId] BIGINT NULL,		
			[TradingPolicyId] BIGINT NULL,[Pre_Clearance_ID] VARCHAR(50) NULL,[Pre_Clearance_Request_Date] DATETIME NULL,
			[PreClearance_Status] BIGINT NULL,[PreclearanceValidTill] DATETIME null,[Securities] VARCHAR(50) NULL,		
			[Transaction_Type] VARCHAR(50) NULL,[Trading_Details_Submission] bigint NULL,		
			[SubmmisonWithin] VARCHAR(50) NULL,[ContinuousDisclosureSubmitWithinText] VARCHAR(50) NULL,[Disclosure_Details_Softcopy] BIGINT NULL,		
			[Disclosure_Details_Hardcopy] BIGINT NULL,[HardcopySubmissionButtonText] VARCHAR(50) NULL,[ContinuousDisclosureSubmissionDate] DATETIME NULL,				
			[SoftcopySubmissionButtonText] VARCHAR(50) NULL,[PreClearanceStatusButtonText] VARCHAR(50) NULL,[TradingDetailsStatusButtonText] VARCHAR(50) NULL,				
			[HardcopySubmissionwithin] VARCHAR(50) NULL,[HardcopySubmissionwithinText] VARCHAR(50) NULL,[SoftcopySubmissionDate] DATETIME NULL,
			[HardcopySubmissionDate] DATETIME NULL,[Submission_to_Stock_Exchange] BIGINT NULL,[HardCopySubmitCOToExchangeDate] DATETIME NULL,		
			[HardCopySubmitCOToExchangeButtonText] VARCHAR(50) NULL,[HardCopySubmitCOToExchangeWithin] VARCHAR(50) NULL,[HardCopySubmitCOToExchangeWithinText] VARCHAR(50) NULL,		
			[EmployeeID] VARCHAR(50) NULL,[PAN] VARCHAR(50) NULL,[EmployeeStatus] VARCHAR(50) NULL,[EmployeeStatusCodeID] BIGINT NULL,
			[DateOfSeparation] VARCHAR(50)NULL,[DesignationText] NVARCHAR(550) NULL,[InsiderName] [nvarchar] (500) NULL,				
			[PreClearance_Qty] DECIMAL(15,4) NULL,[IsAddButtonRow] VARCHAR(50) NULL,[UserInfoID] INT  NULL,[IsPartiallyTraded] INT NULL,				
			[ShowAddButton] INT NULL,[ReasonForNotTradingCodeId] VARCHAR(500) NULL,[Trade_Qty] VARCHAR(500) NULL,[NotTradedStatus1] VARCHAR(50) NULL,				
			[IsAutoApproved] INT NULL,[IsAutoApprovedText] VARCHAR(50) NULL,[Total_Traded_Value] VARCHAR(50) NULL,[IsPreclearanceFormForImplementingCompany] INT NULL,		
			[IsFORMEGenrated] INT NULL,[IsEnterAndUploadEvent] INT NULL,[Name] VARCHAR(500) NULL,[Individual_Traded_Value] VARCHAR(50) NULL, [PreClearance_Qty_Old] DECIMAL(15,4) NULL
			)
		
			INSERT #tmp_tra_ContinuousDisc		
			SELECT * FROM tra_ContinuousDisc order by PreclearanceRequestId desc

				IF @inp_iTransactionMasterId IS NOT NULL OR @inp_iSecurityType <> 0
				BEGIN
					IF @inp_iTransactionMasterId IS NULL
					BEGIN
						SET @inp_iTransactionMasterId = 0
					END			
					INSERT INTO #TempDuplicateRecords(TransactionStatus, TransactionType, SecurityType, DateOfAcquisition, Quantity, Value, DMATAccountNo, DPID, DPName, TMID, TransactionMasterID, ModeOfAcquisition, ExchangeCode,Relation)
					EXEC [st_tra_CheckDuplicateTransaction] @inp_iUserInfoID,@inp_iSecurityType,@inp_iTransactionType,@inp_dtTransactionDate,@inp_iTransactionMasterId
				
					DELETE FROM #tmp_tra_ContinuousDisc WHERE TransactionMasterID NOT IN (SELECT TransactionMasterID FROM #TempDuplicateRecords)
					IF (SELECT COUNT(*) FROM #tmp_tra_ContinuousDisc)>0
					BEGIN
						SET @IsDuplicate = 1
					END
				END

IF(@inp_iStockExchangeSubmissionStatus=154008 AND @inp_FromDashboard=0)
BEGIN
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId) (                   
        SELECT DISTINCT NG.TransactionMasterId
        FROM tra_NSEGroupDetails NG)
 
END

ELSE If(@inp_iStockExchangeSubmissionStatus=154002 AND (@inp_FromDashboard=0 OR @inp_FromDashboard IS NULL))
BEGIN
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId) (	   
		SELECT DISTINCT tra_TransactionMaster.TransactionMasterId
		FROM   tra_TransactionMaster
		WHERE  NOT EXISTS
  		(SELECT *
   		FROM   tra_NSEGroupDetails
   		WHERE  tra_NSEGroupDetails.TransactionMasterId = tra_TransactionMaster.TransactionMasterId))   		
END

ELSE If(@inp_iStockExchangeSubmissionStatus=154002 AND @inp_FromDashboard=1)
BEGIN
INSERT INTO #tmpGroupWiseUser(TransactionMasterId) (	
		SELECT DISTINCT tra_TransactionMaster.TransactionMasterId
		FROM   tra_TransactionMaster
		WHERE  NOT EXISTS
  		(SELECT *
   		FROM   tra_NSEGroupDetails
   		WHERE  tra_NSEGroupDetails.TransactionMasterId = tra_TransactionMaster.TransactionMasterId)   		
   		union   		
		Select TM.TransactionMasterId from tra_NSEGroupDetails NSEGrDtls join tra_TransactionMaster TM on NSEGrDtls.TransactionMasterId=TM.TransactionMasterId
	    join tra_NSEGroup NSEGr on NSEGrDtls.GroupId=NSEGr.GroupId where NSEGr.SubmissionDate is null)
END

ELSE If(@GroupId IS NOT NULL AND (@inp_FromDashboard=0 or @inp_FromDashboard is null))
BEGIN
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId) (	   
		SELECT DISTINCT NG.TransactionMasterId
        FROM tra_NSEGroupDetails NG
		WHERE NG.GroupId=@GroupId)		
END

ELSE 
BEGIN		
		DECLARE @CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED INT = 153019,
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED INT = 153020,
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY INT = 153021
		if(@inp_FromDashboard=2)
		begin				
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId) 
		(	   
   		SELECT TM.TransactionMasterId 
		FROM 
		tra_TransactionMaster TM JOIN eve_EventLog EL
		ON TM.TransactionMasterId=EL.MapToId
		WHERE 
		EventCodeId=(@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED) AND MapToId in(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED))
		AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY))
		AND TM.SoftCopyReq=1
   		)   		
		END
		
		ELSE IF(@inp_FromDashboard=3)
		BEGIN				
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId) 
		(   		
   		SELECT TM.TransactionMasterId 
		FROM 
		tra_TransactionMaster TM JOIN eve_EventLog EL
		ON TM.TransactionMasterId=EL.MapToId
		WHERE 
		EventCodeId=(@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED) AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED))
		AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY))
		AND TM.SoftCopyReq=1 
		)				
		END
		
		ELSE
		BEGIN		
		INSERT INTO #tmpGroupWiseUser(TransactionMasterId,PreReq) (	   
   		SELECT tra_TransactionMaster.TransactionMasterId,PreclearanceRequestId
		FROM tra_TransactionMaster)
		union
		--INSERT INTO #tmpGroupWiseUser (TransactionMasterId,PreReq)
		select 0,PreclearanceRequestId from tra_PreclearanceRequest where IsPartiallyTraded=1
		END
		
END		

		PRINT '-------------'
		IF(@inp_iTradeDetailsStatus=154002 AND @inp_FromDashboard=1)
		BEGIN
		DELETE FROM #tmp_tra_ContinuousDisc 
		WHERE PreclearanceRequestId 
		IN (SELECT tra_PreclearanceRequest.PreclearanceRequestId FROM tra_PreclearanceRequest WHERE IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = 144002 AND ReasonForNotTradingCodeId IS NOT NULL)
		END
		
		IF @IsDuplicate = 1
		BEGIN
			DELETE FROM #tmp_tra_ContinuousDisc WHERE UserInfoId <> @inp_iUserInfoID OR TransactionMasterID = 0
		END
		PRINT '-------------'

		
		INSERT INTO #TempFinalTransactionWithSorting
		SELECT Temp.TransactionMasterId, Temp.PreClearanceRequestID,Temp.ID,
		CASE WHEN Temp.TransactionMasterId = 0 THEN (SELECT TOP 1 TransactionMasterId FROM tra_TransactionMaster WHERE PreclearanceRequestId = Temp.PreclearanceRequestId) 
		ELSE Temp.TransactionMasterId END AS TransactionMasterIDForSort
		FROM #tmp_tra_ContinuousDisc Temp  LEFT JOIN tra_PreclearanceRequest PR ON Temp.PreClearanceRequestID = PR.PreclearanceRequestId  
		JOIN #tmpGroupWiseUser TGW ON Temp.TransactionMasterId=TGW.TransactionMasterId WHERE 1 = 1 
		GROUP BY Temp.PreClearanceRequestID,Temp.TransactionMasterId,Temp.ID
		ORDER BY Temp.PreClearanceRequestID DESC,Temp.TransactionMasterId ASC

	  -- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'Temp.Id '
		END 
		
		UPDATE #tmp_tra_ContinuousDisc SET PreclearanceRequestId=0 where PreclearanceRequestId is null

		SELECT @sSQL = @sSQL + ' SELECT DISTINCT ROW_NUMBER() OVER(Order BY Temp.TransactionMasterIDForSort desc),Temp.TransID '
		SELECT @sSQL = @sSQL + ' FROM #TempFinalTransactionWithSorting Temp '
		SELECT @sSQL = @sSQL + ' JOIN #tmp_tra_ContinuousDisc CD ON Temp.TransID = CD.ID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		IF(@inp_sEmployeeID IS NOT NULL OR @inp_sEmployeeID <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND EmployeeID like ''%' + CONVERT(VARCHAR,@inp_sEmployeeID) + '%'''
		END
		
		IF(@inp_sPANNumber IS NOT NULL OR @inp_sPANNumber <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND PAN like ''%' + CONVERT(VARCHAR,@inp_sPANNumber) + '%'''
		END
	
		IF(@inp_sEmployeeStatus IS NOT NULL OR @inp_sEmployeeStatus <> 0)
		BEGIN
		        IF(@inp_sEmployeeStatus = @nEmpStatusLiveCode)
		        BEGIN
		           SET @inp_sEmployeeStatus = @nEmployeeActive
		           SELECT @sSQL = @sSQL + ' AND EmployeeStatusCodeId = ' + CONVERT(VARCHAR,@inp_sEmployeeStatus) + 'AND DateOfSeparation IS NULL'
		        END
		        
		        ELSE IF(@inp_sEmployeeStatus = @nEmpStatusSeparatedCode)
		        BEGIN
		           SET @inp_sEmployeeStatus = @nEmployeeActive
		           SELECT @sSQL = @sSQL + ' AND EmployeeStatusCodeId = ' + CONVERT(VARCHAR,@inp_sEmployeeStatus) + 'AND DateOfSeparation IS NOT NULL'
		        END
		        
		        ELSE IF(@inp_sEmployeeStatus = @nEmpStatusInactiveCode)
		        BEGIN
		           SET @inp_sEmployeeStatus = @nEmployeeInActive
		           SELECT @sSQL = @sSQL + ' AND EmployeeStatusCodeId = ' + CONVERT(VARCHAR,@inp_sEmployeeStatus)
		        END
		END
		
		IF(@inp_sEmployeeName IS NOT NULL OR @inp_sEmployeeName <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND InsiderName like N''%' + CONVERT(NVARCHAR(Max),@inp_sEmployeeName) + '%'''
		END
		
		IF(@inp_sDesignation IS NOT NULL OR @inp_sDesignation <> 0)
		BEGIN
					
			SELECT @sSQL = @sSQL + ' AND DesignationText like N''%' + CONVERT(NVARCHAR(max),@inp_sDesignation) + '%'''
		END
		
		IF(@inp_iPreclearanceCodeID IS NOT NULL OR @inp_iPreclearanceCodeID <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Pre_Clearance_ID like ''%' + CONVERT(VARCHAR,@inp_iPreclearanceCodeID) + '%'''
		END
		IF(@inp_iPreclearanceRequestStatus IS NOT NULL OR @inp_iPreclearanceRequestStatus <> 0)
		BEGIN
			--PreclearanceStatus
			SELECT @sSQL = @sSQL + ' AND PreClearance_Status = ' + CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus)
		END
		IF((@inp_iTransactionType IS NOT NULL OR @inp_iTransactionType <> 0) AND @IsDuplicate = 0)
		BEGIN
			Declare @sTransactiontype varchar(100)
			select 	@sTransactiontype=CodeName from com_Code where CodeID=	@inp_iTransactionType		
			SELECT @sSQL = @sSQL + ' AND Transaction_Type like ''%' + CONVERT(VARCHAR,@sTransactiontype) + '%'''
		END
		IF(@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN
				print(1)
				SELECT @sSQL = @sSQL + ' AND ContinuousDisclosureSubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (ContinuousDisclosureSubmissionDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (ContinuousDisclosureSubmissionDate IS NULL OR ContinuousDisclosureSubmissionDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NULL)
		BEGIN	
			SELECT @sSQL = @sSQL + ' AND ( ContinuousDisclosureSubmissionDate IS NOT NULL AND ContinuousDisclosureSubmissionDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN				
			SELECT @sSQL = @sSQL + ' AND (ContinuousDisclosureSubmissionDate IS NOT NULL AND ContinuousDisclosureSubmissionDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END		
				
		IF(@inp_iTradeDetailsStatus IS NOT NULL AND @inp_iTradeDetailsStatus <> 0 AND @inp_FromDashboard IS NULL)
		BEGIN			
			SELECT @sSQL = @sSQL + ' AND Trading_Details_Submission = ' + CONVERT(VARCHAR,@inp_iTradeDetailsStatus)
		END
		
		IF(@inp_iTradeDetailsStatus IS NOT NULL AND @inp_iTradeDetailsStatus <> 0 and @inp_FromDashboard=1)
		BEGIN		
			IF(@inp_iTradeDetailsStatus!=154002)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND Trading_Details_Submission = ' + CONVERT(VARCHAR,@inp_iTradeDetailsStatus)
			END
			ELSE
			BEGIN
				DECLARE @iTradeDetailsPending INT=154002
				DECLARE @iTradeDetailsPartiallyTraded INT=154004
				SELECT @sSQL = @sSQL + ' AND Trading_Details_Submission = ' + CONVERT(VARCHAR,@iTradeDetailsPending)
				SELECT @sSQL = @sSQL + ' OR Trading_Details_Submission = ' + CONVERT(VARCHAR,@iTradeDetailsPartiallyTraded)		
			END			
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
		
			SELECT @sSQL = @sSQL + ' AND Disclosure_Details_Softcopy = ' + CONVERT(VARCHAR,@inp_iDisclosureDetailsSoftcopyStatus)
		END
		
		IF(@inp_dtSoftCopySubmissionFromDate IS NOT NULL AND @inp_dtSoftCopySubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND SoftcopySubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (SoftcopySubmissionDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (SoftcopySubmissionDate IS NULL OR SoftcopySubmissionDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSoftCopySubmissionFromDate IS NOT NULL AND @inp_dtSoftCopySubmissionToDate IS NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND ( SoftcopySubmissionDate IS NOT NULL AND SoftcopySubmissionDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSoftCopySubmissionFromDate IS NULL AND @inp_dtSoftCopySubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND (SoftcopySubmissionDate IS NOT NULL AND SoftcopySubmissionDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
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
			SELECT @sSQL = @sSQL + ' AND Disclosure_Details_Hardcopy = ' + CONVERT(VARCHAR,@inp_iDisclosureDetailsHardcopyStatus)
		END		
		
		IF(@inp_dtHardCopySubmissionFromDate IS NOT NULL AND @inp_dtHardCopySubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND HardcopySubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (HardcopySubmissionDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (HardcopySubmissionDate IS NULL OR HardcopySubmissionDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtHardCopySubmissionFromDate IS NOT NULL AND @inp_dtHardCopySubmissionToDate IS NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND ( HardcopySubmissionDate IS NOT NULL AND HardcopySubmissionDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtHardCopySubmissionFromDate IS NULL AND @inp_dtHardCopySubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND (HardcopySubmissionDate IS NOT NULL AND HardcopySubmissionDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		IF(@inp_iStockExchangeSubmissionStatus IS NOT NULL AND @inp_iStockExchangeSubmissionStatus <> 0)
		BEGIN
			IF(@inp_iStockExchangeSubmissionStatus=154001 AND (@inp_FromDashboard=0 OR @inp_FromDashboard IS NULL))
			BEGIN						
				SET @inp_iStockExchangeSubmissionStatus = 1
			END
			ELSE IF(@inp_iStockExchangeSubmissionStatus=154002 AND (@inp_FromDashboard=0 OR @inp_FromDashboard IS NULL))
			BEGIN			
				SET @inp_iStockExchangeSubmissionStatus = 0
			END
			ELSE IF(@inp_iStockExchangeSubmissionStatus=154008 AND (@inp_FromDashboard=0 OR @inp_FromDashboard IS NULL))
			BEGIN			
				SET @inp_iStockExchangeSubmissionStatus = 3
			END				
			
			IF(@inp_iStockExchangeSubmissionStatus=154002 AND @inp_FromDashboard=1)
			BEGIN			
				SELECT @sSQL = @sSQL + ' AND Submission_to_Stock_Exchange IN(0,3)'
			END
			ELSE
			BEGIN			
				SELECT @sSQL = @sSQL + ' AND Submission_to_Stock_Exchange = ' + CONVERT(VARCHAR,@inp_iStockExchangeSubmissionStatus)
			END				
		END
		
		IF(@inp_dtStockExchangeSubmissionFromDate IS NOT NULL AND @inp_dtStockExchangeSubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND HardCopySubmitCOToExchangeDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (HardCopySubmitCOToExchangeDate >= CAST('''  + CAST(@inp_dtStockExchangeSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (HardCopySubmitCOToExchangeDate IS NULL OR HardCopySubmitCOToExchangeDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtStockExchangeSubmissionFromDate IS NOT NULL AND @inp_dtStockExchangeSubmissionToDate IS NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND ( HardCopySubmitCOToExchangeDate IS NOT NULL AND HardCopySubmitCOToExchangeDate >= CAST('''  + CAST(@inp_dtStockExchangeSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtStockExchangeSubmissionFromDate IS NULL AND @inp_dtStockExchangeSubmissionToDate IS NOT NULL)
		BEGIN				
				SELECT @sSQL = @sSQL + ' AND (HardCopySubmitCOToExchangeDate IS NOT NULL AND HardCopySubmitCOToExchangeDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END		
		
		EXEC(@sSQL)

		SELECT 
		TC.[TransactionMasterId] AS TransactionMasterID,TC.[PreclearanceRequestId] AS PreclearanceRequestId,		
		[TradingPolicyId] AS TradingPolicyId,[Pre_Clearance_ID] AS dis_grd_17256,
		[Pre_Clearance_Request_Date] AS dis_grd_17257,[PreClearance_Status] AS dis_grd_17258,
		[PreclearanceValidTill] AS PreclearanceValidTill,[Securities] AS dis_grd_17260,
		[Transaction_Type] AS dis_grd_17259,[Trading_Details_Submission] AS dis_grd_17261,
		[SubmmisonWithin] AS SubmmisonWithin,[ContinuousDisclosureSubmitWithinText] AS ContinuousDisclosureSubmitWithinText,
		[Disclosure_Details_Softcopy] AS dis_grd_17262,[Disclosure_Details_Hardcopy] AS dis_grd_17263,		
		[HardcopySubmissionButtonText] AS HardcopySubmissionButtonText,[ContinuousDisclosureSubmissionDate] AS ContinuousDisclosureSubmissionDate,		
		[SoftcopySubmissionButtonText] AS SoftcopySubmissionButtonText,[PreClearanceStatusButtonText] AS PreClearanceStatusButtonText,		
		[TradingDetailsStatusButtonText] AS TradingDetailsStatusButtonText,[HardcopySubmissionwithin] AS HardcopySubmissionwithin,
		[HardcopySubmissionwithinText] AS HardcopySubmissionwithinText,[SoftcopySubmissionDate] AS SoftcopySubmissionDate,
		[HardcopySubmissionDate] AS HardcopySubmissionDate,[Submission_to_Stock_Exchange] AS dis_grd_17264,
		[HardCopySubmitCOToExchangeDate] AS HardCopySubmitCOToExchangeDate,[HardCopySubmitCOToExchangeButtonText] AS HardCopySubmitCOToExchangeButtonText,
		[HardCopySubmitCOToExchangeWithin] AS HardCopySubmitCOToExchangeWithin,[HardCopySubmitCOToExchangeWithinText] AS HardCopySubmitCOToExchangeWithinText,
		TC.[EmployeeID] AS dis_grd_17255,TC.[PAN] AS dis_grd_50597,[EmployeeStatus] AS dis_grd_50605,
		[InsiderName] AS dis_grd_17254,CASE WHEN @nIsPreClearanceEditable = 524001 THEN [PreClearance_Qty_Old] ELSE [PreClearance_Qty] END AS dis_grd_17354, CASE WHEN @nIsPreClearanceEditable = 524001 AND PreClearance_Status = 153016 THEN [PreClearance_Qty] ELSE '0' END AS dis_grd_52123,
		[IsAddButtonRow] AS IsAddButtonRow,TC.[UserInfoID] AS UserInfoId,
		[IsPartiallyTraded] AS IsPartiallyTraded,[ShowAddButton] AS ShowAddButton,
		[ReasonForNotTradingCodeId] AS ReasonForNotTradingCodeId,[Trade_Qty] AS dis_grd_17355,
		[NotTradedStatus1] AS NotTradedStatus1,[IsAutoApproved] AS IsAutoApproved,
		[IsAutoApprovedText] AS IsAutoApprovedText,	[Total_Traded_Value] AS dis_grd_17448,	
		[IsPreclearanceFormForImplementingCompany] AS IsPreclearanceFormForImplementingCompany,
		[IsFORMEGenrated] AS IsFORMEGenrated,[IsEnterAndUploadEvent] AS IsEnterAndUploadEvent,[Name] AS Name,
		[Individual_Traded_Value] AS dis_grd_50646, Row_Number() OVER (ORDER BY (SELECT T.RowNumber) Desc)  AS RowNum,  
		CCategory.CodeName AS dis_grd_54063
		
		FROM 
		#tmpList T 
		JOIN #TempFinalTransactionWithSorting TempSort ON T.EntityID = TempSort.TransID
		JOIN #tmp_tra_ContinuousDisc TC ON TC.ID=TempSort.TransID
		INNER JOIN usr_UserInfo UT ON TC.UserInfoID=UT.UserInfoId
		LEFT JOIN com_Code CCategory ON CCategory.CodeID=UT.Category
		WHERE   
		TC.TransactionMasterId IS NOT NULL 		
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		DROP TABLE #tmp_tra_ContinuousDisc		  
		DROP TABLE #TempDuplicateRecords 
		DROP TABLE #TempFinalTransactionWithSorting
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUS_DISCLOSURE_LIST
	END CATCH
END
GO
