
IF NOT EXISTS(SELECT 1 FROM sys.types WHERE is_table_type = 1 AND name ='MassTransactionImport_OtherSecuritiesDataTable')
   CREATE TYPE [dbo].[MassTransactionImport_OtherSecuritiesDataTable] AS TABLE(
   	  [TransactionMasterId] [int] NULL,
   	  [UserLoginName] [nvarchar](100) NULL,
   	  [RelationCodeId] [int] NULL,
   	  [FirstLastName] [nvarchar](55) NULL,
   	  [DateOfAcquisition] [datetime] NULL,
   	  [ModeOfAcquisitionCodeId] [int] NULL,
   	  [DateOfInitimationToCompany] [datetime] NULL,
   	  [SecuritiesHeldPriorToAcquisition] [decimal](18, 0) NULL,
   	  [DEMATAccountNo] [nvarchar](50) NULL,
   	  [ExchangeCodeId] [int] NULL,
   	  [TransactionTypeCodeId] [int] NULL,
   	  [SecurityTypeCodeId] [int] NULL,
   	  [PerOfSharesPreTransaction] [decimal](5, 2) NULL,
   	  [PerOfSharesPostTransaction] [decimal](5, 2) NULL,
   	  [Quantity] [decimal](18, 0) NULL,
   	  [Value] [decimal](18, 0) NULL,
   	  [ESOPQuantity] [decimal](18, 0) NULL,
   	  [OtherQuantity] [decimal](18, 0) NULL,
   	  [Quantity2] [decimal](18, 0) NULL,
   	  [Value2] [decimal](18, 0) NULL,
   	  [LotSize] [int] NULL,
   	  [ContractSpecification] [nvarchar](50) NULL,
   	  [ISIN] [nvarchar](50) NULL,
   	  [CompanyName] [nvarchar](500) NULL
   )
GO


