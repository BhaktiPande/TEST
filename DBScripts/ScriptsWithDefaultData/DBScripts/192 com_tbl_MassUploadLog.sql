
  ALTER TABLE com_tbl_MassUploadLog
  ADD UploadedDocumentId INT NULL 
  
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (192, '192 com_tbl_MassUploadLog', 'com_tbl_MassUploadLog Alter', 'Raghvendra')
