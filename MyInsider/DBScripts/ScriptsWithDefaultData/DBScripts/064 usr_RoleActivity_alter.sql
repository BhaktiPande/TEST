/*
   Thursday, February 26, 20155:06:18 PM
   User: sa
   Server: EMERGEBOI
   Database: KPCS_InsiderTrading_Company2
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
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_Activity_ActivityID
GO
ALTER TABLE dbo.usr_Activity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_RoleMaster_RoleID
GO
ALTER TABLE dbo.usr_RoleMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_usr_RoleActivity
	(
	ActivityID int NOT NULL,
	RoleID int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_usr_RoleActivity SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.usr_RoleActivity)
	 EXEC('INSERT INTO dbo.Tmp_usr_RoleActivity (ActivityID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT ActivityID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.usr_RoleActivity WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.usr_RoleActivity
GO
EXECUTE sp_rename N'dbo.Tmp_usr_RoleActivity', N'usr_RoleActivity', 'OBJECT' 
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	PK_usr_RoleActivity_1 PRIMARY KEY CLUSTERED 
	(
	ActivityID,
	RoleID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_RoleMaster_RoleID FOREIGN KEY
	(
	RoleID
	) REFERENCES dbo.usr_RoleMaster
	(
	RoleId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_Activity_ActivityID FOREIGN KEY
	(
	ActivityID
	) REFERENCES dbo.usr_Activity
	(
	ActivityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (64, '064 usr_RoleActivity_alter', 'Alter usr_RoleActivity remove column accessmodecodeid, RoleActivityId, add pk on Role-Activity', 'Arundhati')
