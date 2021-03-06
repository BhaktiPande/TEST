/****** Object:  Table [dbo].[rpt_DefaulterReportOverride]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReportOverride](
	[DefaulterReportID] [bigint] NOT NULL,
	[Reason] [nvarchar](500) NULL,
	[IsRemovedFromNonCompliance] [int] NULL,
 CONSTRAINT [PK_rpt_DefaulterReportOverride] PRIMARY KEY CLUSTERED 
(
	[DefaulterReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportOverride_rpt_DefaulterReport_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride]'))
ALTER TABLE [dbo].[rpt_DefaulterReportOverride]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReportOverride_rpt_DefaulterReport_DefaulterReportID] FOREIGN KEY([DefaulterReportID])
REFERENCES [dbo].[rpt_DefaulterReport] ([DefaulterReportID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportOverride_rpt_DefaulterReport_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride]'))
ALTER TABLE [dbo].[rpt_DefaulterReportOverride] CHECK CONSTRAINT [FK_rpt_DefaulterReportOverride_rpt_DefaulterReport_DefaulterReportID]
GO
