using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class CODashboardSL:IDisposable
    {
        #region GetDashboardDetails
        public CODashboardDTO GetDashboardDetails(string i_sConnectionString, int nLoggedInUserId)
        {
            CODashboardDTO objCODashboardDTO = new CODashboardDTO();
            try
            {
                //CODashboardDAL objCODashboardDAL = new CODashboardDAL();
                using (var objCODashboardDAL = new CODashboardDAL())
                {
                    objCODashboardDTO = objCODashboardDAL.GetDashboardDetails(i_sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCODashboardDTO;
        }
        #endregion GetDashboardDetails

        #region Update Status
        public bool UpdateStatus(string i_sConnectionString, int nLoggedInUserId, int nDashboardId)
        {
            bool bReturnValue = false;
            try
            {
                //CODashboardDAL objCODashboardDAL = new CODashboardDAL();
                using (var objCODashboardDAL = new CODashboardDAL())
                {
                    bReturnValue = objCODashboardDAL.UpdateStatus(i_sConnectionString, nLoggedInUserId, nDashboardId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturnValue;
        }
        #endregion Update Status

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