IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_BalancePoolUpdateDetails_OS')
DROP PROCEDURE [dbo].[st_tra_BalancePoolUpdateDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_BalancePoolUpdateDetails_OS]
	@inp_nMapToTypeCodeId					INT,
	@inp_nPreClearanceRequestId				INT = NULL,
	@inp_nTransactionMasterId				INT = NULL,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_EXECISE_BALANCE_POOL_DETAILS_SAVE_FAIL INT = 17401 -- Error occured while updating exercise pool
	
	DECLARE @nUserInfoId INT
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nPreClearanceRequestId INT = NULL
	DECLARE @nSecurityTypeCodeId INT = NULL
	DECLARE @nTransactionStatusCodeId INT
	DECLARE @bNoHoldingFlag BIT
	DECLARE @nPartiallyTradedFlag INT
	DECLARE @bShowPartialTradeBtn BIT
	DECLARE @nPCLNotTradeCodeID INT
	DECLARE @sPCLNotTradeReason VARCHAR(30)
	DECLARE @nTradingPolicyId INT 
	DECLARE @nExciseOptionForContraTrade INT 
	DECLARE @nTransactionTypeCodeId INT = NULL
	DECLARE @nPCLSecurityTypeCodeId INT = NULL
	DECLARE @nPCLSecuritiesToBeTradedQty DECIMAL(15,4) = NULL
	DECLARE @nPCLESOPExcerciseOptionQty DECIMAL(15,4) = 0
	DECLARE @nPCLOtherExcerciseOptionQty DECIMAL(15,4) = 0
	DECLARE @nPCLPledgeOptionQty DECIMAL(15,4) = 0
	DECLARE @nPreclearanceStatusCodeId INT = NULL
	DECLARE @nESOPExcerciseOptionQtyFlag BIT = NULL
	DECLARE @nOtherESOPExcerciseOptionQtyFlag BIT = NULL
	DECLARE @nPreClrReasonForNonTradeReqFlag BIT
	DECLARE @nPreClrCompleteTradeNotDoneFlag BIT
	DECLARE @nPreClrPartialTradeNotDoneFlag BIT
	
	DECLARE @nDislosureType_Initial INT = 147001
	DECLARE @nDislosureType_Continuous INT = 147002
	DECLARE @nDislosureType_PeriodEnd INT = 147003
	
	DECLARE @nSecurityType_Share INT = 139001
	
	DECLARE @nTransactionStatus_DocUpload INT = 148001
	DECLARE @nTransactionStatus_NotConfirm INT = 148002
	DECLARE @nTransactionStatus_Confirm INT = 148003
	DECLARE @nTransactionStatus_Submitted INT = 148007

	DECLARE @nPreClearanceStatus_Reject INT = 144003
	
	DECLARE @nAction_PreclearanceRequest INT  = 132004
	DECLARE @nAction_DisclosureTransaction INT = 132005
	
	DECLARE @nESOPQuanity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nOtherQuantity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nPledgeQuantity_FromPool DECIMAL(15,4) = 0
	DECLARE @nNotImpactedQuantity_FromPool DECIMAL(15,4) = 0
	
	DECLARE @bChangePoolFlag BIT = 0 -- This flag is used to decide if insert/update flag base on transcation done
	DECLARE @nPoolActionFlag INT = 0 -- 0: NO Action, 1: Insert new record, 2: Update existing record
	
	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	--DECLARE @nTransactionType_CashExercies INT = 143003
	--DECLARE @nTransactionType_CashlessAll INT = 143004
	--DECLARE @nTransactionType_CashlessPartail INT = 143005
	DECLARE @nTransactionType_Pledge INT = 143006
	DECLARE @nTransactionType_PledgeRevoke INT = 143007
	DECLARE @nTransactionType_PledgeInvoke INT = 143008	
	
	DECLARE @nPoolOption_ESOPExciseOptionFirstandThenOtherShares INT = 172001
	DECLARE @nPoolOption_OtherSharesFirstThenESOPExciseOption INT = 172002
	DECLARE @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission INT = 172003
	
	--DECLARE @nESOPQuanity DECIMAL(15,4) = 0
	DECLARE @nOtherQuantity DECIMAL(15,4) = 0
	DECLARE @nPledgeQuantity DECIMAL(15,4) = 0
	DECLARE @nNotImpactedQuantity DECIMAL(15,4) = 0
	
	DECLARE @nTDESOPExcerciseOptionQty DECIMAL(10,0) = 0
	DECLARE @nTDOtherExcerciseOptionQty DECIMAL(10,0) = 0
	
	DECLARE @nContraTradeOption INT
	DECLARE @nContraTradeGeneralOption INT = 175001
	DECLARE @nContraTradeQuantityBase INT = 175002
	
	DECLARE @nModeOfAcquisitionCodeType INT = NULL
	DECLARE @nImptPostShareQtyCodeId INT
	DECLARE @nActionCodeID INT
	--Impact on Post Share quantity
	DECLARE @nAdd  INT = 505001
	DECLARE @nLess INT = 505002    
	DECLARE @nNo   INT = 505004
	--Action 
	DECLARE @nBuy  INT = 504001
	DECLARE @nSell INT = 504002
	DECLARE @nTransaction_SecurityType INT
	
	DECLARE @nTmpRet INT
	DECLARE @nDMATDetailsID INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		
		-- get deatails from transanaction master id 
		-- check if transaction is for per-clearance approve/reject or disclosure transaction submitted 
		-- check if records already exists in exercise pool or does not exists - in case does not exists then insert record
		-- records already exists in exercise pool then in case pre-clearance 
		--		when requested than add/subtract, when approve then no action and in caes of reject reserve action of request
		-- records already exists in exercise pool then in case of disclosure details 
		--		when initial disclosure, add quantity to pool - check all trade details
		--		when continous disclosure (PNT), add/substract when transaction is submitted
		--		when continuous disclosure (PLC), compare quantity for details with quantity mention in pre-clearance and difference is add/substract from pool 
		--		when period end disclosure, add/substract when period end disclosure is submitted
		--			NOTE - in case of period end disclosure, use trading policy from tra_UserPeriodEndDisclosure 
		--			and do not use trading policy from transaction master
		
		-- transaction type will affect pool as follows 
		-- buy - add other quantity pool 
		-- cash exercise(treated as buy) - add esop quantity pool 
		-- cashless partial (buy quantity is more than sell quantity) - difference in buy and sell is updated in esop quantity pool
		-- cashless all - no action because whatever quantity is buy, sell same quantity
		-- sell - check what option is set in trading policy for substact quantity from which pool 
		
		-- fetch record to decide pre-clearance or disclosure transaction
		
		
		SELECT 
			@nUserInfoId = TM.UserInfoId, @nDisclosureTypeCodeId = DisclosureTypeCodeId, @nPreClearanceRequestId = TM.PreclearanceRequestId, 
			@nSecurityTypeCodeId = PCL.SecurityTypeCodeId, @nTransactionStatusCodeId = TransactionStatusCodeId, 
			@bNoHoldingFlag = NoHoldingFlag, 
			--@nPartiallyTradedFlag = IsPartiallyTraded, 
			--@bShowPartialTradeBtn = ShowAddButton, 
			--@nPCLNotTradeCodeID = ReasonForNotTradingCodeId, 
			--@sPCLNotTradeReason = ReasonForNotTradingText,
			@nTradingPolicyId = TM.TradingPolicyId,
			--@nExciseOptionForContraTrade = TP.GenCashAndCashlessPartialExciseOptionForContraTrade, 
			@nTransactionTypeCodeId = PCL.TransactionTypeCodeId, @nPCLSecurityTypeCodeId = PCL.SecurityTypeCodeId,
			@nPCLSecuritiesToBeTradedQty = PCL.SecuritiesToBeTradedQty, 
			--@nPCLESOPExcerciseOptionQty = PCL.ESOPExcerciseOptionQty, @nPCLOtherExcerciseOptionQty = PCL.OtherExcerciseOptionQty,
			@nPreclearanceStatusCodeId = PCL.PreclearanceStatusCodeId, 
			--@nESOPExcerciseOptionQtyFlag = PCL.ESOPExcerciseOptionQtyFlag, @nOtherESOPExcerciseOptionQtyFlag = PCL.OtherESOPExcerciseOptionQtyFlag,			
			@nPreClrReasonForNonTradeReqFlag = TP.PreClrReasonForNonTradeReqFlag, @nPreClrCompleteTradeNotDoneFlag = TP.PreClrCompleteTradeNotDoneFlag,
			@nPreClrPartialTradeNotDoneFlag = TP.PreClrPartialTradeNotDoneFlag, @nPCLPledgeOptionQty = PledgeOptionQty, @nModeOfAcquisitionCodeType = ModeOfAcquisitionCodeId,
			@nDMATDetailsID = PCL.DMATDetailsID
		FROM tra_TransactionMaster_OS TM
		JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PCL ON TM.PreclearanceRequestId = PCL.PreclearanceRequestId
		WHERE 
			(@inp_nTransactionMasterId IS NOT NULL AND  TM.TransactionMasterId = @inp_nTransactionMasterId)
			OR (@inp_nPreClearanceRequestId IS NOT NULL AND TM.PreclearanceRequestId = @inp_nPreClearanceRequestId)
				
		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption FROM mst_Company WHERE IsImplementing = 1
		
		IF (@inp_nMapToTypeCodeId IS NOT NULL)
		BEGIN
			-- set transaction security type
			SELECT @nTransaction_SecurityType = CASE 
													WHEN @inp_nMapToTypeCodeId = @nAction_PreclearanceRequest THEN @nPCLSecurityTypeCodeId
													ELSE @nSecurityTypeCodeId 
												END
		
			--SELECT @nESOPQuanity_FromPool = ESOPQuantity, @nOtherQuantity_FromPool = OtherQuantity, @nPledgeQuantity_FromPool = isnull(PledgeQuantity,0), @nNotImpactedQuantity_FromPool = isnull(NotImpactedQuantity,0) FROM tra_BalancePool_OS tra_ExerciseBalancePool 
			SELECT   @nOtherQuantity_FromPool = ActualQuantity, @nPledgeQuantity_FromPool = isnull(PledgeQuantity,0), @nNotImpactedQuantity_FromPool = isnull(NotImpactedQuantity,0) FROM tra_BalancePool_OS 
			WHERE UserInfoId = @nUserInfoId AND SecurityTypeCodeId = @nTransaction_SecurityType AND DMATDetailsID = @nDMATDetailsID
			
			-- check if record exists or not 
			IF (@nOtherQuantity_FromPool IS NULL)
			BEGIN
				SET @nPoolActionFlag = 1 -- insert new record
				
				-- set quantity because there is nothing in pool				
				SET @nOtherQuantity_FromPool = 0
			END
			ELSE
			BEGIN
				SET @nPoolActionFlag = 2 -- update existing record
			END
			
			
			
			
						
			
			IF (@inp_nMapToTypeCodeId = @nAction_PreclearanceRequest)
			BEGIN
				print 'Preclearance Request - '
				
				SET @bChangePoolFlag = 1 -- set flag to insert/update record
					
				-- here preclearance request is made check security type and transaction type
				IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
				BEGIN
					-- buy transaction affect other pool quantity only
					SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
											WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLSecuritiesToBeTradedQty 
											ELSE @nPCLOtherExcerciseOptionQty END 
					
					-- set quantity from pool				
					SET @nPledgeQuantity = @nPledgeQuantity_FromPool
					SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
				END
				ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
				BEGIN
					IF(@nContraTradeOption = @nContraTradeQuantityBase)
					BEGIN
						-- sell transaction can affect any pool depending on option set in trading policy
						-- check option set in trading policy for pool 
						
						-- use ESOP share quantity first then use Other share quantity
						IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
						BEGIN
							-- requested quantity is less than ESOP quantity in pool
							IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
							BEGIN
								--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
								--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
								--				ELSE -@nPCLESOPExcerciseOptionQty END
								
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
							ELSE
							BEGIN
								-- requested quantity is more than ESOP quantity in pool 
								--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
								--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
								--				ELSE -@nPCLESOPExcerciseOptionQty END
								
								SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
						END
						-- use Other share quantity first then use ESOP share quantity
						ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
						BEGIN
							-- requested quantity is less than Others quantity in pool
							IF (@nPCLSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
							BEGIN
								SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
												
								-- set quantity from pool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
							ELSE
							BEGIN
								-- requested quantity is more than Others quantity in pool 
								SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
								
								--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
								--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
								--				ELSE -@nPCLESOPExcerciseOptionQty END
								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
						END
						-- user has define which share quantity to use
						ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
						BEGIN
							-- use both ESOP and Other share quantity pool 
							-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
							IF (@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
							BEGIN
								-- requested quantity is less than ESOP quantity in pool
								IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
								BEGIN
									--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
									--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
									--				ELSE -@nPCLESOPExcerciseOptionQty END
									
									-- set quantity from pool
									SET @nOtherQuantity = @nOtherQuantity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
								ELSE
								BEGIN
									-- requested quantity is more than ESOP quantity in pool 
									--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
									--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
									--				ELSE -@nPCLESOPExcerciseOptionQty END
									
									SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
													WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
													ELSE -@nPCLOtherExcerciseOptionQty END
													
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
							END
							-- use ESOP share quantity pool ONLY
							ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
							BEGIN
								--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
								--					WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
								--					ELSE -@nPCLESOPExcerciseOptionQty END
								
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
							-- use Other share quantity pool ONLY
							ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
							BEGIN
								SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
								
								-- set quantity from pool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
						END
					END
					ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
					BEGIN
						SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
							-- set quantity from pool
						--SET @nESOPQuanity = @nESOPQuanity_FromPool
						SET @nPledgeQuantity = @nPledgeQuantity_FromPool
						SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
					END
				END
				ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
				BEGIN				
					select @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id from tra_TransactionTypeSettings where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeType and security_type_code_id = @nSecurityTypeCodeId
											   
					   IF(@nImptPostShareQtyCodeId = @nNo)						     
					   BEGIN
						   IF(@nActionCodeID = @nBuy)
						   BEGIN
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLPledgeOptionQty 
														ELSE @nPCLPledgeOptionQty END 
														
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END
						   ELSE IF(@nActionCodeID = @nSell)
						   BEGIN
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLPledgeOptionQty 
														ELSE -@nPCLPledgeOptionQty END 
													
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END
						   ELSE
						   BEGIN
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool									
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END	
					   END
					   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
					   BEGIN
							SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
													WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLOtherExcerciseOptionQty 
													ELSE @nPCLOtherExcerciseOptionQty END 
							
							-- set quantity from pool
							--SET @nESOPQuanity = @nESOPQuanity_FromPool
							SET @nPledgeQuantity = @nPledgeQuantity_FromPool
							SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
					   END
					   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
					   BEGIN
							IF(@nContraTradeOption = @nContraTradeQuantityBase)
							BEGIN
								-- sell transaction can affect any pool depending on option set in trading policy
								-- check option set in trading policy for pool 
								
								-- use ESOP share quantity first then use Other share quantity
								IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
								BEGIN
									-- requested quantity is less than ESOP quantity in pool
									IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
									BEGIN
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
										--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
										--				ELSE -@nPCLESOPExcerciseOptionQty END
										
										-- set quantity from pool
										SET @nOtherQuantity = @nOtherQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									ELSE
									BEGIN
										-- requested quantity is more than ESOP quantity in pool 
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
										--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
										--				ELSE -@nPCLESOPExcerciseOptionQty END
										
										SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
								-- use Other share quantity first then use ESOP share quantity
								ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
								BEGIN
									-- requested quantity is less than Others quantity in pool
									IF (@nPCLSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
									BEGIN
										SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
														
										-- set quantity from pool
										--SET @nESOPQuanity = @nESOPQuanity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									ELSE
									BEGIN
										-- requested quantity is more than Others quantity in pool 
										SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
										
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
										--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
										--				ELSE -@nPCLESOPExcerciseOptionQty END
										
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
								-- user has define which share quantity to use
								ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
								BEGIN
									-- use both ESOP and Other share quantity pool 
									-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
									IF (@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
									BEGIN
										-- requested quantity is less than ESOP quantity in pool
										IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
										BEGIN
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
											--				ELSE -@nPCLESOPExcerciseOptionQty END
											
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										ELSE
										BEGIN
											-- requested quantity is more than ESOP quantity in pool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--				WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
											--				ELSE -@nPCLESOPExcerciseOptionQty END
											
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
															WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
															ELSE -@nPCLOtherExcerciseOptionQty END
															
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									-- use ESOP share quantity pool ONLY
									ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
									BEGIN
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
										--					WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLESOPExcerciseOptionQty 
										--					ELSE -@nPCLESOPExcerciseOptionQty END
										
										-- set quantity from pool
										SET @nOtherQuantity = @nOtherQuantity_FromPool								
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									-- use Other share quantity pool ONLY
									ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
									BEGIN
										SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
										
										-- set quantity from pool
										--SET @nESOPQuanity = @nESOPQuanity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
							END
							ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
							BEGIN
								SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
									-- set quantity from pool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END		
					   END
					   ELSE
					   BEGIN
								-- set quantity from pool
								SET @nOtherQuantity = @nOtherQuantity_FromPool									
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
					   END
				END
			END
			ELSE IF (@inp_nMapToTypeCodeId = @nAction_DisclosureTransaction)
			BEGIN
				print 'Disclosure Transaction - '
				
				-- check if transcation is pre-clearance details enter or PNT/PE 
				-- in case of PNT/PE, update security pool immedately 
				-- in case of pre-clearance, check if pre-clearance is close or not, only when preclearance request is close then update security pool 
				
				-- check if transcation submitted is against pre-clearance requestor PNT/PE
				IF (@nDisclosureTypeCodeId = @nDislosureType_Continuous AND @nPreClearanceRequestId IS NOT NULL)
				BEGIN
					-- check if preclearanc is close or not 
					-- if preclearance is not close then do not take any action because on approval pool is already affected 
					-- if preclearnace is close then get all trancation details for preclearance and update pool accordingly 
					
					-- check if pre-clearance is close without any transcation -- in this case reverse the pool quantity 
					-- preclearnace close after partial trading -- in this case update pool quantity by difference 
					-- check if pre-clearance is close automatically because of over trade -- in this case add addition quantity to pool 
					
					-- if pre-clearance is for share and not close without trading and either overtraded or close partial trading
					IF (@nPartiallyTradedFlag <> 2)
					BEGIN
					
						DECLARE @nTradedQuantity DECIMAL(10,0) = 0
						DECLARE @nTradedQuantity2 DECIMAL(10,0) = 0
						DECLARE @nTradedESOPExcerciseOptionQty DECIMAL(10,0) = 0
						DECLARE @nTradedOtherExcerciseOptionQty DECIMAL(10,0) = 0
						DECLARE @nIsUnderOROverTraded INT = 0 -- 0 : no action, 1 : under traded, 2 : over traded, 3 : same quantity
						DECLARE @nDifferenceQuantity INT = 0
						
						DECLARE @nDifferenceESOPQuantity DECIMAL(15,4) = 0
						DECLARE @nDifferenceOtherQuantity DECIMAL(15,4) = 0
					
						SELECT 
							@nTradedQuantity = SUM(td.Quantity)
						FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
								AND tm.PreclearanceRequestId = @nPreClearanceRequestId and td.SecurityTypeCodeId = @nSecurityTypeCodeId
						group by tm.PreclearanceRequestId
						
						
						-- check if pre-clearance is close -- partial traded and close with reason, OR overtraded OR traded same quantity
						-- in case of same quantity traded, pool affect only when cashless partial exercise is done 
						IF (@nPCLNotTradeCodeID IS NOT NULL OR @nPCLSecuritiesToBeTradedQty <= @nTradedQuantity)
						BEGIN
							-- set flag if transcation is under traded or over traded 
							IF (@nPCLSecuritiesToBeTradedQty < @nTradedQuantity)
							BEGIN
								SET @nIsUnderOROverTraded = 2 -- over traded
								
								--set difference
								SET @nDifferenceQuantity = @nTradedQuantity - @nPCLSecuritiesToBeTradedQty
								
								-- in case of sell transcation get difference in quantity 
								IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
								BEGIN
									SET @nDifferenceESOPQuantity = ISNULL(@nTradedESOPExcerciseOptionQty,0) - ISNULL(@nPCLESOPExcerciseOptionQty,0)
									
									SET @nDifferenceOtherQuantity = ISNULL(@nTradedOtherExcerciseOptionQty,0) - ISNULL(@nPCLOtherExcerciseOptionQty,0)
								END
								
							END
							ELSE IF (@nPCLSecuritiesToBeTradedQty > @nTradedQuantity)
							BEGIN
								SET @nIsUnderOROverTraded = 1 -- under traded
								
								--set difference
								SET @nDifferenceQuantity = @nPCLSecuritiesToBeTradedQty - @nTradedQuantity
								
								-- in case of sell transcation get difference in quantity 
								IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
								BEGIN
									SET @nDifferenceESOPQuantity = ISNULL(@nPCLESOPExcerciseOptionQty,0) - ISNULL(@nTradedESOPExcerciseOptionQty,0)
									
									SET @nDifferenceOtherQuantity = ISNULL(@nPCLOtherExcerciseOptionQty,0) - ISNULL(@nTradedOtherExcerciseOptionQty,0)
								END
							END							
							
							-- check if there is difference in traded quantity and preclarance quantity 
							IF(@nIsUnderOROverTraded <> 0)
							BEGIN
								SET @bChangePoolFlag = 1 -- set flag to insert/update record
							
								-- here preclearance request is made check security type and transaction type
								IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
								BEGIN
									-- buy transaction affect other pool quantity only
									SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN -@nDifferenceQuantity -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN @nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
									
									-- set quantity from pool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
								BEGIN
									IF(@nContraTradeOption = @nContraTradeQuantityBase)
									BEGIN
										-- sell transaction can affect any pool depending on option set in trading policy
										-- check option set in trading policy for pool 
										
										-- use ESOP share quantity first then use Other share quantity
										IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
										BEGIN
											-- requested quantity is more than ESOP quantity in pool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--			WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
											--			WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
											--			WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
											--			END
											
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
														END
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										-- use Other share quantity first then use ESOP share quantity
										ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
										BEGIN
											-- requested quantity is more than Others quantity in pool 
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
														END
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--		WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
											--		WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
											--		WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
											--		END
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										-- user has define which share quantity to use
										ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
										BEGIN
										-- use both ESOP and Other share quantity pool 
										-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
										IF (@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											-- requested quantity is more than ESOP quantity in pool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--			WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
											--			WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
											--			WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
											--			END
											
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
														END
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										-- use ESOP share quantity pool ONLY
										ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
										BEGIN
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--			WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
											--			WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
											--			WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
											--			END
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										-- use Other share quantity pool ONLY
										ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
														END
											-- set quantity from pool
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									END
									ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
									BEGIN
										-- cash exercise transaction affect other pool quantity only
										SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceQuantity -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
									
									-- set quantity from pool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
								BEGIN
				
								   select @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id from tra_TransactionTypeSettings_OS where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeType and security_type_code_id = @nSecurityTypeCodeId
														   
								   IF(@nImptPostShareQtyCodeId = @nNo)						     
								   BEGIN
									   IF(@nActionCodeID = @nBuy)
									   BEGIN
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool								
											
											-- Pledge transaction affect pledge pool quantity only
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN -@nDifferenceQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN @nDifferenceQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
															END
											
										   SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									   END
									   ELSE IF(@nActionCodeID = @nSell)
									   BEGIN
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool									
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											
											-- Pledge transaction affect pledge pool quantity only
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
															END
																								  
										   SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									   END
									   ELSE
									   BEGIN
										-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool									
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
									   END	
								   END
								   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
								   BEGIN
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN -@nDifferenceQuantity -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN @nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
											
											-- set quantity from pool
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
								   END
								   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
								   BEGIN
										IF(@nContraTradeOption = @nContraTradeQuantityBase)
										BEGIN
											-- sell transaction can affect any pool depending on option set in trading policy
											-- check option set in trading policy for pool 
											
											-- use ESOP share quantity first then use Other share quantity
											IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
											BEGIN
												-- requested quantity is more than ESOP quantity in pool 
												--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
												--			WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
												--			WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
												--			WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
												--			END
												
												SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
															END
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
											-- use Other share quantity first then use ESOP share quantity
											ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
											BEGIN
												-- requested quantity is more than Others quantity in pool 
												SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
															END
												
												--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
												--		WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
												--		WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
												--		WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
												--		END
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
											-- user has define which share quantity to use
											ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
											BEGIN
											-- use both ESOP and Other share quantity pool 
											-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
											IF (@nOtherESOPExcerciseOptionQtyFlag = 1)
											BEGIN
												---- requested quantity is more than ESOP quantity in pool 
												--SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
												--			WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
												--			WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
												--			WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
												--			END
												
												SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
															END
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
											-- use ESOP share quantity pool ONLY
											--ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
											--BEGIN
											--	SET @nESOPQuanity = @nESOPQuanity_FromPool + CASE 
											--				WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceESOPQuantity -- under trade
											--				WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceESOPQuantity -- over trade
											--				WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceESOPQuantity -- same trade
											--				END
												
											--	-- set quantity from pool
											--	SET @nOtherQuantity = @nOtherQuantity_FromPool
											--	SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											--	SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											--END
											-- use Other share quantity pool ONLY
											ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
											BEGIN
												SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
															WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceOtherQuantity -- under trade
															WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceOtherQuantity -- over trade
															WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceOtherQuantity -- same trade
															END
												
												-- set quantity from pool
												--SET @nESOPQuanity = @nESOPQuanity_FromPool
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
										END
										END
										ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
										BEGIN
											-- cash exercise transaction affect other pool quantity only
											SET @nOtherQuantity = @nOtherQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
														END
										
										-- set quantity from pool
										--SET @nESOPQuanity = @nESOPQuanity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									ELSE
									BEGIN
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool									
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
							   END	
							END
						END
					
					END
					-- if pre clearance close without trading then reserve the pool quantity
					ELSE IF (@nPartiallyTradedFlag = 2)
					BEGIN
						
						SET @bChangePoolFlag = 1 -- set flag to insert/update record
						
						-- here preclearance request is made check security type and transaction type
						IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
						BEGIN
							-- buy transaction affect other pool quantity only
							SET @nOtherQuantity = @nOtherQuantity_FromPool - @nPCLOtherExcerciseOptionQty 
							
							-- set quantity from pool
							--SET @nESOPQuanity = @nESOPQuanity_FromPool
							SET @nPledgeQuantity = @nPledgeQuantity_FromPool
							SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						END
										
						ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
						BEGIN
							IF(@nContraTradeOption = @nContraTradeQuantityBase)
							BEGIN
								-- sell transaction can affect any pool depending on option set in trading policy
								-- check option set in trading policy for pool 
								
								-- use ESOP share quantity first then use Other share quantity
								IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
								BEGIN
									-- requested quantity is less than ESOP quantity in pool
									IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
									BEGIN
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty 
										
										-- set quantity from pool
										SET @nOtherQuantity = @nOtherQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									ELSE
									BEGIN
										-- requested quantity is more than ESOP quantity in pool 
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
										
										SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
										
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
								-- use Other share quantity first then use ESOP share quantity
								ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
								BEGIN
									-- requested quantity is less than Others quantity in pool
									IF (@nPCLSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
									BEGIN
										SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
														
										-- set quantity from pool
										--SET @nESOPQuanity = @nESOPQuanity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									ELSE
									BEGIN
										-- requested quantity is more than Others quantity in pool 
										SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
										
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
								-- user has define which share quantity to use
								ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
								BEGIN
									-- use both ESOP and Other share quantity pool 
									-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
									IF (@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
									BEGIN
										-- requested quantity is less than ESOP quantity in pool
										IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
										BEGIN
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
											
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										ELSE
										BEGIN
											-- requested quantity is more than ESOP quantity in pool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
											
											SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									-- use ESOP share quantity pool ONLY
									ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
									BEGIN
										--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
										
										-- set quantity from pool
										SET @nOtherQuantity = @nOtherQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
									-- use Other share quantity pool ONLY
									ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
									BEGIN
										SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
										
										-- set quantity from pool
										--SET @nESOPQuanity = @nESOPQuanity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
								END
							END
							ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
							BEGIN
								SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
								
								-- set quantity from pool
								--SET @nESOPQuanity = @nESOPQuanity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
						END
						ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
						BEGIN

						   select @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id from tra_TransactionTypeSettings_OS where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeType and security_type_code_id = @nSecurityTypeCodeId
												   
						   IF(@nImptPostShareQtyCodeId = @nNo)						     
						   BEGIN
							   IF(@nActionCodeID = @nBuy)
							   BEGIN
									-- set quantity from pool
									SET @nOtherQuantity = @nOtherQuantity_FromPool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									-- pledge transaction affect pledge pool quantity only
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool - @nPCLPledgeOptionQty
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
							   END
							   ELSE IF(@nActionCodeID = @nSell)
							   BEGIN
									-- set quantity from pool
									SET @nOtherQuantity = @nOtherQuantity_FromPool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool + @nPCLPledgeOptionQty
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
							   END
							   ELSE
							   BEGIN
								-- set quantity from pool
									SET @nOtherQuantity = @nOtherQuantity_FromPool									
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
							   END	
						   END
						   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
						   BEGIN									
									SET @nOtherQuantity = @nOtherQuantity_FromPool - @nPCLOtherExcerciseOptionQty 
									
									-- set quantity from pool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END
						   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
						   BEGIN
								IF(@nContraTradeOption = @nContraTradeQuantityBase)
								BEGIN
									-- sell transaction can affect any pool depending on option set in trading policy
									-- check option set in trading policy for pool 
									
									-- use ESOP share quantity first then use Other share quantity
									IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
									BEGIN
										-- requested quantity is less than ESOP quantity in pool
										IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
										BEGIN
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty 
											
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										ELSE
										BEGIN
											-- requested quantity is more than ESOP quantity in pool 
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
											
											SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
											
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									-- use Other share quantity first then use ESOP share quantity
									ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
									BEGIN
										-- requested quantity is less than Others quantity in pool
										IF (@nPCLSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
										BEGIN
											SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
															
											-- set quantity from pool
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										ELSE
										BEGIN
											-- requested quantity is more than Others quantity in pool 
											SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
											
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
									-- user has define which share quantity to use
									ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
									BEGIN
										-- use both ESOP and Other share quantity pool 
										-- since both pool has to use so use ESOP pool quantity and then Other pool quanatity
										IF (@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											-- requested quantity is less than ESOP quantity in pool
											IF (@nPCLSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
											BEGIN
												--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
												
												-- set quantity from pool
												SET @nOtherQuantity = @nOtherQuantity_FromPool
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
											ELSE
											BEGIN
												-- requested quantity is more than ESOP quantity in pool 
												--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
												
												SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
												SET @nPledgeQuantity = @nPledgeQuantity_FromPool
												SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
											END
										END
										-- use ESOP share quantity pool ONLY
										ELSE IF(@nESOPExcerciseOptionQtyFlag = 1 AND @nOtherESOPExcerciseOptionQtyFlag = 0)
										BEGIN
											--SET @nESOPQuanity = @nESOPQuanity_FromPool + @nPCLESOPExcerciseOptionQty
											
											-- set quantity from pool
											SET @nOtherQuantity = @nOtherQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
										-- use Other share quantity pool ONLY
										ELSE IF(@nESOPExcerciseOptionQtyFlag = 0 AND @nOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
											
											-- set quantity from pool
											--SET @nESOPQuanity = @nESOPQuanity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
									END
								END
								ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
								BEGIN
									SET @nOtherQuantity = @nOtherQuantity_FromPool + @nPCLOtherExcerciseOptionQty
									
									-- set quantity from pool
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
						   END
						   ELSE
							BEGIN
									-- set quantity from pool
									SET @nOtherQuantity = @nOtherQuantity_FromPool									
									--SET @nESOPQuanity = @nESOPQuanity_FromPool
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
						END	
					END
				END
				ELSE
				BEGIN
					-- Transcation submitted for PNT or period end
					print 'submitted for PNT or period end'
			
					
					-- process PNT and preiod end disclosure details
					IF (@bNoHoldingFlag = 0)
					BEGIN
							-- loop through all transaction details and update pool records is security type is share
						DECLARE @nTransactionDetailsId INT
						DECLARE @nTDSecurityTypeCodeID INT
						DECLARE @nQuantity DECIMAL(10,0)
						DECLARE @nQuantity2 DECIMAL(10,0)
						DECLARE @nModeOfAcquisitionCodeId INT
						DECLARE @LotSize INT
						DECLARE @nQuantityForOther INT
						DECLARE @nQuantityForPledge INT
						DECLARE @nQuantityForNotImpacted INT
						DECLARE @nQuantityForESOP INT
						
						DECLARE @nDematDetailsID INT
						DECLARE @TraDetail_Cursor CURSOR
						--set quantity
						SET @nOtherQuantity = @nOtherQuantity_FromPool 
						--SET @nESOPQuanity = @nESOPQuanity_FromPool					
						SET @nPledgeQuantity = isnull(@nPledgeQuantity_FromPool,0)
						SET @nNotImpactedQuantity = isnull(@nNotImpactedQuantity_FromPool,0)
							
						
								
						-- fetch all details for security type - share 
						SET @TraDetail_Cursor = CURSOR FOR 
							SELECT 
								TD.TransactionDetailsId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.Quantity, 
								 ModeOfAcquisitionCodeId, TD.LotSize,TD.DMATDetailsID
							FROM tra_TransactionDetails_OS TD JOIN 
							tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
								AND TM.TransactionMasterId = @inp_nTransactionMasterId
					
						OPEN @TraDetail_Cursor
						
						FETCH NEXT FROM @TraDetail_Cursor INTO 
							@nTransactionDetailsId, @nTDSecurityTypeCodeID, @nTransactionTypeCodeId, @nQuantity, @nQuantity2, 
							@nESOPExcerciseOptionQtyFlag, @nOtherESOPExcerciseOptionQtyFlag, @nTDESOPExcerciseOptionQty, @nTDOtherExcerciseOptionQty, @nModeOfAcquisitionCodeId, @LotSize,@nDematDetailsID
						
						WHILE @@FETCH_STATUS = 0
						BEGIN						

							SELECT @nESOPQuanity_FromPool = NULL, @nOtherQuantity_FromPool = NULL
							
							SELECT @nESOPQuanity_FromPool = ESOPQuantity, @nOtherQuantity_FromPool = OtherQuantity, @nPledgeQuantity_FromPool = PledgeQuantity, @nNotImpactedQuantity_FromPool = NotImpactedQuantity FROM tra_ExerciseBalancePool 
							WHERE UserInfoId = @nUserInfoId AND SecurityTypeCodeId = @nTDSecurityTypeCodeID AND DMATDetailsID = @nDematDetailsID
							
							--select @nTransactionDetailsId, @nESOPQuanity_FromPool as '@@nESOPQuanity_FromPool', @nOtherQuantity_FromPool as '@@nOtherQuantity_FromPool'
							
							-- check if record exists or not 
							IF (@nESOPQuanity_FromPool IS NULL AND @nOtherQuantity_FromPool IS NULL)
							BEGIN
								SET @nPoolActionFlag = 1 -- insert new record
								
								-- set quantity because there is nothing in pool
								SET @nESOPQuanity_FromPool = 0
								SET @nOtherQuantity_FromPool = 0
								SET @nPledgeQuantity_FromPool = 0
								SET @nNotImpactedQuantity_FromPool = 0
							END
							ELSE
							BEGIN
								SET @nPoolActionFlag = 2 -- update existing record
							END
							
							--print ' PoolActionFlag '+convert(varchar, @nPoolActionFlag) 
							--		+ '  ESOPQuanity_FromPool '+convert(varchar, @nESOPQuanity_FromPool)
							--		+ '  OtherQuantity_FromPool '+convert(varchar, @nOtherQuantity_FromPool)
							--		+ '  @nTransactionDetailsId '+convert(varchar, @nTransactionDetailsId)
							
							--set quantity
							SET @nOtherQuantity = @nOtherQuantity_FromPool 
							--SET @nESOPQuanity = @nESOPQuanity_FromPool
							SET @nPledgeQuantity = isnull(@nPledgeQuantity_FromPool,0)
							SET @nNotImpactedQuantity = isnull(@nNotImpactedQuantity_FromPool,0)
							
							--select top 1 @nQuantityForOther = nOtherQuantity, @nQuantityForPledge = nPledgeQuantity, @nQuantityForNotImpacted = nNotImpactedQuantity, @nQuantityForESOP = nESOPQuanity from uf_tra_GetOtherAndPledgeQuantity(isnull(@nOtherQuantity,0),isnull(@nPledgeQuantity,0),isnull(@nNotImpactedQuantity,0),@nTDOtherExcerciseOptionQty,@nModeOfAcquisitionCodeId,@nTransactionTypeCodeId,ISNULL(@nESOPQuanity,0),ISNULL(@nTDESOPExcerciseOptionQty,0),ISNULL(@nContraTradeOption,0),@nTDSecurityTypeCodeID,ISNULL(@LotSize,0))
							select top 1 @nQuantityForOther = nOtherQuantity, @nQuantityForPledge = nPledgeQuantity, @nQuantityForNotImpacted = nNotImpactedQuantity, @nQuantityForESOP = nESOPQuanity from uf_tra_GetOtherAndPledgeQuantity(isnull(@nOtherQuantity,0),isnull(@nPledgeQuantity,0),isnull(@nNotImpactedQuantity,0),@nTDOtherExcerciseOptionQty,@nModeOfAcquisitionCodeId,@nTransactionTypeCodeId,0,ISNULL(@nTDESOPExcerciseOptionQty,0),ISNULL(@nContraTradeOption,0),@nTDSecurityTypeCodeID,ISNULL(@LotSize,0))
														
							-- here preclearance request is made check security type and transaction type
							IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
							BEGIN
								-- buy transaction affect other pool quantity only								
								SET @nOtherQuantity = @nQuantityForOther
								SET @nPledgeQuantity = @nPledgeQuantity
								SET @nNotImpactedQuantity = @nQuantityForNotImpacted
								-- set quantity from pool 
								-- in case of initial disclosure add value set in details and in other case do not chagne quantity
								--SET @nESOPQuanity = CASE 
								--						WHEN @nDisclosureTypeCodeId = @nDislosureType_Initial
								--								THEN @nQuantityForESOP
								--						ELSE @nESOPQuanity 
								--					END												
							  
							END
						
							
							IF @nPoolActionFlag = 1 OR @nPoolActionFlag = 2 -- add new record
							BEGIN							
							--select @nUserInfoId AS '@nUserInfoId',@nDematDetailsID, @nTDSecurityTypeCodeID, @nESOPQuanity,@nOtherQuantity,@nPledgeQuantity,@nNotImpactedQuantity
							
							EXEC @nTmpRet = st_tra_UpdateBalancePoolDematwise_OS @nUserInfoId,@nDematDetailsID, @nTDSecurityTypeCodeID, @nOtherQuantity,@nOtherQuantity,@nPledgeQuantity,@nNotImpactedQuantity,
											@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
						
							IF @out_nReturnValue <> 0
							BEGIN
								SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
								RETURN @out_nReturnValue
							END
							
							END
							FETCH NEXT FROM @TraDetail_Cursor INTO 
								@nTransactionDetailsId, @nTDSecurityTypeCodeID, @nTransactionTypeCodeId, @nQuantity, @nQuantity2, 
								@nESOPExcerciseOptionQtyFlag, @nOtherESOPExcerciseOptionQtyFlag, @nTDESOPExcerciseOptionQty, @nTDOtherExcerciseOptionQty, @nModeOfAcquisitionCodeId, @LotSize,@nDematDetailsID
							
						END
						
						CLOSE @TraDetail_Cursor
						DEALLOCATE @TraDetail_Cursor;
					END
				END
				
			END
			ELSE
			BEGIN
				print 'NO ACTION'
			END
		
			IF @bChangePoolFlag = 1  -- check if pool need to be change
			BEGIN
				IF @nPoolActionFlag = 1 OR @nPoolActionFlag = 2 -- add new record
				BEGIN			
				
				EXEC @nTmpRet = st_tra_UpdateBalancePoolDematwise_OS @nUserInfoId,@nDMATDetailsID, @nTransaction_SecurityType, @nOtherQuantity,@nOtherQuantity,@nPledgeQuantity,@nNotImpactedQuantity,
											@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
						
				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
					RETURN @out_nReturnValue
				END
				END
			END
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_EXECISE_BALANCE_POOL_DETAILS_SAVE_FAIL, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

