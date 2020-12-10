using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTradingSSO.SL
{
    public class CompaniesSL : IDisposable
    {
        #region Get All Companies
        public List<InsiderTradingDAL.CompanyDTO> getAllCompanies(string i_sConnectionString)
        {
            List<CompanyDTO> lstCompaniesList = new List<CompanyDTO>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    lstCompaniesList = objCompanyDAL.getCompaniesDetails(i_sConnectionString).ToList<InsiderTradingDAL.CompanyDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstCompaniesList;
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