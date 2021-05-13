IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_ContinuousDisclosureEmployeeWise_OS')
DROP PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeWise_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeWise_OS]
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
	DECLARE @ERR_IDEMPLOYEEINDIV INT = -1

	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @iCommentId INT = 162003
	DECLARE @sComment VARCHAR(100)
	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003

	DECLARE @nEventCode_InitialDisclosureConfirmed INT = 153035
	DECLARE @nEventCode_PEDisclosureConfirmed INT = 153037

	DECLARE @nContDisc_Required	INT = 165001
	DECLARE @nContDisc_NotRequired	INT = 165002

	DECLARE @sContDisc_NotRequired VARCHAR(100)
	
	CREATE TABLE #tmpTransactionDetails(TransactionMasterId INT, TransactionDetailsId INT, 
				UserInfoId INT, UserInfoIdRelative INT, InsiderName VARCHAR(200),CompanyName NVARCHAR(200),
				SecurityTypeCodeId INT, TransactionTypeCodeId INT, DateOfAcquisition DATETIME,
				DMATDetailsID INT, BuyQuantity INT, SellQuantity INT, Value DECIMAL(25,4), TransactionDate DATETIME, 
				DetailsSubmissionDate DATETIME, ScpSubmissionDate DATETIME, HcpSubmissionDate DATETIME, HCpByCoSubmissionDate DATETIME,
				ContDisReq INT, Comment INT, LastSubmissionDate DATETIME, CommentId INT, ScpReq INT, HcpReq INT, HcpToExReq INT, Quantity DECIMAL(25,4),CompanyID INT)

	
	BEGIN TRY
		print '[st_rpt_ContinuousDisclosureEmployeeWise_OS]'		
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
		
		

INSERT INTO #tmpTransactionDetails(TransactionMasterId, TransactionDetailsId, UserInfoId,
				UserInfoIdRelative,CompanyName, SecurityTypeCodeId, TransactionTypeCodeId, DateOfAcquisition, 
				DMATDetailsID, BuyQuantity, SellQuantity, Value, TransactionDate, 
				DetailsSubmissionDate, ScpSubmissionDate, HcpSubmissionDate, InsiderName, ScpReq, HcpReq, HcpToExReq, Quantity,CompanyID)
SELECT TD.TransactionMasterId, TD.TransactionDetailsId, TM.UserInfoId, UR.RelationTypeCodeId,CM.CompanyName, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.DateOfAcquisition,
TD.DMATDetailsID,CASE WHEN TD.TransactionTypeCodeId = 143002 THEN 0 ELSE TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) END,
CASE WHEN TD.TransactionTypeCodeId = 143002 THEN TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) ELSE 0 END, Value,
TD.DateOfAcquisition, EL.EventDate, ELScp.EventDate, ELHcp.EventDate,
CASE WHEN UF.UserTypeCodeId = 101004 THEN CM.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END,
TM.SoftCopyReq, TM.HardCopyReq, StExSubmitDiscloToStExByCOHardcopyFlag, Quantity, TD.CompanyId 
FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = TD.TransactionMasterId 
JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId 
JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId 
JOIN usr_UserInfo UFRelative ON TD.ForUserInfoId = UFRelative.UserInfoId 
JOIN rl_CompanyMasterList CM ON TD.CompanyId = CM.RlCompanyId
JOIN eve_EventLog EL ON EL.EventCodeId IN (153052, 153057, 153062) AND EL.MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId 
LEFT JOIN eve_EventLog ELScp ON ELScp.EventCodeId IN (153054,153059, 153064) AND ELScp.MapToTypeCodeId = 132005 AND ELScp.MapToId = TM.TransactionMasterId 
LEFT JOIN eve_EventLog ELHcp ON ELHcp.EventCodeId IN (153055, 153060, 153065) AND ELHcp.MapToTypeCodeId = 132005 AND ELHcp.MapToId = TM.TransactionMasterId 
LEFT JOIN usr_UserRelation UR ON UR.UserInfoId = TM.UserInfoId AND UR.UserInfoIdRelative = TD.ForUserInfoId 
WHERE 1 = 1
AND (TM.TransactionStatusCodeId > 148002 OR TM.PreclearanceRequestId IS NOT NULL)
AND TM.DisclosureTypeCodeId <> 147001 

