
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("usr_RoleMaster")]
    public class RoleMasterDTO
    {	
				[PetaPoco.Column("RoleId")]
		public int? RoleId { get; set; }

		[PetaPoco.Column("RoleName")]
		public string RoleName { get; set; }

		[PetaPoco.Column("Description")]
		public string Description { get; set; }

		[PetaPoco.Column("StatusCodeId")]
		public int? StatusCodeId { get; set; }
        
		[PetaPoco.Column("UserTypeCodeId")]
		public int UserTypeCodeId { get; set; }

        [PetaPoco.Column("IsDefault")]
        public bool IsDefault { get; set; }

        [PetaPoco.Column("IsActivityAssigned")]
        public int? IsActivityAssigned { get; set; }
    }
}
