/****** Object:  Table [dbo].[rul_ApplicabilityDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_ApplicabilityDetails](
	[ApplicabilityDtlsId] [bigint] IDENTITY(1,1) NOT NULL,
	[ApplicabilityMstId] [bigint] NOT NULL,
	[AllEmployeeFlag] [bit] NULL,
	[AllInsiderFlag] [bit] NULL,
	[AllEmployeeInsiderFlag] [bit] NULL,
	[InsiderTypeCodeId] [int] NULL,
	[DepartmentCodeId] [int] NULL,
	[GradeCodeId] [int] NULL,
	[DesignationCodeId] [int] NULL,
	[UserId] [int] NULL,
	[IncludeExcludeCodeId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_rul_ApplicabilityDetails] PRIMARY KEY CLUSTERED 
(
	[ApplicabilityDtlsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'ApplicabilityMstId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: rul_ApplicabilityMaster' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'ApplicabilityMstId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'AllEmployeeFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Employee selected, 0: All Employee not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'AllEmployeeFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'AllInsiderFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Insider selected, 0: All Insider not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'AllInsiderFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'AllEmployeeInsiderFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Employee Insider selected, 0: All Employee Insider not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'AllEmployeeInsiderFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'InsiderTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, 101003: Employee Insider, 101006: NonEmployee Insider, 101004: Corporate Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'InsiderTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'DepartmentCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for department codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'DepartmentCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'GradeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for grade codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'GradeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'DesignationCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for Designation codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'DesignationCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'UserId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers usr_UserInfo for UserInfoId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'UserId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'IncludeExcludeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code for UserId Include/Exclude code : 150001 : Include Insider,150002 : Exclude Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'IncludeExcludeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityDetails', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_DepartmentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_DepartmentCodeId] FOREIGN KEY([DepartmentCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_DepartmentCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_DepartmentCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_DesignationCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_DesignationCodeId] FOREIGN KEY([DesignationCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_DesignationCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_DesignationCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_GradeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_GradeCodeId] FOREIGN KEY([GradeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_GradeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_GradeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_IncludeExcludeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_IncludeExcludeCodeId] FOREIGN KEY([IncludeExcludeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_IncludeExcludeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_IncludeExcludeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_InsiderTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_InsiderTypeCodeId] FOREIGN KEY([InsiderTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_InsiderTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_InsiderTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_rul_ApplicabilityMaster_ApplicabilityMstId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_rul_ApplicabilityMaster_ApplicabilityMstId] FOREIGN KEY([ApplicabilityMstId])
REFERENCES [dbo].[rul_ApplicabilityMaster] ([ApplicabilityId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_rul_ApplicabilityMaster_ApplicabilityMstId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_rul_ApplicabilityMaster_ApplicabilityMstId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_usr_UserInfo_UserId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_ApplicabilityDetails_AllEmployeeFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityDetails_AllEmployeeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityDetails] ADD  CONSTRAINT [DF_rul_ApplicabilityDetails_AllEmployeeFlag]  DEFAULT ((0)) FOR [AllEmployeeFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_ApplicabilityDetails_AllInsiderFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityDetails_AllInsiderFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityDetails] ADD  CONSTRAINT [DF_rul_ApplicabilityDetails_AllInsiderFlag]  DEFAULT ((0)) FOR [AllInsiderFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_ApplicabilityDetails_AllEmployeeInsiderFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityDetails_AllEmployeeInsiderFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityDetails] ADD  CONSTRAINT [DF_rul_ApplicabilityDetails_AllEmployeeInsiderFlag]  DEFAULT ((0)) FOR [AllEmployeeInsiderFlag]
END


End
GO
