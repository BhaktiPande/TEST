/*
   Monday, April 13, 20154:34:25 PM
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
CREATE TABLE dbo.tra_TransactionLetter
	(
	TransactionLetterId bigint NOT NULL IDENTITY (1, 1),
	TransactionMasterId bigint NOT NULL,
	LetterForCodeId int NOT NULL,
	Date nvarchar(50) NOT NULL,
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
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	PK_tra_TransactionLetter PRIMARY KEY CLUSTERED 
	(
	TransactionLetterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Monday, April 13, 20154:39:36 PM
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
ALTER TABLE dbo.tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_com_Code_LetterForCodeId FOREIGN KEY
	(
	LetterForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeId
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
ALTER TABLE dbo.tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (98, '098 tra_TransactionLetter_Create', 'Create tra_TransactionLetter_Create', 'Arundhati')
