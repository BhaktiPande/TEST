IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestSaveValidations')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestSaveValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Validate the preclearancePreclearance Request details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		25-Aug-2015
Modification History:
Modified By		Modified On		Description
Arundhati		11-Sep-2015		Condition on MapToTypeCodeId is added while fetching limits for Preclearance
Parag			08-Oct-2015		Added validation for period end disclosure ie if period end disclosure is not submitted then don't save preclearance
Parag			25-Nov-2015		Add validation on security pool if security from pool is used
Parag			04-Dec-2015		Change validation for period end disclosure ie if current date is last of month then allow user to create pre-clearance 
Tushar			19-Jan-2016		Change related to the In Pre-Clearance settings of Trading policy is Pre-Clearance 
								approval based on limit exceeding of only: 1. Pre-Clearace details. 2. "Pre-Clearace details + Trade details" 
Tushar			16-Feb-2016		Change for related to the In Pre-Clearance settings of Trading policy is Pre-Clearance 
								approval based on limit exceeding of only: 1. Pre-Clearace details. 2. "Pre-Clearace details + Trade details" 
								sum is consider for only those transaction types Pre-Clearance required for transaction types defined
Tushar			09-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Parag			20-Apr-2016		Made change to add validation for check security pool balance while taking pre-clearance 
Tushar			17-May-2016		Comment select statement in procedure
Tushar			14-Jun-2016		Changes for applying pool based validations for security types other than shares 
Tushar			05-Aug-2016		Allow negative balance for configure security type in SecurityConfiguration Table
Parag			18-Aug-2016		Code merge with ESOP code
Tushar			03-Sep-2016		Change for maintaining DMAT wise pool and related validation.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			21-Sep-2016		Performing the validation for Period end to be used when creating Pre clearances.
Tushar			29-Sep-2016		Percentage share capital calculation uncomment.

