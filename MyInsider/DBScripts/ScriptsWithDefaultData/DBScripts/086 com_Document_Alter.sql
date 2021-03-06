/*
   Wednesday, March 25, 20152:26:04 PM
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
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_com_Document
	(
	DocumentId int NOT NULL IDENTITY (1, 1),
	DocumentName varchar(255) NOT NULL,
	GUID varchar(100) NOT NULL,
	Description varchar(512) NOT NULL,
	DocumentPath varchar(512) NOT NULL,
	FileSize bigint NOT NULL,
	FileType nvarchar(50) NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	PurposeCodeId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_Document SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, codegRoupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Depending on the MapToType, it is key from the respective table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'MapToId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 133'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'PurposeCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_com_Document ON
GO
IF EXISTS(SELECT * FROM dbo.com_Document)
	 EXEC('INSERT INTO dbo.Tmp_com_Document (DocumentId, DocumentName, GUID, Description, DocumentPath, FileSize, FileType, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT DocumentId, DocumentName, GUID, Description, DocumentPath, FileSize, FileType, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.com_Document WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_com_Document OFF
GO
--ALTER TABLE dbo.rul_PolicyDocument
--	DROP CONSTRAINT FK_rul_PolicyDocument_com_Document_DocumentId
--GO
ALTER TABLE dbo.rul_EmailAttachment
	DROP CONSTRAINT FK_rul_EmailAttachment_com_Document_DocumentId
GO
DROP TABLE dbo.com_Document
GO
EXECUTE sp_rename N'dbo.Tmp_com_Document', N'com_Document', 'OBJECT' 
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	PK_com_Document PRIMARY KEY CLUSTERED 
	(
	DocumentId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_EmailAttachment ADD CONSTRAINT
	FK_rul_EmailAttachment_com_Document_DocumentId FOREIGN KEY
	(
	DocumentId
	) REFERENCES dbo.com_Document
	(
	DocumentId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_EmailAttachment SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
--ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
--	FK_rul_PolicyDocument_com_Document_DocumentId FOREIGN KEY
--	(
--	DocumentId
--	) REFERENCES dbo.com_Document
--	(
--	DocumentId
--	) ON UPDATE  NO ACTION 
--	 ON DELETE  NO ACTION 
	
--GO
ALTER TABLE dbo.rul_PolicyDocument SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Wednesday, March 25, 20152:27:04 PM
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
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_com_Code_MapToType FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_com_Code_Purpose FOREIGN KEY
	(
	PurposeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Wednesday, March 25, 20154:45:31 PM
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
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_com_Code_MapToType
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_com_Code_Purpose
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_com_Document
	(
	DocumentId int NOT NULL IDENTITY (1, 1),
	DocumentName varchar(255) NOT NULL,
	GUID varchar(100) NOT NULL,
	Description varchar(512) NULL,
	DocumentPath varchar(512) NOT NULL,
	FileSize bigint NOT NULL,
	FileType nvarchar(50) NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	PurposeCodeId int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_Document SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, codegRoupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Depending on the MapToType, it is key from the respective table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'MapToId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 133'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_Document', N'COLUMN', N'PurposeCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_com_Document ON
GO
IF EXISTS(SELECT * FROM dbo.com_Document)
	 EXEC('INSERT INTO dbo.Tmp_com_Document (DocumentId, DocumentName, GUID, Description, DocumentPath, FileSize, FileType, MapToTypeCodeId, MapToId, PurposeCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT DocumentId, DocumentName, GUID, Description, DocumentPath, FileSize, FileType, MapToTypeCodeId, MapToId, PurposeCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.com_Document WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_com_Document OFF
GO
ALTER TABLE dbo.rul_EmailAttachment
	DROP CONSTRAINT FK_rul_EmailAttachment_com_Document_DocumentId
GO
--ALTER TABLE dbo.rul_PolicyDocument
--	DROP CONSTRAINT FK_rul_PolicyDocument_com_Document_DocumentId
--GO
DROP TABLE dbo.com_Document
GO
EXECUTE sp_rename N'dbo.Tmp_com_Document', N'com_Document', 'OBJECT' 
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	PK_com_Document PRIMARY KEY CLUSTERED 
	(
	DocumentId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_com_Code_MapToType FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_com_Code_Purpose FOREIGN KEY
	(
	PurposeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
--ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
--	FK_rul_PolicyDocument_com_Document_DocumentId FOREIGN KEY
--	(
--	DocumentId
--	) REFERENCES dbo.com_Document
--	(
--	DocumentId
--	) ON UPDATE  NO ACTION 
--	 ON DELETE  NO ACTION 
	
--GO
ALTER TABLE dbo.rul_PolicyDocument SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_EmailAttachment ADD CONSTRAINT
	FK_rul_EmailAttachment_com_Document_DocumentId FOREIGN KEY
	(
	DocumentId
	) REFERENCES dbo.com_Document
	(
	DocumentId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_EmailAttachment SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Thursday, March 26, 201510:50:52 AM
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
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_com_Code_MapToType
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_com_Code_Purpose
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Document
	DROP COLUMN MapToTypeCodeId, MapToId, PurposeCodeId
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (86, '086 com_Document_Alter', 'ALTER com_Document', 'Arundhati')
