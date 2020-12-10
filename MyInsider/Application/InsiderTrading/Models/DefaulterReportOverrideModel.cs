using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class DefaulterReportOverrideModel
    {
        [Required]
        [DisplayName("rpt_lbl_19268")]
        public bool IsRemovedFromNonCompliance { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("rpt_lbl_19269")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rpt_msg_50521")]
        public string Reason { get; set; }

        public long? DefaulterReportID { get; set; }

        public List<DocumentDetailsModel> OverrideUpload { get; set; }
    }
}