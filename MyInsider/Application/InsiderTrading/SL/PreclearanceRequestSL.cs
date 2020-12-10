using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class PreclearanceRequestSL:IDisposable
    {
        public PreclearanceRequestDTO Save(string i_sConnectionString, PreclearanceRequestDTO m_objPreclearanceRequestDTO, out string out_dtContraTradeTillDate, out string out_sPeriodEnddate, out string out_sApproveddate, out string out_sPreValiditydate, out string out_sProhibitOnPer, out string out_sProhibitOnQuantity)
        {
            try
            {
                using(var objPreclearanceRequestDAL = new PreclearanceRequestDAL()){
                    return objPreclearanceRequestDAL.Save(i_sConnectionString, m_objPreclearanceRequestDTO, out out_dtContraTradeTillDate, out out_sPeriodEnddate, out out_sApproveddate, out out_sPreValiditydate, out out_sProhibitOnPer, out out_sProhibitOnQuantity);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        public InsiderTradingDAL.PreclearanceRequestDTO GetDetails(string i_sConnectionString, long i_nPreclearanceRequestId)
        {
            try
            {
                using (var objPreclearanceRequestDAL = new PreclearanceRequestDAL())
                {
                    return objPreclearanceRequestDAL.GetDetails(i_sConnectionString, i_nPreclearanceRequestId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }


        #region Get Security Balance from Pool for Contra trade check
        /// <summary>
        /// This method is used to get security balance details for user
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="i_nSecurityTypeCodeId"></param>
        /// <returns></returns>
        public ExerciseBalancePoolDTO GetSecurityBalanceDetailsFromPool(string i_sConnectionString, int i_nUserInfoId, int i_nSecurityTypeCodeId, int i_nDMATDetailsID)
        {
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO = null;

            try
            {
                //PreclearanceRequestDAL objPreclearanceRequestDAL = new PreclearanceRequestDAL();
                using (var objPreclearanceRequestDAL = new PreclearanceRequestDAL())
                {
                    objExerciseBalancePoolDTO = objPreclearanceRequestDAL.GetSecurityBalanceDetailsFromPool(i_sConnectionString, i_nUserInfoId, i_nSecurityTypeCodeId, i_nDMATDetailsID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objExerciseBalancePoolDTO;
        }
        #endregion Get Security Balance from Pool for Contra trade check

        #region Get Form E Details

        public InsiderTradingDAL.FormEDetailsDTO GetFormEDetails(string i_sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId)
        {
            try
            {
                using (var objPreclearanceRequestDAL = new PreclearanceRequestDAL())
                {
                    return objPreclearanceRequestDAL.GetFormEDetails(i_sConnectionString, i_nMapToTypeCodeId, i_nMapToId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
           #endregion Get Form E Details

         #region GetLastPeriodEndSubmissonFlag
        public InsiderTradingDAL.PreclearanceRequestDTO GetLastPeriodEndSubmissonFlag(string i_sConnectionString, int i_nUserInfoID, out int out_nIsPreviousPeriodEndSubmission, out string out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out string out_sSubsequentPeriodEndResourceOwnSecurity)
        {
            try
            {
                using (var objPreclearanceRequestDAL = new PreclearanceRequestDAL())
                {
                    return objPreclearanceRequestDAL.GetLastPeriodEndSubmissonFlag(i_sConnectionString, i_nUserInfoID, out out_nIsPreviousPeriodEndSubmission, out out_sSubsequentPeriodEndOrPreciousPeriodEndResource, out out_sSubsequentPeriodEndResourceOwnSecurity);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>
        public List<GetPendingEmployees> Get_PendingEmployees(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, out int out_iTotalRecords, string sLookUpPrefix, string inp_sParam1 = null, string inp_sParam2 = null, string inp_sParam3 = null, string inp_sParam4 = null,
            string inp_sParam5 = null, string inp_sParam6 = null, string inp_sParam7 = null, string inp_sParam8 = null, string inp_sParam9 = null,
            string inp_sParam10 = null, string inp_sParam11 = null, string inp_sParam12 = null, string inp_sParam13 = null, string inp_sParam14 = null,
            string inp_sParam15 = null, string inp_sParam16 = null, string inp_sParam17 = null, string inp_sParam18 = null, string inp_sParam19=null,
            string inp_sParam20 = null, string inp_sParam21 = null, string inp_sParam22 = null, string inp_sParam23 = null, string inp_sParam24 = null,
            string inp_sParam25 = null, string inp_sParam26 = null, string inp_sParam27 = null, string inp_sParam28 = null, string inp_sParam29 = null,
            string inp_sParam30 = null, string inp_sParam31 = null, string inp_sParam32 = null, string inp_sParam33 = null, string inp_sParam34 = null,
            string inp_sParam35 = null, string inp_sParam36 = null, string inp_sParam37 = null, string inp_sParam38 = null, string inp_sParam39 = null,
            string inp_sParam40 = null, string inp_sParam41 = null, string inp_sParam42 = null, string inp_sParam43 = null, string inp_sParam44 = null,
            string inp_sParam45 = null, string inp_sParam46 = null, string inp_sParam47 = null, string inp_sParam48 = null, string inp_sParam49 = null,
            string inp_sParam50 = null)
        {
            List<GetPendingEmployees> lstPendingEmpList = new List<GetPendingEmployees>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                //using (var objNSEGroupDocDAL = new InsiderTradingDAL.NSEDownLoad.NSEGroupDAL())
                using (var objPendingEmpListL = new InsiderTradingDAL.PreclearanceRequestDAL())
                {
                    //lstGroupDocumentList = objNSEGroupDocDAL.GetNSEDocumentDetails(i_sConnectionString, GroupId).ToList<NSEGroupDocumentMappingDTO>();
                    lstPendingEmpList = objPendingEmpListL.GetUserIdAndTransactionId(sConnectionString, inp_iGridType, inp_iPageSize, inp_iPageNo,
             inp_sSortField, inp_sSortOrder, inp_sParam1 = null, inp_sParam2 = null, inp_sParam3 = null, inp_sParam4 = null,
             inp_sParam5 = null, inp_sParam6 = null, inp_sParam7 = null, inp_sParam8 = null, inp_sParam9 = null,
             inp_sParam10 = null, inp_sParam11 = null, inp_sParam12 = null, inp_sParam13 = null, inp_sParam14 = null,
             inp_sParam15 = null, inp_sParam16 = null, inp_sParam17 = null, inp_sParam18 = null, inp_sParam19,
             inp_sParam20 = null, inp_sParam21 = null, inp_sParam22 = null, inp_sParam23 = null, inp_sParam24 = null,
             inp_sParam25 = null, inp_sParam26 = null, inp_sParam27 = null, inp_sParam28 = null, inp_sParam29 = null,
             inp_sParam30 = null, inp_sParam31 = null, inp_sParam32 = null, inp_sParam33 = null, inp_sParam34 = null,
             inp_sParam35 = null, inp_sParam36 = null, inp_sParam37 = null, inp_sParam38 = null, inp_sParam39 = null,
             inp_sParam40 = null, inp_sParam41 = null, inp_sParam42 = null, inp_sParam43 = null, inp_sParam44 = null,
             inp_sParam45 = null, inp_sParam46 = null, inp_sParam47 = null, inp_sParam48 = null, inp_sParam49 = null,
             inp_sParam50 = null,out out_iTotalRecords,sLookUpPrefix).ToList<GetPendingEmployees>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstPendingEmpList;
        }
        #endregion GetUserIdAndTransactionId
    }
}