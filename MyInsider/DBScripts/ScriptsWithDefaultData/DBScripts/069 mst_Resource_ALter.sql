/*
   Wednesday, March 04, 20153:17:05 PM
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
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_com_Code_ModuleCodeId
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_com_Code_CategoryCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT DF_mst_Resource_OriginalResourceValue
GO
CREATE TABLE dbo.Tmp_mst_Resource
	(
	ResourceId int NOT NULL IDENTITY (1, 1),
	ResourceKey varchar(15) NOT NULL,
	ResourceValue nvarchar(255) NOT NULL,
	ResourceCulture varchar(10) NOT NULL,
	ModuleCodeId int NOT NULL,
	CategoryCodeId int NOT NULL,
	OriginalResourceValue nvarchar(255) NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Referes to com_Code, CodeGroupId = 103'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_mst_Resource', N'COLUMN', N'ModuleCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Referes to com_Code, CodeGroupId = 104'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_mst_Resource', N'COLUMN', N'CategoryCodeId'
GO
ALTER TABLE dbo.Tmp_mst_Resource ADD CONSTRAINT
	DF_mst_Resource_OriginalResourceValue DEFAULT ('') FOR OriginalResourceValue
GO
SET IDENTITY_INSERT dbo.Tmp_mst_Resource OFF
GO
IF EXISTS(SELECT * FROM dbo.mst_Resource)
	 EXEC('INSERT INTO dbo.Tmp_mst_Resource (ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
		SELECT ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn FROM dbo.mst_Resource WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.mst_Resource
GO
EXECUTE sp_rename N'dbo.Tmp_mst_Resource', N'mst_Resource', 'OBJECT' 
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	PK_mst_Resource PRIMARY KEY CLUSTERED 
	(
	ResourceId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

/*
   Wednesday, March 04, 20153:19:06 PM
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
CREATE UNIQUE NONCLUSTERED INDEX uk_mst_Resource_ResourceKey_Culture ON dbo.mst_Resource
	(
	ResourceKey,
	ResourceCulture
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (69, '069 mst_Resource_ALter', 'Alter mst_Resource add identity, uk on resourcekey and culture', 'Arundhati')
