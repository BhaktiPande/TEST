
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicySave_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicySave_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Author      :Rajashri Sathe
-- CREATED DATE:22 July 2020
-- Description : Script for Trading Policy Other security save 
-- ======================================================================================================

CREATE PROCEDURE [dbo].[st_rul_TradingPolicySave_OS] 
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
	@inp_nUserId														INT,						-- Id of the user inserting/updating the TradingPolicy
	
	--New column added on 2-Jun-2016(YES BANK customization)
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
	@inp_iId														   INT,
	@inp_iSearchType			                                       INT,
    @inp_iSearchLimit			                                       INT,
	@inp_iApprovalType			                                       INT,	
	@inp_bIsDematAllowed		                                       BIT = NULL,	
	@inp_bIsFormFRequired		                                       BIT = NULL,
		
	@out_nReturnValue													INT = 0 OUTPUT,
	@out_nSQLErrCode													INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage													NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN



	SET @inp_nContraTradeBasedOn=177001

	-- Variable Declaration
	DECLARE @ERR_TRADINGPOLICY_SAVE														INT
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND													INT
	
	DECLARE @ERR_TRADINGPOLICYNAME_EXISTS												INT
	
	DECLARE @nRetValue INT
	DECLARE @dtCurrentDate						DATETIME
	DECLARE	@dtExistingAppFromDate				DATETIME
	DECLARE	@dtExistingAppToDate				DATETIME
	DECLARE @nNewTradingPolicyParentId							INT
	DECLARE	@nTPExistingStatus					INT


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
		--SELECT @ERR_TRADINGPOLICY_INVALIDDATES												= 55102

		SELECT	@ERR_TRADINGPOLICY_NOTFOUND													= 55098,
				@ERR_TRADINGPOLICY_SAVE														= 55099,
				--@ERR_TRADINGPOLICY_INVALID_STATUS											= 55100,
				
				
				@ERR_TRADINGPOLICYNAME_EXISTS												= 55132
		
		
		/*
			Check Wheather Trading Policy is Exists in table
			If Exits then return error message "Trading Policy name is exits."
			else save trading policy
		*/

		EXEC @nRetValue = st_Check_TradingPolicyName_OS
						 @inp_iTradingPolicyId,
						 @inp_iCurrentHistoryCodeId,
						 @inp_sTradingPolicyName,						
						 @out_nReturnValue OUTPUT,
						 @out_nSQLErrCode OUTPUT,
						 @out_sSQLErrMessage OUTPUT

		--It returns the message Trading Policy already exits
		IF(@out_nReturnValue!=0)
		BEGIN 						
				SELECT	TradingPolicyId, TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, TradingPolicyName, TradingPolicyDescription, 
				ApplicableFromDate, ApplicableToDate, PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap, 
				PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, PreClrSeekDeclarationForUPSIFlag, 
				PreClrUPSIDeclaration, PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag, 
				PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, StExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId, 
				StExMultiTradeFreq, StExMultiTradeCalFinYear, StExTransTradeNoShares, StExTransTradePercPaidSubscribedCap, 
				StExTransTradeShareValue, StExTradeDiscloSubmitLimit, DiscloInitReqFlag, DiscloInitLimit, DiscloInitDateLimit, 
				DiscloPeriodEndReqFlag, DiscloPeriodEndFreq, GenSecurityType, GenTradingPlanTransFlag, GenMinHoldingLimit, 
				GenContraTradeNotAllowedLimit, GenExceptionFor, TradingPolicyStatusCodeId, 
				DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, 
				DiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit,
				DiscloInitReqSoftcopyFlag,DiscloInitReqHardcopyFlag,DiscloInitSubmitToStExByCOSoftcopyFlag,
				DiscloInitSubmitToStExByCOHardcopyFlag,StExTradePerformDtlsSubmitToCOByInsdrLimit,StExSubmitDiscloToStExByCOSoftcopyFlag,
				StExSubmitDiscloToStExByCOHardcopyFlag,DiscloPeriodEndReqSoftcopyFlag,DiscloPeriodEndReqHardcopyFlag,
				DiscloPeriodEndSubmitToStExByCOSoftcopyFlag,DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
				StExSubmitDiscloToCOByInsdrFlag,StExSubmitDiscloToCOByInsdrSoftcopyFlag,StExSubmitDiscloToCOByInsdrHardcopyFlag,
				PreClrAllowNewForOpenPreclearFlag,PreClrAllowNewForOpenPreclearFlag,PreClrMultipleAboveInCodeId,PreClrApprovalPreclearORPreclearTradeFlag,
				GenCashAndCashlessPartialExciseOptionForContraTrade,GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate, 
				TradingThresholdLimtResetFlag,177001 as ContraTradeBasedOn,IsPreclearanceFormForImplementingCompany,
				PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag,IsPreClearanceRequired 
		FROM	rul_TradingPolicy_OS
		WHERE	TradingPolicyId = @inp_iTradingPolicyId
		
				RETURN (@out_nReturnValue)	
		END
		
		--It reruns the Restricted list settings ID
			
		EXEC @nRetValue= st_Get_RestrictedListConfig
						 @inp_iId,
						 @inp_iSearchType,
						 @inp_iSearchLimit,
						 @inp_iApprovalType,
						 @inp_bIsDematAllowed,
						 @inp_bIsFormFRequired,
						 @out_nReturnValue OUTPUT,
						 @out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT	

		
		set @inp_iRestrictedListConfigId=@out_nReturnValue;
		
		
		--Insert New Trading Policy
		IF (@inp_iTradingPolicyId IS NULL OR @inp_iTradingPolicyId = 0)
		BEGIN 
			
						 EXEC @nRetValue= st_rul_TradingPolicyInsert_OS	
										@inp_iTradingPolicyId												,
										@inp_iTradingPolicyParentId											,
										@inp_iCurrentHistoryCodeId											,
										@inp_iTradingPolicyForCodeId										,
										@inp_sTradingPolicyName												,
										@inp_sTradingPolicyDescription										,
										@inp_dtApplicableFromDate											,
										@inp_dtApplicableToDate												,
										@inp_bPreClrTradesApprovalReqFlag									,
										@inp_iPreClrSingleTransTradeNoShares								,
										@inp_iPreClrSingleTransTradePercPaidSubscribedCap					,
										@inp_bPreClrProhibitNonTradePeriodFlag								,
										@inp_iPreClrCOApprovalLimit											,
										@inp_iPreClrApprovalValidityLimit									,
										@inp_bPreClrSeekDeclarationForUPSIFlag								,
										@inp_sPreClrUPSIDeclaration											,
										@inp_bPreClrReasonForNonTradeReqFlag								,
										@inp_bPreClrCompleteTradeNotDoneFlag								,
										@inp_bPreClrPartialTradeNotDoneFlag									,
										@inp_iPreClrTradeDiscloLimit										,
										@inp_iPreClrTradeDiscloShareholdLimit								,
										@inp_bStExSubmitTradeDiscloAllTradeFlag								,
										@inp_iStExSingMultiTransTradeFlagCodeId								,
										@inp_iStExMultiTradeFreq											,
										@inp_iStExMultiTradeCalFinYear										,
										@inp_iStExTransTradeNoShares										,
										@inp_iStExTransTradePercPaidSubscribedCap							,
										@inp_iStExTransTradeShareValue										,
										@inp_iStExTradeDiscloSubmitLimit									,
										@inp_bDiscloInitReqFlag												,
										@inp_iDiscloInitLimit												,
										@inp_dtDiscloInitDateLimit											,
										@inp_bDiscloPeriodEndReqFlag										,
										@inp_iDiscloPeriodEndFreq											,
										@inp_sGenSecurityType												,
										@inp_bGenTradingPlanTransFlag										,
										@inp_iGenMinHoldingLimit											,
										@inp_iGenContraTradeNotAllowedLimit									,
										@inp_sGenExceptionFor												,
										@inp_iTradingPolicyStatusCodeId										,
										@inp_bDiscloInitSubmitToStExByCOFlag								,
										@inp_bStExSubmitDiscloToStExByCOFlag								,
										@inp_iDiscloPeriodEndToCOByInsdrLimit								,
										@inp_bDiscloPeriodEndSubmitToStExByCOFlag							,
										@inp_iDiscloPeriodEndSubmitToStExByCOLimit							,
										@inp_bDiscloInitReqSoftcopyFlag										,
										@inp_bDiscloInitReqHardcopyFlag										,
										@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag						,
										@inp_bDiscloInitSubmitToStExByCOHardcopyFlag						,
										@inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit					,
										@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag						,
										@inp_bStExSubmitDiscloToStExByCOHardcopyFlag						,
										@inp_bDiscloPeriodEndReqSoftcopyFlag								,
										@inp_bDiscloPeriodEndReqHardcopyFlag								,
										@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag					,
										@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag					,
										@inp_bStExSubmitDiscloToCOByInsdrFlag								,
										@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag						,
										@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag						,
										@inp_bPreClrForAllSecuritiesFlag									,
										@inp_bStExForAllSecuritiesFlag										,
										@inp_sSelectedPreClearancerequiredforTransactionValue				,
										@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue	,
										@inp_tblPreClearanceSecuritywise 				,
										@inp_tblContinousSecuritywise 				,
										@inp_tblPreclearanceTransactionSecurityMap    ,
										@inp_bPreClrAllowNewForOpenPreclearFlag							   ,
										@inp_iPreClrMultipleAboveInCodeId									,
										@inp_iPreClrApprovalPreclearORPreclearTradeFlag						,
										@inp_bPreClrTradesAutoApprovalReqFlag								,
										@inp_iPreClrSingMultiPreClrFlagCodeId								,
										@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade			,
										@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate		,
										@inp_bTradingThresholdLimtResetFlag									,
										@inp_nContraTradeBasedOn											,
										@inp_sSelectedContraTradeSecuirtyType								,
										@inp_nUserId														,		
										@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag					,
										@inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures			,
										@inp_DeclarationToBeMandatoryFlag									,
										@inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag	,
										@inp_bIsPreclearanceFormForImplementingCompany						,
										@inp_iPreclearanceWithoutPeriodEndDisclosure						,
										@inp_bPreClrApprovalReasonReqFlag									,
										@inp_bIsPreClearanceRequired										,
										@inp_iRestrictedListConfigId										,									    
										@out_nReturnValue output ,
										@out_nSQLErrCode output ,
										@out_sSQLErrMessage  output										
										
										set @inp_iTradingPolicyId=@out_nReturnValue										
			
			 
		END 
		
		ELSE --Edit existing Trading policy record
		--print'insert end'
		BEGIN
		
			--Fetch the current date of database server 
			SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
			SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
			
			--Fetch the already existing applicable dates and status of the trading policy
			SELECT @dtExistingAppFromDate = ApplicableFromDate, @dtExistingAppToDate = ApplicableToDate, 
				   @nTPExistingStatus = TradingPolicyStatusCodeId,@nNewTradingPolicyParentId = TradingPolicyParentId 
			FROM rul_TradingPolicy_OS
			WHERE TradingPolicyId = @inp_iTradingPolicyId
					
			EXEC @nRetValue=st_rul_TradingPolicyUpdate_OS
							            @inp_iTradingPolicyId												,
										@inp_iTradingPolicyParentId											,
										@inp_iCurrentHistoryCodeId											,
										@inp_iTradingPolicyForCodeId										,
										@inp_sTradingPolicyName												,
										@inp_sTradingPolicyDescription										,
										@inp_dtApplicableFromDate											,
										@inp_dtApplicableToDate												,
										@inp_bPreClrTradesApprovalReqFlag									,
										@inp_iPreClrSingleTransTradeNoShares								,
										@inp_iPreClrSingleTransTradePercPaidSubscribedCap					,
										@inp_bPreClrProhibitNonTradePeriodFlag								,
										@inp_iPreClrCOApprovalLimit											,
										@inp_iPreClrApprovalValidityLimit									,
										@inp_bPreClrSeekDeclarationForUPSIFlag								,
										@inp_sPreClrUPSIDeclaration											,
										@inp_bPreClrReasonForNonTradeReqFlag								,
										@inp_bPreClrCompleteTradeNotDoneFlag								,
										@inp_bPreClrPartialTradeNotDoneFlag									,
										@inp_iPreClrTradeDiscloLimit										,
										@inp_iPreClrTradeDiscloShareholdLimit								,
										@inp_bStExSubmitTradeDiscloAllTradeFlag								,
										@inp_iStExSingMultiTransTradeFlagCodeId								,
										@inp_iStExMultiTradeFreq											,
										@inp_iStExMultiTradeCalFinYear										,
										@inp_iStExTransTradeNoShares										,
										@inp_iStExTransTradePercPaidSubscribedCap							,
										@inp_iStExTransTradeShareValue										,
										@inp_iStExTradeDiscloSubmitLimit									,
										@inp_bDiscloInitReqFlag												,
										@inp_iDiscloInitLimit												,
										@inp_dtDiscloInitDateLimit											,
										@inp_bDiscloPeriodEndReqFlag										,
										@inp_iDiscloPeriodEndFreq											,
										@inp_sGenSecurityType												,
										@inp_bGenTradingPlanTransFlag										,
										@inp_iGenMinHoldingLimit											,
										@inp_iGenContraTradeNotAllowedLimit									,
										@inp_sGenExceptionFor												,
										@inp_iTradingPolicyStatusCodeId										,
										@inp_bDiscloInitSubmitToStExByCOFlag								,
										@inp_bStExSubmitDiscloToStExByCOFlag								,
										@inp_iDiscloPeriodEndToCOByInsdrLimit								,
										@inp_bDiscloPeriodEndSubmitToStExByCOFlag							,
										@inp_iDiscloPeriodEndSubmitToStExByCOLimit							,
										@inp_bDiscloInitReqSoftcopyFlag										,
										@inp_bDiscloInitReqHardcopyFlag										,
										@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag						,
										@inp_bDiscloInitSubmitToStExByCOHardcopyFlag						,
										@inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit					,
										@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag						,
										@inp_bStExSubmitDiscloToStExByCOHardcopyFlag						,
										@inp_bDiscloPeriodEndReqSoftcopyFlag								,
										@inp_bDiscloPeriodEndReqHardcopyFlag								,
										@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag					,
										@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag					,
										@inp_bStExSubmitDiscloToCOByInsdrFlag								,
										@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag						,
										@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag						,
										@inp_bPreClrForAllSecuritiesFlag									,
										@inp_bStExForAllSecuritiesFlag										,
										@inp_sSelectedPreClearancerequiredforTransactionValue				,
										@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue	,
										@inp_tblPreClearanceSecuritywise 				,
										@inp_tblContinousSecuritywise 				,
										@inp_tblPreclearanceTransactionSecurityMap    ,
										@inp_bPreClrAllowNewForOpenPreclearFlag							   ,
										@inp_iPreClrMultipleAboveInCodeId									,
										@inp_iPreClrApprovalPreclearORPreclearTradeFlag						,
										@inp_bPreClrTradesAutoApprovalReqFlag								,
										@inp_iPreClrSingMultiPreClrFlagCodeId								,
										@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade			,
										@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate		,
										@inp_bTradingThresholdLimtResetFlag									,
										@inp_nContraTradeBasedOn											,
										@inp_sSelectedContraTradeSecuirtyType								,
										@inp_nUserId														,		
										@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag					,
										@inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures			,
										@inp_DeclarationToBeMandatoryFlag									,
										@inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag	,
										@inp_bIsPreclearanceFormForImplementingCompany						,
										@inp_iPreclearanceWithoutPeriodEndDisclosure						,
										@inp_bPreClrApprovalReasonReqFlag									,
										@inp_bIsPreClearanceRequired										,
										@inp_iRestrictedListConfigId										,									    
										@out_nReturnValue output ,
										@out_nSQLErrCode output ,
										@out_sSQLErrMessage  output										
										
										set @inp_iTradingPolicyId=@out_nReturnValue
										

		END ---End Edit Existing
	
		-- in case required to return for partial save case.
		SELECT	TradingPolicyId, TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, TradingPolicyName, TradingPolicyDescription, 
				ApplicableFromDate, ApplicableToDate, PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap, 
				PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, PreClrSeekDeclarationForUPSIFlag, 
				PreClrUPSIDeclaration, PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag, 
				PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, StExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId, 
				StExMultiTradeFreq, StExMultiTradeCalFinYear, StExTransTradeNoShares, StExTransTradePercPaidSubscribedCap, 
				StExTransTradeShareValue, StExTradeDiscloSubmitLimit, DiscloInitReqFlag, DiscloInitLimit, DiscloInitDateLimit, 
				DiscloPeriodEndReqFlag, DiscloPeriodEndFreq, GenSecurityType, GenTradingPlanTransFlag, GenMinHoldingLimit, 
				GenContraTradeNotAllowedLimit, GenExceptionFor, TradingPolicyStatusCodeId, 
				DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, 
				DiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit,
				DiscloInitReqSoftcopyFlag,DiscloInitReqHardcopyFlag,DiscloInitSubmitToStExByCOSoftcopyFlag,
				DiscloInitSubmitToStExByCOHardcopyFlag,StExTradePerformDtlsSubmitToCOByInsdrLimit,StExSubmitDiscloToStExByCOSoftcopyFlag,
				StExSubmitDiscloToStExByCOHardcopyFlag,DiscloPeriodEndReqSoftcopyFlag,DiscloPeriodEndReqHardcopyFlag,
				DiscloPeriodEndSubmitToStExByCOSoftcopyFlag,DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
				StExSubmitDiscloToCOByInsdrFlag,StExSubmitDiscloToCOByInsdrSoftcopyFlag,StExSubmitDiscloToCOByInsdrHardcopyFlag,
				PreClrAllowNewForOpenPreclearFlag,PreClrAllowNewForOpenPreclearFlag,PreClrMultipleAboveInCodeId,PreClrApprovalPreclearORPreclearTradeFlag,
				GenCashAndCashlessPartialExciseOptionForContraTrade,GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate, 
				TradingThresholdLimtResetFlag,177001 as ContraTradeBasedOn,IsPreclearanceFormForImplementingCompany,
				PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag,IsPreClearanceRequired 
		FROM	rul_TradingPolicy_OS
		WHERE	TradingPolicyId = @inp_iTradingPolicyId
		
		SET @out_nReturnValue = 0
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


