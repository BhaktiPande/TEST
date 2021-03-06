/****** Object:  Table [dbo].[rul_PolicyDocument]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_PolicyDocument](
	[PolicyDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[PolicyDocumentName] [nvarchar](100) NOT NULL,
	[DocumentCategoryCodeId] [int] NOT NULL,
	[DocumentSubCategoryCodeId] [int] NULL,
	[ApplicableFrom] [datetime] NOT NULL,
	[ApplicableTo] [datetime] NULL,
	[CompanyId] [int] NOT NULL,
	[DisplayInPolicyDocumentFlag] [bit] NOT NULL,
	[SendEmailUpdateFlag] [bit] NOT NULL,
	[DocumentViewFlag] [bit] NOT NULL,
	[DocumentViewAgreeFlag] [bit] NOT NULL,
	[WindowStatusCodeId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_rul_PolicyDocument] PRIMARY KEY CLUSTERED 
(
	[PolicyDocumentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'DocumentCategoryCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 129' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'DocumentCategoryCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'DocumentSubCategoryCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 130' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'DocumentSubCategoryCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'DisplayInPolicyDocumentFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Display, 0: Do not display' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'DisplayInPolicyDocumentFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'SendEmailUpdateFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Send, 0: Do not send' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'SendEmailUpdateFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'DocumentViewFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: View, 0: Do not view' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'DocumentViewFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'DocumentViewAgreeFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: ViewAndAgree, 0: Do not view and agree' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'DocumentViewAgreeFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'WindowStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodeGroupId 131
131001: Activate
131002: Deactivate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'WindowStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_PolicyDocument', N'COLUMN',N'IsDeleted'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag to indicate if record is deleted. 0:Not deleted, 1:Deleted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_PolicyDocument', @level2type=N'COLUMN',@level2name=N'IsDeleted'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_DocumentCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_com_Code_DocumentCategory] FOREIGN KEY([DocumentCategoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_DocumentCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_com_Code_DocumentCategory]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_DocumentSubCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_com_Code_DocumentSubCategory] FOREIGN KEY([DocumentSubCategoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_DocumentSubCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_com_Code_DocumentSubCategory]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_WindowStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_com_Code_WindowStatus] FOREIGN KEY([WindowStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_com_Code_WindowStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_com_Code_WindowStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument]  WITH CHECK ADD  CONSTRAINT [FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
ALTER TABLE [dbo].[rul_PolicyDocument] CHECK CONSTRAINT [FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_PolicyDocument_DisplayInPolicyDocumentFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_PolicyDocument_DisplayInPolicyDocumentFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_PolicyDocument] ADD  CONSTRAINT [DF_rul_PolicyDocument_DisplayInPolicyDocumentFlag]  DEFAULT ((1)) FOR [DisplayInPolicyDocumentFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_PolicyDocument_SendEmailUpdateFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_PolicyDocument_SendEmailUpdateFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_PolicyDocument] ADD  CONSTRAINT [DF_rul_PolicyDocument_SendEmailUpdateFlag]  DEFAULT ((1)) FOR [SendEmailUpdateFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_PolicyDocument_DocumentViewFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_PolicyDocument_DocumentViewFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_PolicyDocument] ADD  CONSTRAINT [DF_rul_PolicyDocument_DocumentViewFlag]  DEFAULT ((1)) FOR [DocumentViewFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_PolicyDocument_DocumentViewAgreeFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_PolicyDocument_DocumentViewAgreeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_PolicyDocument] ADD  CONSTRAINT [DF_rul_PolicyDocument_DocumentViewAgreeFlag]  DEFAULT ((1)) FOR [DocumentViewAgreeFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_PolicyDocument_IsDeleted]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_PolicyDocument]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_PolicyDocument_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_PolicyDocument] ADD  CONSTRAINT [DF_rul_PolicyDocument_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
END


End
GO
