IF EXISTS (SELECT NAME FROM SYS.TYPES WHERE NAME = 'MassNonEmployeeInsiderImportDataTable')
	DROP TYPE MassNonEmployeeInsiderImportDataTable
	
CREATE TYPE MassNonEmployeeInsiderImportDataTable AS TABLE 
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
	Location nvarchar(100),
	DIN nvarchar(50),
	CategoryText nVARCHAR(200),
	SubCategoryText nVARCHAR(200),
	GradeText nVARCHAR(200),
	DesignationText nVARCHAR(200),
	SubDesignationText nVARCHAR(200),
	DepartmentText nVARCHAR(200)
)
