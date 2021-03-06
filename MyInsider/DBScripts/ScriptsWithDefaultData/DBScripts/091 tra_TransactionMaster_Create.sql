/*
   Tuesday, April 07, 20152:24:25 PM
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
CREATE TABLE dbo.tra_TransactionMaster
	(
	TransactionMasterId bigint NOT NULL,
	PreclearanceRequestId bigint NULL,
	UserInfoId int NOT NULL,
	DisclosureTypeCodeId int NOT NULL,
	TransactionStatusCodeId int NOT NULL,
	NoHoldingFlag bit NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 147
147001: Initial
147002: Continuous
147003: PeriodEnd'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_TransactionMaster', N'COLUMN', N'DisclosureTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 148
148001: Document Uploaded
148002: Not Confirmed
148003: Confirmed'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_TransactionMaster', N'COLUMN', N'TransactionStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'1: No Holding, 0: Details are given'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_TransactionMaster', N'COLUMN', N'NoHoldingFlag'
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_NoHoldingFlag DEFAULT 0 FOR NoHoldingFlag
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	PK_tra_TransactionMaster PRIMARY KEY CLUSTERED 
	(
	TransactionMasterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------
/*
   Tuesday, April 07, 20152:31:58 PM
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
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId FOREIGN KEY
	(
	PreclearanceRequestId
	) REFERENCES dbo.tra_PreclearanceRequest
	(
	PreclearanceRequestId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_com_Code_DisclosureType FOREIGN KEY
	(
	DisclosureTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_com_Code_TransactionStatus FOREIGN KEY
	(
	TransactionStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (91, '091 tra_TransactionMaster_Create', 'create tra_TransactionMaster', 'Arundhati')
