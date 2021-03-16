IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PeriodEndDisclosureStatus_OS]'))
DROP VIEW [dbo].[vw_PeriodEndDisclosureStatus_OS]
GO
/*
Modification History:
Modified By		Modified On		Description


*/
CREATE VIEW [dbo].[vw_PeriodEndDisclosureStatus_OS]
AS
SELECT distinct TransactionMasterId, TM.UserInfoId, TM.PeriodEndDate, TM.SoftCopyReq, TM.HardCopyReq, TP.DiscloPeriodEndSubmitToStExByCOHardcopyFlag AS HcpByCOReq,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN (CASE WHEN ELSubmit.EventCode = 153030 THEN 2 ELSE 1 END) ELSE 0 END AS DetailsSubmitStatus,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN ELSubmit.EventDate ELSE NULL END AS DetailsSubmitDate,

CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS ScpSubmitStatus,
CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN ELSCpSubmit.EventDate ELSE NULL END AS ScpSubmitDate,

CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpSubmitStatus,
CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN ELHCpSubmit.EventDate ELSE NULL END AS HcpSubmitDate,

NULL AS HcpByCOSubmitStatus,
NULL AS HcpByCOSubmitDate
FROM tra_TransactionMaster_OS TM 
JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate, MIN(EventCodeId) AS EventCode FROM eve_EventLog WHERE EventCodeId IN (153062, 153063) GROUP BY MapToId) ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153064 GROUP BY MapToId) ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153065 GROUP BY MapToId) ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId
--LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153034 GROUP BY MapToId) ELHCpByCOSubmit ON TM.TransactionMasterId = ELHCpByCOSubmit.MapToId
WHERE DisclosureTypeCodeId = 147003
--ORDER BY TransactionMasterId
