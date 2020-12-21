using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class RestrictedListController : Controller
    {
        private string sLookupPrefix;
        LoginUserDetails objLoginUserDetails;
        RestrictedListSL restrictedListSL;

        public RestrictedListController()
        {
            sLookupPrefix = "rul_msg_";
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            restrictedListSL = new RestrictedListSL();
        }

        // GET: /RestrictedList/
        #region [Index]
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, RestrictedListModel rlModel)
        {
            try
            {
                ViewBag.CompanyNameDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "1", null, null, null, null, true, sLookupPrefix);
                ViewBag.CreatedByDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "5", null, null, null, null, true, sLookupPrefix);
                ViewBag.ScreenList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.RestrictedList.ToString(), null, null, null, null, true);
                List<PopulateComboDTO> statusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedListStatus, null, null, null, null, null, true, sLookupPrefix);
                statusList.RemoveAt(0);
                string defaultStatus = "511001";
                var newStatusList = new List<SelectListItem>();
                foreach (var item in statusList)
                {
                    newStatusList.Add(new SelectListItem()
                    {
                        Text = item.Value,
                        Value = item.Key,
                        Selected = (item.Key == defaultStatus ? true : false)
                    });
                }
                ViewBag.Countries = newStatusList;
                ViewBag.RestrictedListStatus = statusList;
                ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                ViewBag.RID = "/EFMo9hRx5g=";
                ViewBag.acid = acid;
            }
            catch
            {

            }
            return View();
        }
        #endregion [Index]

        #region Employee/Insider List Autocomplete Code
        /// <summary>
        /// This methode is used to auto fill the textboxes
        /// </summary>
        /// <param name="CompanyName"></param>
        /// <returns></returns>
        public JsonResult GetExistNSEBSEDetailsJSON(string CompanyName = "")
        {
            List<RestrictedListDTO> objListt;
            RestrictedListModel restrictedListModel = new RestrictedListModel();
            restrictedListSL = new RestrictedListSL();
            restrictedListModel.Action = "DETAILS";
            restrictedListModel.Details = CompanyName;
            List<RestrictedListDTO> objList = restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel));

            return Json(objListt = objList, JsonRequestBehavior.AllowGet);
        }

        public ActionResult RestrictedListSearch()
        {
            int RequiredModuleID = 0;
            try
            {
                CompanySettingConfigurationDTO objCompanySettingConfigurationDTO = null;
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    ViewBag.RequiredModule = true;
                }
                else
                {
                    ViewBag.RequiredModule = false;
                }
                                
                if(ViewBag.RequiredModule == true)
                {
                    ViewBag.FormFRequire = InsiderTrading.Common.ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                }
                else
                {
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_Required);
                        ViewBag.FormFRequire = objCompanySettingConfigurationDTO.ConfigurationValueCodeId;
                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_TemplateFile);
                        ViewBag.DocumentId = objCompanySettingConfigurationDTO.ConfigurationValueOptional;
                    }

                }
                
                TemplateMasterDTO objTemplateMasterDTO = null;
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.GetFormETemplate(objLoginUserDetails.CompanyDBConnectionString);
                    if (objTemplateMasterDTO != null)
                    {
                        ViewBag.IsFormEtemplateMsgShow = false;
                    }
                    else
                    {
                        ViewBag.IsFormEtemplateMsgShow = true;
                    }

                }
                ViewBag.IsPreClearanceAllow = TempData["IsPreClearanceAllow"] == null ? false : TempData["IsPreClearanceAllow"];
                ViewBag.GridAllow = TempData["GridAllow"] == null ? false : TempData["GridAllow"];
                TempData.Remove("IsPreClearanceAllow");
                TempData.Remove("GridAllow");
               
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View();
            }
            return View();
        }

        /// <summary>
        /// This methode is used to save the data and show pop up message.
        /// </summary>
        /// <param name="restrictedListModel"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RestrictedListSearch(RestrictedListModel restrictedListModel)
        {
            ViewBag.IsPreClearanceAllow = false;
            ViewBag.GridAllow = false;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            RestrictedSearchAudittDTO objRestrictedSearchAudittDTO = null;
            try
            {
                int result = 0;
                int resultCode = 0;
                int resultMsgCode = 0;
                int resultSPCode=0;
                CompanySettingConfigurationDTO restrictedListSettingPreclearanceApproval = null;
                string AlertMessage = string.Empty;
                int RequiredModuleID = 0;
                bool isModelRequired = false;
                restrictedListSL = new RestrictedListSL();
                CompanySettingConfigurationDTO objCompanySettingConfigurationDTO = null;
                TradingPolicyDTO_OS objTradingPolicyDTO_OS = null;

                TemplateMasterDTO objTemplateMasterDTO = null;
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.GetFormETemplate(objLoginUserDetails.CompanyDBConnectionString);
                    if (objTemplateMasterDTO != null)
                    {
                        ViewBag.IsFormEtemplateMsgShow = false;
                    }
                    else
                    {
                        ViewBag.IsFormEtemplateMsgShow = true;
                    }

                }
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    isModelRequired = true;
                    ViewBag.Acid = ConstEnum.UserActions.PreclearanceRequestOtherSecurities;
                    ViewBag.IRListSearch = ConstEnum.UserActions.PreclearanceRequestOtherSecurities;
                }
                else
                {
                    ViewBag.InsiDiscoPreCleRequestNIC = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION;
                    ViewBag.IRListSearch = ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                    isModelRequired = false;
                }
                ViewBag.RequiredModule = isModelRequired;
             //Add the new code for the other security Restricted list  (03/02/2020) 
                if (isModelRequired == false)
                {
                                        
                    RestrictedListSL objRestrictedListSL = new RestrictedListSL();
                    resultSPCode = objRestrictedListSL.RestrictedlistSearchLimit(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_Required);
                        ViewBag.FormFRequire = objCompanySettingConfigurationDTO.ConfigurationValueCodeId;
                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Form_F_TemplateFile);
                        ViewBag.DocumentId = objCompanySettingConfigurationDTO.ConfigurationValueOptional;
                    }
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_required);

                    }
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        restrictedListSettingPreclearanceApproval = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Approval);
                    }
                }
                else
                {
                    ViewBag.FormFRequire = InsiderTrading.Common.ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                    RestrictedListSL objRestrictedListSL = new RestrictedListSL();
                    resultSPCode = objRestrictedListSL.RestrictedlistSearchLimit(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    using (TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS())
                    {
                        objTradingPolicyDTO_OS = objTradingPolicySL_OS.GetTradingPolicySettingConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    }
                }
                
                using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                {
                    resultMsgCode = objRestrictedListSL.RestrictedlistSearchLimit(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    if (resultMsgCode == 1)
                    {
                        TempData["RestrictedListValue"] = "1";
                        objRestrictedSearchAudittDTO = restrictedListSL.RestrictedlistdetailsSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel), out result);
                       
                        if (result > 0)
                        {
                            ArrayList lst = new ArrayList();
                            lst.Add(restrictedListModel.CompanyName.Replace("'", "\'").Replace("\"", "\""));
                            ViewBag.AlertMsg = Common.Common.getResource("rl_msg_50016", lst);
                            if (TempData["List"] != null || TempData["PreClrList"] != null)
                            {
                                ViewBag.GridAllow = true;
                            }
                            else
                            {
                                ViewBag.GridAllow = false;
                            }
                            return View();
                        }
                        else
                        {
                            if (isModelRequired == false)
                            {
                                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                                {
                                    objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_required);

                                }
                                if (objLoginUserDetails.DateOfBecomingInsider != null && objCompanySettingConfigurationDTO.ConfigurationValueCodeId == ConstEnum.Code.CompanyConfig_YesNoSettings_Yes)
                                {

                                    ViewBag.RLSearchAudId = objRestrictedSearchAudittDTO.RlSearchAuditId;
                                    ViewBag.RLCompId = objRestrictedSearchAudittDTO.RlCompanyId;

                                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                                    {
                                        objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.CompanyConfigType_RestrictedListSetting, ConstEnum.Code.RestrictedListSetting_Preclearance_Approval);
                                        if (objCompanySettingConfigurationDTO.ConfigurationValueCodeId == ConstEnum.Code.RestrictedList_PreclearanceApproval_Manual)
                                        {
                                            if (TempData["List"] != null || TempData["PreClrList"] != null)
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = true;
                                            }
                                            else
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = false;
                                            }
                                        }
                                        else
                                        {
                                            if (TempData["List"] != null || TempData["PreClrList"] != null)
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = true;
                                            }
                                            else
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = false;
                                            }
                                        }
                                    }

                                }
                                else
                                {
                                    ArrayList lst = new ArrayList();
                                    lst.Add(restrictedListModel.CompanyName.Replace("'", "\'").Replace("\"", "\""));
                                    ViewBag.AlertMsg = Common.Common.getResource("rl_msg_50015", lst);
                                    return View();
                                }
                            }
                            else
                            {
                                if (objLoginUserDetails.DateOfBecomingInsider != null && objTradingPolicyDTO_OS.IsPreClearanceRequired==true)
                                {
                                    ViewBag.RLSearchAudId = objRestrictedSearchAudittDTO.RlSearchAuditId;
                                    ViewBag.RLCompId = objRestrictedSearchAudittDTO.RlCompanyId;

                                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                                    {

                                        if (objTradingPolicyDTO_OS.PreClrTradesApprovalReqFlag == true)                                            
                                        {
                                            if (TempData["List"] != null || TempData["PreClrList"] != null)
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = true;
                                            }
                                            else
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = false;
                                            }
                                        }
                                        else
                                        {
                                            if (TempData["List"] != null || TempData["PreClrList"] != null)
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = true;
                                            }
                                            else
                                            {
                                                ViewBag.IsPreClearanceAllow = true;
                                                ViewBag.GridAllow = false;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    ArrayList lst = new ArrayList();
                                    lst.Add(restrictedListModel.CompanyName.Replace("'", "\'").Replace("\"", "\""));
                                    ViewBag.AlertMsg = Common.Common.getResource("rl_msg_50015", lst);
                                    return View();
                                }

                            }
                        }
                    }
                    else
                    {
                        TempData["RestrictedListValue"] = "1";
                        ViewBag.AlertMsg = Common.Common.getResource("rl_msg_" + resultMsgCode);
                        if (TempData["List"] != null || TempData["PreClrList"] != null)
                        {
                            ViewBag.GridAllow = true;
                        }
                        return View();
                    }
                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View();
            }
            return View();
        }

        /// <summary>
        /// This method is use for Autocomplete Company Name
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>
        public JsonResult GetList(string term = "")
        {
            try
            {
                RestrictedListModel restrictedListModel = new RestrictedListModel();
                restrictedListSL = new RestrictedListSL();
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.CompanyName = term;
                RestrictedListDTO[] matching = String.IsNullOrEmpty(term) ? restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.CompanyName.ToLower().Contains(term.ToLower())).ToArray();

                return Json(matching.Select(m => new
                {
                    Id = m.RLCompanyId,
                    CompanyName = m.CompanyName
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }

        /// <summary>
        /// This methode is use for Autocomplete ISIN Code
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>
        public JsonResult GetISINList(string term = "")
        {
            try
            {
                RestrictedListModel restrictedListModel = new RestrictedListModel();
                restrictedListSL = new RestrictedListSL();
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.ISINCode = term;
                RestrictedListDTO[] matching = String.IsNullOrEmpty(term) ? restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.ISINCode.ToLower().Contains(term.ToLower())).ToArray();

                return Json(matching.Select(m => new
                {
                    Id = m.RLCompanyId,
                    ISINCode = m.ISINCode
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }

        /// <summary>
        /// This methode is use for Autocomplete NSC Code
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>
        public JsonResult GetNSCList(string term = "")
        {
            try
            {
                RestrictedListModel restrictedListModel = new RestrictedListModel();
                restrictedListSL = new RestrictedListSL();
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.NSECode = term;
                RestrictedListDTO[] matching = String.IsNullOrEmpty(term) ? restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.NSECode.ToLower().Contains(term.ToLower())).ToArray();

                return Json(matching.Select(m => new
                {
                    Id = m.RLCompanyId,
                    NSECode = m.NSECode
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }

        /// <summary>
        /// This methode is use for Autocomplete BSC Code
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>
        public JsonResult GetBSCList(string term = "")
        {
            try
            {
                RestrictedListModel restrictedListModel = new RestrictedListModel();
                restrictedListSL = new RestrictedListSL();
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.BSECode = term;
                RestrictedListDTO[] matching = String.IsNullOrEmpty(term) ? restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    restrictedListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.BSECode.Contains(term)).ToArray();

                return Json(matching.Select(m => new
                {
                    Id = m.RLCompanyId,
                    BSECode = m.BSECode
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }


        /// <summary>
        /// This method is used to set parameters.
        /// </summary>
        /// <param name="rlm"></param>
        /// <returns></returns>
        private Hashtable AutoCompleteSearchParameters(RestrictedListModel rlm)
        {
            Hashtable HT_SearchParam = new Hashtable();
            HT_SearchParam.Add("Action", rlm.Action);
            HT_SearchParam.Add("Details", rlm.Details);
            HT_SearchParam.Add("UserId", objLoginUserDetails.LoggedInUserID);
            HT_SearchParam.Add("CompanyName", rlm.CompanyName);
            HT_SearchParam.Add("ISINCode", rlm.ISINCode);
            HT_SearchParam.Add("BSECode", rlm.BSECode);
            HT_SearchParam.Add("NSECode", rlm.NSECode);
            return HT_SearchParam;
        }
        #endregion

        #region [Create]
        /// <summary>
        /// This method is used for display Restricted View details
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(RestrictedListModel restrictedListModel, int acid, string CalledFrom = "", Int32 nMasterID = 0, Int32 nApplicabilityId = 0, Int32 RuleId = 0)
        {
            bool isAllEdit = false;
            bool showSaveButton = false;
            bool showApplicabilityButton = false;
            bool isPartialEdit = false;
            string applicablityNotDefineMsg = "";

            Int32 nCase = 2;

            #region [Fill Drop down data]
            ViewBag.CompanyNameDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "1", null, null, null, null, true, sLookupPrefix);
            ViewBag.NSECodeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "3", null, null, null, null, true, sLookupPrefix);
            ViewBag.BSECodeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "2", null, null, null, null, true, sLookupPrefix);
            ViewBag.ISINCodeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "4", null, null, null, null, true, sLookupPrefix);

            DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
            restrictedListModel.ApplicableFrom = currentDBDate;
            ViewBag.applicablityNotDefineMsg = applicablityNotDefineMsg;
            #endregion

            if (nMasterID != 0 || RuleId != 0)
            {
                restrictedListModel.RLCompanyId = ((nMasterID.Equals(0) && !RuleId.Equals(0)) ? RuleId : nMasterID);
                List<RestrictedListDTO> lstRestrictedListDTO = GetRListDetailsFromSL(restrictedListSL, objLoginUserDetails, nCase, restrictedListModel);
                if (lstRestrictedListDTO.Count > 0)
                    GetValueFromDTOtoModel(lstRestrictedListDTO, ref restrictedListModel);

                #region [Bind data to ViewBag]
                ViewBag.CompanyId = restrictedListModel.CompanyId;
                ViewBag.CompanyName = restrictedListModel.CompanyName;
                ViewBag.BSECode = restrictedListModel.BSECode;
                ViewBag.NSECode = restrictedListModel.NSECode;
                ViewBag.ISINCode = restrictedListModel.ISINCode;
                ViewBag.ApplicableFrom = InsiderTrading.Common.Common.ApplyFormatting(restrictedListModel.ApplicableFrom, ConstEnum.DataFormatType.Date).Split(' ')[0].ToString();
                ViewBag.ApplicableTo = InsiderTrading.Common.Common.ApplyFormatting(restrictedListModel.ApplicableTo, ConstEnum.DataFormatType.Date).Split(' ')[0].ToString();
                ViewBag.RlMasterId = restrictedListModel.RlMasterId;
                ViewBag.nMasterID = nMasterID;
                ViewBag.nApplicabilityID = nApplicabilityId;
                ViewBag.CurrentDate = currentDBDate;
                #endregion

                #region [Edit & View Functionality]
                if (!string.IsNullOrEmpty(CalledFrom))
                {
                    switch (CalledFrom)
                    {
                        case "E":
                        case "Edit":
                            ViewBag.UserAction = acid;
                            ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                            ViewBag.isAllView = !(ViewBag.isAllEdit = isAllEdit);
                            ViewBag.showSaveButton = !showSaveButton;
                            ViewBag.showApplicabilityButton = !showApplicabilityButton;
                            ViewBag.CalledFrom = CalledFrom;
                            ViewBag.isPartialEdit = isPartialEdit;
                            break;

                        case "V":
                        case "View":
                            ViewBag.UserAction = acid;
                            ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                            ViewBag.isAllView = ViewBag.isAllEdit = isAllEdit;
                            ViewBag.showSaveButton = showSaveButton;
                            ViewBag.showApplicabilityButton = showApplicabilityButton;
                            ViewBag.CalledFrom = CalledFrom;
                            ViewBag.isPartialEdit = isPartialEdit;
                            break;

                        case "H":
                        case "History":
                            ViewBag.UserAction = acid;
                            ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                            ViewBag.isAllView = ViewBag.isAllEdit = isAllEdit;
                            ViewBag.showSaveButton = showSaveButton;
                            ViewBag.showApplicabilityButton = showApplicabilityButton;
                            ViewBag.CalledFrom = CalledFrom;
                            ViewBag.isPartialEdit = isPartialEdit;
                            break;
                    }
                }
                #endregion
                return View(restrictedListModel);
            }
            else
            {
                ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                ViewBag.isPartialEdit = false;
                ViewBag.isAllView = ViewBag.isAllEdit = (acid.Equals(InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_VIEW) || acid.Equals(InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_HISTORY)) ? isAllEdit : (acid.Equals(InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_EDIT) || acid.Equals(InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_CREATE)) ? !isAllEdit : isAllEdit;
                ViewBag.showSaveButton = !showSaveButton;
                ViewBag.CalledFrom = "C"; ViewBag.showApplicabilityButton = showApplicabilityButton;
                return View(restrictedListModel);
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(RestrictedListModel rListModel, Int32? nApplicableID = 0, Int32 RuleId = 0)
        {
            Int32? nRLMasterID = 0;
            nApplicableID = (rListModel.RlMasterId == null) ? 0 : rListModel.RlMasterId;
            string sCompanyID = string.Empty;
            string itemName = string.Empty;
            DateTime dateNull = Convert.ToDateTime(null);
            string sError = string.Empty;
            string i_ErrorMessage = "";
            bool bErrorOccurred = false;
            bool isAllEdit = false;
            bool showSaveButton = false;
            bool showApplicabilityButton = false;
            bool isPartialEdit = false;
            string applicablityNotDefineMsg = "";
            string AlertMessage = string.Empty;
            try
            {
                #region [Save Operations]
                if (Convert.ToString(Request.Form["hdnCalledFrom"]) != "Edit")
                {
                    if (rListModel.CompanyId == null)
                    {
                        i_ErrorMessage = "CompanyName field are required.";
                        bErrorOccurred = true;
                    }
                    else if (rListModel.ApplicableFrom == null && rListModel.ApplicableTo == null)
                    {
                        i_ErrorMessage = "ApplicableFrom date, ApplicableTo date fields are required.";
                        bErrorOccurred = true;
                    }
                    else if (rListModel.ApplicableFrom != null && rListModel.ApplicableTo == null)
                    {
                        i_ErrorMessage = "ApplicableTo date field is required.";
                        bErrorOccurred = true;
                    }
                    else if (rListModel.ApplicableFrom == null && rListModel.ApplicableTo != null)
                    {
                        i_ErrorMessage = "ApplicableFrom date field is required.";
                        bErrorOccurred = true;
                    }
                    else
                    {
                        if (rListModel.ApplicableFrom < Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                        {
                            i_ErrorMessage = "ApplicableFrom date should be current or future date.";
                            bErrorOccurred = true;
                        }
                        else if (!(rListModel.ApplicableFrom <= rListModel.ApplicableTo))
                        {
                            i_ErrorMessage = "ApplicableTo date should be greater than or equal to ApplicableFrom date.";
                            bErrorOccurred = true;
                        }
                    }
                }
                else
                {
                    if (!(rListModel.ApplicableFrom <= rListModel.ApplicableTo))
                    {
                        i_ErrorMessage = "ApplicableTo date should be greater than or equal to ApplicableFrom date.";
                        bErrorOccurred = true;
                        //ViewBag.UserAction = acid;
                        //ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                        //ViewBag.isAllView = !(ViewBag.isAllEdit = isAllEdit);
                        //ViewBag.showSaveButton = !showSaveButton;
                        //ViewBag.showApplicabilityButton = !showApplicabilityButton;
                        //ViewBag.CalledFrom = Convert.ToString(Request.Form["hdnCalledFrom"]);
                        //ViewBag.isPartialEdit = isPartialEdit;
                    }
                    else if (rListModel.ApplicableTo <= Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                    {
                        i_ErrorMessage = "ApplicableTo date should be future date.";
                        bErrorOccurred = true;
                    }
                }
                if (bErrorOccurred)
                {
                    ViewBag.ValidationError = i_ErrorMessage;
                    ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                    ViewBag.isAllView = !(ViewBag.isAllEdit = isAllEdit);
                    ViewBag.showSaveButton = !showSaveButton;
                    ViewBag.showApplicabilityButton = !showApplicabilityButton;
                    ViewBag.CalledFrom = Convert.ToString(Request.Form["hdnCalledFrom"]);
                    ViewBag.isAllEdit = Convert.ToString(Request.Form["hdnCalledFrom"]) == "C" ? true : false;
                    ViewBag.isPartialEdit = isPartialEdit;
                    ViewBag.CompanyNameDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "1", null, null, null, null, true, sLookupPrefix);
                    //ViewBag.showApplicabilityButton = false;
                    return View(rListModel);
                }

                if (!ModelState.IsValid)
                {
                    ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                    ViewBag.isPartialEdit = true;
                    ViewBag.isAllView = !(ViewBag.isAllEdit = true);
                    ViewBag.showSaveButton = !false;
                    ViewBag.CompanyNameDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RestrictedList, "1", null, null, null, null, true, sLookupPrefix);
                    ViewBag.CalledFrom = "C"; ViewBag.showApplicabilityButton = false;
                    return View(rListModel);
                }
                else
                {
                    DataTable dt_RestrictedList;
                    Hashtable hashtable;

                    sCompanyID = RestrictedMaster_DefaultDataField(rListModel, nApplicableID, sCompanyID, out dt_RestrictedList, out hashtable);
                    rListModel = null;
                    nRLMasterID = restrictedListSL.SaveRestrictedList(objLoginUserDetails.CompanyDBConnectionString, hashtable, dt_RestrictedList);
                    if (nRLMasterID != 0)
                    {
                        ViewBag.CalledFrom = "Edit";
                        ViewBag.GridType = ConstEnum.GridType.RestrictedList;
                        List<RestrictedListDTO> lstRestrictedListDTO = Com_GetCompanyInformation(sCompanyID, restrictedListSL, objLoginUserDetails, 1);
                        ArrayList lst = new ArrayList();
                        if (lstRestrictedListDTO.Count > 0)
                        {
                            lst.Add(lstRestrictedListDTO[0].CompanyName.Replace("'", "\'").Replace("\"", "\""));
                            GetValueFromDTOtoModel(lstRestrictedListDTO, ref rListModel);
                        }
                        if (nRLMasterID == -1)
                        {
                            AlertMessage = Common.Common.getResource("cmp_msg_13120", lst);//already exists
                        }
                        else if (nRLMasterID == -10)
                        {
                            AlertMessage = Common.Common.getResource("cmp_msg_50771", lst);//Entry is already present for the same date period
                        }
                        else
                        {
                            AlertMessage = Common.Common.getResource("cmp_msg_13107", lst);//saved successfully
                        }
                        ViewBag.UserAction = InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_CREATE;
                        return RedirectToAction("Create", new { acid = InsiderTrading.Common.ConstEnum.UserActions.RESTRICTED_CREATE, CalledFrom = "Edit", nMasterID = nRLMasterID }).Success(HttpUtility.UrlEncode(AlertMessage));
                    }
                }
                #endregion
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index", rListModel);
            }
            return View();
        }

        private string RestrictedMaster_DefaultDataField(RestrictedListModel rListModel, Int32? nApplicableID, string sCompanyID, out DataTable dt_RestrictedList, out Hashtable hashtable)
        {
            #region [Dynamic Data Binding to collection objects]
            dt_RestrictedList = new DataTable("RestrictedListType");
            dt_RestrictedList.Columns.Add(new DataColumn("ComapnyId", typeof(int)));
            dt_RestrictedList.Columns.Add(new DataColumn("ApplicableFromDate", typeof(DateTime)));
            dt_RestrictedList.Columns.Add(new DataColumn("ApplicableToDate", typeof(DateTime)));

            DataRow drow = dt_RestrictedList.NewRow();
            drow["ComapnyId"] = sCompanyID = Convert.ToString(rListModel.CompanyId);
            drow["ApplicableFromDate"] = rListModel.ApplicableFrom;
            drow["ApplicableToDate"] = rListModel.ApplicableTo;
            dt_RestrictedList.Rows.Add(drow);

            hashtable = new Hashtable();
            hashtable.Add("UserInfoId", objLoginUserDetails.LoggedInUserID);
            hashtable.Add("LoggedInUserId", objLoginUserDetails.LoggedInUserID);
            hashtable.Add("inp_iRlMasterId", nApplicableID);
            hashtable.Add("inp_sActionType", (nApplicableID.Equals(0) ? "CREATE" : "UPDATE"));


            #endregion [Dynamic Data Binding to collection objects]
            return sCompanyID;
        }

        #endregion [Create]

        #region [History]
        public ActionResult History(int acid, Int32 nMasterID = 0)
        {
            ViewBag.GridType = ConstEnum.GridType.RestrictedList;
            ViewBag.RlMasterId = nMasterID;
            return View();
        }
        #endregion [History]

        #region [Display Gray List Data]
        [AuthorizationPrivilegeFilter]
        public ActionResult Read(int acid, Int32 nRlMasterId = 0, string CalledFrom = "")
        {
            ViewBag.isAllEdit = false;
            ViewBag.GridType = ConstEnum.GridType.RestrictedList;
            ViewBag.showApplicabilityButton = true;
            ViewBag.CalledFrom = CalledFrom;
            return View();
        }
        #endregion
        #region [Private & Public Methods]
        /// <summary>
        /// This method is used for Get Company Details and return JsonResult
        /// </summary>
        /// <param name="companyid">Selected Company ID</param>
        /// <returns>It will return JsonResult</returns>
        public JsonResult GetCompanyDetails(string companyid = "")
        {
            //RestrictedListSL restrictedListSL = new RestrictedListSL();
            //LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            List<RestrictedListDTO> lstRestrictedListDTO = Com_GetCompanyInformation(companyid, restrictedListSL, objLoginUserDetails, 1);
            return Json(
                        new
                        {
                            lstRestrictedListDTO[0].RLCompanyId,
                            lstRestrictedListDTO[0].CompanyName,
                            lstRestrictedListDTO[0].BSECode,
                            lstRestrictedListDTO[0].NSECode,
                            lstRestrictedListDTO[0].ISINCode
                        }, JsonRequestBehavior.AllowGet);

        }

        /// <summary>
        /// This method is used for fetching the Restricted List details based on nCase Value
        /// </summary>
        /// <param name="companyid">Company ID</param>
        /// <param name="restrictedListSL">SL class object</param>
        /// <param name="objLoginUserDetails">Session Object</param>
        /// <param name="nCase">Case value</param>
        /// <returns></returns>
        private List<RestrictedListDTO> Com_GetCompanyInformation(string companyid, RestrictedListSL restrictedListSL, LoginUserDetails objLoginUserDetails, int nCase)
        {
            RestrictedListModel restrictedListModel = new RestrictedListModel();
            restrictedListModel.CompanyName = companyid;
            InsiderTradingDAL.RestrictedListDTO objRestrictedListDTO = new InsiderTradingDAL.RestrictedListDTO();
            InsiderTrading.Common.Common.CopyObjectPropertyByName(restrictedListModel, objRestrictedListDTO);
            //, string i_sConnectionString, int inp_iUserInfoId, string i_sCompanyID, int inp_iCase
            List<RestrictedListDTO> lstRestrictedListDTO = GetRListDetailsFromSL(restrictedListSL, objLoginUserDetails, nCase, restrictedListModel);
            return lstRestrictedListDTO;
        }

        private static List<RestrictedListDTO> GetRListDetailsFromSL(RestrictedListSL restrictedListSL, LoginUserDetails objLoginUserDetails, int nCase, RestrictedListModel restrictedListModel)
        {
            Hashtable ht_Param = new Hashtable();
            ht_Param.Add("i_sConnectionString", objLoginUserDetails.CompanyDBConnectionString);
            ht_Param.Add("inp_iUserInfoId", objLoginUserDetails.LoggedInUserID);
            ht_Param.Add("inp_iCase", nCase);
            switch (nCase)
            {
                case 1:
                    ht_Param.Add("i_sCompanyID", restrictedListModel.CompanyName);
                    break;
                case 2:
                    ht_Param.Add("i_sCompanyID", restrictedListModel.RLCompanyId);
                    break;
            }

            List<RestrictedListDTO> lstRestrictedListDTO = restrictedListSL.GetActivityRestrictedListDetails(ht_Param);
            return lstRestrictedListDTO;
        }

        /// <summary>
        /// This method is used to fill Combobox Values
        /// </summary>
        /// <param name="i_sDBConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="i_bIsDefaultValue"></param>
        /// <param name="i_sLookupPrefix"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(string i_sDBConnectionString, int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue, string i_sLookupPrefix)
        {
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;
            try
            {
                objPopulateComboDTO = new PopulateComboDTO();
                lstPopulateComboDTO = new List<PopulateComboDTO>();

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "";

                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }

                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(i_sDBConnectionString, i_nComboType, i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, i_sLookupPrefix).ToList<PopulateComboDTO>());

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstPopulateComboDTO;
        }

        /// <summary>
        /// This method is used for Binding DTO data to Model
        /// </summary>
        /// <param name="lstrlDTO"></param>
        /// <param name="rListModel"></param>
        private void GetValueFromDTOtoModel(List<RestrictedListDTO> lstrlDTO, ref RestrictedListModel rListModel)
        {
            RestrictedListModel rLModel = new RestrictedListModel();
            rLModel.CompanyId = lstrlDTO[0].RLCompanyId;
            rLModel.CompanyName = lstrlDTO[0].CompanyName;
            rLModel.BSECode = lstrlDTO[0].BSECode;
            rLModel.NSECode = lstrlDTO[0].NSECode;
            rLModel.ISINCode = lstrlDTO[0].ISINCode;
            rLModel.RlMasterId = lstrlDTO[0].RlMasterId;
            rLModel.UserName = lstrlDTO[0].UserName;
            rLModel.CreatedBy = lstrlDTO[0].CreatedBy;
            rLModel.ApplicableFrom = lstrlDTO[0].ApplicableFromDate;
            rLModel.ApplicableTo = lstrlDTO[0].ApplicableToDate;
            rListModel = rLModel;
        }

        #region delete
        /// <summary>
        /// Delete User.
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteFromGrid(int RlMasterId, int acid)
        {
            bool bReturn = false;
            var ErrorDictionary = new Dictionary<string, string>();
            bool statusFlag = false;
            Int32 nRLMasterID = 0;
            try
            {
                Hashtable hashtable = new Hashtable();
                hashtable.Add("UserInfoId", objLoginUserDetails.LoggedInUserID);
                hashtable.Add("LoggedInUserId", objLoginUserDetails.LoggedInUserID);
                hashtable.Add("inp_iRlMasterId", RlMasterId);
                hashtable.Add("inp_sActionType", ("DELETE"));

                DataTable dt_RestrictedList = new DataTable("RestrictedListType");
                dt_RestrictedList.Columns.Add(new DataColumn("ComapnyId", typeof(int)));
                dt_RestrictedList.Columns.Add(new DataColumn("ApplicableFromDate", typeof(DateTime)));
                dt_RestrictedList.Columns.Add(new DataColumn("ApplicableToDate", typeof(DateTime)));

                nRLMasterID = restrictedListSL.SaveRestrictedList(objLoginUserDetails.CompanyDBConnectionString, hashtable, dt_RestrictedList);
                bReturn = true;

                if (bReturn)
                {
                    statusFlag = true;
                    ErrorDictionary.Add("success", "Record deleted successfully");
                }
                else
                {
                    ErrorDictionary.Add("error", "Record deletion failed");
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }

            return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
        }

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion Delete

        #region FillGrid
        /// <summary>
        /// 
        /// </summary>
        /// <param name="m_nGridType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
            ViewBag.Param4 = i_sParam4;
            ViewBag.Param5 = i_sParam5;
        }
        #endregion FillGrid

        #region FillComboValues
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }



                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, i_nComboType,
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "cmp_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion FillComboValues

        //#region  DownloadFormF
        //public ActionResult DownloadFormF(int nDocumentDetailsID)
        //{
        //    //LoginUserDetails objLoginUserDetails = null;
        //    try
        //    {
        //        //int nDocumentDetailsID = 0;
        //        //objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
        //        //using(DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
        //        //{
        //        //    nDocumentDetailsID = objDocumentDetailsSL.GetFormFDocumentId(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.FormF, ConstEnum.Code.FormFforRestrictedList);
        //        //}
        //        return RedirectToAction("Download", "Document", new { nDocumentDetailsID = nDocumentDetailsID, GUID = "", sDocumentName = "", sFileType = "", acid = ConstEnum.UserActions.INSIDER_DOCUMENT_VIEW });

        //    }
        //    catch (Exception exp)
        //    {
        //        ModelState.Remove("KEY");
        //        ModelState.Add("KEY", new ModelState());
        //        ModelState.Clear();
        //        string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
        //        ModelState.AddModelError("error", sErrMessage);
        //    }
        //    finally
        //    {

        //    }
        //    return null;
        //}
        //#endregion DownloadFormF

        #endregion [Private & Public Methods]

        [AuthorizationPrivilegeFilter]
        public ActionResult RestrictedListSettings(int acid)
        {
            RestrictedListSettingsDTO objRestrictedListSettingsDTO = null;
            RestrictedListSettingsModel objRestrictedListSettingsModel = null;
            LoginUserDetails objLoginUserDetails = null;
            bool nShowUploadedFile = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                {
                    objRestrictedListSettingsDTO = objRestrictedListSL.GetRestrictedListSettings(objLoginUserDetails.CompanyDBConnectionString);

                    objRestrictedListSettingsModel = getRestrictedListSettingsModel(objRestrictedListSettingsDTO);

                    if (Convert.ToInt32(objRestrictedListSettingsDTO.Preclearance_Form_F_File_Id) > 0)
                    {
                        nShowUploadedFile = true;
                    }
                }

                ViewBag.UserAction = acid;
                ViewBag.ShowUploadedFile = nShowUploadedFile;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                objLoginUserDetails = null;
                objRestrictedListSettingsDTO = null;
            }

            return View("Settings", objRestrictedListSettingsModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveRestrictedListSettings(int acid, RestrictedListSettingsModel objRestrictedListSettingsModel, Dictionary<int, List<DocumentDetailsModel>> dicFormFUploadFileList)
        {
            RestrictedListSettingsDTO objRestrictedListSettingsDTO = null;
            LoginUserDetails objLoginUserDetails = null;

            List<DocumentDetailsModel> UploadFileDocumentDetailsModelList = null;

            List<DocumentDetailsModel> FormFList = null;

            int Document_MapToId = 1;

            RestrictedListSettingsDTO objRestrictedListSettingsDTO2 = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objRestrictedListSettingsDTO = new RestrictedListSettingsDTO();

                //check if pre-clearance is required or not - if not required then do not upload file
                if (objRestrictedListSettingsModel.Preclearance_Required == Configuration_YesNo.Config_Yes)
                {
                    //get file model for uploaded file
                    if (dicFormFUploadFileList.Count > 0) // file is uploaded and data found for file upload
                    {
                        UploadFileDocumentDetailsModelList = dicFormFUploadFileList[ConstEnum.Code.FormF];
                    }

                    //check file upload by comparing purpose code id
                    FormFList = new List<DocumentDetailsModel>();
                    int FileCounter = 0;
                    if (UploadFileDocumentDetailsModelList != null)
                    {
                        foreach (DocumentDetailsModel objDocumentDetailsModel in UploadFileDocumentDetailsModelList)
                        {
                            // check for uploaded document only
                            if (objDocumentDetailsModel.GUID != null)
                            {
                                FileCounter++;
                                FormFList.Add(objDocumentDetailsModel);
                            }
                        }
                    }

                    using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        if (FileCounter != 0)//document is uploaded for saving
                        {
                            //save / update Form F file 
                            List<DocumentDetailsModel> objSavedDocumentDetialsModelList = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, UploadFileDocumentDetailsModelList, ConstEnum.Code.FormF, Document_MapToId, objLoginUserDetails.LoggedInUserID);
                        }
                    }
                }


                using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                {
                    //convert into DTO and save
                    objRestrictedListSettingsDTO.Preclearance_Required = getYesNoSettingCodeId(objRestrictedListSettingsModel.Preclearance_Required);

                    objRestrictedListSettingsDTO.Allow_Restricted_List_Search = getRestrictedListSearchCodeId(objRestrictedListSettingsModel.Allow_Restricted_List_Search);
                    //if pre-clearance is required then set values from model else set already saved values
                    if (objRestrictedListSettingsModel.Preclearance_Required == Configuration_YesNo.Config_Yes)
                    {
                        objRestrictedListSettingsDTO.Preclearance_Approval = getPrClearanceApprovalCodeId(objRestrictedListSettingsModel.Preclearance_Approval);
                        objRestrictedListSettingsDTO.Preclearance_AllowZeroBalance = getYesNoSettingCodeId(objRestrictedListSettingsModel.Preclearance_AllowZeroBalance);
                        objRestrictedListSettingsDTO.Preclearance_FORM_Required_Restricted_company = getYesNoSettingCodeId(objRestrictedListSettingsModel.Preclearance_FORM_Required_Restricted_company);
                    }
                    else if (objRestrictedListSettingsModel.Preclearance_Required == Configuration_YesNo.Config_No)
                    {
                        objRestrictedListSettingsDTO2 = objRestrictedListSL.GetRestrictedListSettings(objLoginUserDetails.CompanyDBConnectionString);

                        objRestrictedListSettingsDTO.Preclearance_Approval = objRestrictedListSettingsDTO2.Preclearance_Approval;
                        objRestrictedListSettingsDTO.Preclearance_AllowZeroBalance = objRestrictedListSettingsDTO2.Preclearance_AllowZeroBalance;
                        objRestrictedListSettingsDTO.Preclearance_FORM_Required_Restricted_company = objRestrictedListSettingsDTO2.Preclearance_FORM_Required_Restricted_company;
                    }
                    objRestrictedListSettingsDTO.Allow_Restricted_List_Search = getRestrictedListSearchCodeId(objRestrictedListSettingsModel.Allow_Restricted_List_Search);
                    objRestrictedListSettingsDTO.RLSearchLimit = objRestrictedListSettingsModel.Allow_Restricted_List_Search == RestrictedListSearch_Allow.Perpetual ? 0 : objRestrictedListSettingsModel.RLSearchLimit;
                    objRestrictedListSettingsDTO = objRestrictedListSL.SaveRestrictedListSettings(objLoginUserDetails.CompanyDBConnectionString, objRestrictedListSettingsDTO, objLoginUserDetails.LoggedInUserID);
                }

                ViewBag.UserAction = acid;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                objLoginUserDetails = null;
                objRestrictedListSettingsDTO = null;
                objRestrictedListSettingsDTO2 = null;
                UploadFileDocumentDetailsModelList = null;
                FormFList = null;
            }

            return RedirectToAction("RestrictedListSettings", "RestrictedList", new { acid = acid }).Success(Common.Common.getResource("rl_msg_50378"));
        }

        private Configuration_YesNo getYesNoSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.CompanyConfig_YesNoSettings_Yes)
            {
                return Configuration_YesNo.Config_Yes;
            }
            else if (codeId == ConstEnum.Code.CompanyConfig_YesNoSettings_No)
            {
                return Configuration_YesNo.Config_No;
            }
            else
            {
                return Configuration_YesNo.Config_No; // this default return if matching not found
            }
        }

        private int getYesNoSettingCodeId(Configuration_YesNo code)
        {
            int setting_code;

            switch (code)
            {
                case Configuration_YesNo.Config_Yes:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_Yes;
                    break;
                case Configuration_YesNo.Config_No:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                    break;
                default:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                    break;
            }

            return setting_code;
        }

        private PreClearance_Approval getPreClearanceApprovalCode(int codeId)
        {
            if (codeId == ConstEnum.Code.RestrictedList_PreclearanceApproval_Auto)
            {
                return PreClearance_Approval.Auto;
            }
            else if (codeId == ConstEnum.Code.RestrictedList_PreclearanceApproval_Manual)
            {
                return PreClearance_Approval.Manual;
            }
            else
            {
                return PreClearance_Approval.Auto; // this default return if matching not found
            }
        }

        private int getPrClearanceApprovalCodeId(PreClearance_Approval code)
        {
            int setting_code;

            switch (code)
            {
                case PreClearance_Approval.Auto:
                    setting_code = ConstEnum.Code.RestrictedList_PreclearanceApproval_Auto;
                    break;
                case PreClearance_Approval.Manual:
                    setting_code = ConstEnum.Code.RestrictedList_PreclearanceApproval_Manual;
                    break;
                default:
                    setting_code = ConstEnum.Code.RestrictedList_PreclearanceApproval_Auto;
                    break;
            }

            return setting_code;
        }

        private RestrictedListSettingsModel getRestrictedListSettingsModel(RestrictedListSettingsDTO objRestrictedListSettingsDTO)
        {
            RestrictedListSettingsModel objRestrictedListSettingsModel = new RestrictedListSettingsModel();
            DocumentDetailsDTO objDocumentDetailsDTO = null;


            objRestrictedListSettingsModel.Preclearance_Required = getYesNoSettingCode(objRestrictedListSettingsDTO.Preclearance_Required);
            objRestrictedListSettingsModel.Preclearance_Approval = getPreClearanceApprovalCode(objRestrictedListSettingsDTO.Preclearance_Approval);
            objRestrictedListSettingsModel.Preclearance_AllowZeroBalance = getYesNoSettingCode(objRestrictedListSettingsDTO.Preclearance_AllowZeroBalance);
            objRestrictedListSettingsModel.Preclearance_FORM_Required_Restricted_company = getYesNoSettingCode(objRestrictedListSettingsDTO.Preclearance_FORM_Required_Restricted_company);
            objRestrictedListSettingsModel.FormFDocId = objRestrictedListSettingsDTO.Preclearance_Form_F_File_Id;
            objRestrictedListSettingsModel.Allow_Restricted_List_Search = getRestrictedListSearchCode(objRestrictedListSettingsDTO.Allow_Restricted_List_Search);
            objRestrictedListSettingsModel.RLSearchLimit = objRestrictedListSettingsDTO.Allow_Restricted_List_Search == getRestrictedListSearchCodeId(RestrictedListSearch_Allow.Perpetual) ? null : objRestrictedListSettingsDTO.RLSearchLimit;

            objRestrictedListSettingsModel.Preclearance_Form_F_NewFile = Common.Common.GenerateDocumentList(ConstEnum.Code.FormF, 0, 0, null, ConstEnum.Code.FormFforRestrictedList, true);

            if (objRestrictedListSettingsModel.FormFDocId != null && objRestrictedListSettingsModel.FormFDocId != 0)
            {
                int nDocumentID = Convert.ToInt32(objRestrictedListSettingsModel.FormFDocId);

                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentID);

                    objRestrictedListSettingsModel.Preclearance_Form_F_Existing = Common.Common.GenerateDocumentList(ConstEnum.Code.FormF, objDocumentDetailsDTO.MapToId, 0, null, ConstEnum.Code.FormFforRestrictedList, true, nDocumentID);

                }
                objDocumentDetailsDTO = null;
            }

            return objRestrictedListSettingsModel;
        }

        private RestrictedListSearch_Allow getRestrictedListSearchCode(int codeId)
        {
            if (codeId == ConstEnum.Code.RestrictedList_Search_Perpetual)
            {
                return RestrictedListSearch_Allow.Perpetual;
            }
            else if (codeId == ConstEnum.Code.RestrictedList_Search_Limited)
            {
                return RestrictedListSearch_Allow.Limited;
            }
            else
            {
                // this default return if matching not found
                return RestrictedListSearch_Allow.Perpetual;
            }
        }

        private int getRestrictedListSearchCodeId(RestrictedListSearch_Allow code)
        {
            int setting_code;

            switch (code)
            {
                case RestrictedListSearch_Allow.Perpetual:
                    setting_code = ConstEnum.Code.RestrictedList_Search_Perpetual;
                    break;
                case RestrictedListSearch_Allow.Limited:
                    setting_code = ConstEnum.Code.RestrictedList_Search_Limited;
                    break;
                default:
                    setting_code = ConstEnum.Code.RestrictedList_Search_Perpetual;
                    break;
            }

            return setting_code;
        }
    }
}