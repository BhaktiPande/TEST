using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_DMATDetails")]
    public class DMATDetailsDTO
    {
        [PetaPoco.Column("DMATDetailsID")]
        public int DMATDetailsID { get; set; }

        [PetaPoco.Column("UserInfoID")]
        public int UserInfoID { get; set; }

        [PetaPoco.Column("DEMATAccountNumber")]
        public string DEMATAccountNumber { get; set; }

        [PetaPoco.Column("DPBank")]
        public string DPBank { get; set; }

        [PetaPoco.Column("DPID")]
        public string DPID { get; set; }

        [PetaPoco.Column("TMID")]
        public string TMID { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("AccountTypeCodeId")]
        public int AccountTypeCodeId { get; set; }

        [PetaPoco.Column("DPBankCodeId")]
        public int? DPBankCodeId { get; set; }

        [PetaPoco.Column("DmatAccStatusCodeId")]
        public int DmatAccStatusCodeId { get; set; }

        public int PendingPeriodEndCount { get; set; }

        public int PendingTransactionsCountPNT { get; set; }

        public int PendingTransactionsCountPCL { get; set; }
    }
}
