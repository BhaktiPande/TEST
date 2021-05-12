
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PreclearanceEmployeeWise_OS')
	DROP PROCEDURE st_rpt_PreclearanceEmployeeWise_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[st_rpt_PreclearanceEmployeeWise_OS]
	 @inp_sEmployeeID					NVARCHAR(50) = ''
	,@inp_sInsiderName					NVARCHAR(100) = ''
	,@inp_sPan							NVARCHAR(100) = ''
	,@inp_sCompanyName					NVARCHAR(200) = ''
	,@inp_dtDateOfTransactionFrom		DATETIME = null
	,@inp_dtDateOfTransactionTo			DATETIME = null
	,@EnableDisableQuantityValue        INT = 400001
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
DECLARE @sSQL NVARCHAR(MAX)
DECLARE @ERR_IDEMPLOYEEWISE INT = -1
DECLARE @nPreclearanceStatus_Confirmed INT = 144001
DECLARE @nPreclearanceStatus_Approved INT = 144002
DECLARE @nPreclearanceStatus_Rejected INT = 144003

DECLARE @nPreclearanceComment_Ok INT = 167001 -- Preclearance Taken
DECLARE @nPreclearanceComment_TrdAftPClDate INT = 167002
DECLARE @nPreclearanceComment_TrdWithoutPcl INT = 167003
DECLARE @nPreclearanceComment_PclNotRq INT = 167004
DECLARE @nPreclearanceComment_TrdDuringBlckout INT = 167005
DECLARE @nPreclearanceComment_Pending INT = 167006

DECLARE @nPreclearanceComment_QtyExceeds INT = 167007
DECLARE @nPreclearanceComment_ValueExceeds INT = 167008
DECLARE @nPreclearanceComment_QtyValueExceeds INT = 167009
DECLARE @nPreclearanceComment_TradeDetailsNotSubmitted INT = 167010
DECLARE @nPreclearanceComment_ContraTrade INT = 167011	
DECLARE @nPreclearanceComment_PartiallyTraded INT = 167012
DECLARE @nPreclearanceComment_BalanceTradeDetailsPending INT = 167013

DECLARE @nTransactionDetailsId BIGINT

DECLARE @sPNT VARCHAR(10) = 'PNT'
DECLARE @sPCL VARCHAR(10) = 'PCL'

DECLARE @nTransactionType_Sell INT = 143002

DECLARE @nTransactionStatus_NotConfirmed INT = 148002

DECLARE @tmpIsContraTradeForTd TABLE(TransactionDetailsId BIGINT, IsContraTrade INT, ContraTradeQty DECIMAL(10,0))

CREATE TABLE #tmpPreclearance(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100), PAN NVARCHAR(50),
	TransactionMasterId INT, TransactionDetailsId INT, PreclearanceId VARCHAR(50), DisplaySequenceNo INT,JoiningDate DATETIME, DateOfSeparation DATETIME,
	 Designation NVARCHAR(512), Grade NVARCHAR(512), Location NVARCHAR(512),Department NVARCHAR(512), Category VARCHAR(512), SubCategory VARCHAR(512),
	  StatusCodeId VARCHAR(512), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(512),Request INT DEFAULT 0, Approved INT DEFAULT 0, Rejected INT DEFAULT 0, 
	  Pending INT DEFAULT 0, Traded INT DEFAULT 0, RequestDate DATETIME,ScripName VARCHAR(100), ISIN VARCHAR(100), TransactionTypeCodeId NVARCHAR(50), 
	  SecurityTypeCodeId NVARCHAR(50), PreQuantity INT, PreValue DECIMAL(25, 4),PreclearanceStatusId INT, PreStatusDate DATETIME, PreApplicableTill DATETIME, 
	  BuyQuantity INT, SellQuantity INT, DateOfAcquisition DATETIME,TradeValue DECIMAL(25,4), ReasonForNotTradedCodeId NVARCHAR(500),
	CommentId_Ok INT, CommentId_TrdAftPClDate INT, CommentId_TrdWithoutPcl INT, CommentId_PclNotRq INT, CommentId_TrdDuringBlckout INT,
	CommentId_Pending INT, CommentId_QtyExceeds INT, CommentId_ValueExceeds INT, CommentId_QtyValueExceeds INT, CommentId_TradeDetailsNotSubmitted INT, CommentId_ContraTrade INT, 
	CommentId_PartiallyTraded INT, CommentId_BalanceTradeDetailsPending INT, ContraTradeQty DECIMAL(10,0), CommentText VARCHAR(MAX),ModeofAcquisition INT)
	
