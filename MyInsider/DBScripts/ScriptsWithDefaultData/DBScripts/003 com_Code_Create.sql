/*
   Wednesday, January 28, 20155:07:31 PM
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
CREATE TABLE dbo.com_Code
	(
	CodeID int NOT NULL,
	CodeName nvarchar(512) NOT NULL,
	CodeGroupId int NOT NULL,
	Description nvarchar(255) NULL,
	IsVisible bit NOT NULL,
	LastModifiedDate datetime NOT NULL,
	DisplayOrder int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	PK_com_Code PRIMARY KEY CLUSTERED 
	(
	CodeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per 

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (3, '003 com_Code_Create', 'To create Code table', 'Arundhati')