Usage:
DECLARE @RC int
EXEC st_tra_PreclearanceRequestSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestSaveValidations] 
	@inp_nPreclearanceRequestId					BIGINT,
	@inp_iTradingPolicyId						INT,
	--@inp_iPreclearanceRequestForCodeId			INT,
	@inp_iUserInfoId							INT,
	--@inp_iUserInfoIdRelative					INT,
	@inp_iTransactionTypeCodeId					INT,
	@inp_iSecurityTypeCodeId					INT,
	@inp_dSecuritiesToBeTradedQty				DECIMAL(15,4),
	@inp_iPreclearanceStatusCodeId				INT,
	--@inp_iCompanyId								INT,
	@inp_dProposedTradeRateRangeFrom			DECIMAL(15,4),
	@inp_dProposedTradeRateRangeTo				DECIMAL(15,4),
	@inp_dSecuritiesToBeTradedValue				DECIMAL(20,4),
	@inp_bESOPExcerciseOptionQtyFlag			BIT,
	@inp_bOtherESOPExcerciseOptionQtyFlag		BIT,
	@inp_iContraTradeOption						INT,
	@inp_iModeOfAcquisitionCodeId               INT,
	@inp_iDMATDetailsID							INT,
	@out_iIsAutoApproved						BIT = 0 OUTPUT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_VALIDATION							INT
	DECLARE @ERR_PRECLEARANCENOTNEEDED									INT = 17382 --? Pre-clearance for the selected transation and security 
																					--  is not needed.
	DECLARE @ERR_PRECLEARANCE_REQUESTED									INT = 17383 --? Cannot save new preclearance request, as a preclearance is already requested and not yet approved.
	DECLARE @ERR_PRECLEARANCE_OPEN										INT = 17384 --? Earlier preclearance request is not yet closed. Close the preclearance request by providing all details or reason for Not/partial trading.
	DECLARE @ERR_PRECLEARANCENOTNEEDED_VALUESWITHINLIMIT				INT = 17385 --? Preclearance is not needed, since the values provided are within limit. you can directly submit trade details.
	DECLARE @ERR_PRECLEARANCE_NOT_ALLOWED_PeriodEndDISC_NOT_SUBMITTED	INT = 17393 -- Cannot create new preclearance request, as a period end disclosure is not yet submiited.
	DECLARE @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY		INT = 17400 -- Exercise security pool does not sufficient quantity
	DECLARE @ERR_PRECLEARANCE_SECURITY_POOL_NOT_SELECTED				INT = 17423 -- Please select exercise pool
	
	DECLARE @nMapToTypeCodeId_Preclearance								INT = 132004
	DECLARE @nPCLStatusCode_Requested									INT = 144001
	DECLARE @nPCLStatusCode_Approved									INT = 144002
	DECLARE @nPCLStatusCode_Rejected									INT = 144003
	
	DECLARE @nTP_PreClrTradesApprovalReqFlag							INT
	DECLARE @nTP_PreClrAllowNewForOpenPreclearFlag						INT
	DECLARE @nTP_AutoAprReqForBelowEnteredValue							INT
	DECLARE @nTP_PreclearanceRequestSingleOrMultiple					INT
	DECLARE @nTP_PreClrApprovalPreclearORPreclearTradeFlag				INT -- 0=Preclearance details, 1=Preclearance and Trade details
	DECLARE @nTP_PreClrForAllSecuritiesFlag								INT -- 0: For selected securities, 1: For ALL securities
	
	DECLARE @nTP_CONST_PreclearanceRequestSingle						INT = 136001 -- Single Preclearance request to be considered
	DECLARE @nTP_CONST_PreclearanceRequestMultiple						INT = 136002 -- Multiple Preclearance requests to be considered
	DECLARE @nTP_CONST_PreClrApprovalPreclear							INT = 0 -- Preclearance details
	DECLARE @nTP_CONST_PreClrApprovalPreclearTrade						INT = 1 -- Preclearance and Trade details
	DECLARE @nTP_CONST_PreClrForAllSecurities							INT = 1 -- 1: For ALL securities
	DECLARE @nTP_CONST_PreClrForSelectedSecurities						INT = 0 -- 0: For selected securities
		
	DECLARE @nSecuritiesToBeTradedQty					DECIMAL(15,4)
	DECLARE @nSecuritiesToBeTradedValue					DECIMAL(20,4)
	DECLARE @nPrecleanceSecuritiesToBeTradedQty			DECIMAL(15,4)
	DECLARE @nPrecleanceSecuritiesToBeTradedValue		DECIMAL(15,4)
	DECLARE @nTDSecuritiesToBeTradedQty					DECIMAL(15,4)
	DECLARE @nTDSecuritiesToBeTradedValue				DECIMAL(15,4)
	
	DECLARE @nSecurityQtyLimit							DECIMAL(15,4)
	DECLARE @nSecurityValueLimit						DECIMAL(15,4)
	DECLARE @nSecurityPercentageLimit					DECIMAL(15,4)

	DECLARE @bIsWithinLimits							BIT
	DECLARE @bWithinLimit								BIT = 1
	DECLARE @bNotWithinLimit							BIT = 0

	DECLARE @nSubCapital								DECIMAL(25,4)
	DECLARE @nPerOfSubCapital							DECIMAL(25,4)
	
	DECLARE @dtPEStartDate								DATETIME
	DECLARE @dtPEEndDate								DATETIME
	DECLARE @nYearCodeId								INT, 
			@nPeriodCodeId								INT 
	DECLARE @dtToday									DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @nPeriodType								INT
	
	DECLARE @nDisclosureType_PeriodEnd					INT = 147003
	DECLARE @nTransStatus_DocumentUploaded				INT = 148001
	DECLARE	@nTransStatus_NotConfirmed					INT = 148002
	
	DECLARE @nTransactionMode_Buy						INT = 143001
	DECLARE @nTransactionMode_Sell						INT = 143002
	DECLARE @nTransactionMode_Cash_Exercise				INT = 143003
	DECLARE @nTranscationMode_Cashless_Partial			INT = 143005
	DECLARE @nTranscationMode_Pledge                    INT = 143006
	DECLARE @nTranscationMode_PledgeRevoke              INT = 143007
	DECLARE @nTranscationMode_PledgeInvoke              INT = 143008
	
	DECLARE @nSecurityType_Share						INT = 139001
	
	DECLARE @nESOPQuantity								INT = 0
	DECLARE @nOtherQuantity								INT = 0
	DECLARE @nPledgeQuantity                            INT = 0
	
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT 
	DECLARE @nTransactionMode_MapToTypeCode_Preclearnace			INT = 132004
	
	DECLARE @nESOPExciseOptionFirstandThenOtherShares				INT = 172001
	DECLARE @nOtherSharesFirstThenESOPExciseOption					INT = 172002
	DECLARE @nUserSelectionOnPreClearanceAndTradeDetailsSubmission	INT = 172003
	DECLARE @nIsProhibitPreClrFunctionalityApplicable INT=0
	
	DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)
	
	DECLARE @nContraTradeWithoutQuantityBase INT = 175001
	DECLARE @nContraTradeQuantityBase INT = 175002
	
	DECLARE @nImptPostShareQtyCodeId INT
	DECLARE @nActionCodeID INT
	--Impact on Post Share quantity	
    DECLARE @nLess INT = 505002    
    DECLARE @nNo   INT = 505004
	--Action 
    DECLARE @nSell INT = 504002	
	
	DECLARE @bIsAllowNegativeBalance BIT
	DECLARE @nTmpRet INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		----print '@inp_iTradingPolicyId' + convert(varchar(10), @inp_iTradingPolicyId)
		
		IF @inp_nPreclearanceRequestId <> 0
		BEGIN
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue
		END
		
		-- Perform validations for new preclearance request
		
		----print 'Check @ERR_PRECLEARANCENOTNEEDED - If it is requested for other type, raise error'
		-- #1 - Pre-clearance Required For based on {Transaction, Security} pair set in the trading policy.
		-- If it is requested for other type, raise error
		IF NOT EXISTS (SELECT * FROM rul_TradingPolicyForTransactionSecurity 
						WHERE MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
							AND TradingPolicyId = @inp_iTradingPolicyId
							AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
							AND TransactionModeCodeId = @inp_iTransactionTypeCodeId
						)
		BEGIN
			SET @out_nReturnValue = @ERR_PRECLEARANCENOTNEEDED
			RETURN @out_nReturnValue
		END
		
		SELECT @nTP_PreClrTradesApprovalReqFlag = PreClrTradesApprovalReqFlag,
			@nTP_PreClrAllowNewForOpenPreclearFlag = PreClrAllowNewForOpenPreclearFlag,
			@nPeriodType = PreClrMultipleAboveInCodeId,
			@nTP_AutoAprReqForBelowEnteredValue = PreClrTradesAutoApprovalReqFlag,
			@nTP_PreclearanceRequestSingleOrMultiple = PreClrSingMultiPreClrFlagCodeId,
			@nTP_PreClrForAllSecuritiesFlag = PreClrForAllSecuritiesFlag,
			@nTP_PreClrApprovalPreclearORPreclearTradeFlag = PreClrApprovalPreclearORPreclearTradeFlag,
			@nGenCashAndCashlessPartialExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade,			
			@nIsProhibitPreClrFunctionalityApplicable=IsProhibitPreClrFunctionalityApplicable 
		FROM rul_TradingPolicy
		WHERE TradingPolicyId = @inp_iTradingPolicyId
		
	--check is allow negative balance for that secuirty type
		EXEC @nTmpRet = st_tra_IsAllowNegativeBalanceForSecurity @inp_iSecurityTypeCodeId,@bIsAllowNegativeBalance OUTPUT,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
			RETURN @out_nReturnValue
		END

		----print 'Check @ERR_PRECLEARANCE_REQUESTED - Check that preclearance in requested state exists'		
		-- #2 Allow new pre clearance to be created when earlier pre clearance is open
		-- PreClrAllowNewForOpenPreclearFlag = 1 -> Allow any preclearance
		IF @nTP_PreClrAllowNewForOpenPreclearFlag = 0
		BEGIN
			----print 'Checking....'
			-- Check that preclearance in requested state exists
			IF EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest 
							WHERE UserInfoId = @inp_iUserInfoId
								AND PreclearanceStatusCodeId = @nPCLStatusCode_Requested)
			BEGIN
				SET @out_nReturnValue = @ERR_PRECLEARANCE_REQUESTED
				RETURN @out_nReturnValue				
			END
			
			----print '@ERR_PRECLEARANCE_OPEN - Check if non-closed preclearance exists'
			-- Check if non-closed preclearance exists
			-- If PreClrAllowNewForOpenPreclearFlag = 0 -> Check that all other preclearance requests are closed
			--	1)	Insider creates a pre-clearance and CO approves and full trade details are provided by insider
			--	2)	Insider creates a pre-clearance and CO approves and not traded details (full) are provided by insider
			--	3)	Insider creates a pre-clearance and CO approves and partial trade details provide and remaining not traded details are provided by insider
			--	4)	Insider creates a pre-clearance and CO rejects
			IF EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest 
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
		IF (EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode 
						WHERE TradingPolicyId = @inp_iTradingPolicyId
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_Preclearnace 
						AND TransactionModeCodeId in (@nTransactionMode_Buy, @nTransactionMode_Sell, @nTransactionMode_Cash_Exercise, @nTranscationMode_Cashless_Partial))
			AND @inp_iSecurityTypeCodeId = @nSecurityType_Share 
			AND @inp_iTransactionTypeCodeId in (@nTransactionMode_Sell)
			AND @inp_iContraTradeOption = @nContraTradeQuantityBase)
		BEGIN
			print '1 validation for security quantity and security avaiable in pool'
			SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID
		
			print '@nESOPQuanity_FromPool '+convert(varchar, ISNULL(@nESOPQuantity,-1)) 
					+ ' @nOtherQuantity_FromPool ' +convert(varchar, ISNULL(@nOtherQuantity,-1))
					+ ' @nGenCashAndCashlessPartialExciseOptionForContraTrade ' +convert(varchar, @nGenCashAndCashlessPartialExciseOptionForContraTrade)
					
			-- validate requested quantity and quantity in pool 
			IF (@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nESOPExciseOptionFirstandThenOtherShares
				OR @nGenCashAndCashlessPartialExciseOptionForContraTrade = @nOtherSharesFirstThenESOPExciseOption)
			BEGIN
				-- check quantity in pool and quantity requested for sell 
				IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty AND @bIsAllowNegativeBalance = 1)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
			END
			ELSE IF (@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nUserSelectionOnPreClearanceAndTradeDetailsSubmission)
			BEGIN
				IF (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_NOT_SELECTED
					RETURN @out_nReturnValue
				END
				
				IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1 
						AND (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty AND @bIsAllowNegativeBalance = 1)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
				
				IF ((@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0 
						AND @nESOPQuantity < @inp_dSecuritiesToBeTradedQty)
					OR (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1 
						AND @nOtherQuantity < @inp_dSecuritiesToBeTradedQty) AND @bIsAllowNegativeBalance = 1 AND @bIsAllowNegativeBalance = 1)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
			END
		END
		ELSE IF (EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode 
						WHERE TradingPolicyId = @inp_iTradingPolicyId
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_Preclearnace 
						AND TransactionModeCodeId in (@nTransactionMode_Buy, @nTransactionMode_Sell, @nTransactionMode_Cash_Exercise, @nTranscationMode_Cashless_Partial, @nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke))
			AND @inp_iSecurityTypeCodeId = @nSecurityType_Share 
			AND @inp_iTransactionTypeCodeId in (@nTransactionMode_Sell)
			AND @inp_iContraTradeOption = @nContraTradeWithoutQuantityBase)
		BEGIN
			print '2 validation for security quantity and security avaiable in pool'
			
			SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID
			
			-- validate requested quantity and quantity in pool 
			-- check quantity in pool and quantity requested for sell 
			IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty AND @bIsAllowNegativeBalance = 1)
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
				SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
				WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID
				PRINT 'Test'
				-- validate requested quantity and quantity in pool 
				-- check quantity in pool and quantity requested for sell 
				IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty AND @bIsAllowNegativeBalance = 1)
				BEGIN
					SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
					RETURN @out_nReturnValue
				END
			END
		END

		
		IF (EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode 
						WHERE TradingPolicyId = @inp_iTradingPolicyId
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_Preclearnace 
						AND TransactionModeCodeId in (@nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke, @nTranscationMode_PledgeInvoke))			 
			AND @inp_iTransactionTypeCodeId in (@nTranscationMode_Pledge, @nTranscationMode_PledgeRevoke, @nTranscationMode_PledgeInvoke))			
		  BEGIN
			   select @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id from tra_TransactionTypeSettings where trans_type_code_id = @inp_iTransactionTypeCodeId and mode_of_acquis_code_id = @inp_iModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId
			    					   
			   IF(@nImptPostShareQtyCodeId = @nNo)						     
			   BEGIN
				   IF(@nActionCodeID = @nSell)
				   BEGIN
						SELECT @nPledgeQuantity = PledgeQuantity FROM tra_ExerciseBalancePool 
						WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID			
						
						IF (@nPledgeQuantity < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
				   END
			   END
			   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
			   BEGIN
			      IF(@inp_iContraTradeOption = @nContraTradeQuantityBase AND @inp_iSecurityTypeCodeId = @nSecurityType_Share)
			      BEGIN
					print '1 validation for security quantity and security avaiable in pool'
					SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
					WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID
				
					print '@nESOPQuanity_FromPool '+convert(varchar, ISNULL(@nESOPQuantity,-1)) 
							+ ' @nOtherQuantity_FromPool ' +convert(varchar, ISNULL(@nOtherQuantity,-1))
							+ ' @nGenCashAndCashlessPartialExciseOptionForContraTrade ' +convert(varchar, @nGenCashAndCashlessPartialExciseOptionForContraTrade)
							
					-- validate requested quantity and quantity in pool 
					IF (@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nESOPExciseOptionFirstandThenOtherShares
						OR @nGenCashAndCashlessPartialExciseOptionForContraTrade = @nOtherSharesFirstThenESOPExciseOption)
					BEGIN
						-- check quantity in pool and quantity requested for sell 
						IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
					END
					ELSE IF (@nGenCashAndCashlessPartialExciseOptionForContraTrade = @nUserSelectionOnPreClearanceAndTradeDetailsSubmission)
					BEGIN
						IF (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_NOT_SELECTED
							RETURN @out_nReturnValue
						END
						
						IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1 
								AND (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
						
						IF ((@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0 
								AND @nESOPQuantity < @inp_dSecuritiesToBeTradedQty)
							OR (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1 
								AND @nOtherQuantity < @inp_dSecuritiesToBeTradedQty))
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
					END
				END
			      ELSE IF(@inp_iContraTradeOption = @nContraTradeWithoutQuantityBase AND @inp_iSecurityTypeCodeId = @nSecurityType_Share)
			      BEGIN
					print '2 validation for security quantity and security avaiable in pool'
					
					SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
					WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID
					
					-- validate requested quantity and quantity in pool 
					-- check quantity in pool and quantity requested for sell 
					IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty)
					BEGIN
						SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
						RETURN @out_nReturnValue
					END
				END
				  ELSE
					BEGIN
						-- For all secuirty type execept Shares
						SELECT @nESOPQuantity = ESOPQuantity, @nOtherQuantity = OtherQuantity FROM tra_ExerciseBalancePool 
						WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID	 						
						-- validate requested quantity and quantity in pool 
						-- check quantity in pool and quantity requested for sell 
						IF ( (@nESOPQuantity + @nOtherQuantity) < @inp_dSecuritiesToBeTradedQty)
						BEGIN
							SET @out_nReturnValue = @ERR_PRECLEARANCE_SECURITY_POOL_INSUFFICIENT_QUANTITY
							RETURN @out_nReturnValue
						END
					
					END				      
				  END			
		 END

		-- Find start and end date for the selected period
		IF @nTP_PreclearanceRequestSingleOrMultiple = @nTP_CONST_PreclearanceRequestMultiple
		BEGIN
		
			----print 'Find PE dates'
			SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
								WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
								WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
								WHEN @nPeriodType = 137004	THEN 123002 -- Weekly
								ELSE @nPeriodType
								END

			EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
			   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtToday, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			   
			----print 'PE Start: ' + convert(varchar(11), @dtPEStartDate)
			----print 'PE END: ' + convert(varchar(11), @dtPEendDate)
		END
		
		-- Check if preclearance is required or not / should it be approved automatically
		IF @nTP_PreClrTradesApprovalReqFlag = 0 -- If "Approval required for all pre-clearances" = "NO"
		BEGIN
			----print 'Check if it is for auto approval ' + CONVERT(VARCHAR(10), @nTP_PreclearanceRequestSingleOrMultiple)
			-- Find preclearance quantity to be compared for the limit (depending on the other flags and conditions)
			IF @nTP_PreclearanceRequestSingleOrMultiple = @nTP_CONST_PreclearanceRequestSingle -- If opted "Single Pre-Clearance Request"
			BEGIN
				SELECT @nSecuritiesToBeTradedQty = @inp_dSecuritiesToBeTradedQty,
					@nSecuritiesToBeTradedValue = @inp_dSecuritiesToBeTradedValue
			END
			ELSE IF @nTP_PreclearanceRequestSingleOrMultiple = @nTP_CONST_PreclearanceRequestMultiple -- If opted "Multiple Pre-Clearance Request"
			BEGIN
				-- Check if the limits are set using "All Security Type" or "Selected Security Type"
				INSERT INTO @tmpSecurities(SecurityTypeCodeId)
					SELECT DISTINCT SecurityTypeCodeId 
					From rul_TradingPolicyForTransactionSecurity
					WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
					
				IF @nTP_PreClrApprovalPreclearORPreclearTradeFlag = @nTP_CONST_PreClrApprovalPreclear
				-- "Preclearance approval based on limit exceeding of only" = "Pre-clearance Details"
				BEGIN
					-- Precleanrce Quanitity consider when
					-- 1. Precleanrce in Pending/approved status not entered any trade deatils.
					-- 2. partial trade case when precleance is open
					SELECT @nPrecleanceSecuritiesToBeTradedQty = SUM(SecuritiesToBeTradedQty),
						@nPrecleanceSecuritiesToBeTradedValue = SUM(SecuritiesToBeTradedValue)
					FROM tra_PreclearanceRequest PR
					JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId  = TM.PreclearanceRequestId
					LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					WHERE PR.UserInfoId = @inp_iUserInfoId
						AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
						AND PR.CreatedOn >= @dtPEStartDate AND PreclearanceStatusCodeId <> @nPCLStatusCode_Rejected AND IsPartiallyTraded <> 2
						AND (TD.TransactionDetailsId IS NULL OR (TD.TransactionDetailsId IS NOT NULL AND PR.IsPartiallyTraded = 1 
						AND PR.ReasonForNotTradingCodeId IS NULL))
						AND PR.TransactionTypeCodeId IN(SELECT TransactionModeCodeId 
								FROM rul_TradingPolicyForTransactionMode WHERE MapToTypeCodeId = 132004 AND TradingPolicyId = @inp_iTradingPolicyId)
					
					-- Transaction details Quanitity consider when
					-- 1. partial trade case when precleance is close by partial traded or overtraded
					SELECT @nTDSecuritiesToBeTradedQty = SUM(ISNULL(TD.Quantity, 0)),
						   @nTDSecuritiesToBeTradedValue = SUM(ISNULL(Value, 0)) 
					FROM tra_TransactionDetails TD 
					JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
					JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
						 JOIN @tmpSecurities tmpSecurities ON tmpSecurities.SecurityTypeCodeId = TD.SecurityTypeCodeId
					WHERE TM.UserInfoId = @inp_iUserInfoId
						AND TM.DisclosureTypeCodeId <> 147001 -- Do not consider initial disclosures
						AND TransactionStatusCodeId > 148002 -- Consider transactions which are submitted
						AND DateOfAcquisition >= @dtPEStartDate
						AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
						AND TM.PreclearanceRequestId IS NOT NULL AND TD.TransactionDetailsId IS NOT NULL AND 
						((PR.IsPartiallyTraded = 1 AND Pr.ReasonForNotTradingCodeId IS NOT NULL) OR (PR.IsPartiallyTraded = 0 AND ShowAddButton = 0))
					    AND TD.TransactionTypeCodeId IN(SELECT TransactionModeCodeId 
								FROM rul_TradingPolicyForTransactionMode WHERE MapToTypeCodeId = 132004 AND TradingPolicyId = @inp_iTradingPolicyId)
					----print 'DEbug 1 @nSecuritiesToBeTradedQty ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedQty,0))
					----print 'DEbug 1 @nSecuritiesToBeTradedValue ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedValue,0))
					
					
					
					SET @nSecuritiesToBeTradedQty = ISNULL(@nPrecleanceSecuritiesToBeTradedQty,0) + ISNULL(@nTDSecuritiesToBeTradedQty,0)
					SET @nSecuritiesToBeTradedValue = ISNULL(@nPrecleanceSecuritiesToBeTradedValue,0) + ISNULL(@nTDSecuritiesToBeTradedValue,0)
					
					IF @nSecuritiesToBeTradedQty IS NULL OR @nSecuritiesToBeTradedQty = 0
					BEGIN
						SELECT @nSecuritiesToBeTradedQty = @inp_dSecuritiesToBeTradedQty,
							@nSecuritiesToBeTradedValue = @inp_dSecuritiesToBeTradedValue
					END
					ELSE
					BEGIN
						SET @nSecuritiesToBeTradedQty = ISNULL(@nSecuritiesToBeTradedQty,0) + ISNULL(@inp_dSecuritiesToBeTradedQty,0)
						SET @nSecuritiesToBeTradedValue = ISNULL(@nSecuritiesToBeTradedValue,0) + ISNULL(@inp_dSecuritiesToBeTradedValue,0)
					END
					
				END
				ELSE -- @nTP_PreClrApprovalPreclearORPreclearTradeFlag = @nTP_CONST_PreClrApprovalPreclearTrade
				-- "Preclearance approval based on limit exceeding of only" = "Pre-clearance + Trade Details"
				BEGIN
					--INSERT INTO @tmpSecurities(SecurityTypeCodeId)
					--SELECT DISTINCT SecurityTypeCodeId 
					--From rul_TradingPolicyForTransactionSecurity
					--WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
					
					-- Precleanrce Quanitity consider when
					-- 1. Precleanrce in Pending/approved status not entered any trade deatils.
					-- 2. partial trade case when precleance is open
					SELECT @nPrecleanceSecuritiesToBeTradedQty = SUM(SecuritiesToBeTradedQty),
						@nPrecleanceSecuritiesToBeTradedValue = SUM(SecuritiesToBeTradedValue)
					FROM tra_PreclearanceRequest PR
					JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId  = TM.PreclearanceRequestId
					LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
					WHERE PR.UserInfoId = @inp_iUserInfoId
						AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
						AND PR.CreatedOn >= @dtPEStartDate AND PreclearanceStatusCodeId <> @nPCLStatusCode_Rejected AND IsPartiallyTraded <> 2
						AND (TD.TransactionDetailsId IS NULL OR (TD.TransactionDetailsId IS NOT NULL AND PR.IsPartiallyTraded = 1 
						AND PR.ReasonForNotTradingCodeId IS NULL))
						 AND PR.TransactionTypeCodeId IN(SELECT TransactionModeCodeId 
								FROM rul_TradingPolicyForTransactionMode WHERE MapToTypeCodeId = 132004 AND TradingPolicyId = @inp_iTradingPolicyId)
					--select @nPrecleanceSecuritiesToBeTradedQty,@nPrecleanceSecuritiesToBeTradedValue
					
					-- Transaction details Quanitity consider when
					-- 1. partial trade case when precleance is close by partial traded or overtraded
					-- 2. All pnt records
					
					SELECT @nTDSecuritiesToBeTradedQty = SUM(ISNULL(TD.Quantity, 0)),
						@nTDSecuritiesToBeTradedValue = SUM(ISNULL(Value, 0))
					FROM tra_TransactionDetails TD 
					JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
					JOIN @tmpSecurities tmpSecurities ON tmpSecurities.SecurityTypeCodeId = TD.SecurityTypeCodeId
					LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
					WHERE TM.UserInfoId = @inp_iUserInfoId
						AND TM.DisclosureTypeCodeId <> 147001 -- Do not consider initial disclosures
						AND TransactionStatusCodeId > 148002 -- Consider transactions which are submitted
						AND DateOfAcquisition >= @dtPEStartDate
						AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
						AND (PR.PreclearanceRequestId IS NULL OR ( PR.PreclearanceRequestId IS NOT NULL AND PR.ShowAddButton <> 1 AND PR.PreclearanceStatusCodeId <> @nPCLStatusCode_Rejected AND PR.IsPartiallyTraded <> 2))
						 AND TD.TransactionTypeCodeId IN(SELECT TransactionModeCodeId 
								FROM rul_TradingPolicyForTransactionMode WHERE MapToTypeCodeId = 132004 AND TradingPolicyId = @inp_iTradingPolicyId)
					--select @nTDSecuritiesToBeTradedQty,@nTDSecuritiesToBeTradedValue
						
					SET @nSecuritiesToBeTradedQty = ISNULL(@nPrecleanceSecuritiesToBeTradedQty,0) + ISNULL(@nTDSecuritiesToBeTradedQty,0)
					SET @nSecuritiesToBeTradedValue = ISNULL(@nPrecleanceSecuritiesToBeTradedValue,0) + ISNULL(@nTDSecuritiesToBeTradedValue,0)
					
					----print 'DEbug 2 @nSecuritiesToBeTradedQty ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedQty,0))
					----print 'DEbug 3 @nSecuritiesToBeTradedValue ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedValue,0))
						
					IF @nSecuritiesToBeTradedQty IS NULL OR @nSecuritiesToBeTradedQty = 0
					BEGIN
						SELECT @nSecuritiesToBeTradedQty = @inp_dSecuritiesToBeTradedQty,
							@nSecuritiesToBeTradedValue = @inp_dSecuritiesToBeTradedValue
					END
					ELSE
					BEGIN
						SET @nSecuritiesToBeTradedQty = ISNULL(@nSecuritiesToBeTradedQty,0) + ISNULL(@inp_dSecuritiesToBeTradedQty,0)
						SET @nSecuritiesToBeTradedValue = ISNULL(@nSecuritiesToBeTradedValue,0) + ISNULL(@inp_dSecuritiesToBeTradedValue,0)
					END

				END
			END

			-- Fetch limits for the selected/all securities set in the trading policy
			SELECT @nSecurityQtyLimit = TPSecLimit.NoOfShares,
				@nSecurityValueLimit = TPSecLimit.ValueOfShares,
				@nSecurityPercentageLimit = TPSecLimit.PercPaidSubscribedCap
			FROM rul_TradingPolicySecuritywiseLimits TPSecLimit
			WHERE TradingPolicyId = @inp_iTradingPolicyId
			AND MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
			AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
			
			-- Find limit on value according to percentage specified
			SELECT top(1) @nSubCapital = Cap.PaidUpShare
			FROM mst_Company C JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID
			WHERE IsImplementing = 1
			and PaidUpAndSubscribedShareCapitalDate <= dbo.uf_com_GetServerDate()
			ORDER BY PaidUpAndSubscribedShareCapitalDate DESC

			SELECT @nPerOfSubCapital = ISNULL(@nSecurityPercentageLimit, 0) * ISNULL(@nSubCapital, 0) / 100.0
			
			
			--SELECT @nSecuritiesToBeTradedQty AS'SecuritiesToBeTradedQty',@nSecurityQtyLimit AS 'SecurityQtyLimit'
			----SELECT @nSecuritiesToBeTradedValue AS 'SecuritiesToBeTradedValue',@nSecurityValueLimit AS 'SecurityValueLimit'
			--SELECT @nSecuritiesToBeTradedValue AS 'SecuritiesToBeTradedValue',@nPerOfSubCapital AS 'PerOfSubCapital'
			-- Check if the request crosses the limit
			IF (@nSecurityQtyLimit IS NOT NULL AND @nSecurityQtyLimit < @nSecuritiesToBeTradedQty) -- Limit on qty is set and exceeds
				OR (@nSecurityValueLimit IS NOT NULL AND @nSecurityValueLimit < @nSecuritiesToBeTradedValue) -- Limit on value is set and exceeds
				OR (@nSecurityPercentageLimit IS NOT NULL AND @nPerOfSubCapital < @nSecuritiesToBeTradedValue) -- Limit on % is set and exceeds
			BEGIN
				SET @bIsWithinLimits = @bNotWithinLimit
			END
			ELSE
			BEGIN
				SET @bIsWithinLimits = @bWithinLimit
			END
			
			----print '@nSecurityQtyLimit = ' + convert(varchar(15), @nSecurityQtyLimit)
			----print '@nSecuritiesToBeTradedQty = ' + convert(varchar(15), @nSecuritiesToBeTradedQty)
			----print '@@nSecurityValueLimit = ' + convert(varchar(15), @nSecurityValueLimit)
			----print '@@nSecuritiesToBeTradedValue = ' + convert(varchar(15), @nSecuritiesToBeTradedValue)
			----print '@@nSecurityPercentageLimit = ' + convert(varchar(15), @nSecurityPercentageLimit)
			----print '@@nPerOfSubCapital = ' + convert(varchar(15), @nPerOfSubCapital)
			DECLARE @nProhibitPreSetting INT=0
			SELECT @nProhibitPreSetting=ProhibitPreClearance FROM mst_Company

			IF @bIsWithinLimits = @bWithinLimit
			BEGIN
				IF @nTP_AutoAprReqForBelowEnteredValue = 0 -- Auto approval is not req below the entered value
				BEGIN
					IF(@nIsProhibitPreClrFunctionalityApplicable<>1)
					BEGIN
						SET @out_nReturnValue = @ERR_PRECLEARANCENOTNEEDED_VALUESWITHINLIMIT
						RETURN @out_nReturnValue
					END
				END
				ELSE
				BEGIN
					-- Set flag for autoapproval
					SET @out_iIsAutoApproved = 1
					--select @out_iIsAutoApproved as 'Auto Approve'
					
				END
			END
		END
		
		DECLARE @out_nIsPreviousPeriodEndSubmission INT
		
		EXEC @nTmpRet = st_tra_CheckPreviousPeriodEndSubmission @inp_iUserInfoID,@out_nIsPreviousPeriodEndSubmission OUTPUT,
							@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue --@ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		ELSE
		BEGIN
			IF(@out_nIsPreviousPeriodEndSubmission = 1)	
			-- Check if all the period end disclosure are submitted 
			/*IF EXISTS(SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
						WHERE 
							TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
							AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
							AND TM.UserInfoId = @inp_iUserInfoId AND CONVERT(date, TM.PeriodEndDate) < CONVERT(date, @dtToday))*/
			BEGIN 
				SET @out_nReturnValue = @ERR_PRECLEARANCE_NOT_ALLOWED_PeriodEndDISC_NOT_SUBMITTED
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
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_VALIDATION, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END