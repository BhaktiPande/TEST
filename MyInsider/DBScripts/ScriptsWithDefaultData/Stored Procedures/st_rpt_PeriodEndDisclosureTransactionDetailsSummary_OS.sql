IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndDisclosureTransactionDetailsSummary_OS')
DROP PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureTransactionDetailsSummary_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureTransactionDetailsSummary_OS] 
	 @inp_sEmployeeID					NVARCHAR(50) = ''
	,@inp_sInsiderName					NVARCHAR(100) = ''
	,@inp_sPan							NVARCHAR(100) = ''
	,@inp_sCompanyName					NVARCHAR(200) = ''
	,@inp_iYearCodeId					NVARCHAR(50) = ''
	,@inp_iPeriodCodeId					NVARCHAR(50) = ''
	,@EnableDisableQuantityValue        INT = 400001
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN

	DECLARE @ERR_PERIODENDDISCLOSURE_TRANSACTIONDETAILS	INT = 53133 -- Error occurred while fetching list of period end disclosure summary details.
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153052
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153057
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001

	DECLARE @iCommentsId_Ok VARCHAR(100) = 'Submitted within stipulated time'
	DECLARE @iCommentsId_NotSubmittedInTime VARCHAR(100) = 'Not submitted in stipulated time'
	DECLARE @iCommentsId_NotSubmitted VARCHAR(100) = 'Not submitted'

	DECLARE @nPeriodType INT
	DECLARE @RC INT
	DECLARE @dtPEStart DATETIME
	DECLARE @dtPEEnd DATETIME
	DECLARE @sSQL NVARCHAR(MAX)

	CREATE TABLE #TempPeriodEnd_EventStatus(TransactionMasterId INT,UserInfoID INT,PeriodEndDate DATETIME,SoftCopyReq BIT,HardCopyReq BIT,
	 DetailsSubmitStatus INT, DetailsSubmitDate DATETIME, ScpSubmitStatus INT, ScpSubmitDate DATETIME,HcpSubmitStatus INT, HcpSubmitDate DATETIME)

	DECLARE @tmpTransactionIds TABLE (TransactionMasterId INT, UserInfoId INT)

	CREATE TABLE #tmpTransactions  (TransactionMasterId INT)

	BEGIN TRY
		SET NOCOUNT ON;

		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF (@inp_iPeriodCodeId IS NOT NULL AND @inp_iPeriodCodeId <> 0)
		BEGIN
			SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeId
			
			-- Find out Period Start and End date for the selected year / period code id
			EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
			   @inp_iYearCodeId OUTPUT
			  ,@inp_iPeriodCodeId OUTPUT
			  ,null
			  ,@nPeriodType
			  ,0
			  ,@dtPEStart OUTPUT
			  ,@dtPEEnd OUTPUT			  
		END		

	INSERT INTO #TempPeriodEnd_EventStatus(TransactionMasterId,UserInfoID,PeriodEndDate,SoftCopyReq,HardCopyReq,
			DetailsSubmitStatus, DetailsSubmitDate, ScpSubmitStatus, ScpSubmitDate,HcpSubmitStatus, HcpSubmitDate)
		EXEC st_tra_PeriodEndDisclosureEventStatus_OS

	INSERT INTO @tmpTransactionIds(TransactionMasterId, UserInfoId)
		SELECT TransactionMasterId, vwPEDS.UserInfoId FROM
		#TempPeriodEnd_EventStatus vwPEDS WHERE 1 = 1
		AND vwPEDS.PeriodEndDate = '' + CONVERT(VARCHAR(11), @dtPEEnd) + ''

		--Get transaction masterid of user and its relative		
	INSERT INTO #tmpTransactions(TransactionMasterId)
		SELECT DISTINCT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
		JOIN eve_EventLog EL ON 
		EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted, @nEventCodeID_ContiDetailsSubmitted) 
		AND EL.MapToId = TM.TransactionMasterId
		JOIN tra_TransactionDetails_OS TD on TM.TransactionMasterId=TD.TransactionMasterId 
		WHERE TM.PeriodEndDate = @dtPEEnd
		AND	TM.UserInfoId in (select UserInfoId from @tmpTransactionIds )

		--Get transaction masterid of User relative who is added after initial disclousre of user is submitted
	INSERT INTO #tmpTransactions(TransactionMasterId)
		SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
		JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = TM.UserInfoId 
		JOIN eve_EventLog EL ON	EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted) 
		AND EL.MapToId = TM.TransactionMasterId
		WHERE UR.UserInfoId in (select UserInfoId from @tmpTransactionIds )
		AND TM.PeriodEndDate = @dtPEEnd

