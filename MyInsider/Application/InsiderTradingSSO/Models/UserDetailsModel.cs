using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace InsiderTradingSSO.Models
{
    public class UserDetailsModel
    {
        public int nUserId {get;set; }
       
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
        [Display(Name = "Select Company")]
        public string sCompanyName { get; set; }
        [Required]
        [DataType(DataType.Text)]
        [Display(Name = "Company Name")]
        public string stxtCompanyName { get; set; }
        public string sErrorMessage { get; set; }
        public string sCalledFrom { get; set; }

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
        public string NewPassword { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Confirm New Password")]
        [StringLength(100)]
        public string ConfirmNewPassword { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [DisplayName("Email ID")]
        [StringLength(100)]
        public string EmailID { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [DisplayName("Select Company")]
        [StringLength(100)]
        public string CompanyID { get; set; }

        [Required]
        [DisplayName("Login ID")]
        public string LoginID { get; set; }

        public int UserInfoID { get; set; }


        public string HashValue { get; set; }

    }
}