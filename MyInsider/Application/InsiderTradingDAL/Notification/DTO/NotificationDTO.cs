
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    public class NotificationDTO
    {	
				[PetaPoco.Column("NotificationQueueId")]
		public string NotificationQueueId { get; set; }

		[PetaPoco.Column("CompanyIdentifierCodeId")]
		public int? CompanyIdentifierCodeId { get; set; }

		[PetaPoco.Column("RuleModeId")]
		public int? RuleModeId { get; set; }

		[PetaPoco.Column("ModeCodeId")]
		public int? ModeCodeId { get; set; }

        [PetaPoco.Column("ModeCodeName")]
        public string ModeCodeName { get; set; }

		[PetaPoco.Column("EventLogId")]
		public string EventLogId { get; set; }

		[PetaPoco.Column("UserId")]
		public int? UserId { get; set; }

		[PetaPoco.Column("UserContactInfo")]
		public string UserContactInfo { get; set; }

		[PetaPoco.Column("Subject")]
		public string Subject { get; set; }

		[PetaPoco.Column("Contents")]
		public string Contents { get; set; }

		[PetaPoco.Column("Signature")]
		public string Signature { get; set; }

		[PetaPoco.Column("CommunicationFrom")]
		public string CommunicationFrom { get; set; }

		[PetaPoco.Column("ResponseStatusCodeId")]
		public int? ResponseStatusCodeId { get; set; }

		[PetaPoco.Column("ResponseMessage")]
		public string ResponseMessage { get; set; }


        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }

        [PetaPoco.Column("AlertCount")]
        public int AlertCount { get; set; }

        public string NotificationTYPE { get; set; }

    }
}
