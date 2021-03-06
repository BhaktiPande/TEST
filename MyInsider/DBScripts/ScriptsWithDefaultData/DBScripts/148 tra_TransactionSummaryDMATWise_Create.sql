/*
   Thursday, April 30, 201512:10:59 PM
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
CREATE TABLE dbo.tra_TransactionSummaryDMATWise
	(
	TransactionSummaryDMATWiseId bigint NOT NULL IDENTITY (1, 1),
	YearCodeId int NOT NULL,
	PeriodCodeId int NOT NULL,
	UserInfoId int NOT NULL,
	UserInfoIdRelative int NULL,
	SecurityTypeCodeId int NOT NULL,
	DMATDetailsID int NOT NULL ,
	OpeningBalance decimal(10, 0) NOT NULL,
	SellQuantity decimal(10, 0) NOT NULL,
	BuyQuantity decimal(10, 0) NOT NULL,
	ClosingBalance decimal(10, 0) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	DF_tra_TransactionSummaryDMATWise_OpeningBalance DEFAULT 0 FOR OpeningBalance
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	DF_tra_TransactionSummaryDMATWise_SellQuantity DEFAULT 0 FOR SellQuantity
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	DF_tra_TransactionSummaryDMATWise_BuyQuantity DEFAULT 0 FOR BuyQuantity
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	DF_tra_TransactionSummaryDMATWise_ClosingBalance DEFAULT 0 FOR ClosingBalance
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	PK_tra_TransactionSummaryDMATWise PRIMARY KEY CLUSTERED 
	(
	TransactionSummaryDMATWiseId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------

/*
   Thursday, April 30, 201512:14:21 PM
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_com_Code_YearCode FOREIGN KEY
	(
	YearCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_com_Code_PeriodCodeId FOREIGN KEY
	(
	PeriodCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
	(
	UserInfoIdRelative
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD CONSTRAINT
	FK_tra_TransactionSummaryDMATWise_usr_DMATDetails_DMATDetailsID FOREIGN KEY
	(
	DMATDetailsID
	) REFERENCES dbo.usr_DMATDetails
	(
	DMATDetailsID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------

/*
   Wednesday, June 10, 201511:09:05 PM
   User: sa
   Server: BALTIX\SQLEXPRESSbaltix
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
ALTER TABLE dbo.tra_TransactionSummaryDMATWise ADD
	Value decimal(25, 4) NOT NULL CONSTRAINT DF_tra_TransactionSummaryDMATWise_Value DEFAULT 0
GO
ALTER TABLE dbo.tra_TransactionSummaryDMATWise SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummaryDMATWise', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (148, '148 tra_TransactionSummaryDMATWiseDMATWise_Create', 'Create tra_TransactionSummaryDMATWiseDMATWise', 'Arundhati')
