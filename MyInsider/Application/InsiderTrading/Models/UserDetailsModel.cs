using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace InsiderTrading.Models
{
    public class UserDetailsModel
    {
        public int nUserId { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Login ID")]
        [StringLength(100, ErrorMessage = "Enter maximum 100 character")]
        public string sUserName { get; set; }
        public string sFirstName { get; set; }
        public string sLastName { get; set; }
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string sPassword { get; set; }
        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Company Name")]
        public string sCompanyName { get; set; }
        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Company Name")]
        public string stxtCompanyName { get; set; }
        public string sErrorMessage { get; set; }
        public string sCalledFrom { get; set; }

        [Required(ErrorMessage = "Please provide valid text")]
        public string sCaptchaText { get; set; }
    }

    public class PasswordManagementModel
    {
        [DataType(DataType.Text)]
        [DisplayName("Old Password")]
        [StringLength(100)]
        public string OldPassword { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("New Password")]
        [StringLength(100)]
        //[RegularExpression(ConstEnum.DataValidation.Password, ErrorMessage = "Minimum 1 Special character. Only (!,@,# $ % ^ & *) characters are allowed")]
        public string NewPassword { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Confirm New Password")]
        [StringLength(100)]
        //[RegularExpression(ConstEnum.DataValidation.Password, ErrorMessage = "Minimum 1 Special character. Only (!,@,# $ % ^ & *) characters are allowed")]
        public string ConfirmNewPassword { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [DisplayName("Email ID")]
        [StringLength(100)]
        public string EmailID { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [DisplayName("Company Name")]
        [StringLength(100)]
        public string CompanyID { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Company Name")]
        public string stxtCompanyName { get; set; }

        [Required]
        [DisplayName("Login ID")]
        public string LoginID { get; set; }

        public int UserInfoID { get; set; }


        public string HashValue { get; set; }
        public string SaltValue { get; set; }

        [Required(ErrorMessage = "Please provide valid text")]
        public string sCaptchaText { get; set; }

    }
}