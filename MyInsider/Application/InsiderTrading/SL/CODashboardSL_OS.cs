using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class CODashboardSL_OS : IDisposable
    {
        #region GetDashboardDetails
        public CODashboardDTO_OS GetDashboardDetails_OS(string i_sConnectionString, int nLoggedInUserId)
        {
            CODashboardDTO_OS objCODashboardDTO = new CODashboardDTO_OS();
            try
            {
                using (var objCODashboardDAL_OS = new CODashboardDAL_OS())
                {
                    objCODashboardDTO = objCODashboardDAL_OS.GetDashboardDetails_OS(i_sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCODashboardDTO;
        }
        #endregion GetDashboardDetails
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