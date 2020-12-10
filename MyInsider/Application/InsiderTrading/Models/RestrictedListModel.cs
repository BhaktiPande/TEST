using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using InsiderTrading.Common;

namespace InsiderTrading.Models
{
    public class RestrictedListModel
    {
        public int? CompanyId { get; set; }
		
        [DefaultValue(0)]
        public int? RLCompanyId { get; set; }

        [StringLength(300)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13060")]
        public string CompanyName { get; set; }

        [StringLength(100)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13105")]
        public string ISINCode { get; set; }

        [StringLength(100)]
        [DataType(DataType.Text)]
        [DisplayName("rl_lbl_50000")]
        public string BSECode { get; set; }

        [StringLength(100)]        
        [DisplayName("rl_lbl_50001")]
        public string NSECode { get; set; }

        [StringLength(100)]
        [DisplayName("rl_lbl_50004")]
        public string CreatedBy { get; set; }

        //[Required]
        //[DisplayName("rul_lbl_15111")]       
        //[DataType(DataType.DateTime)]
        //[DateCompare(CompareToPropertyName = "ApplicableFrom", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15127")]
        public DateTime? ApplicableTo { get; set; }

        //[DisplayName("rul_lbl_15110")]
        //[DataType(DataType.DateTime)]
        //[DateCompare(CompareToPropertyName = "ApplicableTo", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15126")]
        public DateTime? ApplicableFrom { get; set; }

        [DateCompare(CompareToPropertyName = "ApplicableTo", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15128")]
        public DateTime? DBCurrentDate { get; set; }

        [StringLength(50)]
        [DataType(DataType.Text)]
        public string Action { get; set; }

        [StringLength(100)]
        [DataType(DataType.Text)]
        public string Details { get; set; }

        [DisplayName("rl_lbl_50004")]
        public int? RlMasterId { get; set; }

        [DisplayName("usr_lbl_11354")]
        public string UserName { get; set; }

        [DisplayName("rl_lbl_50607")]
        public string RestrictedListStatus { get; set; }
    }
}