
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PreclearanceEmployeeWise')
	DROP PROCEDURE st_rpt_PreclearanceEmployeeWise
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
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Arundhati		04-Sep-2015		Show traded count as 1 for 1 preclearance if one or more transactions are submitted aginst.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
ED				4-Jan-2016		Code integration done on 4-Jan-2016
Gaurishankar	14-Jan-2016		Changes for Mantis Bug id=8475 : 	The user who is updated as Separated but is active as per settings made in "Update Separation" details, is not displayed under any report.
								The user who is seperated but as per "DateOfInactivation" still active in application, should be displayed in all the reports.
Raghvendra		12-Feb-2016		Fix for data truncation error seen for TypeOfInsider field.Increasing the field size fix the issue.
ED			01-Mar-2016		Code merging done on 01-Mar-2016
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PreclearanceEmployeeWise]
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

	DECLARE @nPreclearanceStatus_Confirmed INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003
	  
	CREATE TABLE #tmpPreclearance(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100),
	JoiningDate DATETIME, DateOfInactivation DATETIME, /*CINNumber NVARCHAR(100), */Designation NVARCHAR(512), Grade NVARCHAR(512), Location NVARCHAR(512),
	Department NVARCHAR(512), Category VARCHAR(512), SubCategory VARCHAR(512), StatusCodeId VARCHAR(512), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(512),
	Request INT DEFAULT 0, Approved INT DEFAULT 0, Rejected INT DEFAULT 0, Pending INT DEFAULT 0, Traded INT DEFAULT 0)

	DECLARE @tmpTransactionIds TABLE (TransactionMasterId INT, UserInfoId INT)

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

		print 'st_rpt_InitialDisclosureEmployeeWise'
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'rpt_grd_19191'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'rpt_grd_19191'
		BEGIN
			SET @inp_sSortField = 'EmployeeId'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19192'
		BEGIN
			SET @inp_sSortField = 'InsiderName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19193'
		BEGIN
			SET @inp_sSortField = 'JoiningDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19194'
		BEGIN
			SET @inp_sSortField = 'Designation'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19195'
		BEGIN
			SET @inp_sSortField = 'Grade'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19196'
		BEGIN
			SET @inp_sSortField = 'Location'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19197'
		BEGIN
			SET @inp_sSortField = 'Department'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19198'
		BEGIN
			SET @inp_sSortField = 'CompanyName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19199'
		BEGIN
			SET @inp_sSortField = 'TypeOfInsider'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19201'
		BEGIN
			SET @inp_sSortField = 'Request'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19202'
		BEGIN
			SET @inp_sSortField = 'Approved'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19203'
		BEGIN
			SET @inp_sSortField = 'Rejected'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19204'
		BEGIN
			SET @inp_sSortField = 'Pending'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19205'
		BEGIN
			SET @inp_sSortField = 'Traded'
		END


		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END
		
		INSERT INTO @tmpComments(CodeId, DisplayText)
		SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
		WHERE CodeID BETWEEN 162001 AND 162003

		SELECT @sSQL = 'SELECT UserInfoId FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND (DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < DateOfInactivation) '

		IF ((@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
		  OR (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		  OR (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
		  OR (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
		  OR (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> ''))
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
		END

		print 'Query1 = ' + @sSQL

		INSERT INTO #tmpPreclearance(UserInfoId)
		EXEC (@sSQL)
		
		-- Update user related information
		UPDATE tmpDisc
			SET EmployeeId = UF.EmployeeId,
			DateOfInactivation = UF.DateOfInactivation,
			Category = CCategory.CodeName,
			SubCategory = CSubCategory.CodeName,
			StatusCodeId = CStatusCodeId.CodeName,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			JoiningDate = DateOfBecomingInsider,
			Designation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
			Grade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
			Location = UF.Location,
			Department = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
			CompanyName = C.CompanyName,
			TypeOfInsider = CUserType.CodeName
		FROM #tmpPreclearance tmpDisc JOIN usr_UserInfo UF ON tmpDisc.UserInfoId = UF.UserInfoId
		JOIN mst_Company C ON UF.CompanyId = C.CompanyId
		JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
		LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
		LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
		LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
		LEFT join com_Code CCategory on UF.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UF.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UF.StatusCodeId = CStatusCodeId.CodeID

		-- Update count of Preclearance requests
		UPDATE tmpDisc
		SET Request = t.Request
		FROM #tmpPreclearance tmpDisc
			JOIN (SELECT UserInfoId, count(*) Request FROM tra_PreclearanceRequest GROUP BY UserInfoId) t ON tmpDisc.UserInfoId = t.UserInfoId

		-- Update count of Preclearance requests Approved
		UPDATE tmpDisc
		SET Approved = t.Approved
		FROM #tmpPreclearance tmpDisc
			JOIN (SELECT UserInfoId, count(*) Approved FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId = @nPreclearanceStatus_Approved
					GROUP BY UserInfoId) t ON tmpDisc.UserInfoId = t.UserInfoId

		-- Update count of Preclearance requests Rejected
		UPDATE tmpDisc
		SET Rejected = t.Rejected
		FROM #tmpPreclearance tmpDisc
			JOIN (SELECT UserInfoId, count(*) Rejected FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId = @nPreclearanceStatus_Rejected
					GROUP BY UserInfoId) t ON tmpDisc.UserInfoId = t.UserInfoId
					
		-- Update count of Preclearance requests Pending
		UPDATE tmpDisc
		SET Pending = t.Pending
		FROM #tmpPreclearance tmpDisc
			JOIN (SELECT UserInfoId, count(*) Pending FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId = @nPreclearanceStatus_Confirmed
					GROUP BY UserInfoId) t ON tmpDisc.UserInfoId = t.UserInfoId

		-- Update count of Preclearance requests Traded
		UPDATE tmpDisc
		SET Traded = t.Traded
		FROM #tmpPreclearance tmpDisc
			JOIN (SELECT UserInfoId, COUNT(DISTINCT PreclearanceRequestId) Traded 
					FROM tra_TransactionMaster 
					WHERE PreclearanceRequestId IS NOT NULL
						AND TransactionStatusCodeId > 148002
					GROUP BY UserInfoId) t ON tmpDisc.UserInfoId = t.UserInfoId
		
		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UserInfoId),UserInfoId ' 
		SELECT @sSQL = @sSQL + 'FROM #tmpPreclearance ID '
		
		print @sSQL
		EXEC (@sSQL)

		
		SELECT @sSQL = 'SELECT dbo.uf_rpt_ReplaceSpecialChar(UserInfoId) AS UserInfoId, dbo.uf_rpt_ReplaceSpecialChar(DateOfInactivation) AS DateOfInactivation,dbo.uf_rpt_ReplaceSpecialChar(Category) AS Category,dbo.uf_rpt_ReplaceSpecialChar(SubCategory) AS SubCategory,dbo.uf_rpt_ReplaceSpecialChar(StatusCodeId) AS StatusCodeId,'
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(EmployeeId) AS rpt_grd_19191, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(InsiderName) AS rpt_grd_19192, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(JoiningDate,0)) AS rpt_grd_19193, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Designation),1)) AS rpt_grd_19194, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Grade),1)) AS rpt_grd_19195, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Location),1)) AS rpt_grd_19196, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Department),1)) AS rpt_grd_19197, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(CompanyName) AS rpt_grd_19198, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(TypeOfInsider) AS rpt_grd_19199, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Request) AS rpt_grd_19201, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Approved) AS rpt_grd_19202, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Rejected) AS rpt_grd_19203, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Pending) AS rpt_grd_19204, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Traded) AS rpt_grd_19205 '
		SELECT @sSQL = @sSQL + 'FROM #tmpList t JOIN #tmpPreclearance ID ON t.EntityID = ID.UserInfoId '
		SELECT @sSQL = @sSQL + 'WHERE ID.UserInfoID IS NOT NULL '
		SELECT @sSQL = @sSQL + 'AND ((' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' = 0) '
		SELECT @sSQL = @sSQL + 'OR (T.RowNumber BETWEEN ((' + CONVERT(VARCHAR(10), @inp_iPageNo) + ' - 1) * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' + 1) '
		SELECT @sSQL = @sSQL + 'AND (' + CONVERT(VARCHAR(10), @inp_iPageNo) +  ' * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + '))) '
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
		
		print @sSQL
		EXEC (@sSQL)
		
		--SELECT 'debug1', * FROM #tmpPreclearance ID JOIN com_Code CComment ON ID.CommentId = CComment.CodeID
		--JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
		
		--SELECT ID.CompanyName AS rpt_grd_20001
		--FROM #tmpPreclearance ID
		
		DROP TABLE #tmpPreclearance
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
