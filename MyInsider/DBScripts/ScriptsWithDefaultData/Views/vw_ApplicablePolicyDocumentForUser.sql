/*
Modified On	Modified By	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicablePolicyDocumentForUser]'))
DROP VIEW [dbo].[vw_ApplicablePolicyDocumentForUser]
GO

CREATE VIEW [dbo].[vw_ApplicablePolicyDocumentForUser]
AS

SELECT MAX(ApplicabilityMstId) AS ApplicabilityMstId, UserInfoId, MapToId --, MAX(IncludeFlag) AS IncludeFlag
FROM
(
-- For AllEmployeeFlag ********
SELECT 'AllEmployeeFlag' AS FromList, /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , 0 AS IncludeFlag, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllEmployeeFlag = 1 AND UF.UserTypeCodeId = 101003 AND UF.StatusCodeId = 102001
	AND (UF.DateOfBecomingInsider IS NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate())
--JOIN vw_ApplicabilityMasterCurrentTradingPolicy vwAppMaster ON vwAppMaster.ApplicabilityId = AD.ApplicabilityMstId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UF.UserInfoId, PolicyDocumentId
UNION
SELECT 'AllEmployeeFlag', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllEmployeeFlag = 1 AND UF.UserTypeCodeId = 101003  AND UF.StatusCodeId = 102001
	AND (UF.DateOfBecomingInsider IS NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate())
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
UNION

-- For AllInsiderFlag ********
SELECT 'AllInsiderFlag', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllInsiderFlag = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UF.UserInfoId, PolicyDocumentId
UNION
SELECT 'AllInsiderFlag', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllInsiderFlag = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
UNION

-- For AllEmployeeInsiderFlag ********
SELECT 'AllEmployeeInsiderFlag', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllEmployeeInsiderFlag = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
	AND UF.UserTypeCodeId = 101003
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UF.UserInfoId, PolicyDocumentId
UNION
SELECT 'AllEmployeeInsiderFlag', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllEmployeeInsiderFlag = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
	 AND UF.UserTypeCodeId = 101003
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
UNION
-- For AllNonEmployeeInsiderFlag ********
SELECT 'AllNonEmployeeInsiderFlag', AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
--, MAX(AD.ApplicabilityMstId) ApplicabilityMstId, UF.UserInfoId, 0, vwAppMaster.MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllNonEmployee = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
	AND UF.UserTypeCodeId = 101006
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
UNION
-- For AllCorporateInsiderFlag ********
SELECT 'AllCorporateInsiderFlag',AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
--, MAX(AD.ApplicabilityMstId) ApplicabilityMstId, UF.UserInfoId, 0, vwAppMaster.MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllCorporateEmployees = 1 AND 
	(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
	AND UF.UserTypeCodeId = 101004
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId

UNION

-- InsiderTypeCodeId set ***********
SELECT distinct 'InsiderTypeCodeId', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.UserTypeCodeId = AD.InsiderTypeCodeId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN usr_UserRole UR ON UF.UserInfoID = UR.UserInfoID
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (DepartmentCodeId IS NULL OR UF.DepartmentId = DepartmentCodeId)
AND (GradeCodeId IS NULL OR UF.GradeId = GradeCodeId)
AND (DesignationCodeId IS NULL OR UF.DesignationId = DesignationCodeId)
AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
AND (AD.Category IS  NULL OR UF.Category = AD.Category)
AND (AD.SubCategory IS  NULL OR UF.SubCategory = AD.SubCategory)
AND (AD.RoleID IS NULL OR AD.RoleID = UR.RoleID)
AND AD.NonInsFltrDepartmentCodeId IS NULL AND AD.NonInsFltrGradeCodeId IS NULL
AND AD.NonInsFltrDesignationCodeId IS NULL AND AD.NonInsFltrCategory IS NULL AND AD.NonInsFltrSubCategory IS NULL AND AD.NonInsFltrRoleID IS NULL 
--GROUP BY UF.UserInfoId, PolicyDocumentId
/*
UNION
SELECT distinct 'InsiderTypeCodeId', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.UserTypeCodeId = AD.InsiderTypeCodeId
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
JOIN usr_UserRole UROL ON UF.UserInfoID = UROL.UserInfoID
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (DepartmentCodeId IS NULL OR UF.DepartmentId = DepartmentCodeId)
AND (GradeCodeId IS NULL OR UF.GradeId = GradeCodeId)
AND (DesignationCodeId IS NULL OR UF.DesignationId = DesignationCodeId)
AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
AND (AD.Category IS  NULL OR UF.Category = AD.Category)
AND (AD.SubCategory IS  NULL OR UF.SubCategory = AD.SubCategory)
AND (AD.RoleID IS NULL OR AD.RoleID = UROL.RoleID)
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
*/
UNION
SELECT distinct 'EmpNonInsiderTypeCodeId', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ (UF.DateOfBecomingInsider IS  NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UF.UserTypeCodeId = AD.InsiderTypeCodeId

JOIN usr_UserRole UROL ON UF.UserInfoID = UROL.UserInfoID
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (NonInsFltrDepartmentCodeId IS NULL OR UF.DepartmentId = NonInsFltrDepartmentCodeId)
AND (NonInsFltrGradeCodeId IS NULL OR UF.GradeId = NonInsFltrGradeCodeId)
AND (NonInsFltrDesignationCodeId IS NULL OR UF.DesignationId = NonInsFltrDesignationCodeId)
AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
AND (AD.NonInsFltrCategory IS  NULL OR UF.Category = AD.NonInsFltrCategory)
AND (AD.NonInsFltrSubCategory IS  NULL OR UF.SubCategory = AD.NonInsFltrSubCategory)
AND (AD.NonInsFltrRoleID IS NULL OR AD.NonInsFltrRoleID = UROL.RoleID)
AND AD.DepartmentCodeId IS NULL AND AD.GradeCodeId IS NULL
AND AD.DesignationCodeId IS NULL AND AD.Category IS NULL AND AD.SubCategory IS NULL AND AD.RoleID IS NULL 
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
/*
UNION
SELECT distinct 'EmpNonInsiderTypeCodeId', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 0, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ (UF.DateOfBecomingInsider IS  NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UF.UserTypeCodeId = AD.InsiderTypeCodeId
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
JOIN usr_UserRole UROL ON UF.UserInfoID = UROL.UserInfoID
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (NonInsFltrDepartmentCodeId IS NULL OR UF.DepartmentId = NonInsFltrDepartmentCodeId)
AND (NonInsFltrGradeCodeId IS NULL OR UF.GradeId = NonInsFltrGradeCodeId)
AND (NonInsFltrDesignationCodeId IS NULL OR UF.DesignationId = NonInsFltrDesignationCodeId)
AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
AND (AD.NonInsFltrCategory IS  NULL OR UF.Category = AD.NonInsFltrCategory)
AND (AD.NonInsFltrSubCategory IS  NULL OR UF.SubCategory = AD.NonInsFltrSubCategory)
AND (AD.NonInsFltrRoleID IS NULL OR AD.NonInsFltrRoleID = UROL.RoleID)
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
*/
UNION
-- Exclude set ***********
SELECT distinct 'Exclude', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, 1, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ UF.UserTypeCodeId = AD.InsiderTypeCodeId  AND UF.StatusCodeId = 102001
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150002)
--GROUP BY UF.UserInfoId, PolicyDocumentId
UNION
SELECT distinct 'Exclude', /*MAX(AD.ApplicabilityMstId) AS ApplicabilityMstId,*/ AD.ApplicabilityMstId AS ApplicabilityMstId, UR.UserInfoIdRelative, 1, PolicyDocumentId AS MapToId
FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ UF.UserTypeCodeId = AD.InsiderTypeCodeId  AND UF.StatusCodeId = 102001
JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
--JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId = AM.ApplicabilityId AND AM.MapToTypeCodeId = 132001
JOIN vw_ApplicabilityMasterCurrentPolicyDocument t ON AD.ApplicabilityMstId = t.ApplicabilityId
WHERE 1 = 1
AND (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150002)
--GROUP BY UR.UserInfoIdRelative, PolicyDocumentId
) A
GROUP BY MapToId, UserInfoId
HAVING MAX(IncludeFlag) = 0
