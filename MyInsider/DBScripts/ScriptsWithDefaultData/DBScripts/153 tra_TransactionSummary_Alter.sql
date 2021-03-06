/*
   Wednesday, July 01, 20154:20:42 PM
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
ALTER TABLE dbo.tra_TransactionSummary ADD
	SellValue decimal(25, 4) NOT NULL CONSTRAINT DF_tra_TransactionSummary_SellValue DEFAULT 0,
	BuyValue decimal(25, 0) NOT NULL CONSTRAINT DF_tra_TransactionSummary_BuyValue DEFAULT 0
GO
ALTER TABLE dbo.tra_TransactionSummary SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
/*
   Wednesday, July 01, 20154:27:41 PM
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
EXECUTE sp_rename N'dbo.tra_TransactionSummary.SellValue', N'Tmp_Value', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.tra_TransactionSummary.Tmp_Value', N'Value', 'COLUMN' 
GO
ALTER TABLE dbo.tra_TransactionSummary
	DROP CONSTRAINT DF_tra_TransactionSummary_BuyValue
GO
ALTER TABLE dbo.tra_TransactionSummary
	DROP COLUMN BuyValue
GO
ALTER TABLE dbo.tra_TransactionSummary SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (153, '153 tra_TransactionSummary_Alter', 'tra_TransactionSummary added colum BuyValue, SellValue', 'Arundhati')
