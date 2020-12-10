using InsiderTradingDAL.TwoFactorAuth;
using InsiderTradingDAL.TwoFactorAuth.DTO;
using System;
using System.Collections.Generic;
using System.Linq;

namespace InsiderTrading.SL
{
    public class TwoFactorAuthSL : IDisposable
    {
        public bool CheckIsOTPActived(string i_sConnectionString, string LoggedInId)
        {
            bool bReturn = false;
            try
            {
                using (TwoFactorAuthDAL objOTPAuthDAL = new TwoFactorAuthDAL())
                {
                    bReturn = objOTPAuthDAL.CheckIsOTPActived(i_sConnectionString, LoggedInId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        public List<OTPConfigurationDTO> GetOTPConfiguration(string i_sConnectionString)
        {
            List<OTPConfigurationDTO> lstUserLoginDetails = new List<OTPConfigurationDTO>();

            try
            {
                using (TwoFactorAuthDAL objOTPAuthDAL = new TwoFactorAuthDAL())
                {
                    lstUserLoginDetails = objOTPAuthDAL.GetOTPConfiguration(i_sConnectionString).ToList();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserLoginDetails;
        }

        public List<OTPConfigurationDTO> GetUserDeatailsForOTP(string i_sConnectionString, string userLoginId)
        {
            List<OTPConfigurationDTO> lstUserLoginDetails = new List<OTPConfigurationDTO>();

            try
            {
                using (TwoFactorAuthDAL objOTPAuthDAL = new TwoFactorAuthDAL())
                {
                    lstUserLoginDetails = objOTPAuthDAL.GetUserDeatailsForOTP(i_sConnectionString, userLoginId).ToList();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserLoginDetails;
        }
        public Boolean SaveOTPDetails(string i_sConnectionString, int OTPConfigMasterId, int i_nUserInfo, string EmailID, string OTPCode, int OTPExpirationTime)
        {
            try
            {
                using (TwoFactorAuthDAL objSaveOTPAuthDAL = new TwoFactorAuthDAL())
                {
                    objSaveOTPAuthDAL.SaveOTPDetails(i_sConnectionString, OTPConfigMasterId, i_nUserInfo, EmailID, OTPCode, OTPExpirationTime);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return true;
        }

        public int ValidateOTPDetails(string i_sConnectionString, int OTPConfigMasterId, int i_nUserInfo, string OTPCode)
        {
            int ret_result = 0;
            try
            {
                using (TwoFactorAuthDAL objSaveOTPAuthDAL = new TwoFactorAuthDAL())
                {
                    ret_result = objSaveOTPAuthDAL.ValidateOTPDetails(i_sConnectionString, OTPConfigMasterId, i_nUserInfo, OTPCode);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return ret_result;
        }

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }

        #endregion
    }
}