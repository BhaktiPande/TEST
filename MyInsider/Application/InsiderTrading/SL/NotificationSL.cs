using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace InsiderTrading.SL
{
    public class NotificationSL:IDisposable
    {

        #region GetNotificationAlertList
        /// <summary>
        /// This method is used for the get details for Template Master details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
        /// <returns></returns>
        public List<NotificationDTO> GetNotificationAlertList(string i_sConnectionString, int inp_iLoggedInUserId, string sCalledFrom)
        {
            try
            {
                using (var objNotificationDAL = new NotificationDAL())
                {
                    return objNotificationDAL.GetNotificationAlertList(i_sConnectionString, inp_iLoggedInUserId, sCalledFrom);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetNotificationAlertList

        #region GetDetails
        /// <summary>
        /// This method is used for the get details for Template Master details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
        /// <returns></returns>
        public NotificationDTO GetDetails(string i_sConnectionString, int i_nNotificationQueueId)
        {
            try
            {
                using (var objNotificationDAL = new NotificationDAL())
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

        #region GetCompanyDetailsForNotification
        /// <summary>
        /// This method is used for the Get Company Details For Notification
        /// </summary>
        /// <param name="i_sConnectionString">Master DB Connection string</param>
        /// <param name="i_nCompanyId">Company ID</param>
        /// <param name="i_sCompanyDBName">Company database name for fetching the SMTP details for the corresponding company. 
        /// If Companyid is not given i.e. is 0 then this will be used for fetching the details.</param>
        /// <returns></returns>
        public CompanyDetailsForNotificationDTO GetCompanyDetailsForNotification(string i_sConnectionString, int i_nCompanyId, string i_sCompanyDBName = "")
        {
            List<InsiderTradingDAL.CompanyDetailsForNotificationDTO> objCompanyDetailsForNotificationDTO = new List<CompanyDetailsForNotificationDTO>();
            //NotificationDAL objNotificationDAL = new NotificationDAL();
            try
            {
                using (var objNotificationDAL = new NotificationDAL())
                {
                    objCompanyDetailsForNotificationDTO = (List<InsiderTradingDAL.CompanyDetailsForNotificationDTO>)objNotificationDAL.GetCompanyDetailsForNotification(i_sConnectionString, i_nCompanyId, i_sCompanyDBName);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyDetailsForNotificationDTO.Count > 0?objCompanyDetailsForNotificationDTO[0]:null;
        }
        #endregion GetCompanyDetailsForNotification

        #region GetDashboardNotificationList
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
                using (var objNotificationDAL = new NotificationDAL())
                {
                    return objNotificationDAL.GetDashboardNotificationList(i_sConnectionString, inp_iLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDashboardNotificationList

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