CREATE TABLE #tmpComments(CodeId INT, DisplayText VARCHAR(1000))

DECLARE @tmpPCLQty TABLE(PreclearanceId INT, TradeQty INT, TradeValue DECIMAL(25,4), CommentId INT, 
			TradingPolicyId INT, SecurityTypeCodeId INT, MinAcqDate DATETIME, TradeQtyLimit INT, TradeValueLimit DECIMAL(20,4), PercentageLimit DECIMAL(10,4), ValueFromPerc DECIMAL(20,4), PaidUpCapital DECIMAL(20,4))
	

DECLARE curTDds CURSOR FOR 
SELECT TransactionDetailsId FROM #tmpPreclearance
WHERE ((PreclearanceStatusId = @nPreclearanceStatus_Approved AND DateOfAcquisition IS NOT NULL) OR PreclearanceStatusId IS NULL)

INSERT INTO #tmpComments(CodeId, DisplayText)
SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
WHERE CodeGroupId = 167

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		INSERT INTO #tmpPreclearance(UserInfoId, CompanyName, PreclearanceId,TransactionMasterId)
		select  PR.UserInfoId, CompanyId,PR.PreclearanceRequestId , TM.TransactionMasterId from tra_PreclearanceRequest_NonImplementationCompany PR 
		JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId 
		Group by PR.UserInfoId, CompanyId ,PR.PreclearanceRequestId,  TM.TransactionMasterId
UNION 
		SELECT TM.UserInfoId,TD.CompanyId,NULL, TM.TransactionMasterId 
		FROM tra_TransactionMaster_OS TM LEFT JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId AND TM.TransactionStatusCodeId > 148002
		WHERE DisclosureTypeCodeId <> 147001 
		AND TM.PreclearanceRequestId IS NULL AND TM.TransactionStatusCodeId <> 148002

