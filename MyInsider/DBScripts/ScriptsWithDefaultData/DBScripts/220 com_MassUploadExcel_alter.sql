--Add new column for TemplateFileName  
ALTER TABLE com_MassUploadExcel
ADD TemplateFileName VARCHAR(200) NOT NULL DEFAULT ''

------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (220, '220 com_MassUploadExcel_alter', 'alter table com_MassUploadExcel', 'Raghvendra')
