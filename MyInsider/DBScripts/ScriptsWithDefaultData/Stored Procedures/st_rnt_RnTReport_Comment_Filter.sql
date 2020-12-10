-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 19-NOV-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR COMMENT FILTER ON R & T REPORT 								=
-- EXEC st_rnt_RnTReport_Comment_Filter																	=
-- ======================================================================================================


/*
ED			4-Feb-2016	Code integration done on 4-Feb-2016
*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rnt_RnTReport_Comment_Filter')
	DROP PROCEDURE st_rnt_RnTReport_Comment_Filter
GO
CREATE PROCEDURE st_rnt_RnTReport_Comment_Filter
AS
BEGIN
	SELECT 'Ok.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. R & T Data Lower.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. R & T Data Higher.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. Vigilante Data Not Found (Holding Not Found).' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. R & T Data Not Found (Holding Not Found).' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. Vigilante Data Not Found.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. R & T Data Not Found.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. Traded with Non registered Demat Account.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. Traded with Non registered DPID.' AS Comment
	UNION ALL
	SELECT 'Transaction Mismatched. Traded with Non registered DPID and Demat Account.' AS Comment
END


