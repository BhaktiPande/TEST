using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PreclearanceRequestDAL:IDisposable
    {
        const string sLookUpPrefix = "dis_msg_";
        const string sLookUpPrefix1 = "tra_msg_";

        #region Save

        public PreclearanceRequestDTO Save(string i_sConnectionString, PreclearanceRequestDTO m_objPreclearanceRequestDTO, out string out_sContraTradeTillDate, out string out_sPeriodEnddate, out string out_sApproveddate, out string out_sPreValiditydate, out string out_sProhibitOnPer, out string out_sProhibitOnQuantity)
        {
            #region Paramters
            //bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            out_sPeriodEnddate="";	
            PreclearanceRequestDTO res = null;
            PetaPoco.Database db = null;
            out_sContraTradeTillDate = "";
            out_sApproveddate ="";
            out_sPreValiditydate="";
            out_sProhibitOnPer="";
            out_sProhibitOnQuantity = "";
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
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var sContraTradeTillDate = new SqlParameter("@out_sContraTradeTillDate", System.Data.SqlDbType.VarChar);
                sContraTradeTillDate.Direction = System.Data.ParameterDirection.Output;
                sContraTradeTillDate.Value = "";
                sContraTradeTillDate.Size = 500;
                 var sPeriodEnddate = new SqlParameter("@out_sPeriodEnddate", System.Data.SqlDbType.VarChar);
                sPeriodEnddate.Direction = System.Data.ParameterDirection.Output;
                sPeriodEnddate.Value = "";
                sPeriodEnddate.Size = 500;

                var sApproveddate = new SqlParameter("@out_sApproveddate", System.Data.SqlDbType.VarChar);
                sApproveddate.Direction = System.Data.ParameterDirection.Output;
                sApproveddate.Value = "";
                sApproveddate.Size = 500;

                var sPreValiditydate = new SqlParameter("@out_sPreValiditydate", System.Data.SqlDbType.VarChar);
                sPreValiditydate.Direction = System.Data.ParameterDirection.Output;
                sPreValiditydate.Value = "";
                sPreValiditydate.Size = 500;

                var sProhibitOnPer = new SqlParameter("@out_sProhibitOnPer", System.Data.SqlDbType.VarChar);
                sProhibitOnPer.Direction = System.Data.ParameterDirection.Output;
                sProhibitOnPer.Value = "";
                sProhibitOnPer.Size = 500;

                var sProhibitOnQuantity = new SqlParameter("@out_sProhibitOnQuantity", System.Data.SqlDbType.VarChar);
                sProhibitOnQuantity.Direction = System.Data.ParameterDirection.Output;
                sProhibitOnQuantity.Value = "";
                sProhibitOnQuantity.Size = 500;

                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PreclearanceRequestDTO>("exec st_tra_PreclearanceRequestSave @inp_nPreclearanceRequestId,@inp_iPreclearanceRequestForCodeId,@inp_iUserInfoId,@inp_iUserInfoIdRelative,@inp_iTransactionTypeCodeId,"
	                                                            +"@inp_iSecurityTypeCodeId,@inp_dSecuritiesToBeTradedQty,@inp_iPreclearanceStatusCodeId,@inp_iCompanyId,"
	                                                            +"@inp_dProposedTradeRateRangeFrom,@inp_dProposedTradeRateRangeTo,@inp_iDMATDetailsID,@inp_iReasonForNotTradingCodeId,"
                                                                + "@inp_sReasonForNotTradingText,@inp_nPreclearanceNotTakenFlag,@inp_sReasonForRejection,@inp_dSecuritiesToBeTradedValue,@inp_nUserId,@inp_bESOPExcerciseOptionQtyFlag,@inp_bOtherESOPExcerciseOptionQtyFlag,@inp_iModeOfAcquisitionCodeId,"
                                                                + "@inp_sReasonForApproval,@inp_iReasonForApprovalCodeId,@inp_PreclearanceValidityDateOld,@inp_PreclearanceValidityDateUpdatedByCO,"
                                                                + "@out_sContraTradeTillDate OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT,@out_sPeriodEnddate OUTPUT,@out_sApproveddate OUTPUT,@out_sPreValiditydate OUTPUT,@out_sProhibitOnPer OUTPUT,@out_sProhibitOnQuantity OUTPUT",
                         new
                         {
                             inp_nPreclearanceRequestId = m_objPreclearanceRequestDTO.PreclearanceRequestId,
                             inp_iPreclearanceRequestForCodeId = m_objPreclearanceRequestDTO.PreclearanceRequestForCodeId,
                             inp_iUserInfoId = m_objPreclearanceRequestDTO.UserInfoId,
                             inp_iUserInfoIdRelative = m_objPreclearanceRequestDTO.UserInfoIdRelative,
                             inp_iTransactionTypeCodeId = m_objPreclearanceRequestDTO.TransactionTypeCodeId,
                             inp_iSecurityTypeCodeId = m_objPreclearanceRequestDTO.SecurityTypeCodeId,
                             inp_dSecuritiesToBeTradedQty = m_objPreclearanceRequestDTO.SecuritiesToBeTradedQty,
                             inp_iPreclearanceStatusCodeId = m_objPreclearanceRequestDTO.PreclearanceStatusCodeId,
                             inp_iCompanyId = m_objPreclearanceRequestDTO.CompanyId,
                             inp_dProposedTradeRateRangeFrom = m_objPreclearanceRequestDTO.ProposedTradeRateRangeFrom,
                             inp_dProposedTradeRateRangeTo = m_objPreclearanceRequestDTO.ProposedTradeRateRangeTo,
                             inp_iDMATDetailsID = m_objPreclearanceRequestDTO.DMATDetailsID,
                             inp_iReasonForNotTradingCodeId = m_objPreclearanceRequestDTO.ReasonForNotTradingCodeId,
                             inp_sReasonForNotTradingText = m_objPreclearanceRequestDTO.ReasonForNotTradingText,
                             inp_nPreclearanceNotTakenFlag = m_objPreclearanceRequestDTO.PreclearanceNotTakenFlag,
                             inp_sReasonForRejection = m_objPreclearanceRequestDTO.ReasonForRejection,
                             inp_dSecuritiesToBeTradedValue = m_objPreclearanceRequestDTO.SecuritiesToBeTradedValue,
                             inp_nUserId=m_objPreclearanceRequestDTO.LoggedInUserId,
                             inp_bESOPExcerciseOptionQtyFlag = m_objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag,
                             inp_bOtherESOPExcerciseOptionQtyFlag = m_objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag,
                             inp_iModeOfAcquisitionCodeId = m_objPreclearanceRequestDTO.ModeOfAcquisitionCodeId,
                             inp_sReasonForApproval=m_objPreclearanceRequestDTO.ReasonForApproval,
                             inp_iReasonForApprovalCodeId=m_objPreclearanceRequestDTO.ReasonForApprovalCodeId,
                             inp_PreclearanceValidityDateOld = m_objPreclearanceRequestDTO.PreclearanceValidityDate,
                             inp_PreclearanceValidityDateUpdatedByCO = m_objPreclearanceRequestDTO.PreclearanceValidityDateChanged,
                             out_sContraTradeTillDate = sContraTradeTillDate,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage,
                             out_sPeriodEnddate = sPeriodEnddate,
                             out_sApproveddate = sApproveddate,
                             out_sPreValiditydate = sPreValiditydate,
                             out_sProhibitOnPer = sProhibitOnPer,
                             out_sProhibitOnQuantity = sProhibitOnQuantity

                         }).SingleOrDefault<PreclearanceRequestDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            out_sContraTradeTillDate = Convert.ToString(sContraTradeTillDate.Value);
                            out_sPeriodEnddate = Convert.ToString(sPeriodEnddate.Value);
                            out_sApproveddate = Convert.ToString(sApproveddate.Value); 
                            out_sPreValiditydate =Convert.ToString(sPreValiditydate.Value);
                            out_sProhibitOnPer = Convert.ToString(sProhibitOnPer.Value);
                            out_sProhibitOnQuantity = Convert.ToString(sProhibitOnQuantity.Value); 
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = "";
                            if (out_nReturnValue.ToString().Contains("16"))
                            {
                                sReturnValue = sLookUpPrefix1 + out_nReturnValue;
                            }
                            else
                            {
                                sReturnValue = sLookUpPrefix + out_nReturnValue;
                            }
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
                            //bReturn = false;
                            throw ex;
                        }
                        else
                        {
                            
                            scope.Complete();
                            //bReturn = true;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {

                throw exp;
            }

            return res;
        }
        #endregion Save

        #region Get Details
        
        public InsiderTradingDAL.PreclearanceRequestDTO GetDetails(string i_sConnectionString, long i_nPreclearanceRequestId)
        {
            PreclearanceRequestDTO res = null;
            
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PreclearanceRequestDTO>("exec  st_tra_PreclearanceRequestDetails @inp_sPreclearanceRequestId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sPreclearanceRequestId = i_nPreclearanceRequestId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<PreclearanceRequestDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetUserDetails

        #region Delete
      
        public bool Delete(string i_sConnectionString, int i_nPreclearanceRequestId, int inp_nUserId)
        {
            PreclearanceRequestDTO res = null;
            bool bReturn = false;
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
                sSQLErrMessage.Size = 500;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<PreclearanceRequestDTO>("exec  st_rul_TradingPolicyDelete @inp_iTradingPolicyId, @inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iTradingPolicyId = i_nPreclearanceRequestId,
                                inp_nUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<PreclearanceRequestDTO>();

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
                            bReturn = false;
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            bReturn = true;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }
            return bReturn;
        }
        #endregion InsertUpdateUserDetails

        #region Get Security Balance from Pool for Contra trade check

        public ExerciseBalancePoolDTO GetSecurityBalanceDetailsFromPool(string sConnectionString, int i_nUserInfoId, int i_nSecurityTypeCodeId, int i_nDMATDetailsID)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            ExerciseBalancePoolDTO res = null;
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
                        res = db.Query<ExerciseBalancePoolDTO>("exec st_tra_ExerciseBalancePoolDetails @inp_iUserInfoId, @inp_iSecurityTypeCodeId,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoId = i_nUserInfoId,
                               @inp_iSecurityTypeCodeId = i_nSecurityTypeCodeId,
                               @inp_iDMATDetailsID = i_nDMATDetailsID,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<ExerciseBalancePoolDTO>();

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

        #region Get Form E Details

        public InsiderTradingDAL.FormEDetailsDTO GetFormEDetails(string i_sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId)
        {
            FormEDetailsDTO res = null;

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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<FormEDetailsDTO>("exec st_tra_GetGeneratedFormDetails @inp_iMapToTypeCodeId,@inp_iMapToId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iMapToTypeCodeId = i_nMapToTypeCodeId,
                                @inp_iMapToId = i_nMapToId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<FormEDetailsDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion Get Form E Details

        #region GetLastPeriodEndSubmissonFlag
        public InsiderTradingDAL.PreclearanceRequestDTO GetLastPeriodEndSubmissonFlag(string i_sConnectionString, int i_nUserInfoID, out int out_nIsPreviousPeriodEndSubmission, out string out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out string out_sSubsequentPeriodEndResourceOwnSecurity)
        {
            PreclearanceRequestDTO res = null;
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
                var sSubsequentPeriodEndResourceOwnSecurity = new SqlParameter("@out_sSubsequentPeriodEndResourceOwnSecurity", System.Data.SqlDbType.VarChar);
                sSubsequentPeriodEndResourceOwnSecurity.Direction = System.Data.ParameterDirection.Output;
                sSubsequentPeriodEndResourceOwnSecurity.Value = "";
                sSubsequentPeriodEndResourceOwnSecurity.Size = 500;
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    db.CommandTimeout = 5000;
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PreclearanceRequestDTO>("exec st_tra_CheckPreviousPeriodEndSubmission @inp_iUserInfoID,@out_nIsPreviousPeriodEndSubmission OUTPUT,@out_sSubsequentPeriodEndOrPreciousPeriodEndResource OUTPUT,@out_sSubsequentPeriodEndResourceOwnSecurity OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoID = i_nUserInfoID,
                                @out_nIsPreviousPeriodEndSubmission = nIsPreviousPeriodEndSubmission,
                                @out_sSubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource,
                                @out_sSubsequentPeriodEndResourceOwnSecurity = sSubsequentPeriodEndResourceOwnSecurity,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<PreclearanceRequestDTO>();

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
                            out_sSubsequentPeriodEndResourceOwnSecurity = Convert.ToString(sSubsequentPeriodEndResourceOwnSecurity.Value);
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

        #region GetUserIdAndTransactionId
        /// <summary>
        /// This function will return a list of all the Groups saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<GetPendingEmployees> GetUserIdAndTransactionId(string i_sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, string inp_sParam21, string inp_sParam22, string inp_sParam23, string inp_sParam24,
            string inp_sParam25, string inp_sParam26, string inp_sParam27, string inp_sParam28, string inp_sParam29,
            string inp_sParam30,
            string inp_sParam31, string inp_sParam32, string inp_sParam33, string inp_sParam34,
            string inp_sParam35, string inp_sParam36, string inp_sParam37, string inp_sParam38, string inp_sParam39,
            string inp_sParam40, string inp_sParam41, string inp_sParam42, string inp_sParam43, string inp_sParam44,
            string inp_sParam45, string inp_sParam46, string inp_sParam47, string inp_sParam48, string inp_sParam49,
            string inp_sParam50,
            out int out_iTotalRecords, string sLookupPrefix)
        {
            PetaPoco.Database db = null;

            IEnumerable<GetPendingEmployees> lstGroupDocumentList = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
             out_iTotalRecords = 0;
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
                sSQLErrMessage.Size = 1000;
                
                
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstGroupDocumentList = db.Query<GetPendingEmployees>("exec st_com_PopulateGrid @inp_iGridType,@inp_iPageSize,@inp_iPageNo,@inp_sSortField ,@inp_sSortOrder,@inp_sParam1,@inp_sParam2,"
                    +"@inp_sParam3 ,@inp_sParam4 ,@inp_sParam5 ,@inp_sParam6 ,@inp_sParam7,"
	                +"@inp_sParam8 ,@inp_sParam9 ,@inp_sParam10 ,@inp_sParam11 ,@inp_sParam12 ,@inp_sParam13 ,@inp_sParam14 ,"			
	                +"@inp_sParam15 ,@inp_sParam16 ,@inp_sParam17 ,	@inp_sParam18 ,@inp_sParam19 ,@inp_sParam20,"
                    +"@inp_sParam21 ,@inp_sParam22 ,@inp_sParam23 ,@inp_sParam24 ,"			
	                +"@inp_sParam25 ,@inp_sParam26 ,@inp_sParam27 ,	@inp_sParam28 ,@inp_sParam29 ,@inp_sParam30,"
                  +"@inp_sParam31,@inp_sParam32,@inp_sParam33,@inp_sParam34,@inp_sParam35,@inp_sParam36,@inp_sParam37,"
                    + "@inp_sParam38,@inp_sParam39,@inp_sParam40,@inp_sParam41,@inp_sParam42,@inp_sParam43,@inp_sParam44,@inp_sParam45,@inp_sParam46,"
                    + "@inp_sParam47,@inp_sParam48,@inp_sParam49,@inp_sParam50,"
                    + "@out_iTotalRecords OUTPUT ,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_iGridType,
                             inp_iPageSize,
                             inp_iPageNo,
                             inp_sSortField,
                             inp_sSortOrder,
                             inp_sParam1,
                             inp_sParam2,
                             inp_sParam3,
                             inp_sParam4,
                             inp_sParam5,
                             inp_sParam6,
                             inp_sParam7,
                             inp_sParam8,
                             inp_sParam9,
                             inp_sParam10,
                             inp_sParam11,
                             inp_sParam12,
                             inp_sParam13,
                             inp_sParam14,
                             inp_sParam15,
                             inp_sParam16,
                             inp_sParam17,
                             inp_sParam18,
                             inp_sParam19,
                             inp_sParam20,
                             inp_sParam21,
                             inp_sParam22,
                             inp_sParam23,
                             inp_sParam24,
                             inp_sParam25,
                             inp_sParam26,
                             inp_sParam27,
                             inp_sParam28,
                             inp_sParam29,
                             inp_sParam30,
                             inp_sParam31,
                             inp_sParam32,
                             inp_sParam33,
                             inp_sParam34,
                             inp_sParam35,
                             inp_sParam36,
                             inp_sParam37,
                             inp_sParam38,
                             inp_sParam39,
                             inp_sParam40,
                             inp_sParam41,
                             inp_sParam42,
                             inp_sParam43,
                             inp_sParam44,
                             inp_sParam45,
                             inp_sParam46,
                             inp_sParam47,
                             inp_sParam48,
                             inp_sParam49,
                             inp_sParam50,

                             out_iTotalRecords = nTotalRecords,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
              
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDocumentList;
        }
        #endregion GetUserIdAndTransactionId
    }
}
