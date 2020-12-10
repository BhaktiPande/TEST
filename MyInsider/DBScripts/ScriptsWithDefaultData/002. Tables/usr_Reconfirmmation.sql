/****** Object:  Table [dbo].[usr_Reconfirmmation]    Script Date: 04/03/2019 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_Reconfirmmation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_Reconfirmmation](
	[UserInfoID] [int] NOT NULL,
	[ConfirmationDate] [datetime] NOT NULL,
	[REConfirmationDate] [datetime] NOT NULL,
	[Frequency] [int] NOT NULL,
	[EntryFlag] [int] NOT NULL


	
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Reconfirmmation_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Reconfirmmation]'))
ALTER TABLE [dbo].[usr_Reconfirmmation]  WITH CHECK ADD  CONSTRAINT [FK_usr_Reconfirmmation_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Reconfirmmation_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Reconfirmmation]'))
ALTER TABLE [dbo].[usr_Reconfirmmation] CHECK CONSTRAINT [FK_usr_Reconfirmmation_usr_UserInfo_UserInfoId]
GO
