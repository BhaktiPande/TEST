IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyDetails')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TradingPolicy details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		25-Mar-2015

Modification History:
Modified By		Modified On		Description
Ashashree		31-Mar-2015		Adding the error codes for error handling
Ashashree		02-Apr-2015		Adding the new fields - DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, 
								DiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit
Tushar			07-Apr-2015		Add Column for 1) Softcopy and Hardcopy required for Initial, Continuous and Period End Disclosure
											   2) Trading Details to be submitted by Insider/Employee to CO within ----- 
											   days after trade is performed	 
Tushar			14-Apr-2015		Add Column in Trade Continous Disclosures  Hardcopy and softcopy.
Tushar			25-May-2015		New Column add PreClrForAllSecuritiesFlag,StExForAllSecuritiesFlag 
Tushar			26-Aug-2015		New Column add PreClrAllowNewForOpenPreclearFlag,PreClrAllowNewForOpenPreclearFlag,
								PreClrMultipleAboveInCodeId,PreClrApprovalPreclearORPreclearTradeFlag 
Tushar			23-Nov-2015		Add New column for Contra Trade change and edit continuous disclosure format.
Parag			18-Dec-2015		Get column value for trading threshold limit reset flag
Tushar          30-mar-2016		Get Column value for trading ContraTradeBasedOn.
AniketS			2-Jun-2016		Fetch new column for UPSI declaration on Continuous Disclosures page(YES BANK customization)
Tushar			08-Sep-2016		Fetch new column for IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure

Usage:
EXEC st_rul_TradingPolicyDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicyDetails]
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
		IF (NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy WHERE TradingPolicyId = @inp_iTradingPolicyId))
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
				TradingThresholdLimtResetFlag,ContraTradeBasedOn, SeekDeclarationFromEmpRegPossessionOfUPSIFlag, DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, DeclarationToBeMandatoryFlag, DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
				IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag
		FROM rul_TradingPolicy
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