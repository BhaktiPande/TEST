using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class RestrictedListDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";

        #region GetActivityRestrictedListDetails
        public List<RestrictedListDTO> GetActivityRestrictedListDetails(Hashtable ht_Parameter)
        {
            List<RestrictedListDTO> res = null;
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

                using (db = new PetaPoco.Database(Convert.ToString(ht_Parameter["i_sConnectionString"]), "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<RestrictedListDTO>("exec st_rl_GETCompanyMasterDetails @inp_iUserInfoID,@inp_iCase,@inp_iParam1, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoID = ht_Parameter["inp_iUserInfoId"],
                                inp_iCase = ht_Parameter["inp_iCase"],
                                inp_iParam1 = ht_Parameter["i_sCompanyID"],
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<RestrictedListDTO>();

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

        /// <summary>
        /// This method is use to fetch the dada for autocomplete textboxes 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="HT_SearchParam"></param>
        /// <returns></returns>
        public List<RestrictedListDTO> AutoCompleteList(string i_sConnectionString, Hashtable HT_SearchParam)
        {
            List<RestrictedListDTO> res = null;
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
                //nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<RestrictedListDTO>("exec st_rl_RestrictedListDetails @inp_sAction, @inp_sDetails, @inp_sCompanyName,@inp_sISINCode, @inp_sBSECode, @inp_sNSECode, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sAction = HT_SearchParam["Action"],
                                inp_sDetails = HT_SearchParam["Details"],
                                inp_sCompanyName = HT_SearchParam["CompanyName"],
                                inp_sISINCode = HT_SearchParam["ISINCode"],
                                inp_sBSECode = HT_SearchParam["BSECode"],
                                inp_sNSECode = HT_SearchParam["NSECode"],
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<RestrictedListDTO>();

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

        public Int32 SaveRestrictedListData(string i_sConnectionString, Hashtable HT_RestrictedList, DataTable i_dataTable)
        {
            Int32 res = 0;
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
                var inp_tblRLMasterType = new SqlParameter();
                inp_tblRLMasterType.DbType = DbType.Object;
                inp_tblRLMasterType.ParameterName = "@inp_tblRLMasterType";
                inp_tblRLMasterType.TypeName = "dbo.RestrictedListType";
                inp_tblRLMasterType.SqlValue = i_dataTable;
                inp_tblRLMasterType.SqlDbType = SqlDbType.Structured;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<int>("exec st_rl_RestrictedListSave @inp_iUserInfoID,@inp_iLoggedInUserId,@inp_tblRLMasterType,@inp_iRlMasterId,@inp_sActionType, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoID = HT_RestrictedList["UserInfoId"],
                                inp_iLoggedInUserId = HT_RestrictedList["LoggedInUserId"],
                                inp_tblRLMasterType = inp_tblRLMasterType,
                                inp_iRlMasterId = HT_RestrictedList["inp_iRlMasterId"],
                                inp_sActionType = HT_RestrictedList["inp_sActionType"],
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).Single<int>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0 && Convert.ToInt32(nReturnValue.Value) != -1)
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
                            if (Convert.ToInt32(nReturnValue.Value) != -1)
                                return res;
                            else
                                return Convert.ToInt32(nReturnValue.Value);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        public RestrictedSearchAudittDTO Restrictedlistdetails(string i_sConnectionString, Hashtable HT_SearchParam, out int i_nCount)
        {
            RestrictedSearchAudittDTO res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nCount = new SqlParameter("@out_nCount", System.Data.SqlDbType.Int);
                nCount.Direction = System.Data.ParameterDirection.Output;
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<RestrictedSearchAudittDTO>("exec st_rl_SearchAuditSave @inp_iLoggedInUserId, @inp_sCompanyName, @out_nCount OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iLoggedInUserId = HT_SearchParam["UserId"],
                                inp_sCompanyName = HT_SearchParam["CompanyName"],
                                out_nCount = nCount,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<RestrictedSearchAudittDTO>();

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
                            i_nCount = Convert.ToInt32(nCount.Value);
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

        #region Restricted list search limit check
        public int RestrictedlistSearchLimit(string i_sConnectionString, int i_userId)
        {
            RestrictedSearchAudittDTO res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            int i_result = 0;
            #endregion Paramters
            try
            {
                var out_parameter = new SqlParameter("@out_parameter", System.Data.SqlDbType.Int);
                out_parameter.Direction = System.Data.ParameterDirection.Output;
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<RestrictedSearchAudittDTO>("exec st_rl_CheckNumberOfSearch @inp_iUserId, @out_parameter OUTPUT,  @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserId = i_userId,
                                out_parameter = out_parameter,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<RestrictedSearchAudittDTO>();

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
                        
                    }
                }
                i_result = Convert.ToInt32(out_parameter.Value);
                return i_result;
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion Restricted list search limit check

        #region Get Restricted List Company Details
        /// <summary>
        /// This method is used to get restricted list company details for given company id
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="iCompanyId"></param>
        /// <returns></returns>
        public RestrictedListDTO GetRestrictedListCompanyDetails(string sConnectionString, int iCompanyId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            RestrictedListDTO res = null;
            PetaPoco.Database db = null;

            string LookupPrefix = "rl_msg";
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

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<RestrictedListDTO>("exec st_rl_RestictedListCompanyDetails @inp_iCompanyId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iCompanyId = iCompanyId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<RestrictedListDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = LookupPrefix + out_nReturnValue;
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
            return res;
        }
        #endregion Get Restricted List Company Details

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
