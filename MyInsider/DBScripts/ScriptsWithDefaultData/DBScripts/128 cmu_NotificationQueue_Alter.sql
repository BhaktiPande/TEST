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
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_cmu_NotificationQueue_UserId
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_cmu_NotificationQueue_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (128, '128 cmu_NotificationQueue_Alter', 'Alter cmu_NotificationQueue foreign key names', 'Ashashree')
