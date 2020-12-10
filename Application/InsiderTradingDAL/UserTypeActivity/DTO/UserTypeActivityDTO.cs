
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("usr_UserTypeActivity")]
    public class UserTypeActivityDTO
    {	
				[PetaPoco.Column("ActivityId")]
		public int? ActivityId { get; set; }

		[PetaPoco.Column("UserTypeCodeId")]
		public int? UserTypeCodeId { get; set; }

	      
    }
}
