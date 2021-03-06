/****** Object:  Table [dbo].[com_tbl_MassUploadLog]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_tbl_MassUploadLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_tbl_MassUploadLog](
	[MassUploadLogId] [int] IDENTITY(1,1) NOT NULL,
	[MassUploadTypeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[ErrorReportFileName] [varchar](100) NULL,
	[ErrorMessage] [varchar](1000) NULL,
	[UploadedDocumentId] [int] NULL,
 CONSTRAINT [PK_com_tbl_MassUploadLog] PRIMARY KEY CLUSTERED 
(
	[MassUploadLogId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_tbl_MassUploadLog_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_tbl_MassUploadLog]'))
ALTER TABLE [dbo].[com_tbl_MassUploadLog]  WITH CHECK ADD  CONSTRAINT [FK_com_tbl_MassUploadLog_usr_UserInfo_UserInfoId] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_tbl_MassUploadLog_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_tbl_MassUploadLog]'))
ALTER TABLE [dbo].[com_tbl_MassUploadLog] CHECK CONSTRAINT [FK_com_tbl_MassUploadLog_usr_UserInfo_UserInfoId]
GO
