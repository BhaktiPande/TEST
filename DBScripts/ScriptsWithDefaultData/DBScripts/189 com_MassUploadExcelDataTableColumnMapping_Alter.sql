ALTER TABLE dbo.com_MassUploadExcelDataTableColumnMapping ADD
	DependentColumnNo int NULL,
	DependentColumnErrorCode varchar(20) NULL
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (189, '189 com_MassUploadExcelDataTableColumnMapping_Alter', 'com_MassUploadExcelDataTableColumnMapping Alter', 'Raghvendra')
