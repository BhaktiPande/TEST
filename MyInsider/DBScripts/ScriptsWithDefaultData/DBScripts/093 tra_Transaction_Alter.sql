/*
   Tuesday, April 07, 20153:26:08 PM
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
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_com_Code_DisclosureType
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_com_Code_TransactionStatus
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId
GO
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT DF_tra_TransactionMaster_NoHoldingFlag
GO
CREATE TABLE dbo.Tmp_tra_TransactionMaster
	(
	TransactionMasterId bigint NOT NULL,
	PreclearanceRequestId bigint NULL,
	UserInfoId int NOT NULL,
	DisclosureTypeCodeId int NOT NULL,
	TransactionStatusCodeId int NOT NULL,
	NoHoldingFlag bit NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 147
147001: Initial
147002: Continuous
147003: PeriodEnd'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'DisclosureTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 148
148001: Document Uploaded
148002: Not Confirmed
148003: Confirmed'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'TransactionStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'1: No Holding, 0: Details are given'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'NoHoldingFlag'
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_NoHoldingFlag DEFAULT ((0)) FOR NoHoldingFlag
GO
IF EXISTS(SELECT * FROM dbo.tra_TransactionMaster)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionMaster (TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag)
		SELECT TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag FROM dbo.tra_TransactionMaster WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId
GO
DROP TABLE dbo.tra_TransactionMaster
GO
EXECUTE sp_rename N'dbo.Tmp_tra_TransactionMaster', N'tra_TransactionMaster', 'OBJECT' 
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	PK_tra_TransactionMaster PRIMARY KEY CLUSTERED 
	(
	TransactionMasterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.tra_TransactionDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------

/*
   Tuesday, April 07, 20153:28:12 PM
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
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

/*
   Tuesday, April 07, 20153:32:07 PM
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
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId
GO
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_mst_Company_CompanyId
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tra_PreclearanceRequest
	(
	PreclearanceRequestId bigint NOT NULL IDENTITY (1, 1),
	PreclearanceRequestForCodeId int NOT NULL,
	UserInfoId int NOT NULL,
	UserInfoIdRelative int NULL,
	TransactionTypeCodeId int NOT NULL,
	SecurityTypeCodeId int NOT NULL,
	SecuritiesToBeTradedQty decimal(15, 4) NOT NULL,
	PreclearanceStatusCodeId int NOT NULL,
	CompanyId int NOT NULL,
	ProposedTradeRateRangeFrom decimal(15, 4) NOT NULL,
	ProposedTradeRateRangeTo decimal(15, 4) NOT NULL,
	DMATDetailsID int NOT NULL,
	ReasonForNotTradingCodeId int NULL,
	ReasonForNotTradingText varchar(30) NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 142
142001: Self
142002: Relative'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'PreclearanceRequestForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers usr_UserInfo. Id of the user for whom, or whose relative, the request is to be made.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'UserInfoId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'TransactionTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 144
144001: Confirmed
144002: Approved
144003: Rejected'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'SecurityTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 146
146001: Equity
146002: Derivative'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'PreclearanceStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 145'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'ReasonForNotTradingCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_tra_PreclearanceRequest ON
GO
IF EXISTS(SELECT * FROM dbo.tra_PreclearanceRequest)
	 EXEC('INSERT INTO dbo.Tmp_tra_PreclearanceRequest (PreclearanceRequestId, PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId, SecuritiesToBeTradedQty, PreclearanceStatusCodeId, CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, ReasonForNotTradingCodeId, ReasonForNotTradingText)
		SELECT PreclearanceRequestId, PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId, SecuritiesToBeTradedQty, PreclearanceStatusCodeId, CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, ReasonForNotTradingCodeId, ReasonForNotTradingText FROM dbo.tra_PreclearanceRequest WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_PreclearanceRequest OFF
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId
GO
DROP TABLE dbo.tra_PreclearanceRequest
GO
EXECUTE sp_rename N'dbo.Tmp_tra_PreclearanceRequest', N'tra_PreclearanceRequest', 'OBJECT' 
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	PK_tra_PreclearanceRequest PRIMARY KEY CLUSTERED 
	(
	PreclearanceRequestId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor FOREIGN KEY
	(
	PreclearanceRequestForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
	(
	UserInfoIdRelative
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode FOREIGN KEY
	(
	TransactionTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode FOREIGN KEY
	(
	PreclearanceStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId FOREIGN KEY
	(
	DMATDetailsID
	) REFERENCES dbo.usr_DMATDetails
	(
	DMATDetailsID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading FOREIGN KEY
	(
	ReasonForNotTradingCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*
   Tuesday, April 07, 20153:33:38 PM
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
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

/*
   Tuesday, April 07, 20153:37:02 PM
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
	DROP CONSTRAINT FK_tra_TransactionDetails_mst_Company_CompanyId
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_ForUserId
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
CREATE TABLE dbo.Tmp_tra_TransactionDetails
	(
	TransactionDetailsId bigint NOT NULL,
	TransactionMasterId bigint NOT NULL,
	SecurityTypeCodeId int NOT NULL,
	ForUserInfoId int NOT NULL,
	DMATDetailsID int NOT NULL,
	CompanyId int NOT NULL,
	NoOfSharesVotingRightsAcquired decimal(5, 0) NOT NULL,
	PercentageOfSharesVotingRightsAcquired decimal(4, 2) NOT NULL,
	DateOfAcquisition datetime NOT NULL,
	DateOfInitimationToCompany datetime NOT NULL,
	ModeOfAcquisitionCodeId int NOT NULL,
	ShareHoldingSubsequentToAcquisition decimal(5, 0) NOT NULL,
	ExchangeCodeId int NOT NULL,
	TransactionTypeCodeId int NOT NULL,
	Quantity decimal(5, 0) NOT NULL,
	Value decimal(10, 0) NOT NULL,
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
IF EXISTS(SELECT * FROM dbo.tra_TransactionDetails)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionDetails (TransactionDetailsId, TransactionMasterId, SecurityTypeCodeId, ForUserInfoId, DMATDetailsID, CompanyId, NoOfSharesVotingRightsAcquired, PercentageOfSharesVotingRightsAcquired, DateOfAcquisition, DateOfInitimationToCompany, ModeOfAcquisitionCodeId, ShareHoldingSubsequentToAcquisition, ExchangeCodeId, TransactionTypeCodeId, Quantity, Value)
		SELECT TransactionDetailsId, TransactionMasterId, SecurityTypeCodeId, ForUserInfoId, DMATDetailsID, CompanyId, NoOfSharesVotingRightsAcquired, PercentageOfSharesVotingRightsAcquired, DateOfAcquisition, DateOfInitimationToCompany, ModeOfAcquisitionCodeId, ShareHoldingSubsequentToAcquisition, ExchangeCodeId, TransactionTypeCodeId, Quantity, Value FROM dbo.tra_TransactionDetails WITH (HOLDLOCK TABLOCKX)')
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
-----------------------------------------------------------------------------------------------------
/*
   Tuesday, April 07, 20153:38:28 PM
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
ALTER TABLE dbo.tra_TransactionDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (93, '093 tra_Transaction_Alter', 'Alter all tra_ tables for columns created and modified', 'Arundhati')
