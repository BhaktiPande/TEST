/*
   Wednesday, April 01, 20155:50:43 PM
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
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_com_Code_DocumentCategory
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_com_Code_DocumentSubCategory
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_com_Code_WindowStatus
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_mst_Company_CompanyId
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT DF_rul_PolicyDocument_DisplayInPolicyDocumentFlag
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT DF_rul_PolicyDocument_SendEmailUpdateFlag
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT DF_rul_PolicyDocument_DocumentViewFlag
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT DF_rul_PolicyDocument_DocumentViewAgreeFlag
GO
CREATE TABLE dbo.Tmp_rul_PolicyDocument
	(
	PolicyDocumentId int NOT NULL IDENTITY (1, 1),
	PolicyDocumentName nvarchar(100) NOT NULL,
	DocumentCategoryCodeId int NOT NULL,
	DocumentSubCategoryCodeId int NULL,
	ApplicableFrom datetime NOT NULL,
	ApplicableTo datetime NULL,
	CompanyId int NOT NULL,
	DisplayInPolicyDocumentFlag bit NOT NULL,
	SendEmailUpdateFlag bit NOT NULL,
	DocumentViewFlag bit NOT NULL,
	DocumentViewAgreeFlag bit NOT NULL,
	WindowStatusCodeId int NOT NULL,
	IsDeleted bit NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 129'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'DocumentCategoryCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 130'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'DocumentSubCategoryCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'1: Display, 0: Do not display'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'DisplayInPolicyDocumentFlag'
GO
DECLARE @v sql_variant 
SET @v = N'1: Send, 0: Do not send'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'SendEmailUpdateFlag'
GO
DECLARE @v sql_variant 
SET @v = N'1: View, 0: Do not view'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'DocumentViewFlag'
GO
DECLARE @v sql_variant 
SET @v = N'1: ViewAndAgree, 0: Do not view and agree'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'DocumentViewAgreeFlag'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId 131
131001: Activate
131002: Deactivate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'WindowStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Flag to indicate if record is deleted. 0:Not deleted, 1:Deleted'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_PolicyDocument', N'COLUMN', N'IsDeleted'
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument ADD CONSTRAINT
	DF_rul_PolicyDocument_DisplayInPolicyDocumentFlag DEFAULT ((1)) FOR DisplayInPolicyDocumentFlag
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument ADD CONSTRAINT
	DF_rul_PolicyDocument_SendEmailUpdateFlag DEFAULT ((1)) FOR SendEmailUpdateFlag
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument ADD CONSTRAINT
	DF_rul_PolicyDocument_DocumentViewFlag DEFAULT ((1)) FOR DocumentViewFlag
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument ADD CONSTRAINT
	DF_rul_PolicyDocument_DocumentViewAgreeFlag DEFAULT ((1)) FOR DocumentViewAgreeFlag
GO
ALTER TABLE dbo.Tmp_rul_PolicyDocument ADD CONSTRAINT
	DF_rul_PolicyDocument_IsDeleted DEFAULT 0 FOR IsDeleted
GO
SET IDENTITY_INSERT dbo.Tmp_rul_PolicyDocument ON
GO
IF EXISTS(SELECT * FROM dbo.rul_PolicyDocument)
	 EXEC('INSERT INTO dbo.Tmp_rul_PolicyDocument (PolicyDocumentId, PolicyDocumentName, DocumentCategoryCodeId, DocumentSubCategoryCodeId, ApplicableFrom, ApplicableTo, CompanyId, DisplayInPolicyDocumentFlag, SendEmailUpdateFlag, DocumentViewFlag, DocumentViewAgreeFlag, WindowStatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT PolicyDocumentId, PolicyDocumentName, DocumentCategoryCodeId, DocumentSubCategoryCodeId, ApplicableFrom, ApplicableTo, CompanyId, DisplayInPolicyDocumentFlag, SendEmailUpdateFlag, DocumentViewFlag, DocumentViewAgreeFlag, WindowStatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.rul_PolicyDocument WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_rul_PolicyDocument OFF
GO
DROP TABLE dbo.rul_PolicyDocument
GO
EXECUTE sp_rename N'dbo.Tmp_rul_PolicyDocument', N'rul_PolicyDocument', 'OBJECT' 
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	PK_rul_PolicyDocument PRIMARY KEY CLUSTERED 
	(
	PolicyDocumentId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_com_Code_DocumentCategory FOREIGN KEY
	(
	DocumentCategoryCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_com_Code_DocumentSubCategory FOREIGN KEY
	(
	DocumentSubCategoryCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_com_Code_WindowStatus FOREIGN KEY
	(
	WindowStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (88, '088 rul_PolicyDocument_Alter', 'Alter Policy Document to add Delete flag indicator', 'Ashashree')
