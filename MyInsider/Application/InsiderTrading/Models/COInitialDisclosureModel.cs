using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class COInitialDisclosureModel
    {
        [Display(Name = "dis_lbl_17291")]
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmployeeId { get; set; }

        [Display(Name = "dis_lbl_17292")]
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmployeeName { get; set; }

        [Display(Name = "dis_lbl_17293")]
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public int? DesignationId { get; set; }

         [Display(Name = "dis_lbl_17294")]
        public string EmailSentDate { get; set; }
        
        public DateTime? EmailSentDateFrom { get; set; }
        public DateTime? EmailSentDateTo { get; set; }

         [Display(Name = "dis_lbl_17295")]
        public string DisclosureReceiveDate { get; set; }
        public DateTime? DisclosureReceiveFrom { get; set; }
        public DateTime? DisclosureReceiveTo { get; set; }

        [Display(Name = "dis_lbl_17296")]
        public string HoldingDetailSubmission { get; set; }
        public DateTime? HoldingDetailSubmissionFrom { get; set; }
        public DateTime? HoldingDetailSubmissionTo { get; set; }
        public int HoldingDetailSubmissionStatus { get; set; }

        [Display(Name = "dis_lbl_17297")]
        public string SoftCopySubmission { get; set; }
        public DateTime? SoftCopySubmissionFrom { get; set; }
        public DateTime? SoftCopySubmissionTo { get; set; }
        public int SoftCopySubmissionStatus { get; set; }

        [Display(Name = "dis_lbl_17298")]
        public string HardCopySubmission { get; set; }
        public DateTime? HardCopySubmissionFrom { get; set; }
        public DateTime? HardCopySubmissionTo { get; set; }
        public int HardCopySubmissionStatus { get; set; }

         [Display(Name = "dis_lbl_17299")]
        public string StockExchangeSubmission { get; set; }
        public DateTime? StockExchangeSubmissionFrom { get; set; }
        public DateTime? StockExchangeSubmissionTo { get; set; }
        public int StockExchangeSubmissionStatus { get; set; }

        [Display(Name = "dis_lbl_17300")]
        public int From { get;set;}

         [Display(Name = "dis_lbl_17301")]
        public int To { get;set;}

         [Display(Name = "dis_lbl_17302")]
        public int Status { get;set;}

        //For PAN and EMP Status
         [Display(Name = "dis_lbl_50611")]
         [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
         public string EmployeePAN { get; set; }

         [Display(Name = "dis_lbl_50609")]
         public int EmployStatus { get; set; }
         public int EmployeeStatus { get; set; }
    }
}