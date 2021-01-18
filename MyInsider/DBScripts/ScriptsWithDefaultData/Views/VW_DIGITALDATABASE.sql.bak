IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_DIGITALDATABASE]'))
DROP VIEW [dbo].[VW_DIGITALDATABASE]
GO
/*----------------------------------------------------------			
Created by:		AniketG
Created on:		24-July-2019

Modification History:
Modified By		Modified On		Description
----------------------------------------------------------*/

CREATE VIEW VW_DIGITALDATABASE
AS
	SELECT UI.userinfoid, 
		ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LASTNAME,'') EmployeeName,
		ISNULl(case when PAN is null then ui.UIDAI_IdentificationNo else UI.PAN end,'') IdentificationNo,
		ISNULL(desig.CodeName,'') Designation,
		ISNULL(UI.EMPLOYEEID,'') EmployeeID,
		ISNULL(Dept.CodeName,'') Department,
		ISNULL(UI.Location,'') Location,
		ISNULL(UI.MobileNumber,'') Mobile,
		DBO.uf_com_Relative_Name(UI.userinfoid) RelativeName,
		DBO.uf_com_relation(UI.userinfoid) RelationWithEmployee,
		dbo.uf_com_Relative_PAN(UI.userinfoid) RelativePAN, 
		dbo.uf_com_Relative_Mobile(UI.userinfoid) RelativeMobile,
		dbo.uf_com_Education(UI.userinfoid) Education,
		dbo.uf_com_EducationYear(ui.UserInfoId) EducationYears,
		dbo.uf_com_PastEmployer(UI.UserInfoid) PastEmployers,
		dbo.uf_com_PastEmployerYear(UI.userinfoid) PastEmployersYears,
		dbo.uf_com_DematDetails(ui.userinfoid) DematAccountNumber,
		UI.DateOfBecomingInsider,
		UI.DateOfSeparation
	FROM usr_UserInfo UI 
		LEFT OUTER JOIN com_code Desig ON ui.DesignationId=desig.CodeID
		LEFT OUTER JOIN com_code Dept ON ui.DepartmentId=Dept.CodeID
	WHERE UI.UserTypeCodeId = 101003
	
	