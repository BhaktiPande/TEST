using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class ApplicabilityDTO_OS
    {
        [PetaPoco.Column("AllEmployeeFlag")]
        public bool AllEmployeeFlag { get; set; }

        [PetaPoco.Column("AllInsiderFlag")]
        public bool AllInsiderFlag { get; set; }

        [PetaPoco.Column("AllEmployeeInsiderFlag")]
        public bool AllEmployeeInsiderFlag { get; set; }

        [PetaPoco.Column("AssociatedCorporateCnt")]
        public int AssociatedCorporateCnt { get; set; }

        [PetaPoco.Column("AssociatedNonEmployeeCnt")]
        public int AssociatedNonEmployeeCnt { get; set; }

        [PetaPoco.Column("AllCo")]
        public bool AllCo { get; set; }

        [PetaPoco.Column("AllCorporateEmployees")]
        public bool AllCorporateEmployees { get; set; }

        [PetaPoco.Column("AllNonEmployee")]
        public bool AllNonEmployee { get; set; }

        [PetaPoco.Column("RecordCount")]
        public int RecordCount { get; set; }
    }
}
