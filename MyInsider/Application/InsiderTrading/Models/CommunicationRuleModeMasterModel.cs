

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
    public class CommunicationRuleModeMasterModel
    {
		[DisplayName("XXXX")]
		public int? RuleModeId { get; set; }

		[DisplayName("XXXX")]
		public int? RuleId { get; set; }

		[DisplayName("XXXX")]
		public int? ModeCodeId { get; set; }

		[DisplayName("XXXX")]
		public int? TemplateId { get; set; }

		[DisplayName("XXXX")]
		public int? WaitDaysAfterTriggerEvent { get; set; }

		[DisplayName("XXXX")]
		public int? ExecFrequencyCodeId { get; set; }

		[DisplayName("XXXX")]
		public int? NotificationLimit { get; set; }

		[DisplayName("XXXX")]
		public int? UserId { get; set; }


 
    }
}
