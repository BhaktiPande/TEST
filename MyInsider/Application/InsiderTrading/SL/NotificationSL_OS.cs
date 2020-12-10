using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace InsiderTrading.SL
{
    public class NotificationSL_OS:IDisposable
    {

        #region GetDetails
        /// <summary>
        /// This method is used for the get details for Template Master details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
        /// <returns></returns>
        public NotificationDTO GetDetails_OS(string i_sConnectionString, int i_nNotificationQueueId)
        {
            try
            {
                using (var objNotificationDAL = new NotificationDAL_OS())
                {
                    return objNotificationDAL.GetDetails(i_sConnectionString, i_nNotificationQueueId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDetails
        #region GetDashboardNotificationList_OS
        /// <summary>
        /// This method is used for the get details for User notification.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="inp_iLoggedInUserId"> LoggedIn User ID</param>
        /// <returns></returns>
        public List<NotificationDTO> GetDashboardNotificationList(string i_sConnectionString, int inp_iLoggedInUserId)
        {
            try
            {
                using (var objNotificationDAL = new NotificationDAL_OS())
                {
                    return objNotificationDAL.GetDashboardNotificationList_OS(i_sConnectionString, inp_iLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDashboardNotificationList_OS

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