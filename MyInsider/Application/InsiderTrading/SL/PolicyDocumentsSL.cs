using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class PolicyDocumentsSL:IDisposable
    {
        #region GetPolicyDocumentDetails
        /// <summary>
        /// This method is used to get policy document details
        /// </summary>
        /// <param name="i_sConnectionString">db connection string</param>
        /// <param name="i_nPolicyDocumentId">policy document id</param>
        /// <returns></returns>
        public PolicyDocumentDTO GetPolicyDocumentDetails(string i_sConnectionString, int i_nPolicyDocumentId)
        {
            PolicyDocumentDTO objPolicyDocumentDTO = null;

            try
            {
                //PolicyDocumentDAL objPolicyDocumentDAL = new PolicyDocumentDAL();
                using (var objPolicyDocumentDAL = new PolicyDocumentDAL())
                {
                    objPolicyDocumentDTO = objPolicyDocumentDAL.GetDetails(i_sConnectionString, i_nPolicyDocumentId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objPolicyDocumentDTO;
        }
        #endregion GetPolicyDocumentDetails

        #region SavePolicyDocument
        /// <summary>
        /// This method is used to save (insert/update) policy document details
        /// </summary>
        /// <param name="i_sConnectionString">db connection string</param>
        /// <param name="i_objPolicyDocumentDTO">policy document DTO</param>
        /// <returns></returns>
        public PolicyDocumentDTO SavePolicyDocument(string i_sConnectionString, PolicyDocumentDTO i_objPolicyDocumentDTO)
        {
            PolicyDocumentDTO objPolicyDocumentDTO = null;

            try
            {
                //PolicyDocumentDAL objPolicyDocumentDAL = new PolicyDocumentDAL();
                using (var objPolicyDocumentDAL = new PolicyDocumentDAL())
                {
                    objPolicyDocumentDTO = objPolicyDocumentDAL.SaveDetails(i_sConnectionString, i_objPolicyDocumentDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objPolicyDocumentDTO;
        }
        #endregion SavePolicyDocument

        #region DeletePolicyDocument
        /// <summary>
        /// This method is used to delete policy document and related information ie uploaded document and email upload
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nPolicyDocumentId"></param>
        /// <param name="nLoggedInUserID"></param>
        /// <returns></returns>
        public bool DeletePolicyDocument(string i_sConnectionString, int i_nPolicyDocumentId, int nLoggedInUserID)
        {
            bool bReturn = false;

            try
            {
                //PolicyDocumentDAL objPolicyDocumentDAL = new PolicyDocumentDAL();
                using (var objPolicyDocumentDAL = new PolicyDocumentDAL())
                {
                    bReturn = objPolicyDocumentDAL.Delete(i_sConnectionString, i_nPolicyDocumentId, nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion DeletePolicyDocument

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