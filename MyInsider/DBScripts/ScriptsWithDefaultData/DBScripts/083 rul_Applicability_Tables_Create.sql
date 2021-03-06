/*APPLICABILITY FLAGS - TABLE CREATION*/
/*
   Monday, March 23, 201512:01:06 PM
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
CREATE TABLE dbo.rul_ApplicabilityFlags
	(
	ApplicabilityFlagId int NOT NULL IDENTITY (1, 1),
	MapToTypeCodeId int NOT NULL,
	MapToId int NOT NULL,
	AllEmployeeFlag bit NOT NULL,
	AllInsiderFlag bit NOT NULL,
	AllEmployeeInsidersFlag bit NOT NULL,
	AllCorporateInsiderFlag bit NOT NULL,
	AllNonEmployeeInsiderFlag bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	DF_rul_ApplicabilityFlags_AllEmployeeFlag DEFAULT 0 FOR AllEmployeeFlag
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	DF_rul_ApplicabilityFlags_AllInsiderFlag DEFAULT 0 FOR AllInsiderFlag
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	DF_rul_ApplicabilityFlags_AllEmployeeInsidersFlag DEFAULT 0 FOR AllEmployeeInsidersFlag
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	DF_Table_1_AllCorporateFlag DEFAULT 0 FOR AllCorporateInsiderFlag
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	DF_Table_1_AllNonEmployeeFlag DEFAULT 0 FOR AllNonEmployeeInsiderFlag
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	PK_rul_ApplicabilityFlags PRIMARY KEY CLUSTERED 
	(
	ApplicabilityFlagId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------
/*APPLICABILITY FLAGS - ADD DESCRIPTION*/

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
DECLARE @v sql_variant 
SET @v = N'Refers to com_Code, XXX001: Policy Document , XXX002: Trading Policy'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityFlags', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'When MapToTypeCodeId = XXX001 Then MapToId=PolicyDocumentId'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityFlags', N'COLUMN', N'MapToId'
GO
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------
/*APPLICABILITY FLAGS - FOREIGN KEY APPLICATION*/
/*
   Monday, March 23, 201512:12:17 PM
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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_ApplicabilityFlags ADD CONSTRAINT
	FK_rul_ApplicabilityFlags_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------
/*APPLICABILITY FLAGS - UNIQUE COMBINATION OF MapToTypeCodeId AND MapToId WHEN STORING THE APPLICABILITY FLAGS*/
/*
   Monday, March 23, 201512:21:32 PM
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
CREATE UNIQUE NONCLUSTERED INDEX IX_rul_ApplicabilityFlags_MapToTypeCodeId_MapToId ON dbo.rul_ApplicabilityFlags
	(
	MapToTypeCodeId,
	MapToId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Combination of MapToTypeId and corresponding MapToId will be unique when storing applicability flags.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityFlags', N'INDEX', N'IX_rul_ApplicabilityFlags_MapToTypeCodeId_MapToId'
GO
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*APPLICABILITY MASTER - TABLE CREATION*/

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
	ApplicabilityId int NOT NULL,
	ApplicabilityFlagId int NOT NULL,
	Flag1 bit NOT NULL,
	Flag2 bit NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers : rul_ApplicabilityFlags'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'ApplicabilityFlagId'
GO
DECLARE @v sql_variant 
SET @v = N'When MapToTypeCodeId=XXX001 (PolicyDocument) for rul_Applicability.ApplicabilityFlagId then, this is flag for ''View'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'Flag1'
GO
DECLARE @v sql_variant 
SET @v = N'When MapToTypeCodeId=XXX001 (PolicyDocument) for rul_Applicability.ApplicabilityFlagId then, this is flag for ''View & Agree'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityMaster', N'COLUMN', N'Flag2'
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	DF_rul_ApplicabilityMaster_Flag1 DEFAULT 0 FOR Flag1
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	DF_rul_ApplicabilityMaster_Flag2 DEFAULT 0 FOR Flag2
GO
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*APPLICABILITY MASTER - FOREIGN KEY APPLICATION and UNIQUE COMBINATION OF ApplicabilityFlagId AND ApplicabilityId WHEN STORING THE APPLICABILITY*/

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
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_rul_ApplicabilityMaster_ApplicabilityFlagId_ApplicabilityId ON dbo.rul_ApplicabilityMaster
	(
	ApplicabilityFlagId,
	ApplicabilityId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_rul_ApplicabilityFlags_ApplicabilityFlagId FOREIGN KEY
	(
	ApplicabilityFlagId
	) REFERENCES dbo.rul_ApplicabilityFlags
	(
	ApplicabilityFlagId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*APPLICABILITY DETAILS - TABLE CREATION*/

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
	ApplicabilityId int NOT NULL,
	ApplicabilityFlagId int NOT NULL,
	ApplyToTypeCodeId int NOT NULL,
	ApplyToValue nvarchar(100) NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Refers : rul_ApplicabilityMaster'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ApplicabilityId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers : rul_ApplicabilityFlags'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ApplicabilityFlagId'
GO
DECLARE @v sql_variant 
SET @v = N'Refers : com_Code, XXX001: Company, XXX002: Department, XXX003: Grade, XXX004: Designation, XXX005: UserInfoId'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ApplyToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'will refer to Id integer value if Applicability is for Employee. For Corporate and Non-Employee this will store character value of company and not company id'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_ApplicabilityDetails', N'COLUMN', N'ApplyToValue'
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------
/*APPLICABILITY DETAILS - FOREIGN KEY AND UNIQUE COMBINATION OF ApplicabilityFlagId AND ApplicabilityId WHEN STORING THE APPLICABILITY DETAILS*/

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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_ApplicabilityFlags SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityFlags', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_rul_ApplicabilityDetails_ApplicabilityFlagId_ApplicabilityId ON dbo.rul_ApplicabilityDetails
	(
	ApplicabilityFlagId,
	ApplicabilityId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_rul_ApplicabilityFlags_ApplicabilityFlagId FOREIGN KEY
	(
	ApplicabilityFlagId
	) REFERENCES dbo.rul_ApplicabilityFlags
	(
	ApplicabilityFlagId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_com_Code_ApplyToTypeCodeId FOREIGN KEY
	(
	ApplyToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per 

-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (83, '083 rul_Applicability_Tables_Create', 'Create tables for applicability information storage', 'Ashashree')
