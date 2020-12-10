using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class RoleMasterSL:IDisposable
    {
        #region GetRoleMasterDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.RoleMasterDTO GetRoleMasterDetails(string i_sConnectionString, int i_nRoleId)
        {
            InsiderTradingDAL.RoleMasterDTO res = null;

            try
            {
                //InsiderTradingDAL.RoleMasterDAL objRoleMaterDAL = new InsiderTradingDAL.RoleMasterDAL();
                using (var objRoleMasterDAL = new InsiderTradingDAL.RoleMasterDAL())
                {
                    res = objRoleMasterDAL.GetDetails(i_sConnectionString, i_nRoleId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetRoleMasterDetails

        #region InsertUpdateRoleMasterDetails
        /// <summary>
        /// This method is used for the insert/Update Role Master details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public RoleMasterDTO InsertUpdateRoleMasterDetails(string i_sConnectionString, RoleMasterDTO i_objRoleMasterDTO, int i_nLoggedInUserID)
        {
            RoleMasterDTO objRoleMasterDTO = null;
            try
            {
                //InsiderTradingDAL.RoleMasterDAL objRoleMasterDAL = new InsiderTradingDAL.RoleMasterDAL();
                using (var objRoleMasterDAL = new InsiderTradingDAL.RoleMasterDAL())
                {
                    objRoleMasterDTO = objRoleMasterDAL.InsertUpdateRoleMasterDetails(i_sConnectionString, i_objRoleMasterDTO, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objRoleMasterDTO;
        }
        #endregion InsertUpdateRoleMasterDetails

        #region DeleteRoleMasterDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public bool DeleteRoleMasterDetails(string i_sConnectionString, int i_nRoleId, int i_nLoggedInUserID)
        {
            bool bReturn = false;

            try
            {
                //InsiderTradingDAL.RoleMasterDAL objRoleMasterDAL = new InsiderTradingDAL.RoleMasterDAL();
                using (var objRoleMasterDAL = new InsiderTradingDAL.RoleMasterDAL())
                {
                    bReturn = objRoleMasterDAL.DeleteRoleMasterDetails(i_sConnectionString, i_nRoleId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion InsertUpdateRoleMasterDetails

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