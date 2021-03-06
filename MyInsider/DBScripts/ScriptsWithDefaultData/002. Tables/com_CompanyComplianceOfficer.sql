/****** Object:  Table [dbo].[com_CompanyComplianceOfficer]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_CompanyComplianceOfficer](
	[CompanyComplianceOfficerId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ComplianceOfficerName] [nvarchar](100) NOT NULL,
	[DesignationId] [int] NULL,
	[Address] [nvarchar](255) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[EmailId] [nvarchar](255) NULL,
	[ApplicableFromDate] [datetime] NOT NULL,
	[ApplicableToDate] [datetime] NULL,
	[StatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_CompanyComplianceOfficer] PRIMARY KEY CLUSTERED 
(
	[CompanyComplianceOfficerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_CompanyComplianceOfficer', N'COLUMN',N'DesignationId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_code, CodeGroupId = 109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_CompanyComplianceOfficer', @level2type=N'COLUMN',@level2name=N'DesignationId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_CompanyComplianceOfficer', N'COLUMN',N'StatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 102' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_CompanyComplianceOfficer', @level2type=N'COLUMN',@level2name=N'StatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_com_Code_DesignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyComplianceOfficer_com_Code_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_com_Code_DesignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer] CHECK CONSTRAINT [FK_com_CompanyComplianceOfficer_com_Code_DesignationId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_com_Code_StatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyComplianceOfficer_com_Code_StatusCodeId] FOREIGN KEY([StatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_com_Code_StatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer] CHECK CONSTRAINT [FK_com_CompanyComplianceOfficer_com_Code_StatusCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyComplianceOfficer_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer] CHECK CONSTRAINT [FK_com_CompanyComplianceOfficer_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer] CHECK CONSTRAINT [FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyComplianceOfficer]'))
ALTER TABLE [dbo].[com_CompanyComplianceOfficer] CHECK CONSTRAINT [FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy]
GO
