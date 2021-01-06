using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
   

    public class TradingPolicyModel_OS
    {

        [Required]
        public int? TradingPolicyId { get; set; }

        [DisplayName("rul_lbl_55151")]
        public int? TradingPolicyForCodeId { get; set; }

        public int? CurrentHistoryCodeId { get; set; }

        public int? TradingPolicyParentId { get; set; }

        [Required]
        [StringLength(50)]
        [DisplayName("rul_lbl_55152")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_55211")]
        //[RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "rul_msg_55201")]
        public string TradingPolicyName { get; set; }

        [Required]
        [StringLength(200)]
        [DisplayName("rul_lbl_55153")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_55211")]
        public string TradingPolicyDescription { get; set; }

        [Required]
        [DisplayName("rul_lbl_55154")]
        [DataType(DataType.DateTime)]
        //[DateCompare(CompareToPropertyName = "ApplicableToDate", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "")]
        public DateTime? ApplicableFromDate { get; set; }

        [Required]
        [DisplayName("rul_lbl_55155")]
        [DataType(DataType.DateTime)]
        //[DateCompare(CompareToPropertyName = "ApplicableFromDate", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_55212")]
        public DateTime? ApplicableToDate { get; set; }

        [DisplayName("rul_lbl_55157")]
        public bool PreClrTradesApprovalReqFlag { get; set; }

        [DisplayName("rul_lbl_55156")]
        [Range(1, 99999999, ErrorMessage = "rul_msg_55213")]
        public int? PreClrSingleTransTradeNoShares { get; set; }

        [DisplayName("rul_lbl_55158")]
        //^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$
        [RegularExpression("^(100([.][0]{1,})?$|[0-9]{1,2}([.][0-9]{1,})?)$", ErrorMessage = "rul_msg_55214")]
        public decimal? PreClrSingleTransTradePercPaidSubscribedCap { get; set; }

        [DisplayName("rul_lbl_55159")]
        public bool PreClrProhibitNonTradePeriodFlag { get; set; }
       
        [DisplayName("rul_lbl_55160")]
        // [DefaultValue(0.00)]
        [Range(0, 99, ErrorMessage = "rul_msg_55215")]
        public int? PreClrCOApprovalLimit { get; set; }

       
        [DisplayName("rul_lbl_55161")]
        [Range(0, 99, ErrorMessage = "rul_msg_55216")]
        public int? PreClrApprovalValidityLimit { get; set; }

        [DisplayName("rul_lbl_55162")]
        public bool PreClrSeekDeclarationForUPSIFlag { get; set; }

       
        [DisplayName("rul_lbl_55163")]
        [StringLength(5000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_55211")]
        public string PreClrUPSIDeclaration { get; set; }

        [DefaultValue(true)]
        [DisplayName("rul_lbl_55164")]
        public bool PreClrReasonForNonTradeReqFlag { get; set; }

        [DisplayName("rul_lbl_55165")]
        public bool PreClrCompleteTradeNotDoneFlag { get; set; }

        [DisplayName("rul_lbl_55166")]
        public bool PreClrPartialTradeNotDoneFlag { get; set; }

        [DisplayName("rul_lbl_55167")]//Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within")]//"Trade Disclosure for preclearance approval transaction within")]
        [Range(0, 99, ErrorMessage = "rul_msg_55218")]
        public int? PreClrTradeDiscloLimit { get; set; }

        [DisplayName("Trade Disclosure Within - ")]
        [Range(0, 99, ErrorMessage = "rul_msg_55219")]
        public int? PreClrTradeDiscloShareholdLimit { get; set; }

        [DisplayName("rul_lbl_55168")]
        public bool StExSubmitTradeDiscloAllTradeFlag { get; set; }

        [DisplayName("XXXX")]
        public int? StExSingMultiTransTradeFlagCodeId { get; set; }

        [DisplayName("rul_lbl_55169")]
        public int? StExMultiTradeFreq { get; set; }

        [DisplayName("rul_lbl_55170")]
        public int? StExMultiTradeCalFinYear { get; set; }

        [DisplayName("rul_lbl_55171")]
        [Range(1, 99999999, ErrorMessage = "rul_msg_55220")]
        public int? StExTransTradeNoShares { get; set; }

        [DisplayName("rul_lbl_55172")]
        [RegularExpression("^(100([.][0]{1,})?$|[0-9]{1,2}([.][0-9]{1,})?)$", ErrorMessage = "rul_msg_55221")]
        public decimal? StExTransTradePercPaidSubscribedCap { get; set; }

        [DisplayName("rul_lbl_55173")]
        [Range(1, 9999999999, ErrorMessage = "rul_msg_55222")]
        public int? StExTransTradeShareValue { get; set; }

        [DisplayName("rul_lbl_55174")]
        [Range(0, 99, ErrorMessage = "rul_msg_55223")]
        public int? StExTradeDiscloSubmitLimit { get; set; }

        [DisplayName("rul_lbl_55175")]
        public bool DiscloInitReqFlag { get; set; }
        
        
        [DisplayName("rul_lbl_55191")]
        [Range(0, 99, ErrorMessage = "rul_msg_55224")]
        public int? DiscloInitLimit { get; set; }

       
        [DisplayName("rul_lbl_55176")]
        //  [Range(0, 99, ErrorMessage = "Enter Initial Disclosure before Max 2 digit number")]
        public DateTime? DiscloInitDateLimit { get; set; }

        [DisplayName("rul_lbl_55177")]
        public bool DiscloPeriodEndReqFlag { get; set; }

        [DisplayName("rul_lbl_55178")]
        public int? DiscloPeriodEndFreq { get; set; }

        [DisplayName("rul_lbl_55179")]
        public string GenSecurityType { get; set; }

        [DisplayName("rul_lbl_55180")]
        public bool GenTradingPlanTransFlag { get; set; }

        [DisplayName("rul_lbl_55181")]
        //[Range(0, 99, ErrorMessage = "rul_msg_55230")]
        public int? GenMinHoldingLimit { get; set; }

       
        [DisplayName("rul_lbl_55182")]
        [Range(0, 999, ErrorMessage = "rul_msg_55225")]
        public int? GenContraTradeNotAllowedLimit { get; set; }

        [DisplayName("rul_lbl_55183")]
        public string GenExceptionFor { get; set; }

        [DisplayName("rul_lbl_55184")]
        public int? TradingPolicyStatusCodeId { get; set; }

        public List<PopulateComboDTO> TradingPolicyCodeList { get; set; }

        public List<PopulateComboDTO> AssignedGenSecurityTypeList { get; set; }

        public List<string> SelectedGenSecurityType { get; set; }

        public List<PopulateComboDTO> AssignedGenExceptionForList { get; set; }

        public List<string> SelectedGenExceptionFor { get; set; }

        [DisplayName("rul_lbl_55185")]
        public bool DiscloInitSubmitToStExByCOFlag { get; set; }

        [DisplayName("rul_lbl_55186")]
        public bool StExSubmitDiscloToStExByCOFlag { get; set; }

       
        [DisplayName("rul_lbl_55187")]
        [Range(0, 99, ErrorMessage = "rul_msg_55226")]
        public int? DiscloPeriodEndToCOByInsdrLimit { get; set; }

        [DisplayName("rul_lbl_55188")]
        public bool DiscloPeriodEndSubmitToStExByCOFlag { get; set; }

        [DisplayName("rul_lbl_55189")]
        [Range(0, 99, ErrorMessage = "rul_msg_55227")]
        public int? DiscloPeriodEndSubmitToStExByCOLimit { get; set; }

        //New Column add on 07-Apr-2015

        [DisplayName("rul_lbl_55193")]
        public bool DiscloInitReqSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool DiscloInitReqHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_55193")]
        public bool DiscloInitSubmitToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool DiscloInitSubmitToStExByCOHardcopyFlag { get; set; }

       
        [DisplayName("rul_lbl_55192")]
        [Range(0, 99, ErrorMessage = "rul_msg_55228")]
        public int? StExTradePerformDtlsSubmitToCOByInsdrLimit { get; set; }

        [DisplayName("rul_lbl_55193")]
        public bool StExSubmitDiscloToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool StExSubmitDiscloToStExByCOHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_55193")]
        public bool DiscloPeriodEndReqSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool DiscloPeriodEndReqHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_55193")]
        public bool DiscloPeriodEndSubmitToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool DiscloPeriodEndSubmitToStExByCOHardcopyFlag { get; set; }

        //New Column add on 14-Apr-2015

        [DisplayName("rul_lbl_55231")]
        public bool StExSubmitDiscloToCOByInsdrFlag { get; set; }

        [DisplayName("rul_lbl_55193")]
        public bool StExSubmitDiscloToCOByInsdrSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_55190")]
        public bool StExSubmitDiscloToCOByInsdrHardcopyFlag { get; set; }

        //New column added on 2-Jun-2016(YES BANK customization)
        [DisplayName("rul_lbl_55194")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_55221")]
        public bool SeekDeclarationFromEmpRegPossessionOfUPSIFlag { get; set; }

        [DisplayName("rul_lbl_55248")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_55211")]
        public string DeclarationFromInsiderAtTheTimeOfContinuousDisclosures { get; set; }

        [DisplayName("rul_lbl_55195")]
        public bool DeclarationToBeMandatoryFlag { get; set; }

        [DisplayName("rul_lbl_55196")]
        public bool DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag { get; set; }

        public List<DocumentDetailsModel> TradingPolicyDocumentFile { get; set; }


        public List<PreSecuritiesValuesModel_OS> PreSecuritiesValuesList { get; set; }

        [DisplayName("rul_lbl_55197")]
        public bool PreClrForAllSecuritiesFlag { get; set; }

        public bool StExForAllSecuritiesFlag { get; set; }

        public List<PopulateComboDTO> AssignedPreClearancerequiredforTransactionList { get; set; }

        public List<string> SelectedPreClearancerequiredforTransaction { get; set; }

        public List<PopulateComboDTO> AssignedPreClrProhibitNonTradePeriodTransactionList { get; set; }

        public List<string> SelectedPreClrProhibitNonTradePeriodTransaction { get; set; }

        public List<TransactionSecurityMapConfigDTO_OS> AllTransactionSecurityMappingList { get; set; }

        public List<TransactionSecurityMapConfigDTO_OS> SelectedTransactionSecurityMappingList { get; set; }

        public TransactionSecurity_OS TransactionSecurityMap { get; set; }

        [DisplayName("rul_lbl_55198")]
        public bool PreClrAllowNewForOpenPreclearFlag { get; set; }

        [DisplayName("rul_lbl_55199")]
        public int? PreClrMultipleAboveInCodeId { get; set; }

        [DisplayName("rul_lbl_55200")]
        public int PreClrApprovalPreclearORPreclearTradeFlag { get; set; }

        [DisplayName("rul_lbl_55201")]
        public bool PreClrTradesAutoApprovalReqFlag { get; set; }


        public int? PreClrSingMultiPreClrFlagCodeId { get; set; }


        public int GenCashAndCashlessPartialExciseOptionForContraTrade { get; set; }

       // [DisplayName("rul_lbl_55202")]
        public bool GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate { get; set; }

        public bool? TradingThresholdLimtResetFlag { get; set; }

        [DisplayName("rul_lbl_55203")]
        public TPYesNo_OS ThresholdLimtResetFlag { get; set; }

        [DisplayName("rul_lbl_55204")]
        public int? ContraTradeBasedOn { get; set; }

        public List<PopulateComboDTO> AllSecurityTypeList { get; set; }

        public List<PopulateComboDTO> ContraTradeSelectedSecurityTypeList { get; set; }

        [DisplayName("rul_lbl_55318")]
        public bool IsPreclearanceFormForImplementingCompany { get; set; }

        
        [DisplayName("rul_lbl_55207")]
        public int PreclearanceWithoutPeriodEndDisclosure { get; set; }

        [DefaultValue(true)]
        [DisplayName("rul_lbl_55208")]
        public bool PreClrApprovalReasonReqFlag { get; set; }

        //Add new filed for restricted list (28-01-2020)
        [DisplayName("rul_lbl_55315")]
        public bool IsPreClearanceRequired { get; set; }
       
        public int? RestrictedListConfigId { get; set; }
      
        public int? Id { get; set; }

        [DisplayName("rul_lbl_55310")]
        public int SearchType { get; set; }

        [DisplayName("rul_lbl_55321")]
        //[RegularExpression("^[0-9]*$", ErrorMessage = "rl_msg_55323")]
        //[Range(1, 99, ErrorMessage = "rl_msg_55322")]
        public int? SearchLimit { get; set; }

        [DisplayName("rul_lbl_55364")]
        public int ApprovalType { get; set; }

        [DisplayName("rul_lbl_55316")]
        public bool IsDematAllowed { get; set; }

        [DisplayName("rul_lbl_55320")]
        public bool IsFormFRequired { get; set; }
       
        

    }
    public class PreSecuritiesValuesModel_OS
    {
        public int? SecurityCodeID { get; set; }

        public int? NoOfShare { get; set; }

        [RegularExpression(@"^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$", ErrorMessage = "rul_msg_50499")]
        public decimal? Capital { get; set; }

        public decimal? ValueOfShare { get; set; }
    }

    public class TransactionSecurityMapping_OS
    {
        public int TransactionTypeID { get; set; }

        public string TransactionType { get; set; }

        public int SecurityTypeID { get; set; }

        public string SecurityType { get; set; }
    }

    public class TransactionSecurity_OS
    {
        //this array will be used to POST values from the form to the controller
        public string[] TransactionSecurityId { get; set; }
    }

    public class TransactionSecuritymap_OS
    {
        public int? TransactionType { get; set; }

        public int? SecurityType { get; set; }
    }

    public enum TPYesNo_OS
    {
        No = 0,
        Yes = 1
    }
    
}