/*
   Friday, March 13, 20153:34:39 PM
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
CREATE TABLE dbo.com_MassUploadDataTable
	(
	MassUploadDataTableId int NOT NULL,
	MassUploadDataTableName varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'This will have the different DataTables used in the Mass Upload'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_MassUploadDataTable', NULL, NULL
GO
ALTER TABLE dbo.com_MassUploadDataTable ADD CONSTRAINT
	PK_com_MassUploadDataTable PRIMARY KEY CLUSTERED 
	(
	MassUploadDataTableId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_MassUploadDataTable SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (179, '179 com_MassUploadDataTable_create', 'Create com_MassUploadDataTable', 'Raghvendra')
