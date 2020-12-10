using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace InsiderTradingDAL
{
    public class DataUploadUtilityDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";

        #region GetMappingDetails
        public List<DataUploadUtilityDTO> GetMappingDetails(string i_sConnectionString)
        {
            List<DataUploadUtilityDTO> res = null;

            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(Convert.ToString(i_sConnectionString), "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<DataUploadUtilityDTO>("exec st_du_GetMappingTableDetails @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<DataUploadUtilityDTO>();

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
                            scope.Complete();
                            return res;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion GetActivityRestrictedListDetails

        #region GetImplementingCompany
        public List<ImplementingCompanyDetails> GetImplementingCompany(string i_sConnectionString)
        {
            List<ImplementingCompanyDetails> res = null;

            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(Convert.ToString(i_sConnectionString), "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<ImplementingCompanyDetails>("exec st_du_GetImplementingCompany @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<ImplementingCompanyDetails>();

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
                            scope.Complete();
                            return res;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion 
        
        #region GetMappingFieldsDetails
        public List<MappingFieldsDTO> GetMappingFieldsDetails(string i_sConnectionString)
        {
            List<MappingFieldsDTO> res = null;

            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(Convert.ToString(i_sConnectionString), "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<MappingFieldsDTO>("exec st_du_GetMappingFieldsDetails @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<MappingFieldsDTO>();

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
                            scope.Complete();
                            return res;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion 

        #region SaveUserSeparation
        /// <summary>
        /// This method is used for the insert/Update User Separation
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable Object</param>
        /// <param name="i_nLoggedInUserID">Logged In User Object</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns></returns>
        public Boolean SaveUserSeparation(string i_sConnectionString, DataTable i_tblUserInfo, int i_nLoggedInUserID)
        {
            #region Paramters
            List<UserInfoDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                var inp_tblUserSeparationType = new SqlParameter();
                inp_tblUserSeparationType.DbType = DbType.Object;
                inp_tblUserSeparationType.ParameterName = "@inp_tblUserSeparationType";
                inp_tblUserSeparationType.TypeName = "du_type_UpdateSeperation";
                inp_tblUserSeparationType.SqlValue = i_tblUserInfo;
                inp_tblUserSeparationType.SqlDbType = SqlDbType.Structured;
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<UserInfoDTO>("exec st_du_UpdateUserInfoSeparation @inp_tblUserSeparationType, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_tblUserSeparationType = inp_tblUserSeparationType,
                            inp_iLoggedInUserId = i_nLoggedInUserID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<UserInfoDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {
                            scope.Complete();
                            return true;
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion SaveUserSeparation

        #region IDisposable Members
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        void IDisposable.Dispose()
        {
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
