/*
   Monday, February 16, 20156:34:20 PM
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
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT FK_com_Code_com_CodeGroup_CodeGroupId
GO
ALTER TABLE dbo.com_CodeGroup SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CodeGroup', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT DF_com_Code_IsVisible
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT DF_com_Code_ModifiedBy
GO
CREATE TABLE dbo.Tmp_com_Code
	(
	CodeID int NOT NULL,
	CodeName nvarchar(512) NOT NULL,
	CodeGroupId int NOT NULL,
	Description nvarchar(255) NULL,
	IsVisible bit NOT NULL,
	IsActive int NOT NULL,
	DisplayOrder int NOT NULL,
	DisplayCode nvarchar(50) NULL,
	ParentCodeId int NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_Code SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'1: Active, 0: Inactive'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Code', N'COLUMN', N'IsActive'
GO
ALTER TABLE dbo.Tmp_com_Code ADD CONSTRAINT
	DF_com_Code_IsVisible DEFAULT ((1)) FOR IsVisible
GO
ALTER TABLE dbo.Tmp_com_Code ADD CONSTRAINT
	DF_com_Code_IsActive DEFAULT 1 FOR IsActive
GO
ALTER TABLE dbo.Tmp_com_Code ADD CONSTRAINT
	DF_com_Code_ModifiedBy DEFAULT ((1)) FOR ModifiedBy
GO
IF EXISTS(SELECT * FROM dbo.com_Code)
	 EXEC('INSERT INTO dbo.Tmp_com_Code (CodeID, CodeName, CodeGroupId, Description, IsVisible, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
		SELECT CodeID, CodeName, CodeGroupId, Description, IsVisible, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn FROM dbo.com_Code WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_CountryId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_designationId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_GradeId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_StateId
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT FK_com_Code_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_Category
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_SubCategory
GO
ALTER TABLE dbo.com_GridHeaderSetting
	DROP CONSTRAINT FK_com_GridHeaderSetting_com_Code_GridTypeCodeId
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_com_Code_Status
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_com_Code_UserTypeCodeId
GO
ALTER TABLE dbo.usr_UserTypeActivity
	DROP CONSTRAINT FK_usr_UserTypeActivity_com_Code_UserTypeCodeId
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT FK_com_Code_com_Code_ParentCodeId
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_com_Code_Status
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_com_Code_ObjectType
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_com_Code_Status
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_com_Code_ModuleCodeId
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_com_Code_CategoryCodeId
GO
ALTER TABLE dbo.usr_UserRelation
	DROP CONSTRAINT FK_usr_UserRelation_com_Code_relationTypeCodeId
GO
DROP TABLE dbo.com_Code
GO
EXECUTE sp_rename N'dbo.Tmp_com_Code', N'com_Code', 'OBJECT' 
GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	PK_com_Code PRIMARY KEY CLUSTERED 
	(
	CodeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	FK_com_Code_com_CodeGroup_CodeGroupId FOREIGN KEY
	(
	CodeGroupId
	) REFERENCES dbo.com_CodeGroup
	(
	CodeGroupID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	FK_com_Code_com_Code_ParentCodeId FOREIGN KEY
	(
	ParentCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserRelation ADD CONSTRAINT
	FK_usr_UserRelation_com_Code_relationTypeCodeId FOREIGN KEY
	(
	RelationTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRelation SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_com_Code_ObjectType FOREIGN KEY
	(
	ModuleCodeID
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_com_Code_Status FOREIGN KEY
	(
	StatusCodeID
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_MenuMaster ADD CONSTRAINT
	FK_mst_MenuMaster_com_Code_Status FOREIGN KEY
	(
	StatusCodeID
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_MenuMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserTypeActivity ADD CONSTRAINT
	FK_usr_UserTypeActivity_com_Code_UserTypeCodeId FOREIGN KEY
	(
	UserTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserTypeActivity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserTypeActivity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_RoleMaster ADD CONSTRAINT
	FK_usr_RoleMaster_com_Code_Status FOREIGN KEY
	(
	StatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleMaster ADD CONSTRAINT
	FK_usr_RoleMaster_com_Code_UserTypeCodeId FOREIGN KEY
	(
	UserTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_GridHeaderSetting ADD CONSTRAINT
	FK_com_GridHeaderSetting_com_Code_GridTypeCodeId FOREIGN KEY
	(
	GridTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_CountryId FOREIGN KEY
	(
	CountryId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_DepartmentId FOREIGN KEY
	(
	DepartmentId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_designationId FOREIGN KEY
	(
	DesignationId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_GradeId FOREIGN KEY
	(
	GradeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_StateId FOREIGN KEY
	(
	StateId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	FK_com_Code_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_Category FOREIGN KEY
	(
	Category
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_SubCategory FOREIGN KEY
	(
	SubCategory
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 
--------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (53, '053 com_Code_ALter AddColumn', 'added column for active/inactive status in com_code', 'Arundhati')
