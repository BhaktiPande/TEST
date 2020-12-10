using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class DefaulterReportOverrideDTO
    {
        [PetaPoco.Column("IsRemovedFromNonCompliance")]
        public int? IsRemovedFromNonCompliance { get; set; }

        [PetaPoco.Column("Reason")]
        public string Reason { get; set; }

        [PetaPoco.Column("DefaulterReportID")]
        public long? DefaulterReportID { get; set; }
    }
}