UPDATE tmpDisc
			SET 
			EmployeeId = UF.EmployeeId,
			DateOfSeparation = UF.DateOfSeparation,
			Category = CCategory.CodeName,
			SubCategory = CSubCategory.CodeName,
			StatusCodeId = CStatusCodeId.CodeName,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN CM.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			PAN = UF.PAN,
			DisplaySequenceNo = PR.DisplaySequenceNo,
			--PreclearanceId = PR.PreclearanceRequestId,
			--TransactionMasterId = TM.TransactionMasterId,
			TransactionDetailsId = TD.TransactionDetailsId,
			JoiningDate = DateOfBecomingInsider,			
			Designation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
			Grade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
			Location = UF.Location,
			Department = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
			--CompanyName = CM.CompanyName,
			TypeOfInsider = CUserType.CodeName,
			RequestDate = PR.CreatedOn,
			ISIN = CM.ISINCode,
			TransactionTypeCodeId = CTransactionTypeCodeId.CodeName,
			SecurityTypeCodeId = CSecurityTypeCodeId.CodeName,
			PreQuantity = CASE WHEN tmpDisc.PreclearanceId IS NOT NULL THEN PR.SecuritiesToBeTradedQty ELSE NULL END,
			PreValue = CASE WHEN tmpDisc.PreclearanceId IS NOT NULL THEN PR.SecuritiesToBeTradedValue ELSE NULL END,
			PreclearanceStatusId = CASE WHEN tmpDisc.PreclearanceId IS NOT NULL THEN PR.PreclearanceStatusCodeId ELSE NULL END,--CPreclearanceStatusId.CodeName,
			PreStatusDate = CASE WHEN tmpDisc.PreclearanceId IS NOT NULL THEN ELPre.EventDate ELSE NULL END,
			DateOfAcquisition = TD.DateOfAcquisition,
			BuyQuantity = CASE WHEN TD.TransactionTypeCodeId IS NULL 
					THEN NULL 
					ELSE CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell 
							THEN 0 
							ELSE TD.Quantity 
						END 
				END,
			SellQuantity = CASE WHEN TD.TransactionTypeCodeId IS NULL
					THEN NULL 
					ELSE CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell 
							THEN TD.Quantity 
							ELSE 0
						END
				END,
			TradeValue = TD.Value,
			ReasonForNotTradedCodeId = CASE WHEN tmpDisc.PreclearanceId IS NOT NULL THEN CReasonForNotTradedCodeId.CodeName ELSE NULL END,
			ModeofAcquisition = TD.ModeOfAcquisitionCodeId
			FROM #tmpPreclearance tmpDisc JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = tmpDisc.TransactionMasterId
			JOIN tra_PreclearanceRequest_NonImplementationCompany PR 
			ON Convert(Varchar,Pr.PreclearanceRequestId)=tmpDisc.PreclearanceId AND PR.UserInfoId = tmpDisc.UserInfoId AND PR.CompanyId = tmpDisc.CompanyName
				JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = PR.CompanyId 
				--LEFT JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId AND TM.PreclearanceRequestId IS NULL
				LEFT JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId --AND TM.TransactionStatusCodeId <> @nTransactionStatus_NotConfirmed
				JOIN usr_UserInfo UF ON UF.UserInfoId = tmpDisc.UserInfoId
				JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
				LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
				LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
				LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
				LEFT join com_Code CCategory on UF.Category = CCategory.CodeID
				LEFT JOIN com_Code CSubCategory ON UF.SubCategory = CSubCategory.CodeID
				LEFT JOIN com_Code CStatusCodeId ON UF.StatusCodeId = CStatusCodeId.CodeID
				LEFT JOIN com_Code CTransactionTypeCodeId ON CTransactionTypeCodeId.CodeID = PR.TransactionTypeCodeId
				LEFT JOIN com_Code CSecurityTypeCodeId ON CSecurityTypeCodeId.CodeID = PR.SecurityTypeCodeId
				LEFT JOIN com_Code CPreclearanceStatusId ON CPreclearanceStatusId.CodeID = PR.PreclearanceStatusCodeId
				LEFT JOIN com_Code CReasonForNotTradedCodeId ON CReasonForNotTradedCodeId.CodeID = PR.ReasonForNotTradingCodeId
				LEFT JOIN eve_EventLog ELPre ON ((PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Confirmed AND ELPre.EventCodeId = 153045)
												OR (PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Approved AND ELPre.EventCodeId = 153046)
												OR (PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Rejected AND ELPre.EventCodeId = 153047)
												)
												AND ELPre.MapToTypeCodeId = 132015 AND ELPre.MapToId = PR.PreclearanceRequestId
-- Update Applicable till date
UPDATE tmpData
			SET PreApplicableTill = ELApp.EventDate--CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE,TEMP.EventType,TEMP.WindowCloseDate))
			FROM #tmpPreclearance tmpData JOIN tra_TransactionMaster_OS TM ON tmpData.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
				JOIN eve_EventLog ELApp ON EventCodeId = 153067 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId		
UPDATE tmpDisc
		SET Request = REQT.Request FROM #tmpPreclearance tmpDisc 
		JOIN (select PR.UserInfoId,CompanyId , PR.PreclearanceRequestId, count(*) Request from tra_PreclearanceRequest_NonImplementationCompany PR JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId GROUP BY PR.UserInfoId , CompanyId , PR.PreclearanceRequestId) REQT 
		ON REQT.CompanyId = tmpDisc.CompanyName
		join rl_CompanyMasterList CM ON CM.RlCompanyId = REQT.CompanyId
UPDATE tmpDisc
		SET Approved = APPROT.Approved
		FROM #tmpPreclearance tmpDisc
		LEFT JOIN (select PR.UserInfoId,CompanyId , PR.PreclearanceRequestId, count(*) Approved from tra_PreclearanceRequest_NonImplementationCompany PR 
		JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId WHERE PreclearanceStatusCodeId = 144002 AND TM.PartiallyTradedFlag!=1 GROUP BY PR.UserInfoId , CompanyId, PR.PreclearanceRequestId) APPROT
		ON APPROT.CompanyId = tmpDisc.CompanyName AND tmpDisc.PreclearanceId = APPROT.PreclearanceRequestId
		JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = APPROT.CompanyId
