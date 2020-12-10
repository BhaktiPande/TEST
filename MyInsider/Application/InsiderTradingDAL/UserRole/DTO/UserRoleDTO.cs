
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("usr_UserRole")]
    public class UserRoleDTO
    {	
				[PetaPoco.Column("UserRoleID")]
		public int? UserRoleID { get; set; }

		[PetaPoco.Column("UserInfoID")]
		public int? UserInfoID { get; set; }

		[PetaPoco.Column("RoleID")]
		public int? RoleID { get; set; }

	      
    }
}
