/*
   Wednesday, March 11, 201510:59:46 AM
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
CREATE TABLE dbo.usr_UserResetPassword
	(
	UserPasswordId int NOT NULL,
	UserInfoId int NOT NULL,
	CreatedOn datetime NOT NULL,
	HashCode nvarchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.usr_UserResetPassword ADD CONSTRAINT
	PK_usr_UserResetPassword PRIMARY KEY CLUSTERED 
	(
	UserPasswordId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_UserResetPassword SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------

/*
   Wednesday, March 11, 201511:00:48 AM
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserResetPassword ADD CONSTRAINT
	FK_usr_UserResetPassword_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserResetPassword SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (74, '074 usr_UserResetPassword_Create', 'Create usr_UserResetPassword', 'Arundhati')
