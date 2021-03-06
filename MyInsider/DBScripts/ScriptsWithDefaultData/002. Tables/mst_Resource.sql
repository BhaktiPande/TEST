/****** Object:  Table [dbo].[mst_Resource]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Resource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[mst_Resource](
	[ResourceId] [int] NOT NULL,
	[ResourceKey] [varchar](15) NOT NULL,
	[ResourceValue] [nvarchar](2000) NOT NULL,
	[ResourceCulture] [varchar](10) NOT NULL,
	[ModuleCodeId] [int] NOT NULL,
	[CategoryCodeId] [int] NOT NULL,
	[ScreenCodeId] [int] NOT NULL,
	[OriginalResourceValue] [nvarchar](2000) NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_mst_Resource] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'mst_Resource', N'COLUMN',N'ModuleCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Referes to com_Code, CodeGroupId = 103' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mst_Resource', @level2type=N'COLUMN',@level2name=N'ModuleCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'mst_Resource', N'COLUMN',N'CategoryCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Referes to com_Code, CodeGroupId = 104' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mst_Resource', @level2type=N'COLUMN',@level2name=N'CategoryCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_CategoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource]  WITH CHECK ADD  CONSTRAINT [FK_mst_Resource_com_Code_CategoryCodeId] FOREIGN KEY([CategoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_CategoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource] CHECK CONSTRAINT [FK_mst_Resource_com_Code_CategoryCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_ModuleCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource]  WITH CHECK ADD  CONSTRAINT [FK_mst_Resource_com_Code_ModuleCodeId] FOREIGN KEY([ModuleCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_ModuleCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource] CHECK CONSTRAINT [FK_mst_Resource_com_Code_ModuleCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_ScreenCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource]  WITH CHECK ADD  CONSTRAINT [FK_mst_Resource_com_Code_ScreenCodeId] FOREIGN KEY([ScreenCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_com_Code_ScreenCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource] CHECK CONSTRAINT [FK_mst_Resource_com_Code_ScreenCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource]  WITH CHECK ADD  CONSTRAINT [FK_mst_Resource_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Resource_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
ALTER TABLE [dbo].[mst_Resource] CHECK CONSTRAINT [FK_mst_Resource_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_mst_Resource_ScreenCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_mst_Resource_ScreenCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[mst_Resource] ADD  CONSTRAINT [DF_mst_Resource_ScreenCodeId]  DEFAULT ((122001)) FOR [ScreenCodeId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_mst_Resource_OriginalResourceValue]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Resource]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_mst_Resource_OriginalResourceValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[mst_Resource] ADD  CONSTRAINT [DF_mst_Resource_OriginalResourceValue]  DEFAULT ('') FOR [OriginalResourceValue]
END


End
GO
