using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace InsiderTrading.SL
{
    public class PreclearanceRequestNonImplCompanySL : IDisposable
    {

        #region Save Pre-clearance request
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool SavePreclearanceRequest(string i_sConnectionString, DataTable dt_PreClearanceList)
        {
            bool IsSave = false;
            try
            {
                using (PreclearanceRequestNonImplCompanyDAL objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    IsSave = objPreclearanceRequestNonImplCompanyDAL.SavePreclearanceRequest(i_sConnectionString, dt_PreClearanceList);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return IsSave;

        }
        #endregion Save Pre-clearance request

        #region Get reqested pre-clearance request details
        /// <summary>
        /// This method is used to get pre-clearance request details
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nPreclearanceRequestId"></param>
        /// <returns></returns>
        public PreclearanceRequestNonImplCompanyDTO GetPreclearanceRequestDetail(string sConnectionString, long nPreclearanceRequestId)
        {
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
            try
            {
                using (PreclearanceRequestNonImplCompanyDAL objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    objPreclearanceRequestNonImplCompanyDTO = objPreclearanceRequestNonImplCompanyDAL.GetPreclearanceRequestDetail(sConnectionString, nPreclearanceRequestId);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return objPreclearanceRequestNonImplCompanyDTO;

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

        #region Save Pre-clearance request other securities
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool SavePreclearanceRequest_OS(string i_sConnectionString, DataTable dt_PreClearanceList, int? preclearanceRequestId, bool? preclearanceNotTakenFlag, int? reasonForNotTradingCodeId,
            string reasonForNotTradingText, int? userID, string preclearanceStatusCodeId, string reasonForRejection, string reasonForApproval, int? ReasonForApprovalCodeId,int? displaySequenceNo)
        {
            bool returnVal = false;
            try
            {
                using (PreclearanceRequestNonImplCompanyDAL objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    returnVal = objPreclearanceRequestNonImplCompanyDAL.SavePreclearanceRequest_OS(i_sConnectionString, dt_PreClearanceList, preclearanceRequestId, preclearanceNotTakenFlag, reasonForNotTradingCodeId,
               reasonForNotTradingText, userID, preclearanceStatusCodeId, reasonForRejection, reasonForApproval, ReasonForApprovalCodeId, displaySequenceNo);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return returnVal;

        }
        #endregion Save Pre-clearance request other securities

        #region Get Security Balance from Pool for Contra trade check
        /// <summary>
        /// This method is used to get security balance details for user
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="i_nSecurityTypeCodeId"></param>
        /// <returns></returns>
        public BalancePoolOSDTO GetSecurityBalanceDetailsFromPool(string i_sConnectionString, int? i_nUserInfoId, int i_nSecurityTypeCodeId, int i_nDMATDetailsID, int i_nCompanyID)
        {
            BalancePoolOSDTO objExerciseBalancePoolDTO = null;

            try
            {
                //PreclearanceRequestDAL objPreclearanceRequestDAL = new PreclearanceRequestDAL();
                using (var objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    objExerciseBalancePoolDTO = objPreclearanceRequestNonImplCompanyDAL.GetSecurityBalanceDetailsFromPool(i_sConnectionString, i_nUserInfoId, i_nSecurityTypeCodeId, i_nDMATDetailsID, i_nCompanyID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objExerciseBalancePoolDTO;
        }
        #endregion Get Security Balance from Pool for Contra trade check

        #region ValidatePreclearanceRequest
        public int ValidatePreclearanceRequest(string i_sConnectionString, int preclearanceRequestId, int tradingPolicyID, int userInfoId,int? userInfoIdRelative,
                        int transactionTypeCodeId,int securityTypeCodeId,decimal? securitiesToBeTradedQty,decimal? securitiesToBeTradedValue, int companyId,
                        int modeOfAcquisitionCodeId, int DMATDetailsID, out bool out_bIsContraTrade, out string sContraTradeDate, out bool iIsAutoApproved)
        {
            int returnVal = 0;
            try
            {
                using (PreclearanceRequestNonImplCompanyDAL objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    returnVal = objPreclearanceRequestNonImplCompanyDAL.ValidatePreclearanceRequest(i_sConnectionString, preclearanceRequestId, tradingPolicyID, userInfoId,userInfoIdRelative,
                        transactionTypeCodeId, securityTypeCodeId, securitiesToBeTradedQty,securitiesToBeTradedValue, companyId, modeOfAcquisitionCodeId, DMATDetailsID, out out_bIsContraTrade, out sContraTradeDate, out iIsAutoApproved);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return returnVal;
        }
        #endregion

        #region update Pre-clearance approve/reject status
        public bool PreclearanceRequestApproveRejectSave_OS(string sConnectionString, DataTable dt_PreClearanceList, DataTable dt_PreclearanceRequestId, bool? preclearanceNotTakenFlag, int? reasonForNotTradingCodeId,
            string reasonForNotTradingText, int? userID, int preclearanceStatusCodeId, string reasonForRejection, string reasonForApproval, int? ReasonForApprovalCodeId)
        {
            bool returnVal = false;
            using (PreclearanceRequestNonImplCompanyDAL objPreclearanceRequestNonImplCompanyDAL = new PreclearanceRequestNonImplCompanyDAL())
            {
                returnVal = objPreclearanceRequestNonImplCompanyDAL.PreclearanceRequestApproveRejectSave_OS(sConnectionString, dt_PreClearanceList, dt_PreclearanceRequestId, preclearanceNotTakenFlag, reasonForNotTradingCodeId,
            reasonForNotTradingText, userID, preclearanceStatusCodeId, reasonForRejection, reasonForApproval, ReasonForApprovalCodeId);
            }
            return returnVal;
        }
        #endregion update Pre-clearance approve/reject status

        #region GetLastPeriodEndSubmissonFlag
        public InsiderTradingDAL.PreclearanceRequestNonImplCompanyDTO GetLastPeriodEndSubmissonFlag_OS(string i_sConnectionString, int i_nUserInfoID, out int out_nIsPreviousPeriodEndSubmission, out string out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out string out_sSubsequentPeriodEndResourceOtherSecurity)
        {
            try
            {
                using (var objPreclearanceRequestDAL = new PreclearanceRequestNonImplCompanyDAL())
                {
                    return objPreclearanceRequestDAL.GetLastPeriodEndSubmissonFlag_OS(i_sConnectionString, i_nUserInfoID, out out_nIsPreviousPeriodEndSubmission, out out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out out_sSubsequentPeriodEndResourceOtherSecurity);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetLastPeriodEndSubmissonFlag
    }
}