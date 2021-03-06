/*
   Thursday, February 26, 20155:11:37 PM
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
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_com_Code_ObjectType
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_com_Code_Status
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_usr_Activity
	(
	ActivityID int NOT NULL,
	ScreenName nvarchar(100) NOT NULL,
	ActivityName nvarchar(100) NOT NULL,
	ModuleCodeID int NOT NULL,
	ControlName nvarchar(100) NULL,
	Description nvarchar(512) NULL,
	StatusCodeID int NOT NULL,
	DisplayOrder varchar(9) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_usr_Activity SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Display order used while assigning activities against role or delegation. First 3 characters for Module, next 3 for Screen, next 3 for activity'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_Activity', N'COLUMN', N'DisplayOrder'
GO
ALTER TABLE dbo.Tmp_usr_Activity ADD CONSTRAINT
	DF_usr_Activity_DisplayOrder DEFAULT '' FOR DisplayOrder
GO
IF EXISTS(SELECT * FROM dbo.usr_Activity)
	 EXEC('INSERT INTO dbo.Tmp_usr_Activity (ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.usr_Activity WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.usr_DelegationDetails
	DROP CONSTRAINT FK_usr_DelegationDetails_usr_Activity_ActivityId
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_Activity_ActivityID
GO
ALTER TABLE dbo.usr_UserTypeActivity
	DROP CONSTRAINT FK_usr_UserTypeActivity_usr_Activity_ActivityId
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_usr_Activity_ActivityID
GO
DROP TABLE dbo.usr_Activity
GO
EXECUTE sp_rename N'dbo.Tmp_usr_Activity', N'usr_Activity', 'OBJECT' 
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	PK_usr_Activity PRIMARY KEY CLUSTERED 
	(
	ActivityID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_com_Code_ObjectType FOREIGN KEY
	(
	ModuleCodeID
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_com_Code_Status FOREIGN KEY
	(
	StatusCodeID
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_MenuMaster ADD CONSTRAINT
	FK_mst_MenuMaster_usr_Activity_ActivityID FOREIGN KEY
	(
	ActivityID
	) REFERENCES dbo.usr_Activity
	(
	ActivityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_MenuMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserTypeActivity ADD CONSTRAINT
	FK_usr_UserTypeActivity_usr_Activity_ActivityId FOREIGN KEY
	(
	ActivityId
	) REFERENCES dbo.usr_Activity
	(
	ActivityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserTypeActivity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_RoleActivity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DelegationDetails ADD CONSTRAINT
	FK_usr_DelegationDetails_usr_Activity_ActivityId FOREIGN KEY
	(
	ActivityId
	) REFERENCES dbo.usr_Activity
	(
	ActivityID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DelegationDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DelegationDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DelegationDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DelegationDetails', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (65, '065 usr_Activity_Alter', 'Alter usr_Activity add column DisplayOrder', 'Arundhati')
