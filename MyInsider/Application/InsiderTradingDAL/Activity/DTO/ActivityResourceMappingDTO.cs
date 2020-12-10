using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_ActivityResourceMapping")]
    public class ActivityResourceMappingDTO
    {
        [PetaPoco.Column("ActivityId")]
        public int ActivityId { get; set; }

        [PetaPoco.Column("ResourceKey")]
        public string ResourceKey { get; set; }

        [PetaPoco.Column("EditFlag")]
        public int EditFlag { get; set; }

        [PetaPoco.Column("MandatoryFlag")]
        public int MandatoryFlag { get; set; }

        [PetaPoco.Column("ColumnName")]
        public string ColumnName { get; set; }

        [PetaPoco.Column("IsForRelative")]
        public int IsForRelative { get; set; }
    }
}

