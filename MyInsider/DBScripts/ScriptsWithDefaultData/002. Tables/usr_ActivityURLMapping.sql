/****** Object:  Table [dbo].[usr_ActivityURLMapping]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_ActivityURLMapping](
	[ActivityURLMappingId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID] [int] NOT NULL,
	[ControllerName] [varchar](500) NOT NULL,
	[ActionName] [varchar](500) NOT NULL,
	[ActionButtonName] [varchar](255) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping]  WITH CHECK ADD  CONSTRAINT [FK_usr_ActivityURLMapping_usr_Activity_ActivityID] FOREIGN KEY([ActivityID])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping] CHECK CONSTRAINT [FK_usr_ActivityURLMapping_usr_Activity_ActivityID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping]  WITH CHECK ADD  CONSTRAINT [FK_usr_ActivityURLMapping_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping] CHECK CONSTRAINT [FK_usr_ActivityURLMapping_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping]  WITH CHECK ADD  CONSTRAINT [FK_usr_ActivityURLMapping_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityURLMapping_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityURLMapping]'))
ALTER TABLE [dbo].[usr_ActivityURLMapping] CHECK CONSTRAINT [FK_usr_ActivityURLMapping_usr_UserInfo_ModifiedBy]
GO
