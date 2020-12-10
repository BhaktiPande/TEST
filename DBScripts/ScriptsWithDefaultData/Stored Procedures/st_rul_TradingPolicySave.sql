IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicySave')
DROP PROCEDURE [dbo].[st_rul_TradingPolicySave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Trading Policy details along with history record handling for version maintenance

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		25-Mar-2015
Modification History:
Modified By		Modified On		Description
Ashashree		31-Mar-2015		Adding the conditional save for trading policy based on its status and history record creation
Ashashree		02-Apr-2015		Adding validations and new fields - DiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag, DiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag, DiscloPeriodEndSubmitToStExByCOLimit
Tushar			07-Apr-2015		Add Column for 1) Softcopy and Hardcopy required for Initial, Continuous and Period End Disclosure
											   2) Trading Details to be submitted by Insider/Employee to CO within ----- days after trade is performed	 
Tushar			14-Apr-2015		Add Column in Trade Continous Disclosures  Hardcopy and softcopy.
Ashashree		16-Apr-2015		1)Adding the code snippet to copy applicability records from record-being-marked-history to newly added trading policy record
								2)Changed the datatype for columns "PreClrSingleTransTradePercPaidSubscribedCap" and "StExTransTradePercPaidSubscribedCap" from INT to DECIMAL(15,4)
Tushar			25-Apr-2015		Check Mandatory Field for Preclearance Requirement when Trading Policy Type is Insider not Employee.
Tushar			25-May-2015		New Column add and insert record in rul_TradingPolicySecuritywiseLimits And rul_TradingPolicyForTransactionMode table.
Tushar			29-May-2015		In Secuitywise Limits Table insert record When Preclearance Required All Trade/ Continuous Disclosure Required ALl Trade
								Flag No Then otherwise doesnot insert.
Tushar			01-Jun-2015		Mandatory flag check if Policy activate check properly.
Tushar			12-Jun-2015		add check for duplicate policy name.
Tushar			15-Jun-2015		Change query for  duplicate policy name.
Tushar			30-Jun-2015		Changes in Trading Policy logic after new changes told by ESOP
Tushar			07-Jul-2015		Change condition for creating history if Incomplete policy then its update only doesnot make 
								history if current date is greater than from date
Tushar			24-Aug-2015		Changes Related to the phase 1.5 Preclearance related.
Tushar			28-Aug-2015		Remove code SET @inp_iPreClrCOApprovalLimit  = NULL 
Tushar			02-Sep-2015		Bugs Fixe for Document Upload related changes.
Tushar			04-Sep-2015		General Section: minimum holding period can be 0. 
Tushar			23-Nov-2015		Add New column for Contra Trade change and edit continuous disclosure format.
Parag			18-Dec-2015		Add New column for trading threshold limit reset flag
Tushar			30-Mar-2016		Add New column for trading ContraTradeBasedOn
Raghvendra		17-May-2016		Increased the size of the variable used for saving the UPSI Decleration from 255 to 5000
AniketS			02-Jun-2016		Added new column for UPSI declaration on Continuous Disclosures page(YES BANK customization)
Tushar			12-Aug-2016		While making history of the policy old applicability save to new policy applicability, add RoleId,Category,SubCategory,AllCo,AllCorporateEmployees,AllNonEmployee,NonInsFltrDepartmentCodeId,NonInsFltrGradeCodeId,
								NonInsFltrDesignationCodeId,NonInsFltrRoleId,NonInsFltrCategory,NonInsFltrSubCategory column.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			09-Sep-2016		Add new column for IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure
