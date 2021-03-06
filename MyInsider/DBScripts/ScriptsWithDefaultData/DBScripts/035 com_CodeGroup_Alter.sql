/*
   Thursday, February 05, 201511:08:20 AM
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
ALTER TABLE dbo.com_CodeGroup ADD
	ParentCodeGroupId int NULL
GO
ALTER TABLE dbo.com_CodeGroup SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------

-- Add references
/*
   Thursday, February 05, 201511:09:12 AM
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
ALTER TABLE dbo.com_CodeGroup ADD CONSTRAINT
	FK_com_CodeGroup_com_CodeGroup_ParentCodeGroupId FOREIGN KEY
	(
	ParentCodeGroupId
	) REFERENCES dbo.com_CodeGroup
	(
	CodeGroupID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CodeGroup SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (35, '035 com_CodeGroup_Alter', 'Alter com_CodeGroup and add references', 'Arundhati')
