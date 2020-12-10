IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ExerciseBalancePoolUpdateDetails_OS')
DROP PROCEDURE st_tra_ExerciseBalancePoolUpdateDetails_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save/update security balance details in pool

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		21-Feb-2019

Usage:
EXEC st_tra_ExerciseBalancePoolUpdateDetails_OS <user id> <security type>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_ExerciseBalancePoolUpdateDetails_OS]
	@inp_nMapToTypeCodeId					INT,
	@inp_nPreClearanceRequestId				INT = NULL,
	@inp_nTransactionMasterId				INT = NULL,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_EXECISE_BALANCE_POOL_DETAILS_SAVE_FAIL INT = 53005 -- Error occured while updating exercise pool
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
	DECLARE @nPreClrReasonForNonTradeReqFlag BIT
	DECLARE @nPreClrCompleteTradeNotDoneFlag BIT
	DECLARE @nPreClrPartialTradeNotDoneFlag BIT
	
	DECLARE @nDislosureType_Initial INT = 147001
	DECLARE @nDislosureType_Continuous INT = 147002
	DECLARE @nDislosureType_PeriodEnd INT = 147003
	
	DECLARE @nSecurityType_Share INT = 139001
	DECLARE @nSecurityType_Warrants INT = 139002
	DECLARE @nSecurityType_ConvertibleDebentures INT =139003
	
	DECLARE @nPreClearanceStatus_Reject INT = 144003
	
	DECLARE @nAction_PreclearanceRequest INT  = 132004
	DECLARE @nAction_DisclosureTransaction INT = 132005
	
	DECLARE @nVirtualQuantity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nActualQuantity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nPledgeQuantity_FromPool DECIMAL(15,4) = 0
	DECLARE @nNotImpactedQuantity_FromPool DECIMAL(15,4) = 0
	
	DECLARE @bChangePoolFlag BIT = 0 -- This flag is used to decide if insert/update flag base on transcation done
	DECLARE @nPoolActionFlag INT = 0 -- 0: NO Action, 1: Insert new record, 2: Update existing record
	
	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @nTransactionType_Pledge INT = 143006
	DECLARE @nTransactionType_PledgeRevoke INT = 143007
	DECLARE @nTransactionType_PledgeInvoke INT = 143008	
	
	DECLARE @nVirtualQuantity DECIMAL(15,4) = 0
	DECLARE @nActualQuantity DECIMAL(15,4) = 0
	DECLARE @nPledgeQuantity DECIMAL(15,4) = 0
	DECLARE @nNotImpactedQuantity DECIMAL(15,4) = 0
	
	DECLARE @nTDESOPExcerciseOptionQty DECIMAL(10,0) = 0
	DECLARE @nTDOtherExcerciseOptionQty DECIMAL(10,0) = 0
	
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
	DECLARE @nPCLCompanyID INT=NULL

	DECLARE @nUserType INT 
	DECLARE @nUserType_Relative INT = 101007
	DECLARE @nUserID INT 

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
		
		print 'in pool'
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
			@bNoHoldingFlag = NoHoldingFlag, @nPartiallyTradedFlag = IsPartiallyTraded, 
			@bShowPartialTradeBtn = ShowAddButton, @nPCLNotTradeCodeID = ReasonForNotTradingCodeId, @sPCLNotTradeReason = ReasonForNotTradingText,
			@nTradingPolicyId = TM.TradingPolicyId,
			@nExciseOptionForContraTrade = TP.GenCashAndCashlessPartialExciseOptionForContraTrade, 
			@nTransactionTypeCodeId = PCL.TransactionTypeCodeId, @nPCLSecurityTypeCodeId = PCL.SecurityTypeCodeId,
			@nPCLSecuritiesToBeTradedQty = PCL.SecuritiesToBeTradedQty, @nPCLOtherExcerciseOptionQty = PCL.OtherExcerciseOptionQty,
			@nPreclearanceStatusCodeId = PCL.PreclearanceStatusCodeId,
			@nPreClrReasonForNonTradeReqFlag = TP.PreClrReasonForNonTradeReqFlag, @nPreClrCompleteTradeNotDoneFlag = TP.PreClrCompleteTradeNotDoneFlag,
			@nPreClrPartialTradeNotDoneFlag = TP.PreClrPartialTradeNotDoneFlag, @nPCLPledgeOptionQty = PledgeOptionQty, @nModeOfAcquisitionCodeType = ModeOfAcquisitionCodeId,
			@nDMATDetailsID = PCL.DMATDetailsID, @nPCLCompanyID = PCL.CompanyId
		FROM tra_TransactionMaster_OS TM
		JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PCL ON TM.PreclearanceRequestId = PCL.PreclearanceRequestId
		WHERE 
			(@inp_nTransactionMasterId IS NOT NULL AND  TM.TransactionMasterId = @inp_nTransactionMasterId)
			OR (@inp_nPreClearanceRequestId IS NOT NULL AND TM.PreclearanceRequestId = @inp_nPreClearanceRequestId)
		
		--SELECT @nUserInfoId as '@nUserInfoId', @nDisclosureTypeCodeId as '@nDisclosureTypeCodeId', @nPreClearanceRequestId as '@nPreClearanceRequestId', 
		--		@nSecurityTypeCodeId as '@nSecurityTypeCodeId', @nTransactionStatusCodeId as '@nTransactionStatusCodeId', 
		--		@bNoHoldingFlag as '@bNoHoldingFlag', @nPartiallyTradedFlag as '@nPartiallyTradedFlag', 
		--		@bShowPartialTradeBtn as '@bShowPartialTradeBtn', @nPCLNotTradeCodeID as '@nPCLNotTradeCodeID', 
		--		@sPCLNotTradeReason as '@sPCLNotTradeReason', @nTradingPolicyId as '@nTradingPolicyId', 
		--		@nExciseOptionForContraTrade as '@nExciseOptionForContraTrade', @nTransactionTypeCodeId as '@nTransactionTypeCodeId', 
		--		@nPCLSecurityTypeCodeId as '@nPCLSecurityTypeCodeId', @nPCLSecuritiesToBeTradedQty as '@nPCLSecuritiesToBeTradedQty',
		--		@nPCLESOPExcerciseOptionQty as '@nPCLESOPExcerciseOptionQty', @nPCLOtherExcerciseOptionQty as '@nPCLOtherExcerciseOptionQty', 
		--		@nPreclearanceStatusCodeId as '@nPreclearanceStatusCodeId', 
		--		@nPreClrReasonForNonTradeReqFlag as '@nPreClrReasonForNonTradeReqFlag', 
		--		@nPreClrCompleteTradeNotDoneFlag as '@nPreClrCompleteTradeNotDoneFlag', 
		--		@nPreClrPartialTradeNotDoneFlag as '@nPreClrPartialTradeNotDoneFlag'
		
		--print '@nMapToTypeCodeId '+convert(varchar, ISNULL(@inp_nMapToTypeCodeId,-1))

		
			SELECT @nUserType = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @nUserInfoId
			IF @nUserType = @nUserType_Relative
			BEGIN
				SELECT @nUserID = UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative = @nUserInfoId
				SET @nUserInfoId = @nUserID
			END
		
		IF (@inp_nMapToTypeCodeId IS NOT NULL)
		BEGIN
			-- set transaction security type
			SELECT @nTransaction_SecurityType = CASE 
													WHEN @inp_nMapToTypeCodeId = @nAction_PreclearanceRequest THEN @nPCLSecurityTypeCodeId
													ELSE @nSecurityTypeCodeId 
												END
		
			SELECT @nVirtualQuantity_FromPool = VirtualQuantity, @nActualQuantity_FromPool = ActualQuantity, 
			@nPledgeQuantity_FromPool = isnull(PledgeQuantity,0), @nNotImpactedQuantity_FromPool = isnull(NotImpactedQuantity,0) 
			FROM tra_BalancePool_OS 
			WHERE UserInfoId = @nUserInfoId AND SecurityTypeCodeId = @nTransaction_SecurityType AND DMATDetailsID = @nDMATDetailsID AND CompanyID = @nPCLCompanyID
			
			-- check if record exists or not 
			IF (@nVirtualQuantity_FromPool IS NULL AND @nActualQuantity_FromPool IS NULL)
			BEGIN
				-- set quantity because there is nothing in pool
				SET @nVirtualQuantity_FromPool = 0
				SET @nActualQuantity_FromPool = 0
			END
			
			--print '@nESOPQuanity_FromPool '+convert(varchar, ISNULL(@nESOPQuanity_FromPool,-1)) 
			--		+ ' @nOtherQuantity_FromPool ' +convert(varchar, ISNULL(@nOtherQuantity_FromPool,-1))
			--print '@nPCLESOPExcerciseOptionQty '+convert(varchar, ISNULL(@nESOPExcerciseOptionQty,-1)) 
			--		+ ' @nPCLOtherExcerciseOptionQty ' +convert(varchar, ISNULL(@nOtherExcerciseOptionQty,-1))
			
			
			IF (@inp_nMapToTypeCodeId = @nAction_PreclearanceRequest)
			BEGIN
				print 'Preclearance Request - '
				
				SET @bChangePoolFlag = 1 -- set flag to insert/update record
					
				-- here preclearance request is made check security type and transaction type
				IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
				BEGIN
					-- buy transaction affect other pool quantity only
					SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
											WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLOtherExcerciseOptionQty 
											ELSE @nPCLOtherExcerciseOptionQty END 
					
					-- set quantity from pool
					SET @nActualQuantity = @nActualQuantity_FromPool
					SET @nPledgeQuantity = @nPledgeQuantity_FromPool
					SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
				END
				ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
				BEGIN
					SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
												WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
												ELSE -@nPCLOtherExcerciseOptionQty END
							-- set quantity from pool
					SET @nActualQuantity = @nActualQuantity_FromPool
					SET @nPledgeQuantity = @nPledgeQuantity_FromPool
					SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
				END
				ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
				BEGIN
					SELECT @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id FROM tra_TransactionTypeSettings_OS 
					WHERE trans_type_code_id = @nTransactionTypeCodeId AND mode_of_acquis_code_id = @nModeOfAcquisitionCodeType AND security_type_code_id = @nSecurityTypeCodeId
											   
					   IF(@nImptPostShareQtyCodeId = @nNo)						     
					   BEGIN
						   IF(@nActionCodeID = @nBuy)
						   BEGIN
								-- set quantity from pool
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool
								SET @nActualQuantity = @nActualQuantity_FromPool
								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLPledgeOptionQty 
														ELSE @nPCLPledgeOptionQty END 
														
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END
						   ELSE IF(@nActionCodeID = @nSell)
						   BEGIN
								-- set quantity from pool
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool
								SET @nActualQuantity = @nActualQuantity_FromPool
								
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLPledgeOptionQty 
														ELSE -@nPCLPledgeOptionQty END 
													
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END
						   ELSE
						   BEGIN
								-- set quantity from pool
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool
								SET @nActualQuantity = @nActualQuantity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
						   END	
					   END
					   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
					   BEGIN
							SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
													WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN -@nPCLOtherExcerciseOptionQty 
													ELSE @nPCLOtherExcerciseOptionQty END 
							
							-- set quantity from pool
							SET @nActualQuantity = @nActualQuantity_FromPool
							SET @nPledgeQuantity = @nPledgeQuantity_FromPool
							SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
					   END
					   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
					   BEGIN
							SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
														WHEN @nPreclearanceStatusCodeId = @nPreClearanceStatus_Reject THEN @nPCLOtherExcerciseOptionQty 
														ELSE -@nPCLOtherExcerciseOptionQty END
									-- set quantity from pool
							SET @nActualQuantity = @nActualQuantity_FromPool
							SET @nPledgeQuantity = @nPledgeQuantity_FromPool
							SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
					   END
					   ELSE
					   BEGIN
								-- set quantity from pool
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool
								SET @nActualQuantity = @nActualQuantity_FromPool
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
						DECLARE @nIsUnderOROverTraded INT = 0 -- 0 : no action, 1 : under traded, 2 : over traded, 3 : same quantity
						DECLARE @nDifferenceQuantity INT = 0
						DECLARE @nDifferenceOtherQuantity DECIMAL(15,4) = 0
						DECLARE @nSingleTradedQuantity DECIMAL(10,0) = 0
						DECLARE @nPreviousTransactionID INT
						
						IF @nSecurityTypeCodeId in(@nSecurityType_Share,@nSecurityType_Warrants,@nSecurityType_ConvertibleDebentures)
						BEGIN
							SELECT 
								@nTradedQuantity = SUM(TD.Quantity)
							FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
									AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId
							GROUP BY tm.PreclearanceRequestId
						END
						ELSE
						BEGIN 
							SELECT 
								@nTradedQuantity = SUM(TD.Quantity * TD.LotSize)
							FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
									AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId
							GROUP BY tm.PreclearanceRequestId
						END

						SELECT TOP 1 @nPreviousTransactionID = TM.TransactionMasterId FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
									AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId AND TM.PartiallyTradedFlag = 1
									WHERE TD.TransactionMasterId < @inp_nTransactionMasterId ORDER BY TD.TransactionMasterId DESC

						print '@nPreviousTransactionID'
						print @nPreviousTransactionID
						print '@nTradedQuantity'
						print @nTradedQuantity
						-- check if pre-clearance is close -- partial traded and close with reason, OR overtraded OR traded same quantity
						-- in case of same quantity traded, pool affect only when cashless partial exercise is done 
						--IF (@nPCLNotTradeCodeID IS NOT NULL OR @nPCLSecuritiesToBeTradedQty <= @nTradedQuantity)
						--BEGIN 
							-- set flag if transcation is under traded or over traded 
							IF (@nPCLSecuritiesToBeTradedQty < @nTradedQuantity)
							BEGIN
								SET @nIsUnderOROverTraded = 2 -- over traded
								
								--set difference
								SET @nDifferenceQuantity = @nTradedQuantity - @nPCLSecuritiesToBeTradedQty
							END
							ELSE IF (@nPCLSecuritiesToBeTradedQty > @nTradedQuantity)
							BEGIN
								SET @nIsUnderOROverTraded = 1 -- under traded
								
								--set difference
								SET @nDifferenceQuantity = @nPCLSecuritiesToBeTradedQty - @nTradedQuantity
							END
							ELSE IF (@nPCLSecuritiesToBeTradedQty = @nTradedQuantity)
							BEGIN
								SET @nIsUnderOROverTraded = 3 -- same quantity traded
								--set difference
								SET @nDifferenceQuantity = 0
							END
							print '@nIsUnderOROverTraded'
							print @nIsUnderOROverTraded
							print '@nDifferenceQuantity'
							print @nDifferenceQuantity
							-- check if there is difference in traded quantity and preclarance quantity 
							IF(@nIsUnderOROverTraded <> 0)
							BEGIN
								SET @bChangePoolFlag = 1 -- set flag to insert/update record
								
								print '@nActualQuantity_FromPool'
								print @nActualQuantity_FromPool
								print @nPCLSecuritiesToBeTradedQty
								-- here preclearance request is made check security type and transaction type
								IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
								BEGIN 
									-- buy transaction affect other pool quantity only
									SELECT @nSingleTradedQuantity = TD.Quantity
											FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
												AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId
												AND TD.TransactionDetailsId = (SELECT MAX(TransactionDetailsId) FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
												AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId)
									
									SET @nActualQuantity = CASE WHEN @nIsUnderOROverTraded= 1 THEN CASE WHEN @nPCLNotTradeCodeID IS NOT NULL THEN @nActualQuantity_FromPool ELSE @nActualQuantity_FromPool + @nSingleTradedQuantity END
																	WHEN @nIsUnderOROverTraded = 2 THEN @nActualQuantity_FromPool + @nSingleTradedQuantity -- over trade
																	WHEN @nIsUnderOROverTraded = 3 THEN @nActualQuantity_FromPool + @nSingleTradedQuantity
																END
																					
									-- set quantity from pool
									SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN CASE WHEN @nPCLNotTradeCodeID IS NOT NULL THEN -@nDifferenceQuantity ELSE - 0 END -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN @nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
								BEGIN print 'sell'
								SELECT @nSingleTradedQuantity = TD.Quantity
											FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
												AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId
												AND TD.TransactionDetailsId = (SELECT MAX(TransactionDetailsId) FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
												AND tm.PreclearanceRequestId = @nPreClearanceRequestId AND td.SecurityTypeCodeId = @nSecurityTypeCodeId)
										print'@nSingleTradedQuantity'
										print @nSingleTradedQuantity
										IF @nIsUnderOROverTraded = 1
										BEGIN
											SET @nActualQuantity = CASE WHEN @nPCLNotTradeCodeID IS NOT NULL THEN @nActualQuantity_FromPool ELSE @nActualQuantity_FromPool - @nSingleTradedQuantity END-- under trade
										END
										ELSE
										BEGIN
											IF(@nPreviousTransactionID <> @inp_nTransactionMasterId)--check prev transaction id is diff means its partiallytraded transaction
											BEGIN
												SET @nActualQuantity = @nActualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 2 THEN -@nSingleTradedQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN -@nSingleTradedQuantity -- same trade
													END
											END
											ELSE
											BEGIN
												SET @nActualQuantity = @nActualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 2 THEN -@nTradedQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN -@nTradedQuantity -- same trade
													END
											END
										END
									-- set quantity from pool
									SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN CASE WHEN @nPCLNotTradeCodeID IS NOT NULL THEN  @nDifferenceQuantity ELSE 0 END-- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
									SET @nPledgeQuantity = @nPledgeQuantity_FromPool
									SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
								BEGIN
								   SELECT @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id FROM tra_TransactionTypeSettings_OS 
								   WHERE trans_type_code_id = @nTransactionTypeCodeId AND mode_of_acquis_code_id = @nModeOfAcquisitionCodeType AND security_type_code_id = @nSecurityTypeCodeId
														   
								   IF(@nImptPostShareQtyCodeId = @nNo)						     
								   BEGIN 
									   IF(@nActionCodeID = @nBuy)
									   BEGIN
											-- set quantity from pool
											SET @nVirtualQuantity = @nVirtualQuantity_FromPool 
											SET @nActualQuantity = @nActualQuantity_FromPool								
											
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
											SET @nVirtualQuantity = @nVirtualQuantity_FromPool 
											SET @nActualQuantity = @nActualQuantity_FromPool	
											
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
											SET @nVirtualQuantity = @nVirtualQuantity_FromPool 
											SET @nActualQuantity = @nActualQuantity_FromPool	
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
									   END	
								   END
								   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
								   BEGIN 
											SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN -@nDifferenceQuantity -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN @nDifferenceQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
													END
											SET @nActualQuantity = @nActualQuantity_FromPool + CASE 
													WHEN @nIsUnderOROverTraded = 1 THEN -@nTradedQuantity -- under trade
													WHEN @nIsUnderOROverTraded = 2 THEN @nTradedQuantity -- over trade
													WHEN @nIsUnderOROverTraded = 3 THEN @nTradedQuantity -- same trade
													END
											-- set quantity from pool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
								   END
								   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
								   BEGIN 
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nDifferenceQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nDifferenceQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN @nDifferenceQuantity -- same trade
														END
										SET @nActualQuantity = @nActualQuantity_FromPool + CASE 
														WHEN @nIsUnderOROverTraded = 1 THEN @nTradedQuantity -- under trade
														WHEN @nIsUnderOROverTraded = 2 THEN -@nTradedQuantity -- over trade
														WHEN @nIsUnderOROverTraded = 3 THEN -@nTradedQuantity -- same trade
														END
										-- set quantity from pool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
										END
								   ELSE
								   BEGIN
											-- set quantity from pool
											SET @nVirtualQuantity = @nVirtualQuantity_FromPool 
											SET @nActualQuantity = @nActualQuantity_FromPool
											SET @nPledgeQuantity = @nPledgeQuantity_FromPool
											SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
								   END
							   END	
							END
					-- if pre clearance close without trading then reserve the pool quantity
					END
					ELSE IF (@nPartiallyTradedFlag = 2)
					BEGIN
							SET @bChangePoolFlag = 1 -- set flag to insert/update record
						
							-- here preclearance request is made check security type and transaction type
							IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
							BEGIN
								-- buy transaction affect other pool quantity only
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool - @nPCLOtherExcerciseOptionQty 
							
								-- set quantity from pool
								SET @nActualQuantity = @nActualQuantity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
							ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
							BEGIN
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool + @nPCLOtherExcerciseOptionQty
									-- set quantity from pool
								SET @nActualQuantity = @nActualQuantity_FromPool
								SET @nPledgeQuantity = @nPledgeQuantity_FromPool
								SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
							ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
							BEGIN

							   select @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id from tra_TransactionTypeSettings_OS where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeType and security_type_code_id = @nSecurityTypeCodeId
												   
							   IF(@nImptPostShareQtyCodeId = @nNo)						     
							   BEGIN
								   IF(@nActionCodeID = @nBuy)
								   BEGIN
										-- set quantity from pool
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool
										SET @nActualQuantity = @nActualQuantity_FromPool
										-- pledge transaction affect pledge pool quantity only
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool - @nPCLPledgeOptionQty
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
								   END
								   ELSE IF(@nActionCodeID = @nSell)
								   BEGIN
										-- set quantity from pool
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool
										SET @nActualQuantity = @nActualQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool + @nPCLPledgeOptionQty
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
								   END
								   ELSE
								   BEGIN
									-- set quantity from pool
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool
										SET @nActualQuantity = @nActualQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool	
								   END	
							   END
							   ELSE IF(@nImptPostShareQtyCodeId = @nAdd)
							   BEGIN									
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool - @nPCLOtherExcerciseOptionQty 
									
										-- set quantity from pool
										SET @nActualQuantity = @nActualQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							   END
							   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
							   BEGIN
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool + @nPCLOtherExcerciseOptionQty
									
										-- set quantity from pool
										SET @nActualQuantity = @nActualQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
									END
							   END
							ELSE
							BEGIN
										-- set quantity from pool
										SET @nVirtualQuantity = @nVirtualQuantity_FromPool
										SET @nActualQuantity = @nActualQuantity_FromPool
										SET @nPledgeQuantity = @nPledgeQuantity_FromPool
										SET @nNotImpactedQuantity = @nNotImpactedQuantity_FromPool
							END
					END
				END
				ELSE
				BEGIN
						-- Transcation submitted for PNT or period end
						print 'submitted for PNT or period end'
					
						-- commented following because use current trading policy and not PE applicable trading policy
						---- in case of period end disclosure fetch trading policy applicable from tra_userperiodendmapping table
						--IF (@nDisclosureTypeCodeId = @nDislosureType_PeriodEnd)
						--BEGIN
						--	SELECT 
						--		@nTradingPolicyId = UPEMap.TradingPolicyId, 
						--		@nExciseOptionForContraTrade = TP.GenCashAndCashlessPartialExciseOptionForContraTrade
						--	FROM tra_TransactionMaster TM 
						--	JOIN tra_UserPeriodEndMapping UPEMap ON TM.PeriodEndDate = UPEMap.PEEndDate AND TM.TransactionMasterId = @inp_nTransactionMasterId
						--	JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
						--END
					
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
							DECLARE @nQuantityForVirtual INT
							DECLARE @nQuantityForActual INT
							DECLARE @nQuantityForPledge INT
							DECLARE @nQuantityForNotImpacted INT
							DECLARE @nQuantityForESOP INT
						
							DECLARE @nDematDetailsID INT
							DECLARE @nCompanyID INT=NULL
							DECLARE @TraDetail_Cursor CURSOR
							--set quantity
							SET @nVirtualQuantity = @nVirtualQuantity_FromPool
							SET @nActualQuantity = @nActualQuantity_FromPool					
							SET @nPledgeQuantity = isnull(@nPledgeQuantity_FromPool,0)
							SET @nNotImpactedQuantity = isnull(@nNotImpactedQuantity_FromPool,0)
							
						
								
							-- fetch all details for security type - share 
							SET @TraDetail_Cursor = CURSOR FOR 
								SELECT 
									TD.TransactionDetailsId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.Quantity, 
									OtherExcerciseOptionQty, ModeOfAcquisitionCodeId, TD.LotSize,TD.DMATDetailsID, TD.CompanyId
								FROM tra_TransactionDetails_OS TD JOIN 
								tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId 
									AND TM.TransactionMasterId = @inp_nTransactionMasterId
					
							OPEN @TraDetail_Cursor
						
							FETCH NEXT FROM @TraDetail_Cursor INTO 
								@nTransactionDetailsId, @nTDSecurityTypeCodeID, @nTransactionTypeCodeId, @nQuantity, 
								@nTDOtherExcerciseOptionQty, @nModeOfAcquisitionCodeId, @LotSize,@nDematDetailsID, @nCompanyID
						
							WHILE @@FETCH_STATUS = 0
							BEGIN
														
								--print 'TransactionMasterId '+convert(varchar, @inp_nTransactionMasterId) 							 
								--		+ '  @nTransactionDetailsId '+convert(varchar, @nTransactionDetailsId)
								--select @nTransactionDetailsId as 'TD id', @nTDSecurityTypeCodeID, @nTransactionTypeCodeId, @nQuantity, @nQuantity2, 
								--		@nTransactionTypeCodeId, @nQuantity, @nQuantity2, 
								--		@nESOPExcerciseOptionQtyFlag, @nOtherESOPExcerciseOptionQtyFlag, @nTDESOPExcerciseOptionQty, 
								--		@nTDOtherExcerciseOptionQty,@nDematDetailsID AS '@nDematDetailsID'

								SELECT @nVirtualQuantity_FromPool = NULL, @nActualQuantity_FromPool = NULL
							
								SELECT @nVirtualQuantity_FromPool = VirtualQuantity, @nActualQuantity_FromPool = ActualQuantity, @nPledgeQuantity_FromPool = PledgeQuantity, @nNotImpactedQuantity_FromPool = NotImpactedQuantity 
								FROM tra_BalancePool_OS 
								WHERE UserInfoId = @nUserInfoId AND SecurityTypeCodeId = @nTDSecurityTypeCodeID AND DMATDetailsID = @nDematDetailsID AND CompanyID = @nCompanyID
							
								--select @nTransactionDetailsId, @nESOPQuanity_FromPool as '@@nESOPQuanity_FromPool', @nOtherQuantity_FromPool as '@@nOtherQuantity_FromPool'
							
								-- check if record exists or not 
								IF (@nVirtualQuantity_FromPool IS NULL AND @nActualQuantity_FromPool IS NULL)
								BEGIN
									-- set quantity because there is nothing in pool
									SET @nVirtualQuantity_FromPool = 0
									SET @nActualQuantity_FromPool = 0
									SET @nPledgeQuantity_FromPool = 0
									SET @nNotImpactedQuantity_FromPool = 0
								END
							
								--print ' PoolActionFlag '+convert(varchar, @nPoolActionFlag) 
								--		+ '  ESOPQuanity_FromPool '+convert(varchar, @nESOPQuanity_FromPool)
								--		+ '  OtherQuantity_FromPool '+convert(varchar, @nOtherQuantity_FromPool)
								--		+ '  @nTransactionDetailsId '+convert(varchar, @nTransactionDetailsId)
							
								--set quantity
								SET @nVirtualQuantity = @nVirtualQuantity_FromPool
								SET @nActualQuantity = @nActualQuantity_FromPool
								SET @nPledgeQuantity = isnull(@nPledgeQuantity_FromPool,0)
								SET @nNotImpactedQuantity = isnull(@nNotImpactedQuantity_FromPool,0)

								if(@nDisclosureTypeCodeId = @nDislosureType_Initial)
								BEGIN
									SET @nTransactionTypeCodeId = 143001
								END
							
								select top 1 @nQuantityForVirtual = nVirtualQuantity, @nQuantityForActual = nActualQuantity, @nQuantityForPledge = nPledgeQuantity, @nQuantityForNotImpacted = nNotImpactedQuantity
								from uf_tra_GetOtherAndPledgeQuantity_OS(isnull(@nVirtualQuantity,0),isnull(@nActualQuantity,0),isnull(@nPledgeQuantity,0),isnull(@nNotImpactedQuantity,0),@nTDOtherExcerciseOptionQty,@nModeOfAcquisitionCodeId,@nTransactionTypeCodeId,@nTDSecurityTypeCodeID,ISNULL(@LotSize,0))
														
								-- here preclearance request is made check security type and transaction type
								IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
								BEGIN
									-- buy transaction affect other pool quantity only								
									SET @nVirtualQuantity = @nQuantityForVirtual
									SET @nActualQuantity = @nQuantityForActual
									SET @nPledgeQuantity = @nPledgeQuantity
									SET @nNotImpactedQuantity = @nQuantityForNotImpacted
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
								BEGIN
										SET @nVirtualQuantity = @nQuantityForVirtual
										SET @nActualQuantity = @nQuantityForActual
										SET @nPledgeQuantity = @nPledgeQuantity
										SET @nNotImpactedQuantity = @nQuantityForNotImpacted
								END
								ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Pledge OR @nTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @nTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
								BEGIN
										-- Pledge transaction type affect the pledge pool quantity only																
										SET @nVirtualQuantity = @nQuantityForVirtual
										SET @nActualQuantity = @nQuantityForActual
										SET @nPledgeQuantity = @nQuantityForPledge
										SET @nNotImpactedQuantity = @nNotImpactedQuantity
								END
								IF(@nCompanyID IS NOT NULL OR @nCompanyID='')
								BEGIN
								EXEC @nTmpRet = st_tra_UpdateBalancePoolDematwise_OS @nUserInfoId, @nDematDetailsID, @nCompanyID, @nTDSecurityTypeCodeID, @nVirtualQuantity,@nActualQuantity,@nPledgeQuantity,@nNotImpactedQuantity,
												@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
								END
						
								IF @out_nReturnValue <> 0
								BEGIN
									SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
									RETURN @out_nReturnValue
								END
							
								FETCH NEXT FROM @TraDetail_Cursor INTO 
									@nTransactionDetailsId, @nTDSecurityTypeCodeID, @nTransactionTypeCodeId, @nQuantity, 
									@nTDOtherExcerciseOptionQty, @nModeOfAcquisitionCodeId, @LotSize,@nDematDetailsID,@nCompanyID
							
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
			
			print '@bChangePoolFlag '+convert(varchar, @bChangePoolFlag)
					+' @nUserInfoId '+convert(varchar, @nUserInfoId)+' @nSecurityType_Share '+convert(varchar, @nSecurityType_Share)
					+' @nVirtualQuantity '+convert(varchar, ISNULL(@nVirtualQuantity,-1))+' @nActualQuantity '+convert(varchar, ISNULL(@nActualQuantity,-1))
					+' @nPledgeQuantity '+convert(varchar, ISNULL(@nPledgeQuantity,-1))
			
			 --check flag
			 IF @bChangePoolFlag = 1
			 BEGIN
				IF(@nPCLCompanyID IS NOT NULL OR @nPCLCompanyID='')
				BEGIN
						EXEC @nTmpRet = st_tra_UpdateBalancePoolDematwise_OS @nUserInfoId,@nDMATDetailsID,@nPCLCompanyID, @nTransaction_SecurityType, @nVirtualQuantity,@nActualQuantity,@nPledgeQuantity,@nNotImpactedQuantity,
											@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
				END
			 END
						
			IF @out_nReturnValue <> 0
			BEGIN
				SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
				RETURN @out_nReturnValue
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

