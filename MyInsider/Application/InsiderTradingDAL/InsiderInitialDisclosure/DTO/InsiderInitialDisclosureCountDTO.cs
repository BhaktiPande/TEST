using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL.InsiderInitialDisclosure.DTO
{
    public class InsiderInitialDisclosureCountDTO
    {
        [PetaPoco.Column("InsiderCount")]
        public int InsiderCount { get; set; }

        [PetaPoco.Column("SoftCopyPendingCount")]
        public int SoftCopyPendingCount { get; set; }

        [PetaPoco.Column("HardCopyPendingCount")]
        public int HardCopyPendingCount { get; set; }

        [PetaPoco.Column("SoftCopySubmittedCount")]
        public int SoftCopySubmittedCount { get; set; }

        [PetaPoco.Column("HardCopySubmittedCount")]
        public int HardCopySubmittedCount { get; set; }

        public int IDTransCntforEmployee { get; set; }
        public int IDTransCntforInsider { get; set; }
    }

}

