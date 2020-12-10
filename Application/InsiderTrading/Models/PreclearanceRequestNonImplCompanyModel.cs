using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class PreclearanceRequestNonImplCompanyModel
    {
        [Required]
        public Int64 PreclearanceRequestId { get; set; }

        [Required]
        public int RlSearchAuditId { get; set; }

        [Required]
        public int RlSearchAuditIdOS { get; set; }

        public Int64 DisplaySequenceNo { get; set; }

        [Required]
        //[DisplayName("dis_lbl_17xxx")]
        public PreclearanceRequestFor PreclearanceRequestForCodeId { get; set; }

        [Required]
        public int UserInfoId { get; set; }

        [Required]
        [DisplayName("dis_lbl_17462")]
        public int? UserInfoIdRelative { get; set; }

        [DisplayName("dis_lbl_17463")]
        public DateTime PreclearanceDate { get; set; }

        [Required]
        [DisplayName("dis_lbl_17464")]
        public int TransactionTypeCodeId { get; set; }

        [Required]
        [DisplayName("dis_lbl_17465")]
        public int SecurityTypeCodeId { get; set; }

        [DisplayName("dis_lbl_17466")]
        public string CompanyName { get; set; }

        [Required]
        [DisplayName("dis_lbl_17467")]
        [Range(0, 99999999999, ErrorMessage = "dis_msg_17482")]
        public decimal? SecuritiesToBeTradedQty { get; set; }

        [DisplayName("dis_lbl_17468")]
        [Range(0, 99999999999, ErrorMessage = "dis_msg_17483")]
        public decimal? SecuritiesToBeTradedValue { get; set; }

        [Required]
        [DisplayName("dis_lbl_17469")]
        public int ModeOfAcquisitionCodeId { get; set; }

        [Required]
        [DisplayName("dis_lbl_17470")]
        public int DMATDetailsID { get; set; }

        [DisplayName("dis_lbl_17474")]
        public string PreclearanceStatusText { get; set; }

        [DisplayName("dis_lbl_17475")]
        public DateTime? ApproveOrRejectOn { get; set; }

        //[DisplayName("dis_lbl_17xxx")]
        //public string EmployeeName { get; set; }

        //[DisplayName("dis_lbl_17xxx")]
        //public string RelativeName { get; set; }

        //[DisplayName("dis_lbl_17xxx")]
        //public string EmployeeId { get; set; }

        //[Required]
        //[DisplayName("dis_lbl_17xxx")]
        //[StringLength(200)]
        //public string ReasonForRejection { get; set; }

        public int? PreclearanceStatusCodeId { get; set; }

        public int CompanyId { get; set; }

        public int? ApprovedBy { get; set; }

        public string ApprovedByName { get; set; }

        public int SequenceNo { get; set; }

        public string EmployeeName { get; set; }

        public string TransactionType { get; set; }

        public string SecurityType { get; set; }

        public string ModeOfAcquisition { get; set; }

        public string DEMATAccountNumber { get; set; }

        public string TradedFor { get; set; }

        [DisplayName("dis_lbl_17271")]
        public string ReasonForNotTradingCodeText { get; set; }

        [StringLength(30)]
        [DisplayName("dis_lbl_17271")]
        public string ReasonForNotTradingText { get; set; }

        public bool IsAutoApproved { get; set; }

        public string ReasonForApproval { get; set; }

        public string ReasonForApprovalCodeId { get; set; }

        public string ReasonForRejection { get; set; }
    }

    public enum PreclearanceRequestFor
    {
        Self = ConstEnum.Code.PreclearanceRequestForSelf,
        Relative = ConstEnum.Code.PreclearanceRequestForRelative
    }
}