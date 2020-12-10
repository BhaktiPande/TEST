
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("cmu_CommunicationRuleModeMaster")]
    public class CommunicationRuleModeMasterDTO
    {	
		[PetaPoco.Column("RuleModeId")]
		public int? RuleModeId { get; set; }

		[PetaPoco.Column("RuleId")]
		public int? RuleId { get; set; }

		[PetaPoco.Column("ModeCodeId")]
		public int? ModeCodeId { get; set; }

		[PetaPoco.Column("TemplateId")]
		public int? TemplateId { get; set; }

		[PetaPoco.Column("WaitDaysAfterTriggerEvent")]
		public int? WaitDaysAfterTriggerEvent { get; set; }

		[PetaPoco.Column("ExecFrequencyCodeId")]
		public int? ExecFrequencyCodeId { get; set; }

		[PetaPoco.Column("NotificationLimit")]
		public int? NotificationLimit { get; set; }

		[PetaPoco.Column("UserId")]
		public int? UserId { get; set; }

	      
    }
}
