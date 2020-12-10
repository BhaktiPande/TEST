using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CODashboardDAL:IDisposable
    {
        const String sLookupPrefix = "tra_msg_";
        #region GetDashboardDetails
        public CODashboardDTO GetDashboardDetails(string sConnectionString, int nLoggedInUserId)
        {
            CODashboardDTO res = null;
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
                    res = db.Query<CODashboardDTO>("exec st_tra_DashBoardForCO @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                          //  inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).FirstOrDefault<CODashboardDTO>();

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

        #region Update Status
        public bool UpdateStatus(string sConnectionString, int nLoggedInUserId, int nDashboardId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool bReturn = true;
            int res;
            #endregion Paramters
            try
            {
                #region Out Paramter
                var nout_nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nout_nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nout_nReturnValue.Value = 0;
                var nout_nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nout_nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nout_nSQLErrCode.Value = 0;
                var sout_sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.NVarChar);
                sout_sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sout_sSQLErrMessage.Value = string.Empty;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<int>("exec st_tra_DashBoardForCOUpdate @inp_nDashboardCountId,@inp_nLoggedInUserId ,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nDashboardCountId = nDashboardId,
                            @inp_nLoggedInUserId = nLoggedInUserId,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage

                        }).Single<int>();

                    #region Error Values
                    if (Convert.ToInt32(nout_nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nout_nReturnValue.Value);
                        e.Data[0] = out_nReturnValue;
                        if (nout_nSQLErrCode.Value != System.DBNull.Value)
                        {
                            out_nSQLErrCode = Convert.ToInt32(nout_nSQLErrCode.Value);
                            e.Data[1] = out_nSQLErrCode;
                        }
                        if (sout_sSQLErrMessage.Value != System.DBNull.Value)
                        {
                            out_sSQLErrMessage = Convert.ToString(sout_sSQLErrMessage.Value);
                            e.Data[2] = out_sSQLErrMessage;
                        }
                        bReturn = false;
                        Exception ex = new Exception(db.LastCommand.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        bReturn = true;
                    }
                    #endregion Error Values

                }
            }
            catch (Exception exp)
            {
                throw exp;

            }
            finally
            {

            }
            return bReturn;
        }
        #endregion Update Status

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
