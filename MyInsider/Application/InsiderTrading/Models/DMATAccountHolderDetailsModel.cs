using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class DMATAccountHolderDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATAccountHolderId { get; set; }

        public int? DMATDetailsID { get; set; }

        [StringLength(500)]
        [Required]
        [DisplayName("usr_lbl_11223")]
        public string AccountHolderName { get; set; }

        [StringLength(400)]
        [Required]
        [DisplayName("usr_lbl_11224")]
        [RegularExpression("[A-Z]{5}\\d{4}[A-Z]{1}", ErrorMessage = "usr_msg_11217")]
        public string PAN { get; set; }

        [Required]
        [DisplayName("usr_lbl_11225")]
        public int RelationTypeCodeId { get; set; }
    }

    public class Corporate_DMATAccountHolderDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATAccountHolderId { get; set; }

        public int? DMATDetailsID { get; set; }

        [StringLength(500)]
        [Required]
        [DisplayName("usr_lbl_11313")]
        public string AccountHolderName { get; set; }

        [StringLength(400)]
        [Required]
        [DisplayName("usr_lbl_11314")]
        [RegularExpression("[A-Z]{5}\\d{4}[A-Z]{1}", ErrorMessage = "usr_msg_11384")]
        public string PAN { get; set; }

        [Required]
        [DisplayName("usr_lbl_11315")]
        public int RelationTypeCodeId { get; set; }
    }

    public class Relative_DMATAccountHolderDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATAccountHolderId { get; set; }

        public int? DMATDetailsID { get; set; }

        [StringLength(500)]
        [Required]
        [DisplayName("usr_lbl_11375")]
        public string AccountHolderName { get; set; }

        [StringLength(400)]
        [Required]
        [DisplayName("usr_lbl_11376")]
        [RegularExpression("[A-Z]{5}\\d{4}[A-Z]{1}", ErrorMessage = "usr_msg_11385")]
        public string PAN { get; set; }

        [Required]
        [DisplayName("usr_lbl_11377")]
        public int RelationTypeCodeId { get; set; }
    }
}