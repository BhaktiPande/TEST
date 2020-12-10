using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class PeriodEndDisclosureSL_OS : IDisposable
    {


        #region Get form G for Other securities
        /// <summary>
        /// This method is used to get impact on securities held post to acquisition.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nTransTypeCodeId"></param>
        /// <param name="nModeOfAcquisCodeId"></param>      
        /// <returns></returns>
        public FormGDetails_OSDTO GetFormGOSDetails(string sConnectionString, int MapToTypeCodeId, int nTransactionMasterId)
        {
            FormGDetails_OSDTO objFormGDetails_OSDTO = new FormGDetails_OSDTO();

            try
            {
                using (var objPeriodEndDisclosureDAL_OS = new PeriodEndDisclosureDAL_OS())
                {
                    objFormGDetails_OSDTO = objPeriodEndDisclosureDAL_OS.GetFormGOSDetails(sConnectionString, MapToTypeCodeId, nTransactionMasterId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objFormGDetails_OSDTO;
        }
        #endregion 

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