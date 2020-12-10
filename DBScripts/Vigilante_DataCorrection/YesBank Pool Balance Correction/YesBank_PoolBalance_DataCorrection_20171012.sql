
/*
	Created By  :	Shubhangi Gurude
	Created On  :   12-Oct-2017
	Description :	This script is used to correct exercise balance pool for Yes Bank	
*/

UPDATE ebp SET otherquantity = tsdw.ClosingBalance 
FROM tra_ExerciseBalancePool ebp inner join tra_TransactionSummaryDMATWise 
TSDW on ebp.UserInfoId = TSDW.UserInfoId 
and ebp.SecurityTypeCodeId = tsdw.SecurityTypeCodeId 
and ebp.DMATDetailsID = tsdw.DMATDetailsID 
WHERE  ebp.SecurityTypeCodeId IN (SELECT CodeID FROM com_Code WHERE CodeGroupId=139 and IsActive=1)
and tsdw.TransactionSummaryDMATWiseId = (SELECT max(TransactionSummaryDMATWiseId) FROM tra_TransactionSummaryDMATWise WHERE UserInfoId = ebp.UserInfoId and SecurityTypeCodeId= ebp.SecurityTypeCodeId and DMATDetailsID = EBP.DMATDetailsID)
and (ebp.OtherQuantity <> tsdw.ClosingBalance) 
and ebp.UserInfoId NOT IN(SELECT UserInfoId FROM tra_PreclearanceRequest PreC WHERE PreC.PreclearanceStatusCodeId not in (144002,144003))