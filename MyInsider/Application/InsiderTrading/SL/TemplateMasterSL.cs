using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class TemplateMasterSL:IDisposable
    {
         #region Save
        /// <summary>
        /// This method is used for the save Template Master details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objTradingPolicyDTO">object TemplateMasterDTO</param>
        /// <returns></returns>
        public TemplateMasterDTO SaveDetails(TemplateMasterDTO m_objTemplateMasterDTO, string i_sConnectionString, int i_nLoggedInUserId)
        {
            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    return objTemplateMasterDAL.SaveDetails(m_objTemplateMasterDTO, i_sConnectionString, i_nLoggedInUserId);
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
        /// This method is used for the get details for Template Master details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
        /// <returns></returns>
        public TemplateMasterDTO GetDetails(string i_sConnectionString, int i_nTemplateMasterId)
        {
            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    return objTemplateMasterDAL.GetDetails(i_sConnectionString, i_nTemplateMasterId);
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
        /// This method is used for the delete Template Master
       /// </summary>
       /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
       /// <param name="inp_nUserId">Logged In User ID</param>
       /// <returns></returns>
        public bool Delete(string i_sConnectionString, int i_nTemplateMasterID, int inp_nUserId)
        {
            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    return objTemplateMasterDAL.Delete(i_sConnectionString, i_nTemplateMasterID, inp_nUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Delete

        #region GetFAQDetails
        /// <summary>
        /// This method is used for the get details for FAQ from tra_TemplateMaster table.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <returns></returns>
        public List<FAQDTO> GetFAQDetails(string i_sConnectionString,int i_nUserTypeCodeId, int i_nPageSize, int i_nPageNo, string i_sSortColumn, string i_sSortOrder, bool i_bForDashboard)
        {
            List<FAQDTO> lstFAQList = new List<FAQDTO>();
            //TemplateMasterDAL objTemplateMasterDAL = new TemplateMasterDAL();

            String[] arr = new string[21];

            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    lstFAQList = objTemplateMasterDAL.GetFAQList(i_sConnectionString, i_nUserTypeCodeId, i_nPageSize, i_nPageNo, i_sSortColumn, i_sSortOrder, i_bForDashboard);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstFAQList;
        }
        #endregion GetFAQDetails

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

        #region GetTransactionLetterDetailsForGroup
        /// <summary>
        /// This method is used for the get details for Template Master details.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="i_nTradingPolicyId">Template Master ID</param>
        /// <returns></returns>
        public TemplateMasterDTO GetTransactionLetterDetailsForGroup(string i_sConnectionString, int nDisclosureTypeCodeId, int nLetterForCodeId)
        {
            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    return objTemplateMasterDAL.GetTransactionLetterDetailsForGroup(i_sConnectionString, nDisclosureTypeCodeId,nLetterForCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetTransactionLetterDetailsForGroup        

        #region GetFormETemplate
        /// <summary>
        /// This method is used for check Form E Template Available or not
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <returns></returns>
        public TemplateMasterDTO GetFormETemplate(string i_sConnectionString)
        {
            try
            {
                using (var objTemplateMasterDAL = new TemplateMasterDAL())
                {
                    return objTemplateMasterDAL.GetFormETemplate(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetFormETemplate
    }
}