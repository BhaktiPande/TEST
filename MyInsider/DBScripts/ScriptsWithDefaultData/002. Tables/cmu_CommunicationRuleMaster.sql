/****** Object:  Table [dbo].[cmu_CommunicationRuleMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_CommunicationRuleMaster](
	[RuleId] [int] IDENTITY(1,1) NOT NULL,
	[RuleName] [nvarchar](255) NOT NULL,
	[RuleDescription] [nvarchar](1024) NULL,
	[RuleForCodeId] [varchar](50) NOT NULL,
	[RuleCategoryCodeId] [int] NOT NULL,
	[InsiderPersonalizeFlag] [bit] NOT NULL,
	[TriggerEventCodeId] [varchar](500) NULL,
	[OffsetEventCodeId] [varchar](500) NULL,
	[EventsApplyToCodeId] [int] NULL,
	[RuleStatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_cmu_CommunicationRuleMaster] PRIMARY KEY CLUSTERED 
(
	[RuleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'RuleName'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rule name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'RuleName'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'RuleForCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This indicates comma separated list of codes, for whom the rule is applicable for and will help to decide whether user can personalize the rule and whether email content will contain user-list(CO rule can have userlist in content). 159001: Insider, 159002: CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'RuleForCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'RuleCategoryCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code. Manual mode will be selected when user defines new rule for him/herself for immediate and one-time execution. For manual rule, no trigger/offset events will be associated with rule. 157001: Auto, 157002: Manual' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'RuleCategoryCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'InsiderPersonalizeFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Yes=1, No= 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'InsiderPersonalizeFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'TriggerEventCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers : eve_EventLog. Comma separated list of EventCodeIds which should have occurred to trigger the communication rule (use ORing on these event codes - 15300A OR 15300B). Rule will trigger when any one of the trigger events occurs. Can be NULL for manual rule.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'TriggerEventCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'OffsetEventCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers : eve_EventLog. Comma separated list of EventCodeIds which should not occur so that the rule gets triggered(use ANDing on these event codes - NOT (15300C AND 15300D AND 15300E) ). Rule will trigger when none of these events have occurred. Can be NULL for manual rule.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'OffsetEventCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'EventsApplyToCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will store the code indicating whether trigger and offset events apply to Insider/CO. Will be NULL for Manual rules. 163001:Insider, 163002:CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'EventsApplyToCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'RuleStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code. 160001:Active, 160002:Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'RuleStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleMaster', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleMaster', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_EventsApplyToCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_EventsApplyToCodeId] FOREIGN KEY([EventsApplyToCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_EventsApplyToCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_EventsApplyToCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId] FOREIGN KEY([RuleCategoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId] FOREIGN KEY([RuleStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster] CHECK CONSTRAINT [FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_cmu_CommunicationRuleMaster_InsiderPersonalizeFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_cmu_CommunicationRuleMaster_InsiderPersonalizeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cmu_CommunicationRuleMaster] ADD  CONSTRAINT [DF_cmu_CommunicationRuleMaster_InsiderPersonalizeFlag]  DEFAULT ((1)) FOR [InsiderPersonalizeFlag]
END


End
GO
