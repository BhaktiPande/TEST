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
ALTER TABLE dbo.Companies
	DROP CONSTRAINT DF_Companies_UpdateResources
GO
CREATE TABLE dbo.Tmp_Companies
	(
	CompanyId int NOT NULL,
	CompanyName varchar(200) NULL,
	ConnectionServer varchar(200) NULL,
	ConnectionDatabaseName varchar(200) NULL,
	ConnectionUserName varchar(200) NULL,
	ConnectionPassword varchar(200) NULL,
	UpdateResources int NOT NULL,
	IsDatabaseServerRemote bit NOT NULL,
	SmtpServer varchar(200) NULL,
	SmtpPortNumber int NULL,
	SmtpUserName varchar(200) NULL,
	SmtpPassword varchar(200) NULL,
	LinkedServerName varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Companies SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Identifies whether database server for company''s database is remotely located or is on same server as the master database. Default=1 : Company database is stored remotely.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Companies', N'COLUMN', N'IsDatabaseServerRemote'
GO
ALTER TABLE dbo.Tmp_Companies ADD CONSTRAINT
	DF_Companies_UpdateResources DEFAULT ((0)) FOR UpdateResources
GO
ALTER TABLE dbo.Tmp_Companies ADD CONSTRAINT
	DF_Companies_IsDatabaseServerRemote DEFAULT 1 FOR IsDatabaseServerRemote
GO
IF EXISTS(SELECT * FROM dbo.Companies)
	 EXEC('INSERT INTO dbo.Tmp_Companies (CompanyId, CompanyName, ConnectionServer, ConnectionDatabaseName, ConnectionUserName, ConnectionPassword, UpdateResources, SmtpServer, SmtpPortNumber, SmtpUserName, SmtpPassword, LinkedServerName)
		SELECT CompanyId, CompanyName, ConnectionServer, ConnectionDatabaseName, ConnectionUserName, ConnectionPassword, UpdateResources, SmtpServer, SmtpPortNumber, SmtpUserName, SmtpPassword, LinkedServerName FROM dbo.Companies WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Companies
GO
EXECUTE sp_rename N'dbo.Tmp_Companies', N'Companies', 'OBJECT' 
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Companies', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Companies', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Companies', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (4, '004 Companies_Column_IsDatabaseServerRemote_Alter.sql', 'Alter Companies Add Column IsDatabaseServerRemote', 'Ashashree')
