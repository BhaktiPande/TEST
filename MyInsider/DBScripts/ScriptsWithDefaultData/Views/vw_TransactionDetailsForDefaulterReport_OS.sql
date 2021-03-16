IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_TransactionDetailsForDefaulterReport_OS]'))
DROP VIEW [dbo].[vw_TransactionDetailsForDefaulterReport_OS]
GO
/*
Modification History
ModifiedBy	ModifiedOn		Description


*/
CREATE VIEW [dbo].[vw_TransactionDetailsForDefaulterReport_OS]
AS
SELECT TD.TransactionMasterId, PreclearanceRequestId, TransactionDetailsId, CSecurityType.CodeName AS SecurityType, CTransaction.CodeName AS TransactionType, TD.SecurityTypeCodeId, TransactionTypeCodeId,
CASE WHEN TransactionTypeCodeId IN (143001, 143003, 143004, 143005) THEN Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) ELSE NULL END AS TradeBuyQty,
CASE WHEN TransactionTypeCodeId = 143002 THEN Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) ELSE NULL END
	--WHEN TransactionTypeCodeId IN (143004, 143005) THEN Quantity2 * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END) ELSE NULL END 
	AS TradeSellQty,
(Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) AS Qty,
Value,
TD.DMATDetailsID AS DMATDetailsID,
DMATD.DEMATAccountNumber AS DEMATAccountNumber,
UI.UserFullName AS AccountHolderName,
CASE WHEN code.CodeName IS NULL THEN 'Self' ELSE code.CodeName END AS Relation
FROM tra_TransactionDetails_OS TD JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID
	JOIN com_Code CTransaction ON TransactionTypeCodeId = CTransaction.CodeID
	JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
	JOIN usr_DMATDetails DMATD ON TD.DMATDetailsID = DMATD.DMATDetailsID
	JOIN vw_UserInformation UI ON DMATD.UserInfoID = UI.UserInfoId
	LEFT JOIN usr_UserRelation UR ON UI.UserInfoID = UR.UserInfoIdRelative 
	LEFT JOIN com_Code code ON UR.RelationTypeCodeId = code.CodeID
WHERE TransactionStatusCodeId > 148002