UPDATE tmpDisc
		SET Rejected = REJT.Rejected
		FROM #tmpPreclearance tmpDisc
		LEFT JOIN (select PR.UserInfoId,CompanyId , PR.PreclearanceRequestId, count(*) Rejected from tra_PreclearanceRequest_NonImplementationCompany PR JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId WHERE PreclearanceStatusCodeId = 144003 GROUP BY PR.UserInfoId , CompanyId, PR.PreclearanceRequestId) REJT
		ON REJT.CompanyId = tmpDisc.CompanyName AND REJT.PreclearanceRequestId=tmpDisc.PreclearanceId
		JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = REJT.CompanyId
UPDATE tmpDisc
		SET Pending = PENT.Pending
		FROM #tmpPreclearance tmpDisc
		LEFT JOIN (select PR.UserInfoId,CompanyId , PR.PreclearanceRequestId, count(*) Pending from tra_PreclearanceRequest_NonImplementationCompany PR JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId WHERE PreclearanceStatusCodeId = 144001 GROUP BY PR.UserInfoId , CompanyId, PR.PreclearanceRequestId) PENT
		ON PENT.CompanyId = tmpDisc.CompanyName
		JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = PENT.CompanyId				
UPDATE tmpDisc
		SET Traded = CASE WHEN TRADET.Traded IS NULL THEN 0 ELSE TRADET.Traded END
		FROM #tmpPreclearance tmpDisc
		LEFT JOIN (select PR.UserInfoId,PR.CompanyId , PR.PreclearanceRequestId, count(*) Traded from tra_PreclearanceRequest_NonImplementationCompany PR 
		JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId
		 WHERE  TransactionStatusCodeId > 148002 GROUP BY PR.UserInfoId , PR.CompanyId, PR.PreclearanceRequestId) TRADET
		ON TRADET.PreclearanceRequestId = tmpDisc.PreclearanceId

INSERT INTO @tmpPCLQty(PreclearanceId, TradeQty, TradeValue)
SELECT distinct PreclearanceId, 0, 0
FROM #tmpPreclearance

UPDATE PCL
			SET TradeQty = PCLQty.TradeQty,
				TradeValue = PCLQty.TradeValue,
				TradingPolicyId = PCLQty.TradingPolicyId,
				--SecurityTypeCodeId = PCLQty.SecurityTypeCodeId,
				MinAcqDate = PCLQty.DateOfAcquisition
			FROM @tmpPCLQty PCL JOIN
			(SELECT PreclearanceId, SUM(Quantity) TradeQty, SUM(Value) TradeValue, MIN(TM.TradingPolicyId) AS TradingPolicyId, MIN(DateOfAcquisition) AS DateOfAcquisition
			FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
				JOIN @tmpPCLQty PCL ON TM.PreclearanceRequestId = PCL.PreclearanceId
			WHERE TM.TransactionStatusCodeId > 148002
			GROUP BY PreclearanceId) AS PCLQty ON PCL.PreclearanceId = PCLQty.PreclearanceId


UPDATE PCL
		SET CommentId = CASE --WHEN PR.SecuritiesToBeTradedQty < PCL.TradeQty AND PR.SecuritiesToBeTradedValue < PCL.TradeValue THEN @nPreclearanceComment_QtyValueExceeds
						WHEN PR.SecuritiesToBeTradedQty < PCL.TradeQty THEN @nPreclearanceComment_QtyExceeds
						--WHEN PR.SecuritiesToBeTradedValue < PCL.TradeValue THEN @nPreclearanceComment_ValueExceeds
						END
						FROM @tmpPCLQty PCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON PCL.PreclearanceId = PR.PreclearanceRequestId


-- Update comments
-- Pending - Preclearance not approved
UPDATE tmpData
			SET CommentId_Pending = @nPreclearanceComment_Pending
			FROM #tmpPreclearance tmpData
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Confirmed

