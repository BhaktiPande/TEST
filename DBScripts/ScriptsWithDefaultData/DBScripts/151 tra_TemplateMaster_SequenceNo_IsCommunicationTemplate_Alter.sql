/*
   Thursday, June 18, 201511:24:35 AM
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
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_com_Code_LetterForCodeId
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT DF_tra_TemplateMaster_CommunicationModeCodeId
GO
CREATE TABLE dbo.Tmp_tra_TemplateMaster
	(
	TemplateMasterId int NOT NULL IDENTITY (1, 1),
	TemplateName nvarchar(255) NOT NULL,
	CommunicationModeCodeId int NOT NULL,
	DisclosureTypeCodeId int NULL,
	LetterForCodeId int NULL,
	IsActive bit NOT NULL,
	Date datetime NULL,
	ToAddress1 nvarchar(250) NULL,
	ToAddress2 nvarchar(250) NULL,
	Subject nvarchar(150) NULL,
	Contents nvarchar(4000) NOT NULL,
	Signature nvarchar(200) NULL,
	CommunicationFrom varchar(100) NULL,
	SequenceNo varchar(50) NULL,
	IsCommunicationTemplate bit NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Name with which template can be referred.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'TemplateName'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code. 156001:Letter, 156002:Email, 156003:SMS, 156004:Text Alert, 156005:Popup Alert.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'CommunicationModeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupID = 147
147001: Initial
147002: Continuous
147003: Period End. Applicable for Transaction Letter.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'DisclosureTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupID = 151
151001: Insider
151002: CO. Applicable for Transaction Letter.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'LetterForCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'1: Active, 0: Inactive'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'IsActive'
GO
DECLARE @v sql_variant 
SET @v = N'Applicable for Transaction Letter.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'Date'
GO
DECLARE @v sql_variant 
SET @v = N'Applicable for Transaction Letter.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'ToAddress1'
GO
DECLARE @v sql_variant 
SET @v = N'Applicable for Transaction Letter.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'ToAddress2'
GO
DECLARE @v sql_variant 
SET @v = N'Applicable only for email and transaction letter. Empty string or NULL in case of CM- SMS/Alert/Popup'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'Subject'
GO
DECLARE @v sql_variant 
SET @v = N'will contain formatted text along with placeholders in between the content, where placeholder will be codename from com_Code related to placeholderCode. Placeholders will be handled at a later stage, not in first cut.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'Contents'
GO
DECLARE @v sql_variant 
SET @v = N'Applicable for Letter, Email.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'Signature'
GO
DECLARE @v sql_variant 
SET @v = N'Appliable only in case of Email and SMS - email from email address / SMS from number.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'CommunicationFrom'
GO
DECLARE @v sql_variant 
SET @v = N'Sequence number as 1, 1.1, 1.1.2, 2.1, 2.1.1 when Subject and Contents store FAQ and corresponding answer'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'SequenceNo'
GO
DECLARE @v sql_variant 
SET @v = N'Flag to indicate whether template is for Email/SMS/Text Alert/Popup Alert (value =1) or for Letter/FAQ (value=0)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tra_TemplateMaster', N'COLUMN', N'IsCommunicationTemplate'
GO
ALTER TABLE dbo.Tmp_tra_TemplateMaster ADD CONSTRAINT
	DF_tra_TemplateMaster_CommunicationModeCodeId DEFAULT ((156001)) FOR CommunicationModeCodeId
GO
ALTER TABLE dbo.Tmp_tra_TemplateMaster ADD CONSTRAINT
	DF_tra_TemplateMaster_IsCommunicationTemplate DEFAULT 1 FOR IsCommunicationTemplate
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TemplateMaster ON
GO
IF EXISTS(SELECT * FROM dbo.tra_TemplateMaster)
	 EXEC('INSERT INTO dbo.Tmp_tra_TemplateMaster (TemplateMasterId, TemplateName, CommunicationModeCodeId, DisclosureTypeCodeId, LetterForCodeId, IsActive, Date, ToAddress1, ToAddress2, Subject, Contents, Signature, CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT TemplateMasterId, TemplateName, CommunicationModeCodeId, DisclosureTypeCodeId, LetterForCodeId, IsActive, Date, ToAddress1, ToAddress2, Subject, Contents, Signature, CommunicationFrom, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.tra_TemplateMaster WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tra_TemplateMaster OFF
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId
GO
DROP TABLE dbo.tra_TemplateMaster
GO
EXECUTE sp_rename N'dbo.Tmp_tra_TemplateMaster', N'tra_TemplateMaster', 'OBJECT' 
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	PK_tra_TemplateMaster PRIMARY KEY CLUSTERED 
	(
	TemplateMasterId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId FOREIGN KEY
	(
	DisclosureTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_com_Code_LetterForCodeId FOREIGN KEY
	(
	LetterForCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId FOREIGN KEY
	(
	CommunicationModeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_tra_TemplateMaster_TemplateId FOREIGN KEY
	(
	TemplateId
	) REFERENCES dbo.tra_TemplateMaster
	(
	TemplateMasterId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (151, '151 tra_TemplateMaster_SequenceNo_IsCommunicationTemplate_Alter.sql', 'Alter tra_TemplateMaster for SequenceNo and IsCommunicationTemplate flag addition', 'Ashashree')
