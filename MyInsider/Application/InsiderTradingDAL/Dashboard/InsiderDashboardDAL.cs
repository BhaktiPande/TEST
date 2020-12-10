using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace InsiderTradingDAL
{
    public class InsiderDashboardDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";
        #region GetDashboardDetails
        public InsiderDashboardDTO GetDashboardDetails(string sConnectionString, int nLoggedInUserId)
        {
            InsiderDashboardDTO res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                    res = db.Query<InsiderDashboardDTO>("exec st_usr_InsiderDashBoard @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).FirstOrDefault<InsiderDashboardDTO>();

                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        return res;
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
        #endregion GetDashboardDetails

        #region GetPasswordExpiryReminder
        public PasswordExpiryReminderDTO GetPasswordExpiryReminder(string sConnectionString, int nUserId)
        {
            PasswordExpiryReminderDTO res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                    res = db.Query<PasswordExpiryReminderDTO>("exec st_cmu_PasswordExpiryReminder @inp_iUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iUserId = nUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).FirstOrDefault<PasswordExpiryReminderDTO>();

                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        return res;
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
        #endregion GetPasswordExpiryReminder

        #region GetDupTransCnt
        /// <summary>
        /// This function will return duplicate transaction records exists in System	
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<DupTransCntDTO> GetDupTransCnt(string i_sConnectionString, int i_UserInfoId)
        {
            PetaPoco.Database db = null;

            IEnumerable<DupTransCntDTO> lstDupTransCnt = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstDupTransCnt = db.Query<DupTransCntDTO>("exec st_tra_GetDupTransCnt @inp_iUserInfoId",
                         new
                         {
                             inp_iUserInfoId = i_UserInfoId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstDupTransCnt;
        }
        #endregion GetDupTransCnt

        #region GetTradingCalenderRuleDetails
        /// <summary>
        /// This function will return a user logged in details saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public InsiderDashboardDTO GetTradingCalenderDetails(string i_sConnectionString, int inp_userInfoID)
        {
            PetaPoco.Database db = null;

            InsiderDashboardDTO TradingCalenderDetails = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        TradingCalenderDetails = db.Query<InsiderDashboardDTO>("exec st_usr_CalenderRuleDetails @inp_userInfoID",
                         new
                         {
                             inp_userInfoID = inp_userInfoID

                         }).FirstOrDefault<InsiderDashboardDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return TradingCalenderDetails;
        }
        #endregion GetTradingCalenderRuleDetails

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
