/*
   Tuesday, April 07, 201512:22:25 PM
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
CREATE TABLE dbo.tra_PreclearanceRequest
	(
	PreclearanceRequestId bigint NOT NULL IDENTITY (1, 1),
	PreclearanceRequestForCodeId int NOT NULL,
	UserInfoId int NOT NULL,
	UserInfoIdRelative int NULL,
	TransactionTypeCodeId int NOT NULL,
	SecurityTypeCodeId int NOT NULL,
	SecuritiesToBeTradedQty DECIMAL(15,4) NOT NULL,
	PreclearanceStatusCodeId int NOT NULL,
	CompanyId int NOT NULL,
	ProposedTradeRateRangeFrom decimal(15,4) NOT NULL,
	ProposedTradeRateRangeTo decimal(15,4) NOT NULL,
	DMATDetailsID int NOT NULL,
	ReasonForNotTradingCodeId int NULL,
	ReasonForNotTradingText varchar(30) NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 142
142001: Self
142002: Relative'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'PreclearanceRequestForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers usr_UserInfo. Id of the user for whom, or whose relative, the request is to be made.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'UserInfoId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'TransactionTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 144
144001: Confirmed
144002: Approved
144003: Rejected'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'SecurityTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 146
146001: Equity
146002: Derivative'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'PreclearanceStatusCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 145'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tra_PreclearanceRequest', N'COLUMN', N'ReasonForNotTradingCodeId'
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	PK_tra_PreclearanceRequest PRIMARY KEY CLUSTERED 
	(
	PreclearanceRequestId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Tuesday, April 07, 201512:34:33 PM
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
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (90, '090 tra_PreclearanceRequest_Create', 'Create tra_PreclearanceRequest', 'Arundhati')
