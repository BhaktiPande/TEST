using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class TradingPolicySL_OS:IDisposable
    {
        #region Save
        /// <summary>
        /// This method is used for the save Trading policy details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objTradingPolicyDTO">object TradingPolicyDTO</param>
        /// <returns></returns>
        public TradingPolicyDTO Save(string i_sConnectionString, TradingPolicyDTO m_objTradingPolicyDTO, DataTable i_tblPreclearanceSecuritywise, 
            DataTable i_tblContinousSecuritywise,DataTable i_tblPreclearanceTransactionSecurityMap)
        {
            try
            {
                using (var objTradingPolicyDAL = new TradingPolicyDAL())
                {
                    return objTradingPolicyDAL.Save(i_sConnectionString, m_objTradingPolicyDTO, i_tblPreclearanceSecuritywise, i_tblContinousSecuritywise, i_tblPreclearanceTransactionSecurityMap);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Save

        #region GetDetails
        /// <summary>
        /// This method is used for the get details for trading policy details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Trading Policy ID</param>
        /// <returns></returns>
        public InsiderTradingDAL.TradingPolicyDTO_OS GetDetails(string i_sConnectionString, int i_nTradingPolicyId)
        {
            try
            {
                using (var objTradingPolicyDAL_OS = new TradingPolicyDAL_OS())
                {
                    return objTradingPolicyDAL_OS.GetDetails(i_sConnectionString, i_nTradingPolicyId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDetails

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
            try
            {
                using (var objTradingPolicyDAL = new TradingPolicyDAL())
                {
                    return objTradingPolicyDAL.Delete(i_sConnectionString, i_nTradingPolicyId, inp_nUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Delete

       #region Get Applicable Trading Policy Details
       /// <summary>
       /// This methos is used for the Get Applicable Trading Policy Details 
       /// </summary>
       /// <param name="i_sConnectionString"></param>
       /// <param name="i_nUserInfoID"></param>
       /// <returns></returns>
        public InsiderTradingDAL.ApplicableTradingPolicyDetailsDTO_OS GetApplicableTradingPolicyDetails(string i_sConnectionString, int i_nUserInfoID, Int64 i_nTransacationMasterId = 0)
        {
            try
            {
                using (var objTradingPolicyDAL_OS = new TradingPolicyDAL_OS())
                {
                    return objTradingPolicyDAL_OS.GetApplicableTradingPolicyDetails(i_sConnectionString, i_nUserInfoID, i_nTransacationMasterId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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
            try
            {
                using (var objTradingPolicyDAL = new TradingPolicyDAL())
                {
                    return objTradingPolicyDAL.GetUserwiseOverlapTradingPolicyCount(i_sConnectionString, i_nTradingPolicyId, out out_nCountUserAndOverlapTradingPolicy);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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
            try
            {
                using (var objTradingPolicyDAL = new TradingPolicyDAL())
                {
                    return objTradingPolicyDAL.TransactionSecurityMapConfigList(i_sConnectionString, i_nTransactionTypeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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
            try
            {
                using (var objTradingPolicyDAL = new TradingPolicyDAL())
                {
                    return objTradingPolicyDAL.TradingPolicyForTransactionSecurityList(i_sConnectionString, i_nTradingPolicyId, i_nMapToTypeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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