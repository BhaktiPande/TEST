IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_DefaulterReportComments]'))
DROP VIEW [dbo].[vw_DefaulterReportComments]
GO
/*
Modification History
ModifiedBy	ModifiedOn		Description
Parag		08-Dec-2015		Made change to show quantity with contra trade comment
Tushar		15-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)

*/
CREATE VIEW [dbo].[vw_DefaulterReportComments]
AS 
SELECT DISTINCT DRC1.DefaulterReportID,
STUFF((SELECT ','+ CONVERT(VARCHAR(MAX), ar.CodeID )
				   FROM rpt_DefaulterReportComments DRC
				  LEFT JOIN com_Code ar ON ar.CodeID = DRC.CommentCodeId
				  WHERE DRC.DefaulterReportID = DRC1.DefaulterReportID
			   GROUP BY ar.CodeID
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1, 1, '') AS CommentsID,
STUFF((SELECT ','+ CASE WHEN ar.CodeID = 169007 THEN 
				  CASE WHEN DRC.ContraTradeQty > 0 THEN ar.CodeName + ' for ' + CONVERT(varchar(20), DRC.ContraTradeQty) + ' qty ' 
				       ELSE ar.CodeName + ' ' END
			ELSE ar.CodeName END
				   FROM rpt_DefaulterReportComments DRC
				  LEFT JOIN com_Code ar ON ar.CodeID = DRC.CommentCodeId
				  WHERE DRC.DefaulterReportID = DRC1.DefaulterReportID
			   GROUP BY ar.CodeName, ar.CodeID, DRC.ContraTradeQty
				FOR XML PATH(''), TYPE).value('.','VARCHAR(max)'), 1, 1, '') AS Comments
FROM rpt_DefaulterReportComments DRC1

