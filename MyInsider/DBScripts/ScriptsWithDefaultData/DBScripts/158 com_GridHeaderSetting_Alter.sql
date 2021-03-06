/*
   Tuesday, July 28, 201511:42:08 AM
   User: sa
   Server: emergeboi
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
	OverrideGridTypeCodeId int NULL,
	OverrideResourceKey varchar(15) NULL
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------

/*
   Tuesday, July 28, 201511:58:32 AM
   User: sa
   Server: emergeboi
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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_GridHeaderSetting ADD CONSTRAINT
	FK_com_GridHeaderSetting_com_Code_OverrideGridTypeCodeId FOREIGN KEY
	(
	OverrideGridTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------

/*
   Wednesday, July 29, 201512:54:08 PM
   User: sa
   Server: emergeboi
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
ALTER TABLE dbo.com_GridHeaderSetting
	DROP CONSTRAINT PK_com_GridHeaderSetting
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (158, '158 com_GridHeaderSetting_Alter', 'Alter com_GridHeaderSetting, add override columns', 'Arundhati')
