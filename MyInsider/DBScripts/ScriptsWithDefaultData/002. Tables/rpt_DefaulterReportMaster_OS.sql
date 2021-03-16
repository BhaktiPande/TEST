
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportMaster_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReportMaster_OS](
	[DefaulterReportMaster] [int] NOT NULL,
	[LastRunTime] [datetime] NULL
) 
END
GO
