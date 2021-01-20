using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class CompaniesSL : IDisposable
    {
        #region Main Company

        #region Get All Companies
        public List<InsiderTradingDAL.CompanyDTO> getAllCompanies(string i_sConnectionString)
        {
            List<CompanyDTO> lstCompaniesList = new List<CompanyDTO>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    lstCompaniesList = objCompanyDAL.getCompaniesDetails(i_sConnectionString).ToList<InsiderTradingDAL.CompanyDTO>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstCompaniesList;
        }

        #endregion

        #region Get Selected Companies
        public InsiderTradingDAL.CompanyDTO getSingleCompanies(string i_sConnectionString, string i_sCompanyDatabaseName)
        {
            InsiderTradingDAL.CompanyDTO objCompaniesList = new InsiderTradingDAL.CompanyDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompaniesList = objCompanyDAL.GetSingleCompanyDetails(i_sConnectionString, i_sCompanyDatabaseName);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompaniesList;
        }
        #endregion Get Selected Companies

        #region UpdateMasterCompanyDetails
        public int UpdateMasterCompanyDetails(string i_sConnectionString, string i_sCompanyDatabaseName, int i_nCompanyResourceUpdateStatus)
        {
            int objCompanyobject = 0;
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompanyDAL.UpdateMasterCompanyDetails(i_sConnectionString, i_sCompanyDatabaseName, i_nCompanyResourceUpdateStatus);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyobject;
        }
        #endregion UpdateMasterCompanyDetails

        #endregion Main Company

        #region Company Master Functions

        #region GetDetails
        /// <summary>
        /// This method is used for the get details of Company.
        /// </summary>
        /// <param name="sConnectionString">db Connection string</param>
        /// <param name="m_objCompanyDTO">Company DTO</param>
        /// <returns> return List Of Company DTO</returns>
        public ImplementedCompanyDTO GetDetails(string i_sConnectionString, int i_nCompanyId, int i_nImplementing)
        {
            InsiderTradingDAL.ImplementedCompanyDTO objCompaniesList = new InsiderTradingDAL.ImplementedCompanyDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompaniesList = objCompanyDAL.GetDetails(i_sConnectionString, i_nCompanyId, i_nImplementing);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompaniesList;
        }
        #endregion GetDetails

        #region SaveDetails
        /// <summary>
        /// This method is used for the saving company details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO">ImplementedCompanyDTO objects</param>
        /// <returns>if save then return true else return false</returns>
        public bool SaveDetails(string i_sConnectionString, ImplementedCompanyDTO m_objCompanyDTO)
        {
            bool bReturn = false;
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    bReturn = objCompanyDAL.SaveDetails(i_sConnectionString, m_objCompanyDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion SaveDetails

        #region Delete
        /// <summary>
        /// This method is used for the delete the company
        /// </summary>
        /// <param name="sConnectionString">DB COnnection string</param>
        /// <param name="m_objCompanyDTO">ImplementedCompanyDTO object</param>
        /// <returns>if delete return true else false</returns>
        public bool Delete(string i_sConnectionString, ImplementedCompanyDTO m_objCompanyDTO)
        {
            bool bReturn = false;
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    bReturn = objCompanyDAL.Delete(i_sConnectionString, m_objCompanyDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion Delete

        #endregion Company Master Functions

        #region Face Value Function

        #region GetCompanyFaceValueDetails
        /// <summary>
        /// This method is used for the get face value details for the company.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyFaceValueID">Company Face Value ID</param>
        /// <returns>Object Face Value DTO</returns>
        public CompanyFaceValueDTO GetCompanyFaceValueDetails(string i_sConnectionString, int i_nCompanyFaceValueID)
        {
            InsiderTradingDAL.CompanyFaceValueDTO objCompanyFaceValueDTO = new InsiderTradingDAL.CompanyFaceValueDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompanyFaceValueDTO = objCompanyDAL.GetCompanyFaceValueDetails(i_sConnectionString, i_nCompanyFaceValueID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyFaceValueDTO;
        }
        #endregion GetCompanyFaceValueDetails

        #region SaveCompanyFaceValueDetails
        /// <summary>
        /// This method is used for the sace Company Face Value details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyFaceValueDTO">Object of ComapnyFaceValue DTO</param>
        /// <returns></returns>
        public CompanyFaceValueDTO SaveCompanyFaceValueDetails(string i_sConnectionString, CompanyFaceValueDTO m_objCompanyFaceValueDTO)
        {
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveCompanyFaceValueDetails(i_sConnectionString, m_objCompanyFaceValueDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion SaveCompanyFaceValueDetails

        #region DeleteCompanyFaceValueDetails
        /// <summary>
        /// Delete Company Face Value details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyFaceValueDTO">Object of CompanyFaceValue DTO</param>
        /// <returns></returns>
        public bool DeleteCompanyFaceValueDetails(string i_sConnectionString, CompanyFaceValueDTO m_objCompanyFaceValueDTO)
        {
            bool bReturn = false;
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    bReturn = objCompanyDAL.DeleteCompanyFaceValueDetails(i_sConnectionString, m_objCompanyFaceValueDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion Delete

        #endregion Face Value Function

        #region Authorised Shares Function

        #region GetAuthorisedShareCapitalDetails
        /// <summary>
        /// This method is used for the get Authorised share capital details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyAuthorizedShareCapitalID">Authorised Shared Capital DTO</param>
        /// <returns>Object of Authorised Share DTO</returns>
        public CompanyAuthorizedShareCapitalDTO GetAuthorisedShareCapitalDetails(string i_sConnectionString, int i_nCompanyAuthorizedShareCapitalID)
        {
            InsiderTradingDAL.CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = new InsiderTradingDAL.CompanyAuthorizedShareCapitalDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompanyAuthorizedShareCapitalDTO = objCompanyDAL.GetAuthorisedShareCapitalDetails(i_sConnectionString, i_nCompanyAuthorizedShareCapitalID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyAuthorizedShareCapitalDTO;
        }
        #endregion GetCompanyFaceValueDetails

        #region GetAuthorisedShareCapitalDetailsForTransactionOnDate
        /// <summary>
        /// This method is used for the get Authorised share capital details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyAuthorizedShareCapitalID">Authorised Shared Capital DTO</param>
        /// <returns>Object of Authorised Share DTO</returns>
        public CompanyPaidUpAndSubscribedShareCapitalDTO GetAuthorisedShareCapitalDetailsForTransactionOnDate(string i_sConnectionString, DateTime i_dtAuthorizedShareCapitalDate)
        {
            InsiderTradingDAL.CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = new InsiderTradingDAL.CompanyPaidUpAndSubscribedShareCapitalDTO();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    objCompanyAuthorizedShareCapitalDTO = objCompanyDAL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(i_sConnectionString, i_dtAuthorizedShareCapitalDate);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyAuthorizedShareCapitalDTO;
        }
        #endregion GetAuthorisedShareCapitalDetailsForTransactionOnDate

        #region SaveAuthorisedShareDetails
        /// <summary>
        /// This method is used for the save Authorised share details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyAuthorizedShareCapitalDTO">Authorisede Shared DTO</param>
        /// <returns></returns>
        public CompanyAuthorizedShareCapitalDTO SaveAuthorisedSharesDetails(string i_sConnectionString, CompanyAuthorizedShareCapitalDTO m_objCompanyAuthorizedShareCapitalDTO)
        {
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveAuthorisedSharesDetails(i_sConnectionString, m_objCompanyAuthorizedShareCapitalDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion SaveCompanyFaceValueDetails

        #region DeleteCompanyAuthorizedShareCapitalDetails
        /// <summary>
        /// This method is used for the delete authorised share details.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="m_objCompanyAuthorizedShareCapitalDTO"></param>
        /// <returns></returns>
        public bool DeleteCompanyAuthorizedShareCapitalDetails(string sConnectionString, CompanyAuthorizedShareCapitalDTO m_objCompanyAuthorizedShareCapitalDTO)
        {
            bool bReturn = false;
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL();
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    bReturn = objCompanyDAL.DeleteCompanyAuthorizedShareCapitalDetails(sConnectionString, m_objCompanyAuthorizedShareCapitalDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion Delete

        #endregion Authorised Shares Function

        #region PaidUpAndSubscribedShareCapital

        #region GetCompanyPaidUpAndSubscribedShareDetails
        /// <summary>
        /// This method is used for the get company Paid & Subscribe Share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyPaidUpAndSubscribedShareCapitalId">CompanyPaidUpAndSubscribedShareCapitalId</param>
        /// <returns></returns>
        public CompanyPaidUpAndSubscribedShareCapitalDTO GetCompanyPaidUpAndSubscribedShareDetails(string i_sConnectionString, int i_nCompanyPaidUpAndSubscribedShareCapitalId)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.GetCompanyPaidUpAndSubscribedShareDetails(i_sConnectionString, i_nCompanyPaidUpAndSubscribedShareCapitalId);
                }

            }
            catch (Exception e)
            {
                throw e;
            }
        }
        #endregion GetCompanyPaidUpAndSubscribedShareDetails

        #region SaveCompanyPaidUpAndSubscribedShareCapitalDetails
        /// <summary>
        /// This method is used for the save company paid & subscribe share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB connection string</param>
        /// <param name="m_objCompanyPaidUpAndSubscribedShareCapitalDTO">Object of CompanyPaidUpAndSubscribedShareCapitalDTO</param>
        /// <returns></returns>
        public bool SaveCompanyPaidUpAndSubscribedShareCapitalDetails(string i_sConnectionString, CompanyPaidUpAndSubscribedShareCapitalDTO m_objCompanyPaidUpAndSubscribedShareCapitalDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveCompanyPaidUpAndSubscribedShareCapitalDetails(i_sConnectionString, m_objCompanyPaidUpAndSubscribedShareCapitalDTO);
                }

            }
            catch (Exception exp)
            {

                throw exp;

            }
        }
        #endregion SaveCompanyPaidUpAndSubscribedShareCapitalDetails

        #region DeleteCompanyPaidUpAndSubscribedShareCapital
        /// <summary>
        /// This method is used for the delete Company Paid & Sunscribe Share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyPaidUpAndSubscribedShareCapitalDTO">ID CompanyPaidUpAndSubscribedShareCapital</param>
        /// <returns></returns>
        public bool DeleteCompanyPaidUpAndSubscribedShareCapital(string i_sConnectionString, int i_nCompanyPaidUpAndSubscribedShareCapitalID)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.DeleteCompanyPaidUpAndSubscribedShareCapital(i_sConnectionString, i_nCompanyPaidUpAndSubscribedShareCapitalID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion DeleteCompanyPaidUpAndSubscribedShareCapital

        #endregion PaidUpAndSubscribedShareCapital

        #region Listing Details

        #region GetCompanyListingDetailsDTODetails
        /// <summary>
        /// This method is used for the get Listing details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="inp_iCompanyListingDetailsId">ID Company Listing details.</param>
        /// <returns></returns>
        public CompanyListingDetailsDTO GetCompanyListingDetails(string i_sConnectionString, int i_nCompanyListingDetailsId)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.GetCompanyListingDetails(i_sConnectionString, i_nCompanyListingDetailsId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetCompanyListingDetailsDTODetails

        #region SaveCompanyListingDetails
        /// <summary>
        /// This method is used for the save Company listing details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyListingDetailsDTO">Object of CompanyListinDetailsDTO</param>
        /// <returns></returns>
        public bool SaveCompanyListingDetails(string i_sConnectionString, CompanyListingDetailsDTO m_objCompanyListingDetailsDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveCompanyListingDetails(i_sConnectionString, m_objCompanyListingDetailsDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SaveCompanyListingDetails

        #region DeleteCompanyListingDetails
        /// <summary>
        /// This methd is used for the delete company listing details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyListingDetailsID">ID of Company Listing details</param>
        /// <returns></returns>
        public bool DeleteCompanyListingDetails(string i_sConnectionString, CompanyListingDetailsDTO m_objCompanyListingDetailsDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.DeleteCompanyListingDetails(i_sConnectionString, m_objCompanyListingDetailsDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion DeleteCompanyListingDetails

        #endregion Listing Details

        #region Compliance Officer

        #region GetCompanyComplianceOfficerDetails
        /// <summary>
        /// This method is used for the Company Compliance Officer details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyComplianceOfficerId">ID Company Compliance Officer</param>
        /// <returns></returns>
        public CompanyComplianceOfficerDTO GetCompanyComplianceOfficerDetails(string i_sConnectionString, int i_nCompanyComplianceOfficerId)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.GetCompanyComplianceOfficerDetails(i_sConnectionString, i_nCompanyComplianceOfficerId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetCompanyComplianceOfficerDetails

        #region SaveCompanyComplianceOfficerDetails
        /// <summary>
        /// This method is used for the save COmpany COmpliance officer details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyComplianceOfficerDTO">object of CompanyComplianceOfficerDTO</param>
        /// <returns></returns>
        public bool SaveCompanyComplianceOfficerDetails(string i_sConnectionString, CompanyComplianceOfficerDTO m_objCompanyComplianceOfficerDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveCompanyComplianceOfficerDetails(i_sConnectionString, m_objCompanyComplianceOfficerDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SaveCompanyComplianceOfficerDetails

        #region DeleteCompanyComplianceOfficer
        /// <summary>
        /// This method is used for the delete Company Compliance officer.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyComplianceOfficerId">Compliance Officer Id</param>
        /// <returns></returns>
        public bool DeleteCompanyComplianceOfficer(string i_sConnectionString, int i_nCompanyComplianceOfficerId)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.DeleteCompanyComplianceOfficer(i_sConnectionString, i_nCompanyComplianceOfficerId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion DeleteCompanyComplianceOfficer

        #endregion Compliance Officer

        #region Company setting configuration

        #region Get Company Configuration Details
        /// <summary>
        /// This method is used to get policy document details
        /// </summary>
        /// <param name="i_sConnectionString">db connection string</param>
        /// <param name="i_nPolicyDocumentId">policy document id</param>
        /// <returns></returns>
        public CompanyConfigurationDTO GetCompanyConfigurationDetails(string i_sConnectionString)
        {
            List<CompanySettingConfigurationDTO> lstCompanySettingConfigurationDTO = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;
            List<PopulateComboDTO> lstDPBankList = null;

            try
            {
                objCompanyConfigurationDTO = new CompanyConfigurationDTO();
                lstDPBankList = new List<PopulateComboDTO>();

                using (var objCompanyDAL = new CompanyDAL())
                {
                    //get list for enter upload setting
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting);

                    //set enter upload setting
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        switch (configSettingDTO.ConfigurationCodeId)
                        {
                            case Common.ConstEnum.Code.DisclosureTypeInitial:
                                objCompanyConfigurationDTO.InitialDisclosure = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.DisclosureTypeContinuous:
                                objCompanyConfigurationDTO.ContinuousDisclosure = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.DisclosureTypePeriodEnd:
                                objCompanyConfigurationDTO.PeriodEndDisclosure = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                        }
                    }

                    //get list for demat account setting
                    lstCompanySettingConfigurationDTO = null;
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting);
                    
                    //set demat setting
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        switch (configSettingDTO.ConfigurationCodeId)
                        {
                            case Common.ConstEnum.Code.PreClearanceType_ImplementingCompany:
                                objCompanyConfigurationDTO.PreClearanceImplementingCompany = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);

                                if (configSettingDTO.IsMappingCode && objCompanyConfigurationDTO.PreClearanceImplementingCompany == Common.ConstEnum.Code.DematAccountSetting_SelectedDemat)
                                {
                                    objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping = this.getConfigurationMappingId(i_sConnectionString, Common.ConstEnum.Code.DematAccount, Common.ConstEnum.Code.PreClearanceType_ImplementingCompany);
                                }

                                break;
                            case Common.ConstEnum.Code.PreClearanceType_NonImplementingCompany:
                                objCompanyConfigurationDTO.PreClearanceNonImplementingCompany = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);

                                if (configSettingDTO.IsMappingCode && objCompanyConfigurationDTO.PreClearanceNonImplementingCompany == Common.ConstEnum.Code.DematAccountSetting_SelectedDemat)
                                {
                                    objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping = this.getConfigurationMappingId(i_sConnectionString, Common.ConstEnum.Code.DematAccount, Common.ConstEnum.Code.PreClearanceType_NonImplementingCompany);
                                }

                                break;
                            case Common.ConstEnum.Code.DisclosureTypeInitial:
                                objCompanyConfigurationDTO.InitialDisclosureTransaction = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);

                                if (configSettingDTO.IsMappingCode && objCompanyConfigurationDTO.InitialDisclosureTransaction == Common.ConstEnum.Code.DematAccountSetting_SelectedDemat)
                                {
                                    objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping = this.getConfigurationMappingId(i_sConnectionString, Common.ConstEnum.Code.DematAccount, Common.ConstEnum.Code.DisclosureTypeInitial);
                                }

                                break;
                            case Common.ConstEnum.Code.DisclosureTypeContinuous:
                                objCompanyConfigurationDTO.ContinuousDisclosureTransaction = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);

                                if (configSettingDTO.IsMappingCode && objCompanyConfigurationDTO.ContinuousDisclosureTransaction == Common.ConstEnum.Code.DematAccountSetting_SelectedDemat)
                                {
                                    objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping = this.getConfigurationMappingId(i_sConnectionString, Common.ConstEnum.Code.DematAccount, Common.ConstEnum.Code.DisclosureTypeContinuous);
                                }

                                break;
                            case Common.ConstEnum.Code.DisclosureTypePeriodEnd:
                                objCompanyConfigurationDTO.PeriodEndDisclosureTransaction = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);

                                if (configSettingDTO.IsMappingCode && objCompanyConfigurationDTO.PeriodEndDisclosureTransaction == Common.ConstEnum.Code.DematAccountSetting_SelectedDemat)
                                {
                                    objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping = this.getConfigurationMappingId(i_sConnectionString, Common.ConstEnum.Code.DematAccount, Common.ConstEnum.Code.DisclosureTypePeriodEnd);
                                }

                                break;
                        }
                    }

                    //get all DP bank name list
                    lstDPBankList.AddRange(Common.Common.GetPopulateCombo(i_sConnectionString, Common.ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.DPName, null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                    lstCompanySettingConfigurationDTO = null;
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_EULAAcceptanceSetting);
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        objCompanyConfigurationDTO.EULAAcceptanceSettings = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                    }



                    //UPSI Setting
                    lstCompanySettingConfigurationDTO = null;
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_UPSISetting);
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        objCompanyConfigurationDTO.UPSISetting = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                    }
                    lstCompanySettingConfigurationDTO = null;
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_ReqiuredEULAReconfirmation);
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        objCompanyConfigurationDTO.ReqiuredEULAReconfirmation = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                        objCompanyConfigurationDTO.EULAAcceptance_DocumentId = Convert.ToInt32(configSettingDTO.ConfigurationValueOptional);
                    }
                    //Email Setting
                    lstCompanySettingConfigurationDTO = null;
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(i_sConnectionString, Common.ConstEnum.Code.CompanyConfigType_MailSetting);
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        switch (configSettingDTO.ConfigurationCodeId)
                        {
                            case Common.ConstEnum.Code.CompanyConfigType_TriggerEmailsUPSIUpdated:
                                objCompanyConfigurationDTO.TriggerEmailsUPSIUpdated = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.CompanyConfigType_TriggerEmailsUPSIPublished:
                                objCompanyConfigurationDTO.TriggerEmailsUPSIpublished = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            

                        }
                        switch (configSettingDTO.ConfigurationCodeId)
                        {
                            case Common.ConstEnum.Code.CompanyConfigType_MailSettingTo:
                                objCompanyConfigurationDTO.SubmittedDefaultMailTo = configSettingDTO.ConfigurationValueOptional;
                                break;
                            case Common.ConstEnum.Code.CompanyConfigType_MailSettingCC:
                                objCompanyConfigurationDTO.SubmittedDefaultMailCC = configSettingDTO.ConfigurationValueOptional;
                                break;


                        }

                    }
                    
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                lstCompanySettingConfigurationDTO = null;
                lstDPBankList = null;
            }

            return objCompanyConfigurationDTO;
        }
        #endregion  Get Company Configuration Details

        #region Save/Update Company Configuration Details
        public CompanyConfigurationDTO SaveCompanyConfigurationDetails(string i_sConnectionString, CompanyConfigurationDTO objCompanyConfigurationDTO, int LoggedInUserID)
        {
            CompanyConfigurationDTO objCompanyConfigurationDTO2 = null;

            DataTable dtblUpdateConfiguration = null;
            DataTable dtblAddConfigurationMapping = null;
            DataTable dtblDeleteConfigurationMapping = null;

            DataRow DataRow = null;
            try
            {
                #region set data table for company configuration
                //Set Data table and its column
                dtblUpdateConfiguration = new DataTable("CompanySettingConfigurationDataTable");

                DataColumn ConfigurationTypeCodeId = new DataColumn("ConfigurationTypeCodeId", typeof(System.Int32));
                ConfigurationTypeCodeId.AllowDBNull = false;

                DataColumn ConfigurationCodeId = new DataColumn("ConfigurationCodeId", typeof(System.Int32));
                ConfigurationCodeId.AllowDBNull = false;

                DataColumn ConfigurationValueCodeId = new DataColumn("ConfigurationValueCodeId", typeof(System.Int32));
                ConfigurationValueCodeId.AllowDBNull = true;

                DataColumn ConfigurationValueOptional = new DataColumn("ConfigurationValueOptional", typeof(System.String));
                ConfigurationValueOptional.AllowDBNull = true;

                DataColumn IsMappingCode = new DataColumn("IsMappingCode", typeof(System.Boolean));
                IsMappingCode.AllowDBNull = false;

                DataColumn ModifiedBy = new DataColumn("ModifiedBy", typeof(System.Int32));
                ModifiedBy.AllowDBNull = false;

                dtblUpdateConfiguration.Columns.Add(ConfigurationTypeCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationValueCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationValueOptional);
                dtblUpdateConfiguration.Columns.Add(IsMappingCode);
                dtblUpdateConfiguration.Columns.Add(ModifiedBy);
                #endregion set data table for company configuration

                #region set data table for adding new company configuration mapping
                //Set Data table and its column
                dtblAddConfigurationMapping = new DataTable("CompanySettingConfigurationMappingDataTable");

                DataColumn MapToTypeCodeId = new DataColumn("MapToTypeCodeId", typeof(System.Int32));
                MapToTypeCodeId.AllowDBNull = false;

                DataColumn ConfigurationMapToId = new DataColumn("ConfigurationMapToId", typeof(System.Int32));
                ConfigurationMapToId.AllowDBNull = false;

                DataColumn ConfigurationValueId = new DataColumn("ConfigurationValueId", typeof(System.Int32));
                ConfigurationValueId.AllowDBNull = true;

                DataColumn ConfigurationValueOptional2 = new DataColumn("ConfigurationValueOptional", typeof(System.String));
                ConfigurationValueOptional2.AllowDBNull = true;

                DataColumn ModifiedBy2 = new DataColumn("ModifiedBy", typeof(System.Int32));
                ModifiedBy2.AllowDBNull = false;

                DataColumn RLSearchLimit = new DataColumn("RLSearchLimit", typeof(System.String));
                RLSearchLimit.AllowDBNull = true;

                dtblAddConfigurationMapping.Columns.Add(MapToTypeCodeId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationMapToId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationValueId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationValueOptional2);
                dtblAddConfigurationMapping.Columns.Add(ModifiedBy2);
                dtblUpdateConfiguration.Columns.Add(RLSearchLimit);
                #endregion set data table for adding new company configuration mapping

                #region set data table for delete existing company configuration mapping
                //set data table to delete mapping records
                dtblDeleteConfigurationMapping = new DataTable("CompanySettingConfigurationMappingDataTable");

                DataColumn MapToTypeCodeId2 = new DataColumn("MapToTypeCodeId", typeof(System.Int32));
                MapToTypeCodeId.AllowDBNull = false;

                DataColumn ConfigurationMapToId2 = new DataColumn("ConfigurationMapToId", typeof(System.Int32));
                ConfigurationMapToId.AllowDBNull = false;

                DataColumn ConfigurationValueId2 = new DataColumn("ConfigurationValueId", typeof(System.Int32));
                ConfigurationValueId.AllowDBNull = true;

                DataColumn ConfigurationValueOptional3 = new DataColumn("ConfigurationValueOptional", typeof(System.String));
                ConfigurationValueOptional2.AllowDBNull = true;

                DataColumn ModifiedBy3 = new DataColumn("ModifiedBy", typeof(System.Int32));
                ModifiedBy2.AllowDBNull = false;

                dtblDeleteConfigurationMapping.Columns.Add(MapToTypeCodeId2);
                dtblDeleteConfigurationMapping.Columns.Add(ConfigurationMapToId2);
                dtblDeleteConfigurationMapping.Columns.Add(ConfigurationValueId2);
                dtblDeleteConfigurationMapping.Columns.Add(ConfigurationValueOptional3);
                dtblDeleteConfigurationMapping.Columns.Add(ModifiedBy3);
                #endregion set data table for delete existing company configuration mapping

                #region add data for enter upload details setting configuration
                //enter-upload configuration for initial disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypeInitial;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.InitialDisclosure;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //enter-upload configuration for continuous disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypeContinuous;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.ContinuousDisclosure;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //enter-upload configuration for period end disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypePeriodEnd;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.PeriodEndDisclosure;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //add data for enter upload details setting configuration
                //demat account configuration for pre-clearance for implementing company
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.PreClearanceType_ImplementingCompany;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.PreClearanceImplementingCompany;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //demat account configuration for pre-clearance for non-implementing company
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.PreClearanceType_NonImplementingCompany;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.PreClearanceNonImplementingCompany;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //demat account configuration for initial disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypeInitial;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.InitialDisclosureTransaction;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //demat account configuration for Continuous disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypeContinuous;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.ContinuousDisclosureTransaction;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //demat account configuration for period end disclosure
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_DematAccountSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.DisclosureTypePeriodEnd;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.PeriodEndDisclosureTransaction;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //EULA Acceptance setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_EULAAcceptanceSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_EULAAcceptanceSetting;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.EULAAcceptanceSettings;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_ReqiuredEULAReconfirmation;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_ReqiuredEULAReconfirmation;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.ReqiuredEULAReconfirmation;
                DataRow["ConfigurationValueOptional"] = objCompanyConfigurationDTO.EULAAcceptance_DocumentId;
                DataRow["IsMappingCode"] = objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping.Count() > 0 ? 1 : 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                // UPSI Setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_UPSISetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_UPSISetting;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.UPSISetting;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);
                // UPSI Email updated Setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_TriggerEmailsUPSIUpdated;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.TriggerEmailsUPSIUpdated;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);
                // UPSI Email Published Setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_TriggerEmailsUPSIPublished;
                DataRow["ConfigurationValueCodeId"] = objCompanyConfigurationDTO.TriggerEmailsUPSIpublished;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);
                // UPSI Email To Setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSettingTo;
                DataRow["ConfigurationValueCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationValueOptional"] = objCompanyConfigurationDTO.SubmittedDefaultMailTo;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);
                // UPSI Email CC Setting
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSettingCC;
                DataRow["ConfigurationValueCodeId"] = Common.ConstEnum.Code.CompanyConfigType_MailSetting;
                DataRow["ConfigurationValueOptional"] = objCompanyConfigurationDTO.SubmittedDefaultMailCC;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblUpdateConfiguration.Rows.Add(DataRow);
                #endregion add data for enter upload details setting configuration

                #region add data to delete demat mapping details 
                //pre-clearance for implemneting company to delete from mapping table
                DataRow = dtblDeleteConfigurationMapping.NewRow();
                DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.PreClearanceType_ImplementingCompany;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblDeleteConfigurationMapping.Rows.Add(DataRow);

                //pre-clearance for non implemneting company to delete from mapping table
                DataRow = dtblDeleteConfigurationMapping.NewRow();
                DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.PreClearanceType_NonImplementingCompany;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblDeleteConfigurationMapping.Rows.Add(DataRow);

                //initial disclosure mapping to delete from mapping table
                DataRow = dtblDeleteConfigurationMapping.NewRow();
                DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypeInitial;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblDeleteConfigurationMapping.Rows.Add(DataRow);

                //continuous disclosure mapping to delete from mapping table
                DataRow = dtblDeleteConfigurationMapping.NewRow();
                DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypeContinuous;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblDeleteConfigurationMapping.Rows.Add(DataRow);

                //period end  disclosure mapping to delete from mapping table
                DataRow = dtblDeleteConfigurationMapping.NewRow();
                DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypePeriodEnd;
                DataRow["ModifiedBy"] = LoggedInUserID;
                dtblDeleteConfigurationMapping.Rows.Add(DataRow);
                #endregion add data to delete demat mapping details

                #region add data for adding mapping details setting configuration
                //pre-clearance for implemneting company mapping records
                for (int i = 0; i < objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping.Count(); i++)
                {
                    DataRow = dtblAddConfigurationMapping.NewRow();
                    DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                    DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.PreClearanceType_ImplementingCompany;
                    DataRow["ConfigurationValueId"] = objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping[i];
                    DataRow["ModifiedBy"] = LoggedInUserID;
                    dtblAddConfigurationMapping.Rows.Add(DataRow);
                }

                //pre-clearance for non implemneting company mapping records
                for (int i = 0; i < objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping.Count(); i++)
                {
                    DataRow = dtblAddConfigurationMapping.NewRow();
                    DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                    DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.PreClearanceType_NonImplementingCompany;
                    DataRow["ConfigurationValueId"] = objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping[i];
                    DataRow["ModifiedBy"] = LoggedInUserID;
                    dtblAddConfigurationMapping.Rows.Add(DataRow);
                }

                //initial disclosure mapping records
                for (int i = 0; i < objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping.Count(); i++)
                {
                    DataRow = dtblAddConfigurationMapping.NewRow();
                    DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                    DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypeInitial;
                    DataRow["ConfigurationValueId"] = objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping[i];
                    DataRow["ModifiedBy"] = LoggedInUserID;
                    dtblAddConfigurationMapping.Rows.Add(DataRow);
                }

                //continuous disclosure mapping records
                for (int i = 0; i < objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping.Count(); i++)
                {
                    DataRow = dtblAddConfigurationMapping.NewRow();
                    DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                    DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypeContinuous;
                    DataRow["ConfigurationValueId"] = objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping[i];
                    DataRow["ModifiedBy"] = LoggedInUserID;
                    dtblAddConfigurationMapping.Rows.Add(DataRow);
                }

                //period end disclosure mapping records
                for (int i = 0; i < objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping.Count(); i++)
                {
                    DataRow = dtblAddConfigurationMapping.NewRow();
                    DataRow["MapToTypeCodeId"] = Common.ConstEnum.Code.DematAccount;
                    DataRow["ConfigurationMapToId"] = Common.ConstEnum.Code.DisclosureTypePeriodEnd;
                    DataRow["ConfigurationValueId"] = objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping[i];
                    DataRow["ModifiedBy"] = LoggedInUserID;
                    dtblAddConfigurationMapping.Rows.Add(DataRow);
                }

                #endregion add data for mapping details setting configuration

                using (CompanyDAL objCompanyDAL = new CompanyDAL())
                {
                    objCompanyDAL.SaveCompanySettingConfiguration(i_sConnectionString, dtblUpdateConfiguration, dtblDeleteConfigurationMapping, dtblAddConfigurationMapping);

                    objCompanyConfigurationDTO2 = GetCompanyConfigurationDetails(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                dtblUpdateConfiguration = null;
                dtblAddConfigurationMapping = null;
                dtblDeleteConfigurationMapping = null;
            }

            return objCompanyConfigurationDTO2;
        }
        #endregion Save/Update Company Configuration Details

        private List<int> getConfigurationMappingId(string i_sConnectionString, int nMapToTypeCodeId, int nConfigurationMapToId)
        {
            List<CompanySettingConfigurationMappingDTO> lstCompanySettingConfigurationMappingDTO = null;
            List<int> lstMappingId = null;

            try
            {
                lstMappingId = new List<int>();

                using (var objCompanyDAL = new CompanyDAL())
                {
                    lstCompanySettingConfigurationMappingDTO = objCompanyDAL.GetCompanySettingConfigurationMappingList(i_sConnectionString, nMapToTypeCodeId, nConfigurationMapToId);

                    if (lstCompanySettingConfigurationMappingDTO.Count() > 0)
                    {
                        foreach (CompanySettingConfigurationMappingDTO configSettingMappingDTO in lstCompanySettingConfigurationMappingDTO)
                        {
                            lstMappingId.Add(Convert.ToInt32(configSettingMappingDTO.ConfigurationValueId));
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                lstCompanySettingConfigurationMappingDTO = null;
            }

            return lstMappingId;
        }


        #region Get Enter Upload Settings Configuration Details
        /// <summary>
        /// This method is used for Get Company Setting Configuration.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyComplianceOfficerId">ID  ConfigurationTypeCodeId</param>
        /// <param name="i_nCompanyComplianceOfficerId">ID  ConfigurationCodeId</param>
        /// <returns></returns>
        public CompanySettingConfigurationDTO GetEnterUploadSettingsConfigurationDetails(string i_sConnectionString, int nConfigurationTypeCodeId, int nConfigurationCodeId)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.GetCompanySettingConfiguration(i_sConnectionString, nConfigurationTypeCodeId, nConfigurationCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Get Enter Upload Settings Configuration Details
        #endregion Company setting configuration

        #region SavePersonalDetailsConfirmation
        /// <summary>
        /// This method is used for the Save Personal Details Confirmation details.
        /// </summary>
        /// <returns></returns>
        public bool SavePersonalDetailsConfirmation(string i_sConnectionString, PersonalDetailsConfirmationDTO m_objPersonalDetailsConfirmationDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SavePersonalDetailsConfirmation(i_sConnectionString, m_objPersonalDetailsConfirmationDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SavePersonalDetailsConfirmation

        #region SaveWorkandEducationDetailsConfiguration
        /// <summary>
        /// This method is used for the Save Work and Education Details Configuration details.
        /// </summary>
        /// <returns></returns>
        public bool SaveWorkandEducationDetailsConfiguration(string i_sConnectionString, WorkandEducationDetailsConfigurationDTO m_objWorkandEducationDetailsConfigurationDTO)
        {
            try
            {
                using (var objCompanyDAL = new InsiderTradingDAL.CompanyDAL())
                {
                    return objCompanyDAL.SaveWorkandEducationDetailsConfiguration(i_sConnectionString, m_objWorkandEducationDetailsConfigurationDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SaveWorkandEducationDetailsConfiguration

        #region GetWorkandeducationDetailsConfiguration
        /// <summary>
        /// This method is used for the Get work and education details configuration.
        /// </summary>
        /// <returns></returns>
        public WorkandEducationDetailsConfigurationDTO GetWorkandeducationDetailsConfiguration(string i_sConnectionString, int i_nCompanyId)
        {
            try
            {
                using (var objCompanyDAL = new CompanyDAL())
                {
                    return objCompanyDAL.GetWorkandeducationDetailsConfiguration(i_sConnectionString, i_nCompanyId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetWorkandeducationDetailsConfiguration

        #region GetPersonal_Details_Confirmation_Frequency
        /// <summary>
        /// This method is used for the Get Personal Details Confirmation Frequency Details.
        /// </summary>
        /// <returns></returns>
        public PersonalDetailsConfirmationDTO GetPersonal_Details_Confirmation_Frequency(string i_sConnectionString, int i_nCompanyId)
        {
            try
            {
                using (var objCompanyDAL = new CompanyDAL())
                {
                    return objCompanyDAL.GetPersonal_Details_Confirmation_Frequency(i_sConnectionString, i_nCompanyId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetPersonal_Details_Confirmation_Frequency

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