-- Ok - Preclearance approved, and transaction done before applicable till date
UPDATE tmpData
			SET CommentId_Ok = @nPreclearanceComment_Ok
			FROM #tmpPreclearance tmpData
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved 
-- Trading After PCl Date - Preclearance approved, and transaction done after applicable till date
UPDATE tmpData
			SET CommentId_TrdAftPClDate = @nPreclearanceComment_TrdAftPClDate
			FROM #tmpPreclearance tmpData
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved 
				AND DateOfAcquisition IS NOT NULL 
				AND DateOfAcquisition > PreApplicableTill

UPDATE tmpData
			SET CommentId_PclNotRq = @nPreclearanceComment_PclNotRq
			FROM #tmpPreclearance tmpData JOIN tra_TransactionDetails TD ON tmpData.TransactionDetailsId = TD.TransactionDetailsId
			WHERE IsPLCReq = 0
			AND PreclearanceId IS NULL

--Trading without PCl - Preclearance is null
UPDATE tmpData
			SET CommentId_TrdWithoutPcl = (case when TTS.EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 then @nPreclearanceComment_TrdWithoutPcl else @nPreclearanceComment_PclNotRq end)
			FROM #tmpPreclearance tmpData JOIN tra_TransactionTypeSettings TTS on tmpData.ModeofAcquisition=TTS.MODE_OF_ACQUIS_CODE_ID AND tmpData.SecurityTypeCodeId=TTS.SECURITY_TYPE_CODE_ID AND tmpData.TransactionTypeCodeId=TTS.TRANS_TYPE_CODE_ID
			WHERE PreclearanceId IS NULL AND CommentId_PclNotRq IS NULL

UPDATE tmpData
			SET CommentId_PclNotRq = (case when TTS.EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 then @nPreclearanceComment_TrdWithoutPcl else @nPreclearanceComment_PclNotRq end)
			FROM #tmpPreclearance tmpData JOIN tra_TransactionTypeSettings TTS on tmpData.ModeofAcquisition=TTS.MODE_OF_ACQUIS_CODE_ID AND tmpData.SecurityTypeCodeId=TTS.SECURITY_TYPE_CODE_ID AND tmpData.TransactionTypeCodeId=TTS.TRANS_TYPE_CODE_ID
			WHERE PreclearanceId IS NULL AND CommentId_PclNotRq IS NULL
-- Traded More Than Pre-Clearance Approved Quantity
UPDATE tmpData
			SET CommentId_QtyExceeds = PCL.CommentId
			FROM #tmpPreclearance tmpData JOIN @tmpPCLQty PCL ON tmpData.PreclearanceId = PCL.PreclearanceId
			WHERE PCL.CommentId = @nPreclearanceComment_QtyExceeds

UPDATE tmpData
			SET CommentId_ValueExceeds = PCL.CommentId
			FROM #tmpPreclearance tmpData JOIN @tmpPCLQty PCL ON tmpData.PreclearanceId = PCL.PreclearanceId
			WHERE PCL.CommentId = @nPreclearanceComment_ValueExceeds

UPDATE tmpData
			SET CommentId_QtyValueExceeds = PCL.CommentId
			FROM #tmpPreclearance tmpData JOIN @tmpPCLQty PCL ON tmpData.PreclearanceId = PCL.PreclearanceId
			WHERE PCL.CommentId = @nPreclearanceComment_QtyValueExceeds
			
UPDATE tmpData
			SET CommentId_TradeDetailsNotSubmitted = @nPreclearanceComment_TradeDetailsNotSubmitted
			FROM #tmpPreclearance tmpData
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved AND tmpData.DateOfAcquisition IS NULL

-- Run cursor here
OPEN curTDds

FETCH NEXT FROM  curTDds
			INTO @nTransactionDetailsId

WHILE @@FETCH_STATUS = 0
			BEGIN
				
				INSERT INTO @tmpIsContraTradeForTd(TransactionDetailsId, IsContraTrade, ContraTradeQty)
				SELECT TransactionDetailsId, IsContraTrade, ContraTradeQty FROM dbo.uf_tra_IsContraTrade(@nTransactionDetailsId)
				
				FETCH NEXT FROM curTDds 
				INTO @nTransactionDetailsId
			END

			CLOSE curTDds;
			DEALLOCATE curTDds;

