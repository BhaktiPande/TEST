using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class SecurityTransferSL : IDisposable
    {   

        #region GetAvailableQuantityForIndividualDematOrAllDemat
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoID"></param>
        /// <param name="i_nSecurityTypeCodeID"></param>
        /// <param name="i_nDMATdetailsID"></param>
        /// <param name="i_nSecurityTransferOption"></param>
        /// <param name="out_dAvailableQuantity"></param>
        /// <returns></returns>
        public SecurityTransferDTO GetAvailableQuantityForIndividualDematOrAllDemat(string i_sConnectionString, int i_nUserInfoID, int i_nUserInfoRelativeID,
            int i_nSecurityTypeCodeID, int i_nDMATdetailsID, int i_nSecurityTransferOption,
            out decimal out_dAvailableQuantity, out decimal out_dAvailableESOPQty, out decimal out_dAvailableOtherQty)
        {
            try
            {
                using (var objSecurityTransferDAL = new SecurityTransferDAL())
                {
                    return objSecurityTransferDAL.GetAvailableQuantityForIndividualDematOrAllDemat(i_sConnectionString, i_nUserInfoID,i_nUserInfoRelativeID, i_nSecurityTypeCodeID, i_nDMATdetailsID
                                    , i_nSecurityTransferOption, out out_dAvailableQuantity, out out_dAvailableESOPQty, out out_dAvailableOtherQty);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
          #endregion GetAvailableQuantityForIndividualDematOrAllDemat

        #region TransferBalance
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="objSecurityTransferDTO"></param>
        /// <returns></returns>
        public InsiderTradingDAL.SecurityTransferDTO TransferBalance(string i_sConnectionString, SecurityTransferDTO objSecurityTransferDTO)
        {
            try
            {
                using (var objSecurityTransferDAL = new SecurityTransferDAL())
                {
                    return objSecurityTransferDAL.TransferBalance(i_sConnectionString, objSecurityTransferDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion TransferBalance


        #region GetPendingTransactionforSecurityTransfer
        /// <summary>
        /// 
        /// </summary>
        public SecurityTransferDTO GetPendingTransactionforSecurityTransfer(string i_sConnectionString, int i_nUserInfoID,
            out int out_PendingPeriodEndCount, out int out_PendingTransactionsCountPNT, out int out_PendingTransactionsCountPCL)
        {
            try
            {
                using (var objSecurityTransferDAL = new SecurityTransferDAL())
                {
                    return objSecurityTransferDAL.GetPendingTransactionforSecurityTransfer(i_sConnectionString, i_nUserInfoID,
                    out out_PendingPeriodEndCount, out out_PendingTransactionsCountPNT, out out_PendingTransactionsCountPCL);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetPendingTransactionforSecurityTransfer

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