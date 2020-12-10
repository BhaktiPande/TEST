-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 19-NOV-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR R & T REPORT												=
-- EXEC st_rl_RnTReport																					=
-- ======================================================================================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_RnTReport')
	DROP PROCEDURE st_rl_RnTReport
GO
CREATE PROCEDURE st_rl_RnTReport
AS
BEGIN
CREATE TABLE #RNT_VIG_DATA
(
	UserInfoId					INT, 
	EmployeeId					VARCHAR(300), 
	EmployeeName				VARCHAR(300), 
	Designation					VARCHAR(300), 
	Grade						VARCHAR(300), 
	Location					VARCHAR(300),
	Department					VARCHAR(300),
	CompanyName					VARCHAR(300),
	TypeofInsider				VARCHAR(300),
	RelationWithEmployee		VARCHAR(300),
	ReletiveName				VARCHAR(300),
	PAN							VARCHAR(300),
	SecurityType				VARCHAR(300),
	SecurityTypeCode			VARCHAR(300),
	Quantity					DECIMAL(10,0),
	DPID						VARCHAR(300),
	DEMATAccountNumber			VARCHAR(300),       
	RnT_PAN						VARCHAR(300),
	RnT_SecurityType			VARCHAR(300),
	RnT_SecurityTypeCode		VARCHAR(300),	      	
	RnT_DPID					VARCHAR(300),
	RnT_DEMAT					VARCHAR(300),
	RnT_Quantity				DECIMAL(10,0),	
)

CREATE TABLE #FINAL_RNT_VIG_OUTPUT
(
	UserInfoId					INT, 
	EmployeeId					VARCHAR(300), 
	EmployeeName				VARCHAR(300), 
	Designation					VARCHAR(300), 
	Grade						VARCHAR(300), 
	Location					VARCHAR(300),
	Department					VARCHAR(300),
	CompanyName					VARCHAR(300),
	TypeofInsider				VARCHAR(300),
	RelationWithEmployee		VARCHAR(300),
	ReletiveName				VARCHAR(300),
	PAN							VARCHAR(300),
	SecurityType				VARCHAR(300),
	SecurityTypeCode			VARCHAR(300),
	Quantity					DECIMAL(10,0),
	DPID						VARCHAR(300),
	DEMATAccountNumber			VARCHAR(300),       
	RnT_PAN						VARCHAR(300),
	RnT_SecurityType			VARCHAR(300),
	RnT_SecurityTypeCode		VARCHAR(300),	      	
	RnT_DPID					VARCHAR(300),
	RnT_DEMAT					VARCHAR(300),
	RnT_Quantity				DECIMAL(10,0),
	COMMENT						VARCHAR(300)
)

INSERT INTO #RNT_VIG_DATA
(
	UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
	SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
)
SELECT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
	SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
