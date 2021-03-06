/****** Object:  Table [dbo].[usr_RoleActivity]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_RoleActivity](
	[ActivityID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_RoleActivity_1] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleActivity_usr_Activity_ActivityID] FOREIGN KEY([ActivityID])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity] CHECK CONSTRAINT [FK_usr_RoleActivity_usr_Activity_ActivityID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_RoleMaster_RoleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleActivity_usr_RoleMaster_RoleID] FOREIGN KEY([RoleID])
REFERENCES [dbo].[usr_RoleMaster] ([RoleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_RoleMaster_RoleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity] CHECK CONSTRAINT [FK_usr_RoleActivity_usr_RoleMaster_RoleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleActivity_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity] CHECK CONSTRAINT [FK_usr_RoleActivity_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleActivity_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleActivity_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleActivity]'))
ALTER TABLE [dbo].[usr_RoleActivity] CHECK CONSTRAINT [FK_usr_RoleActivity_usr_UserInfo_ModifiedBy]
GO
