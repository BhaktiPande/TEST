using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class UpsiSL : IDisposable
    {

        #region SaveUpsiList
        /// <summary>
        /// This method is used for the SaveUpsiList.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO">ImplementedCompanyDTO objects</param>  SaveDetails
        /// <returns>if save then return true else return false</returns>
        public UpsiDTO SaveUpsiList(string i_sConnectionString, DataTable dt_UpsiList)
        {
          
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objUpsiDAL = new InsiderTradingDAL.UpsiDAL())
                {
                    return objUpsiDAL.SaveUpsiList(i_sConnectionString, dt_UpsiList);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            //return bReturn;
        }
        #endregion SaveDetails

        #region SaveDetails
        /// <summary>
        /// This method is used for the SaveUpsiList.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO">ImplementedCompanyDTO objects</param>  
        /// <returns>if save then return true else return false</returns>
        public Boolean SaveDetails(string i_sConnectionString, UpsiDTO objUpsiTempSharingData)
        {

            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objUpsiDAL = new InsiderTradingDAL.UpsiDAL())
                {
                    return objUpsiDAL.SaveDetails(i_sConnectionString, objUpsiTempSharingData);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return true;
        }
        #endregion SaveDetails

        #region AutoCompleteList
        /// <summary>
        /// This method is used for the AutoComplete Upsi details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO">UpsiTempSharingData objects</param>
        /// <returns></returns>
        public List<UpsiDTO> AutoCompleteListSL(string i_sConnectionString, Hashtable ht_SearchParam)
        {
            List<UpsiDTO> lstRestrictedListDTO = new List<UpsiDTO>();
            try
            {
                //RestrictedListDAL objActivityDAL = new RestrictedListDAL();
                using (var objUpsiListDAL = new UpsiDAL())
                {
                    lstRestrictedListDTO = objUpsiListDAL.AutoCompleteList(i_sConnectionString, ht_SearchParam);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstRestrictedListDTO;
        }
        #endregion AutoCompleteList
        
        #region GetUserInfo
        /// <summary>
        /// This method Get User info
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public UpsiDTO GetUserInfo(string i_sConnectionString, int UserInfo)
        {
            UpsiDTO res = null;

            try
            {
               using (var objUpsiDAL = new UpsiDAL())
                {
                    res = objUpsiDAL.GetUserInfo(i_sConnectionString, UserInfo);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetUserInfo

        #region GetDocumentAutoID
        /// <summary>
        /// This method get Document Number Auto Generated
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public UpsiDTO GetDocumentAutoID(string i_sConnectionString, int UserInfo)
        {           

            try
            {
               
                using (var objUpsiDAL = new UpsiDAL())
                {
                    return objUpsiDAL.GetDocumentAutoID(i_sConnectionString, UserInfo);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
           
        }
        #endregion GetDocumentAutoID
        
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