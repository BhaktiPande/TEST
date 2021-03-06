/*
   Tuesday, May 12, 201511:14:53 AM
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
ALTER TABLE dbo.eve_EventLog ADD
	CreatedBy int NOT NULL CONSTRAINT DF_eve_EventLog_CreatedBy DEFAULT 1
GO
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (125, '125 eve_EventLog_Alter', 'Alter eve_EventLog add column CreatedBy', 'Arundhati')

