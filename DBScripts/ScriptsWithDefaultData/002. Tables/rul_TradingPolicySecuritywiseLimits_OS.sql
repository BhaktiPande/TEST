GO
/****** Object:  Table [dbo].[rul_TradingPolicySecuritywiseLimits_OS]    Script Date: 2/6/2019 5:55:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS](
	[TradingPolicyId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[NoOfShares] [int] NULL,
	[PercPaidSubscribedCap] [decimal](15, 4) NULL,
	[ValueOfShares] [decimal](18, 4) NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_com_Code_MapToTypeCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_com_Code_SecurityTypeCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_rul_TradingPolicy_OS_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_OS_rul_TradingPolicy_OS_TradingPolicyId]
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS]  WITH CHECK ADD  CONSTRAINT [CK_rul_TradingPolicySecuritywiseLimits_OS_NoValuePer_AllNotNull] CHECK  (([NoOfShares] IS NOT NULL OR [PercPaidSubscribedCap] IS NOT NULL OR [ValueOfShares] IS NOT NULL))
GO
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits_OS] CHECK CONSTRAINT [CK_rul_TradingPolicySecuritywiseLimits_OS_NoValuePer_AllNotNull]
GO
