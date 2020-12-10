using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class ApplicabilityDAL:IDisposable
    {
        const String sLookupPrefix = "rul_msg_";
        #region InsertDeleteApplicability
        public bool InsertDeleteApplicability(string sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId, int i_nAllEmployeeFlag, int i_nAllInsiderFlag, int i_nAllEmployeeInsiderFlag, int i_nAllCoFlag, int i_nAllCorporateInsiderFlag, int i_nAllNonEmployeeInsiderFlag, DataTable i_tblApplicabilityFilterType, DataTable i_tblNonInsEmpApplicabilityFilterType, DataTable i_tblApplicabilityIncludeExcludeUsers, int i_nLoggedInUserID, out int nOutCountOverlapPolicy)
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
                var nout_nCountUserAndOverlapTradingPolicy = new SqlParameter("@out_nCountUserAndOverlapTradingPolicy", System.Data.SqlDbType.Int);
                nout_nCountUserAndOverlapTradingPolicy.Direction = System.Data.ParameterDirection.Output;
                nout_nCountUserAndOverlapTradingPolicy.Value = 0;
                var nout_nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nout_nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nout_nReturnValue.Value = 0;
                var nout_nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nout_nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nout_nSQLErrCode.Value = 0;
                var sout_sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.NVarChar);
                sout_sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sout_sSQLErrMessage.Value = string.Empty;
                sout_sSQLErrMessage.Size = 1000;
                var inp_tblApplicabilityFilterType = new SqlParameter();
                inp_tblApplicabilityFilterType.DbType = DbType.Object;
                inp_tblApplicabilityFilterType.ParameterName = "@inp_tblApplicabilityFilterType";
                inp_tblApplicabilityFilterType.TypeName = "dbo.ApplicabilityFilterType";
                inp_tblApplicabilityFilterType.SqlValue = i_tblApplicabilityFilterType;
                inp_tblApplicabilityFilterType.SqlDbType = SqlDbType.Structured;

                var inp_tblNonInsEmpApplicabilityFilterType = new SqlParameter();
                inp_tblNonInsEmpApplicabilityFilterType.DbType = DbType.Object;
                inp_tblNonInsEmpApplicabilityFilterType.ParameterName = "@inp_tblNonInsEmpApplicabilityFilterType";
                inp_tblNonInsEmpApplicabilityFilterType.TypeName = "dbo.NonInsEmpApplicabilityFilterType";
                inp_tblNonInsEmpApplicabilityFilterType.SqlValue = i_tblNonInsEmpApplicabilityFilterType;
                inp_tblNonInsEmpApplicabilityFilterType.SqlDbType = SqlDbType.Structured;

                var inp_tblApplicabilityIncludeExcludeUsers = new SqlParameter();
                inp_tblApplicabilityIncludeExcludeUsers.DbType = DbType.Object;
                inp_tblApplicabilityIncludeExcludeUsers.ParameterName = "@inp_tblApplicabilityIncludeExcludeUsers";
                inp_tblApplicabilityIncludeExcludeUsers.TypeName = "dbo.ApplicabilityUserIncludeExcludeType";
                inp_tblApplicabilityIncludeExcludeUsers.SqlValue = i_tblApplicabilityIncludeExcludeUsers;
                inp_tblApplicabilityIncludeExcludeUsers.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<Test>("exec st_rul_ApplicabilityAssociationSave @inp_nMapToTypeCodeId, @inp_nMapToId, @inp_nAllEmployeeFlag, @inp_nAllInsiderFlag, @inp_nAllEmployeeInsiderFlag ,@inp_nAllCoFlag , @inp_nAllCorporateInsiderFlag , @inp_nAllNonEmployeeInsiderFlag, @inp_tblApplicabilityFilterType, @inp_tblNonInsEmpApplicabilityFilterType, @inp_tblApplicabilityIncludeExcludeUsers, @inp_nUserId, @out_nCountUserAndOverlapTradingPolicy OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nMapToTypeCodeId =	i_nMapToTypeCodeId,
	                        @inp_nMapToId =	i_nMapToId,
	                        @inp_nAllEmployeeFlag = i_nAllEmployeeFlag,
	                        @inp_nAllInsiderFlag =	i_nAllInsiderFlag,
                            @inp_nAllEmployeeInsiderFlag = i_nAllEmployeeInsiderFlag, // ,@inp_nAllCoFlag , @inp_nAllCorporateInsiderFlag , @inp_nAllNonEmployeeInsiderFlag
                            @inp_nAllCoFlag = i_nAllCoFlag,
                            @inp_nAllCorporateInsiderFlag = i_nAllCorporateInsiderFlag,
                            @inp_nAllNonEmployeeInsiderFlag = i_nAllNonEmployeeInsiderFlag,
                            @inp_tblApplicabilityFilterType = inp_tblApplicabilityFilterType,
                            @inp_tblNonInsEmpApplicabilityFilterType = inp_tblNonInsEmpApplicabilityFilterType,
                            @inp_tblApplicabilityIncludeExcludeUsers = inp_tblApplicabilityIncludeExcludeUsers,
	                        @inp_nUserId = i_nLoggedInUserID,
                            @out_nCountUserAndOverlapTradingPolicy = nout_nCountUserAndOverlapTradingPolicy,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).SingleOrDefault<Test>();

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
                            nOutCountOverlapPolicy = Convert.ToInt32(nout_nCountUserAndOverlapTradingPolicy.Value);
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
        }
        #endregion InsertDeleteApplicability

        #region GetDetails
        /// <summary>
        /// This method is used to get Applicability details 
        /// </summary>
        /// <param name="sConnectionString">db connection string</param>
        /// <param name="inp_nMapToTypeID">Map to type id</param>
        /// /// <param name="inp_nMapToId">Map to id</param>
        /// <returns>null or ApplicabilityDTO object</returns>
        public ApplicabilityDTO GetDetails(string sConnectionString, int inp_nMapToTypeID, int inp_nMapToId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            ApplicabilityDTO res = null;
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
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<ApplicabilityDTO>("exec st_rul_ApplicabilityAssociationFlagDetails @inp_nMapToTypeCodeId, @inp_nMapToId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nMapToTypeCodeId = inp_nMapToTypeID,
                               @inp_nMapToId = inp_nMapToId,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<ApplicabilityDTO>();

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
        #endregion GetDetails

        #region Get Count of applicable rule (policy document / trading policy) count
        /// <summary>
        /// This method is used to get applicability count for user
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nUserId"></param>
        /// <param name="nMapToTypeCodeId"></param>
        /// <returns></returns>
        public int UserApplicabilityCount(string sConnectionString, int nUserInfoId, int nMapToTypeCodeId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
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
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_usr_UserApplicabilityCount @inp_iUserInfoId,@inp_nApplicabilityType, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoId = nUserInfoId,
                               @inp_nApplicabilityType = nMapToTypeCodeId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<int>();

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
                            scope.Complete();
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                //return bReturn;
                throw exp;
            }
            finally
            {

            }
            return res;
        }
        #endregion Get Count of applicable rule (policy document / trading policy) count

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

    public class Test
    {
        public int reurnValue { get; set; }
    }

       
}
