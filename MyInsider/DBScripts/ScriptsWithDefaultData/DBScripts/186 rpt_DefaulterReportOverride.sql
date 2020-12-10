CREATE TABLE rpt_DefaulterReportOverride
(
DefaulterReportID BIGINT NOT NULL,
Reason NVARCHAR(500),
IsRemovedFromNonCompliance INT
)
GO

-- PK on DefaulterReportID
ALTER TABLE rpt_DefaulterReportOverride ADD CONSTRAINT PK_rpt_DefaulterReportOverride PRIMARY KEY (DefaulterReportID)
GO

-- FK DefaulterReportID
ALTER TABLE rpt_DefaulterReportOverride ADD CONSTRAINT FK_rpt_DefaulterReportOverride_rpt_DefaulterReport_DefaulterReportID FOREIGN KEY
(DefaulterReportID) REFERENCES rpt_DefaulterReport(DefaulterReportID)	
GO

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (186, '186 rpt_DefaulterReportOverride_Create', 'Create 174 rpt_DefaulterReportOverride', 'Arundhati')
