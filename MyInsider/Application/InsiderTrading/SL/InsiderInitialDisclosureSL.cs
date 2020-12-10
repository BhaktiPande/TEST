using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL.InsiderInitialDisclosure;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;

namespace InsiderTrading.SL
{
    public class InsiderInitialDisclosureSL:IDisposable
    {
        #region SaveEvent
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public bool SaveEvent(string i_sConnectionString, UserPolicyDocumentEventLogDTO m_objUserPolicyDocumentEventLogDTO, int nLoggedInUserId)
        {
            bool bReturn = false;
            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    bReturn = objInsiderInitialDisclosureDAL.SaveEvent(i_sConnectionString, m_objUserPolicyDocumentEventLogDTO, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion SaveEvent

        #region SaveReconfirmation
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public bool SaveReconfirmation(string i_sConnectionString, int UserInfoId, int nLoggedInUserId)
        {
            bool bReturn = false;
            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    bReturn = objInsiderInitialDisclosureDAL.SaveReconfirmation(i_sConnectionString, UserInfoId, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion SaveReconfirmation

        #region GetDocumentDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public UsersPolicyDocumentDTO GetDocumentDetails(string i_sConnectionString, int PolicyDocumentID, int DocumentID)
        {
            UsersPolicyDocumentDTO res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDocumentDetails(i_sConnectionString, PolicyDocumentID, DocumentID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDocumentDetails

        #region GetDashBoardDetails
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetails(string i_sConnectionString, int UserInfoId, int UserTypeCodeID)
        {
            IEnumerable<InsiderInitialDisclosureDTO> res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDashBoardDetails(i_sConnectionString, UserInfoId, UserTypeCodeID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDashBoardDetails

        #region GetDashBoardDetailsInsider
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetailsInsider(string i_sConnectionString, int UserInfoId, int UserTypeCodeID)
        {
            IEnumerable<InsiderInitialDisclosureDTO> res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDashBoardDetailsInsider(i_sConnectionString, UserInfoId, UserTypeCodeID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDashBoardDetailsInsider


        #region GetDashBoardDetails_OS
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetails_OS(string i_sConnectionString, int UserInfoId, int UserTypeCodeID)
        {
            IEnumerable<InsiderInitialDisclosureDTO> res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDashBoardDetails_OS(i_sConnectionString, UserInfoId, UserTypeCodeID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDashBoardDetails_OS

        #region GetDashBoardDetailsInsider_OS
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetailsInsider_OS(string i_sConnectionString, int UserInfoId, int UserTypeCodeID)
        {
            IEnumerable<InsiderInitialDisclosureDTO> res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDashBoardDetailsInsider_OS(i_sConnectionString, UserInfoId, UserTypeCodeID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDashBoardDetailsInsider_OS


        #region GetDashBoardInsiderCount
        public InsiderInitialDisclosureCountDTO GetDashBoardInsiderCount(string i_sConnectionString)
        {
            InsiderInitialDisclosureCountDTO res = null;
            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetDashBoardInsiderCount(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDashBoardInsiderCount

        #region GetInitialDisclosureDetails
        public IEnumerable<InsiderInitialDisclosureDTO> GetInitialDisclosureDetails(string i_sConnectionString, int UserInfoId)
        {
            IEnumerable<InsiderInitialDisclosureDTO> res = null;

            try
            {
                //InsiderInitialDisclosureDAL objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL();
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    res = objInsiderInitialDisclosureDAL.GetInitialDisclosureDetails(i_sConnectionString, UserInfoId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetInitialDisclosureDetails

        #region Get_TradingPolicyID_for_OS
        /// <summary>
        /// This method is used to get trading policy id for other security type
        /// </summary>
        /// <returns></returns>
        public InsiderInitialDisclosureDTO Get_TradingPolicyID_forOS(string i_sConnectionString, int UserInfoID)
        {
            try
            {
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    return objInsiderInitialDisclosureDAL.st_tra_GetTradingPolicyIDfor_OS(i_sConnectionString, UserInfoID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Get_TradingPolicyID_for_OS

        #region Get_mst_company_details
        /// <summary>
        /// This method is used for the Get mst_company details.
        /// </summary>
        /// <returns></returns>
        public InsiderInitialDisclosureDTO Get_mst_company_details(string i_sConnectionString)
        {
            try
            {
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    return objInsiderInitialDisclosureDAL.Get_mst_company_details(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Get_mst_company_details
        #region Get Form B Details

        public FormBDetails_OSDTO GetFormBDetails_OS(string i_sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId)
        {
            try
            {
                using (var objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDAL())
                {
                    return objInsiderInitialDisclosureDAL.GetFormBOSDetails(i_sConnectionString, i_nMapToTypeCodeId, i_nMapToId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Get Form B Details

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