
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("com_Code")]
    public class ComCodeDTO
    {	
        [PetaPoco.Column("CodeID")]
		public int? CodeID { get; set; }

		[PetaPoco.Column("CodeName")]
		public string CodeName { get; set; }

		[PetaPoco.Column("CodeGroupId")]
		public string CodeGroupId { get; set; }

		[PetaPoco.Column("Description")]
		public string Description { get; set; }

		[PetaPoco.Column("IsVisible")]
		public bool IsVisible { get; set; }

        [PetaPoco.Column("IsActive")]
        public bool IsActive { get; set; }

		[PetaPoco.Column("DisplayOrder")]
		public int? DisplayOrder { get; set; }

		[PetaPoco.Column("DisplayCode")]
		public string DisplayCode { get; set; }

		[PetaPoco.Column("ParentCodeId")]
		public int? ParentCodeId { get; set; }

        public int LoggedInUserId { get; set; }

	      
    }
}
