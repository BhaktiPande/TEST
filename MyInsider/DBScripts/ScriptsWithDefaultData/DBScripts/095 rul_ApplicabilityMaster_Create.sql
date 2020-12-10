/*
   Thursday, April 09, 20153:31:48 PM
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
CREATE TABLE dbo.rul_ApplicabilityMaster
	(
	ApplicabilityId bigint NOT NULL IDENTITY (1, 1),
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	VersionNumber int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code - 132001:Policy Document, 132002:Trading Policy'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Actual Id of map type defined by MapToTypeCodeId'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'MapToId'
GO
DECLARE @v sql_variant 
SET @v = N'version number of applicability where latest version will be associated with MapToId. Latest version will be calculated as max+1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'VersionNumber'
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	DF_rul_ApplicabilityMaster_VersionNumber DEFAULT 1 FOR VersionNumber
GO
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/* Constraints addition for rul_ApplicabilityMaster */

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
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	PK_rul_ApplicabilityMaster PRIMARY KEY CLUSTERED 
	(
	ApplicabilityId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (95, '095 rul_ApplicabilityMaster_Create', 'Create applicability master table', 'Ashashree')
