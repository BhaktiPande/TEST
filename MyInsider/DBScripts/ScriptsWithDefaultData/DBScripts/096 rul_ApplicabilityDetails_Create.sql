/*
   Thursday, April 09, 20154:45:59 PM
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
CREATE TABLE dbo.rul_ApplicabilityDetails
	(
	ApplicabilityDtlsId bigint NOT NULL IDENTITY (1, 1),
	ApplicabilityMstId bigint NOT NULL,
	AllEmployeeFlag bit NULL,
	AllInsiderFlag bit NULL,
	AllEmployeeInsiderFlag bit NULL,
	InsiderTypeCodeId int NULL,
	Department int NULL,
	Grade int NULL,
	Designation int NULL,
	UserId int NULL,
	IncludeExcludeCodeId int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers: rul_ApplicabilityMaster'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ApplicabilityMstId'
GO
DECLARE @v sql_variant 
SET @v = N'1:All Employee selected, 0: All Employee not selected'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'AllEmployeeFlag'
GO
DECLARE @v sql_variant 
SET @v = N'1:All Insider selected, 0: All Insider not selected'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'AllInsiderFlag'
GO
DECLARE @v sql_variant 
SET @v = N'1:All Employee Insider selected, 0: All Employee Insider not selected'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'AllEmployeeInsiderFlag'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code, 101003: Employee Insider, 101006: NonEmployee Insider, 101004: Corporate Insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'InsiderTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code for department codes'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'Department'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code for grade codes'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'Grade'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: com_Code for Designation codes'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'Designation'
GO
DECLARE @v sql_variant 
SET @v = N'Refers usr_UserInfo for UserInfoId'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'UserId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers com_Code for UserId Include/Exclude code : 150001 : Include Insider,150002 : Exclude Insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'IncludeExcludeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'CreatedBy'
GO
DECLARE @v sql_variant 
SET @v = N'Refers: usr_UserInfo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ModifiedBy'
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	DF_rul_ApplicabilityDetails_AllEmployeeFlag DEFAULT 0 FOR AllEmployeeFlag
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	DF_rul_ApplicabilityDetails_AllInsiderFlag DEFAULT 0 FOR AllInsiderFlag
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	DF_rul_ApplicabilityDetails_AllEmployeeInsiderFlag DEFAULT 0 FOR AllEmployeeInsiderFlag
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
/* Rename fields that refer to codeId of com_Code for rul_ApplicabilityDetails */

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
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Department', N'Tmp_DepartmentCodeId', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Grade', N'Tmp_GradeCodeId_1', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Designation', N'Tmp_DesignationCodeId_2', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Tmp_DepartmentCodeId', N'DepartmentCodeId', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Tmp_GradeCodeId_1', N'GradeCodeId', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.rul_ApplicabilityDetails.Tmp_DesignationCodeId_2', N'DesignationCodeId', 'COLUMN' 
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------
/* Constraints addition for rul_ApplicabilityDetails */

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
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	PK_rul_ApplicabilityDetails PRIMARY KEY CLUSTERED 
	(
	ApplicabilityDtlsId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_rul_ApplicabilityMaster_ApplicabilityMstId FOREIGN KEY
	(
	ApplicabilityMstId
	) REFERENCES dbo.rul_ApplicabilityMaster
	(
	ApplicabilityId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_InsiderTypeCodeId FOREIGN KEY
	(
	InsiderTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_DepartmentCodeId FOREIGN KEY
	(
	DepartmentCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_GradeCodeId FOREIGN KEY
	(
	GradeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_DesignationCodeId FOREIGN KEY
	(
	DesignationCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_IncludeExcludeCodeId FOREIGN KEY
	(
	IncludeExcludeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (96, '096 rul_ApplicabilityDetails_Create', 'Create applicability details table', 'Ashashree')