UPDATE tmpData
			SET CommentId_ContraTrade = @nPreclearanceComment_ContraTrade,
				ContraTradeQty = tmpIsContra.ContraTradeQty
			FROM #tmpPreclearance tmpData JOIN @tmpIsContraTradeForTd tmpIsContra ON tmpData.TransactionDetailsId = tmpIsContra.TransactionDetailsId
			WHERE --PreclearanceStatusId = @nPreclearanceStatus_Approved AND tmpData.DateOfAcquisition IS NOT NULL
			IsContraTrade = 1

UPDATE tmpData
			SET CommentText = ISNULL(tOk.DisplayText + ', ', '')
							+ ISNULL(tTrdAftPClDate.DisplayText + ', ', '')
							+ ISNULL(tTrdWithoutPcl.DisplayText + ', ', '')
							+ ISNULL(tPclNotRq.DisplayText + ', ', '')
							+ ISNULL(tTrdDuringBlckout.DisplayText + ', ', '')
							+ ISNULL(tPending.DisplayText + ', ', '')
							+ ISNULL(tQtyExceeds.DisplayText + ', ', '')
							+ ISNULL(tValueExceeds.DisplayText + ', ', '')
							+ ISNULL(tQtyValueExceeds.DisplayText + ', ', '')
							+ ISNULL(tTradeNotSubmitted.DisplayText + ', ', '')
							+ CASE WHEN tmpData.ContraTradeQty > 0 THEN ISNULL(tContraTrade.DisplayText + ' for ' + CONVERT(VARCHAR(20), tmpData.ContraTradeQty) + ' Qty, ', '') 
							              ELSE ISNULL(tContraTrade.DisplayText + ', ','') END
							+ ISNULL(tPartiallyTraded.DisplayText + ', ', '')
							+ ISNULL(tBalTrdDetailsPending.DisplayText + ', ', '')
			FROM #tmpPreclearance tmpData
				LEFT JOIN #tmpComments tOk ON tmpData.CommentId_Ok = tOk.CodeId AND tOk.CodeId = @nPreclearanceComment_Ok
				LEFT JOIN #tmpComments tTrdAftPClDate ON tmpData.CommentId_TrdAftPClDate = tTrdAftPClDate.CodeId AND tTrdAftPClDate.CodeId = @nPreclearanceComment_TrdAftPClDate
				LEFT JOIN #tmpComments tTrdWithoutPcl ON tmpData.CommentId_TrdWithoutPcl = tTrdWithoutPcl.CodeId AND tTrdWithoutPcl.CodeId = @nPreclearanceComment_TrdWithoutPcl
				LEFT JOIN #tmpComments tPclNotRq ON tmpData.CommentId_PclNotRq = tPclNotRq.CodeId AND tPclNotRq.CodeId = @nPreclearanceComment_PclNotRq
				LEFT JOIN #tmpComments tTrdDuringBlckout ON tmpData.CommentId_TrdDuringBlckout = tTrdDuringBlckout.CodeId AND tTrdDuringBlckout.CodeId = @nPreclearanceComment_TrdDuringBlckout
				LEFT JOIN #tmpComments tPending ON tmpData.CommentId_Pending = tPending.CodeId AND tPending.CodeId = @nPreclearanceComment_Pending
				LEFT JOIN #tmpComments tQtyExceeds ON tmpData.CommentId_QtyExceeds = tQtyExceeds.CodeId AND tQtyExceeds.CodeId = @nPreclearanceComment_QtyExceeds
				LEFT JOIN #tmpComments tValueExceeds ON tmpData.CommentId_ValueExceeds = tValueExceeds.CodeId AND tValueExceeds.CodeId = @nPreclearanceComment_ValueExceeds
				LEFT JOIN #tmpComments tQtyValueExceeds ON tmpData.CommentId_QtyValueExceeds = tQtyValueExceeds.CodeId AND tQtyValueExceeds.CodeId = @nPreclearanceComment_QtyValueExceeds
				LEFT JOIN #tmpComments tTradeNotSubmitted ON tmpData.CommentId_TradeDetailsNotSubmitted = tTradeNotSubmitted.CodeId AND tTradeNotSubmitted.CodeId = @nPreclearanceComment_TradeDetailsNotSubmitted
				LEFT JOIN #tmpComments tContraTrade ON tmpData.CommentId_ContraTrade = tContraTrade.CodeId AND tContraTrade.CodeId = @nPreclearanceComment_ContraTrade
				LEFT JOIN #tmpComments tPartiallyTraded ON tmpData.CommentId_PartiallyTraded = tPartiallyTraded.CodeId AND tPartiallyTraded.CodeId = @nPreclearanceComment_PartiallyTraded
				LEFT JOIN #tmpComments tBalTrdDetailsPending ON tmpData.CommentId_BalanceTradeDetailsPending = tBalTrdDetailsPending.CodeId AND tBalTrdDetailsPending.CodeId = @nPreclearanceComment_BalanceTradeDetailsPending
				
