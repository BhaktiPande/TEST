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
CREATE TABLE dbo.Tmp_com_MassUploadExcel
	(
	MassUploadExcelId int NOT NULL,
	MassUploadName varchar(100) NOT NULL,
	HasMultipleSheets bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_MassUploadExcel SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Will contain the list of mass uploads which can be performed and also the excel file to be used for performing the Mass upload'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_com_MassUploadExcel', NULL, NULL
GO
IF EXISTS(SELECT * FROM dbo.com_MassUploadExcel)
	 EXEC('INSERT INTO dbo.Tmp_com_MassUploadExcel (MassUploadExcelId, MassUploadName, HasMultipleSheets)
		SELECT MassUploadExcelId, MassUploadName, HasMultipleSheets FROM dbo.com_MassUploadExcel WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.com_MassUploadExcel
GO
EXECUTE sp_rename N'dbo.Tmp_com_MassUploadExcel', N'com_MassUploadExcel', 'OBJECT' 
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_MassUploadExcel', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_MassUploadExcel', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_MassUploadExcel', 'Object', 'CONTROL') as Contr_Per 


----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (203, '203 com_MassUploadExcel_RemoveIdentityProperty', 'com_MassUploadExcel_RemoveIdentityProperty alter', 'Raghvendra')
