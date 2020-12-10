
/****** Object:  Table [dbo].[rul_TradingPolicyForProhibitSecurityTypes_OS]    Script Date: 03/06/2019 01:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rul_TradingPolicyForProhibitSecurityTypes_OS](
	[TradingPolicyId] [int] NOT NULL,
	[SecurityTypeCodeID] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[rul_TradingPolicyForProhibitSecurityTypes_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicyForProhibitSecurityTypes_OS_rul_TradingPolicy_OS] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO

ALTER TABLE [dbo].[rul_TradingPolicyForProhibitSecurityTypes_OS] CHECK CONSTRAINT [FK_rul_TradingPolicyForProhibitSecurityTypes_OS_rul_TradingPolicy_OS]
GO


