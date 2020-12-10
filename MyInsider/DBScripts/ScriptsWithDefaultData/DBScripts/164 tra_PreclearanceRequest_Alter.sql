/*
   Friday, August 21, 20154:45:21 PM
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
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy
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
	DROP CONSTRAINT FK_tra_PreclearanceRequest_mst_Company_CompanyId
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT DF_tra_PreclearanceRequest_SecuritiesToBeTradedValue
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT DF_tra_PreclearanceRequest_IsPartiallyTraded
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT DF_tra_PreclearanceRequest_ShowAddButton
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
	SecuritiesToBeTradedValue decimal(20, 4) NOT NULL,
	PreclearanceStatusCodeId int NOT NULL,
	CompanyId int NOT NULL,
	ProposedTradeRateRangeFrom decimal(15, 4) NOT NULL,
	ProposedTradeRateRangeTo decimal(15, 4) NOT NULL,
	DMATDetailsID int NOT NULL,
	ReasonForNotTradingCodeId int NULL,
	ReasonForNotTradingText varchar(30) NULL,
	ReasonForRejection nvarchar(200) NULL,
	IsPartiallyTraded int NOT NULL,
	ShowAddButton int NOT NULL,
	IsAutoApproved bit NOT NULL,
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
DECLARE @v sql_variant 
SET @v = N'When preclearance request is rejected, user will give rejection reason.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'ReasonForRejection'
GO
DECLARE @v sql_variant 
SET @v = N'1: Partially Traded (Total Qty < PCL Qty),
0:Traded fully or excess (Total Qty >= PCLQty)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'IsPartiallyTraded'
GO
DECLARE @v sql_variant 
SET @v = N'0:Do not Show Add button (If atleast one transaction not submitted or TotalQty >= PCL)
1: Show Add button (All transactions are submitted and TotalQty < PCLQty)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'ShowAddButton'
GO
DECLARE @v sql_variant 
SET @v = N'To indicate if preclearance is auto approved. 0=not auto approved, 1=auto approved.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_PreclearanceRequest', N'COLUMN', N'IsAutoApproved'
GO
ALTER TABLE dbo.Tmp_tra_PreclearanceRequest ADD CONSTRAINT
	DF_tra_PreclearanceRequest_SecuritiesToBeTradedValue DEFAULT ((0)) FOR SecuritiesToBeTradedValue
GO
ALTER TABLE dbo.Tmp_tra_PreclearanceRequest ADD CONSTRAINT
	DF_tra_PreclearanceRequest_IsPartiallyTraded DEFAULT ((1)) FOR IsPartiallyTraded
GO
ALTER TABLE dbo.Tmp_tra_PreclearanceRequest ADD CONSTRAINT
	DF_tra_PreclearanceRequest_ShowAddButton DEFAULT ((0)) FOR ShowAddButton
GO
ALTER TABLE dbo.Tmp_tra_PreclearanceRequest ADD CONSTRAINT
	DF_tra_PreclearanceRequest_IsAutoApproved DEFAULT 0 FOR IsAutoApproved
GO
SET IDENTITY_INSERT dbo.Tmp_tra_PreclearanceRequest ON
GO
IF EXISTS(SELECT * FROM dbo.tra_PreclearanceRequest)
	 EXEC('INSERT INTO dbo.Tmp_tra_PreclearanceRequest (PreclearanceRequestId, PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId, SecuritiesToBeTradedQty, SecuritiesToBeTradedValue, PreclearanceStatusCodeId, CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, ReasonForNotTradingCodeId, ReasonForNotTradingText, ReasonForRejection, IsPartiallyTraded, ShowAddButton, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT PreclearanceRequestId, PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId, SecuritiesToBeTradedQty, SecuritiesToBeTradedValue, PreclearanceStatusCodeId, CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, ReasonForNotTradingCodeId, ReasonForNotTradingText, ReasonForRejection, IsPartiallyTraded, ShowAddButton, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_PreclearanceRequest WITH (HOLDLOCK TABLOCKX)')
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
-- =============================================
-- Author:		Arundhati
-- Create date: 29-Apr-2015
-- Description:	Insert data in event table, when status changes, log the corresponding event

-- Edited By		Edited On			Description
-- Ashashree		30-Jun-2015			Adding postdated event to event log table, when pre-clearance is approved, the pre-clearance expiry event will get logged as well
-- =============================================

CREATE TRIGGER [dbo].[tr_tra_PreclearanceRequestStatus] ON dbo.tra_PreclearanceRequest
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT
	DECLARE @nEventCodeIDPreClearanceExpiry INT
	DECLARE @nEventCodeID_PreClearanceRequested INT = 153015
	DECLARE @nEventCodeID_PreClearanceApproved INT = 153016
	DECLARE @nEventCodeID_PreClearanceRejected INT = 153017
	DECLARE @nEventCodeID_PreClearanceExpiry INT = 153018 --Pre-clearance expiry (this will always be a postdated event added to eventlog when any Pre-clearance gets approved)

	DECLARE @nMapToTypeCodeId INT = 132004 -- Preclearance
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	DECLARE @nModifiedBy INT
	
	DECLARE @nPreclearanceStatus_Requested INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003	

	DECLARE @nPreclearanceStatusNew INT, @nPreclearanceStatusOld INT
	DECLARE @nPreclearanceId INT
	
	DECLARE @dtPreClearanceExpiryDate DATETIME
	DECLARE @nTradingPolicyId INT
	DECLARE @TradingPolicyPreClrApprovalValidityLimit INT
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--print 'trigger'
	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nPreclearanceStatusNew = PreclearanceStatusCodeId, 
			@nUserInfoId = UserInfoId,
			@nMapToId = PreclearanceRequestId,
			@nModifiedBy = ModifiedBy
	FROM #tmpValues_New
	
	SELECT	@nPreclearanceStatusOld = PreclearanceStatusCodeId
	FROM #tmpValues_Old
	
	-- Initial disclosures
	IF ISNULL(@nPreclearanceStatusNew, 0) <> ISNULL(@nPreclearanceStatusOld, 0)
	BEGIN
		IF @nPreclearanceStatusNew = @nPreclearanceStatus_Requested
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceRequested
		END
		ELSE IF @nPreclearanceStatusNew = @nPreclearanceStatus_Approved
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceApproved
			SET @nEventCodeIDPreClearanceExpiry = @nEventCodeID_PreClearanceExpiry --For postdated "pre-clearance expiry" event
		END
		ELSE IF @nPreclearanceStatusNew = @nPreclearanceStatus_Rejected
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceRejected
		END
		
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		VALUES(@nEventCodeID, GETDATE(), @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
		
		--Start : When pre-clearance is Approved then, calculate and add a postdated "pre-clearance expiry" event based upon trading policy applicable to user
		IF @nPreclearanceStatusNew = @nPreclearanceStatus_Approved 
		BEGIN
			IF(NOT EXISTS(SELECT EventLogId From eve_EventLog WHERE UserInfoId = @nUserInfoId AND MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nMapToId AND EventCodeId = @nEventCodeIDPreClearanceExpiry))
			BEGIN
				SELECT @nTradingPolicyId = TradingPolicyId FROM tra_TransactionMaster WHERE PreclearanceRequestId = @nMapToId
				SELECT @TradingPolicyPreClrApprovalValidityLimit = PreClrApprovalValidityLimit FROM rul_TradingPolicy where TradingPolicyId = ISNULL(@nTradingPolicyId,0)
				SELECT @TradingPolicyPreClrApprovalValidityLimit = ISNULL(@TradingPolicyPreClrApprovalValidityLimit,0)
				--Calculate the pre-clearance expiry date
				SELECT @dtPreClearanceExpiryDate = DATEADD(DAY, @TradingPolicyPreClrApprovalValidityLimit , DATEADD(DAY, 1, GETDATE())) --days (after approval is given excluding approval day) : "DATEADD(DAY, 1, GETDATE())" is done to exclude the approval day
				
				INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
				VALUES(@nEventCodeIDPreClearanceExpiry, @dtPreClearanceExpiryDate, @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
			END
		END
		--End : When pre-clearance is Approved then, calculate and add a postdated "pre-clearance expiry" event based upon trading policy applicable to user
	END

END
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

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (164, '164 tra_PreclearanceRequest_Alter', 'Alter tra_PreclearanceRequest, Add flag to indicate AutoApproval', 'Ashashree')