UPDATE #tmpPreclearance
			SET CommentText = SUBSTRING(CommentText, 1, DATALENGTH(CommentText) - 2)
			WHERE CommentText <> ''

IF(@EnableDisableQuantityValue = 400003)
 BEGIN
	SELECT @sSQL = 'SELECT EmployeeId AS [Employee ID], InsiderName AS [Insider Name],PAN, dbo.uf_rpt_FormatDateValue(JoiningDate,0) AS [Date of becoming insider] , dbo.uf_rpt_FormatDateValue(DateOfSeparation,0) AS [Date Of Separation],Designation,Grade,Location,Department,Category,SubCategory,CM.CompanyName AS [Company Name],TypeOfInsider AS [Type Of Insider],Request,Approved,Rejected,Pending,
	 Traded,CASE WHEN PreclearanceId IS NULL THEN '''+@sPNT+''' + CONVERT(NVARCHAR(MAX),DisplaySequenceNo) ELSE '''+@sPCL+''' + CONVERT(NVARCHAR(MAX),DisplaySequenceNo) END  AS [Pre-clearance ID]
	, dbo.uf_rpt_FormatDateValue(Requestdate,0) AS [Request date],ISIN,TransactionTypeCodeId AS [Transaction Type], SecurityTypeCodeId AS [Security Type],CPreclearanceStatusId.CodeName AS [Pre-Clearance Status], dbo.uf_rpt_FormatDateValue(PreStatusDate,0) AS [Approved/Rejected  date], dbo.uf_rpt_FormatDateValue(PreApplicableTill,0) AS [Applicable till]
	,BuyQuantity AS [BUY],SellQuantity AS [SELL], dbo.uf_rpt_FormatDateValue(DateOfAcquisition,0) AS [Date of Trasaction],TradeValue AS [Trade Value],ReasonForNotTradedCodeId AS [Reason for Not Traded],CommentText AS [Comments], 
	PreQuantity AS [Number of Securities],PreValue AS [Value]'
	SELECT @sSQL = @sSQL + 'from #tmpPreclearance tmpDisc JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = tmpDisc.CompanyName '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CPreclearanceStatusId ON CPreclearanceStatusId.CodeID = tmpDisc.PreclearanceStatusId '
	SELECT @sSQL = @sSQL + 'where 1= 1 '
	IF ((@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			  OR (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			  OR (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> '')
			   OR (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> ''))
	
			BEGIN
				IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
				BEGIN
					print '@inp_sEmployeeID'
					SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
				END
				IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
				BEGIN
					print '@inp_sInsiderName'
					SELECT @sSQL = @sSQL + ' AND InsiderName like ''%' + @inp_sInsiderName + '%'''
				
				END			
				IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
				BEGIN
					print '@inp_sPan'
					SELECT @sSQL = @sSQL + ' AND PAN like ''%' + @inp_sPan + '%'' '
					
				END
				IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
				BEGIN
					print '@inp_sCompanyName'
					SELECT @sSQL = @sSQL + ' AND CM.CompanyName like ''%' + @inp_sCompanyName + '%'''
				
				END
				IF (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> '')
					BEGIN
						print '@inp_dtDateOfTransactionFrom'
						SELECT @sSQL = @sSQL + ' AND DateOfAcquisition >= ''' + CONVERT(VARCHAR(11), @inp_dtDateOfTransactionFrom) + ''' '
					END
	  			IF (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> '')
					BEGIN
						print '@inp_dtDateOfTransactionTo'
						SELECT @sSQL = @sSQL + ' AND DateOfAcquisition < ''' + CONVERT(VARCHAR(11), DATEADD(D, 1, @inp_dtDateOfTransactionTo)) + ''' '
					
					END
			END
  END
ELSE
  BEGIN
     SELECT @sSQL = 'SELECT EmployeeId AS [Employee ID], InsiderName AS [Insider Name],PAN, dbo.uf_rpt_FormatDateValue(JoiningDate,0) AS [Date of becoming insider] , dbo.uf_rpt_FormatDateValue(DateOfSeparation,0) AS [Date Of Separation],Designation,Grade,Location,Department,Category,SubCategory,CM.CompanyName AS [Company Name],TypeOfInsider AS [Type Of Insider],Request,Approved,Rejected,Pending,
	 Traded,CASE WHEN PreclearanceId IS NULL THEN '''+@sPNT+''' + CONVERT(NVARCHAR(MAX),DisplaySequenceNo) ELSE '''+@sPCL+''' + CONVERT(NVARCHAR(MAX),DisplaySequenceNo) END  AS [Pre-clearance ID]
	, dbo.uf_rpt_FormatDateValue(Requestdate,0) AS [Request date],ISIN,TransactionTypeCodeId AS [Transaction Type], SecurityTypeCodeId AS [Security Type],PreQuantity AS [Number of Securities],PreValue AS [Value],CPreclearanceStatusId.CodeName AS [Pre-Clearance Status], dbo.uf_rpt_FormatDateValue(PreStatusDate,0) AS [Approved/Rejected  date], dbo.uf_rpt_FormatDateValue(PreApplicableTill,0) AS [Applicable till]
	,BuyQuantity AS [BUY],SellQuantity AS [SELL], dbo.uf_rpt_FormatDateValue(DateOfAcquisition,0) AS [Date of Trasaction],TradeValue AS [Trade Value],ReasonForNotTradedCodeId AS [Reason for Not Traded],CommentText AS [Comments] '
	SELECT @sSQL = @sSQL + 'from #tmpPreclearance tmpDisc JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = tmpDisc.CompanyName '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CPreclearanceStatusId ON CPreclearanceStatusId.CodeID = tmpDisc.PreclearanceStatusId '
	SELECT @sSQL = @sSQL + 'where 1= 1 '
	IF ((@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			  OR (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			  OR (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> '')
			   OR (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> ''))
	
			BEGIN
				IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
				BEGIN
					print '@inp_sEmployeeID'
					SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
				END
				IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
				BEGIN
					print '@inp_sInsiderName'
					SELECT @sSQL = @sSQL + ' AND InsiderName like ''%' + @inp_sInsiderName + '%'''
				
				END			
				IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
				BEGIN
					print '@inp_sPan'
					SELECT @sSQL = @sSQL + ' AND PAN like ''%' + @inp_sPan + '%'' '
					
				END
				IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
				BEGIN
					print '@inp_sCompanyName'
					SELECT @sSQL = @sSQL + ' AND CM.CompanyName like ''%' + @inp_sCompanyName + '%'''
				
				END
				IF (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> '')
					BEGIN
						print '@inp_dtDateOfTransactionFrom'
						SELECT @sSQL = @sSQL + ' AND DateOfAcquisition >= ''' + CONVERT(VARCHAR(11), @inp_dtDateOfTransactionFrom) + ''' '
					END
	  			IF (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> '')
					BEGIN
						print '@inp_dtDateOfTransactionTo'
						SELECT @sSQL = @sSQL + ' AND DateOfAcquisition < ''' + CONVERT(VARCHAR(11), DATEADD(D, 1, @inp_dtDateOfTransactionTo)) + ''' '
					
					END
			END
  END
print(@sSQL)
EXEC (@sSQL)
	
DROP TABLE #tmpPreclearance
DROP TABLE #tmpComments
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
