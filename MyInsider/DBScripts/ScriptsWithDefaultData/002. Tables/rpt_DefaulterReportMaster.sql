/****** Object:  Table [dbo].[rpt_DefaulterReportMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReportMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReportMaster](
	[DefaulterReportMaster] [int] NOT NULL,
	[LastRunTime] [datetime] NULL
) ON [PRIMARY]
END
GO
