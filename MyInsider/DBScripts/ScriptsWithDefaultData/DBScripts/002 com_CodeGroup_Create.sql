/*
   Wednesday, January 28, 20155:02:42 PM
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
CREATE TABLE dbo.com_CodeGroup
	(
	CodeGroupID int NOT NULL,
	COdeGroupName nvarchar(512) NOT NULL,
	Description nvarchar(1024) NULL,
	IsVisible bit NOT NULL,
	IsEditable bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.com_CodeGroup ADD CONSTRAINT
	PK_com_CodeGroup PRIMARY KEY CLUSTERED 
	(
	CodeGroupID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_CodeGroup SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'CONTROL') as Contr_Per 

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (2, '002 com_CodeGroup_Create', 'To create CodeGroup table', 'Arundhati')