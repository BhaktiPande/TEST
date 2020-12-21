using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class ApplicabilitySL_OS:IDisposable
    {
        #region InsertDeleteApplicability
        /// <summary>
        /// 
        /// </summary>
        /// 
        /// <returns></returns>
        public bool InsertDeleteApplicability(string sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId, int i_nAllEmployeeFlag, int i_nAllInsiderFlag, int i_nAllEmployeeInsiderFlag, int i_nAllCoFlag, int i_nAllCorporateInsiderFlag, int i_nAllNonEmployeeInsiderFlag, DataTable i_tblApplicabilityFilterType, DataTable i_tblNonInsEmpApplicabilityFilterType, DataTable i_tblApplicabilityIncludeExcludeUsers, int i_nLoggedInUserID, out int o_nCountOverlapPolicy)
        {
            bool bReturn = true;
            try
            {
                //InsiderTradingDAL.ApplicabilityDAL objApplicabilityDAL = new InsiderTradingDAL.ApplicabilityDAL();
                using (var objApplicabilityDAL = new InsiderTradingDAL.ApplicabilityDAL_OS())
                {
                    bReturn = objApplicabilityDAL.InsertDeleteApplicability(sConnectionString, i_nMapToTypeCodeId, i_nMapToId, i_nAllEmployeeFlag, i_nAllInsiderFlag, i_nAllEmployeeInsiderFlag, i_nAllCoFlag, i_nAllCorporateInsiderFlag, i_nAllNonEmployeeInsiderFlag,  i_tblApplicabilityFilterType, i_tblNonInsEmpApplicabilityFilterType, i_tblApplicabilityIncludeExcludeUsers, i_nLoggedInUserID, out o_nCountOverlapPolicy);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion InsertDeleteApplicability


        #region GetDetails
        public ApplicabilityDTO_OS GetDetails(string sConnectionString, int inp_nMapToTypeID, int inp_nMapToId)
        {
            try
            {
                //InsiderTradingDAL.ApplicabilityDAL objApplicabilityDAL = new InsiderTradingDAL.ApplicabilityDAL();
                using (var objApplicabilityDAL = new InsiderTradingDAL.ApplicabilityDAL_OS())
                {
                    return objApplicabilityDAL.GetDetails(sConnectionString, inp_nMapToTypeID, inp_nMapToId);
                }
            }
            catch(Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDetails

        #region Get Count of applicable rule (policy document / trading policy) count
        /// <summary>
        /// This method is used to get applicability count for user
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nUserId"></param>
        /// <param name="nMapToTypeCodeId"></param>
        /// <returns></returns>
        public int UserApplicabilityCount(string sConnectionString, int nUserInfoId, int nMapToTypeCodeId)
        {
            int nCount = 0;

            try
            {
                //ApplicabilityDAL objApplicabilityDAL = new ApplicabilityDAL();
                using (var objApplicabilityDAL = new InsiderTradingDAL.ApplicabilityDAL_OS())
                {
                    nCount = objApplicabilityDAL.UserApplicabilityCount(sConnectionString, nUserInfoId, nMapToTypeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return nCount;
        }
        #endregion Get Count of applicable rule (policy document / trading policy) count

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