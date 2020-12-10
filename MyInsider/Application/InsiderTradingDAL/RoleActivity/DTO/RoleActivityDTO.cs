
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("usr_RoleActivity")]
    public class RoleActivityDTO
    {
        [PetaPoco.Column("ActivityID")]
        public int? ActivityID { get; set; }

        [PetaPoco.Column("ScreenName")]
        public string ScreenName { get; set; }

        [PetaPoco.Column("ActivityName")]
        public string ActivityName { get; set; }

        [PetaPoco.Column("Module")]
        public string Module { get; set; }

        [PetaPoco.Column("ControlName")]
        public string ControlName { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("Status")]
        public string Status { get; set; }


        [PetaPoco.Column("IsSelected")]
        public int? IsSelected { get; set; } 
	      
    }
}