FROM
(
	SELECT UI.UserInfoId, UI.EmployeeId, ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName, '') AS EmployeeName,
			CDesignation.CodeName AS Designation, 
			CGrade.CodeName AS Grade, 
			UI.Location,
			CDepartment.CodeName AS Department,
			MCompany.CompanyName AS CompanyName,
			CInsider.CodeName AS TypeofInsider,
			CRelation.CodeName AS RelationWithEmployee,
			ISNULL(URelative.FirstName,'') + ' ' + ISNULL(URelative.LastName,'') AS ReletiveName,
			UI.PAN ,
			CSecurity.CodeName AS SecurityType,
			CSecurity.CodeID AS SecurityTypeCode,
			SUM(TD.Quantity) Quantity,
			UDD.DPID AS DPID,
			UDD.DEMATAccountNumber,
			RMS.PANNumber AS RnT_PAN,
			RMS.SecurityType AS RnT_SecurityType,
			RMS.SecurityTypeCode AS RnT_SecurityTypeCode,
			RMS.DPID AS RnT_DPID,
			RMS.DematAccountNo AS RnT_DEMAT,
			RMS.Shares AS RnT_Quantity
	FROM tra_TransactionMaster TM
		INNER JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
		INNER JOIN usr_UserInfo UI ON TM.UserInfoId = UI.UserInfoId
		INNER JOIN com_Code CDesignation ON UI.DesignationId = CDesignation.CodeID
		INNER JOIN com_Code CGrade ON UI.GradeId = CGrade.CodeID
		INNER JOIN com_Code CDepartment ON UI.DepartmentId = CDepartment.CodeID
		INNER JOIN mst_Company MCompany ON UI.CompanyId = MCompany.CompanyId
		LEFT OUTER JOIN com_Code CInsider ON UI.SubCategory = CInsider.CodeId
		LEFT OUTER JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoId
		LEFT OUTER JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
		LEFT OUTER JOIN usr_UserInfo URelative ON UR.UserInfoIdRelative = URelative.UserInfoId	
		INNER JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
		INNER JOIN usr_DMATDetails UDD ON UI.UserInfoId = UDD.UserInfoID and TD.DMATDetailsID = UDD.DMATDetailsID
		LEFT OUTER JOIN rnt_MassUploadDetails RMS ON UI.PAN = RMS.PANNumber AND CSecurity.CodeName = RMS.SecurityType AND UDD.DEMATAccountNumber = RMS.DematAccountNo --AND UDD.DPID = RMS.DPID 
	WHERE DisclosureTypeCodeId IN (147001, 147002)
	GROUP BY UI.UserInfoId, UI.EmployeeId, ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName, ''),UI.Location,
			CDesignation.CodeName,CGrade.CodeName,CDepartment.CodeName,MCompany.CompanyName,CInsider.CodeName,
			CRelation.CodeName,ISNULL(URelative.FirstName,'') + ' ' + ISNULL(URelative.LastName,''),
			UI.PAN, CSecurity.CodeName,CSecurity.CodeID, UDD.DPID, UDD.DEMATAccountNumber, RMS.PANNumber, RMS.SecurityType, RMS.SecurityTypeCode,	RMS.DPID, RMS.DematAccountNo, RMS.Shares

	UNION

	SELECT 
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE UI.UserInfoId END userInfoId, 
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE UI.EmployeeId END EmployeeId, 
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName, '') END AS EmployeeName,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CDesignation.CodeName END AS Designation, 
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CGrade.CodeName END AS Grade, 
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE UI.Location END AS Location,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CDepartment.CodeName END AS Department,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE MCompany.CompanyName END AS CompanyName,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CInsider.CodeName END AS TypeofInsider,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CRelation.CodeName END AS RelationWithEmployee,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE ISNULL(URelative.FirstName,'') + ' ' + ISNULL(URelative.LastName,'') END AS ReletiveName,
			UI.PAN PAN,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CSecurity.CodeName END AS SecurityType,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE CSecurity.CodeID END AS SecurityTypeCode,
			CASE WHEN RMS.DPID <> UDD.DPID OR RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE SUM(TD.Quantity) END Quantity,
			CASE WHEN RMS.DPID <> UDD.DPID THEN NULL ELSE UDD.DPID END AS DPID,
			CASE WHEN RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN NULL ELSE UDD.DEMATAccountNumber END AS DEMATAccountNumber,
			RMS.PANNumber AS RnT_PAN,
			RMS.SecurityType AS RnT_SecurityType,
			RMS.SecurityTypeCode AS RnT_SecurityTypeCode,
			RMS.DPID AS RnT_DPID,
			RMS.DematAccountNo AS RnT_DEMAT,
			RMS.Shares AS RnT_Quantity
	FROM tra_TransactionMaster TM
		INNER JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
		INNER JOIN usr_UserInfo UI ON TM.UserInfoId = UI.UserInfoId		
		INNER JOIN com_Code CDesignation ON UI.DesignationId = CDesignation.CodeID
		INNER JOIN com_Code CGrade ON UI.GradeId = CGrade.CodeID
		INNER JOIN com_Code CDepartment ON UI.DepartmentId = CDepartment.CodeID
		INNER JOIN mst_Company MCompany ON UI.CompanyId = MCompany.CompanyId
		LEFT OUTER JOIN com_Code CInsider ON UI.SubCategory = CInsider.CodeId
		LEFT OUTER JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoId
		LEFT OUTER JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
		LEFT OUTER JOIN usr_UserInfo URelative ON UR.UserInfoIdRelative = URelative.UserInfoId		
		INNER JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
		INNER JOIN usr_DMATDetails UDD ON UI.UserInfoId = UDD.UserInfoID and TD.DMATDetailsID = UDD.DMATDetailsID
		RIGHT JOIN rnt_MassUploadDetails RMS ON UI.PAN = RMS.PANNumber AND CSecurity.CodeName = RMS.SecurityType 
		AND RMS.DematAccountNo = CASE WHEN RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN RMS.DematAccountNo ELSE UDD.DEMATAccountNumber END
		AND RMS.DPID = CASE WHEN RMS.DPID <> UDD.DPID THEN RMS.DPID ELSE UDD.DPID END
	WHERE DisclosureTypeCodeId IN (147001, 147002)
	AND 
		(RMS.DPID = 
		CASE 
			WHEN RMS.DPID <> UDD.DPID AND RMS.DematAccountNo <> UDD.DEMATAccountNumber THEN RMS.DematAccountNo 
			WHEN (RMS.DPID <> UDD.DPID AND RMS.DematAccountNo = UDD.DEMATAccountNumber) OR (RMS.DPID = UDD.DPID AND RMS.DematAccountNo <> UDD.DEMATAccountNumber) THEN RMS.DPID  		
		END)
	GROUP BY UI.UserInfoId, UI.EmployeeId, ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName, ''),
			UI.Location,
			CDesignation.CodeName,CGrade.CodeName,CDepartment.CodeName,MCompany.CompanyName,CInsider.CodeName,
			CRelation.CodeName,ISNULL(URelative.FirstName,'') + ' ' + ISNULL(URelative.LastName,''),
			UI.PAN, CSecurity.CodeName,	CSecurity.CodeID, UDD.DPID, UDD.DEMATAccountNumber, RMS.PANNumber, RMS.SecurityType, RMS.SecurityTypeCode,RMS.DPID, 
			RMS.DematAccountNo, RMS.Shares
) TEMP_OUTPUT

