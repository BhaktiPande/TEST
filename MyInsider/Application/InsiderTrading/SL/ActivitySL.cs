using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;
using System.Data;

namespace InsiderTrading.SL
{
    public class ActivitySL:IDisposable
    {
        #region GetActivityResourceMappingDetails
        /// <summary>
        /// This function will be used for geeting the mapping of activity and resource.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public List<ActivityResourceMappingDTO> GetActivityResourceMappingDetails(string i_sConnectionString, int i_nLoggedInUserID)
        {
            List<ActivityResourceMappingDTO> lstActivityResourceMappingDTO = new List<ActivityResourceMappingDTO>();
            try
            {
                //ActivityDAL objActivityDAL = new ActivityDAL();
                using (var objActivityDAL = new ActivityDAL())
                {
                    lstActivityResourceMappingDTO = objActivityDAL.GetActivityResourceMappingDetails(i_sConnectionString, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstActivityResourceMappingDTO;
        }
        #endregion GetActivityResourceMappingDetails

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