IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionMasterIsPCLReqOverride_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionMasterIsPCLReqOverride_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to decide if PCL was req. This procedure is called from st_tra_TradingTransactionMasterCreate, when the transaction is getting 
				submitted, i.e. TransactionMasterId <> 0, NoHolding option is not selected i.e. some details are present for this transaction
				It will be called from st_tra_TransactionMasterIsPCLReq with the @inp_UpdateTD = 1

Returns:		0, if Success.
				
Created by:		Hemant
Created on:		05-Jan-2021

Modification History:
Modified By		Modified On		Description
 

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionMasterIsPCLReqOverride_OS]
	@inp_nTransactionMasterId		BIGINT,
	@inp_UpdateTD					INT = 1, -- 0: Output is records with PCL req flag true, 1: Update transactionDetails Table
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRANSACTIONMASTER_PCLReqFlag INT = 16292 -- Error occurred while deciding preclearance required value.

	DECLARE @nTradingPolicyId INT = 0
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nTransactionDetailsId INT
	DECLARE @nSecurityTypeCodeId INT
	DECLARE @nTransactionTypeCodeId	INT
	DECLARE @nQuantity DECIMAL(10,0)
	DECLARE @nValue DECIMAL(10, 0)
	DECLARE @nTotQuantity DECIMAL(10,0)
	DECLARE @nTotValue DECIMAL(10, 0)
	DECLARE @nIsPCLReq INT -- 0: Not req, 1: Req
	DECLARE @nPreclearanceRequestId INT
	
	DECLARE @nMapToTypeCodeId_Preclearance INT = 132015
	--DECLARE @nPCLStatusCode_Requested INT = 144001
	--DECLARE @nPCLStatusCode_Approved INT = 144002
	--DECLARE @nPCLStatusCode_Rejected INT = 144003

	DECLARE @nTP_PreClrTradesApprovalReqFlag INT
	--DECLARE @nTP_PreClrAllowNewForOpenPreclearFlag INT
	DECLARE @nTP_AutoAprReqForBelowEnteredValue INT
	DECLARE @nTP_PreclearanceRequestSingleOrMultiple INT
	DECLARE @nTP_PreClrApprovalPreclearORPreclearTradeFlag INT -- 0=Preclearance details, 1=Preclearance and Trade details
	DECLARE @nTP_PreClrForAllSecuritiesFlag INT -- 0: For selected securities, 1: For ALL securities
	
	DECLARE @nTP_CONST_PreclearanceRequestSingle INT = 136001 -- Single Preclearance request to be considered
	DECLARE @nTP_CONST_PreclearanceRequestMultiple INT = 136002 -- Multiple Preclearance requests to be considered
	DECLARE @nTP_CONST_PreClrApprovalPreclear INT = 0 -- Preclearance details
	DECLARE @nTP_CONST_PreClrApprovalPreclearTrade INT = 1 -- Preclearance and Trade details
	DECLARE @nTP_CONST_PreClrForAllSecurities INT = 1 -- 1: For ALL securities
	--DECLARE @nTP_CONST_PreClrForSelectedSecurities INT = 0 -- 0: For selected securities
		
	DECLARE @nSecuritiesToBeTradedQty DECIMAL(15,4)
	DECLARE @nSecuritiesToBeTradedValue DECIMAL(20,4)
	DECLARE @nPeriodType INT
	DECLARE @dtPEStartDate DATETIME
	DECLARE @dtPEEndDate DATETIME
	DECLARE @dtAcqDate DATETIME
	DECLARE @nYearCodeId INT, @nPeriodCodeId INT 
	DECLARE @nUserInfoId INT
	DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)

	DECLARE @nSecurityQtyLimit DECIMAL(15,4)
	DECLARE @nSecurityValueLimit DECIMAL(15,4)
	DECLARE @nSecurityPercentageLimit DECIMAL(15,4)

	DECLARE @nSubCapital DECIMAL(25,4)
	DECLARE @nPerOfSubCapital DECIMAL(25,4)

	DECLARE @bIsWithinLimits BIT
	DECLARE @bWithinLimit BIT = 1
	DECLARE @bNotWithinLimit BIT = 0
	
	DECLARE @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID INT = 147002

	DECLARE @tblTDIdPCLReqFlag	TransactionDetailsIdPCLReqType
	
	IF CURSOR_STATUS('global', 'curTransDetails') > -1
	BEGIN
		--print 'cursor status = '-- + convert(varchar(5), CURSOR_STATUS('global', 'curTransDetails'))
		CLOSE curTransDetails
		DEALLOCATE curTransDetails
		--print 'closing cursor curTransDetails START'
	END

	DECLARE curTransDetails CURSOR FOR
	SELECT TransactionDetailsId, SecurityTypeCodeId, TransactionTypeCodeId, Quantity, Value
	FROM tra_TransactionDetails_OS
	WHERE TransactionMasterId = @inp_nTransactionMasterId

	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Initialize variables
		SET @out_nReturnValue = 0

		--print 'st_tra_TransactionMasterIsPCLReqOverride : ' + convert(varchar(10), @inp_nTransactionMasterId)

		SELECT @nTradingPolicyId = TradingPolicyId,
			@nDisclosureTypeCodeId = DisclosureTypeCodeId,
			@nPreclearanceRequestId = PreclearanceRequestId,
			@nUserInfoId = UserInfoId
		FROM tra_TransactionMaster_OS
		WHERE TransactionMasterId = @inp_nTransactionMasterId

		SELECT @nTP_PreClrTradesApprovalReqFlag = PreClrTradesApprovalReqFlag,
			--@nTP_PreClrAllowNewForOpenPreclearFlag = PreClrAllowNewForOpenPreclearFlag,
			@nPeriodType = PreClrMultipleAboveInCodeId,
			@nTP_AutoAprReqForBelowEnteredValue = PreClrTradesAutoApprovalReqFlag,
			@nTP_PreclearanceRequestSingleOrMultiple = PreClrSingMultiPreClrFlagCodeId,
			@nTP_PreClrForAllSecuritiesFlag = PreClrForAllSecuritiesFlag,
			@nTP_PreClrApprovalPreclearORPreclearTradeFlag = PreClrApprovalPreclearORPreclearTradeFlag
		FROM rul_TradingPolicy_OS
		WHERE TradingPolicyId = @nTradingPolicyId

		-- If disclosure is not continuous type, then 
		IF @nDisclosureTypeCodeId <> @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID
			-- If PCL is not requested then only evaluate if it is not required
			OR @nPreclearanceRequestId IS NOT NULL
		BEGIN
			--print 'Return 0'
			DEALLOCATE curTransDetails
			--IF (@inp_UpdateTD = 0)
			--BEGIN
			--	SELECT TransactionDetailsId FROM @tblTDIdPCLReqFlag
			--END
			RETURN 0
		END		

	--DECLARE curTransDetails CURSOR FOR
	--SELECT TransactionDetailsId, SecurityTypeCodeId, TransactionTypeCodeId, Quantity, Value
	--FROM tra_TransactionDetails
	--WHERE TransactionMasterId = @inp_nTransactionMasterId

		SELECT @dtAcqDate = MIN(DateOfAcquisition),
			@nTotQuantity = SUM(Quantity),
			@nTotValue = SUM(Value)
		FROM tra_TransactionDetails_OS 
		WHERE TransactionMasterId = @inp_nTransactionMasterId
		
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
			   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtAcqDate, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			   
			----print 'PE Start: ' + convert(varchar(11), @dtPEStartDate)
			----print 'PE END: ' + convert(varchar(11), @dtPEendDate)
		END

		INSERT INTO @tmpSecurities(SecurityTypeCodeId)
		SELECT DISTINCT SecurityTypeCodeId 
		From rul_TradingPolicyForTransactionSecurity_OS
		WHERE TradingPolicyId = @nTradingPolicyId AND MapToTypeCodeId = @nMapToTypeCodeId_Preclearance

		-- Find limit on value according to percentage specified
		SELECT top(1) @nSubCapital = Cap.PaidUpShare
		FROM mst_Company C JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID
		WHERE IsImplementing = 1
		and PaidUpAndSubscribedShareCapitalDate <= @dtAcqDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC
		
		OPEN curTransDetails

		FETCH NEXT FROM curTransDetails 
		INTO @nTransactionDetailsId, @nSecurityTypeCodeId, @nTransactionTypeCodeId, @nQuantity, @nValue

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @nIsPCLReq = 0
			-- PCL is required if selected transaction + security is listed under “Preclearance Required For”
			IF EXISTS (SELECT * FROM rul_TradingPolicyForTransactionSecurity_OS 
							WHERE MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
								AND TradingPolicyId = @nTradingPolicyId
								AND SecurityTypeCodeId = @nSecurityTypeCodeId 
								AND TransactionModeCodeId = @nTransactionTypeCodeId
							)
			BEGIN
				--print 'Security + Transaction combination exists in the trading policy'

				-----------------------------------------------------------------------------------------------------------------
				-- Check if preclearance is required or not / should it be approved automatically
				IF @nTP_PreClrTradesApprovalReqFlag = 0 -- If "Approval required for all pre-clearances" = "NO"
				BEGIN
					--print '@nTP_PreClrTradesApprovalReqFlag = 0 '
					-- Find preclearance quantity to be compared for the limit (depending on the other flags and conditions)
					IF @nTP_PreclearanceRequestSingleOrMultiple = @nTP_CONST_PreclearanceRequestSingle -- If opted "Single Pre-Clearance Request"
					BEGIN
						--print 'PreclearanceRequestSingleOrMultiple = SINGLE'
						SELECT @nSecuritiesToBeTradedQty = @nTotQuantity,
							@nSecuritiesToBeTradedValue = @nTotValue
					END
					ELSE IF @nTP_PreclearanceRequestSingleOrMultiple = @nTP_CONST_PreclearanceRequestMultiple -- If opted "Multiple Pre-Clearance Request"
					BEGIN
						--print 'PreclearanceRequestSingleOrMultiple = MULTIPLE'
						-- Check if the limits are set using "All Security Type" or "Selected Security Type"
					
						IF @nTP_PreClrApprovalPreclearORPreclearTradeFlag = @nTP_CONST_PreClrApprovalPreclear
						-- "Preclearance approval based on limit exceeding of only" = "Pre-clearance Details"
						BEGIN
							--print 'PreClrApprovalPreclearORPreclearTradeFlag = Preclearance'
							SELECT @nSecuritiesToBeTradedQty = SUM(SecuritiesToBeTradedQty) + @nTotQuantity,
								@nSecuritiesToBeTradedValue = SUM(SecuritiesToBeTradedValue) + @nTotValue
							FROM tra_PreclearanceRequest_NonImplementationCompany
							WHERE UserInfoId = @nUserInfoId
								AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR SecurityTypeCodeId = @nSecurityTypeCodeId)
								AND CreatedOn >= @dtPEStartDate
								AND (@inp_UpdateTD = 1 OR CreatedOn <= @dtAcqDate)
							
							--print 'DEbug 1 @nSecuritiesToBeTradedQty ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedQty,0))
							--print 'DEbug 1 @nSecuritiesToBeTradedValue ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedValue,0))
							
							IF @nSecuritiesToBeTradedQty IS NULL
							BEGIN
								SELECT @nSecuritiesToBeTradedQty = @nTotQuantity,
									@nSecuritiesToBeTradedValue = @nTotValue
							END

						END
						ELSE -- @nTP_PreClrApprovalPreclearORPreclearTradeFlag = @nTP_CONST_PreClrApprovalPreclearTrade
						-- "Preclearance approval based on limit exceeding of only" = "Pre-clearance + Trade Details"
						BEGIN
							--print 'PreClrApprovalPreclearORPreclearTradeFlag = Preclearance + Trade Details'							
							SELECT @nSecuritiesToBeTradedQty = SUM(ISNULL(TD.Quantity, 0)) + @nTotQuantity,
								@nSecuritiesToBeTradedValue = SUM(ISNULL(Value, 0)) + @nTotValue
							FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
								JOIN @tmpSecurities tmpSecurities ON tmpSecurities.SecurityTypeCodeId = TD.SecurityTypeCodeId
							WHERE UserInfoId = @nUserInfoId
								AND TM.DisclosureTypeCodeId <> 147001 -- Do not consider initial disclosures
								AND TransactionStatusCodeId > 148002 -- Consider transactions which are submitted
								AND DateOfAcquisition >= @dtPEStartDate
								AND (@inp_UpdateTD = 1 OR DateOfAcquisition <= @dtAcqDate)
								AND (@nTP_PreClrForAllSecuritiesFlag = @nTP_CONST_PreClrForAllSecurities OR TD.SecurityTypeCodeId = @nSecurityTypeCodeId)

							--print 'DEbug 2 @nSecuritiesToBeTradedQty ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedQty,0))
							--print 'DEbug 3 @nSecuritiesToBeTradedValue ' + convert(varchar(10), ISNULL(@nSecuritiesToBeTradedValue,0))
								
							IF @nSecuritiesToBeTradedQty IS NULL
							BEGIN
								SELECT @nSecuritiesToBeTradedQty = @nTotQuantity,
									@nSecuritiesToBeTradedValue = @nTotValue
							END

						END
					END

					-- Fetch limits for the selected/all securities set in the trading policy
					SELECT @nSecurityQtyLimit = TPSecLimit.NoOfShares,
						@nSecurityValueLimit = TPSecLimit.ValueOfShares,
						@nSecurityPercentageLimit = TPSecLimit.PercPaidSubscribedCap
					FROM rul_TradingPolicySecuritywiseLimits_OS TPSecLimit
					WHERE TradingPolicyId = @nTradingPolicyId
					AND MapToTypeCodeId = @nMapToTypeCodeId_Preclearance
					AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @nSecurityTypeCodeId)
					

					SELECT @nPerOfSubCapital = ISNULL(@nSecurityPercentageLimit, 0) * ISNULL(@nSubCapital, 0) / 100.0

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
					
					--print '@nSecurityQtyLimit = ' + convert(varchar(15), @nSecurityQtyLimit)
					--print '@nSecuritiesToBeTradedQty = ' + convert(varchar(15), @nSecuritiesToBeTradedQty)
					--print '@@nSecurityValueLimit = ' + convert(varchar(15), @nSecurityValueLimit)
					--print '@@nSecuritiesToBeTradedValue = ' + convert(varchar(15), @nSecuritiesToBeTradedValue)
					--print '@@nSecurityPercentageLimit = ' + convert(varchar(15), @nSecurityPercentageLimit)
					--print '@@nPerOfSubCapital = ' + convert(varchar(15), @nPerOfSubCapital)
					
					IF @bIsWithinLimits = @bWithinLimit
					BEGIN
						--IF @nTP_AutoAprReqForBelowEnteredValue = 0 -- Auto approval is not req below the entered value
						--BEGIN
						--	SET @out_nReturnValue = @ERR_PRECLEARANCENOTNEEDED_VALUESWITHINLIMIT
						--	RETURN @out_nReturnValue
						--END
						--ELSE
						IF @nTP_AutoAprReqForBelowEnteredValue = 1 -- Auto approval is req below entered value
						BEGIN
							-- Here preclearance was required, only thing it would have got approved automatically
							-- Set IsPCLReq = 1
							--SET @out_iIsAutoApproved = 1
							SET @nIsPCLReq = 1
						END
					END
					ELSE -- This is the case when the the transaction details crossing limit, so PCL was required, set the flag
					BEGIN
						SET @nIsPCLReq = 1
					END
				END
				ELSE
				BEGIN
					-- Approval is reuired for all trades
					--print '@nTP_PreClrTradesApprovalReqFlag = 1'
					SET @nIsPCLReq = 1
				END

				
				IF @nIsPCLReq = 1
				BEGIN
					--print 'Update TD for Details Id ' + CONVERT(varchar(10), @nTransactionDetailsId)
					IF (@inp_UpdateTD = 1)
					BEGIN
					print '@inp_UpdateTD'
						--UPDATE tra_TransactionDetails_OS SET IsPLCReq = 1 WHERE TransactionDetailsId = @nTransactionDetailsId
					END
					ELSE
					BEGIN
						INSERT INTO @tblTDIdPCLReqFlag(TransactionDetailsId, IsPCLReq)
						VALUES(@nTransactionDetailsId,1)
					END
				END
				-----------------------------------------------------------------------------------------------------------------
			END
			
			FETCH NEXT FROM curTransDetails 
			INTO @nTransactionDetailsId, @nSecurityTypeCodeId, @nTransactionTypeCodeId, @nQuantity, @nValue

		END
		
		CLOSE curTransDetails;
		DEALLOCATE curTransDetails;
		
		--print 'Clsing cursor curTransDetails.......END'
		IF (@inp_UpdateTD = 0)
		BEGIN
			SELECT TransactionDetailsId FROM @tblTDIdPCLReqFlag
		END
		--print 'returning ' + convert(varchar(10), @out_nReturnValue)
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONMASTER_PCLReqFlag, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END