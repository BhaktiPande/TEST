/****** Object:  Table [dbo].[com_Document]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_Document]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [varchar](255) NOT NULL,
	[GUID] [varchar](100) NOT NULL,
	[Description] [varchar](512) NULL,
	[DocumentPath] [varchar](512) NOT NULL,
	[FileSize] [bigint] NOT NULL,
	[FileType] [nvarchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Document_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Document]'))
ALTER TABLE [dbo].[com_Document]  WITH CHECK ADD  CONSTRAINT [FK_com_Document_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Document_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Document]'))
ALTER TABLE [dbo].[com_Document] CHECK CONSTRAINT [FK_com_Document_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Document_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Document]'))
ALTER TABLE [dbo].[com_Document]  WITH CHECK ADD  CONSTRAINT [FK_com_Document_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_Document_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_Document]'))
ALTER TABLE [dbo].[com_Document] CHECK CONSTRAINT [FK_com_Document_usr_UserInfo_ModifiedBy]
GO
