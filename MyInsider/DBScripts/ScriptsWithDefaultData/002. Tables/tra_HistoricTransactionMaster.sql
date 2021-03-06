/****** Object:  Table [dbo].[tra_HistoricTransactionMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_HistoricTransactionMaster](
	[TransactionMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[PreclearanceRequestId] [bigint] NULL,
	[UserInfoId] [int] NOT NULL,
	[DisclosureTypeCodeId] [int] NOT NULL,
	[NoHoldingFlag] [bit] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
 CONSTRAINT [PK_tra_HistoricTransactionMaster] PRIMARY KEY CLUSTERED 
(
	[TransactionMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionMaster]'))
ALTER TABLE [dbo].[tra_HistoricTransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId] FOREIGN KEY([PreclearanceRequestId])
REFERENCES [dbo].[tra_HistoricPreclearanceRequest] ([PreclearanceRequestId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_HistoricTransactionMaster]'))
ALTER TABLE [dbo].[tra_HistoricTransactionMaster] CHECK CONSTRAINT [FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId]
GO
