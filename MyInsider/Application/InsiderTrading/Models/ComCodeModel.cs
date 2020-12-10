
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;

namespace InsiderTrading.Models
{
    public class ComCodeModel
    {
        [Required]
		public int? CodeID { get; set; }
        		
		[Required]	
		//[Display(Name = "Name")]
        [StringLength(512)]
        [LocalizedDisplayName("mst_lbl_10019")]
        [RegularExpression(Common.ConstEnum.DataValidation.DescriptionType, ErrorMessage = "mst_msg_50502")]
		public string CodeName { get; set; }

		[Required]		
		//[Display(Name = "Code Group")]
        [LocalizedDisplayName("mst_lbl_10021")]
		public string CodeGroupId { get; set; }

		
		//[Display(Name = "Description")]
        [StringLength(255)]
        [LocalizedDisplayName("mst_lbl_10024")]
        [RegularExpression(Common.ConstEnum.DataValidation.DescriptionType, ErrorMessage = "mst_msg_50503")]
		public string Description { get; set; }

		[Required]	
		//[Display(Name = "Is Visible")]
        [LocalizedDisplayName("mst_lbl_10023")]
		public bool IsVisible { get; set; }

        [Required]
        //[Display(Name = "Is Active")]
        [LocalizedDisplayName("mst_lbl_10022")]
        public bool IsActive { get; set; }
			
		[Display(Name = "display Order")]
        [RegularExpression(Common.ConstEnum.DataValidation.NumbersOnly, ErrorMessage = "mst_msg_50504")]
		public int? DisplayOrder { get; set; }
        		
		//[Display(Name = "Display Code")]
        [StringLength(1000)]
        [LocalizedDisplayName("mst_lbl_10020")]
        [RegularExpression(Common.ConstEnum.DataValidation.DescriptionType, ErrorMessage = "mst_msg_50502")]
		public string DisplayCode { get; set; }

        [Display(Name = "mst_lbl_10050")]       
		public int? ParentCodeId { get; set; }
        
    }
}
