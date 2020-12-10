using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using InsiderTradingDAL;


namespace InsiderTrading.SL
{
    public class CommonSL : IDisposable
    {
        #region CheckUserTypeAccess
        /// <summary>
        /// This Function fetches the user access for that page as per parameters.
        /// Function for validating user access for specified page, user should not view or modify other user details.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="inp_iMapToTypeCodeId"></param>
        /// <param name="inp_iMapToId"></param>
        /// <param name="inp_iLoggenInUserId"></param>
        /// <param name="out_nIsAccess"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public void CheckUserTypeAccess(string i_sConnectionString, int i_iMapToTypeCodeId, Int64 i_iMapToId, int i_iLoggenInUserId, out int nIsAccess)
        {
            try
            {
                //InsiderTradingDAL.ComCodeDAL objComCodeDAL = new InsiderTradingDAL.ComCodeDAL();
                using (var objCommonDAL = new InsiderTradingDAL.CommonDAL())
                {
                    objCommonDAL.CheckUserTypeAccess(i_sConnectionString, i_iMapToTypeCodeId, i_iMapToId, i_iLoggenInUserId, out nIsAccess);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion CheckUserTypeAccess
        #region Email Log
        public bool SaveEamilLog(string i_sConnectionString, DataTable dtEamilLog)
        {
            bool result = false;
            try
            {
                using (CommonDAL objCommonDAL = new CommonDAL())
                {
                    result=  objCommonDAL.SaveEamilLog(i_sConnectionString, dtEamilLog);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            

            return result;
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