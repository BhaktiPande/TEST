
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading.Models
{
    public class RoleMasterModel
    {
       	[ScaffoldColumn(false)]
		[Required(ErrorMessage = "XXXX")]
		public int RoleId { get; set; }

		[StringLength(200)]
        [Required]
		[DataType(DataType.Text)]
        [DisplayName("usr_lbl_12038")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50492")]
		public string RoleName { get; set; }

		[StringLength(510)]
		[DataType(DataType.Text)]
        [DisplayName("usr_lbl_12039")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50493")]
		public string Description { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50494")]
        [DisplayName("usr_lbl_12040")]
		public int? StatusCodeId { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50495")]
        [DisplayName("usr_lbl_12041")]
		public int? UserTypeCodeId { get; set; }

        [DisplayName("usr_lbl_12042")]
        public bool IsDefault { get; set; }
        
    }
}
