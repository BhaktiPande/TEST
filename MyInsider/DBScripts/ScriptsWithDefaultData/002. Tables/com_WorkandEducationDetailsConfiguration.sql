
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_WorkandEducationDetailsConfiguration]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[com_WorkandEducationDetailsConfiguration](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[CompanyId] INT NULL,
		[WorkandEducationDetailsConfigurationId] INT NULL,
		[CreatedBy] [int] NULL,
	    [CreatedOn] [datetime] NULL,
	    [ModifiedBy] [int] NULL,
	    [ModifiedOn] [datetime] NULL,
		
	CONSTRAINT [PK_com_WorkandEducationDetailsConfiguration] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO