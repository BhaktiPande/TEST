/****** Object:  Table [dbo].[com_GlobalRedirectToURL]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_GlobalRedirectToURL]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_GlobalRedirectToURL](
	[ID] [int] NOT NULL,
	[Controller] [nvarchar](255) NOT NULL,
	[Action] [nvarchar](255) NOT NULL,
	[Parameter] [nvarchar](255) NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_GlobalRedirectToURL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_com_GlobalRedirectToURL_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GlobalRedirectToURL]'))
ALTER TABLE [dbo].[com_GlobalRedirectToURL]  WITH CHECK ADD  CONSTRAINT [fk_com_GlobalRedirectToURL_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_com_GlobalRedirectToURL_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_GlobalRedirectToURL]'))
ALTER TABLE [dbo].[com_GlobalRedirectToURL] CHECK CONSTRAINT [fk_com_GlobalRedirectToURL_usr_UserInfo_ModifiedBy]
GO
