IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndDisclosurePeriodSummary_OS')
DROP PROCEDURE dbo.st_rpt_PeriodEndDisclosurePeriodSummary_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndDisclosurePeriodSummary_OS] 
	 @inp_sEmployeeID					NVARCHAR(50) = ''
	,@inp_sInsiderName					NVARCHAR(100) = ''
	,@inp_sPan							NVARCHAR(100) = ''
	,@inp_sCompanyName					NVARCHAR(200) = ''
	,@inp_iYearCodeId					NVARCHAR(50) = ''
	,@inp_iPeriodCodeId					NVARCHAR(50) = ''
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003
	DECLARE @iIsTransCriteria INT = 0
	DECLARE @nInsiderFlag_Insider			INT = 173001
	DECLARE @nInsiderFlag_NonInsider		INT = 173002
	DECLARE @sInsider VARCHAR(20)			= ' Insider'
	DECLARE @RC INT
	DECLARE @dtPEStart DATETIME
	DECLARE @dtPEEnd DATETIME	
	DECLARE @nPeriodType INT
	DECLARE @dtCurrentDate DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001

	SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

	CREATE TABLE #TempPeriodEnd_EventStatus(TransactionMasterId INT,UserInfoID INT,PeriodEndDate DATETIME,SoftCopyReq BIT,HardCopyReq BIT,
	 DetailsSubmitStatus INT, DetailsSubmitDate DATETIME, ScpSubmitStatus INT, ScpSubmitDate DATETIME,HcpSubmitStatus INT, HcpSubmitDate DATETIME)

	CREATE TABLE #tmpPEDisclosure(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100),PAN NVARCHAR(50),
		StatusCodeId VARCHAR(50), TypeOfInsider NVARCHAR(50), SubmissionDate DATETIME,
		SoftCopySubmissionDate DATETIME, HardCopySubmissionDate DATETIME, CommentId INT DEFAULT 162003,TransactionMasterId INT,  
		LastSubmissionDate DATETIME, PEndDate DATETIME, YearCodeId INT, PeriodCodeId INT,PeriodTypeId INT,PeriodType varchar(50))

	CREATE TABLE #tmpTransactions (TransactionMasterId INT, UserInfoID INT)

