/****** Object:  Table [dbo].[rul_ApplicabilityMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_ApplicabilityMaster](
	[ApplicabilityId] [bigint] IDENTITY(1,1) NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[MapToId] [int] NOT NULL,
	[VersionNumber] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_rul_ApplicabilityMaster] PRIMARY KEY CLUSTERED 
(
	[ApplicabilityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityMaster', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code - 132001:Policy Document, 132002:Trading Policy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityMaster', N'COLUMN',N'MapToId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Actual Id of map type defined by MapToTypeCodeId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster', @level2type=N'COLUMN',@level2name=N'MapToId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_ApplicabilityMaster', N'COLUMN',N'VersionNumber'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'version number of applicability where latest version will be associated with MapToId. Latest version will be calculated as max+1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster', @level2type=N'COLUMN',@level2name=N'VersionNumber'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_ApplicabilityMaster_VersionNumber]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityMaster_VersionNumber]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityMaster] ADD  CONSTRAINT [DF_rul_ApplicabilityMaster_VersionNumber]  DEFAULT ((1)) FOR [VersionNumber]
END


End
GO
