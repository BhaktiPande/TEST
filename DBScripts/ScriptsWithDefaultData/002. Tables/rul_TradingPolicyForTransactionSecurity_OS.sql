GO
/****** Object:  Table [dbo].[rul_TradingPolicyForTransactionSecurity_OS]    Script Date: 2/6/2019 5:52:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS](
	[TradingPolicyId] [int] NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[TransactionModeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
 CONSTRAINT [PK_rul_TradingPolicyForTransactionSecurity_OS] PRIMARY KEY CLUSTERED 
(
	[TradingPolicyId] ASC,
	[MapToTypeCodeId] ASC,
	[TransactionModeCodeId] ASC,
	[SecurityTypeCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_MapToTypeCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_SecurityTypeCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_TransactionModeCodeId] FOREIGN KEY([TransactionModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_com_Code_TransactionModeCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_rul_TradingPolicy_OS_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
ALTER TABLE [dbo].[rul_TradingPolicyForTransactionSecurity_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForTransactionSecurity_OS_rul_TradingPolicy_OS_TradingPolicyId]
GO