-- Update Last Submission Date for period end disclosure
			UPDATE tmpTD
			SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate,ISNULL(DiscloPeriodEndToCOByInsdrLimit,1),null,1,1,0,116001)), --DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
				CommentId = @iCommentsId_NotSubmittedInTime
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			WHERE TM.DisclosureTypeCodeId = 147003

			-- Update Comment Date for period end disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < EL.EventDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN eve_EventLog EL ON EventCodeId = @nEventCode_PEDisclosureConfirmed AND MapToTypeCodeId = 132015 AND MapToId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147003

			-- Update Last Submission Date for intial disclosure
			UPDATE tmpTD
			SET LastSubmissionDate = CASE WHEN UF.CreatedOn < TP.DiscloInitDateLimit THEN DiscloInitDateLimit
													ELSE  DATEADD(D, DiscloInitLimit, UF.CreatedOn) END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
				JOIN usr_UserInfo UF ON UF.UserInfoId = TM.UserInfoId
			WHERE TM.DisclosureTypeCodeId = 147001
			
			-- Update Comment for intial disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < EL.EventDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN eve_EventLog EL ON EventCodeId = @nEventCode_InitialDisclosureConfirmed AND MapToTypeCodeId = 132015 AND MapToId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147001

			-- Update Last Submission Date for continuous disclosure for which preclearance is not taken
			UPDATE tmpTD
			SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(TransactionDate,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit,1),null,1,1,0,116001))--DATEADD(D, TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, TransactionDate)
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			WHERE TM.DisclosureTypeCodeId = 147002 

			-- Update Comment for Continuous disclosure
			UPDATE tmpTD
			SET CommentId = CASE WHEN LastSubmissionDate < DetailsSubmissionDate THEN @iCommentsId_NotSubmittedInTime ELSE @iCommentsId_Ok END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			WHERE TM.DisclosureTypeCodeId = 147002 AND DetailsSubmissionDate IS NOT NULL
						
			-- Update Req / Not req flags
			UPDATE tmpTD
			SET ContDisReq = CASE WHEN TM.DisclosureTypeCodeId = 147002 THEN
								CASE WHEN (TP.StExSubmitDiscloToCOByInsdrFlag = 0) OR (ISNULL(CONVERT(INT, TM.SoftCopyReq), 0) + ISNULL(CONVERT(INT, TM.HardCopyReq), 0) = 0)
									THEN @nContDisc_NotRequired ELSE @nContDisc_Required END
							 ELSE @nContDisc_NotRequired END
			FROM #tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId

