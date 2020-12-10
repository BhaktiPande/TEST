-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 24-NOV-2015                                                 							=
-- Description : THIS VIEW IS USED FOR R & T REPORT	FILTERS												=
-- SELECT * FROM VW_RnTReporT																			=
-- ======================================================================================================
/*
ED			4-Feb-2016	Code integration done on 4-Feb-2016
*/
IF EXISTS(SELECT NAME FROM SYS.views WHERE NAME = 'VW_RnTReporT')
	DROP VIEW VW_RnTReporT
GO
CREATE VIEW VW_RnTReporT AS

	--SELECT	ISNULL(UI_B.UserInfoId, UI.UserInfoId) AS UserInfoId, 
	--	ISNULL(UI_B.EmployeeId, UI.EmployeeId) AS EmployeeId, 
	--	ISNULL(UI_B.FirstName, ISNULL(UI.FirstName, '')) + ' ' + ISNULL(UI_B.LastName, ISNULL(UI.LastName, '')) AS EmployeeName,
	--	ISNULL(CDesignation_A.CodeName, CDesignation.CodeName) AS Designation, 
	--	ISNULL(CGrade_A.CodeName, CGrade.CodeName) AS Grade, 
	--	ISNULL(UI_B.Location, UI.Location) AS Location,
	--	ISNULL(CDepartment_A.CodeName, CDepartment.CodeName) AS Department,
	--	ISNULL(MCompany_A.CompanyName, MCompany.CompanyName) AS CompanyName,
	--	ISNULL(CInsider_A.CodeName, CInsider.CodeName) AS TypeofInsider,
	--	CRelation.CodeName AS RelationWithEmployee,
	--	ISNULL(CASE WHEN (CRelation.CodeName IS NULL) THEN '' ELSE UI.FirstName END,'') + ' ' + ISNULL(CASE WHEN (CRelation.CodeName IS NULL)  THEN '' ELSE UI.LastName END,'') AS ReletiveName,
	--	UI.PAN ,
	--	CSecurity.CodeName AS SecurityType,
	--	CSecurity.CodeID AS SecurityTypeCode,
	--	UDD.DPID AS DPID,
	--	UDD.DEMATAccountNumber
	--FROM tra_TransactionMaster TM
	--INNER JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
	--LEFT OUTER JOIN usr_UserInfo UI ON TD.ForUserInfoId = UI.UserInfoId
	--LEFT OUTER JOIN com_Code CDesignation ON UI.DesignationId = CDesignation.CodeID
	--LEFT OUTER JOIN com_Code CGrade ON UI.GradeId = CGrade.CodeID
	--LEFT OUTER JOIN com_Code CDepartment ON UI.DepartmentId = CDepartment.CodeID
	--LEFT OUTER JOIN com_Code CInsider ON UI.SubCategory = CInsider.CodeId
	--LEFT OUTER JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
	--LEFT OUTER JOIN mst_Company MCompany ON UI.CompanyId = MCompany.CompanyId
	--LEFT OUTER JOIN usr_UserInfo UI_A ON UI.UserInfoId = UI_A.UserInfoId
	--LEFT OUTER JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = UI.UserInfoId
	--LEFT OUTER JOIN usr_UserInfo UI_B ON UR.UserInfoId = UI_B.UserInfoId
	--LEFT OUTER JOIN com_Code CRelation ON CRelation.CodeID = UR.RelationTypeCodeId
	--LEFT OUTER JOIN com_Code CDesignation_A ON UI_B.DesignationId = CDesignation_A.CodeID
	--LEFT OUTER JOIN com_Code CGrade_A ON UI_B.GradeId = CGrade_A.CodeID
	--LEFT OUTER JOIN com_Code CDepartment_A ON UI_B.DepartmentId = CDepartment_A.CodeID
	--LEFT OUTER JOIN mst_Company MCompany_A ON UI_B.CompanyId = MCompany_A.CompanyId
	--LEFT OUTER JOIN com_Code CInsider_A ON UI_B.SubCategory = CInsider_A.CodeId
	--LEFT OUTER JOIN usr_DMATDetails UDD ON UI.UserInfoId = UDD.UserInfoID and TD.DMATDetailsID = UDD.DMATDetailsID
	
	
		SELECT	
			ISNULL(UI_B.UserInfoId, UI.UserInfoId) AS UserInfoId, 
			ISNULL(UI_B.EmployeeId, UI.EmployeeId) AS EmployeeId, 
			ISNULL(UI_B.FirstName, ISNULL(UI.FirstName, '')) + ' ' + ISNULL(UI_B.LastName, ISNULL(UI.LastName, '')) AS EmployeeName,
			ISNULL(ISNULL(CDesignation_A.CodeName, CDesignation.CodeName),UI.DesignationText) AS Designation, 
			ISNULL(ISNULL(CGrade_A.CodeName, CGrade.CodeName),UI.GradeText) AS Grade, 
			ISNULL(UI_B.Location, UI.Location) AS Location,
			ISNULL(ISNULL(CDepartment_A.CodeName, CDepartment.CodeName),UI.DepartmentText) AS Department,
			ISNULL(MCompany_A.CompanyName, MCompany.CompanyName) AS CompanyName,
			ISNULL(ISNULL(CInsider_A.CodeName, CInsider.CodeName),UI.SubCategoryText) AS TypeofInsider,
			CRelation.CodeName AS RelationWithEmployee,
			ISNULL(CASE WHEN (CRelation.CodeName IS NULL) THEN '' ELSE UI.FirstName END,'') + ' ' + ISNULL(CASE WHEN (CRelation.CodeName IS NULL)  THEN '' ELSE UI.LastName END,'') AS ReletiveName,
			UI.PAN ,
			CSecurity.CodeName AS SecurityType,
			CSecurity.CodeID AS SecurityTypeCode,
			UDD.DPID AS DPID,
			UDD.DEMATAccountNumber			
		FROM tra_TransactionMaster TM
			INNER JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			LEFT OUTER JOIN usr_UserInfo UI ON TD.ForUserInfoId = UI.UserInfoId
			LEFT OUTER JOIN com_Code CDesignation ON UI.DesignationId = CDesignation.CodeID
			LEFT OUTER JOIN com_Code CGrade ON UI.GradeId = CGrade.CodeID
			LEFT OUTER JOIN com_Code CDepartment ON UI.DepartmentId = CDepartment.CodeID
			LEFT OUTER JOIN com_Code CInsider ON UI.SubCategory = CInsider.CodeId
			LEFT OUTER JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
			LEFT OUTER JOIN mst_Company MCompany ON UI.CompanyId = MCompany.CompanyId
			LEFT OUTER JOIN usr_UserInfo UI_A ON UI.UserInfoId = UI_A.UserInfoId
			LEFT OUTER JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = UI.UserInfoId
			LEFT OUTER JOIN usr_UserInfo UI_B ON UR.UserInfoId = UI_B.UserInfoId
			LEFT OUTER JOIN com_Code CRelation ON CRelation.CodeID = UR.RelationTypeCodeId
			LEFT OUTER JOIN com_Code CDesignation_A ON UI_B.DesignationId = CDesignation_A.CodeID
			LEFT OUTER JOIN com_Code CGrade_A ON UI_B.GradeId = CGrade_A.CodeID
			LEFT OUTER JOIN com_Code CDepartment_A ON UI_B.DepartmentId = CDepartment_A.CodeID
			LEFT OUTER JOIN mst_Company MCompany_A ON UI_B.CompanyId = MCompany_A.CompanyId
			LEFT OUTER JOIN com_Code CInsider_A ON UI_B.SubCategory = CInsider_A.CodeId
			LEFT OUTER JOIN usr_DMATDetails UDD ON UI.UserInfoId = UDD.UserInfoID and TD.DMATDetailsID = UDD.DMATDetailsID
			