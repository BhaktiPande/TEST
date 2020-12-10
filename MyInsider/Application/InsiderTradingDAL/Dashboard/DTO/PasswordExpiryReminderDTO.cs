using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PasswordExpiryReminderDTO
    {
        [PetaPoco.Column("UserID")]
        public int UserID { get; set; }

        [PetaPoco.Column("ValidityDate")]
        public DateTime ValidityDate { get; set; }

        [PetaPoco.Column("ExpiryReminderDate")]
        public DateTime ExpiryReminderDate { get; set; }

        [PetaPoco.Column("PasswordChangeDate")]
        public DateTime PasswordChangeDate { get; set; }
    }
}
