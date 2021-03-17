
/*
Modified By		Modified On		Description
Arundhati		02-Jul-2015		Added condition for Applicable From <= GETDATE
Tushar			28-Jun-2016		Comment TP.CurrentHistoryCodeId = 134001
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterCurrentTradingPolicy_OS]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterCurrentTradingPolicy_OS]
GO

CREATE VIEW [dbo].[vw_ApplicabilityMasterCurrentTradingPolicy_OS]
AS
WITH tblTradingPolicy
AS
(
 SELECT MAX(TradingPolicyId) AS TradingPolicyId, TradingPolicyParentId 
 FROM (
       SELECT TP.TradingPolicyId AS TradingPolicyId, ISNULL(TP.TradingPolicyParentId,TradingPolicyId) AS TradingPolicyParentId FROM rul_TradingPolicy_OS TP
	   WHERE 
       TP.TradingPolicyStatusCodeId = 141002
       AND (TP.ApplicableToDate IS NULL OR TP.ApplicableToDate >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate())))
       AND TP.ApplicableFromDate <= dbo.uf_com_GetServerDate()
	  ) TblResult GROUP BY TradingPolicyParentId 
)
SELECT AM.* FROM rul_ApplicabilityMaster_OS AM JOIN
(SELECT MapToTypeCodeId, MapToId, MAX(ApplicabilityId) AS ApplicabilityId
FROM rul_ApplicabilityMaster_OS AM JOIN rul_TradingPolicy_OS TP ON MapToTypeCodeId = 132022 AND AM.MapToId = TP.TradingPolicyId
INNER JOIN tblTradingPolicy tblTP ON AM.MapToId = tblTP.TradingPolicyId
GROUP BY MapToTypeCodeId, MapToId) AS AMCurrent
ON AM.ApplicabilityId = AMCurrent.ApplicabilityId