IF(@EnableDisableQuantityValue = 400003)
 BEGIN
	SELECT @sSQL = 'SELECT UF.EmployeeId AS [Employee Id],ISNULL(UF.FirstName,'''') + '' '' + ISNULL(UF.LastName, '''') AS [Insider Name],dbo.uf_rpt_FormatDateValue(UF.DateOfBecomingInsider,0) AS [Insider From],
	CASE WHEN UF.DateOfSeparation IS NULL THEN ''LIVE''
		 WHEN UF.DateOfSeparation IS NOT NULL THEN ''Separation'' END AS [Live/Separated],
		 dbo.uf_rpt_FormatDateValue(UF.DateOfSeparation,0) AS [Date Of Separation],
		 CStatus.CodeName AS [Status],UF.DIN, CDesignation.CodeName [Designation], CGrade.CodeName AS [Grade], UF.Location,CDept.CodeName AS [Department],CCategory.CodeName AS [Category],CSubCategory.CodeName AS [SubCategory]
		,company.CompanyName AS [Trading Company Name],CUserType.CodeName + '' Insider'' AS [Type of Insider],CPeriod.DisplayCode+ '' '' +CYear.CodeName AS [Period and Year]
		,dbo.uf_rpt_FormatDateValue(dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, '''+CONVERT(VARCHAR(11), @nExchangeTypeCodeId_NSE)+''' ),1) AS [Last Submission Date]
		--,CONVERT(VARCHAR(20), TD.DateOfAcquisition, 103) AS [Date of Transaction]
		--,vwIn.DetailsSubmitDate, vwIn.ScpSubmitDate, vwIn.HcpSubmitDate,
		,CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.DetailsSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.DetailsSubmitDate,1) END AS Holding,
		CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.ScpSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.ScpSubmitDate,1) END AS SoftCopy,
		CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.HcpSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.HcpSubmitDate,1) END AS HardCopy

		,CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN '''+CONVERT(VARCHAR(100), @iCommentsId_NotSubmitted)+'''
							WHEN vwIn.DetailsSubmitDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''', DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, '''+CONVERT(VARCHAR(100), @nExchangeTypeCodeId_NSE)+''' )) THEN '''+CONVERT(VARCHAR(100), @iCommentsId_Ok)+''' -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit,@dtPEEnd)
							ELSE '''+CONVERT(VARCHAR(100), @iCommentsId_NotSubmittedInTime)+''' END AS [Comments]
		,DD.DEMATAccountNumber AS [Demat Account Number], UIF.FirstName + '' '' + UIF.LastName AS [A/C Holder Name],
		CASE WHEN UR.UserInfoId IS NULL  THEN ''Self'' ELSE CRelation.CodeName END AS [Relation with Insider],UF.PAN AS PAN,company.ISINCode AS [ISIN], 
		CSecurityType.CodeName AS [Security Type] FROM  #tmpTransactions tTrans '
	SELECT @sSQL = @sSQL +'JOIN tra_TransactionMaster_OS TM ON tTrans.TransactionMasterId = TM.TransactionMasterId '
	SELECT @sSQL = @sSQL +'JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId '
	SELECT @sSQL = @sSQL +'JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
	SELECT @sSQL = @sSQL +'LEFT JOIN #TempPeriodEnd_EventStatus vwIn ON TM.UserInfoId = vwIn.UserInfoId AND vwIn.PeriodEndDate = ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '
	SELECT @sSQL = @sSQL +'JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
	SELECT @sSQL = @sSQL +'JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID '
	SELECT @sSQL = @sSQL +'JOIN rl_CompanyMasterList company ON TD.CompanyId = company.RlCompanyId '
	SELECT @sSQL = @sSQL +'LEFT JOIN usr_UserRelation UR ON TD.ForUserInfoId = UR.UserInfoIdRelative '
	SELECT @sSQL = @sSQL +'LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
	SELECT @sSQL = @sSQL +'JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CDesignation ON CDesignation .CodeID = UF.DesignationId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CGrade ON CGrade.CodeID = UF.GradeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CDept ON CDept.CodeID = UF.DepartmentId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CCategory ON CCategory.CodeID = UF.Category '
	SELECT @sSQL = @sSQL +'JOIN com_Code CSubCategory ON CSubCategory.CodeID = UF.SubCategory '
	SELECT @sSQL = @sSQL +'JOIN com_Code CUserType ON CUserType.CodeID = UF.UserTypeCodeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CPeriod ON CPeriod.CodeID = '''+CONVERT(VARCHAR(11), @inp_iPeriodCodeId)+''' '
	SELECT @sSQL = @sSQL +'JOIN com_Code CYear ON CYear.CodeID = '''+CONVERT(VARCHAR(11), @inp_iYearCodeId)+''' '
	SELECT @sSQL = @sSQL +'JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId '
	SELECT @sSQL = @sSQL +'JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId '		
	SELECT @sSQL = @sSQL +'LEFT JOIN usr_UserInfo UIF ON UIF.UserInfoId = DD.UserInfoID '
	SELECT @sSQL = @sSQL +'WHERE TD.TransactionDetailsId IS NOT NULL '
	IF ((@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sPan IS NOT NULL AND @inp_sPan <> ''))

		BEGIN
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND ISNULL(UF.FirstName,'''') + '' '' + ISNULL(UF.LastName, '''') like ''%' + @inp_sInsiderName + '%'''
			
			END			
			IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			BEGIN
				print '@inp_sPan'
				SELECT @sSQL = @sSQL + ' AND UF.PAN like ''%' + @inp_sPan + '%'' '
				
			END
			IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + ' AND company.CompanyName like ''%' + @inp_sCompanyName + '%'''
			
			END	
	END
  END
