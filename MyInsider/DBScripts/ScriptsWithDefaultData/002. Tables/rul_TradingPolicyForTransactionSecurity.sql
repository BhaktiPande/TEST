/****** Object:  Table [dbo].[rul_TradingPolicyForTransactionSecurity]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_TradingPolicyForTransactionSecurity](
	[TradingPolicyId] [int] NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[TransactionModeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
 CONSTRAINT [PK_rul_TradingPolicyForTransactionSecurity] PRIMARY KEY CLUSTERED 
(
	[TradingPolicyId] ASC,
	[MapToTypeCodeId] ASC,
	[TransactionModeCodeId] ASC,
	[SecurityTypeCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_TransactionModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_TransactionModeCodeId] FOREIGN KEY([TransactionModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_com_Code_TransactionModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_com_Code_TransactionModeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_rul_TradingPolicy_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicyForTransactionSecurity_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicyForTransactionSecurity]'))
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_rul_TradingPolicy_TradingPolicyId]
GO
