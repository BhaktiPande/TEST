
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("mst_Company")]
    public class CompanyNamesDTO
    {
        [PetaPoco.Column("CompanyId")]
        public int CompanyId { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

    }
}
