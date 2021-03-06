/****** Object:  Table [dbo].[usr_DocumentDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_DocumentDetails](
	[DocumentDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[UserInfoID] [int] NOT NULL,
	[GUID] [varchar](100) NOT NULL,
	[DocumentName] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](512) NOT NULL,
	[DocumentPath] [nvarchar](512) NOT NULL,
	[FileSize] [bigint] NOT NULL,
	[FileType] [nvarchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_DocumentDetails] PRIMARY KEY CLUSTERED 
(
	[DocumentDetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_DocumentDetails', N'COLUMN',N'FileSize'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'File size in bytes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_DocumentDetails', @level2type=N'COLUMN',@level2name=N'FileSize'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails] CHECK CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_modifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_modifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_modifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails] CHECK CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_modifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_UserInfoID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_UserInfoID] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DocumentDetails_usr_UserInfo_UserInfoID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DocumentDetails]'))
ALTER TABLE [dbo].[usr_DocumentDetails] CHECK CONSTRAINT [FK_usr_DocumentDetails_usr_UserInfo_UserInfoID]
GO
