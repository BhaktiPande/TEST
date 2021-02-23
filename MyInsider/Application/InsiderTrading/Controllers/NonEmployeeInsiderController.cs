using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class NonEmployeeInsiderController : Controller
    {
        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid, int nUserInfoID = 0, bool isPPD_Details_Saved = false, bool isNonEmployee = true)
        {
            bool show_create_role_link = true;
            bool show_not_login_user_details = true;

            UserInfoDTO objUserInfoDTO = null;

            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;

            int user_action_ViewDetails = 0;

            ViewBag.UserDetailsSaved = false;

            LoginUserDetails objLoginUserDetails = null;
            EmployeeModel objEmployeeModel = new EmployeeModel();
            UserInfoModel objUserInfoModel = new UserInfoModel();
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }

                objUserInfoDTO = new UserInfoDTO();

                if (nUserInfoID != 0)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);

                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                    objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objDocumentDetailsModel.MapToId = nUserInfoID;
                    objDocumentDetailsModel.PurposeCodeId = null;
                }
                else
                {
                    ViewBag.NewNonEmpRegistration = true;
                }

                ViewBag.EmpPANNumber = objUserInfoModel.PAN;

                PopulateCombo(objImplementedCompanyDTO.CompanyId);

                objUserInfoModel.UPSIAccessOfCompanyID = objImplementedCompanyDTO.CompanyId;
                objUserInfoModel.UPSIAccessOfCompanyName = objImplementedCompanyDTO.CompanyName;

                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;

                objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.NonEmployeeType.ToString(), null, null, null, null, true);
                objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.NonEmployeeType.ToString(), nUserInfoID.ToString(), null, null, null, false);

                //set flag to show applicability define or not msg 
                if (nUserInfoID != 0 && nUserInfoID != objLoginUserDetails.LoggedInUserID)
                {
                    //check if user has policy document and trading policy appliable by checking count and set flag to show warning msg if applicabiliyt not define
                    using (ApplicabilitySL objApplicabilitySL = new ApplicabilitySL())
                    {
                        int pcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, ConstEnum.Code.PolicyDocument);
                        int tcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, ConstEnum.Code.TradingPolicy);

                        bool showMsgPolicyDocNotApplicable = (pcount <= 0) ? true : false;
                        bool showMsgTradingPolicyNotApplicable = (tcount <= 0) ? true : false;

                        ViewBag.IsShowMsgPDocNotApp = showMsgPolicyDocNotApplicable;
                        ViewBag.IsShowMsgTPocNotApp = showMsgTradingPolicyNotApplicable;
                    }
                }
                else
                {
                    ViewBag.IsShowMsgPDocNotApp = false;
                    ViewBag.IsShowMsgTPocNotApp = false;
                }

                //check if details being shown for login user then set flag to do not show create role link 
                if (nUserInfoID != 0 && nUserInfoID == objLoginUserDetails.LoggedInUserID)
                {
                    show_create_role_link = false;
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objUserInfoDTO.IsRequiredConfirmPersonalDetails != null && (bool)objUserInfoDTO.IsRequiredConfirmPersonalDetails)
                    {
                        show_confirm_personal_details_btn = true;
                        showMsgConfirmPersonalDetails = true;
                    }
                }
                ViewBag.show_create_role_link = show_create_role_link;
                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.user_action = acid;

                ViewBag.IsShowMsgConfirmDetails = showMsgConfirmPersonalDetails;
                ViewBag.show_confirm_personal_details_btn = show_confirm_personal_details_btn;

                switch (objLoginUserDetails.UserTypeCodeId)
                {
                    case ConstEnum.Code.Admin:
                    case ConstEnum.Code.COUserType:
                        user_action_ViewDetails = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW;
                        break;
                   case ConstEnum.Code.NonEmployeeType:
                        user_action_ViewDetails = ConstEnum.UserActions.VIEW_DETAILS_PERMISSION_FOR_NON_EMPLOYEE_USER;
                        break;
                }

                ViewBag.user_action_ViewDetails = user_action_ViewDetails;

                Session["UserInfoId"] = objUserInfoModel.UserInfoId;
                Session["Confirm_PersonalDetails_Required"] = objUserInfoModel.IsRequiredConfirmPersonalDetails;
                Session["show_confirm_personal_details_btn"] = ViewBag.show_confirm_personal_details_btn;
                Session["NonEmployeeType"] = isNonEmployee;
                Session["EmployeeType"] = false;
                WorkandEducationDetailsConfigurationDTO objWorkandEducationDetailsConfigurationDTO = new WorkandEducationDetailsConfigurationDTO();
                using(var objCompaniesSL = new CompaniesSL())                
                {
                    objWorkandEducationDetailsConfigurationDTO = objCompaniesSL.GetWorkandeducationDetailsConfiguration(objLoginUserDetails.CompanyDBConnectionString, 1);
                }
                ViewBag.WorkandEducationDetailsConfiguration = objWorkandEducationDetailsConfigurationDTO.WorkandEducationDetailsConfigurationId;
                Session["WorkandEducationConfiguration"] = ViewBag.WorkandEducationDetailsConfiguration;
                if (isPPD_Details_Saved)
                {
                    ViewBag.UserDetailsSaved = true;
                    return View("NonEmployeeDmatDetails", objEmployeeModel);
                }
                else
                {
                    return View(objEmployeeModel);
                }
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoDTO = null;
                objEmployeeModel = null;
                objUserInfoModel = null;
                objDMATDetailsModel = null;
                objDocumentDetailsModel = null;
                objImplementedCompanyDTO = null;
            }
            return View("Create");

        }
        #endregion Create

        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        public ActionResult Create(UserInfoModel objUserInfoModel, string OldPassword, int acid, bool IsConfirmDetails = false)
        {
            int nUserInfoID = 0;
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();

            bool show_create_role_link = true;
            bool show_not_login_user_details = true;

            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;

            List<PopulateComboDTO> lstSelectedRole = null;
            UserInfoModel objNewUserInfoModel = new UserInfoModel();

            bool isError = false; //flag to check for validation error 
            string sMsgDOJ = "";
            string sMsgDOBI = "";
            string sMsgDateCompare = "";
            string sMsgException = "";

            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = null;
            EmployeeModel objEmployeeModel = new EmployeeModel();
            string strConfirmMessage = "";

            try
            {
                //check if details being shown for login user then set flag to do not show create role link 
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                if (objUserInfoModel.UserInfoId != 0 && objUserInfoModel.UserInfoId == objLoginUserDetails.LoggedInUserID)
                {
                    show_create_role_link = false;
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objUserInfoModel.IsRequiredConfirmPersonalDetails != null && (bool)objUserInfoModel.IsRequiredConfirmPersonalDetails)
                    {
                        show_confirm_personal_details_btn = true;
                        showMsgConfirmPersonalDetails = true;
                    }
                }
                ViewBag.show_create_role_link = show_create_role_link;
                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.IsShowMsgConfirmDetails = showMsgConfirmPersonalDetails;
                ViewBag.show_confirm_personal_details_btn = show_confirm_personal_details_btn;

                ViewBag.user_action = acid;

                switch (objLoginUserDetails.UserTypeCodeId)
                {
                    case ConstEnum.Code.Admin:
                    case ConstEnum.Code.COUserType:
                        if (objUserInfoModel.UserInfoId > 0)
                        {
                            ViewBag.user_action = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT;
                        }
                        else
                        {
                            ViewBag.user_action = ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE;
                        }
                        break;
                    case ConstEnum.Code.NonEmployeeType:
                        if (objUserInfoModel.UserInfoId > 0)
                        {
                            ViewBag.user_action = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT;
                        }
                        else
                        {
                            ViewBag.user_action = ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE;
                        }
                        break;
                }

                using(CompaniesSL objCompaniesSL = new CompaniesSL()){
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }

                if (objUserInfoModel.DateOfJoining != null || objUserInfoModel.DateOfBecomingInsider != null)
                {
                    DateTime current_date = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                    if (objUserInfoModel.DateOfJoining > current_date)
                    {
                        sMsgDOJ = Common.Common.getResource("usr_msg_11413"); // "Date of Joining should be less than today's date";
                        isError = true;
                    }

                    if (objUserInfoModel.DateOfBecomingInsider > current_date)
                    {
                        sMsgDOBI = Common.Common.getResource("usr_msg_11414"); // "Date of Becoming Insider should be less than today's date";
                        isError = true;
                    }

                    if (objUserInfoModel.DateOfBecomingInsider < objUserInfoModel.DateOfJoining)
                    {
                        sMsgDateCompare = Common.Common.getResource("usr_msg_11415"); // "Date of Becoming Insider should not be less than Date of Joining";
                        isError = true;
                    }    
                }

                //check if validation error by checking flag
                if (!isError)
                {
                    if (objUserInfoModel.UserInfoId != 0)
                    {
                        using(UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoModel.UserInfoId);
                        }
                    }

                    InsiderTrading.Common.Common.CopyObjectPropertyByNameAndActivity(objUserInfoModel, objUserInfoDTO);
                    objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.NonEmployeeType;
                    objUserInfoDTO.IsInsider = ConstEnum.UserType.Insider;
                    objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                    objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objUserInfoDTO.AllowUpsiUser = objUserInfoModel.AllowUpsiUser;

                    if (objUserInfoDTO.StateId == 0)
                        objUserInfoDTO.StateId = null;
                    if (objUserInfoDTO.CountryId == 0)
                        objUserInfoDTO.CountryId = null;

                    objUserInfoDTO.UPSIAccessOfCompanyID = objImplementedCompanyDTO.CompanyId;

                    objUserInfoDTO.Password = "";
                    using(UserInfoSL objUserInfoSL = new UserInfoSL()){
                        objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                    }

                    if (objUserInfoDTO.UserInfoId != 0)
                    {
                        nUserInfoID = objUserInfoDTO.UserInfoId;
                    }                    

                    //check if need to confirm personal details 
                    if (IsConfirmDetails && objUserInfoModel.IsRequiredConfirmPersonalDetails == true)
                    {
                        int UserInfoID = 0;
                        int RequiredModuleID = 0;
                        try
                        {
                            objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                            //set values to save into event log table
                            objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.Event_ConfirmPersonalDetails;
                            objUserPolicyDocumentEventLogDTO.UserInfoId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                            UserInfoID = objUserInfoDTO.UserInfoId;

                            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                            {
                                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                                if (objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity)
                                {
                                    RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity;
                                }
                                else
                                {
                                    RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity;
                                }
                            }

                            bool isConfirm = false;

                            using(InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL()){
                                isConfirm = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                            }

                            if (isConfirm)
                            {
                                strConfirmMessage = Common.Common.getResource("usr_msg_11420"); //Personal Details confirm successfully.
                                //return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(HttpUtility.UrlEncode(strConfirmMessage));
                                return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE, UserInfoId = UserInfoID, ReqModuleId = RequiredModuleID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
                            }
                        }
                        catch (Exception ex)
                        {
                            strConfirmMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                            throw ex;
                        }
                        finally{
                            objUserPolicyDocumentEventLogDTO = null;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                sMsgException = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                isError = true;
                using(CompaniesSL objCompaniesSL = new CompaniesSL()){
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }
            }

            //check if there are validation error and show validation error 
            if (isError)
            {   
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();

                //set validation error messages
                if (sMsgDOJ != "")
                {
                    ModelState.AddModelError("Error", sMsgDOJ);
                }

                if (sMsgDOBI != "")
                {
                    ModelState.AddModelError("Error", sMsgDOBI);
                }

                if (sMsgDateCompare != "")
                {
                    ModelState.AddModelError("Error", sMsgDateCompare);
                }

                if (sMsgException != "")
                {
                    ModelState.AddModelError("Error", sMsgException);
                }

                if (strConfirmMessage != "")
                {
                    ModelState.AddModelError("Error", strConfirmMessage);
                }

                //check if user has selected role and assign those role 
                if (objUserInfoModel.SubmittedRole != null)
                {
                    lstSelectedRole = new List<PopulateComboDTO>();
                    for (int cnt = 0; cnt < objUserInfoModel.SubmittedRole.Count; cnt++)
                    {
                        PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                        objPopulateComboDTO.Key = objUserInfoModel.SubmittedRole[cnt];
                        lstSelectedRole.Add(objPopulateComboDTO);
                        objPopulateComboDTO = null;
                    }
                }

                //check if user already saved and set non editable property with already saved valued in DB 
                if (objUserInfoModel.UserInfoId != 0)
                {
                    //get saved info from DB 
                    UserInfoDTO objExistingDetails_UserInfoDTO = null;
                    using(UserInfoSL objUserInfoSL = new UserInfoSL()){
                        objExistingDetails_UserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoModel.UserInfoId);
                    }

                    //copy editable property into DTO so we get existing property and change property
                    Common.Common.CopyObjectPropertyByNameAndActivity(objUserInfoModel, objExistingDetails_UserInfoDTO);

                    //copy DTO to new model which can be pass to view with already saved details with newly change details
                    Common.Common.CopyObjectPropertyByName(objExistingDetails_UserInfoDTO, objNewUserInfoModel);

                    //set user info model to employee model which content edited info and already save info
                    //objUserInfoModel = objNewUserInfoModel;
                }
                else
                {
                    //set user info model to employee model which content edited info and already save info
                    objNewUserInfoModel = objUserInfoModel;
                }

                objNewUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.NonEmployeeType.ToString(), null, null, null, null, true);

                //check if user has selected role and assign those role 
                if (lstSelectedRole != null && lstSelectedRole.Count > 0)
                {
                    objNewUserInfoModel.AssignedRole = lstSelectedRole;
                }
                else
                {
                    objNewUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.NonEmployeeType.ToString(), nUserInfoID.ToString(), null, null, null, false);
                }
                lstSelectedRole = null;
                PopulateCombo(objImplementedCompanyDTO.CompanyId);
                objEmployeeModel.userInfoModel = objNewUserInfoModel;

                //check if dmat details model is set or not
                if (objEmployeeModel.dmatDetailsModel == null)
                {
                    objEmployeeModel.dmatDetailsModel = new DMATDetailsModel();

                    if (objUserInfoModel.UserInfoId != 0)
                    {
                        objEmployeeModel.dmatDetailsModel.UserInfoID = objEmployeeModel.userInfoModel.UserInfoId;
                    }
                }

                //check if document details are set or not
                if (objEmployeeModel.documentDetailsModel == null)
                {
                    objEmployeeModel.documentDetailsModel = new DocumentDetailsModel();

                    objEmployeeModel.documentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objEmployeeModel.documentDetailsModel.PurposeCodeId = null;

                    if (objUserInfoModel.UserInfoId != 0)
                    {
                        objEmployeeModel.documentDetailsModel.MapToId = objEmployeeModel.userInfoModel.UserInfoId;
                    }
                }

                return View("Create", objEmployeeModel);
            }

            ArrayList lst = new ArrayList();
            
            //before showing success message check if first name and last name is NOT NULL
            string fname = objUserInfoModel.FirstName == null ? "" : objUserInfoModel.FirstName.Replace("'", "\'").Replace("\"", "\"");
            string lname = objUserInfoModel.LastName == null ? "" : objUserInfoModel.LastName.Replace("'", "\'").Replace("\"", "\"");

            lst.Add(fname + " " + lname);
            string AlertMessage = Common.Common.getResource("usr_msg_11266", lst);
            objUserInfoModel = null;
            return RedirectToAction("Create", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoID = nUserInfoID, isPPD_Details_Saved = true }).Success(HttpUtility.UrlEncode(AlertMessage));
        }
        #endregion Create

        private void PopulateCombo(int? CompanyID) {
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstCompanyList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstStateList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstCountryList = new List<PopulateComboDTO>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                
                lstCompanyList.Add(objPopulateComboDTO);
                lstCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                    CompanyID.ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.CompanyDropdown = lstCompanyList;
                
                lstStateList.Add(objPopulateComboDTO);
                lstStateList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.StateDropDown = lstStateList;
                
                lstCountryList.Add(objPopulateComboDTO);
                lstCountryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.CountryDropDown = lstCountryList;
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstCompanyList = null;
                lstStateList = null;
                lstCountryList = null;
            }
        }

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
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                
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
            finally
            {
                lstPopulateComboDTO = null;
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
            }
        }
        #endregion FillComboValues

        #region Confirm Personal Details
        [AuthorizationPrivilegeFilter]
        public ActionResult ConfirmDetails(int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = null;
            string strConfirmMessage = "";
            int UserInfoID = 0;
            int RequiredModuleID = 0;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                //set values to save into event log table
                objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.Event_ConfirmPersonalDetails;
                objUserPolicyDocumentEventLogDTO.UserInfoId = Convert.ToInt32(Session["UserInfoId"]);
                objUserPolicyDocumentEventLogDTO.MapToId = Convert.ToInt32(Session["UserInfoId"]);
                objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                UserInfoID = Convert.ToInt32(Session["UserInfoId"]);
                bool isConfirm = false;


                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    if (objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity)
                    {
                        RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity;
                    }
                    else
                    {
                        RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity;
                    }
                }

                using (InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    isConfirm = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                }
                using (InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    isConfirm = objInsiderInitialDisclosureSL.SaveReconfirmation(objLoginUserDetails.CompanyDBConnectionString, UserInfoID, objLoginUserDetails.LoggedInUserID);
                }
                if (isConfirm)
                {
                    strConfirmMessage = Common.Common.getResource("usr_msg_11420"); //Personal Details confirm successfully.                    
                    return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE, UserInfoId = UserInfoID, ReqModuleId = RequiredModuleID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
                }
            }
            catch (Exception ex)
            {
                strConfirmMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                throw ex;
            }
            finally
            {
                objUserPolicyDocumentEventLogDTO = null;
            }
            return RedirectToAction("Create", "NonEmployeeInsider", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoID = objLoginUserDetails.LoggedInUserID });
            
        }
        #endregion Confirm Personal Details

        #region Dispose
        /// <summary>
        /// Dispose Method
        /// </summary>
        /// <param name="disposing"></param>
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose
    }
}