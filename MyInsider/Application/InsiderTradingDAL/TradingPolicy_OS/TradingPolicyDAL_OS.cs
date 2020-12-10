using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
   public class TradingPolicyDAL_OS:IDisposable
    {
       const string sLookUpPrefix = "rul_msg_";

       #region Save
       /// <summary>
       /// This method is used for the save Trading policy details
       /// </summary>
       /// <param name="i_sConnectionString">DB Connection string</param>
       /// <param name="m_objTradingPolicyDTO">object TradingPolicyDTO</param>
       /// <returns></returns>
       public TradingPolicyDTO Save(string i_sConnectionString, TradingPolicyDTO m_objTradingPolicyDTO, DataTable i_tblPreclearanceSecuritywise,
           DataTable i_tblContinousSecuritywise, DataTable i_tblPreclearanceTransactionSecurityMap)
        {
            #region Paramters
            //bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            TradingPolicyDTO res = null;
            PetaPoco.Database db = null;
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

                var inp_tblPreclearanceSecuritywise = new SqlParameter();
                inp_tblPreclearanceSecuritywise.DbType = DbType.Object;
                inp_tblPreclearanceSecuritywise.ParameterName = "@inp_tblPreClearanceSecuritywise";
                inp_tblPreclearanceSecuritywise.TypeName = "dbo.SecuritywiseLimitsType";
                inp_tblPreclearanceSecuritywise.SqlValue = i_tblPreclearanceSecuritywise;
                inp_tblPreclearanceSecuritywise.SqlDbType = SqlDbType.Structured;

                var inp_tblContinousSecuritywise = new SqlParameter();
                inp_tblContinousSecuritywise.DbType = DbType.Object;
                inp_tblContinousSecuritywise.ParameterName = "@inp_tblContinousSecuritywise";
                inp_tblContinousSecuritywise.TypeName = "dbo.SecuritywiseLimitsType";
                inp_tblContinousSecuritywise.SqlValue = i_tblContinousSecuritywise;
                inp_tblContinousSecuritywise.SqlDbType = SqlDbType.Structured;

                var inp_tblPreclearanceTransactionSecurityMap = new SqlParameter();
                inp_tblPreclearanceTransactionSecurityMap.DbType = DbType.Object;
                inp_tblPreclearanceTransactionSecurityMap.ParameterName = "@inp_tblPreclearanceTransactionSecurityMap";
                inp_tblPreclearanceTransactionSecurityMap.TypeName = "dbo.TradingPolicyForTransactionSecurityMap";
                inp_tblPreclearanceTransactionSecurityMap.SqlValue = i_tblPreclearanceTransactionSecurityMap;
                inp_tblPreclearanceTransactionSecurityMap.SqlDbType = SqlDbType.Structured;

                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<TradingPolicyDTO>("exec st_rul_TradingPolicySave @inp_iTradingPolicyId,@inp_iTradingPolicyParentId,"
                        +"@inp_iCurrentHistoryCodeId,@inp_iTradingPolicyForCodeId,@inp_sTradingPolicyName,@inp_sTradingPolicyDescription,@inp_dtApplicableFromDate,"
                        +"@inp_dtApplicableToDate,@inp_bPreClrTradesApprovalReqFlag,@inp_iPreClrSingleTransTradeNoShares,"
                        +"@inp_iPreClrSingleTransTradePercPaidSubscribedCap,@inp_bPreClrProhibitNonTradePeriodFlag,@inp_iPreClrCOApprovalLimit,"
                        +"@inp_iPreClrApprovalValidityLimit,@inp_bPreClrSeekDeclarationForUPSIFlag,@inp_sPreClrUPSIDeclaration,@inp_bPreClrReasonForNonTradeReqFlag,"
                        +"@inp_bPreClrCompleteTradeNotDoneFlag,@inp_bPreClrPartialTradeNotDoneFlag,@inp_iPreClrTradeDiscloLimit,"
                        +"@inp_iPreClrTradeDiscloShareholdLimit,@inp_bStExSubmitTradeDiscloAllTradeFlag,@inp_iStExSingMultiTransTradeFlagCodeId,"
                        +"@inp_iStExMultiTradeFreq,@inp_iStExMultiTradeCalFinYear,@inp_iStExTransTradeNoShares,@inp_iStExTransTradePercPaidSubscribedCap,"
                        +"@inp_iStExTransTradeShareValue,@inp_iStExTradeDiscloSubmitLimit,@inp_bDiscloInitReqFlag,@inp_iDiscloInitLimit,"
                        +"@inp_dtDiscloInitDateLimit,@inp_bDiscloPeriodEndReqFlag,@inp_iDiscloPeriodEndFreq,@inp_sGenSecurityType,@inp_bGenTradingPlanTransFlag,"
                        +"@inp_iGenMinHoldingLimit,@inp_iGenContraTradeNotAllowedLimit,@inp_sGenExceptionFor,@inp_iTradingPolicyStatusCodeId,"
                        +"@inp_bDiscloInitSubmitToStExByCOFlag,@inp_bStExSubmitDiscloToStExByCOFlag,@inp_iDiscloPeriodEndToCOByInsdrLimit,@inp_bDiscloPeriodEndSubmitToStExByCOFlag,@inp_iDiscloPeriodEndSubmitToStExByCOLimit,"
                        +"@inp_bDiscloInitReqSoftcopyFlag,@inp_bDiscloInitReqHardcopyFlag,@inp_bDiscloInitSubmitToStExByCOSoftcopyFlag,@inp_bDiscloInitSubmitToStExByCOHardcopyFlag,"
                        +"@inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit,@inp_bStExSubmitDiscloToStExByCOSoftcopyFlag,@inp_bStExSubmitDiscloToStExByCOHardcopyFlag,"
                        +"@inp_bDiscloPeriodEndReqSoftcopyFlag,@inp_bDiscloPeriodEndReqHardcopyFlag,@inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag,@inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag,"
                        +"@inp_bStExSubmitDiscloToCOByInsdrFlag,@inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag,@inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag,"
                        +"@inp_bPreClrForAllSecuritiesFlag,@inp_bStExForAllSecuritiesFlag,"
                        +"@inp_sSelectedPreClearancerequiredforTransactionValue,@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue,"
                        +"@inp_tblPreClearanceSecuritywise,@inp_tblContinousSecuritywise,"
                        +"@inp_tblPreclearanceTransactionSecurityMap,@inp_bPreClrAllowNewForOpenPreclearFlag,@inp_iPreClrMultipleAboveInCodeId,"
                        +"@inp_iPreClrApprovalPreclearORPreclearTradeFlag,"
                        +"@inp_bPreClrTradesAutoApprovalReqFlag,@inp_iPreClrSingMultiPreClrFlagCodeId,"
                        +"@inp_iGenCashAndCashlessPartialExciseOptionForContraTrade,@inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,"
                        + "@inp_bTradingThresholdLimtResetFlag,@inp_nContraTradeBasedOn,@inp_sSelectedContraTradeSecuirtyType, "
                        + "@inp_nUserId,@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag,@inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures,@inp_DeclarationToBeMandatoryFlag,@inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,"
                        + "@inp_bIsPreclearanceFormForImplementingCompany,@inp_iPreclearanceWithoutPeriodEndDisclosure,@inp_PreClrApprovalReasonReqFlag,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_iTradingPolicyId = m_objTradingPolicyDTO.TradingPolicyId,
                             inp_iTradingPolicyParentId = m_objTradingPolicyDTO.TradingPolicyParentId,
                             inp_iCurrentHistoryCodeId = m_objTradingPolicyDTO.CurrentHistoryCodeId,
                             inp_iTradingPolicyForCodeId = m_objTradingPolicyDTO.TradingPolicyForCodeId,
                             inp_sTradingPolicyName = m_objTradingPolicyDTO.TradingPolicyName,
                             inp_sTradingPolicyDescription = m_objTradingPolicyDTO.TradingPolicyDescription,
                             inp_dtApplicableFromDate = m_objTradingPolicyDTO.ApplicableFromDate,
                             inp_dtApplicableToDate = m_objTradingPolicyDTO.ApplicableToDate,
                             inp_bPreClrTradesApprovalReqFlag = m_objTradingPolicyDTO.PreClrTradesApprovalReqFlag,
                             inp_iPreClrSingleTransTradeNoShares = m_objTradingPolicyDTO.PreClrSingleTransTradeNoShares,
                             inp_iPreClrSingleTransTradePercPaidSubscribedCap = m_objTradingPolicyDTO.PreClrSingleTransTradePercPaidSubscribedCap,
                             inp_bPreClrProhibitNonTradePeriodFlag = m_objTradingPolicyDTO.PreClrProhibitNonTradePeriodFlag,
                             inp_iPreClrCOApprovalLimit = m_objTradingPolicyDTO.PreClrCOApprovalLimit,
                             inp_iPreClrApprovalValidityLimit = m_objTradingPolicyDTO.PreClrApprovalValidityLimit,
                             inp_bPreClrSeekDeclarationForUPSIFlag = m_objTradingPolicyDTO.PreClrSeekDeclarationForUPSIFlag,
                             inp_sPreClrUPSIDeclaration = m_objTradingPolicyDTO.PreClrUPSIDeclaration,
                             inp_bPreClrReasonForNonTradeReqFlag = m_objTradingPolicyDTO.PreClrReasonForNonTradeReqFlag,
                             inp_bPreClrCompleteTradeNotDoneFlag = m_objTradingPolicyDTO.PreClrCompleteTradeNotDoneFlag,
                             inp_bPreClrPartialTradeNotDoneFlag = m_objTradingPolicyDTO.PreClrPartialTradeNotDoneFlag,
                             inp_iPreClrTradeDiscloLimit = m_objTradingPolicyDTO.PreClrTradeDiscloLimit,
                             inp_iPreClrTradeDiscloShareholdLimit = m_objTradingPolicyDTO.PreClrTradeDiscloShareholdLimit,
                             inp_bStExSubmitTradeDiscloAllTradeFlag = m_objTradingPolicyDTO.StExSubmitTradeDiscloAllTradeFlag,
                             inp_iStExSingMultiTransTradeFlagCodeId = m_objTradingPolicyDTO.StExSingMultiTransTradeFlagCodeId,
                             inp_iStExMultiTradeFreq = m_objTradingPolicyDTO.StExMultiTradeFreq,
                             inp_iStExMultiTradeCalFinYear = m_objTradingPolicyDTO.StExMultiTradeCalFinYear,
                             inp_iStExTransTradeNoShares = m_objTradingPolicyDTO.StExTransTradeNoShares,
                             inp_iStExTransTradePercPaidSubscribedCap = m_objTradingPolicyDTO.StExTransTradePercPaidSubscribedCap,
                             inp_iStExTransTradeShareValue = m_objTradingPolicyDTO.StExTransTradeShareValue,
                             inp_iStExTradeDiscloSubmitLimit = m_objTradingPolicyDTO.StExTradeDiscloSubmitLimit,
                             inp_bDiscloInitReqFlag = m_objTradingPolicyDTO.DiscloInitReqFlag,
                             inp_iDiscloInitLimit = m_objTradingPolicyDTO.DiscloInitLimit,
                             inp_dtDiscloInitDateLimit = m_objTradingPolicyDTO.DiscloInitDateLimit,
                             inp_bDiscloPeriodEndReqFlag = m_objTradingPolicyDTO.DiscloPeriodEndReqFlag,
                             inp_iDiscloPeriodEndFreq = m_objTradingPolicyDTO.DiscloPeriodEndFreq,
                             inp_sGenSecurityType = m_objTradingPolicyDTO.GenSecurityType,
                             inp_bGenTradingPlanTransFlag = m_objTradingPolicyDTO.GenTradingPlanTransFlag,
                             inp_iGenMinHoldingLimit = m_objTradingPolicyDTO.GenMinHoldingLimit,
                             inp_iGenContraTradeNotAllowedLimit = m_objTradingPolicyDTO.GenContraTradeNotAllowedLimit,
                             inp_sGenExceptionFor = m_objTradingPolicyDTO.GenExceptionFor,
                             inp_iTradingPolicyStatusCodeId = m_objTradingPolicyDTO.TradingPolicyStatusCodeId,
                             inp_bDiscloInitSubmitToStExByCOFlag = m_objTradingPolicyDTO.DiscloInitSubmitToStExByCOFlag,
                             inp_bStExSubmitDiscloToStExByCOFlag = m_objTradingPolicyDTO.StExSubmitDiscloToStExByCOFlag,
                             inp_iDiscloPeriodEndToCOByInsdrLimit = m_objTradingPolicyDTO.DiscloPeriodEndToCOByInsdrLimit,
                             inp_bDiscloPeriodEndSubmitToStExByCOFlag = m_objTradingPolicyDTO.DiscloPeriodEndSubmitToStExByCOFlag,
                             inp_iDiscloPeriodEndSubmitToStExByCOLimit = m_objTradingPolicyDTO.DiscloPeriodEndSubmitToStExByCOLimit,
                             inp_bDiscloInitReqSoftcopyFlag = m_objTradingPolicyDTO.DiscloInitReqSoftcopyFlag,
                             inp_bDiscloInitReqHardcopyFlag = m_objTradingPolicyDTO.DiscloInitReqHardcopyFlag,
                             inp_bDiscloInitSubmitToStExByCOSoftcopyFlag = m_objTradingPolicyDTO.DiscloInitSubmitToStExByCOSoftcopyFlag,
                             inp_bDiscloInitSubmitToStExByCOHardcopyFlag = m_objTradingPolicyDTO.DiscloInitSubmitToStExByCOHardcopyFlag,
                             inp_iStExTradePerformDtlsSubmitToCOByInsdrLimit = m_objTradingPolicyDTO.StExTradePerformDtlsSubmitToCOByInsdrLimit,
                             inp_bStExSubmitDiscloToStExByCOSoftcopyFlag = m_objTradingPolicyDTO.StExSubmitDiscloToStExByCOSoftcopyFlag,
                             inp_bStExSubmitDiscloToStExByCOHardcopyFlag = m_objTradingPolicyDTO.StExSubmitDiscloToStExByCOHardcopyFlag,
                             inp_bDiscloPeriodEndReqSoftcopyFlag = m_objTradingPolicyDTO.DiscloPeriodEndReqSoftcopyFlag,
                             inp_bDiscloPeriodEndReqHardcopyFlag = m_objTradingPolicyDTO.DiscloPeriodEndReqHardcopyFlag,
                             inp_bDiscloPeriodEndSubmitToStExByCOSoftcopyFlag = m_objTradingPolicyDTO.DiscloPeriodEndSubmitToStExByCOSoftcopyFlag,
                             inp_bDiscloPeriodEndSubmitToStExByCOHardcopyFlag = m_objTradingPolicyDTO.DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
                             inp_bStExSubmitDiscloToCOByInsdrFlag = m_objTradingPolicyDTO.StExSubmitDiscloToCOByInsdrFlag,
                             inp_bStExSubmitDiscloToCOByInsdrSoftcopyFlag = m_objTradingPolicyDTO.StExSubmitDiscloToCOByInsdrSoftcopyFlag,
                             inp_bStExSubmitDiscloToCOByInsdrHardcopyFlag = m_objTradingPolicyDTO.StExSubmitDiscloToCOByInsdrHardcopyFlag,
                             inp_bPreClrForAllSecuritiesFlag = m_objTradingPolicyDTO.PreClrForAllSecuritiesFlag,
                             inp_bStExForAllSecuritiesFlag = m_objTradingPolicyDTO.StExForAllSecuritiesFlag,
                             inp_sSelectedPreClearancerequiredforTransactionValue = m_objTradingPolicyDTO.SelectedPreClearancerequiredforTransactionValue,
                             inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue = m_objTradingPolicyDTO.SelectedPreClearanceProhibitforNonTradingforTransactionValue,
                             inp_tblPreClearanceSecuritywise = inp_tblPreclearanceSecuritywise,
                             inp_tblContinousSecuritywise = inp_tblContinousSecuritywise,
                             inp_tblPreclearanceTransactionSecurityMap = inp_tblPreclearanceTransactionSecurityMap,
                             inp_bPreClrAllowNewForOpenPreclearFlag = m_objTradingPolicyDTO.PreClrAllowNewForOpenPreclearFlag,
                             inp_iPreClrMultipleAboveInCodeId = m_objTradingPolicyDTO.PreClrMultipleAboveInCodeId,
                             inp_iPreClrApprovalPreclearORPreclearTradeFlag = m_objTradingPolicyDTO.PreClrApprovalPreclearORPreclearTradeFlag,
                             inp_bPreClrTradesAutoApprovalReqFlag = m_objTradingPolicyDTO.PreClrTradesAutoApprovalReqFlag,
                             inp_iPreClrSingMultiPreClrFlagCodeId = m_objTradingPolicyDTO.PreClrSingMultiPreClrFlagCodeId,
                             inp_iGenCashAndCashlessPartialExciseOptionForContraTrade = m_objTradingPolicyDTO.GenCashAndCashlessPartialExciseOptionForContraTrade,
                             inp_bGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = m_objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate,
                             @inp_bTradingThresholdLimtResetFlag = m_objTradingPolicyDTO.TradingThresholdLimtResetFlag,
                             @inp_nContraTradeBasedOn = m_objTradingPolicyDTO.ContraTradeBasedOn,
                             inp_sSelectedContraTradeSecuirtyType = m_objTradingPolicyDTO.SelectedContraTradeSecuirtyType,
                             inp_nUserId = m_objTradingPolicyDTO.LoggedInUserId,
                             //New column added on 2-Jun-2016(YES BANK customization)
                             inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag = m_objTradingPolicyDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag,
                             inp_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = m_objTradingPolicyDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures,
                             inp_DeclarationToBeMandatoryFlag = m_objTradingPolicyDTO.DeclarationToBeMandatoryFlag,
                             inp_DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = m_objTradingPolicyDTO.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag,
                             @inp_bIsPreclearanceFormForImplementingCompany = m_objTradingPolicyDTO.IsPreclearanceFormForImplementingCompany,
                             @inp_iPreclearanceWithoutPeriodEndDisclosure = m_objTradingPolicyDTO.PreclearanceWithoutPeriodEndDisclosure,
                             @inp_PreClrApprovalReasonReqFlag=m_objTradingPolicyDTO.PreClrApprovalReasonReqFlag,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage

                         }).SingleOrDefault<TradingPolicyDTO>();

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
       /// <summary>
       /// This method is used for the get details for trading policy details.
       /// </summary>
       /// <param name="i_sConnectionString">DB COnnection string</param>
       /// <param name="i_nTradingPolicyId">Trading Policy ID</param>
       /// <returns></returns>
       public InsiderTradingDAL.TradingPolicyDTO_OS GetDetails(string i_sConnectionString, int i_nTradingPolicyId)
       {
           TradingPolicyDTO_OS res = null;
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
                       res = db.Query<TradingPolicyDTO_OS>("exec  st_rul_TradingPolicyDetails_OS @inp_iTradingPolicyId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iTradingPolicyId = i_nTradingPolicyId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).FirstOrDefault<TradingPolicyDTO_OS>();

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
       #endregion GetUserDetails

       #region Delete
       /// <summary>
       /// This method is used for the delete Trading Policy
       /// </summary>
       /// <param name="i_sConnectionString">DB COnnection string</param>
       /// <param name="i_nTradingPolicyId">Trading Policy ID</param>
       /// <param name="inp_nUserId">Logged In User ID</param>
       /// <returns></returns>
       public bool Delete(string i_sConnectionString, int i_nTradingPolicyId, int inp_nUserId)
       {
           TradingPolicyDTO res = null;
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

                       res = db.Query<TradingPolicyDTO>("exec  st_rul_TradingPolicyDelete @inp_iTradingPolicyId, @inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iTradingPolicyId = i_nTradingPolicyId,
                               inp_nUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<TradingPolicyDTO>();

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

       #region Get Applicable Trading Policy Details
       /// <summary>
       /// This methos is used for the Get Applicable Trading Policy Details 
       /// </summary>
       /// <param name="i_sConnectionString"></param>
       /// <param name="i_nUserInfoID"></param>
       /// <returns></returns>
       public InsiderTradingDAL.ApplicableTradingPolicyDetailsDTO_OS GetApplicableTradingPolicyDetails(string i_sConnectionString, int i_nUserInfoID, Int64 i_nTrasactionMasterId = 0)
       {
           ApplicableTradingPolicyDetailsDTO_OS res = null;
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

               using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
               {
                   using (var scope = db.GetTransaction())
                   {
                       res = db.Query<ApplicableTradingPolicyDetailsDTO_OS>("exec  st_rul_ApplicableTradingPolicyDetails_OS @inp_iUserInfoID,@inp_iTransacationMasterId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iUserInfoID = i_nUserInfoID,
                               @inp_iTransacationMasterId = i_nTrasactionMasterId,

                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).FirstOrDefault<ApplicableTradingPolicyDetailsDTO_OS>();

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
       #endregion Get Applicable Trading Policy Details

       #region GetUserwiseOverlapTradingPolicyCount
       /// <summary>
       /// This method is used for the get details for trading policy details.
       /// </summary>
       /// <param name="i_sConnectionString">DB COnnection string</param>
       /// <param name="i_nTradingPolicyId">Trading Policy ID</param>
       /// <returns></returns>
       public InsiderTradingDAL.TradingPolicyDTO GetUserwiseOverlapTradingPolicyCount(string i_sConnectionString, int i_nTradingPolicyId, out int out_nCountUserAndOverlapTradingPolicy)
       {
           TradingPolicyDTO res = null;
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
               var nCountUserAndOverlapTradingPolicy = new SqlParameter("@out_nCountUserAndOverlapTradingPolicy", System.Data.SqlDbType.Int);
               nCountUserAndOverlapTradingPolicy.Direction = System.Data.ParameterDirection.Output;

               using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
               {
                   db.CommandTimeout = 5000;
                   using (var scope = db.GetTransaction())
                   {
                       res = db.Query<TradingPolicyDTO>("exec  st_rul_UserwiseOverlapTradingPolicyCount @inp_iTradingPolicyId,@out_nCountUserAndOverlapTradingPolicy OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iTradingPolicyId = i_nTradingPolicyId,
                               out_nCountUserAndOverlapTradingPolicy = nCountUserAndOverlapTradingPolicy,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).FirstOrDefault<TradingPolicyDTO>();

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
                           out_nCountUserAndOverlapTradingPolicy = Convert.ToInt32(nCountUserAndOverlapTradingPolicy.Value);
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
       #endregion GetUserwiseOverlapTradingPolicyCount

       #region TransactionSecurityMapConfigList
     /// <summary>
       /// This method is used for fetching Transaction Security Map Config List
     /// </summary>
     /// <param name="i_sConnectionString">DB Connection string</param>
     /// <param name="i_nTransactionTypeCodeId">Transaction Type Code ID</param>
     /// <returns></returns>
       public IEnumerable<TransactionSecurityMapConfigDTO> TransactionSecurityMapConfigList(string i_sConnectionString, int? i_nTransactionTypeCodeId)
       {
           IEnumerable<TransactionSecurityMapConfigDTO> res = null;
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
             

               using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
               {
                   using (var scope = db.GetTransaction())
                   {
                       res = db.Query<TransactionSecurityMapConfigDTO>("exec  st_rul_TransactionSecurityMapConfigList @inp_iTransactionTypeCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iTransactionTypeCodeId = i_nTransactionTypeCodeId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<TransactionSecurityMapConfigDTO>();

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
       #endregion TransactionSecurityMapConfigList

       #region TradingPolicyForTransactionSecurityList
     /// <summary>
       /// This method is used for get Trading Policy For Transaction Security List
     /// </summary>
     /// <param name="i_sConnectionString">DB Connection string</param>
     /// <param name="i_nTradingPolicyId">Trading Policy ID</param>
     /// <param name="i_nMapToTypeCodeId">Map To Type code ID</param>
     /// <returns></returns>
       public IEnumerable<TradingPolicyForTransactionSecurityDTO> TradingPolicyForTransactionSecurityList(string i_sConnectionString,
           int? i_nTradingPolicyId, int i_nMapToTypeCodeId)
       {
           IEnumerable<TradingPolicyForTransactionSecurityDTO> res = null;
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


               using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
               {
                   using (var scope = db.GetTransaction())
                   {
                       res = db.Query<TradingPolicyForTransactionSecurityDTO>("exec st_rul_TradingPolicyForTransactionSecurityList @inp_iTradingPolicyId,@inp_iMapToTypeCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iTradingPolicyId = i_nTradingPolicyId,
                               inp_iMapToTypeCodeId = i_nMapToTypeCodeId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<TradingPolicyForTransactionSecurityDTO>();

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
       #endregion TradingPolicyForTransactionSecurityList

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
