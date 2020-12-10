
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_RoleMaster")]
    public class RolesDTO
    {
        [PetaPoco.Column("RoleId")]
        public int RoleId { get; set; }

        [PetaPoco.Column("RoleName")]
        public string RoleName { get; set; }

    }
}
