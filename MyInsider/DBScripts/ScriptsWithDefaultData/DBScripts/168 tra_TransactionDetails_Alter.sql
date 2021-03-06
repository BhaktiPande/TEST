/*
   Monday, September 07, 201512:18:08 PM
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
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId
GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_ForUserId
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID
GO
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_com_Code_ExchangeCodeId
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_mst_Company_CompanyId
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId
GO
ALTER TABLE dbo.tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT DF_tra_TransactionDetails_SellQuantity
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT DF_tra_TransactionDetails_SellValue
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT DF_tra_TransactionDetails_LotSize
GO
CREATE TABLE dbo.Tmp_tra_TransactionDetails
	(
	TransactionDetailsId bigint NOT NULL IDENTITY (1, 1),
	TransactionMasterId bigint NOT NULL,
	SecurityTypeCodeId int NOT NULL,
	ForUserInfoId int NOT NULL,
	DMATDetailsID int NOT NULL,
	CompanyId int NOT NULL,
	SecuritiesPriorToAcquisition decimal(10, 0) NOT NULL,
	PerOfSharesPreTransaction decimal(5, 2) NOT NULL,
	DateOfAcquisition datetime NOT NULL,
	DateOfInitimationToCompany datetime NOT NULL,
	ModeOfAcquisitionCodeId int NOT NULL,
	PerOfSharesPostTransaction decimal(5, 2) NOT NULL,
	ExchangeCodeId int NOT NULL,
	TransactionTypeCodeId int NOT NULL,
	Quantity decimal(10, 0) NOT NULL,
	Value decimal(10, 0) NOT NULL,
	Quantity2 decimal(10, 0) NOT NULL,
	Value2 decimal(10, 0) NOT NULL,
	TransactionLetterId bigint NULL,
	LotSize int NOT NULL,
	IsPLCReq int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_TransactionDetails SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodegRoupId = 146
146001: Equity
146002: Derivative'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionDetails', N'COLUMN', N'SecurityTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 149
149001: Market Purchase
149002: Public
149003: Right preferential
149004: Offer'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionDetails', N'COLUMN', N'ModeOfAcquisitionCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'referes com_Code.
CodeGroupId = 116'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionDetails', N'COLUMN', N'ExchangeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionDetails', N'COLUMN', N'TransactionTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'0: Preclearance not req
1: Preclearance req'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionDetails', N'COLUMN', N'IsPLCReq'
GO
ALTER TABLE dbo.Tmp_tra_TransactionDetails ADD CONSTRAINT
	DF_tra_TransactionDetails_SellQuantity DEFAULT ((0)) FOR Quantity2
GO
ALTER TABLE dbo.Tmp_tra_TransactionDetails ADD CONSTRAINT
	DF_tra_TransactionDetails_SellValue DEFAULT ((0)) FOR Value2
GO
ALTER TABLE dbo.Tmp_tra_TransactionDetails ADD CONSTRAINT
	DF_tra_TransactionDetails_LotSize DEFAULT ((0)) FOR LotSize
GO
ALTER TABLE dbo.Tmp_tra_TransactionDetails ADD CONSTRAINT
	DF_tra_TransactionDetails_IsPLCReq DEFAULT 0 FOR IsPLCReq
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionDetails ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TransactionDetails)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionDetails (TransactionDetailsId, TransactionMasterId, SecurityTypeCodeId, ForUserInfoId, DMATDetailsID, CompanyId, SecuritiesPriorToAcquisition, PerOfSharesPreTransaction, DateOfAcquisition, DateOfInitimationToCompany, ModeOfAcquisitionCodeId, PerOfSharesPostTransaction, ExchangeCodeId, TransactionTypeCodeId, Quantity, Value, Quantity2, Value2, TransactionLetterId, LotSize, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TransactionDetailsId, TransactionMasterId, SecurityTypeCodeId, ForUserInfoId, DMATDetailsID, CompanyId, SecuritiesPriorToAcquisition, PerOfSharesPreTransaction, DateOfAcquisition, DateOfInitimationToCompany, ModeOfAcquisitionCodeId, PerOfSharesPostTransaction, ExchangeCodeId, TransactionTypeCodeId, Quantity, Value, Quantity2, Value2, TransactionLetterId, LotSize, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TransactionDetails WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionDetails OFF
GO
DROP TABLE dbo.tra_TransactionDetails
GO
EXECUTE sp_rename N'dbo.Tmp_tra_TransactionDetails', N'tra_TransactionDetails', 'OBJECT' 
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	PK_tra_TransactionDetails PRIMARY KEY CLUSTERED 
	(
	TransactionDetailsId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId FOREIGN KEY
	(
	TransactionLetterId
	) REFERENCES dbo.tra_TransactionLetter
	(
	TransactionLetterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID FOREIGN KEY
	(
	DMATDetailsID
	) REFERENCES dbo.usr_DMATDetails
	(
	DMATDetailsID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId FOREIGN KEY
	(
	ModeOfAcquisitionCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_com_Code_ExchangeCodeId FOREIGN KEY
	(
	ExchangeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId FOREIGN KEY
	(
	TransactionTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_ForUserId FOREIGN KEY
	(
	ForUserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId FOREIGN KEY
	(
	TransactionMasterId
	) REFERENCES dbo.tra_TransactionMaster
	(
	TransactionMasterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (168, '168 tra_TransactionDetails_Alter', 'Alter tra_TransactionDetails, add column IsPCLReq', 'Arundhati')
