/*
   Friday, March 13, 20153:27:44 PM
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
CREATE TABLE dbo.com_MassUploadExcel
	(
	MassUploadExcelId int NOT NULL IDENTITY (1, 1),
	MassUploadName varchar(100) NOT NULL,
	HasMultipleSheets bit NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Will contain the list of mass uploads which can be performed and also the excel file to be used for performing the Mass upload'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'com_MassUploadExcel', NULL, NULL
GO
ALTER TABLE dbo.com_MassUploadExcel SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (177, '177 com_MassUploadExcel_create', 'Create com_MassUploadExcel', 'Raghvendra')
