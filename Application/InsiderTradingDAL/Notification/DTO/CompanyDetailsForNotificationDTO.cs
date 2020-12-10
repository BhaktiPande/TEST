using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CompanyDetailsForNotificationDTO
    {
        [PetaPoco.Column("SmtpServer")]
        public string SmtpServer { get; set; }

        [PetaPoco.Column("SmtpPortNumber")]
        public string SmtpPortNumber { get; set; }

        [PetaPoco.Column("SmtpUserName")]
        public string SmtpUserName { get; set; }

        [PetaPoco.Column("SmtpPassword")]
        public string SmtpPassword { get; set; }

        [PetaPoco.Column("FromMailID")]
        public string FromMailID { get; set; }
    }

    public class CompanyIDListDTO
    {
        [PetaPoco.Column("CompanyId")]
        public int CompanyId { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("ConnectionDatabaseName")]
        public string ConnectionDatabaseName { get; set; }

    }

    public class NotificationSendListDTO
    {
        [PetaPoco.Column("NotificationQueueId")]
        public string NotificationQueueId { get; set; }

        [PetaPoco.Column("CompanyIdentifierCodeId")]
        public int? CompanyIdentifierCodeId { get; set; }

        [PetaPoco.Column("RuleModeId")]
        public int? RuleModeId { get; set; }

        [PetaPoco.Column("ModeCodeId")]
        public int? ModeCodeId { get; set; }

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

        [PetaPoco.Column("DocumentPath")]
        public string DocumentPath { get; set; }

        [PetaPoco.Column("DocumentName")]
        public string DocumentName { get; set; }
    }
}
