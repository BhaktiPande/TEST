using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("mst_Resource")]
    public class ResourcesDTO
    {
        //[PetaPoco.Column("ResourceKey")]
        //public string sResourceKey { get; set; }
        //[PetaPoco.Column("ResourceValue")]
        //public string sResourceMessage { get; set; }

        [PetaPoco.Column("ResourceId")]
        public int? ResourceId { get; set; }

        [PetaPoco.Column("ResourceKey")]
        public string ResourceKey { get; set; }

        [PetaPoco.Column("ResourceValue")]
        public string ResourceValue { get; set; }

        [PetaPoco.Column("ResourceCulture")]
        public string ResourceCulture { get; set; }

        [PetaPoco.Column("ModuleCodeId")]
        public int? ModuleCodeId { get; set; }

        [PetaPoco.Column("CategoryCodeId")]
        public int? CategoryCodeId { get; set; }

        [PetaPoco.Column("ScreenCodeId")]
        public int? ScreenCodeId { get; set; }

        [PetaPoco.Column("OriginalResourceValue")]
        public string OriginalResourceValue { get; set; }

        [PetaPoco.Column("ModuleCodeName")]
        public string ModuleCodeName { get; set; }

        [PetaPoco.Column("CategoryCodeName")]
        public string CategoryCodeName { get; set; }

        [PetaPoco.Column("ScreenName")]
        public string ScreenName { get; set; }

        [PetaPoco.Column("GridTypeCodeId")]
        public int? GridTypeCodeId { get; set; }

        [PetaPoco.Column("GridHeaderListName")]
        public string GridHeaderListName { get; set; }

       [PetaPoco.Column("IsVisible")]
       public bool IsVisible { get; set; }

        [PetaPoco.Column("SequenceNumber")]
        public int? SequenceNumber { get; set; }

        [PetaPoco.Column("ColumnWidth")]
        public int? ColumnWidth { get; set; }

        [PetaPoco.Column("ColumnAlignment")]
        public int? ColumnAlignment { get; set; }

        public int LoggedInUserId { get; set; }
    }
}
