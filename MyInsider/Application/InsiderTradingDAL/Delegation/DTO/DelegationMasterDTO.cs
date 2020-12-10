
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("usr_DelegationMaster")]
    public class DelegationMasterDTO
    {	
		[PetaPoco.Column("DelegationId")]
		public int DelegationId { get; set; }

		[PetaPoco.Column("DelegationFrom")]
		public DateTime? DelegationFrom { get; set; }

		[PetaPoco.Column("DelegationTo")]
		public DateTime? DelegationTo { get; set; }

		[PetaPoco.Column("UserInfoIdFrom")]
		public int? UserInfoIdFrom { get; set; }

		[PetaPoco.Column("UserInfoIdTo")]
		public int? UserInfoIdTo { get; set; }

	      
    }
}
