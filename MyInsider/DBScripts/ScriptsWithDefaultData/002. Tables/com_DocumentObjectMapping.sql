/****** Object:  Table [dbo].[com_DocumentObjectMapping]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_DocumentObjectMapping](
	[DocumentObjectMapId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[MapToId] [int] NOT NULL,
	[PurposeCodeId] [int] NULL,
 CONSTRAINT [PK_com_DocumentObjectMapping] PRIMARY KEY CLUSTERED 
(
	[DocumentObjectMapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_DocumentObjectMapping', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, codegRoupId = 132' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_DocumentObjectMapping', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_DocumentObjectMapping', N'COLUMN',N'MapToId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Depending on the MapToType, it is key from the respective table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_DocumentObjectMapping', @level2type=N'COLUMN',@level2name=N'MapToId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_DocumentObjectMapping', N'COLUMN',N'PurposeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 133' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_DocumentObjectMapping', @level2type=N'COLUMN',@level2name=N'PurposeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Code_MapToType]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping]  WITH CHECK ADD  CONSTRAINT [FK_com_DocumentObjectMapping_com_Code_MapToType] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Code_MapToType]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping] CHECK CONSTRAINT [FK_com_DocumentObjectMapping_com_Code_MapToType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Code_PurposeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping]  WITH CHECK ADD  CONSTRAINT [FK_com_DocumentObjectMapping_com_Code_PurposeCode] FOREIGN KEY([PurposeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Code_PurposeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping] CHECK CONSTRAINT [FK_com_DocumentObjectMapping_com_Code_PurposeCode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Document_DocumentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping]  WITH CHECK ADD  CONSTRAINT [FK_com_DocumentObjectMapping_com_Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[com_Document] ([DocumentId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_DocumentObjectMapping_com_Document_DocumentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_DocumentObjectMapping]'))
ALTER TABLE [dbo].[com_DocumentObjectMapping] CHECK CONSTRAINT [FK_com_DocumentObjectMapping_com_Document_DocumentId]
GO
