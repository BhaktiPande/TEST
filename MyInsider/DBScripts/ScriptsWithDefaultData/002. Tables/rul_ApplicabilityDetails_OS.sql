GO
/****** Object:  Table [dbo].[rul_ApplicabilityDetails_OS]    Script Date: 2/6/2019 6:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rul_ApplicabilityDetails_OS](
	[ApplicabilityDtlsId] [bigint] IDENTITY(1,1) NOT NULL,
	[ApplicabilityMstId] [bigint] NOT NULL,
	[AllEmployeeFlag] [bit] NULL CONSTRAINT [DF_rul_ApplicabilityDetails_OS_AllEmployeeFlag]  DEFAULT ((0)),
	[AllInsiderFlag] [bit] NULL CONSTRAINT [DF_rul_ApplicabilityDetails_OS_AllInsiderFlag]  DEFAULT ((0)),
	[AllEmployeeInsiderFlag] [bit] NULL CONSTRAINT [DF_rul_ApplicabilityDetails_OS_AllEmployeeInsiderFlag]  DEFAULT ((0)),
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
	[RoleId] [int] NULL,
	[Category] [int] NULL,
	[SubCategory] [int] NULL,
	[AllCo] [bit] NULL,
	[AllCorporateEmployees] [bit] NULL,
	[AllNonEmployee] [bit] NULL,
	[NonInsFltrDepartmentCodeId] [int] NULL,
	[NonInsFltrGradeCodeId] [int] NULL,
	[NonInsFltrDesignationCodeId] [int] NULL,
	[NonInsFltrRoleId] [int] NULL,
	[NonInsFltrCategory] [int] NULL,
	[NonInsFltrSubCategory] [int] NULL,
 CONSTRAINT [PK_rul_ApplicabilityDetails_OS] PRIMARY KEY CLUSTERED 
(
	[ApplicabilityDtlsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_DepartmentCodeId] FOREIGN KEY([DepartmentCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_DepartmentCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_DesignationCodeId] FOREIGN KEY([DesignationCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_DesignationCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_GradeCodeId] FOREIGN KEY([GradeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_GradeCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_IncludeExcludeCodeId] FOREIGN KEY([IncludeExcludeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_IncludeExcludeCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_InsiderTypeCodeId] FOREIGN KEY([InsiderTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_com_Code_InsiderTypeCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_rul_ApplicabilityMaster_OS_ApplicabilityMstId] FOREIGN KEY([ApplicabilityMstId])
REFERENCES [dbo].[rul_ApplicabilityMaster_OS] ([ApplicabilityId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_rul_ApplicabilityMaster_OS_ApplicabilityMstId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_CreatedBy]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_ModifiedBy]
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityDetails_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityDetails_OS_usr_UserInfo_UserId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: rul_ApplicabilityMaster_OS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'ApplicabilityMstId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Employee selected, 0: All Employee not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'AllEmployeeFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Insider selected, 0: All Insider not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'AllInsiderFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:All Employee Insider selected, 0: All Employee Insider not selected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'AllEmployeeInsiderFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, 101003: Employee Insider, 101006: NonEmployee Insider, 101004: Corporate Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'InsiderTypeCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for department codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'DepartmentCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for grade codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'GradeCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code for Designation codes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'DesignationCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers usr_UserInfo for UserInfoId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code for UserId Include/Exclude code : 150001 : Include Insider,150002 : Exclude Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'IncludeExcludeCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityDetails_OS', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
