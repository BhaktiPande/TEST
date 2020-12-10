IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionCheckForContraTrade')
DROP PROCEDURE [dbo].[st_tra_TransactionCheckForContraTrade]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Check wheather contra trade is present or not

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		17-Jul-2015

Modification History:
Modified By		Modified On		Description
Tushar			20-Jul-2015		Period End Transaction include
Tushar			21-Jul-2015		Period End Transaction include
Tushar			21-Jul-2015		Check Contra Trade case for If Preclearnace is Taken and not enetered trade details also incluede
								Preclearance for check contra trade case.
Tushar			14-Aug-2015		Change for Not Tarded Case		
Tushar			10-Dec-2015		Contra Trade check for Sell Transaction Type check ESOP and other Qty.
Tushar			11-Dec-2015		remove manual set value 
Tushar			11-Dec-2015		If Transaction Type Sell and security type shares then contra trade check on the basis of quantity.
								AND Transaction Type Sell and security type not shares then only check opposite transaction as old behaviour.
Parag			15-Dec-2015		Made change to fix issue where contra trade flag is not return properly
Parag			21-Dec-2015		Made change to check contra trade on historic data
Parag			29-Dec-2015		Made change to fix issue of unable to take preclearance for sell for security type other than share (user id check is missing)
								Add condition to exclude rejected preclearance for contra trade 
Tushar			15-Jan-2016		Add condition for considering PNT records for contra trade check
Tushar			11-Feb-2016		Past histroic condition change consider histroic pnt records.			
Tushar			15-Feb-2016		For Sell Transaction Type ignore excemted transactios.					
Tushar			09-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Tushar			07-Apr-2016		Change Contra trade (applicable for single or different security types)
Tushar			28-Apr-2016		Change Pre clearance request message for contra trade.show Date and transaction type till in message.
Tushar			03-May-2016		Bugs fix for sell transacton type.
								Mantix Bugs is - 8884 - A previous pre-Clearance for 'Sell' transaction is present. Now, I am taking another 
								Pre-Clearance for 'Sell' transaction. Currently, there are no shares present to sell.
