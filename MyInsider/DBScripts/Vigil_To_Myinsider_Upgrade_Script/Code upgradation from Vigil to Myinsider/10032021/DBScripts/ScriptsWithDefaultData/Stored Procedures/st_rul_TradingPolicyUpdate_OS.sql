
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyUpdate_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyUpdate_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Author      :Rajashri Sathe
-- CREATED DATE:22 July 2020
-- Description : Script for Trading Policy Other security update when satus is incomplete
--======================================================================================================

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyUpdate_OS] 
	@inp_iTradingPolicyId												INT,
	@inp_iTradingPolicyParentId											INT,
	@inp_iCurrentHistoryCodeId											INT,
	@inp_iTradingPolicyForCodeId										INT,
	@inp_sTradingPolicyName												NVARCHAR(100),
	@inp_sTradingPolicyDescription										NVARCHAR(1024),
	@inp_dtApplicableFromDate											DATETIME,
	@inp_dtApplicableToDate												DATETIME,
	@inp_bPreClrTradesApprovalReqFlag									BIT,
	@inp_iPreClrSingleTransTradeNoShares								INT,
	@inp_iPreClrSingleTransTradePercPaidSubscribedCap					DECIMAL(15,4),
	@inp_bPreClrProhibitNonTradePeriodFlag								BIT,
	@inp_iPreClrCOApprovalLimit											INT,
	@inp_iPreClrApprovalValidityLimit									INT,
	@inp_bPreClrSeekDeclarationForUPSIFlag								BIT,
	@inp_sPreClrUPSIDeclaration											VARCHAR(5000),
	@inp_bPreClrReasonForNonTradeReqFlag								BIT,
	@inp_bPreClrCompleteTradeNotDoneFlag								BIT,
	@inp_bPreClrPartialTradeNotDoneFlag									BIT,
	@inp_iPreClrTradeDiscloLimit										INT,
	@inp_iPreClrTradeDiscloShareholdLimit								INT,
	@inp_bStExSubmitTradeDiscloAllTradeFlag								BIT,
	@inp_iStExSingMultiTransTradeFlagCodeId								INT,
	@inp_iStExMultiTradeFreq											INT,
	@inp_iStExMultiTradeCalFinYear										INT,
	@inp_iStExTransTradeNoShares										INT,
	@inp_iStExTransTradePercPaidSubscribedCap							DECIMAL(15,4),
	@inp_iStExTransTradeShareValue										INT,
	@inp_iStExTradeDiscloSubmitLimit									INT,
	@inp_bDiscloInitReqFlag												BIT,
	@inp_iDiscloInitLimit												INT,
	@inp_dtDiscloInitDateLimit											DATETIME,
	@inp_bDiscloPeriodEndReqFlag										BIT,
	@inp_iDiscloPeriodEndFreq											INT,
	@inp_sGenSecurityType												VARCHAR(1024),
	@inp_bGenTradingPlanTransFlag										BIT,
	@inp_iGenMinHoldingLimit											INT,
	@inp_iGenContraTradeNotAllowedLimit									INT,
	@inp_sGenExceptionFor												VARCHAR(1024),
	@inp_iTradingPolicyStatusCodeId										INT,
	@inp_bDiscloInitSubmitToStExByCOFlag								BIT,
	@inp_bStExSubmitDiscloToStExByCOFlag								BIT,
	@inp_iDiscloPeriodEndToCOByInsdrLimit								INT,
	@inp_bDiscloPeriodEndSubmitToStExByCOFlag							BIT, 
	@inp_iDiscloPeriodEndSubmitToStExByCOLimit							INT,
	--New Column added on 07 Apr 2015
	@inp_bDiscloInitReqSoftcopyFlag										BIT,
	@inp_bDiscloInitReqHardcopyFlag										BIT,
	@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag						BIT,
	@inp_bDiscloInitSubmitToStExByCOHardcopyFlag						BIT,
	@inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit					INT,
	@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag						BIT,
	@inp_bStExSubmitDiscloToStExByCOHardcopyFlag						BIT,
	@inp_bDiscloPeriodEndReqSoftcopyFlag								BIT,
	@inp_bDiscloPeriodEndReqHardcopyFlag								BIT,
	@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag					BIT,
	@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag					BIT,
	--End Here
	--New Column 14-Apr-2014
	@inp_bStExSubmitDiscloToCOByInsdrFlag								BIT,
	@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag						BIT,
	@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag						BIT,
	--End Here
	@inp_bPreClrForAllSecuritiesFlag									BIT,
	@inp_bStExForAllSecuritiesFlag										BIT,
	@inp_sSelectedPreClearancerequiredforTransactionValue				VARCHAR(1024),
	@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue	VARCHAR(1024),
	@inp_tblPreClearanceSecuritywise SecuritywiseLimitsType				READONLY,
	@inp_tblContinousSecuritywise SecuritywiseLimitsType				READONLY,
	
	--New Column Add 25-Aug-2015
	@inp_tblPreclearanceTransactionSecurityMap TradingPolicyForTransactionSecurityMap   READONLY,
	@inp_bPreClrAllowNewForOpenPreclearFlag							    BIT,
	@inp_iPreClrMultipleAboveInCodeId									INT,
	@inp_iPreClrApprovalPreclearORPreclearTradeFlag						INT,
	@inp_bPreClrTradesAutoApprovalReqFlag								BIT,
	@inp_iPreClrSingMultiPreClrFlagCodeId								INT,
	
	@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade			INT,
	@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate		BIT,
	@inp_bTradingThresholdLimtResetFlag									BIT,
	@inp_nContraTradeBasedOn											INT,
	@inp_sSelectedContraTradeSecuirtyType								VARCHAR(1024),
	@inp_nUserId														INT,				-- Id of the user inserting/updating the TradingPolicy	
	@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag					BIT = NULL,
	@inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures			VARCHAR(MAX) = NULL,
	@inp_DeclarationToBeMandatoryFlag									BIT = NULL,
	@inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag	BIT = NULL,	
	@inp_bIsPreclearanceFormForImplementingCompany						BIT,
	@inp_iPreclearanceWithoutPeriodEndDisclosure						INT,	
	@inp_bPreClrApprovalReasonReqFlag									BIT = NULL,	
	@inp_bIsPreClearanceRequired										BIT,
	@inp_iRestrictedListConfigId										INT,
	--@inp_iId														   INT,
	--@inp_iSearchType			                                       INT,
 --   @inp_iSearchLimit			                                       INT,
	--@inp_iApprovalType			                                       INT,	
	--@inp_bIsDematAllowed		                                       BIT = NULL,	
	--@inp_bIsFormFRequired		                                       BIT = NULL,

	@out_nReturnValue													INT = 0 OUTPUT,
	@out_nSQLErrCode													INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage													NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	-- Variable Declaration
	DECLARE @ERR_TRADINGPOLICY_SAVE				INT		
	DECLARE @nTPStatusIncomplete				INT
	DECLARE @nTPStatusActive					INT
	DECLARE @nTPStatusInactive					INT
	DECLARE	@nTPExistingStatus					INT	
	DECLARE @dtCurrentDate						DATETIME
	DECLARE	@dtExistingAppFromDate				DATETIME
	DECLARE	@dtExistingAppToDate				DATETIME
	DECLARE	@nTPCurrentRecordCode				INT
	DECLARE	@nTPHistoryRecordCode				INT
	DECLARE	@nExistingParentId					INT	
	--DECLARE @nPrevTradingPolicyId				INT				--This will store the TradingPolicyId for the record that gets marked as History, to copy over applicability from this history record to the newly added current record
	DECLARE @TradingPolicyInsiderTypeCode		INT
	DECLARE @nNewTradingPolicyParentId			INT	
	DECLARE @nRetValue							INT

	BEGIN TRY


	SELECT	@nTPStatusIncomplete			= 141001,
				@nTPStatusActive				= 141002,
				@nTPStatusInactive				= 141003
				
		SELECT	@nTPCurrentRecordCode			= 134001,
				@nTPHistoryRecordCode			= 134002
		
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
			SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
			
			--Fetch the already existing applicable dates and status of the trading policy
			SELECT @dtExistingAppFromDate = ApplicableFromDate, @dtExistingAppToDate = ApplicableToDate, 
				   @nTPExistingStatus = TradingPolicyStatusCodeId,@nNewTradingPolicyParentId = TradingPolicyParentId 
			FROM rul_TradingPolicy_OS
			WHERE TradingPolicyId = @inp_iTradingPolicyId

		--Check the trading policy Status is incomplet or Active/Inactive 
		
		IF(@nTPExistingStatus = @nTPStatusIncomplete OR DATEDIFF(DAY,@dtCurrentDate,@dtExistingAppFromDate) > 0)
		BEGIN
		
					SET @inp_iCurrentHistoryCodeId = @nTPCurrentRecordCode		
					IF @nNewTradingPolicyParentId IS NULL
					BEGIN	
						SET @inp_iTradingPolicyParentId = NULL
					END
					ELSE
					BEGIN
						SET @inp_iTradingPolicyParentId = @nNewTradingPolicyParentId
					END					
					UPDATE	rul_TradingPolicy_OS
					SET 	TradingPolicyParentId = @inp_iTradingPolicyParentId, 
							CurrentHistoryCodeId = @inp_iCurrentHistoryCodeId,		
							TradingPolicyForCodeId = @inp_iTradingPolicyForCodeId, 
							TradingPolicyName = @inp_sTradingPolicyName,
						    TradingPolicyDescription = @inp_sTradingPolicyDescription, 
							ApplicableFromDate = @inp_dtApplicableFromDate,
						    ApplicableToDate = @inp_dtApplicableToDate, 
							PreClrTradesApprovalReqFlag = @inp_bPreClrTradesApprovalReqFlag, 
							PreClrSingleTransTradeNoShares = @inp_iPreClrSingleTransTradeNoShares, 
							PreClrSingleTransTradePercPaidSubscribedCap = @inp_iPreClrSingleTransTradePercPaidSubscribedCap,
							PreClrProhibitNonTradePeriodFlag = @inp_bPreClrProhibitNonTradePeriodFlag,
							PreClrCOApprovalLimit = @inp_iPreClrCOApprovalLimit,
							PreClrApprovalValidityLimit = @inp_iPreClrApprovalValidityLimit, 
							PreClrSeekDeclarationForUPSIFlag = @inp_bPreClrSeekDeclarationForUPSIFlag,
							PreClrUPSIDeclaration = @inp_sPreClrUPSIDeclaration, 
							PreClrReasonForNonTradeReqFlag = @inp_bPreClrReasonForNonTradeReqFlag,
							PreClrCompleteTradeNotDoneFlag = @inp_bPreClrCompleteTradeNotDoneFlag, 
							PreClrPartialTradeNotDoneFlag = @inp_bPreClrPartialTradeNotDoneFlag,
							PreClrTradeDiscloLimit = @inp_iPreClrTradeDiscloLimit,
							PreClrTradeDiscloShareholdLimit = @inp_iPreClrTradeDiscloShareholdLimit,
							StExSubmitTradeDiscloAllTradeFlag = @inp_bStExSubmitTradeDiscloAllTradeFlag,
							StExSingMultiTransTradeFlagCodeId = @inp_iStExSingMultiTransTradeFlagCodeId,
							StExMultiTradeFreq = @inp_iStExMultiTradeFreq, 
							StExMultiTradeCalFinYear = @inp_iStExMultiTradeCalFinYear,
							StExTransTradeNoShares = @inp_iStExTransTradeNoShares,
							StExTransTradePercPaidSubscribedCap = @inp_iStExTransTradePercPaidSubscribedCap,
							StExTransTradeShareValue = @inp_iStExTransTradeShareValue,
							StExTradeDiscloSubmitLimit = @inp_iStExTradeDiscloSubmitLimit,
							DiscloInitReqFlag = @inp_bDiscloInitReqFlag,
							DiscloInitLimit = @inp_iDiscloInitLimit,
							DiscloInitDateLimit = @inp_dtDiscloInitDateLimit,
							DiscloPeriodEndReqFlag = @inp_bDiscloPeriodEndReqFlag,
							DiscloPeriodEndFreq = @inp_iDiscloPeriodEndFreq, 
							GenSecurityType = @inp_sGenSecurityType,
							GenTradingPlanTransFlag = @inp_bGenTradingPlanTransFlag,
							GenMinHoldingLimit = @inp_iGenMinHoldingLimit,
							GenContraTradeNotAllowedLimit = @inp_iGenContraTradeNotAllowedLimit,
							GenExceptionFor = @inp_sGenExceptionFor,
							TradingPolicyStatusCodeId = @inp_iTradingPolicyStatusCodeId,
							DiscloInitSubmitToStExByCOFlag = @inp_bDiscloInitSubmitToStExByCOFlag,
							StExSubmitDiscloToStExByCOFlag = @inp_bStExSubmitDiscloToStExByCOFlag,
							DiscloPeriodEndToCOByInsdrLimit = @inp_iDiscloPeriodEndToCOByInsdrLimit, 
							DiscloPeriodEndSubmitToStExByCOFlag = @inp_bDiscloPeriodEndSubmitToStExByCOFlag, 
							DiscloPeriodEndSubmitToStExByCOLimit = @inp_iDiscloPeriodEndSubmitToStExByCOLimit,
							DiscloInitReqSoftcopyFlag = @inp_bDiscloInitReqSoftcopyFlag,
							DiscloInitReqHardcopyFlag = @inp_bDiscloInitReqHardcopyFlag,
							DiscloInitSubmitToStExByCOSoftcopyFlag = @inp_bDiscloInitSubmitToStExByCOSoftcopyFlag,
							DiscloInitSubmitToStExByCOHardcopyFlag = @inp_bDiscloInitSubmitToStExByCOHardcopyFlag,
							StExTradePerformDtlsSubmitToCOByInsdrLimit = @inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit,
							StExSubmitDiscloToStExByCOSoftcopyFlag = @inp_bStExSubmitDiscloToStExByCOSoftcopyFlag,
							StExSubmitDiscloToStExByCOHardcopyFlag = @inp_bStExSubmitDiscloToStExByCOHardcopyFlag,
							DiscloPeriodEndReqSoftcopyFlag = @inp_bDiscloPeriodEndReqSoftcopyFlag,
							DiscloPeriodEndReqHardcopyFlag = @inp_bDiscloPeriodEndReqHardcopyFlag,
							DiscloPeriodEndSubmitToStExByCOSoftcopyFlag = @inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag,
							DiscloPeriodEndSubmitToStExByCOHardcopyFlag = @inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag,
							StExSubmitDiscloToCOByInsdrFlag =  @inp_bStExSubmitDiscloToCOByInsdrFlag,
							StExSubmitDiscloToCOByInsdrSoftcopyFlag = @inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag,
							StExSubmitDiscloToCOByInsdrHardcopyFlag = @inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag,
							PreClrForAllSecuritiesFlag = @inp_bPreClrForAllSecuritiesFlag,
							StExForAllSecuritiesFlag = @inp_bStExForAllSecuritiesFlag,
							PreClrAllowNewForOpenPreclearFlag = @inp_bPreClrAllowNewForOpenPreclearFlag,
							PreClrMultipleAboveInCodeId = @inp_iPreClrMultipleAboveInCodeId,
							PreClrApprovalPreclearORPreclearTradeFlag = @inp_iPreClrApprovalPreclearORPreclearTradeFlag,
							PreClrTradesAutoApprovalReqFlag = @inp_bPreClrTradesAutoApprovalReqFlag,
							PreClrSingMultiPreClrFlagCodeId = @inp_iPreClrSingMultiPreClrFlagCodeId,
							GenCashAndCashlessPartialExciseOptionForContraTrade = @inp_iGenCashAndCashlessPartialExciseOptionForContraTrade,
							GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = @inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
							TradingThresholdLimtResetFlag = @inp_bTradingThresholdLimtResetFlag,
							ContraTradeBasedOn = @inp_nContraTradeBasedOn,
							ModifiedBy	= @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate(),							
							SeekDeclarationFromEmpRegPossessionOfUPSIFlag = @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag,
							DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = @inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures,
							DeclarationToBeMandatoryFlag = @inp_DeclarationToBeMandatoryFlag,
							DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = @inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
							IsPreclearanceFormForImplementingCompany = @inp_bIsPreclearanceFormForImplementingCompany,
							PreclearanceWithoutPeriodEndDisclosure = @inp_iPreclearanceWithoutPeriodEndDisclosure,
							PreClrApprovalReasonReqFlag = @inp_bPreClrApprovalReasonReqFlag,
							IsPreClearanceRequired = @inp_bIsPreClearanceRequired,
							RestrictedListConfigId =@inp_iRestrictedListConfigId
							
							
					WHERE TradingPolicyId = @inp_iTradingPolicyId	

					--SET @inp_iTradingPolicyId = TradingPolicyId
					EXEC @nRetValue= st_rul_Check_PreCleranceRequest_OS
								@inp_iTradingPolicyId,
								@inp_bStExSubmitTradeDiscloAllTradeFlag,
								@inp_bPreClrTradesApprovalReqFlag, 
								@inp_sGenExceptionFor, 
								@inp_tblPreClearanceSecuritywise,
								@inp_tblContinousSecuritywise,	
								@inp_tblPreclearanceTransactionSecurityMap,
								@inp_sSelectedPreClearancerequiredforTransactionValue,
								@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue,
								@inp_sSelectedContraTradeSecuirtyType,	
								@out_nReturnValue,
								@out_nSQLErrCode,				
								@out_sSQLErrMessage	
					SET @out_nReturnValue = @inp_iTradingPolicyId
			END	--(@nTPExistingStatus = @nTPStatusIncomplete)

			--Need to open if aaplicablity is done
	    ELSE --(@nTPExistingStatus = @nTPStatusActive / @nTPStatusInactive)
		
		--If Status is Active /Inactive this block is use
		BEGIN			
		print'Active'
				--Insert the value in case of status is Active and Inactive
				EXEC @nRetValue= st_rul_TradingPolicyInsertStatusActiveInactive_OS
							 @inp_iTradingPolicyId,	
							 @inp_iTradingPolicyParentId,
							 @inp_iCurrentHistoryCodeId,
							 @inp_iTradingPolicyForCodeId, 
					         @inp_sTradingPolicyName, 
							 @inp_sTradingPolicyDescription, 
							 @inp_dtApplicableFromDate, 
							 @inp_dtApplicableToDate,
					         @inp_bPreClrTradesApprovalReqFlag, 
							 @inp_iPreClrSingleTransTradeNoShares, 
							 @inp_iPreClrSingleTransTradePercPaidSubscribedCap,
					         @inp_bPreClrProhibitNonTradePeriodFlag, 
							 @inp_iPreClrCOApprovalLimit, 
							 @inp_iPreClrApprovalValidityLimit, 
							 @inp_bPreClrSeekDeclarationForUPSIFlag,
					         @inp_sPreClrUPSIDeclaration, 
							 @inp_bPreClrReasonForNonTradeReqFlag, 
							 @inp_bPreClrCompleteTradeNotDoneFlag,
					         @inp_bPreClrPartialTradeNotDoneFlag, 
							 @inp_iPreClrTradeDiscloLimit, 
							 @inp_iPreClrTradeDiscloShareholdLimit,
					         @inp_bStExSubmitTradeDiscloAllTradeFlag, 
							 @inp_iStExSingMultiTransTradeFlagCodeId, 
							 @inp_iStExMultiTradeFreq, 
							 @inp_iStExMultiTradeCalFinYear,
					         @inp_iStExTransTradeNoShares, 
							 @inp_iStExTransTradePercPaidSubscribedCap, 
							 @inp_iStExTransTradeShareValue, 
							 @inp_iStExTradeDiscloSubmitLimit,
					         @inp_bDiscloInitReqFlag, 
							 @inp_iDiscloInitLimit, 
							 @inp_dtDiscloInitDateLimit, 
							 @inp_bDiscloPeriodEndReqFlag, 
							 @inp_iDiscloPeriodEndFreq,
					         @inp_sGenSecurityType, 
							 @inp_bGenTradingPlanTransFlag, 
							 @inp_iGenMinHoldingLimit, 
							 @inp_iGenContraTradeNotAllowedLimit, 
							 @inp_sGenExceptionFor,
					         @inp_iTradingPolicyStatusCodeId, 
							 @inp_bDiscloInitSubmitToStExByCOFlag, 
							 @inp_bStExSubmitDiscloToStExByCOFlag,
					         @inp_iDiscloPeriodEndToCOByInsdrLimit, 
							 @inp_bDiscloPeriodEndSubmitToStExByCOFlag, 
							 @inp_iDiscloPeriodEndSubmitToStExByCOLimit,
					         @inp_bDiscloInitReqSoftcopyFlag,
							 @inp_bDiscloInitReqHardcopyFlag,
							 @inp_bDiscloInitSubmitToStExByCOSoftcopyFlag,
					         @inp_bDiscloInitSubmitToStExByCOHardcopyFlag,
							 @inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit,
							 @inp_bStExSubmitDiscloToStExByCOSoftcopyFlag,
					         @inp_bStExSubmitDiscloToStExByCOHardcopyFlag,
							 @inp_bDiscloPeriodEndReqSoftcopyFlag,
							 @inp_bDiscloPeriodEndReqHardcopyFlag,
					         @inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag,
							 @inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag,
					         @inp_bStExSubmitDiscloToCOByInsdrFlag,
							 @inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag,
							 @inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag,
					         @inp_bPreClrForAllSecuritiesFlag,
							 @inp_bStExForAllSecuritiesFlag,
							 @inp_sSelectedPreClearancerequiredforTransactionValue,
							 @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue,
							 @inp_tblPreClearanceSecuritywise,
							 @inp_tblContinousSecuritywise,
							 @inp_tblPreclearanceTransactionSecurityMap,
					         @inp_bPreClrAllowNewForOpenPreclearFlag,
							 @inp_iPreClrMultipleAboveInCodeId,
							 @inp_iPreClrApprovalPreclearORPreclearTradeFlag,
					         @inp_bPreClrTradesAutoApprovalReqFlag,
							 @inp_iPreClrSingMultiPreClrFlagCodeId,
					         @inp_iGenCashAndCashlessPartialExciseOptionForContraTrade,
							 @inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
					         @inp_bTradingThresholdLimtResetFlag,
							 @inp_nContraTradeBasedOn,
							 @inp_sSelectedContraTradeSecuirtyType,
					         @inp_nUserId,	
					         @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag, 
							 @inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures,
							 @inp_DeclarationToBeMandatoryFlag, 
							 @inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
					         @inp_bIsPreclearanceFormForImplementingCompany,
							 @inp_iPreclearanceWithoutPeriodEndDisclosure,
							 @inp_bPreClrApprovalReasonReqFlag,
					         @inp_bIsPreClearanceRequired,
							 @inp_iRestrictedListConfigId,							
							 @out_nReturnValue OUTPUT,
						     @out_nSQLErrCode OUTPUT,
						     @out_sSQLErrMessage OUTPUT	

					 SET @inp_iTradingPolicyId = @out_nReturnValue					
					 SET @out_nReturnValue =@inp_iTradingPolicyId
				----Define Applicability
				EXEC @nRetValue=st_rul_DefineApplicability_OS
								@inp_iTradingPolicyId,
								@inp_nUserId,   
								@out_nReturnValue,
								@out_nSQLErrCode,				
								@out_sSQLErrMessage	
		
		END
		
		RETURN @out_nReturnValue
			
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGPOLICY_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
GO


