IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyDetails_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ======================================================================================================

--Description:	Marks the Trading Policy details is fetch.

-- Author      :Rajashri Sathe

-- ======================================================================================================*/

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyDetails_OS]
	@inp_iTradingPolicyId INT,							-- Id of the TradingPolicy whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGPOLICY_GETDETAILS INT
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND INT

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
		

		--Initialize variables
		SELECT	@ERR_TRADINGPOLICY_NOTFOUND = 15059, /*Trading Policy does not exist.*/
				@ERR_TRADINGPOLICY_GETDETAILS = 15058 /*Error occurred while fetching trading policy details.*/

		--Check if the TradingPolicy whose details are being fetched exists
		IF (NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_iTradingPolicyId))
		BEGIN	
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
		--Fetch the TradingPolicy details
		SELECT	TradingPolicyId, TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, 
				TradingPolicyName, TradingPolicyDescription, ApplicableFromDate, ApplicableToDate, 
				PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap, 
				PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, 
				PreClrSeekDeclarationForUPSIFlag, PreClrUPSIDeclaration, 
				PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag, 
				PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, 
				StExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId, 
				StExMultiTradeFreq, StExMultiTradeCalFinYear, 
				StExTransTradeNoShares, StExTransTradePercPaidSubscribedCap, StExTransTradeShareValue, StExTradeDiscloSubmitLimit, 
				DiscloInitReqFlag, DiscloInitLimit, DiscloInitDateLimit, 
				DiscloPeriodEndReqFlag, DiscloPeriodEndFreq, 
				GenSecurityType, GenTradingPlanTransFlag, GenMinHoldingLimit, 
				GenContraTradeNotAllowedLimit, GenExceptionFor, TradingPolicyStatusCodeId,
				DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, DiscloPeriodEndToCOByInsdrLimit, 
				DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit,
				DiscloInitReqSoftcopyFlag,DiscloInitReqHardcopyFlag,DiscloInitSubmitToStExByCOSoftcopyFlag,
				DiscloInitSubmitToStExByCOHardcopyFlag,StExTradePerformDtlsSubmitToCOByInsdrLimit,StExSubmitDiscloToStExByCOSoftcopyFlag,
				StExSubmitDiscloToStExByCOHardcopyFlag,DiscloPeriodEndReqSoftcopyFlag,DiscloPeriodEndReqHardcopyFlag,
				DiscloPeriodEndSubmitToStExByCOSoftcopyFlag,DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
				StExSubmitDiscloToCOByInsdrFlag,StExSubmitDiscloToCOByInsdrSoftcopyFlag,StExSubmitDiscloToCOByInsdrHardcopyFlag,
				PreClrForAllSecuritiesFlag,StExForAllSecuritiesFlag,
				PreClrAllowNewForOpenPreclearFlag,PreClrAllowNewForOpenPreclearFlag,PreClrMultipleAboveInCodeId,PreClrApprovalPreclearORPreclearTradeFlag,
				PreClrTradesAutoApprovalReqFlag,PreClrSingMultiPreClrFlagCodeId,
				GenCashAndCashlessPartialExciseOptionForContraTrade,GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate, 
				TradingThresholdLimtResetFlag,177001 as  ContraTradeBasedOn, SeekDeclarationFromEmpRegPossessionOfUPSIFlag, DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, DeclarationToBeMandatoryFlag, DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
				IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag,IsPreClearanceRequired,
				Id	,SearchType,	SearchLimit,	ApprovalType,	IsDematAllowed,	IsFormFRequired
		FROM rul_TradingPolicy_OS TP join rl_RestrictedListConfig rl on TP.RestrictedListConfigId=rl.Id
		WHERE TradingPolicyId = @inp_iTradingPolicyId
		AND IsDeletedFlag = 0 /*Get details of non-deleted record only*/
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRADINGPOLICY_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END