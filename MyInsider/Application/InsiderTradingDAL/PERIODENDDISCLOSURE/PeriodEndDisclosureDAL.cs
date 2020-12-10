using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PeriodEndDisclosureDAL:IDisposable
    {
        const string sLookUpPrefix = "tra_msg_";

        #region Get period start and end date
        /// <summary>
        /// This method is used to get period's start and end date in year
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="YearCode"></param>
        /// <param name="PeriodCode"></param>
        /// <returns></returns>
        public Dictionary<String, Object> GetPeriodStarEndDate(string sConnectionString, int YearCode, int PeriodCode, int PeriodType)
        {
            var PeriodStartEndDate = new Dictionary<String, object>();

            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            DateTime? dtDate = null;
            DateTime out_dtStartDate;
            DateTime out_dtEndDate;
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

                var dtPeriodStartDate = new SqlParameter("@out_dtStartDate", System.Data.SqlDbType.DateTime);
                dtPeriodStartDate.Direction = System.Data.ParameterDirection.Output;
                dtPeriodStartDate.Value = "";

                var dtPeriodEndDate = new SqlParameter("@out_dtEndDate", System.Data.SqlDbType.DateTime);
                dtPeriodEndDate.Direction = System.Data.ParameterDirection.Output;
                dtPeriodEndDate.Value = "";

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PeriodEndDisclosureStartEndDate2 @inp_nYearCode,@inp_nPeriodCode,@inp_dtDate,@inp_iPeriodType,@inp_nReturnSelect, @out_dtStartDate OUTPUT,@out_dtEndDate OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nYearCode = YearCode,
                               @inp_nPeriodCode = PeriodCode,
                               @inp_dtDate = dtDate,
                               @inp_iPeriodType = PeriodType,
                               @inp_nReturnSelect = 1,

                               @out_dtStartDate = dtPeriodStartDate,
                               @out_dtEndDate = dtPeriodEndDate,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            out_dtStartDate = Convert.ToDateTime(dtPeriodStartDate.Value);
                            out_dtEndDate = Convert.ToDateTime(dtPeriodEndDate.Value);

                            scope.Complete();

                            PeriodStartEndDate.Add("start_date", out_dtStartDate);
                            PeriodStartEndDate.Add("end_date", out_dtEndDate);
                            
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
            return PeriodStartEndDate;
        }
        #endregion Get period start and end date
        
        #region Get lastest period end year code
        /// <summary>
        /// This method is used to lastest period end disclosure year code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetLastestPeriodEndYearCode(string sConnectionString)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            int out_nLatestPeriodEndYearCode;
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

                var nLatestPeriodEndYearCode = new SqlParameter("@out_nLatestPeriodEndYearCode", System.Data.SqlDbType.Int);
                nLatestPeriodEndYearCode.Direction = System.Data.ParameterDirection.Output;
                nLatestPeriodEndYearCode.Value = 0;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PeriodEndDisclosureCurrentDisclosureYearCode @out_nLatestPeriodEndYearCode OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @out_nLatestPeriodEndYearCode = nLatestPeriodEndYearCode,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            out_nLatestPeriodEndYearCode = Convert.ToInt32(nLatestPeriodEndYearCode.Value);

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
            return out_nLatestPeriodEndYearCode;
        }
        #endregion Get lastest period end year code

        #region Get Closing Balance Of Annual Period
        /// <summary>
        /// This method is used to get Closing balance of annual period of that user.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public double GetClosingBalanceOfAnnualPeriod(string sConnectionString, int nUserInfoId, int nUserInfoIdRelative, int nSecurityTypeCodeId)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            double out_nClosingBalance;
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

                var nClosingBalance = new SqlParameter("@out_nnClosingBalance", System.Data.SqlDbType.Float);
                nClosingBalance.Direction = System.Data.ParameterDirection.Output;
                nClosingBalance.Value = 0;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_GetClosingBalanceOfAnnualPeriod @inp_nUserInfoId, @inp_nUserInfoIdRelative, @inp_nSecurityTypeCodeId, @out_nClosingBalance OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nUserInfoId = nUserInfoId,
                               @inp_nUserInfoIdRelative = nUserInfoIdRelative,
                               @inp_nSecurityTypeCodeId = nSecurityTypeCodeId,                             
                               @out_nClosingBalance = nClosingBalance,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            out_nClosingBalance = Convert.ToDouble(nClosingBalance.Value);

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
            return out_nClosingBalance;
        }
        #endregion  Get Closing Balance Of Annual Period

        #region Get lastest period end period code
        /// <summary>
        /// This method is used to lastest period end disclosure year code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetLastestPeriodEndPeriodCode(string sConnectionString)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            int out_nLatestPeriodEndCode;
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

                var nLatestPeriodEndCode = new SqlParameter("@out_nLatestPeriodEndCode", System.Data.SqlDbType.Int);
                nLatestPeriodEndCode.Direction = System.Data.ParameterDirection.Output;
                nLatestPeriodEndCode.Value = 0;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PeriodEndDisclosureCurrentDisclosurePeriodCode @inp_nReturnSelect, @out_nLatestPeriodEndCode OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nReturnSelect = 1,
                               @out_nLatestPeriodEndCode = nLatestPeriodEndCode,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            out_nLatestPeriodEndCode = Convert.ToInt32(nLatestPeriodEndCode.Value);

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
            return out_nLatestPeriodEndCode;
        }
        #endregion Get lastest period end period code


        #region Get impact on securities held post to acquisition
        /// <summary>
        /// This method is used to get impact on securities held post to acquisition.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nTransTypeCodeId"></param>
        /// <param name="nModeOfAcquisCodeId"></param>        
        /// <returns></returns>
        public int GetImpactOnPostQuantity(string sConnectionString, int nTransTypeCodeId, int nModeOfAcquisCodeId, int nSecurityTypeCodeId)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            int @out_nImpactOnPostQuantity;
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

                var nImpactOnPostQuantity = new SqlParameter("@out_nImpactOnPostQuantity", System.Data.SqlDbType.Float);
                nImpactOnPostQuantity.Direction = System.Data.ParameterDirection.Output;
                nImpactOnPostQuantity.Value = 0;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_GetImpactOnPostQuantity @nTransTypeCodeId, @nModeOfAcquisCodeId, @nSecurityTypeCodeId, @out_nImpactOnPostQuantity OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @nTransTypeCodeId = nTransTypeCodeId,
                               @nModeOfAcquisCodeId = nModeOfAcquisCodeId,
                               @nSecurityTypeCodeId = nSecurityTypeCodeId,
                               @out_nImpactOnPostQuantity = nImpactOnPostQuantity,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            out_nImpactOnPostQuantity = Convert.ToInt32(nImpactOnPostQuantity.Value);

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
            return out_nImpactOnPostQuantity;
        }
        #endregion  Get impact on securities held post to acquisition



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
