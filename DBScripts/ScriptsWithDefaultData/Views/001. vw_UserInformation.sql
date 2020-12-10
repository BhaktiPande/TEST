IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_UserInformation]'))
DROP VIEW [dbo].[vw_UserInformation]
GO
/*
Modification History
ModifiedBy	ModifiedOn Description

*/
CREATE VIEW [dbo].[vw_UserInformation]
AS 
SELECT UserInfoID,
UF.EmployeeId,
CASE WHEN UserTypeCodeId = 101004 THEN CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END UserFullName,
DateOfJoining,CIN,DIN,
CASE WHEN CDesignation.CodeID IS NOT NULL THEN CDesignation.CodeName ELSE UF.DesignationText END AS Designation,
CGrade.CodeName AS Grade,
UF.Location AS Location,
CDepartment.CodeName AS Department,
CUserType.CodeName AS UserType,
UF.CompanyId,
C.CompanyName,
CASE WHEN UF.UserTypeCodeId = 101004 THEN UF.CIN ELSE UF.DIN END AS CINAndDIN,
UF.DesignationId AS DesignationId,
UF.GradeId AS GradeId,
UF.DepartmentId AS DepartmentId, 
UF.UserTypeCodeId AS UserTypeCodeId,
ISINNumber,
UF.DateOfBecomingInsider AS DateOfBecomingInsider,
UF.DateOfInactivation as DateOfInactivation,
UF.PAN AS PAN,
UF.GradeText AS GradeText,
UF.DepartmentText AS DepartmentText
FROM usr_UserInfo UF
LEFT JOIN mst_Company C ON UF.CompanyId = C.CompanyId
LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID
LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
LEFT JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
