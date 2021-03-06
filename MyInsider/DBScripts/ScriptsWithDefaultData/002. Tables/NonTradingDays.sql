/****** Object:  Table [dbo].[NonTradingDays]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NonTradingDays]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NonTradingDays](
	[NonTradDay] [datetime] NOT NULL,
	[Exchangetype] [int] NOT NULL,
	[Reason] [varchar](200) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NonTradingDays_com_Code_Exchangetype]') AND parent_object_id = OBJECT_ID(N'[dbo].[NonTradingDays]'))
ALTER TABLE [dbo].[NonTradingDays]  WITH CHECK ADD  CONSTRAINT [FK_NonTradingDays_com_Code_Exchangetype] FOREIGN KEY([Exchangetype])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NonTradingDays_com_Code_Exchangetype]') AND parent_object_id = OBJECT_ID(N'[dbo].[NonTradingDays]'))
ALTER TABLE [dbo].[NonTradingDays] CHECK CONSTRAINT [FK_NonTradingDays_com_Code_Exchangetype]
GO
