/****** Object:  UserDefinedFunction [dbo].[uf_tra_IsContraTrade]    Script Date: 12/08/2015 14:10:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_IsContraTrade]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[uf_tra_IsContraTrade]
GO

/*-------------------------------------------------------------------------------------------------
Author:			Arundhati
Create date:	03-Aug-2015
Description:	This function tell if the transaction is contra trade or not

Modification History:
Modified By		Modified On		Description
Arundhati		27-Nov-2015		Handled the case, when 2 transactions having same date of acquisition are submitted, then the latest submitted transaction will receive the comment
Arundhati		08-Dec-2015		Handled condition for ESOP pool and and finding contra trade quantity
Arundhati		11-Dec-2015		Condition changed for other transaction of security type other than Share
Parag			23-Dec-2015		Made change to check contra trade for historic data
Parag			29-Dec-2015		Made change to fix issue found in testing - contra trade is not shown in report on historic data
Tushar			15-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Tushar			11-Apr-2016		Change Contra trade (applicable for single or different security types)
Tushar			13-Oct-2016		Change for contra trade qty base if transaction found for only other qty then show contra trade for other qty
								if found for ESOP then contra trade for ESOP qty & if Both then sum of both is contra trade qty.
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION uf_tra_IsContraTrade
(
	-- Add the parameters for the function here
	@inp_iTransactionDetailsId BIGINT
)
RETURNS @tmpContraTrade TABLE (TransactionDetailsId BIGINT, IsContraTrade INT, ContraTradeQty DECIMAL(10,0))-- 0: Not contra trade, 1: Contra Trade
AS
BEGIN
	DECLARE @nIsContraTrade INT = 1
	DECLARE @nTradingPolicyId INT
	DECLARE @nTransactionModeId INT
	DECLARE @nNoOfDays INT
	DECLARE @dtDateOfAcq DATETIME
	DECLARE @dtDateToCheckForContraTrade DATETIME
	DECLARE @nUserInfoId INT
	DECLARE @dtSubmitDate DATETIME
	DECLARE @nTransactionMasterId BIGINT
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nSecurityTypeCodeId INT
	
	DECLARE @nMapToTypeDisclosureTransaction INT = 132005
	DECLARE @nMapToTypeTradingPolicyExceptionforTransactionMode INT = 132008
	
	DECLARE @nTransaction_SELL INT = 143002
	DECLARE @nTransaction_BUY INT = 143001
	
	DECLARE @nContinuousDisclosure INT  = 147002
	DECLARE @nPeriodEndDisclosure INT  = 147002
	
	DECLARE @nDisclosureStatusNotConfirmed INT= 148002
	
	DECLARE @nEventContinuousDisclosureDetailsEntered INT = 153019
	DECLARE @nEventPeriodEndDisclosureDetailsEntered INT = 153029
	
	DECLARE @nSecurityTypeCodeId_Share INT = 139001
	DECLARE @nEsopQty DECIMAL(10,0) = 0
	DECLARE @nOtherQty DECIMAL(10,0) = 0
	DECLARE @nESOP_Transactions INT = 0
	DECLARE @nOTHER_Transactions INT = 0
	DECLARE @nContraTradeQty DECIMAL(10,0) = 0
	
	DECLARE @nContraTradeOption INT
	DECLARE @nContraTradeWithoutQuantiy INT = 175001
	DECLARE @nContraTradeQuantiyBase INT = 175002
	
	DECLARE @nContraTradeBasedOn INT
	DECLARE @nContraTradeBasedOnAllSecurityType INT  = 177001
	DECLARE @nContraTradeBasedOnIndividualSecurityType INT  = 177002
	DECLARE @nTDSecurityTypeCodeID		INT	
	DECLARE @nTDModeOfAcquisitionCodeId	INT
	DECLARE @nContraTrade_No            INT = 506002
	DECLARE @bIsContraTradeSettings     BIT = 1
	DECLARE @nIndividualSecurityType    INT = 177002
	
	-- Declare the return variable here
	DECLARE @tmpOppositeTranasction TABLE (TransactionCodeId INT, OppositeTransactionCodeId INT)
	DECLARE @tmpExceptionTransactionCodes TABLE(TransactionCodeId INT)
	DECLARE @tmpContraTradeSecurityMode TABLE(SecurityCodeId INT)
	DECLARE @tempTransactionTypeSettings TABLE(TransactionType INT, ModeOfAcquisitionCodeId INT, SecurityTypeCodeId INT)
	
	INSERT INTO @tmpOppositeTranasction (TransactionCodeId, OppositeTransactionCodeId)
	SELECT * FROM tra_OppositeTranasctionCodes
	
	

	SELECT @nTradingPolicyId = TP.TradingPolicyId, @nTransactionModeId = TransactionTypeCodeId, 
		@nNoOfDays = GenContraTradeNotAllowedLimit, @dtDateOfAcq = DateOfAcquisition,
		@nUserInfoId = TM.UserInfoId,
		@nTransactionMasterId = TM.TransactionMasterId,
		@nDisclosureTypeCodeId = DisclosureTypeCodeId,
		@nEsopQty = ESOPExcerciseOptionQty,
		@nOtherQty = OtherExcerciseOptionQty,
		@nSecurityTypeCodeId = TD.SecurityTypeCodeId,
		@nContraTradeBasedOn = TP.ContraTradeBasedOn,
		@nTDSecurityTypeCodeID = TD.SecurityTypeCodeId,
		@nTDModeOfAcquisitionCodeId = TD.ModeOfAcquisitionCodeId
	FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
		JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
	WHERE TransactionDetailsId = @inp_iTransactionDetailsId
	
	INSERT INTO @tmpContraTradeSecurityMode (SecurityCodeId)
	SELECT SecurityTypeCodeID FROM rul_TradingPolicyForSecurityMode WHERE TradingPolicyId = @nTradingPolicyId
	
	INSERT INTO @tempTransactionTypeSettings
	SELECT DISTINCT TRANS_TYPE_CODE_ID, MODE_OF_ACQUIS_CODE_ID,SECURITY_TYPE_CODE_ID FROM tra_TransactionTypeSettings WHERE CONTRA_TRADE_CODE_ID = @nContraTrade_No AND security_type_code_id = CASE WHEN @nContraTradeBasedOn = @nIndividualSecurityType THEN @nTDSecurityTypeCodeID ELSE security_type_code_id END
	
	SELECT @bIsContraTradeSettings = [dbo].[uf_tra_CheckForContraTrade](@nTransactionModeId,@nTDModeOfAcquisitionCodeId,@nTDSecurityTypeCodeID)	
	
	IF(@bIsContraTradeSettings = 0)	
	BEGIN
		SELECT @dtSubmitDate = EventDate
		FROM eve_EventLog EL 
		WHERE EL.MapToId = @nTransactionMasterId AND EL.MapToTypeCodeId = @nMapToTypeDisclosureTransaction
					AND ((EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered AND @nDisclosureTypeCodeId = @nContinuousDisclosure)
						 OR (EL.EventCodeId = @nEventPeriodEndDisclosureDetailsEntered AND @nDisclosureTypeCodeId = @nPeriodEndDisclosure))

		SELECT @dtDateToCheckForContraTrade = DATEADD(D, -@nNoOfDays, @dtDateOfAcq)
		
		INSERT INTO @tmpExceptionTransactionCodes
		SELECT TransactionModeCodeId FROM rul_TradingPolicyForTransactionMode
		WHERE TradingPolicyId = @nTradingPolicyId
		AND MapToTypeCodeId = @nMapToTypeTradingPolicyExceptionforTransactionMode
		
		DELETE OppTra
		FROM @tmpOppositeTranasction OppTra JOIN @tmpExceptionTransactionCodes ExcTra 
		ON ExcTra.TransactionCodeId IN (OppTra.TransactionCodeId, OppTra.OppositeTransactionCodeId)

		DELETE FROM @tmpOppositeTranasction WHERE TransactionCodeId <> @nTransactionModeId

		SELECT @nContraTradeOption = ContraTradeOption FROM mst_Company WHERE IsImplementing = 1
		
		IF @nTransactionModeId <> @nTransaction_SELL OR @nSecurityTypeCodeId <> @nSecurityTypeCodeId_Share
		BEGIN
			IF NOT EXISTS(
				SELECT *
				FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
					JOIN eve_EventLog EL ON EL.MapToId = TM.TransactionMasterId AND EL.MapToTypeCodeId = @nMapToTypeDisclosureTransaction
						AND ((EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered AND DisclosureTypeCodeId = @nContinuousDisclosure)
							 OR (EL.EventCodeId = @nEventPeriodEndDisclosureDetailsEntered AND DisclosureTypeCodeId = @nPeriodEndDisclosure))
				WHERE TM.UserInfoId = @nUserInfoId
					AND DateOfAcquisition >= @dtDateToCheckForContraTrade 
					AND (DateOfAcquisition < @dtDateOfAcq OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate < @dtSubmitDate)
						OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate = @dtSubmitDate AND TransactionDetailsId < @inp_iTransactionDetailsId))
					AND TM.TransactionStatusCodeId > @nDisclosureStatusNotConfirmed
					AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType 
					AND TD.SecurityTypeCodeId IN(SELECT SecurityCodeId FROM @tmpContraTradeSecurityMode))
					OR (@nContraTradeBasedOn = @nContraTradeBasedOnIndividualSecurityType
					AND TD.SecurityTypeCodeId = @nTDSecurityTypeCodeID))					
					AND (NOT EXISTS(select 1 from @tempTransactionTypeSettings TTS where (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
			)
			BEGIN
				SELECT @nIsContraTrade = 0
			END
			ELSE
			BEGIN
				IF(@nContraTradeOption = @nContraTradeQuantiyBase)
				BEGIN
					SET @nContraTradeQty = @nEsopQty + @nOtherQty
				END
			END
		END
		ELSE
		BEGIN
		
			IF(@nContraTradeOption=@nContraTradeQuantiyBase)
			BEGIN
			IF @nEsopQty > 0
			BEGIN
					IF EXISTS(
						SELECT *
						FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
							JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
							JOIN eve_EventLog EL ON EL.MapToId = TM.TransactionMasterId AND EL.MapToTypeCodeId = @nMapToTypeDisclosureTransaction
								AND ((EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered AND DisclosureTypeCodeId = @nContinuousDisclosure)
									 OR (EL.EventCodeId = @nEventPeriodEndDisclosureDetailsEntered AND DisclosureTypeCodeId = @nPeriodEndDisclosure))
						WHERE TM.UserInfoId = @nUserInfoId
							AND DateOfAcquisition >= @dtDateToCheckForContraTrade 
							AND (DateOfAcquisition < @dtDateOfAcq OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate < @dtSubmitDate)
								OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate = @dtSubmitDate AND TransactionDetailsId < @inp_iTransactionDetailsId))
							AND TM.TransactionStatusCodeId > @nDisclosureStatusNotConfirmed
							AND TD.TransactionTypeCodeId <> @nTransaction_BUY
							AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType 
							AND TD.SecurityTypeCodeId IN(SELECT SecurityCodeId FROM @tmpContraTradeSecurityMode))
							OR (@nContraTradeBasedOn = @nContraTradeBasedOnIndividualSecurityType
							AND TD.SecurityTypeCodeId = @nTDSecurityTypeCodeID))
					        AND (NOT EXISTS(select 1 from @tempTransactionTypeSettings TTS where (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					)
					BEGIN
					
						SELECT @nESOP_Transactions = 1
						SET @nContraTradeQty = @nContraTradeQty + @nEsopQty
					END
				END
				IF @nOtherQty > 0
				BEGIN
					IF EXISTS(
						SELECT *
						FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
							JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
							JOIN eve_EventLog EL ON EL.MapToId = TM.TransactionMasterId AND EL.MapToTypeCodeId = @nMapToTypeDisclosureTransaction
								AND ((EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered AND DisclosureTypeCodeId = @nContinuousDisclosure)
									 OR (EL.EventCodeId = @nEventPeriodEndDisclosureDetailsEntered AND DisclosureTypeCodeId = @nPeriodEndDisclosure))
						WHERE TM.UserInfoId = @nUserInfoId
							AND DateOfAcquisition >= @dtDateToCheckForContraTrade 
							AND (DateOfAcquisition < @dtDateOfAcq OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate < @dtSubmitDate)
								OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate = @dtSubmitDate AND TransactionDetailsId < @inp_iTransactionDetailsId))
							AND TM.TransactionStatusCodeId > @nDisclosureStatusNotConfirmed
							AND TD.TransactionTypeCodeId = @nTransaction_BUY
							AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType 
							AND TD.SecurityTypeCodeId IN(SELECT SecurityCodeId FROM @tmpContraTradeSecurityMode))
							OR (@nContraTradeBasedOn = @nContraTradeBasedOnIndividualSecurityType
							AND TD.SecurityTypeCodeId = @nTDSecurityTypeCodeID))
					        AND (NOT EXISTS(select 1 from @tempTransactionTypeSettings TTS where (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					)
					BEGIN
						SELECT @nOTHER_Transactions = 1
						SET @nContraTradeQty = @nContraTradeQty + @nOtherQty
					END
				END
				
				IF @nESOP_Transactions = 0 AND @nOTHER_Transactions = 0
				BEGIN
					SET @nIsContraTrade = 0
				END
				ELSE
				BEGIN
					IF(@nContraTradeOption = @nContraTradeQuantiyBase)
					BEGIN
						--SET @nContraTradeQty = @nEsopQty + @nOtherQty
						IF @nESOP_Transactions = 0 AND @nOTHER_Transactions = 1
						BEGIN
							SET @nContraTradeQty = @nOtherQty
						END
						ELSE IF @nESOP_Transactions = 1 AND @nOTHER_Transactions = 0
						BEGIN
							SET @nContraTradeQty = @nEsopQty
						END
						ELSE IF @nESOP_Transactions = 1 AND @nOTHER_Transactions = 1
						BEGIN
							SET @nContraTradeQty = @nEsopQty + @nOtherQty
						END
					END
				END
		END
		ELSE IF(@nContraTradeOption=@nContraTradeWithoutQuantiy)
		BEGIN
		
			IF NOT EXISTS(
				SELECT *
				FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
					JOIN eve_EventLog EL ON EL.MapToId = TM.TransactionMasterId AND EL.MapToTypeCodeId = @nMapToTypeDisclosureTransaction
						AND ((EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered AND DisclosureTypeCodeId = @nContinuousDisclosure)
							 OR (EL.EventCodeId = @nEventPeriodEndDisclosureDetailsEntered AND DisclosureTypeCodeId = @nPeriodEndDisclosure))
				WHERE TM.UserInfoId = @nUserInfoId
					AND DateOfAcquisition >= @dtDateToCheckForContraTrade 
					AND (DateOfAcquisition < @dtDateOfAcq OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate < @dtSubmitDate)
						OR (DateOfAcquisition = @dtDateOfAcq AND EL.EventDate = @dtSubmitDate AND TransactionDetailsId < @inp_iTransactionDetailsId))
					AND TM.TransactionStatusCodeId > @nDisclosureStatusNotConfirmed
					AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType 
					AND TD.SecurityTypeCodeId IN(SELECT SecurityCodeId FROM @tmpContraTradeSecurityMode))
					OR (@nContraTradeBasedOn = @nContraTradeBasedOnIndividualSecurityType
					AND TD.SecurityTypeCodeId = @nTDSecurityTypeCodeID))
					AND (NOT EXISTS(select 1 from @tempTransactionTypeSettings TTS where (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
			)
			BEGIN
				SELECT @nIsContraTrade = 0
			END
		END
		END
		-- when contra trade flag is false then check on historic data for contra trade
		IF (@nIsContraTrade = 0)
		BEGIN
			IF EXISTS( SELECT * FROM tra_HistoricTransactionMaster HTM 
						JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId 
						JOIN @tmpOppositeTranasction expOpptra ON HTD.TransactionTypeCodeId = expOpptra.OppositeTransactionCodeId
						WHERE HTM.UserInfoId = @nUserInfoId AND DateOfAcquisition >= @dtDateToCheckForContraTrade 
						AND DateOfAcquisition < @dtDateOfAcq
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType 
						AND HTD.SecurityTypeCodeId IN(SELECT SecurityCodeId FROM @tmpContraTradeSecurityMode))
						OR (@nContraTradeBasedOn = @nContraTradeBasedOnIndividualSecurityType
						AND HTD.SecurityTypeCodeId = @nTDSecurityTypeCodeID)))
			BEGIN
				SELECT @nIsContraTrade = 1
				SET @nContraTradeQty = @nEsopQty + @nOtherQty
			END
		END
	END
	ELSE
	BEGIN
		SELECT @nIsContraTrade = 0
	END
	INSERT INTO @tmpContraTrade(TransactionDetailsId, IsContraTrade, ContraTradeQty)
	VALUES(@inp_iTransactionDetailsId, @nIsContraTrade, @nContraTradeQty)
	
	RETURN
END
GO