Tushar			20-Sep-2016		IF PreclearanceWithoutPeriodEndDisclosure is null then set default No value for it.
Usage:
DECLARE @RC int
EXEC st_rul_TradingPolicySave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicySave] 
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
	
	@inp_PreClrApprovalReasonReqFlag									BIT = NULL,
	
	@out_nReturnValue													INT = 0 OUTPUT,
	@out_nSQLErrCode													INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage													NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	-- Variable Declaration
	DECLARE @ERR_TRADINGPOLICY_SAVE														INT
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND													INT
	DECLARE @ERR_TRADINGPOLICY_INVALID_STATUS											INT
	DECLARE	@ERR_TRADINGPOLICY_APPLICABLE_DATES_MANDATORY								INT
	DECLARE	@ERR_TRADINGPOLICY_INVALIDDATES												INT
	DECLARE	@ERR_TRADINGPOLICY_FOR_MANDATORY											INT
	DECLARE	@ERR_TRADINGPOLICY_NAME_MANDATORY											INT
	DECLARE	@ERR_TRADINGPOLICY_DESCRIPTION_MANDATORY									INT
	DECLARE	@ERR_TRADINGPOLICY_PRECLR_TRADES_APPROV_REQ_MANDATORY						INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_SINGL_TRADE_SHARES_PERC_PAID_CAP_MANDATORY		INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_PROHIBIT_NONTRADE_PERIOD_MANDATORY				INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_CO_APPROV_LIMIT_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_APPROV_VALIDITY_LIMIT_MANDATORY					INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_UPSI_DECLAR_MANDATORY								INT
	DECLARE @ERR_TRADINGPOLICY_PRECLR_NONTRADE_REASON_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_INIT_REQ_MANDATORY								INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_INIT_LIMIT_MANDATORY								INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_INIT_DATE_LIMIT_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_INIT_SUBMIT_TO_STEX_BY_CO_MANDATORY				INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_TO_CO_BY_INSDR_MANDATORY				INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_ALL_TRADE_MANDATORY					INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SINGL_MULTI_TRADE_MANDATORY					INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SINGL_TRADE_ABOVE_MANDATORY					INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_MULTI_TRADE_ABOVE_MANDATORY					INT
	DECLARE	@ERR_TRADINGPOLICY_DISCLO_CONTI_MULTI_TRADE_ABOVE_CAL_FIN_YEAR_MANDATORY	INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_TO_STEX_BY_CO_MANDATORY				INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_LIMIT_MANDATORY						INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_REQ_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_FREQ_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_CO_BY_INSDR_LIMIT_MANDATORY			INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_SUBMIT_TO_STEX_BY_CO_REQ_MANDATORY		INT
	DECLARE @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_STEX_BY_CO_LIMIT_MANDATORY			INT
	DECLARE @ERR_TRADINGPOLICY_GENERAL_MIN_HOLD_LIMIT_MANDATORY							INT
	DECLARE @ERR_TRADINGPOLICY_GENERAL_CONTRA_TRADE_NOT_ALLOW_MANDATORY					INT
	DECLARE @ERR_TRADINGPOLICYNAME_EXISTS												INT
	
	DECLARE @nTPStatusIncomplete				INT
	DECLARE @nTPStatusActive					INT
	DECLARE @nTPStatusInactive					INT
	DECLARE	@nTPExistingStatus					INT
	
	DECLARE	@nSingleTransTradeCode				INT
	DECLARE	@nMultiTransTradeCode				INT
	DECLARE	@nMultiTradeFreqYearly				INT
	
	DECLARE @dtCurrentDate						DATETIME
	DECLARE	@dtExistingAppFromDate				DATETIME
	DECLARE	@dtExistingAppToDate				DATETIME
	
	DECLARE	@nTPCurrentRecordCode				INT
	DECLARE	@nTPHistoryRecordCode				INT
	DECLARE	@nExistingParentId					INT
	
	--Variables to copy over applicability details from older version to current version
	DECLARE @nMapToTypeCodeId									INT = 132002	--MapToTypeCodeId indicating type is of Trading Policy
	DECLARE @nPrevTradingPolicyId								INT				--This will store the TradingPolicyId for the record that gets marked as History, to copy over applicability from this history record to the newly added current record
	DECLARE @nMaxAppVersionNumber								INT = 0			--Store the applicability's maximum version number
	DECLARE @nExistingApplicabilityMstId						INT = 0			--Store the applicability-master-id for applicability with maximum version number belonging to maptotype = 132002 and maptoId = TradingPolicyId-being-marked-history
	DECLARE @nNewApplicabilityMstId								INT
	DECLARE @TradingPolicyInsiderTypeCode						INT
	DECLARE @nMapToTypePreclearance								INT = 132004
	DECLARE @nMapToTypeContinous								INT = 132005
	DECLARE @nMapToTypeProhibitPreclearanceDuringNonTrading		INT = 132007
	DECLARE @nMapToTypeTradingPolicyExceptionforTransactionMode	INT = 132008
	DECLARE @nNewTradingPolicyParentId							INT
	
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
		SELECT	@ERR_TRADINGPOLICY_NOTFOUND													= 15059,
				@ERR_TRADINGPOLICY_SAVE														= 15060,
				@ERR_TRADINGPOLICY_INVALID_STATUS											= 15061,
				@ERR_TRADINGPOLICY_APPLICABLE_DATES_MANDATORY								= 15068,
				@ERR_TRADINGPOLICY_INVALIDDATES												= 15069,
				@ERR_TRADINGPOLICY_FOR_MANDATORY											= 15070,
				@ERR_TRADINGPOLICY_NAME_MANDATORY											= 15071,
				@ERR_TRADINGPOLICY_DESCRIPTION_MANDATORY									= 15072,
				@ERR_TRADINGPOLICY_PRECLR_TRADES_APPROV_REQ_MANDATORY						= 15073,
				@ERR_TRADINGPOLICY_PRECLR_SINGL_TRADE_SHARES_PERC_PAID_CAP_MANDATORY		= 15074,
				@ERR_TRADINGPOLICY_PRECLR_PROHIBIT_NONTRADE_PERIOD_MANDATORY				= 15075,
				@ERR_TRADINGPOLICY_PRECLR_CO_APPROV_LIMIT_MANDATORY							= 15076,
				@ERR_TRADINGPOLICY_PRECLR_APPROV_VALIDITY_LIMIT_MANDATORY					= 15077,
				@ERR_TRADINGPOLICY_PRECLR_UPSI_DECLAR_MANDATORY								= 15078,
				@ERR_TRADINGPOLICY_PRECLR_NONTRADE_REASON_MANDATORY							= 15079,
				@ERR_TRADINGPOLICY_DISCLO_INIT_REQ_MANDATORY								= 15080,
				@ERR_TRADINGPOLICY_DISCLO_INIT_LIMIT_MANDATORY								= 15081,
				@ERR_TRADINGPOLICY_DISCLO_INIT_DATE_LIMIT_MANDATORY							= 15082,
				@ERR_TRADINGPOLICY_DISCLO_INIT_SUBMIT_TO_STEX_BY_CO_MANDATORY				= 15083,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_TO_CO_BY_INSDR_MANDATORY				= 15084,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_ALL_TRADE_MANDATORY					= 15085,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SINGL_MULTI_TRADE_MANDATORY					= 15086,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SINGL_TRADE_ABOVE_MANDATORY					= 15087,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_MULTI_TRADE_ABOVE_MANDATORY					= 15088,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_MULTI_TRADE_ABOVE_CAL_FIN_YEAR_MANDATORY	= 15089,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_TO_STEX_BY_CO_MANDATORY				= 15090,
				@ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_LIMIT_MANDATORY						= 15091,
				@ERR_TRADINGPOLICY_DISCLO_PERIOD_END_REQ_MANDATORY							= 15092,
				@ERR_TRADINGPOLICY_DISCLO_PERIOD_END_FREQ_MANDATORY							= 15093,
				@ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_CO_BY_INSDR_LIMIT_MANDATORY			= 15094,
				@ERR_TRADINGPOLICY_DISCLO_PERIOD_END_SUBMIT_TO_STEX_BY_CO_REQ_MANDATORY		= 15095,
				@ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_STEX_BY_CO_LIMIT_MANDATORY			= 15096,
				@ERR_TRADINGPOLICY_GENERAL_MIN_HOLD_LIMIT_MANDATORY							= 15097,
				@ERR_TRADINGPOLICY_GENERAL_CONTRA_TRADE_NOT_ALLOW_MANDATORY					= 15098,
				@ERR_TRADINGPOLICYNAME_EXISTS												= 15381
				
		SELECT	@nTPStatusIncomplete			= 141001,
				@nTPStatusActive				= 141002,
				@nTPStatusInactive				= 141003
				
		SELECT	@nTPCurrentRecordCode			= 134001,
				@nTPHistoryRecordCode			= 134002
				
		SELECT	@nSingleTransTradeCode			= 136001,
				@nMultiTransTradeCode			= 136002,
				@nMultiTradeFreqYearly			= 137001,
			    @TradingPolicyInsiderTypeCode	= 132001
		
		/*
			Check Wheather Trading Policy is Exists in table
			If Exits then return error message "Trading Policy name is exits."
			else save trading policy
		*/
		IF (((@inp_iTradingPolicyId IS NULL OR @inp_iTradingPolicyId = 0) AND 
			EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy WHERE TradingPolicyName = @inp_sTradingPolicyName AND CurrentHistoryCodeId = @nTPCurrentRecordCode))
			OR ((@inp_iTradingPolicyId IS NOT NULL OR @inp_iTradingPolicyId > 0) AND 
			EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy 
			WHERE TradingPolicyName = @inp_sTradingPolicyName AND TradingPolicyId <> @inp_iTradingPolicyId AND CurrentHistoryCodeId = @nTPCurrentRecordCode))) 
		BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICYNAME_EXISTS
				RETURN (@out_nReturnValue)
		END
		
		/*
			Validation Part check when User can activate the Trading policy then check all mandatory fileds are entered.
		*/
		IF(@inp_iTradingPolicyStatusCodeId = @nTPStatusActive) --validate input only when trading policy is being activated. Otherwise allow partial save with NULL values.
		BEGIN		
			--TODO : Add validations for mandatory fields
			IF(@inp_iTradingPolicyForCodeId IS NULL OR @inp_iTradingPolicyForCodeId <= 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_FOR_MANDATORY
				RETURN (@out_nReturnValue)
			END
			--Validate : Trading policy name
			IF(@inp_sTradingPolicyName IS NULL OR @inp_sTradingPolicyName = '')
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NAME_MANDATORY
				RETURN (@out_nReturnValue)
			END
			--Validate : Trading policy description
			IF(@inp_sTradingPolicyDescription IS NULL OR @inp_sTradingPolicyDescription = '')
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DESCRIPTION_MANDATORY
				RETURN (@out_nReturnValue)
			END
			--Validate : Trading Policy From-To dates are mandatory
			IF(@inp_dtApplicableFromDate IS NULL OR @inp_dtApplicableToDate IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_APPLICABLE_DATES_MANDATORY
				RETURN (@out_nReturnValue)
			END
			--Validate : Applicable To date should be greater/equal applicable from date
			IF(@inp_dtApplicableFromDate IS NOT NULL AND @inp_dtApplicableToDate IS NOT NULL AND (@inp_dtApplicableFromDate > @inp_dtApplicableToDate) )
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_INVALIDDATES
				RETURN (@out_nReturnValue)
			END
			--Validate : Preclearance Approval Required for all trades
			IF((@inp_iTradingPolicyForCodeId = @TradingPolicyInsiderTypeCode) AND @inp_bPreClrTradesApprovalReqFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_PRECLR_TRADES_APPROV_REQ_MANDATORY
				RETURN (@out_nReturnValue)
			END	
			
			IF((@inp_iTradingPolicyForCodeId = @TradingPolicyInsiderTypeCode) AND @inp_sSelectedPreClearancerequiredforTransactionValue IS NOT NULL AND
			@inp_iPreClrCOApprovalLimit IS NULL OR @inp_iPreClrCOApprovalLimit <= 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_PRECLR_CO_APPROV_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF((@inp_iTradingPolicyForCodeId = @TradingPolicyInsiderTypeCode) AND @inp_iPreClrApprovalValidityLimit IS NULL OR @inp_iPreClrApprovalValidityLimit <= 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_PRECLR_APPROV_VALIDITY_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF((@inp_iTradingPolicyForCodeId = @TradingPolicyInsiderTypeCode) AND @inp_bPreClrSeekDeclarationForUPSIFlag IS NOT NULL AND @inp_bPreClrSeekDeclarationForUPSIFlag = 1 AND 
				(@inp_sPreClrUPSIDeclaration IS NULL OR @inp_sPreClrUPSIDeclaration = '') )
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_PRECLR_UPSI_DECLAR_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF((@inp_iTradingPolicyForCodeId = @TradingPolicyInsiderTypeCode) AND (@inp_bPreClrReasonForNonTradeReqFlag IS NOT NULL AND @inp_bPreClrReasonForNonTradeReqFlag = 1) AND
				(@inp_bPreClrCompleteTradeNotDoneFlag IS NULL OR @inp_bPreClrCompleteTradeNotDoneFlag = 0) AND
				(@inp_bPreClrPartialTradeNotDoneFlag IS NULL OR @inp_bPreClrPartialTradeNotDoneFlag = 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_PRECLR_NONTRADE_REASON_MANDATORY
				RETURN (@out_nReturnValue)
			END	
			
			--Initial Disclosure
				
			IF(@inp_bDiscloInitReqFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_INIT_REQ_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloInitReqFlag = 1 AND(@inp_iDiscloInitLimit IS NULL OR @inp_iDiscloInitLimit <= 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_INIT_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloInitReqFlag = 1 AND @inp_dtDiscloInitDateLimit IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_INIT_DATE_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloInitReqFlag = 1 AND @inp_bDiscloInitSubmitToStExByCOFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_INIT_SUBMIT_TO_STEX_BY_CO_MANDATORY
				RETURN (@out_nReturnValue)
			END
			
			
			IF(@inp_bStExSubmitDiscloToCOByInsdrFlag = 1 AND @inp_bStExSubmitTradeDiscloAllTradeFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_ALL_TRADE_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bStExSubmitDiscloToCOByInsdrFlag = 1 AND @inp_bStExSubmitTradeDiscloAllTradeFlag = 0 AND @inp_iStExSingMultiTransTradeFlagCodeId IS NULL OR @inp_iStExSingMultiTransTradeFlagCodeId <= 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_CONTI_SINGL_MULTI_TRADE_MANDATORY
				RETURN (@out_nReturnValue)
			END
			
			IF((@inp_iStExMultiTradeFreq IS NOT NULL AND @inp_iStExMultiTradeFreq = @nMultiTradeFreqYearly) AND 
				(@inp_iStExMultiTradeCalFinYear IS NULL OR @inp_iStExMultiTradeCalFinYear <= 0) )
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_CONTI_MULTI_TRADE_ABOVE_CAL_FIN_YEAR_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bStExSubmitDiscloToCOByInsdrFlag = 1 AND @inp_bStExSubmitDiscloToStExByCOFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_TO_STEX_BY_CO_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bStExSubmitDiscloToCOByInsdrFlag = 1 AND @inp_bStExSubmitDiscloToStExByCOFlag = 1 AND 
			   (@inp_iStExTradeDiscloSubmitLimit IS NULL OR @inp_iStExTradeDiscloSubmitLimit <= 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_CONTI_SUBMIT_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			
			-- Period End Disclosure
			
			IF(@inp_bDiscloPeriodEndReqFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_REQ_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloPeriodEndReqFlag =  1 AND (@inp_iDiscloPeriodEndFreq IS NULL OR @inp_iDiscloPeriodEndFreq <= 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_FREQ_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloPeriodEndReqFlag =  1 AND (@inp_iDiscloPeriodEndToCOByInsdrLimit IS NULL OR @inp_iDiscloPeriodEndToCOByInsdrLimit <= 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_CO_BY_INSDR_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloPeriodEndReqFlag =  1 AND @inp_bDiscloPeriodEndSubmitToStExByCOFlag IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_SUBMIT_TO_STEX_BY_CO_REQ_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_bDiscloPeriodEndReqFlag =  1 AND @inp_bDiscloPeriodEndSubmitToStExByCOFlag = 1 AND 
				(@inp_iDiscloPeriodEndSubmitToStExByCOLimit IS NULL OR @inp_iDiscloPeriodEndSubmitToStExByCOLimit <= 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DISCLO_PERIOD_END_TO_STEX_BY_CO_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			
			--General Section
			
			IF(@inp_iGenMinHoldingLimit IS NULL OR @inp_iGenMinHoldingLimit < 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_GENERAL_MIN_HOLD_LIMIT_MANDATORY
				RETURN (@out_nReturnValue)
			END
			IF(@inp_iGenContraTradeNotAllowedLimit IS NULL OR @inp_iGenContraTradeNotAllowedLimit <= 0)
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_GENERAL_CONTRA_TRADE_NOT_ALLOW_MANDATORY
				RETURN (@out_nReturnValue)
			END
		END /*Perform validations only when status is to be set as Active*/
	    
	    --	print 'validations done....'
	    
		--SET Default values for flags if they are NULL
		IF(@inp_bPreClrTradesApprovalReqFlag IS NULL)
			SET @inp_bPreClrTradesApprovalReqFlag = 0
		IF(@inp_bPreClrProhibitNonTradePeriodFlag IS NULL)
			SET @inp_bPreClrProhibitNonTradePeriodFlag = 0
		IF(@inp_bPreClrReasonForNonTradeReqFlag IS NULL)
			SET @inp_bPreClrReasonForNonTradeReqFlag = 0
		IF(@inp_bPreClrCompleteTradeNotDoneFlag IS NULL)
			SET @inp_bPreClrCompleteTradeNotDoneFlag = 0
		IF(@inp_bPreClrPartialTradeNotDoneFlag IS NULL)
			SET @inp_bPreClrPartialTradeNotDoneFlag = 0			
		IF(@inp_bStExSubmitTradeDiscloAllTradeFlag IS NULL)
			SET @inp_bStExSubmitTradeDiscloAllTradeFlag = 0				
		IF(@inp_bDiscloInitReqFlag IS NULL)
			SET @inp_bDiscloInitReqFlag = 0
		IF(@inp_bDiscloPeriodEndReqFlag IS NULL)
			SET @inp_bDiscloPeriodEndReqFlag = 0
		IF(@inp_bGenTradingPlanTransFlag IS NULL)
			SET @inp_bGenTradingPlanTransFlag = 0
		IF(@inp_bDiscloInitSubmitToStExByCOFlag IS NULL)
			SET @inp_bDiscloInitSubmitToStExByCOFlag = 0
		IF(@inp_bStExSubmitDiscloToStExByCOFlag IS NULL)
			SET @inp_bStExSubmitDiscloToStExByCOFlag = 0
		IF(@inp_bDiscloPeriodEndSubmitToStExByCOFlag IS NULL)
			SET @inp_bDiscloPeriodEndSubmitToStExByCOFlag = 0		
		IF(@inp_bDiscloInitReqSoftcopyFlag IS NULL)
			SET @inp_bDiscloInitReqSoftcopyFlag = 0
		IF(@inp_bDiscloInitReqHardcopyFlag IS NULL)
			SET @inp_bDiscloInitReqHardcopyFlag = 0
		IF(@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag IS NULL)
			SET @inp_bDiscloInitSubmitToStExByCOSoftcopyFlag = 0
		IF(@inp_bDiscloInitSubmitToStExByCOHardcopyFlag IS NULL)
			SET @inp_bDiscloInitSubmitToStExByCOHardcopyFlag = 0
		IF(@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag IS NULL)
			SET @inp_bStExSubmitDiscloToStExByCOSoftcopyFlag = 0
		IF(@inp_bStExSubmitDiscloToStExByCOHardcopyFlag IS NULL)
			SET @inp_bStExSubmitDiscloToStExByCOHardcopyFlag = 0
		IF(@inp_bDiscloPeriodEndReqSoftcopyFlag IS NULL)
			SET @inp_bDiscloPeriodEndReqSoftcopyFlag = 0
		IF(@inp_bDiscloPeriodEndReqHardcopyFlag IS NULL)
			SET @inp_bDiscloPeriodEndReqHardcopyFlag = 0
		IF(@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag IS NULL)
			SET @inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag = 0	
		IF(@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag IS NULL)
			SET @inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag = 0
		IF(@inp_bStExSubmitDiscloToCOByInsdrFlag IS NULL)
			SET @inp_bStExSubmitDiscloToCOByInsdrFlag = 0	
		IF(@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag IS NULL)	
			SET @inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag = 0
		IF(@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag IS NULL)
			SET @inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag = 0
			
		/*
			SET VALUE NULL in Some Cases
		*/
		IF @inp_bPreClrSeekDeclarationForUPSIFlag = 0
		BEGIN
			SET @inp_sPreClrUPSIDeclaration = NULL
		END
		
		IF @inp_bPreClrReasonForNonTradeReqFlag = 0
		BEGIN
			SET @inp_bPreClrCompleteTradeNotDoneFlag = 0
			SET @inp_bPreClrPartialTradeNotDoneFlag = 0
		END
		IF @inp_sSelectedPreClearancerequiredforTransactionValue IS NULL OR @inp_sSelectedPreClearancerequiredforTransactionValue = ''
		BEGIN
			SET @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue = NULL
		END
		IF @inp_iPreclearanceWithoutPeriodEndDisclosure IS NULL OR @inp_iPreclearanceWithoutPeriodEndDisclosure = 0
		BEGIN
			SET @inp_iPreclearanceWithoutPeriodEndDisclosure = 188003
		END
		--Initial Disclosure
		IF @inp_bDiscloInitReqFlag = 0
		BEGIN
			SET @inp_iDiscloInitLimit = NULL
			SET @inp_dtDiscloInitDateLimit = NULL
			SET @inp_bDiscloInitReqSoftcopyFlag = NULL
			SET @inp_bDiscloInitReqHardcopyFlag = NULL
			SET @inp_bDiscloInitSubmitToStExByCOFlag = NULL
			SET @inp_bDiscloInitSubmitToStExByCOSoftcopyFlag = NULL
			SET @inp_bDiscloInitSubmitToStExByCOHardcopyFlag = NULL
		END
		IF @inp_bDiscloInitSubmitToStExByCOFlag = 0
		BEGIN
			SET @inp_bDiscloInitSubmitToStExByCOSoftcopyFlag = NULL
			SET @inp_bDiscloInitSubmitToStExByCOHardcopyFlag = NULL
		END
		
		--Continuous Disclosure
		IF @inp_bStExSubmitDiscloToCOByInsdrFlag = 0
		BEGIN
			SET @inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag = NULL
			SET @inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag = NULL
			SET @inp_iPreClrTradeDiscloLimit = NULL
			SET @inp_iStExSingMultiTransTradeFlagCodeId = NULL
			SET @inp_iPreClrTradeDiscloLimit = NULL
			SET @inp_bStExSubmitDiscloToStExByCOFlag = NULL
			SET @inp_bStExSubmitDiscloToStExByCOSoftcopyFlag = NULL
			SET @inp_bStExSubmitDiscloToStExByCOHardcopyFlag = NULL
			SET @inp_iStExTradeDiscloSubmitLimit = NULL
		END
		
		IF @inp_bStExSubmitTradeDiscloAllTradeFlag = 1
		BEGIN
			SET @inp_iStExSingMultiTransTradeFlagCodeId = NULL
		END
		
		IF @inp_bStExSubmitDiscloToStExByCOFlag = 0
		BEGIN
			SET @inp_bStExSubmitDiscloToStExByCOSoftcopyFlag = NULL
			SET @inp_bStExSubmitDiscloToStExByCOHardcopyFlag = NULL
			SET @inp_iStExTradeDiscloSubmitLimit = NULL
		END
		
		--Period End
		IF @inp_bDiscloPeriodEndReqFlag = 0
		BEGIN
			SET @inp_bDiscloPeriodEndReqSoftcopyFlag = NULL
			SET @inp_bDiscloPeriodEndReqHardcopyFlag = NULL
			SET @inp_iDiscloPeriodEndFreq = NULL
			SET @inp_iDiscloPeriodEndToCOByInsdrLimit = NULL
			SET @inp_bDiscloPeriodEndSubmitToStExByCOFlag = NULL
			SET @inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag = NULL
			SET @inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag = NULL
			SET @inp_iDiscloPeriodEndSubmitToStExByCOLimit = NULL		
		END
		
		IF @inp_bDiscloPeriodEndSubmitToStExByCOFlag = 0
		BEGIN
			SET @inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag = NULL
			SET @inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag = NULL
			SET @inp_iDiscloPeriodEndSubmitToStExByCOLimit = NULL		
		END
		
		IF @inp_iStExSingMultiTransTradeFlagCodeId = 136001
		BEGIN
			SET @inp_iStExMultiTradeFreq = NULL
			SET @inp_iStExMultiTradeCalFinYear = NULL
		END
					
		--Save the TradingPolicy details
		-- If Trading Policy id null then insert new record in db.
		IF (@inp_iTradingPolicyId IS NULL OR @inp_iTradingPolicyId = 0)
		BEGIN
			IF @inp_iTradingPolicyStatusCodeId IS NULL 
			BEGIN
				SET @inp_iTradingPolicyStatusCodeId = @nTPStatusIncomplete	--New trading policy record will always be added with status 'Incomplete'
			END
			SET @inp_iCurrentHistoryCodeId = @nTPCurrentRecordCode		--New trading policy record will get added as record type Current.
			SET @inp_iTradingPolicyParentId = NULL
			INSERT INTO rul_TradingPolicy( TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, 
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
					IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag )
			VALUES ( @inp_iTradingPolicyParentId, @inp_iCurrentHistoryCodeId, @inp_iTradingPolicyForCodeId, 
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
					@inp_bIsPreclearanceFormForImplementingCompany,@inp_iPreclearanceWithoutPeriodEndDisclosure,@inp_PreClrApprovalReasonReqFlag 
					)
			SET @inp_iTradingPolicyId = SCOPE_IDENTITY()
		
			/*
				This part is used for insert/Delete Trading Policy Securitywise Limits as per PreCLearance and Continous Disclosure
			*/
		
			DELETE FROM rul_TradingPolicySecuritywiseLimits 
			WHERE TradingPolicyId = @inp_iTradingPolicyId AND 
			MapToTypeCodeId = @nMapToTypePreclearance
			
			IF(@inp_bPreClrTradesApprovalReqFlag = 0)
			BEGIN
				INSERT INTO rul_TradingPolicySecuritywiseLimits 
				SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypePreclearance,NoOfShares,PercPaidSubscribedCap,ValueOfShares
				FROM @inp_tblPreClearanceSecuritywise
			END
			
			DELETE FROM rul_TradingPolicySecuritywiseLimits 
			WHERE TradingPolicyId = @inp_iTradingPolicyId AND 
			MapToTypeCodeId = @nMapToTypeContinous
			
			
			IF(@inp_bStExSubmitTradeDiscloAllTradeFlag = 0)
			BEGIN
				INSERT INTO rul_TradingPolicySecuritywiseLimits 
				SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypeContinous,NoOfShares,PercPaidSubscribedCap,ValueOfShares
				FROM @inp_tblContinousSecuritywise
			END
			
			-- Insert Value PreClearance required for Transaction  
			IF @inp_sSelectedPreClearancerequiredforTransactionValue IS NOT NULL OR @inp_sSelectedPreClearancerequiredforTransactionValue <> '' 
			BEGIN
				INSERT INTO rul_TradingPolicyForTransactionMode 
							SELECT @inp_iTradingPolicyId,@nMapToTypePreclearance,Items 
							FROM uf_com_Split(@inp_sSelectedPreClearancerequiredforTransactionValue)
			END
			-- Insert Value  PreClearance Prohibit forNon Trading for Transaction 
			IF @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue IS NOT NULL 
				OR @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue <> ''
			BEGIN
				INSERT INTO rul_TradingPolicyForTransactionMode 
							SELECT @inp_iTradingPolicyId,@nMapToTypeProhibitPreclearanceDuringNonTrading,Items 
							FROM uf_com_Split(@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue)
			END
			-- Insert Value General Exception For
			IF @inp_sGenExceptionFor IS NOT NULL OR @inp_sGenExceptionFor <> ''
			BEGIN
				INSERT INTO rul_TradingPolicyForTransactionMode 
							SELECT @inp_iTradingPolicyId,@nMapToTypeTradingPolicyExceptionforTransactionMode,Items 
							FROM uf_com_Split(@inp_sGenExceptionFor)
			END
			
			-- Insert Preclearance Transaction Security map
			DELETE FROM rul_TradingPolicyForTransactionSecurity
			WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = 132004
			
			INSERT INTO rul_TradingPolicyForTransactionSecurity 
				SELECT @inp_iTradingPolicyId,MapToTypeCodeID,TransactionModeCodeId,SecurityTypeCodeId
				FROM @inp_tblPreclearanceTransactionSecurityMap
			
		  IF(@inp_sSelectedContraTradeSecuirtyType IS NOT NULL OR @inp_sSelectedContraTradeSecuirtyType <> '')
		  BEGIN
			INSERT INTO rul_TradingPolicyForSecurityMode
							SELECT @inp_iTradingPolicyId,132013,Items 
							FROM uf_com_Split(@inp_sSelectedContraTradeSecuirtyType)
		  END
		  
		END
		ELSE --Edit existing Trading policy record
		BEGIN
			--Validate : Check if the TradingPolicy whose details are being updated exists
			IF (NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy WHERE TradingPolicyId = @inp_iTradingPolicyId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)
			END	
			
			--Fetch the current date of database server 
			SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
			SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
			print @dtCurrentDate
			--Fetch the already existing applicable dates and status of the trading policy
			SELECT @dtExistingAppFromDate = ApplicableFromDate, @dtExistingAppToDate = ApplicableToDate, 
				   @nTPExistingStatus = TradingPolicyStatusCodeId,@nNewTradingPolicyParentId = TradingPolicyParentId 
			FROM rul_TradingPolicy
			WHERE TradingPolicyId = @inp_iTradingPolicyId
			--print @nTPExistingStatus
			--If existing record status is Incomplete then, simply update TP details without creating a history record.
			--Status change Incomplete-->Incomplete OR Incomplete-->Active OR Incomplete-->Inactive does not require history record creation.
			--History will be created only for Active/Inactive records
			--IF(@nTPExistingStatus = @nTPStatusIncomplete)
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
					--print 'UPDATE WHEN STATUS IS INCOMPLETE..'
					UPDATE	rul_TradingPolicy
					SET 	TradingPolicyParentId = @inp_iTradingPolicyParentId, CurrentHistoryCodeId = @inp_iCurrentHistoryCodeId,		
							TradingPolicyForCodeId = @inp_iTradingPolicyForCodeId, 
							TradingPolicyName = @inp_sTradingPolicyName, TradingPolicyDescription = @inp_sTradingPolicyDescription, 
							ApplicableFromDate = @inp_dtApplicableFromDate, ApplicableToDate = @inp_dtApplicableToDate, 
							PreClrTradesApprovalReqFlag = @inp_bPreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares = @inp_iPreClrSingleTransTradeNoShares, 
							PreClrSingleTransTradePercPaidSubscribedCap = @inp_iPreClrSingleTransTradePercPaidSubscribedCap,
							PreClrProhibitNonTradePeriodFlag = @inp_bPreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit = @inp_iPreClrCOApprovalLimit,
							PreClrApprovalValidityLimit = @inp_iPreClrApprovalValidityLimit, PreClrSeekDeclarationForUPSIFlag = @inp_bPreClrSeekDeclarationForUPSIFlag,
							PreClrUPSIDeclaration = @inp_sPreClrUPSIDeclaration, PreClrReasonForNonTradeReqFlag = @inp_bPreClrReasonForNonTradeReqFlag,
							PreClrCompleteTradeNotDoneFlag = @inp_bPreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag = @inp_bPreClrPartialTradeNotDoneFlag,
							PreClrTradeDiscloLimit = @inp_iPreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit = @inp_iPreClrTradeDiscloShareholdLimit,
							StExSubmitTradeDiscloAllTradeFlag = @inp_bStExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId = @inp_iStExSingMultiTransTradeFlagCodeId,
							StExMultiTradeFreq = @inp_iStExMultiTradeFreq, StExMultiTradeCalFinYear = @inp_iStExMultiTradeCalFinYear,
							StExTransTradeNoShares = @inp_iStExTransTradeNoShares, StExTransTradePercPaidSubscribedCap = @inp_iStExTransTradePercPaidSubscribedCap,
							StExTransTradeShareValue = @inp_iStExTransTradeShareValue, StExTradeDiscloSubmitLimit = @inp_iStExTradeDiscloSubmitLimit,
							DiscloInitReqFlag = @inp_bDiscloInitReqFlag, DiscloInitLimit = @inp_iDiscloInitLimit,
							DiscloInitDateLimit = @inp_dtDiscloInitDateLimit, DiscloPeriodEndReqFlag = @inp_bDiscloPeriodEndReqFlag,
							DiscloPeriodEndFreq = @inp_iDiscloPeriodEndFreq, 
							GenSecurityType = @inp_sGenSecurityType, GenTradingPlanTransFlag = @inp_bGenTradingPlanTransFlag,
							GenMinHoldingLimit = @inp_iGenMinHoldingLimit, GenContraTradeNotAllowedLimit = @inp_iGenContraTradeNotAllowedLimit,
							GenExceptionFor = @inp_sGenExceptionFor, TradingPolicyStatusCodeId = @inp_iTradingPolicyStatusCodeId,
							DiscloInitSubmitToStExByCOFlag = @inp_bDiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag = @inp_bStExSubmitDiscloToStExByCOFlag,
							DiscloPeriodEndToCOByInsdrLimit = @inp_iDiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag = @inp_bDiscloPeriodEndSubmitToStExByCOFlag, 
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
							PreClrApprovalReasonReqFlag=@inp_PreClrApprovalReasonReqFlag
					WHERE TradingPolicyId = @inp_iTradingPolicyId	
					
					
					DELETE FROM rul_TradingPolicySecuritywiseLimits 
					WHERE TradingPolicyId = @inp_iTradingPolicyId AND 
					MapToTypeCodeId = @nMapToTypePreclearance
					
					IF(@inp_bPreClrTradesApprovalReqFlag = 0)
					BEGIN
						INSERT INTO rul_TradingPolicySecuritywiseLimits 
						SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypePreclearance,NoOfShares,PercPaidSubscribedCap,ValueOfShares
						FROM @inp_tblPreClearanceSecuritywise
					END
					
					DELETE FROM rul_TradingPolicySecuritywiseLimits 
					WHERE TradingPolicyId = @inp_iTradingPolicyId AND 
					MapToTypeCodeId = @nMapToTypeContinous
					
					IF(@inp_bStExSubmitTradeDiscloAllTradeFlag = 0)
					BEGIN
						INSERT INTO rul_TradingPolicySecuritywiseLimits 
						SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypeContinous,NoOfShares,PercPaidSubscribedCap,ValueOfShares
						FROM @inp_tblContinousSecuritywise
					END
					
					DELETE rul_TradingPolicyForTransactionMode WHERE TradingPolicyId = @inp_iTradingPolicyId 
					
					-- Insert Value PreClearance required for Transaction  
					IF @inp_sSelectedPreClearancerequiredforTransactionValue IS NOT NULL OR @inp_sSelectedPreClearancerequiredforTransactionValue <> '' 
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypePreclearance,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearancerequiredforTransactionValue)
					END
					-- Insert Value  PreClearance Prohibit forNon Trading for Transaction 
					IF @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue IS NOT NULL 
						OR @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypeProhibitPreclearanceDuringNonTrading,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue)
					END
					-- Insert Value General Exception For
					IF @inp_sGenExceptionFor IS NOT NULL OR @inp_sGenExceptionFor <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypeTradingPolicyExceptionforTransactionMode,Items 
									FROM uf_com_Split(@inp_sGenExceptionFor)
					END
					
					-- Insert Preclearance Transaction Security map
				DELETE FROM rul_TradingPolicyForTransactionSecurity
				WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = 132004
				
				INSERT INTO rul_TradingPolicyForTransactionSecurity 
					SELECT @inp_iTradingPolicyId,MapToTypeCodeID,TransactionModeCodeId,SecurityTypeCodeId
					FROM @inp_tblPreclearanceTransactionSecurityMap
					
				DELETE FROM rul_TradingPolicyForSecurityMode
				WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = 132013	
				 
				INSERT INTO rul_TradingPolicyForSecurityMode
								SELECT @inp_iTradingPolicyId,132013,Items 
								FROM uf_com_Split(@inp_sSelectedContraTradeSecuirtyType)
					
			END	--(@nTPExistingStatus = @nTPStatusIncomplete)
			ELSE --(@nTPExistingStatus = @nTPStatusActive / @nTPStatusInactive)
			BEGIN
				
				--Get the TradingPolicyParentId of the existing record before existing record gets marked as history
				SELECT @nExistingParentId = (CASE WHEN (TradingPolicyParentId IS NULL) THEN TradingPolicyId ELSE TradingPolicyParentId END) 
				FROM rul_TradingPolicy 
				WHERE TradingPolicyId = @inp_iTradingPolicyId
				
				--Update existing record to become history record
				UPDATE rul_TradingPolicy
				SET CurrentHistoryCodeId = @nTPHistoryRecordCode
				WHERE TradingPolicyId = @inp_iTradingPolicyId
				
				--Store input TradingPolicyId into @nPrevTradingPolicyId for applicability copying later, before the input variable gets updated with Id of newly added record
				SELECT @nPrevTradingPolicyId = @inp_iTradingPolicyId
				
				--Insert a new record as the Current record by using data of the previous record. Newly added Current record will have a ParentId. 
				INSERT INTO rul_TradingPolicy( 
							TradingPolicyParentId, CurrentHistoryCodeId, TradingPolicyForCodeId, 
							TradingPolicyName, TradingPolicyDescription, ApplicableFromDate, ApplicableToDate,
							PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap,
							PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, 
							PreClrSeekDeclarationForUPSIFlag, PreClrUPSIDeclaration, 
							PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag,
							PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, 
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
							PreClrTradesAutoApprovalReqFlag,PreClrSingMultiPreClrFlagCodeId ,
							GenCashAndCashlessPartialExciseOptionForContraTrade,GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
							TradingThresholdLimtResetFlag,ContraTradeBasedOn,
							CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
							SeekDeclarationFromEmpRegPossessionOfUPSIFlag, DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, DeclarationToBeMandatoryFlag, DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
							IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag)
				SELECT		@nExistingParentId, @nTPCurrentRecordCode, TradingPolicyForCodeId, 
							TradingPolicyName, TradingPolicyDescription, ApplicableFromDate, ApplicableToDate,
							PreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares, PreClrSingleTransTradePercPaidSubscribedCap,
							PreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit, PreClrApprovalValidityLimit, 
							PreClrSeekDeclarationForUPSIFlag, PreClrUPSIDeclaration, 
							PreClrReasonForNonTradeReqFlag, PreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag,
							PreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit, 
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
							@inp_bPreClrAllowNewForOpenPreclearFlag	,@inp_iPreClrMultipleAboveInCodeId,@inp_iPreClrApprovalPreclearORPreclearTradeFlag,
							@inp_bPreClrTradesAutoApprovalReqFlag,@inp_iPreClrSingMultiPreClrFlagCodeId,
							@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade,@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
							TradingThresholdLimtResetFlag,@inp_nContraTradeBasedOn,
							CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
							@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag, @inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures, @inp_DeclarationToBeMandatoryFlag, @inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
							@inp_bIsPreclearanceFormForImplementingCompany,@inp_iPreclearanceWithoutPeriodEndDisclosure,@inp_PreClrApprovalReasonReqFlag
				FROM rul_TradingPolicy
				WHERE TradingPolicyId = @inp_iTradingPolicyId
				
				
				
				/*RETURN THE SCROPE IDENTITY OF NEWLY CREATED RECORD*/
				SET @inp_iTradingPolicyId = SCOPE_IDENTITY()
					--print @inp_iTradingPolicyId		
				
				  INSERT INTO com_DocumentObjectMapping 	
				  SELECT  DocumentId,MapToTypeCodeId,@inp_iTradingPolicyId,NULL FROM com_DocumentObjectMapping
				  WHERE MapToId = @nPrevTradingPolicyId AND MapToTypeCodeId = 132002
				
				IF(@inp_bPreClrTradesApprovalReqFlag = 0)
				BEGIN
					INSERT INTO rul_TradingPolicySecuritywiseLimits 
					SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypePreclearance,NoOfShares,PercPaidSubscribedCap,ValueOfShares
					FROM @inp_tblPreClearanceSecuritywise
				END
					
				IF(@inp_bStExSubmitTradeDiscloAllTradeFlag = 0)
				BEGIN
					INSERT INTO rul_TradingPolicySecuritywiseLimits 
					SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypeContinous,NoOfShares,PercPaidSubscribedCap,ValueOfShares
					FROM @inp_tblContinousSecuritywise
				END
					
					--DELETE rul_TradingPolicyForTransactionMode WHERE TradingPolicyId = @inp_iTradingPolicyId 
					
					-- Insert Value PreClearance required for Transaction  
					IF @inp_sSelectedPreClearancerequiredforTransactionValue IS NOT NULL OR @inp_sSelectedPreClearancerequiredforTransactionValue <> '' 
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypePreclearance,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearancerequiredforTransactionValue)
					END
					-- Insert Value  PreClearance Prohibit forNon Trading for Transaction 
					IF @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue IS NOT NULL 
						OR @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypeProhibitPreclearanceDuringNonTrading,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue)
					END
					-- Insert Value General Exception For
					IF @inp_sGenExceptionFor IS NOT NULL OR @inp_sGenExceptionFor <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode 
									SELECT @inp_iTradingPolicyId,@nMapToTypeTradingPolicyExceptionforTransactionMode,Items 
									FROM uf_com_Split(@inp_sGenExceptionFor)
					END
					
				INSERT INTO rul_TradingPolicyForTransactionSecurity 
				SELECT @inp_iTradingPolicyId,MapToTypeCodeID,TransactionModeCodeId,SecurityTypeCodeId
				FROM @inp_tblPreclearanceTransactionSecurityMap
				
				IF(@inp_sSelectedContraTradeSecuirtyType IS NOT NULL OR @inp_sSelectedContraTradeSecuirtyType <> '')
				BEGIN	
				INSERT INTO rul_TradingPolicyForSecurityMode
								SELECT @inp_iTradingPolicyId,132013,Items 
								FROM uf_com_Split(@inp_sSelectedContraTradeSecuirtyType)	
			    END
				/*--------------- Start : Applicability change done on 16-Apr-2015---------------------------
				If one or more applicability records found for trading policy record being marked as History then, 
				copy the applicability records (master-details) from the record marked as History to the newly added Curent record 
				for maximum applicability version number*/
				IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId))
				BEGIN	
					print 'Applicability is mapped'
					SELECT @nMaxAppVersionNumber = MAX(VersionNumber) FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId
					SELECT @nExistingApplicabilityMstId = ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId AND VersionNumber = @nMaxAppVersionNumber 
					--Copy applicability for newly added trading policy record by inserting the records from previous trading policy record
					INSERT INTO rul_ApplicabilityMaster(MapToTypeCodeId, MapToId, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
					VALUES(@nMapToTypeCodeId, @inp_iTradingPolicyId, @nMaxAppVersionNumber, @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate())
					
					SELECT @nNewApplicabilityMstId = SCOPE_IDENTITY() --Get ApplicabilityMstID for newly added applicability-master record
					
					--Copy the applicability details records by doing a bulk insert-select-from
					INSERT	INTO rul_ApplicabilityDetails(ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
								InsiderTypeCodeId, DepartmentCodeId, GradeCodeId, DesignationCodeId, UserId, IncludeExcludeCodeId, 
								CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
								RoleId,Category,SubCategory,AllCo,AllCorporateEmployees,AllNonEmployee,NonInsFltrDepartmentCodeId,NonInsFltrGradeCodeId,
								NonInsFltrDesignationCodeId,NonInsFltrRoleId,NonInsFltrCategory,NonInsFltrSubCategory)
							SELECT  @nNewApplicabilityMstId, AD.AllEmployeeFlag, AD.AllInsiderFlag, AD.AllEmployeeInsiderFlag,
									AD.InsiderTypeCodeId, AD.DepartmentCodeId, AD.GradeCodeId, Ad.DesignationCodeId,
									AD.UserId, AD.IncludeExcludeCodeId, 
									@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate(),
									AD.RoleId,AD.Category,AD.SubCategory,AD.AllCo,AD.AllCorporateEmployees,AD.AllNonEmployee,AD.NonInsFltrDepartmentCodeId,AD.NonInsFltrGradeCodeId,
									AD.NonInsFltrDesignationCodeId,AD.NonInsFltrRoleId,AD.NonInsFltrCategory,AD.NonInsFltrSubCategory
							FROM    rul_ApplicabilityDetails AD
							WHERE   AD.ApplicabilityMstId = @nExistingApplicabilityMstId
				END	--Applicability exists for trading policy which is being-marked-history
				/*--------------- End : Applicability change done on 16-Apr-2015---------------------------*/					
				
				--If current-date < applicable-from-date <= applicable-to-date then update all fields even when status is Active/Inactive
			--	IF(@dtCurrentDate < @dtExistingAppFromDate AND @dtExistingAppFromDate <= @dtExistingAppToDate)
			--	BEGIN
					--Update all fields with the input values. 
					--ParentId remains as that which was set when record was newly created as Current record. Record type remains as Current.
					UPDATE	rul_TradingPolicy
					SET 	TradingPolicyParentId = @nExistingParentId, CurrentHistoryCodeId = @nTPCurrentRecordCode,		
							TradingPolicyForCodeId = @inp_iTradingPolicyForCodeId, 
							TradingPolicyName = @inp_sTradingPolicyName, TradingPolicyDescription = @inp_sTradingPolicyDescription, 
							ApplicableFromDate = @inp_dtApplicableFromDate, ApplicableToDate = @inp_dtApplicableToDate, 
							PreClrTradesApprovalReqFlag = @inp_bPreClrTradesApprovalReqFlag, PreClrSingleTransTradeNoShares = @inp_iPreClrSingleTransTradeNoShares, 
							PreClrSingleTransTradePercPaidSubscribedCap = @inp_iPreClrSingleTransTradePercPaidSubscribedCap,
							PreClrProhibitNonTradePeriodFlag = @inp_bPreClrProhibitNonTradePeriodFlag, PreClrCOApprovalLimit = @inp_iPreClrCOApprovalLimit,
							PreClrApprovalValidityLimit = @inp_iPreClrApprovalValidityLimit, PreClrSeekDeclarationForUPSIFlag = @inp_bPreClrSeekDeclarationForUPSIFlag,
							PreClrUPSIDeclaration = @inp_sPreClrUPSIDeclaration, PreClrReasonForNonTradeReqFlag = @inp_bPreClrReasonForNonTradeReqFlag,
							PreClrCompleteTradeNotDoneFlag = @inp_bPreClrCompleteTradeNotDoneFlag, PreClrPartialTradeNotDoneFlag = @inp_bPreClrPartialTradeNotDoneFlag,
							PreClrTradeDiscloLimit = @inp_iPreClrTradeDiscloLimit, PreClrTradeDiscloShareholdLimit = @inp_iPreClrTradeDiscloShareholdLimit,
							StExSubmitTradeDiscloAllTradeFlag = @inp_bStExSubmitTradeDiscloAllTradeFlag, StExSingMultiTransTradeFlagCodeId = @inp_iStExSingMultiTransTradeFlagCodeId,
							StExMultiTradeFreq = @inp_iStExMultiTradeFreq, StExMultiTradeCalFinYear = @inp_iStExMultiTradeCalFinYear,
							StExTransTradeNoShares = @inp_iStExTransTradeNoShares, StExTransTradePercPaidSubscribedCap = @inp_iStExTransTradePercPaidSubscribedCap,
							StExTransTradeShareValue = @inp_iStExTransTradeShareValue, StExTradeDiscloSubmitLimit = @inp_iStExTradeDiscloSubmitLimit,
							DiscloInitReqFlag = @inp_bDiscloInitReqFlag, DiscloInitLimit = @inp_iDiscloInitLimit,
							DiscloInitDateLimit = @inp_dtDiscloInitDateLimit, DiscloPeriodEndReqFlag = @inp_bDiscloPeriodEndReqFlag,
							DiscloPeriodEndFreq = @inp_iDiscloPeriodEndFreq, 
							GenSecurityType = @inp_sGenSecurityType, GenTradingPlanTransFlag = @inp_bGenTradingPlanTransFlag,
							GenMinHoldingLimit = @inp_iGenMinHoldingLimit, GenContraTradeNotAllowedLimit = @inp_iGenContraTradeNotAllowedLimit,
							GenExceptionFor = @inp_sGenExceptionFor, TradingPolicyStatusCodeId = @inp_iTradingPolicyStatusCodeId,
							DiscloInitSubmitToStExByCOFlag = @inp_bDiscloInitSubmitToStExByCOFlag, StExSubmitDiscloToStExByCOFlag = @inp_bStExSubmitDiscloToStExByCOFlag,
							DiscloPeriodEndToCOByInsdrLimit = @inp_iDiscloPeriodEndToCOByInsdrLimit, DiscloPeriodEndSubmitToStExByCOFlag = @inp_bDiscloPeriodEndSubmitToStExByCOFlag, 
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
							PreClrApprovalReasonReqFlag=@inp_PreClrApprovalReasonReqFlag
					WHERE	TradingPolicyId = @inp_iTradingPolicyId
			--	END
				--If current date between applicable-from-date and applicable-to-date then update only the applicable-to-date and status
				--IF(@dtExistingAppFromDate <= @dtCurrentDate AND @dtCurrentDate <= @dtExistingAppToDate AND @dtExistingAppFromDate <= @dtExistingAppToDate)
				--BEGIN
				--	--Active/Inactive record cannot be marked as Incomplete. Active record cannot be deactivated.
				--	IF( (@nTPExistingStatus = @nTPStatusActive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusIncomplete) OR
				--		(@nTPExistingStatus = @nTPStatusActive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusInactive) OR
				--		(@nTPExistingStatus = @nTPStatusInactive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusIncomplete) )
				--	BEGIN
				--		SET @out_nReturnValue = @ERR_TRADINGPOLICY_INVALID_STATUS
				--		RETURN (@out_nReturnValue)
				--	END
				--	--update only applicable-to-date and status if status is valid
				--	UPDATE	rul_TradingPolicy
				--	SET 	ApplicableToDate = @inp_dtApplicableToDate,
				--			TradingPolicyStatusCodeId = @inp_iTradingPolicyStatusCodeId,
				--			ModifiedBy	= @inp_nUserId, 
				--			ModifiedOn = dbo.uf_com_GetServerDate()
				--	WHERE	TradingPolicyId = @inp_iTradingPolicyId
				--END
				--ELSE IF(@dtCurrentDate > @dtExistingAppToDate AND @dtExistingAppFromDate <= @dtExistingAppToDate)
				--BEGIN
				--	--Active/Inactive record cannot be marked as Incomplete. Active record cannot be deactivated.
				--	IF( (@nTPExistingStatus = @nTPStatusActive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusIncomplete) OR
				--		(@nTPExistingStatus = @nTPStatusInactive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusIncomplete) OR
				--		(@nTPExistingStatus = @nTPStatusInactive AND @inp_iTradingPolicyStatusCodeId = @nTPStatusActive) )
				--	BEGIN
				--		SET @out_nReturnValue = @ERR_TRADINGPOLICY_INVALID_STATUS
				--		RETURN (@out_nReturnValue)
				--	END				
				--	--update only the status from input is it is valid status
				--	UPDATE	rul_TradingPolicy
				--	SET 	TradingPolicyStatusCodeId = @inp_iTradingPolicyStatusCodeId,
				--			ModifiedBy	= @inp_nUserId, 
				--			ModifiedOn = dbo.uf_com_GetServerDate()
				--	WHERE	TradingPolicyId = @inp_iTradingPolicyId
				--END
			END --(@nTPExistingStatus = @nTPStatusActive / @nTPStatusInactive)
		END --Edit existing Trading policy record
		
		DECLARE @nProhibitPreSetting INT=0
		SELECT @nProhibitPreSetting=ProhibitPreClearance FROM mst_Company
		
		IF(@nProhibitPreSetting=512002)
		BEGIN
		EXEC st_rul_UpdateTradingPolicyForProhibitPreSetting @inp_iTradingPolicyId 
		END
		
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
				TradingThresholdLimtResetFlag,ContraTradeBasedOn,IsPreclearanceFormForImplementingCompany,PreclearanceWithoutPeriodEndDisclosure,PreClrApprovalReasonReqFlag
		FROM	rul_TradingPolicy
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