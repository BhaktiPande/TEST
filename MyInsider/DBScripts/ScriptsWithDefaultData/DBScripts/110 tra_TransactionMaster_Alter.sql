/*
   Wednesday, April 29, 20156:05:17 PM
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
	DROP CONSTRAINT FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId
GO
ALTER TABLE dbo.rul_TradingPolicy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy
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
	TransactionMasterId bigint NOT NULL IDENTITY (1, 1),
	PreclearanceRequestId bigint NULL,
	UserInfoId int NOT NULL,
	DisclosureTypeCodeId int NOT NULL,
	TransactionStatusCodeId int NOT NULL,
	NoHoldingFlag bit NOT NULL,
	TradingPolicyId int NOT NULL,
	PeriodEndDate datetime NULL,
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
DECLARE @v sql_variant 
SET @v = N'If DisclosureTypeCodeId = Period End, then this will store PeriodEndDate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'PeriodEndDate'
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_NoHoldingFlag DEFAULT ((0)) FOR NoHoldingFlag
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionMaster ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TransactionMaster)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionMaster (TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TransactionMaster WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionMaster OFF
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId
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
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId FOREIGN KEY
	(
	TradingPolicyId
	) REFERENCES dbo.rul_TradingPolicy
	(
	TradingPolicyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
CREATE TRIGGER [dbo].[tr_tra_TransactionMaster_DisclosureStatus] ON dbo.tra_TransactionMaster
FOR UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT = 153001
	DECLARE @nMapToTypeCodeId INT = 132005 -- Disclosure Transaction
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	
	DECLARE @nDisclosureTypeCodeId_Initial INT = 147001
	DECLARE @nDisclosureTypeCodeId_Continuous INT = 147002
	DECLARE @nDisclosureTypeCodeId_PeriodEnd INT = 147003

	DECLARE @nTransactionStatus_DocumentUploaded INT = 148001
	DECLARE @nTransactionStatus_Confirmed INT = 148003
	DECLARE @nTransactionStatus_SoftCopySubmitted INT = 148004
	DECLARE @nTransactionStatus_HardCopySubmitted INT = 148005
	DECLARE @nTransactionStatus_HardCopySubmittedByCO INT = 148006

	DECLARE @nTransactionStatusOld INT, @nTransactionStatusNew INT
	DECLARE @nDisclosureTypeCodeIdOld INT, @nDisclosureTypeCodeIdNew INT
	
	DECLARE @nEventCodeID_InitialDisclosureDetailsEntered INT = 153007
	DECLARE @nEventCodeID_InitialDisclosureUploaded INT = 153008
	DECLARE @nEventCodeID_InitialDisclosureSubmittedSoftcopy INT = 153009
	DECLARE @nEventCodeID_InitialDisclosureSubmittedHardcopy INT = 153010
	DECLARE @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange INT = 153012

	DECLARE @nEventCodeID_ContinuousDisclosureDetailsEntered INT = 153019
	DECLARE @nEventCodeID_ContinuousDisclosureUploaded INT = 153020
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy INT = 153021
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedHardcopy INT = 153022
	DECLARE @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange INT = 153024

	DECLARE @nEventCodeID_PEDisclosureDetailsEntered INT = 153029
	DECLARE @nEventCodeID_PEDisclosureUploaded INT = 153030
	DECLARE @nEventCodeID_PEDisclosureSubmittedSoftcopy INT = 153031
	DECLARE @nEventCodeID_PEDisclosureSubmittedHardcopy INT = 153032
	DECLARE @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange INT = 153034

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nTransactionStatusNew = TransactionStatusCodeId, 
			@nDisclosureTypeCodeIdNew = DisclosureTypeCodeId,
			@nMapToId = TransactionMasterId,
			@nUserInfoId = UserInfoId
	FROM #tmpValues_New
	
	SELECT	@nTransactionStatusOld = TransactionStatusCodeId,
			@nDisclosureTypeCodeIdOld = DisclosureTypeCodeId
	FROM #tmpValues_Old
	
	-- Initial disclosures
	IF ISNULL(@nTransactionStatusNew, 0) <> ISNULL(@nTransactionStatusOld, 0)
	BEGIN
		If @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Initial
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureDetailsEntered
			END
			IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureUploaded
			END
			IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedSoftcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedHardcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange
			END
		END
		
		-- Continuous disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Continuous
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureDetailsEntered
			END
			IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureUploaded
			END
			IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedHardcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange
			END
		END
		-- Period End disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_PeriodEnd
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureDetailsEntered
			END
			IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureUploaded
			END
			IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedSoftcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedHardcopy
			END
			IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange
			END
		END

		-- 
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
		VALUES(@nEventCodeID, GETDATE(), @nUserInfoId, @nMapToTypeCodeId, @nMapToId)
	END
	
    -- Insert statements for trigger here

END
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (110, '110 tra_TransactionMaster_Alter', 'Alter tra_TransactionMaster, add column PeriodEndDate', 'Arundhati')
