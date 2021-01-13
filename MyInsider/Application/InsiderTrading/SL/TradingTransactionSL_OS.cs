using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;
using System.Data;

namespace InsiderTrading.SL
{
    public class TradingTransactionSL_OS : IDisposable
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
        public InsiderTradingDAL.TradingTransactionDTO_OS GetTradingTransactionDetails(string i_sConnectionString, int m_iTransactionDetailsId)
        {
            InsiderTradingDAL.TradingTransactionDTO_OS res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    res = objTradingTransactionDAL_OS.GetDetails(i_sConnectionString, m_iTransactionDetailsId);
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
        public InsiderTradingDAL.TradingTransactionMasterDTO_OS GetTradingTransactionMasterDetails(string i_sConnectionString, Int64 m_iTransactionMasterId)
        {
            InsiderTradingDAL.TradingTransactionMasterDTO_OS res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    res = objTradingTransactionDAL_OS.GetTransactionMasterDetails(i_sConnectionString, m_iTransactionMasterId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetTradingTransactionMasterDetails

        public InsiderTradingDAL.TradingTransactionMasterDTO_OS GetQuantity(string sConnectionString, int m_iDisclosureTypeCodeId, int m_iUserInfoId)
        {
            InsiderTradingDAL.TradingTransactionMasterDTO_OS res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    res= objTradingTransactionDAL_OS.GetQunatityValue(sConnectionString, m_iDisclosureTypeCodeId, m_iUserInfoId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #region Get_mst_company_details
        /// <summary>
        /// This method is used for the Get mst_company details.
        /// </summary>
        /// <returns></returns>
        public InsiderTradingDAL.TradingTransactionMasterDTO_OS Get_mst_company_details(string i_sConnectionString)
        {
            try
            {
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    return objTradingTransactionDAL_OS.Get_mst_company_details(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Get_mst_company_details

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
        public InsiderTradingDAL.TradingTransactionMasterDTO_OS GetTradingTransactionMasterCreate(string i_sConnectionString,
                                TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS, int i_nLoggedInUserId, out int o_iDisclosureCompletedFlag)
        {
            InsiderTradingDAL.TradingTransactionMasterDTO_OS res = null;

            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    res = objTradingTransactionDAL_OS.GetTransactionMasterCreate(i_sConnectionString, objTradingTransactionMasterDTO_OS, i_nLoggedInUserId, out o_iDisclosureCompletedFlag);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetTradingTransactionMasterCreate

        #region InsertTransactionFormDetails
        /// <summary>
        /// This method is used for the insert/Update trading transaction details for CD, preclearance and period end disclosure.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public bool InsertTransactionFormDetails(string i_sConnectionString, TransactionLetterDTO_OS i_objTransactionLetterDTO_OS)
        {
            bool IsSave = false;
            try
            {
                using (TradingTransactionDAL_OS objTradingTransactionDAL_OS = new TradingTransactionDAL_OS())
                {
                    IsSave = objTradingTransactionDAL_OS.InsertTransactionFormDetails(i_sConnectionString, i_objTransactionLetterDTO_OS);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return IsSave;

        }
        #endregion InsertTransactionFormDetails

        #region InsertTransactionFormDetails_ForTrade
        /// <summary>
        /// This method is used for the insert/Update trading transaction details for CD, preclearance and period end disclosure.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public bool InsertTransactionFormDetails_ForTrade(string i_sConnectionString, TransactionLetterDTO_OS i_objTransactionLetterDTO_OS)
        {
            bool IsSave = false;
            try
            {
                using (TradingTransactionDAL_OS objTradingTransactionDAL_OS = new TradingTransactionDAL_OS())
                {
                    IsSave = objTradingTransactionDAL_OS.InsertTransactionFormDetails_ForTrade(i_sConnectionString, i_objTransactionLetterDTO_OS);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return IsSave;

        }
        #endregion InsertTransactionFormDetails_ForTrade
        #region InsertTransactionFormDetails_ForPeriodEnd
        /// <summary>
        /// InsertTransactionFormDetails_ForPeriodEnd
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objTransactionLetterDTO_OS"></param>
        /// <returns></returns>
        public bool InsertTransactionFormDetails_ForPeriodEnd(string i_sConnectionString, TransactionLetterDTO_OS i_objTransactionLetterDTO_OS)
        {
            bool IsSave = false;
            try
            {
                using (TradingTransactionDAL_OS objTradingTransactionDAL_OS = new TradingTransactionDAL_OS())
                {
                    IsSave = objTradingTransactionDAL_OS.InsertTransactionFormDetails_ForPeriodEnd(i_sConnectionString, i_objTransactionLetterDTO_OS);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return IsSave;

        }
        #endregion InsertTransactionFormDetails_ForPeriodEnd
        #region InsertUpdateTradingTransactionDetails
        /// <summary>
        /// This method is used for the insert/Update trading transaction details for CD, preclearance and period end disclosure.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public TradingTransactionDTO_OS InsertUpdateTradingTransactionDetails(string i_sConnectionString, TradingTransactionDTO_OS i_objTradingTransactionDTO_OS, int i_nLoggedInUserID)
        {
            TradingTransactionDTO_OS objTradingTransactionDTO_OS = null;
            try
            {
                //InsiderTradingDAL.TradingTransactionDAL objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL();
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    objTradingTransactionDTO_OS = objTradingTransactionDAL_OS.InsertUpdateTradingTransactionDetails(i_sConnectionString, i_objTradingTransactionDTO_OS, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objTradingTransactionDTO_OS;
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
                using (TradingTransactionDAL_OS objTradingTransactionDAL_OS = new TradingTransactionDAL_OS())
                {
                    IsSave = objTradingTransactionDAL_OS.InsertUpdateIDTradingTransactionDetails(i_sConnectionString, dt_InitialDiscList);
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
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    bReturn = objTradingTransactionDAL_OS.DeleteTradingTransactionDetails(i_sConnectionString, m_iTransactionDetailsId, i_nLoggedInUserID);
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
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL_OS())
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
        public TradingTransactionSummaryDTO_OS GetTransactionSummary(string sConnectionString, Int64 m_iTransactionMasterId, Int64 m_iPreclearanceId)
        {
            try
            {
                using (var objTradingTransactionDAL = new InsiderTradingDAL.TradingTransactionDAL_OS())
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

        #region GetCountforPEDisclosureStatus_OS
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
            List<ContinuousDisclosureStatusDTO> lstPEDisclosureStatus_OS = new List<ContinuousDisclosureStatusDTO>();

            try
            {
                using (var objContDisStatusDAL_OS = new TradingTransactionDAL_OS())
                {
                    lstPEDisclosureStatus_OS = objContDisStatusDAL_OS.GetPEDisclosureStatus(i_sConnectionString, i_UserInfoId, dtEndDate).ToList<ContinuousDisclosureStatusDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstPEDisclosureStatus_OS;
        }
        #endregion GetCountforPEDisclosureStatus_OS


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

        #region CheckDuplicateTransaction_OS
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<DuplicateTransactionDetailsDTO_OS> CheckDuplicateTransaction_OS(string i_sConnectionString, int nLoggedInUserId, int nDMATDetailsID, int nSecurityType, int CompanyId, long nTransactionDetailsId)
        {
            List<DuplicateTransactionDetailsDTO_OS> objDuplicateTransactionsDTO_OS = new List<DuplicateTransactionDetailsDTO_OS>();
            try
            {
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    objDuplicateTransactionsDTO_OS = objTradingTransactionDAL_OS.CheckDuplicateTransaction_OS(i_sConnectionString, nLoggedInUserId, nDMATDetailsID, nSecurityType, CompanyId, nTransactionDetailsId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDuplicateTransactionsDTO_OS;
        }
        #endregion CheckDuplicateTransaction_OS


        #region CheckIntialDisclosureNoHolding_OS
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<DuplicateTransactionDetailsDTO_OS> CheckIntialDisclosureNoHolding_OS(string i_sConnectionString, int nTradingTransactionMasterId)
        {
            List<DuplicateTransactionDetailsDTO_OS> objDuplicateTransactionsDTO_OS = new List<DuplicateTransactionDetailsDTO_OS>();
            try
            {
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    objDuplicateTransactionsDTO_OS = objTradingTransactionDAL_OS.CheckIntialDisclosureNoHolding_OS(i_sConnectionString, nTradingTransactionMasterId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDuplicateTransactionsDTO_OS;
        }
        #endregion CheckIntialDisclosureNoHolding_OS


        public List<ApprovedPCLDTO_OS> GetApprovedPCLCntSL(string i_sConnectionString, int i_UserInfoId)
        {
            List<ApprovedPCLDTO_OS> lstApprovedPCLStatus_OS = new List<ApprovedPCLDTO_OS>();

            try
            {
                using (var objTradingTransactionDAL_OS = new TradingTransactionDAL_OS())
                {
                    lstApprovedPCLStatus_OS = objTradingTransactionDAL_OS.GetApprovedPCLCnt(i_sConnectionString, i_UserInfoId).ToList<ApprovedPCLDTO_OS>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstApprovedPCLStatus_OS;
        }

        #region Get_PanNumber_OS
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public List<TradingTransactionMasterDTO_OS> Get_PanNumber_OS(TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO, string i_sConnectionString)
        {
            List<TradingTransactionMasterDTO_OS> lstPanNo_OS = new List<TradingTransactionMasterDTO_OS>();
            try
            {
                using (var objTradingTransactionDAL_OS = new InsiderTradingDAL.TradingTransactionDAL_OS())
                {
                    lstPanNo_OS = objTradingTransactionDAL_OS.GetPanNumber_OS(objTradingTransactionMasterDTO, i_sConnectionString).ToList<TradingTransactionMasterDTO_OS>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstPanNo_OS;
        }
        #endregion Get_PanNumber_OS
    }
}