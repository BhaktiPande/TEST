using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace InsiderTrading.SL
{
    public class CommunicationRuleMasterSL:IDisposable
    {
         #region Save
        /// <summary>
        /// This method is used for the save Template Master details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objTradingPolicyDTO">object TemplateMasterDTO</param>
        /// <returns></returns>
        public CommunicationRuleMasterDTO SaveDetails(CommunicationRuleMasterDTO m_objCommunicationRuleMasterDTO, DataTable i_tblCommunicationRuleModeMasterType, string i_sConnectionString, int i_nLoggedInUserId)
        {
            try
            {
                using (var objCommunicationRuleMasterDAL = new CommunicationRuleMasterDAL())
                {
                    return objCommunicationRuleMasterDAL.SaveDetails(m_objCommunicationRuleMasterDTO, i_tblCommunicationRuleModeMasterType, i_sConnectionString, i_nLoggedInUserId);
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
        public CommunicationRuleMasterDTO GetDetails(string i_sConnectionString, int i_nCommunicationRuleMasterId)
        {
            try
            {
                using (var objCommunicationRuleMasterDAL = new CommunicationRuleMasterDAL())
                {
                    return objCommunicationRuleMasterDAL.GetDetails(i_sConnectionString, i_nCommunicationRuleMasterId);
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