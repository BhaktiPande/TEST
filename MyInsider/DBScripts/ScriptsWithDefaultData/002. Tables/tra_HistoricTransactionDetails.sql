/****** Object:  Table [dbo].[tra_HistoricTransactionDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_HistoricTransactionDetails](
	[TransactionDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] [bigint] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[ForUserInfoId] [int] NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[SecuritiesPriorToAcquisition] [decimal](10, 0) NOT NULL,
	[PerOfSharesPreTransaction] [decimal](5, 2) NOT NULL,
	[DateOfAcquisition] [datetime] NOT NULL,
	[DateOfInitimationToCompany] [datetime] NOT NULL,
	[ModeOfAcquisitionCodeId] [int] NOT NULL,
	[PerOfSharesPostTransaction] [decimal](5, 2) NOT NULL,
	[ExchangeCodeId] [int] NOT NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[Quantity] [decimal](10, 0) NOT NULL,
	[Value] [decimal](10, 0) NOT NULL,
	[Quantity2] [decimal](10, 0) NOT NULL,
	[Value2] [decimal](10, 0) NOT NULL,
	[LotSize] [int] NOT NULL,
	[IsPLCReq] [int] NOT NULL,
	[ContractSpecification] [varchar](50) NULL,
 CONSTRAINT [PK_tra_HistoricTransactionDetails] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionDetails]'))
ALTER TABLE [dbo].[tra_HistoricTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_HistoricTransactionMaster] ([TransactionMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionDetails]'))
ALTER TABLE [dbo].[tra_HistoricTransactionDetails] CHECK CONSTRAINT [FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId]
GO
