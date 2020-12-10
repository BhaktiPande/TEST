using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;


namespace InsiderTrading.SL
{
    public class ComCodeSL:IDisposable
    {
        #region GetDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.ComCodeDTO GetDetails(string i_sConnectionString, int i_nCodeId)
        {
            InsiderTradingDAL.ComCodeDTO res = null;

            try
            {
                //InsiderTradingDAL.ComCodeDAL objComCodeDAL = new InsiderTradingDAL.ComCodeDAL();
                using (var objComCodeDAL = new InsiderTradingDAL.ComCodeDAL())
                {
                    res = objComCodeDAL.GetDetails(i_sConnectionString, i_nCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public ComCodeDTO Save(string i_sConnectionString, ComCodeDTO m_objComCodeDTO)
        {
            try
            {
                //InsiderTradingDAL.ComCodeDAL objComCodeDAL = new InsiderTradingDAL.ComCodeDAL();
                using (var objComCodeDAL = new InsiderTradingDAL.ComCodeDAL())
                {
                    return objComCodeDAL.SaveDetails(i_sConnectionString, m_objComCodeDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion Save

        #region Delete
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public bool Delete(string i_sConnectionString,int nLoggedInUserId, int nCodeId)
        {
            bool bReturn = false;
            try
            {
                //InsiderTradingDAL.ComCodeDAL objComCodeDAL = new InsiderTradingDAL.ComCodeDAL();
                using (var objComCodeDAL = new InsiderTradingDAL.ComCodeDAL())
                {
                    bReturn = objComCodeDAL.Delete(i_sConnectionString, nLoggedInUserId, nCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion Save

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