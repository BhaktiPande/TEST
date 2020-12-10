IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterConfirm')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterConfirm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Create and fetch TradingTransaction Master details

Returns:		0, if Success.
				
Created by:		Amar
Created on:		07-May-2015

Modification History:
Modified By		Modified On	Description
Arundhati		25-May-2015	Added checks of single and multiple transaction to decide the soft copy and hard copy required flags in case of continuous disclosure.
Arundhati		29-May-2015	Added condition of SubmissionForAllTrade flag
Arundhati		02-Jun-2015	Partially traded flag was getting reset to 0 in case of soft copy/hard copy submission. It is corretced now.
Arundhati		01-Jul-2015	While applying rule, consider value and % limit also.
Arundhati		08-Jul-2015	For period end disclosure, do not calculate PeriodEnd date. Use the date as it is from TrnsactionMaster
Arundhati		16-Jul-2015	Column name used was wrong instead of TransactionMasterId, TransactionLetterId was used
Arundhati		18-Jul-2015	If rul is set for "All" security limits for continuous, then take the sum irrespective of security type, and set the flags
							Do not consider trade count from Initial disclosure while applying rule on multiple transactions
Arundahti		05-Aug-2015	Changes related to Partial Trading
Parag			09-Oct-2015		Made change for period end disclouser, get period end type set in trading policy 
Parag			29-Oct-2015		Made change for disclouser that do not update "Period End Date" when confirm transaction 
Parag			23-Nov-2015		Made change to handle condition when period end disclosure is not applicable for user
Arundhati		23-Dec-2015	Changes made to evaluate flag based on the threshold limit reset flag.
Parag			28-Jan-2016		Made change to fix issue of threshold limit not working ie last submitted transcation details being getting included 
Parag			15-Feb-2016		Made change to fix issue of Softcopy and hard copy flag is not set properly when period end disclosure is not required 
Parag			09-May-2016		Made change to save users details when transcation details are submitted and soft-copy form is submitted 
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC [st_tra_TradingTransactionMasterCreate] 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterConfirm] 
	@inp_iTransactionMasterId		BIGINT,
	@inp_nUserId					INT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @nDisclosureType INT
	DECLARE @nTradingPolicyId INT
	DECLARE @nSoftCopyReqFlag INT
	DECLARE @nHardCopyReqFlag INT
	DECLARE @nIsMultipleTrans INT = 0
	DECLARE @nTransLimit INT = NULL
	DECLARE @nValueLimit DECIMAL(18,4) = NULL
	DECLARE @nPercentageLimit DECIMAL(15,4) = NULL
	DECLARE @nUpdateToConfirmFlag INT = 0
	DECLARE @nPartiallyTradedFlag INT = 0
	DECLARE @nShowAddButtonFlag INT = 1
	DECLARE @nPreclearanceId INT = 0
	DECLARE @nPre_ProposedSharesToBeTraded INT
	DECLARE @nSecurityTypeCodeId INT
	
	DECLARE @nStatusCodeId INT

	DECLARE @nDisclosureTypeCodeId_Initial INT = 147001
	DECLARE @nDisclosureTypeCodeId_Continuous INT = 147002
	DECLARE @nDisclosureTypeCodeId_PeriodEnd INT = 147003

	DECLARE @nTransactionStatus_DocumentUploaded INT = 148001
	DECLARE @nTransactionStatus_Confirmed INT = 148003
	DECLARE @nTransactionStatus_SoftCopySubmitted INT = 148004
	DECLARE @nTransactionStatus_HardCopySubmitted INT = 148005
	DECLARE @nTransactionStatus_HardCopySubmittedByCO INT = 148006
	DECLARE @nTransactionStatus_Submitted INT = 148007
	
	DECLARE @nTransactionTrade_Single INT = 136001
	DECLARE @nTransactionTrade_Multiple INT = 136002
	
	DECLARE @dtAcquisition DATETIME
	DECLARE @dtPeriodEndDate DATETIME
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @dtStartDate DATETIME
	DECLARE @dtEndDate DATETIME = NULL
	DECLARE @nTradeNoTillNow INT = 0
	DECLARE @nTradeValueTillNow DECIMAL(25,4) = 0
	DECLARE @nUserInfoId INT
	DECLARE @nSubmitForAll INT
	DECLARE @nStExSubmitDiscloToCOByInsdrFlag INT
	DECLARE @nStExForAllSecuritiesFlag INT
	DECLARE @nSubCapital DECIMAL(25,4)
	DECLARE @nPerOfSubCapital DECIMAL(25,4)
	DECLARE @nIsLimitSetForAllSecurities INT = 0 -- 1: Yes, 0: Securitywise

	DECLARE @nTradeNoFromInitial INT = 0
	DECLARE @nTradeValueFromInitial INT = 0
	
	DECLARE @nPeriodType INT
	
	DECLARE @nPeriodTypeThreshold INT
	DECLARE @nTradingThresholdLimtResetFlag INT = 0
	DECLARE @nStExMultiTradeFreq INT
	DECLARE @dtLastScpSubmissionDate DATETIME = '2015-01-01'
	
	DECLARE @nMaxDisplayRollingNumber BIGINT = 0
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		--print 'procedure confirm'
		SELECT @nTradingPolicyId = TradingPolicyId,
			@nDisclosureType = DisclosureTypeCodeId,
			@nStatusCodeId = TransactionStatusCodeId,
			@dtPeriodEndDate = PeriodEndDate,
			@nSecurityTypeCodeId = TM.SecurityTypeCodeId,
			@nUserInfoId = TM.UserInfoId,
			@nPartiallyTradedFlag = TM.PartiallyTradedFlag
			--@nPCLPartiallyTradedFlag = PR.IsPartiallyTraded
		FROM tra_TransactionMaster TM LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TransactionMasterId = @inp_iTransactionMasterId

		SELECT top(1) @nSubCapital = Cap.PaidUpShare
		FROM mst_Company C JOIN com_CompanyPaidUpAndSubscribedShareCapital Cap ON C.CompanyId = Cap.CompanyID
		WHERE IsImplementing = 1
		and PaidUpAndSubscribedShareCapitalDate <= dbo.uf_com_GetServerDate()
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC

		SELECT top(1) @dtAcquisition = DateOfAcquisition
		FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		--get period type from trading policy 
		SELECT @nPeriodType = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
								ELSE TP.DiscloPeriodEndFreq 
							 END,
				@nPeriodTypeThreshold = CASE 
								WHEN TP.StExMultiTradeFreq = 137001 THEN 123001 -- Yearly
								WHEN TP.StExMultiTradeFreq = 137002 THEN 123003 -- Quarterly
								WHEN TP.StExMultiTradeFreq = 137003 THEN 123004 -- Monthly
								WHEN TP.StExMultiTradeFreq = 137004 THEN 123002 -- half yearly
								ELSE TP.StExMultiTradeFreq 
							 END,
				@nTradingThresholdLimtResetFlag = ISNULL(TradingThresholdLimtResetFlag, 0)
		FROM rul_TradingPolicy TP WHERE TP.TradingPolicyId = @nTradingPolicyId
		
		IF (@nPeriodTypeThreshold IS NOT NULL)
		BEGIN
			EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
				   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtAcquisition, /*@nPeriodType*/@nPeriodTypeThreshold, 0, 
				   @dtStartDate OUTPUT, @dtEndDate OUTPUT, 
				   @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		END
		
		IF @nDisclosureType = 147003 -- For Period End date do not change the date
		BEGIN
			SELECT @dtEndDate = @dtPeriodEndDate
		END
		
		IF @nTradingPolicyId IS NOT NULL
		BEGIN
			IF @nDisclosureType = @nDisclosureTypeCodeId_Initial
			BEGIN
				--print 'initial .. trading policy = ' + convert(varchar(10), @nTradingPolicyId)
				SELECT @nSoftCopyReqFlag = ISNULL(TP.DiscloInitReqSoftcopyFlag, 0), @nHardCopyReqFlag = ISNULL(DiscloInitReqHardcopyFlag, 0)
				FROM rul_TradingPolicy TP
				WHERE TradingPolicyId = @nTradingPolicyId
			END		

			IF @nDisclosureType = @nDisclosureTypeCodeId_Continuous
			BEGIN
				--print 'conti.. trading policy = ' + convert(varchar(10), @nTradingPolicyId)
				SELECT @nSoftCopyReqFlag = ISNULL(TP.StExSubmitDiscloToCOByInsdrSoftcopyFlag, 0), @nHardCopyReqFlag = ISNULL(StExSubmitDiscloToCOByInsdrHardcopyFlag, 0),
					@nIsMultipleTrans = ISNULL(TP.StExSingMultiTransTradeFlagCodeId, 0),
					@nSubmitForAll = StExSubmitTradeDiscloAllTradeFlag,
					@nStExSubmitDiscloToCOByInsdrFlag =  StExSubmitDiscloToCOByInsdrFlag,
					@nStExForAllSecuritiesFlag=StExForAllSecuritiesFlag
				FROM rul_TradingPolicy TP
				WHERE TradingPolicyId = @nTradingPolicyId
				
				SELECT @nTransLimit = NoOfShares,
						@nValueLimit = ValueOfShares,
						@nPercentageLimit = PercPaidSubscribedCap,
						@nIsLimitSetForAllSecurities = CASE WHEN SecurityTypeCodeId IS NULL THEN 1 ELSE 0 END -- 1: For all, 0: For indiv security
				FROM rul_TradingPolicySecuritywiseLimits
				WHERE TradingPolicyId = @nTradingPolicyId
				AND MapToTypeCodeId = 132005
				AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @nSecurityTypeCodeId)
				
				SELECT @nPerOfSubCapital = @nPercentageLimit * @nSubCapital / 100.0
				
				IF @nStatusCodeId = @nTransactionStatus_Submitted
				BEGIN
					--print '@nStatusCodeId = @nTransactionStatus_Submitted'
					SELECT @nPreclearanceId = ISNULL(PreclearanceRequestId, 0) FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId
					IF @nPreclearanceId > 0
					BEGIN
						SELECT @nPre_ProposedSharesToBeTraded = PR.SecuritiesToBeTradedQty
						FROM tra_PreclearanceRequest PR WHERE PreclearanceRequestId = @nPreclearanceId
						
						IF @nPre_ProposedSharesToBeTraded > 
							--(SELECT ISNULL(SUM(TD.Quantity), 0) FROM tra_TransactionDetails TD WHERE TransactionMasterId = @inp_iTransactionMasterId)
							(SELECT SUM(ISNULL(TD.Quantity, 0) * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) TotalQty
								FROM tra_PreclearanceRequest PR JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
									JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
								WHERE TM.TransactionStatusCodeId > 148002
								AND PR.PreclearanceRequestId = @nPreclearanceId)
						BEGIN
							SET @nPartiallyTradedFlag = 1
							
							-- If all transactions are submitted, then set the flag ShowAddButton = 1
							-- Else ShowAddButton = 0
							SET @nShowAddButtonFlag = 1
							IF EXISTS(SELECT * FROM tra_TransactionMaster 
										WHERE PreclearanceRequestId = @nPreclearanceId
										AND TransactionStatusCodeId <= 148002)
							BEGIN
								SET @nShowAddButtonFlag = 0
							END
							
							UPDATE tra_PreclearanceRequest 
							SET ShowAddButton = @nShowAddButtonFlag
							WHERE PreclearanceRequestId = @nPreclearanceId
						END
						ELSE
						BEGIN
							-- IsPartiallyTraded flag in Preclearance table has default value set to 1
							-- Make it 0 is Quantity equals or exceed the preclearance quantity
							UPDATE tra_PreclearanceRequest
							SET IsPartiallyTraded = 0,
								ShowAddButton = 0
							WHERE PreclearanceRequestId = @nPreclearanceId
						END
					END
					
					IF @nStExSubmitDiscloToCOByInsdrFlag = 0
					BEGIN
						--print '@nStExSubmitDiscloToCOByInsdrFlag = 0'
						SELECT @nSoftCopyReqFlag = 0, @nHardCopyReqFlag = 0
					END
					-- If SubmitForAll is not flase, then check for if limits are applied for single or multiple transaction
					ELSE IF @nSubmitForAll = 0 AND (@nSoftCopyReqFlag = 1 OR @nHardCopyReqFlag = 1)
					BEGIN
						----SELECT top(1) @dtAcquisition = DateOfAcquisition
						----FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId
						
						--EXECUTE st_tra_PeriodEndDisclosureStartEndDate
						--	   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtAcquisition, 0, @dtStartDate OUTPUT, @dtEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
					
						IF @nIsMultipleTrans = @nTransactionTrade_Single
						BEGIN
							--print 'rule on Single transaction'
							SELECT @nTradeNoTillNow = SUM(Quantity + Quantity2),
									@nTradeValueTillNow = SUM(Value + Value2)
							FROM tra_TransactionDetails
							WHERE TransactionMasterId = @inp_iTransactionMasterId
							
							-- The limit is not crossed, then no need to submit soft copy & hard copy, so reset the flags to 0
							IF (@nTransLimit IS NULL AND @nValueLimit IS NULL AND @nPercentageLimit IS NULL)
								OR
								((@nTransLimit IS NULL OR @nTransLimit >= @nTradeNoTillNow)
									AND (@nValueLimit IS NULL OR @nValueLimit >= @nTradeValueTillNow)
									AND (@nPercentageLimit IS NULL OR @nPerOfSubCapital >= @nTradeValueTillNow))
							BEGIN
								--print 'The limit is not crossed, then no need to submit soft copy & hard copy, so reset the flags to 0'
								SELECT @nSoftCopyReqFlag = 0, @nHardCopyReqFlag = 0
							END
						END
						ELSE IF @nIsMultipleTrans = @nTransactionTrade_Multiple
						BEGIN
							IF @nTradingThresholdLimtResetFlag = 1 -- Limits should be set to 0 after submission
							BEGIN
								-- Find the last submission date where soft copy was submitted, if exists
								IF(@nStExForAllSecuritiesFlag=1)
								BEGIN
									SELECT 
										@dtLastScpSubmissionDate = ISNULL(MAX(EventDate), @dtLastScpSubmissionDate)
									FROM 
										eve_EventLog EL JOIN tra_TransactionMaster TM ON EL.MapToId = TM.TransactionMasterId AND EL.EventCodeId IN (153019, 153029)
									WHERE 
										TM.UserInfoId = @nUserInfoId AND Tm.SoftCopyReq = 1 
								END
								ELSE
								BEGIN
									SELECT 
										@dtLastScpSubmissionDate = ISNULL(MAX(EventDate), @dtLastScpSubmissionDate)
									FROM 
										eve_EventLog EL JOIN tra_TransactionMaster TM ON EL.MapToId = TM.TransactionMasterId AND EL.EventCodeId IN (153019, 153029)
									WHERE 
										TM.UserInfoId = @nUserInfoId AND Tm.SoftCopyReq = 1 AND TM.SecurityTypeCodeId=@nSecurityTypeCodeId
								END																
							END
						
							-- Find trade quantity from the last submission date (if the reset flag is true, else from default date), 
							-- and the acqusition dates should be in the period for multiple transaction rule
							SELECT @nTradeNoTillNow	= SUM(Quantity + Quantity2),
									@nTradeValueTillNow = SUM(Value + Value2)
							FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
							JOIN eve_EventLog EL ON EL.MapToId = TM.TransactionMasterId AND EL.EventCodeId IN (153019, 153029)
							WHERE TM.UserInfoId = @nUserInfoId
								AND (@nIsLimitSetForAllSecurities = 1 OR TD.SecurityTypeCodeId = @nSecurityTypeCodeId)
								AND TD.DateOfAcquisition >= @dtStartDate AND TD.DateOfAcquisition <= @dtEndDate
								AND EL.EventDate > @dtLastScpSubmissionDate
							
							/*
							-- Find trade quantity from initial if that is done during this period
							SELECT @nTradeNoFromInitial = SUM(Quantity),
									@nTradeValueFromInitial = SUM(Value)
							FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
							WHERE UserInfoId = @nUserInfoId
								AND DisclosureTypeCodeId = @nDisclosureTypeCodeId_Initial
								AND (@nIsLimitSetForAllSecurities = 1 OR TD.SecurityTypeCodeId = @nSecurityTypeCodeId)
								AND PeriodEndDate = @dtEndDate


							--print 'rule on multiple transaction'
							-- For rule using multiple transaction, take the total traiding for this period from summary table.							
							SELECT @nTradeNoTillNow	= SUM(BuyQuantity + SellQuantity) - ISNULL(@nTradeNoFromInitial, 0),
									@nTradeValueTillNow = SUM(TS.Value) - ISNULL(@nTradeValueFromInitial, 0)
							FROM tra_TransactionSummary TS
							WHERE UserInfoId = @nUserInfoId
								AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
								AND YearCodeId = @nYearCodeId
								AND PeriodCodeId = @nPeriodCodeId
							*/

							--print '@nTradeNoTillNow = ' + CONVERT(VaRCHAR(20), ISNULL(@nTradeNoTillNow, 0))
							--	+ '@nTradeValueTillNow = ' + CONVERT(VaRCHAR(20), ISNULL(@nTradeValueTillNow, 0))
							--	+ '@@nPerOfSubCapital = ' + CONVERT(VaRCHAR(20), ISNULL(@nPerOfSubCapital, 0))
							--	+ '@@nSecurityTypeCodeId = ' + CONVERT(VaRCHAR(20), ISNULL(@nSecurityTypeCodeId, 0))
								
							--print '@@nTransLimit = ' + CONVERT(VaRCHAR(20), ISNULL(@nTransLimit, 0))
							--	+ '@@nValueLimit = ' + CONVERT(VaRCHAR(20), ISNULL(@nValueLimit, 0))
							--	+ '@@nPercentageLimit = ' + CONVERT(VaRCHAR(20), ISNULL(@nPercentageLimit, 0))

							IF (@nTransLimit IS NULL AND @nValueLimit IS NULL AND @nPercentageLimit IS NULL)
								OR
								((@nTransLimit IS NULL OR @nTransLimit >= @nTradeNoTillNow)
									AND (@nValueLimit IS NULL OR @nValueLimit >= @nTradeValueTillNow)
									AND (@nPercentageLimit IS NULL OR @nPerOfSubCapital >= @nTradeValueTillNow))
							BEGIN
								--print 'Check trans limits'
								SELECT @nSoftCopyReqFlag = 0, @nHardCopyReqFlag = 0
							END
						END
					END
					
					
					IF @nPreclearanceId IS NULL OR @nPreclearanceId = 0
					BEGIN
					
						PRINT 'Calculate Max Display Rolling Number '
						-- Calculate Max Display Rolling Number 
						SELECT @nMaxDisplayRollingNumber = MAX(ISNULL(DisplayRollingNumber,0)) 
						FROM tra_TransactionMaster 
						WHERE DisclosureTypeCodeId = @nDisclosureTypeCodeId_Continuous
						SET @nMaxDisplayRollingNumber = @nMaxDisplayRollingNumber + 1
						
						UPDATE tra_TransactionMaster
						SET DisplayRollingNumber = @nMaxDisplayRollingNumber
						WHERE TransactionMasterId = @inp_iTransactionMasterId
					END
					
				END
				
				
				
			END		

			IF @nDisclosureType = @nDisclosureTypeCodeId_PeriodEnd
			BEGIN
				--print 'PE.. trading policy = ' + convert(varchar(10), @nTradingPolicyId)
				SELECT @nSoftCopyReqFlag = ISNULL(TP.DiscloPeriodEndReqSoftcopyFlag, 0), @nHardCopyReqFlag = ISNULL(DiscloPeriodEndReqHardcopyFlag, 0)
				FROM rul_TradingPolicy TP
				WHERE TradingPolicyId = @nTradingPolicyId
			END		
		
		END
		
				
		---------------------------------------------------------------------------------------------------------
		-- Update Status to confirmed
		--print '@nStatusCodeId = ' + convert(varchar(10), @nStatusCodeId)
		--print '@nSoftCopyReqFlag = ' + convert(varchar(10), @nSoftCopyReqFlag)
		--print '@nHardCopyReqFlag = ' + convert(varchar(10), @nHardCopyReqFlag)
		
		If ((@nStatusCodeId = @nTransactionStatus_Submitted AND @nSoftCopyReqFlag = 0 AND @nHardCopyReqFlag = 0)
			OR (@nStatusCodeId = @nTransactionStatus_SoftCopySubmitted AND @nHardCopyReqFlag = 0)
			OR (@nStatusCodeId = @nTransactionStatus_HardCopySubmitted))
		BEGIN
			--print 'confirm flag set to 1'
			SET @nUpdateToConfirmFlag = 1
		END
		
		DECLARE @nTotTradeValue DECIMAL(10,0)=0		
		IF(@nSoftCopyReqFlag=1)
		BEGIN					
			CREATE TABLE #tmptransactionID
			(
			TMID BIGINT
			)			
			INSERT INTO #tmptransactionID
			EXEC st_tra_TransactionIdsForLetter @inp_iTransactionMasterId

			SELECT @nTotTradeValue=SUM(TD.Value) FROM tra_TransactionDetails TD JOIN #tmptransactionID transID
			ON TD.TransactionMasterId=transID.TMID
			
			UPDATE tra_TransactionMaster 
			SET TotalTradeValue=@nTotTradeValue
			WHERE TransactionMasterId = @inp_iTransactionMasterId
			
			DROP TABLE #tmptransactionID		
		END		
				
		UPDATE tra_TransactionMaster 
		SET SoftCopyReq = @nSoftCopyReqFlag,
			HardCopyReq = @nHardCopyReqFlag,
			PartiallyTradedFlag = @nPartiallyTradedFlag,			
			TransactionStatusCodeId = CASE WHEN @nUpdateToConfirmFlag = 1 THEN @nTransactionStatus_Confirmed ELSE @nStatusCodeId END			
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		-----------------------------------------------End Update Status to confirmed ------------------------------
		
		DECLARE @bFormDetails BIT = 0
		
		-- check if status is updated to confirm ie transaction details submitted OR soft-copy submitted and save user details 
		IF (@nStatusCodeId = @nTransactionStatus_Submitted ) -- transcation submitted
		BEGIN
			print 'save users details for per transaction details'
			
			-- save user details for each transaction details
			EXEC st_tra_TradingTransactionUserDetailsSave
					@inp_iTransactionMasterId,
					@bFormDetails,
					@out_nReturnValue,
					@out_nSQLErrCode,
					@out_sSQLErrMessage
			
			-- check if any error 
			IF @out_nReturnValue <> 0
			BEGIN
				RETURN @out_nReturnValue
			END
		END
		-- soft copy submitted OR if soft-copy is not required and stock exchange submitted
		ELSE IF (@nStatusCodeId = @nTransactionStatus_SoftCopySubmitted 
					OR (@nSoftCopyReqFlag = 0 AND @nStatusCodeId = @nTransactionStatus_HardCopySubmittedByCO) )
		BEGIN
			print 'save users details for form submitted'
			
			-- NOTE - Form details are save only once. 
			-- When soft-copy is required then save letter details but for stock exchange do not save details (use soft-copy details for stock exchange)
			-- When soft-copy is NOT required then save letter details for stock exchange only 
			
			SET @bFormDetails = 1
			
			-- save user details for letter
			EXEC st_tra_TradingTransactionUserDetailsSave
					@inp_iTransactionMasterId,
					@bFormDetails,
					@out_nReturnValue,
					@out_nSQLErrCode,
					@out_sSQLErrMessage
			
			IF @out_nReturnValue <> 0
			BEGIN
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
		SET @out_nReturnValue  = -1 --dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END