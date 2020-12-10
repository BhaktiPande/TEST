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
ALTER TABLE dbo.cmu_NotificationDocReference
	DROP CONSTRAINT FK_cmu_NotificationDocReference_cmu_NotificationDocReference_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationDocReference
	DROP CONSTRAINT FK_cmu_NotificationDocReference_cmu_NotificationDocReference_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'CONTROL') as Contr_Per 
--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (126, '126 cmu_NotificationDocReference_Alter', 'Alter cmu_NotificationDocReference foreign key names', 'Ashashree')
