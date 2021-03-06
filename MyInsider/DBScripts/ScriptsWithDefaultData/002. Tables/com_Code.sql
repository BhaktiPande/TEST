/****** Object:  Table [dbo].[com_Code]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_Code]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_Code](
	[CodeID] [int] NOT NULL,
	[CodeName] [nvarchar](512) NOT NULL,
	[CodeGroupId] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[IsVisible] [bit] NOT NULL,
	[IsActive] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[DisplayCode] [nvarchar](50) NULL,
	[ParentCodeId] [int] NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_Code] PRIMARY KEY CLUSTERED 
(
	[CodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_Code', N'COLUMN',N'IsActive'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Active, 0: Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_Code', @level2type=N'COLUMN',@level2name=N'IsActive'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_com_Code_ParentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code]  WITH CHECK ADD  CONSTRAINT [FK_com_Code_com_Code_ParentCodeId] FOREIGN KEY([ParentCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_com_Code_ParentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code] CHECK CONSTRAINT [FK_com_Code_com_Code_ParentCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_com_CodeGroup_CodeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code]  WITH CHECK ADD  CONSTRAINT [FK_com_Code_com_CodeGroup_CodeGroupId] FOREIGN KEY([CodeGroupId])
REFERENCES [dbo].[com_CodeGroup] ([CodeGroupID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_com_CodeGroup_CodeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code] CHECK CONSTRAINT [FK_com_Code_com_CodeGroup_CodeGroupId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code]  WITH CHECK ADD  CONSTRAINT [FK_com_Code_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Code_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
ALTER TABLE [dbo].[com_Code] CHECK CONSTRAINT [FK_com_Code_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_Code_IsVisible]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_Code_IsVisible]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_Code] ADD  CONSTRAINT [DF_com_Code_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_Code_IsActive]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_Code_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_Code] ADD  CONSTRAINT [DF_com_Code_IsActive]  DEFAULT ((1)) FOR [IsActive]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_Code_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Code]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_Code_ModifiedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_Code] ADD  CONSTRAINT [DF_com_Code_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
END


End
GO
