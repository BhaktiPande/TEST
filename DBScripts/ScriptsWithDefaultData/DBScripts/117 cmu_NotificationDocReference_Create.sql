/*
   Friday, May 08, 20153:08:22 PM
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
CREATE TABLE dbo.cmu_NotificationDocReference
	(
	NotificationQueueId bigint NOT NULL,
	CompanyIdentifierCodeId int NULL,
	DocumentName varchar(255) NOT NULL,
	GUID varchar(400) NOT NULL,
	DocumentPath varchar(512) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'refers: cmu_NotificationQueue. If document is stored remotely, then when sending notification, pull the document onto server that will run the notification sender job and then update the DocumentPath as per the server location from which notification sender job is run.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationDocReference', N'COLUMN', N'NotificationQueueId'
GO
DECLARE @v sql_variant 
SET @v = N'refers: com_Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationDocReference', N'COLUMN', N'CompanyIdentifierCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'If document is pulled to location where notification sender job runs then, prefix CompanyIdentifierCodeId to GUID to have unique document name on physical folder location. On master we can possibly have 2 docs with same GUID but of different CompanyIdentifierCodeId.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationDocReference', N'COLUMN', N'GUID'
GO
DECLARE @v sql_variant 
SET @v = N'refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationDocReference', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_NotificationDocReference', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.cmu_NotificationDocReference SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'CONTROL') as Contr_Per 

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
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_com_Code_CompanyIdentifierCodeId FOREIGN KEY
	(
	CompanyIdentifierCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_cmu_NotificationDocReference_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_cmu_NotificationDocReference_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (117, '117 cmu_NotificationDocReference_Create', 'Create cmu_NotificationDocReference', 'Ashashree')
