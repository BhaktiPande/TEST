using InsiderTrading.SL;
using InsiderTrading.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Common;
using InsiderTradingDAL;
using InsiderTrading.Filters;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class CorporateUserController : Controller
    {
        const string sLookUpPrefix = "usr_msg_";

        #region Index
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            CorporateUSerModel objCorporateUSerModel = new CorporateUSerModel();
            Dictionary<string, string> objStatusDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            Corporate_DMATDetailsModel objDMATDetailsModel = new Corporate_DMATDetailsModel();

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstCompanyList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstDesignationList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstCountryList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstStateList = new List<PopulateComboDTO>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstCompanyList.Add(objPopulateComboDTO);
                lstCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                    null, null, null, null, null, sLookUpPrefix));

                ViewBag.CompanyDropdown = lstCompanyList;


                lstDesignationList.Add(objPopulateComboDTO);
                lstDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMasterForAutoHelp).ToString(), null, null, null, null, sLookUpPrefix));

                ViewBag.DesignationDropDown = lstDesignationList;


                lstCountryList.Add(objPopulateComboDTO);
                lstCountryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                   Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, sLookUpPrefix));

                ViewBag.CountryDropDown = lstCountryList;


                lstStateList.Add(objPopulateComboDTO);
                lstStateList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                 Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, sLookUpPrefix));

                objCorporateUSerModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), null, null, null, null, true);
                objCorporateUSerModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), objCorporateUSerModel.UserInfoId.ToString(), null, null, null, false);
                objCorporateUSerModel.dmatDetailsModel = objDMATDetailsModel;

                ViewBag.StatedropDown = lstStateList;

                //Flag set to do not show warning message of applicability
                ViewBag.IsShowMsgPDocNotApp = false;
                ViewBag.IsShowMsgTPocNotApp = false;

                //Flag set to show create role link
                ViewBag.show_create_role_link = true;
                ViewBag.show_not_login_user_details = true;

                ViewBag.user_action = acid;
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objStatusDictionary = null;
                objLoginUserDetails = null;
                objDMATDetailsModel = null;
                objPopulateComboDTO = null;
                lstCompanyList = null;
                lstDesignationList = null;
                lstCountryList = null;
                lstStateList = null;
            }
            return View("CorporateUserdetails", objCorporateUSerModel);


        }
        #endregion Index

        #region Create
        // GET: /CorporateUser/Create
        public ActionResult Create()
        {
            return View("CorporateUserdetails");
        }
        #endregion Create

        #region CorporateUserCreate
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "Create")]
        [ActionName("CorporateUserCreate")]
        public ActionResult CorporateUserCreate(CorporateUSerModel objCorporateUSerModel, bool IsConfirmDetails = false)
        {
            LoginUserDetails objLoginUserDetails = null;

            bool show_create_role_link = true;
            bool show_not_login_user_details = true;

            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;

            List<PopulateComboDTO> lstSelectedRole = null;

            bool isError = false; //flag to check for validation error 
            string sMsgDOBI = "";
            string sMsgException = "";

            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = new UserInfoDTO();

            //InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = null;
            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = null;

            string strConfirmMessage = "";

            try
            {
                //check if details being shown for login user then set flag to do not show create role link 
                //LoginUserDetails objLoginUser = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                if (objCorporateUSerModel.UserInfoId != 0 && objCorporateUSerModel.UserInfoId == objLoginUserDetails.LoggedInUserID)
                {
                    show_create_role_link = false;
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objCorporateUSerModel.IsConfirmPersonalDetails != null && (bool)objCorporateUSerModel.IsConfirmPersonalDetails)
                    {
                        show_confirm_personal_details_btn = true;
                        showMsgConfirmPersonalDetails = true;
                    }
                }
                ViewBag.show_create_role_link = show_create_role_link;
                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.IsShowMsgConfirmDetails = showMsgConfirmPersonalDetails;
                ViewBag.show_confirm_personal_details_btn = show_confirm_personal_details_btn;

                int acid = 0;
                if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                {
                    acid = Convert.ToInt32(Request.Params["authorization"].Split(',')[0].Split(':')[1]);
                }

                ViewBag.user_action = acid;


                if (objCorporateUSerModel.DateOfBecomingInsider != null)
                {
                    DateTime current_date = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                    //check and validate date of becoming insider
                    if (objCorporateUSerModel.DateOfBecomingInsider > current_date)
                    {
                        sMsgDOBI = Common.Common.getResource("usr_msg_11263");
                        isError = true;
                    }
                }

                if (!isError)
                {
                    //get insider details saved in DB
                    if (objCorporateUSerModel.UserInfoId != 0)
                    {
                        using (var objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objCorporateUSerModel.UserInfoId);
                        }
                    }

                   InsiderTrading.Common.Common.CopyObjectPropertyByName(objCorporateUSerModel, objUserInfoDTO);
                   //InsiderTrading.Common.Common.CopyObjectPropertyByNameAndActivity(objCorporateUSerModel, objUserInfoDTO);
                    
                    objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.CorporateUserType;
                    objUserInfoDTO.AllowUpsiUser = objCorporateUSerModel.AllowUpsiUser;

                    if (objCorporateUSerModel.SubmittedRole != null && objCorporateUSerModel.SubmittedRole.Count() > 0)
                    {
                        var sSubmittedRoleList = String.Join(",", objCorporateUSerModel.SubmittedRole);
                        objUserInfoDTO.SubmittedRoleIds = sSubmittedRoleList;
                    }

                    if (objUserInfoDTO.StateId == 0)
                    {
                        objUserInfoDTO.StateId = null;
                    }

                    objUserInfoDTO.Password = "";

                    //save records into DB
                    using(UserInfoSL objUserInfoSL = new UserInfoSL()){
                        objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                    }

                    //check if need to confirm personal details 
                    if (IsConfirmDetails && objCorporateUSerModel.IsConfirmPersonalDetails == true)
                    {
                        try
                        {
                            //objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();

                            objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                            //set values to save into event log table
                            objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.Event_ConfirmPersonalDetails;
                            objUserPolicyDocumentEventLogDTO.UserInfoId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                            bool isConfirm = false;
                            using(InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL()){
                                isConfirm = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                            }
                            if (isConfirm)
                            {
                                strConfirmMessage = Common.Common.getResource("usr_msg_11421"); //Personal Details confirm successfully.
                                return RedirectToAction("Edit", "CorporateUser", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoId = objLoginUserDetails.LoggedInUserID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
                            }
                        }
                        catch (Exception ex)
                        {
                            strConfirmMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                            throw ex;
                        }
                        finally{
                            objUserPolicyDocumentEventLogDTO = null;
                            objUserPolicyDocumentEventLogDTO = null;
                            objUserInfoDTO = null;
                            objLoginUserDetails = null;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                sMsgException = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                isError = true;
            }

            //check if there are validation error and show validation error 
            if (isError)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();

                //set validation error messages
                if (sMsgDOBI != "")
                {
                    ModelState.AddModelError("Error", sMsgDOBI);
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
                if (objCorporateUSerModel.SubmittedRole != null)
                {
                    lstSelectedRole = new List<PopulateComboDTO>();
                    for (int cnt = 0; cnt < objCorporateUSerModel.SubmittedRole.Count; cnt++)
                    {
                        PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                        objPopulateComboDTO.Key = objCorporateUSerModel.SubmittedRole[cnt];
                        lstSelectedRole.Add(objPopulateComboDTO);
                    }
                }

                ViewBag.CompanyDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                   null, null, null, null, null, sLookUpPrefix);

                ViewBag.DesignationDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.CountryDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                   Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.StateDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                 Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, sLookUpPrefix);

                objCorporateUSerModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), null, null, null, null, true);

                //check if user has selected role and assign those role 
                if (lstSelectedRole != null && lstSelectedRole.Count > 0)
                {
                    objCorporateUSerModel.AssignedRole = lstSelectedRole;
                }
                else
                {
                    objCorporateUSerModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), objCorporateUSerModel.UserInfoId.ToString(), null, null, null, false);
                }

                //check if dmat details model is set or not
                if (objCorporateUSerModel.dmatDetailsModel == null)
                {
                    objCorporateUSerModel.dmatDetailsModel = new Corporate_DMATDetailsModel();
                }
                lstSelectedRole = null;
                objLoginUserDetails = null;
                return View("CorporateUserdetails", objCorporateUSerModel);
            }
            objLoginUserDetails = null;
            return RedirectToAction("Edit", "CorporateUser", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoId = objUserInfoDTO.UserInfoId }).Success(Common.Common.getResource("usr_msg_11264"));
        }
        #endregion CorporateUserCreate

        #region Delete
        // GET: /CorporateUser/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "Delete")]
        [ActionName("CorporateUserCreate")]
        public ActionResult Delete(int UserInfoId, CorporateUSerModel objCorporateUSerModel)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.LoggedInUserID);
                }
                return RedirectToAction("Index", "CorporateUser", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW }).Success(Common.Common.getResource("usr_msg_11265"));
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.CompanyDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                   null, null, null, null, null, sLookUpPrefix);

                ViewBag.DesignationDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.CountryDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                   Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.StateDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                 Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, sLookUpPrefix);

                objCorporateUSerModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), null, null, null, null, true);
                objCorporateUSerModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), objCorporateUSerModel.UserInfoId.ToString(), null, null, null, false);

                return View("CorporateUserdetails", objCorporateUSerModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Delete

        #region Edit
        // GET: /CorporateUser/Delete/5
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int nUserInfoId, int acid)
        {
            bool show_create_role_link = true;
            bool show_not_login_user_details = true;
            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;

            CorporateUSerModel objCorporateUSerModel = new CorporateUSerModel();
            Corporate_DMATDetailsModel objDMATDetailsModel = new Corporate_DMATDetailsModel();
            LoginUserDetails objLoginUserDetails = null;
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoId);
                }

                ViewBag.CompanyDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                    null, null, null, null, null, sLookUpPrefix);

                ViewBag.DesignationDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.CountryDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                   Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, sLookUpPrefix);

                ViewBag.StateDropDown = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                 Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, sLookUpPrefix);

                objCorporateUSerModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), null, null, null, null, true);
                objCorporateUSerModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), nUserInfoId.ToString(), null, null, null, false);

                //set flag to show applicability define or not msg 
                //same view use to show details to insider so check if login user is not insider
                if (nUserInfoId != 0 && nUserInfoId != objLoginUserDetails.LoggedInUserID)
                {
                    //check if user has policy document and trading policy appliable by checking count and set flag to show warning msg if applicabiliyt not define
                    using (ApplicabilitySL objApplicabilitySL = new ApplicabilitySL())
                    {
                        int pcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoId, ConstEnum.Code.PolicyDocument);
                        int tcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoId, ConstEnum.Code.TradingPolicy);

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
                if (nUserInfoId != 0 && nUserInfoId == objLoginUserDetails.LoggedInUserID)
                {
                    show_create_role_link = false;
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objUserInfoDTO != null && objUserInfoDTO.IsRequiredConfirmPersonalDetails != null && (bool)objUserInfoDTO.IsRequiredConfirmPersonalDetails)
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

                ViewBag.CorpPANNumber = objUserInfoDTO.PAN;

                if (objUserInfoDTO != null)
                {

                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objCorporateUSerModel);

                    //set flag is need to confirm details
                    objCorporateUSerModel.IsConfirmPersonalDetails = objUserInfoDTO.IsRequiredConfirmPersonalDetails;

                    //check if details being shown for login user then set flag to do not show create role link 
                    if (nUserInfoId != 0 && nUserInfoId == objLoginUserDetails.LoggedInUserID && !show_not_login_user_details)
                    {
                        objCorporateUSerModel.SubmittedRole = objUserInfoDTO.SubmittedRoleIds.Split(',').ToList<string>();
                    }

                    objDMATDetailsModel.UserInfoID = objUserInfoDTO.UserInfoId;
                    objCorporateUSerModel.dmatDetailsModel = objDMATDetailsModel;
                    return View("CorporateUserdetails", objCorporateUSerModel);
                }
                return View("CorporateUserdetails");
            }
            catch (Exception exp)
            {
                // string sErrCode = exp.InnerException.Data[0].ToString();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ViewBag.ErrorMessage = sErrMessage;
            }
            finally
            {
                objDMATDetailsModel = null;
                objLoginUserDetails = null;
                objUserInfoDTO = null;
                objCorporateUSerModel = null;
            }
            return View("CorporateUserdetails");
        }
        #endregion Edit

        #region Cancel
        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <returns></returns>
        ///  
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("CorporateUserCreate")]
        public ActionResult Cancel()
        {

            return RedirectToAction("Index", "Employee", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW });

        }
        #endregion Cancel

        #region ViewRecords
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewRecords(int nUserInfoID, int acid)
        {
            bool show_not_login_user_details = true;

            //UserInfoSL objUserInfoSL = new UserInfoSL();
            CorporateUSerModel objCorporateUSerModel = new CorporateUSerModel();
            Corporate_DMATDetailsModel objDMATDetailsModel = new Corporate_DMATDetailsModel();
            LoginUserDetails objLoginUserDetails = null;
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                }

                objCorporateUSerModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), null, null, null, null, false);
                objCorporateUSerModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.CorporateUserType.ToString(), nUserInfoID.ToString(), null, null, null, false);
                objCorporateUSerModel.dmatDetailsModel = objDMATDetailsModel;

                //set flag to show applicability define or not msg 
                //same view use to show details to insider so check if login user is not insider
                if (nUserInfoID != 0 && nUserInfoID != objLoginUserDetails.LoggedInUserID)
                {
                    //check if user has policy document and trading policy appliable by checking count and set flag to show warning msg if applicabiliyt not define
                    ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
                    int pcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, ConstEnum.Code.PolicyDocument);
                    int tcount = objApplicabilitySL.UserApplicabilityCount(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, ConstEnum.Code.TradingPolicy);

                    bool showMsgPolicyDocNotApplicable = (pcount <= 0) ? true : false;
                    bool showMsgTradingPolicyNotApplicable = (tcount <= 0) ? true : false;

                    ViewBag.IsShowMsgPDocNotApp = showMsgPolicyDocNotApplicable;
                    ViewBag.IsShowMsgTPocNotApp = showMsgTradingPolicyNotApplicable;
                }
                else
                {
                    ViewBag.IsShowMsgPDocNotApp = false;
                    ViewBag.IsShowMsgTPocNotApp = false;
                }

                //check if details being shown for login user then set flag to do not show create role link 
                //also check if login user is employee then set flag to show confirm button 
                if (nUserInfoID != 0 && nUserInfoID == objLoginUserDetails.LoggedInUserID)
                {
                    show_not_login_user_details = false;
                }

                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.user_action = acid;

                if (objUserInfoDTO != null)
                {
                    objCorporateUSerModel.dmatDetailsModel.UserInfoID = objUserInfoDTO.UserInfoId;

                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objCorporateUSerModel);

                    return View("CorporateUserView", objCorporateUSerModel);
                }
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objCorporateUSerModel = null;
                objDMATDetailsModel = null;
                objUserInfoDTO = null;
            }
            return View("CorporateUserView");
        }

        #endregion ViewRecoreds

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
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstPopulateComboDTO = null;
            }
        }
        #endregion FillComboValues

        #region AutoComplete
        public JsonResult Autocomplete(string sSearchString)
        {
            LoginUserDetails objLoginUserDetails = null;
            IEnumerable<PopulateComboDTO> result = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                var suggestions = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                   Convert.ToInt32(ConstEnum.CodeGroup.DesignationMasterForAutoHelp).ToString(), null, null, null, null, sLookUpPrefix);
                result = suggestions.Where(s => s.Value.ToLower().Contains(sSearchString.ToLower())).Select(w => w).ToList();
            }
            catch (Exception exp) { }
            finally
            {
                objLoginUserDetails = null;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        #endregion AutoComplete

        #region Edit DMAT Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public PartialViewResult EditDMATDetails(int acid, int nDMATDetailsID = 0, int nUserInfoID = 0, int utype = 0)
        {
            Corporate_DMATDetailsModel objCorporate_DMATDetailsModel = null;
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new DMATAccountHolderDetailsModel();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstDPNameList = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDPBankDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstAccountTypeList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstRelationTypeList = new List<PopulateComboDTO>();
            Common.Common objCommon = new Common.Common();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objCorporate_DMATDetailsModel = new Corporate_DMATDetailsModel();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return PartialView("~/Views/Home/UnauthorizedAcess.cshtml");
                }


                lstDPNameList.Add(objPopulateComboDTO);
                lstDPNameList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DPName).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());

                objPopulateComboDPBankDTO.Key = "1";
                objPopulateComboDPBankDTO.Value = "Other";
                lstDPNameList.Add(objPopulateComboDPBankDTO);
                ViewBag.DPBankDropdown = lstDPNameList;

                lstAccountTypeList.Add(objPopulateComboDTO);
                lstAccountTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DMATAccountType).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                if (lstAccountTypeList.Select(elem => elem.Key == "121002").Count() > 0)
                {
                    lstAccountTypeList.RemoveAll(elem => elem.Key == "121002");
                }
                ViewBag.AccountTypeDropdown = lstAccountTypeList;

                lstRelationTypeList.Add(objPopulateComboDTO);
                lstRelationTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.RelationWithEmployee).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                ViewBag.RelationTypeDropdown = lstRelationTypeList;

                if (nDMATDetailsID != 0)
                {
                    using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                    {
                        objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID);
                    }

                    ViewBag.DPBankCodeId = objDMATDetailsDTO.DPBankCodeId;
                    Common.Common.CopyObjectPropertyByName(objDMATDetailsDTO, objCorporate_DMATDetailsModel); //copy property for corporate dmat details model

                    bool flag = false;
                    foreach (PopulateComboDTO kvp in lstDPNameList)
                    {
                        if (objDMATDetailsDTO.DPBank == "" || kvp.Value == objDMATDetailsDTO.DPBank)
                        {
                            objCorporate_DMATDetailsModel.DPBank = objDMATDetailsDTO.DPBankCodeId.ToString();
                            objCorporate_DMATDetailsModel.DPBankName = null;

                            flag = true;
                            break;
                        }
                    }
                    if (!flag)
                    {
                        objCorporate_DMATDetailsModel.DPBank = "Other";
                        objCorporate_DMATDetailsModel.DPBankName = objDMATDetailsDTO.DPBank;
                    }
                }
                else
                {
                    objCorporate_DMATDetailsModel.UserInfoID = nUserInfoID;
                }

                //set user type into viewbag 
                ViewBag.user_type = utype;

                ViewBag.user_action = acid;

                return PartialView("~/Views/CorporateUser/DMATDetailsModal.cshtml", objCorporate_DMATDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objCorporate_DMATDetailsModel = null;
                objLoginUserDetails = null;
                objDMATDetailsDTO = new DMATDetailsDTO();
                objDMATAccountHolderDetailsModel = new DMATAccountHolderDetailsModel();
                objPopulateComboDTO = new PopulateComboDTO();
                lstDPNameList = new List<PopulateComboDTO>();
                objPopulateComboDPBankDTO = new PopulateComboDTO();
                lstAccountTypeList = new List<PopulateComboDTO>();
                lstRelationTypeList = new List<PopulateComboDTO>();
            }

        }
        #endregion Edit DMAT Details

        #region Save DMAT Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public JsonResult SaveDMATDetails(Corporate_DMATDetailsModel objDMATDetailsModel, int acid, string callfrom = "")
        {
            bool getList = false;
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            bool bRefreshDematList = false;
            try
            {

                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                Common.Common.CopyObjectPropertyByName(objDMATDetailsModel, objDMATDetailsDTO);

                //check DEMAT account type(CDSL, NSDL, OThers)
                if (objDMATDetailsModel.DEMATAccountNumber != "" && (!string.IsNullOrEmpty(objDMATDetailsModel.DEMATAccountNumber)))
                    objDMATDetailsDTO.DEMATAccountNumber = objDMATDetailsModel.DEMATAccountNumber;
                else if (objDMATDetailsModel.DEMATAccountNumberNSDL != "" && (!string.IsNullOrEmpty(objDMATDetailsModel.DEMATAccountNumberNSDL)))
                    objDMATDetailsDTO.DEMATAccountNumber = objDMATDetailsModel.DEMATAccountNumberNSDL;
                else
                    objDMATDetailsDTO.DEMATAccountNumber = objDMATDetailsModel.DEMATAccountNumberOthers;


                //check DP bank and if not selected then set empty, in case of other set entered bank name
                if (objDMATDetailsModel.DPBank == "1")
                {
                    objDMATDetailsDTO.DPBank = objDMATDetailsModel.DPBankName;
                    objDMATDetailsDTO.DPBankCodeId = null;
                }
                else if (objDMATDetailsModel.DPBank == "Select")
                {
                    objDMATDetailsDTO.DPBank = "";
                    objDMATDetailsDTO.DPBankCodeId = null;
                }
                else
                {
                    objDMATDetailsDTO.DPBank = "";
                    objDMATDetailsDTO.DPBankCodeId = Convert.ToInt32(objDMATDetailsModel.DPBank);
                }

                if (objDMATDetailsDTO.AccountTypeCodeId == ConstEnum.Code.Joint)
                {
                    getList = true;
                }

                //check DEMAT account for DPID
                if (objDMATDetailsModel.DPID != "" && (!string.IsNullOrEmpty(objDMATDetailsModel.DPID)))
                    objDMATDetailsDTO.DPID = objDMATDetailsModel.DPID;
                else
                    objDMATDetailsDTO.DPID = objDMATDetailsModel.DPIDCDSL;

                if (objDMATDetailsModel.Description == null)
                    objDMATDetailsDTO.Description = "";

                if (objDMATDetailsModel.TMID == null)
                    objDMATDetailsDTO.TMID = "";

                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsDTO = objDMATDetailsSL.SaveDMATDetails(objLoginUserDetails.CompanyDBConnectionString, objDMATDetailsDTO, objLoginUserDetails.LoggedInUserID);
                    if (objDMATDetailsDTO.DMATDetailsID == 0)
                    {
                        string sErrMessage = Common.Common.getResource("usr_msg_50067");
                        ModelState.AddModelError("", "");
                        return Json(new
                        {
                            status = false,
                            Message = sErrMessage,
                        }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        if (callfrom == "popup")
                        {
                            bRefreshDematList = true;
                        }

                        return Json(new
                        {
                            status = true,
                            Message = Common.Common.getResource("usr_msg_11316"), //"DMAT Details Save Successfully",
                            type = getList,
                            DMATDetailsID = objDMATDetailsDTO.DMATDetailsID,
                            RefreshDematList = bRefreshDematList
                        }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATDetailsDTO = null;
            }

        }
        #endregion Save DMAT Details

        #region Delete DMAT Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteDMATDetails(int acid, int nDMATDetailsID)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID, objLoginUserDetails.LoggedInUserID);
                }
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11320"));
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
            finally
            {
                objLoginUserDetails = null;
                objDMATDetailsDTO = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);

        }
        #endregion Delete DMAT Details

        #region GET Joint DMAT List
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>        
        public PartialViewResult GETDMATList(int nDMATDetailsID = 0)
        {
            Corporate_DMATDetailsModel objDMATDetailsModel = new Corporate_DMATDetailsModel();
            try
            {
                objDMATDetailsModel.DMATDetailsID = nDMATDetailsID;
                return PartialView("~/Views/CorporateUser/DMATHolderList.cshtml", objDMATDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objDMATDetailsModel = null;
            }

        }
        #endregion GET Joint DMAT List

        #region Save Joint DMAT Holder Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>

        public JsonResult SaveDMATHolderDetails(Corporate_DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                Common.Common.CopyObjectPropertyByName(objDMATAccountHolderDetailsModel, objDMATAccountHolderDTO);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.SaveDMATHolderDetails(objLoginUserDetails.CompanyDBConnectionString, objDMATAccountHolderDTO, objLoginUserDetails.LoggedInUserID);
                }
                return Json(new
                {
                    status = true,
                    Message = Common.Common.getResource("usr_msg_11319"), //"DMAT Joint Account Holder Details Save Successfully"

                }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATAccountHolderDTO = null;
            }

        }
        #endregion Save Joint DMAT Holder Details

        #region Edit Joint DMAT Holder Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>

        public PartialViewResult EditDMATHolderDetails(int nDMATAccountHolderID = 0, int nDMATDetailsID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();

            Corporate_DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new Corporate_DMATAccountHolderDetailsModel();

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstRelationTypeList = new List<PopulateComboDTO>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";


                lstRelationTypeList.Add(objPopulateComboDTO);
                lstRelationTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.RelationWithEmployee).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());

                ViewBag.RelationTypeDropdown = lstRelationTypeList;

                if (nDMATAccountHolderID != 0)
                {
                    using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                    {
                        objDMATAccountHolderDTO = objDMATDetailsSL.GetDMATHolderDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATAccountHolderID);
                    }
                    Common.Common.CopyObjectPropertyByName(objDMATAccountHolderDTO, objDMATAccountHolderDetailsModel);
                }
                else
                {
                    objDMATAccountHolderDetailsModel.DMATDetailsID = nDMATDetailsID;
                }

                return PartialView("~/Views/CorporateUser/DMATHolderDetails.cshtml", objDMATAccountHolderDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATAccountHolderDTO = null;
                objDMATAccountHolderDetailsModel = null;
                objPopulateComboDTO = null;
                lstRelationTypeList = null;
            }

        }
        #endregion Edit Joint DMAT Holder Details

        #region Delete Joint DMAT Holder Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>

        public JsonResult DeleteDMATHolderDetails(int nDMATAccountHolderID)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            var ErrorDictionary = new Dictionary<string, string>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.DeleteDMATHolder(objLoginUserDetails.CompanyDBConnectionString, nDMATAccountHolderID, objLoginUserDetails.LoggedInUserID);
                }

                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11321")); //"DMAT Joint Account Holder Details Deleted Successfully"

                return Json(new
                {
                    status = true,
                    Message = ErrorDictionary,

                }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATAccountHolderDTO = null;
                ErrorDictionary = null;
            }

        }
        #endregion Delete Joint DMAT Holder Details

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        #region Confirm Personal Details

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "ConfirmDetails")]
        [ActionName("CorporateUserCreate")]
        [AuthorizationPrivilegeFilter]
        public ActionResult ConfirmDetails(CorporateUSerModel objCorporateUSerModel)
        {
            bool IsConfirmDetails = true;

            return CorporateUserCreate(objCorporateUSerModel, IsConfirmDetails);
        }
        #endregion Confirm Personal Details

        #region Dispose
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose
    }
}
