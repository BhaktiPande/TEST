GO
/****** Object:  Table [dbo].[rul_TradingPolicyForSecurityMode_OS]    Script Date: 2/6/2019 5:41:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rul_TradingPolicyForSecurityMode_OS](
	[TradingPolicyId] [int] NOT NULL,
	[MapToTypeCodeID] [int] NOT NULL,
	[SecurityTypeCodeID] [int] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[rul_TradingPolicyForSecurityMode_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForSecurityMode_OS_rul_TradingPolicy_OS_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
ALTER TABLE [dbo].[rul_TradingPolicyForSecurityMode_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForSecurityMode_OS_rul_TradingPolicy_OS_TradingPolicyId]
GO
