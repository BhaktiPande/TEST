using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class PasswordConfigSL:IDisposable
    {
        #region GetPasswordConfigDetails
        /// <summary>
        /// This function will be used for validating if the given user is registered under the given company database.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public InsiderTradingDAL.PasswordConfigDTO GetPasswordConfigDetails(string i_sConnectionString)
        {
            InsiderTradingDAL.PasswordConfigDTO bReturn = null;
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.PasswordConfigDAL())
                {
                    bReturn = objUserInfoDAL.GetPasswordConfigDetails(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion ValidateUser

        #region SavePasswordConfigDetails
        /// <summary>
        /// This function will be used for validating if the given user is registered under the given company database.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public Boolean SavePasswordConfigDetails(string i_sConnectionString,InsiderTradingDAL.PasswordConfigDTO objPassConfigDTO)
        {
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objPassConfigDAL = new InsiderTradingDAL.PasswordConfigDAL())
                {
                    objPassConfigDAL.SavePasswordConfigDetails(i_sConnectionString, objPassConfigDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return true;
        }
        #endregion ValidateUser
        
        #region CheckPasswordHistory

        /// <summary>
        /// This method is used for the get user pwd Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="LoggedInId">LoggedInId</param>
        /// <returns>Object PasswordConfigDTO DTO</returns>

        public List<PasswordConfigDTO> CheckPasswordHistory(string i_sConnectionString, int i_sUserInfoId)
        {
            List<PasswordConfigDTO> lstUserPwdDetails = new List<PasswordConfigDTO>();

            try
            {
                using (var objPassConfigDAL = new InsiderTradingDAL.PasswordConfigDAL())
                {
                    lstUserPwdDetails = objPassConfigDAL.CheckPasswordHistory(i_sConnectionString,i_sUserInfoId).ToList<PasswordConfigDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserPwdDetails;
        }
        #endregion CheckPasswordHistory

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