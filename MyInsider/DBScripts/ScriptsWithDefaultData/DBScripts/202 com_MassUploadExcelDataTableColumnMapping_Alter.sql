ALTER TABLE com_MassUploadExcelDataTableColumnMapping
ADD DefaultValue VARCHAR(100) NULL


----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (202, '202 com_MassUploadExcelDataTableColumnMapping_Alter', 'com_MassUploadExcelDataTableColumnMapping_Alter', 'Raghvendra')
