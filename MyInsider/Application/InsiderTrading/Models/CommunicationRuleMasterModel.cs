
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using InsiderTradingDAL;

namespace InsiderTrading.Models
{
    public class CommunicationRuleMasterModel
    {

		public int RuleId { get; set; }

		[StringLength(510, ErrorMessage = "XXXX")]
		[Required]
        [DisplayName("cmu_lbl_18021")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "rpt_msg_50521")]
		public string RuleName { get; set; }

		[StringLength(2048, ErrorMessage = "XXXX")]
        [DisplayName("cmu_lbl_18023")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "cmu_msg_50516")]
		public string RuleDescription { get; set; }

		[StringLength(50, ErrorMessage = "XXXX")]
		[Required]
        [DisplayName("cmu_lbl_18027")]
		public string RuleForCodeId { get; set; }

		[Required]
        [DisplayName("cmu_lbl_18022")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "cmu_lbl_18059")]
		public int? RuleCategoryCodeId { get; set; }

		[Required]
        [DisplayName("cmu_lbl_18028")]
        public YesNo? InsiderPersonalize { get; set; }
		public bool InsiderPersonalizeFlag { get; set; }

		[StringLength(500, ErrorMessage = "XXXX")]
        [DisplayName("cmu_lbl_18024")]
		public string TriggerEventCodeId { get; set; }

		[StringLength(500, ErrorMessage = "XXXX")]
        [DisplayName("cmu_lbl_18025")]
		public string OffsetEventCodeId { get; set; }
        [DisplayName("cmu_lbl_18026")]
        public int EventsApplyToCodeId { get; set; }
        
		[Required]
        [DisplayName("cmu_lbl_18029")]
		public int? RuleStatusCodeId { get; set; }
        [DisplayName("cmu_lbl_18057")]

        public YesNo? RuleForCodeId_bool { get; set; }
        [DisplayName("cmu_lbl_18058")]
        public YesNo? EventsApplyToCodeId_bool { get; set; }

        public List<PopulateComboDTO> AssignedTriggerEventCodeId { get; set; }

        public List<string> SelectTriggerEventCodeId { get; set; }

        public List<CommunicationRuleModeMasterModel> CommunicationRuleModeMasterModelList { get; set; }
        public List<PopulateComboDTO> AssignedOffsetEventCodeId { get; set; }

        public List<string> SelectOffsetEventCodeId { get; set; }

        [DisplayName("cmu_lbl_18029")]
        public RuleStatusCode? RuleStatus { get; set; }

        public enum RuleStatusCode
        {
            Active = Common.ConstEnum.Code.CommunicationRuleStatusActive,
            Inactive = Common.ConstEnum.Code.CommunicationRuleStatusInactive
        }
        
        public bool? IsApplicabilityDefined { get; set; }
        
        public int? UserId { get; set; }
    }
}
