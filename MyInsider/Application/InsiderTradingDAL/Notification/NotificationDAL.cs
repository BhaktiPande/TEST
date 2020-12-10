using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace InsiderTrading
{
    public class NotificationDAL:IDisposable
    {
        const string sLookUpPrefix = "";
         
        #region GetDetails
        public NotificationDTO GetDetails(string sConnectionString, int inp_iNotificationQueueId)
        {    
            #region Paramters
                int out_nReturnValue;
                int out_nSQLErrCode;        
                string out_sSQLErrMessage;
                NotificationDTO res= null;
            #endregion Paramters
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<NotificationDTO>("exec st_cmu_NotificationDetails @inp_iNotificationQueueId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iNotificationQueueId = inp_iNotificationQueueId,

                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).Single<NotificationDTO>();   
                        
                        #region Error Values
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookUpPrefix + out_nReturnValue;
                        e.Data[0] = sReturnValue;
                        if (nSQLErrCode.Value != System.DBNull.Value)
                        {
                            out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                            e.Data[1] = out_nSQLErrCode;
                        }
                        if (sSQLErrMessage.Value != System.DBNull.Value)
                        {
                            out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                            e.Data[2] = out_sSQLErrMessage;
                        }
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        scope.Complete();
                        return res;
                    }
                       #endregion Error Values
                    }
                }
            }
            catch(Exception exp)
            {
                 throw exp;
            }
            finally
            {

            }
            
        }
        #endregion GetDetails

        #region GetNotificationAlertList
        public List<NotificationDTO> GetNotificationAlertList(string sConnectionString, int inp_iLoggedInUserId, string sCalledFrom)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<NotificationDTO> res = null;
            #endregion Paramters
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<NotificationDTO>("exec st_cmu_NotificationAlertList @inp_nLoggedInUserId,@inp_sCalledFrom,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nLoggedInUserId = inp_iLoggedInUserId,
                            @inp_sCalledFrom = sCalledFrom,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).ToList<NotificationDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return res;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }

        }
        #endregion GetNotificationAlertList

        #region GetCompanyDetailsForNotification
        /// <summary>
        /// This method is used for the Get Company Details For Notification
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyId">Company ID</param>
        /// <param name="i_sCompanyDBName">Company database name for fetching the SMTP details for the corresponding company. 
        /// If Companyid is not given i.e. is 0 then this will be used for fetching the details.</param>
        /// <returns></returns>
        public IEnumerable<InsiderTradingDAL.CompanyDetailsForNotificationDTO> GetCompanyDetailsForNotification(string i_sConnectionString, int i_nCompanyId, string i_sCompanyDBName = "")
        {
            PetaPoco.Database db = null;
            IEnumerable<InsiderTradingDAL.CompanyDetailsForNotificationDTO> lstCompanyList = null;
            try
            {

                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyList = db.Query<InsiderTradingDAL.CompanyDetailsForNotificationDTO>("exec st_cmu_GetCompanyDetailsForNotification @inp_nCompanyId, @inp_sCompanyDBName,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_nCompanyId = i_nCompanyId,
                             inp_sCompanyDBName = i_sCompanyDBName,
                             out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstCompanyList;
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
            PetaPoco.Database db = null;
            IEnumerable<InsiderTradingDAL.CompanyIDListDTO> lstCompanyList = null;
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyList = db.Query<InsiderTradingDAL.CompanyIDListDTO>("exec st_cmu_GetCompanyIds @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstCompanyList;
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
            PetaPoco.Database db = null;
            IEnumerable<InsiderTradingDAL.NotificationSendListDTO> lstCompanyList = null;
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyList = db.Query<InsiderTradingDAL.NotificationSendListDTO>("exec st_cmu_GetNotificationSendList @inp_nCompanyId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_nCompanyId = i_nCompanyId,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstCompanyList;
        }
        #endregion GetNotificationSendList

        #region Update Notification Response
        /// <summary>
        /// This method is used for the Update Notification response
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nCompanyId"></param>
        /// <param name="i_tblNotificationResponseMessage"></param>
        /// <returns></returns>
        public bool UpdateNotificationResponse(string i_sConnectionString,int i_nCompanyId, DataTable i_tblNotificationResponseMessage)
        {
            PetaPoco.Database db = null;
            IEnumerable<InsiderTradingDAL.NotificationSendListDTO> lstCompanyList = null;
            bool bReturn = false;
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                var inp_tblNootification = new SqlParameter();
                inp_tblNootification.DbType = DbType.Object;
                inp_tblNootification.ParameterName = "@inp_tblNotificationQueueResponse";
                inp_tblNootification.TypeName = "dbo.NotificationQueueResponse";
                inp_tblNootification.SqlValue = i_tblNotificationResponseMessage;
                inp_tblNootification.SqlDbType = SqlDbType.Structured;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyList = db.Query<InsiderTradingDAL.NotificationSendListDTO>("exec st_cmu_UpdateNotificationResponse @inp_nCompanyId,@inp_tblNotificationQueueResponse,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_nCompanyId = i_nCompanyId,
                             inp_tblNotificationQueueResponse = inp_tblNootification,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
                bReturn = true;
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }
            return bReturn;
        }
        #endregion pdate Notification Response

        #region GetDashboardNotificationList
        public List<NotificationDTO> GetDashboardNotificationList(string sConnectionString, int inp_iLoggedInUserId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<NotificationDTO> res = null;
            #endregion Paramters
            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<NotificationDTO>("exec st_cmu_DashboardNotificationList @inp_nLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nLoggedInUserId = inp_iLoggedInUserId,                           
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).ToList<NotificationDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return res;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

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
