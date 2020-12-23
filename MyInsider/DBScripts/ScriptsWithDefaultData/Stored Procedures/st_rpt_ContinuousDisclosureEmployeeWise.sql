IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_ContinuousDisclosureEmployeeWise')
DROP PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeWise]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee wise report

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		01-Jun-2015

Modification History:
Modified By		Modified On		Description
Arundhati		13-Jul-2015		Exclude Initial disclosure data
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Raghvendra		29-Oct-2015		Fix for returning the dates in required format so that it can be seen correctly in Excel download.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Arundhati		03-Dec-2015		Search on multiple Transaction type was giving error. It is corrected.
ED				04-Jan-2016		Code integration done on 4-Jan-2016
ED				08-Jan-2016		Code integration done on 8-Jan-2016
Tushar			12-Jan-2016		1. Add User Type for Non Insider employee search and grid
Gaurishankar	14-Jan-2016		Changes for Mantis Bug id=8475 : 	The user who is updated as Separated but is active as per settings made in "Update Separation" details, is not displayed under any report.
								The user who is seperated but as per "DateOfInactivation" still active in application, should be displayed in all the reports.
ED			01-Mar-2016		Code changes during code merge done on 1-Mar-2016								
Raghvendra		1-Apr-2016		Fix for mantis issue no 8475 i.e. Sapreated users which are inactive should not be seen in any of the reports.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_ContinuousDisclosureEmployeeWise]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iUserInfoId			VARCHAR(MAX)
	,@inp_sEmployeeID			NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName			NVARCHAR(100) --= 's'
	,@inp_sDesignation			NVARCHAR(100) --= 's'
	,@inp_sGrade				NVARCHAR(100) --= 'a'
	,@inp_sLocation				NVARCHAR(50) --= 'pune'
	,@inp_sDepartment			NVARCHAR(100) --= 'a'
	,@inp_sCompanyName			NVARCHAR(200) --= 'k'
	,@inp_sTypeOfInsider		NVARCHAR(200) --= 101003,101006
	
	,@inp_sSecurityTypeCodeId NVARCHAR(200)
	,@inp_sTransactionTypeCodeId NVARCHAR(200)

	,@inp_dtFrom DATETIME --= '2015-05-15'
	,@inp_dtTo DATETIME --= '2015-05-19'

	--,@inp_dtSubmissionDateFrom DATETIME --= '2015-05-15'
	--,@inp_dtSubmissionDateTo DATETIME --= '2015-05-19'
	--,@inp_dtSoftCopySubmissionDateFrom DATETIME --= '2015-05-14'
	--,@inp_dtSoftCopySubmissionDateTo DATETIME --= '2015-05-15'
	--,@inp_dtHardCopySubmissionDateFrom DATETIME
	--,@inp_dtHardCopySubmissionDateTo DATETIME

	--,@inp_iCommentsId INT --= 162002
	,@inp_sIsInsiderFlag				NVARCHAR(200) -- 173001 : Insider, 173002 : Non Insider
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'

	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003
	DECLARE @iIsTransCriteria INT = 0

	DECLARE @nTransaction_Buy INT = 143001
	DECLARE @nTransaction_Sell INT = 143002
	DECLARE @nInsiderFlag_Insider			INT = 173001
	DECLARE @nInsiderFlag_NonInsider		INT = 173002
	DECLARE @sInsider VARCHAR(20)					= ' Insider'
	
	DECLARE @sTransaction_BuySell VARCHAR(100)

	CREATE TABLE #tmpInitialDisclosure(Id INT Identity(1,1), UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100),
	JoiningDate DATETIME, CINNumber NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(100), Location NVARCHAR(50),
	Department NVARCHAR(100), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(50), SecurityType VARCHAR(100), TransactionType VARCHAR(100),
	BuyQuantity INT DEFAULT 0, SellQuantity INT DEFAULT 0, Value DECIMAL(25,4) DEFAULT 0,
	SecurityTypeCodeId INT, TransactionTypeCodeId INT,
	DateOfInactivation DATETIME, Category VARCHAR(500), SubCategory  VARCHAR(500), CodeName VARCHAR(500))

	DECLARE @tmpTransactionDetails TABLE (TransactionDetailsId INT, UserInfoId INT)

	CREATE TABLE #tmpUsers(UserInfoId INT)

	DECLARE @tmpComments TABLE (CodeId INT, DisplayText VARCHAR(100))
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @sTransaction_BuySell = CodeName FROM com_Code WHERE CodeID = @nTransaction_Buy
		SELECT @sTransaction_BuySell = @sTransaction_BuySell + '/' + CodeName FROM com_Code WHERE CodeID = @nTransaction_Sell
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'rpt_grd_19074'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'rpt_grd_19074'
		BEGIN
			SET @inp_sSortField = 'EmployeeId'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19075'
		BEGIN
			SET @inp_sSortField = 'InsiderName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19076'
		BEGIN
			SET @inp_sSortField = 'JoiningDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19077'
		BEGIN
			SET @inp_sSortField = 'CINNumber'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19078'
		BEGIN
			SET @inp_sSortField = 'Designation'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19079'
		BEGIN
			SET @inp_sSortField = 'Grade'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19080'
		BEGIN
			SET @inp_sSortField = 'Location'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19081'
		BEGIN
			SET @inp_sSortField = 'Department'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19082'
		BEGIN
			SET @inp_sSortField = 'CompanyName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19083'
		BEGIN
			SET @inp_sSortField = 'TypeOfInsider'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19084'
		BEGIN
			SET @inp_sSortField = 'SecurityType'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19085'
		BEGIN
			SET @inp_sSortField = 'TransactionType'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19087'
		BEGIN
			SET @inp_sSortField = 'BuyQuantity'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19088'
		BEGIN
			SET @inp_sSortField = 'SellQuantity'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19089'
		BEGIN
			SET @inp_sSortField = 'Value'
		END


		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END
		
		INSERT INTO @tmpComments(CodeId, DisplayText)
		SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
		WHERE CodeID BETWEEN 162001 AND 162003

		-- Find all applicable users based on the filter criteria if applied
		SELECT @sSQL = 'SELECT UserInfoId FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		--SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND (DateOfSeparation IS NULL OR dbo.uf_com_GetServerDate() <= DateOfSeparation) '
		SELECT @sSQL = @sSQL + 'AND (((DateOfBecomingInsider IS NULL OR DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UserTypeCodeId = 101003) OR (DateOfBecomingInsider <= dbo.uf_com_GetServerDate()))  AND (DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < DateOfInactivation) '

		IF ((@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
		  OR (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		  OR (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
		  OR (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
		  OR (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> '')
		  OR (@inp_sIsInsiderFlag IS NOT NULL AND @inp_sIsInsiderFlag <> ''))
		BEGIN
			IF (@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
			BEGIN
				print '@inp_iUserInfoId'
				SELECT @sSQL = @sSQL + ' AND UserInfoId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_iUserInfoId + ''', '',''))'
			END
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
  			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''') END like ''%' + @inp_sInsiderName + '%'''
			
			END
  			IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
			BEGIN
				print '@inp_sDesignation'
				SELECT @sSQL = @sSQL + ' AND (CDesignation.CodeName like ''%' + @inp_sDesignation + '%'' OR DesignationText like ''%' + @inp_sDesignation + '%'')'
			
			END
  			IF (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
			BEGIN
				print '@inp_sGrade'
				SELECT @sSQL = @sSQL + ' AND (CGrade.CodeName like ''%' + @inp_sGrade + '%'' OR GradeText like ''%' + @inp_sGrade + '%'')'
			
			END
  			IF (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
			BEGIN
				print '@inp_sLocation'
				SELECT @sSQL = @sSQL + ' AND Location like ''%' + @inp_sLocation + '%'''
			
			END
  			IF (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
			BEGIN
				print '@inp_sDepartment'
				SELECT @sSQL = @sSQL + ' AND (CDepartment.CodeName like ''%' + @inp_sDepartment + '%'' OR DepartmentText like ''%' + @inp_sDepartment + '%'')'
			END
  			IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + ' AND C.CompanyName like ''%' + @inp_sCompanyName + '%'''
			
			END
  			IF (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> '')
			BEGIN
				print '@inp_sTypeOfInsider'
				SELECT @sSQL = @sSQL + ' AND UF.UserTypeCodeId IN (' + @inp_sTypeOfInsider + ') '
			END
			BEGIN
			PRINT @inp_sIsInsiderFlag
			IF CHARINDEX(',',@inp_sIsInsiderFlag) <= 0
			BEGIN
				IF @inp_sIsInsiderFlag = @nInsiderFlag_Insider
				BEGIN
					-- When the flag is one, records with date of becoming insider not null to be taken
					SELECT @sSQL = @sSQL + ' AND UF.DateOfBecomingInsider IS '
					SELECT @sSQL = @sSQL + ' NOT'			
				END
				ELSE IF @inp_sIsInsiderFlag = @nInsiderFlag_NonInsider
				BEGIN
					-- When the flag is one, records with date of becoming insider not null to be taken
					SELECT @sSQL = @sSQL + ' AND UF.DateOfBecomingInsider IS '
					SELECT @sSQL = @sSQL + ''			
				END
				SELECT @sSQL = @sSQL + ' NULL '
			END
		END
		END

		print 'Query1 = ' + @sSQL

		INSERT INTO #tmpUsers(UserInfoId)
		EXEC (@sSQL)

		-- Collect all transaction details Ids based on Filter criteria provided
		SELECT @sSQL = 'SELECT TD.TransactionDetailsId, TM.UserInfoId '
		SELECT @sSQL = @sSQL + 'FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId '
		SELECT @sSQL = @sSQL + 'JOIN #tmpUsers t ON TM.UserInfoId = t.UserInfoId '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 AND TM.TransactionStatusCodeId > 148002 '
		SELECT @sSQL = @sSQL + 'AND TM.DisclosureTypeCodeId <> 147001 '

		IF ((@inp_dtFrom IS NOT NULL AND @inp_dtFrom <> '')
			OR (@inp_dtTo IS NOT NULL AND @inp_dtTo <> ''))
		BEGIN
			SET @iIsTransCriteria = 1
			IF (@inp_dtFrom IS NOT NULL AND @inp_dtFrom <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtFrom) + ''') <= TD.DateOfAcquisition '
			END
			
			IF (@inp_dtTo IS NOT NULL AND @inp_dtTo <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtTo) + ''') >= TD.DateOfAcquisition '
			END
		END

		IF (@inp_sSecurityTypeCodeId IS NOT NULL AND @inp_sSecurityTypeCodeId <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId IN (' +  @inp_sSecurityTypeCodeId + ') '
		END

		IF (@inp_sTransactionTypeCodeId IS NOT NULL AND @inp_sTransactionTypeCodeId <> '')
		BEGIN
			--IF @inp_sTransactionTypeCodeId = @nTransaction_Sell
			--BEGIN
			--	SELECT @sSQL = @sSQL + ' AND TD.TransactionTypeCodeId IN (143001, 143002) '
			--END
			--ELSE
			BEGIN
				SELECT @sSQL = @sSQL + ' AND TD.TransactionTypeCodeId IN (' + @inp_sTransactionTypeCodeId + ') '
			END
		END
		
		print 'Query2 = ' + @sSQL

		INSERT INTO @tmpTransactionDetails(TransactionDetailsId, UserInfoId)
		EXEC (@sSQL)

		--IF @iIsTransCriteria = 1
		--BEGIN
		--	DELETE tmpDisc
		--	FROM #tmpInitialDisclosure tmpDisc LEFT JOIN @tmpTransactionIds tmpTrans ON tmpDisc.UserInfoId = tmpTrans.UserInfoId
		--	WHERE tmpTrans.UserInfoId IS NULL
		--END

		INSERT INTO #tmpInitialDisclosure(UserInfoId, SecurityTypeCodeId, TransactionTypeCodeId)
		SELECT TM.UserInfoId, TD.SecurityTypeCodeId, CASE WHEN TransactionTypeCodeId = @nTransaction_Sell THEN @nTransaction_Buy ELSE TransactionTypeCodeId END
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			JOin tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
		GROUP BY TM.UserInfoId, TD.SecurityTypeCodeId, CASE WHEN TransactionTypeCodeId = @nTransaction_Sell THEN @nTransaction_Buy ELSE TransactionTypeCodeId END


		UPDATE tmpDisc
			SET EmployeeId = UF.EmployeeId,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			JoiningDate = DateOfBecomingInsider,
			CINNumber = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END,
			Designation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
			Grade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
			Location = UF.Location,
			Department = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
			CompanyName = C.CompanyName,
			TypeOfInsider = CUserType.CodeName + CASE WHEN DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END,
			SecurityType = CSecurity.CodeName,
			TransactionType = CASE WHEN TransactionTypeCodeId = @nTransaction_Buy THEN @sTransaction_BuySell ELSE CTransaction.CodeName END,
			DateOfInactivation = UF.DateOfInactivation,
			Category = CCategory.CodeName,
			SubCategory = CSubCategory.CodeName,
			CodeName = CCode.CodeName
		FROM #tmpInitialDisclosure tmpDisc JOIN usr_UserInfo UF ON tmpDisc.UserInfoId = UF.UserInfoId
			JOIN mst_Company C ON UF.CompanyId = C.CompanyId
			JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
			JOIN com_Code CSecurity ON tmpDisc.SecurityTypeCodeId = CSecurity.CodeID
			JOIN com_Code CTransaction ON tmpDisc.TransactionTypeCodeId = CTransaction.CodeID
			--LEFT JOIN vw_InitialDisclosureStatus vwIn ON tmpDisc.UserInfoId = vwIn.UserInfoId
			LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
			LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
			LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
			LEFT JOIN com_Code CCategory ON CCategory.CodeID = UF.Category
			LEFT JOIN com_Code CSubCategory ON CSubCategory.CodeID = UF.SubCategory
			LEFT JOIN com_Code CCode ON CCode.CodeID = UF.StatusCodeId
			
		UPDATE tmpDisc
		SET BuyQuantity = TD.BuyQuantity,
			SellQuantity = TD.SellQuantity,
			Value = TD.BuyValue + TD.SellValue
		FROM #tmpInitialDisclosure tmpDisc JOIN
			(SELECT TM.UserInfoId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, SUM(Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) AS BuyQuantity, SUM(Quantity2 * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) AS SellQuantity, SUM(Value) AS BuyValue, SUM(Value2) AS SellValue
				FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
					JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
				GROUP BY TM.UserInfoId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId) TD ON 
					tmpDisc.UserInfoId = TD.UserInfoId AND tmpDisc.SecurityTypeCodeId = TD.SecurityTypeCodeId AND tmpDisc.TransactionTypeCodeId = TD.TransactionTypeCodeId
		
		-- Consider the sell transactions' effect
		UPDATE tmpDisc
		SET SellQuantity = SellQuantity + TD.Quantity,
			Value = tmpDisc.Value + TD.Value
		FROM #tmpInitialDisclosure tmpDisc JOIN
			(SELECT TM.UserInfoId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, SUM(Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) AS Quantity, SUM(Value) AS Value
				FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
					JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId = @nTransaction_Sell
				GROUP BY TM.UserInfoId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId) TD ON 
					tmpDisc.UserInfoId = TD.UserInfoId AND tmpDisc.SecurityTypeCodeId = TD.SecurityTypeCodeId AND tmpDisc.TransactionTypeCodeId = @nTransaction_Buy



		--INSERT INTO #tmpList(RowNumber, EntityID)
		--SELECT t.Id, t.Id FROM #tmpInitialDisclosure t

		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
		SELECT @sSQL = @sSQL + 'FROM #tmpInitialDisclosure ID '
		
		print @sSQL
		EXEC (@sSQL)

		--SELECT * FROM #tmpInitialDisclosure
		--ORDER BY EmployeeId, InsiderName, SecurityTypeCodeId, TransactionTypeCodeId
		
		SELECT @sSQL = 'SELECT '
		SELECT @sSQL = @sSQL + 'EmployeeId AS rpt_grd_19074, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(InsiderName) AS rpt_grd_19075, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(JoiningDate,0) AS rpt_grd_19076, '
		SELECT @sSQL = @sSQL + 'CINNumber AS rpt_grd_19077, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Designation),1)) AS rpt_grd_19078, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Grade),1)) AS rpt_grd_19079, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Location),1)) AS rpt_grd_19080, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Department),1)) AS rpt_grd_19081, '
		SELECT @sSQL = @sSQL + 'CompanyName AS rpt_grd_19082, '
		SELECT @sSQL = @sSQL + 'TypeOfInsider AS rpt_grd_19083, '
		SELECT @sSQL = @sSQL + 'SecurityType AS rpt_grd_19084, '
		SELECT @sSQL = @sSQL + 'TransactionType AS rpt_grd_19085, '
		SELECT @sSQL = @sSQL + 'BuyQuantity AS rpt_grd_19087, '
		SELECT @sSQL = @sSQL + 'SellQuantity AS rpt_grd_19088, '
		SELECT @sSQL = @sSQL + 'Value AS rpt_grd_19089, '
		SELECT @sSQL = @sSQL + 'UserInfoId, SecurityTypeCodeId, TransactionTypeCodeId,  dbo.uf_rpt_FormatDateValue(ID.DateOfInactivation,0) AS DateOfInactivation , ID.Category , ID.SubCategory , ID.CodeName '
		SELECT @sSQL = @sSQL + 'FROM #tmpInitialDisclosure ID JOIN #tmpList t ON t.EntityID = ID.Id '
		--SELECT @sSQL = @sSQL + 'ORDER BY EmployeeId, InsiderName, SecurityTypeCodeId, TransactionTypeCodeId '
		SELECT @sSQL = @sSQL + 'WHERE ID.UserInfoID IS NOT NULL '
		SELECT @sSQL = @sSQL + 'AND ((' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' = 0) '
		SELECT @sSQL = @sSQL + 'OR (T.RowNumber BETWEEN ((' + CONVERT(VARCHAR(10), @inp_iPageNo) + ' - 1) * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' + 1) '
		SELECT @sSQL = @sSQL + 'AND (' + CONVERT(VARCHAR(10), @inp_iPageNo) +  ' * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + '))) '
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
		
		print @sSQL
		EXEC (@sSQL)

		DROP TABLE #tmpInitialDisclosure
		DROP TABLE #tmpUsers
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
GO