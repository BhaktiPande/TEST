
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace InsiderTrading.Models
{
    public class DocumentDetailsModel
    {
        public int? DocumentId { get; set; }

		public string GUID { get; set; }

		[StringLength(400)]
		[Required]
        [DisplayName("usr_lbl_11210")]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50525")]
		public string DocumentName { get; set; }

		[StringLength(1024)]
        [DisplayName("usr_lbl_11211")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50526")]
		public string Description { get; set; }

		public string DocumentPath { get; set; }

        public Int64 FileSize { get; set; }

		public string FileType { get; set; }

        public int MapToTypeCodeId { get; set; }

        public int MapToId { get; set; }

        public int? PurposeCodeId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11212")]
        public HttpPostedFileBase Document { get; set; }

        public int Index { get; set; }

        public int SubIndex { get; set; }

        public bool HideRow { get; set; }

        public bool HasAddNewOption { get; set; }
    }
}
