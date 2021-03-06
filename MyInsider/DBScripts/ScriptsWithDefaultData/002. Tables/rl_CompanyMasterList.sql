/****** Object:  Table [dbo].[rl_CompanyMasterList]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rl_CompanyMasterList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rl_CompanyMasterList](
	[RlCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](300) NOT NULL,
	[BSECode] [varchar](300) NOT NULL,
	[NSECode] [varchar](300) NOT NULL,
	[ISINCode] [varchar](300) NOT NULL,
	[ModuleCodeId] [int] NOT NULL,
	[StatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RlCompanyId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Compan__Modul__2823D721]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_CompanyMasterList]'))
ALTER TABLE [dbo].[rl_CompanyMasterList]  WITH CHECK ADD FOREIGN KEY([ModuleCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__rl_Compan__Statu__2917FB5A]') AND parent_object_id = OBJECT_ID(N'[dbo].[rl_CompanyMasterList]'))
ALTER TABLE [dbo].[rl_CompanyMasterList]  WITH CHECK ADD FOREIGN KEY([StatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
