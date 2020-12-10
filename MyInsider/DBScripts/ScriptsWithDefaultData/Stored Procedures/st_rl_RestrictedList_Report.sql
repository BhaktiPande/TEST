IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_RestrictedList_Report')
DROP PROCEDURE [dbo].[st_rl_RestrictedList_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Restricted search list along with preclearance details (if preclearance details are available).

Returns:		0, if Success.
				
Created by:		Raghvendra	
Created on:		23-Sep-2016

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_rl_RestrictedList_Report @inp_iLoggedInUserId
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rl_RestrictedList_Report]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)
	,@inp_iLoggedInUserId					INT --Loggedin UserInfoId
	,@inp_sEmployeeID						NVARCHAR(100)
	,@inp_sEmployeeName						NVARCHAR(MAX)
	,@inp_sDepartment						NVARCHAR(MAX)
	,@inp_sDesignation						NVARCHAR(MAX)
	,@inp_sGrade							NVARCHAR(MAX)
	,@inp_sCompanyName						VARCHAR(300)
	,@inp_dtSearchDateFrom					DATETIME
	,@inp_dtSearchDateTo					DATETIME
	,@inp_sTradingAllowedCodes				NVARCHAR(300)
	,@inp_iPreclearanceID					NVARCHAR(300)
	,@inp_dtPreclearanceRequestDateFrom		DATETIME
	,@inp_dtPreclearanceRequestDateTo		DATETIME
	,@inp_sTransactionTypeCodeIds			NVARCHAR(MAX)
	,@inp_sSecurityTypeCodeIds				NVARCHAR(MAX)
	,@inp_sPreclearanceStatusCodeIds		NVARCHAR(MAX)
	,@out_nReturnValue						INT = 0				OUTPUT
	,@out_nSQLErrCode						INT = 0				OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY	INT = 50300 --Error occurred while fetching restricted list report data.
	DECLARE @sNotAvailable					VARCHAR(50) = 'Not Available'

	DECLARE @sPrceclearanceCodePrefixText		 VARCHAR(4)
	--DECLARE @sNonPrceclearanceCodePrefixText	 VARCHAR(4)
	DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(4)

	DECLARE @nPreclearanceTakenCase INT = 176001
	DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
	DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003

	DECLARE @nEventPreclearanceRequested INT = 153045
	DECLARE @nEventPreclearanceApproved INT = 153046
	DECLARE @nEventPreclearanceRejected INT = 153047
	DECLARE @nMapToTypePreclearanceNonImplementingCompany INT = 132015
	DECLARE @nResourceKeyTradingNotAllowed INT = 50016 
	DECLARE @nUserTypeCodeIdAdmin			INT = 101001
	DECLARE @nUserTypeCodeIdCO				INT = 101002
	DECLARE @nLoggedInUserTypeCodeId		INT

	BEGIN TRY

		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Set the Prefix to display for Preclearance ID
		SET	@sPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
		--SET @sNonPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
		SET @sPrceclearanceNotRequiredPrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)

		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UI.EmployeeId '
		END

		IF @inp_sSortField IS NULL OR @inp_sSortField <> ''
		BEGIN 
			SELECT @inp_sSortField = 'UI.EmployeeId '
		END

		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',RLSA.RlSearchAuditId DESC),RLSA.RlSearchAuditId '
		SELECT @sSQL = @sSQL + ' FROM rl_SearchAudit RLSA INNER JOIN usr_UserInfo UI ON RLSA.UserInfoId = UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CDept ON UI.DepartmentId = CDept.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CDesig ON UI.DesignationId = CDesig.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CGrade ON UI.GradeId = CDesig.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN rl_CompanyMasterList CML ON RLSA.RlCompanyId = CML.RlCompanyId '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC ON (RLSA.RlSearchAuditId = PRNIC.RlSearchAuditId) AND (PRNIC.UserInfoId = UI.UserInfoId) '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CTransactionType ON PRNIC.TransactionTypeCodeId = CTransactionType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CSecurityType ON PRNIC.SecurityTypeCodeId = CSecurityType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN 
									(
										SELECT E.MapToId AS PRNICId, EventCodeId AS PRNICEventCode, E.EventDate AS PRNICEventDate 
										FROM eve_EventLog E
										JOIN (SELECT MAX(EventDate) AS EventDate, MapToTypeCodeId, MapToId FROM eve_EventLog E 
										WHERE MapToTypeCodeId = ' + CONVERT(VARCHAR(10), @nMapToTypePreclearanceNonImplementingCompany) + ' ' +
										' AND EventCodeId IN ('+ CONVERT(VARCHAR(10),@nEventPreclearanceRequested) + ','+ CONVERT(VARCHAR(10),@nEventPreclearanceApproved) +',' + CONVERT(VARCHAR(10),@nEventPreclearanceRejected) +')
										GROUP BY MapToTypeCodeId, MapToId
										) RequestApproveRejectEventDate
										ON E.EventDate = RequestApproveRejectEventDate.EventDate 
										AND E.MapToTypeCodeId = RequestApproveRejectEventDate.MapToTypeCodeId 
										AND E.MapToId = RequestApproveRejectEventDate.MapToId
										AND E.MapToTypeCodeId = ' + CONVERT(VARCHAR(10),@nMapToTypePreclearanceNonImplementingCompany) + 
										' AND E.EventCodeId IN (' + CONVERT(VARCHAR(10),@nEventPreclearanceRequested) +','+ CONVERT(VARCHAR(10),@nEventPreclearanceApproved) +',' + CONVERT(VARCHAR(10),@nEventPreclearanceRejected) +')
										--ORDER BY E.MapToId
									) PRNICEventsTable ON PRNIC.PreclearanceRequestId = PRNICEventsTable.PRNICId '
		SELECT @sSQL = @sSQL + ' LEFT OUTER JOIN com_Code CPRNICStatus ON (PRNIC.PreclearanceStatusCodeId = CPRNICStatus.CodeID) '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '


		--Add the filter conditions here
		IF @inp_iLoggedInUserId IS NOT NULL AND @inp_iLoggedInUserId <> 0
		BEGIN 
			SELECT @nLoggedInUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_iLoggedInUserId
			IF( @nLoggedInUserTypeCodeId <> @nUserTypeCodeIdAdmin AND @nLoggedInUserTypeCodeId <> @nUserTypeCodeIdCO) --Restrict records display for users other than Admin and CO 
			BEGIN
				SELECT @sSQL = @sSQL + ' AND UI.UserInfoId = ' + CONVERT(VARCHAR(10), @inp_iLoggedInUserId) 
			END
		END

		IF(@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.EmployeeId like ''%' + CONVERT(VARCHAR,@inp_sEmployeeID) + '%'''
		END
		IF(@inp_sEmployeeName IS NOT NULL AND @inp_sEmployeeName <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UI.FirstName like ''%' + CONVERT(VARCHAR,@inp_sEmployeeName) + '%'''
			SELECT @sSQL = @sSQL + ' OR UI.LastName like ''%' + CONVERT(VARCHAR,@inp_sEmployeeName) + '%'') '
		END
		IF(@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (CDept.CodeName like ''%' + CONVERT(VARCHAR,@inp_sDepartment) + '%'''
			SELECT @sSQL = @sSQL + ' OR UI.DepartmentText like ''%' + CONVERT(VARCHAR,@inp_sDepartment) + '%'')'
		END
		IF(@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (CDesig.CodeName like ''%' + CONVERT(VARCHAR,@inp_sDesignation) + '%'''
			SELECT @sSQL = @sSQL + ' OR UI.DesignationText like ''%' + CONVERT(VARCHAR,@inp_sDesignation) + '%'')'
		END
		IF(@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (CGrade.CodeName like ''%' + CONVERT(VARCHAR,@inp_sGrade) + '%'''
			SELECT @sSQL = @sSQL + ' OR UI.GradeText like ''%' + CONVERT(VARCHAR,@inp_sGrade) + '%'')'
		END

		IF(@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CML.CompanyName like ''%' + CONVERT(VARCHAR,@inp_sCompanyName) + '%'' '
		END
		--Restricted Search Audit Created On Date
		IF(@inp_dtSearchDateFrom IS NOT NULL AND @inp_dtSearchDateFrom <> '' AND @inp_dtSearchDateTo IS NOT NULL AND @inp_dtSearchDateTo <> '')
		BEGIN
				SELECT @sSQL = @sSQL + ' AND RLSA.CreatedOn IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (RLSA.CreatedOn >= CAST('''  + CAST(@inp_dtSearchDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (RLSA.CreatedOn IS NULL OR RLSA.CreatedOn <= CAST('''  + CAST(@inp_dtSearchDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSearchDateFrom IS NOT NULL AND @inp_dtSearchDateFrom <> '' AND (@inp_dtSearchDateTo IS NULL OR @inp_dtSearchDateTo = ''))
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( RLSA.CreatedOn IS NOT NULL AND RLSA.CreatedOn >= CAST('''  + CAST(@inp_dtSearchDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF ((@inp_dtSearchDateFrom IS NULL OR @inp_dtSearchDateFrom = '') AND @inp_dtSearchDateTo IS NOT NULL AND @inp_dtSearchDateTo <> '')
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (RLSA.CreatedOn IS NOT NULL AND RLSA.CreatedOn <= CAST('''  + CAST(@inp_dtSearchDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END		
		--RLSA.ResourceKey can be 50016 denoting 'No' or RLSA.ResourceKey can be 50015 denoting 'Yes'
		IF(@inp_sTradingAllowedCodes IS NOT NULL AND @inp_sTradingAllowedCodes <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RLSA.ResourceKey IN (' + @inp_sTradingAllowedCodes + ') '
		END

		IF(@inp_iPreclearanceID IS NOT NULL AND @inp_iPreclearanceID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND( 
										(UI.DateOfBecomingInsider IS NOT NULL AND ''' + @sPrceclearanceCodePrefixText + ''' + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo) like ''%'+ CONVERT(VARCHAR,@inp_iPreclearanceID) +'%'') '
			SELECT @sSQL = @sSQL + ' OR (UI.DateOfBecomingInsider IS NULL AND ''' + @sPrceclearanceNotRequiredPrefixText + ''' + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo) like ''%'+ CONVERT(VARCHAR,@inp_iPreclearanceID) +'%'') '
			SELECT @sSQL = @sSQL + ' ) '
		END

		--Preclearance Created On Date
		IF(@inp_dtPreclearanceRequestDateFrom IS NOT NULL AND @inp_dtPreclearanceRequestDateFrom <> '' AND @inp_dtPreclearanceRequestDateTo IS NOT NULL AND @inp_dtPreclearanceRequestDateTo <> '')
		BEGIN
				SELECT @sSQL = @sSQL + ' AND PRNIC.CreatedOn IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (PRNIC.CreatedOn >= CAST('''  + CAST(@inp_dtPreclearanceRequestDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (PRNIC.CreatedOn IS NULL OR PRNIC.CreatedOn <= CAST('''  + CAST(@inp_dtPreclearanceRequestDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtPreclearanceRequestDateFrom IS NOT NULL AND @inp_dtPreclearanceRequestDateFrom <> '' AND (@inp_dtPreclearanceRequestDateTo IS NULL OR @inp_dtPreclearanceRequestDateTo = ''))
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( PRNIC.CreatedOn IS NOT NULL AND PRNIC.CreatedOn >= CAST('''  + CAST(@inp_dtPreclearanceRequestDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF ((@inp_dtPreclearanceRequestDateFrom IS NULL OR @inp_dtPreclearanceRequestDateFrom = '') AND @inp_dtPreclearanceRequestDateTo IS NOT NULL AND @inp_dtPreclearanceRequestDateTo <> '')
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( PRNIC.CreatedOn IS NOT NULL AND PRNIC.CreatedOn <= CAST('''  + CAST(@inp_dtPreclearanceRequestDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END	

		IF(@inp_sTransactionTypeCodeIds IS NOT NULL AND @inp_sTransactionTypeCodeIds <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CTransactionType.CodeID IN (' + @inp_sTransactionTypeCodeIds + ') '
		END
		IF(@inp_sSecurityTypeCodeIds IS NOT NULL AND @inp_sSecurityTypeCodeIds <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CSecurityType.CodeID IN (' + @inp_sSecurityTypeCodeIds + ') '
		END
		IF(@inp_sPreclearanceStatusCodeIds IS NOT NULL AND @inp_sPreclearanceStatusCodeIds <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CPRNICStatus.CodeID IN (' + @inp_sPreclearanceStatusCodeIds + ') '
		END
		

		PRINT @sSQL
		EXEC(@sSQL)

		SELECT RLSA.RlSearchAuditId, ISNULL(UI.EmployeeId,'') AS rl_grd_50301,--'EmployeeId', 
		ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS rl_grd_50302,--'Employee Name',
		CASE WHEN UI.DepartmentId IS NULL THEN ISNULL(UI.DepartmentText,'') ELSE (CASE WHEN CDept.DisplayCode IS NULL THEN ISNULL(CDept.CodeName,'') ELSE CDept.DisplayCode END) END AS rl_grd_50303,--'Department',
		CASE WHEN UI.DesignationId IS NULL THEN ISNULL(UI.DesignationText,'') ELSE (CASE WHEN CDesig.DisplayCode IS NULL THEN ISNULL(CDesig.CodeName,'') ELSE CDesig.DisplayCode END) END AS rl_grd_50304,--'Designation',
		CASE WHEN UI.GradeId IS NULL THEN ISNULL(UI.GradeText,'') ELSE (CASE WHEN CGrade.DisplayCode IS NULL THEN ISNULL(CGrade.CodeName,'') ELSE CGrade.DisplayCode END) END AS rl_grd_50305,--'Grade',
		CML.CompanyName AS rl_grd_50306,--'Company Name',
		CASE WHEN CML.ISINCode IS NULL OR RTRIM(LTRIM(CML.ISINCode)) = '' THEN @sNotAvailable ELSE CML.ISINCode END AS rl_grd_50307,--'ISIN Code',
		CASE WHEN CML.BSECode IS NULL OR RTRIM(LTRIM(CML.BSECode)) = '' THEN @sNotAvailable ELSE CML.BSECode END AS rl_grd_50308,--'BSE Code',
		CASE WHEN CML.NSECode IS NULL OR RTRIM(LTRIM(CML.NSECode)) = '' THEN @sNotAvailable ELSE CML.NSECode END AS rl_grd_50309,--'NSE Code',
		UPPER(REPLACE(CONVERT(VARCHAR(20), RLSA.CreatedOn, 106), ' ', '/')) AS rl_grd_50310,--'Search Date',
		RIGHT(CONVERT(VARCHAR(50), RLSA.CreatedOn, 100),8) AS rl_grd_50311,--'Search Time',
		CASE RLSA.ResourceKey WHEN @nResourceKeyTradingNotAllowed THEN 'No' ELSE 'Yes' END AS rl_grd_50312,--'Trading Allowed',
		ISNULL(CASE WHEN UI.DateOfBecomingInsider IS NOT NULL 
				THEN @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo)
				ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo) 
				END,'') AS rl_grd_50313,--'Pre Clearance ID',
		ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), PRNIC.CreatedOn, 106), ' ', '/')),'') AS rl_grd_50314,--'Request Date',
		CASE WHEN CTransactionType.DisplayCode IS NULL THEN ISNULL(CTransactionType.CodeName,'') ELSE CTransactionType.DisplayCode END AS rl_grd_50315,--'Transaction Type',
		CASE WHEN CSecurityType.DisplayCode IS NULL THEN ISNULL(CSecurityType.CodeName,'') ELSE CSecurityType.DisplayCode END AS rl_grd_50316,--'Security Type',
		PRNIC.SecuritiesToBeTradedQty AS rl_grd_50317,--'Number of Securities',
		PRNIC.SecuritiesToBeTradedValue AS rl_grd_50318,--'Value',
		CASE WHEN CPRNICStatus.DisplayCode IS NULL THEN ISNULL(CPRNICStatus.CodeName,'') ELSE CPRNICStatus.DisplayCode END AS rl_grd_50319,--'Pre-Clearance Status',
		ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), PRNICEventsTable.PRNICEventDate, 106), ' ', '/')),'') AS rl_grd_50320--'Status Date'
		FROM #tmpList T 
		INNER JOIN rl_SearchAudit RLSA ON T.EntityID = RLSA.RlSearchAuditId
		INNER JOIN usr_UserInfo UI ON RLSA.UserInfoId = UI.UserInfoId
		LEFT OUTER JOIN com_Code CDept ON UI.DepartmentId = CDept.CodeID
		LEFT OUTER JOIN com_Code CDesig ON UI.DesignationId = CDesig.CodeID
		LEFT OUTER JOIN com_Code CGrade ON UI.GradeId = CDesig.CodeID
		LEFT OUTER JOIN rl_CompanyMasterList CML ON RLSA.RlCompanyId = CML.RlCompanyId
		LEFT OUTER JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC ON (RLSA.RlSearchAuditId = PRNIC.RlSearchAuditId) AND (PRNIC.UserInfoId = UI.UserInfoId)
		LEFT OUTER JOIN com_Code CTransactionType ON PRNIC.TransactionTypeCodeId = CTransactionType.CodeID
		LEFT OUTER JOIN com_Code CSecurityType ON PRNIC.SecurityTypeCodeId = CSecurityType.CodeID
		LEFT OUTER JOIN 
		(
			SELECT E.MapToId AS PRNICId, EventCodeId AS PRNICEventCode, E.EventDate AS PRNICEventDate 
			FROM eve_EventLog E
			JOIN (SELECT MAX(EventDate) AS EventDate, MapToTypeCodeId, MapToId FROM eve_EventLog E 
			WHERE MapToTypeCodeId = @nMapToTypePreclearanceNonImplementingCompany 
			AND EventCodeId IN (@nEventPreclearanceRequested,@nEventPreclearanceApproved,@nEventPreclearanceRejected)
			GROUP BY MapToTypeCodeId, MapToId
			) RequestApproveRejectEventDate
			ON E.EventDate = RequestApproveRejectEventDate.EventDate 
			AND E.MapToTypeCodeId = RequestApproveRejectEventDate.MapToTypeCodeId 
			AND E.MapToId = RequestApproveRejectEventDate.MapToId
			AND E.MapToTypeCodeId = @nMapToTypePreclearanceNonImplementingCompany AND E.EventCodeId IN (@nEventPreclearanceRequested,@nEventPreclearanceApproved,@nEventPreclearanceRejected)
			--ORDER BY E.MapToId
		) PRNICEventsTable ON PRNIC.DisplaySequenceNo = PRNICEventsTable.PRNICId
		LEFT OUTER JOIN com_Code CPRNICStatus ON (PRNIC.PreclearanceStatusCodeId = CPRNICStatus.CodeID)
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber


		RETURN 0

	END	 TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY
	END CATCH
	 			
END