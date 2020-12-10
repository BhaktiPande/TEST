
ALTER TABLE rpt_DefaulterReportComments 
	ADD ContraTradeQty DECIMAL(10,0)

GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (211, '211 rpt_DefaulterReportComments_Alter', 'rpt_DefaulterReportComments alter', 'Arundhati')

