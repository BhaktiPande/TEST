/*
	Created By  :	Akhilesh Kamate
	Created On 	:	12-Mar-2016
	Description :	This type is used to update seperation
	
*/

IF NOT EXISTS (SELECT 1 FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.schema_id = SS.schema_id WHERE (ST.name = N'du_type_EmployeeDetailsAxisBank') AND (SS.name = N'dbo'))
BEGIN
	CREATE TYPE du_type_EmployeeDetailsAxisBank AS TABLE 
	(
		EMPLOYEE_NUMBER VARCHAR(MAX), 
		USER_NAME VARCHAR(MAX), 
		FIRST_NAME  VARCHAR(MAX), 
		MIDDLE_NAMES  VARCHAR(MAX), 
		LAST_NAME VARCHAR(MAX), 
		CITY VARCHAR(MAX), 
		PINCODE VARCHAR(MAX), 
		MOBILE_NO VARCHAR(MAX),
		OFFICIAL_EMAIL_ID  VARCHAR(MAX), 
		PAN_NUMBER VARCHAR(MAX), 
		ROLE_NAME VARCHAR(MAX), 
		DATE_OF_JOINING VARCHAR(MAX), 
		GRADE_NAME VARCHAR(MAX), 
		DEPARTMENT VARCHAR(MAX), 
		DateOfSeparation VARCHAR(MAX), 
		ReasonForSeparation VARCHAR(MAX), 
		NoOfDaysToBeActive VARCHAR(MAX)
	)
	END
GO
