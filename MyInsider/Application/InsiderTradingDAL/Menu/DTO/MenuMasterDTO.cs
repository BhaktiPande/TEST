using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("mst_MenuMaster")]
    public class MenuMasterDTO
    {
        [PetaPoco.Column("ID")]
        public int MenuID { get; set; }

        [PetaPoco.Column("MENUDESC")]
        public string MenuDesc { get; set; }

        [PetaPoco.Column("MenuName")]
        public string MenuName { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("MenuURL")]
        public string MenuURL { get; set; }

        [PetaPoco.Column("DisplayOrder")]
        public int DisplayOrder { get; set; }

        [PetaPoco.Column("ParentMenuID")]
        public int ParentMenuID { get; set; }

        [PetaPoco.Column("Levels")]
        public int Levels { get; set; }

        [PetaPoco.Column("StatusCodeID")]
        public int StatusCodeID { get; set; }

        [PetaPoco.Column("ImageURL")]
        public string ImageURL { get; set; }

        [PetaPoco.Column("ToolTipText")]
        public string ToolTipText { get; set; }

        [PetaPoco.Column("ActivityID")]
        public int ActivityID { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }

        [PetaPoco.Column("ModifiedBy")]
        public int ModifiedBy { get; set; }

        [PetaPoco.Column("ModifiedOn")]
        public DateTime ModifiedOn { get; set; }
    }
}
