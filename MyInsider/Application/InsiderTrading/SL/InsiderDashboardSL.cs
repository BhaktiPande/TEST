using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;

namespace InsiderTrading.SL
{
    public class InsiderDashboardSL : IDisposable
    {
        #region GetDashboardDetails
        public InsiderDashboardDTO GetDashboardDetails(string i_sConnectionString, int nLoggedInUserId)
        {
            InsiderDashboardDTO objInsiderDashboardDTO = new InsiderDashboardDTO();
            try
            {
                //InsiderDashboardDAL objInsiderDashboardDAL = new InsiderDashboardDAL();
                using (var objInsiderDashboardDAL = new InsiderDashboardDAL())
                {
                    objInsiderDashboardDTO = objInsiderDashboardDAL.GetDashboardDetails(i_sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objInsiderDashboardDTO;
        }
        #endregion GetDashboardDetails

        #region GetPasswordExpiryReminder
        public PasswordExpiryReminderDTO GetPasswordExpiryReminder(string i_sConnectionString, int nUserId)
        {
            PasswordExpiryReminderDTO objPasswordExpiryReminderDTO = new PasswordExpiryReminderDTO();
            try
            {
                //InsiderDashboardDAL objInsiderDashboardDAL = new InsiderDashboardDAL();
                using (var objInsiderDashboardDAL = new InsiderDashboardDAL())
                {
                    objPasswordExpiryReminderDTO = objInsiderDashboardDAL.GetPasswordExpiryReminder(i_sConnectionString, nUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objPasswordExpiryReminderDTO;
        }
        #endregion GetPasswordExpiryReminder

        #region Get_DupTransCnt       
        /// <summary>
        /// This function will return duplicate transaction records exists in System
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_UserInfoId">UserInfo ID</param>
        /// <returns>Object InsiderDashboard DTO</returns>

        public List<DupTransCntDTO> Get_DupTransCnt(string i_sConnectionString, int i_UserInfoId)
        {
            List<DupTransCntDTO> lstDupTransCnt = new List<DupTransCntDTO>();

            try
            {
                using (var objInsiderDashboardDAL = new InsiderDashboardDAL())
                {
                    lstDupTransCnt = objInsiderDashboardDAL.GetDupTransCnt(i_sConnectionString, i_UserInfoId).ToList<DupTransCntDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstDupTransCnt;
        }
        #endregion Get_DupTransCnt

        #region GetRuleDetails
        public InsiderDashboardDTO GetTradingCalenderDetails(string i_sConnectionString, int nLoggedInUserId)
        {
            InsiderDashboardDTO objInsiderDashboardDTO = new InsiderDashboardDTO();
            try
            {
                //InsiderDashboardDAL objInsiderDashboardDAL = new InsiderDashboardDAL();
                using (var objInsiderDashboardDAL = new InsiderDashboardDAL())
                {
                    objInsiderDashboardDTO = objInsiderDashboardDAL.GetTradingCalenderDetails(i_sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objInsiderDashboardDTO;
        }
        #endregion GetRuleDetails

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