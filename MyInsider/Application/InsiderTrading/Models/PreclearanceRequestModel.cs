using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class PreclearanceRequestModel
    {
        [Required]
        public long PreclearanceRequestId { get; set; }

        [Required]
   //     [DisplayName("Pre-Clearance Request")]
        public int? PreclearanceRequestForCodeId { get; set; }

       
        public int? UserInfoId { get; set; }

        public int? UserInfoIdRelative { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "dis_msg_17231")]
        [DisplayName("dis_lbl_17081")]
        public int? TransactionTypeCodeId { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "dis_msg_17232")]
        [DisplayName("dis_lbl_17082")]
        public int? SecurityTypeCodeId { get; set; }

        [Required]
         [DisplayName("dis_lbl_17083")]
       // [DisplayName("Securities proposed to be traded")]
    //    [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$",ErrorMessage="Enter value greater than zero.")]
         [Range(0, 99999999999, ErrorMessage = "dis_msg_17265")]
        public decimal? SecuritiesToBeTradedQty { get; set; }

     
        public int? PreclearanceStatusCodeId { get; set; }

        [Required]
        [DisplayName("dis_lbl_17084")]
        public int? CompanyId { get; set; }
          [DisplayName("dis_lbl_17084")]
        public string CompanyName { get; set; }

        [Required]
        [DisplayName("dis_lbl_17085")]
    //    [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "Enter value greater than zero.")]
        [Range(0, 99999999999, ErrorMessage = "dis_msg_17266")]
        public decimal? ProposedTradeRateRangeFrom { get; set; }

        [Required]
        [DisplayName("dis_lbl_17086")]
  //      [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "Enter value greater than zero.")]
        [Range(0, 99999999999, ErrorMessage = "dis_msg_17267")]
        [GenericCompare(CompareToPropertyName = "ProposedTradeRateRangeFrom", OperatorName = GenericCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Integer, ErrorMessage = "dis_msg_17307")]//"Proposed Trade Rate Range To is Greater than Proposed Trade Rate Range From")]
        public decimal? ProposedTradeRateRangeTo { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "dis_msg_17233")]
        [DisplayName("dis_lbl_17087")]
        public int? DMATDetailsID1 { get; set; }

        [DisplayName("XXXX")]
        public int? ReasonForNotTradingCodeId { get; set; }

        [StringLength(30)]
        [DisplayName("dis_lbl_17271")]
        public string ReasonForNotTradingText { get; set; }

        public int? CreatedBy { get; set; }

        [DisplayName("dis_lbl_17080")]
        public DateTime? PreClearanceRequestedDate { get; set; }


         [DisplayName("dis_lbl_17235")]
        public string EmployeeId { get; set; }

        [DisplayName("dis_lbl_17236")]
        public string UserName { get; set; }

        [DisplayName("dis_lbl_17237")]
        public string SecurityTypeText { get; set; }

        [DisplayName("dis_lbl_17081")]
        public string TransactionTypeText { get; set; }

        [StringLength(200)]
        [DisplayName("dis_lbl_17238")]
        public string ReasonForRejection { get; set; }

        [StringLength(200)]
        [DisplayName("dis_lbl_50550")]
        public string ReasonForApproval { get; set; }

        [StringLength(200)]
        [DisplayName("dis_lbl_50552")]
        public string ReasonForApprovalText { get; set; }

        [ResourceKey("ReasonForApprovalCodeId")]
        [ActivityResourceKey("dis_lbl_50552")]
        [DisplayName("dis_lbl_50552")]
        public int? ReasonForApprovalCodeId { get; set; }

        [StringLength(30)]
        [DisplayName("dis_lbl_17239")]
        public string PreClearanceFor { get; set; }

        [StringLength(30)]
        [DisplayName("dis_lbl_17240")]
        public string RelativeName { get; set; }

        [DisplayName("dis_lbl_17241")]
        [Range(0, 99999999999, ErrorMessage = "dis_msg_17268")]
        public decimal? SecuritiesToBeTradedValue { get; set; }

        [DisplayName("dis_lbl_17271")]
        public string ReasonForNotTradingCodeText { get; set; }

        [DisplayName("Status : ")]
        public string PreclearanceStatusName { get; set; }

        [DisplayName("Date : ")]
        public DateTime? EventDate { get; set; }

        [DisplayName("dis_lbl_17397")]
        public bool ESOPExcerciseOptionQtyFlag { get; set; }

        [DisplayName("dis_lbl_17398")]
        public bool OtherESOPExcerciseOptionQtyFlag { get; set; }

        public decimal ESOPExcerciseOptionQty { get; set; }

        public decimal OtherExcerciseOptionQty { get; set; }

        [DisplayName("tra_lbl_16032")]
        public int ModeOfAcquisitionCodeId { get; set; }

        [DisplayName("tra_lbl_52114")]
        [DataType(DataType.DateTime)]
        public DateTime? PreclearanceValidityDate { get; set; }

        [DisplayName("tra_lbl_52112")]
        public decimal? SecuritiesApproved { get; set; }

        [DisplayName("tra_lbl_52113")]
        public DateTime? PreclearanceValidityDateChanged { get; set; }

        [DisplayName("tra_lbl_52127")]
        public string PreclearanceTakenQtyOld { get; set; }

        [DisplayName("tra_lbl_52128")]
        [DataType(DataType.DateTime)]
        public DateTime? DisplayPreclearanceValidityDate { get; set; }

        [DisplayName("tra_lbl_52126")]
        public DateTime? DisplayPreclearanceValidityDateChanged { get; set; }  

    }

    public class ViewModel
    {

    }

    public class LabelViewModel
    {

    }
}