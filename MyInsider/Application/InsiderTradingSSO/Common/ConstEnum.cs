namespace InsiderTradingSSO.Common
{
    public class ConstEnum
    {
        #region SessionValue
        /// <summary>
        /// This class is used to define session variables
        /// </summary>
        public class SessionValue
        {
            public const string UserDetails = "UserDetails";

            public const string SessionValidationKey = "SessionValidationKey";

            public const string CookiesValidationKey = "CookiesValidationKey";
            
        }

        public const string User_Password_Encryption_Key = "99-102-245-9-16-230-97-24-80-31-38-64-146-69-177-4-98-105-64-153-1-215-64-056-103-130-168-64-242-133";

        public const string s_SSO = "~{0}~IT~POWEREDBYESOPDIRECT~SSOLOGIN~IT~{0}~";

        #endregion SessionValue

        #region Client Database Name
        public const string CLIENT_DB_NAME = "Vigilante_Axisbank";
        #endregion Client Database Name

        /// <summary>
        /// This is used when encrypting / decrypting the user name and password in javascript
        /// </summary>
        public const string Javascript_Encryption_Key = "8080808080808080";
    }
}