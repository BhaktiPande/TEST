ALTER TABLE com_MassUploadExcelDataTableColumnMapping
ADD DependentValueColumnNumber INT NULL

ALTER TABLE com_MassUploadExcelDataTableColumnMapping
ADD DependentValueColumnValue VARCHAR(4000) NULL 

ALTER TABLE com_MassUploadExcelDataTableColumnMapping
ADD DependentValueColumnErrorCode VARCHAR(20) NULL

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (196, '196 com_MassUploadExcelDataTableColumnMapping_Alter', 'com_MassUploadExcelDataTableColumnMapping Alter', 'Raghvendra')
