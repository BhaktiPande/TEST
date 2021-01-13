using InsiderTradingDAL;
using System;
using System.Collections;

namespace InsiderTradingSSO.SL
{
    public class SSOSL : IDisposable
    {
        #region LoginSSOUserInfo
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>        
        public UserInfoDTO LoginSSOUserInfo(string i_sConnectionString, Hashtable ht_Parameter)
        {
            UserInfoDTO res = null;

            try
            {
                UserInfoDAL objUserInfoDAL = new UserInfoDAL();
                res = objUserInfoDAL.LoginSSOUserInfo(i_sConnectionString, ht_Parameter); 
                
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion LoginSSOUserInfo

        #region Get Selected Companies
        public InsiderTradingDAL.CompanyDTO getSingleCompanies(string i_sConnectionString, string i_sCompanyDatabaseName)
        {
            InsiderTradingDAL.CompanyDTO objCompaniesList = new InsiderTradingDAL.CompanyDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompaniesList = objCompanyDAL.GetSingleCompanyDetails(i_sConnectionString, i_sCompanyDatabaseName);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompaniesList;
        }
        #endregion Get Selected Companies

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