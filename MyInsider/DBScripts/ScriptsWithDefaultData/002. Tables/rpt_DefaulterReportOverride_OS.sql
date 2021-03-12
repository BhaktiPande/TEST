
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReportOverride_OS](
	[DefaulterReportID] [bigint] NOT NULL,
	[Reason] [nvarchar](500) NULL,
	[IsRemovedFromNonCompliance] [int] NULL,
 CONSTRAINT [PK_rpt_DefaulterReportOverride_OS] PRIMARY KEY CLUSTERED 
(
	[DefaulterReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportOverride_OS_rpt_DefaulterReport_OS_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride_OS]'))
ALTER TABLE [dbo].[rpt_DefaulterReportOverride_OS]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReportOverride_OS_rpt_DefaulterReport_OS_DefaulterReportID] FOREIGN KEY([DefaulterReportID])
REFERENCES [dbo].[rpt_DefaulterReport_OS] ([DefaulterReportID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReportOverride_OS_rpt_DefaulterReport_OS_DefaulterReportID]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportOverride_OS]'))
ALTER TABLE [dbo].[rpt_DefaulterReportOverride_OS] CHECK CONSTRAINT [FK_rpt_DefaulterReportOverride_OS_rpt_DefaulterReport_OS_DefaulterReportID]
GO
