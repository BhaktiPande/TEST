/*
   Friday, March 20, 20153:39:07 PM
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
CREATE TABLE dbo.com_Document
	(
	DocumentId int NOT NULL IDENTITY (1, 1),
	DocumentName varchar(255) NOT NULL,
	GUID varchar(100) NOT NULL,
	Description varchar(512) NOT NULL,
	DocumentPath varchar(512) NOT NULL,
	FileSize bigint NOT NULL,
	FileType nvarchar(50) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	PK_com_Document PRIMARY KEY CLUSTERED 
	(
	DocumentId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Friday, March 20, 20153:48:03 PM
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
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (79, '079 com_Document_Create', 'Create com_Document_Create', 'Arundhati')
