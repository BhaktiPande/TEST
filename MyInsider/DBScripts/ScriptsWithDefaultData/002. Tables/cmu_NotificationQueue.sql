/****** Object:  Table [dbo].[cmu_NotificationQueue]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_NotificationQueue](
	[NotificationQueueId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyIdentifierCodeId] [int] NULL,
	[RuleModeId] [int] NOT NULL,
	[ModeCodeId] [int] NOT NULL,
	[EventLogId] [bigint] NULL,
	[UserId] [int] NOT NULL,
	[UserContactInfo] [nvarchar](250) NULL,
	[Subject] [nvarchar](150) NULL,
	[Contents] [nvarchar](max) NULL,
	[Signature] [nvarchar](200) NULL,
	[CommunicationFrom] [varchar](100) NULL,
	[ResponseStatusCodeId] [int] NULL,
	[ResponseMessage] [nvarchar](200) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_cmu_NotificationQueue] PRIMARY KEY CLUSTERED 
(
	[NotificationQueueId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'CompanyIdentifierCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code : Have a code within the com_Code config group to uniquely identify implementing company with specific company in master database.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'CompanyIdentifierCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'RuleModeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: cmu_CommunicationRuleModeMaster' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'RuleModeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'ModeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - 156001:Letter, 156002:Email, 156003:SMS, 156004: Text Alert, 156005: Popup Alert' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'ModeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'EventLogId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: eve_EventLog.  The event from eventlog against which the communication is sent.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'EventLogId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'UserId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo. UserId to for whom notification mode is personalized.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'UserId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'UserContactInfo'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will store the user''s email address for Email / mobile number for SMS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'UserContactInfo'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'Subject'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This is applicable for email only. SMS / alert / popup will have this as NULL.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'Subject'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'Contents'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will store the formatted email / SMS / alert / popup content that will be used by the communication sender to send notification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'Contents'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'Signature'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Store the signature whereever applicable in case of notification. Applies to Email/Letter type of templates.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'Signature'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'CommunicationFrom'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'will store the email Id in case of email or the contact number in case of SMS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'CommunicationFrom'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_NotificationQueue', N'COLUMN',N'ResponseStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, will be null when record is added to queue and will get updated when record is processed for sending notification.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_NotificationQueue', @level2type=N'COLUMN',@level2name=N'ResponseStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId] FOREIGN KEY([RuleModeId])
REFERENCES [dbo].[cmu_CommunicationRuleModeMaster] ([RuleModeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId] FOREIGN KEY([CompanyIdentifierCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_ModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_com_Code_ModeCodeId] FOREIGN KEY([ModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_ModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_com_Code_ModeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId] FOREIGN KEY([ResponseStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_eve_EventLog_EventLogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_eve_EventLog_EventLogId] FOREIGN KEY([EventLogId])
REFERENCES [dbo].[eve_EventLog] ([EventLogId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_eve_EventLog_EventLogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_eve_EventLog_EventLogId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue]  WITH CHECK ADD  CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_NotificationQueue_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_NotificationQueue]'))
ALTER TABLE [dbo].[cmu_NotificationQueue] CHECK CONSTRAINT [FK_cmu_NotificationQueue_usr_UserInfo_UserId]
GO
