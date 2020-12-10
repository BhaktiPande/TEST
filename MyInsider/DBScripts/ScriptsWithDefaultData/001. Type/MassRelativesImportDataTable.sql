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