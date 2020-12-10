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
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_UserId
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_eve_EventLog_EventLogId
GO
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_cmu_NotificationQueue
	(
	NotificationQueueId bigint NOT NULL IDENTITY (1, 1),
	CompanyIdentifierCodeId int NULL,
	RuleModeId int NOT NULL,
	EventLogId bigint NULL,
	UserId int NOT NULL,
	UserContactInfo nvarchar(250) NULL,
	Subject nvarchar(150) NULL,
	Contents nvarchar(MAX) NULL,
	Signature nvarchar(200) NULL,
	CommunicationFrom varchar(100) NULL,
	ResponseStatusCodeId int NULL,
	ResponseMessage nvarchar(200) NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_cmu_NotificationQueue SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code : Have a code within the com_Code config group to uniquely identify implementing company with specific company in master database.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'CompanyIdentifierCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: cmu_CommunicationRuleModeMaster'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'RuleModeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: eve_EventLog.  The event from eventlog against which the communication is sent.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'EventLogId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo. UserId to for whom notification mode is personalized.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'UserId'
GO
DECLARE @v sql_variant 
SET @v = N'This will store the user''s email address for Email / mobile number for SMS'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'UserContactInfo'
GO
DECLARE @v sql_variant 
SET @v = N'This is applicable for email only. SMS / alert / popup will have this as NULL.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'Subject'
GO
DECLARE @v sql_variant 
SET @v = N'This will store the formatted email / SMS / alert / popup content that will be used by the communication sender to send notification'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'Contents'
GO
DECLARE @v sql_variant 
SET @v = N'Store the signature whereever applicable in case of notification. Applies to Email/Letter type of templates.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'Signature'
GO
DECLARE @v sql_variant 
SET @v = N'will store the email Id in case of email or the contact number in case of SMS'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'CommunicationFrom'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code, will be null when record is added to queue and will get updated when record is processed for sending notification.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_cmu_NotificationQueue', N'COLUMN', N'ResponseStatusCodeId'
GO
SET IDENTITY_INSERT dbo.Tmp_cmu_NotificationQueue ON
GO
IF EXISTS(SELECT * FROM dbo.cmu_NotificationQueue)
	 EXEC('INSERT INTO dbo.Tmp_cmu_NotificationQueue (NotificationQueueId, CompanyIdentifierCodeId, RuleModeId, EventLogId, UserId, UserContactInfo, Subject, Contents, Signature, ResponseStatusCodeId, ResponseMessage, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT NotificationQueueId, CompanyIdentifierCodeId, RuleModeId, EventLogId, UserId, UserContactInfo, Subject, Contents, Signature, ResponseStatusCodeId, ResponseMessage, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.cmu_NotificationQueue WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_cmu_NotificationQueue OFF
GO
ALTER TABLE dbo.cmu_NotificationDocReference
	DROP CONSTRAINT FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_cmu_NotificationQueue_NotificationQueueId
GO
DROP TABLE dbo.cmu_NotificationQueue
GO
EXECUTE sp_rename N'dbo.Tmp_cmu_NotificationQueue', N'cmu_NotificationQueue', 'OBJECT' 
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	PK_cmu_NotificationQueue PRIMARY KEY CLUSTERED 
	(
	NotificationQueueId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_com_Code_CompanyIdentifierCodeId FOREIGN KEY
	(
	CompanyIdentifierCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_cmu_CommunicationRuleModeMaster_RuleModeId FOREIGN KEY
	(
	RuleModeId
	) REFERENCES dbo.cmu_CommunicationRuleModeMaster
	(
	RuleModeId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_com_Code_ResponseStatusCodeId FOREIGN KEY
	(
	ResponseStatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_eve_EventLog_EventLogId FOREIGN KEY
	(
	EventLogId
	) REFERENCES dbo.eve_EventLog
	(
	EventLogId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.cmu_NotificationQueueParameters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_cmu_NotificationQueue_NotificationQueueId FOREIGN KEY
	(
	NotificationQueueId
	) REFERENCES dbo.cmu_NotificationQueue
	(
	NotificationQueueId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (146, '146 cmu_NotificationQueue_Alter', 'Alter cmu_NotificationQueue Add CommunicationFrom column', 'Ashashree')
