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
