
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
    public class NotificationModel
    {
       		[Required]
		[DisplayName("XXXX")]
		public string NotificationQueueId { get; set; }

		[DisplayName("XXXX")]
		public int? CompanyIdentifierCodeId { get; set; }

		[Required]
		[DisplayName("XXXX")]
		public int? RuleModeId { get; set; }

        [DisplayName("cmu_lbl_18041")]
		public int? ModeCodeId { get; set; }

        [DisplayName("cmu_lbl_18041")]
        public string ModeCodeName { get; set; }

		[DisplayName("XXXX")]
		public string EventLogId { get; set; }

		[Required]
		[DisplayName("XXXX")]
		public int? UserId { get; set; }

        [StringLength(500, ErrorMessage = "cmu_lbl_18042")]
        [DisplayName("cmu_lbl_18042")]
		public string UserContactInfo { get; set; }

        [StringLength(300, ErrorMessage = "cmu_lbl_18037")]
        [DisplayName("cmu_lbl_18037")]
		public string Subject { get; set; }

        [StringLength(400, ErrorMessage = "cmu_lbl_18038")]
        [DisplayName("cmu_lbl_18038")]
		public string Contents { get; set; }

        [StringLength(400, ErrorMessage = "cmu_lbl_18043")]
        [DisplayName("cmu_lbl_18043")]
		public string Signature { get; set; }

		[StringLength(100, ErrorMessage = "XXXX")]
		[DisplayName("XXXX")]
		public string CommunicationFrom { get; set; }

		[DisplayName("XXXX")]
		public int? ResponseStatusCodeId { get; set; }

		[StringLength(400, ErrorMessage = "XXXX")]
		[DisplayName("XXXX")]
		public string ResponseMessage { get; set; }

        [DisplayName("cmu_lbl_18039")]
        public DateTime FromDate { get; set; }

        [DisplayName("cmu_lbl_18040")]
        public DateTime ToDate { get; set; }

        [DisplayName("cmu_lbl_18044")]
        public DateTime CreatedOn { get; set; }
    }
}
