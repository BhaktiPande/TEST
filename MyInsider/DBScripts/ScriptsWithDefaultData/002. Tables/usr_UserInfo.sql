/****** Object:  Table [dbo].[usr_UserInfo]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_UserInfo](
	[UserInfoId] [int] IDENTITY(1,1) NOT NULL,
	[EmailId] [nvarchar](250) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[EmployeeId] [nvarchar](50) NULL,
	[MobileNumber] [nvarchar](15) NULL,
	[CompanyId] [int] NULL,
	[AddressLine1] [nvarchar](500) NULL,
	[AddressLine2] [nvarchar](500) NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NULL,
	[City] [nvarchar](100) NULL,
	[PinCode] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[DateOfJoining] [datetime] NULL,
	[DateOfBecomingInsider] [datetime] NULL,
	[LandLine1] [varchar](50) NULL,
	[LandLine2] [varchar](50) NULL,
	[Website] [nvarchar](500) NULL,
	[PAN] [nvarchar](50) NULL,
	[TAN] [nvarchar](50) NULL,
	[Description] [nvarchar](1024) NULL,
	[Category] [int] NULL,
	[SubCategory] [int] NULL,
	[GradeId] [int] NULL,
	[DesignationId] [int] NULL,
	[SubDesignationId] [int] NULL,
	[Location] [nvarchar](50) NULL,
	[DepartmentId] [int] NULL,
	[UPSIAccessOfCompanyID] [int] NULL,
	[UserTypeCodeId] [int] NOT NULL,
	[StatusCodeId] [int] NOT NULL,
	[IsInsider] [int] NOT NULL,
	[CategoryText] [nvarchar](100) NULL,
	[SubCategoryText] [nvarchar](100) NULL,
	[GradeText] [nvarchar](100) NULL,
	[DesignationText] [nvarchar](100) NULL,
	[SubDesignationText] [nvarchar](100) NULL,
	[DepartmentText] [nvarchar](100) NULL,
	[ResetPasswordFlag] [int] NOT NULL,
	[DateOfSeparation] [datetime] NULL,
	[ReasonForSeparation] [nvarchar](200) NULL,
	[CIN] [nvarchar](50) NULL,
	[DIN] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[NoOfDaysToBeActive] [int] NULL,
	[DateOfInactivation] [datetime] NULL,
 CONSTRAINT [PK_usr_UserInfo] PRIMARY KEY CLUSTERED 
(
	[UserInfoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'Category'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insider / Non-Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'Category'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'IsInsider'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: Not insider, 1: Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'IsInsider'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'CategoryText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, category is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'CategoryText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'SubCategoryText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, subcategory is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'SubCategoryText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'GradeText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, grade is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'GradeText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'DesignationText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, designation is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'DesignationText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'SubDesignationText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, subdesignation is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'SubDesignationText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'DepartmentText'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For nonemployee, department is captures as text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'DepartmentText'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserInfo', N'COLUMN',N'ResetPasswordFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Need to reset flag, 0: Otherwise' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserInfo', @level2type=N'COLUMN',@level2name=N'ResetPasswordFlag'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_Category]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_Category] FOREIGN KEY([Category])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_Category]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_Category]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_CountryId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_CountryId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_DepartmentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_DepartmentId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_DepartmentId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_designationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_designationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_designationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_designationId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_GradeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_GradeId] FOREIGN KEY([GradeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_GradeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_GradeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_StateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_StateId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_SubCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_SubCategory] FOREIGN KEY([SubCategory])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_SubCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_SubCategory]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_SubDesignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_com_Code_SubDesignationId] FOREIGN KEY([SubDesignationId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_com_Code_SubDesignationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_com_Code_SubDesignationId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserInfo_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserInfo_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
ALTER TABLE [dbo].[usr_UserInfo] CHECK CONSTRAINT [FK_usr_UserInfo_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_UserInfo_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_UserInfo_UserTypeCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_UserInfo] ADD  CONSTRAINT [DF_usr_UserInfo_UserTypeCodeId]  DEFAULT ((101001)) FOR [UserTypeCodeId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_UserInfo_StatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_UserInfo_StatusCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_UserInfo] ADD  CONSTRAINT [DF_usr_UserInfo_StatusCodeId]  DEFAULT ((102001)) FOR [StatusCodeId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_UserInfo_IsInsider]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_UserInfo_IsInsider]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_UserInfo] ADD  CONSTRAINT [DF_usr_UserInfo_IsInsider]  DEFAULT ((0)) FOR [IsInsider]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_UserInfo_ResetPasswordFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserInfo]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_UserInfo_ResetPasswordFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_UserInfo] ADD  CONSTRAINT [DF_usr_UserInfo_ResetPasswordFlag]  DEFAULT ((1)) FOR [ResetPasswordFlag]
END


End
GO
