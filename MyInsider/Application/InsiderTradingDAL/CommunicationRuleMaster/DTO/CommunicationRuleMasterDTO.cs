
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("cmu_CommunicationRuleMaster")]
    public class CommunicationRuleMasterDTO
    {	
				[PetaPoco.Column("RuleId")]
		public int? RuleId { get; set; }

		[PetaPoco.Column("RuleName")]
		public string RuleName { get; set; }

		[PetaPoco.Column("RuleDescription")]
		public string RuleDescription { get; set; }

		[PetaPoco.Column("RuleForCodeId")]
		public string RuleForCodeId { get; set; }

		[PetaPoco.Column("RuleCategoryCodeId")]
		public int? RuleCategoryCodeId { get; set; }

        [PetaPoco.Column("EventsApplyToCodeId")]
        public int? EventsApplyToCodeId { get; set; }

		[PetaPoco.Column("InsiderPersonalizeFlag")]
		public bool InsiderPersonalizeFlag { get; set; }

		[PetaPoco.Column("TriggerEventCodeId")]
		public string TriggerEventCodeId { get; set; }

		[PetaPoco.Column("OffsetEventCodeId")]
		public string OffsetEventCodeId { get; set; }

		[PetaPoco.Column("RuleStatusCodeId")]
		public int? RuleStatusCodeId { get; set; }

        [PetaPoco.Column("IsApplicabilityDefined")]
        public bool? IsApplicabilityDefined { get; set; }

        [PetaPoco.Column("UserId")]
        public int? UserId { get; set; }
	      
    }
}
