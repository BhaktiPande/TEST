IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ContinuousDisclosureStatus]'))
DROP VIEW [dbo].[vw_ContinuousDisclosureStatus]
GO
/*
Modification History
ModifiedBy	ModifiedOn		Description
Tushar		17-May-2016		Return Display Rolling Number Column 

*/
CREATE VIEW [dbo].[vw_ContinuousDisclosureStatus]
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

CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpByCOSubmitStatus,
CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN ELHCpByCOSubmit.EventDate ELSE NULL END AS HcpByCOSubmitDate,
TM.DisplayRollingNumber AS DisplayRollingNumber
FROM tra_TransactionMaster TM
JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId IN (153019, 153020) GROUP BY MapToId) ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153021 GROUP BY MapToId) ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153022 GROUP BY MapToId) ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153024 GROUP BY MapToId) ELHCpByCOSubmit ON TM.TransactionMasterId = ELHCpByCOSubmit.MapToId
WHERE DisclosureTypeCodeId = 147002