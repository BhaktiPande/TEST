/*
   Sunday, March 22, 201510:11:47 PM
   User: 
   Server: BALTIX\SQLEXPRESSbaltix
   Database: KPCS_InsiderTrading
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
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_rul_TradingWindowEvent
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
	TradingWindowStatusCodeId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_rul_TradingWindowEvent SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 125
Applicable to event type = FinancialResult'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'FinancialYearCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 124
Applicable to event type = FinancialResult'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'FinancialPeriodCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 126 (EventType)
126001: Financial Result
126002: Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'EventTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'CodeGroupId = 127 (Trading Window Event)
NULL if EventTypeCodeId is 126001 (Financial Result)
If EventTypeCodeId = 126002 (Result), then this should be set.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'TradingWindowEventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, this is EventDeclarationDate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'ResultDeclarationDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowClosesAt'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowCloseDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowOpensOn'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowOpenDate'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowClosesBeforeDays'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'DaysPriorToResultDeclaration'
GO
DECLARE @v sql_variant 
SET @v = N'For EventType = Other, WindowOpensAfterDays'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'DaysPostResultDeclaration'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowClosesBeforeHours'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowClosesBeforeMinutes'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowOpensAfterHours'
GO
DECLARE @v sql_variant 
SET @v = N'Applicablt to EventType = Other'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_rul_TradingWindowEvent', N'COLUMN', N'WindowOpensAfterMinutes'
GO
ALTER TABLE dbo.Tmp_rul_TradingWindowEvent ADD CONSTRAINT
	DF_rul_TradingWindowEvent_TradingWindowStatusCodeId DEFAULT 131001 FOR TradingWindowStatusCodeId
GO
SET IDENTITY_INSERT dbo.Tmp_rul_TradingWindowEvent ON
GO
IF EXISTS(SELECT * FROM dbo.rul_TradingWindowEvent)
	 EXEC('INSERT INTO dbo.Tmp_rul_TradingWindowEvent (TradingWindowEventId, FinancialYearCodeId, FinancialPeriodCodeId, TradingWindowId, EventTypeCodeId, TradingWindowEventCodeId, ResultDeclarationDate, WindowCloseDate, WindowOpenDate, DaysPriorToResultDeclaration, DaysPostResultDeclaration, WindowClosesBeforeHours, WindowClosesBeforeMinutes, WindowOpensAfterHours, WindowOpensAfterMinutes, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TradingWindowEventId, FinancialYearCodeId, FinancialPeriodCodeId, TradingWindowId, EventTypeCodeId, TradingWindowEventCodeId, ResultDeclarationDate, WindowCloseDate, WindowOpenDate, DaysPriorToResultDeclaration, DaysPostResultDeclaration, WindowClosesBeforeHours, WindowClosesBeforeMinutes, WindowOpensAfterHours, WindowOpensAfterMinutes, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.rul_TradingWindowEvent WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_rul_TradingWindowEvent OFF
GO
DROP TABLE dbo.rul_TradingWindowEvent
GO
EXECUTE sp_rename N'dbo.Tmp_rul_TradingWindowEvent', N'rul_TradingWindowEvent', 'OBJECT' 
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	PK_rul_TradingWindowEvent PRIMARY KEY CLUSTERED 
	(
	TradingWindowEventId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------


/*
   Sunday, March 22, 201510:12:38 PM
   User: 
   Server: BALTIX\SQLEXPRESSbaltix
   Database: KPCS_InsiderTrading
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
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_com_Code_TradingWindowStatus FOREIGN KEY
	(
	TradingWindowStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (82, '082 rul_TradingWindowEvent_Alter', 'Alter rul_TradingWindowEvent', 'Arundhati')
