using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;
using System.Data;

namespace InsiderTrading.SL
{
    public class TradingTransactionSL:IDisposable
    {
        #region GetTradingTransactionDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.TradingTransactionDTO GetTradingTransactionDetails(string i_sConnectionString, int m_iTransactionDetailsId)
        {
            InsiderTradingDAL.TradingTransactionDTO res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    res = objTradingTransactionDAL.GetDetails(i_sConnectionString, m_iTransactionDetailsId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetTradingTransactionDetails

        #region GetTradingTransactionMasterDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.TradingTransactionMasterDTO GetTradingTransactionMasterDetails(string i_sConnectionString, Int64 m_iTransactionMasterId)
        {
            InsiderTradingDAL.TradingTransactionMasterDTO res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    res = objTradingTransactionDAL.GetTransactionMasterDetails(i_sConnectionString, m_iTransactionMasterId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetTradingTransactionMasterDetails

        #region GetTradingTransactionMasterCreate
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.TradingTransactionMasterDTO GetTradingTransactionMasterCreate(string i_sConnectionString, 
                                TradingTransactionMasterDTO objTradingTransactionMasterDTO, int i_nLoggedInUserId,out int o_iDisclosureCompletedFlag)
        {
            InsiderTradingDAL.TradingTransactionMasterDTO res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    res = objTradingTransactionDAL.GetTransactionMasterCreate(i_sConnectionString, objTradingTransactionMasterDTO, i_nLoggedInUserId, out o_iDisclosureCompletedFlag);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetTradingTransactionMasterCreate

        #region InsertUpdateTradingTransactionDetails
        /// <summary>
        /// This method is used for the insert/Update trading transaction details for CD, preclearance and period end disclosure.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public TradingTransactionDTO InsertUpdateTradingTransactionDetails(string i_sConnectionString, TradingTransactionDTO i_objTradingTransactionDTO, int i_nLoggedInUserID)
        {
            TradingTransactionDTO objTradingTransactionDTO = null;
            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    objTradingTransactionDTO = objTradingTransactionDAL.InsertUpdateTradingTransactionDetails(i_sConnectionString, i_objTradingTransactionDTO, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objTradingTransactionDTO;
        }
        #endregion InsertUpdateTradingTransactionDetails


        #region InsertUpdateIDTradingTransactionDetails
        /// <summary>
        /// This method is used to save Initial Disclosure List
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public bool InsertUpdateIDTradingTransactionDetails(string i_sConnectionString, DataTable dt_InitialDiscList)
        {
            bool IsSave = false;
            try
            {
                using (TradingTransactionDAL objTradingTransactionDAL = new TradingTransactionDAL())
                {
                    IsSave = objTradingTransactionDAL.InsertUpdateIDTradingTransactionDetails(i_sConnectionString, dt_InitialDiscList);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return IsSave;

        }
        #endregion InsertUpdateIDTradingTransactionDetails


        #region DeleteTradingTransactionDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public bool DeleteTradingTransactionDetails(string i_sConnectionString, int m_iTransactionDetailsId, int i_nLoggedInUserID)
        {
            bool bReturn = false;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    bReturn = objTradingTransactionDAL.DeleteTradingTransactionDetails(i_sConnectionString, m_iTransactionDetailsId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteTradingTransactionDetails

        #region DeleteTradingTransactionMaster
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public bool DeleteTradingTransactionMaster(string i_sConnectionString, int m_iTransactionMasterId, int i_nLoggedInUserID)
        {
            bool bReturn = false;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    bReturn = objTradingTransactionDAL.DeleteTradingTransactionMaster(i_sConnectionString, m_iTransactionMasterId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteTradingTransactionMaster

        #region GetTransactionLetterDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public TemplateMasterDTO GetTransactionLetterDetails(string i_sConnectionString, Int64 i_nTransactionLetterId, Int64 i_nTransactionMasterId, int i_nDisclosureTypeCodeId, int i_nLetterForCodeId, int i_nCommunicationModeCodeId)
        {
            TemplateMasterDTO objTemplateMasterDTO = new TemplateMasterDTO();
            try
            {
                //TradingTransactionDAL objTradingTransactionDAL = new TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    objTemplateMasterDTO = objTradingTransactionDAL.GetTransactionLetterDetails(i_sConnectionString, i_nTransactionLetterId, i_nTransactionMasterId, i_nDisclosureTypeCodeId, i_nLetterForCodeId, i_nCommunicationModeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objTemplateMasterDTO;
        }
        #endregion GetTransactionLetterDetails

        #region InsertUpdateTradingTransactionLetterDetails
        /// <summary>
        /// This method is used for the insert/Update trading transaction letter details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objTransactionLetterDTO">Trading Transaction letter Object</param>
        /// <param name="i_nLoggedInUserID">Logged In User ID</param>
        /// <returns></returns>
        public TemplateMasterDTO InsertUpdateTradingTransactionLetterDetails(string i_sConnectionString, TemplateMasterDTO i_objTemplateMasterDTO, int i_nLoggedInUserID)
        {
            TemplateMasterDTO objTemplateMasterDTO = new TemplateMasterDTO();
            try
            {
                //TradingTransactionDAL objTradingTransactionDAL = new TradingTransactionDAL();
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    objTemplateMasterDTO = objTradingTransactionDAL.InsertUpdateTradingTransactionLetterDetails(i_sConnectionString, i_objTemplateMasterDTO, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objTemplateMasterDTO;
        }
        #endregion InsertUpdateTradingTransactionLetterDetails

        #region GetTransactionSummary
        public TradingTransactionSummaryDTO GetTransactionSummary(string sConnectionString, Int64 m_iTransactionMasterId, Int64 m_iPreclearanceId)
        {
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    return objTradingTransactionDAL.GetTransactionSummary(sConnectionString, m_iTransactionMasterId, m_iPreclearanceId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
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
        public bool IsAllowNegativeBalanceForSecurity(int nSecuirtyTypeCodeID, string sConnectionString)
        {
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    return objTradingTransactionDAL.IsAllowNegativeBalanceForSecurity(nSecuirtyTypeCodeID, sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion IsAllowNegativeBalanceForSecurity

        #region TradingTransactionConfirmHoldingsFor
        public int TradingTransactionConfirmHoldingsFor(Int64 nTransactionMasterId, int nConfirmCompanyHoldingsFor, int nConfirmNonCompanyHoldingsFor, int nLoggedInUserId, string sConnectionString, string sLookupPrefix = "usr_com_")
        {
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    return objTradingTransactionDAL.TradingTransactionConfirmHoldingsFor(nTransactionMasterId, nConfirmCompanyHoldingsFor, nConfirmNonCompanyHoldingsFor, nLoggedInUserId, sConnectionString, sLookupPrefix);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion TradingTransactionConfirmHoldingsFor

        #region GetCountforContinuousDisclosureStatus
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get Continuous Disclosure Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_UserInfoId">User Info Id</param>
        /// <param name="dtEndDate">Period End Date</param>
        /// <returns>Object ContinuousDisclosureStatus DTO</returns>

        public List<ContinuousDisclosureStatusDTO> Get_ContinuousDisclosureStatus(string i_sConnectionString, int i_UserInfoId, DateTime dtEndDate)
        {
            List<ContinuousDisclosureStatusDTO> lstContinuousDisclosureStatus = new List<ContinuousDisclosureStatusDTO>();

            try
            {
                using (var objContDisStatusDAL = new TradingTransactionDAL())
                {
                    lstContinuousDisclosureStatus = objContDisStatusDAL.GetContinuousDisclosureStatus(i_sConnectionString, i_UserInfoId, dtEndDate).ToList<ContinuousDisclosureStatusDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstContinuousDisclosureStatus;
        }
        #endregion GetCountforContinuousDisclosureStatus

        #region GetCountforPEDisclosureStatus
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get pending PE disclosure count
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_UserInfoId">User Info Id</param>
        /// <param name="dtEndDate">Period End Date</param>
        /// <returns>Object ContinuousDisclosureStatus DTO</returns>

        public List<ContinuousDisclosureStatusDTO> Get_PEDisclosureStatus(string i_sConnectionString, int i_UserInfoId, DateTime dtEndDate)
        {
            List<ContinuousDisclosureStatusDTO> lstPEDisclosureStatus = new List<ContinuousDisclosureStatusDTO>();

            try
            {
                using (var objContDisStatusDAL = new TradingTransactionDAL())
                {
                    lstPEDisclosureStatus = objContDisStatusDAL.GetPEDisclosureStatus(i_sConnectionString, i_UserInfoId, dtEndDate).ToList<ContinuousDisclosureStatusDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstPEDisclosureStatus;
        }
        #endregion GetCountforPEDisclosureStatus


        #region Get_CDTransIdduringPE
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<TradingTransactionMasterDTO> Get_CDTransIdduringPE(TradingTransactionMasterDTO objTradingTransactionMasterDTO, string i_sConnectionString, bool cdDuringPE)
        {
            List<TradingTransactionMasterDTO> lstTransId = new List<TradingTransactionMasterDTO>();
            try
            {
               using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    lstTransId = objTradingTransactionDAL.GetCDTransIdduringPE(objTradingTransactionMasterDTO, i_sConnectionString, cdDuringPE).ToList<TradingTransactionMasterDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstTransId;
        }
        #endregion Get_CDTransIdduringPE

        #region CheckDuplicateTransaction
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<DuplicateTransactionDetailsDTO> CheckDuplicateTransaction(string i_sConnectionString, int nLoggedInUserId, int nSecurityType, int nTransactionType, DateTime? dtTransactionDate, long nTransactionId)
        {
            List<DuplicateTransactionDetailsDTO> objDuplicateTransactionsDTO = new List<DuplicateTransactionDetailsDTO>();
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    objDuplicateTransactionsDTO = objTradingTransactionDAL.CheckDuplicateTransaction(i_sConnectionString, nLoggedInUserId, nSecurityType, nTransactionType, dtTransactionDate, nTransactionId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDuplicateTransactionsDTO;
        }
        #endregion CheckDuplicateTransaction


        public List<ApprovedPCLDTO> GetApprovedPCLCntSL(string i_sConnectionString, int i_UserInfoId)
        {
            List<ApprovedPCLDTO> lstApprovedPCLStatus = new List<ApprovedPCLDTO>();

            try
            {
                using (var objTradingTransactionDAL = new TradingTransactionDAL())
                {
                    lstApprovedPCLStatus = objTradingTransactionDAL.GetApprovedPCLCnt(i_sConnectionString, i_UserInfoId).ToList<ApprovedPCLDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstApprovedPCLStatus;
        }

        #region Get_PanNumber
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<TradingTransactionMasterDTO> Get_PanNumber(TradingTransactionMasterDTO objTradingTransactionMasterDTO, string i_sConnectionString)
        {
            List<TradingTransactionMasterDTO> lstPanNo = new List<TradingTransactionMasterDTO>();
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL())
                {
                    lstPanNo = objTradingTransactionDAL.GetPanNumber(objTradingTransactionMasterDTO, i_sConnectionString).ToList<TradingTransactionMasterDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstPanNo;
        }
        #endregion Get_PanNumber

    }
}