using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class TransactionLetterModel
    {
        public Int64 TransactionLetterId { get; set; }

        public int DisclosureTypeCodeId { get; set; }

        public Int64 TransactionMasterId { get; set; }

        public int LetterForCodeId { get; set; }

        public int CommunicationModeCodeId { get; set; }

        [Required]
        [DisplayName("dis_lbl_17105")]
        public DateTime Date { get; set; }

        [Required]
        [StringLength(250)]
        
        [DisplayName("dis_lbl_17106")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50505")]
        public string ToAddress1 { get; set; }

        [Required]
        [StringLength(250)]
        [DisplayName("dis_lbl_17107")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50505")]
        public string ToAddress2 { get; set; }

        [Required]
        [StringLength(150)]
        [DisplayName("dis_lbl_17108")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50505")]
        public string Subject { get; set; }

        [Required]
        [StringLength(2000)]
        [DisplayName("dis_lbl_17109")]
        //[RegularExpression(ConstEnum.DataValidation.LetterContent, ErrorMessage = "tra_msg_50531")]
        public string Contents { get; set; }

        [Required]
        [StringLength(200)]
        [DisplayName("dis_lbl_17110")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50505")]
        public string Signature { get; set; }

        public bool IsActive { get; set; }

        [DisplayName("dis_lbl_17104")]
        public string CompanyLogo { get; set; }

        public string CommunicationFrom { get; set; }

        public int WarningMessage { get; set; }

        public string LetterForUserDesignation { get; set; }
    }
}