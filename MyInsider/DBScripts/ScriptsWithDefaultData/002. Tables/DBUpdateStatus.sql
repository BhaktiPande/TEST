/****** Object:  Table [dbo].[DBUpdateStatus]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBUpdateStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DBUpdateStatus](
	[ScriptNumber] [int] NOT NULL,
	[ScriptFileName] [varchar](100) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[CreatedBy] [varchar](100) NOT NULL,
 CONSTRAINT [PK_DBUpdateStatus] PRIMARY KEY CLUSTERED 
(
	[ScriptNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