IF(@EnableDisableQuantityValue = 400003)
 BEGIN
	SELECT @sSQL = 'select UF.EmployeeId, InsiderName AS [Insider Name], UFS.PAN, dbo.uf_rpt_FormatDateValue(UF.DateOfBecomingInsider,0) AS [Date Of Becoming Insider],
					CASE WHEN UF.DateOfSeparation IS NULL THEN ''Live'' ELSE ''Separated'' END AS [Live/Separated], dbo.uf_rpt_FormatDateValue(UFS.DateOfSeparation,0) AS [Date Of Separation] , CASE WHEN UF.StatusCodeId = 102001 THEN ''ACTIVE'' ELSE ''INACTIVE'' END AS Status, UF.DIN,
					CASE WHEN  UF.DesignationId IS NULL THEN NULL ELSE CDesignation.CodeName END AS Designation , 
					CASE WHEN  UF.GradeId IS NULL THEN NULL ELSE CGrade.CodeName END AS Grade, UF.Location,
					CASE WHEN UF.DepartmentId IS NULL THEN NULL ELSE CDEPT.CodeName END AS Department,
					CASE WHEN UF.Category IS NULL THEN NULL ELSE CCategory.CodeName END AS Category , 
					CASE WHEN UF.SubCategory IS NULL THEN NULL ELSE CSubCategory.CodeName END AS SubCategory ,
					CUserTypeCode.CodeName AS [Type Of Insider],TD.CompanyName AS [Company Name],CML.ISINCode,DD.DEMATAccountNumber AS [DEMAT Account Number], UFS.FirstName + UFS.LastName AS [A/C Holder Name],
					CASE WHEN CRelation.codename IS NULL THEN ''Self'' ELSE CRelation.codename END  AS [Relation with Insider], CSecurity.CodeName AS [Security Type], CTransaction.CodeName AS [Trasaction Type] ,
					dbo.uf_rpt_FormatDateValue(TransactionDate,0) AS [Transaction Date], dbo.uf_rpt_FormatDateValue(DetailsSubmissionDate,0) AS [Trading Details Submission Date], CContRequired.CodeName AS [Continuous Disclosure],
					dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS [Disclosure to be submitted by], 
					CASE WHEN ScpReq = 0 THEN '''+@sContDisc_NotRequired+''' ELSE dbo.uf_rpt_FormatDateValue(ScpSubmissionDate,1) END AS [Soft Copy] ,
					CASE WHEN HcpReq = 0 THEN '''+@sContDisc_NotRequired+''' ELSE dbo.uf_rpt_FormatDateValue(HcpSubmissionDate,1) END AS [Hard Copy] ,
					RComment.ResourceValue AS Comments,
					CASE WHEN HcpToExReq = 0 THEN '''+@sContDisc_NotRequired+''' 
					     WHEN ScpReq = 0 AND HcpReq = 0 THEN '''+@sContDisc_NotRequired+''' 
					ELSE dbo.uf_rpt_FormatDateValue(HCpByCoSubmissionDate,1) END AS [Continuous Disclosure to stock exchange submission date], Value, Quantity as Trades '
	SELECT @sSQL = @sSQL + 'FROM #tmpTransactionDetails TD JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CRelation ON TD.UserInfoIdRelative = CRelation.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UF ON TD.UserInfoId = UF.UserInfoId '
	SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UFS ON DD.UserInfoId = UFS.UserInfoId '
	SELECT @sSQL = @sSQL + 'JOIN rl_CompanyMasterList CML ON CML.RlCompanyId = TD.CompanyId '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CDEPT ON UF.DepartmentId= CDEPT.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CDesignation ON UF.DesignationId= CDesignation.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CGrade ON UF.GradeId= CGrade.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CCategory ON UF.Category= CCategory.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CSubCategory ON UF.SubCategory= CSubCategory .CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CUserTypeCode ON UFS.UserTypeCodeId= CUserTypeCode.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CTransaction ON TD.TransactionTypeCodeId = CTransaction.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CContRequired ON TD.ContDisReq = CContRequired.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CComment ON TD.CommentId = CComment.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
	SELECT @sSQL = @sSQL + 'where 1 = 1 '
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
					SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like ''%' + @inp_sEmployeeID + '%'''
				END
				IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
				BEGIN
					print '@inp_sInsiderName'
					SELECT @sSQL = @sSQL + ' AND InsiderName like ''%' + @inp_sInsiderName + '%'''
				
				END			
				IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
				BEGIN
					print '@inp_sPan'
					SELECT @sSQL = @sSQL + ' AND UFS.PAN like ''%' + @inp_sPan + '%'' '
					
				END
				IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
				BEGIN
					print '@inp_sCompanyName'
					SELECT @sSQL = @sSQL + ' AND TD.CompanyName like ''%' + @inp_sCompanyName + '%'''
				
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
  END
