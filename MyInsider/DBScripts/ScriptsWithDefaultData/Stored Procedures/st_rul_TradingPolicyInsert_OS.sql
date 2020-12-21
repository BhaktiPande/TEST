
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyInsert_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyInsert_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Author      :Rajashri Sathe
-- CREATED DATE:22 July 2020
-- Description : Script for Trading Policy Other security insert into table
-- ======================================================================================================

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyInsert_OS] 
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
	@inp_bStExSubmitDiscloToCOByInsdrFlag								BIT,
	@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag						BIT,
	@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag						BIT,	
	@inp_bPreClrForAllSecuritiesFlag									BIT,
	@inp_bStExForAllSecuritiesFlag										BIT,
	@inp_sSelectedPreClearancerequiredforTransactionValue				VARCHAR(1024),
	@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue	VARCHAR(1024),
	@inp_tblPreClearanceSecuritywise SecuritywiseLimitsType				READONLY,
	@inp_tblContinousSecuritywise SecuritywiseLimitsType				READONLY,	
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
	@inp_nUserId														INT,						-- Id of the user inserting/updating the TradingPolicy	
	@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag					BIT = NULL,
	@inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures			VARCHAR(MAX) = NULL,
	@inp_DeclarationToBeMandatoryFlag									BIT = NULL,
	@inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag	BIT = NULL,	
	@inp_bIsPreclearanceFormForImplementingCompany						BIT,
	@inp_iPreclearanceWithoutPeriodEndDisclosure						INT,	
	@inp_bPreClrApprovalReasonReqFlag									BIT = NULL,

	--new column added on 22 July 2020(For Restricted List OS)
	@inp_bIsPreClearanceRequired										BIT,
	@inp_iRestrictedListConfigId										INT,
	--insert the value in new table as RestrictedListConfig
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
	DECLARE @ERR_TRADINGPOLICY_SAVE						INT	
	DECLARE @ERR_TRADINGPOLICYNAME_EXISTS				INT		
	DECLARE @nRetValue								    INT
	print'123'
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

	
		 --Save the TradingPolicy details
		 -- If Trading Policy id null then insert new record in db.
		
		BEGIN	
		
		print'11'
				   INSERT INTO rul_TradingPolicy_OS( TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, 
					TradingPolicyName, TradingPolicyDescription, ApplicableFromDate, ApplicableToDate, 
					PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap, 
					PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, PreClrSeekDeclarationForUPSIFlag, 
					PreClrUPSIDeclaration, PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, 
					PreClrPartialTradeNotDoneFlag, PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, 
					StExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId, StExMultiTradeFreq, StExMultiTradeCalFinYear, 
					StExTransTradeNoShares, StExTransTradePercPaidSubscribedCap, StExTransTradeShareValue, StExTradeDiscloSubmitLimit,
					DiscloInitReqFlag, DiscloInitLimit, DiscloInitDateLimit, DiscloPeriodEndReqFlag, DiscloPeriodEndFreq,
					GenSecurityType, GenTradingPlanTransFlag, GenMinHoldingLimit, GenContraTradeNotAllowedLimit, GenExceptionFor,
					TradingPolicyStatusCodeId, DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, 
					DiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit,
					DiscloInitReqSoftcopyFlag,DiscloInitReqHardcopyFlag,DiscloInitSubmitToStExByCOSoftcopyFlag,
					DiscloInitSubmitToStExByCOHardcopyFlag,StExTradePerformDtlsSubmitToCOByInsdrLimit,StExSubmitDiscloToStExByCOSoftcopyFlag,
					StExSubmitDiscloToStExByCOHardcopyFlag,DiscloPeriodEndReqSoftcopyFlag,DiscloPeriodEndReqHardcopyFlag,
					DiscloPeriodEndSubmitToStExByCOSoftcopyFlag,DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
					StExSubmitDiscloToCOByInsdrFlag,StExSubmitDiscloToCOByInsdrSoftcopyFlag,StExSubmitDiscloToCOByInsdrHardcopyFlag,
					PreClrForAllSecuritiesFlag,StExForAllSecuritiesFlag,
					PreClrAllowNewForOpenPreclearFlag,PreClrMultipleAboveInCodeId,PreClrApprovalPreclearORPreclearTradeFlag,
					PreClrTradesAutoApprovalReqFlag,PreClrSingMultiPreClrFlagCodeId,
					GenCashAndCashlessPartialExciseOptionForContraTrade,GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate, 
					TradingThresholdLimtResetFlag,ContraTradeBasedOn,
					CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
					SeekDeclarationFromEmpRegPossessionOfUPSIFlag, DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, DeclarationToBeMandatoryFlag, DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
					IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag,IsPreClearanceRequired,RestrictedListConfigId
					)
			VALUES (@inp_iTradingPolicyParentId, @inp_iCurrentHistoryCodeId, @inp_iTradingPolicyForCodeId, 
					@inp_sTradingPolicyName, @inp_sTradingPolicyDescription, @inp_dtApplicableFromDate, @inp_dtApplicableToDate,
					@inp_bPreClrTradesApprovalReqFlag, @inp_iPreClrSingleTransTradeNoShares, @inp_iPreClrSingleTransTradePercPaidSubscribedCap,
					@inp_bPreClrProhibitNonTradePeriodFlag, @inp_iPreClrCOApprovalLimit, @inp_iPreClrApprovalValidityLimit, @inp_bPreClrSeekDeclarationForUPSIFlag,
					@inp_sPreClrUPSIDeclaration, @inp_bPreClrReasonForNonTradeReqFlag, @inp_bPreClrCompleteTradeNotDoneFlag,
					@inp_bPreClrPartialTradeNotDoneFlag, @inp_iPreClrTradeDiscloLimit, @inp_iPreClrTradeDiscloShareholdLimit,
					@inp_bStExSubmitTradeDiscloAllTradeFlag, @inp_iStExSingMultiTransTradeFlagCodeId, @inp_iStExMultiTradeFreq, @inp_iStExMultiTradeCalFinYear,
					@inp_iStExTransTradeNoShares, @inp_iStExTransTradePercPaidSubscribedCap, @inp_iStExTransTradeShareValue, @inp_iStExTradeDiscloSubmitLimit,
					@inp_bDiscloInitReqFlag, @inp_iDiscloInitLimit, @inp_dtDiscloInitDateLimit, @inp_bDiscloPeriodEndReqFlag, @inp_iDiscloPeriodEndFreq,
					@inp_sGenSecurityType, @inp_bGenTradingPlanTransFlag, @inp_iGenMinHoldingLimit, @inp_iGenContraTradeNotAllowedLimit, @inp_sGenExceptionFor,
					@inp_iTradingPolicyStatusCodeId, @inp_bDiscloInitSubmitToStExByCOFlag, @inp_bStExSubmitDiscloToStExByCOFlag,
					@inp_iDiscloPeriodEndToCOByInsdrLimit, @inp_bDiscloPeriodEndSubmitToStExByCOFlag, @inp_iDiscloPeriodEndSubmitToStExByCOLimit,
					@inp_bDiscloInitReqSoftcopyFlag,@inp_bDiscloInitReqHardcopyFlag,@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag,
					@inp_bDiscloInitSubmitToStExByCOHardcopyFlag,@inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit,@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag,
					@inp_bStExSubmitDiscloToStExByCOHardcopyFlag,@inp_bDiscloPeriodEndReqSoftcopyFlag,@inp_bDiscloPeriodEndReqHardcopyFlag,
					@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag,@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag,
					@inp_bStExSubmitDiscloToCOByInsdrFlag,@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag,@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag,
					@inp_bPreClrForAllSecuritiesFlag,@inp_bStExForAllSecuritiesFlag,
					@inp_bPreClrAllowNewForOpenPreclearFlag	,@inp_iPreClrMultipleAboveInCodeId,@inp_iPreClrApprovalPreclearORPreclearTradeFlag,
					@inp_bPreClrTradesAutoApprovalReqFlag,@inp_iPreClrSingMultiPreClrFlagCodeId,
					@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade,@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
					@inp_bTradingThresholdLimtResetFlag,@inp_nContraTradeBasedOn,
					@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate(),
					@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag, @inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, @inp_DeclarationToBeMandatoryFlag, @inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
					@inp_bIsPreclearanceFormForImplementingCompany,@inp_iPreclearanceWithoutPeriodEndDisclosure,@inp_bPreClrApprovalReasonReqFlag,
					@inp_bIsPreClearanceRequired,@inp_iRestrictedListConfigId)			
					
				SET @inp_iTradingPolicyId = SCOPE_IDENTITY()
				
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
								@out_nReturnValue output,
								@out_nSQLErrCode output,				
								@out_sSQLErrMessage	output				
				
			END 
	
			set @out_nReturnValue=@inp_iTradingPolicyId
		
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


