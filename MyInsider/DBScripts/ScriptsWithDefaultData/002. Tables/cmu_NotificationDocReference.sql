/****** Object:  Table [dbo].[cmu_NotificationDocReference]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_NotificationDocReference](
	[NotificationQueueId] [bigint] NOT NULL,
	[CompanyIdentifierCodeId] [int] NULL,
	[DocumentName] [varchar](255) NOT NULL,
	[GUID] [varchar](400) NOT NULL,
	[DocumentPath] [varchar](512) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationDocReference', N'COLUMN',N'NotificationQueueId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'refers: cmu_NotificationQueue. If document is stored remotely, then when sending notification, pull the document onto server that will run the notification sender job and then update the DocumentPath as per the server location from which notification sender job is run.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationDocReference', @level2type=N'COLUMN',@level2name=N'NotificationQueueId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationDocReference', N'COLUMN',N'CompanyIdentifierCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'refers: com_Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationDocReference', @level2type=N'COLUMN',@level2name=N'CompanyIdentifierCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationDocReference', N'COLUMN',N'GUID'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If document is pulled to location where notification sender job runs then, prefix CompanyIdentifierCodeId to GUID to have unique document name on physical folder location. On master we can possibly have 2 docs with same GUID but of different CompanyIdentifierCodeId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationDocReference', @level2type=N'COLUMN',@level2name=N'GUID'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationDocReference', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationDocReference', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationDocReference', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationDocReference', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId] FOREIGN KEY([NotificationQueueId])
REFERENCES [dbo].[cmu_NotificationQueue] ([NotificationQueueId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference] CHECK CONSTRAINT [FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_com_Code_CompanyIdentifierCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationDocReference_com_Code_CompanyIdentifierCodeId] FOREIGN KEY([CompanyIdentifierCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_com_Code_CompanyIdentifierCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference] CHECK CONSTRAINT [FK_cmu_NotificationDocReference_com_Code_CompanyIdentifierCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference] CHECK CONSTRAINT [FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationDocReference]'))
ALTER TABLE [dbo].[cmu_NotificationDocReference] CHECK CONSTRAINT [FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy]
GO