ELSE
  BEGIN
    SELECT @sSQL = 'SELECT UF.EmployeeId AS [Employee Id],ISNULL(UF.FirstName,'''') + '' '' + ISNULL(UF.LastName, '''') AS [Insider Name],dbo.uf_rpt_FormatDateValue(UF.DateOfBecomingInsider,0) AS [Insider From],
	CASE WHEN UF.DateOfSeparation IS NULL THEN ''LIVE''
		 WHEN UF.DateOfSeparation IS NOT NULL THEN ''Separation'' END AS [Live/Separated],
		 dbo.uf_rpt_FormatDateValue(UF.DateOfSeparation,0) AS [Date Of Separation],
		 CStatus.CodeName AS [Status],UF.DIN, CDesignation.CodeName [Designation], CGrade.CodeName AS [Grade], UF.Location,CDept.CodeName AS [Department],CCategory.CodeName AS [Category],CSubCategory.CodeName AS [SubCategory]
		,company.CompanyName AS [Trading Company Name],CUserType.CodeName + '' Insider'' AS [Type of Insider],CPeriod.DisplayCode+ '' '' +CYear.CodeName AS [Period and Year]
		,dbo.uf_rpt_FormatDateValue(dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, '''+CONVERT(VARCHAR(11), @nExchangeTypeCodeId_NSE)+''' ),1) AS [Last Submission Date]
		--,CONVERT(VARCHAR(20), TD.DateOfAcquisition, 103) AS [Date of Transaction]
		--,vwIn.DetailsSubmitDate, vwIn.ScpSubmitDate, vwIn.HcpSubmitDate,
		,CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.DetailsSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.DetailsSubmitDate,1) END AS Holding,
		CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.ScpSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.ScpSubmitDate,1) END AS SoftCopy,
		CASE WHEN dbo.uf_rpt_FormatDateValue(vwIn.HcpSubmitDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(vwIn.HcpSubmitDate,1) END AS HardCopy

		,CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN '''+CONVERT(VARCHAR(100), @iCommentsId_NotSubmitted)+'''
							WHEN vwIn.DetailsSubmitDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''', DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, '''+CONVERT(VARCHAR(100), @nExchangeTypeCodeId_NSE)+''' )) THEN '''+CONVERT(VARCHAR(100), @iCommentsId_Ok)+''' -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit,@dtPEEnd)
							ELSE '''+CONVERT(VARCHAR(100), @iCommentsId_NotSubmittedInTime)+''' END AS [Comments]
		,DD.DEMATAccountNumber AS [Demat Account Number], UIF.FirstName + '' '' + UIF.LastName AS [A/C Holder Name],
		CASE WHEN UR.UserInfoId IS NULL  THEN ''Self'' ELSE CRelation.CodeName END AS [Relation with Insider],UF.PAN AS PAN,company.ISINCode AS [ISIN], 
		CSecurityType.CodeName AS [Security Type],
		TD.Quantity AS [Holdings] FROM  #tmpTransactions tTrans '
	SELECT @sSQL = @sSQL +'JOIN tra_TransactionMaster_OS TM ON tTrans.TransactionMasterId = TM.TransactionMasterId '
	SELECT @sSQL = @sSQL +'JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId '
	SELECT @sSQL = @sSQL +'JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
	SELECT @sSQL = @sSQL +'LEFT JOIN #TempPeriodEnd_EventStatus vwIn ON TM.UserInfoId = vwIn.UserInfoId AND vwIn.PeriodEndDate = ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '
	SELECT @sSQL = @sSQL +'JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
	SELECT @sSQL = @sSQL +'JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID '
	SELECT @sSQL = @sSQL +'JOIN rl_CompanyMasterList company ON TD.CompanyId = company.RlCompanyId '
	SELECT @sSQL = @sSQL +'LEFT JOIN usr_UserRelation UR ON TD.ForUserInfoId = UR.UserInfoIdRelative '
	SELECT @sSQL = @sSQL +'LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
	SELECT @sSQL = @sSQL +'JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CDesignation ON CDesignation .CodeID = UF.DesignationId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CGrade ON CGrade.CodeID = UF.GradeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CDept ON CDept.CodeID = UF.DepartmentId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CCategory ON CCategory.CodeID = UF.Category '
	SELECT @sSQL = @sSQL +'JOIN com_Code CSubCategory ON CSubCategory.CodeID = UF.SubCategory '
	SELECT @sSQL = @sSQL +'JOIN com_Code CUserType ON CUserType.CodeID = UF.UserTypeCodeId '
	SELECT @sSQL = @sSQL +'JOIN com_Code CPeriod ON CPeriod.CodeID = '''+CONVERT(VARCHAR(11), @inp_iPeriodCodeId)+''' '
	SELECT @sSQL = @sSQL +'JOIN com_Code CYear ON CYear.CodeID = '''+CONVERT(VARCHAR(11), @inp_iYearCodeId)+''' '
	SELECT @sSQL = @sSQL +'JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId '
	SELECT @sSQL = @sSQL +'JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId '		
	SELECT @sSQL = @sSQL +'LEFT JOIN usr_UserInfo UIF ON UIF.UserInfoId = DD.UserInfoID '
	SELECT @sSQL = @sSQL +'WHERE TD.TransactionDetailsId IS NOT NULL '
	IF ((@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sPan IS NOT NULL AND @inp_sPan <> ''))

		BEGIN
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND ISNULL(UF.FirstName,'''') + '' '' + ISNULL(UF.LastName, '''') like ''%' + @inp_sInsiderName + '%'''
			
			END			
			IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			BEGIN
				print '@inp_sPan'
				SELECT @sSQL = @sSQL + ' AND UF.PAN like ''%' + @inp_sPan + '%'' '
				
			END
			IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + ' AND company.CompanyName like ''%' + @inp_sCompanyName + '%'''
			
			END	
	END
  END

	--print(@sSQL)
	EXEC (@sSQL)	
	
	DROP TABLE #TempPeriodEnd_EventStatus
	DROP TABLE #tmpTransactions			
	
	RETURN 0			
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_TRANSACTIONDETAILS
	END CATCH
END