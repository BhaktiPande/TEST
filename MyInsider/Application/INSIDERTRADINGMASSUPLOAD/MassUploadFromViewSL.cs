using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTradingMassUpload
{
    public class MassUploadFromViewSL<T> : MassUploadFromViewDAL<T>
    {

        #region FetchFromView
        /// <summary>
        /// This generic method is used for the fetching all list data.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_sViewName">View name</param>
        /// <returns>List Of Generic DTO list</returns>
        public IEnumerable<T> FetchFromView(string i_sConnectionString, string i_sViewName)
        {
            try
            {
                return FetchFromViewDAL(i_sConnectionString, i_sViewName);
            }
            catch (Exception exp)
            {
                throw exp;
                //return null;
            }

        }
        #endregion FetchFromView

    }
}