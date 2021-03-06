/*
   Tuesday, April 28, 20153:58:31 PM
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
ALTER TABLE dbo.com_GridHeaderSetting ADD
	ColumnWidth int NOT NULL CONSTRAINT DF_com_GridHeaderSetting_ColumnWidth DEFAULT 0
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
/*
   Thursday, April 30, 201511:52:50 AM
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
ALTER TABLE dbo.com_GridHeaderSetting ADD
	ColumnAlignment int NOT NULL CONSTRAINT DF_com_GridHeaderSetting_ColumnAlignment DEFAULT 155001
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (109, '109 com_GridHeaderSetting_Alter', 'Alter com_GridHeaderSetting, add column columnwidth', 'Arundhati')
