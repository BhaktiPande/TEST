IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PreclearanceEmployeeIndividual')
	DROP PROCEDURE st_rpt_PreclearanceEmployeeIndividual
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee wise report

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		18-Jun-2015

Modification History:
Modified By		Modified On		Description
Arundhati		23-Jun-2015		PNT, PCL prefix is added
Arundhati		01-Jul-2015		For Cahsless transactions Value is always considered as Value1 + Value2.
Arundhati		08-Jul-2015		Changes related to status "Traded more than approved qty"
Arundhati		14-Jul-2015		Comments are corrected for blackout period
								Comments are corrected for Quantity/value exceeds.
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Arundhati		23-Jul-2015		Filter on comma separated comments is added
Arundhati		31-Jul-2015		Condition for Clockout period for financial year event is added
Arundhati		03-Aug-2015		Added comment regarding Contra-Trade in the report	
Arundhati		14-Aug-2015		Preclearance Request date taken directly from table, rather than event log, as the event is not logged for the PCL getting approved automatically
Arundhati		01-Sep-2015		Changes in Comments due to Partial Trading
Arundhati		08-Sep-2015		PCL not required comment taken from TransactionDetails table.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Arundhati		03-Dec-2015		If Preclearance is not required, then comment Preclearance not taken should not be shown.
Arundhati		08-Dec-2015		Handled condition for ESOP pool and and finding contra trade quantity
Raghvendra		30-Dec-2015		Change to show - where data is not available Fix for Mantis bug 7889
ED				4-Jan-2016		Code integration done on 4-Jan-2016
Tushar			12-Jan-2016		resolved Issue in regarding comments text
Tushar			15-Jan-2016		PNT recoed considered for Contra Trade check
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
								Also made change to use "PreClrApprovalValidityLimit" field for calculating pre clearance valid till. (Earlier "PreClrCOApprovalLimit" field is used )
