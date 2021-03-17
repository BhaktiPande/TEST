IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassInitialDisclosure_OtherSecuritiesDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassInitialDisclosure_OtherSecuritiesDataTable
END
GO

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

