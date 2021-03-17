IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityAssociationList_Employee_OS')
DROP PROCEDURE [dbo].[st_rul_ApplicabilityAssociationList_Employee_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Applicability association list for applicability allocation - Employee (grid type 114133).

Returns:		0, if Success.
				
Created by:		Rajashri

Usage:
EXEC st_rul_ApplicabilityAssociationList_Employee_OS 10, 1, 'EmployeeId','ASC', 132001, 2,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_ApplicabilityAssociationList_Employee_OS]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)
	,@inp_nGridTypeCodeId					INT		-- 114133 for Employee Insider , 114091 for Employee non insider.
	,@inp_nMapToTypeCodeId					INT			/*Map to type code : 132001=Policy Document, 132002=Trading Policy in case of Applicability*/
	,@inp_nMapToId							INT			/*This will be Id of the object identified by @inp_nMapToTypeCodeId*/
	,@inp_nCallingModuleCodeId				INT	= 103006/*This refers to the module from which the procedure is called : Set Rules-->103006 OR Transactions-->*/
	,@inp_sEmployeeId						NVARCHAR(50) = '' /*This will be sent from CO-->Transaction-->Disclosures-->Transactions and will be NULL/ empty otherwise*/
	,@inp_sEmployeeName						NVARCHAR(255) = ''/*This will be sent from CO-->Transaction-->Disclosures-->Transactions and will be NULL/ empty otherwise*/
	,@inp_nApplicabilityId                  INT = 0 --This will be sent from History page of restricted list otherwise it is 0
	,@out_nReturnValue						INT = 0 OUTPUT
	,@out_nSQLErrCode						INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @sCallingModuleFilter NVARCHAR(3072) = ''
	DECLARE @ERR_APPLICABILITY_ASSOCIATION_LIST_EMPLOYEE INT = 15129 -- Error occurred while fetching list of Employees for applicability allocation.
	DECLARE @nActiveUserStatusCodeId INT = 102001
	DECLARE @nInactiveUserStatusCodeId INT = 102002
	
	DECLARE	@nSetRulesModuleCodeId	INT	= 103006 /*CodeID from com_Code where CodeName - Rules and CodeGroupId=103(Resource modules)*/
	DECLARE @nUserTypeEmployeeCodeId	INT = 101003	--Code for UserType Employee
	DECLARE @nIncludeCodeId	INT = 150001	--150001 : IncludeEmployee, 150002: ExcludeEmployee
	DECLARE @nExcludeCodeId	INT = 150002	--150001 : IncludeEmployee, 150002: ExcludeEmployee
	
	DECLARE @nAppMaxVersionNumber	INT = 0
	
	--select * from mst_Resource where ResourceKey in( 'usr_grd_11228','rul_grd_55330','rul_grd_55331','rul_grd_55332','rul_grd_55333','rul_grd_55334')


	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		--Set default value for calling module
		IF(@inp_nCallingModuleCodeId IS NULL OR @inp_nCallingModuleCodeId <=0)
		BEGIN
			SET @inp_nCallingModuleCodeId = @nSetRulesModuleCodeId
		END			

		IF(@inp_nApplicabilityId! = 0)
		BEGIN
			--Fetch the version number according to applicabilityId of applicabilityMaster to show history
			Select @nAppMaxVersionNumber = VersionNumber from rul_ApplicabilityMaster_OS where ApplicabilityId= @inp_nApplicabilityId
		END
		ELSE
		BEGIN
			--Fetch the maximum version number for the applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId
			SELECT @nAppMaxVersionNumber =  ISNULL(MAX(VersionNumber), 0) FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId
		END
			
		/*Fetch employees which have applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId and which match input search criteria (if any)*/	
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
		
		IF @inp_sSortField = 'rul_grd_55330' -- Employee Name
		BEGIN 
			SELECT @inp_sSortField = '(ISNULL(UI.FirstName, '''') + '' '' + ISNULL(UI.LastName, '''')) ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55331' -- EmployeeId
		BEGIN 
			SELECT @inp_sSortField = 'UI.EmployeeId ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55332' -- Department
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '''' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END ' --CdUIDepartment.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_55333' -- Grade
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '''' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END ' --CdUIGrade.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_55334' -- Designation
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '''' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END ' --CdUIDesignation.CodeName
		END
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UI.UserInfoId), UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' FROM ( '
		
		SELECT @sSQL = @sSQL + ' SELECT UserInfoId, SUM(ExcludeIndicator) AS ExcludeIndicator '
		SELECT @sSQL = @sSQL + ' FROM ( '
		/**/
		IF (@inp_nGridTypeCodeId = 114133 )
		BEGIN 
			SELECT @sSQL = @sSQL + ' SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
									 AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 0 AS ExcludeIndicator '
			SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI 
									 JOIN usr_UserRole UROL ON UI.UserInfoID = UROL.UserInfoID '
			SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityDetails_OS AD ON UI.UserTypeCodeId = AD.InsiderTypeCodeId '
			SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.ApplicabilityId = AD.ApplicabilityMstId '
			
			--Add the calling module based join conditions
			SELECT @sCallingModuleFilter = ''
			IF(@inp_nCallingModuleCodeId <> @nSetRulesModuleCodeId)
			BEGIN
				--TODO: HERE ADD THE JOIN CONDITION TO CHECK WHETHER THE EMPLOYEE FOR WHOM APPLICABILITY IS ASSOCIATED HAS ACTUALLY VIEWED / VIEWED-AGREED TO DOCUMENT
				SELECT @sCallingModuleFilter = @sCallingModuleFilter + ''
			END
			SELECT @sSQL = @sSQL + @sCallingModuleFilter

			SELECT @sSQL = @sSQL + ' WHERE 1=1 '
			SELECT @sSQL = @sSQL + ' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR)
			SELECT @sSQL = @sSQL + ' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 '
			--SELECT @sSQL = @sSQL + ' AND UI.IsInsider = 1 '
			SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()'
			
			SELECT @sSQL = @sSQL + ' AND ((UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) OR (UI.DateOfSeparation IS NOT NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)) '
			SELECT @sSQL = @sSQL + ' AND ((CONVERT(date,dbo.uf_com_GetServerDate()) <= CONVERT(date,UI.DateOfInactivation)) OR UI.DateOfInactivation IS NULL)'
			SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) /*Fetch employee users only*/
			SELECT @sSQL = @sSQL + ' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20))  /*Fetch only Active employees*/
			SELECT @sSQL = @sSQL + ' AND (AD.DepartmentCodeId IS NULL OR AD.DepartmentCodeId = UI.DepartmentId) '
			SELECT @sSQL = @sSQL + ' AND (AD.Category IS NULL OR AD.Category = UI.Category) '
			SELECT @sSQL = @sSQL + ' AND (AD.SubCategory IS NULL OR AD.SubCategory = UI.SubCategory) '
			SELECT @sSQL = @sSQL + ' AND (AD.RoleID IS NULL OR AD.RoleID = UROL.RoleID) '
			SELECT @sSQL = @sSQL + ' AND (AD.GradeCodeId IS NULL OR AD.GradeCodeId = UI.GradeId) 
									AND AD.NonInsFltrDepartmentCodeId IS NULL AND AD.NonInsFltrGradeCodeId IS NULL
									AND AD.NonInsFltrDesignationCodeId IS NULL AND AD.NonInsFltrCategory IS NULL AND AD.NonInsFltrSubCategory IS NULL 
									AND AD.NonInsFltrRoleID IS NULL '
			SELECT @sSQL = @sSQL + ' AND (AD.DesignationCodeId IS NULL OR AD.DesignationCodeId = UI.DesignationId) '
			SELECT @sSQL = @sSQL + ' AND (AD.UserId IS NULL OR (AD.UserId = UI.UserInfoId AND AD.IncludeExcludeCodeId = ' + CAST(@nIncludeCodeId AS VARCHAR) + ') ) '
			SELECT @sSQL = @sSQL + ' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) 
			SELECT @sSQL = @sSQL + ' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR)
			SELECT @sSQL = @sSQL + ' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 
		END 
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + ' SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
									 AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 0 AS ExcludeIndicator '
			SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI '
			SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityDetails_OS AD ON UI.UserTypeCodeId = AD.InsiderTypeCodeId '
			SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.ApplicabilityId = AD.ApplicabilityMstId '
			SELECT @sSQL = @sSQL + ' INNER JOIN usr_UserRole UR ON UI.UserInfoId = UR.UserInfoID '
			
			--Add the calling module based join conditions
			SELECT @sCallingModuleFilter = ''
			IF(@inp_nCallingModuleCodeId <> @nSetRulesModuleCodeId)
			BEGIN
				--TODO: HERE ADD THE JOIN CONDITION TO CHECK WHETHER THE EMPLOYEE FOR WHOM APPLICABILITY IS ASSOCIATED HAS ACTUALLY VIEWED / VIEWED-AGREED TO DOCUMENT
				SELECT @sCallingModuleFilter = @sCallingModuleFilter + ''
			END
			SELECT @sSQL = @sSQL + @sCallingModuleFilter

			SELECT @sSQL = @sSQL + ' WHERE 1=1 '
			SELECT @sSQL = @sSQL + ' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR)
			SELECT @sSQL = @sSQL + ' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 '
			--SELECT @sSQL = @sSQL + ' AND UI.IsInsider = 1 '
			SELECT @sSQL = @sSQL + ' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) '
			
			SELECT @sSQL = @sSQL + ' AND ((UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) OR (UI.DateOfSeparation IS NOT NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)) '
			SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) /*Fetch employee users only*/
			SELECT @sSQL = @sSQL + ' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20))  /*Fetch only Active employees*/
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrDepartmentCodeId IS NULL OR AD.NonInsFltrDepartmentCodeId = UI.DepartmentId) '
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrGradeCodeId IS NULL OR AD.NonInsFltrGradeCodeId = UI.GradeId) '
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrDesignationCodeId IS NULL OR AD.NonInsFltrDesignationCodeId = UI.DesignationId) '
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrCategory IS NULL OR AD.NonInsFltrCategory = UI.Category) '
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrSubCategory IS NULL OR AD.NonInsFltrSubCategory = UI.SubCategory) '
			SELECT @sSQL = @sSQL + ' AND (AD.NonInsFltrRoleId IS NULL OR AD.NonInsFltrRoleId = UR.RoleId) 
									AND AD.DepartmentCodeId IS NULL AND AD.GradeCodeId IS NULL
									AND AD.DesignationCodeId IS NULL AND AD.Category IS NULL 
									AND AD.SubCategory IS NULL AND AD.RoleID IS NULL  '			
			SELECT @sSQL = @sSQL + ' AND (AD.UserId IS NULL OR (AD.UserId = UI.UserInfoId AND AD.IncludeExcludeCodeId = ' + CAST(@nIncludeCodeId AS VARCHAR) + ') ) '
			SELECT @sSQL = @sSQL + ' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) 
			SELECT @sSQL = @sSQL + ' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR)
			SELECT @sSQL = @sSQL + ' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 
		
		END 
		
		/**/
		SELECT @sSQL = @sSQL + ' UNION '
		
		--Include the excluded employee IDs with ExcludeIndicator as 1
		SELECT @sSQL = @sSQL + ' SELECT UI.UserInfoId, UI.DepartmentId, UI.GradeId, UI.DesignationId, 
								 AD.UserId, AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.IncludeExcludeCodeId, 1 AS ExcludeIndicator '
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI '
		SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityDetails_OS AD ON UI.UserInfoId = AD.UserId '
		SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.ApplicabilityId = AD.ApplicabilityMstId '
		
		--Add the calling module based join conditions
		SELECT @sCallingModuleFilter = ''
		IF(@inp_nCallingModuleCodeId <> @nSetRulesModuleCodeId)
		BEGIN
			--TODO: HERE ADD THE JOIN CONDITION TO CHECK WHETHER THE EMPLOYEE FOR WHOM APPLICABILITY IS ASSOCIATED HAS ACTUALLY VIEWED / VIEWED-AGREED TO DOCUMENT
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ''
		END
		SELECT @sSQL = @sSQL + @sCallingModuleFilter
		
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '
		SELECT @sSQL = @sSQL + ' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR) 
		SELECT @sSQL = @sSQL + ' AND AD.AllEmployeeFlag = 0 AND AllInsiderFlag = 0 AND AllEmployeeInsiderFlag = 0 '
		--SELECT @sSQL = @sSQL + ' AND UI.IsInsider = 1 '
		IF (@inp_nGridTypeCodeId = 114133 )
		BEGIN 
			SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()'
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) '
		END
		SELECT @sSQL = @sSQL + ' AND ((UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) OR (UI.DateOfSeparation IS NOT NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation))'
		SELECT @sSQL = @sSQL + ' AND ((CONVERT(date,dbo.uf_com_GetServerDate()) <= CONVERT(date,UI.DateOfInactivation)) OR UI.DateOfInactivation IS NULL )'
		SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeEmployeeCodeId AS VARCHAR)  
		SELECT @sSQL = @sSQL + ' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20))   
		SELECT @sSQL = @sSQL + ' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR) 
		SELECT @sSQL = @sSQL + ' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR)
		SELECT @sSQL = @sSQL + ' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 
		SELECT @sSQL = @sSQL + ' AND AD.IncludeExcludeCodeId = ' + CAST(@nExcludeCodeId AS VARCHAR)

		SELECT @sSQL = @sSQL + ' ) INCLUDED_EXCLUDED_APPLICABILITY '
		SELECT @sSQL = @sSQL + ' GROUP BY UserInfoId '
		
		SELECT @sSQL = @sSQL + ' ) ONLY_INCLUDED_APPLICABILITY '
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_UserInfo UI ON ONLY_INCLUDED_APPLICABILITY.UserInfoId = UI.UserInfoId ' 
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIDepartment ON UI.DepartmentId = CdUIDepartment.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIGrade ON UI.GradeId = CdUIGrade.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdUIDesignation ON UI.DesignationId = CdUIDesignation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE ExcludeIndicator = 0 '
		IF (@inp_nGridTypeCodeId = 114133 )
		BEGIN 
			SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()'
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UI.DateOfBecomingInsider IS NULL OR UI.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) '
		END
		SELECT @sSQL = @sSQL + ' AND ((UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) OR (UI.DateOfSeparation IS NOT NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)) '
		
		
		
		
		SELECT @sCallingModuleFilter = ''
		--EmployeeId filtering for CO-->Transaction-->Disclosures-->Transactions
		IF(@inp_nCallingModuleCodeId <> @nSetRulesModuleCodeId AND @inp_sEmployeeId IS NOT NULL AND @inp_sEmployeeId <> '')
		BEGIN
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' AND UI.EmployeeId LIKE N''%' + @inp_sEmployeeId + '%'' '
		END

		--Employeename filter for CO-->Transaction-->Disclosures-->Transactions
		IF (@inp_nCallingModuleCodeId <> @nSetRulesModuleCodeId AND @inp_sEmployeeName IS NOT NULL AND @inp_sEmployeeName <> '')	
		BEGIN
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' AND ('
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' UI.FirstName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' OR UI.MiddleName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' OR UI.LastName LIKE N''%' + @inp_sEmployeeName + '%'' '
			SELECT @sCallingModuleFilter = @sCallingModuleFilter + ' ) '
		END
		--Append @sCallingModuleFilter to SELECT query to get direct applicability association employee
		SELECT @sSQL = @sSQL + @sCallingModuleFilter
		
		--print @sCallingModuleFilter
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	UI.UserInfoId AS UserInfoId, 
		(UI.FirstName + ' ' + UI.LastName) AS rul_grd_55330 /*EmployeeName*/,
		UI.EmployeeId AS rul_grd_55331 /*EmployeeId*/,
		CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END AS rul_grd_55332 /*Department*/,
		CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END AS rul_grd_55333 /*Grade*/,
		CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END AS rul_grd_55334 /*Designation*/
		FROM	#tmpList T INNER JOIN usr_UserInfo UI ON T.EntityID = UI.UserInfoId
				LEFT JOIN com_Code CdUIDepartment ON UI.DepartmentId = CdUIDepartment.CodeID
				LEFT JOIN com_Code CdUIGrade ON UI.GradeId = CdUIGrade.CodeID
				LEFT JOIN com_Code CdUIDesignation ON UI.DesignationId = CdUIDesignation.CodeID 
		WHERE	1=1 
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
		
	END TRY
		
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_APPLICABILITY_ASSOCIATION_LIST_EMPLOYEE
	END CATCH
	
END
