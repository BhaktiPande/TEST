
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
CREATE TABLE dbo.Tmp_com_MassUploadProcedureParameterDetails
	(
	MassUploadProcedureParameterDetailsId int NOT NULL,
	MassUploadSheetId int NOT NULL,
	MassUploadProcedureParameterNumber int NOT NULL,
	MassUploadDataTableId int NULL,
	MassUploadExcelDataTableColumnMappingId int NULL,
	MassUploadProcedureParameterValue nvarchar(100) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_com_MassUploadProcedureParameterDetails SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.com_MassUploadProcedureParameterDetails)
	 EXEC('INSERT INTO dbo.Tmp_com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId, MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue)
		SELECT MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId, MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue FROM dbo.com_MassUploadProcedureParameterDetails WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.com_MassUploadProcedureParameterDetails
GO
EXECUTE sp_rename N'dbo.Tmp_com_MassUploadProcedureParameterDetails', N'com_MassUploadProcedureParameterDetails', 'OBJECT' 
GO
COMMIT

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (204, '204 com_MassUploadProcedureParameterDetails_RemoveIdentityColumn', 'com_MassUploadProcedureParameterDetails_RemoveIdentityColumn alter', 'Raghvendra')
