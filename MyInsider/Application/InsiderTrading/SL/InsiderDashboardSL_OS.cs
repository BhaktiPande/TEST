using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class InsiderDashboardSL_OS : IDisposable
    {
        #region GetDashboardDetails
        public InsiderDashboardDTO_OS GetDashboardDetails_OS(string i_sConnectionString, int nLoggedInUserId)
        {
            InsiderDashboardDTO_OS objInsiderDashboardDTO = new InsiderDashboardDTO_OS();
            try
            {
                using (var InsiderDashboardDAL_OS = new InsiderDashboardDAL_OS())
                {
                    objInsiderDashboardDTO = InsiderDashboardDAL_OS.GetDashboardDetails_OS(i_sConnectionString, nLoggedInUserId);
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
        public PasswordExpiryReminderDTO GetPasswordExpiryReminder(string i_sConnectionString,int nUserId)
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