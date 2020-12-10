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
	DIN nvarchar(50)
)

--drop type MassNonEmployeeInsiderImportDataTable
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

--drop type MassCorpEmployeeInsiderImportDataTable
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

--06.MassRelativesImportDataTable
--drop type [MassRelativesImportDataTable]
IF EXISTS (SELECT NAME FROM SYS.TYPES WHERE NAME = 'MassRelativesImportDataTable')
	DROP TYPE MassRelativesImportDataTable
	
CREATE TYPE [dbo].[MassRelativesImportDataTable] AS TABLE(
	UserInfoIdRelative	INT NULL,
	UserInfoId nVARCHAR(50) NULL,
	RelationTypeCodeId INT NULL,
	[FirstName] [nvarchar](100) NULL,
	[MiddleName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[AddressLine1] [nvarchar](1000) NULL,
	[CountryId] [int] NULL,
	[PinCode] [nvarchar](50) NULL,
	[MobileNumber] [nvarchar](30) NULL,
	[EmailAddress] [nvarchar](500) NULL,
	[PAN] [nvarchar](50) NULL
)


--08.IndividualDmatDetailsDataTable
/*
The datatable used for transfering the individual DMAT details 
for employees or relatives from excel to Procedure call
*/
--drop type [dbo].[IndividualDmatDetailsDataTable] 
IF EXISTS (SELECT NAME FROM SYS.TYPES WHERE NAME = 'IndividualDmatDetailsDataTable')
	DROP TYPE IndividualDmatDetailsDataTable
	
CREATE TYPE [dbo].[IndividualDmatDetailsDataTable] AS TABLE(
	DEMATDetailsId [int] NULL,
	UserInfoId [int] NULL,
	DEMATAccountNumber nvarchar(50) NULL,
	DPBankName [nvarchar](200) NULL,
	DPID [nvarchar](50) NULL,
	TMID [nvarchar](50) NULL,
	Description [nvarchar](200) NULL,
	AccountType [int] NULL
)

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (181, '181 MassUpload_TableTypes_create', 'Create MassUpload_TableTypes', 'Raghvendra')
