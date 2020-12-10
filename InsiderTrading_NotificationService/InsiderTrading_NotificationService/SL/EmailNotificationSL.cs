using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
    public class EmailNotificationSL
    {
        #region GetCompanyDetailsForNotification
        /// <summary>
        /// This method is used for the Get Company Details For Notification
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyId">Company ID</param>
        /// <returns></returns>
        public IEnumerable<InsiderTradingDAL.CompanyDetailsForNotificationDTO> GetCompanyDetailsForNotification(string i_sConnectionString, int i_nCompanyId)
        {
            try
            {
                return new InsiderTrading.NotificationDAL().GetCompanyDetailsForNotification(i_sConnectionString, i_nCompanyId);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetCompanyDetailsForNotification

        #region GetCompanyIds
        /// <summary>
        /// This method is used for the Get Company ID's List
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyId">Company ID</param>
        /// <returns></returns>
        public IEnumerable<InsiderTradingDAL.CompanyIDListDTO> GetCompanyIds(string i_sConnectionString)
        {
            try
            {
                return new InsiderTrading.NotificationDAL().GetCompanyIds(i_sConnectionString);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
         #endregion GetCompanyIds

        #region GetNotificationSendList
        /// <summary>
        /// This method is used for the Get Notification queue list.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyId">Company ID</param>
        /// <returns></returns>
        public IEnumerable<InsiderTradingDAL.NotificationSendListDTO> GetNotificationSendList(string i_sConnectionString, int i_nCompanyId)
        {
            try
            {
                return new InsiderTrading.NotificationDAL().GetNotificationSendList(i_sConnectionString, i_nCompanyId);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
          #endregion GetNotificationSendList

        #region UpdateNotificationResponse
        /// <summary>
        /// This method is used for the Update Notification response
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nCompanyId"></param>
        /// <param name="i_tblNotificationResponseMessage"></param>
        /// <returns></returns>
        public bool UpdateNotificationResponse(string i_sConnectionString, int i_nCompanyId, DataTable i_tblNotificationResponseMessage)
        {
            try
            {
                return new InsiderTrading.NotificationDAL().UpdateNotificationResponse(i_sConnectionString, i_nCompanyId, i_tblNotificationResponseMessage);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion UpdateNotificationResponse
    }
}
