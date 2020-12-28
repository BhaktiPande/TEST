--05.MassEmployeeImportDataTable
--drop type MassEmployeeInsiderImportDataTable

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
	DROP PROCEDURE st_com_MassUploadCommonProcedureExecution	

IF EXISTS (SELECT NAME FROM SYS.TYPES WHERE NAME = 'MassEmployeeInsiderImportDataTable')
	DROP TYPE MassEmployeeInsiderImportDataTable
	
CREATE TYPE MassEmployeeInsiderImportDataTable AS TABLE 
(
	UserInfoId INT,
	UserName nvarchar(250),
	LoginId  nvarchar(100),
	CompanyId INT,
	FirstName nvarchar(100),
	MiddleName nvarchar(100),
	LastName nvarchar(100),
	AddressLine1 nvarchar(1000),
	PinCode nvarchar(50),
	CountryId INT,
	MobileNumber nvarchar(30),
	EmailAddress nvarchar(500),
	PAN nvarchar(50),
	RoleId INT,
	DateOfJoining datetime,
	DateOfBecomingInsider datetime,
	Category INT,
	SubCategory INT,
	Grade INT,
	DesignationID INT,
	SubDesignationID INT,
	Location nvarchar(100),
	DepartmentID INT,
	DIN nvarchar(50),
	PersonalAddress  nvarchar(50)
)