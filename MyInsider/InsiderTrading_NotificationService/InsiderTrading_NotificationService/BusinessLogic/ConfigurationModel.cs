using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
   public class ConfigurationModel
    {
           public string SmtpServer { get; set; }

           public string SmtpPortNumber { get; set; }

           public string SmtpUserName { get; set; }

           public string SmtpPassword { get; set; }
    }
}
