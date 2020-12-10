using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_PasswordConfig")]
    public class PasswordConfigDTO
    {
        [PetaPoco.Column("PasswordConfigID")]
        public int PasswordConfigID { get; set; }

        [PetaPoco.Column("MinLength")]
        public int MinLength { get; set; }

        [PetaPoco.Column("MaxLength")]
        public int MaxLength { get; set; }

        [PetaPoco.Column("MinAlphabets")]
        public int MinAlphabets { get; set; }

        [PetaPoco.Column("MinNumbers")]
        public int MinNumbers { get; set; }

        [PetaPoco.Column("MinSplChar")]
        public int MinSplChar { get; set; }

        [PetaPoco.Column("MinUppercaseChar")]
        public int MinUppercaseChar { get; set; }

        [PetaPoco.Column("CountOfPassHistory")]
        public int CountOfPassHistory { get; set; }

        [PetaPoco.Column("PassValidity")]
        public int PassValidity { get; set; }

        [PetaPoco.Column("ExpiryReminder")]
        public int ExpiryReminder { get; set; }

        [PetaPoco.Column("LastUpdatedOn")]
        public DateTime LastUpdatedOn { get; set; }

        [PetaPoco.Column("LastUpdatedBy")]
        public string LastUpdatedBy { get; set; }

        [PetaPoco.Column("LoginAttempts")]
        public int LoginAttempts { get; set; }

        public string SaultValue { get; set; }
    }
}
