/*
   Wednesday, February 18, 20154:57:39 PM
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
CREATE TABLE dbo.com_CompanyComplianceOfficer
	(
	CompanyComplianceOfficerId int NOT NULL IDENTITY (1, 1),
	CompanyId int NOT NULL,
	ComplianceOfficerName nvarchar(100) NOT NULL,
	DesignationId int NULL,
	Address nvarchar(255) NULL,
	PhoneNumber varchar(20) NULL,
	EmailId nvarchar(255) NULL,
	ApplicableFromDate datetime NOT NULL,
	ApplicableToDate datetime NULL,
	StatusCodeId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_code, CodeGroupId = 109'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_CompanyComplianceOfficer', N'COLUMN', N'DesignationId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code, CodeGroupId = 102'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_CompanyComplianceOfficer', N'COLUMN', N'StatusCodeId'
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	PK_com_CompanyComplianceOfficer PRIMARY KEY CLUSTERED 
	(
	CompanyComplianceOfficerId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_CompanyComplianceOfficer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*
   Wednesday, February 18, 20155:04:22 PM
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
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_com_Code_DesignationId FOREIGN KEY
	(
	DesignationId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_com_Code_StatusCodeId FOREIGN KEY
	(
	StatusCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (59, '059 com_CompanyComplianceOfficer_Create', 'Create 059 com_CompanyComplianceOfficer', 'Arundhati')
