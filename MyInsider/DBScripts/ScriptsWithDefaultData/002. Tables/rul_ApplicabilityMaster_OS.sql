GO
/****** Object:  Table [dbo].[rul_ApplicabilityMaster_OS]    Script Date: 2/6/2019 6:03:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rul_ApplicabilityMaster_OS](
	[ApplicabilityId] [bigint] IDENTITY(1,1) NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[MapToId] [int] NOT NULL,
	[VersionNumber] [int] NOT NULL CONSTRAINT [DF_rul_ApplicabilityMaster_OS_VersionNumber]  DEFAULT ((1)),
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[UserCount] [int] NOT NULL CONSTRAINT [DF_rul_ApplicabilityMaster_OS_UserCount]  DEFAULT ((0)),
 CONSTRAINT [PK_rul_ApplicabilityMaster_OS] PRIMARY KEY CLUSTERED 
(
	[ApplicabilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_OS_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_OS_com_Code_MapToTypeCodeId]
GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_OS_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_OS_usr_UserInfo_CreatedBy]
GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_ApplicabilityMaster_OS_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[rul_ApplicabilityMaster_OS] CHECK CONSTRAINT [FK_rul_ApplicabilityMaster_OS_usr_UserInfo_ModifiedBy]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code - 132001:Policy Document, 132002:Trading Policy' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster_OS', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Actual Id of map type defined by MapToTypeCodeId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster_OS', @level2type=N'COLUMN',@level2name=N'MapToId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'version number of applicability where latest version will be associated with MapToId. Latest version will be calculated as max+1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_ApplicabilityMaster_OS', @level2type=N'COLUMN',@level2name=N'VersionNumber'
GO
