/*
   Thursday, February 05, 201511:24:24 AM
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
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_com_Code_StatusCode
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_com_Code_UserType
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT PK_usr_Authentication
GO
ALTER TABLE dbo.usr_Authentication ADD CONSTRAINT
	PK_usr_Authentication_1 PRIMARY KEY CLUSTERED 
	(
	UserInfoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_Authentication
	DROP COLUMN AuthenticationId, UserTypeCodeId, StatusCodeId
GO
ALTER TABLE dbo.usr_Authentication SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------


/*
   Thursday, February 05, 201511:26:10 AM
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
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT PK_usr_Authentication_1
GO
ALTER TABLE dbo.usr_Authentication ADD CONSTRAINT
	PK_usr_Authentication PRIMARY KEY CLUSTERED 
	(
	UserInfoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX uk_usr_Authentication_LoginId ON dbo.usr_Authentication
	(
	LoginID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.usr_Authentication SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (37, '037 usr_Authentication_Alter', 'Alter usr_Authenitcation and add references', 'Arundhati')
