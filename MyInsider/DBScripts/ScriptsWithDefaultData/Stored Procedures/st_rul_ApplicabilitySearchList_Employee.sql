IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilitySearchList_Employee')
DROP PROCEDURE [dbo].[st_rul_ApplicabilitySearchList_Employee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Applicability search list for applicability allocation - Employee .

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		30-Mar-2015

Modification History:
Modified By		Modified On		Description
Ashashree		12-Apr-2015		Modifying query to fetch the employee users for whom applicability is not associated
Gaurishankar	08-Apr-2016		Changes for AllCo, AllCorporateInsider, AllNonEmployeeInsider and Non Insider Employee Applicability.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
								Added new filter Category, SubCategory & Role for applicability.
Usage:
EXEC st_rul_ApplicabilitySearchList_Employee 10, 1, 'EmployeeId','ASC', 132001, 2,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_ApplicabilitySearchList_Employee]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_nGridTypeCodeId	INT		-- 114023 for Employee Insider , 114089 for Employee non insider.
	,@inp_nMapToTypeCodeId	INT			/*Map to type code : 132001=Policy Document, 132002=Trading Policy in case of Applicability*/
	,@inp_nMapToId			INT			/*This will be Id of the object identified by @inp_nMapToTypeCodeId*/
	,@inp_sDepartmentIds	VARCHAR(255)
	,@inp_sGradeIds			VARCHAR(255)
	,@inp_sDesignationIds	VARCHAR(255)
	,@inp_sEmployeeId		NVARCHAR(50)
	,@inp_sEmployeeName		NVARCHAR(255)
	,@inp_sCategoryIds		VARCHAR(255)
	,@inp_sSubCategoryIds	VARCHAR(255)
	,@inp_sRoleIds			VARCHAR(255)
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_APPLICABILITYSEARCH_LIST_EMPLOYEE INT = 15051 -- Error occurred while fetching list of Employees for applicability allocation.
	DECLARE @nActiveUserStatusCodeId INT = 102001
	DECLARE @nInactiveUserStatusCodeId INT = 102002
	DECLARE @nUserTypeEmployeeCodeId	INT = 101003	--Code for UserType Employee
	DECLARE @nIncludeCodeId	INT = 150001	--150001 : IncludeEmployee, 150002: ExcludeEmployee
	DECLARE @nExcludeCodeId	INT = 150002	--150001 : IncludeEmployee, 150002: ExcludeEmployee
	
	DECLARE @nAppMaxVersionNumber	INT = 0

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Fetch the maximum version number for the applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId
		SELECT @nAppMaxVersionNumber =  ISNULL(MAX(VersionNumber), 0) FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId

		/*Search employees which are matching the input search criteria*/	
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		--Set default sort order
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		--Set default sort field
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UI.EmployeeId '
		END
		
		IF @inp_sSortField = 'rul_grd_15046' -- Employee Name
		BEGIN 
			SELECT @inp_sSortField = '(ISNULL(UI.FirstName, '''') + '' '' + ISNULL(UI.LastName, '''')) ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15047' -- EmployeeId
		BEGIN 
			SELECT @inp_sSortField = 'UI.EmployeeId ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15048' -- Department
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '''' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END ' --CdUIDepartment.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_15049' -- Grade
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '''' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END ' --CdUIGrade.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_15050' -- Designation
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '''' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END ' --CdUIDesignation.CodeName
		END
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UI.UserInfoId),UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIDepartment ON UI.DepartmentId = CdUIDepartment.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIGrade ON UI.GradeId = CdUIGrade.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIDesignation ON UI.DesignationId = CdUIDesignation.CodeID '		
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_UserRole UR ON UI.UserInfoID = UR.UserInfoID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN ( 
											SELECT ONLY_INCLUDED_APPLICABILITY.UserInfoId, ONLY_INCLUDED_APPLICABILITY.ExcludeIndicator
											FROM (  
													SELECT UserInfoId, SUM(ExcludeIndicator) AS ExcludeIndicator  
													FROM (  '
		IF (@inp_nGridTypeCodeId = 114023 )
		BEGIN 
		SELECT @sSQL = @sSQL + 								 ' SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
															  AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 0 AS ExcludeIndicator  
															  FROM usr_UserInfo UI  
															  INNER JOIN rul_ApplicabilityDetails AD ON UI.UserTypeCodeId = AD.InsiderTypeCodeId AND UI.UserInfoId = AD.UserId 
															  INNER JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = AD.ApplicabilityMstId  
															  WHERE 1=1 ' +
															' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) +
															' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 ' +
															--' AND UI.IsInsider = 1  ' +
															' AND UI.DateOfBecomingInsider IS NOT NULL AND  UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()' +
															' AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) ' +
															' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) +
															' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20)) +
															' AND (AD.DepartmentCodeId IS NULL OR AD.DepartmentCodeId = UI.DepartmentId)  
															  AND (AD.GradeCodeId IS NULL OR AD.GradeCodeId = UI.GradeId) 
															  AND (AD.DesignationCodeId IS NULL OR AD.DesignationCodeId = UI.DesignationId) 
															  AND AD.NonInsFltrDepartmentCodeId IS NULL AND AD.NonInsFltrGradeCodeId IS NULL
															  AND AD.NonInsFltrDesignationCodeId IS NULL AND AD.NonInsFltrCategory IS NULL 
															  AND AD.NonInsFltrSubCategory IS NULL AND AD.NonInsFltrRoleID IS NULL  ' +
															' AND (AD.UserId IS NULL OR (AD.UserId = UI.UserInfoId AND AD.IncludeExcludeCodeId = ' + CAST(@nIncludeCodeId AS VARCHAR) + ') ) ' +
															' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) +
															' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR) +
															' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 
		END
		ELSE
		BEGIN
		SELECT @sSQL = @sSQL + 								 ' SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
															  AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 0 AS ExcludeIndicator  
															  FROM usr_UserInfo UI  
															  INNER JOIN rul_ApplicabilityDetails AD ON UI.UserTypeCodeId = AD.InsiderTypeCodeId  
															  INNER JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = AD.ApplicabilityMstId  
															  INNER JOIN usr_UserRole UR ON UI.UserInfoId = UR.UserInfoID 
															  WHERE 1=1 ' +
															' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) +
															' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 ' +
															--' AND UI.IsInsider = 1  ' +
		
															' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) ' +
															' AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) ' +
															' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) +
															' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20)) +
															' AND (AD.NonInsFltrDepartmentCodeId IS NULL OR AD.NonInsFltrDepartmentCodeId = UI.DepartmentId)  
															  AND (AD.NonInsFltrGradeCodeId IS NULL OR AD.NonInsFltrGradeCodeId = UI.GradeId) 
															  AND (AD.NonInsFltrDesignationCodeId IS NULL OR AD.NonInsFltrDesignationCodeId = UI.DesignationId) 
															  AND (AD.NonInsFltrCategory IS NULL OR AD.NonInsFltrCategory = UI.Category) 
															  AND (AD.NonInsFltrSubCategory IS NULL OR AD.NonInsFltrSubCategory = UI.SubCategory)
															  AND (AD.NonInsFltrRoleId IS NULL OR AD.NonInsFltrRoleId = UR.RoleId) 
															  AND AD.DepartmentCodeId IS NULL AND AD.GradeCodeId IS NULL
															  AND AD.DesignationCodeId IS NULL AND AD.Category IS NULL 
															  AND AD.SubCategory IS NULL AND AD.RoleID IS NULL' +
															' AND (AD.UserId IS NULL OR (AD.UserId = UI.UserInfoId AND AD.IncludeExcludeCodeId = ' + CAST(@nIncludeCodeId AS VARCHAR) + ') ) ' +
															' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) +
															' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR) +
															' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 
		END
		
		SELECT @sSQL = @sSQL + 								' UNION  
															
															  SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
															  AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 1 AS ExcludeIndicator  
															  FROM usr_UserInfo UI  
															  INNER JOIN rul_ApplicabilityDetails AD ON UI.UserInfoId = AD.UserId  
															  INNER JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = AD.ApplicabilityMstId  
															  WHERE 1=1 ' +
															' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) + 
															' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 ' 
															--' AND UI.IsInsider = 1 ' +
		IF (@inp_nGridTypeCodeId = 114023 )
		BEGIN 
			SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL AND  UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()'
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) '
		END
															SELECT @sSQL = @sSQL + ' AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) ' +
															' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) +
															' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20)) + 
															' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) +
															' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR) +
															' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) +
															' AND AD.IncludeExcludeCodeId = ' + CAST(@nExcludeCodeId AS VARCHAR) +
														
														' ) INCLUDED_EXCLUDED_APPLICABILITY  
														 GROUP BY UserInfoId  
												
												) ONLY_INCLUDED_APPLICABILITY  
												WHERE ExcludeIndicator = 0  
										) FINAL_APPLICABILITY_DETAILS 
										ON UI.UserInfoId = FINAL_APPLICABILITY_DETAILS.UserInfoId '

		SELECT @sSQL = @sSQL + ' WHERE 1=1 ' 
		SELECT @sSQL = @sSQL + ' AND FINAL_APPLICABILITY_DETAILS.UserInfoId IS NULL '
		SELECT @sSQL = @sSQL + ' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20)) + ' '  /*Fetch only Active employees*/
		--SELECT @sSQL = @sSQL + ' AND UI.IsInsider = 1 '
		IF (@inp_nGridTypeCodeId = 114023 )
		BEGIN 
			SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL AND  UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()'
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) '
		END
		SELECT @sSQL = @sSQL + ' AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) '
		SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR)

		--Department filter
		IF (@inp_sDepartmentIds IS NOT NULL AND @inp_sDepartmentIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.DepartmentId IN (' + @inp_sDepartmentIds + ') '
		END

		--Grade filter
		IF (@inp_sGradeIds IS NOT NULL AND @inp_sGradeIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.GradeId IN (' + @inp_sGradeIds + ') '
		END

		--Designation filter
		IF (@inp_sDesignationIds IS NOT NULL AND @inp_sDesignationIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.DesignationId IN (' + @inp_sDesignationIds + ') '
		END
		
		IF (@inp_sCategoryIds IS NOT NULL AND @inp_sCategoryIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.Category IN (' + @inp_sCategoryIds + ') '
		END
		IF (@inp_sSubCategoryIds IS NOT NULL AND @inp_sSubCategoryIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.SubCategory IN (' + @inp_sSubCategoryIds + ') '
		END
		IF (@inp_sRoleIds IS NOT NULL AND @inp_sRoleIds <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UR.RoleID IN (' + @inp_sRoleIds + ') '
		END
		--EmployeeID filter
		IF (@inp_sEmployeeId IS NOT NULL AND @inp_sEmployeeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.EmployeeId LIKE N''%' + @inp_sEmployeeId + '%'' '
		END
		
		--Employeename filter
		IF (@inp_sEmployeeName IS NOT NULL AND @inp_sEmployeeName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ('
			SELECT @sSQL = @sSQL + ' UI.FirstName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sSQL = @sSQL + ' OR UI.MiddleName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sSQL = @sSQL + ' OR UI.LastName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sSQL = @sSQL + ' ) '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		IF (@inp_nGridTypeCodeId = 114023 )
		BEGIN 
			SELECT	UI.UserInfoId AS UserInfoId, 
			(UI.FirstName + ' ' + UI.LastName) AS rul_grd_15046 /*EmployeeName*/,
			UI.EmployeeId AS rul_grd_15047 /*EmployeeId*/,
			CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END AS rul_grd_15048 /*Department*/,
			CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END AS rul_grd_15049 /*Grade*/,
			CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END AS rul_grd_15050, /*Designation*/
			ISNULL((CASE WHEN CdUICategory.DisplayCode IS NULL OR CdUICategory.DisplayCode = '' THEN CdUICategory.CodeName ELSE CdUICategory.DisplayCode END ),'') AS rul_grd_15448,--Category
			ISNULL((CASE WHEN CdUISubCategory.DisplayCode IS NULL OR CdUISubCategory.DisplayCode = '' THEN CdUISubCategory.CodeName ELSE CdUISubCategory.DisplayCode END ),'') AS rul_grd_15449,--Sub Category
			UR.RoleName AS rul_grd_15450, -- Role
			EXCLUDED_EMPLOYEES.IncludeExcludeCodeId
			FROM	#tmpList T INNER JOIN usr_UserInfo UI ON T.EntityID = UI.UserInfoId
					LEFT JOIN com_Code CdUIDepartment ON UI.DepartmentId = CdUIDepartment.CodeID
					LEFT JOIN com_Code CdUIGrade ON UI.GradeId = CdUIGrade.CodeID
					LEFT JOIN com_Code CdUIDesignation ON UI.DesignationId = CdUIDesignation.CodeID 
					
					LEFT JOIN 
					(
					  SELECT UI.UserInfoId AS UserInfoId, AD.IncludeExcludeCodeId AS IncludeExcludeCodeId
					  FROM usr_UserInfo UI  
					  INNER JOIN rul_ApplicabilityDetails AD ON UI.UserInfoId = AD.UserId  
					  INNER JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = AD.ApplicabilityMstId  
					  WHERE 1=1  
					  AND AD.InsiderTypeCodeId = @nUserTypeEmployeeCodeId 
					  AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0  
					  --AND UI.IsInsider = 1  
					  AND UI.DateOfBecomingInsider IS NOT NULL AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()
					  AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)
					  AND UI.UserTypeCodeId = @nUserTypeEmployeeCodeId 
					  AND UI.StatusCodeId = @nActiveUserStatusCodeId 
					  AND AM.MapToTypeCodeId = @inp_nMapToTypeCodeId 
					  AND AM.MapToId = @inp_nMapToId 
					  AND AM.VersionNumber = @nAppMaxVersionNumber 
					  AND AD.IncludeExcludeCodeId = @nExcludeCodeId 
					) EXCLUDED_EMPLOYEES
					ON UI.UserInfoId = EXCLUDED_EMPLOYEES.UserInfoId
					LEFT JOIN com_Code CdUICategory ON UI.Category = CdUICategory.CodeID 
					LEFT JOIN com_Code CdUISubCategory ON UI.SubCategory = CdUISubCategory.CodeID 
					LEFT JOIN vw_UserRoleNames UR ON UI.UserInfoId = UR.UserInfoID
			WHERE	1=1 
			AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END
		ELSE  
		BEGIN
			SELECT	UI.UserInfoId AS UserInfoId, 
			(UI.FirstName + ' ' + UI.LastName) AS rul_grd_15046 /*EmployeeName*/,
			UI.EmployeeId AS rul_grd_15047 /*EmployeeId*/,
			CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END AS rul_grd_15048 /*Department*/,
			CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END AS rul_grd_15049 /*Grade*/,
			CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END AS rul_grd_15050, /*Designation*/
			ISNULL((CASE WHEN CdUICategory.DisplayCode IS NULL OR CdUICategory.DisplayCode = '' THEN CdUICategory.CodeName ELSE CdUICategory.DisplayCode END ),'') AS rul_grd_15448,--Category
			ISNULL((CASE WHEN CdUISubCategory.DisplayCode IS NULL OR CdUISubCategory.DisplayCode = '' THEN CdUISubCategory.CodeName ELSE CdUISubCategory.DisplayCode END ),'') AS rul_grd_15449,--Sub Category
			UR.RoleName AS rul_grd_15450, -- Role
			EXCLUDED_EMPLOYEES.IncludeExcludeCodeId
			FROM	#tmpList T INNER JOIN usr_UserInfo UI ON T.EntityID = UI.UserInfoId
					LEFT JOIN com_Code CdUIDepartment ON UI.DepartmentId = CdUIDepartment.CodeID
					LEFT JOIN com_Code CdUIGrade ON UI.GradeId = CdUIGrade.CodeID
					LEFT JOIN com_Code CdUIDesignation ON UI.DesignationId = CdUIDesignation.CodeID 
					
					LEFT JOIN 
					(
					  SELECT UI.UserInfoId AS UserInfoId, AD.IncludeExcludeCodeId AS IncludeExcludeCodeId
					  FROM usr_UserInfo UI  
					  INNER JOIN rul_ApplicabilityDetails AD ON UI.UserInfoId = AD.UserId  
					  INNER JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = AD.ApplicabilityMstId  
					  WHERE 1=1  
					  AND AD.InsiderTypeCodeId = @nUserTypeEmployeeCodeId 
					  AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0  
					  --AND UI.IsInsider = 1  
					  AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate())
					  AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)
					  AND UI.UserTypeCodeId = @nUserTypeEmployeeCodeId 
					  AND UI.StatusCodeId = @nActiveUserStatusCodeId 
					  AND AM.MapToTypeCodeId = @inp_nMapToTypeCodeId 
					  AND AM.MapToId = @inp_nMapToId 
					  AND AM.VersionNumber = @nAppMaxVersionNumber 
					  AND AD.IncludeExcludeCodeId = @nExcludeCodeId 
					) EXCLUDED_EMPLOYEES
					ON UI.UserInfoId = EXCLUDED_EMPLOYEES.UserInfoId
					LEFT JOIN com_Code CdUICategory ON UI.Category = CdUICategory.CodeID 
					LEFT JOIN com_Code CdUISubCategory ON UI.SubCategory = CdUISubCategory.CodeID 
					LEFT JOIN vw_UserRoleNames UR ON UI.UserInfoId = UR.UserInfoID
			WHERE	1=1 
			AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END
		RETURN 0
		
	END TRY
		
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_APPLICABILITYSEARCH_LIST_EMPLOYEE
	END CATCH
END
