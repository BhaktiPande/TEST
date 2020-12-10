using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class MassUploadLogDTO
    {
        [PetaPoco.Column("MassUploadLogId")]
        public int MassUploadLoglId { get; set; }

        [PetaPoco.Column("MassUploadTypeId")]
        public int MassUploadTypeId { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public int CreatedBy { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }

        [PetaPoco.Column("Status")]
        public int Status { get; set; }

        [PetaPoco.Column("ErrorReportFileName")]
        public string ErrorReportFileName { get; set; }

    }
}