Parag			18-Aug-2016		Code merge with ESOP code
Tushar			06-Sep-2016		Change for maintaining DMAT wise pool and related validation.

Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_tra_TransactionCheckForContraTrade 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionCheckForContraTrade]
	@inp_iUserInfoID									INT,						-- Id of the PreclearanceRequest whose details are to be fetched.
	@inp_iTransactionTypeCodeID							INT,						--Transaction Type
	@inp_iSecurityTypeCodeId							INT,						
	@inp_dSecuritiesToBeTradedQty						DECIMAL(15,4),
	@inp_bESOPExcerciseOptionQtyFlag					BIT,
	@inp_bOtherESOPExcerciseOptionQtyFlag				BIT,
	@inp_iModeOfAcquisitionCodeId                       INT,
	@inp_iDMATDetailsID									INT,
	@out_bIsContraTrade									BIT = 0 OUTPUT,
	@out_dtIsContraTradeTillDate					    DATETIME OUTPUT,
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	--Declare Variable
	DECLARE @ERR_TRANSACTIONCHECKFORCONTRATRADE			INT = 17342
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL				INT
	DECLARE @bIsContraTrade								BIT = 1
	DECLARE @nContinuousDisclosureType					INT = 147002
	DECLARE @nPeriodEndDisclosureType					INT = 147003
	DECLARE @nBuyTransactionType						INT = 143001
	DECLARE @nSellTransactionType						INT = 143002
	DECLARE @nCashExciseTransactionType					INT = 143003
	DECLARE @nCashlessAllTransactionType				INT = 143004
	DECLARE @nCashlessPartialTransactionType			INT = 143005
	DECLARE @nPledgeTransactionType                     INT = 143006
	DECLARE @nPledgeRevokeTransactionType               INT = 143007
	DECLARE @nPledgeInvokeTransactionType               INT = 143008	
	
	DECLARE @nTradingPolicyID							INT = 0
	DECLARE @nGenContraTradeNotAllowedLimit				INT	= 0
	
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT
	DECLARE @nESOPFirstOptionThenOther								INT = 172001
	DECLARE @nOtherFirstThenESOP									INT = 172002
	DECLARE @nUserSelectionRule										INT = 172003
	
	DECLARE @nESOPPoolQty												DECIMAL(10, 0)
	DECLARE @nOtherPoolQty												DECIMAL(10, 0)
	
	DECLARE @nESOSplitPQty											DECIMAL(10, 0) = 0
	DECLARE @nOtherSplitQty											DECIMAL(10, 0) = 0
	
	DECLARE @bESOPExcerseOptionQtyFlag		BIT
	DECLARE @bOtherESOPExcerseOptionFlag	BIT
	
	SET @ERR_UPDATEEXCERCISEBALANCEPOOL		= 16327
	
	DECLARE @nPreClearanceStatus_Rejected	INT = 144003
	DECLARE @nPreClearanceStatus_Approve	INT = 144002
	
	
	DECLARE @nContraTradeOption				INT
	DECLARE @nContraTradeGeneralOption		INT = 175001
	DECLARE @nContraTradeQuantityBase		INT = 175002
	
	DECLARE @nContraTradeBasedOn INT
	DECLARE @nContraTradeBasedOnAllSecurityType		INT = 177001
	DECLARE @nContraTradeBasedOnIndivisualSecurityType		INT = 177002
	
	DECLARE @nMapToTypeTradingPolicyExceptionforTransactionMode INT = 132008
	DECLARE @nMapToTypeContraTradeBasedOn INT						= 132013
	
	DECLARE @dtContraTradeTransactionDetailsID BIGINT
	DECLARE @dtContraTradeTillDate DATETIME
	
	DECLARE @nContraTrade_No         INT = 506002
	DECLARE @bIsContraTradeSettings  BIT = 1
	DECLARE @nIndividualSecurityType INT = 177002
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Create Temp Table for Fetching applicable Transaction Type for That policy which ar exempted for disclosure
		CREATE TABLE #temp(TransactionType INT)
		CREATE TABLE #tempContraTradeSecurityType(SecurityTypeCodeID INT)
		CREATE TABLE #tempTransactionTypeSettings(TransactionType INT, ModeOfAcquisitionCodeId INT, SecurityTypeCodeId INT)
		--Get Applicible Trading policy for that user
		SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0)
		FROM vw_ApplicableTradingPolicyForUser  WHERE UserInfoId = @inp_iUserInfoID
		
		-- Set Value For Contra Trade Not Allowed Limit
		SELECT @nGenContraTradeNotAllowedLimit = GenContraTradeNotAllowedLimit 
			   ,@nGenCashAndCashlessPartialExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade
			   ,@nContraTradeBasedOn = ContraTradeBasedOn 
		FROM rul_TradingPolicy 
		WHERE TradingPolicyId = @nTradingPolicyID
	
		--Insert Exempted Transaction In Temp Table
		INSERT INTO #temp 
		SELECT TransactionModeCodeId 
		FROM rul_TradingPolicyForTransactionMode 
		WHERE TradingPolicyId = @nTradingPolicyID AND MapToTypeCodeId = @nMapToTypeTradingPolicyExceptionforTransactionMode
		
		-- Insert contra Trade security
		INSERT INTO #tempContraTradeSecurityType
		SELECT SecurityTypeCodeID 
		FROM rul_TradingPolicyForSecurityMode 
		WHERE TradingPolicyId = @nTradingPolicyID AND MapToTypeCodeId = @nMapToTypeContraTradeBasedOn
		
		INSERT INTO #tempTransactionTypeSettings
		SELECT DISTINCT TRANS_TYPE_CODE_ID, MODE_OF_ACQUIS_CODE_ID, SECURITY_TYPE_CODE_ID FROM tra_TransactionTypeSettings WHERE CONTRA_TRADE_CODE_ID = @nContraTrade_No AND security_type_code_id = CASE WHEN @nContraTradeBasedOn = @nIndividualSecurityType THEN @inp_iSecurityTypeCodeId ELSE security_type_code_id END
		
			-- Declare the return variable here
		DECLARE @tmpOppositeTranasction TABLE (TransactionCodeId INT, OppositeTransactionCodeId INT)
		DECLARE @tmpExceptionTransactionCodes TABLE(TransactionCodeId INT)
		
		INSERT INTO @tmpOppositeTranasction (TransactionCodeId, OppositeTransactionCodeId)
		SELECT * FROM tra_OppositeTranasctionCodes
		
		
		DELETE OppTra
		FROM @tmpOppositeTranasction OppTra JOIN #temp ExcTra 
		ON ExcTra.TransactionType IN (OppTra.TransactionCodeId, OppTra.OppositeTransactionCodeId)

		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption
		FROM mst_Company WHERE IsImplementing = 1
		
		--Check Wheathe rtransaction type in exempt case then allow trade else check wheathe condition for contra trade 
	    SELECT @bIsContraTradeSettings = [dbo].[uf_tra_CheckForContraTrade](@inp_iTransactionTypeCodeID,@inp_iModeOfAcquisitionCodeId,@inp_iSecurityTypeCodeId)
	    
		IF((@bIsContraTradeSettings = 1) OR NOT EXISTS(SELECT SecurityTypeCodeID FROM #tempContraTradeSecurityType WHERE SecurityTypeCodeID = @inp_iSecurityTypeCodeId))
		BEGIN
			SET @bIsContraTrade = 0
		END
		ELSE IF(@inp_iTransactionTypeCodeID <> @nCashlessAllTransactionType AND 
				@inp_iTransactionTypeCodeID <> @nCashlessPartialTransactionType)
		BEGIN
			/*
				If Transaction Type Buy
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Cash Excise, Buy, Pledge OR Pledge Revoke,
				5. Not Traded Ignore
			*/
			IF (@inp_iTransactionTypeCodeID = @nBuyTransactionType)
			BEGIN
			
				SELECT TOP 1  @dtContraTradeTransactionDetailsID =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster TM 
				LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 					 
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						    ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @bIsContraTrade = 1
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				
				-- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				IF (@bIsContraTrade = 0)
				BEGIN
					-- check if there is transaction details available for user in historic data for contra trade period
					
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN HTD.TransactionDetailsId IS NOT NULL THEN HTD.TransactionDetailsId ELSE HPR.PreclearanceRequestId END
						,@dtContraTradeTillDate =  CASE WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition ELSE HPR.DateApplyingForPreClearance END
					    FROM tra_HistoricTransactionMaster HTM 
						LEFT JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId
						LEFT JOIN tra_HistoricPreclearanceRequest HPR ON HTM.PreclearanceRequestId = HPR.PreclearanceRequestId
						WHERE HTM.UserInfoId = @inp_iUserInfoID 
						AND ( ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HPR.DateApplyingForPreClearance)) <= @nGenContraTradeNotAllowedLimit
							OR ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HTD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit)
						AND (HPR.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp)
							OR HTD.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp))
						AND (HPR.TransactionTypeCodeId NOT IN (@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)
							OR HTD.TransactionTypeCodeId NOT IN (@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType))
						--AND (HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND HTD.TransactionDetailsId IS NOT NULL) -- condition check only preclearance has data
						--AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected
						AND (( HPR.PreclearanceRequestId IS NOT NULL AND HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve 
								AND HTD.TransactionDetailsId IS NOT NULL AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR (HPR.PreclearanceRequestId IS NULL AND HTD.TransactionDetailsId IS NOT NULL))
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((HPR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (HTD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((HPR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR HTD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE 
									WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition 
									ELSE HPR.DateApplyingForPreClearance 
								END DESC
					
					IF (@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
					BEGIN
						SET @bIsContraTrade = 1
						SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					END
				END
			END
			/*
				If Transaction Type Sell
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Sell,Pledge, Pledge Revoke Or Pledge Invoke
				5. Not Traded Ignore
			*/
			ELSE IF(@inp_iTransactionTypeCodeID = @nSellTransactionType OR @inp_iTransactionTypeCodeID = @nPledgeInvokeTransactionType)
			BEGIN
				IF(@nContraTradeOption = @nContraTradeQuantityBase)
				BEGIN
					IF(@inp_iSecurityTypeCodeId = 139001)
					BEGIN
						 SELECT @nESOPPoolQty = ESOPQuantity,
								@nOtherPoolQty=OtherQuantity 
						 FROM tra_ExerciseBalancePool 
						 WHERE UserInfoId = @inp_iUserInfoID AND SecurityTypeCodeId = 139001 AND DMATDetailsID = @inp_iDMATDetailsID
					 
						 IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nESOPFirstOptionThenOther)
						 BEGIN
							IF(@inp_dSecuritiesToBeTradedQty <= @nESOPPoolQty)
									BEGIN
										SET @nESOSplitPQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @nESOSplitPQty = @nESOPPoolQty
										IF(@nOtherPoolQty>=@inp_dSecuritiesToBeTradedQty-@nESOSplitPQty)
										BEGIN
											SET @nOtherSplitQty = @inp_dSecuritiesToBeTradedQty-@nESOSplitPQty
										END
										ELSE
										BEGIN
											SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
											RETURN @out_nReturnValue
										END
								END
						 END
						 ELSE IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nOtherFirstThenESOP)
						 BEGIN
							IF(@inp_dSecuritiesToBeTradedQty <= @nOtherPoolQty)
									BEGIN
										SET @nOtherSplitQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @nOtherSplitQty = @nOtherPoolQty
										IF(@nESOPPoolQty>=@inp_dSecuritiesToBeTradedQty-@nOtherPoolQty)
										BEGIN
											SET @nESOSplitPQty = @inp_dSecuritiesToBeTradedQty-@nOtherPoolQty
										END
										ELSE
										BEGIN
											SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
											RETURN @out_nReturnValue
										END
								END
								
						 END	 
						 ELSE IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nUserSelectionRule)
						 BEGIN
							IF(@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
								BEGIN
									IF(@inp_dSecuritiesToBeTradedQty <= @nESOPPoolQty)
									BEGIN
										SET @nESOSplitPQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @nESOSplitPQty = @nESOPPoolQty
										IF(@nOtherPoolQty>=@inp_dSecuritiesToBeTradedQty-@nESOSplitPQty)
										BEGIN
											SET @nOtherSplitQty = @inp_dSecuritiesToBeTradedQty-@nESOSplitPQty
										END
										ELSE
										BEGIN
											SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
											RETURN @out_nReturnValue
										END
									END
								END
								ELSE IF(@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0)
								BEGIN
									IF(@inp_dSecuritiesToBeTradedQty <= @nESOPPoolQty)
									BEGIN
										SET @nESOSplitPQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
										RETURN @out_nReturnValue
									END
								END
								ELSE IF(@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
								BEGIN
									IF(@inp_dSecuritiesToBeTradedQty <= @nOtherPoolQty)
									BEGIN
										SET @nOtherSplitQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
										RETURN @out_nReturnValue
									END
								END
						 END
						 
						 IF(@nESOSplitPQty>0)
						 BEGIN
							SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
							,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
							FROM tra_TransactionMaster TM 
							LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
							LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
							LEFT JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
							LEFT JOIN @tmpOppositeTranasction expOppTra1 ON PR.TransactionTypeCodeId = expOppTra1.OppositeTransactionCodeId
							WHERE TM.UserInfoId = @inp_iUserInfoID
								  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
								  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn))<= @nGenContraTradeNotAllowedLimit) 
										OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit) ) 
								  AND ((PR.TransactionTypeCodeId NOT IN(@nBuyTransactionType)) 
										OR (TD.TransactionTypeCodeId NOT IN(@nBuyTransactionType)))								 
								  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
								  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
										OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
								  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
										OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
							      AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
										OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
										OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
										AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
							ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
							IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
							BEGIN
								SET @bIsContraTrade = 1
								SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
							END
							ELSE
							BEGIN
								SET @bIsContraTrade = 0
							END
						 END
						 
						 
						 IF(@nOtherSplitQty>0)
						 BEGIN
							SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
							,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
								FROM tra_TransactionMaster TM 
								LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
								LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
								LEFT JOIN @tmpOppositeTranasction expOppTra ON TD.TransactionTypeCodeId = expOppTra.OppositeTransactionCodeId
								LEFT JOIN @tmpOppositeTranasction expOppTra1 ON PR.TransactionTypeCodeId = expOppTra1.OppositeTransactionCodeId
								WHERE TM.UserInfoId = @inp_iUserInfoID
									  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
									  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn))<= @nGenContraTradeNotAllowedLimit) 
											OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit) ) 
									  AND ((PR.TransactionTypeCodeId IN(@nBuyTransactionType)) 
											OR (TD.TransactionTypeCodeId IN(@nBuyTransactionType)))									
									  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
									  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
											OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
									 AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
											OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
									AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
											OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
											OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
											AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
								ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
							 IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
								BEGIN
									SET @bIsContraTrade = 1
									SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
								END
								ELSE
								BEGIN
									SET @bIsContraTrade = 0
								END
							END
					 END	
					ELSE 
					BEGIN
						
						SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
						,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
										FROM tra_TransactionMaster TM 
										LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
										LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
							  WHERE TM.UserInfoId = @inp_iUserInfoID  
							  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
							  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn))<= @nGenContraTradeNotAllowedLimit) 
									OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit) )							  
							  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
							  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
									OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
							  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
								   OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
							 AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
									OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
									OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
									AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
						
						IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
						BEGIN
							SET @bIsContraTrade = 1
							SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
						END
						ELSE
						BEGIN
							SET @bIsContraTrade = 0
						END
					END
				 -- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				END
				ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
				BEGIN
				 print 'i m here'
				SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster TM 
				LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 				
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
				ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				--select @dtContraTradeTransactionDetailsID,@nGenContraTradeNotAllowedLimit
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					SET @bIsContraTrade = 1
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				END
				
				IF (@bIsContraTrade = 0)
				BEGIN
					-- check if there is transaction details available for user in historic data for contra trade period
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN HTD.TransactionDetailsId IS NOT NULL THEN HTD.TransactionDetailsId ELSE HPR.PreclearanceRequestId END
								,@dtContraTradeTillDate =  CASE WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition ELSE HPR.DateApplyingForPreClearance END 
					FROM tra_HistoricTransactionMaster HTM 
						LEFT JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId
						LEFT JOIN tra_HistoricPreclearanceRequest HPR ON HTM.PreclearanceRequestId = HPR.PreclearanceRequestId
						WHERE HTM.UserInfoId = @inp_iUserInfoID 
						AND ( ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HPR.DateApplyingForPreClearance)) <= @nGenContraTradeNotAllowedLimit
							OR ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HTD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit)
						AND (HPR.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp)
							OR HTD.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp))
						AND (HPR.TransactionTypeCodeId NOT IN (@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)
							OR HTD.TransactionTypeCodeId NOT IN (@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType))
						--AND (HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND HTD.TransactionDetailsId IS NOT NULL) -- condition check only preclearance has data
						--AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected
						AND (( HPR.PreclearanceRequestId IS NOT NULL AND HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve 
								AND HTD.TransactionDetailsId IS NOT NULL AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR (HPR.PreclearanceRequestId IS NULL AND HTD.TransactionDetailsId IS NOT NULL))
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((HPR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (HTD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((HPR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR HTD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE 
									WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition 
									ELSE HPR.DateApplyingForPreClearance 
								END DESC
					IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
					BEGIN
						SET @bIsContraTrade = 1
						SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					END
				END
				
			END	
			/*
				If Transaction Type Cash Excise
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Cash Excise, Buy, Pledge Or Pledge Revoke
				5. Not Traded Ignore
			*/
			ELSE IF(@inp_iTransactionTypeCodeID = @nCashExciseTransactionType)
			BEGIN
				SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster TM 
				LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit))  					 
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
				ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @bIsContraTrade = 1
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				
				-- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				IF (@bIsContraTrade = 0)
				BEGIN
					-- check if there is transaction details available for user in historic data for contra trade period
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN HTD.TransactionDetailsId IS NOT NULL THEN HTD.TransactionDetailsId ELSE HPR.PreclearanceRequestId END
					,@dtContraTradeTillDate =  CASE WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition ELSE HPR.DateApplyingForPreClearance END
					FROM tra_HistoricTransactionMaster HTM 
						LEFT JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId
						LEFT JOIN tra_HistoricPreclearanceRequest HPR ON HTM.PreclearanceRequestId = HPR.PreclearanceRequestId
						WHERE HTM.UserInfoId = @inp_iUserInfoID 
						AND ( ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HPR.DateApplyingForPreClearance)) <= @nGenContraTradeNotAllowedLimit
							OR ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HTD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit)
						AND (HPR.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp)
							OR HTD.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp))
						AND (HPR.TransactionTypeCodeId NOT IN (@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)
							OR HTD.TransactionTypeCodeId NOT IN (@nCashExciseTransactionType,@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType))
						--AND (HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND HTD.TransactionDetailsId IS NOT NULL) -- condition check only preclearance has data
						--AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected
						AND (( HPR.PreclearanceRequestId IS NOT NULL AND HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve 
								AND HTD.TransactionDetailsId IS NOT NULL AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR (HPR.PreclearanceRequestId IS NULL AND HTD.TransactionDetailsId IS NOT NULL))
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((HPR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (HTD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((HPR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR HTD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE 
									WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition 
									ELSE HPR.DateApplyingForPreClearance 
								END DESC
					IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
					BEGIN
						SET @bIsContraTrade = 1
						SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					END
				END
			END
			
			/*
				If Transaction Type Pledge
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Pledge,Pledge Invoke, Buy, Sell, CashExcise, CashlessAll Or CashlessPartial
				5. Not Traded Ignore
			*/
			ELSE IF (@inp_iTransactionTypeCodeID = @nPledgeTransactionType)
			BEGIN
			
				SELECT TOP 1  @dtContraTradeTransactionDetailsID =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster TM 
				LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 					
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nPledgeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nPledgeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						    ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @bIsContraTrade = 1
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				
				-- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				IF (@bIsContraTrade = 0)
				BEGIN
					-- check if there is transaction details available for user in historic data for contra trade period
					
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN HTD.TransactionDetailsId IS NOT NULL THEN HTD.TransactionDetailsId ELSE HPR.PreclearanceRequestId END
						,@dtContraTradeTillDate =  CASE WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition ELSE HPR.DateApplyingForPreClearance END
					    FROM tra_HistoricTransactionMaster HTM 
						LEFT JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId
						LEFT JOIN tra_HistoricPreclearanceRequest HPR ON HTM.PreclearanceRequestId = HPR.PreclearanceRequestId
						WHERE HTM.UserInfoId = @inp_iUserInfoID 
						AND ( ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HPR.DateApplyingForPreClearance)) <= @nGenContraTradeNotAllowedLimit
							OR ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HTD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit)
						AND (HPR.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp)
							OR HTD.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp))
						AND (HPR.TransactionTypeCodeId NOT IN (@nPledgeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)
							OR HTD.TransactionTypeCodeId NOT IN (@nPledgeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType))
						--AND (HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND HTD.TransactionDetailsId IS NOT NULL) -- condition check only preclearance has data
						--AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected
						AND (( HPR.PreclearanceRequestId IS NOT NULL AND HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve 
								AND HTD.TransactionDetailsId IS NOT NULL AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR (HPR.PreclearanceRequestId IS NULL AND HTD.TransactionDetailsId IS NOT NULL))
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((HPR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (HTD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((HPR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR HTD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE 
									WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition 
									ELSE HPR.DateApplyingForPreClearance 
								END DESC
					
					IF (@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
					BEGIN
						SET @bIsContraTrade = 1
						SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					END
				END
			END
			
			
			/*
				If Transaction Type Pledge Revoke
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Pledge Revoke,Pledge Invoke, Buy, Sell, CashExcise, CashlessAll Or CashlessPartial
				5. Not Traded Ignore
			*/
			ELSE IF (@inp_iTransactionTypeCodeID = @nPledgeRevokeTransactionType)
			BEGIN
			
				SELECT TOP 1  @dtContraTradeTransactionDetailsID =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster TM 
				LEFT JOIN tra_TransactionDetails TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 					
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						    ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @bIsContraTrade = 1
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				
				-- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				IF (@bIsContraTrade = 0)
				BEGIN
					-- check if there is transaction details available for user in historic data for contra trade period
					
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN HTD.TransactionDetailsId IS NOT NULL THEN HTD.TransactionDetailsId ELSE HPR.PreclearanceRequestId END
						,@dtContraTradeTillDate =  CASE WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition ELSE HPR.DateApplyingForPreClearance END
					    FROM tra_HistoricTransactionMaster HTM 
						LEFT JOIN tra_HistoricTransactionDetails HTD ON HTM.TransactionMasterId = HTD.TransactionMasterId
						LEFT JOIN tra_HistoricPreclearanceRequest HPR ON HTM.PreclearanceRequestId = HPR.PreclearanceRequestId
						WHERE HTM.UserInfoId = @inp_iUserInfoID 
						AND ( ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HPR.DateApplyingForPreClearance)) <= @nGenContraTradeNotAllowedLimit
							OR ABS(DATEDIFF(DAY, dbo.uf_com_GetServerDate(), HTD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit)
						AND (HPR.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp)
							OR HTD.TransactionTypeCodeId NOT IN (SELECT TransactionType FROM #temp))
						AND (HPR.TransactionTypeCodeId NOT IN (@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType)
							OR HTD.TransactionTypeCodeId NOT IN (@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType,@nBuyTransactionType,@nSellTransactionType,@nCashExciseTransactionType,@nCashlessAllTransactionType,@nCashlessPartialTransactionType))
						--AND (HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND HTD.TransactionDetailsId IS NOT NULL) -- condition check only preclearance has data
						--AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected
						AND (( HPR.PreclearanceRequestId IS NOT NULL AND HPR.PreclearanceStatusCodeId = @nPreClearanceStatus_Approve 
								AND HTD.TransactionDetailsId IS NOT NULL AND HPR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR (HPR.PreclearanceRequestId IS NULL AND HTD.TransactionDetailsId IS NOT NULL))
						AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((HPR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (HTD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((HPR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR HTD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE 
									WHEN HTD.DateOfAcquisition IS NOT NULL THEN HTD.DateOfAcquisition 
									ELSE HPR.DateApplyingForPreClearance 
								END DESC
					
					IF (@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
					BEGIN
						SET @bIsContraTrade = 1
						SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					END
				END
			END
			
		END
		--SET @bIsContraTrade = 0
		--Set Contra Trade Value
		SELECT @out_bIsContraTrade = @bIsContraTrade
		
		SET @out_nReturnValue = 0
		SELECT @out_dtIsContraTradeTillDate
		RETURN @out_nReturnValue
		
		-- Drop Temp Table.
		DROP TABLE #temp
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONCHECKFORCONTRATRADE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
		
	END CATCH
END

