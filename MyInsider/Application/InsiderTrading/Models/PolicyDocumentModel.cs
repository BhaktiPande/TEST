
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace InsiderTrading.Models
{
    public class PolicyDocumentModel
    {                
       	[ScaffoldColumn(false)]
        //[Required]
        //[DisplayName("XXXX")]
		public int? PolicyDocumentId { get; set; }

        [StringLength(50, ErrorMessage = "rul_msg_15125")]
		[Required]
        [DisplayName("rul_lbl_15107")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "rul_msg_50496")]
		public string PolicyDocumentName { get; set; }

        [Required]
        [DisplayName("rul_lbl_15108")]
		public int? DocumentCategoryCodeId { get; set; }

        [Required]
        [DisplayName("rul_lbl_15109")]
		public int? DocumentSubCategoryCodeId { get; set; }

		[Required]
        [DisplayName("rul_lbl_15110")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableTo", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15126")]
		public DateTime? ApplicableFrom { get; set; }

        [Required]
        [DisplayName("rul_lbl_15111")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableFrom", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15127")]
		public DateTime? ApplicableTo { get; set; }

		[Required]
        [DisplayName("rul_lbl_15112")]
		public int? CompanyId { get; set; }
		
        public bool DisplayInPolicyDocumentFlag { get; set; }

        [Required]
        [DisplayName("rul_lbl_15113")]
        public YesNo? DisplayInPolicyDocument { get; set; }

		public bool SendEmailUpdateFlag { get; set; }

        [Required]
        [DisplayName("rul_lbl_15114")]
        public YesNo? SendEmailUpdate { get; set; }

		public int? WindowStatusCodeId { get; set; }

        //[Required]
        [DisplayName("rul_lbl_15115")]
        public WindowStatusCode? WindowStatus { get; set; }

        [DisplayName("rul_lbl_15116")]
        public bool DocumentViewFlag { get; set; }

        [DisplayName("rul_lbl_15117")]
        public bool DocumentViewAgreeFlag { get; set; }

        [DateCompare(CompareToPropertyName = "ApplicableTo", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15128")]
        public DateTime? DBCurrentDate { get; set; }

        public String DocumentCategoryName { get; set; }

        public String DocumentSubCategoryName { get; set; }

        public String CompanyName { get; set; }

        public List<DocumentDetailsModel> PolicyDocumentFile { get; set; }

        public List<DocumentDetailsModel> EmailAttachment { get; set; }

        public bool isSaveAllowed { get; set; }

        //Field for policy document status page search functionality
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmpolyeeID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmpolyeeName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmpID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmpName { get; set; }
 
    }

    public enum YesNo
    {
        No = 0,
        Yes = 1
    }

    public enum WindowStatusCode
    {
        Incomplete = Common.ConstEnum.Code.PolicyDocumentWindowStatusIncomplete,
        Active = Common.ConstEnum.Code.PolicyDocumentWindowStatusActive,
        Deactive = Common.ConstEnum.Code.PolicyDocumentWindowStatusDeactive
    }
}
