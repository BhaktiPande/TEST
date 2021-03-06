/****** Object:  Table [dbo].[rl_RistrictedMasterList]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rl_RistrictedMasterList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rl_RistrictedMasterList](
	[RlMasterId] [int] IDENTITY(1,1) NOT NULL,
	[RlCompanyId] [int] NOT NULL,
	[ModuleCodeId] [int] NOT NULL,
	[ApplicableFromDate] [datetime] NOT NULL,
	[ApplicableToDate] [datetime] NOT NULL,
	[StatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RlMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Ristri__Modul__2ED0D4B0]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_RistrictedMasterList]'))
ALTER TABLE [dbo].[rl_RistrictedMasterList]  WITH CHECK ADD FOREIGN KEY([ModuleCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Ristri__RlCom__2DDCB077]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_RistrictedMasterList]'))
ALTER TABLE [dbo].[rl_RistrictedMasterList]  WITH CHECK ADD FOREIGN KEY([RlCompanyId])
REFERENCES [dbo].[rl_CompanyMasterList] ([RlCompanyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Ristri__Statu__2FC4F8E9]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_RistrictedMasterList]'))
ALTER TABLE [dbo].[rl_RistrictedMasterList]  WITH CHECK ADD FOREIGN KEY([StatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
