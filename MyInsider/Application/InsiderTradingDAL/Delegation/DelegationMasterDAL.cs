using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class DelegationMasterDAL:IDisposable
    {
        const String sLookupPrefix = "usr_msg_";

        #region GetDetails
        public DelegationMasterDTO GetDetails(DelegationMasterDTO m_objDelegationMasterDTO, string sConnectionString)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                    var res = db.Query<DelegationMasterDTO>("exec st_usr_DelegationMasterDetails @inp_nDelegationMasterDetailsID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nDelegationMasterDetailsID = m_objDelegationMasterDTO.DelegationId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).SingleOrDefault<DelegationMasterDTO>();

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
            catch (Exception exp)
            {
                throw exp;
            }


        }
        #endregion GetDetails

        #region GetDelegationActivityDetails
        public List<RoleActivityDTO> GetDelegationActivityDetails(string sConnectionString, int m_nDelegationID, int m_nUserInfoIdFrom, int m_nUserInfoIdTo)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            
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
                    var res = db.Query<RoleActivityDTO>("exec st_usr_DelegationActivityDetails @inp_nDelegationMasterID, @inp_nUserInfoIdFrom, @inp_nUserInfoIdTo, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nDelegationMasterID = m_nDelegationID,
                            @inp_nUserInfoIdFrom = m_nUserInfoIdFrom,
                            @inp_nUserInfoIdTo = m_nUserInfoIdTo,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).ToList<RoleActivityDTO>();

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
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion GetDelegationActivityDetails

        #region DelegationDetailsSaveDelete
        public bool DelegationDetailsSaveDelete(string sConnectionString, DataTable i_tblDelegationDetails, int i_nLoggedInUserID)
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
                sout_sSQLErrMessage.Value = string.Empty;
                var inp_tblDelegationDetailsType = new SqlParameter();
                inp_tblDelegationDetailsType.DbType = DbType.Object;
                inp_tblDelegationDetailsType.ParameterName = "@inp_tblDelegationDetailsType";
                inp_tblDelegationDetailsType.TypeName = "dbo.RoleActivityType";
                inp_tblDelegationDetailsType.SqlValue = i_tblDelegationDetails;
                inp_tblDelegationDetailsType.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<int>("exec st_usr_DelegationDetailsSaveDelete @inp_tblDelegationDetailsType,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_tblDelegationDetailsType = inp_tblDelegationDetailsType,
                            @inp_iLoggedInUserId = i_nLoggedInUserID,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).Single<int>();

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
                            Exception ex = new Exception(db.LastCommand.ToString(), e);
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
        #endregion DelegationDetailsSaveDelete


        #region Save
        public DelegationMasterDTO SaveDetails(DelegationMasterDTO m_objDelegationMasterDTO, int m_nPartialSave, string sConnectionString, int nLoggedInUserId)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                    var res = db.Query<DelegationMasterDTO>("exec st_usr_DelegationMasterSave @inp_sDelegationId,@inp_iUserInfoIdFrom,@inp_iUserInfoIdTo,@inp_dtDelegationFrom,@inp_dtDelegationTo,@inp_nPartialSave,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_sDelegationId = m_objDelegationMasterDTO.DelegationId,
                            @inp_dtDelegationFrom = m_objDelegationMasterDTO.DelegationFrom,
                            @inp_dtDelegationTo = m_objDelegationMasterDTO.DelegationTo,
                            @inp_iUserInfoIdFrom = m_objDelegationMasterDTO.UserInfoIdFrom,
                            @inp_iUserInfoIdTo = m_objDelegationMasterDTO.UserInfoIdTo,
                            @inp_nPartialSave = m_nPartialSave,

                            @inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).SingleOrDefault<DelegationMasterDTO>();

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
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Save

        #region Delete
        public bool Delete(int m_nDelegationMasterId, string sConnectionString, int nLoggedInUserId)
        {
            #region Paramters
            bool bReturn;
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
                    var res = db.Query<DelegationMasterDTO>("exec st_usr_DelegationMasterDelete @inp_nDelegationId, @inp_nLoggedInUserId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_nDelegationId = m_nDelegationMasterId,

                            inp_nLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<DelegationMasterDTO>();

                    #region Error Values
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
        #endregion Delete

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
