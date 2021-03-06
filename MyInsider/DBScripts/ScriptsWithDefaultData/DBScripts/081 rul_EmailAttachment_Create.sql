/*
   Monday, March 23, 201511:28:32 AM
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
CREATE TABLE dbo.rul_EmailAttachment
	(
	MapToTypeCodeId int NULL,
	MapToId int NULL,
	DocumentId int NULL,
	CreatedBy int NULL,
	CreatedOn datetime NULL,
	ModifiedBy int NULL,
	ModifiedOn datetime NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_EmailAttachment', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Document'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_EmailAttachment', N'COLUMN', N'DocumentId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_EmailAttachment', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_EmailAttachment', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.rul_EmailAttachment SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_EmailAttachment', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
/*FOREIGN KEY REFERENCE APPLICATION*/
/*
   Monday, March 23, 201511:28:32 AM
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
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_EmailAttachment ADD CONSTRAINT
	FK_rul_EmailAttachment_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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

-----------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (81, '081 rul_EmailAttachment_Create', 'Created table for generic email attachment record storage', 'Ashashree')

