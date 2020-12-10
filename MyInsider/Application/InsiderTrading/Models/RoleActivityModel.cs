
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;
using System.ComponentModel;

namespace InsiderTrading.Models
{
    public class RoleActivityModel
    {
       		
		public int? RoleActivityID { get; set; }

        [DisplayName("usr_lbl_11009")]
		public int? ActivityID { get; set; }

        [DisplayName("usr_lbl_11009")]
		public int? RoleID { get; set; }

        [DisplayName("usr_lbl_11009")]
		public int? AccessModeCodeID { get; set; }


 
    }
}
