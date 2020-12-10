using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace InsiderTrading.Models
{
    public class TwoFactorAuthModel
    {
        [DefaultValue(0)]
        public int UserInfoId { get; set; }

        public string EmailId { get; set; }

        [Required(ErrorMessage = "The OTP field is required")]
        public string OTPCode { get; set; }

        public int? IsValidated { get; set; }
    }
}