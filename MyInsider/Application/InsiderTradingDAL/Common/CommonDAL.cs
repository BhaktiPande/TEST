using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CommonDAL : IDisposable
    {
        // const String sLookupPrefix = "usr_com_";

        #region GetPopulateCombo
        /// <summary>
        /// This Function fetches the value for the Dropdown.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public IEnumerable<PopulateComboDTO> GetPopulateCombo(string sConnectionString, int inp_iComboType, string inp_sParam1,
            string inp_sParam2, string inp_sParam3, string inp_sParam4, string inp_sParam5, string sLookupPrefix)
        {
            List<PopulateComboDTO> res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<PopulateComboDTO>("exec st_com_populateCombo @inp_iComboType, @inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5"
                    + ",@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT ",
                        new
                        {
                            inp_iComboType,
                            inp_sParam1,
                            inp_sParam2,
                            inp_sParam3,
                            inp_sParam4,
                            inp_sParam5,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<PopulateComboDTO>();

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
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetPopulateCombo

        #region GetPopulateDataTable

        public IEnumerable<PopulateComboDTO> GetPopulateDataTable(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, out int out_iTotalRecords, string sLookupPrefix)
        {
            List<PopulateComboDTO> res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nTotalRecords = new SqlParameter("@out_iTotalRecords", System.Data.SqlDbType.Int);
                nTotalRecords.Direction = System.Data.ParameterDirection.Output;
                nTotalRecords.Value = 0;
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";


                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<PopulateComboDTO>("exec st_com_populateCombo @inp_iComboType, @inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5"
                    + ",@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT ",
                        new
                        {
                            inp_iGridType,
                            inp_sParam1,
                            inp_sParam2,
                            inp_sParam3,
                            inp_sParam4,
                            inp_sParam5,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<PopulateComboDTO>();

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
                        if (nTotalRecords.Value != DBNull.Value)
                        {
                            out_iTotalRecords = Convert.ToInt32(nTotalRecords.Value);
                        }
                        else
                        {
                            out_iTotalRecords = 0;
                        }
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetPopulateDataTable

        #region GetCurrentDate
        /// <summary>
        /// This method is used to get current DB date or date time
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="bDateWithTimestamp"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public DateTime GetCurrentDate(string sConnectionString, bool bDateWithTimestamp = false, string sLookupPrefix = "usr_com_")
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            DateTime res;
            PetaPoco.Database db = null;
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
                var dtCurrentDate = new SqlParameter("@out_dtCurrentDate", System.Data.SqlDbType.DateTime);
                dtCurrentDate.Direction = System.Data.ParameterDirection.Output;
                dtCurrentDate.Value = "";
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<DateTime>("exec st_com_GetDBServerDate @inp_iGetDateWithTimestamp,@out_dtCurrentDate OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iGetDateWithTimestamp = bDateWithTimestamp,

                               @out_dtCurrentDate = dtCurrentDate,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<DateTime>();

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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            //out_dtCurrentDate = Convert.ToDateTime(dtCurrentDate.Value);
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
        #endregion GetCurrentDate

        #region GetCurrentYearCode
        /// <summary>
        /// This method is used to get current year code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public int GetCurrentYearCode(string sConnectionString, string sLookupPrefix = "usr_com_")
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            int out_nCurrentYearCode;
            PetaPoco.Database db = null;
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
                var nCurrentYearCode = new SqlParameter("@out_nCurrentYearCode", System.Data.SqlDbType.Int);
                nCurrentYearCode.Direction = System.Data.ParameterDirection.Output;
                nCurrentYearCode.Value = 0;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_com_GetCurrentYearCode @out_nCurrentYearCode OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @out_nCurrentYearCode = nCurrentYearCode,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            out_nCurrentYearCode = Convert.ToInt32(nCurrentYearCode.Value);
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
            return out_nCurrentYearCode;
        }
        #endregion GetCurrentYearCode

        #region InitialChecks
        /// <summary>
        /// This Function fetches the value for the Dropdown.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public CommonDTO InitialChecks(string sConnectionString, int inp_iValidationType, int inp_iLoggenInUserId, out int RedirectionType)
        {
            CommonDTO res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            const String sLookupPrefix = "usr_com_";
            #endregion Paramters
            try
            {
                var nRedirectionType = new SqlParameter("@out_nRedirectionType", System.Data.SqlDbType.Int);
                nRedirectionType.Direction = System.Data.ParameterDirection.Output;
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

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<CommonDTO>("exec st_com_InitialChecks @inp_iValidationType, @inp_iLoggenInUserId, @out_nRedirectionType OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT ",
                        new
                        {
                            inp_iValidationType,
                            inp_iLoggenInUserId,
                            out_nRedirectionType = nRedirectionType,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).SingleOrDefault<CommonDTO>();

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
                    RedirectionType = Convert.ToInt32(nRedirectionType.Value);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion InitialChecks

        #region Get Configuration value from com code
        /// <summary>
        /// This method is used to get configuration code for code id
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nCodeId"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public int GetConfiguartionCode(string sConnectionString, int nCodeId, string sLookupPrefix = "usr_com_")
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            int out_nCodeName;
            PetaPoco.Database db = null;
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
                var nCodeName = new SqlParameter("@out_nCodeName", System.Data.SqlDbType.Int);
                nCodeName.Direction = System.Data.ParameterDirection.Output;
                nCodeName.Value = 0;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_com_GetConfigurationCode @inp_nCodeId, @inp_nReturnSelect, @out_nCodeName OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nCodeId = nCodeId,
                               @inp_nReturnSelect = 1,
                               @out_nCodeName = nCodeName,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            out_nCodeName = Convert.ToInt32(nCodeName.Value);
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
            return out_nCodeName;
        }
        #endregion Get Configuration value from com code

        #region Global Redirection
        /// <summary>
        /// This Function fetches the value for the Dropdown.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public CommonDTO GlobalRedirection(string sConnectionString, string sControllerAction, int inp_iLoggenInUserId)
        {
            CommonDTO res = null;
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            const String sLookupPrefix = "usr_com_";
            #endregion Paramters
            try
            {
                //var nRedirectionType = new SqlParameter("@out_nRedirectionType", System.Data.SqlDbType.VarChar);
                //nRedirectionType.Direction = System.Data.ParameterDirection.Output;
                //nRedirectionType.Size = 500;
                //nRedirectionType.Value = "";
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

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<CommonDTO>("exec st_com_GlobalRedirection @sControllerAction, @inp_iLoggenInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT ",
                        new
                        {
                            sControllerAction,
                            inp_iLoggenInUserId,
                            //out_nRedirectionType = nRedirectionType,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).SingleOrDefault<CommonDTO>();

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
                    //RedirectionType = Convert.ToString(nRedirectionType.Value);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion Global Redirection

        #region Save Eamil log
        //public bool SaveEamilLog(string sConnectionString, DataTable dtEamilLog)
        //{
        //    #region Paramters
        //    const String sLookupPrefix = "cmp_msg_";
        //    int out_nReturnValue;
        //    int out_nSQLErrCode;
        //    string out_sSQLErrMessage;
        //    int res;
        //    PetaPoco.Database db = null;

        //    bool retStatus = false;
        //    #endregion Paramters
        //    try
        //    {
        //        #region Out Paramter

        //        var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
        //        nReturnValue.Direction = System.Data.ParameterDirection.Output;
        //        nReturnValue.Value = 0;

        //        var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
        //        nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
        //        nSQLErrCode.Value = 0;

        //        var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
        //        sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
        //        sSQLErrMessage.Value = "";

        //        var inp_tblEamilLog = new SqlParameter();
        //        inp_tblEamilLog.DbType = DbType.Object;
        //        inp_tblEamilLog.ParameterName = "@inp_tblEamilProperties";
        //        inp_tblEamilLog.TypeName = "dbo.EmailLogDataTable";
        //        inp_tblEamilLog.SqlDbType = SqlDbType.Structured;
        //        inp_tblEamilLog.SqlValue = dtEamilLog;

        //        #endregion Out Paramter

        //        using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
        //        {
        //            using (var scope = db.GetTransaction())
        //            {
        //                res = db.Query<int>("exec st_com_SaveEmailLog @inp_tblEamilProperties, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
        //                   new
        //                   {
        //                       @inp_tblEamilProperties = inp_tblEamilLog,
        //                       @out_nReturnValue = nReturnValue,
        //                       @out_nSQLErrCode = nSQLErrCode,
        //                       @out_sSQLErrMessage = sSQLErrMessage
        //                   }).SingleOrDefault<int>();

        //                #region Error Values
        //                if (Convert.ToInt32(nReturnValue.Value) != 0)
        //                {
        //                    Exception e = new Exception();
        //                    out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
        //                    string sReturnValue = sLookupPrefix + out_nReturnValue;
        //                    e.Data[0] = sReturnValue;
        //                    if (nSQLErrCode.Value != System.DBNull.Value)
        //                    {
        //                        out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
        //                        e.Data[1] = out_nSQLErrCode;
        //                    }
        //                    if (sSQLErrMessage.Value != System.DBNull.Value)
        //                    {
        //                        out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
        //                        e.Data[2] = out_sSQLErrMessage;
        //                    }

        //                    Exception ex = new Exception(db.LastSQL.ToString(), e);
        //                    throw ex;
        //                }
        //                else
        //                {
        //                    scope.Complete();
        //                    retStatus = true;
        //                }
        //                #endregion Error Values
        //            }
        //        }
        //    }
        //    catch (Exception exp)
        //    {
        //        throw exp;
        //    }
        //    finally
        //    {

        //    }
        //    return retStatus;

        //}

        public bool SaveEamilLog(string i_sConnectionString, DataTable dtEamilLog)
        {
            #region Paramters
            const String sLookupPrefix = "cmp_msg_";
            List<EmailPropertiesDTO>  res = null;
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


                var inp_tblEamilLog = new SqlParameter();
                inp_tblEamilLog.DbType = DbType.Object;
                inp_tblEamilLog.ParameterName = "@inp_tblEamilProperties";
                inp_tblEamilLog.TypeName = "dbo.EmailLogDataTable";
                inp_tblEamilLog.SqlDbType = SqlDbType.Structured;
                inp_tblEamilLog.SqlValue = dtEamilLog;

                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<EmailPropertiesDTO>("exec st_com_SaveEmailLog @inp_tblEamilProperties, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblEamilProperties = inp_tblEamilLog,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).ToList();


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

        #endregion Save Eamil log
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

        #region CheckUserTypeAccess
        /// <summary>
        /// This Function fetches the user access for that page as per parameters.
        /// Function for validating user access for specified page, user should not view or modify other user details.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="inp_iMapToTypeCodeId"></param>
        /// <param name="inp_iMapToId"></param>
        /// <param name="inp_iLoggenInUserId"></param>
        /// <param name="out_nIsAccess"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public void CheckUserTypeAccess(string sConnectionString, int inp_iMapToTypeCodeId, Int64 inp_iMapToId, int inp_iLoggenInUserId, out int out_nIsAccess)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            const String sLookupPrefix = "usr_msg_";
            #endregion Paramters
            try
            {
                var nIsAccess = new SqlParameter("@out_nIsAccess", System.Data.SqlDbType.Int);
                nIsAccess.Direction = System.Data.ParameterDirection.Output;
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

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    var res = db.Query<int>("exec st_com_GetAccess @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iLoggenInUserId, @out_nIsAccess output,	@out_nReturnValue output, @out_nSQLErrCode output,@out_sSQLErrMessage output ",
                        new
                        {
                            inp_iMapToTypeCodeId,
                            inp_iMapToId,
                            inp_iLoggenInUserId,
                            out_nIsAccess = nIsAccess,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).SingleOrDefault<int>();

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
                    out_nIsAccess = Convert.ToInt32(nIsAccess.Value);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion CheckUserTypeAccess
    }
}
