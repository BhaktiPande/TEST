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
ALTER TABLE dbo.Companies ADD
	SmtpServer varchar(200) NULL,
	SmtpPortNumber int NULL,
	SmtpUserName varchar(200) NULL,
	SmtpPassword varchar(200) NULL,
	LinkedServerName varchar(50) NULL
GO
ALTER TABLE dbo.Companies SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Companies', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Companies', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Companies', 'Object', 'CONTROL') as Contr_Per 

---------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (1, '001 Companies_Add_Smtp_Fields_Linked_Servername_Alter.sql', 'Add columns for Smtp configuration fields and linked servername', 'Ashashree')
