using System;
using System.Collections.Generic;
using System.Linq;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class NSEGroupSL : IDisposable
    {
        #region Get_All_NSEGroup
        /* Reference from GetPeriodEndPerformedUserInfoList Method in UserInfoSL.cs*/
        /// <summary>
        /// This method is used for fetching the list NSEGroup
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <returns>NSEGroup Information List</returns>
        public IEnumerable<NSEGroupDTO> Get_All_NSEGroup(string i_sConnectionString)
        {
            IEnumerable<NSEGroupDTO> NSEGroupInfoList = new List<NSEGroupDTO>();
            try
            {
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    NSEGroupInfoList = objNSEGroupDAL.getGroupsDetails(i_sConnectionString);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return NSEGroupInfoList;
        }

        #endregion Get_All_NSEGroup

        #region Save_New_NSEGroup
        /* Reference from SaveDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the saving Group details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objNSEGroupDTO">NSEGroupDTO objects</param>
        /// <returns>if save then return true else return false</returns>
        //public bool Save_New_NSEGroup(string i_sConnectionString, NSEGroupDTO m_objNSEGroupDTO)
        public List<NSEGroupDTO> Save_New_NSEGroup(string i_sConnectionString, NSEGroupDTO m_objNSEGroupDTO)
        {
            bool bReturn = false;
            List<NSEGroupDTO> lstGroup = new List<NSEGroupDTO>();
            try
            {
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    lstGroup = objNSEGroupDAL.SaveGroup(i_sConnectionString, m_objNSEGroupDTO).ToList<NSEGroupDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroup;
        }
        #endregion Save_New_NSEGroup

        #region Get_NSEGroup_Details
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>
        public NSEGroupDTO Get_NSEGroup_Details(string i_sConnectionString, int i_nGroupId)
        {
            NSEGroupDTO objNSEGroupDTO = new NSEGroupDTO();
            try
            {
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    objNSEGroupDTO = objNSEGroupDAL.GetSingleGroupDetails(i_sConnectionString, i_nGroupId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objNSEGroupDTO;
        }
        #endregion Get_NSEGroup_Details

        #region Delete_User_From_NSEGroup
        /* Reference from Delete Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the delete User From  NSEGroup
        /// </summary>
        /// <param name="sConnectionString">DB COnnection string</param>
        /// <param name="m_objNSEGroupDTO">NSEGroupDTO objects</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <param name="i_nUserInfoId">User ID</param>
        /// <returns>if delete return true else false</returns>
        public bool Delete_User_From_NSEGroup(string i_sConnectionString, NSEGroupDetailsDTO m_objNSEGroupDTO)
        {
            bool bReturn = false;
            try
            {
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    bReturn = objNSEGroupDAL.Delete(i_sConnectionString, m_objNSEGroupDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion Delete_User_From_NSEGroup

        #region Save_NSEGroup_Details
        /* Reference from SaveDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the saving Group details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objNSEGroupDetailsDTO">NSEGroupDetailsDTO objects</param>
        /// <returns>if save then return true else return false</returns>
        public List<NSEGroupDetailsDTO> Save_NSEGroup_Details(string i_sConnectionString, NSEGroupDetailsDTO m_objNSEGroupDetailsDTO)
        {
            List<NSEGroupDetailsDTO> lstGroupDetails = new List<NSEGroupDetailsDTO>();
            try
            {
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    lstGroupDetails = objNSEGroupDAL.SaveGroupDetails(i_sConnectionString, m_objNSEGroupDetailsDTO).ToList<NSEGroupDetailsDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDetails;
        }
        #endregion Save_NSEGroup_Details

        #region Update_NSEGroup
        /* Reference from UpdateStatus Method in CODashboardSL.cs*/
        /// <summary>
        /// This function will be for updating NSEGroup
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns></returns>
        public bool Update_NSEGroup(string i_sConnectionString, NSEGroupDTO m_objNSEGroupDTO)
        {
            bool bReturnValue = false;
            try
            {
                //CODashboardDAL objCODashboardDAL = new CODashboardDAL();
                using (var objNSEGroupDAL = new NSEGroupDAL())
                {
                    bReturnValue = objNSEGroupDAL.UpdateGroup(i_sConnectionString, m_objNSEGroupDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturnValue;
        }
        #endregion Update_NSEGroup


        #region Save_New_NSEDocument
        /* Reference from SaveDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the saving Group details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objNSEGroupDTO">NSEGroupDTO objects</param>
        /// <returns>if save then return true else return false</returns>
        public bool Save_New_NSEDocument(string i_sConnectionString, NSEGroupDocumentMappingDTO m_objGroupDocumentDTO, string GUID)
        {
            bool bReturn = false;
            try
            {
                using (var objGroupDocumentDAL = new NSEGroupDAL())
                {
                    bReturn = objGroupDocumentDAL.SaveNSEDocument(i_sConnectionString, m_objGroupDocumentDTO, GUID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion Save_New_NSEDocument

        #region Get_NSEGroupdocument_Details
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>

        public List<NSEGroupDocumentMappingDTO> Get_All_NSEGroupDocument(string i_sConnectionString, int GroupId, int UserInfoIdCheck)
        {
            List<NSEGroupDocumentMappingDTO> lstGroupDocumentList = new List<NSEGroupDocumentMappingDTO>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objNSEGroupDocDAL = new NSEGroupDAL())
                {
                    lstGroupDocumentList = objNSEGroupDocDAL.GetNSEDocumentDetails(i_sConnectionString, GroupId, UserInfoIdCheck).ToList<NSEGroupDocumentMappingDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDocumentList;
        }
        #endregion Get_NSEGroupdocument_Details

        #region Get_Singledocument_Details
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>

        public List<NSEGroupDocumentMappingDTO> Get_Singledocument_Details(string i_sConnectionString, int TransactionId)
        {
            List<NSEGroupDocumentMappingDTO> lstSingleDocumentList = new List<NSEGroupDocumentMappingDTO>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objNSEGroupDocDAL = new NSEGroupDAL())
                {
                    lstSingleDocumentList = objNSEGroupDocDAL.GetSingleNSEDocumentDetails(i_sConnectionString, TransactionId).ToList<NSEGroupDocumentMappingDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstSingleDocumentList;
        }
        #endregion Get_Singledocument_Details


        #region GetGroupwiseTransactionId
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>

        public List<NSEGroupDetailsDTO> Get_Group_TransactionId(string i_sConnectionString, int GroupId)
        {
            List<NSEGroupDetailsDTO> lstGroupTransIdList = new List<NSEGroupDetailsDTO>();
            try
            {
                using (var objNSEGroupDocDAL = new NSEGroupDAL())
                {
                    lstGroupTransIdList = objNSEGroupDocDAL.GetGroupwiseTransactionId(i_sConnectionString, GroupId).ToList<NSEGroupDetailsDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupTransIdList;
        }
        #endregion GetGroupwiseTransactionId

        #region GetGroupwiseDate
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroup DTO</returns>

        public List<NSEGroupDTO> Get_Group_Date(string i_sConnectionString, int GroupId)
        {
            List<NSEGroupDTO> lstGroupDate = new List<NSEGroupDTO>();
            
            try
            {
                using (var objNSEGrpDateDAL = new NSEGroupDAL())
                {
                    lstGroupDate = objNSEGrpDateDAL.GetgroupDate(i_sConnectionString, GroupId).ToList<NSEGroupDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDate;
        }
        #endregion GetGroupwiseDate

        #region GetGroupId
        /* Reference from GetCompanyFaceValueDetails Method in CompaniesSL.cs*/
        /// <summary>
        /// This method is used for the get NSEGroup Id
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nGroupID">NSEGroup ID</param>
        /// <returns>Object NSEGroupDetailsDTO</returns>

        public List<NSEGroupDetailsDTO> GetgroupId(string i_sConnectionString, int GroupId, int TransId)
        {
            List<NSEGroupDetailsDTO> lstGroupId = new List<NSEGroupDetailsDTO>();           
            try
            {
                using (var objNSEGrpDateDAL = new NSEGroupDAL())
                {                    
                    lstGroupId = objNSEGrpDateDAL.GetgroupId(i_sConnectionString, GroupId, TransId).ToList<NSEGroupDetailsDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupId;
        }
        #endregion GetGroupwiseDate

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