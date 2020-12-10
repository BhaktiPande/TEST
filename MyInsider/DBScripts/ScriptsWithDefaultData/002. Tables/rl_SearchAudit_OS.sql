/****** Object:  Table [dbo].[rl_SearchAudit_OS]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rl_SearchAudit_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rl_SearchAudit_OS](
	[RlSearchAuditId] [int] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[ResourceKey] [varchar](15) NOT NULL,
	[RlCompanyId] [int] NOT NULL,
	[RlMasterId] [int] NULL,
	[ModuleCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RlSearchAuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Search_OS_Modul__37661AB1]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_SearchAudit_OS]'))
ALTER TABLE [dbo].[rl_SearchAudit_OS]  WITH CHECK ADD FOREIGN KEY([ModuleCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Search_OS_RlCom__357DD23F]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_SearchAudit_OS]'))
ALTER TABLE [dbo].[rl_SearchAudit_OS]  WITH CHECK ADD FOREIGN KEY([RlCompanyId])
REFERENCES [dbo].[rl_CompanyMasterList] ([RlCompanyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Search_OS_RlMas__3671F678]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_SearchAudit_OS]'))
ALTER TABLE [dbo].[rl_SearchAudit_OS]  WITH CHECK ADD FOREIGN KEY([RlMasterId])
REFERENCES [dbo].[rl_RistrictedMasterList] ([RlMasterId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Search_OS_UserI__3489AE06]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_SearchAudit_OS]'))
ALTER TABLE [dbo].[rl_SearchAudit_OS]  WITH CHECK ADD FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
