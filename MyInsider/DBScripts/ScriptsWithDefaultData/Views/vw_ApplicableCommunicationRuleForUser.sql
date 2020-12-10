/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicableCommunicationRuleForUser]'))
DROP VIEW [dbo].[vw_ApplicableCommunicationRuleForUser]
GO

CREATE VIEW [dbo].[vw_ApplicableCommunicationRuleForUser]
AS
	SELECT RuleId, ApplicabilityMstId, UserTypeCodeId, UserInfoId, MAX(IncludeFlag) AS IncludeFlag
	FROM
	(
		--Rule applicable to All Active Employee
		SELECT 'AllEmployeeFlag' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , UF.UserTypeCodeId, 0 AS IncludeFlag, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.AllEmployeeFlag = 1 AND UF.UserTypeCodeId = 101003 AND  UF.StatusCodeId = 102001 
				 AND (UF.DateOfBecomingInsider IS NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate())
		--AllEmployeeFlag indicates all users of type employee who are non-insiders
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		--Rule applicable to All Active Insider
		SELECT 'AllInsiderFlag' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , UF.UserTypeCodeId, 0 AS IncludeFlag, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.AllInsiderFlag = 1 AND UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() --AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= dbo.uf_com_GetServerDate()) 
		AND UF.StatusCodeId = 102001
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		--Rule applicable to All Active Employee Insider
		SELECT 'AllEmployeeInsiderFlag' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , UF.UserTypeCodeId, 0 AS IncludeFlag, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.AllEmployeeInsiderFlag = 1 AND UF.UserTypeCodeId = 101003 AND UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= dbo.uf_com_GetServerDate()) 
		AND UF.StatusCodeId = 102001
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		-- For AllNonEmployeeInsiderFlag ********
		SELECT 'AllNonEmployeeInsiderFlag' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , UF.UserTypeCodeId, 0 AS IncludeFlag, RuleId
		--, MAX(AD.ApplicabilityMstId) ApplicabilityMstId, UF.UserInfoId, 0, vwAppMaster.MapToId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllNonEmployee = 1 AND 
			(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
			AND UF.UserTypeCodeId = 101006
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		-- For AllCorporateInsiderFlag ********
		SELECT 'AllCorporateInsiderFlag' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId , UF.UserTypeCodeId, 0 AS IncludeFlag, RuleId
		--, MAX(AD.ApplicabilityMstId) ApplicabilityMstId, UF.UserInfoId, 0, vwAppMaster.MapToId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON AD.AllCorporateEmployees = 1 AND 
			(/*UF.IsInsider = 1*/UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.StatusCodeId = 102001)--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))))
			AND UF.UserTypeCodeId = 101004
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		--Rule applicable to All Active Insider Users / CO-Users depending upon Department,Grade,Designation (in case of Employee Insider) and depending upon UserId(in case of Employee Insider, Non-Employee Insider, Corporate Insider, CO-User)
		SELECT distinct 'AllCoTypeCodeId' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, UF.UserTypeCodeId, 0, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.AllCo = 1  AND UF.StatusCodeId = 102001 AND UF.UserTypeCodeId = 101002
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		UNION
		--Rule applicable to All Active Insider Users / CO-Users depending upon Department,Grade,Designation (in case of Employee Insider) and depending upon UserId(in case of Employee Insider, Non-Employee Insider, Corporate Insider, CO-User)
		SELECT distinct 'InsiderTypeCodeId' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, UF.UserTypeCodeId, 0, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.InsiderTypeCodeId = UF.UserTypeCodeId  AND UF.StatusCodeId = 102001
		JOIN usr_UserRole UR ON UF.UserInfoID = UR.UserInfoID
		--AND UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
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
		AND  (AD.InsiderTypeCodeId <> 101002 AND UF.DateOfBecomingInsider IS NOT NULL AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= dbo.uf_com_GetServerDate()))  /*user is (CO-User(101002) OR (non CO-User but an Insider)*/
		UNION
		--Rule applicable to All Active Insider Users / CO-Users depending upon Department,Grade,Designation (in case of Employee Insider) and depending upon UserId(in case of Employee Insider, Non-Employee Insider, Corporate Insider, CO-User)
		SELECT distinct 'EmpNonInsiderTypeCodeId' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, UF.UserTypeCodeId, 0, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.InsiderTypeCodeId = UF.UserTypeCodeId  AND UF.StatusCodeId = 102001
		JOIN usr_UserRole UR ON UF.UserInfoID = UR.UserInfoID
		--AND UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		WHERE 1 = 1
		AND (NonInsFltrDepartmentCodeId IS NULL OR UF.DepartmentId = NonInsFltrDepartmentCodeId)
		AND (NonInsFltrGradeCodeId IS NULL OR UF.GradeId = NonInsFltrGradeCodeId)
		AND (NonInsFltrDesignationCodeId IS NULL OR UF.DesignationId = NonInsFltrDesignationCodeId)
		AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
		AND (AD.NonInsFltrCategory IS  NULL OR UF.Category = AD.NonInsFltrCategory)
		AND (AD.NonInsFltrSubCategory IS  NULL OR UF.SubCategory = AD.NonInsFltrSubCategory)
		AND (AD.NonInsFltrRoleID IS NULL OR AD.NonInsFltrRoleID = UR.RoleID)		
		AND AD.DepartmentCodeId IS NULL AND AD.GradeCodeId IS NULL
		AND AD.DesignationCodeId IS NULL AND AD.Category IS NULL AND AD.SubCategory IS NULL AND AD.RoleID IS NULL 
		AND (AD.InsiderTypeCodeId <> 101002 AND (UF.DateOfBecomingInsider IS  NULL OR UF.DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation >= dbo.uf_com_GetServerDate()))  /*user is (CO-User(101002) OR (non CO-User but an Insider)*/
		UNION
		--Rule applicable to All Active Insider Users / CO-Users depending upon Department,Grade,Designation (in case of Employee Insider) and depending upon UserId(in case of Employee Insider, Non-Employee Insider, Corporate Insider, CO-User)
		SELECT distinct 'CoTypeCodeId' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, UF.UserTypeCodeId, 0, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.InsiderTypeCodeId = UF.UserTypeCodeId  AND UF.StatusCodeId = 102001 AND UF.UserTypeCodeId = 101002
		--AND UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate()
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		WHERE 1 = 1
		AND (UserId IS NULL OR (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150001))
		  /*user is (CO-User(101002) OR (non CO-User but an Insider)*/
		AND AD.InsiderTypeCodeId = 101002 
		UNION
		--Rule NOT applicable to All Active users who are Excluded from Rule applicability
		SELECT distinct 'Excluded' AS ApplicabilityType, AD.ApplicabilityMstId AS ApplicabilityMstId, UF.UserInfoId, UF.UserTypeCodeId, 1, RuleId
		FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF 
		ON AD.InsiderTypeCodeId = UF.UserTypeCodeId  AND UF.StatusCodeId = 102001
		JOIN vw_ApplicabilityMasterCurrentCommunicationRule AMCR 
		ON AD.ApplicabilityMstId = AMCR.ApplicabilityId
		WHERE 1 = 1
		AND (UF.UserInfoId = UserId AND IncludeExcludeCodeId = 150002)
	) AllUsers
	GROUP BY RuleId, UserInfoId, ApplicabilityMstId, UserTypeCodeId
	HAVING MAX(IncludeFlag) = 0
	--ORDER BY RuleId, ApplicabilityMstId, UserTypeCodeId, UserInfoId
