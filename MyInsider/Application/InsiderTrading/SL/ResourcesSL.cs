using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading
{
    public class ResourcesSL:IDisposable
    {
        public void GetAllResources(string i_sConnectionString, out Dictionary<string, string> o_lstResources)
        {
            o_lstResources = new Dictionary<string, string>();
            //InsiderTradingDAL.ResourcesDAL objResourcesDAL = new ResourcesDAL();
            try
            {
                using (var objResourcesDAL = new ResourcesDAL())
                {
                    objResourcesDAL.GetAllResources(i_sConnectionString, out o_lstResources);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        #region GetDetails
        /// <summary>
        /// This method is used for fetching details of resource key.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="inp_sResourceKey">Resource Key</param>
        /// <returns>Object of ResourceDTO</returns>
        public ResourcesDTO GetDetails(string i_sConnectionString, string inp_sResourceKey)
        {
            try
            {
                using (var objResourcesDAL = new ResourcesDAL())
                {
                    return objResourcesDAL.GetDetails(i_sConnectionString, inp_sResourceKey);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This procedure is used for the update the resource key value.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objResourceDTO">Object of Resource DTO</param>
        /// <returns>If saves return true otherwise false</returns>
        public bool SaveDetails(string i_sConnectionString, ResourcesDTO m_objResourcesDTO)
        {
            try
            {
                using (var objResourcesDAL = new ResourcesDAL())
                {
                    return objResourcesDAL.Save(i_sConnectionString, m_objResourcesDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
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