/*
   Thursday, March 19, 201512:27:20 PM
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
ALTER TABLE dbo.usr_ActivityResourceMapping ADD
	ColumnName varchar(100) NOT NULL CONSTRAINT DF_usr_ActivityResourceMapping_ColumnName DEFAULT ''
GO
ALTER TABLE dbo.usr_ActivityResourceMapping SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_ActivityResourceMapping', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_ActivityResourceMapping', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_ActivityResourceMapping', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (77, '077 usr_ActivityResourceMapping_Alter', 'Alter 077 usr_ActivityResourceMapping add column ColumnName', 'Arundhati')
