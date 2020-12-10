
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("usr_Activity")]
    public class ActivityDTO
    {	
				[PetaPoco.Column("ActivityID")]
		public int? ActivityID { get; set; }

		[PetaPoco.Column("ScreenName")]
		public string ScreenName { get; set; }

		[PetaPoco.Column("ActivityName")]
		public string ActivityName { get; set; }

		[PetaPoco.Column("ModuleCodeID")]
		public int? ModuleCodeID { get; set; }

		[PetaPoco.Column("ControlName")]
		public string ControlName { get; set; }

		[PetaPoco.Column("Description")]
		public string Description { get; set; }

		[PetaPoco.Column("StatusCodeID")]
		public int? StatusCodeID { get; set; }

	      
    }
}
