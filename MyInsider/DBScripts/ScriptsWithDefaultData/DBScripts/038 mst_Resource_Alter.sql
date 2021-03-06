/*
   Thursday, February 05, 201511:48:24 AM
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
CREATE TABLE dbo.Tmp_mst_Resource
	(
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
	DF_mst_Resource_OriginalResourceValue DEFAULT '' FOR OriginalResourceValue
GO
IF EXISTS(SELECT * FROM dbo.mst_Resource)
	 EXEC('INSERT INTO dbo.Tmp_mst_Resource (ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ModifiedBy, ModifiedOn)
		SELECT ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ModifiedBy, ModifiedOn FROM dbo.mst_Resource WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.mst_Resource
GO
EXECUTE sp_rename N'dbo.Tmp_mst_Resource', N'mst_Resource', 'OBJECT' 
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	PK_mst_Resource PRIMARY KEY CLUSTERED 
	(
	ResourceKey,
	ResourceCulture
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

--------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (38, '038 mst_Resource_Alter', 'Alter resource table', 'Arundhati')
