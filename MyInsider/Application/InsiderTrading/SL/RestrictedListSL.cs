using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading
{
    public class RestrictedListSL:IDisposable
    {
        #region GetRestrictedListDetails
        /// <summary>
        /// This function will be used for geeting the mapping of activity and resource.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public List<RestrictedListDTO> GetActivityRestrictedListDetails(Hashtable ht_Parameter)
        {
            List<RestrictedListDTO> lstRestrictedListDTO = new List<RestrictedListDTO>();
            try
            {
                //RestrictedListDAL objActivityDAL = new RestrictedListDAL();
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    lstRestrictedListDTO = objRestrictedListDAL.GetActivityRestrictedListDetails(ht_Parameter);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstRestrictedListDTO;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="ht_SearchParam"></param>
        /// <returns></returns>
        public List<RestrictedListDTO> AutoCompleteListSL(string i_sConnectionString, Hashtable ht_SearchParam)
        {
            List<RestrictedListDTO> lstRestrictedListDTO = new List<RestrictedListDTO>();
            try
            {
                //RestrictedListDAL objActivityDAL = new RestrictedListDAL();
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    lstRestrictedListDTO = objRestrictedListDAL.AutoCompleteList(i_sConnectionString, ht_SearchParam);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstRestrictedListDTO;
        }

        public Int32 SaveRestrictedList(string i_sConnectionString, Hashtable ht_SearchParam, DataTable dt_RLList)
        {
            Int32 bReturn;
            try
            {
                //InsiderTradingDAL.RestrictedListDAL objDelegationDetailsDAL = new InsiderTradingDAL.RestrictedListDAL();
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    bReturn = objRestrictedListDAL.SaveRestrictedListData(i_sConnectionString, ht_SearchParam, dt_RLList);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }

        public RestrictedSearchAudittDTO RestrictedlistdetailsSL(string i_sConnectionString, Hashtable ht_SearchParam, out int i_nCount)
        {
            RestrictedSearchAudittDTO resultl = null;
            try
            {
                //RestrictedListDAL objActivityDAL = new RestrictedListDAL();
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    resultl = objRestrictedListDAL.Restrictedlistdetails(i_sConnectionString, ht_SearchParam, out i_nCount );
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return resultl;
        }
        #endregion GetRestrictedListDetails

        /// <summary>
        /// This method is used to get restricted list company details for given company id
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="iCompanyId"></param>
        /// <returns></returns>
        public RestrictedListDTO GetRestrictedListCompanyDetails(string sConnectionString, int iCompanyId)
        {
            RestrictedListDTO objRestrictedListDTO = null;

            try
            {
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    objRestrictedListDTO = objRestrictedListDAL.GetRestrictedListCompanyDetails(sConnectionString, iCompanyId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objRestrictedListDTO;
        }

        /// <summary>
        /// This method is used to get restricted list settings.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public RestrictedListSettingsDTO GetRestrictedListSettings(string sConnectionString)
        {
            List<CompanySettingConfigurationDTO> lstCompanySettingConfigurationDTO = null;
            RestrictedListSettingsDTO objRestrictedListSettingsDTO = null;

            try
            {
                objRestrictedListSettingsDTO = new RestrictedListSettingsDTO();

                using (var objCompanyDAL = new CompanyDAL())
                {
                    //get list for restricted list setting
                    lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(sConnectionString, Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting);

                    //set restricted list setting
                    foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                    {
                        switch (configSettingDTO.ConfigurationCodeId)
                        {
                            case Common.ConstEnum.Code.RestrictedListSetting_Preclearance_required:
                                objRestrictedListSettingsDTO.Preclearance_Required = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Approval:
                                objRestrictedListSettingsDTO.Preclearance_Approval = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Allow_Zero_Balance:
                                objRestrictedListSettingsDTO.Preclearance_AllowZeroBalance = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_Required:
                                objRestrictedListSettingsDTO.Preclearance_FORM_Required_Restricted_company = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                break;
                            case Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_TemplateFile:
                                objRestrictedListSettingsDTO.Preclearance_Form_F_File_Id = Convert.ToInt32(configSettingDTO.ConfigurationValueOptional);
                                break;
                            case Common.ConstEnum.Code.RestrictedListSetting_Allow_Restricted_List_Search:
                                objRestrictedListSettingsDTO.Allow_Restricted_List_Search = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                                objRestrictedListSettingsDTO.RLSearchLimit = configSettingDTO.RLSearchLimit;
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
            }
            return objRestrictedListSettingsDTO;
        }

        #region Save/Update Restricted List Setting
        /// <summary>
        /// This method is used to update restricted list setting
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="objRestrictedListSettingsDTO"></param>
        /// <param name="LoggedInUserID"></param>
        /// <returns></returns>
        public RestrictedListSettingsDTO SaveRestrictedListSettings(string i_sConnectionString, RestrictedListSettingsDTO objRestrictedListSettingsDTO, int LoggedInUserID)
        {
            bool isUpdated = false;

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

                DataColumn RLSearchLimit = new DataColumn("RLSearchLimit", typeof(System.Int32));
                ModifiedBy.AllowDBNull = true;

                dtblUpdateConfiguration.Columns.Add(ConfigurationTypeCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationValueCodeId);
                dtblUpdateConfiguration.Columns.Add(ConfigurationValueOptional);
                dtblUpdateConfiguration.Columns.Add(IsMappingCode);
                dtblUpdateConfiguration.Columns.Add(ModifiedBy);
                dtblUpdateConfiguration.Columns.Add(RLSearchLimit);
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

                dtblAddConfigurationMapping.Columns.Add(MapToTypeCodeId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationMapToId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationValueId);
                dtblAddConfigurationMapping.Columns.Add(ConfigurationValueOptional2);
                dtblAddConfigurationMapping.Columns.Add(ModifiedBy2);
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

                #region add data for restricted list setting
                //restricted list setting - preclearance required
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Preclearance_required;
                DataRow["ConfigurationValueCodeId"] = objRestrictedListSettingsDTO.Preclearance_Required;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                DataRow["RLSearchLimit"] = 0;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //restricted list setting - preclearance approval
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Approval;
                DataRow["ConfigurationValueCodeId"] = objRestrictedListSettingsDTO.Preclearance_Approval;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                DataRow["RLSearchLimit"] = 0;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //restricted list setting - preclearance allowed at zero balance
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Allow_Zero_Balance;
                DataRow["ConfigurationValueCodeId"] = objRestrictedListSettingsDTO.Preclearance_AllowZeroBalance;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                DataRow["RLSearchLimit"] = 0;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //restricted list setting - preclearance form-f required
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_Required;
                DataRow["ConfigurationValueCodeId"] = objRestrictedListSettingsDTO.Preclearance_FORM_Required_Restricted_company;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                DataRow["RLSearchLimit"] = 0;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //restricted list setting - allow restricted list search
                DataRow = dtblUpdateConfiguration.NewRow();
                DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Allow_Restricted_List_Search;
                DataRow["ConfigurationValueCodeId"] = objRestrictedListSettingsDTO.Allow_Restricted_List_Search;
                DataRow["IsMappingCode"] = 0;
                DataRow["ModifiedBy"] = LoggedInUserID;
                DataRow["RLSearchLimit"] = objRestrictedListSettingsDTO.RLSearchLimit;
                dtblUpdateConfiguration.Rows.Add(DataRow);

                //COMMENTED BECAUSE - form F document Id update at db level
                //restricted list setting - preclearance form-f doucment id 
                //DataRow = dtblUpdateConfiguration.NewRow();
                //DataRow["ConfigurationTypeCodeId"] = Common.ConstEnum.Code.CompanyConfigType_RestrictedListSetting;
                //DataRow["ConfigurationCodeId"] = Common.ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_TemplateFile;
                //DataRow["ConfigurationValueOptional"] = objRestrictedListSettingsDTO.Preclearance_Form_F_File_Id;
                //DataRow["IsMappingCode"] = 0;
                //DataRow["ModifiedBy"] = LoggedInUserID;
                //dtblUpdateConfiguration.Rows.Add(DataRow);

                
                #endregion add data for restricted list setting

                using (CompanyDAL objCompanyDAL = new CompanyDAL())
                {
                    isUpdated = objCompanyDAL.SaveCompanySettingConfiguration(i_sConnectionString, dtblUpdateConfiguration, dtblDeleteConfigurationMapping, dtblAddConfigurationMapping);
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

            return objRestrictedListSettingsDTO;
        }
        #endregion Save/Update Restricted List Setting

        public int RestrictedlistSearchLimit(string sConnectionString, int iUserId)
        {
            int resultCode = 0;

            try
            {
                using (var objRestrictedListDAL = new RestrictedListDAL())
                {
                    resultCode = objRestrictedListDAL.RestrictedlistSearchLimit(sConnectionString, iUserId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return resultCode;
        }

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