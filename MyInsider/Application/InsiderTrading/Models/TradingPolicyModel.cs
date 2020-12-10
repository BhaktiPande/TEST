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
    public class TradingPolicyModel
    {

        [Required]
        public int? TradingPolicyId { get; set; }

        [DisplayName("rul_lbl_15196")]
        public int? TradingPolicyForCodeId { get; set; }

        public int? CurrentHistoryCodeId { get; set; }

        public int? TradingPolicyParentId { get; set; }

        [Required]
        [StringLength(50)]
        [DisplayName("rul_lbl_15151")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "rul_msg_50497")]
        public string TradingPolicyName { get; set; }

        //[Required]
        [StringLength(200)]
        [DisplayName("rul_lbl_15152")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_50498")]
        public string TradingPolicyDescription { get; set; }

        [Required]
        [DisplayName("rul_lbl_15153")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableToDate", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15044")]
        public DateTime? ApplicableFromDate { get; set; }

        [Required]
        [DisplayName("rul_lbl_15154")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableFromDate", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15044")]
        public DateTime? ApplicableToDate { get; set; }

        [DisplayName("rul_lbl_15155")]
        public bool PreClrTradesApprovalReqFlag { get; set; }

        [DisplayName("rul_lbl_15157")]
        [Range(1, 99999999, ErrorMessage = "rul_msg_15228")]
        public int? PreClrSingleTransTradeNoShares { get; set; }

        [DisplayName("rul_lbl_15158")]
        //^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$
        [RegularExpression("^(100([.][0]{1,})?$|[0-9]{1,2}([.][0-9]{1,})?)$", ErrorMessage = "rul_msg_15244")]
        public decimal? PreClrSingleTransTradePercPaidSubscribedCap { get; set; }

        [DisplayName("rul_lbl_15159")]
        public bool PreClrProhibitNonTradePeriodFlag { get; set; }

        [DisplayName("rul_lbl_15160")]
       // [DefaultValue(0.00)]
        [Range(0, 99, ErrorMessage = "rul_msg_15229")]
        public int? PreClrCOApprovalLimit { get; set; }

        [DisplayName("rul_lbl_15162")]
        [Range(0, 99, ErrorMessage = "rul_msg_15230")]
        public int? PreClrApprovalValidityLimit { get; set; }

        [DisplayName("rul_lbl_15164")]
        public bool PreClrSeekDeclarationForUPSIFlag { get; set; }

        [DisplayName("rul_lbl_15165")]
        [StringLength(5000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_50498")]
        public string PreClrUPSIDeclaration { get; set; }

        [DefaultValue(true)]
        [DisplayName("rul_lbl_15166")]
        public bool PreClrReasonForNonTradeReqFlag { get; set; }

        [DisplayName("rul_lbl_15167")]
        public bool PreClrCompleteTradeNotDoneFlag { get; set; }

        [DisplayName("rul_lbl_15168")]
        public bool PreClrPartialTradeNotDoneFlag { get; set; }

        [DisplayName("rul_lbl_15184")]//Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within")]//"Trade Disclosure for preclearance approval transaction within")]
        [Range(0, 99, ErrorMessage = "rul_msg_15231")]
        public int? PreClrTradeDiscloLimit { get; set; }

        [DisplayName("Trade Disclosure Within - ")]
        [Range(0, 99, ErrorMessage = "rul_msg_15232")]
        public int? PreClrTradeDiscloShareholdLimit { get; set; }

        [DisplayName("rul_lbl_15187")]
        public bool StExSubmitTradeDiscloAllTradeFlag { get; set; }

        [DisplayName("XXXX")]
        public int? StExSingMultiTransTradeFlagCodeId { get; set; }

        [DisplayName("rul_lbl_15190")]
        public int? StExMultiTradeFreq { get; set; }

        [DisplayName("rul_lbl_15191")]
        public int? StExMultiTradeCalFinYear { get; set; }

        [DisplayName("rul_lbl_15157")]
        [Range(1, 99999999, ErrorMessage = "rul_msg_15233")]
        public int? StExTransTradeNoShares { get; set; }

        [DisplayName("rul_lbl_15158")]
        [RegularExpression("^(100([.][0]{1,})?$|[0-9]{1,2}([.][0-9]{1,})?)$", ErrorMessage = "rul_msg_15244")]
        public decimal? StExTransTradePercPaidSubscribedCap { get; set; }

        [DisplayName("rul_lbl_15192")]
        [Range(1, 9999999999, ErrorMessage = "rul_msg_15234")]
        public int? StExTransTradeShareValue { get; set; }

        [DisplayName("rul_lbl_15194")]
        [Range(0, 99, ErrorMessage = "rul_msg_15235")]
        public int? StExTradeDiscloSubmitLimit { get; set; }

        [DisplayName("rul_lbl_15236")]
        public bool DiscloInitReqFlag { get; set; }

        [DisplayName("rul_lbl_15172")]
        [Range(0, 99, ErrorMessage = "rul_msg_15237")]
        public int? DiscloInitLimit { get; set; }

        [DisplayName("rul_lbl_15174")]
      //  [Range(0, 99, ErrorMessage = "Enter Initial Disclosure before Max 2 digit number")]
        public DateTime? DiscloInitDateLimit { get; set; }

        [DisplayName("rul_lbl_15197")]
        public bool DiscloPeriodEndReqFlag { get; set; }

        [DisplayName("rul_lbl_15198")]
        public int? DiscloPeriodEndFreq { get; set; }

        [DisplayName("rul_lbl_15204")]
        public string GenSecurityType { get; set; }

        [DisplayName("rul_lbl_15205")]
        public bool GenTradingPlanTransFlag { get; set; }

        [DisplayName("rul_lbl_15208")]
        [Range(0, 99, ErrorMessage = "rul_msg_15238")]
        public int? GenMinHoldingLimit { get; set; }

        [DisplayName("rul_lbl_15210")]
        [Range(0, 999, ErrorMessage = "rul_msg_15239")]
        public int? GenContraTradeNotAllowedLimit { get; set; }

        [DisplayName("rul_lbl_15212")]
        public string GenExceptionFor { get; set; }

        [DisplayName("rul_lbl_15213")]
        public int? TradingPolicyStatusCodeId { get; set; }

        public List<PopulateComboDTO> TradingPolicyCodeList { get; set; }

        public List<PopulateComboDTO> AssignedGenSecurityTypeList { get; set; }

        public List<string> SelectedGenSecurityType { get; set; }

        public List<PopulateComboDTO> AssignedGenExceptionForList { get; set; }

        public List<string> SelectedGenExceptionFor { get; set; }

        [DisplayName("rul_lbl_15181")]
        public bool DiscloInitSubmitToStExByCOFlag { get; set; }

        [DisplayName("rul_lbl_15193")]
        public bool StExSubmitDiscloToStExByCOFlag { get; set; }

        [DisplayName("rul_lbl_15199")]
        [Range(0, 99, ErrorMessage = "rul_msg_15240")]
        public int? DiscloPeriodEndToCOByInsdrLimit { get; set; }

        [DisplayName("rul_lbl_15201")]
        public bool DiscloPeriodEndSubmitToStExByCOFlag { get; set; }

        [DisplayName("rul_lbl_15202")]
        [Range(0, 99, ErrorMessage = "rul_msg_15241")]
        public int? DiscloPeriodEndSubmitToStExByCOLimit { get; set; }

        //New Column add on 07-Apr-2015

        [DisplayName("rul_lbl_15179")]
        public bool DiscloInitReqSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_15180")]
        public bool DiscloInitReqHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_15179")]
        public bool DiscloInitSubmitToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_15180")]
        public bool DiscloInitSubmitToStExByCOHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_15182")]
        [Range(0, 99, ErrorMessage = "rul_msg_15242")]
        public int? StExTradePerformDtlsSubmitToCOByInsdrLimit { get; set; }

        [DisplayName("rul_lbl_15179")]
        public bool StExSubmitDiscloToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_15180")]
        public bool StExSubmitDiscloToStExByCOHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_15179")]
        public bool DiscloPeriodEndReqSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_15180")]
        public bool DiscloPeriodEndReqHardcopyFlag { get; set; }

        [DisplayName("rul_lbl_15179")]
        public bool DiscloPeriodEndSubmitToStExByCOSoftcopyFlag { get; set; }

        [DisplayName("rul_lbl_15180")]
        public bool DiscloPeriodEndSubmitToStExByCOHardcopyFlag { get; set; }

        //New Column add on 14-Apr-2015

         [DisplayName("rul_lbl_15243")]
        public bool StExSubmitDiscloToCOByInsdrFlag { get; set; }

         [DisplayName("rul_lbl_15179")]
        public bool StExSubmitDiscloToCOByInsdrSoftcopyFlag { get; set; }

         [DisplayName("rul_lbl_15180")]
        public bool StExSubmitDiscloToCOByInsdrHardcopyFlag { get; set; }

         //New column added on 2-Jun-2016(YES BANK customization)
         [DisplayName("rul_lbl_50069")]
         [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_50498")]
         public bool SeekDeclarationFromEmpRegPossessionOfUPSIFlag { get; set; }

         [DisplayName("rul_lbl_50070")]
         [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rul_msg_50498")]
         public string DeclarationFromInsiderAtTheTimeOfContinuousDisclosures { get; set; }

         [DisplayName("rul_lbl_50071")]
         public bool DeclarationToBeMandatoryFlag { get; set; }

         [DisplayName("rul_lbl_50072")]
         public bool DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag { get; set; }

         public List<DocumentDetailsModel> TradingPolicyDocumentFile { get; set; }


         public List<PreSecuritiesValuesModel> PreSecuritiesValuesList { get; set; }

         [DisplayName("rul_lbl_15389")]
         public bool PreClrForAllSecuritiesFlag { get; set; }

         public bool StExForAllSecuritiesFlag { get; set; }

         public List<PopulateComboDTO> AssignedPreClearancerequiredforTransactionList { get; set; }

         public List<string> SelectedPreClearancerequiredforTransaction { get; set; }

         public List<PopulateComboDTO> AssignedPreClrProhibitNonTradePeriodTransactionList { get; set; }

         public List<string> SelectedPreClrProhibitNonTradePeriodTransaction { get; set; }

         public List<TransactionSecurityMapConfigDTO> AllTransactionSecurityMappingList { get; set; }

         public List<TransactionSecurityMapConfigDTO> SelectedTransactionSecurityMappingList { get; set; }

         public TransactionSecurity TransactionSecurityMap { get; set; }

         [DisplayName("rul_lbl_15416")]
         public bool PreClrAllowNewForOpenPreclearFlag { get; set; }

         [DisplayName("rul_lbl_15420")]
         public int? PreClrMultipleAboveInCodeId { get; set; }

         [DisplayName("rul_lbl_15421")]
         public int PreClrApprovalPreclearORPreclearTradeFlag { get; set; }

         [DisplayName("rul_lbl_15417")]
         public bool PreClrTradesAutoApprovalReqFlag { get; set; }

       
         public int? PreClrSingMultiPreClrFlagCodeId { get; set; }

        
         public int GenCashAndCashlessPartialExciseOptionForContraTrade { get; set; }

         [DisplayName("rul_lbl_15440")]
         public bool GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate { get; set; }

        public bool? TradingThresholdLimtResetFlag { get; set; }

        [DisplayName("rul_lbl_15446")]
        public TPYesNo ThresholdLimtResetFlag { get; set; }

        [DisplayName("rul_lbl_15455")]
        public int? ContraTradeBasedOn { get; set; }

        public List<PopulateComboDTO> AllSecurityTypeList { get; set; }

        public List<PopulateComboDTO> ContraTradeSelectedSecurityTypeList { get; set; }

        [DisplayName("rul_lbl_15460")]
        public bool IsPreclearanceFormForImplementingCompany { get; set; }

        [DisplayName("rul_lbl_15461")]
        public int PreclearanceWithoutPeriodEndDisclosure { get; set; }

        [DefaultValue(true)]
        [DisplayName("rul_lbl_50551")]
        public bool PreClrApprovalReasonReqFlag { get; set; }

    }

    public class PreSecuritiesValuesModel
    {
        public int? SecurityCodeID { get; set; }

        public int? NoOfShare { get; set; }

        [RegularExpression(@"^(100\.00|100\.0|100)|([0-9]{1,2}){0,1}(\.[0-9]{1,2}){0,1}$", ErrorMessage = "rul_msg_50499")]
        public decimal? Capital { get; set; }

        public decimal? ValueOfShare { get; set; }
    }

    public class TransactionSecurityMapping{

        public int TransactionTypeID { get; set; }

        public string TransactionType { get; set; }

        public int SecurityTypeID { get; set; }

         public string SecurityType { get; set; }
    }

    public class TransactionSecurity
    {
        //this array will be used to POST values from the form to the controller
        public string[] TransactionSecurityId { get; set; }
    }

    public class TransactionSecuritymap
    {
        public int? TransactionType { get; set; }

        public int? SecurityType { get; set; }
    }

    public enum TPYesNo
    {
        No = 0,
        Yes = 1
    }

}