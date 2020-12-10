using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class UserActivityDTO
    {
        [PetaPoco.Column("ActivityId")]
		public int ActivityId { get; set; }

        [PetaPoco.Column("ScreenName")]
        public string ScreenName { get; set; }

        [PetaPoco.Column("ActivityName")]
        public string ActivityName { get; set; }

        [PetaPoco.Column("ModuleCodeId")]
        public int ModuleCodeId { get; set; }

        [PetaPoco.Column("ControlName")]
        public string ControlName { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("StatusCodeId")]
        public int StatusCodeId { get; set; }

        [PetaPoco.Column("ControllerName")]
        public string ControllerName { get; set; }

        [PetaPoco.Column("ActionName")]
        public string ActionName { get; set; }

        [PetaPoco.Column("ActionButtonName")]
        public string ActionButtonName { get; set; }
    }
}
