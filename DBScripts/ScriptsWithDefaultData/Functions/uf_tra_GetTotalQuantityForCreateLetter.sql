IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_tra_GetTotalQuantityForCreateLetter')
	DROP FUNCTION uf_tra_GetTotalQuantityForCreateLetter
GO
/*-------------------------------------------------------------------------------------------------
Description:	This function used for Total quantity of shares to be displayed on Pre-clearance Continous Disclosure page for which 
				the stock exchange submission row is required.
Created by:		Tushar
Created on:		29-Apr-2016

Modification History:
Modified By		Modified On		Description
Tushar			02-May-2016		Replace Qty by Value.
--------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_tra_GetTotalQuantityForCreateLetter]
(
	@inp_iTransactionMasterID	BIGINT	-- Default error number
)
RETURNS DECIMAL(10,0) AS  
BEGIN
	
	DECLARE @nQuantity DECIMAL(10,0)
	
	DECLARE @dtPeriodEndDate DATETIME, @nTradingPolicyId INT, @dtSubmissionDate DATETIME, @dtLastSubmissionDate DATETIME
	DECLARE @nMultiTransTradeFlagCodeId INT,@nSecurityTypeCodeId INT, @nDisclosureTypeCodeId INT, @nUserInfoId INT
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153019
	DECLARE @nSoftCopyReq INT
	DECLARE @nTransactionTrade_Multiple INT = 136002
	DECLARE @nIsLimitSetForAllSecurities INT
	
	DECLARE @tmptransactionID TABLE(TMID BIGINT)
	DECLARE @tmptransactionIDQty TABLE(TMID BIGINT,Quantity DECIMAL(10,0))
		
	SELECT @dtPeriodEndDate = PeriodEndDate, @nTradingPolicyId = TM.TradingPolicyId, @nSoftCopyReq = SoftCopyReq,
			@nMultiTransTradeFlagCodeId = StExSingMultiTransTradeFlagCodeId,
			@dtSubmissionDate = EL.EventDate,
			@nDisclosureTypeCodeId = DisclosureTypeCodeId,
			@nSecurityTypeCodeId = SecurityTypeCodeId,
			@nUserInfoId = TM.UserInfoId
		FROM tra_TransactionMaster TM JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			LEFT JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.MapToId = @inp_iTransactionMasterId
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		
	SELECT @nIsLimitSetForAllSecurities = CASE WHEN SecurityTypeCodeId IS NULL THEN 1 ELSE 0 END -- 1: For all, 0: For indiv security
		FROM rul_TradingPolicySecuritywiseLimits
		WHERE TradingPolicyId = @nTradingPolicyId
		AND MapToTypeCodeId = 132005
		AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @nSecurityTypeCodeId)
		
	--INSERT INTO @tmptransactionID
	--EXEC st_tra_TransactionIdsForLetter @inp_iTransactionMasterID
	
	
	--print 'For continuous'
			--print '@nMultiTransTradeFlagCodeId = ' + CONVERT(VARCHAR(10), @nMultiTransTradeFlagCodeId)
			--print '@@nIsLimitSetForAllSecurities = ' + CONVERT(VARCHAR(10), @nIsLimitSetForAllSecurities)
			IF @nMultiTransTradeFlagCodeId = @nTransactionTrade_Multiple
			BEGIN
				SELECT @dtLastSubmissionDate = EL.EventDate
				FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
				WHERE EL.EventDate < @dtSubmissionDate
					AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
					AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
					AND SoftCopyReq = 1

				--print '@dtLastSubmissionDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtLastSubmissionDate, ''))
				--print '@dtPeriodEndDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtPeriodEndDate, ''))
				--print '@dtSubmissionDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtSubmissionDate, ''))
				--print '@nSecurityTypeCodeId = ' + CONVERT(VARCHAR(10), @nSecurityTypeCodeId) 
				
				
				INSERT INTO @tmptransactionID(TMID)		
				SELECT TransactionMasterId
				FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
				WHERE TM.UserInfoId = @nUserInfoId
					ANd EL.EventDate <= @dtSubmissionDate
					AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
					AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
					--AND SoftCopyReq = 1
					AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)
					
			END
			ELSE
			BEGIN
				INSERT INTO @tmptransactionID(TMID) VALUES(@inp_iTransactionMasterId)
			END
	
			INSERT INTO @tmptransactionIDQty
			SELECT TD.TransactionMasterId , SUM(TD.Value) Qty
			FROM tra_TransactionDetails TD
			JOIN @tmptransactionID T ON TD.TransactionMasterId = T.TMID
			GROUP BY td.TransactionMasterId
	
			SELECT @nQuantity = SUM(quantity) 
			FROM @tmptransactionIDQty
				
			RETURN @nQuantity
	
END


