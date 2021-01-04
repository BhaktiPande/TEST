
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 15-DEC-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR R & T HISTORY REPORT										=
-- EXEC st_RnTHistoryReport '2016-02-17',N'180,182',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL	=

/*ModifiedBy	Modified ON		Comment
ED			04-Jan-2016		Code merging done on 4-Jan-2016
ED			01-Mar-2016		Code merging done on 1-Mar-2016

*/
--Transaction Mismatched. R & T Data Higher.,Transaction Mismatched. Traded with Non registered Demat Account.
-- ======================================================================================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_RnTHistoryReport')
	DROP PROCEDURE st_RnTHistoryReport
GO

CREATE PROCEDURE st_RnTHistoryReport
(
	@HistoryDate			DATETIME,
	@EmployeeId				NVARCHAR(MAX) = NULL, 
	@EmployeeName			NVARCHAR(MAX) = NULL, 
	@Designation			NVARCHAR(MAX) = NULL, 
	@Grade					NVARCHAR(MAX) = NULL, 
	@Location				NVARCHAR(MAX) = NULL, 
	@Department				NVARCHAR(MAX) = NULL, 
	@CompanyName			NVARCHAR(MAX) = NULL, 
	@TypeofInsider			NVARCHAR(MAX) = NULL,
	@PAN					NVARCHAR(MAX) = NULL,
	@DPID					NVARCHAR(MAX) = NULL, 
	@DEMATAccountNumber 	NVARCHAR(MAX) = NULL,
	@SecurityType			NVARCHAR(MAX) = NULL,
	@COMMENT				NVARCHAR(MAX) = NULL,
	@EmpSepOrLive           NVARCHAR(MAX) = NULL,
	@EmpStatus              NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	PRINT @EmpStatus
	DECLARE @nEmployeeStatusLive            VARCHAR(100),
			@nEmployeeStatusSeparated       VARCHAR(100),
			@nEmployeeStatusInactive        VARCHAR(100),
			@nEmpStatusLiveCode             INT = 510001,
			@nEmpStatusSeparatedCode        INT = 510002,
			@nEmpStatusInactiveCode         INT = 510003,
			@nEmployeeActive                INT = 102001,
			@nEmployeeInActive              INT = 102002,
			@nEmpActive                     VARCHAR(100),
			@nEmpInActive                   VARCHAR(100)
	
	SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
			
	SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
			
	SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
			
	SELECT @nEmpActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeActive
			
	SELECT @nEmpInActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeInActive 	 
	
	BEGIN	
		CREATE TABLE #TEMP_EMPLOYEE_ID 
		(
			EMPLOYEE_ID NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_EMPLOYEE_ID 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE [PARAM] END FROM dbo.FN_VIGILANTE_SPLIT(@EmployeeId, ',')		
	END
	
	BEGIN	
		CREATE TABLE #TEMP_EMPLOYEE_NAME 
		(
			EMPLOYEE_NAME NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_EMPLOYEE_NAME 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@EmployeeName, ',')								
	END

	BEGIN	
		CREATE TABLE #TEMP_DESIGNATION
		(
			EMPLOYEE_DESIGNATION NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_DESIGNATION 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@Designation, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_@GRADE
		(
			EMPLOYEE_GRADE NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_@GRADE 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@Grade, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_LOCATION
		(
			EMPLOYEE_LOCATION NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_LOCATION 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@Location, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_DEPARTMENT
		(
			EMPLOYEE_DEPARTMENT NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_DEPARTMENT 
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@Department, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_COMPANYNAME
		(
			EMPLOYEE_COMPANY_NAME NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_COMPANYNAME
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@CompanyName, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_TYPEOFINSIDER
		(
			EMPLOYEE_TYPE_OF_INSIDER NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_TYPEOFINSIDER
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@TypeofInsider, ',')						
	END
		
	BEGIN	
		CREATE TABLE #TEMP_SECURITYTYPE
		(
			EMPLOYEE_SECURITY_TYPE NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_SECURITYTYPE
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@SecurityType, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_COMMENT
		(
			EMPLOYEE_COMMENT NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_COMMENT
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE [PARAM] END FROM dbo.FN_VIGILANTE_SPLIT(@COMMENT, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_LIVE_OR_SEPERATED
		(
			EMPLOYEE_LIVE_OR_SEPERATED NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_LIVE_OR_SEPERATED
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@EmpSepOrLive, ',')						
	END
	
	BEGIN	
		CREATE TABLE #TEMP_EMPLOYEE_STATUS
		(
			EMPLOYEE_STATUS NVARCHAR(1000)
		)
		
		INSERT INTO #TEMP_EMPLOYEE_STATUS
		SELECT CASE WHEN [PARAM] = '-' THEN '' ELSE REPLACE([PARAM],'|',',') END FROM dbo.FN_VIGILANTE_SPLIT(@EmpStatus, ',')						
	END
	
	
		INSERT INTO #TEMP_LOCATION VALUES ('')
		INSERT INTO #TEMP_DEPARTMENT VALUES ('')
	 --SELECT EMPLOYEE_ID FROM #TEMP_EMPLOYEE_ID		
	 --SELECT EMPLOYEE_NAME FROM #TEMP_EMPLOYEE_NAME
	 --SELECT EMPLOYEE_DESIGNATION FROM #TEMP_DESIGNATION
	 --SELECT EMPLOYEE_GRADE FROM #TEMP_@GRADE
	 --SELECT EMPLOYEE_LOCATION FROM #TEMP_LOCATION
	 --SELECT EMPLOYEE_DEPARTMENT FROM #TEMP_DEPARTMENT
	 --SELECT EMPLOYEE_COMPANY_NAME FROM #TEMP_COMPANYNAME
	 --SELECT EMPLOYEE_TYPE_OF_INSIDER FROM #TEMP_TYPEOFINSIDER
	 --SELECT EMPLOYEE_SECURITY_TYPE FROM #TEMP_SECURITYTYPE
	 --SELECT EMPLOYEE_COMMENT FROM #TEMP_COMMENT	 	
	
	CREATE TABLE #TEMP_REPORT_DATA(MassUploadHistoryId VARCHAR(200),UserInfoId VARCHAR(200), EmployeeId VARCHAR(200), EmployeeName nVARCHAR(200), Designation nVARCHAR(200), Grade VARCHAR(200), Location VARCHAR(200), Department VARCHAR(200), CompanyName nVARCHAR(200), TypeofInsider VARCHAR(200), RelationWithEmployee VARCHAR(200), 
			ReletiveName VARCHAR(200), PAN VARCHAR(200), SecurityType VARCHAR(200), SecurityTypeCode VARCHAR(200), Quantity VARCHAR(200), DPID VARCHAR(200), DEMATAccountNumber VARCHAR(200), RnT_PAN VARCHAR(200), RnT_SecurityType VARCHAR(200), RnT_SecurityTypeCode VARCHAR(200), RnT_DPID VARCHAR(200), 
			RnT_DEMAT VARCHAR(200), RnT_Quantity VARCHAR(200), COMMENT VARCHAR(200), RntUploadDate VARCHAR(200),
			LiveSeperated VARCHAR(200),
		    DateOfSeperation VARCHAR(200),
		    UserStatus VARCHAR(200))
	
	 INSERT INTO #TEMP_REPORT_DATA(MassUploadHistoryId,UserInfoId, EmployeeId, EmployeeName, Designation, Grade, Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, 
			ReletiveName, PAN, SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, 
			RnT_DEMAT, RnT_Quantity, COMMENT, RntUploadDate,
			LiveSeperated,
		    DateOfSeperation,
		    UserStatus)
	
	 SELECT	DISTINCT
			MassUploadHistoryId, RMUH.UserInfoId AS UserInfoId, RMUH.EmployeeId AS EmployeeId, EmployeeName, Designation, Grade, RMUH.Location AS Location, Department, CompanyName, TypeofInsider, RelationWithEmployee, 
			ReletiveName, RMUH.PAN AS PAN, SecurityType, SecurityTypeCode, Quantity, DPID, DEMATAccountNumber, RnT_PAN, RnT_SecurityType, RnT_SecurityTypeCode, RnT_DPID, 
			RnT_DEMAT, RnT_Quantity, COMMENT, RntUploadDate,
			CASE WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
			 WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
		     WHEN UF.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
		    END AS LiveSeperated,
		    UF.DateOfSeparation AS DateOfSeperation,
		    CCode.CodeName AS UserStatus
		    	    
	FROM 
		rnt_MassUploadHistory AS RMUH
			
		INNER JOIN #TEMP_EMPLOYEE_ID AS TED ON TED.EMPLOYEE_ID = ISNULL(RMUH.UserInfoId,'')
		INNER JOIN #TEMP_EMPLOYEE_NAME AS TEMP ON TEMP.EMPLOYEE_NAME= ISNULL(RMUH.UserInfoId,'')
		INNER JOIN #TEMP_DESIGNATION AS TDG ON TDG.EMPLOYEE_DESIGNATION = ISNULL(RMUH.Designation,'')
		INNER JOIN #TEMP_@GRADE AS TGE ON TGE.EMPLOYEE_GRADE = ISNULL(RMUH.Grade,'')
		INNER JOIN #TEMP_LOCATION AS TLOC ON TLOC.EMPLOYEE_LOCATION = ISNULL(RMUH.Location,'')
		INNER JOIN #TEMP_DEPARTMENT AS TDEPT ON TDEPT.EMPLOYEE_DEPARTMENT = ISNULL(RMUH.Department,'')
		INNER JOIN #TEMP_COMPANYNAME AS TCNM ON TCNM.EMPLOYEE_COMPANY_NAME = ISNULL(RMUH.CompanyName,'')
		LEFT JOIN #TEMP_TYPEOFINSIDER AS TINS ON TINS.EMPLOYEE_TYPE_OF_INSIDER = ISNULL(RMUH.TypeofInsider,'')
		INNER JOIN #TEMP_SECURITYTYPE AS TSECTYP ON UPPER(RTRIM(LTRIM(TSECTYP.EMPLOYEE_SECURITY_TYPE))) = ISNULL(RMUH.SecurityType,'')
		LEFT JOIN #TEMP_COMMENT AS TCOMT ON ISNULL(TCOMT.EMPLOYEE_COMMENT,'') = ISNULL(RMUH.COMMENT,'')
		INNER JOIN usr_UserInfo UF ON UF.UserInfoId= RMUH.UserInfoId
		LEFT JOIN com_Code CCode ON CCode.CodeID = UF.StatusCodeId

	WHERE 
		CONVERT(DATE,RntUploadDate) = CONVERT(DATE, @HistoryDate) 
		AND (RMUH.PAN = (CASE WHEN @PAN = '' THEN RMUH.PAN ELSE @PAN END) OR RnT_PAN = (CASE WHEN @PAN = '' THEN RnT_PAN ELSE @PAN END)) 	
		AND ((DPID = (CASE WHEN @DPID = '' THEN DPID ELSE @DPID END) OR DPID IS NULL) AND (RnT_DPID = (CASE WHEN @DPID = '' THEN RnT_DPID ELSE @DPID END) OR RnT_DPID IS NULL))
		AND ((DEMATAccountNumber IN ((CASE WHEN @DEMATAccountNumber = '' THEN DEMATAccountNumber ELSE @DEMATAccountNumber END)) OR DEMATAccountNumber IS NULL) AND (RnT_DEMAT IN ((CASE WHEN @DEMATAccountNumber = '' THEN RnT_DEMAT ELSE @DEMATAccountNumber END)) OR RnT_DEMAT IS NULL))	
		ORDER BY RMUH.EmployeeName		

	SELECT * FROM #TEMP_REPORT_DATA TRD 
	WHERE TRD.LiveSeperated IN (SELECT * FROM #TEMP_LIVE_OR_SEPERATED)
	AND TRD.UserStatus IN (SELECT * FROM #TEMP_EMPLOYEE_STATUS)
	
	SET NOCOUNT OFF;
END
GO
