using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("rul_TradingPolicy")]
    public class TradingPolicyDTO
    {
        [PetaPoco.Column("TradingPolicyId")]
        public int? TradingPolicyId { get; set; }

        [PetaPoco.Column("TradingPolicyForCodeId")]
        public int? TradingPolicyForCodeId { get; set; }

        [PetaPoco.Column("TradingPolicyParentId")]
        public int? TradingPolicyParentId { get; set; }

        [PetaPoco.Column("CurrentHistoryCodeId")]
        public int? CurrentHistoryCodeId { get; set; }

        [PetaPoco.Column("TradingPolicyName")]
        public string TradingPolicyName { get; set; }

        [PetaPoco.Column("TradingPolicyDescription")]
        public string TradingPolicyDescription { get; set; }

        [PetaPoco.Column("ApplicableFromDate")]
        public DateTime? ApplicableFromDate { get; set; }

        [PetaPoco.Column("ApplicableToDate")]
        public DateTime? ApplicableToDate { get; set; }

        [PetaPoco.Column("PreClrTradesApprovalReqFlag")]
        public bool PreClrTradesApprovalReqFlag { get; set; }

        [PetaPoco.Column("PreClrSingleTransTradeNoShares")]
        public int? PreClrSingleTransTradeNoShares { get; set; }

        [PetaPoco.Column("PreClrSingleTransTradePercPaidSubscribedCap")]
        public decimal? PreClrSingleTransTradePercPaidSubscribedCap { get; set; }

        [PetaPoco.Column("PreClrProhibitNonTradePeriodFlag")]
        public bool PreClrProhibitNonTradePeriodFlag { get; set; }

        [PetaPoco.Column("PreClrCOApprovalLimit")]
        public int? PreClrCOApprovalLimit { get; set; }

        [PetaPoco.Column("PreClrApprovalValidityLimit")]
        public int? PreClrApprovalValidityLimit { get; set; }

        [PetaPoco.Column("PreClrSeekDeclarationForUPSIFlag")]
        public bool PreClrSeekDeclarationForUPSIFlag { get; set; }

        [PetaPoco.Column("PreClrUPSIDeclaration")]
        public string PreClrUPSIDeclaration { get; set; }

        [PetaPoco.Column("PreClrReasonForNonTradeReqFlag")]
        public bool PreClrReasonForNonTradeReqFlag { get; set; }

        [PetaPoco.Column("PreClrApprovalReasonReqFlag")]
        public bool PreClrApprovalReasonReqFlag { get; set; }

        [PetaPoco.Column("PreClrCompleteTradeNotDoneFlag")]
        public bool PreClrCompleteTradeNotDoneFlag { get; set; }

        [PetaPoco.Column("PreClrPartialTradeNotDoneFlag")]
        public bool PreClrPartialTradeNotDoneFlag { get; set; }

        [PetaPoco.Column("PreClrTradeDiscloLimit")]
        public int? PreClrTradeDiscloLimit { get; set; }

        [PetaPoco.Column("PreClrTradeDiscloShareholdLimit")]
        public int? PreClrTradeDiscloShareholdLimit { get; set; }

        [PetaPoco.Column("StExSubmitTradeDiscloAllTradeFlag")]
        public bool StExSubmitTradeDiscloAllTradeFlag { get; set; }

        [PetaPoco.Column("StExSingMultiTransTradeFlagCodeId")]
        public int? StExSingMultiTransTradeFlagCodeId { get; set; }

        [PetaPoco.Column("StExMultiTradeFreq")]
        public int? StExMultiTradeFreq { get; set; }

        [PetaPoco.Column("StExMultiTradeCalFinYear")]
        public int? StExMultiTradeCalFinYear { get; set; }

        [PetaPoco.Column("StExTransTradeNoShares")]
        public int? StExTransTradeNoShares { get; set; }

        [PetaPoco.Column("StExTransTradePercPaidSubscribedCap")]
        public decimal? StExTransTradePercPaidSubscribedCap { get; set; }

        [PetaPoco.Column("StExTransTradeShareValue")]
        public int? StExTransTradeShareValue { get; set; }

        [PetaPoco.Column("StExTradeDiscloSubmitLimit")]
        public int? StExTradeDiscloSubmitLimit { get; set; }

        [PetaPoco.Column("DiscloInitReqFlag")]
        public bool DiscloInitReqFlag { get; set; }

        [PetaPoco.Column("DiscloInitLimit")]
        public int? DiscloInitLimit { get; set; }

        [PetaPoco.Column("DiscloInitDateLimit")]
        public DateTime? DiscloInitDateLimit { get; set; }

        [PetaPoco.Column("DiscloPeriodEndReqFlag")]
        public bool DiscloPeriodEndReqFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndFreq")]
        public int? DiscloPeriodEndFreq { get; set; }

        [PetaPoco.Column("GenSecurityType")]
        public string GenSecurityType { get; set; }

        [PetaPoco.Column("GenTradingPlanTransFlag")]
        public bool GenTradingPlanTransFlag { get; set; }

        [PetaPoco.Column("GenMinHoldingLimit")]
        public int? GenMinHoldingLimit { get; set; }

        [PetaPoco.Column("GenContraTradeNotAllowedLimit")]
        public int? GenContraTradeNotAllowedLimit { get; set; }

        [PetaPoco.Column("GenExceptionFor")]
        public string GenExceptionFor { get; set; }

        [PetaPoco.Column("TradingPolicyStatusCodeId")]
        public int? TradingPolicyStatusCodeId { get; set; }
        
        // New Column
        [PetaPoco.Column("DiscloInitSubmitToStExByCOFlag")]
        public bool DiscloInitSubmitToStExByCOFlag { get; set; }

        [PetaPoco.Column("StExSubmitDiscloToStExByCOFlag")]
        public bool StExSubmitDiscloToStExByCOFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndToCOByInsdrLimit")]
        public int? DiscloPeriodEndToCOByInsdrLimit { get; set; }

        [PetaPoco.Column("DiscloPeriodEndSubmitToStExByCOFlag")]
        public bool DiscloPeriodEndSubmitToStExByCOFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndSubmitToStExByCOLimit")]
        public int? DiscloPeriodEndSubmitToStExByCOLimit { get; set; }

        //New Column add on 07-Apr-2015

        [PetaPoco.Column("DiscloInitReqSoftcopyFlag")]
        public bool DiscloInitReqSoftcopyFlag { get; set; }

        [PetaPoco.Column("DiscloInitReqHardcopyFlag")]
        public bool DiscloInitReqHardcopyFlag { get; set; }

        [PetaPoco.Column("DiscloInitSubmitToStExByCOSoftcopyFlag")]
        public bool DiscloInitSubmitToStExByCOSoftcopyFlag { get; set; }

        [PetaPoco.Column("DiscloInitSubmitToStExByCOHardcopyFlag")]
        public bool DiscloInitSubmitToStExByCOHardcopyFlag { get; set; }

        [PetaPoco.Column("StExTradePerformDtlsSubmitToCOByInsdrLimit")]
        public int? StExTradePerformDtlsSubmitToCOByInsdrLimit { get; set; }

        [PetaPoco.Column("StExSubmitDiscloToStExByCOSoftcopyFlag")]
        public bool StExSubmitDiscloToStExByCOSoftcopyFlag { get; set; }

        [PetaPoco.Column("StExSubmitDiscloToStExByCOHardcopyFlag")]
        public bool StExSubmitDiscloToStExByCOHardcopyFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndReqSoftcopyFlag")]
        public bool DiscloPeriodEndReqSoftcopyFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndReqHardcopyFlag")]
        public bool DiscloPeriodEndReqHardcopyFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndSubmitToStExByCOSoftcopyFlag")]
        public bool DiscloPeriodEndSubmitToStExByCOSoftcopyFlag { get; set; }

        [PetaPoco.Column("DiscloPeriodEndSubmitToStExByCOHardcopyFlag")]
        public bool DiscloPeriodEndSubmitToStExByCOHardcopyFlag { get; set; }

        public int LoggedInUserId { get; set; }

        //New Column add on 14-Apr-2015

        [PetaPoco.Column("StExSubmitDiscloToCOByInsdrFlag")]
        public bool StExSubmitDiscloToCOByInsdrFlag { get; set; }

        [PetaPoco.Column("StExSubmitDiscloToCOByInsdrSoftcopyFlag")]
        public bool StExSubmitDiscloToCOByInsdrSoftcopyFlag { get; set; }

        [PetaPoco.Column("StExSubmitDiscloToCOByInsdrHardcopyFlag")]
        public bool StExSubmitDiscloToCOByInsdrHardcopyFlag { get; set; }

        //New column added on 2-Jun-2016(YES BANK customization)
        [PetaPoco.Column("SeekDeclarationFromEmpRegPossessionOfUPSIFlag")]
        public bool SeekDeclarationFromEmpRegPossessionOfUPSIFlag { get; set; }

        [PetaPoco.Column("DeclarationFromInsiderAtTheTimeOfContinuousDisclosures")]
        public string DeclarationFromInsiderAtTheTimeOfContinuousDisclosures { get; set; }

        [PetaPoco.Column("DeclarationToBeMandatoryFlag")]
        public bool DeclarationToBeMandatoryFlag { get; set; }

        [PetaPoco.Column("DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag")]
        public bool DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag { get; set; }
        //End column added on 2-Jun-2016
        
        [PetaPoco.Column("PreClrForAllSecuritiesFlag")]
        public bool PreClrForAllSecuritiesFlag { get; set; }

        [PetaPoco.Column("StExForAllSecuritiesFlag")]
        public bool StExForAllSecuritiesFlag { get; set; }

        public string SelectedPreClearancerequiredforTransactionValue { get; set; }

        public string SelectedPreClearanceProhibitforNonTradingforTransactionValue { get; set; }

        //New Column add on 24-Aug-2015
        [PetaPoco.Column("PreClrAllowNewForOpenPreclearFlag")]
        public bool PreClrAllowNewForOpenPreclearFlag  { get; set; }

        [PetaPoco.Column("PreClrMultipleAboveInCodeId")]
        public int? PreClrMultipleAboveInCodeId { get; set; }

        [PetaPoco.Column("PreClrApprovalPreclearORPreclearTradeFlag")]
        public int PreClrApprovalPreclearORPreclearTradeFlag { get; set; }

        [PetaPoco.Column("PreClrTradesAutoApprovalReqFlag")]
        public bool PreClrTradesAutoApprovalReqFlag { get; set; }

        [PetaPoco.Column("PreClrSingMultiPreClrFlagCodeId")]
        public int? PreClrSingMultiPreClrFlagCodeId { get; set; }

        [PetaPoco.Column("GenCashAndCashlessPartialExciseOptionForContraTrade")]
        public int GenCashAndCashlessPartialExciseOptionForContraTrade { get; set; }

        [PetaPoco.Column("GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate")]
        public bool GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate { get; set; }

        [PetaPoco.Column("TradingThresholdLimtResetFlag")]
        public bool? TradingThresholdLimtResetFlag { get; set; }

        [PetaPoco.Column("ContraTradeBasedOn")]
        public int? ContraTradeBasedOn { get; set; }

        public string SelectedContraTradeSecuirtyType { get; set; }

        [PetaPoco.Column("IsPreclearanceFormForImplementingCompany")]
        public bool IsPreclearanceFormForImplementingCompany { get; set; }

        [PetaPoco.Column("PreclearanceWithoutPeriodEndDisclosure")]
        public int PreclearanceWithoutPeriodEndDisclosure { get; set; }
    }

    public class ApplicableTradingPolicyDetailsDTO
    {
        [PetaPoco.Column("TradingPolicyId")]
        public int TradingPolicyId { get; set; }

        [PetaPoco.Column("PreClrTradeDiscloLimit")]
        public int PreClrTradeDiscloLimit { get; set; }

        [PetaPoco.Column("PreClrSeekDeclarationForUPSIFlag")]
        public bool PreClrSeekDeclarationForUPSIFlag { get; set; }

        [PetaPoco.Column("PreClrUPSIDeclaration")]
        public string PreClrUPSIDeclaration { get; set; }

        [PetaPoco.Column("NonTradingPeriodFlag")]
        public bool NonTradingPeriodFlag { get; set; }

        [PetaPoco.Column("WindowCloseDate")]
        public DateTime? WindowCloseDate { get; set; }

        [PetaPoco.Column("WindowOpenDate")]
        public DateTime? WindowOpenDate { get; set; }

        [PetaPoco.Column("GenContraTradeNotAllowedLimit")]
        public int GenContraTradeNotAllowedLimit { get; set; }

        [PetaPoco.Column("GenCashAndCashlessPartialExciseOptionForContraTrade")]
        public int GenCashAndCashlessPartialExciseOptionForContraTrade { get; set; }

        [PetaPoco.Column("UseExerciseSecurityPool")]
        public bool UseExerciseSecurityPool { get; set; }

        [PetaPoco.Column("PreClrApprovalValidityLimit")]
        public int PreClrApprovalValidityLimit { get; set; }
        
    }

    public class TransactionSecurityMapConfigDTO
    {
        [PetaPoco.Column("TransactionSecurityMapId")]
        public int TransactionSecurityMapId { get; set; }

        [PetaPoco.Column("TransactionTypeCodeId")]
        public int TransactionTypeCodeId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("TransactionType")]
        public string TransactionType { get; set; }

        [PetaPoco.Column("SecurityType")]
        public string SecurityType { get; set; }

    }

    public class TradingPolicyForTransactionSecurityDTO
    {
        [PetaPoco.Column("TransactionModeCodeId")]
        public int TransactionModeCodeId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }
    }

}