Tushar			15-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Parag			17-May-2016		Made change for not showing pre-clearance value exceed comment into report
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.


Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PreclearanceEmployeeIndividual]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	
	,@inp_iOutputSeq			INT -- 1: User details, 2: Transaction status details
	,@inp_iUserInfoId VARCHAR(MAX)
	,@inp_sPreclearanceID VARCHAR(100)
	
	,@inp_dtRequestDateFrom DATETIME
	,@inp_dtRequestDateTo DATETIME
	
	,@inp_sTransactionTypeCodeId VARCHAR(200)
	,@inp_sSecurityTypeCodeId VARCHAR(200)
	
	,@inp_sPreClearanceStatusCodeId VARCHAR(200)
	
	,@inp_dtApplicableTill INT

	,@inp_dtDateOfTransactionFrom DATETIME
	,@inp_dtDateOfTransactionTo DATETIME
	
	,@inp_sComment VARCHAR(200)

	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @nTransactionId INT = 0

	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003
	DECLARE @iIsTransCriteria INT = 0

	DECLARE @nPreclearanceStatus_Confirmed INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003
	
	DECLARE @nTransactionStatus_NotConfirmed INT = 148002

	--DECLARE @nTranasctionType_Buy INT =
	DECLARE @nTransactionType_Sell INT = 143002

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

	DECLARE @nDataType_String INT = 1

	DECLARE @sEmployeeID NVARCHAR(50)
	DECLARE @sInsiderName NVARCHAR(100)
	
	DECLARE @sPNT VARCHAR(10) = 'PNT'
	DECLARE @sPCL VARCHAR(10) = 'PCL'

	DECLARE @nTransactionDetailsId BIGINT
		
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	
	CREATE TABLE #tmpPreclearance(Id INT IDENTITY(1,1), UserInfoId INT, TransactionMasterId INT, TransactionMasterIdText VARCHAR(20), TransactionDetailsId INT, PreclearanceId VARCHAR(50), RequestDate DATETIME,
	ScripName VARCHAR(100), ISIN VARCHAR(100), TransactionTypeCodeId INT, SecurityTypeCodeId INT, PreQuantity INT, PreValue DECIMAL(25, 4),
	PreclearanceStatusId INT, PreStatusDate DATETIME, PreApplicableTill DATETIME, BuyQuantity INT, SellQuantity INT, DateOfAcquisition DATETIME,
	TradeValue DECIMAL(25,4), ReasonForNotTradedCodeId INT, 
	CommentId_Ok INT, CommentId_TrdAftPClDate INT, CommentId_TrdWithoutPcl INT, CommentId_PclNotRq INT, CommentId_TrdDuringBlckout INT,
	CommentId_Pending INT, CommentId_QtyExceeds INT, CommentId_ValueExceeds INT, CommentId_QtyValueExceeds INT, CommentId_TradeDetailsNotSubmitted INT, CommentId_ContraTrade INT, 
	CommentId_PartiallyTraded INT, CommentId_BalanceTradeDetailsPending INT, CommentText VARCHAR(MAX), ContraTradeQty DECIMAL(10,0),TradingPolicyId INT,ModeofAcquisition INT
	,UpdatedValidity DATETIME, Preclearance_comments VARCHAR(MAX),UpdatedNoOfSecurity INT)

	DECLARE @tmpPCLQty TABLE(PreclearanceId INT, TradeQty INT, TradeValue DECIMAL(25,4), CommentId INT, 
			TradingPolicyId INT, SecurityTypeCodeId INT, MinAcqDate DATETIME, TradeQtyLimit INT, TradeValueLimit DECIMAL(20,4), PercentageLimit DECIMAL(10,4), ValueFromPerc DECIMAL(20,4), PaidUpCapital DECIMAL(20,4))
	
	CREATE TABLE #tmpTransactionIds (TransactionMasterId INT, TransactionDetailsId INT)
	
	DECLARE @tmpTransactionIdForLimits TABLE (TransactionMasterId INT, TradeQty INT, TradeValue DECIMAL(25,4), 
				TradingPolicyId INT, SecurityTypeCodeId INT, MinAcqDate DATETIME, TradeQtyLimit INT, TradeValueLimit DECIMAL(20,4), PercentageLimit DECIMAL(10,4), ValueFromPerc DECIMAL(20,4), PaidUpCapital DECIMAL(20,4))
	
	DECLARE @tmpUserDetails TABLE(Id INT IDENTITY(1,1), RKey VARCHAR(20), Value VARCHAR(50), DataType INT)
	
	DECLARE curTDds CURSOR FOR 
	SELECT TransactionDetailsId FROM #tmpPreclearance
	WHERE ((PreclearanceStatusId = @nPreclearanceStatus_Approved AND DateOfAcquisition IS NOT NULL) OR PreclearanceStatusId IS NULL)
	
	
	DECLARE @tmpIsContraTradeForTd TABLE(TransactionDetailsId BIGINT, IsContraTrade INT, ContraTradeQty DECIMAL(10,0))
	
	CREATE TABLE #tmpComments(CodeId INT, DisplayText VARCHAR(1000))
	DECLARE @tmpComment TABLE(CommentId INT)
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print 'st_rpt_PreclearanceEmployeeIndividual'
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'TransactionMasterIdText'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'rpt_grd_19206'
		BEGIN
			SET @inp_sSortField = 'TransactionMasterIdText'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19207'
		BEGIN
			SET @inp_sSortField = 'Requestdate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19208'
		BEGIN
			SET @inp_sSortField = 'Scripname'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19209'
		BEGIN
			SET @inp_sSortField = 'ISIN'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19210'
		BEGIN
			SET @inp_sSortField = 'CTransaction.CodeName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19211'
		BEGIN
			SET @inp_sSortField = 'CSecurity.CodeName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19212'
		BEGIN
			SET @inp_sSortField = 'PreQuantity'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19213'
		BEGIN
			SET @inp_sSortField = 'PreValue'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19214'
		BEGIN
			SET @inp_sSortField = 'CPreStatus.CodeName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19215'
		BEGIN
			SET @inp_sSortField = 'PreStatusDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19216'
		BEGIN
			SET @inp_sSortField = 'PreApplicableTill'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19218'
		BEGIN
			SET @inp_sSortField = 'BuyQuantity'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19219'
		BEGIN
			SET @inp_sSortField = 'SellQuantity'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19220'
		BEGIN
			SET @inp_sSortField = 'DateOfAcquisition'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19221'
		BEGIN
			SET @inp_sSortField = 'TradeValue'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19222'
		BEGIN
			SET @inp_sSortField = 'CRsnNotTrd.CodeName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19223'
		BEGIN
			--SET @inp_sSortField = 'tComment.DisplayText'
			SET @inp_sSortField = 'CommentText'
		END

		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END
		
		INSERT INTO #tmpComments(CodeId, DisplayText)
		SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
		WHERE CodeGroupId = 167--BETWEEN 162001 AND 162003

		IF(@inp_sComment IS NOT NULL AND @inp_sComment <>'')
		BEGIN
			INSERT INTO @tmpComment SELECT * FROM uf_com_Split(@inp_sComment)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpComment
			SELECT CodeID FROM com_Code C WHERE CodeGroupId = 167		
		END
		IF ISNUMERIC(SUBSTRING(@inp_sPreclearanceID, 4, 10)) <> 0
		BEGIN
			SELECT @nTransactionId = SUBSTRING(@inp_sPreclearanceID, 4, 10)
		END

		IF @inp_iOutputSeq = 1
		BEGIN
			SELECT @sEmployeeID = EmployeeId, 
					@sInsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END
			FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId
			JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
			--LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
			--LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
			--LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
			WHERE UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT(@inp_iUserInfoId, ','))
					
			INSERT INTO @tmpUserDetails(RKey, Value, DataType)
			VALUES ('rpt_lbl_19173', @sEmployeeID, @nDataType_String),
				('rpt_lbl_19174', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sInsiderName),1)), @nDataType_String)

			INSERT INTO #tmpList(RowNumber, EntityID)
			VALUES (1,1)
				
			SELECT * FROM @tmpUserDetails ORDER BY ID
		END
		ELSE
		BEGIN

			SELECT @sSQL = 'SELECT TM.TransactionMasterId, TD.TransactionDetailsId '
			SELECT @sSQL = @sSQL + 'FROM tra_TransactionMaster TM LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId AND TM.TransactionStatusCodeId > 148002'
			SELECT @sSQL = @sSQL + 'LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId '
			SELECT @sSQL = @sSQL + 'LEFT JOIN eve_EventLog ELPreReq on ELPreReq.EventCodeId = 153015 AND ELPreReq.MapToTypeCodeId = 132004 AND ELPreReq.MapToId = PR.PreclearanceRequestId '
			SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
			SELECT @sSQL = @sSQL + 'AND DisclosureTypeCodeId <> 147001 AND TM.UserInfoId IN (' + CONVERT(VARCHAR(10), @inp_iUserInfoId) + ' ) '
			SELECT @sSQL = @sSQL + 'AND (TM.PreclearanceRequestId IS NOT NULL OR TM.TransactionStatusCodeId <> 148002) '
		
			IF ((@inp_sPreclearanceID IS NOT NULL AND @inp_sPreclearanceID <> '')
			  OR (@inp_dtRequestDateFrom IS NOT NULL AND @inp_dtRequestDateFrom <> '')
			  OR (@inp_dtRequestDateTo IS NOT NULL AND @inp_dtRequestDateTo <> '')
			  OR (@inp_sTransactionTypeCodeId IS NOT NULL AND @inp_sTransactionTypeCodeId <> '')
			  OR (@inp_sSecurityTypeCodeId IS NOT NULL AND @inp_sSecurityTypeCodeId <> '')
			  OR (@inp_sPreClearanceStatusCodeId IS NOT NULL AND @inp_sPreClearanceStatusCodeId <> '')
			  OR (@inp_dtApplicableTill IS NOT NULL AND @inp_dtApplicableTill <> '')
			  OR (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> 0)
			  OR (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> 0))
			BEGIN
				IF (@inp_sPreclearanceID IS NOT NULL AND @inp_sPreclearanceID <> '')
				BEGIN
					print '@inp_sPreclearanceID'
					--SELECT @sSQL = @sSQL + ' AND TM.TransactionMasterId = ' + CONVERT(VARCHAR(10), @nTransactionId)
					SELECT @sSQL = @sSQL + 'AND (''' + @sPCL + ''' + CONVERT(VARCHAR(10), ISNULL(ParentTransactionMasterId, TM.TransactionMasterId)) like ''%' + @inp_sPreclearanceID + '%'''
					SELECT @sSQL = @sSQL + 'OR ''' + @sPCL + ''' + CONVERT(VARCHAR(10), ISNULL(ParentTransactionMasterId, TM.TransactionMasterId)) like ''%' + @inp_sPreclearanceID + '%'')'
				END
				IF (@inp_dtRequestDateFrom IS NOT NULL AND @inp_dtRequestDateFrom <> '')
				BEGIN
					print '@inp_dtRequestDateFrom'
					SELECT @sSQL = @sSQL + ' AND ELPreReq.EventDate >= ''' + CONVERT(VARCHAR(11), @inp_dtRequestDateFrom) + ''' '
				END
  				IF (@inp_dtRequestDateTo IS NOT NULL AND @inp_dtRequestDateTo <> '')
				BEGIN
					print '@inp_dtRequestDateTo'
					SELECT @sSQL = @sSQL + ' AND ELPreReq.EventDate < ''' + CONVERT(VARCHAR(11), DATEADD(D, 1, @inp_dtRequestDateTo)) + ''' '
				
				END
  				IF (@inp_sTransactionTypeCodeId IS NOT NULL AND @inp_sTransactionTypeCodeId <> '')
				BEGIN
					print '@inp_sTransactionTypeCodeId'
					SELECT @sSQL = @sSQL + ' AND TD.TransactionTypeCodeId IN(' + @inp_sTransactionTypeCodeId + ') '
				
				END
  				IF (@inp_sSecurityTypeCodeId IS NOT NULL AND @inp_sSecurityTypeCodeId <> '')
				BEGIN
					print '@inp_sSecurityTypeCodeId'
					SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId IN (' + @inp_sSecurityTypeCodeId + ') '
				
				END
  				IF (@inp_sPreClearanceStatusCodeId IS NOT NULL AND @inp_sPreClearanceStatusCodeId <> '')
				BEGIN
					print '@inp_sPreClearanceStatusCodeId'
					SELECT @sSQL = @sSQL + ' AND PR.PreclearanceStatusCodeId IN(' + @inp_sPreClearanceStatusCodeId + ') '
				
				END
				IF (@inp_dtDateOfTransactionFrom IS NOT NULL AND @inp_dtDateOfTransactionFrom <> '')
				BEGIN
					print '@inp_dtDateOfTransactionFrom'
					SELECT @sSQL = @sSQL + ' AND TD.DateOfAcquisition >= ''' + CONVERT(VARCHAR(11), @inp_dtDateOfTransactionFrom) + ''' '
				END
  				IF (@inp_dtDateOfTransactionTo IS NOT NULL AND @inp_dtDateOfTransactionTo <> '')
				BEGIN
					print '@inp_dtDateOfTransactionTo'
					SELECT @sSQL = @sSQL + ' AND TD.DateOfAcquisition < ''' + CONVERT(VARCHAR(11), DATEADD(D, 1, @inp_dtDateOfTransactionTo)) + ''' '
				
				END
			END

			print 'Query1 final = ' + @sSQL

			INSERT INTO #tmpTransactionIds(TransactionMasterId, TransactionDetailsId)
			EXEC (@sSQL)
					
			INSERT INTO #tmpPreclearance(TransactionMasterId, TransactionMasterIdText, TransactionDetailsId, UserInfoId, PreclearanceId, RequestDate, ScripName, ISIN, TransactionTypeCodeId, SecurityTypeCodeId,
					PreQuantity, PreValue, PreclearanceStatusId, PreStatusDate,
					BuyQuantity, SellQuantity, DateOfAcquisition, TradeValue, ReasonForNotTradedCodeId,TradingPolicyId,ModeofAcquisition
					,UpdatedNoOfSecurity,Preclearance_comments,UpdatedValidity,PreApplicableTill
					)
			SELECT DISTINCT TM.TransactionMasterId, 
					CASE WHEN PR.PreclearanceRequestId IS NULL THEN @sPNT + CONVERT(VARCHAR(10), TM.DisplayRollingNumber) ELSE @sPCL + CONVERT(VARCHAR(10), TM.DisplayRollingNumber) END,
					TD.TransactionDetailsId, TM.UserInfoId, TM.PreclearanceRequestId, PR.CreatedOn/*ELPreReq.EventDate*/, C.CompanyName, C.ISINNumber,
					CASE WHEN PR.PreclearanceRequestId IS NULL THEN TD.TransactionTypeCodeId ELSE PR.TransactionTypeCodeId END, 
					CASE WHEN PR.PreclearanceRequestId IS NULL THEN TD.SecurityTypeCodeId ELSE PR.SecurityTypeCodeId END,
					PR.SecuritiesToBeTradedQtyOld, PR.SecuritiesToBeTradedValue, PR.PreclearanceStatusCodeId, ELPre.EventDate,
				CASE WHEN TD.TransactionTypeCodeId IS NULL 
					THEN NULL 
					ELSE CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell 
							THEN 0 
							ELSE TD.Quantity 
						END 
				END,
				CASE WHEN TD.TransactionTypeCodeId IS NULL
					THEN NULL 
					ELSE CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell 
							THEN TD.Quantity 
							ELSE TD.Quantity2 
						END
				END,
				TD.DateOfAcquisition, CASE WHEN TD.Value IS NULL THEN NULL ELSE TD.Value + TD.Value2 END, PR.ReasonForNotTradingCodeId,
				TM.TradingPolicyId,
				TD.ModeOfAcquisitionCodeId
				,PR.SecuritiesToBeTradedQty,
				PR.ReasonForApproval,
				PR.PreclearanceValidityDateUpdatedByCO,
				PR.PreclearanceValidityDateOld			
				FROM #tmpTransactionIds tmpTM JOIN tra_TransactionMaster TM ON tmpTM.TransactionMasterId = TM.TransactionMasterId
				JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
				JOIN mst_Company C ON UF.CompanyId = C.CompanyId
				LEFT JOIN tra_TransactionDetails TD ON TM.TransactionStatusCodeId <> @nTransactionStatus_NotConfirmed AND TM.TransactionMasterId = TD.TransactionMasterId AND tmpTM.TransactionDetailsId = TD.TransactionDetailsId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				--LEFT JOIN eve_EventLog ELPreReq ON ELPreReq.EventCodeId = 153015 AND ELPreReq.MapToTypeCodeId = 132004 AND ELPreReq.MapToId = PR.PreclearanceRequestId
				LEFT JOIN eve_EventLog ELPre ON ((PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Confirmed AND ELPre.EventCodeId = 153015)
												OR (PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Approved AND ELPre.EventCodeId = 153016)
												OR (PR.PreclearanceStatusCodeId = @nPreclearanceStatus_Rejected AND ELPre.EventCodeId = 153017)
												)
												AND ELPre.MapToTypeCodeId = 132004 AND ELPre.MapToId = PR.PreclearanceRequestId
			
			
			-- Update Applicable till date
			--UPDATE tmpData
			--SET PreApplicableTill = ELApp.EventDate--CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE,TEMP.EventType,TEMP.WindowCloseDate))
			--FROM #tmpPreclearance tmpData JOIN tra_TransactionMaster TM ON tmpData.TransactionMasterId = TM.TransactionMasterId
			--	JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			--	JOIN eve_EventLog ELApp ON EventCodeId = 153018 AND ELApp.MapToTypeCodeId = 132004 AND ELApp.MapToId = TM.PreclearanceRequestId		
		
			INSERT INTO @tmpPCLQty(PreclearanceId, TradeQty, TradeValue)
			SELECT distinct PreclearanceId, 0, 0
			FROM #tmpPreclearance
			
			UPDATE PCL
			SET TradeQty = PCLQty.TradeQty,
				TradeValue = PCLQty.TradeValue,
				TradingPolicyId = PCLQty.TradingPolicyId,
				SecurityTypeCodeId = PCLQty.SecurityTypeCodeId,
				MinAcqDate = PCLQty.DateOfAcquisition
			FROM @tmpPCLQty PCL JOIN
			(SELECT PreclearanceId, SUM(Quantity) TradeQty, SUM(Value) TradeValue, MIN(TM.TradingPolicyId) AS TradingPolicyId, MIN(TM.SecurityTypeCodeId) AS SecurityTypeCodeId, MIN(DateOfAcquisition) AS DateOfAcquisition
			FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				JOIN @tmpPCLQty PCL ON TM.PreclearanceRequestId = PCL.PreclearanceId
			WHERE TM.TransactionStatusCodeId > 148002
			GROUP BY PreclearanceId) AS PCLQty ON PCL.PreclearanceId = PCLQty.PreclearanceId
			
			UPDATE PCL
			SET CommentId = CASE --WHEN PR.SecuritiesToBeTradedQty < PCL.TradeQty AND PR.SecuritiesToBeTradedValue < PCL.TradeValue THEN @nPreclearanceComment_QtyValueExceeds
								WHEN PR.SecuritiesToBeTradedQty < PCL.TradeQty THEN @nPreclearanceComment_QtyExceeds
								--WHEN PR.SecuritiesToBeTradedValue < PCL.TradeValue THEN @nPreclearanceComment_ValueExceeds
							END
			FROM @tmpPCLQty PCL JOIN tra_PreclearanceRequest PR ON PCL.PreclearanceId = PR.PreclearanceRequestId
			
			-- Update PCL for limits
			UPDATE PCL
			SET PCL.TradeQtyLimit = TPSL.NoOfShares,
				PCL.TradeValueLimit = TPSL.ValueOfShares,
				PCL.PercentageLimit = TPSL.PercPaidSubscribedCap
			FROM @tmpPCLQty PCL JOIN rul_TradingPolicy TP ON PCL.TradingPolicyId = TP.TradingPolicyId
				JOIN rul_TradingPolicySecuritywiseLimits TPSL ON TP.TradingPolicyId = TPSL.TradingPolicyId AND TPSL.MapToTypeCodeId = 132004
					AND (TPSL.SecurityTypeCodeId IS NULL OR TPSL.SecurityTypeCodeId = PCL.SecurityTypeCodeId)
			
			-- Update PCL with latest PaidUpCapital value
			UPDATE PCL
			SET PCL.PaidUpCapital = Cap.PaidUpShare
			FROM @tmpPCLQty PCL
			JOIN (SELECT PCL1.MinAcqDate, MAX(Cap.PaidUpAndSubscribedShareCapitalDate) AS CapDt
					FROM @tmpPCLQty PCL1 JOIN mst_Company C ON IsImplementing = 1
						JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID AND cap.PaidUpAndSubscribedShareCapitalDate <= PCL1.MinAcqDate
					GROUP BY PCL1.MinAcqDate) AS Cap1 ON PCL.MinAcqDate = Cap1.MinAcqDate
					JOIN mst_Company C ON IsImplementing = 1
						JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID AND Cap1.CapDt = Cap.PaidUpAndSubscribedShareCapitalDate

			UPDATE @tmpPCLQty
			SET ValueFromPerc = PercentageLimit * PaidUpCapital / 100.0
			WHERE PercentageLimit IS NOT NULL 
				AND PaidUpCapital IS NOT NULL
			
			---------------------------------------------------------------------------------------------
			-- Find limits for transactions of type PNT	
			INSERT INTO @tmpTransactionIdForLimits(TransactionMasterId, TradingPolicyId)
			SELECT TM.TransactionMasterId, TradingPolicyId
			FROM #tmpTransactionIds tmpTM JOIN tra_TransactionMaster TM ON tmpTM.TransactionMasterId = TM.TransactionMasterId
			WHERE PreclearanceRequestId IS NULL

			UPDATE tmpTMLimit
			SET TradeQty = TMQty.TradeQty,
				TradeValue = TMQty.TradeValue,
				SecurityTypeCodeId = TMQty.SecurityTypeCodeId,
				MinAcqDate = TMQty.DateOfAcquisition
			FROM @tmpTransactionIdForLimits tmpTMLimit JOIN
			(SELECT TM.TransactionMasterId, SUM(Quantity) TradeQty, SUM(Value) TradeValue, MIN(TM.SecurityTypeCodeId) AS SecurityTypeCodeId, MIN(DateOfAcquisition) AS DateOfAcquisition
			FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				JOIN @tmpTransactionIdForLimits tmpTMLimit ON TM.TransactionMasterId = tmpTMLimit.TransactionMasterId
			WHERE TM.TransactionStatusCodeId > 148002
			GROUP BY TM.TransactionMasterId) AS TMQty ON tmpTMLimit.TransactionMasterId = TMQty.TransactionMasterId

			UPDATE tmpTMLimit
			SET tmpTMLimit.TradeQtyLimit = TPSL.NoOfShares,
				tmpTMLimit.TradeValueLimit = TPSL.ValueOfShares,
				tmpTMLimit.PercentageLimit = TPSL.PercPaidSubscribedCap
			FROM @tmpTransactionIdForLimits tmpTMLimit JOIN rul_TradingPolicy TP ON tmpTMLimit.TradingPolicyId = TP.TradingPolicyId
				JOIN rul_TradingPolicySecuritywiseLimits TPSL ON TP.TradingPolicyId = TPSL.TradingPolicyId AND TPSL.MapToTypeCodeId = 132004
					AND (TPSL.SecurityTypeCodeId IS NULL OR TPSL.SecurityTypeCodeId = tmpTMLimit.SecurityTypeCodeId)

			-- Update PCL with latest PaidUpCapital value
			UPDATE tmpTMLimit
			SET tmpTMLimit.PaidUpCapital = Cap.PaidUpShare
			FROM @tmpTransactionIdForLimits tmpTMLimit
			JOIN (SELECT tmpTMLimit1.MinAcqDate, MAX(Cap.PaidUpAndSubscribedShareCapitalDate) AS CapDt
					FROM @tmpTransactionIdForLimits tmpTMLimit1 JOIN mst_Company C ON IsImplementing = 1
						JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID AND cap.PaidUpAndSubscribedShareCapitalDate <= tmpTMLimit1.MinAcqDate
					GROUP BY tmpTMLimit1.MinAcqDate) AS Cap1 ON tmpTMLimit.MinAcqDate = Cap1.MinAcqDate
					JOIN mst_Company C ON IsImplementing = 1
						JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID AND Cap1.CapDt = Cap.PaidUpAndSubscribedShareCapitalDate

			UPDATE @tmpTransactionIdForLimits
			SET ValueFromPerc = PercentageLimit * PaidUpCapital / 100.0
			WHERE PercentageLimit IS NOT NULL 
				AND PaidUpCapital IS NOT NULL
				
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
			--	AND DateOfAcquisition IS NOT NULL 
			--	AND DateOfAcquisition < DATEADD(D, 1, PreApplicableTill)
			
			-- Trading After PCl Date - Preclearance approved, and transaction done after applicable till date
			UPDATE tmpData
			SET CommentId_TrdAftPClDate = @nPreclearanceComment_TrdAftPClDate
			FROM #tmpPreclearance tmpData
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved 
				AND DateOfAcquisition IS NOT NULL 
				AND DateOfAcquisition > PreApplicableTill
			
			---- PCl not req - Preclearance not req
			--UPDATE tmpData
			--SET CommentId_PclNotRq = @nPreclearanceComment_PclNotRq
			--FROM #tmpPreclearance tmpData  JOIN tra_TransactionMaster TM ON tmpData.TransactionMasterId = TM.TransactionMasterId
			--	LEFT JOIN rul_TradingPolicyForTransactionMode TPTM ON TM.TradingPolicyId = TPTM.TradingPolicyId AND MapToTypeCodeId = 132004
			--		AND TPTM.TransactionModeCodeId = tmpData.TransactionTypeCodeId
			--WHERE PreclearanceId IS NULL AND TPTM.TradingPolicyId IS NULL

			--UPDATE tmpData
			--SET CommentId_PclNotRq = @nPreclearanceComment_PclNotRq
			--FROM #tmpPreclearance tmpData JOIN @tmpTransactionIdForLimits tmpTMLimit ON tmpData.TransactionMasterId = tmpTMLimit.TransactionMasterId
			--WHERE (tmpTMLimit.TradeQtyLimit IS NULL OR tmpTMLimit.TradeQtyLimit >= tmpTMLimit.TradeQty)
			--	AND (tmpTMLimit.TradeQtyLimit IS NULL OR tmpTMLimit.TradeValueLimit >= tmpTMLimit.TradeValue)
			--	AND (tmpTMLimit.ValueFromPerc IS NULL OR tmpTMLimit.ValueFromPerc >= tmpTMLimit.TradeValue)

			--UPDATE tmpData
			--SET CommentId_PclNotRq = @nPreclearanceComment_PclNotRq
			--FROM #tmpPreclearance tmpData JOIN @tmpPCLQty tmpPCLLimit ON tmpData.PreclearanceId = tmpPCLLimit.PreclearanceId
			--WHERE (tmpPCLLimit.TradeQtyLimit IS NULL OR tmpPCLLimit.TradeQtyLimit >= tmpPCLLimit.TradeQty)
			--	AND (tmpPCLLimit.TradeQtyLimit IS NULL OR tmpPCLLimit.TradeValueLimit >= tmpPCLLimit.TradeValue)
			--	AND (tmpPCLLimit.ValueFromPerc IS NULL OR tmpPCLLimit.ValueFromPerc >= tmpPCLLimit.TradeValue)
			--	AND PreclearanceStatusId = @nPreclearanceStatus_Approved

			UPDATE tmpData
			SET CommentId_PclNotRq = @nPreclearanceComment_PclNotRq
			FROM #tmpPreclearance tmpData JOIN tra_TransactionDetails TD ON tmpData.TransactionDetailsId = TD.TransactionDetailsId
			WHERE IsPLCReq = 0
				AND PreclearanceId IS NULL
							
			-- Trading without PCl - Preclearance is null
			UPDATE tmpData
			SET CommentId_TrdWithoutPcl = (case when TTS.EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 then @nPreclearanceComment_TrdWithoutPcl else @nPreclearanceComment_PclNotRq end)
			FROM #tmpPreclearance tmpData JOIN tra_TransactionTypeSettings TTS on tmpData.ModeofAcquisition=TTS.MODE_OF_ACQUIS_CODE_ID AND tmpData.SecurityTypeCodeId=TTS.SECURITY_TYPE_CODE_ID AND tmpData.TransactionTypeCodeId=TTS.TRANS_TYPE_CODE_ID
			WHERE PreclearanceId IS NULL AND CommentId_PclNotRq IS NULL
		
			UPDATE tmpData
			SET CommentId_PclNotRq = (case when TTS.EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 then @nPreclearanceComment_TrdWithoutPcl else @nPreclearanceComment_PclNotRq end)
			FROM #tmpPreclearance tmpData JOIN tra_TransactionTypeSettings TTS on tmpData.ModeofAcquisition=TTS.MODE_OF_ACQUIS_CODE_ID AND tmpData.SecurityTypeCodeId=TTS.SECURITY_TYPE_CODE_ID AND tmpData.TransactionTypeCodeId=TTS.TRANS_TYPE_CODE_ID
			WHERE PreclearanceId IS NULL AND CommentId_PclNotRq IS NULL
				
			--- Traded during blackout
			-- Preclearance Not Taken
			UPDATE tmpData 
			SET CommentId_TrdDuringBlckout = @nPreclearanceComment_TrdDuringBlckout
	        FROM #tmpPreclearance tmpData JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.UserInfoId = tmpData.UserInfoId
			JOIN rul_TradingWindowEvent TWE ON vwTWE.MapToId = TWE.TradingWindowEventId
			WHERE TWE.WindowCloseDate <= DateOfAcquisition AND DateOfAcquisition <= TWE.WindowOpenDate 
				--AND PreclearanceId IS NULL

			-- Preclearance taken
			--UPDATE tmpData 
			--SET CommentId_TrdDuringBlckout = @nPreclearanceComment_TrdDuringBlckout
			--FROM #tmpPreclearance tmpData JOIN tra_TransactionMaster TM ON tmpData.TransactionMasterId = TM.TransactionMasterId
			--	JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.UserInfoId = tmpData.UserInfoId
			--	JOIN rul_TradingWindowEvent TWE ON vwTWE.MapToId = TWE.TradingWindowEventId
			--	JOIN rul_TradingPolicyForTransactionMode TPTM ON TM.TradingPolicyId = TPTM.TradingPolicyId AND MapToTypeCodeId = 132007
			--		AND TPTM.TransactionModeCodeId = tmpData.TransactionTypeCodeId
			--WHERE TWE.WindowCloseDate <= DateOfAcquisition AND DateOfAcquisition <= TWE.WindowOpenDate
			--	AND PreclearanceId IS NOT NULL

			-- Blockout during Financial year events
			UPDATE tmpData 
			SET CommentId_TrdDuringBlckout = @nPreclearanceComment_TrdDuringBlckout
			FROM #tmpPreclearance tmpData JOIN rul_TradingWindowEvent TWE ON TWE.EventTypeCodeId = 126001
			WHERE TWE.WindowCloseDate <= DateOfAcquisition AND DateOfAcquisition <= TWE.WindowOpenDate
			
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

			--UPDATE tmpData
			--SET CommentId_ContraTrade = CASE WHEN dbo.uf_tra_IsContraTrade(tmpData.TransactionDetailsId) = 1 THEN @nPreclearanceComment_ContraTrade ELSE NULL END
			--FROM #tmpPreclearance tmpData
			--WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved AND tmpData.DateOfAcquisition IS NOT NULL
			
			UPDATE tmpData
			SET CommentId_ContraTrade = @nPreclearanceComment_ContraTrade,
				ContraTradeQty = tmpIsContra.ContraTradeQty
			FROM #tmpPreclearance tmpData JOIN @tmpIsContraTradeForTd tmpIsContra ON tmpData.TransactionDetailsId = tmpIsContra.TransactionDetailsId
			WHERE --PreclearanceStatusId = @nPreclearanceStatus_Approved AND tmpData.DateOfAcquisition IS NOT NULL
				IsContraTrade = 1

			UPDATE tmpData
			SET CommentId_PartiallyTraded = @nPreclearanceComment_PartiallyTraded,
				CommentId_BalanceTradeDetailsPending = CASE WHEN PR.ReasonForNotTradingCodeId IS NULL AND IsPartiallyTraded = 1 THEN @nPreclearanceComment_BalanceTradeDetailsPending ELSE CommentId_BalanceTradeDetailsPending END
			FROM #tmpPreclearance tmpData JOIN tra_PreclearanceRequest PR ON tmpData.PreclearanceId = PR.PreclearanceRequestId
			WHERE PreclearanceStatusId = @nPreclearanceStatus_Approved AND tmpData.DateOfAcquisition IS NOT NULL
				AND IsPartiallyTraded <> 0
			
			
			--UPDATE tmpData
			--SET CommentId_Ok = NULL
			--FROM #tmpPreclearance tmpData
			--WHERE CommentId_TrdAftPClDate IS NOT NULL
			--	OR CommentId_TrdWithoutPcl IS NOT NULL
			--	OR CommentId_PclNotRq IS NOT NULL
			--	OR CommentId_TrdDuringBlckout IS NOT NULL
			--	OR CommentId_Pending IS NOT NULL
			--	OR CommentId_QtyExceeds IS NOT NULL
			--	OR CommentId_ValueExceeds IS NOT NULL
			--	OR CommentId_QtyValueExceeds IS NOT NULL
			--	OR CommentId_TradeDetailsNotSubmitted IS NOT NULL
			
			IF @inp_sComment IS NOT NULL AND @inp_sComment <> ''
			BEGIN
				DELETE tmpPCL
				FROM #tmpPreclearance tmpPCL LEFT JOIN @tmpComment tComment ON tmpPCL.CommentId_Ok = tComment.CommentId
					OR CommentId_TrdAftPClDate  = tComment.CommentId
					OR CommentId_TrdWithoutPcl  = tComment.CommentId
					OR CommentId_PclNotRq  = tComment.CommentId
					OR CommentId_TrdDuringBlckout  = tComment.CommentId
					OR CommentId_Pending  = tComment.CommentId
					OR CommentId_QtyExceeds  = tComment.CommentId
					OR CommentId_ValueExceeds  = tComment.CommentId
					OR CommentId_QtyValueExceeds  = tComment.CommentId
					OR CommentId_TradeDetailsNotSubmitted  = tComment.CommentId
					OR CommentId_ContraTrade  = tComment.CommentId
					OR CommentId_PartiallyTraded  = tComment.CommentId
					OR CommentId_BalanceTradeDetailsPending  = tComment.CommentId
				WHERE tComment.CommentId IS NULL
				
				--DELETE FROM #tmpPreclearance
				--WHERE (@inp_iComment = @nPreclearanceComment_Ok AND CommentId_Ok IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_TrdAftPClDate AND CommentId_TrdAftPClDate IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_TrdWithoutPcl AND CommentId_TrdWithoutPcl IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_PclNotRq AND CommentId_PclNotRq IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_TrdDuringBlckout AND CommentId_TrdDuringBlckout IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_Pending AND CommentId_Pending IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_QtyExceeds AND CommentId_QtyExceeds IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_ValueExceeds AND CommentId_ValueExceeds IS NULL)
				--	OR(@inp_iComment = @nPreclearanceComment_QtyValueExceeds AND CommentId_QtyValueExceeds IS NULL)
				
				--DELETE FROM #tmpPreclearance
				--WHERE CommentId <> @inp_iComment
			END
			
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
				
			SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
			SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
			SELECT @sSQL = @sSQL + 'FROM #tmpPreclearance ID '
			SELECT @sSQL = @sSQL + 'JOIN com_Code CTransaction ON ID.TransactionTypeCodeId = CTransaction.CodeID '
			SELECT @sSQL = @sSQL + 'JOIN com_Code CSecurity ON ID.SecurityTypeCodeId = CSecurity.CodeID '
			SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CPreStatus ON ID.PreclearanceStatusId = CPreStatus.CodeID '
			SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CRsnNotTrd ON ID.ReasonForNotTradedCodeId = CRsnNotTrd.CodeID '
			--SELECT @sSQL = @sSQL + 'LEFT JOIN #tmpComments tComment ON ID.CommentId = tComment.CodeId '
			
			print @sSQL
			EXEC (@sSQL)
			SELECT 
				tmpData.UserInfoId,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN tmpData.TransactionMasterIdText ELSE '' END AS rpt_grd_19206,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatDateValue(Requestdate,0) ELSE null END AS rpt_grd_19207,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN Scripname ELSE '' END AS rpt_grd_19208,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN ISIN ELSE '' END AS rpt_grd_19209,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN CTransaction.CodeName ELSE '' END AS rpt_grd_19210,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN CSecurity.CodeName ELSE '' END AS rpt_grd_19211,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),PreQuantity),1) ELSE null END AS rpt_grd_19212,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),PreValue),1) ELSE null END AS rpt_grd_19213,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),CPreStatus.CodeName),1) ELSE '' END AS rpt_grd_19214,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatDateValue(PreStatusDate,0) ELSE null END AS rpt_grd_19215,
				CASE WHEN TM.ParentTransactionMasterId IS NULL THEN dbo.uf_rpt_FormatDateValue(PreApplicableTill,0) ELSE null END AS rpt_grd_19216,
				 --AS rpt_grd_19225,
				--Trade AS rpt_grd_19217,
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),BuyQuantity),1) AS rpt_grd_19218,
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),SellQuantity),1) AS rpt_grd_19219,
				dbo.uf_rpt_FormatDateValue(DateOfAcquisition,0) AS rpt_grd_19220,
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),TradeValue),1) AS rpt_grd_19221,
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),CRsnNotTrd.CodeName),1) AS rpt_grd_19222,
				 --AS rpt_grd_19226,
				--tComment.DisplayText AS rpt_grd_19223, -- Comment
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),CommentText),1) AS rpt_grd_19223, -- Comment
				PreclearanceId,
				TM.TransactionStatusCodeId,
				tmpData.TransactionTypeCodeId,
				--tmpData.commentt,
				PreclearanceStatusId,
				TransactionDetailsId
				,tmpData.UpdatedNoOfSecurity AS usr_grd_52131,
				dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),tmpData.Preclearance_comments),1) AS usr_grd_52132,
				dbo.uf_rpt_FormatDateValue(tmpData.UpdatedValidity,0) AS usr_grd_52133
			FROM #tmpList t JOIN #tmpPreclearance tmpData ON t.EntityID = tmpData.Id
				JOIN com_Code CTransaction ON tmpData.TransactionTypeCodeId = CTransaction.CodeID
				JOIN com_Code CSecurity ON tmpData.SecurityTypeCodeId = CSecurity.CodeID
				LEFT JOIN tra_TransactionMaster TM ON tmpData.TransactionMasterId = TM.TransactionMasterId
				LEFT JOIN com_Code CPreStatus ON tmpData.PreclearanceStatusId = CPreStatus.CodeID
				LEFT JOIN com_Code CRsnNotTrd ON tmpData.ReasonForNotTradedCodeId = CRsnNotTrd.CodeID
				--LEFT JOIN #tmpComments tComment ON tmpData.CommentId = tComment.CodeId
			WHERE ((@inp_iPageSize = 0)
						OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			--ORDER BY T.RowNumber 
			ORDER BY rpt_grd_19206, rpt_grd_19207  DESC
		END
		/*
		SELECT @sSQL = 'SELECT UserInfoId, '
		SELECT @sSQL = @sSQL + 'EmployeeId AS rpt_grd_19191, '
		SELECT @sSQL = @sSQL + 'InsiderName AS rpt_grd_19192, '
		SELECT @sSQL = @sSQL + 'JoiningDate AS rpt_grd_19193, '
		SELECT @sSQL = @sSQL + 'Designation AS rpt_grd_19194, '
		SELECT @sSQL = @sSQL + 'Grade AS rpt_grd_19195, '
		SELECT @sSQL = @sSQL + 'Location AS rpt_grd_19196, '
		SELECT @sSQL = @sSQL + 'Department AS rpt_grd_19197, '
		SELECT @sSQL = @sSQL + 'CompanyName AS rpt_grd_19198, '
		SELECT @sSQL = @sSQL + 'TypeOfInsider AS rpt_grd_19199, '
		SELECT @sSQL = @sSQL + 'Request AS rpt_grd_19201, '
		SELECT @sSQL = @sSQL + 'Approved AS rpt_grd_19202, '
		SELECT @sSQL = @sSQL + 'Rejected AS rpt_grd_19203, '
		SELECT @sSQL = @sSQL + 'Pending AS rpt_grd_19204, '
		SELECT @sSQL = @sSQL + 'Traded AS rpt_grd_19205 '
		SELECT @sSQL = @sSQL + 'FROM #tmpList t JOIN #tmpPreclearance ID ON t.EntityID = ID.UserInfoId '
		SELECT @sSQL = @sSQL + 'WHERE ID.UserInfoID IS NOT NULL '
		SELECT @sSQL = @sSQL + 'AND ((' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' = 0) '
		SELECT @sSQL = @sSQL + 'OR (T.RowNumber BETWEEN ((' + CONVERT(VARCHAR(10), @inp_iPageNo) + ' - 1) * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' + 1) '
		SELECT @sSQL = @sSQL + 'AND (' + CONVERT(VARCHAR(10), @inp_iPageNo) +  ' * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + '))) '
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
		
		print @sSQL
		EXEC (@sSQL)
		*/
		--SELECT 'debug1', * FROM #tmpPreclearance ID JOIN com_Code CComment ON ID.CommentId = CComment.CodeID
		--JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
		
		--SELECT ID.CompanyName AS rpt_grd_20001
		--FROM #tmpPreclearance ID
		
		DROP TABLE #tmpPreclearance
		DROP TABLE #tmpComments
		DROP TABLE #tmpTransactionIds
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