ELSE
  BEGIN
	SELECT @sSQL = 'select UF.EmployeeId, InsiderName AS [Insider Name], UFS.PAN, dbo.uf_rpt_FormatDateValue(UF.DateOfBecomingInsider,0) AS [Date Of Becoming Insider],
					CASE WHEN UF.DateOfSeparation IS NULL THEN ''Live'' ELSE ''Separated'' END AS [Live/Separated], dbo.uf_rpt_FormatDateValue(UFS.DateOfSeparation,0) AS [Date Of Separation] , CASE WHEN UF.StatusCodeId = 102001 THEN ''ACTIVE'' ELSE ''INACTIVE'' END AS Status, UF.DIN,
					CASE WHEN  UF.DesignationId IS NULL THEN NULL ELSE CDesignation.CodeName END AS Designation , 
					CASE WHEN  UF.GradeId IS NULL THEN NULL ELSE CGrade.CodeName END AS Grade, UF.Location,
					CASE WHEN UF.DepartmentId IS NULL THEN NULL ELSE CDEPT.CodeName END AS Department,
					CASE WHEN UF.Category IS NULL THEN NULL ELSE CCategory.CodeName END AS Category , 
					CASE WHEN UF.SubCategory IS NULL THEN NULL ELSE CSubCategory.CodeName END AS SubCategory ,
					CUserTypeCode.CodeName AS [Type Of Insider],TD.CompanyName AS [Company Name],CML.ISINCode,DD.DEMATAccountNumber AS [DEMAT Account Number], UFS.FirstName + UFS.LastName AS [A/C Holder Name],
					CASE WHEN CRelation.codename IS NULL THEN ''Self'' ELSE CRelation.codename END  AS [Relation with Insider], CSecurity.CodeName AS [Security Type], CTransaction.CodeName AS [Trasaction Type] ,
					CASE WHEN TD.TransactionTypeCodeId = 143002 THEN SellQuantity ELSE BuyQuantity END AS [Trades],Value, dbo.uf_rpt_FormatDateValue(TransactionDate,0) AS [Transaction Date], dbo.uf_rpt_FormatDateValue(DetailsSubmissionDate,0) AS [Trading Details Submission Date], CContRequired.CodeName AS [Continuous Disclosure],
					dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS [Disclosure to be submitted by], 
					CASE WHEN ScpReq = 0 THEN '''+@sContDisc_NotRequired+''' ELSE dbo.uf_rpt_FormatDateValue(ScpSubmissionDate,1) END AS [Soft Copy] ,
					CASE WHEN HcpReq = 0 THEN '''+@sContDisc_NotRequired+''' ELSE dbo.uf_rpt_FormatDateValue(HcpSubmissionDate,1) END AS [Hard Copy] ,
					RComment.ResourceValue AS Comments,
					CASE WHEN HcpToExReq = 0 THEN '''+@sContDisc_NotRequired+''' 
					     WHEN ScpReq = 0 AND HcpReq = 0 THEN '''+@sContDisc_NotRequired+''' 
					ELSE dbo.uf_rpt_FormatDateValue(HCpByCoSubmissionDate,1) END AS [Continuous Disclosure to stock exchange submission date] '
	SELECT @sSQL = @sSQL + 'FROM #tmpTransactionDetails TD JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CRelation ON TD.UserInfoIdRelative = CRelation.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UF ON TD.UserInfoId = UF.UserInfoId '
	SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UFS ON DD.UserInfoId = UFS.UserInfoId '
	SELECT @sSQL = @sSQL + 'JOIN rl_CompanyMasterList CML ON CML.RlCompanyId = TD.CompanyId '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CDEPT ON UF.DepartmentId= CDEPT.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CDesignation ON UF.DesignationId= CDesignation.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CGrade ON UF.GradeId= CGrade.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CCategory ON UF.Category= CCategory.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CSubCategory ON UF.SubCategory= CSubCategory .CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CUserTypeCode ON UFS.UserTypeCodeId= CUserTypeCode.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CTransaction ON TD.TransactionTypeCodeId = CTransaction.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN com_Code CContRequired ON TD.ContDisReq = CContRequired.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CComment ON TD.CommentId = CComment.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
	SELECT @sSQL = @sSQL + 'where 1 = 1 '
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
					SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like ''%' + @inp_sEmployeeID + '%'''
				END
				IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
				BEGIN
					print '@inp_sInsiderName'
					SELECT @sSQL = @sSQL + ' AND InsiderName like ''%' + @inp_sInsiderName + '%'''
				
				END			
				IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
				BEGIN
					print '@inp_sPan'
					SELECT @sSQL = @sSQL + ' AND UFS.PAN like ''%' + @inp_sPan + '%'' '
					
				END
				IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
				BEGIN
					print '@inp_sCompanyName'
					SELECT @sSQL = @sSQL + ' AND TD.CompanyName like ''%' + @inp_sCompanyName + '%'''
				
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
  END

