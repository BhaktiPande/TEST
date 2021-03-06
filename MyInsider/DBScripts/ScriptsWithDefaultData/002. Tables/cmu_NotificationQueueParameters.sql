/****** Object:  Table [dbo].[cmu_NotificationQueueParameters]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_NotificationQueueParameters](
	[NotificationQueueId] [bigint] NOT NULL,
	[EventLogId] [bigint] NOT NULL,
	[UserInfoId] [int] NULL,
	[MapToTypeCodeId] [int] NULL,
	[MapToId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueueParameters', N'COLUMN',N'NotificationQueueId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers:  cmu_NotificationQueue. Parameter IDs stored here will be used to construct the formatted Contents within table cmu_NotificationQueue. Thus, first scan will fill tables cmu_NotificationQueue and cmu_NotificationQueueParameters. Then next scan will process parameters and UPDATE Contents and prepare cmu_NotificationQueue for actual formatted and complete notification content.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueueParameters', @level2type=N'COLUMN',@level2name=N'NotificationQueueId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueueParameters', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueueParameters', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueueParameters', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueueParameters', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueueParameters', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueueParameters', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId] FOREIGN KEY([NotificationQueueId])
REFERENCES [dbo].[cmu_NotificationQueue] ([NotificationQueueId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_eve_EventLog_EventLogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_eve_EventLog_EventLogId] FOREIGN KEY([EventLogId])
REFERENCES [dbo].[eve_EventLog] ([EventLogId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_eve_EventLog_EventLogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_eve_EventLog_EventLogId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueueParameters]'))
ALTER TABLE [dbo].[cmu_NotificationQueueParameters] CHECK CONSTRAINT [FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId]
GO
