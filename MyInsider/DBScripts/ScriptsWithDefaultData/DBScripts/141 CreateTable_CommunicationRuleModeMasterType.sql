

CREATE TYPE [dbo].[CommunicationRuleModeMasterType] AS TABLE(
[RuleModeId] [int] NOT NULL,
	[RuleId] [int] NOT NULL,
	[ModeCodeId] [int] NOT NULL,
	[TemplateId] [int] NULL,
	[WaitDaysAfterTriggerEvent] [int] NOT NULL,
	[ExecFrequencyCodeId] [int] NULL,
	[NotificationLimit] [int] NULL,
	[UserId] [int] NULL
)
--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (141, '141 CreateTable_CommunicationRuleModeMasterType', 'Create CreateTable_CommunicationRuleModeMasterType', 'GS')

