/****** Object:  Table [dbo].[usr_PasswordHistory]    Script Date: 07/25/2017 14:46:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_PasswordHistory]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[usr_PasswordHistory](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UserId] INT NOT NULL,
		[Password] [varchar](200) NOT NULL,
		[LastUpdatedOn] [datetime] NULL,
		[LastUpdatedBy] [varchar](50) NULL,
	CONSTRAINT [PK_usr_PasswordHistory] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO


