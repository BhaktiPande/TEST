/****** Object:  Table [dbo].[rpt_DefaulterReportComments]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportComments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReportComments](
	[DefaulterReportID] [bigint] NULL,
	[CommentCodeId] [int] NULL,
	[ContraTradeQty] [decimal](10, 0) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportComments_com_Code_CommentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportComments]'))
ALTER TABLE [dbo].[rpt_DefaulterReportComments]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReportComments_com_Code_CommentCodeId] FOREIGN KEY([CommentCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportComments_com_Code_CommentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportComments]'))
ALTER TABLE [dbo].[rpt_DefaulterReportComments] CHECK CONSTRAINT [FK_rpt_DefaulterReportComments_com_Code_CommentCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportComments_rpt_DefaulterReport_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportComments]'))
ALTER TABLE [dbo].[rpt_DefaulterReportComments]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReportComments_rpt_DefaulterReport_DefaulterReportID] FOREIGN KEY([DefaulterReportID])
REFERENCES [dbo].[rpt_DefaulterReport] ([DefaulterReportID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportComments_rpt_DefaulterReport_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportComments]'))
ALTER TABLE [dbo].[rpt_DefaulterReportComments] CHECK CONSTRAINT [FK_rpt_DefaulterReportComments_rpt_DefaulterReport_DefaulterReportID]
GO
