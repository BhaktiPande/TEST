
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
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_CreatedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_ModeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_cmu_CommunicationRuleModeMaster_TemplateId
GO
ALTER TABLE dbo.tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId FOREIGN KEY
	(
	TemplateId
	) REFERENCES dbo.tra_TemplateMaster
	(
	TemplateMasterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_com_Code_ModeCodeId FOREIGN KEY
	(
	ModeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
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

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (130, '130 cmu_CommunicationRuleModeMaster_Alter', 'Alter cmu_CommunicationRuleModeMaster foreign key names', 'Ashashree')
