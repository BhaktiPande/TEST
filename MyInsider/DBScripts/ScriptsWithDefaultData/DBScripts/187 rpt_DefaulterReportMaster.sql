CREATE TABLE rpt_DefaulterReportMaster
(
DefaulterReportMaster INT NOT NULL,
LastRunTime DATETIME
)
GO

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (187, '187 rpt_DefaulterReportMaster_Create', '175 rpt_DefaulterReportMaster', 'Arundhati')