DECLARE @tmpTransactionIds TABLE (TransactionMasterId INT, UserInfoId INT)
DECLARE @tmpComments TABLE (CodeId INT, DisplayText VARCHAR(100))

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

	IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
	BEGIN
		SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
	END

	INSERT INTO @tmpComments(CodeId, DisplayText)
		SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
		WHERE CodeID BETWEEN 162001 AND 162003

	INSERT INTO #tmpPEDisclosure(UserInfoId, PEndDate)
		SELECT UF.UserInfoId,TM.PeriodEndDate 
		FROM tra_TransactionMaster_OS TM LEFT JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId AND TM.DisclosureTypeCodeId = 147003
		AND TM.PeriodEndDate =  '' + CONVERT(VARCHAR(11), @dtPEEnd) + ''
		AND TM.PeriodEndDate <  '' + CONVERT(VARCHAR(11), @dtCurrentDate) + ''
		JOIN mst_Company C ON UF.CompanyId = C.CompanyId
		LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID
		LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID
		LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
		LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
		WHERE 1 = 1 AND (DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < DateOfInactivation)

	INSERT INTO #TempPeriodEnd_EventStatus(TransactionMasterId,UserInfoID,PeriodEndDate,SoftCopyReq,HardCopyReq,
			DetailsSubmitStatus, DetailsSubmitDate, ScpSubmitStatus, ScpSubmitDate,HcpSubmitStatus, HcpSubmitDate)
		EXEC st_tra_PeriodEndDisclosureEventStatus_OS

	INSERT INTO @tmpTransactionIds(TransactionMasterId, UserInfoId)
		SELECT TransactionMasterId, vwPEDS.UserInfoId FROM
		#TempPeriodEnd_EventStatus vwPEDS WHERE 1 = 1
		AND vwPEDS.PeriodEndDate = '' + CONVERT(VARCHAR(11), @dtPEEnd) + ''

	UPDATE tmpTD
		SET LastSubmissionDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
			CommentId = @iCommentsId_NotSubmittedInTime
		FROM #tmpPEDisclosure tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId 
			JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate 
					AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		WHERE TM.DisclosureTypeCodeId = 147003

	UPDATE tmpDisc
			SET EmployeeId = UF.EmployeeId,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			PAN = UF.PAN , 
			StatusCodeId = CStatusCodeId.CodeName,
			TypeOfInsider = CUserType.CodeName + CASE WHEN DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END,
			SubmissionDate = vwIn.DetailsSubmitDate,
			SoftCopySubmissionDate = vwIn.ScpSubmitDate,
			HardCopySubmissionDate = vwIn.HcpSubmitDate,
			TransactionMasterId = vwIn.TransactionMasterId,
			LastSubmissionDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
			YearCodeId = UPEMap.YearCodeId, 
			PeriodCodeId = UPEMap.PeriodCodeId,
			PeriodTypeId=CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.DiscloPeriodEndFreq 
						END,
			PeriodType=CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN (select CodeName from com_code where codeId='123001') -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN (select CodeName from com_code where codeId='123003') -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN (select CodeName from com_code where codeId='123004') -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN (select CodeName from com_code where codeId='123002') -- half yearly
							ELSE (select CodeName from com_code where codeId=TP.DiscloPeriodEndFreq) 
						END
		FROM #tmpPEDisclosure tmpDisc JOIN usr_UserInfo UF ON tmpDisc.UserInfoId = UF.UserInfoId
		JOIN mst_Company C ON UF.CompanyId = C.CompanyId
		JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
		LEFT JOIN #TempPeriodEnd_EventStatus vwIn ON tmpDisc.UserInfoId = vwIn.UserInfoId AND PeriodEndDate = tmpDisc.PEndDate
		LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
		LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
		LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
		LEFT JOIN tra_TransactionMaster_OS TM ON vwIn.TransactionMasterId = TM.TransactionMasterId
		LEFT JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
		LEFT JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		LEFT join com_Code CCategory on UF.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UF.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UF.StatusCodeId = CStatusCodeId.CodeID
	
	UPDATE tmpTrans
		SET CommentId = /*CASE WHEN JoiningDate < @dtImplementation THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate < DiscloInitDateLimit THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN JoiningDate >= @dtImplementation THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate < DATEADD(D, DiscloInitLimit, JoiningDate) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END*/
						CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
							WHEN tmpTrans.SubmissionDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(PEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) THEN @iCommentsId_Ok -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit,@dtPEEnd)
							ELSE @iCommentsId_NotSubmittedInTime END
		FROM #tmpPEDisclosure tmpTrans JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
		JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId


	IF(@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		BEGIN
			INSERT INTO #tmpTransactions (TransactionMasterId , UserInfoID)
			select TM.TransactionMasterId,TM.UserInfoID FROM tra_TransactionMaster_OS TM WHERE UserInfoId in(
			select TM.UserInfoId FROM tra_TransactionDetails_OS TD  right join tra_TransactionMaster_OS TM
			ON TM.TransactionMasterId=TD.TransactionMasterId		
			LEFT JOIN rl_CompanyMasterList CM ON CM.RlCompanyId=TD.CompanyId
			WHERE PeriodEndDate=@dtPEEnd AND CM.CompanyName like '%'+@inp_sCompanyName+'%')
			AND DisclosureTypeCodeId=147003
		END

		SELECT @sSQL = 'SELECT EmployeeId,InsiderName AS [Employee Name],StatusCodeId AS [Status],TypeOfInsider AS [Type Of Insider],
		CPeriod.DisplayCode + '' '' + CYear.CodeName AS [Period and Year]
		,dbo.uf_rpt_FormatDateValue(LastSubmissionDate,1) AS [Last Submission Date],
		CASE WHEN dbo.uf_rpt_FormatDateValue(SubmissionDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(SubmissionDate,1) END AS Holding,
		CASE WHEN dbo.uf_rpt_FormatDateValue(SoftCopySubmissionDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(SoftCopySubmissionDate,1) END AS SoftCopy,
		CASE WHEN dbo.uf_rpt_FormatDateValue(HardCopySubmissionDate,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(HardCopySubmissionDate,1) END AS HardCopy,
		PAN,RComment.ResourceValue AS [Comment Name] from #tmpPEDisclosure PED '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CPeriod ON CPeriod.CodeID = PED.PeriodCodeId '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CYear ON CYear.CodeID = PED.YearCodeId '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CComment ON CComment.CodeID = PED.CommentId '
		SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
		IF ((@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sPan IS NOT NULL AND @inp_sPan <> ''))
		  BEGIN
			 IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
				BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + 'JOIN #tmpTransactions TMP ON TMP.userinfoid = PED.userinfoid '
				END
				
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND PED.EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND PED.InsiderName like ''%' + @inp_sInsiderName + '%'''
			
			END			
			IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			BEGIN
				print '@inp_sPan'
				SELECT @sSQL = @sSQL + ' AND PED.PAN like ''%' + @inp_sPan + '%'' '
				
			END		
		  END

	EXEC (@sSQL)	  
	DROP TABLE #tmpPEDisclosure
	DROP TABLE #TempPeriodEnd_EventStatus
	DROP TABLE #tmpTransactions

	RETURN 0
END