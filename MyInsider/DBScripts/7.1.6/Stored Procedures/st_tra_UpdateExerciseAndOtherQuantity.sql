IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateExerciseAndOtherQuantity')
DROP PROCEDURE [dbo].[st_tra_UpdateExerciseAndOtherQuantity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for Update ESOPExcerciseOptionQty & OtherExcerciseOptionQty column
				while submitting transaction. and while sell type transaction check then check available qty 
				exists in balance poll

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		24-Nov-2015
Modification History:
Modified By		Modified On		Description
Tushar			03-Dec-2015		Change condition for Preclearance.
Tushar			03-Dec-2015		Change condition Transaction status.
Tushar			08-Dec-2015		Datatype change for INT to decimal for @inp_dESOPExcerciseOptionQty & @inp_dOtherExcerciseOptionQty
Tushar			09-Dec-2015		Other secuirty type case occur then update quantity in Other Quantity table.
Tushar			10-Dec-2015		Preclearance id fetch from table.
Parag			19-Dec-2015		Properly indended code,
								Fix issue for trading poliyc option 2 - user quantity from other pool first then esop pool -  
									on sell transaction other pool quantity become "0", when sell the less than pool quantity
								Fix issue of esop/other quantity NOT updated in transcation details table 
									becasue of this exercise pool not updated This happen only in case of 
									if user has NOT made initial disclosure/Preclearance and enter PNT transaction
Tushar			09-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Parag			13-Mar-2016		Fix issue of "Insufficient quantity" message shown when after initial disclosure, preclearance of sell is taken for 
									all quantity and trade details is submitted for same quantity
Tushar			21-Apr-2016		Non negative balance validation for contra trade option- without quantity base.		
Tushar			12-May-2016		Mantis bug 8791: Issue in Dashboard count of Holding - Negative count appearing 
							    bugs fix for Non negative balance validation for contra trade option- without quantity base.
Tushar			14-Jun-2016		Changes for applying pool based validations for security types other than shares 		
Tushar			13-Jul-2016		Mantis Bug fix 9164 :- System is allowing me to sell any security type when there is no balance in their respective pool 
								to sell & as a result, showing negative quantity on user dashboard.This issue is occurring when Admin submits 
								the continuous disclosures details via mass upload.	
Tushar			05-Aug-2016		Allow negative balance for configure security type in SecurityConfiguration Table	
Parag			18-Aug-2016		Code merge with ESOP code
Tushar			06-Sep-2016		Change for maintaining DMAT wise pool and related validation.

		
Usage:
DECLARE	@return_value int,
		@out_nReturnValue int,
		@out_nSQLErrCode int,
		@out_sSQLErrMessage nvarchar(500)

EXEC	@return_value = [dbo].[st_tra_UpdateExerciseAndOtherQuantity]
		@inp_iTransactionMasterID = 786,
		@out_nReturnValue = @out_nReturnValue OUTPUT,
		@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
		@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT

SELECT	@out_nReturnValue as N'@out_nReturnValue',
		@out_nSQLErrCode as N'@out_nSQLErrCode',
		@out_sSQLErrMessage as N'@out_sSQLErrMessage'

SELECT	'Return Value' = @return_value
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_UpdateExerciseAndOtherQuantity] 
	@inp_iTransactionMasterID					BIGINT,
	@inp_sPreclearanceRequestId					BIGINT = NULL,
	@inp_iDisclosureTypeCodeId					INT,
	@inp_iTransactionStatusCodeId				INT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	--Declare Variable
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL							INT
	DECLARE @ERR_NEGATIVEERRORMESSAGE								INT
	DECLARE @nUserInfoID											INT
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT
	DECLARE @TrasnactionDetailsID									INT
	DECLARE @Quantity												DECIMAL(10, 0)
	DECLARE @nESOPQty												DECIMAL(10, 0)
	DECLARE @nOtherQty												DECIMAL(10, 0)
	DECLARE @nTempQty												DECIMAL(10, 0) = 0
	DECLARE @nTempQty1												DECIMAL(10, 0) = 0
	DECLARE @ESOPQtyFlg												BIT
	DECLARE @OTHERQtyFlg											BIT
	
	DECLARE @nBuyTransctionType										INT = 143001
	DECLARE @nSellTransctionType									INT = 143002
	DECLARE @nCashExcerciseTransctionType							INT = 143003
	DECLARE @nCashlessAllTransctionType								INT = 143004
	DECLARE @nCashlessPartialTransctionType							INT = 143005
	DECLARE @nPledgeTransctionType                                  INT = 143006
	DECLARE @nPledgeRevokeTransctionType                            INT = 143007
	DECLARE @nPledgeInvokeTransctionType                            INT = 143008
	
	DECLARE @nShareSecurityType										INT = 139001
	DECLARE @nWarrantsSecurityType									INT = 139002
	DECLARE @nConvertibleDebenturesType								INT = 139003
	DECLARE @nFutureContractsSecurityType							INT = 139004
	DECLARE @nOptionContractsSecurityType							INT = 139005
	
	DECLARE @nTransStatus_Confirmed									INT = 148007
	
	DECLARE @nESOPFirstOptionThenOther								INT = 172001
	DECLARE @nOtherFirstThenESOP									INT = 172002
	DECLARE @nUserSelectionRule										INT = 172003
	
	SET @ERR_UPDATEEXCERCISEBALANCEPOOL		= 16327
	SET @ERR_NEGATIVEERRORMESSAGE		= 16430
	
	DECLARE @nESOPSUMQty					DECIMAL(10, 0)
	DECLARE @nOtherSumQty					DECIMAL(10, 0)
	DECLARE @nBuyTransactionTotalQuanity							DECIMAL(10, 0)
	DECLARE @nESOPTransactionTotalQuanity							DECIMAL(10, 0)
	DECLARE @nESOPTransactionPartialTotalQuanity					DECIMAL(10, 0)
	
	DECLARE @nSumDetailsQuantity	DECIMAL(10, 0) 
	DECLARE @nPCLQuantity			DECIMAL(10, 0) 
	DECLARE @nOverTradedDifferenceQty	DECIMAL(10, 0)
	
	DECLARE @bESOPExcerseOptionQtyFlag BIT
	DECLARE @bOtherESOPExcerseOptionFlag BIT
	
	DECLARE @nContraTradeOption INT
	DECLARE @nContraTradeWithoutQuantiy INT = 175001
	DECLARE @nContraTradeQuantiyBase INT = 175002
	
	DECLARE @nPCLESOPExerciseOptionQuantity							DECIMAL(10, 0) = 0
	DECLARE @nPCLOtherExerciseOptionQuantity						DECIMAL(10, 0) = 0
	DECLARE @nPreClearanceTrasactionType	INT
	DECLARE @nSecurityTypeCodeID	INT
	DECLARE @nPreClearanceModeOfAcquisition INT
	DECLARE @nPreClearanceSecurityTypeCodeId INT
	
	--Impact on Post Share quantity  
	DECLARE @nAdd  INT = 505001
	DECLARE @nLess INT = 505002
	DECLARE @nBoth INT = 505003
	
	DECLARE @nSellTransactionPartialTotalQuanity	DECIMAL(10, 0)

	DECLARE @bIsAllowNegativeBalance BIT
	DECLARE @nTmpRet INT
	
	DECLARE @nPCLDMATDetailsID INT
	DECLARE @TDDMATDEtailsID INT
	DECLARE @nTDSecurityTypeCodeID INT
	DECLARE @nPreclearanceQuantity INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		--Curosr Start
				
				
	IF (@inp_iTransactionMasterId <> 0 AND @inp_iTransactionStatusCodeId = @nTransStatus_Confirmed AND @inp_iDisclosureTypeCodeId <> 147001)
	BEGIN	
		
		DECLARE @GetTrasnactionDetailsID CURSOR 
		
		SELECT @nContraTradeOption = ContraTradeOption FROM mst_Company WHERE IsImplementing = 1
		
		
		PRINT 'Contra Trade Option' + CONVERT(VARCHAR(MAX),@nContraTradeOption)
		
		DECLARE @Results TABLE
				(
					Esopsum int,
					othersum int
				)
				
		SELECT @nUserInfoID = UserInfoID FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterID
			
		SELECT @inp_sPreclearanceRequestId = PreclearanceRequestId  FROM tra_TransactionMaster 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		IF @inp_sPreclearanceRequestId IS  NOT NULL OR @inp_sPreclearanceRequestId <> 0
		BEGIN
			SELECT @nSecurityTypeCodeID =  SecurityTypeCodeId,
			@nPCLDMATDetailsID = DMATDetailsID 
			FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
		END
		ELSE
		BEGIN
			SELECT TOP 1 @nSecurityTypeCodeID = SecurityTypeCodeId 
			FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId
		END
		
		--Check this secuirty type allow negative balance flag
		--SET @bIsAllowNegativeBalance =  dbo.uf_tra_IsAllowNegativeBalanceForSecurity(@nSecurityTypeCodeID)
		
		--check is allow negative balance for that secuirty type
			EXEC @nTmpRet = st_tra_IsAllowNegativeBalanceForSecurity @nSecurityTypeCodeID,@bIsAllowNegativeBalance OUTPUT,
							@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
			IF @out_nReturnValue <> 0
			BEGIN
				SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
				RETURN @out_nReturnValue
			END
		
		
		--IF EXISTS(SELECT ISNULL(ESOPQuantity,0),ISNULL(OtherQuantity,0) FROM tra_ExerciseBalancePool 
		--WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = )
		--BEGIN
		--	INSERT INTO @Results
		--	SELECT ISNULL(ESOPQuantity,0),ISNULL(OtherQuantity,0) FROM tra_ExerciseBalancePool 
		--	WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID
		--END
		--ELSE 
		--BEGIN
		--	INSERT INTO @Results select 0,0
		--END
		
		/*
	    
			Create Temp Table and save balance in per details
	    
	    */
	    
	    CREATE TABLE #tabledematwise(DMATID INT,SecurityTypeCodeID INT, ESOPBalance DECIMAL(15,0),OtherBalance DECIMAL(15,0))
	    
	    INSERT INTO #tabledematwise	
		SELECT DMATDetailsID,SecurityTypeCodeId,0,0 FROM tra_TransactionDetails 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		GROUP BY SecurityTypeCodeId,DMATDetailsID
		
		UPDATE TW 
		SET ESOPBalance = EBP.ESOPQuantity,
			OtherBalance = EBP.OtherQuantity
		FROM #tabledematwise TW
		JOIN tra_ExerciseBalancePool EBP ON EBP.DMATDetailsID = TW.DMATID
		AND TW.SecurityTypeCodeID = EBP.SecurityTypeCodeId
		WHERE EBP.UserInfoId = @nUserInfoID
		
		IF(@nContraTradeOption = @nContraTradeQuantiyBase)
		BEGIN
				PRINT 'Contra Trade Quntity Base'
				-- When Transaction Type Buy & Secuirty type Shares then selected Qty 
				-- set in OtherExcerciseOptionQty column 
			    
				SELECT @inp_sPreclearanceRequestId = PreclearanceRequestId FROM tra_TransactionMaster 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
			    
			    
				UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId IN (@nBuyTransctionType,@nPledgeTransctionType,@nPledgeRevokeTransctionType,@nPledgeInvokeTransctionType) AND TD.SecurityTypeCodeId =  @nShareSecurityType 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				 
				 
				-- When Transaction Type Cash Excercise & Secuirty type Shares then selected Qty 
				-- set in ESOPExcerciseOptionQty column
				UPDATE  TD
					SET TD.ESOPExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId = @nCashExcerciseTransctionType AND TD.SecurityTypeCodeId =  @nShareSecurityType 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				
				
				-- When Transaction Type Cashless Partial & Secuirty type Shares then (buy Qty - sell qty)
				-- set in ESOPExcerciseOptionQty column
				UPDATE  TD
				   SET TD.ESOPExcerciseOptionQty = TD.Quantity-TD.Quantity2
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId = @nCashlessPartialTransctionType AND TD.SecurityTypeCodeId =  @nShareSecurityType 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				
			   
				UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType) 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				AND TD.TransactionTypeCodeId NOT IN(@nCashlessPartialTransctionType,@nCashlessAllTransctionType)
				
				
				
			   UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity-TD.Quantity2
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType) 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				AND TD.TransactionTypeCodeId = @nCashlessPartialTransctionType 				
				
				
				UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId = @nSellTransctionType AND TD.SecurityTypeCodeId =  @nShareSecurityType 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID
				and @nLess != (select impt_post_share_qty_code_id from tra_TransactionTypeSettings where mode_of_acquis_code_id = TD.modeofacquisitioncodeid and trans_type_code_id = TD.transactiontypecodeid and security_type_code_id = TD.SecurityTypeCodeId)
						
			    
			    
				
				
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId IN (@nBuyTransctionType) AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
							
				UPDATE TW
				SET ESOPBalance = ESOPBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashExcerciseTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
				
				UPDATE TW
				SET ESOPBalance = ESOPBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0)-ISNULL(SUM(Quantity2),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashlessPartialTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
				
				 
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId NOT IN(@nCashlessPartialTransctionType,@nCashlessAllTransctionType) AND SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType)
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
				 
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0)-ISNULL(SUM(Quantity2),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashlessPartialTransctionType AND SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType)
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID 
				 
				--select * from #tabledematwise
						
				 /*
					This part for if Transaction Type Sell and Secuirty Shares
					1. Fetch Cash And Cashless Partial Excise Option For Contra Trade from Trading Policy rule
				 */
				SELECT @nGenCashAndCashlessPartialExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade 
				FROM tra_TransactionMaster TM
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
				WHERE TransactionMasterId = @inp_iTransactionMasterID
					
				
					
				--SELECT * FROm @Results
					
				-- in case of pre clearance (sell transaction type) reserve the quantity to get original exiercise pool balance
				-- because exercise pool is already change when pre clearance is taken
				IF(@inp_sPreclearanceRequestId IS NOT NULL)
				BEGIN
					-- get pre clearance exercise pool quantity which is set when preclearance is taken
					
						
					--IF EXISTS(SELECT ISNULL(ESOPQuantity,0),ISNULL(OtherQuantity,0) FROM tra_ExerciseBalancePool 
					--WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID)
					--BEGIN
					--	--INSERT INTO @Results
					--	UPDATE TW
					--		SET ESOPBalance = ESOPBalance + ESOPQty,
					--		OtherBalance = OtherBalance + OtherQty
					--	FROM #tabledematwise TW 
					--	JOIN(
					--	SELECT DMATDetailsID,ISNULL(ESOPQuantity,0) AS ESOPQty,ISNULL(OtherQuantity,0) AS OtherQty FROM tra_ExerciseBalancePool 
					--	WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID) EBP ON EBP.DMATDetailsID = TW.DMATID
						
					--END
					----ELSE 
					----BEGIN
					--	--INSERT INTO @Results select 0,0
					----END
					
					SELECT @nPCLESOPExerciseOptionQuantity = ESOPExcerciseOptionQty, @nPCLOtherExerciseOptionQuantity = OtherExcerciseOptionQty, 
						@nPreClearanceTrasactionType = TransactionTypeCodeId, @nPreClearanceModeOfAcquisition = ModeOfAcquisitionCodeId, @nPreClearanceSecurityTypeCodeId = SecurityTypeCodeId 
					FROM tra_PreclearanceRequest 
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId AND SecurityTypeCodeId = @nShareSecurityType					
					
					IF (@nLess = (select impt_post_share_qty_code_id from tra_TransactionTypeSettings where mode_of_acquis_code_id = @nPreClearanceModeOfAcquisition AND trans_type_code_id = @nPreClearanceTrasactionType and security_type_code_id = @nPreClearanceSecurityTypeCodeId))
					BEGIN
						UPDATE @Results SET Esopsum = Esopsum + @nPCLESOPExerciseOptionQuantity, othersum = othersum+@nPCLOtherExerciseOptionQuantity
						
						UPDATE #tabledematwise
						SET ESOPBalance = ESOPBalance + @nPCLESOPExerciseOptionQuantity,OtherBalance = OtherBalance+@nPCLOtherExerciseOptionQuantity
						WHERE SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATID = @nPCLDMATDetailsID 
					END
				END
				/*
				 -- Get Quantity of Sum of Buy transaction and then add to the Other balance 
				SELECT @nBuyTransactionTotalQuanity = ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nBuyTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				 
				SELECT @nESOPTransactionTotalQuanity = ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashExcerciseTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				 
				SELECT @nESOPTransactionPartialTotalQuanity = ISNULL(SUM(Quantity),0)-ISNULL(SUM(Quantity2),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashlessPartialTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				*/
				
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nSellTransctionType AND SecurityTypeCodeId IN(@nShareSecurityType)
					AND @nAdd = (SELECT impt_post_share_qty_code_id from tra_TransactionTypeSettings 
								WHERE mode_of_acquis_code_id = tra_TransactionDetails.modeofacquisitioncodeid 
								AND trans_type_code_id = tra_TransactionDetails.transactiontypecodeid 
								AND security_type_code_id = tra_TransactionDetails.SecurityTypeCodeId)
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID 
				/*
				SELECT @nSellTransactionPartialTotalQuanity = ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nSellTransctionType AND SecurityTypeCodeId = @nShareSecurityType
					and @nAdd = (select impt_post_share_qty_code_id from tra_TransactionTypeSettings where mode_of_acquis_code_id = tra_TransactionDetails.modeofacquisitioncodeid and trans_type_code_id = tra_TransactionDetails.transactiontypecodeid and security_type_code_id = tra_TransactionDetails.SecurityTypeCodeId)
				GROUP BY TransactionMasterId
					*/
				UPDATE @Results
				SET Esopsum = Esopsum + ISNULL(@nESOPTransactionTotalQuanity,0) + ISNULL(@nESOPTransactionPartialTotalQuanity,0),
					othersum = othersum + ISNULL(@nBuyTransactionTotalQuanity,0)+ ISNULL(@nSellTransactionPartialTotalQuanity,0)
				
					  
				IF(@inp_sPreclearanceRequestId IS NOT NULL)	
				BEGIN
					SELECT  @nSumDetailsQuantity = SUM(TD.Quantity),
							@nPCLQuantity = PR.SecuritiesToBeTradedQty
					FROM tra_TransactionMaster TM 
					JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
					WHERE @nLess = (select impt_post_share_qty_code_id from tra_TransactionTypeSettings where mode_of_acquis_code_id = TD.ModeOfAcquisitionCodeId AND trans_type_code_id = TD.TransactionTypeCodeId and security_type_code_id = TD.SecurityTypeCodeId)
					AND TD.SecurityTypeCodeId = @nSecurityTypeCodeID AND TM.PreclearanceRequestId IS NOT NULL 
					AND TM.PreclearanceRequestId =  @inp_sPreclearanceRequestId
					GROUP BY TM.PreclearanceRequestId,PR.SecuritiesToBeTradedQty
						
					SET @nOverTradedDifferenceQty = @nPCLQuantity - @nSumDetailsQuantity
						 
					IF(@nOverTradedDifferenceQty<0)
					BEGIN
						--SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						SELECT @nESOPQty = ESOPBalance,@nOtherQty = OtherBalance 
						FROM #tabledematwise WHERE SecurityTypeCodeID = @nSecurityTypeCodeID AND DMATID = @nPCLDMATDetailsID
						
						IF(@nSecurityTypeCodeID = @nShareSecurityType)	
						BEGIN	
							IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nESOPFirstOptionThenOther OR 
									@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nOtherFirstThenESOP)
							BEGIN
								IF(@nOverTradedDifferenceQty>(@nESOPQty+@nOtherQty) AND @bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
								END
								ELSE IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nUserSelectionRule)
								BEGIN
											
							SELECT @bESOPExcerseOptionQtyFlag = ESOPExcerciseOptionQtyFlag,
								   @bOtherESOPExcerseOptionFlag = OtherESOPExcerciseOptionQtyFlag 
							FROM tra_PreclearanceRequest 
							WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
											
							IF((@bESOPExcerseOptionQtyFlag = 1 AND @bOtherESOPExcerseOptionFlag = 1 AND @nOverTradedDifferenceQty>(@nESOPQty+@nOtherQty))
							OR (@bESOPExcerseOptionQtyFlag = 1 AND @bOtherESOPExcerseOptionFlag = 0 AND @nOverTradedDifferenceQty>(@nESOPQty))
							OR (@bESOPExcerseOptionQtyFlag = 0 AND @bOtherESOPExcerseOptionFlag = 1 AND @nOverTradedDifferenceQty>(@nOtherQty))
							AND @bIsAllowNegativeBalance = 1)
							BEGIN
								SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
								RETURN @out_nReturnValue
							END
						END	
					   END
					   ELSE
					   BEGIN
							IF(@nOverTradedDifferenceQty > @nOtherQty AND @bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
					   END
					END 
				END
				
				
					
				SET @GetTrasnactionDetailsID = CURSOR FOR
					--Select Transaction details Quantity, Balance pool quantity
					SELECT TransactionDetailsID,Quantity,TD.ESOPExcerseOptionQtyFlag,TD.OtherESOPExcerseOptionFlag,TD.DMATDetailsID,TD.SecurityTypeCodeId
					FROM tra_TransactionDetails TD
					JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
					--LEFT JOIN tra_ExerciseBalancePool EBP ON TM.UserInfoId = EBP.UserInfoId
					WHERE TD.TransactionMasterID = @inp_iTransactionMasterID					
					AND TD.SecurityTypeCodeId =  @nSecurityTypeCodeID					
					AND @nLess = (select IMPT_POST_SHARE_QTY_CODE_ID from tra_TransactionTypeSettings where MODE_OF_ACQUIS_CODE_ID = TD.ModeOfAcquisitionCodeId AND TRANS_TYPE_CODE_ID = TD.TransactionTypeCodeId AND SECURITY_TYPE_CODE_ID = TD.SecurityTypeCodeId)
				
				DECLARe @ntmpty1 INT = 0
				
				
				OPEN @GetTrasnactionDetailsID
				
				FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@ESOPQtyFlg,@OTHERQtyFlg,@TDDMATDEtailsID,@nTDSecurityTypeCodeID
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF(@nSecurityTypeCodeID = @nShareSecurityType)
					BEGIN
					IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nESOPFirstOptionThenOther)
					BEGIN	
						--SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						select * from #tabledematwise
						SELECT @nESOPQty = ESOPBalance,@nOtherQty=OtherBalance 
						
						FROM #tabledematwise WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
						
						IF(@Quantity <= @nESOPQty)
						BEGIN
							SET @nTempQty = @Quantity
						END
						ELSE
						BEGIN
							SET @nTempQty = @nESOPQty
							
							IF(@nOtherQty>=@Quantity-@nTempQty)
							BEGIN
								SET @nTempQty1 = @Quantity-@nTempQty
							END
							ELSE
							BEGIN
								IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
							END
						END
								
						UPDATE tra_TransactionDetails
						SET ESOPExcerciseOptionQty = @nTempQty,
							OtherExcerciseOptionQty = @nTempQtY1
						WHERE TransactionDetailsId = @TrasnactionDetailsID
							
						--UPDATE @Results
						--SET Esopsum = Esopsum-@nTempQty,
							--othersum = othersum - @nTempQty1		
						
						UPDATE #tabledematwise
						SET ESOPBalance = ESOPBalance - @nTempQty,
							OtherBalance = OtherBalance - @nTempQty1
						WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
								
					END
					ELSE IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nOtherFirstThenESOP)
					BEGIN
						--SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						SELECT @nESOPQty = ESOPBalance,@nOtherQty=OtherBalance 
						FROM #tabledematwise WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
						
						IF(@Quantity <= @nOtherQty)
						BEGIN
							SET @nTempQty = @Quantity
						END
						ELSE
						BEGIN
							SET @nTempQty = @nOtherQty
							
							IF(@nESOPQty >=@Quantity-@nTempQty)
							BEGIN
								SET @nTempQty1 = @Quantity-@nTempQty
							END
							ELSE
							BEGIN
								IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
							END
						END
						
						UPDATE tra_TransactionDetails
						SET ESOPExcerciseOptionQty = @nTempQty1,
							OtherExcerciseOptionQty = @nTempQtY
						WHERE TransactionDetailsId = @TrasnactionDetailsID
					
						--UPDATE @Results
						--SET Esopsum = Esopsum-@nTempQty1,
						--	othersum = othersum - @nTempQty
							
					   UPDATE #tabledematwise
						SET ESOPBalance = ESOPBalance - @nTempQty1,
							OtherBalance = OtherBalance - @nTempQty
						WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
					   
					END
					ELSE IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nUserSelectionRule)
					BEGIN
						
						--SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						
						SELECT @nESOPQty = ESOPBalance,@nOtherQty=OtherBalance 
						FROM #tabledematwise WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
						
						
						IF(@ESOPQtyFlg = 1 AND @OTHERQtyFlg = 1)
						BEGIN
							IF(@Quantity <= @nESOPQty)
							BEGIN
								SET @nTempQty = @Quantity
							END
							ELSE
							BEGIN
								SET @nTempQty = @nESOPQty
								
								IF(@nOtherQty>=@Quantity-@nTempQty)
								BEGIN
									SET @nTempQty1 = @Quantity-@nTempQty
								END
								ELSE
								BEGIN
									IF(@bIsAllowNegativeBalance = 1)
									BEGIN
										SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
										RETURN @out_nReturnValue
									END
								END
							END
								
							UPDATE tra_TransactionDetails
							SET ESOPExcerciseOptionQty = @nTempQty,
								OtherExcerciseOptionQty = @nTempQtY1
							WHERE TransactionDetailsId = @TrasnactionDetailsID
							
							--UPDATE @Results
							--SET Esopsum = Esopsum-@nTempQty,othersum =othersum -  @nTempQty1
							
						UPDATE #tabledematwise
						SET ESOPBalance = ESOPBalance - @nTempQty,
							OtherBalance = OtherBalance - @nTempQty1
						WHERE SecurityTypeCodeID = @nShareSecurityType AND DMATID = @TDDMATDEtailsID
								
						END
						ELSE IF(@ESOPQtyFlg = 1 AND @OTHERQtyFlg = 0)
						BEGIN					
							IF(@Quantity <= @nESOPQty)
							BEGIN
								SET @nTempQty = @Quantity
							END
							ELSE 
							BEGIN
							    IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
							END
							
							UPDATE tra_TransactionDetails
							SET ESOPExcerciseOptionQty = @nTempQty,
							    OtherExcerciseOptionQty = 0
							WHERE TransactionDetailsId = @TrasnactionDetailsID
							
							UPDATE @Results
							SET Esopsum = Esopsum-@nTempQty
						END
						ELSE IF(@ESOPQtyFlg = 0 AND @OTHERQtyFlg = 1)
						BEGIN
							IF(@Quantity <= @nOtherQty)
							BEGIN
								SET @nTempQty = @Quantity
							END
							ELSE
							BEGIN
								IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
							END
							
							SET @nOtherQty = @nOtherQty-@nTempQty1
							
							UPDATE tra_TransactionDetails
							SET OtherExcerciseOptionQty = @nTempQty,
							    ESOPExcerciseOptionQty = 0
							WHERE TransactionDetailsId = @TrasnactionDetailsID
							
							UPDATE @Results
							SET othersum = othersum - @nTempQty
									
						END
						ELSE
						BEGIN
							    IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
						END
					END
					END
					ELSE
					BEGIN
					--select * from @Results
						--SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						
						SELECT @nESOPQty= ESOPBalance,
							@nOtherQty = OtherBalance
						FROM #tabledematwise WHERE SecurityTypeCodeID = @nTDSecurityTypeCodeID AND DMATID = @TDDMATDEtailsID
						
						SET @ntmpty1 = @ntmpty1 + @Quantity
						--select @ntmpty1,@nOtherQty
						IF(@ntmpty1 > @nOtherQty)
						BEGIN
							   IF(@bIsAllowNegativeBalance = 1)
								BEGIN
									SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
									RETURN @out_nReturnValue
								END
						END
						
						UPDATE tra_TransactionDetails
						SET ESOPExcerciseOptionQty = 0,
							OtherExcerciseOptionQty = @Quantity
						WHERE TransactionDetailsId = @TrasnactionDetailsID
						
						UPDATE @Results
						SET Esopsum = 0,
							othersum = othersum - @Quantity
						
						UPDATE #tabledematwise
						SET ESOPBalance =0,
							OtherBalance = OtherBalance - @Quantity
						WHERE SecurityTypeCodeID = @nTDSecurityTypeCodeID AND DMATID = @TDDMATDEtailsID
						
					END
					
					FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@ESOPQtyFlg,@OTHERQtyFlg,@TDDMATDEtailsID,@nTDSecurityTypeCodeID
				END
						
				CLOSE @GetTrasnactionDetailsID
				DEALLOCATE @GetTrasnactionDetailsID
			END
		ELSE IF(@nContraTradeOption = @nContraTradeWithoutQuantiy)
		BEGIN
			--SELECT @inp_sPreclearanceRequestId = PreclearanceRequestId FROM tra_TransactionMaster 
			--	WHERE TransactionMasterId = @inp_iTransactionMasterId
			UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.TransactionTypeCodeId IN(@nBuyTransctionType,@nCashExcerciseTransctionType,@nPledgeTransctionType,@nPledgeRevokeTransctionType,@nPledgeInvokeTransctionType) 
				AND TD.SecurityTypeCodeId =  @nShareSecurityType 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
		
			UPDATE TD
				   SET TD.OtherExcerciseOptionQty = TD.Quantity-TD.Quantity2
			FROM tra_TransactionMaster TM
			JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TD.TransactionTypeCodeId = @nCashlessPartialTransctionType 
			AND TD.SecurityTypeCodeId =  @nShareSecurityType 
			AND TM.TransactionMasterId = @inp_iTransactionMasterID 
						
			UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType) 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				AND TD.TransactionTypeCodeId NOT IN(@nCashlessPartialTransctionType,@nCashlessAllTransctionType)
				
			   UPDATE  TD
					SET TD.OtherExcerciseOptionQty = TD.Quantity-TD.Quantity2
				FROM tra_TransactionMaster TM
				JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
				WHERE TD.SecurityTypeCodeId IN(@nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType) 
				AND TM.TransactionMasterId = @inp_iTransactionMasterID 
				AND TD.TransactionTypeCodeId = @nCashlessPartialTransctionType 
			
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId IN (@nBuyTransctionType,@nCashExcerciseTransctionType) AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
				
				UPDATE TW
				SET OtherBalance = OtherBalance + Qty
				FROM #tabledematwise TW JOIN
				(SELECT DMATDetailsID, ISNULL(SUM(Quantity),0)-ISNULL(SUM(Quantity2),0) AS  Qty FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId IN (@nCashlessPartialTransctionType) AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId,DMATDetailsID) TD ON tw.DMATID = TD.DMATDetailsID
		       -- in case of pre clearance (sell transaction type) reserve the quantity to get original exiercise pool balance
				-- because exercise pool is already change when pre clearance is taken
				IF(@inp_sPreclearanceRequestId IS NOT NULL)
				BEGIN
					-- get pre clearance exercise pool quantity which is set when preclearance is taken
					
					--IF EXISTS(SELECT ISNULL(ESOPQuantity,0),ISNULL(OtherQuantity,0) FROM tra_ExerciseBalancePool 
					--WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID)
					--BEGIN
					--	--INSERT INTO @Results
					--	UPDATE TW
					--		SET ESOPBalance = ESOPBalance + ESOPQty,
					--		OtherBalance = OtherBalance + OtherQty
					--	FROM #tabledematwise TW 
					--	JOIN(
					--	SELECT DMATDetailsID,ISNULL(ESOPQuantity,0) AS ESOPQty,ISNULL(OtherQuantity,0) AS OtherQty FROM tra_ExerciseBalancePool 
					--	WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID) EBP ON EBP.DMATDetailsID = TW.DMATID
						
					--END
					
					SELECT @nPCLESOPExerciseOptionQuantity = ESOPExcerciseOptionQty, @nPCLOtherExerciseOptionQuantity = OtherExcerciseOptionQty, 
						@nPreClearanceTrasactionType = TransactionTypeCodeId, @nPreClearanceModeOfAcquisition = ModeOfAcquisitionCodeId, @nPreClearanceSecurityTypeCodeId = SecurityTypeCodeId 
					FROM tra_PreclearanceRequest 
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId AND SecurityTypeCodeId = @nShareSecurityType AND DMATDetailsID = @nPCLDMATDetailsID					
					
					IF (@nLess = (select IMPT_POST_SHARE_QTY_CODE_ID from tra_TransactionTypeSettings where MODE_OF_ACQUIS_CODE_ID = @nPreClearanceModeOfAcquisition AND TRANS_TYPE_CODE_ID = @nPreClearanceTrasactionType AND SECURITY_TYPE_CODE_ID = @nPreClearanceSecurityTypeCodeId))
					BEGIN
						UPDATE @Results SET othersum = othersum + @nPCLOtherExerciseOptionQuantity
						
						UPDATE TW
							SET
							OtherBalance = OtherBalance + OtherQty
						FROM #tabledematwise TW 
						JOIN(
						SELECT DMATDetailsID,ISNULL(ESOPQuantity,0) AS ESOPQty,ISNULL(OtherQuantity,0) AS OtherQty FROM tra_ExerciseBalancePool 
						WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID) EBP ON EBP.DMATDetailsID = TW.DMATID
					END
				END
				
				
				/*
				 -- Get Quantity of Sum of Buty transaction and then add to the Other balance 
				SELECT @nBuyTransactionTotalQuanity = ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nBuyTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				 
				SELECT @nESOPTransactionTotalQuanity = ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashExcerciseTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				 
				SELECT @nESOPTransactionPartialTotalQuanity = ISNULL(SUM(Quantity),0)-ISNULL(SUM(Quantity2),0) FROM tra_TransactionDetails 
				WHERE TransactionMasterId = @inp_iTransactionMasterId
					AND TransactionTypeCodeId = @nCashlessPartialTransctionType AND SecurityTypeCodeId = @nShareSecurityType
				GROUP BY TransactionMasterId
				
				UPDATE @Results
				SET othersum = othersum + ISNULL(@nBuyTransactionTotalQuanity,0) + ISNULL(@nESOPTransactionTotalQuanity,0) + ISNULL(@nESOPTransactionPartialTotalQuanity,0)
				*/
					
				IF(@inp_sPreclearanceRequestId IS NOT NULL)	
				BEGIN
					SELECT  @nSumDetailsQuantity = SUM(TD.Quantity),
							@nPCLQuantity = PR.SecuritiesToBeTradedQty
					FROM tra_TransactionMaster TM 
					JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
					WHERE TD.TransactionTypeCodeId = 143002 
					AND TD.SecurityTypeCodeId = @nSecurityTypeCodeID AND TM.PreclearanceRequestId IS NOT NULL 
					AND TM.PreclearanceRequestId =  @inp_sPreclearanceRequestId
					GROUP BY TM.PreclearanceRequestId,PR.SecuritiesToBeTradedQty
						
					SET @nOverTradedDifferenceQty = @nPCLQuantity - @nSumDetailsQuantity
				
				   select @nOverTradedDifferenceQty,@nSumDetailsQuantity,@nPCLQuantity
				 
					IF(@nOverTradedDifferenceQty<0)
					BEGIN
						SELECT @nESOPQty = Esopsum,@nOtherQty=othersum FROM @Results
						
						UPDATE #tabledematwise
						SET ESOPBalance = ESOPBalance + @nPCLESOPExerciseOptionQuantity,OtherBalance = OtherBalance+@nPCLOtherExerciseOptionQuantity
						WHERE SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATID = @nPCLDMATDetailsID
								
						IF(@nOverTradedDifferenceQty>@nOtherQty AND @bIsAllowNegativeBalance = 1)
						BEGIN
							SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE
							RETURN @out_nReturnValue
						END	
					END 
				END
				
				
				--Curosr Start
				
					
				SET @GetTrasnactionDetailsID = CURSOR FOR
					--Select Transaction details Quantity, Balance pool quantity
					SELECT TransactionDetailsID,Quantity,TD.ESOPExcerseOptionQtyFlag,TD.OtherESOPExcerseOptionFlag,DMATDetailsID,TD.SecurityTypeCodeId
					FROM tra_TransactionDetails TD
					JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
					--LEFT JOIN tra_ExerciseBalancePool EBP ON TM.UserInfoId = EBP.UserInfoId
					WHERE TD.TransactionMasterID = @inp_iTransactionMasterID
					AND TD.TransactionTypeCodeId = @nSellTransctionType AND TD.SecurityTypeCodeId =  @nSecurityTypeCodeID
				
				OPEN @GetTrasnactionDetailsID
				DECLARE @ntmpty INT = 0
				FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@ESOPQtyFlg,@OTHERQtyFlg,@TDDMATDEtailsID,@nTDSecurityTypeCodeID
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
				--SELECT @nOtherQty=othersum FROM @Results
					IF(@inp_sPreclearanceRequestId IS NOT NULL)
					BEGIN
						SELECT @nPreclearanceQuantity = SecuritiesToBeTradedQty FROM tra_PreclearanceRequest WHERE TransactionTypeCodeId = @nSellTransctionType AND PreclearanceRequestId = @inp_sPreclearanceRequestId
						SET @ntmpty = @ntmpty + @Quantity
						IF(@ntmpty > @nPreclearanceQuantity AND @bIsAllowNegativeBalance = 1)
						BEGIN
								SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE
								RETURN @out_nReturnValue
						END
						ELSE
						BEGIN
							UPDATE tra_TransactionDetails
							SET OtherExcerciseOptionQty = @Quantity
							WHERE TransactionDetailsId = @TrasnactionDetailsID
						END
					END
					ELSE
					BEGIN
						SELECT @nESOPQty = ESOPBalance,@nOtherQty=OtherBalance 
							FROM #tabledematwise WHERE SecurityTypeCodeID = @nTDSecurityTypeCodeID AND DMATID = @TDDMATDEtailsID
						SET @ntmpty = @ntmpty + @Quantity
						IF(@ntmpty > @nOtherQty AND @bIsAllowNegativeBalance = 1)
						BEGIN
								SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE
								RETURN @out_nReturnValue
						END
						ELSE
						BEGIN
							UPDATE tra_TransactionDetails
							SET OtherExcerciseOptionQty = @Quantity
							WHERE TransactionDetailsId = @TrasnactionDetailsID
						END
					END
					FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@ESOPQtyFlg,@OTHERQtyFlg,@TDDMATDEtailsID,@nTDSecurityTypeCodeID
				END	
				CLOSE @GetTrasnactionDetailsID
				DEALLOCATE @GetTrasnactionDetailsID
		END
	END
	RETURN @out_nReturnValue
		
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_UPDATEEXCERCISEBALANCEPOOL, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END