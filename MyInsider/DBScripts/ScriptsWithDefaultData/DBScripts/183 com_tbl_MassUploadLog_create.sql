/*
   Tuesday, September 29, 201510:26:01 AM
   User: sa
   Server: ATLANTIX\SQLEXPRESS
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
CREATE TABLE dbo.com_tbl_MassUploadLog
	(
	MassUploadLogId int NOT NULL,
	MassUploadTypeId int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn int NOT NULL,
	Status int NOT NULL,
	ErrorReportFileName varchar(100) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.com_tbl_MassUploadLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (183, '183 com_tbl_MassUploadLog_create', 'Create com_tbl_MassUploadLog', 'Raghvendra')
