/*
   Thursday, January 29, 201511:53:29 AM
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
CREATE TABLE dbo.usr_RoleMaster
	(
	RoleId int NOT NULL,
	RoleName nvarchar(100) NOT NULL,
	Description nvarchar(255) NULL,
	StatusCodeId int NOT NULL,
	LandingPageURL nvarchar(255) NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.usr_RoleMaster ADD CONSTRAINT
	PK_usr_RoleMaster PRIMARY KEY CLUSTERED 
	(
	RoleId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_RoleMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'CONTROL') as Contr_Per 


INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (7, '007 usr_RoleMaster_Create', 'To create role table', 'Arundhati')