using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class SecurityTransferLogModel
    {
        public long SecurityTransaferID { get; set; }

        [Required]
        [DisplayName("UserInfoId")]
        public int UserInfoId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11446")]
        public int ForUserInfoId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11450")]
        public int FromDEMATAcountID { get; set; }

        [Required]
        [DisplayName("usr_lbl_11449")]
        public int SecurityTypeCodeID { get; set; }

        [Required]
        [DisplayName("usr_lbl_11451")]
        public int ToDEMATAcountID { get; set; }


        [DisplayName("usr_lbl_11452")]
     //   [Range(1, Double.MaxValue, ErrorMessage = "Please enter transfer quantity greater than zero.")]
        public Decimal? TransferQuantity { get; set; }


        [DisplayName("usr_lbl_50653")]
        public Decimal? TransferESOPQuantity { get; set; }

        [Required]
        [DisplayName("TransferFor")]
        public int TransferFor { get; set; }

        [Required]
        [DisplayName("SecurityTransferOption")]
        public int SecurityTransferOption { get; set; }
    }
}