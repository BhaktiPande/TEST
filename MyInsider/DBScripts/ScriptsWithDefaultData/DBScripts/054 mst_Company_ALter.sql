/*
   Tuesday, February 17, 201512:57:34 PM
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
CREATE TABLE dbo.Tmp_mst_Company
	(
	CompanyId int NOT NULL,
	CompanyName nvarchar(200) NOT NULL,
	Address nvarchar(1024) NOT NULL,
	Website nvarchar(512) NULL,
	EmailId nvarchar(250) NULL,
	IsImplementing bit NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_mst_Company SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_mst_Company ADD CONSTRAINT
	DF_mst_Company_IsImplementing DEFAULT 0 FOR IsImplementing
GO
IF EXISTS(SELECT * FROM dbo.mst_Company)
	 EXEC('INSERT INTO dbo.Tmp_mst_Company (CompanyId, CompanyName, Address, Website, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT CompanyId, CompanyName, Address, Website, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.mst_Company WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_mst_Company_CompanyId
GO
DROP TABLE dbo.mst_Company
GO
EXECUTE sp_rename N'dbo.Tmp_mst_Company', N'mst_Company', 'OBJECT' 
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	PK_mst_Company PRIMARY KEY CLUSTERED 
	(
	CompanyId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------

/*
   Wednesday, February 18, 201511:13:23 AM
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
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT DF_mst_Company_IsImplementing
GO
CREATE TABLE dbo.Tmp_mst_Company
	(
	CompanyId int NOT NULL IDENTITY (1, 1),
	CompanyName nvarchar(200) NOT NULL,
	Address nvarchar(1024) NOT NULL,
	Website nvarchar(512) NULL,
	EmailId nvarchar(250) NULL,
	IsImplementing bit NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_mst_Company SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_mst_Company ADD CONSTRAINT
	DF_mst_Company_IsImplementing DEFAULT ((0)) FOR IsImplementing
GO
SET IDENTITY_INSERT dbo.Tmp_mst_Company ON
GO
IF EXISTS(SELECT * FROM dbo.mst_Company)
	 EXEC('INSERT INTO dbo.Tmp_mst_Company (CompanyId, CompanyName, Address, Website, EmailId, IsImplementing, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT CompanyId, CompanyName, Address, Website, EmailId, IsImplementing, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.mst_Company WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_mst_Company OFF
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_mst_Company_CompanyId
GO
DROP TABLE dbo.mst_Company
GO
EXECUTE sp_rename N'dbo.Tmp_mst_Company', N'mst_Company', 'OBJECT' 
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	PK_mst_Company PRIMARY KEY CLUSTERED 
	(
	CompanyId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (54, '054 mst_Company_ALter', 'added columns emailid and IsImplementing flag in Company Master', 'Arundhati')
