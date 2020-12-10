IF EXISTS (SELECT NAME FROM SYS.TYPES WHERE NAME = 'MassCorpEmployeeInsiderImportDataTable')
	DROP TYPE MassCorpEmployeeInsiderImportDataTable
	
CREATE TYPE MassCorpEmployeeInsiderImportDataTable AS TABLE 
(
	UserInfoId INT,
	LoginId  nvarchar(100),
	CompanyId INT,
	AddressLine1 nvarchar(1000),
	PinCode nvarchar(50),
	CountryId INT,
	EmailAddress nvarchar(500),
	PAN nvarchar(50),
	RoleId INT,
	TAN nvarchar(50),
	DateOfBecomingInsider datetime,
	Description nvarchar(1024),
	ContactPerson nvarchar(100),
	Website  nvarchar(500),
	DesignationText nvarchar(50),
	Landline1   nvarchar(50),
	Landline2   nvarchar(50),
	CIN nvarchar(50)
)