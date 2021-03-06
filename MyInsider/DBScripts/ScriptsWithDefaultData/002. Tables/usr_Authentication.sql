/****** Object:  Table [dbo].[usr_Authentication]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_Authentication]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_Authentication](
	[UserInfoID] [int] NOT NULL,
	[LoginID] [varchar](100) NOT NULL,
	[Password] [varchar](200) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[LastLoginTime] [datetime] NULL,
 CONSTRAINT [PK_usr_Authentication] PRIMARY KEY CLUSTERED 
(
	[UserInfoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Authentication_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Authentication]'))
ALTER TABLE [dbo].[usr_Authentication]  WITH CHECK ADD  CONSTRAINT [FK_usr_Authentication_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Authentication_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Authentication]'))
ALTER TABLE [dbo].[usr_Authentication] CHECK CONSTRAINT [FK_usr_Authentication_usr_UserInfo_UserInfoId]
GO
