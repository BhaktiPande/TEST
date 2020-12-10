
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;

namespace InsiderTrading.Models
{
    public class ActivityModel
    {
        [LocalizedDisplayName("usr_lbl_11009")]
		[Display(Name = "XXXX")]
		public int? ActivityID { get; set; }

		[StringLength(200, ErrorMessage = "XXXX")]
        [LocalizedDisplayName("usr_lbl_11009")]
		[DataType(DataType.Text)]
		[Display(Name = "XXXX")]
		public string ScreenName { get; set; }

		[StringLength(200, ErrorMessage = "XXXX")]
		[Required(ErrorMessage = "XXXX")]
		[DataType(DataType.Text)]
		[Display(Name = "XXXX")]
		public string ActivityName { get; set; }

		[Required(ErrorMessage = "XXXX")]
		[Display(Name = "XXXX")]
		public int? ModuleCodeID { get; set; }

		[StringLength(200, ErrorMessage = "XXXX")]
		[DataType(DataType.Text)]
		[Display(Name = "XXXX")]
		public string ControlName { get; set; }

		[StringLength(1024, ErrorMessage = "XXXX")]
		[DataType(DataType.Text)]
		[Display(Name = "XXXX")]
		public string Description { get; set; }

		[Required(ErrorMessage = "XXXX")]
		[DataType(DataType.Text)]
		[Display(Name = "XXXX")]
		public int? StatusCodeID { get; set; }


 
    }
}
