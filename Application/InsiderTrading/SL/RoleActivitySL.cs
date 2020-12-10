using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class RoleActivitySL: IDisposable
    {
        #region GetRoleActivityDetails
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public Dictionary<string, Dictionary<string, List<RoleActivityDTO>>> GetRoleActivityDetails(string i_sConnectionString, int i_RoleId)
        {
            List<RoleActivityDTO> lstRoleActivities = null;
            Dictionary<string, Dictionary<string, List<RoleActivityDTO>>> objModuleDictionary = null;
            Dictionary<string, List<RoleActivityDTO>> objScreenDictionary = null;
            try
            {
                objModuleDictionary = new Dictionary<string,Dictionary<string,List<RoleActivityDTO>>>();
                
                //InsiderTradingDAL.RoleActivityDAL objRoleActivityDAL = new InsiderTradingDAL.RoleActivityDAL();
                using (var objRoleActivityDAL = new InsiderTradingDAL.RoleActivityDAL())
                {
                    lstRoleActivities = objRoleActivityDAL.GetDetails(i_sConnectionString, i_RoleId);
                }
                foreach (RoleActivityDTO objRoleActivityDTO in lstRoleActivities)
                {
                    if (objModuleDictionary.ContainsKey(objRoleActivityDTO.Module))
                    {
                        objScreenDictionary = objModuleDictionary[objRoleActivityDTO.Module];
                    }
                    else
                    {
                        objScreenDictionary = new Dictionary<string, List<RoleActivityDTO>>();
                    }
                    if (objScreenDictionary.ContainsKey(objRoleActivityDTO.ScreenName))
                    {
                        lstRoleActivities = objScreenDictionary[objRoleActivityDTO.ScreenName];
                    }
                    else
                    {
                        lstRoleActivities = new List<RoleActivityDTO>();
                    }
                    lstRoleActivities.Add(objRoleActivityDTO);
                    objScreenDictionary[objRoleActivityDTO.ScreenName] = lstRoleActivities;
                    objModuleDictionary[objRoleActivityDTO.Module] = objScreenDictionary;
                    //objScreenDictionary = new Dictionary<string,List<RoleActivityDTO>>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objModuleDictionary;
        }
        #endregion GetRoleActivityDetails

        #region InsertDeleteRoleActivities
        /// <summary>
        /// This method is used for the insert/Update Role Master details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public bool InsertDeleteRoleActivities(string i_sConnectionString, DataTable i_tblRoleActivity, int i_nLoggedInUserID)
        {
            bool bReturn = true;
            try
            {
                //InsiderTradingDAL.RoleActivityDAL objRoleActivityDAL = new InsiderTradingDAL.RoleActivityDAL();
                using (var objRoleActivityDAL = new InsiderTradingDAL.RoleActivityDAL())
                {
                    bReturn = objRoleActivityDAL.InsertDeleteRoleActivities(i_sConnectionString, i_tblRoleActivity, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion InsertDeleteRoleActivities

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