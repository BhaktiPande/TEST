/*
   Tuesday, March 24, 20153:20:57 PM
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
CREATE TABLE dbo.rul_TradingPolicy
	(
	TradingPolicyId int NOT NULL IDENTITY (1, 1),
	TradingPolicyForCodeId int NULL,
	TradingPolicyName nvarchar(100) NOT NULL,
	TradingPolicyDescription nvarchar(1024) NULL,
	ApplicableFromDate datetime NULL,
	ApplicableToDate datetime NULL,
	PreClrTradesApprovalReqFlag bit NOT NULL,
	PreClrSingleTransTradeNoShares int NULL,
	PreClrSingleTransTradePercPaidSubscribedCap int NULL,
	PreClrProhibitNonTradePeriodFlag bit NOT NULL,
	PreClrCOApprovalLimit int NULL,
	PreClrApprovalValidityLimit int NULL,
	PreClrSeekDeclarationForUPSIFlag bit NOT NULL,
	PreClrUPSIDeclaration nvarchar(255) NULL,
	PreClrReasonForNonTradeReqFlag bit NOT NULL,
	PreClrCompleteTradeNotDoneFlag bit NOT NULL,
	PreClrPartialTradeNotDoneFlag bit NOT NULL,
	PreClrTradeDiscloLimit int NULL,
	PreClrTradeDiscloShareholdLimit int NULL,
	StExSubmitTradeDiscloAllTradeFlag bit NOT NULL,
	StExSingMultiTransTradeFlagCodeId int NULL,
	StExMultiTradeFreq int NULL,
	StExMultiTradeCalFinYear int NULL,
	StExTransTradeNoShares int NULL,
	StExTransTradePercPaidSubscribedCap int NULL,
	StExTransTradeShareValue int NULL,
	StExTradeDiscloSubmitLimit int NULL,
	DiscloInitReqFlag bit NOT NULL,
	DiscloInitLimit int NULL,
	DiscloInitDateLimit datetime NULL,
	DiscloPeriodEndReqFlag bit NOT NULL,
	DiscloPeriodEndFreq int NULL,
	GenSecurityType varchar(1024) NULL,
	GenTradingPlanTransFlag bit NOT NULL,
	GenMinHoldingLimit int NULL,
	GenContraTradeNotAllowedLimit int NULL,
	GenExceptionFor varchar(1024) NULL,
	TradingPolicyStatusCodeId int NULL,
	CreatedBy int NULL,
	CreatedOn datetime NULL,
	ModifiedBy int NULL,
	ModifiedOn datetime NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - XXX001: Employee (Non Insider), XXX002: Employee Insider, XXX003: NonEmployee Insider, XXX004: Corporate Insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'TradingPolicyForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Preclearance Approval Required for all trades)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrTradesApprovalReqFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Preclearance Approval required for single trade transaction above number of shares'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrSingleTransTradeNoShares'
GO
DECLARE @v sql_variant 
SET @v = N'Preclearance Approval required for single trade transaction above percentage of paid up and subscribed capital'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrSingleTransTradePercPaidSubscribedCap'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 1 (as per SRS) (Prohibit pre-clearance during non-trading period)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrProhibitNonTradePeriodFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Preclearance approval to be given within X days by Complaince Officer'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrCOApprovalLimit'
GO
DECLARE @v sql_variant 
SET @v = N'Preclearance approval validity X days (after approval is given and excluding approval day)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrApprovalValidityLimit'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Seek declaration from employee regarding possession of UPSI'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrSeekDeclarationForUPSIFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Declaration sought from the insider at the time of preclearance'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrUPSIDeclaration'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Preclearance - Reason for non-trade to be provided)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrReasonForNonTradeReqFlag'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Complete trade not done for pre-clearance taken)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrCompleteTradeNotDoneFlag'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Partial trade not done for pre-clearance taken)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrPartialTradeNotDoneFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Trade disclosure for preclearance approval transactions within X days'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrTradeDiscloLimit'
GO
DECLARE @v sql_variant 
SET @v = N'Preclearance Trade disclosure within X days of change in share holdings (more than 5%)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'PreClrTradeDiscloShareholdLimit'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Trade disclosures to be submitted to stock exchanges for all trades)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExSubmitTradeDiscloAllTradeFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - XXX001: Single Transaction Trade, XXX002: Multiple Transaction Trade(Stock exchange disclosure related Single or Multiple Transaction trade above)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExSingMultiTransTradeFlagCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week(Stock exchange disclosure related Multiple transaction trade above in week, month etc)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExMultiTradeFreq'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - XXX001:Calendar Year, XXX002: Finanacial Year(Stock exchange disclosure related Multiple transaction trade for calendar or financial year)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExMultiTradeCalFinYear'
GO
DECLARE @v sql_variant 
SET @v = N'Stock exchange disclosure related Single or Multiple Transaction trade above number of shares'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExTransTradeNoShares'
GO
DECLARE @v sql_variant 
SET @v = N'Stock exchange disclosure related Single or Multiple Transaction trade above % of paid up and subscribed capital'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExTransTradePercPaidSubscribedCap'
GO
DECLARE @v sql_variant 
SET @v = N'Stock exchange disclosure related Single or Multiple Transaction trade above value of shares'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExTransTradeShareValue'
GO
DECLARE @v sql_variant 
SET @v = N'Stock exchange disclosure related trade disclosure within X days of submision by insider/employee'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'StExTradeDiscloSubmitLimit'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Initial disclosures required / not required)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'DiscloInitReqFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Initial disclosure within X days of joining / being categorized as insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'DiscloInitLimit'
GO
DECLARE @v sql_variant 
SET @v = N'Initial disclosure before X date of application go live'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'DiscloInitDateLimit'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'DiscloPeriodEndReqFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code, XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'DiscloPeriodEndFreq'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code, comma separated list of id from com_Code, XXX001:Equity, XXX002: Derivatives'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'GenSecurityType'
GO
DECLARE @v sql_variant 
SET @v = N'0:No, 1:Yes, Default : 0 (Trading policy applies or does not apply to transaction under trading plan)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'GenTradingPlanTransFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Minimum holding period X days'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'GenMinHoldingLimit'
GO
DECLARE @v sql_variant 
SET @v = N'Contra trade not allowed for X days from opposite transaction'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'GenContraTradeNotAllowedLimit'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - comma separated list of id from com_Code XXX001: Exercise of Options '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'GenExceptionFor'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code - XXX001: Incomplete, XXX002: Active, XXX003: Inactive'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingPolicy', N'COLUMN', N'TradingPolicyStatusCodeId'
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrTradesApprovalReqFlag DEFAULT 0 FOR PreClrTradesApprovalReqFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrProhibitNonTradePeriodFlag DEFAULT 1 FOR PreClrProhibitNonTradePeriodFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrSeekDeclarationForUPSIFlag DEFAULT 0 FOR PreClrSeekDeclarationForUPSIFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrReasonForNonTradeReqFlag DEFAULT 0 FOR PreClrReasonForNonTradeReqFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrCompleteTradeNotDoneFlag DEFAULT 0 FOR PreClrCompleteTradeNotDoneFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_PreClrPartialTradeNotDoneFlag DEFAULT 0 FOR PreClrPartialTradeNotDoneFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_StExSubmitTradeDiscloAllTradeFlag DEFAULT 0 FOR StExSubmitTradeDiscloAllTradeFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_DiscloInitReqFlag DEFAULT 0 FOR DiscloInitReqFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_DiscloPeriodEndReqFlag DEFAULT 0 FOR DiscloPeriodEndReqFlag
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	DF_rul_TradingPolicy_GenTradingPlanTransFlag DEFAULT 0 FOR GenTradingPlanTransFlag
GO
ALTER TABLE dbo.rul_TradingPolicy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------
/*FOREIGN KEY CONSTRATINTS ADDITION*/

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
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	PK_rul_TradingPolicy PRIMARY KEY CLUSTERED 
	(
	TradingPolicyId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_TradingPolicyForCodeId FOREIGN KEY
	(
	TradingPolicyForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_StExSingMultiTransTradeFlagCodeId FOREIGN KEY
	(
	StExSingMultiTransTradeFlagCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_StExMultiTradeFreq FOREIGN KEY
	(
	StExMultiTradeFreq
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_StExMultiTradeCalFinYear FOREIGN KEY
	(
	StExMultiTradeCalFinYear
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_DiscloPeriodEndFreq FOREIGN KEY
	(
	DiscloPeriodEndFreq
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy ADD CONSTRAINT
	FK_rul_TradingPolicy_com_Code_TradingPolicyStatusCodeId FOREIGN KEY
	(
	TradingPolicyStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (84, '084 rul_TradingPolicy_Create', 'Create table for trading policy', 'Ashashree')
