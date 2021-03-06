/*
   Wednesday, March 11, 20152:48:49 PM
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
CREATE TABLE dbo.rul_TradingWindowEvent
	(
	TradingWindowEventId int NOT NULL IDENTITY (1, 1),
	FinancialYearCodeId int NULL,
	FinancialPeriodCodeId int NULL,
	TradingWindowId varchar(50) NULL,
	EventTypeCodeId int NOT NULL,
	TradingWindowEventCodeId int NULL,
	ResultDeclarationDate datetime NOT NULL,
	WindowCloseDate datetime NOT NULL,
	WindowOpenDate datetime NOT NULL,
	DaysPriorToResultDeclaration int NOT NULL,
	DaysPostResultDeclaration int NOT NULL,
	WindowClosesBeforeHours int NULL,
	WindowClosesBeforeMinutes int NULL,
	WindowOpensAfterHours int NULL,
	WindowOpensAfterMinutes int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 125
Applicable to event type = FinancialResult'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'FinancialYearCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 124
Applicable to event type = FinancialResult'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'FinancialPeriodCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 126 (EventType)
126001: Financial Result
126002: Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'EventTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 127 (Trading Window Event)
NULL if EventTypeCodeId is 126001 (Financial Result)
If EventTypeCodeId = 126002 (Result), then this should be set.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'TradingWindowEventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, this is EventDeclarationDate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'ResultDeclarationDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowClosesAt'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowCloseDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowOpensOn'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowOpenDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowClosesBeforeDays'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'DaysPriorToResultDeclaration'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowOpensAfterDays'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'DaysPostResultDeclaration'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowClosesBeforeHours'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowClosesBeforeMinutes'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowOpensAfterHours'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TradingWindowEvent', N'COLUMN', N'WindowOpensAfterMinutes'
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	PK_rul_TradingWindowEvent PRIMARY KEY CLUSTERED 
	(
	TradingWindowEventId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_TradingWindowEvent SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
/*
   Wednesday, March 11, 20152:53:10 PM
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
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId FOREIGN KEY
	(
	FinancialYearCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId FOREIGN KEY
	(
	FinancialPeriodCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId FOREIGN KEY
	(
	EventTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId FOREIGN KEY
	(
	TradingWindowEventCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (75, '075 rul_TradingWindowEvent_Create', 'Create rul_TradingWindowEvent', 'Arundhati')
