
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'rpt_DefaulterReportComments_OS')
BEGIN

	CREATE TABLE rpt_DefaulterReportComments_OS
	(
		DefaulterReportID BIGINT NULL CONSTRAINT [FK_rpt_DefaulterReportComments_OS_rpt_DefaulterReport_OS_DefaulterReportID] FOREIGN KEY(DefaulterReportID) REFERENCES rpt_DefaulterReport_OS (DefaulterReportID),
		CommentCodeId INT NULL CONSTRAINT [FK_rpt_DefaulterReportComments_OS_com_Code_CommentCodeId] FOREIGN KEY(CommentCodeId) REFERENCES com_Code (CodeID),
		ContraTradeQty DECIMAL(10, 0) NULL
	)
END
GO
