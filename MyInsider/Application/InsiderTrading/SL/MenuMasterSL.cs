using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class MenuMasterSL:IDisposable
    {

        #region GetMenuMasterList
        /// <summary>
        ///  Get Menu List as per the logged user id.
        /// </summary>
        /// <Author>Tushar Tekawade</Author>
        /// <CreatedDate>30 Jan 2015</CreatedDate>
        /// <Modifed>
        /// 1. 
        /// 
        /// </Modifed>
        /// <param name="UserID">Login User ID</param>
        /// <param name="sConnectionString">Database connection string</param>
        /// <returns>Menu List</returns>
        public IEnumerable<InsiderTradingDAL.MenuMasterDTO> GetMenuMasterList(int i_nUserID, string i_sConnectionString)
        {
            IEnumerable<InsiderTradingDAL.MenuMasterDTO> lstMenuMasterList = new List<InsiderTradingDAL.MenuMasterDTO>();
            //InsiderTradingDAL.MenuDAL objMenuDAL = new InsiderTradingDAL.MenuDAL();
            //int out_iTotalRecords = 0;
            //int o_nReturnValue = 0;
            //int o_nErroCode = 0;
            //string o_sErrorMessage = "";
            try
            {
                using (var objMenuDAL = new InsiderTradingDAL.MenuDAL())
                {
                    lstMenuMasterList = objMenuDAL.GetMenuMasterList(i_nUserID, i_sConnectionString);
                }

                //IEnumerable<InsiderTradingDAL.MenuMasterDTO> lst = objMenuDAL.ListALL(i_sConnectionString, 1, 10, 1,
                //   null, null, "1", null, null, null,
                //   null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, out  out_iTotalRecords, out  o_nReturnValue, out  o_nErroCode,
                //  out  o_sErrorMessage);

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstMenuMasterList;
        }

        #endregion GetMenuMasterList

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