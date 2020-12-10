/****** Object:  Table [dbo].[com_PersonalDetailsConfirmation]    Script Date: 10/10/2018 15:47:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_PersonalDetailsConfirmation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[com_PersonalDetailsConfirmation](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[CompanyId] INT NULL,
		[ReConfirmationFreqId] INT NULL,
		[CreatedBy] [int] NULL,
	    [CreatedOn] [datetime] NULL,
	    [ModifiedBy] [int] NULL,
	    [ModifiedOn] [datetime] NULL,
		
	CONSTRAINT [PK_com_PersonalDetailsConfirmation] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO