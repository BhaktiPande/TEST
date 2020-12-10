using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CommonDTO
    {
        [PetaPoco.Column("Controller")]
        public string Controller { get; set; }

        [PetaPoco.Column("Action")]
        public string Action { get; set; }

        [PetaPoco.Column("Parameter")]
        public string Parameter { get; set; }

        //[PetaPoco.Column("PolicyDocumentId")]
        //public int? PolicyDocumentId { get; set; }

        //[PetaPoco.Column("DocumentId")]
        //public int? DocumentId { get; set; }

        //[PetaPoco.Column("CalledFrom")]
        //public string CalledFrom { get; set; }      
    }
}
