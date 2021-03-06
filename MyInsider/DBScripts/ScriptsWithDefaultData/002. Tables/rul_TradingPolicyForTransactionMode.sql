/****** Object:  Table [dbo].[rul_TradingPolicyForTransactionMode]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_TradingPolicyForTransactionMode](
	[TradingPolicyId] [int] NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[TransactionModeCodeId] [int] NOT NULL,
 CONSTRAINT [PK_rul_TradingPolicyForTransactionMode] PRIMARY KEY CLUSTERED 
(
	[TradingPolicyId] ASC,
	[MapToTypeCodeId] ASC,
	[TransactionModeCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_com_Code_TransactionModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_com_Code_TransactionModeCodeId] FOREIGN KEY([TransactionModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_com_Code_TransactionModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_com_Code_TransactionModeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_rul_TradingPolicy_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionMode_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionMode]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionMode] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionMode_rul_TradingPolicy_TradingPolicyId]
GO
