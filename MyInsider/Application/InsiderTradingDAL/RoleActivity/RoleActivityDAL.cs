using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class RoleActivityDAL:IDisposable
    {
        const String sLookupPrefix = "usr_msg_";

        #region GetDetails
        public List<RoleActivityDTO> GetDetails(string sConnectionString, int m_nRoleId)
        {    
            #region Paramters
                int out_nReturnValue;
                int out_nSQLErrCode;        
                string out_sSQLErrMessage;
                //bool bReturn = true;
            #endregion Paramters
            try
            {
                #region Out Paramter
                var nout_nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nout_nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nout_nReturnValue.Value = 0;
                var nout_nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nout_nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nout_nSQLErrCode.Value = 0;
                var sout_sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.NVarChar);
                sout_sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sout_sSQLErrMessage.Value = string.Empty;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    var res = db.Query<RoleActivityDTO>("exec st_usr_RoleActivityDetails @inp_iRoleId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iRoleId = m_nRoleId,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).ToList<RoleActivityDTO>();   
                        
                        #region Error Values
                        if (Convert.ToInt32(nout_nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nout_nReturnValue.Value);
                            string sReturnValue = sLookupPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
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
                            //bReturn = false;
                            Exception ex = new Exception(db.LastCommand.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            return res;
                        }
                        #endregion Error Values
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

        #region InsertDeleteRoleActivities
        public bool InsertDeleteRoleActivities(string sConnectionString, DataTable i_tblRoleActivity, int i_nLoggedInUserID)
        {   
            #region Paramters
                int out_nReturnValue;
                int out_nSQLErrCode;
                string out_sSQLErrMessage;
                bool bReturn = true;
            #endregion Paramters

            try
            {        
                #region Out Paramter
                var nout_nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nout_nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nout_nReturnValue.Value = 0;
                var nout_nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nout_nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nout_nSQLErrCode.Value = 0;
                var sout_sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.NVarChar);
                sout_sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sout_sSQLErrMessage.Size = 500;
                sout_sSQLErrMessage.Value = string.Empty;
                var inp_tblRoleActivityType = new SqlParameter();
                inp_tblRoleActivityType.DbType = DbType.Object;
                inp_tblRoleActivityType.ParameterName = "@inp_tblRoleActivityType";
                inp_tblRoleActivityType.TypeName = "dbo.RoleActivityType";
                inp_tblRoleActivityType.SqlValue = i_tblRoleActivity;
                inp_tblRoleActivityType.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<int>("exec st_usr_RoleActivitySaveDelete @inp_tblRoleActivityType,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_tblRoleActivityType = inp_tblRoleActivityType,
                            @inp_iLoggedInUserId = i_nLoggedInUserID,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).SingleOrDefault<int>();

                        #region Error Values
                        if (Convert.ToInt32(nout_nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nout_nReturnValue.Value);
                            string sReturnValue = sLookupPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return bReturn;
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
            //return bReturn;
        }
        #endregion InsertDeleteRoleActivities

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
