IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_SearchEmployeeDetails')
	DROP PROCEDURE st_rl_SearchEmployeeDetails
GO
-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 18-SEP-2015                                                 			=
-- Description : THIS PROCEDURE IS USED FOR SEARCH RESTRICTED LIST EMPLOYEE DETAILS     =
--					st_rl_SearchEmployeeDetails																	=
-- ======================================================================================


CREATE PROC st_rl_SearchEmployeeDetails

AS 
BEGIN
	SELECT ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS EMPLOYEENAME,rAD.UserId As UserInfoId,
		rAM.ApplicabilityId,RML.RlMasterId,CC.CodeName AS Designation,UI.DesignationId, 
		CCD.CodeName AS Department,UI.DepartmentId,UI.GradeId,CCG.CodeName AS Grade,
		CML.BSECode,CML.ISINCode,(CASE CML.NSECode WHEN '' THEN 'Not Available' ELSE CML.NSECode END) AS NSECode ,CML.CompanyName,
	CONVERT(VARCHAR(10),RML.ApplicableFromDate,103) AS ApplicableFromDate,
	CONVERT(VARCHAR(10),RML.ApplicableToDate,103) AS ApplicableToDate
	FROM usr_UserInfo UI 
	LEFT OUTER JOIN rul_ApplicabilityDetails rAD ON rAD.UserId = UI.UserInfoId
	LEFT OUTER JOIN rul_ApplicabilityMaster rAM ON rAM.ApplicabilityId =  rAD.ApplicabilityMstId
	LEFT OUTER JOIN rl_RistrictedMasterList RML ON RML.RlMasterId = rAM.MapToId	
	LEFT OUTER JOIN com_Code CC ON CC.CodeID = UI.DesignationId
	LEFT OUTER JOIN com_Code CCD ON CCD.CodeID = UI.DepartmentId
	LEFT OUTER JOIN com_Code CCG ON CCG.CodeID = UI.GradeId
	LEFT OUTER JOIN rl_CompanyMasterList CML ON CML.RlCompanyId = RML.RlCompanyId
	WHERE rAD.IncludeExcludeCodeId=150001 AND RML.StatusCodeId = 105001
END