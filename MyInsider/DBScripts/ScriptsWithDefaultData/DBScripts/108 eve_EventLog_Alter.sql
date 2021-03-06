/*
   Tuesday, April 28, 201512:50:41 PM
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
ALTER TABLE dbo.eve_EventLog
	DROP CONSTRAINT FK_eve_EventLog_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.eve_EventLog
	DROP CONSTRAINT FK_eve_EventLog_com_Code_EventCodeId
GO
ALTER TABLE dbo.eve_EventLog
	DROP CONSTRAINT FK_eve_EventLog_com_Code_MapToTypeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_eve_EventLog
	(
	EventLogId bigint NOT NULL IDENTITY (1, 1),
	EventCodeId int NOT NULL,
	EventDate datetime NOT NULL,
	UserInfoId int NOT NULL,
	MapToTypeCodeId int NULL,
	MapToId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code
CodeGroupId = 153'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_eve_EventLog', N'COLUMN', N'EventCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'refers com_code
CodeGroupId = 132'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_eve_EventLog', N'COLUMN', N'MapToTypeCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_eve_EventLog ON
GO
IF EXISTS(SELECT * FROM dbo.eve_EventLog)
	 EXEC('INSERT INTO dbo.Tmp_eve_EventLog (EventLogId, EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
		SELECT EventLogId, EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId FROM dbo.eve_EventLog WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_eve_EventLog OFF
GO
DROP TABLE dbo.eve_EventLog
GO
EXECUTE sp_rename N'dbo.Tmp_eve_EventLog', N'eve_EventLog', 'OBJECT' 
GO
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	PK_eve_EventLog PRIMARY KEY CLUSTERED 
	(
	EventLogId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (108, '108 eve_EventLog_Alter', 'Alter eve_EventLog allow null in MapToTypeCodeId, MapToId', 'Arundhati')
