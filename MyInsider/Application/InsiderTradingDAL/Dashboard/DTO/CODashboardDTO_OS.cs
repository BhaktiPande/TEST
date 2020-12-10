using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL 
{
   public  class CODashboardDTO_OS
    {
        [PetaPoco.Column("PersonalDetailsConfirmation")]
        public int PersonalDetailsConfirmation { get; set; }

        [PetaPoco.Column("PersonalDetailsReconfirmation")]
        public int PersonalDetailsReconfirmation { get; set; }

        [PetaPoco.Column("InitialDisclosures_OS")]
        public int InitialDisclosures_OS { get; set; }

        [PetaPoco.Column("InitialDisclosuresRelative_OS")]
        public int InitialDisclosuresRelative_OS { get; set; }

        [PetaPoco.Column("TradeDetails_OS")]
        public int TradeDetails_OS { get; set; }

        [PetaPoco.Column("PeriodendDisclosures_OS")]
        public int PeriodendDisclosures_OS { get; set; }

        [PetaPoco.Column("PreclearanceApproval_OS")]
        public int PreclearanceApproval_OS { get; set; }

        [PetaPoco.Column("TradingPolicydueforExpiry_OS")]
        public int TradingPolicydueforExpiry_OS { get; set; }

        [PetaPoco.Column("PolicyDocumentdueforExpiry")]
        public int PolicyDocumentdueforExpiry { get; set; }

    }
}
