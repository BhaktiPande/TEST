/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	15-Mar-2016
	Description :	This stored Procedure is used to get Employee Details based on settings
	
	EXEC st_du_GetEmployeeDetails 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_GetEmployeeDetails')
	DROP PROCEDURE st_du_GetEmployeeDetails
GO

CREATE PROCEDURE st_du_GetEmployeeDetails
	@EmployeeDetailsAxisBank du_type_EmployeeDetailsAxisBank READONLY
AS	
BEGIN
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_YESBANK VARCHAR(50) = 'YESBANK'	
	SET NOCOUNT ON;
	IF(CHARINDEX(@FIND_YESBANK,@DBNAME) > 0)
	BEGIN
		SELECT 
			EMPLOYEE_NUMBER as UserInfoId, 
  			[USER_NAME] AS LoginID,     
  			EMPLOYEE_NUMBER AS UserName,  
			FIRST_NAME, MIDDLE_NAMES, LAST_NAME,
			CITY, PINCODE, MOBILE_NO, CASE WHEN DateOfSeparation IS NOT NULL AND DateOfSeparation <> '' THEN '' ELSE OFFICIAL_EMAIL_ID END AS OFFICIAL_EMAIL_ID, PAN_NUMBER, ID.ROLE_NAME, DATE_OF_JOINING , 
			CASE WHEN UPPER(DEPT.Category) = 'DESIGNATED EMPLOYEE' OR UPPER(DESIG.Category) = 'DESIGNATED EMPLOYEE' THEN
			CASE 
				WHEN CONVERT(DATE, DATE_OF_JOINING) <= CONVERT(DATE, '15-MAY-2015') 
				THEN CONVERT(DATE, '15-MAY-2015') 
				ELSE DATE_OF_JOINING 
			END 
			ELSE
				NULL
			END AS DateOfBecomingInsider, 
			
			GRADE_NAME, DEPARTMENT, 
			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.RoleName
			WHEN DEPT.RoleName IS NOT NULL THEN DEPT.RoleName
			WHEN DESIG.RoleName IS NOT NULL THEN DESIG.RoleName  
			ELSE 'Non Designated Employee'
			END AS ROLENAME,

			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.Category
			WHEN DEPT.Category IS NOT NULL THEN DEPT.Category
			WHEN DESIG.Category IS NOT NULL THEN DESIG.Category  
			ELSE 'Non Designated Employee'
			END AS Category,


			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.SubCategory
			WHEN DEPT.SubCategory IS NOT NULL THEN DEPT.SubCategory
			WHEN DESIG.SubCategory IS NOT NULL THEN DESIG.SubCategory  
			ELSE 'Employee'
			END AS SubCategory,
			DateOfSeparation, CASE WHEN (DateOfSeparation IS NOT NULL AND DateOfSeparation <> '') AND (ReasonForSeparation = '' OR ReasonForSeparation IS NULL) THEN 'No Reasons from HRIS' ELSE ReasonForSeparation END AS ReasonForSeparation, 
			NoOfDaysToBeActive

		FROM 
			@EmployeeDetailsAxisBank ID 

		LEFT OUTER JOIN (SELECT DISTINCT FROMHRMS_DEPT, RoleName, Category, SubCategory FROM du_MappingValuesException) DEPT ON DEPARTMENT = FromHRMS_DEPT 
		LEFT OUTER JOIN (SELECT DISTINCT FromHRMS_DESIGNATION, RoleName, Category, SubCategory FROM du_MappingValuesException) DESIG ON GRADE_NAME = FromHRMS_DESIGNATION
	END	
	ELSE
	BEGIN
		SELECT 
			EMPLOYEE_NUMBER as UserInfoId, 
  		[USER_NAME] AS LoginID,     
  			EMPLOYEE_NUMBER AS UserName,  
			FIRST_NAME, MIDDLE_NAMES, LAST_NAME,
			CITY, PINCODE, MOBILE_NO, OFFICIAL_EMAIL_ID, PAN_NUMBER, ID.ROLE_NAME, DATE_OF_JOINING , 
			CASE WHEN UPPER(DEPT.Category) = 'DESIGNATED EMPLOYEE' OR UPPER(DESIG.Category) = 'DESIGNATED EMPLOYEE' THEN
			CASE 
				WHEN CONVERT(DATE, DATE_OF_JOINING) <= CONVERT(DATE, '15-MAY-2015') 
				THEN CONVERT(DATE, '15-MAY-2015') 
				ELSE DATE_OF_JOINING 
			END 
			ELSE
				NULL
			END AS DateOfBecomingInsider, 
			
			GRADE_NAME, DEPARTMENT, 
			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.RoleName
			WHEN DEPT.RoleName IS NOT NULL THEN DEPT.RoleName
			WHEN DESIG.RoleName IS NOT NULL THEN DESIG.RoleName  
			ELSE 'Non Designated Employee'
			END AS ROLENAME,

			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.Category
			WHEN DEPT.Category IS NOT NULL THEN DEPT.Category
			WHEN DESIG.Category IS NOT NULL THEN DESIG.Category  
			ELSE 'Non Designated Employee'
			END AS Category,


			CASE 
			WHEN 
				DESIG.FromHRMS_DESIGNATION IS NOT NULL AND 
				(UPPER(DESIG.FromHRMS_DESIGNATION) = 'SENIOR VICE PRESIDENT' OR 
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'EXECUTIVE VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'VICE PRESIDENT' OR
				UPPER(DESIG.FromHRMS_DESIGNATION) = 'PRESIDENT') THEN DESIG.SubCategory
			WHEN DEPT.SubCategory IS NOT NULL THEN DEPT.SubCategory
			WHEN DESIG.SubCategory IS NOT NULL THEN DESIG.SubCategory  
			ELSE 'Employee'
			END AS SubCategory,
			DateOfSeparation, ReasonForSeparation, NoOfDaysToBeActive

		FROM 
			@EmployeeDetailsAxisBank ID 

		LEFT OUTER JOIN (SELECT DISTINCT FROMHRMS_DEPT, RoleName, Category, SubCategory FROM du_MappingValuesException) DEPT ON DEPARTMENT = FromHRMS_DEPT 
		LEFT OUTER JOIN (SELECT DISTINCT FromHRMS_DESIGNATION, RoleName, Category, SubCategory FROM du_MappingValuesException) DESIG ON GRADE_NAME = FromHRMS_DESIGNATION
	END
			
	SET NOCOUNT OFF;
END