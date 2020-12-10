/*
   Friday, May 08, 20152:43:26 PM
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
CREATE TABLE dbo.cmu_NotificationQueueParameters
	(
	NotificationQueueId bigint NOT NULL,
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers:  cmu_NotificationQueue. Parameter IDs stored here will be used to construct the formatted Contents within table cmu_NotificationQueue. Thus, first scan will fill tables cmu_NotificationQueue and cmu_NotificationQueueParameters. Then next scan will process parameters and UPDATE Contents and prepare cmu_NotificationQueue for actual formatted and complete notification content.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationQueueParameters', N'COLUMN', N'NotificationQueueId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationQueueParameters', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationQueueParameters', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationQueueParameters', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'CONTROL') as Contr_Per 


/*Add FOREIGN KEY references*/
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
ALTER TABLE dbo.cmu_NotificationQueue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId FOREIGN KEY
	(
	NotificationQueueId
	) REFERENCES dbo.cmu_NotificationQueue
	(
	NotificationQueueId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'CONTROL') as Contr_Per 

/*----------------Add column EventLogId for knowing against which EventLogs from EventLog table is the list for Notification Queue entered as Onset event and make MapToTypeCodeId and MapToId NULLABLE--------------*/

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
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId
GO
ALTER TABLE dbo.cmu_NotificationQueue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_cmu_NotificationQueueParameters
	(
	NotificationQueueId bigint NOT NULL,
	EventLogId bigint NOT NULL,
	UserInfoId int NULL,
	MapToTypeCodeId int NULL,
	MapToId int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_cmu_NotificationQueueParameters SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers:  cmu_NotificationQueue. Parameter IDs stored here will be used to construct the formatted Contents within table cmu_NotificationQueue. Thus, first scan will fill tables cmu_NotificationQueue and cmu_NotificationQueueParameters. Then next scan will process parameters and UPDATE Contents and prepare cmu_NotificationQueue for actual formatted and complete notification content.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueueParameters', N'COLUMN', N'NotificationQueueId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueueParameters', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueueParameters', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueueParameters', N'COLUMN', N'ModifiedBy'
GO
IF EXISTS(SELECT * FROM dbo.cmu_NotificationQueueParameters)
	 EXEC('INSERT INTO dbo.Tmp_cmu_NotificationQueueParameters (NotificationQueueId, MapToTypeCodeId, MapToId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT NotificationQueueId, MapToTypeCodeId, MapToId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.cmu_NotificationQueueParameters WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.cmu_NotificationQueueParameters
GO
EXECUTE sp_rename N'dbo.Tmp_cmu_NotificationQueueParameters', N'cmu_NotificationQueueParameters', 'OBJECT' 
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId FOREIGN KEY
	(
	NotificationQueueId
	) REFERENCES dbo.cmu_NotificationQueue
	(
	NotificationQueueId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_cmu_NotificationQueueParameters_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_eve_EventLog_EventLogId FOREIGN KEY
	(
	EventLogId
	) REFERENCES dbo.eve_EventLog
	(
	EventLogId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (116, '116 cmu_NotificationQueueParameters_Create', 'Create cmu_NotificationQueueParameters', 'Ashashree')
