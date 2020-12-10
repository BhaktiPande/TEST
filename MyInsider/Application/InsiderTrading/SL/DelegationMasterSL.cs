using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class DelegationMasterSL:IDisposable
    {
        #region Details
        public DelegationMasterDTO GetDetails(DelegationMasterDTO m_objDelegationMasterDTO, string sConnectionString)
        {
            try
            {
                //InsiderTradingDAL.DelegationMasterDAL objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL();
                using (var objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL())
                {
                    return objDelegationMasterDAL.GetDetails(m_objDelegationMasterDTO, sConnectionString);
                }
            }
            catch(Exception e)
            {
                throw e;
            }
        }
        #endregion Details

        #region Save
        public DelegationMasterDTO SaveDetails(DelegationMasterDTO m_objDelegationMasterDTO, int m_nPartialSave, string sConnectionString, int nLoggedInUserId)
        {
            try
            {
                //InsiderTradingDAL.DelegationMasterDAL objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL();
                using (var objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL())
                {
                    return objDelegationMasterDAL.SaveDetails(m_objDelegationMasterDTO, m_nPartialSave, sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        #endregion Save

        #region delete
        public bool Delete(int m_nDelegationMasterId, string sConnectionString, int nLoggedInUserId)
        {
            try
            {
                //InsiderTradingDAL.DelegationMasterDAL objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL();
                using (var objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL())
                {
                    return objDelegationMasterDAL.Delete(m_nDelegationMasterId, sConnectionString, nLoggedInUserId);
                }
            }
            catch (Exception e)
            {
                
                throw e;
            }
        }
        #endregion delete

        #region GetDelegationActivityDetails
        public Dictionary<string, Dictionary<string, List<RoleActivityDTO>>> GetDelegationActivityDetails(string sConnectionString, int m_nDelegationID, int m_nUserInfoIdFrom, int m_nUserInfoIdTo)
        {
            List<RoleActivityDTO> lstDelegationActivities = null ;
            Dictionary<string, Dictionary<string, List<RoleActivityDTO>>> objModuleDictionary = null;
            Dictionary<string, List<RoleActivityDTO>> objScreenDictionary = null;
            try
            {
                objModuleDictionary = new Dictionary<string, Dictionary<string, List<RoleActivityDTO>>>();
                //InsiderTradingDAL.DelegationMasterDAL objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL();
                using (var objDelegationMasterDAL = new InsiderTradingDAL.DelegationMasterDAL())
                {
                    lstDelegationActivities = objDelegationMasterDAL.GetDelegationActivityDetails(sConnectionString, m_nDelegationID, m_nUserInfoIdFrom, m_nUserInfoIdTo);
                }
                foreach (RoleActivityDTO objRoleActivityDTO in lstDelegationActivities)
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
                        lstDelegationActivities = objScreenDictionary[objRoleActivityDTO.ScreenName];
                    }
                    else
                    {
                        lstDelegationActivities = new List<RoleActivityDTO>();
                    }
                    lstDelegationActivities.Add(objRoleActivityDTO);
                    objScreenDictionary[objRoleActivityDTO.ScreenName] = lstDelegationActivities;
                    objModuleDictionary[objRoleActivityDTO.Module] = objScreenDictionary;
                    //objScreenDictionary = new Dictionary<string,List<RoleActivityDTO>>();
                }
            }
            catch (Exception e)
            {
                throw e;
            }
            return objModuleDictionary;
        }
        #endregion GetDelegationActivityDetails

        #region DelegationDetailsSaveDelete
        public bool DelegationDetailsSaveDelete(string i_sConnectionString, DataTable i_tblDelegationDetails, int i_nLoggedInUserID)
        {
            bool bReturn = true;
            try
            {
                //InsiderTradingDAL.DelegationMasterDAL objDelegationDetailsDAL = new InsiderTradingDAL.DelegationMasterDAL();
                using (var objDelegationDetailsDAL = new InsiderTradingDAL.DelegationMasterDAL())
                {
                    bReturn = objDelegationDetailsDAL.DelegationDetailsSaveDelete(i_sConnectionString, i_tblDelegationDetails, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion DelegationDetailsSaveDelete

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