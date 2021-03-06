/****** Object:  Table [dbo].[com_GridHeaderSetting]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_GridHeaderSetting](
	[GridTypeCodeId] [int] NOT NULL,
	[ResourceKey] [varchar](15) NOT NULL,
	[IsVisible] [int] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
	[ColumnWidth] [int] NOT NULL,
	[ColumnAlignment] [int] NOT NULL,
	[OverrideGridTypeCodeId] [int] NULL,
	[OverrideResourceKey] [varchar](15) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_GridHeaderSetting', N'COLUMN',N'GridTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_code, CodeGroupId = 114' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_GridHeaderSetting', @level2type=N'COLUMN',@level2name=N'GridTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_GridHeaderSetting', N'COLUMN',N'ResourceKey'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ResourceKey from mst_Resource table used to show the column header' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_GridHeaderSetting', @level2type=N'COLUMN',@level2name=N'ResourceKey'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_GridHeaderSetting_com_Code_GridTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
ALTER TABLE [dbo].[com_GridHeaderSetting]  WITH CHECK ADD  CONSTRAINT [FK_com_GridHeaderSetting_com_Code_GridTypeCodeId] FOREIGN KEY([GridTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_GridHeaderSetting_com_Code_GridTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
ALTER TABLE [dbo].[com_GridHeaderSetting] CHECK CONSTRAINT [FK_com_GridHeaderSetting_com_Code_GridTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_GridHeaderSetting_com_Code_OverrideGridTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
ALTER TABLE [dbo].[com_GridHeaderSetting]  WITH CHECK ADD  CONSTRAINT [FK_com_GridHeaderSetting_com_Code_OverrideGridTypeCodeId] FOREIGN KEY([OverrideGridTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_GridHeaderSetting_com_Code_OverrideGridTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
ALTER TABLE [dbo].[com_GridHeaderSetting] CHECK CONSTRAINT [FK_com_GridHeaderSetting_com_Code_OverrideGridTypeCodeId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_GridHeaderSetting_IsVisible]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_GridHeaderSetting_IsVisible]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_GridHeaderSetting] ADD  CONSTRAINT [DF_com_GridHeaderSetting_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_GridHeaderSetting_ColumnWidth]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_GridHeaderSetting_ColumnWidth]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_GridHeaderSetting] ADD  CONSTRAINT [DF_com_GridHeaderSetting_ColumnWidth]  DEFAULT ((0)) FOR [ColumnWidth]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_GridHeaderSetting_ColumnAlignment]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GridHeaderSetting]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_GridHeaderSetting_ColumnAlignment]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_GridHeaderSetting] ADD  CONSTRAINT [DF_com_GridHeaderSetting_ColumnAlignment]  DEFAULT ((155001)) FOR [ColumnAlignment]
END


End
GO
