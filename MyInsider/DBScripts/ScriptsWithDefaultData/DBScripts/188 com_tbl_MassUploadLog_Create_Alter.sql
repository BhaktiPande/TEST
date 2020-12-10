
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_tbl_MassUploadLog]') AND type in (N'U'))
DROP TABLE [dbo].[com_tbl_MassUploadLog]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[com_tbl_MassUploadLog](
	[MassUploadLogId] [int] IDENTITY(1,1) NOT NULL,
	[MassUploadTypeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[ErrorReportFileName] [varchar](100) NULL,
	[ErrorMessage] [varchar](1000) NULL,
 CONSTRAINT [PK_com_tbl_MassUploadLog] PRIMARY KEY CLUSTERED 
(
	[MassUploadLogId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


ALTER TABLE [dbo].com_tbl_MassUploadLog  WITH CHECK ADD  CONSTRAINT FK_com_tbl_MassUploadLog_usr_UserInfo_UserInfoId 
FOREIGN KEY(CreatedBy)
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (188, '188 com_tbl_MassUploadLog_Create_Alter', 'Create and alter com_tbl_MassUploadLog', 'Raghvendra')
