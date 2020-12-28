IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_ContinuousDisclosureEmployeeIndividual')
DROP PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeIndividual]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee individual

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Jun-2015

Modification History:
Modified By		Modified On		Description
Arundhati		01-Jul-2015		For Cahsless transactions Value is always considered as Value1 + Value2.
Arundahti		08-Jul-2015		Last Submission Date for continuous disclosure for which preclearance is approved, was not correct.
								Also only continuous and PE disclosures are shown in this report. (Bug #7644, #7884)
Arundhati		13-Jul-2015		Comments were not shown for Continuous disclosures. Also Last submission date for PNT.
Raghvendra		18-Jul-2015		Added a field for TransactionMasterId for SoftCopy and HardCopy submission dates. This is for adding a view link to the corresponding letter screen
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Arundhati		22-Jul-2015		Handled filters for comma separated list of comments, AccountHolder, ScipName, ISIN
Arundahti		24-Jul-2015		Filter for Req/Not req is handled
Raghvendra		29-Oct-2015		Fix for returning the dates in required format so that it can be seen correctly in Excel download.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Arundhati		27-Nov-2015		Not Required is shown in the columns for Soft Copy and Hard Copy, if it is not required
								Handled case for Stock exchange submission as well
ED				04-Jan-2016		Code integration done on 4-Jan-2016								
ED				08-Jan-2016		Code integration done on 8-Jan-2016
Tushar			22-Jan-2016		Change for Non Trading days count.
Tushar			22-Jan-2016		Change for Non Trading days count.
Tushar			05-Jan-2016		resolved Soft Copy & Hard Copy of Continuous Disclosures Submission is "Not Required". In this case, 
								in report, system should show "Not Required" in "Continuous Disclosure to stock exchange submission date" 
								column. Currently.
Parag			13-May-2016		made change to show user details save at time of transaction submitted
Priyanka		22-Feb-2017     Update Last Submission Date for continuous disclosure 

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeIndividual]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iOutputSeq			INT -- 1: User details, 2: Transaction status details, 3: Transaction Details
	,@inp_iUserInfoId			VARCHAR(MAX) -- = 339
	,@inp_sDMATDetailsId		VARCHAR(200) -- Comma separated DMAt ids 1, 2, 3
	,@inp_sAccountHolder		NVARCHAR(Max)
	,@inp_sRelationTypeCodeId	VARCHAR(200) -- Null: Filter not applicable, 0: Self, NonZero: Actual relation id (Comma separated ids)
	,@inp_sScripName			NVARCHAR(Max)
	,@inp_sISIN					VARCHAR(20)
	,@inp_sSecurityTypeCodeID	VARCHAR(200) -- Comma separated SecurityCodeIds 139001, 139002 etc
	,@inp_sTransactionTypeCodeId	VARCHAR(200) -- Comma separated TranactionTypeCodeId 143001, 143004 etc
	
	,@inp_dtTransactionDateFrom	DATETIME
	,@inp_dtTransactionDateTo	DATETIME

	,@inp_dtSubmissionDateFrom DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo DATETIME --= '2015-05-19'

	,@inp_dtSoftCopySubmissionDateFrom DATETIME --= '2015-05-14'
	,@inp_dtSoftCopySubmissionDateTo DATETIME --= '2015-05-15'

	,@inp_dtHardCopySubmissionDateFrom DATETIME
	,@inp_dtHardCopySubmissionDateTo DATETIME

	,@inp_dtHardCopyByCOSubmissionDateFrom DATETIME
	,@inp_dtHardCopyByCOSubmissionDateTo DATETIME

	,@inp_sCommentsId VARCHAR(200) --= 162002,162001
	,@inp_sContDiscReqCodeId	VARCHAR(200) -- 165001,165002

	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEINDIV INT = -1

	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'

	DECLARE @nTransactionMasterId INT = 0
	DECLARE @iCommentId INT = 162003
	DECLARE @sComment VARCHAR(100)
	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003

	DECLARE @sEmployeeID NVARCHAR(50)
	DECLARE @sInsiderName NVARCHAR(100)
	DECLARE @sDesignation NVARCHAR(100)
	DECLARE @sGrade NVARCHAR(100)
	DECLARE @sLocation NVARCHAR(100)
	DECLARE @sDepartment NVARCHAR(100)
	DECLARE @sCompanyName NVARCHAR(100)
	DECLARE @sTypeOfInsider NVARCHAR(100)
	DECLARE @sCINDIN NVARCHAR(100)
	
	DECLARE @dtDateOfBecomingInsider DATETIME
	DECLARE @dtDetailsSubmitLastDate DATETIME
	DECLARE @dtScpSubmitDate DATETIME
	DECLARE @dtHcpSubmitDate DATETIME
	DECLARE @sStatusOfSubmission VARCHAR(100)

	DECLARE @nContDisc_Required	INT = 165001
	DECLARE @nContDisc_NotRequired	INT = 165002
	
	DECLARE @nEventCode_InitialDisclosureConfirmed INT = 153035
	DECLARE @nEventCode_PEDisclosureConfirmed INT = 153037
	
	DECLARE @nDataType_String INT = 1
	DECLARE @nDataType_Int INT = 2
	DECLARE @nDataType_Date INT = 3

	DECLARE @sContDisc_NotRequired VARCHAR(100)
	
	CREATE TABLE #tmpTransactionDetails(tmpTransactionDetailId INT IDENTITY(1,1), TransactionMasterId INT, TransactionDetailsId INT, 
				UserInfoId INT, UserInfoIdRelative INT, InsiderName NVARCHAR(max),
				SecurityTypeCodeId INT, TransactionTypeCodeId INt,
				DMATDetailsID INT, BuyQuantity INT, SellQuantity INT, Value DECIMAL(25,4), TransactionDate DATETIME, 
				DetailsSubmissionDate DATETIME, ScpSubmissionDate DATETIME, HcpSubmissionDate DATETIME, HCpByCoSubmissionDate DATETIME,
				ContDisReq INT, Comment INT, LastSubmissionDate DATETIME, CommentId INT, ScpReq INT, HcpReq INT, HcpToExReq INT)

	DECLARE @tmpUserDetails TABLE(Id INT IDENTITY(1,1), RKey VARCHAR(20), Value NVARCHAR(50), DataType INT)
	DECLARE @tmpUserTable TABLE(Id INT IDENTITY(1,1), UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, DMATDetailsID INT, Relation VARCHAR(100))
	DECLARE @tmpComments TABLE(CommentId INT)
	DECLARE @tmpReq TABLE(ReqId INT)
	BEGIN TRY
		print '[st_rpt_ContinuousDisclosureEmployeeIndividual]'		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @sContDisc_NotRequired = CodeName
		FROM com_Code WHERE CodeID = @nContDisc_NotRequired
		
		--IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'tmpTransactionDetailId'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		
		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END

		-- Populate @tmpComments table as per the filter criteria
		IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
		BEGIN
			INSERT INTO @tmpComments SELECT * FROM uf_com_Split(@inp_sCommentsId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpComments
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 162
		END
		
		-- Populate @tmpReq table as per the filter criteria
		IF @inp_sContDiscReqCodeId IS NOT NULL AND @inp_sContDiscReqCodeId <> ''
		BEGIN
			INSERT INTO @tmpReq SELECT * FROM uf_com_Split(@inp_sContDiscReqCodeId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpReq
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 165
		END

		IF @inp_iOutputSeq = 1
		BEGIN
			print 'Op seq 1'		
			-- Output #1 : USer details
			SELECT @sEmployeeID = EmployeeId, 
					@sInsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, N'') + N' ' + ISNULL(LastName, N'') END,
					@sDesignation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
					@sGrade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
					@sLocation = UF.Location,
					@sDepartment = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
					@sCompanyName = C.CompanyName,
					@sTypeOfInsider = CUserType.CodeName,
					@sCINDIN = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END
			FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId
			JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
			LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
			LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
			LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
			WHERE UserInfoId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(@inp_iUserInfoId,','))
			
			INSERT INTO @tmpUserDetails(RKey, Value, DataType)
			VALUES ('rpt_lbl_19111', @sEmployeeID, @nDataType_String),
				('rpt_lbl_19112',  CONVERT(NVARCHAR(max), @sInsiderName)  , @nDataType_String),
				('rpt_lbl_19113',  CONVERT(NVARCHAR(max), @sDesignation) , @nDataType_String),
				('rpt_lbl_19123', ISNULL(@sCINDIN, ''), @nDataType_String),
				('rpt_lbl_19114', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sGrade),1)), @nDataType_String),
				('rpt_lbl_19115', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sLocation),1)), @nDataType_String),
				('rpt_lbl_19116', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sDepartment),1)), @nDataType_String),
				('rpt_lbl_19117', @sCompanyName, @nDataType_String),
				('rpt_lbl_19118', @sTypeOfInsider, @nDataType_String)

			INSERT INTO #tmpList(RowNumber, EntityID)
			VALUES (1,1)
				
			SELECT * FROM @tmpUserDetails ORDER BY ID
		END
		ELSE
		BEGIN
			print 'Op seq 2'
			SELECT @sSQL = 'SELECT TD.TransactionMasterId, TD.TransactionDetailsId, TM.UserInfoId, UR.RelationTypeCodeId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, '
			SELECT @sSQL = @sSQL + 'TD.DMATDetailsID, CASE WHEN TD.TransactionTypeCodeId = 143002 THEN 0 ELSE TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) END, '
			SELECT @sSQL = @sSQL + 'CASE WHEN TD.TransactionTypeCodeId = 143002 THEN TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) ELSE TD.quantity2 * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) END, '
			SELECT @sSQL = @sSQL + '(Value + Value2), TD.DateOfAcquisition, EL.EventDate, ELScp.EventDate, ELHcp.EventDate, ELHcpByCO.EventDate, '
			SELECT @sSQL = @sSQL + 'CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '''') + '' '' + ISNULL(UFRelative.LastName, '''') END, '
			SELECT @sSQL = @sSQL + 'TM.SoftCopyReq, TM.HardCopyReq, StExSubmitDiscloToStExByCOHardcopyFlag '
			SELECT @sSQL = @sSQL + 'FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId '
			SELECT @sSQL = @sSQL + 'JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId '
			SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId '
			SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UFRelative ON TD.ForUserInfoId = UFRelative.UserInfoId '
			SELECT @sSQL = @sSQL + 'JOIN mst_Company C ON UF.CompanyId = C.CompanyId '
			SELECT @sSQL = @sSQL + 'JOIN eve_EventLog EL ON EL.EventCodeId IN (153007, 153019, 153029) AND EL.MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId '
			SELECT @sSQL = @sSQL + 'LEFT JOIN eve_EventLog ELScp ON ELScp.EventCodeId IN (153009,153021, 153031) AND ELScp.MapToTypeCodeId = 132005 AND ELScp.MapToId = TM.TransactionMasterId '
			SELECT @sSQL = @sSQL + 'LEFT JOIN eve_EventLog ELHcp ON ELHcp.EventCodeId IN (153010, 153022, 153032) AND ELHcp.MapToTypeCodeId = 132005 AND ELHcp.MapToId = TM.TransactionMasterId '
			SELECT @sSQL = @sSQL + 'LEFT JOIN eve_EventLog ELHcpByCO ON ELHcpByCO.EventCodeId = 153024 AND ELHcpByCO.MapToTypeCodeId = 132005 AND ELHcpByCO.MapToId = TM.TransactionMasterId '
			SELECT @sSQL = @sSQL + 'LEFT JOIN usr_UserRelation UR ON UR.UserInfoId = TM.UserInfoId AND UR.UserInfoIdRelative = TD.ForUserInfoId '
			SELECT @sSQL = @sSQL + 'WHERE 1 = 1 AND (TM.TransactionStatusCodeId > 148002 OR TM.PreclearanceRequestId IS NOT NULL)'
			SELECT @sSQL = @sSQL + 'AND TM.DisclosureTypeCodeId <> 147001 '
			SELECT @sSQL = @sSQL + 'AND TM.UserInfoId IN (' + @inp_iUserInfoId + ')'

			-- Filter on Transaction date
			IF ((@inp_dtTransactionDateFrom IS NOT NULL AND @inp_dtTransactionDateFrom <> '')
				OR (@inp_dtTransactionDateTo IS NOT NULL AND @inp_dtTransactionDateTo <> ''))
			BEGIN
				IF (@inp_dtTransactionDateFrom IS NOT NULL AND @inp_dtTransactionDateFrom <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtTransactionDateFrom) + ''') <= TD.DateOfAcquisition '
				END
				
				IF (@inp_dtTransactionDateTo IS NOT NULL AND @inp_dtTransactionDateTo <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtTransactionDateTo) + ''') >= TD.DateOfAcquisition '
				END
			END

			-- Filter on submission date
			IF ((@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateFrom <> '')
				OR (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> ''))
			BEGIN
				IF (@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateFrom <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateFrom) + ''') <= EL.EventDate '
				END
				
				IF (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateTo) + ''') >= EL.EventDate '
				END
			END

			-- Filter on scp submission date
			IF ((@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateFrom <> '')
				OR (@inp_dtSoftCopySubmissionDateTo IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo <> ''))
			BEGIN
				IF (@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateFrom <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSoftCopySubmissionDateFrom) + ''') <= ELScp.EventDate '
				END
				
				IF (@inp_dtSoftCopySubmissionDateTo IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSoftCopySubmissionDateTo) + ''') >= ELScp.EventDate '
				END
			END

			-- Filter on hcp submission date
			IF ((@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateFrom <> '')
				OR (@inp_dtHardCopySubmissionDateTo IS NOT NULL AND @inp_dtHardCopySubmissionDateTo <> ''))
			BEGIN
				IF (@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateFrom <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopySubmissionDateFrom) + ''') <= ELHcp.EventDate '
				END
				
				IF (@inp_dtHardCopySubmissionDateTo IS NOT NULL AND @inp_dtHardCopySubmissionDateTo <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopySubmissionDateTo) + ''') >= ELHcp.EventDate '
				END
			END

			-- Filter on hcp by CO submission date
			IF ((@inp_dtHardCopyByCOSubmissionDateFrom IS NOT NULL AND @inp_dtHardCopyByCOSubmissionDateFrom <> '')
				OR (@inp_dtHardCopyByCOSubmissionDateTo IS NOT NULL AND @inp_dtHardCopyByCOSubmissionDateTo <> ''))
			BEGIN
				IF (@inp_dtHardCopyByCOSubmissionDateFrom IS NOT NULL AND @inp_dtHardCopyByCOSubmissionDateFrom <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopyByCOSubmissionDateFrom) + ''') <= ELHcpByCO.EventDate '
				END
				
				IF (@inp_dtHardCopyByCOSubmissionDateTo IS NOT NULL AND @inp_dtHardCopyByCOSubmissionDateTo <> '')
				BEGIN
					SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopyByCOSubmissionDateTo) + ''') >= ELHcpByCO.EventDate '
				END
			END
			
			-- Filter on DMAT details
			IF (@inp_sDMATDetailsId IS NOT NULL AND @inp_sDMATDetailsId <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND TD.DMATDetailsID IN (' + @inp_sDMATDetailsId + ') '
			END

			-- Filter on Security type
			IF (@inp_sSecurityTypeCodeId IS NOT NULL AND @inp_sSecurityTypeCodeId <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId IN (' + @inp_sSecurityTypeCodeId + ') '
			END

			-- Filter on transaction type
			IF (@inp_sTransactionTypeCodeId IS NOT NULL AND @inp_sTransactionTypeCodeId <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND TD.TransactionTypeCodeId IN (' + @inp_sTransactionTypeCodeId + ') '
			END
			
			-- Filter on Relation
			IF (@inp_sRelationTypeCodeId IS NOT NULL AND @inp_sRelationTypeCodeId <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND ISNULL(UR.RelationTypeCodeId, 0) IN ( ' + @inp_sRelationTypeCodeId + ') '
			END
			
			SELECT @sSQL = @sSQL + ' ORDER BY DateOfAcquisition, TD.ForUserInfoID, TD.DMATDetailsID '
			
			print 'Query2 = ' + @sSQL

			INSERT INTO #tmpTransactionDetails(TransactionMasterId, TransactionDetailsId, UserInfoId,
				UserInfoIdRelative, SecurityTypeCodeId, TransactionTypeCodeId,
				DMATDetailsID, BuyQuantity, SellQuantity, Value, TransactionDate, 
				DetailsSubmissionDate, ScpSubmissionDate, HcpSubmissionDate, HCpByCoSubmissionDate, InsiderName, ScpReq, HcpReq, HcpToExReq)
			EXEC (@sSQL)		
		
			-- Update Last Submission Date for period end disclosure
			UPDATE tmpTD
			SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate,ISNULL(DiscloPeriodEndToCOByInsdrLimit,1),null,1,1,0,116001)), --DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
				CommentId = @iCommentsId_NotSubmittedInTime
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			WHERE TM.DisclosureTypeCodeId = 147003

			-- Update Comment Date for period end disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < EL.EventDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN eve_EventLog EL ON EventCodeId = @nEventCode_PEDisclosureConfirmed AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147003

			-- Update Last Submission Date for intial disclosure
			UPDATE tmpTD
			SET LastSubmissionDate = CASE WHEN UF.CreatedOn < TP.DiscloInitDateLimit THEN DiscloInitDateLimit
													ELSE  DATEADD(D, DiscloInitLimit, UF.CreatedOn) END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
				JOIN usr_UserInfo UF ON UF.UserInfoId = TM.UserInfoId
			WHERE TM.DisclosureTypeCodeId = 147001
			
			-- Update Comment for intial disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < EL.EventDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN eve_EventLog EL ON EventCodeId = @nEventCode_InitialDisclosureConfirmed AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147001

			-- Update Last Submission Date for continuous disclosure for which preclearance is not taken
			UPDATE tmpTD
			SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(TransactionDate,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit,1),null,1,1,0,116001))--DATEADD(D, TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, TransactionDate)
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			WHERE TM.DisclosureTypeCodeId = 147002 

			-- Update Comment for Continuous disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < DetailsSubmissionDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147002 AND DetailsSubmissionDate IS NOT NULL

			
			-- Update Req / Not req flags
			UPDATE tmpTD
			SET ContDisReq = CASE WHEN TM.DisclosureTypeCodeId = 147002 THEN
								CASE WHEN (TP.StExSubmitDiscloToCOByInsdrFlag = 0) OR (ISNULL(CONVERT(INT, TM.SoftCopyReq), 0) + ISNULL(CONVERT(INT, TM.HardCopyReq), 0) = 0)
									THEN @nContDisc_NotRequired ELSE @nContDisc_Required END
							 ELSE @nContDisc_NotRequired END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			

			--- Filter on comments
			IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
			BEGIN
				DELETE TD
				FROM #tmpTransactionDetails TD LEFT JOIN @tmpComments tComments ON TD.CommentId = tComments.CommentId
				WHERE tComments.CommentId IS NULL			
			END
			
			--- Filter on Req/NotReq
			IF @inp_sContDiscReqCodeId IS NOT NULL AND @inp_sContDiscReqCodeId <> ''
			BEGIN
				DELETE TD
				FROM #tmpTransactionDetails TD LEFT JOIN @tmpReq tReq ON TD.ContDisReq = tReq.ReqId
				WHERE tReq.ReqId IS NULL			
			END

			-- Delete records which do not satisfy filter condition on AccountHolder
			IF @inp_sAccountHolder IS NOT NULL OR @inp_sAccountHolder <> ''
			BEGIN
				DELETE #tmpTransactionDetails
				WHERE InsiderName NOT LIKE '%' + @inp_sAccountHolder + '%'
			END
			
			-- Delete records which do not satisfy filter condition on ScripName / ISIN
			IF (@inp_sScripName IS NOT NULL AND @inp_sScripName <> '')
				OR (@inp_sISIN IS NOT NULL AND @inp_sISIN <> '')
			BEGIN
				DELETE TD
				FROM #tmpTransactionDetails TD 
					JOIN usr_UserInfo UF ON TD.UserInfoId = UF.UserInfoId
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
				WHERE (ISNULL(@inp_sScripName, '') <> '' AND C.CompanyName NOT LIKE '%' + @inp_sScripName + '%')
					OR (ISNULL(@inp_sISIN, '') <> '' AND ISNULL(C.ISINNumber, '') NOT LIKE '%' + @inp_sISIN + '%')
			END
			
			SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
			SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TransactionDetailsId),TransactionDetailsId ' 
			SELECT @sSQL = @sSQL + 'FROM #tmpTransactionDetails ID '
			
			print @sSQL
			EXEC (@sSQL)
			
			
			SELECT UF.UserInfoId,
				CASE 
					WHEN TUD.TransactionDetailsId IS NULL THEN DD.DEMATAccountNumber 
					ELSE TUD.DematAccountNumber 
				END AS rpt_grd_19090,
				CASE 
					WHEN TUD.TransactionDetailsId IS NULL THEN InsiderName 
					ELSE 
						CASE 
							WHEN TUD.UserTypeCode = 101004 THEN TUD.CompanyName 
							ELSE ISNULL(TUD.FirstName, N'') + N' ' + ISNULL(TUD.LastName, N'') 
						END
				END As rpt_grd_19091, -- AccountHolder,
				CASE 
					WHEN TUD.TransactionDetailsId IS NULL THEN ISNULL(CRelation.CodeName, 'Self') 
					ELSE TUD.Relation 
				END AS rpt_grd_19092, -- Relation,
				C.CompanyName AS rpt_grd_19093, -- Scrip,
				ISNULL(C.ISINNumber, '') AS rpt_grd_19094, -- ISIN,
				CSecurity.CodeName AS rpt_grd_19095, -- SecurityType,
				CTransaction.CodeName AS rpt_grd_19096, -- TransactionType,
				BuyQuantity AS rpt_grd_19098, -- Buy,
				SellQuantity AS rpt_grd_19099, -- Sell,
				Value AS rpt_grd_19100, -- Value,
				dbo.uf_rpt_FormatDateValue(TD.TransactionDate,0) AS rpt_grd_19101, --,
				dbo.uf_rpt_FormatDateValue(TD.DetailsSubmissionDate,0) AS rpt_grd_19102, --,
				CContRequired.CodeName AS rpt_grd_19103, -- ContinuousDisclosureReq,
				dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS rpt_grd_19104, --,
				CASE WHEN ScpReq = 0 THEN @sContDisc_NotRequired ELSE dbo.uf_rpt_FormatDateValue(ScpSubmissionDate,1) END AS rpt_grd_19106, --,
				CASE WHEN HcpReq = 0 THEN @sContDisc_NotRequired ELSE dbo.uf_rpt_FormatDateValue(HcpSubmissionDate,1) END AS rpt_grd_19107, --,
				RComment.ResourceValue AS rpt_grd_19108, -- Comment,
				CASE WHEN HcpToExReq = 0 THEN @sContDisc_NotRequired 
				     WHEN ScpReq = 0 AND HcpReq = 0 THEN @sContDisc_NotRequired
				ELSE dbo.uf_rpt_FormatDateValue(HCpByCoSubmissionDate,1) END AS rpt_grd_19109, --,
				TD.TransactionMasterId AS TransactionMasterId,
				'151001' AS LetterForCodeId,
				'0' AS TransactionLetterId,
				'147002' AS DisclosureTypeCodeId,
				'167' AS Acid
			FROM #tmpTransactionDetails TD 
				JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
				LEFT JOIN com_Code CRelation ON TD.UserInfoIdRelative = CRelation.CodeID
				JOIN usr_UserInfo UF ON TD.UserInfoId = UF.UserInfoId
				JOIN mst_Company C ON UF.CompanyId = C.CompanyId
				JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
				JOIN com_Code CTransaction ON TD.TransactionTypeCodeId = CTransaction.CodeID
				JOIN com_Code CContRequired ON TD.ContDisReq = CContRequired.CodeID
				LEFT JOIN com_Code CComment ON TD.CommentId = CComment.CodeID
				LEFT JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
				LEFT JOIN tra_TradingTransactionUserDetails TUD ON TD.TransactionDetailsId = TUD.TransactionDetailsId AND TUD.FormDetails = 0
		
