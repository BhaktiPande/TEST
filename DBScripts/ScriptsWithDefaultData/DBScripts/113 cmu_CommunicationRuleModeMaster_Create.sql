/*
   Friday, May 08, 201511:38:54 AM
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
CREATE TABLE dbo.cmu_CommunicationRuleModeMaster
	(
	RuleModeId int NOT NULL IDENTITY (1, 1),
	RuleId int NOT NULL,
	ModeCodeId int NOT NULL,
	TemplateId int NULL,
	WaitDaysAfterTriggerEvent int NOT NULL,
	ExecFrequencyCodeId int NULL,
	NotificationLimit int NULL,
	--LastExecTimestamp datetime NULL,
	UserId int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers: cmu_CommunicationRuleMaster'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'RuleId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - 156001:Letter, 156002:Email, 156003:SMS, 156004: Text Alert, 156005: Popup Alert'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'ModeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: tra_TemplateMaster. This will be NULL when user defines new RuleMode for him/herself under already existing rule. In such a case, there will be no template associated with RuleMode but the content details will be stored in table cmu_CommunicationRuleModePersonalize'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'TemplateId'
GO
DECLARE @v sql_variant 
SET @v = N'Can be different for different modes of communication - Email, SMS, Alert etc. If value is N then send/display notification N days after trigger event. If value is -N then send/display notification N days before trigger event. If N=0 then send/display notification without waiting.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'WaitDaysAfterTriggerEvent'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - 158001:  Halt execution, 158002: Once, 158003: Daily. Will be NULL if rule is defined for manual execution - manual execution will add to notification queue immediately as one time notification.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'ExecFrequencyCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'This will indicate maximum number of times that the notification can be sent. If count(notificationqueue records for that particular onset communication event ) < NotificationLimit then continue to send notification. If ExecFrequencyCodeId = Once, NotificationLimit=1.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'NotificationLimit'
GO
--DECLARE @v sql_variant 
--SET @v = N'Very first time this will be NULL or system start date. Update after every execution. Use to calculate next execution as per ExecFrequencyCodeId'
--EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'LastExecTimestamp'
--GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo. For global RuleMode, this will be NULL. Will store UserId when user defines new RuleMode for self under already defined Rule or when user defines new Rule for self and defines RuleModes for self under that new Rule. Contents to use for this RuleMode defined by user will be stored in table cmu_CommunicationRuleModePersonalize.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModeMaster', N'COLUMN', N'UserId'
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	DF_cmu_CommunicationRuleModeMaster_WaitDaysAfterTriggerEvent DEFAULT 0 FOR WaitDaysAfterTriggerEvent
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	PK_cmu_CommunicationRuleModeMaster PRIMARY KEY CLUSTERED 
	(
	RuleModeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per 


/*Add FOREIGN KEY references*/

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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleMaster SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_ModeCodeId FOREIGN KEY
	(
	ModeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_TemplateId FOREIGN KEY
	(
	TemplateId
	) REFERENCES dbo.tra_TemplateMaster
	(
	TemplateMasterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_com_Code_ExecFrequencyCodeId FOREIGN KEY
	(
	ExecFrequencyCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (113, '113 cmu_CommunicationRuleModeMaster_Create', 'Create cmu_CommunicationRuleModeMaster', 'Ashashree')
