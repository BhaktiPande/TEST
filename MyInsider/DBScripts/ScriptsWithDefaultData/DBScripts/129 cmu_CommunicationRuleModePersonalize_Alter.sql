
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
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_UserId
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_CreatedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_RuleModeId
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModeMaster_RuleModeId FOREIGN KEY
	(
	RuleModeId
	) REFERENCES dbo.cmu_CommunicationRuleModeMaster
	(
	RuleModeId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (129, '129 cmu_CommunicationRuleModePersonalize_Alter', 'Alter cmu_CommunicationRuleModePersonalize foreign key names', 'Ashashree')
