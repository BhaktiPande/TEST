/****** Object:  Table [dbo].[mst_Company]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Company]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[mst_Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](1024) NOT NULL,
	[Website] [nvarchar](512) NULL,
	[EmailId] [nvarchar](250) NULL,
	[IsImplementing] [bit] NOT NULL,
	[ISINNumber] [nvarchar](50) NULL,
	[CompanyLogoURL] [varchar](512) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[TradingDaysCountType] [int] NULL,
	[ContraTradeOption] [int] NULL,
	[AutoSubmitTransaction] [int] NULL,
 CONSTRAINT [PK_mst_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Company_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Company]'))
ALTER TABLE [dbo].[mst_Company]  WITH CHECK ADD  CONSTRAINT [FK_mst_Company_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Company_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Company]'))
ALTER TABLE [dbo].[mst_Company] CHECK CONSTRAINT [FK_mst_Company_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Company_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Company]'))
ALTER TABLE [dbo].[mst_Company]  WITH CHECK ADD  CONSTRAINT [FK_mst_Company_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Company_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Company]'))
ALTER TABLE [dbo].[mst_Company] CHECK CONSTRAINT [FK_mst_Company_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_mst_Company_IsImplementing]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Company]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_mst_Company_IsImplementing]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[mst_Company] ADD  CONSTRAINT [DF_mst_Company_IsImplementing]  DEFAULT ((0)) FOR [IsImplementing]
END


End
GO
