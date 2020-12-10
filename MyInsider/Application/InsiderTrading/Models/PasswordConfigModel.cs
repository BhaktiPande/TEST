using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class PasswordConfigModel
    {
        public int PasswordConfigID { get; set; }

        [Required]
        [DisplayName("pc_lbl_50556")]
        [Range(0,99, ErrorMessage = "Please enter 2 digit number")]
        public int MinLength { get; set; }

        [Required]
        [DisplayName("pc_lbl_50557")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int MaxLength { get; set; }

        [Required]
        [DisplayName("pc_lbl_50558")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int MinAlphabets { get; set; }

        [Required]
        [DisplayName("pc_lbl_50559")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int MinNumbers { get; set; }

        [Required]
        [DisplayName("pc_lbl_50560")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int MinSplChar { get; set; }

        [Required]
        [DisplayName("pc_lbl_50561")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int MinUppercaseChar { get; set; }

        [Required]
        [DisplayName("pc_lbl_50562")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int CountOfPassHistory { get; set; }

        [Required]
        [DisplayName("pc_lbl_50563")]
        [Range(0, 999, ErrorMessage = "Please enter 3 digit number")]
        public int PassValidity { get; set; }

        [Required]
        [DisplayName("pc_lbl_50564")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int ExpiryReminder { get; set; }

        public DateTime LastUpdatedOn { get; set; }

        public string LastUpdatedBy { get; set; }

        [Required]
        [DisplayName("pc_lbl_50568")]
        [Range(0, 99, ErrorMessage = "Please enter 2 digit number")]
        public int LoginAttempts { get; set; }
        
    }
}