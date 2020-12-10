namespace InsiderTradingDAL.TwoFactorAuth.DTO
{
    [PetaPoco.TableName("UserLoginOTPDetails")]
    public class TwoFactorAuthDTO
    {
        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("EmailID")]
        public string EmailID { get; set; }

        [PetaPoco.Column("OTPCode")]
        public string OTPCode { get; set; }


    }
    public class OTPConfigurationDTO
    {
        [PetaPoco.Column("OTPConfigurationSettingMasterID")]
        public int OTPConfigurationSettingMasterID { get; set; }

        [PetaPoco.Column("OTPExpirationTimeInSeconds")]
        public int OTPExpirationTimeInSeconds { get; set; }

        [PetaPoco.Column("OTPDigits")]
        public int OTPDigits { get; set; }

        [PetaPoco.Column("AttemptAllowed")]
        public int AttemptAllowed { get; set; }

        [PetaPoco.Column("IsOTPResendButtonEnable")]
        public bool IsOTPResendButtonEnable { get; set; }

        [PetaPoco.Column("IsAlphaNumeric")]
        public bool IsAlphaNumeric { get; set; }

        [PetaPoco.Column("IsActive")]
        public bool IsActive { get; set; }

        public int UserInfoId { get; set; }

        public string EmailID { get; set; }
        public string FullName { get; set; }

    }
}
