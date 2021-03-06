/****** Object:  Table [dbo].[rul_TradingPolicySecuritywiseLimits]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_TradingPolicySecuritywiseLimits](
	[TradingPolicyId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[NoOfShares] [int] NULL,
	[PercPaidSubscribedCap] [decimal](15, 4) NULL,
	[ValueOfShares] [decimal](18, 4) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits] CHECK CONSTRAINT [FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_rul_TradingPolicySecuritywiseLimits_NoValuePer_AllNotNull]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits]  WITH CHECK ADD  CONSTRAINT [CK_rul_TradingPolicySecuritywiseLimits_NoValuePer_AllNotNull] CHECK  (([NoOfShares] IS NOT NULL OR [PercPaidSubscribedCap] IS NOT NULL OR [ValueOfShares] IS NOT NULL))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_rul_TradingPolicySecuritywiseLimits_NoValuePer_AllNotNull]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicySecuritywiseLimits]'))
ALTER TABLE [dbo].[rul_TradingPolicySecuritywiseLimits] CHECK CONSTRAINT [CK_rul_TradingPolicySecuritywiseLimits_NoValuePer_AllNotNull]
GO
