IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'CommunicationRuleModeMasterType')
BEGIN
	DROP TYPE CommunicationRuleModeMasterType
END
GO

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