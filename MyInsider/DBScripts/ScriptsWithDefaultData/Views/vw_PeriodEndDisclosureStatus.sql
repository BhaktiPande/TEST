IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PeriodEndDisclosureStatus]'))
DROP VIEW [dbo].[vw_PeriodEndDisclosureStatus]
GO
/*
Modification History:
Modified By		Modified On		Description
Parag			10-Aug-2015		Made change return details submission status - 1 for disclosure status code submitted and 2 for status code uploaded 
Parag			23-Oct-2015		Made change to show "Stock exchange submission" date accepted instead of event log date
Parag			02-Nov-2015		Made change to user TP from UserPeriodEndMapping table which applicable for that period 
Parag			05-Nov-2015		Made change to fix issue of duplicate records

*/
CREATE VIEW [dbo].[vw_PeriodEndDisclosureStatus]
AS
SELECT distinct TransactionMasterId, TM.UserInfoId, TM.PeriodEndDate, TM.SoftCopyReq, TM.HardCopyReq, TP.DiscloPeriodEndSubmitToStExByCOHardcopyFlag AS HcpByCOReq,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN (CASE WHEN ELSubmit.EventCode = 153030 THEN 2 ELSE 1 END) ELSE 0 END AS DetailsSubmitStatus,
CASE WHEN ELSubmit.MapToId IS NOT NULL THEN ELSubmit.EventDate ELSE NULL END AS DetailsSubmitDate,

CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS ScpSubmitStatus,
CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN ELSCpSubmit.EventDate ELSE NULL END AS ScpSubmitDate,

CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpSubmitStatus,
CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN ELHCpSubmit.EventDate ELSE NULL END AS HcpSubmitDate,

CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpByCOSubmitStatus,
CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN TM.HardCopyByCOSubmissionDate ELSE NULL END AS HcpByCOSubmitDate
FROM tra_TransactionMaster TM 
JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate, MIN(EventCodeId) AS EventCode FROM eve_EventLog WHERE EventCodeId IN (153029, 153030) GROUP BY MapToId) ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153031 GROUP BY MapToId) ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153032 GROUP BY MapToId) ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId
LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153034 GROUP BY MapToId) ELHCpByCOSubmit ON TM.TransactionMasterId = ELHCpByCOSubmit.MapToId
WHERE DisclosureTypeCodeId = 147003
--ORDER BY TransactionMasterId
