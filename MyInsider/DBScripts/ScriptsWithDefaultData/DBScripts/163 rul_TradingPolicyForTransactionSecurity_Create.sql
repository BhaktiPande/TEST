/*
   Friday, August 21, 20153:54:41 PM
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
CREATE TABLE dbo.rul_TradingPolicyForTransactionSecurity
	(
	TradingPolicyId int NOT NULL,
	MapToTypeCodeId int NOT NULL,
	TransactionModeCodeId int NOT NULL,
	SecurityTypeCodeId int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'CONTROL') as Contr_Per 

/*Alter table to add combined primary key and foreign key references*/

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
ALTER TABLE dbo.rul_TradingPolicy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity ADD CONSTRAINT
	PK_rul_TradingPolicyForTransactionSecurity PRIMARY KEY CLUSTERED 
	(
	TradingPolicyId,
	MapToTypeCodeId,
	TransactionModeCodeId,
	SecurityTypeCodeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity ADD CONSTRAINT
	FK_rul_TradingPolicyForTransactionSecurity_rul_TradingPolicy_TradingPolicyId FOREIGN KEY
	(
	TradingPolicyId
	) REFERENCES dbo.rul_TradingPolicy
	(
	TradingPolicyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity ADD CONSTRAINT
	FK_rul_TradingPolicyForTransactionSecurity_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity ADD CONSTRAINT
	FK_rul_TradingPolicyForTransactionSecurity_com_Code_TransactionModeCodeId FOREIGN KEY
	(
	TransactionModeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity ADD CONSTRAINT
	FK_rul_TradingPolicyForTransactionSecurity_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicyForTransactionSecurity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicyForTransactionSecurity', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (163, '163 rul_TradingPolicyForTransactionSecurity_Create', 'Create rul_TradingPolicyForTransactionSecurity', 'Ashashree')
