/*
   Thursday, April 16, 20154:49:25 PM
   User: sa
   Server: EMERGEBOI
   Database: InsiderTradingDepl_Company1
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
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_com_Code_LetterForCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tra_TemplateMaster
	(
	TemplateMasterId int NOT NULL IDENTITY (1, 1),
	DisclosureTypeCodeId int NOT NULL,
	LetterForCodeId int NOT NULL,
	IsActive bit NOT NULL,
	Date datetime NOT NULL,
	ToAddress1 nvarchar(250) NOT NULL,
	ToAddress2 nvarchar(250) NOT NULL,
	Subject nvarchar(150) NOT NULL,
	Contents nvarchar(2000) NOT NULL,
	Signature nvarchar(200) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupID = 147
147001: Initial
147002: Continuous
147003: Period End'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'DisclosureTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupID = 151
151001: Insider
151002: CO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'LetterForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'1: Active, 0: Inactive'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'IsActive'
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TemplateMaster ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TemplateMaster)
	 EXEC('INSERT INTO dbo.Tmp_tra_TemplateMaster (TemplateMasterId, DisclosureTypeCodeId, LetterForCodeId, IsActive, Date, ToAddress1, ToAddress2, Subject, Contents, Signature, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TemplateMasterId, DisclosureTypeCodeId, LetterForCodeId, IsActive, CONVERT(datetime, Date), ToAddress1, ToAddress2, Subject, Contents, Signature, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TemplateMaster WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TemplateMaster OFF
GO
DROP TABLE dbo.tra_TemplateMaster
GO
EXECUTE sp_rename N'dbo.Tmp_tra_TemplateMaster', N'tra_TemplateMaster', 'OBJECT' 
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	PK_tra_TemplateMaster PRIMARY KEY CLUSTERED 
	(
	TemplateMasterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId FOREIGN KEY
	(
	DisclosureTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_com_Code_LetterForCodeId FOREIGN KEY
	(
	LetterForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

/*
   Thursday, April 16, 20154:52:09 PM
   User: sa
   Server: EMERGEBOI
   Database: InsiderTradingDepl_Company1
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
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId
GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_com_Code_LetterForCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tra_TransactionLetter
	(
	TransactionLetterId bigint NOT NULL IDENTITY (1, 1),
	TransactionMasterId bigint NOT NULL,
	LetterForCodeId int NOT NULL,
	Date datetime NOT NULL,
	ToAddress1 nvarchar(250) NOT NULL,
	ToAddress2 nvarchar(250) NOT NULL,
	Subject nvarchar(150) NOT NULL,
	Contents nvarchar(2000) NOT NULL,
	Signature nvarchar(200) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionLetter ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TransactionLetter)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionLetter (TransactionLetterId, TransactionMasterId, LetterForCodeId, Date, ToAddress1, ToAddress2, Subject, Contents, Signature, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TransactionLetterId, TransactionMasterId, LetterForCodeId, CONVERT(datetime, Date), ToAddress1, ToAddress2, Subject, Contents, Signature, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TransactionLetter WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionLetter OFF
GO
DROP TABLE dbo.tra_TransactionLetter
GO
EXECUTE sp_rename N'dbo.Tmp_tra_TransactionLetter', N'tra_TransactionLetter', 'OBJECT' 
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	PK_tra_TransactionLetter PRIMARY KEY CLUSTERED 
	(
	TransactionLetterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_com_Code_LetterForCodeId FOREIGN KEY
	(
	LetterForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId FOREIGN KEY
	(
	TransactionMasterId
	) REFERENCES dbo.tra_TransactionMaster
	(
	TransactionMasterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (105, '105 tra_TemplateMaster_tra_TransactionLetter_Alter', 'ALter 105 tra_TemplateMaster tra_TransactionLetter column type changed to Date', 'Arundhati')
