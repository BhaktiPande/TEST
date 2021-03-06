/*
   Wednesday, April 15, 201511:09:32 AM
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
CREATE TABLE dbo.eve_EventLog
	(
	EventLogId bigint NOT NULL IDENTITY (1, 1),
	EventCodeId int NOT NULL,
	EventDate datetime NOT NULL,
	UserInfoId int NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code
CodeGroupId = 153'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'eve_EventLog', N'COLUMN', N'EventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'refers com_code
CodeGroupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'eve_EventLog', N'COLUMN', N'MapToTypeCodeId'
GO
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	PK_eve_EventLog PRIMARY KEY CLUSTERED 
	(
	EventLogId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/*
   Wednesday, April 15, 201511:11:00 AM
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
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	FK_eve_EventLog_com_Code_EventCodeId FOREIGN KEY
	(
	EventCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	FK_eve_EventLog_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	FK_eve_EventLog_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (103, '103 eve_EventLog_Create', 'Create eve_EventLog', 'Arundhati')
