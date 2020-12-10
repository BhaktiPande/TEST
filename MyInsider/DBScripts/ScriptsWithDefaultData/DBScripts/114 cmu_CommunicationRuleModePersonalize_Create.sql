/*
   Friday, May 08, 201512:03:22 PM
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
CREATE TABLE dbo.cmu_CommunicationRuleModePersonalize
	(
	RuleModePersonalizeId bigint NOT NULL IDENTITY (1, 1),
	RuleModeId int NOT NULL,
	UserId int NOT NULL,
	Subject nvarchar(150) NULL,
	Contents nvarchar(4000) NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers: cmu_CommunicationRuleModeMaster'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModePersonalize', N'COLUMN', N'RuleModeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModePersonalize', N'COLUMN', N'UserId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModePersonalize', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'cmu_CommunicationRuleModePersonalize', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	PK_cmu_CommunicationRuleModePersonalize PRIMARY KEY CLUSTERED 
	(
	RuleModePersonalizeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'CONTROL') as Contr_Per 

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
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_RuleModeId FOREIGN KEY
	(
	RuleModeId
	) REFERENCES dbo.cmu_CommunicationRuleModeMaster
	(
	RuleModeId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModePersonalize_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (114, '114 cmu_CommunicationRuleModePersonalize_Create', 'Create cmu_CommunicationRuleModePersonalize', 'Ashashree')
