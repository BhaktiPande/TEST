using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace InsiderTradingDAL
{
    public class PreclearanceRequestNonImplCompanyDAL : IDisposable
    {
        const string sLookUpPrefix = "dis_msg_";

        #region Save Pre-clearance request
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool SavePreclearanceRequest(string sConnectionString, DataTable dt_PreClearanceList)
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
                var inp_tblPreClearanceList = new SqlParameter();
                inp_tblPreClearanceList.DbType = DbType.Object;
                inp_tblPreClearanceList.ParameterName = "@inp_tblPreClearanceList";
                inp_tblPreClearanceList.TypeName = "dbo.PreClearanceListType";
                inp_tblPreClearanceList.SqlValue = dt_PreClearanceList;
                inp_tblPreClearanceList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PreclearanceRequestNonImplCompanySave @inp_tblPreClearanceList, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblPreClearanceList = inp_tblPreClearanceList,

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
        #endregion Save Pre-clearance request

        #region Get reqested pre-clearance request details
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nPreclearanceRequestId"></param>
        /// <returns></returns>
        public PreclearanceRequestNonImplCompanyDTO GetPreclearanceRequestDetail(string sConnectionString, long nPreclearanceRequestId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PreclearanceRequestNonImplCompanyDTO res = null;
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
                        res = db.Query<PreclearanceRequestNonImplCompanyDTO>("exec st_tra_PreclearanceRequestNonImplCompanyDetail @inp_iPreclearanceRequestId,  @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iPreclearanceRequestId = nPreclearanceRequestId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<PreclearanceRequestNonImplCompanyDTO>();

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
        #endregion Get reqested pre-clearance request details

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

        #region Save Pre-clearance request
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>

        public bool SavePreclearanceRequest_OS(string sConnectionString, DataTable dt_PreClearanceList, int? preclearanceRequestId, bool? preclearanceNotTakenFlag, int? reasonForNotTradingCodeId,
            string reasonForNotTradingText, int? userID, string preclearanceStatusCodeId, string reasonForRejection, string reasonForApproval, int? ReasonForApprovalCodeId, int? displaySequenceNo)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool returnVal = false;
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
                var inp_tblPreClearanceList = new SqlParameter();
                inp_tblPreClearanceList.DbType = DbType.Object;
                inp_tblPreClearanceList.ParameterName = "@inp_tblPreClearanceList";
                inp_tblPreClearanceList.TypeName = "dbo.PreClearanceListType";
                inp_tblPreClearanceList.SqlValue = dt_PreClearanceList;
                inp_tblPreClearanceList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PreclearanceRequestSave_OS @inp_tblPreClearanceList,@inp_nPreclearanceRequestId,@inp_nPreclearanceNotTakenFlag, @inp_iReasonForNotTradingCodeId, @inp_sReasonForNotTradingText,@inp_nUserId,@inp_iPreclearanceStatusCodeId,@inp_sReasonForRejection,@inp_sReasonForApproval,@inp_iReasonForApprovalCodeId,@inp_iDisplaySequenceNo, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblPreClearanceList = inp_tblPreClearanceList,
                               @inp_nPreclearanceRequestId = preclearanceRequestId,
                               @inp_nPreclearanceNotTakenFlag = preclearanceNotTakenFlag,
                               @inp_iReasonForNotTradingCodeId = reasonForNotTradingCodeId,
                               @inp_sReasonForNotTradingText = reasonForNotTradingText,
                               @inp_nUserId = userID,
                               @inp_iPreclearanceStatusCodeId = preclearanceStatusCodeId,
                               @inp_sReasonForRejection = reasonForRejection,
                               @inp_sReasonForApproval = reasonForApproval,
                               @inp_iReasonForApprovalCodeId = ReasonForApprovalCodeId,
                               @inp_iDisplaySequenceNo = displaySequenceNo,
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
                            scope.Complete();
                            returnVal = true;
                        }
                        #endregion Error Values
                    }
                }
                return returnVal;
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion Save Pre-clearance request

        #region Get Security Balance from Pool for Contra trade check

        public BalancePoolOSDTO GetSecurityBalanceDetailsFromPool(string sConnectionString, int? i_nUserInfoId, int i_nSecurityTypeCodeId, int i_nDMATDetailsID, int i_nCompanyID)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            BalancePoolOSDTO res = null;
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
                        res = db.Query<BalancePoolOSDTO>("exec st_tra_BalancePoolDetails_OS @inp_iUserInfoId, @inp_iSecurityTypeCodeId,@inp_iDMATDetailsID,@inp_iCompanyID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoId = i_nUserInfoId,
                               @inp_iSecurityTypeCodeId = i_nSecurityTypeCodeId,
                               @inp_iDMATDetailsID = i_nDMATDetailsID,
                               @inp_iCompanyID = i_nCompanyID,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<BalancePoolOSDTO>();

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
        #endregion Get Security Balance from Pool for Contra trade check

        #region Validate Pre-clearance request
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public int ValidatePreclearanceRequest(string sConnectionString, int preclearanceRequestId, int tradingPolicyID, int userInfoId, int? userInfoIdRelative,
                        int transactionTypeCodeId, int securityTypeCodeId, decimal? securitiesToBeTradedQty, decimal? securitiesToBeTradedValue, int companyId,
                        int modeOfAcquisitionCodeId, int DMATDetailsID, out bool bIsContraTrade, out string sContraTradeDate, out bool iIsAutoApproved)
        {
            #region Paramters

            int out_nReturnValue = 0;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            PetaPoco.Database db = null;
            bIsContraTrade = false;
            sContraTradeDate = "";
            iIsAutoApproved = false;
            bool out_bIsContraTrade = false;
            bool out_iIsAutoApproved = false;
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
                var sContraTradeTillDate = new SqlParameter("@out_sContraTradeTillDate", System.Data.SqlDbType.VarChar);
                sContraTradeTillDate.Direction = System.Data.ParameterDirection.Output;
                sContraTradeTillDate.Value = "";
                sContraTradeTillDate.Size = 500;
                var isAutoApproved = new SqlParameter("@out_iIsAutoApproved", System.Data.SqlDbType.Bit);
                isAutoApproved.Direction = System.Data.ParameterDirection.Output;
                isAutoApproved.Value = 0;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PreclearanceRequestNonImplCompanySaveValidations @inp_nPreclearanceRequestId,@inp_iTradingPolicyId,@inp_iUserInfoId,@inp_iUserInfoIdRelative,@inp_iTransactionTypeCodeId,@inp_iSecurityTypeCodeId,@inp_dSecuritiesToBeTradedQty,@inp_dSecuritiesToBeTradedValue,@inp_iCompanyId,@inp_iModeOfAcquisitionCodeId,@inp_iDMATDetailsID,@out_bIsContraTrade OUTPUT,@out_sContraTradeTillDate OUTPUT, @out_iIsAutoApproved OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_nPreclearanceRequestId = preclearanceRequestId,
                               @inp_iTradingPolicyId = tradingPolicyID,
                               @inp_iUserInfoId = userInfoId,
                               @inp_iUserInfoIdRelative = userInfoIdRelative,
                               @inp_iTransactionTypeCodeId = transactionTypeCodeId,
                               @inp_iSecurityTypeCodeId = securityTypeCodeId,
                               @inp_dSecuritiesToBeTradedQty = securitiesToBeTradedQty,
                               @inp_dSecuritiesToBeTradedValue = securitiesToBeTradedValue,
                               @inp_iCompanyId = companyId,
                               @inp_iModeOfAcquisitionCodeId = modeOfAcquisitionCodeId,
                               @inp_iDMATDetailsID = DMATDetailsID,
                               @out_bIsContraTrade = bIsContraTrade,
                               @out_sContraTradeTillDate = sContraTradeTillDate,
                               @out_iIsAutoApproved = isAutoApproved,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<int>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            bIsContraTrade = out_bIsContraTrade;
                            sContraTradeDate = Convert.ToString(sContraTradeTillDate.Value);
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
                            if (isAutoApproved.Value != System.DBNull.Value)
                            {
                                iIsAutoApproved = Convert.ToBoolean(isAutoApproved.Value);
                                scope.Complete();
                            }
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
            return out_nReturnValue;
        }
        #endregion Save Pre-clearance request

        #region update Pre-clearance approve/reject status
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>

        public bool PreclearanceRequestApproveRejectSave_OS(string sConnectionString, DataTable dt_PreClearanceList, DataTable dt_PreclearanceRequestId, bool? preclearanceNotTakenFlag, int? reasonForNotTradingCodeId,
            string reasonForNotTradingText, int? userID, int preclearanceStatusCodeId, string reasonForRejection, string reasonForApproval, int? ReasonForApprovalCodeId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res = 0;
            bool returnVal = false;
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
                var inp_tblPreClearanceList = new SqlParameter();
                inp_tblPreClearanceList.DbType = DbType.Object;
                inp_tblPreClearanceList.ParameterName = "@inp_tblPreClearanceList";
                inp_tblPreClearanceList.TypeName = "dbo.PreClearanceListType";
                inp_tblPreClearanceList.SqlValue = dt_PreClearanceList;
                inp_tblPreClearanceList.SqlDbType = SqlDbType.Structured;

                var inp_tblPreclearanceRequestId = new SqlParameter();
                inp_tblPreclearanceRequestId.DbType = DbType.Object;
                inp_tblPreclearanceRequestId.ParameterName = "@inp_tblPreclearanceRequestId";
                inp_tblPreclearanceRequestId.TypeName = "dbo.PreClearanceIDType";
                inp_tblPreclearanceRequestId.SqlValue = dt_PreclearanceRequestId;
                inp_tblPreclearanceRequestId.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_tra_PreclearanceRequestApproveRejectSave_OS @inp_tblPreClearanceList,@inp_tblPreclearanceRequestId,@inp_nPreclearanceNotTakenFlag, @inp_iReasonForNotTradingCodeId, @inp_sReasonForNotTradingText,@inp_nUserId,@inp_iPreclearanceStatusCodeId,@inp_sReasonForRejection,@inp_sReasonForApproval,@inp_iReasonForApprovalCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblPreClearanceList = inp_tblPreClearanceList,
                               @inp_tblPreclearanceRequestId = inp_tblPreclearanceRequestId,
                               @inp_nPreclearanceNotTakenFlag = preclearanceNotTakenFlag,
                               @inp_iReasonForNotTradingCodeId = reasonForNotTradingCodeId,
                               @inp_sReasonForNotTradingText = reasonForNotTradingText,
                               @inp_nUserId = userID,
                               @inp_iPreclearanceStatusCodeId = preclearanceStatusCodeId,
                               @inp_sReasonForRejection = reasonForRejection,
                               @inp_sReasonForApproval = reasonForApproval,
                               @inp_iReasonForApprovalCodeId = ReasonForApprovalCodeId,
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
                            scope.Complete();
                            returnVal = true;
                        }
                        #endregion Error Values
                    }
                }
                return returnVal;
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion update Pre-clearance approve/reject status

        #region GetLastPeriodEndSubmissonFlag
        public InsiderTradingDAL.PreclearanceRequestNonImplCompanyDTO GetLastPeriodEndSubmissonFlag_OS(string i_sConnectionString, int i_nUserInfoID, out int out_nIsPreviousPeriodEndSubmission, out string out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out string out_sSubsequentPeriodEndResourceOtherSecurity)
        {
            PreclearanceRequestNonImplCompanyDTO res = null;
            //bool bReturn = false;
            string sErrCode = string.Empty;
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
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var nIsPreviousPeriodEndSubmission = new SqlParameter("@out_nIsPreviousPeriodEndSubmission", System.Data.SqlDbType.Int);
                nIsPreviousPeriodEndSubmission.Direction = System.Data.ParameterDirection.Output;
                var sSubsequentPeriodEndOrPreciousPeriodEndResource = new SqlParameter("@out_sSubsequentPeriodEndOrPreciousPeriodEndResource", System.Data.SqlDbType.VarChar);
                sSubsequentPeriodEndOrPreciousPeriodEndResource.Direction = System.Data.ParameterDirection.Output;
                sSubsequentPeriodEndOrPreciousPeriodEndResource.Value = "";
                sSubsequentPeriodEndOrPreciousPeriodEndResource.Size = 500;
                var sSubsequentPeriodEndResourceOtherSecurity = new SqlParameter("@out_sSubsequentPeriodEndResourceOtherSecurity", System.Data.SqlDbType.VarChar);
                sSubsequentPeriodEndResourceOtherSecurity.Direction = System.Data.ParameterDirection.Output;
                sSubsequentPeriodEndResourceOtherSecurity.Value = "";
                sSubsequentPeriodEndResourceOtherSecurity.Size = 500; 
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    db.CommandTimeout = 5000;
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PreclearanceRequestNonImplCompanyDTO>("exec st_tra_CheckPreviousPeriodEndSubmission_OS @inp_iUserInfoID,@out_nIsPreviousPeriodEndSubmission OUTPUT,@out_sSubsequentPeriodEndOrPreciousPeriodEndResource OUTPUT, @out_sSubsequentPeriodEndResourceOtherSecurity OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoID = i_nUserInfoID,
                                @out_nIsPreviousPeriodEndSubmission = nIsPreviousPeriodEndSubmission,
                                @out_sSubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource,
                                @out_sSubsequentPeriodEndResourceOtherSecurity = sSubsequentPeriodEndResourceOtherSecurity,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<PreclearanceRequestNonImplCompanyDTO>();

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
                            //bReturn = false;
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            out_nIsPreviousPeriodEndSubmission = Convert.ToInt32(nIsPreviousPeriodEndSubmission.Value);
                            out_sSubsequentPeriodEndOrPreciousPeriodEndResource = Convert.ToString(sSubsequentPeriodEndOrPreciousPeriodEndResource.Value);
                            out_sSubsequentPeriodEndResourceOtherSecurity = Convert.ToString(sSubsequentPeriodEndResourceOtherSecurity.Value);
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                //bReturn = false;
                throw exp;
            }
            return res;
        }
        #endregion GetLastPeriodEndSubmissonFlag
    }
}
