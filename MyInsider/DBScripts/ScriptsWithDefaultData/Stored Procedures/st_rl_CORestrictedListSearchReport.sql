-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 07-OCT-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR CO RESTRICTED LIST SEARCH REPORT							=
-- EXEC st_rl_CORestrictedListSearchReport '','','','','','','','','','0','2015-10-01','2015-10-31'		=
-- ======================================================================================================
/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_CORestrictedListSearchReport')
	DROP PROCEDURE st_rl_CORestrictedListSearchReport
GO
CREATE PROCEDURE st_rl_CORestrictedListSearchReport 
(	
	@EmployeeId				VARCHAR(300) = '',
	@EmployeeName			VARCHAR(300) = '',
	@CompanyName			VARCHAR(300) = '',
	@ISINCode				VARCHAR(300) = '',
	@BSECode				VARCHAR(300) = '',
	@NSECode				VARCHAR(300) = '',
	@Designation			VARCHAR(300) = '',
	@Department				VARCHAR(300) = '',
	@Grade					VARCHAR(300) = '',
	@TradingAllow			VARCHAR(300) = '',
	@SearchFromDate			DATETIME,
	@SearchToDate			DATETIME
)
AS 
BEGIN

	DECLARE @ALLOWTRAD VARCHAR(100) = 50015
	DECLARE @NOTALLOWTRAD VARCHAR(100) = 50016
	
	PRINT @ALLOWTRAD
	PRINT @NOTALLOWTRAD
	
SELECT RlSearchAuditId, SA.UserInfoId, ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS EMPLOYEENAME, ResourceKey, SA.RlCompanyId, SA.RlMasterId, SA.ModuleCodeId, 
	ISNULL(CC.CodeName,'') AS Designation, (CASE CML.BSECode WHEN '' THEN 'Not Available' ELSE CML.BSECode END) AS BSECode,
	CML.ISINCode, (CASE CML.NSECode WHEN '' THEN 'Not Available' ELSE CML.NSECode END) AS NSECode, CML.CompanyName, CCD.CodeName AS Department, 
	CCG.CodeName AS GRADE,SA.CreatedBy, SA.CreatedOn AS SearchDate,RML.ApplicableFromDate, RML.ApplicableToDate,
	LTRIM(RIGHT(CONVERT(VARCHAR(25), SA.CreatedOn, 100), 7)) AS SearchTime, CASE SA.ResourceKey WHEN @NOTALLOWTRAD THEN 'No' ELSE 'Yes' END AS [Trading Allow]	
	FROM rl_SearchAudit SA
	LEFT OUTER JOIN usr_UserInfo UI ON UI.UserInfoId = SA.UserInfoId
	LEFT OUTER JOIN com_Code CC ON CC.CodeID = ISNULL(UI.DesignationId, NULL)
	LEFT OUTER JOIN com_Code CCD ON CCD.CodeID = UI.DepartmentId
	LEFT OUTER JOIN com_Code CCG ON CCG.CodeID = UI.GradeId
	LEFT OUTER JOIN rl_CompanyMasterList CML ON CML.RlCompanyId = SA.RlCompanyId
	LEFT OUTER JOIN rl_RistrictedMasterList RML ON RML.RlCompanyId = SA.RlCompanyId AND SA.RlMasterId = RML.RlMasterId
	WHERE 
	SA.UserInfoId = (CASE @EmployeeId WHEN '' THEN SA.UserInfoId ELSE @EmployeeId END) 
	AND ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') = (CASE @EmployeeName WHEN '' THEN ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') ELSE @EmployeeName END)
	AND ISNULL(CML.CompanyName,'') = (CASE WHEN @CompanyName = '' THEN ISNULL(CML.CompanyName,'') ELSE @CompanyName END)     
	AND ISNULL(CML.ISINCode,'') = (CASE WHEN @ISINCode = '' THEN ISNULL(CML.ISINCode,'') ELSE @ISINCode END)      
	AND ISNULL(CML.BSECode,'') = (CASE WHEN @BSECode = '' THEN ISNULL(CML.BSECode,'') ELSE @BSECode END)    
	AND ISNULL(CML.NSECode,'') = (CASE WHEN @NSECode = '' THEN ISNULL(CML.NSECode,'') ELSE @NSECode END)        
	AND ISNULL(CC.CodeName,'') = (CASE WHEN @Designation = '' THEN ISNULL(CC.CodeName,'') ELSE @Designation END)    
	AND ISNULL(CCD.CodeName,'') = (CASE WHEN @Department  ='' THEN ISNULL(CCD.CodeName,'') ELSE @Department END)    
	AND ISNULL(CCG.CodeName,'') = (CASE WHEN @Grade = '' THEN ISNULL(CCG.CodeName,'') ELSE @Grade END)    
	AND SA.ResourceKey = (CASE @TradingAllow WHEN '0' THEN  ResourceKey WHEN @ALLOWTRAD THEN @ALLOWTRAD ELSE @TradingAllow END)
	AND((CONVERT(DATE, SA.CreatedOn) >= CONVERT(DATE,@SearchFromDate)) AND (CONVERT(DATE, ISNULL(SA.CreatedOn, dbo.uf_com_GetServerDate())) <=  CONVERT(DATE,@SearchToDate)))
	
END