/****** Object:  Table [dbo].[mst_MenuMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[mst_MenuMaster](
	[MenuID] [int] NOT NULL,
	[MenuName] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[MenuURL] [nvarchar](512) NULL,
	[DisplayOrder] [int] NOT NULL,
	[ParentMenuID] [int] NULL,
	[StatusCodeID] [int] NOT NULL,
	[ImageURL] [nvarchar](512) NULL,
	[ToolTipText] [nvarchar](512) NULL,
	[ActivityID] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_mst_MenuMaster] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_mst_MenuMaster_com_Code_Status] FOREIGN KEY([StatusCodeID])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster] CHECK CONSTRAINT [FK_mst_MenuMaster_com_Code_Status]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_mst_MenuMaster_ParentMenuID]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_mst_MenuMaster_mst_MenuMaster_ParentMenuID] FOREIGN KEY([ParentMenuID])
REFERENCES [dbo].[mst_MenuMaster] ([MenuID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_mst_MenuMaster_ParentMenuID]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster] CHECK CONSTRAINT [FK_mst_MenuMaster_mst_MenuMaster_ParentMenuID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_mst_MenuMaster_usr_Activity_ActivityID] FOREIGN KEY([ActivityID])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_Activity_ActivityID]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster] CHECK CONSTRAINT [FK_mst_MenuMaster_usr_Activity_ActivityID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_mst_MenuMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster] CHECK CONSTRAINT [FK_mst_MenuMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster]  WITH CHECK ADD  CONSTRAINT [FK_mst_MenuMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_MenuMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_MenuMaster]'))
ALTER TABLE [dbo].[mst_MenuMaster] CHECK CONSTRAINT [FK_mst_MenuMaster_usr_UserInfo_ModifiedBy]
GO
