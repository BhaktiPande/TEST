IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityFilterList_Employee_OS')
DROP PROCEDURE [dbo].[st_rul_ApplicabilityFilterList_Employee_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Applicability association filter sets used during applicability allocation -Employee (grid type 114139).

Returns:		0, if Success.
				
Created by:		Rajashri
Created on:		25-Feb-2020

EXEC st_rul_ApplicabilityFilterList_Employee_OS 10, 1, '','ASC', 132001, 2,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_ApplicabilityFilterList_Employee_OS]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_nGridTypeCodeId	INT		-- 114139 for Employee Insider , 114090 for Employee non insider.
	,@inp_nMapToTypeCodeId	INT			/*Map to type code : 132001=Policy Document, 132022=Trading Policy in case of Applicability*/
	,@inp_nMapToId			INT			/*This will be Id of the object identified by @inp_nMapToTypeCodeId*/
	,@inp_nApplicabilityId  INT = 0 --This will be sent from History page of restricted list otherwise it is 0
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_APPLICABILITY_FILTER_LIST_EMPLOYEE INT = 15342 -- Error occurred while fetching list of filter sets used during applicability association.
	DECLARE @nAppMaxVersionNumber	INT = 0
	DECLARE	@nUserTypeEmployeeCodeId INT = 101003	--Code for UserType Corporate

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF(@inp_nApplicabilityId! = 0)
		BEGIN
			--Fetch the version number according to applicabilityId of applicabilityMaster to show history
			Select @nAppMaxVersionNumber = VersionNumber from rul_ApplicabilityMaster_OS where ApplicabilityId= @inp_nApplicabilityId
		END
		ELSE
		BEGIN
			--Fetch the maximum version number for the applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId
			SELECT @nAppMaxVersionNumber =  ISNULL(MAX(VersionNumber), 0) FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId
			print @nAppMaxVersionNumber
		END
		
		IF (@inp_nGridTypeCodeId = 114139 )
		BEGIN 
			SELECT 
			ApplicabilityDtlsId, 
		    --CdUIDepartment.CodeName,CdUIGrade.CodeName, CdUIDesignation.CodeName,
			  ISNULL((CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END),'') AS rul_grd_55363,--DepartmentName,
			  ISNULL((CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END),'') AS rul_grd_55362,--GradeName,
			  ISNULL((CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END ),'') AS rul_grd_55361,--DesignationName,
			  		  
			  ISNULL(AD.DepartmentCodeId, 0) AS DepartmentId, ISNULL(AD.GradeCodeId, 0) AS GradeId, ISNULL(AD.DesignationCodeId, 0) AS DesignationId,
			  ISNULL((CASE WHEN CdUICategory.DisplayCode IS NULL OR CdUICategory.DisplayCode = '' THEN CdUICategory.CodeName ELSE CdUICategory.DisplayCode END ),'') AS rul_grd_55359,--Category
			  ISNULL((CASE WHEN CdUISubCategory.DisplayCode IS NULL OR CdUISubCategory.DisplayCode = '' THEN CdUISubCategory.CodeName ELSE CdUISubCategory.DisplayCode END ),'') AS rul_grd_55358,--Sub Category
			  UR.RoleName AS rul_grd_55357, -- Role	
			  ISNULL(AD.Category, 0) AS CategoryId, ISNULL(AD.SubCategory, 0) AS SubCategoryId, ISNULL(AD.RoleId, 0) AS RoleId
			  FROM rul_ApplicabilityDetails_OS AD 
			  INNER JOIN rul_ApplicabilityMaster_OS AM ON AD.ApplicabilityMstId = AM.ApplicabilityId
			  --INNER JOIN usr_UserInfo UF ON AD.UserId = UF.UserInfoID
			  LEFT JOIN com_Code CdUIDepartment ON AD.DepartmentCodeId = CdUIDepartment.CodeID
			  LEFT JOIN com_Code CdUIGrade ON AD.GradeCodeId = CdUIGrade.CodeID
			  LEFT JOIN com_Code CdUIDesignation ON AD.DesignationCodeId = CdUIDesignation.CodeID 
			  LEFT JOIN com_Code CdUICategory ON AD.Category = CdUICategory.CodeID 
			  LEFT JOIN com_Code CdUISubCategory ON AD.SubCategory = CdUISubCategory.CodeID 
			  LEFT JOIN usr_RoleMaster UR ON AD.RoleId = UR.RoleId
			  WHERE 1 = 1
			  AND AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
			  AND AM.MapToId = @inp_nMapToId
			  AND AM.VersionNumber = @nAppMaxVersionNumber
			  AND AD.InsiderTypeCodeId = @nUserTypeEmployeeCodeId
			  AND AD.UserId IS NULL
			  AND AD.NonInsFltrDepartmentCodeId IS NULL AND AD.NonInsFltrGradeCodeId IS NULL
			  AND AD.NonInsFltrDesignationCodeId IS NULL AND AD.NonInsFltrCategory IS NULL AND AD.NonInsFltrSubCategory IS NULL AND AD.NonInsFltrRoleID IS NULL 
			  --AND (UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate())
			  ORDER BY ApplicabilityDtlsId	
			  print('1')			
		END
		ELSE  
		BEGIN		
			SELECT 
			ApplicabilityDtlsId, 
		    --CdUIDepartment.CodeName,CdUIGrade.CodeName, CdUIDesignation.CodeName,
			  ISNULL((CASE WHEN CdUIDepartment.DisplayCode IS NULL OR CdUIDepartment.DisplayCode = '' THEN CdUIDepartment.CodeName ELSE CdUIDepartment.DisplayCode END),'') AS rul_grd_55363,--DepartmentName,
			  ISNULL((CASE WHEN CdUIGrade.DisplayCode IS NULL OR CdUIGrade.DisplayCode = '' THEN CdUIGrade.CodeName ELSE CdUIGrade.DisplayCode END),'') AS rul_grd_55362,--GradeName,
			  ISNULL((CASE WHEN CdUIDesignation.DisplayCode IS NULL OR CdUIDesignation.DisplayCode = '' THEN CdUIDesignation.CodeName ELSE CdUIDesignation.DisplayCode END ),'') AS rul_grd_55361,--DesignationName,
			  		  
			  ISNULL(AD.NonInsFltrDepartmentCodeId, 0) AS DepartmentId, ISNULL(AD.NonInsFltrGradeCodeId, 0) AS GradeId, ISNULL(AD.NonInsFltrDesignationCodeId, 0) AS DesignationId,
			  ISNULL((CASE WHEN CdUICategory.DisplayCode IS NULL OR CdUICategory.DisplayCode = '' THEN CdUICategory.CodeName ELSE CdUICategory.DisplayCode END ),'') AS rul_grd_55359,--Category
			  ISNULL((CASE WHEN CdUISubCategory.DisplayCode IS NULL OR CdUISubCategory.DisplayCode = '' THEN CdUISubCategory.CodeName ELSE CdUISubCategory.DisplayCode END ),'') AS rul_grd_55358,--Sub Category
			  UR.RoleName AS rul_grd_55357, -- Role	
			  ISNULL(AD.NonInsFltrCategory, 0) AS CategoryId, ISNULL(AD.NonInsFltrSubCategory, 0) AS SubCategoryId, ISNULL(AD.NonInsFltrRoleId, 0) AS RoleId
			  FROM rul_ApplicabilityDetails_OS AD 
			  INNER JOIN rul_ApplicabilityMaster_OS AM ON AD.ApplicabilityMstId = AM.ApplicabilityId
			 -- INNER JOIN usr_UserInfo UF ON AD.UserId = UF.UserInfoID
			  LEFT JOIN com_Code CdUIDepartment ON AD.NonInsFltrDepartmentCodeId = CdUIDepartment.CodeID
			  LEFT JOIN com_Code CdUIGrade ON AD.NonInsFltrGradeCodeId = CdUIGrade.CodeID
			  LEFT JOIN com_Code CdUIDesignation ON AD.NonInsFltrDesignationCodeId = CdUIDesignation.CodeID 
			  LEFT JOIN com_Code CdUICategory ON AD.NonInsFltrCategory = CdUICategory.CodeID 
			  LEFT JOIN com_Code CdUISubCategory ON AD.NonInsFltrSubCategory = CdUISubCategory.CodeID 
			  LEFT JOIN usr_RoleMaster UR ON AD.NonInsFltrRoleId = UR.RoleId
			  WHERE 1 = 1
			  AND AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
			  AND AM.MapToId = @inp_nMapToId
			  AND AM.VersionNumber = @nAppMaxVersionNumber
			  AND AD.InsiderTypeCodeId = @nUserTypeEmployeeCodeId
			  AND AD.UserId IS NULL
			  AND AD.DepartmentCodeId IS NULL AND AD.GradeCodeId IS NULL
			  AND AD.DesignationCodeId IS NULL AND AD.Category IS NULL AND AD.SubCategory IS NULL AND AD.RoleID IS NULL 
			 -- AND (UF.DateOfBecomingInsider IS NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate())
			  ORDER BY ApplicabilityDtlsId		
		END
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_APPLICABILITY_FILTER_LIST_EMPLOYEE
	END CATCH
END
