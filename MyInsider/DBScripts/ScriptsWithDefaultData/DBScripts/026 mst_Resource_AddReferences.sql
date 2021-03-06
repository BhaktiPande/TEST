/*
   Friday, January 30, 201512:30:57 PM
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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	FK_mst_Resource_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	FK_mst_Resource_com_Code_ModuleCodeId FOREIGN KEY
	(
	ModuleCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	FK_mst_Resource_com_Code_CategoryCodeId FOREIGN KEY
	(
	CategoryCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per 

GO
-----------------------------------------------------------------------------------------------------------------
/*
   Friday, January 30, 201512:36:59 PM
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
DECLARE @v sql_variant 
SET @v = N'Referes to com_Code, CodeGroupId = 103'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mst_Resource', N'COLUMN', N'ModuleCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Referes to com_Code, CodeGroupId = 104'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mst_Resource', N'COLUMN', N'CategoryCodeId'
GO
ALTER TABLE dbo.mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (26, '026 mst_Resource_AddReferences', 'To add references to resource table', 'Arundhati')
