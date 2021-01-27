IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestNonImplCompanySaveValidations')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanySaveValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the PreclearanceRequest details for non implementing company

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		22-Feb-2019

Modification History:
Modified By		Modified On		Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanySaveValidations] 
	@inp_nPreclearanceRequestId					BIGINT,
	@inp_iTradingPolicyId						INT,
	@inp_iUserInfoId							INT,
	@inp_iUserInfoIdRelative                    INT,
	@inp_iTransactionTypeCodeId					INT,
	@inp_iSecurityTypeCodeId					INT,
	@inp_dSecuritiesToBeTradedQty				DECIMAL(15,4),
	@inp_dSecuritiesToBeTradedValue				DECIMAL(15,4),
	@inp_iCompanyId								INT,
	@inp_iModeOfAcquisitionCodeId               INT,
	@inp_iDMATDetailsID							INT,
	@inp_DisplaySequenceNo						INT=0,
	@out_bIsContraTrade							BIT = 0 OUTPUT,
	@out_sContraTradeTillDate				    NVARCHAR(500) OUTPUT,
	@out_iIsAutoApproved                        BIT = 0 OUTPUT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @nContraTradeOption                     INT
	DECLARE @nTmpRet                                INT = 0
	DECLARE @out_dtContraTradeTillDate				DATETIME
	DECLARE @nTradingPolicyID						INT
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT
	DECLARE @nTP_PreClrTradesApprovalReqFlag							INT
	DECLARE @nTP_PreClrAllowNewForOpenPreclearFlag						INT
	DECLARE @nTP_AutoAprReqForBelowEnteredValue							INT
	DECLARE @nTP_PreclearanceRequestSingleOrMultiple					INT
	DECLARE @nTP_PreClrApprovalPreclearORPreclearTradeFlag				INT -- 0=Preclearance details, 1=Preclearance and Trade details
	DECLARE @nTP_PreClrForAllSecuritiesFlag								INT -- 0: For selected securities, 1: For ALL securities
	DECLARE @ERR_PRECLEARANCE_REQUESTED									INT = 17383 --? Cannot save new preclearance request, as a preclearance is already requested and not yet approved.
	DECLARE @ERR_PRECLEARANCE_OPEN										INT = 17384 --? Earlier preclearance request is not yet closed. Close the preclearance request by providing all details or reason for Not/partial trading.
	DECLARE @nPeriodType INT

	DECLARE @nTransactionMode_MapToTypeCode_PreclearnaceOS INT = 132015
	DECLARE @nUserSelectionOnPreClearanceAndTradeDetailsSubmission	INT = 172003

	DECLARE @nTransactionMode_Buy						INT = 143001
	DECLARE @nTransactionMode_Sell						INT = 143002
	DECLARE @nTransactionMode_Cash_Exercise				INT = 143003
	DECLARE @nTranscationMode_Cashless_Partial			INT = 143005
	DECLARE @nTranscationMode_Pledge                    INT = 143006
	DECLARE @nTranscationMode_PledgeRevoke              INT = 143007
	DECLARE @nTranscationMode_PledgeInvoke              INT = 143008

	DECLARE @nSecurityType_Share						INT = 139001
	DECLARE @nDisclosureStatusConfirmed                 INT = 148003
	DECLARE @nDisclosureTypeContinuous                  INT = 147002
	DECLARE @nVirtualQuantity                       INT = 0
	DECLARE @nActualQuantity                        INT = 0
	DECLARE @nPledgeQuantity                            INT = 0
	DECLARE @nImptPostShareQtyCodeId INT
	DECLARE @nActionCodeID INT

	DECLARE @nPCLStatusCode_Requested									INT = 144001
	DECLARE @nPCLStatusCode_Approved									INT = 144002
	DECLARE @nPCLStatusCode_Rejected									INT = 144003
	--Impact on Post Share quantity	
    DECLARE @nLess INT = 505002    
    DECLARE @nNo   INT = 505004
	--Action 
	DECLARE @nBuy INT = 504001
    DECLARE @nSell INT = 504002
	--Error Codes
	DECLARE @ERR_CONTRATRADEOCCURED				    INT = 53002
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND             INT = 53003
	DECLARE @ERR_PRECLEARANCENOTNEEDED              INT = 53004
	DECLARE @ERR_PRECLEARANCE_NOT_ALLOWED_PeriodEndDISC_NOT_SUBMITTED  INT = 53031
	DECLARE @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY		INT = 53032
	DECLARE @ERR INT = 0
	DECLARE @ERR_ContinuousDisclosureforDupPNTEntry INT = 52086
	DECLARE @ERR_InitialDisclosureforRelative INT = 53094
	DECLARE @ERR_PRECLEARANCENOTNEEDED_VALUESWITHINLIMIT INT = 53097

	DECLARE @nSecurityQtyLimit							DECIMAL(15,4)
	DECLARE @nSecurityValueLimit						DECIMAL(15,4)
	
	DECLARE @nSubCapital								DECIMAL(25,4)
	DECLARE @nPerOfSubCapital							DECIMAL(25,4)

	DECLARE @bIsWithinLimits							BIT
	DECLARE @bWithinLimit								BIT = 1
	DECLARE @bNotWithinLimit							BIT = 0
	SET @out_iIsAutoApproved = 0
	--Temp tables
	CREATE TABLE #tmpTrading(ApplicabilityMstId INT,UserInfoId INT,MapToId INT)

	BEGIN TRY
		SET NOCOUNT ON;
				
		IF @inp_nPreclearanceRequestId <> 0
		BEGIN
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue
		END
		
		SELECT 1 --Petapoco
		
		IF @inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0
		BEGIN
			--Call Contra Trade check
			EXEC @nTmpRet = st_tra_TransactionCheckForContraTrade_OS @inp_iUserInfoID, @inp_iTransactionTypeCodeID,@inp_iSecurityTypeCodeId,@inp_iModeOfAcquisitionCodeId,@inp_iDMATDetailsID,
			@inp_iCompanyID,@out_bIsContraTrade OUTPUT,@out_dtContraTradeTillDate OUTPUT,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
			IF @out_nReturnValue <> 0
			BEGIN 
				SET @out_nReturnValue = @out_nReturnValue --@ERR_TRANSACTIONMASTER_SAVE
				RETURN @out_nReturnValue
			END
			
			IF(@out_bIsContraTrade = 1)
			BEGIN 
				SET @out_sContraTradeTillDate = (SELECT dbo.uf_rpt_FormatDateValue(@out_dtContraTradeTillDate,0))
				SET @out_nReturnValue = @ERR_CONTRATRADEOCCURED				
				RETURN (@out_nReturnValue)	
			END
			--End Here
		END 
		--Get Applicable Trading Policy	
		INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
		SELECT * FROM vw_ApplicableTradingPolicyForUser_OS
		
		SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0) 
		FROM #tmpTrading  
		WHERE UserInfoId = @inp_iUserInfoId
		
		---- Check If any applicable policy apply for that user if no then give error message ----
		IF @nTradingPolicyID = 0 AND (@inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0)
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
			RETURN (@out_nReturnValue)				
		END

		SELECT @nTP_PreClrTradesApprovalReqFlag = PreClrTradesApprovalReqFlag,
			@nTP_PreClrAllowNewForOpenPreclearFlag = PreClrAllowNewForOpenPreclearFlag,
			@nPeriodType = PreClrMultipleAboveInCodeId,
			@nTP_AutoAprReqForBelowEnteredValue = PreClrTradesAutoApprovalReqFlag,
			@nTP_PreclearanceRequestSingleOrMultiple = PreClrSingMultiPreClrFlagCodeId,
			@nTP_PreClrForAllSecuritiesFlag = PreClrForAllSecuritiesFlag,
			@nTP_PreClrApprovalPreclearORPreclearTradeFlag = PreClrApprovalPreclearORPreclearTradeFlag,
			@nGenCashAndCashlessPartialExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade
		FROM rul_TradingPolicy_OS
		WHERE TradingPolicyId = @inp_iTradingPolicyId

		DECLARE @out_nIsPreviousPeriodEndSubmission INT
		DECLARE @out_sSubsequentPeriodEndOrPreciousPeriodEndResource nvarchar(500)
		DECLARE @out_sSubsequentPeriodEndResourceOtherSecurity NVARCHAR(500)
				
		EXEC @nTmpRet = st_tra_CheckPreviousPeriodEndSubmission_OS @inp_iUserInfoID,@out_nIsPreviousPeriodEndSubmission OUTPUT,@out_sSubsequentPeriodEndOrPreciousPeriodEndResource OUTPUT,
							@out_sSubsequentPeriodEndResourceOtherSecurity OUTPUT,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue --@ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		ELSE
		BEGIN
			IF(@out_nIsPreviousPeriodEndSubmission = 1)
			BEGIN 
				SET @out_nReturnValue = @ERR_PRECLEARANCE_NOT_ALLOWED_PeriodEndDISC_NOT_SUBMITTED
				RETURN @out_nReturnValue
			
			END
		END

		--not able to sell or pledge if balance is not available
		IF(@inp_iTransactionTypeCodeId = @nTransactionMode_Sell)
		BEGIN 
			 IF NOT EXISTS (SELECT * FROM tra_BalancePool_OS 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId)
			BEGIN 
				SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
				RETURN @out_nReturnValue 
			END
		END
		ELSE IF (@inp_iTransactionTypeCodeId = @nTranscationMode_Pledge OR @inp_iTransactionTypeCodeId = @nTranscationMode_PledgeInvoke OR @inp_iTransactionTypeCodeId = @nTranscationMode_PledgeRevoke)
		BEGIN
			IF NOT EXISTS (SELECT * FROM tra_BalancePool_OS 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId)
			BEGIN 
				SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
				RETURN @out_nReturnValue 
			END
			ELSE
			BEGIN
				SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
				WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId

				IF @nVirtualQuantity = 0
				BEGIN 
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue 
				END	
				SET @nVirtualQuantity = 0
				SET @nActualQuantity = 0
			END
		END

		----print 'Check @ERR_PRECLEARANCE_REQUESTED - Check that preclearance in requested state exists'		
		-- #2 Allow new pre clearance to be created when earlier pre clearance is open
		-- PreClrAllowNewForOpenPreclearFlag = 1 -> Allow any preclearance
		IF @nTP_PreClrAllowNewForOpenPreclearFlag = 0
		BEGIN
			----print 'Checking....'
			IF(@inp_DisplaySequenceNo<>0)
			BEGIN
			-- Check that preclearance in requested state exists
			IF EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest_NonImplementationCompany
							WHERE UserInfoId = @inp_iUserInfoId
								AND PreclearanceStatusCodeId = @nPCLStatusCode_Requested AND DisplaySequenceNo<>@inp_DisplaySequenceNo)
			BEGIN
				SET @out_nReturnValue = @ERR_PRECLEARANCE_REQUESTED
				RETURN @out_nReturnValue				
			END
			END
			
			----print '@ERR_PRECLEARANCE_OPEN - Check if non-closed preclearance exists'
			-- Check if non-closed preclearance exists
			-- If PreClrAllowNewForOpenPreclearFlag = 0 -> Check that all other preclearance requests are closed
			--	1)	Insider creates a pre-clearance and CO approves and full trade details are provided by insider
			--	2)	Insider creates a pre-clearance and CO approves and not traded details (full) are provided by insider
			--	3)	Insider creates a pre-clearance and CO approves and partial trade details provide and remaining not traded details are provided by insider
			--	4)	Insider creates a pre-clearance and CO rejects
			IF EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest_NonImplementationCompany 
							WHERE UserInfoId = @inp_iUserInfoId
								AND PreclearanceStatusCodeId = @nPCLStatusCode_Approved
								AND ReasonForNotTradingCodeId IS NULL
								AND IsPartiallyTraded = 1)
			BEGIN
				SET @out_nReturnValue = @ERR_PRECLEARANCE_OPEN
				RETURN @out_nReturnValue
			END
		
		END

		-- validation for security quantity and security avaiable in pool
		IF (EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode_OS 
						WHERE TradingPolicyId = @inp_iTradingPolicyId
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_PreclearnaceOS 
						AND TransactionModeCodeId in (@nTransactionMode_Buy, @nTransactionMode_Sell,@nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke))
			AND @inp_iSecurityTypeCodeId = @nSecurityType_Share 
			AND @inp_iTransactionTypeCodeId in (@nTransactionMode_Sell))
		BEGIN
			print 'validation for security quantity and security avaiable in pool'
			
			SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
			
			IF ( (@nVirtualQuantity) < @inp_dSecuritiesToBeTradedQty)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
		END
		ELSE
		BEGIN
		   IF(@inp_iTransactionTypeCodeId  = @nTransactionMode_Sell)
		   BEGIN
				-- For all secuirty type execept Shares
				SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
				WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
				
				-- validate requested quantity and quantity in pool 
				-- check quantity in pool and quantity requested for sell 
				IF ( @nVirtualQuantity < @inp_dSecuritiesToBeTradedQty)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
			END
		END
				
		IF (EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode_OS 
						WHERE TradingPolicyId = @inp_iTradingPolicyId
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_PreclearnaceOS 
						AND TransactionModeCodeId in (@nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke, @nTranscationMode_PledgeInvoke))			 
			AND @inp_iTransactionTypeCodeId in (@nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke, @nTranscationMode_PledgeInvoke))			
		  BEGIN
			   SELECT @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id FROM tra_TransactionTypeSettings_OS WHERE trans_type_code_id = @inp_iTransactionTypeCodeId AND mode_of_acquis_code_id = @inp_iModeOfAcquisitionCodeId AND security_type_code_id = @inp_iSecurityTypeCodeId
			    				
			   IF(@nImptPostShareQtyCodeId = @nNo)						     
			   BEGIN
				   IF(@nActionCodeID = @nSell)
				   BEGIN
						SELECT @nPledgeQuantity = PledgeQuantity FROM tra_BalancePool_OS 
						WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId			
						
						IF (@nPledgeQuantity < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
				   END
				   ELSE
				   BEGIN IF(@nActionCodeID = @nBuy)
						SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
					WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
					IF ( (@nVirtualQuantity) < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
				   END
			   END
			   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
			   BEGIN
			      IF(@inp_iSecurityTypeCodeId = @nSecurityType_Share)
			      BEGIN
					print '2 validation for security quantity and security avaiable in pool'
					
					SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
					WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
					IF ( (@nVirtualQuantity) < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
				END
				  ELSE
					BEGIN
						-- For all secuirty type execept Shares
						SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
						WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID  AND CompanyID = @inp_iCompanyId	 						
						-- validate requested quantity and quantity in pool 
						-- check quantity in pool and quantity requested for sell 
						IF (@nVirtualQuantity < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
					
					END				      
				  END	
		 END

		 IF EXISTS (SELECT * FROM tra_TransactionMaster_OS TM 
			INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			WHERE TM.TransactionStatusCodeId <> @nDisclosureStatusConfirmed AND TM.DisclosureTypeCodeId = @nDisclosureTypeContinuous
			AND DMATDetailsID= @inp_iDMATDetailsID AND CompanyID= @inp_iCompanyId AND SecurityTypeCodeId= @inp_iSecurityTypeCodeId
			AND PR.ReasonForNotTradingCodeId IS NULL)
		BEGIN
			SET @out_nReturnValue = @ERR_ContinuousDisclosureforDupPNTEntry
			RETURN @out_nReturnValue
		END
		ELSE
		IF EXISTS (SELECT * FROM tra_TransactionMaster_OS TM 
			INNER JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId
			WHERE TM.TransactionStatusCodeId <> @nDisclosureStatusConfirmed AND TM.DisclosureTypeCodeId = @nDisclosureTypeContinuous
			AND DMATDetailsID= @inp_iDMATDetailsID AND CompanyID= @inp_iCompanyId AND SecurityTypeCodeId= @inp_iSecurityTypeCodeId)
		BEGIN
			SET @out_nReturnValue = @ERR_ContinuousDisclosureforDupPNTEntry
			RETURN @out_nReturnValue
		END

		IF @inp_iUserInfoIdRelative IS NOT NULL
		BEGIN
			IF (NOT EXISTS (SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
							JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId 
							WHERE TM.DisclosureTypeCodeId = 147001 AND TD.ForUserInfoId = @inp_iUserInfoIdRelative AND TM.TransactionStatusCodeId = 148003))
			BEGIN
				SET @out_nReturnValue = @ERR_InitialDisclosureforRelative
				RETURN @out_nReturnValue
			END
		END
		
		-- Fetch limits for the selected/all securities set in the trading policy
		SELECT @nSecurityQtyLimit = TPSecLimit.NoOfShares,
				@nSecurityValueLimit = TPSecLimit.ValueOfShares
		FROM rul_TradingPolicySecuritywiseLimits_OS TPSecLimit
		WHERE TradingPolicyId = @inp_iTradingPolicyId
		AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_PreclearnaceOS
		AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
			
			--SELECT @nSecuritiesToBeTradedQty AS'SecuritiesToBeTradedQty',@nSecurityQtyLimit AS 'SecurityQtyLimit'
			----SELECT @nSecuritiesToBeTradedValue AS 'SecuritiesToBeTradedValue',@nSecurityValueLimit AS 'SecurityValueLimit'
			--SELECT @nSecuritiesToBeTradedValue AS 'SecuritiesToBeTradedValue',@nPerOfSubCapital AS 'PerOfSubCapital'
			-- Check if the request crosses the limit
			
			IF(@nTP_PreClrTradesApprovalReqFlag=1)
			BEGIN
				SET @out_iIsAutoApproved = 0
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue
			END
			ELSE
			BEGIN
				IF (@nSecurityQtyLimit IS NOT NULL AND @nSecurityQtyLimit < @inp_dSecuritiesToBeTradedQty) -- Limit on qty is set and exceeds
					OR (@nSecurityValueLimit IS NOT NULL AND @nSecurityValueLimit < @inp_dSecuritiesToBeTradedValue) -- Limit on value is set and exceeds
				BEGIN			
					SET @bIsWithinLimits = @bNotWithinLimit
				END
				ELSE
				BEGIN			
					SET @bIsWithinLimits = @bWithinLimit
				END
			
				IF @bIsWithinLimits = @bWithinLimit
				BEGIN			
					IF @nTP_AutoAprReqForBelowEnteredValue = 0 -- Auto approval is not req below the entered value
					BEGIN
						SET @out_nReturnValue = @ERR_PRECLEARANCENOTNEEDED_VALUESWITHINLIMIT
						RETURN @out_nReturnValue
					END
					ELSE
					BEGIN				
						-- Set flag for autoapproval
						SET @out_iIsAutoApproved = 1
						--select @out_iIsAutoApproved as 'Auto Approve'
					END
				END
			END


	END TRY
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	

		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =   ERROR_NUMBER()
		RETURN @out_nReturnValue
	END CATCH
END