INSERT INTO #FINAL_RNT_VIG_OUTPUT 
(
	UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
	SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity, COMMENT
)
SELECT 
	UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
	SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity,
	COMMENT =
	CASE
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity = RnT_Quantity) THEN 'Ok'		
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity > RnT_Quantity) THEN 'Transaction Mismatched. R & T Data Lower.'
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity < RnT_Quantity) THEN 'Transaction Mismatched. R & T Data Higher.'
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity IS NULL) AND (RnT_Quantity <> 0 OR RnT_Quantity IS NOT NULL) THEN 'Transaction Mismatched. Vigilante Data Not Found (Holding Not Found).'
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity <> 0 OR Quantity IS NOT NULL) AND (RnT_Quantity IS NULL) THEN 'Transaction Mismatched. R & T Data Not Found (Holding Not Found).'
		WHEN (PAN = RnT_PAN) AND UserInfoId IS NULL THEN 'Transaction Mismatched. Vigilante Data Not Found.'
		WHEN (RnT_PAN IS NULL) THEN 'Transaction Mismatched. R & T Data Not Found.'
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber <> RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID)  THEN 'Transaction Mismatched. Traded with Non registered Demat Account.' 
		WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID <> RnT_DPID)  THEN 'Transaction Mismatched. Traded with Non registered DPID' 
		
	END	
	FROM #RNT_VIG_DATA
	
	
SELECT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
	SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity, COMMENT
FROM #FINAL_RNT_VIG_OUTPUT


DROP TABLE #RNT_VIG_DATA

DROP TABLE #FINAL_RNT_VIG_OUTPUT
END
