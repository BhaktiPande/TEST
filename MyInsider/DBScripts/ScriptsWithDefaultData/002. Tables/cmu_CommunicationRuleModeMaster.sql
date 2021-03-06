/****** Object:  Table [dbo].[cmu_CommunicationRuleModeMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_CommunicationRuleModeMaster](
	[RuleModeId] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[ModeCodeId] [int] NOT NULL,
	[TemplateId] [int] NULL,
	[WaitDaysAfterTriggerEvent] [int] NOT NULL,
	[ExecFrequencyCodeId] [int] NULL,
	[NotificationLimit] [int] NULL,
	[UserId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_cmu_CommunicationRuleModeMaster] PRIMARY KEY CLUSTERED 
(
	[RuleModeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'RuleId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: cmu_CommunicationRuleMaster' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'RuleId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'ModeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - 156001:Letter, 156002:Email, 156003:SMS, 156004: Text Alert, 156005: Popup Alert' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'ModeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'TemplateId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: tra_TemplateMaster. This will be NULL when user defines new RuleMode for him/herself under already existing rule. In such a case, there will be no template associated with RuleMode but the content details will be stored in table cmu_CommunicationRuleModePersonalize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'TemplateId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'WaitDaysAfterTriggerEvent'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can be different for different modes of communication - Email, SMS, Alert etc. If value is N then send/display notification N days after trigger event. If value is -N then send/display notification N days before trigger event. If N=0 then send/display notification without waiting.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'WaitDaysAfterTriggerEvent'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'ExecFrequencyCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - 158001:  Halt execution, 158002: Once, 158003: Daily. Will be NULL if rule is defined for manual execution - manual execution will add to notification queue immediately as one time notification.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'ExecFrequencyCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'NotificationLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will indicate maximum number of times that the notification can be sent. If count(notificationqueue records for that particular onset communication event ) < NotificationLimit then continue to send notification. If ExecFrequencyCodeId = Once, NotificationLimit=1.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'NotificationLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModeMaster', N'COLUMN',N'UserId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo. For global RuleMode, this will be NULL. Will store UserId when user defines new RuleMode for self under already defined Rule or when user defines new Rule for self and defines RuleModes for self under that new Rule. Contents to use for this RuleMode defined by user will be stored in table cmu_CommunicationRuleModePersonalize.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModeMaster', @level2type=N'COLUMN',@level2name=N'UserId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[cmu_CommunicationRuleMaster] ([RuleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_com_Code_ExecFrequencyCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_com_Code_ExecFrequencyCodeId] FOREIGN KEY([ExecFrequencyCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_com_Code_ExecFrequencyCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_com_Code_ExecFrequencyCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_com_Code_ModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_com_Code_ModeCodeId] FOREIGN KEY([ModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_com_Code_ModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_com_Code_ModeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[tra_TemplateMaster] ([TemplateMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_cmu_CommunicationRuleModeMaster_WaitDaysAfterTriggerEvent]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModeMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cmu_CommunicationRuleModeMaster_WaitDaysAfterTriggerEvent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cmu_CommunicationRuleModeMaster] ADD  CONSTRAINT [DF_cmu_CommunicationRuleModeMaster_WaitDaysAfterTriggerEvent]  DEFAULT ((0)) FOR [WaitDaysAfterTriggerEvent]
END


End
GO
