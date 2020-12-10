IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TransactionSummaryPeriodEndDate]'))
DROP VIEW [dbo].[vw_TransactionSummaryPeriodEndDate]
GO
/*
Modification History
ModifiedBy	ModifiedOn Description

*/
CREATE VIEW vw_TransactionSummaryPeriodEndDate
AS
SELECT
DATEADD(YY, CONVERT(INT, SUBSTRING(cYear.Description,1, 4)) - 1970, cPeriod.Description) PeriodEndDate, TransactionSummaryId
From tra_TransactionSummary TS JOIN com_Code cYear ON TS.YearCodeId = cYear.CodeID
JOIN com_Code cPeriod ON TS.PeriodCodeId = cPeriod.CodeID
