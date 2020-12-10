IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_RestrictedListSearchReport')
	DROP PROCEDURE st_rl_RestrictedListSearchReport
GO
-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 18-SEP-2015                                                 			=
-- Description : THIS PROCEDURE IS USED FOR RESTRICTED LIST SEARCH REPORT				=
--																						=
-- ======================================================================================


CREATE PROC st_rl_RestrictedListSearchReport 
(
	@inp_iLoggedInUserId		INT
)
AS 
BEGIN
	SELECT RlSearchAuditId, SA.UserInfoId, ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS EMPLOYEENAME, 
	ResourceKey,SA.RlCompanyId, SA.RlMasterId, SA.ModuleCodeId, CC.CodeName AS Designation,CML.BSECode,CML.ISINCode,
	(CASE CML.NSECode WHEN '' THEN 'Not Available' ELSE CML.NSECode END) AS NSECode ,CML.CompanyName,
		CCD.CodeName AS Department,CCG.DisplayCode AS GRADE,SA.CreatedBy, CONVERT(VARCHAR(10),SA.CreatedOn,103) AS SearchDate,
		CONVERT(VARCHAR(10),RML.ApplicableFromDate,103) AS ApplicableFromDate,CONVERT(VARCHAR(10),RML.ApplicableToDate,103) AS ApplicableToDate,
		LTRIM(RIGHT(CONVERT(VARCHAR(25), SA.CreatedOn, 100), 7)) AS SearchTime,
		CASE SA.ResourceKey WHEN 50016 THEN 'No' ELSE 'Yes' END AS [Trading Allow]	
	FROM rl_SearchAudit SA
	LEFT OUTER JOIN usr_UserInfo UI ON UI.UserInfoId = SA.UserInfoId
	LEFT OUTER JOIN com_Code CC ON CC.CodeID = UI.DesignationId
	LEFT OUTER JOIN com_Code CCD ON CCD.CodeID = UI.DepartmentId
	LEFT OUTER JOIN com_Code CCG ON CCG.CodeID = UI.GradeId
	LEFT OUTER JOIN rl_CompanyMasterList CML ON CML.RlCompanyId = SA.RlCompanyId
	LEFT OUTER JOIN rl_RistrictedMasterList RML ON RML.RlCompanyId = SA.RlCompanyId AND SA.RlMasterId = RML.RlMasterId
	WHERE SA.UserInfoId = (CASE @inp_iLoggedInUserId WHEN 0 THEN SA.UserInfoId ELSE @inp_iLoggedInUserId END)
	ORDER BY RlSearchAuditId DESC
	
END
