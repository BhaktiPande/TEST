IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterConfirm_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterConfirm_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Create and fetch TradingTransaction Master details

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		22-Mar-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterConfirm_OS] 
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
			@nUserInfoId = TM.UserInfoId,
			@nPartiallyTradedFlag = TM.PartiallyTradedFlag
			--@nPCLPartiallyTradedFlag = PR.IsPartiallyTraded
		FROM tra_TransactionMaster_OS TM LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TransactionMasterId = @inp_iTransactionMasterId


		SELECT top(1) @dtAcquisition = DateOfAcquisition
		FROM tra_TransactionDetails_OS WHERE TransactionMasterId = @inp_iTransactionMasterId
		
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
		FROM rul_TradingPolicy_OS TP WHERE TP.TradingPolicyId = @nTradingPolicyId
		
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
				SELECT @nSoftCopyReqFlag = ISNULL(TP.DiscloInitReqSoftcopyFlag, 0), @nHardCopyReqFlag = ISNULL(DiscloInitReqHardcopyFlag, 0)
				FROM rul_TradingPolicy_OS TP
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
				FROM rul_TradingPolicy_OS TP
				WHERE TradingPolicyId = @nTradingPolicyId
				
				SELECT @nTransLimit = NoOfShares,
						@nValueLimit = ValueOfShares,
						@nPercentageLimit = PercPaidSubscribedCap,
						@nIsLimitSetForAllSecurities = CASE WHEN SecurityTypeCodeId IS NULL THEN 1 ELSE 0 END -- 1: For all, 0: For indiv security
				FROM rul_TradingPolicySecuritywiseLimits_OS
				WHERE TradingPolicyId = @nTradingPolicyId
				AND MapToTypeCodeId = 132005
				AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @nSecurityTypeCodeId)
				
				--SELECT @nPerOfSubCapital = @nPercentageLimit * @nSubCapital / 100.0
				
				IF @nStatusCodeId = @nTransactionStatus_Submitted
				BEGIN					
					SELECT @nPreclearanceId = ISNULL(PreclearanceRequestId, 0) FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iTransactionMasterId
					IF @nPreclearanceId > 0
					BEGIN
						SELECT @nPre_ProposedSharesToBeTraded = PR.SecuritiesToBeTradedQty
						FROM tra_PreclearanceRequest_NonImplementationCompany PR WHERE PreclearanceRequestId = @nPreclearanceId
						
						IF @nPre_ProposedSharesToBeTraded > 							
							(SELECT SUM(ISNULL(TD.Quantity, 0) * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) TotalQty
								FROM tra_PreclearanceRequest_NonImplementationCompany PR JOIN tra_TransactionMaster_OS TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
									JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
								WHERE TM.TransactionStatusCodeId > 148002
								AND PR.PreclearanceRequestId = @nPreclearanceId)
						BEGIN
							SET @nPartiallyTradedFlag = 1
							
							-- Else ShowAddButton = 0
							SET @nShowAddButtonFlag = 1
							IF EXISTS(SELECT * FROM tra_TransactionMaster_OS 
										WHERE PreclearanceRequestId = @nPreclearanceId
										AND TransactionStatusCodeId <= 148002)
							BEGIN
								SET @nShowAddButtonFlag = 0
							END
							
							UPDATE tra_PreclearanceRequest_NonImplementationCompany 
							SET ShowAddButton = @nShowAddButtonFlag
							WHERE PreclearanceRequestId = @nPreclearanceId
						END
						ELSE
						BEGIN
							-- Make it 0 is Quantity equals or exceed the preclearance quantity
							UPDATE tra_PreclearanceRequest_NonImplementationCompany
							SET IsPartiallyTraded = 0,
								ShowAddButton = 0
							WHERE PreclearanceRequestId = @nPreclearanceId
						END
					END
					
					IF @nStExSubmitDiscloToCOByInsdrFlag = 0
					BEGIN						
						SELECT @nSoftCopyReqFlag = 0, @nHardCopyReqFlag = 0
					END				
					
					IF @nPreclearanceId IS NULL OR @nPreclearanceId = 0
					BEGIN
					
						PRINT 'Calculate Max Display Rolling Number '
						-- Calculate Max Display Rolling Number 
						SELECT @nMaxDisplayRollingNumber = MAX(ISNULL(DisplayRollingNumber,0)) 
						FROM tra_TransactionMaster_OS 
						WHERE DisclosureTypeCodeId = @nDisclosureTypeCodeId_Continuous
						SET @nMaxDisplayRollingNumber = @nMaxDisplayRollingNumber + 1
						
						UPDATE tra_TransactionMaster_OS
						SET DisplayRollingNumber = @nMaxDisplayRollingNumber
						WHERE TransactionMasterId = @inp_iTransactionMasterId
					END					
				END				
			END		

			IF @nDisclosureType = @nDisclosureTypeCodeId_PeriodEnd
			BEGIN
				--print 'PE.. trading policy = ' + convert(varchar(10), @nTradingPolicyId)
				SELECT @nSoftCopyReqFlag = ISNULL(TP.DiscloPeriodEndReqSoftcopyFlag, 0), @nHardCopyReqFlag = ISNULL(DiscloPeriodEndReqHardcopyFlag, 0)
				FROM rul_TradingPolicy_OS TP
				WHERE TradingPolicyId = @nTradingPolicyId
			END		
		
		END		
		
		If ((@nStatusCodeId = @nTransactionStatus_Submitted AND @nSoftCopyReqFlag = 0 AND @nHardCopyReqFlag = 0)
			OR (@nStatusCodeId = @nTransactionStatus_SoftCopySubmitted AND @nHardCopyReqFlag = 0)
			OR (@nStatusCodeId = @nTransactionStatus_HardCopySubmitted))
		BEGIN
			--print 'confirm flag set to 1'
			SET @nUpdateToConfirmFlag = 1
		END	
				
		UPDATE tra_TransactionMaster_OS 
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
			
		END
		-- soft copy submitted OR if soft-copy is not required and stock exchange submitted
		ELSE IF (@nStatusCodeId = @nTransactionStatus_SoftCopySubmitted 
					OR (@nSoftCopyReqFlag = 0 AND @nStatusCodeId = @nTransactionStatus_HardCopySubmittedByCO) )
		BEGIN
			print 'save users details for form submitted'			
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