/****** Object:  Table [dbo].[rul_EmailAttachment]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_EmailAttachment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_EmailAttachment](
	[MapToTypeCodeId] [int] NULL,
	[MapToId] [int] NULL,
	[DocumentId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_EmailAttachment', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_EmailAttachment', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_EmailAttachment', N'COLUMN',N'DocumentId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_EmailAttachment', @level2type=N'COLUMN',@level2name=N'DocumentId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_EmailAttachment', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_EmailAttachment', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_EmailAttachment', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_EmailAttachment', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_EmailAttachment_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_EmailAttachment]'))
ALTER TABLE [dbo].[rul_EmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_rul_EmailAttachment_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_EmailAttachment_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_EmailAttachment]'))
ALTER TABLE [dbo].[rul_EmailAttachment] CHECK CONSTRAINT [FK_rul_EmailAttachment_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_EmailAttachment_com_Document_DocumentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_EmailAttachment]'))
ALTER TABLE [dbo].[rul_EmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_rul_EmailAttachment_com_Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[com_Document] ([DocumentId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_EmailAttachment_com_Document_DocumentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_EmailAttachment]'))
ALTER TABLE [dbo].[rul_EmailAttachment] CHECK CONSTRAINT [FK_rul_EmailAttachment_com_Document_DocumentId]
GO
