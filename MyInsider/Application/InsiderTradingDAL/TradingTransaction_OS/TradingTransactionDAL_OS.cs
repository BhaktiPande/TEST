using InsiderTrading;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace InsiderTradingDAL
{
    public class TradingTransactionDAL_OS:IDisposable
    {
        const String sLookupPrefix = "tra_msg_";
        #region GetDetails
        public TradingTransactionDTO_OS GetDetails(string sConnectionString, int m_iTransactionDetailsId)
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
                    var res = db.Query<TradingTransactionDTO_OS>("exec st_tra_TradingTransactionDetails_OS @inp_iTransactionDetailsId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTransactionDetailsId = m_iTransactionDetailsId,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<TradingTransactionDTO_OS>();   
                        
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
            catch(Exception exp)
            {
                 throw exp;
            }
            finally
            {

            }
        }
        #endregion GetDetails

        #region GetTransactionMasterDetails
        public TradingTransactionMasterDTO_OS GetTransactionMasterDetails(string sConnectionString, Int64 m_iTransactionMasterId)
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
                    var res = db.Query<TradingTransactionMasterDTO_OS>("exec st_tra_TradingTransactionMasterDetails_OS @inp_iTransactionMasterId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTransactionMasterId = m_iTransactionMasterId,

                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<TradingTransactionMasterDTO_OS>();

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
            finally
            {

            }
        }
        #endregion GetTransactionMasterDetails

        #region GetQunatityValue
        public TradingTransactionMasterDTO_OS GetQunatityValue(string sConnectionString,int m_iDisclosureTypeCodeId,int m_iUserInfoId)
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
                    var res = db.Query<TradingTransactionMasterDTO_OS>("exec st_tra_QuantityValueDetails_OS @inp_iDisclosuerType,@inp_iUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            //@inp_iTransactionType= m_iTransactionTypeCodeId,
                            @inp_iDisclosuerType= m_iDisclosureTypeCodeId,
                            @inp_iUserInfoId= m_iUserInfoId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<TradingTransactionMasterDTO_OS>();

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
            finally
            {

            }
        }
        #endregion

        #region Get_mst_company_details
        /// <summary>
        /// This function will Get mst_company details
        /// </summary>
        /// <returns></returns>
        public TradingTransactionMasterDTO_OS Get_mst_company_details(string inp_sConnectionString)
        {
            PetaPoco.Database db = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDAL_OS = new TradingTransactionMasterDTO_OS();
            try
            {
                using (db = new PetaPoco.Database(inp_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objTradingTransactionMasterDAL_OS = db.Query<TradingTransactionMasterDTO_OS>("exec st_com_mst_Company_Details",
                             new
                             {

                             }).Single<TradingTransactionMasterDTO_OS>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objTradingTransactionMasterDAL_OS;
        }
        #endregion Get_mst_company_details

        #region InsertUpdateIDTradingTransactionDetails_OS
        /// <summary>
        /// This method is used to save Initial Disclosure List for Other Securities
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool InsertUpdateIDTradingTransactionDetails_OS(string sConnectionString, DataTable dt_InitialDiscList)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool retStatus = false;
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
                var inp_tblInitialDisList = new SqlParameter();
                inp_tblInitialDisList.DbType = DbType.Object;
                inp_tblInitialDisList.ParameterName = "@inp_tblInitialDiscList";
                inp_tblInitialDisList.TypeName = "dbo.InitialDisListType";
                inp_tblInitialDisList.SqlValue = dt_InitialDiscList;
                inp_tblInitialDisList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_SaveInitialDisclosureList @inp_tblInitialDisList, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblInitialDisList = inp_tblInitialDisList,
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
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;
        }
        #endregion InsertUpdateIDTradingTransactionDetails_OS

        #region InsertUpdateIDTradingTransactionDetails
        /// <summary>
        /// This method is used to save Initial Disclosure List
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool InsertUpdateIDTradingTransactionDetails(string sConnectionString, DataTable dt_InitialDiscList)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool retStatus = false;
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
                var inp_tblInitialDisList = new SqlParameter();
                inp_tblInitialDisList.DbType = DbType.Object;
                inp_tblInitialDisList.ParameterName = "@inp_tblInitialDisList_OS";
                inp_tblInitialDisList.TypeName = "dbo.InitialDisListType_OS";
                inp_tblInitialDisList.SqlValue = dt_InitialDiscList;
                inp_tblInitialDisList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_SaveInitialDisclosureList_OS @inp_tblInitialDisList_OS, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblInitialDisList_OS = inp_tblInitialDisList,
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
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;
        }
        #endregion InsertUpdateIDTradingTransactionDetails

        #region InsertTransactionFormDetails
        public bool InsertTransactionFormDetails(string sConnectionString, TransactionLetterDTO_OS m_objTransactionLetterDTO_OS)
        {
            
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool retStatus = false;
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
                        res = db.Query<int>("exec st_tra_GenerateFormDetails_OS @inp_nMapToTypeCodeId, @inp_nMapToId,@inp_nLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nMapToTypeCodeId = m_objTransactionLetterDTO_OS.MapToTypeCodeId,
                               @inp_nMapToId = m_objTransactionLetterDTO_OS.MapToId,
                               @inp_nLoggedInUserId = m_objTransactionLetterDTO_OS.LoggedInUserId,
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
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;        
        }
        #endregion InsertTransactionFormDetails

        #region InsertTransactionFormDetails_ForTrade
        public bool InsertTransactionFormDetails_ForTrade(string sConnectionString, TransactionLetterDTO_OS m_objTransactionLetterDTO_OS)
        {

            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool retStatus = false;
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
                        res = db.Query<int>("exec st_tra_GenerateFormDetails_ForTrade_OS @inp_nMapToTypeCodeId, @inp_nMapToId,@inp_nLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nMapToTypeCodeId = m_objTransactionLetterDTO_OS.MapToTypeCodeId,
                               @inp_nMapToId = m_objTransactionLetterDTO_OS.MapToId,
                               @inp_nLoggedInUserId = m_objTransactionLetterDTO_OS.LoggedInUserId,
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
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;
        }
        #endregion InsertTransactionFormDetails_ForTrade
        #region InsertTransactionFormDetails_ForPeriodEnd
        public bool InsertTransactionFormDetails_ForPeriodEnd(string sConnectionString, TransactionLetterDTO_OS m_objTransactionLetterDTO_OS)
        {

            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool retStatus = false;
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
                        res = db.Query<int>("exec st_tra_PeriodEndDisclosureGetLetterContent_OS @inp_nMapToTypeCodeId, @inp_nMapToId,@inp_iUserInfoId,@inp_iYearCodeId,@inp_iPeriodCodeID,@inp_nLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nMapToTypeCodeId = m_objTransactionLetterDTO_OS.MapToTypeCodeId,
                               @inp_nMapToId = m_objTransactionLetterDTO_OS.MapToId,
                               @inp_iUserInfoId= m_objTransactionLetterDTO_OS.LoggedInUserId,
                               @inp_iYearCodeId= m_objTransactionLetterDTO_OS.inp_iYearCodeId,
                               @inp_iPeriodCodeID= m_objTransactionLetterDTO_OS.inp_iPeriodCodeID,
                               @inp_nLoggedInUserId = m_objTransactionLetterDTO_OS.LoggedInUserId,
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
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;
        }
        #endregion 

        #region InsertUpdateTradingTransactionDetails
        public TradingTransactionDTO_OS InsertUpdateTradingTransactionDetails(string sConnectionString, TradingTransactionDTO_OS m_objTradingTransactionDTO_OS, int nLoggedInUserId)
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
                sout_sSQLErrMessage.Size = 1000;
                sout_sSQLErrMessage.Value = string.Empty;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TradingTransactionDTO_OS>("exec st_tra_TradingTransactionSave_OS @inp_iTransactionDetailsId, @inp_iTransactionMasterId, @inp_iSecurityTypeCodeId, @inp_iForUserInfoId, @inp_iDMATDetailsID, @inp_iCompanyId, @inp_dtDateOfAcquisition, @inp_dtDateOfInitimationToCompany,	@inp_iModeOfAcquisitionCodeId, @inp_iExchangeCodeId, @inp_iTransactionTypeCodeId,	@inp_dQuantity,	@inp_dValue, @inp_iLotSize, @inp_sContractSpecification, @inp_sCompanyName, @inp_iLoggedInUserId,@inp_dOtherExcerciseOptionQty, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",

                            new
                            {
                                @inp_iTransactionDetailsId = m_objTradingTransactionDTO_OS.TransactionDetailsId,
                                @inp_iTransactionMasterId = m_objTradingTransactionDTO_OS.TransactionMasterId,
                                @inp_iSecurityTypeCodeId = m_objTradingTransactionDTO_OS.SecurityTypeCodeId,
                                @inp_iForUserInfoId = m_objTradingTransactionDTO_OS.ForUserInfoId,
                                @inp_iDMATDetailsID = m_objTradingTransactionDTO_OS.DMATDetailsID,
                                @inp_iCompanyId = m_objTradingTransactionDTO_OS.CompanyId,                              
                                @inp_dtDateOfAcquisition = m_objTradingTransactionDTO_OS.DateOfAcquisition,
                                @inp_dtDateOfInitimationToCompany = m_objTradingTransactionDTO_OS.DateOfInitimationToCompany,
                                @inp_iModeOfAcquisitionCodeId = m_objTradingTransactionDTO_OS.ModeOfAcquisitionCodeId,                              
                                @inp_iExchangeCodeId = m_objTradingTransactionDTO_OS.ExchangeCodeId,
                                @inp_iTransactionTypeCodeId = m_objTradingTransactionDTO_OS.TransactionTypeCodeId,
                                @inp_dQuantity = m_objTradingTransactionDTO_OS.Quantity,
                                @inp_dValue = m_objTradingTransactionDTO_OS.Value,
                                @inp_iLotSize = m_objTradingTransactionDTO_OS.LotSize,
                                @inp_sContractSpecification = m_objTradingTransactionDTO_OS.ContractSpecification,
                                @inp_sCompanyName = m_objTradingTransactionDTO_OS.CompanyName,
                                @inp_iLoggedInUserId = m_objTradingTransactionDTO_OS.LoggedInUserId,
                                @inp_dOtherExcerciseOptionQty = m_objTradingTransactionDTO_OS.OtherExcerciseOptionQty,
                                @out_nReturnValue = nout_nReturnValue,
                                @out_nSQLErrCode = nout_nSQLErrCode,
                                @out_sSQLErrMessage = sout_sSQLErrMessage,

                            }).SingleOrDefault<TradingTransactionDTO_OS>();

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
                            scope.Complete();
                            return res;
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
        #endregion InsertUpdateTradingTransactionDetails

        #region InsertUpdateSellAllDetails
        public TradingTransactionDTO_OS InsertUpdateSellAllDetails(string sConnectionString, TradingTransactionDTO_OS m_objTradingTransactionDTO_OS, int nLoggedInUserId)
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
                sout_sSQLErrMessage.Size = 1000;
                sout_sSQLErrMessage.Value = string.Empty;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TradingTransactionDTO_OS>("exec st_tra_SaveSellAllDetails_OS  @inp_iTransactionMasterId, @inp_iTransactionDetalisId,@inp_bSellAllFlag, @inp_iForUserInfoId,@inp_iCompanyId,@inp_iDMATDetailsId,@inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",

                            new
                            {
                                //@inp_iSellAllDetailsId=m_objTradingTransactionDTO_OS.SellAllDetailsId,
                                @inp_iTransactionMasterId = m_objTradingTransactionDTO_OS.TransactionMasterId,
                                @inp_iTransactionDetalisId=m_objTradingTransactionDTO_OS.TransactionDetailsId,
                                @inp_bSellAllFlag = m_objTradingTransactionDTO_OS.SellAllFlag,
                                @inp_iForUserInfoId = m_objTradingTransactionDTO_OS.ForUserInfoId,
                                inp_iCompanyId=m_objTradingTransactionDTO_OS.CompanyId,
                                @inp_iDMATDetailsId=m_objTradingTransactionDTO_OS.DMATDetailsID,
                                @inp_iLoggedInUserId = m_objTradingTransactionDTO_OS.ForUserInfoId,
                                @out_nReturnValue = nout_nReturnValue,
                                @out_nSQLErrCode = nout_nSQLErrCode,
                                @out_sSQLErrMessage = sout_sSQLErrMessage,

                            }).SingleOrDefault<TradingTransactionDTO_OS>();

                        #region Error Values

                        //if (!(nout_nReturnValue is DBNull))
                        //    m_objTradingTransactionDTO_OS.SellAllDetailsId = Convert.ToInt64(nout_nReturnValue);
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
                            scope.Complete();
                            return res;
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
        #endregion InsertUpdateSellAllDetails

        #region GetTransactionMasterCreate
        public TradingTransactionMasterDTO_OS GetTransactionMasterCreate(string sConnectionString, TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS,
                int nLoggedInUserId, out int o_iDisclosureCompletedFlag)
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
                sout_sSQLErrMessage.Size = 1000;
                var nout_nDisclosureCompletedFlag = new SqlParameter("@out_nDisclosureCompletedFlag", System.Data.SqlDbType.Int);
                nout_nDisclosureCompletedFlag.Direction = System.Data.ParameterDirection.Output;
                nout_nDisclosureCompletedFlag.Value = 0;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    var res = db.Query<TradingTransactionMasterDTO_OS>("exec st_tra_TradingTransactionMasterCreate_OS @inp_sTransactionMasterId, @inp_sPreclearanceRequestId, @inp_iUserInfoId, @inp_iDisclosureTypeCodeId, @inp_iTransactionStatusCodeId, @inp_sNoHoldingFlag, @inp_iTradingPolicyId,@inp_dtPeriodEndDate, @inp_bPartiallyTradedFlag, @inp_bSoftCopyReq, @inp_bHardCopyReq, @inp_nUserId, @inp_CDDuringPE, @inp_InsiderIDFlag, @out_nDisclosureCompletedFlag OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_sTransactionMasterId = objTradingTransactionMasterDTO_OS.TransactionMasterId,
                            @inp_sPreclearanceRequestId = objTradingTransactionMasterDTO_OS.PreclearanceRequestId,
                            @inp_iUserInfoId = objTradingTransactionMasterDTO_OS.UserInfoId,
                            @inp_iDisclosureTypeCodeId = objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId,
                            @inp_iTransactionStatusCodeId = objTradingTransactionMasterDTO_OS.TransactionStatusCodeId,
                            @inp_sNoHoldingFlag = objTradingTransactionMasterDTO_OS.NoHoldingFlag,
                            @inp_iTradingPolicyId = objTradingTransactionMasterDTO_OS.TradingPolicyId,
                            @inp_dtPeriodEndDate = objTradingTransactionMasterDTO_OS.PeriodEndDate,
                            @inp_bPartiallyTradedFlag = objTradingTransactionMasterDTO_OS.PartiallyTradedFlag,
                            @inp_bSoftCopyReq = objTradingTransactionMasterDTO_OS.SoftCopyReq,
                            @inp_bHardCopyReq = objTradingTransactionMasterDTO_OS.HardCopyReq,
                          //  @inp_dtHCpByCOSubmission = objTradingTransactionMasterDTO_OS.HardCopyByCOSubmissionDate,
                            @inp_nUserId = nLoggedInUserId,
                          //  @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingTransactionMasterDTO_OS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag,
                            @inp_CDDuringPE = objTradingTransactionMasterDTO_OS.CDDuringPE,
                            @inp_InsiderIDFlag = objTradingTransactionMasterDTO_OS.InsiderIDFlag,
                            @out_nDisclosureCompletedFlag = nout_nDisclosureCompletedFlag,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).SingleOrDefault<TradingTransactionMasterDTO_OS>();

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
                        if (nout_nDisclosureCompletedFlag.Value != System.DBNull.Value)
                        {
                            o_iDisclosureCompletedFlag = Convert.ToInt32(nout_nDisclosureCompletedFlag.Value);
                        }
                        else
                        {
                            o_iDisclosureCompletedFlag = 0;
                        }
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
        #endregion GetTransactionMasterCreate

        #region Delete Transaction master
        public bool DeleteTradingTransactionMaster(string sConnectionString, int m_iTransactionMasterId, int nLoggedInUserId)
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
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TradingTransactionDTO_OS>("exec st_tra_TradingTransactionMasterDelete_OS @inp_iTransactionMasterId,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTransactionMasterId = m_iTransactionMasterId,
                            @inp_iLoggedInUserId = nLoggedInUserId,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage

                        }).ToList<TradingTransactionDTO_OS>();
                        //TO DO.... Exception occured while Deleting the Role.. that NULL value is recived for nout_nReturnValue.
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
                            bReturn = true;
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
            return bReturn;
        }
        #endregion Delete Transaction master

        #region Delete
        public bool DeleteTradingTransactionDetails(string sConnectionString, int m_iTransactionDetailsId, int nLoggedInUserId)
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
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TradingTransactionDTO_OS>("exec st_tra_TradingTransactionDelete_OS @inp_iTransactionDetailsId,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTransactionDetailsId = m_iTransactionDetailsId,
                            @inp_iLoggedInUserId = nLoggedInUserId,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage

                        }).ToList<TradingTransactionDTO_OS>();
                        //TO DO.... Exception occured while Deleting the Role.. that NULL value is recived for nout_nReturnValue.
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
                            bReturn = true;
                        }
                        #endregion Error Values
                    }
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
        public IEnumerable<RoleMasterDTO> GetList(RoleMasterDTO m_objRoleMasterDTO, string sConnectionString)
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
                    var res = db.Query<RoleMasterDTO>("exec st_usr_RoleMasterList @inp_iRoleId,@inp_sRoleName,@inp_sDescription,@inp_iStatusCodeId,@inp_sLandingPageURL,@inp_iUserTypeCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                           	@inp_iRoleId=m_objRoleMasterDTO.RoleId,
		                    @inp_sRoleName=m_objRoleMasterDTO.RoleName,
		                    @inp_sDescription=m_objRoleMasterDTO.Description,
		                    @inp_iStatusCodeId=m_objRoleMasterDTO.StatusCodeId,
                            @inp_iUserTypeCodeId=m_objRoleMasterDTO.UserTypeCodeId,
                        }).ToList<RoleMasterDTO>();

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

        #region GetTransactionLetterDetails
        public TemplateMasterDTO GetTransactionLetterDetails(string sConnectionString, Int64 nTransactionLetterId, Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int nLetterForCodeId, int nCommunicationModeCodeId)
        {
            List<TemplateMasterDTO> res = null;
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

                var nWarningValue = new SqlParameter("@out_nWarningNotTemplateFound", System.Data.SqlDbType.Int);
                nWarningValue.Direction = System.Data.ParameterDirection.Output;
                nWarningValue.Value = 0;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<TemplateMasterDTO>("exec st_tra_TransactionLetterDetails @inp_iTransactionLetterId, @inp_iTransactionMasterId, @inp_iDisclosureTypeCodeId, @inp_iLetterForCodeId, @inp_iCommunicationModeCodeId, @out_nWarningNotTemplateFound OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iTransactionLetterId = nTransactionLetterId,
                            inp_iTransactionMasterId = nTransactionMasterId,
                            inp_iDisclosureTypeCodeId = nDisclosureTypeCodeId,
                            inp_iLetterForCodeId = nLetterForCodeId,
                            inp_iCommunicationModeCodeId = nCommunicationModeCodeId,
                            out_nWarningNotTemplateFound = nWarningValue,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).ToList<TemplateMasterDTO>();

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
                        //res[0].WarningMessage = Convert.ToInt32(nWarningValue.Value);
                        return res.FirstOrDefault();
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
        #endregion GetTransactionLetterDetails

        #region InsertUpdateTradingTransactionLetterDetails
        public TemplateMasterDTO InsertUpdateTradingTransactionLetterDetails(string sConnectionString, TemplateMasterDTO objTemplateMasterDTO, int nLoggedInUserId)
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
                sout_sSQLErrMessage.Size = 1000;
                sout_sSQLErrMessage.Value = string.Empty;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TemplateMasterDTO>("exec st_tra_TransactionLetterSave @inp_iTransactionLetterId, @inp_iTransactionMasterId, @inp_iLetterForCodeId, @inp_dtDate, @inp_sToAddress1, @inp_sToAddress2, @inp_sSubject, @inp_sContents, @inp_sSignature, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",

                            new
                            {
                                inp_iTransactionLetterId = objTemplateMasterDTO.TransactionLetterId,
                                inp_iTransactionMasterId = objTemplateMasterDTO.TransactionMasterId,
                                inp_iLetterForCodeId = objTemplateMasterDTO.LetterForCodeId,
                                inp_dtDate = objTemplateMasterDTO.Date,
                                inp_sToAddress1 = objTemplateMasterDTO.ToAddress1,
                                inp_sToAddress2 = objTemplateMasterDTO.ToAddress2,
                                inp_sSubject = objTemplateMasterDTO.Subject,
                                inp_sContents = objTemplateMasterDTO.Contents,
                                inp_sSignature = objTemplateMasterDTO.Signature,
                                inp_iLoggedInUserId = nLoggedInUserId,
                                out_nReturnValue = nout_nReturnValue,
                                out_nSQLErrCode = nout_nSQLErrCode,
                                out_sSQLErrMessage = sout_sSQLErrMessage,

                            }).SingleOrDefault<TemplateMasterDTO>();

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
                            scope.Complete();
                            return res;
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
        #endregion InsertUpdateTradingTransactionLetterDetails

        #region GetTransactionSummary
        public TradingTransactionSummaryDTO_OS GetTransactionSummary(string sConnectionString, Int64 m_iTransactionMasterId, Int64 m_iPreclearanceId)
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
                    var res = db.Query<TradingTransactionSummaryDTO_OS>("exec st_tra_TradingQuantitySummary_OS @inp_iTransactionMasterId,@inp_iPreclearanceId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iTransactionMasterId = m_iTransactionMasterId,
                            inp_iPreclearanceId = m_iPreclearanceId,
                            out_nReturnValue = nout_nReturnValue,
                            out_nSQLErrCode = nout_nSQLErrCode,
                            out_sSQLErrMessage = sout_sSQLErrMessage,
                        }).Single<TradingTransactionSummaryDTO_OS>();

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
            finally
            {

            }
        }
        #endregion GetTransactionSummary

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


        #region IsAllowNegativeBalanceForSecurity
        /// <summary>
        /// This method is used to get IsAllowNegativeBalanceForSecurity
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public bool IsAllowNegativeBalanceForSecurity(int nSecuirtyTypeCodeID,string sConnectionString, string sLookupPrefix = "usr_com_")
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            bool out_nCurrentYearCode;
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
                var bIsAllowNegatibeBalance = new SqlParameter("@out_bIsAllowNegatibeBalance", System.Data.SqlDbType.Bit);
                bIsAllowNegatibeBalance.Direction = System.Data.ParameterDirection.Output;
                bIsAllowNegatibeBalance.Value = 0;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_IsAllowNegativeBalanceForSecurity @inp_iSecuirtyTypeCodeID,@out_bIsAllowNegatibeBalance OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                              @inp_iSecuirtyTypeCodeID = nSecuirtyTypeCodeID,
                              @out_bIsAllowNegatibeBalance = bIsAllowNegatibeBalance,
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
                            out_nCurrentYearCode = Convert.ToBoolean(bIsAllowNegatibeBalance.Value);
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
        #endregion IsAllowNegativeBalanceForSecurity

        #region TradingTransactionConfirmHoldingsFor
        /// <summary>
        /// This method is used to Save TradingTransactionConfirmHoldingsFor
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public int TradingTransactionConfirmHoldingsFor(Int64 nTransactionMasterId, int nConfirmCompanyHoldingsFor, int nConfirmNonCompanyHoldingsFor, int nLoggedInUserId, string sConnectionString, string sLookupPrefix = "usr_com_")
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
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
                        res = db.Query<int>("exec st_tra_TradingTransactionConfirmHoldingsFor @inp_iTransactionMasterId,@inp_iConfirmCompanyHoldingsFor, @inp_iConfirmNonCompanyHoldingsFor,@inp_iLoggedInUserId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iTransactionMasterId = nTransactionMasterId,
                               @inp_iConfirmCompanyHoldingsFor = nConfirmCompanyHoldingsFor,
                               @inp_iConfirmNonCompanyHoldingsFor = nConfirmNonCompanyHoldingsFor,
                               @inp_iLoggedInUserId = nLoggedInUserId,
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
        #endregion TradingTransactionConfirmHoldingsFor

        #region GetContinuousDisclosureStatus
        /// <summary>
        /// This function will return Continuous Disclosure Status
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<ContinuousDisclosureStatusDTO> GetContinuousDisclosureStatus(string i_sConnectionString, int i_UserInfoId, DateTime dtEndDate)
        {
            PetaPoco.Database db = null;

            IEnumerable<ContinuousDisclosureStatusDTO> lstContDisStatus = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstContDisStatus = db.Query<ContinuousDisclosureStatusDTO>("exec st_tra_GetContDisStatus @inp_iUserInfoId, @inp_dtEndDate",
                         new
                         {
                             inp_iUserInfoId = i_UserInfoId,
                             inp_dtEndDate = dtEndDate
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstContDisStatus;
        }
        #endregion GetContinuousDisclosureStatus

        #region GetPEDisclosureStatus
        /// <summary>
        /// This function will return PE Disclosure Status
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<ContinuousDisclosureStatusDTO> GetPEDisclosureStatus(string i_sConnectionString, int i_UserInfoId, DateTime dtEndDate)
        {
            PetaPoco.Database db = null;

            IEnumerable<ContinuousDisclosureStatusDTO> lstPEDisStatus = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstPEDisStatus = db.Query<ContinuousDisclosureStatusDTO>("exec st_tra_GetPreviousPETrans_OS @inp_iUserInfoId, @inp_dtEndDate",
                         new
                         {
                             inp_iUserInfoId = i_UserInfoId,
                             inp_dtEndDate = dtEndDate
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstPEDisStatus;
        }
        #endregion GetPEDisclosureStatus

        #region GetCDTransIdduringPE
        /// <summary>
        /// This function will return continuous disclosureTransaction master Id raised during period end
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<TradingTransactionMasterDTO> GetCDTransIdduringPE(TradingTransactionMasterDTO objTradingTransactionMasterDTO, string sConnectionString, bool cdDuringPE)
        {
            PetaPoco.Database db = null;

            IEnumerable<TradingTransactionMasterDTO> lstTransId = null;
            try
            {
                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstTransId = db.Query<TradingTransactionMasterDTO>("exec st_tra_GetCDTransIdduringPE @inp_iUserInfoId,@inp_sCDDuringPE,@inp_dPeriodEndDate,@inp_iTransactionMasterId",
                         new
                         {
                             inp_iUserInfoId = objTradingTransactionMasterDTO.UserInfoId,
                             inp_sCDDuringPE = cdDuringPE,
                             inp_dPeriodEndDate = objTradingTransactionMasterDTO.PeriodEndDate,
                             inp_iTransactionMasterId=objTradingTransactionMasterDTO.TransactionMasterId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstTransId;
        }
        #endregion GetCDTransIdduringPE        

        #region CheckDuplicateTransaction_OS
        public List<DuplicateTransactionDetailsDTO_OS> CheckDuplicateTransaction_OS(string sConnectionString, int nLoggedInUserId, int nDMATDetailsID, int nSecurityType, int CompanyId, long nTransactionDetailsId)
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
                sout_sSQLErrMessage.Size = 50;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<DuplicateTransactionDetailsDTO_OS>("exec st_tra_CheckDuplicateTransaction_OS @inp_iUserInfoId,@inp_iDMATDetailsID,@inp_iSecurityType,@inp_iCompanyId,@inp_iTransactionDetailsId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iUserInfoId = nLoggedInUserId,
                            @inp_iDMATDetailsID = nDMATDetailsID,
                            @inp_iSecurityType = nSecurityType,
                            @inp_iCompanyId = CompanyId,
                            @inp_iTransactionDetailsId = nTransactionDetailsId,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage

                        }).ToList<DuplicateTransactionDetailsDTO_OS>();
                        //TO DO.... Exception occured while Deleting the Role.. that NULL value is recived for nout_nReturnValue.
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
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion CheckDuplicateTransaction_OS


        #region CheckIntialDisclosureNoHolding_OS
        public List<DuplicateTransactionDetailsDTO_OS> CheckIntialDisclosureNoHolding_OS(string sConnectionString, int nTradingTransactionMasterId)
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
                sout_sSQLErrMessage.Size = 50;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<DuplicateTransactionDetailsDTO_OS>("exec st_tra_CheckIntialDisclosureNoHolding_OS @inp_iTransactionId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTransactionId = nTradingTransactionMasterId,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage

                        }).ToList<DuplicateTransactionDetailsDTO_OS>();
                        //TO DO.... Exception occured while Deleting the Role.. that NULL value is recived for nout_nReturnValue.
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
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion CheckIntialDisclosureNoHolding_OS


        public IEnumerable<ApprovedPCLDTO_OS> GetApprovedPCLCnt(string i_sConnectionString, int i_UserInfoId)
        {
            PetaPoco.Database db = null;

            IEnumerable<ApprovedPCLDTO_OS> lstApprovedPCLStatus_OS = null;
       
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstApprovedPCLStatus_OS = db.Query<ApprovedPCLDTO_OS>("exec st_tra_GetApprovedPCLCnt @inp_iUserInfoId",
                         new
                         {
                             inp_iUserInfoId = i_UserInfoId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstApprovedPCLStatus_OS;
        }

        #region GetPanNumber_OS
        /// <summary>
        /// This stored Procedure is used to get Pan and Date Of Acquisition for Other Securities
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<TradingTransactionMasterDTO_OS> GetPanNumber_OS(TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS, string sConnectionString)
        {
            PetaPoco.Database db = null;

            IEnumerable<TradingTransactionMasterDTO_OS> lstPanNo_OS = null;
            try
            {
                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstPanNo_OS = db.Query<TradingTransactionMasterDTO_OS>("exec st_tra_GetPanNumber_OS @inp_iTransactionMasterId",
                         new
                         {
                             inp_iTransactionMasterId = objTradingTransactionMasterDTO_OS.TransactionMasterId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstPanNo_OS;
        }
        #endregion GetPanNumber_OS
    }
}
