IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PreclearanceRequestStatus]'))
DROP VIEW [dbo].[vw_PreclearanceRequestStatus]
GO
/*
Modification History
ModifiedBy	ModifiedOn Description

*/
CREATE VIEW [dbo].[vw_PreclearanceRequestStatus]
AS
SELECT
PR.PreclearanceRequestId,
PR.CreatedOn AS RequestDate,
SecuritiesToBeTradedQty AS RequestedQty,
SecuritiesToBeTradedValue AS RequestedValue,
CASE WHEN EventCodeId = 153016 THEN DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate) ELSE NULL END AS PreclearanceApplicabletill,
ELApp.EventDate AS PreclearanceStatusDate,
PreclearanceStatusCodeId,
CdPRStatus.CodeName AS PreclearanceStatus,
PR.SecurityTypeCodeId,
CSecurity.CodeName AS SecurityType,
PR.TransactionTypeCodeId,
CTransaction.CodeName AS TransactionType,
MIN(TransactionMasterId) AS TransactionMasterId,
PR.DMATDetailsID AS DMATDetailsID,
DMATD.DEMATAccountNumber AS DEMATAccountNumber,
UI.UserFullName AS AccountHolderName
FROM tra_PreclearanceRequest PR
JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
JOIN eve_EventLog ELApp ON ELApp.EventCodeId IN (153017,153016) AND MapToTypeCodeId = 132004 AND ELApp.MapToId = PR.PreclearanceRequestId
JOIN com_Code CdPRStatus ON PreclearanceStatusCodeId = CdPRStatus.CodeID
JOIN com_Code CSecurity ON PR.SecurityTypeCodeId = CSecurity.CodeID
JOIN com_Code CTransaction ON PR.TransactionTypeCodeId = CTransaction.CodeID
JOIN usr_DMATDetails DMATD ON PR.DMATDetailsID = DMATD.DMATDetailsID
JOIN vw_UserInformation UI ON DMATD.UserInfoID = UI.UserInfoId
GROUP BY PR.PreclearanceRequestId,
PR.CreatedOn,
SecuritiesToBeTradedQty,
SecuritiesToBeTradedValue,
EventCodeId,
TP.PreClrCOApprovalLimit, 
ELApp.EventDate,--CASE WHEN EventCodeId = 153016 THEN DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate) ELSE NULL END AS PreclearanceApplicabletill,
PreclearanceStatusCodeId,
CdPRStatus.CodeName,
PR.SecurityTypeCodeId,
CSecurity.CodeName,
PR.TransactionTypeCodeId,
CTransaction.CodeName,
PR.DMATDetailsID,
DMATD.DEMATAccountNumber,
UI.UserFullName