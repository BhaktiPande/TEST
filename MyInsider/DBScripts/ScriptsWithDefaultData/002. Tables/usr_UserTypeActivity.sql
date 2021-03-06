/****** Object:  Table [dbo].[usr_UserTypeActivity]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_UserTypeActivity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_UserTypeActivity](
	[ActivityId] [int] NOT NULL,
	[UserTypeCodeId] [int] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserTypeActivity_com_Code_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserTypeActivity]'))
ALTER TABLE [dbo].[usr_UserTypeActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserTypeActivity_com_Code_UserTypeCodeId] FOREIGN KEY([UserTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserTypeActivity_com_Code_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserTypeActivity]'))
ALTER TABLE [dbo].[usr_UserTypeActivity] CHECK CONSTRAINT [FK_usr_UserTypeActivity_com_Code_UserTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserTypeActivity_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserTypeActivity]'))
ALTER TABLE [dbo].[usr_UserTypeActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserTypeActivity_usr_Activity_ActivityId] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserTypeActivity_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserTypeActivity]'))
ALTER TABLE [dbo].[usr_UserTypeActivity] CHECK CONSTRAINT [FK_usr_UserTypeActivity_usr_Activity_ActivityId]
GO
