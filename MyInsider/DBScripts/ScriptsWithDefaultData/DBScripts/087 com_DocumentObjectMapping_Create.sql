/*
   Thursday, March 26, 201510:54:24 AM
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
CREATE TABLE dbo.com_DocumentObjectMapping
	(
	DocumentId int NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	PurposeCodeId int NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, codegRoupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_DocumentObjectMapping', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Depending on the MapToType, it is key from the respective table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_DocumentObjectMapping', N'COLUMN', N'MapToId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 133'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_DocumentObjectMapping', N'COLUMN', N'PurposeCodeId'
GO
ALTER TABLE dbo.com_DocumentObjectMapping SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Thursday, March 26, 201510:56:06 AM
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
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Document_DocumentId FOREIGN KEY
	(
	DocumentId
	) REFERENCES dbo.com_Document
	(
	DocumentId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Code_MapToType FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Code_PurposeCode FOREIGN KEY
	(
	PurposeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_DocumentObjectMapping SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Thursday, March 26, 201511:00:44 AM
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
ALTER TABLE dbo.com_DocumentObjectMapping
	DROP CONSTRAINT FK_com_DocumentObjectMapping_com_Code_MapToType
GO
ALTER TABLE dbo.com_DocumentObjectMapping
	DROP CONSTRAINT FK_com_DocumentObjectMapping_com_Code_PurposeCode
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_DocumentObjectMapping
	DROP CONSTRAINT FK_com_DocumentObjectMapping_com_Document_DocumentId
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_com_DocumentObjectMapping
	(
	DocumentObjectMapId int NOT NULL IDENTITY (1, 1),
	DocumentId int NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	PurposeCodeId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_DocumentObjectMapping SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, codegRoupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_DocumentObjectMapping', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Depending on the MapToType, it is key from the respective table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_DocumentObjectMapping', N'COLUMN', N'MapToId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 133'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_DocumentObjectMapping', N'COLUMN', N'PurposeCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_com_DocumentObjectMapping OFF
GO
IF EXISTS(SELECT * FROM dbo.com_DocumentObjectMapping)
	 EXEC('INSERT INTO dbo.Tmp_com_DocumentObjectMapping (DocumentId, MapToTypeCodeId, MapToId, PurposeCodeId)
		SELECT DocumentId, MapToTypeCodeId, MapToId, PurposeCodeId FROM dbo.com_DocumentObjectMapping WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.com_DocumentObjectMapping
GO
EXECUTE sp_rename N'dbo.Tmp_com_DocumentObjectMapping', N'com_DocumentObjectMapping', 'OBJECT' 
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	PK_com_DocumentObjectMapping PRIMARY KEY CLUSTERED 
	(
	DocumentObjectMapId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Document_DocumentId FOREIGN KEY
	(
	DocumentId
	) REFERENCES dbo.com_Document
	(
	DocumentId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Code_MapToType FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_DocumentObjectMapping ADD CONSTRAINT
	FK_com_DocumentObjectMapping_com_Code_PurposeCode FOREIGN KEY
	(
	PurposeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_DocumentObjectMapping', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (87, '087 com_DocumentObjectMapping_Create', 'Create com_DocumentObjectMapping', 'Arundhati')