/*		
			INSERT INTO @tmpUserTable(UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, Relation)
			SELECT UF.UserInfoId UserInfoID, UF.UserInfoId UserInfoIdRelative, CodeID SecurityTypeCodeId, DD.DMATDetailsID DMATDetailsID, 'Self'
			FROM usr_UserInfo UF JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
				JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
			WHERE UF.UserInfoId = @inp_iUserInfoId
			UNION
			SELECT UF.UserInfoId, UR.UserInfoIdRelative, CSecurity.CodeID, DD.DMATDetailsID, CRelation.CodeName
			FROM usr_UserInfo UF
				JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
				JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
				JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
			WHERE UF.UserInfoId = @inp_iUserInfoId
			ORDER BY UserInfoID, UserInfoIdRelative, DMATDetailsID, SecurityTypeCodeId

			INSERT INTO #tmpList(RowNumber, EntityID)
			SELECT ID, ID FROM @tmpUserTable

			-- Output #3 : Transaction details
			SELECT DMat.DEMATAccountNumber rpt_grd_19032, 
			CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END AS rpt_grd_19033,
			Relation AS rpt_grd_19034,
			C.CompanyName AS rpt_grd_19035,
			C.ISINNumber AS rpt_grd_19036,
			CSecurityType.CodeName AS rpt_grd_19037,
			SUM(ISNULL(TD.Quantity, 0)) AS rpt_grd_19038
			FROM @tmpUserTable tmpUser
				JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
				JOIN mst_Company C ON UF.CompanyId = C.CompanyId
				JOIN usr_UserInfo UFRelative ON tmpUser.UserInfoIdRelative = UFRelative.UserInfoId
				--JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId AND UR.UserInfoIdRelative = UFRelative.UserInfoId
				JOIN com_Code CSecurityType ON tmpUser.SecurityTypeCodeId = CSecurityType.CodeID
				LEFT JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = @nTransactionMasterId
				LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId AND TD.ForUserInfoId = UFRelative.UserInfoId 
						AND td.SecurityTypeCodeId = CSecurityType.CodeID AND tmpUser.DMATDetailsID = TD.DMATDetailsID
				LEFT JOIN usr_DMATDetails DMat ON tmpUser.DMATDetailsID = DMat.DMATDetailsID
			GROUP BY Id, DMat.DEMATAccountNumber, UF.UserTypeCodeId, C.CompanyName, UFRelative.FirstName, UFRelative.LastName,
				Relation, C.CompanyName, C.ISINNumber, CSecurityType.CodeName
			ORDER BY Id
		*/
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEINDIV
	END CATCH
END
