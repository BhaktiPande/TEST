/****** Object:  Table [dbo].[usr_UserResetPassword]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_UserResetPassword]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_UserResetPassword](
	[UserPasswordId] [int] NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[HashCode] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_usr_UserResetPassword] PRIMARY KEY CLUSTERED 
(
	[UserPasswordId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserResetPassword_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserResetPassword]'))
ALTER TABLE [dbo].[usr_UserResetPassword]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserResetPassword_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserResetPassword_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserResetPassword]'))
ALTER TABLE [dbo].[usr_UserResetPassword] CHECK CONSTRAINT [FK_usr_UserResetPassword_usr_UserInfo_UserInfoId]
GO
