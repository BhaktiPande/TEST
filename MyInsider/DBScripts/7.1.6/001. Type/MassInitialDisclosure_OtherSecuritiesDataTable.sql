IF NOT EXISTS(SELECT 1 FROM sys.types WHERE is_table_type = 1 AND name ='MassInitialDisclosure_OtherSecuritiesDataTable')
	CREATE TYPE [dbo].[MassInitialDisclosure_OtherSecuritiesDataTable] AS TABLE(
		[TransactionMasterId] [int] NULL,
		[UserName] [nvarchar](250) NULL,
		[PANNumber] [nvarchar](100) NULL,
		[DateOfBecomingInsider] [datetime] NULL,
		[SecurityType] [int] NULL,
		[ModeOfAcquisation] [int] NULL,
		[DateOfIntimationToCompany] [datetime] NULL,
		[TradingForRelation] [int] NULL,
		[FirstNameLastName] [nvarchar](500) NULL,
		[DEMATAccountNo] [nvarchar](50) NULL,
		[StockExchange] [int] NULL,
		[PercentOfSecurities] [decimal](5, 2) NULL,
		[LotSize] [int] NULL,
		[NumberOfSecurities] [decimal](18, 0) NULL,
		[ValueOfSecurities] [decimal](18, 0) NULL,
		[ISIN] [nvarchar](50) NULL,
		[CompanyName] [nvarchar](500) NULL
	)
GO

