/*
   Thursday, May 28, 20154:29:39 PM
   User: sa
   Server: EMERGEBOI
   Database: KPCS_InsiderTrading_Company1
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster
	DROP CONSTRAINT DF_cmu_CommunicationRuleMaster_InsiderPersonalizeFlag
GO
CREATE TABLE dbo.Tmp_cmu_CommunicationRuleMaster
	(
	RuleId int NOT NULL IDENTITY (1, 1),
	RuleName nvarchar(255) NOT NULL,
	RuleDescription nvarchar(1024) NULL,
	RuleForCodeId varchar(50) NOT NULL,
	RuleCategoryCodeId int NOT NULL,
	InsiderPersonalizeFlag bit NOT NULL,
	TriggerEventCodeId varchar(500) NULL,
	OffsetEventCodeId varchar(500) NULL,
	EventsApplyToCodeId int NULL,
	RuleStatusCodeId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_cmu_CommunicationRuleMaster SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Rule name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'RuleName'
GO
DECLARE @v sql_variant 
SET @v = N'This indicates comma separated list of codes, for whom the rule is applicable for and will help to decide whether user can personalize the rule and whether email content will contain user-list(CO rule can have userlist in content). 159001: Insider, 159002: CO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'RuleForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code. Manual mode will be selected when user defines new rule for him/herself for immediate and one-time execution. For manual rule, no trigger/offset events will be associated with rule. 157001: Auto, 157002: Manual'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'RuleCategoryCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Yes=1, No= 0'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'InsiderPersonalizeFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Refers : eve_EventLog. Comma separated list of EventCodeIds which should have occurred to trigger the communication rule (use ORing on these event codes - 15300A OR 15300B). Rule will trigger when any one of the trigger events occurs. Can be NULL for manual rule.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'TriggerEventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers : eve_EventLog. Comma separated list of EventCodeIds which should not occur so that the rule gets triggered(use ANDing on these event codes - NOT (15300C AND 15300D AND 15300E) ). Rule will trigger when none of these events have occurred. Can be NULL for manual rule.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'OffsetEventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'This will store the code indicating whether trigger and offset events apply to Insider/CO. Will be NULL for Manual rules. 163001:Insider, 163002:CO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'EventsApplyToCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code. 160001:Active, 160002:Inactive'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'RuleStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_CommunicationRuleMaster', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.Tmp_cmu_CommunicationRuleMaster ADD CONSTRAINT
	DF_cmu_CommunicationRuleMaster_InsiderPersonalizeFlag DEFAULT ((1)) FOR InsiderPersonalizeFlag
GO
SET IDENTITY_INSERT dbo.Tmp_cmu_CommunicationRuleMaster ON
GO
IF EXISTS(SELECT * FROM dbo.cmu_CommunicationRuleMaster)
	 EXEC('INSERT INTO dbo.Tmp_cmu_CommunicationRuleMaster (RuleId, RuleName, RuleDescription, RuleForCodeId, RuleCategoryCodeId, InsiderPersonalizeFlag, TriggerEventCodeId, OffsetEventCodeId, RuleStatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT RuleId, RuleName, RuleDescription, RuleForCodeId, RuleCategoryCodeId, InsiderPersonalizeFlag, TriggerEventCodeId, OffsetEventCodeId, RuleStatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.cmu_CommunicationRuleMaster WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_cmu_CommunicationRuleMaster OFF
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId
GO
DROP TABLE dbo.cmu_CommunicationRuleMaster
GO
EXECUTE sp_rename N'dbo.Tmp_cmu_CommunicationRuleMaster', N'cmu_CommunicationRuleMaster', 'OBJECT' 
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster ADD CONSTRAINT
	PK_cmu_CommunicationRuleMaster PRIMARY KEY CLUSTERED 
	(
	RuleId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleMaster_com_Code_RuleCategoryCodeId FOREIGN KEY
	(
	RuleCategoryCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleMaster_com_Code_RuleStatusCodeId FOREIGN KEY
	(
	RuleStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleMaster_com_Code_EventsApplyToCodeId FOREIGN KEY
	(
	EventsApplyToCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleMaster_RuleId FOREIGN KEY
	(
	RuleId
	) REFERENCES dbo.cmu_CommunicationRuleMaster
	(
	RuleId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (145, '145 cmu_CommunicationRuleMaster_Alter', 'Alter cmu_CommunicationRuleMaster Add EventsApplyToCodeId column', 'Ashashree')
