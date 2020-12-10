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

GO



