
ALTER TABLE com_MassUploadExcelDataTableColumnMapping
ALTER COLUMN ValidationRegularExpression VARCHAR(2000) NULL

GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (212, '212 com_MassUploadExcelDataTableColumnMapping_alter', 'com_MassUploadExcelDataTableColumnMapping alter', 'Arundhati')

