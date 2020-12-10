CREATE TABLE rpt_DefaulterReportComments
(
DefaulterReportID BIGINT,
CommentCodeId INT
)
GO

-- FK CommentCodeId
ALTER TABLE rpt_DefaulterReportComments ADD CONSTRAINT FK_rpt_DefaulterReportComments_com_Code_CommentCodeId FOREIGN KEY
(CommentCodeId) REFERENCES com_Code(CodeID)	
GO


-- FK DefaulterReportID
ALTER TABLE rpt_DefaulterReportComments ADD CONSTRAINT FK_rpt_DefaulterReportComments_rpt_DefaulterReport_DefaulterReportID FOREIGN KEY
(DefaulterReportID) REFERENCES rpt_DefaulterReport(DefaulterReportID)	
GO


CREATE UNIQUE NONCLUSTERED INDEX uk_rpt_DefaulterReportComments_DefaulterReportID_CommentId ON dbo.rpt_DefaulterReportComments
(DefaulterReportID,CommentCodeId)
GO

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (185, '185 rpt_DefaulterReportComments_Create', 'Create rpt_DefaulterReportComments', 'Arundhati')
