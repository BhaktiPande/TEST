using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{
    public class UserRoleDAL:IDisposable
    {

        #region GetDetails
        public UserRoleDTO GetDetails(UserRoleDTO m_objUserRoleDTO, string sConnectionString)
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
                    var res = db.Query<UserRoleDTO>("exec st_usr_UserRoleDetails @inp_iUserRoleID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iUserRoleID=m_objUserRoleDTO.UserRoleID,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<UserRoleDTO>();   
                        
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
        public UserRoleDTO SaveDetails(UserRoleDTO m_objUserRoleDTO, string sConnectionString, int nLoggedInUserId)
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
                    var res = db.Query<UserRoleDTO>("exec st_usr_UserRoleSave @inp_iUserRoleID,@inp_iUserInfoID,@inp_iRoleID,@inp_nUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iUserRoleID=m_objUserRoleDTO.UserRoleID,
		@inp_iUserInfoID=m_objUserRoleDTO.UserInfoID,
		@inp_iRoleID=m_objUserRoleDTO.RoleID,

                            @inp_nUserInfoId = nLoggedInUserId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).Single<UserRoleDTO>();
                        
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
        public bool Delete(UserRoleDTO m_objUserRoleDTO, string sConnectionString,int nLoggedInUserId)
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
                    var res = db.Query<UserRoleDTO>("exec st_usr_UserRoleDelete @inp_iUserRoleID,@inp_nUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            		@inp_iUserRoleID=m_objUserRoleDTO.UserRoleID,

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
        public IEnumerable<UserRoleDTO> GetList(UserRoleDTO m_objUserRoleDTO, string sConnectionString)
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
                    var res = db.Query<UserRoleDTO>("exec st_usr_UserRoleList @inp_iUserRoleID,@inp_iUserInfoID,@inp_iRoleID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           		@inp_iUserRoleID=m_objUserRoleDTO.UserRoleID,
		@inp_iUserInfoID=m_objUserRoleDTO.UserInfoID,
		@inp_iRoleID=m_objUserRoleDTO.RoleID,

                            //@out_nReturnValue = nReturnValue,
                            //@out_nSQLErrCode = nSQLErrCode,
                            //@out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<UserRoleDTO>();

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
