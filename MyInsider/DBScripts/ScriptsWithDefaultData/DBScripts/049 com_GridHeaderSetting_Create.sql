/*
   Tuesday, February 10, 20155:28:38 PM
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
CREATE TABLE dbo.com_GridHeaderSetting
	(
	GridTypeCodeId int NOT NULL,
	ResourceKey varchar(15) NOT NULL,
	IsVisible int NOT NULL,
	SequenceNumber int NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'ResourceKey from mst_Resource table used to show the column header'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_GridHeaderSetting', N'COLUMN', N'ResourceKey'
GO
ALTER TABLE dbo.com_GridHeaderSetting ADD CONSTRAINT
	DF_com_GridHeaderSetting_IsVisible DEFAULT 1 FOR IsVisible
GO
ALTER TABLE dbo.com_GridHeaderSetting ADD CONSTRAINT
	PK_com_GridHeaderSetting PRIMARY KEY CLUSTERED 
	(
	GridTypeCodeId,
	ResourceKey
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------

/*
   Tuesday, February 10, 20155:37:23 PM
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
DECLARE @v sql_variant 
SET @v = N'Refers com_code, CodeGroupId = 114'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_GridHeaderSetting', N'COLUMN', N'GridTypeCodeId'
GO
ALTER TABLE dbo.com_GridHeaderSetting ADD CONSTRAINT
	FK_com_GridHeaderSetting_com_Code_GridTypeCodeId FOREIGN KEY
	(
	GridTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_GridHeaderSetting SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_GridHeaderSetting', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (49, '049 com_GridHeaderSetting_Create', 'Create grid header setting table', 'Arundhati')
