/*
   Tuesday, May 19, 201511:16:09 AM
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
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT DF_tra_TransactionMaster_PartiallyTradedFlag
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT DF_tra_TransactionMaster_SoftCopyReq
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT DF_tra_TransactionMaster_HardCopyReq
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
	PartiallyTradedFlag bit NOT NULL,
	SoftCopyReq bit NOT NULL,
	HardCopyReq bit NOT NULL,
	SecurityTypeCodeId int NULL,
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
DECLARE @v sql_variant 
SET @v = N'In case of preclearance, if no of shares specified in preclearance is greater than the total in transaction details, then this flag becomes 1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'PartiallyTradedFlag'
GO
DECLARE @v sql_variant 
SET @v = N'In case of rule set for multiple transaction, it will be calculated at the time of submission, which will be useful for generating status table for continuous.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'SoftCopyReq'
GO
DECLARE @v sql_variant 
SET @v = N'in case of Initial / Period End disclosure, this field will be null. In case of Continuous, it will not be null. It refers CodeGroupId = 139'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TransactionMaster', N'COLUMN', N'SecurityTypeCodeId'
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_NoHoldingFlag DEFAULT ((0)) FOR NoHoldingFlag
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_PartiallyTradedFlag DEFAULT ((0)) FOR PartiallyTradedFlag
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_SoftCopyReq DEFAULT ((0)) FOR SoftCopyReq
GO
ALTER TABLE dbo.Tmp_tra_TransactionMaster ADD CONSTRAINT
	DF_tra_TransactionMaster_HardCopyReq DEFAULT ((0)) FOR HardCopyReq
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TransactionMaster ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TransactionMaster)
	 EXEC('INSERT INTO dbo.Tmp_tra_TransactionMaster (TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId, PeriodEndDate, PartiallyTradedFlag, SoftCopyReq, HardCopyReq, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId, PeriodEndDate, PartiallyTradedFlag, SoftCopyReq, HardCopyReq, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TransactionMaster WITH (HOLDLOCK TABLOCKX)')
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
	DECLARE @dtEventDate DATETIME = GETDATE()
	DECLARE @dtPeriodEndDate DATETIME

	DECLARE @nTransactionMasterId INT
	DECLARE @dtDateOfAcq DATETIME
	DECLARE @nPeriodType INT
	DECLARE @nYear INT
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @tblTransactionSummary TABLE(UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, ClosingBalance DECIMAL(10))
	
	DECLARE @nDisclosureTypeCodeId_Initial INT = 147001
	DECLARE @nDisclosureTypeCodeId_Continuous INT = 147002
	DECLARE @nDisclosureTypeCodeId_PeriodEnd INT = 147003

	DECLARE @nTransactionStatus_DocumentUploaded INT = 148001
	DECLARE @nTransactionStatus_Confirmed INT = 148003
	DECLARE @nTransactionStatus_SoftCopySubmitted INT = 148004
	DECLARE @nTransactionStatus_HardCopySubmitted INT = 148005
	DECLARE @nTransactionStatus_HardCopySubmittedByCO INT = 148006
	DECLARE @nTransactionStatus_Submitted INT = 148007

	DECLARE @nTransactionStatusOld INT, @nTransactionStatusNew INT
	DECLARE @nDisclosureTypeCodeIdOld INT, @nDisclosureTypeCodeIdNew INT
	
	DECLARE @nEventCodeID_InitialDisclosureDetailsEntered INT = 153007
	DECLARE @nEventCodeID_InitialDisclosureUploaded INT = 153008
	DECLARE @nEventCodeID_InitialDisclosureSubmittedSoftcopy INT = 153009
	DECLARE @nEventCodeID_InitialDisclosureSubmittedHardcopy INT = 153010
	DECLARE @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange INT = 153012
	DECLARE @nEventCodeID_InitialDisclosureConfirmed INT = 153035

	DECLARE @nEventCodeID_ContinuousDisclosureDetailsEntered INT = 153019
	DECLARE @nEventCodeID_ContinuousDisclosureUploaded INT = 153020
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy INT = 153021
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedHardcopy INT = 153022
	DECLARE @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange INT = 153024
	DECLARE @nEventCodeID_ContinuousDisclosureConfirmed INT = 153036

	DECLARE @nEventCodeID_PEDisclosureDetailsEntered INT = 153029
	DECLARE @nEventCodeID_PEDisclosureUploaded INT = 153030
	DECLARE @nEventCodeID_PEDisclosureSubmittedSoftcopy INT = 153031
	DECLARE @nEventCodeID_PEDisclosureSubmittedHardcopy INT = 153032
	DECLARE @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange INT = 153034
	DECLARE @nEventCodeID_PEDisclosureConfirmed INT = 153037

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nTransactionStatusNew = TransactionStatusCodeId, 
			@nDisclosureTypeCodeIdNew = DisclosureTypeCodeId,
			@nMapToId = TransactionMasterId,
			@nUserInfoId = UserInfoId,
			@dtPeriodEndDate = PeriodEndDate,
			@nTransactionMasterId = TransactionMasterId
	FROM #tmpValues_New
	
	SELECT	@nTransactionStatusOld = TransactionStatusCodeId,
			@nDisclosureTypeCodeIdOld = DisclosureTypeCodeId
	FROM #tmpValues_Old
	
	-- Initial disclosures
	IF ISNULL(@nTransactionStatusNew, 0) <> ISNULL(@nTransactionStatusOld, 0)
	BEGIN
		If @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Initial
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureDetailsEntered
			END 
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureUploaded
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedHardcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureConfirmed
			END
		END
		
		-- Continuous disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Continuous
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureDetailsEntered
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureUploaded
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedHardcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureConfirmed
			END
		END
		-- Period End disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_PeriodEnd
		BEGIN
			--SET @dtEventDate = @dtPeriodEndDate
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureDetailsEntered
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureUploaded
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedHardcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureConfirmed
			END
		END

		-- 
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
		VALUES(@nEventCodeID, @dtEventDate, @nUserInfoId, @nMapToTypeCodeId, @nMapToId)
		
		
		
		
		/************************* If TransactionStatus is Confirmed, update Summary table ********************************/
		IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
		BEGIN
			SELECT @dtDateOfAcq = MIN(DateOfAcquisition) FROM tra_TransactionDetails WHERE TransactionMasterId = @nTransactionMasterId
			SELECT @nPeriodType = CodeName FROM com_Code WHERE CodeID = 128002

			-- Find Year
			SELECT @nYear = YEAR(@dtDateOfAcq)
			
			IF MONTH(@dtDateOfAcq) < 4
			BEGIN
				SET @nYear = @nYear - 1
			END

			SELECT @nYearCodeId = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'

			-- Find PeriodCodeId
			SELECT TOP(1) @nPeriodCodeId = CodeID FROM com_Code 
			WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType AND @dtDateOfAcq <= DATEADD(YEAR, @nYear - 1970, CONVERT(DATETIME, Description))
			ORDER BY CONVERT(DATETIME, Description) ASC

			INSERT INTO @tblTransactionSummary(SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, ClosingBalance)
			SELECT TS.SecurityTypeCodeId, TS.UserInfoId, TS.UserInfoIdRelative, ClosingBalance
			FROM tra_TransactionSummary TS JOIN
			(SELECT SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, MAX(TransactionSummaryId) TransactionSummaryId
				FROM tra_TransactionSummary 
				WHERE UserInfoId = @nUserInfoId
				GROUP BY SecurityTypeCodeId, UserInfoId, UserInfoIdRelative
			) TS1 ON TS.TransactionSummaryId = TS1.TransactionSummaryId
			
			INSERT INTO tra_TransactionSummary
			(YearCodeId, PeriodCodeId, UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, OpeningBalance, SellQuantity, BuyQuantity, ClosingBalance)
			SELECT @nYearCodeId, @nPeriodCodeId, TM.UserInfoId, TD.ForUserInfoId, TD.SecurityTypeCodeId, ISNULL(TSOld.ClosingBalance, 0), 0, 0, ISNULL(TSOld.ClosingBalance, 0)
			FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
				LEFT JOIN tra_TransactionSummary TS ON TS.YearCodeId = @nYearCodeId AND TS.PeriodCodeId = @nPeriodCodeId AND TM.UserInfoId = TS.UserInfoId AND TD.ForUserInfoId = TS.UserInfoIdRelative
				LEFT JOIN @tblTransactionSummary TSOld ON TSOld.SecurityTypeCodeId = TD.SecurityTypeCodeId AND TSOld.UserInfoId = TM.UserInfoId AND ISNULL(TSOld.UserInfoIdRelative, 0) = ISNULL(TD.ForUserInfoId, 0)
			WHERE TM.TransactionMasterId = @nTransactionMasterId
				AND TS.TransactionSummaryId IS NULL
			GROUP BY TM.UserInfoId, TD.ForUserInfoId, TD.SecurityTypeCodeId, TSOld.ClosingBalance

			-- Update TransactionSummary
			UPDATE TS
			SET ClosingBalance = ClosingBalance + CASE WHEN TD.TransactionTypeCodeId = 143001 /*Buy*/ THEN TD.Quantity ELSE -TD.Quantity END,
				BuyQuantity = BuyQuantity + CASE WHEN TD.TransactionTypeCodeId = 143001 /*Buy*/ THEN TD.Quantity ELSE 0 END,
				SellQuantity = SellQuantity + CASE WHEN TD.TransactionTypeCodeId = 143001 /*Buy*/ THEN 0 ELSE TD.Quantity END
			FROM tra_TransactionSummary TS
				JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = @nTransactionMasterId
				JOIN tra_TransactionDetails TD ON TD.TransactionMasterId = TM.TransactionMasterId AND TS.YearCodeId = @nYearCodeId 
						AND TS.PeriodCodeId = @nPeriodCodeId AND TM.UserInfoId = TS.UserInfoId AND TD.ForUserInfoId = TS.UserInfoIdRelative
		END
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

--------------------------------------------------------------------------------------------------------
/*
   Tuesday, May 19, 201511:17:05 AM
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
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
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

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (135, '135 tra_TransactionMaster_Alter', 'Alter tra_TransactionMaster add column SecurityTypeCodeId', 'Arundhati')
