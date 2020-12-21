
/****** Object:  Table [dbo].[rl_RestrictedListConfig]    Script Date: 07/16/2020 05:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rl_RestrictedListConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rl_RestrictedListConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SearchType] [int] NOT NULL ,---SearchType
	[SearchLimit] [int] NULL , ---SearchLimit	 
	[ApprovalType] [int] NOT NULL ,---ApprovalType
	[IsDematAllowed] [bit] NULL,  ---IsDematAllowed
	[IsFormFRequired] [bit] NULL ,---IsFormFRequired
	
 CONSTRAINT [PK_rl_RestrictedListConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END




