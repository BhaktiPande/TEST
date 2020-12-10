/*Add columns for managing the HIMs server connection details*/
ALTER TABLE dbo.Companies
ADD HIMSConnectionServer VARCHAR(200) NULL
ALTER TABLE dbo.Companies
ADD HIMSConnectionDatabaseName VARCHAR(200) NULL
ALTER TABLE dbo.Companies
ADD HIMSConnectionUserName VARCHAR(200) NULL
ALTER TABLE dbo.Companies
ADD HIMSConnectionPassword VARCHAR(200) NULL
ALTER TABLE dbo.Companies
ADD HIMSViewName VARCHAR(200) NULL

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (5, '005 Companies_Add_HRMS_Server_Columns_Alter.sql', 'Alter Companies Add HRMS related columns', 'Raghvendra')
