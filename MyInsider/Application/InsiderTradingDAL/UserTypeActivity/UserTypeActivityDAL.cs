using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{
    public class UserTypeActivityDAL:IDisposable
    {

        #region GetDetails
        public UserTypeActivityDTO GetDetails(UserTypeActivityDTO m_objUserTypeActivityDTO, string sConnectionString)
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
                    var res = db.Query<UserTypeActivityDTO>("exec st_usr_UserTypeActivityDetails @inp_iActivityId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iActivityId=m_objUserTypeActivityDTO.ActivityId,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<UserTypeActivityDTO>();   
                        
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
            catch(Exception exp)
            {
                 throw exp;
            }
            finally
            {

            }
            
        }
        #endregion GetDetails

        #region Save
        public UserTypeActivityDTO SaveDetails(UserTypeActivityDTO m_objUserTypeActivityDTO, string sConnectionString, int nLoggedInUserId)
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
                    var res = db.Query<UserTypeActivityDTO>("exec st_usr_UserTypeActivitySave @inp_iActivityId,@inp_iUserTypeCodeId,@inp_nUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iActivityId=m_objUserTypeActivityDTO.ActivityId,
		@inp_iUserTypeCodeId=m_objUserTypeActivityDTO.UserTypeCodeId,

                            @inp_nUserInfoId = nLoggedInUserId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).Single<UserTypeActivityDTO>();
                        
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
        #endregion Save

        #region Delete
        public bool Delete(UserTypeActivityDTO m_objUserTypeActivityDTO, string sConnectionString,int nLoggedInUserId)
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
                    var res = db.Query<UserTypeActivityDTO>("exec st_usr_UserTypeActivityDelete @inp_iActivityId,@inp_nUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            		@inp_iActivityId=m_objUserTypeActivityDTO.ActivityId,

                            @inp_nUserInfoId = nLoggedInUserId,
                            //@out_nReturnValue = nReturnValue,
                            //@out_nSQLErrCode = nSQLErrCode,
                            //@out_sSQLErrMessage = sSQLErrMessage

                        });

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
            catch(Exception exp)
            {
                throw exp;

            }
            finally
            {

            }
            return bReturn;
        }
        #endregion Delete

        #region GetList
        public IEnumerable<UserTypeActivityDTO> GetList(UserTypeActivityDTO m_objUserTypeActivityDTO, string sConnectionString)
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
                    var res = db.Query<UserTypeActivityDTO>("exec st_usr_UserTypeActivityList @inp_iActivityId,@inp_iUserTypeCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iActivityId=m_objUserTypeActivityDTO.ActivityId,
		@inp_iUserTypeCodeId=m_objUserTypeActivityDTO.UserTypeCodeId,

                            //@out_nReturnValue = nReturnValue,
                            //@out_nSQLErrCode = nSQLErrCode,
                            //@out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<UserTypeActivityDTO>();

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
            catch(Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }

        #endregion GetList

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