--SELECT @sSQL = '' 

	--SELECT UF.EmployeeId, InsiderName, UFS.PAN, UFS.DateOfBecomingInsider,
	--CASE WHEN UFS.DateOfSeparation IS NULL THEN 'Live' ELSE 'Separated' END AS 'Live/Separated', 
	--UFS.DateOfSeparation,
	--CASE WHEN UFS.StatusCodeId = 102001 THEN 'ACTIVE' ELSE 'INACTIVE' END AS Status ,
	--UFS.DIN, 
	--CASE WHEN  UFS.DesignationId IS NULL THEN NULL ELSE CDesignation.CodeName END AS Designation , 
	--CASE WHEN  UFS.GradeId IS NULL THEN NULL ELSE CGrade.CodeName END AS Grade ,
	--UFS.Location,
	--CASE WHEN UFS.DepartmentId IS NULL THEN NULL ELSE CDEPT.CodeName END AS Department,
	--CASE WHEN UFS.Category IS NULL THEN NULL ELSE CCategory.CodeName END AS Category , 
	--CASE WHEN UFS.SubCategory IS NULL THEN NULL ELSE CSubCategory.CodeName END AS SubCategory , 
	--CUserTypeCode.CodeName AS 'Type Of Insider',TD.CompanyName,CML.ISINCode,DD.DEMATAccountNumber, UFS.FirstName + UFS.LastName AS 'A/C Holder Name',
	--CASE WHEN CRelation.codename IS NULL THEN 'Self' ELSE CRelation.codename END  AS 'Relation with Insider', CSecurity.CodeName AS 'Security Type', CTransaction.CodeName AS 'Trasaction Type' ,
	--CASE WHEN TD.TransactionTypeCodeId = 143002 THEN SellQuantity ELSE BuyQuantity END AS 'Trades',Value,TransactionDate, DetailsSubmissionDate, CContRequired.CodeName AS 'Continuous Disclosure',
	--LastSubmissionDate AS 'Disclosure to be submitted by', 
	--CASE WHEN ScpReq = 1 THEN @sContDisc_NotRequired ELSE dbo.uf_rpt_FormatDateValue(ScpSubmissionDate,1) END AS 'Soft Copy' ,
	--CASE WHEN HcpReq = 1 THEN @sContDisc_NotRequired ELSE dbo.uf_rpt_FormatDateValue(HcpSubmissionDate,1) END AS 'Hard Copy' ,--ScpSubmissionDate,HcpSubmissionDate ,
	-- RComment.ResourceValue,
	-- CASE WHEN HcpToExReq = 1 THEN @sContDisc_NotRequired 
	--			     WHEN ScpReq = 1 AND HcpReq = 1 THEN @sContDisc_NotRequired
	--			ELSE dbo.uf_rpt_FormatDateValue(HCpByCoSubmissionDate,1) END AS 'Continuous Disclosure to stock exchange submission date'
	--FROM #tmpTransactionDetails TD 
	--JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
	--LEFT JOIN com_Code CRelation ON TD.UserInfoIdRelative = CRelation.CodeID
	--JOIN usr_UserInfo UF ON TD.UserInfoId = UF.UserInfoId
	--JOIN usr_UserInfo UFS ON DD.UserInfoId = UFS.UserInfoId
	--JOIN rl_CompanyMasterList CML ON CML.CompanyName = TD.CompanyName
	--JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
	--JOIN com_Code CDEPT ON UF.DepartmentId= CDEPT.CodeID
	--JOIN com_Code CDesignation ON UF.DesignationId= CDesignation.CodeID
	--JOIN com_Code CGrade ON UF.GradeId= CGrade.CodeID
	--JOIN com_Code CCategory ON UF.Category= CCategory.CodeID
	--JOIN com_Code CSubCategory ON UF.SubCategory= CSubCategory .CodeID
	--JOIN com_Code CUserTypeCode ON UFS.UserTypeCodeId= CUserTypeCode.CodeID
	--JOIN com_Code CTransaction ON TD.TransactionTypeCodeId = CTransaction.CodeID
	--JOIN com_Code CContRequired ON TD.ContDisReq = CContRequired.CodeID
	--LEFT JOIN com_Code CComment ON TD.CommentId = CComment.CodeID
	--LEFT JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
print(@sSQL)
EXEC (@sSQL)
	DROP TABLE #tmpTransactionDetails
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEINDIV
	END CATCH
END
