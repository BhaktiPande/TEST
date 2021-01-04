-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 19-NOV-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR R & T REPORT												=
-- EXEC st_RnTReport																					=
-- ======================================================================================================

/*
ED			4-Feb-2016	Code integration done on 4-Feb-2016
ED			1-Mar-2016	Code integration done on 1-Mar-2016
Raghvendra	07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Priyanka    22-05-2016  Changed SPROC-fetched records from tra_transactionSummaryDmatwise.
*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_RnTReport')
	DROP PROCEDURE st_RnTReport
GO
CREATE PROCEDURE st_RnTReport
AS
BEGIN
    DECLARE @nPeriodCodeId INT = 124001
	CREATE TABLE #RNT_VIG_DATA
	(
		UserInfoId					INT, 
		EmployeeId					VARCHAR(300), 
		EmployeeName				NVARCHAR(300), 
		Designation					NVARCHAR(300), 
		Grade						VARCHAR(300), 
		Location					VARCHAR(300),
		Department					VARCHAR(300),
		CompanyName					NVARCHAR(300),
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
	CREATE TABLE #RNT_New_DATA
	(
		UserInfoId					INT, 
		EmployeeId					VARCHAR(300), 
		EmployeeName				NVARCHAR(300), 
		Designation					NVARCHAR(300), 
		Grade						VARCHAR(300), 
		Location					VARCHAR(300),
		Department					VARCHAR(300),
		CompanyName					NVARCHAR(300),
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
	CREATE TABLE #RNT_ALL_DATA
	(
		UserInfoId					INT, 
		EmployeeId					VARCHAR(300), 
		EmployeeName				NVARCHAR(300), 
		Designation					NVARCHAR(300), 
		Grade						VARCHAR(300), 
		Location					VARCHAR(300),
		Department					VARCHAR(300),
		CompanyName					NVARCHAR(300),
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

	INSERT INTO #RNT_VIG_DATA--Dont change this two queries
	(
		UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
	)
	SELECT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
	FROM
	(--compared vigilante data with rnt data
		SELECT DISTINCT UI.UserInfoId AS UserInfoId, 
			ISNULL(UI.EmployeeId,'') AS EmployeeId, 
			ISNULL(UI.FirstName + ' ' + UI.LastName,'') AS EmployeeName,
			ISNULL(CDesignation.CodeName, UI.DesignationText) AS Designation, 
			ISNULL(ISNULL(CGrade.CodeName,UI.GradeText),'') AS Grade, 
			ISNULL(ISNULL(UI_B.Location, UI.Location),'') AS Location,
			ISNULL(ISNULL(CDepartment.CodeName,UI.DepartmentText),'') AS Department,
			ISNULL(MCompany.CompanyName,'') AS CompanyName,
			CInsider.CodeName AS TypeofInsider,
			ISNULL(CRelation.CodeName,'') AS RelationWithEmployee,
			ISNULL(UI_B.FirstName,'') + ' ' + ISNULL(UI_B.LastName,'') AS ReletiveName,
			CASE WHEN UI_B.FirstName IS NOT NULL THEN UI_B.PAN ELSE UI.PAN END AS PAN,
			CSecurity.CodeName AS SecurityType,
			CSecurity.CodeID AS SecurityTypeCode,
			TSD.ClosingBalance as Quantity,
			CASE WHEN UDD.DPID IS NULL THEN UDD2.DPID ELSE UDD.DPID END AS DPID,
			CASE WHEN UDD.DEMATAccountNumber IS NULL THEN UDD2.DEMATAccountNumber ELSE UDD.DEMATAccountNumber END  AS DEMATAccountNumber,
			CASE WHEN RMS1.PANNumber IS NULL THEN RMS2.PANNumber ELSE RMS1.PANNumber END AS RnT_PAN,
			CASE WHEN RMS1.SecurityType IS NULL THEN RMS2.SecurityType ELSE RMS1.SecurityType END AS RnT_SecurityType,
			CASE WHEN RMS1.SecurityTypeCode IS NULL THEN RMS2.SecurityTypeCode ELSE RMS1.SecurityTypeCode END AS RnT_SecurityTypeCode,
			CASE WHEN RMS1.DPID IS NULL THEN RMS2.DPID ELSE RMS1.DPID END AS RnT_DPID, 
			CASE WHEN RMS1.DematAccountNo IS NULL THEN RMS2.DematAccountNo ELSE RMS1.DematAccountNo END AS RnT_DEMAT,
			CASE WHEN RMS1.Shares IS NULL THEN RMS2.Shares ELSE RMS1.Shares END AS RnT_Quantity
FROM tra_TransactionSummaryDMATWise TSD
			LEFT OUTER JOIN usr_UserInfo UI ON TSD.UserInfoId = UI.UserInfoId
			LEFT OUTER JOIN usr_UserInfo UI_B ON TSD.UserInfoIdRelative = UI_B.UserInfoId AND UI_B.UserInfoId<>UI.UserInfoId
			LEFT OUTER JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId AND UI_B.UserInfoId<>UI.UserInfoId
			LEFT OUTER JOIN com_Code CRelation ON CRelation.CodeID = UR.RelationTypeCodeId
			LEFT OUTER JOIN com_Code CSecurity ON TSD.SecurityTypeCodeId = CSecurity.CodeID
			LEFT OUTER JOIN com_Code CDesignation ON UI.DesignationId = CDesignation.CodeID
			LEFT OUTER JOIN com_Code CGrade ON UI.GradeId = CGrade.CodeID
			LEFT OUTER JOIN com_Code CDepartment ON UI.DepartmentId = CDepartment.CodeID
			LEFT OUTER JOIN com_Code CInsider ON UI.UserTypeCodeId = CInsider.CodeId
			LEFT OUTER JOIN mst_Company MCompany ON UI.CompanyId = MCompany.CompanyId
			LEFT OUTER JOIN usr_DMATDetails UDD ON UDD.DMATDetailsID=TSD.DMATDetailsID AND UDD.UserInfoID=UI.UserInfoId
			LEFT OUTER JOIN usr_DMATDetails UDD2 ON UDD2.DMATDetailsID=TSD.DMATDetailsID AND UDD2.UserInfoID=UI_B.UserInfoId
			LEFT OUTER JOIN rnt_MassUploadDetails RMS1 ON CSecurity.CodeName = RMS1.SecurityType AND UDD.DEMATAccountNumber=RMS1.DematAccountNo AND RMS1.PANNumber=UI.PAN
			LEFT OUTER JOIN rnt_MassUploadDetails RMS2 ON CSecurity.CodeName = RMS2.SecurityType AND UDD2.DEMATAccountNumber=RMS2.DematAccountNo AND RMS2.PANNumber=UI_B.PAN
WHERE TSD.PeriodCodeId=@nPeriodCodeId AND TSD.YearCodeId in(SELECT MAX(YearCodeId) FROM tra_TransactionSummaryDMATWise WHERE UserInfoId=TSD.UserInfoId AND SecurityTypeCodeId=TSD.SecurityTypeCodeId GROUP BY SecurityTypeCodeId) 
UNION
--compared rnt data with vigilante data
SELECT DISTINCT CASE
				WHEN UIRELATIVE.UserInfoId IS NOT NULL THEN (SELECT UR.UserInfoId FROM usr_UserInfo UI LEFT JOIN usr_UserRelation UR ON UI.UserInfoId=UR.UserInfoIdRelative WHERE UR.UserInfoIdRelative=UIRELATIVE.UserInfoId)
				ELSE UIUser.UserInfoId END AS userInfoId,
				CASE
				WHEN UIRELATIVE.UserInfoId IS NOT NULL THEN (SELECT EmployeeId FROM USR_USERINFO WHERE USERINFOID=(SELECT UR.UserInfoId FROM usr_UserInfo UI LEFT JOIN usr_UserRelation UR ON UI.UserInfoId=UR.UserInfoIdRelative WHERE UR.UserInfoIdRelative=UIRELATIVE.UserInfoId))
				ELSE UIUser.EmployeeId END  AS EmployeeId,
				CASE
				WHEN UIRELATIVE.UserInfoId IS NOT NULL 
				THEN (SELECT FirstName FROM USR_USERINFO WHERE USERINFOID=(SELECT UR.UserInfoId FROM usr_UserInfo UI LEFT JOIN usr_UserRelation UR ON UI.UserInfoId=UR.UserInfoIdRelative WHERE UR.UserInfoIdRelative=UIRELATIVE.UserInfoId))+' '+(SELECT FirstName FROM USR_USERINFO WHERE USERINFOID=(SELECT UR.UserInfoId FROM usr_UserInfo UI LEFT JOIN usr_UserRelation UR ON UI.UserInfoId=UR.UserInfoIdRelative WHERE UR.UserInfoIdRelative=UIRELATIVE.UserInfoId))
				ELSE UIUser.FirstName+ ' '+UIUser.LastName END as EmployeeName,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDesignation.CodeName ELSE CDesignation.CodeName END as Designation,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RGrade.CodeName ELSE CGrade.CodeName END AS Grade,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UserOfReletive.Location ELSE UIUser.Location END AS Location,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDepartment.CodeName ELSE CDepartment.CodeName END AS Department,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RCompany.CompanyName ELSE MCompany.CompanyName END AS CompanyName,
			    CInsider.CodeName AS TypeofInsider,
				CASE WHEN UserRelationCode.CodeName IS NOT NULL THEN UserRelationCode.CodeName ELSE '' END AS RelationWithEmployee,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRELATIVE.FirstName+' '+UIRelative.LastName ELSE '' END as ReletiveName,
				CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.PAN ELSE UIUser.PAN END as PAN,
				CSecurity.CodeName AS SecurityType,
				CSecurity.CodeID AS SecurityTypeCode,
				TSD.ClosingBalance AS Quantity,
				UDD.DPID AS DPID, 	
				UDD.DEMATAccountNumber AS DEMATAccountNumber,
				RMS.PANNumber AS RnT_PAN,
				RMS.SecurityType AS RnT_SecurityType,
				RMS.SecurityTypeCode AS RnT_SecurityTypeCode,
				RMS.DPID AS RnT_DPID,
				RMS.DematAccountNo AS RnT_DEMAT,
				RMS.Shares AS RnT_Quantity
		FROM rnt_MassUploadDetails RMS
			LEFT OUTER JOIN usr_UserInfo UIUser ON UIUser.UserInfoId=(SELECT UserInfoId FROM usr_UserInfo WHERE PAN=RMS.PANNumber)--USER
			LEFT OUTER JOIN usr_UserRelation URRelative ON URRelative.UserInfoIdRelative= (SELECT UserInfoId FROM usr_UserInfo WHERE PAN=RMS.PANNumber)
			LEFT OUTER JOIN usr_UserInfo UIRelative ON UIRelative.UserInfoId=URRelative.UserInfoIdRelative--RELATIVE
			LEFT OUTER JOIN usr_UserInfo UserOfReletive ON UserOfReletive.UserInfoId=(SELECT UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=UIRelative.UserInfoId)--TO FIND RELATION
			LEFT OUTER JOIN com_Code UserRelationCode ON URRelative.RelationTypeCodeId=UserRelationCode.CodeID
			LEFT OUTER JOIN usr_DMATDetails UDD ON UIUSER.UserInfoId = UDD.UserInfoID and UDD.DMATDetailsID=(SELECT DMATDetailsID FROM USR_DMATDetails WHERE DEMATAccountNumber=RMS.DematAccountNo)
			LEFT OUTER JOIN tra_TransactionSummaryDMATWise TSD ON TSD.SecurityTypeCodeId=RMS.SecurityTypeCode AND UDD.DMATDetailsID=TSD.DMATDetailsID 
			AND TSD.PeriodCodeId=@nPeriodCodeId AND TSD.YearCodeId=(SELECT MAX(YearCodeId) FROM tra_TransactionSummaryDMATWise WHERE UserInfoId=TSD.UserInfoId AND SecurityTypeCodeId=TSD.SecurityTypeCodeId GROUP BY SecurityTypeCodeId)  
			LEFT OUTER JOIN com_Code CSecurity ON RMS.SecurityTypeCode = CSecurity.CodeID
			LEFT OUTER JOIN com_Code CDesignation ON UIUser.DesignationId = CDesignation.CodeID
			LEFT OUTER JOIN COM_CODE RDesignation ON UserOfReletive.DesignationId=RDesignation.CodeID
			LEFT OUTER JOIN com_Code CGrade ON UIUser.GradeId = CGrade.CodeID
			LEFT OUTER JOIN com_Code RGrade ON UserOfReletive.GradeId = RGrade.CodeID
			LEFT OUTER JOIN com_Code CDepartment ON UIUser.DepartmentId = CDepartment.CodeID
			LEFT OUTER JOIN com_Code RDepartment ON UserOfReletive.DepartmentId = RDepartment.CodeID
			LEFT OUTER JOIN com_Code CInsider ON UIUser.UserTypeCodeId = CInsider.CodeId
			--LEFT OUTER JOIN com_Code RInsider ON UserOfReletive.SubCategory = RInsider.CodeId
			LEFT OUTER JOIN mst_Company MCompany ON UIUser.CompanyId = MCompany.CompanyId
			LEFT OUTER JOIN mst_Company RCompany ON UserOfReletive.CompanyId = RCompany.CompanyId
) TEMP_OUTPUT 

INSERT INTO #RNT_New_DATA
--Find new users and users whose initial disclousre is not submitted
SELECT CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.UserInfoId ELSE UI.UserInfoId END AS UserInfoID,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.EmployeeId ELSE UI.EmployeeId END AS EmployeeId,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.FirstName +' '+ UIRelative.LastName ELSE UI.FirstName +' '+ UI.LastName END AS EmployeeName,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDesignation.CodeName ELSE UDesignation.CodeName END AS Designation,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RGrade.CodeName ELSE UGrade.CodeName END AS Grade,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.Location ELSE UI.Location END AS Location,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDepartment.CodeName ELSE UDepartment.CodeName END AS Department,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RCompany.CompanyName ELSE UCompany.CompanyName END AS CompanyName,
		UInsider.CodeName AS TypeofInsider,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UserRelationCode.CodeName ELSE ' ' END AS RelationWithEmployee,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UI.FirstName +' '+ UI.LastName ELSE ' ' END AS ReletiveName,
		UI.PAN AS PAN,
		'SecurityType' AS SecurityType,
		'1111' AS SecurityTypeCode,
		NULL AS Quantity,
		UDD.DPID AS DPID,
		UDD.DEMATAccountNumber AS DEMATAccountNumber,
		RMS.PANNumber AS RnT_PAN,
		RMS.SecurityType AS RnT_SecurityType,
		RMS.SecurityTypeCode AS RnT_SecurityTypeCode,
		RMS.DPID AS RnT_DPID,
		RMS.DematAccountNo AS RnT_DEMAT,
		RMS.Shares AS RnT_Quantity
		FROM usr_UserInfo UI--ALL USERS
		LEFT JOIN usr_UserRelation URRelative ON URRelative.UserInfoIdRelative = UI.UserInfoId
		LEFT JOIN usr_UserInfo UIRelative ON UIRelative.UserInfoId = URRelative.UserInfoId--RELATIVE'S USER
		LEFT JOIN com_Code UDesignation ON UDesignation.CodeID = UI.DesignationId
		LEFT JOIN com_Code RDesignation ON RDesignation.CodeID = UIRelative.DesignationId
		LEFT JOIN com_Code UGrade ON UGrade.CodeID = UI.GradeId
		LEFT JOIN com_Code RGrade ON RGrade.CodeID = UIRelative.GradeId
		LEFT JOIN com_Code UDepartment ON UDepartment.CodeID = UI.DepartmentId
		LEFT JOIN com_Code RDepartment ON RDepartment.CodeID = UIRelative.DepartmentId
		LEFT JOIN com_Code UInsider ON UInsider.CodeId = UI.UserTypeCodeId
		--LEFT JOIN com_Code RInsider ON RInsider.CodeId = UIRelative.SubCategory
		LEFT JOIN mst_Company UCompany ON UCompany.CompanyId = UI.CompanyId
		LEFT JOIN mst_Company RCompany ON  RCompany.CompanyId = UIRelative.CompanyId 
		LEFT JOIN com_Code UserRelationCode ON URRelative.RelationTypeCodeId=UserRelationCode.CodeID
		LEFT JOIN usr_DMATDetails UDD ON UDD.UserInfoID = UI.UserInfoId
		LEFT JOIN rnt_MassUploadDetails RMS ON RMS.PANNumber = UI.PAN AND UDD.DEMATAccountNumber IS NULL OR RMS.DematAccountNo = UDD.DEMATAccountNumber
		WHERE UI.UserInfoId NOT IN(SELECT UserInfoId FROM tra_TransactionMaster WHERE DisclosureTypeCodeId=147001 AND TransactionStatusCodeId!=148002)
				AND UI.UserTypeCodeId NOT IN (101001,101002,101005,101007)
				OR UI.UserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoID IN (SELECT UserInfoID--to remove user from query,query showing relatives whose users done transaction
					FROM usr_UserInfo WHERE UserInfoId NOT IN(SELECT UserInfoId FROM tra_TransactionMaster 
					WHERE DisclosureTypeCodeId=147001 AND TransactionStatusCodeId!=148002)
					AND UserTypeCodeId NOT IN (101001,101002,101005,101007)))
UNION
--Find users whose noholding flag is set and No continuous disclosure transaction is entered
SELECT CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.UserInfoId ELSE UI.UserInfoId END AS UserInfoID,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.EmployeeId ELSE UI.EmployeeId END AS EmployeeId,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.FirstName +' '+ UIRelative.LastName ELSE UI.FirstName +' '+ UI.LastName END AS EmployeeName,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDesignation.CodeName ELSE UDesignation.CodeName END AS Designation,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RGrade.CodeName ELSE UGrade.CodeName END AS Grade,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UIRelative.Location ELSE UI.Location END AS Location,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RDepartment.CodeName ELSE UDepartment.CodeName END AS Department,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN RCompany.CompanyName ELSE UCompany.CompanyName END AS CompanyName,
		UInsider.CodeName AS TypeofInsider,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UserRelationCode.CodeName ELSE ' ' END AS RelationWithEmployee,
		CASE WHEN UIRelative.UserInfoId IS NOT NULL THEN UI.FirstName +' '+ UI.LastName ELSE ' ' END AS ReletiveName,
		UI.PAN AS PAN,
		'SecurityType' AS SecurityType,
		'1111' AS SecurityTypeCode,
		0 AS Quantity,
		UDD.DPID AS DPID,
		UDD.DEMATAccountNumber AS DEMATAccountNumber,
		RMS.PANNumber AS RnT_PAN,
		RMS.SecurityType AS RnT_SecurityType,
		RMS.SecurityTypeCode AS RnT_SecurityTypeCode,
		RMS.DPID AS RnT_DPID,
		RMS.DematAccountNo AS RnT_DEMAT,
		RMS.Shares AS RnT_Quantity
		FROM usr_UserInfo UI--ALL USERS
		LEFT JOIN usr_UserRelation URRelative ON URRelative.UserInfoIdRelative = UI.UserInfoId
		LEFT JOIN usr_UserInfo UIRelative ON UIRelative.UserInfoId = URRelative.UserInfoId--RELATIVE'S USER
		LEFT JOIN com_Code UDesignation ON UDesignation.CodeID = UI.DesignationId
		LEFT JOIN com_Code RDesignation ON RDesignation.CodeID = UIRelative.DesignationId
		LEFT JOIN com_Code UGrade ON UGrade.CodeID = UI.GradeId
		LEFT JOIN com_Code RGrade ON RGrade.CodeID = UIRelative.GradeId
		LEFT JOIN com_Code UDepartment ON UDepartment.CodeID = UI.DepartmentId
		LEFT JOIN com_Code RDepartment ON RDepartment.CodeID = UIRelative.DepartmentId
		LEFT JOIN com_Code UInsider ON UInsider.CodeId = UI.UserTypeCodeId
		--LEFT JOIN com_Code RInsider ON RInsider.CodeId = UIRelative.SubCategory
		LEFT JOIN mst_Company UCompany ON UCompany.CompanyId = UI.CompanyId
		LEFT JOIN mst_Company RCompany ON  RCompany.CompanyId = UIRelative.CompanyId 
		LEFT JOIN com_Code UserRelationCode ON URRelative.RelationTypeCodeId=UserRelationCode.CodeID
		LEFT JOIN usr_DMATDetails UDD ON UDD.UserInfoID = UI.UserInfoId
		LEFT JOIN rnt_MassUploadDetails RMS ON RMS.PANNumber = UI.PAN AND UDD.DEMATAccountNumber IS NULL OR RMS.DematAccountNo = UDD.DEMATAccountNumber
		WHERE UI.UserInfoId IN (SELECT UserInfoID from tra_TransactionMaster WHERE NoHoldingFlag=1 
				AND UserInfoId NOT IN(select forUserInfoId from tra_TransactionDetails)
				AND UserInfoId NOT IN(select UserInfoId from tra_PreclearanceRequest))
				AND UI.UserTypeCodeId NOT IN (101001,101002,101005,101007)
				OR UI.UserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoID IN
					(SELECT UserInfoId FROM tra_TransactionMaster 
					WHERE NoHoldingFlag=1 
					AND UserInfoId NOT IN(select forUserInfoId from tra_TransactionDetails)
					AND UserInfoId NOT IN(select UserInfoId from tra_PreclearanceRequest)))
		ORDER BY UserInfoID	
			
		UPDATE #RNT_VIG_DATA SET SecurityType='', SecurityTypeCode='' WHERE	UserInfoId in (SELECT UserInfoId FROM #RNT_New_DATA)
		
		DELETE FROM #RNT_VIG_DATA WHERE UserInfoId in (SELECT UserInfoId FROM #RNT_New_DATA) AND DEMATAccountNumber IS NOT NULL
		
		UPDATE #RNT_New_DATA SET SecurityType = REPLACE(SecurityType,'SecurityType',' '),SecurityTypeCode = REPLACE(SecurityTypeCode,'1111',' ')
		
		INSERT INTO #RNT_ALL_DATA 
		SELECT DISTINCT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
		FROM (
		SELECT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
		FROM #RNT_VIG_DATA
		UNION
		SELECT UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity
		FROM #RNT_New_DATA	
		) AS AllData
		
		UPDATE #RNT_ALL_DATA SET SecurityType = REPLACE(SecurityType,'SecurityType',' '),SecurityTypeCode = REPLACE(SecurityTypeCode,'1111',' ')
		
	INSERT INTO rnt_MassUploadHistory 
	(
		UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity, COMMENT,RntUploadDate
	)
	SELECT 
		UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, ReletiveName, PAN, 
		SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, RnT_DEMAT,RnT_Quantity,
		COMMENT =
		CASE
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity = RnT_Quantity) THEN 'Ok.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (DPID = RnT_DPID) AND (Quantity = 0) AND (RnT_Quantity = 0) THEN 'Ok.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity = 0) AND (RnT_Quantity IS NULL) THEN 'OK- Holdings not available in R & T.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (DPID = RnT_DPID) AND (Quantity IS NULL) AND (RnT_Quantity = 0) THEN 'Ok- Holdings not entered on Vigilante'	
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity IS NULL) AND (RnT_Quantity IS NULL) THEN 'Holdings not entered on Vigilante and not found in R&T'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (DPID = RnT_DPID) AND (Quantity IS NULL) AND (RnT_Quantity <> 0 OR Quantity IS NOT NULL) THEN 'Transaction mismatch -Holdings not entered on Vigilante'	
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber IS NULL) AND (RnT_DEMAT IS NOT NULL) AND (DPID IS NULL) AND(RnT_DPID IS NOT NULL) AND (Quantity IS NULL) AND (RnT_Quantity <> 0 OR Quantity IS NOT NULL OR RnT_Quantity = 0) THEN 'Transaction mismatch. Demat details not updated in Vigilante. Traded with non registered demat account'													
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity > RnT_Quantity) THEN 'Transaction Mismatched. R & T Data Lower.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity < RnT_Quantity) THEN 'Transaction Mismatched. R & T Data Higher.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity IS NULL) AND (RnT_Quantity <> 0 OR RnT_Quantity IS NOT NULL) THEN 'Transaction Mismatched. Vigilante holding data not found. '
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID) AND (Quantity <> 0 OR Quantity IS NOT NULL) AND (RnT_Quantity IS NULL) THEN 'Transaction Mismatched. R & T Data Not Found (Holding Not Found).'
			WHEN (PAN = RnT_PAN) AND SecurityType IS NULL AND DPID IS NULL AND DEMATAccountNumber IS NULL THEN 'Transaction Mismatched. Vigilante Data Not Found.'
			WHEN (PAN IS NOT NULL)AND (DEMATAccountNumber IS NULL)  AND (RnT_PAN IS NULL) THEN 'No DEMAT A/C Record found with RTA'
			WHEN (PAN IS NOT NULL)AND (DEMATAccountNumber IS NOT NULL)  AND (RnT_PAN IS NULL) THEN 'Holdings not entered on Vigilante and not found in R&T.'
			WHEN (PAN = RnT_PAN) AND (SecurityType = RnT_SecurityType) AND (RnT_DEMAT IS NULL) AND (RnT_DPID IS NULL) THEN 'Transaction Mismatched. R & T Data Not Found.'
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber <> RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID = RnT_DPID)  THEN 'Transaction Mismatched. Traded with Non registered Demat Account.' 
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber = RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID <> RnT_DPID)  THEN 'Transaction Mismatched. Traded with Non registered DPID.' 
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber <> RnT_DEMAT) AND (SecurityType = RnT_SecurityType) AND (DPID <> RnT_DPID)  THEN 'Transaction Mismatched. Traded with Non registered DPID and Demat Account.' 			
			WHEN (PAN = RnT_PAN) AND (DEMATAccountNumber IS NULL) AND (DPID IS NULL) AND (Quantity IS NULL) THEN 'Transaction Mismatched. Traded with Non registered DPID and Demat Account.' 			 			
			WHEN (PAN IS NULL) THEN 'Transaction Mismatched. Vigilante Data not found'
		END,dbo.uf_com_GetServerDate()	
		FROM #RNT_ALL_DATA
	
	DROP TABLE #RNT_VIG_DATA
	DROP TABLE #RNT_New_DATA
	DROP TABLE #RNT_ALL_DATA
END

