IF NOT EXISTS(SELECT NAME FROM SYS.tables WHERE NAME = 'ELMAH_Error')
BEGIN
	/*Table used for maintaining the error logged by ELMHA*/
	CREATE TABLE [dbo].[ELMAH_Error](
		[ErrorId] [uniqueidentifier] NOT NULL,
		[Application] [nvarchar](60) NOT NULL,
		[Host] [nvarchar](50) NOT NULL,
		[Type] [nvarchar](100) NOT NULL,
		[Source] [nvarchar](60) NOT NULL,
		[Message] [nvarchar](500) NOT NULL,
		[User] [nvarchar](50) NOT NULL,
		[StatusCode] [int] NOT NULL,
		[TimeUtc] [datetime] NOT NULL,
		[Sequence] [int] IDENTITY(1,1) NOT NULL,
		[AllXml] [ntext] NOT NULL,
	 CONSTRAINT [PK_ELMAH_Error] PRIMARY KEY NONCLUSTERED 
	(
		[ErrorId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	
	ALTER TABLE [dbo].[ELMAH_Error] ADD  CONSTRAINT [DF_ELMAH_Error_ErrorId]  DEFAULT (newid()) FOR [ErrorId]
	
END	

GO
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (0, '000 ELMAH_Error_Createscript', 'To create ELMAH error log table', 'Raghvendra')

