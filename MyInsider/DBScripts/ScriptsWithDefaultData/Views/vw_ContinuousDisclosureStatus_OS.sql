IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ContinuousDisclosureStatus_OS]'))
DROP VIEW [dbo].[vw_ContinuousDisclosureStatus_OS]
GO
/*
Modification History
ModifiedBy	ModifiedOn		Description
 

*/
CREATE VIEW [dbo].[vw_ContinuousDisclosureStatus_OS]
AS
SELECT distinct TransactionMasterId, TM.UserInfoId, TM.PeriodEndDate, 
                TM.SoftCopyReq, TM.HardCopyReq,
                TP.StExSubmitDiscloToStExByCOHardcopyFlag AS HcpByCOReq,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS DetailsSubmitStatus,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN ELSubmit.EventDate ELSE NULL END AS DetailsSubmitDate,

CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS ScpSubmitStatus,
CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN ELSCpSubmit.EventDate ELSE NULL END AS ScpSubmitDate,

CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpSubmitStatus,
CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN ELHCpSubmit.EventDate ELSE NULL END AS HcpSubmitDate,

NULL AS HcpByCOSubmitStatus,
NULL AS HcpByCOSubmitDate,
TM.DisplayRollingNumber AS DisplayRollingNumber
FROM tra_TransactionMaster_OS TM
JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId IN (153057, 153058) GROUP BY MapToId) ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153059 GROUP BY MapToId) ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153060 GROUP BY MapToId) ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId
WHERE DisclosureTypeCodeId = 147002