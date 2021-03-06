/*
   Monday, August 03, 20152:10:13 PM
   User: sa
   Server: emergeboi
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
CREATE TABLE dbo.tra_OppositeTranasctionCodes
	(
	TransactionCodeId int NOT NULL,
	OppositeTransactionCodeId int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tra_OppositeTranasctionCodes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------

/*
   Monday, August 03, 20152:13:06 PM
   User: sa
   Server: emergeboi
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
ALTER TABLE dbo.tra_OppositeTranasctionCodes ADD CONSTRAINT
	FK_tra_OppositeTranasctionCodes_com_Code_TransactionCodeId FOREIGN KEY
	(
	TransactionCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_OppositeTranasctionCodes ADD CONSTRAINT
	FK_tra_OppositeTranasctionCodes_com_Code_OppositeTransactionCodeId FOREIGN KEY
	(
	OppositeTransactionCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_OppositeTranasctionCodes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_OppositeTranasctionCodes', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (159, '159 tra_OppositeTranasctionCodes_Create', 'Create tra_OppositeTranasctionCodes', 'Arundhati')
