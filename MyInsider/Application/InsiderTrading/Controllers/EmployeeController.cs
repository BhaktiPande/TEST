using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;



namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class EmployeeController : Controller
    {
        const string sLookUpPrefix = "usr_msg_";
        bool MobileValidaton = false;
        bool MobileNumberOnly = false;
        #region Employee/Insider List
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            PopulateCombo();

            ViewBag.GridType = ConstEnum.GridType.EmployeeUserList;
            ViewBag.Param1 = ConstEnum.Code.EmployeeType.ToString();
            InsiderTradingDAL.ImplementedCompanyDTO objImplementedCompanyDTO = new InsiderTradingDAL.ImplementedCompanyDTO();
            using (var objCompaniesSL = new InsiderTrading.SL.CompaniesSL())
            {
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

            }
            ViewBag.ISMCQRquired = objImplementedCompanyDTO.IsMCQRequired;
            return View();
        }
        #endregion Employee/Insider List

        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid, int nUserInfoID = 0, bool isPPD_Details_Saved = false, bool isEmployee = true)
        {
            bool show_create_role_link = true;
            bool show_not_login_user_details = true;

            TempData["ContactDetails"] = null;

            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;

            int user_action_ViewDetails = 0;
            ViewBag.UserDetailsSaved = false;
            List<ContactDetails> ContactDetails = new List<InsiderTradingDAL.ContactDetails>();
            EmployeeModel objEmployeeModel = new EmployeeModel();
            UserInfoModel objUserInfoModel = new UserInfoModel();
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            LoginUserDetails objLoginUserDetails = null;
            ViewBag.CompanyName = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME_DCMShriram))
                {
                    ViewBag.CompanyName = true;
                }

                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                using (var objCompaniesSL = new CompaniesSL())
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }

                objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.EmployeeType.ToString(), null, null, null, null, true);
                objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.EmployeeType.ToString(), nUserInfoID.ToString(), null, null, null, false);
                using (var objUserInfoSL = new UserInfoSL())
                {
                    if (TempData["ContactDetails"] == null || TempData["ContactDetails"] == "")
                    {
                        ContactDetails = objUserInfoSL.GetContactDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                        if (ContactDetails.Count > 0)
                        {
                            TempData["ContactDetails"] = bindDataTable(ContactDetails, nUserInfoID, 0);
                            ViewBag.mobileno = ContactDetails;
                        }
                    }
                    else
                    {
                        ViewBag.mobileno = ConvertFromDT_ToList((DataTable)TempData["ContactDetails"]);
                        TempData.Keep("ContactDetails");
                    }
                }
                if (nUserInfoID != 0)
                {

                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);

                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                    objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objDocumentDetailsModel.MapToId = nUserInfoID;
                    objDocumentDetailsModel.PurposeCodeId = null;


                }

                //Change added by Raghvendra for fixing the Mantis Bug no 8516 i.e. Different values for Company are seen if Employee added using Mass Upload 
                //and if Company is other than Implementation Company, then on the Employee Create/Edit screen implementation company name was seen. So added
                //a condition to check if the companyid is null or zero as received from the objUserModel i.e. case when adding a new employee user, then only 
                //set the implementation company else show what is saved in database.
                else
                {
                    objUserInfoModel.CompanyId = objImplementedCompanyDTO.CompanyId;
                    objUserInfoModel.CompanyName = objImplementedCompanyDTO.CompanyName;
                    ViewBag.NewEmpRegistration = true;
                }

                ViewBag.EmpPANNumber = objUserInfoModel.PAN;

                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;

                PopulateCombo();
                PopulateSubCategoryCombo(objUserInfoModel.Category);
                PopulateSubDesignationCombo(objUserInfoModel.DesignationId);

                if (ContactDetails.Count == 0 && TempData["ContactDetails"] == null)
                {
                    ContactDetails objcontct = new ContactDetails();
                    objcontct.MobileNumber = (objEmployeeModel.userInfoModel.MobileNumber == null || objEmployeeModel.userInfoModel.MobileNumber == "") ? "+91" : objEmployeeModel.userInfoModel.MobileNumber;
                    ContactDetails.Add(objcontct);
                    TempData["ContactDetails"] = bindDataTable(ContactDetails, nUserInfoID, 0);
                    ViewBag.mobileno = ContactDetails;
                }
                else
                {
                    DataTable dtMobileNo = (DataTable)TempData["ContactDetails"];
                    if (dtMobileNo.Rows.Count > 0)
                    {
                        objEmployeeModel.userInfoModel.MobileNumber = ((DataTable)TempData["ContactDetails"]).Rows[0]["MobileNumber"].ToString();
                        TempData.Keep("ContactDetails");
                    }
                    else
                    { objEmployeeModel.userInfoModel.MobileNumber = "+91"; }

                }
                //set flag to show applicability define or not msg 
                //same view use to show details to insider so check if login user is not insider
                if (nUserInfoID != 0 && nUserInfoID != objLoginUserDetails.LoggedInUserID)
                {
                    //check if user has policy document and trading policy appliable by checking count and set flag to show warning msg if applicabiliyt not define

                    using (var objApplicabilitySL = new ApplicabilitySL())
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
                        user_action_ViewDetails = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW;
                        break;
                    case ConstEnum.Code.EmployeeType:
                        user_action_ViewDetails = ConstEnum.UserActions.VIEW_DETAILS_PERMISSION_FOR_EMPLOYEE_INSIDER;
                        break;
                }

                ViewBag.user_action_ViewDetails = user_action_ViewDetails;

                Session["UserInfoId"] = objUserInfoModel.UserInfoId;
                Session["Confirm_PersonalDetails_Required"] = objUserInfoModel.IsRequiredConfirmPersonalDetails;
                Session["show_confirm_personal_details_btn"] = ViewBag.show_confirm_personal_details_btn;
                Session["EmployeeType"] = isEmployee;
                Session["NonEmployeeType"] = false;

                if (isPPD_Details_Saved)
                {
                    ViewBag.UserDetailsSaved = true;
                    return View("EmployeeDmatDetails", objEmployeeModel);
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
                objUserInfoModel = null;
                objDMATDetailsModel = null;
                objDocumentDetailsModel = null;
                objImplementedCompanyDTO = null;
                objUserInfoDTO = null;
                objLoginUserDetails = null;
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
        public ActionResult Create(EmployeeModel objEmployeeModel, string OldPassword, int acid, bool IsConfirmDetails = false)
        {
            int nUserInfoID = 0;
            //UserInfoModel objUserInfoModel = null;
            LoginUserDetails objLoginUserDetails = null;

            ContactDetails ContactDetailsdata = new ContactDetails();
            bool show_create_role_link = true;
            bool show_not_login_user_details = true;

            bool show_confirm_personal_details_btn = false;
            bool showMsgConfirmPersonalDetails = false;


            List<PopulateComboDTO> lstSelectedRole = null;

            ImplementedCompanyDTO objImplementedCompanyDTO = null;

            bool isError = false; //flag to check for validation error 
            string sMsgDOJ = "";
            string sMsgDOBI = "";
            string sMsgDateCompare = "";
            string sMsgException = "";

            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = null;
            //LoginUserDetails objLoginUser = null;
            string strConfirmMessage = "";
            bool isConfirm = false;

            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                //check if details being shown for login user then set flag to do not show create role link 
                //objLoginUser = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(objEmployeeModel.userInfoModel.UserInfoId), objLoginUserDetails.LoggedInUserID))
                {
                    objLoginUserDetails = null;
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (objEmployeeModel.userInfoModel.UserInfoId != 0 && objEmployeeModel.userInfoModel.UserInfoId == objLoginUserDetails.LoggedInUserID)
                {
                    show_create_role_link = false;
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objEmployeeModel.userInfoModel.IsRequiredConfirmPersonalDetails != null && (bool)objEmployeeModel.userInfoModel.IsRequiredConfirmPersonalDetails)
                    {
                        show_confirm_personal_details_btn = true;
                        showMsgConfirmPersonalDetails = true;
                    }
                }
                else
                {
                    //check if user has permission to create role
                    if (!Common.Common.CanPerform(ConstEnum.UserActions.CRUSER_ROLEMASTER_CREATE))
                    {
                        show_create_role_link = false;
                    }
                }

                ViewBag.show_create_role_link = show_create_role_link;
                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.IsShowMsgConfirmDetails = showMsgConfirmPersonalDetails;
                ViewBag.show_confirm_personal_details_btn = show_confirm_personal_details_btn;

                ViewBag.user_action = acid;

                if (objEmployeeModel.userInfoModel.DateOfJoining != null || objEmployeeModel.userInfoModel.DateOfBecomingInsider != null)
                {
                    DateTime current_date = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                    //check and validate date of joining and date of becoming insider
                    if (objEmployeeModel.userInfoModel.DateOfJoining > current_date)
                    {
                        sMsgDOJ = Common.Common.getResource("usr_msg_11413"); // "Date of Joining should be less than today's date";
                        isError = true;
                    }

                    if (objEmployeeModel.userInfoModel.DateOfBecomingInsider > current_date)
                    {
                        sMsgDOBI = Common.Common.getResource("usr_msg_11414"); // "Date of Becoming Insider should be less than today's date";
                        isError = true;
                    }

                    if (objEmployeeModel.userInfoModel.DateOfBecomingInsider < objEmployeeModel.userInfoModel.DateOfJoining)
                    {
                        sMsgDateCompare = Common.Common.getResource("usr_msg_11415"); // "Date of Becoming Insider should not be less than Date of Joining";
                        isError = true;
                    }
                }

                //check if validation error by checking flag
                if (!isError)
                {
                    UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                    using (var objCompaniesSL = new CompaniesSL())
                    {
                        objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    }
                    //get insider details saved in DB
                    if (objEmployeeModel.userInfoModel.UserInfoId != 0)
                    {
                        using (var objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objEmployeeModel.userInfoModel.UserInfoId);
                        }
                    }


                    //copy details change by insider into DTO to save into DB
                    InsiderTrading.Common.Common.CopyObjectPropertyByNameAndActivity(objEmployeeModel.userInfoModel, objUserInfoDTO);

                    objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.EmployeeType;
                    objUserInfoDTO.IsInsider = ConstEnum.UserType.NonInsider;
                    objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                    objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objUserInfoDTO.ResidentTypeId = objEmployeeModel.userInfoModel.ResidentTypeId;
                    objUserInfoDTO.UIDAI_IdentificationNo = objEmployeeModel.userInfoModel.UIDAI_IdentificationNo;
                    objUserInfoDTO.IdentificationTypeId = objEmployeeModel.userInfoModel.IdentificationTypeId;
                    objUserInfoDTO.AllowUpsiUser = objEmployeeModel.userInfoModel.AllowUpsiUser;

                    
                    if (objUserInfoDTO.StateId == 0)
                        objUserInfoDTO.StateId = null;

                    if (objUserInfoDTO.CountryId == 0)
                        objUserInfoDTO.CountryId = null;

                    if (objUserInfoDTO.Category == 0)
                        objUserInfoDTO.Category = null;

                    if (objUserInfoDTO.SubCategory == 0)
                        objUserInfoDTO.SubCategory = null;

                    if (objUserInfoDTO.GradeId == 0)
                        objUserInfoDTO.GradeId = null;

                    if (objUserInfoDTO.DesignationId == 0)
                        objUserInfoDTO.DesignationId = null;

                    if (objUserInfoDTO.SubDesignationId == 0)
                        objUserInfoDTO.SubDesignationId = null;

                    if (objUserInfoDTO.DepartmentId == 0)
                        objUserInfoDTO.DepartmentId = null;

                    if (objUserInfoDTO.RelationTypeCodeId == 0)
                        objUserInfoDTO.RelationTypeCodeId = null;

                    objUserInfoDTO.CompanyId = objImplementedCompanyDTO.CompanyId;
                    objUserInfoDTO.Password = "";
                    TempData.Keep();
                    //save records into DB
                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                        DataTable dt = new DataTable();
                        dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
                        dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
                        dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
                        if (objEmployeeModel.userInfoModel.UserInfoId == 0)// only excute first time user createion
                        {
                            int rowCount = 0;
                            DataRow dr = dt.NewRow();
                            dt.Rows.Add(dr);
                            dt.Rows[rowCount]["MobileNumber"] = objEmployeeModel.userInfoModel.MobileNumber;
                            dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(objUserInfoDTO.UserInfoId);
                            dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(objUserInfoDTO.UserInfoId);
                            ContactDetailsdata = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
                            TempData["ContactDetails"] = null;
                        }
                    }
                    System.Web.Routing.RouteValueDictionary objRouteValueDictionary = InsiderTrading.Common.Common.IsEditable("MobileNumber", "usr_lbl_11364", null, 0);
                    if (objUserInfoDTO.UserInfoId != 0)
                    {
                        nUserInfoID = objUserInfoDTO.UserInfoId;

                        if (TempData["ContactDetails"] != null)
                        {
                            using (var objUserInfoSL = new UserInfoSL())
                            {
                                MobileNumberOnly = false;
                                MobileValidaton = false;
                                DataTable dt = (DataTable)TempData["ContactDetails"];
                                TempData.Keep();
                                System.Text.RegularExpressions.Regex re = new System.Text.RegularExpressions.Regex(@"^(?:\d{1,15}|(\+91\d{10}|\+[1-8]\d{1,13}|\+(9[987654320])\d{1,12}))$");
                                System.Text.RegularExpressions.Regex reIsText = new System.Text.RegularExpressions.Regex(@"^[+0-9]*$");
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {

                                    if (InsiderTrading.Common.Common.IsEditable("MobileNumber", "usr_lbl_11334").Values.Count != 0)
                                    {


                                        foreach (var objRouteValue in objRouteValueDictionary)
                                        {
                                            if (objRouteValue.Value != "disabled")
                                            {
                                                if (!re.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                                {
                                                    isError = true;
                                                    MobileValidaton = true;
                                                }
                                                if (!reIsText.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                                {
                                                    isError = true;
                                                    MobileNumberOnly = true;
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (dt.Rows[i]["MobileNumber"].ToString().Contains("+") && (dt.Rows[i]["MobileNumber"].ToString()).Length > 3)
                                        {
                                            if (!re.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                            {
                                                isError = true;
                                                MobileValidaton = true;
                                            }
                                            if (!reIsText.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                            {
                                                isError = true;
                                                MobileNumberOnly = true;
                                            }
                                        }
                                        else if (dt.Rows[i]["MobileNumber"].ToString().Contains("+") && (dt.Rows[i]["MobileNumber"].ToString()).Length <= 3)
                                        {
                                            dt.Rows[i]["MobileNumber"] = null;
                                        }
                                    }
                                    dt.Rows[i]["MobileNumber"] = dt.Rows[i]["MobileNumber"].ToString();
                                    dt.Rows[i]["UserInfoID"] = Convert.ToInt32(nUserInfoID);
                                    dt.Rows[i]["UserRelativeID"] = Convert.ToInt32(nUserInfoID);


                                    if ((dt.Rows[i]["MobileNumber"].ToString() == "" || dt.Rows[i]["MobileNumber"].ToString() == null) && dt.Rows.Count > 1)
                                    {
                                        dt.Rows[i].Delete();
                                    }

                                }
                                if (!isError)
                                {
                                    ContactDetailsdata = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);

                                    if (ContactDetailsdata.DuplicateMobileNo != "0")
                                    {
                                        isError = true;
                                    }
                                    else
                                    {
                                        TempData["ContactDetails"] = null;
                                    }
                                }
                            }
                        }
                    }


                    //check if need to confirm personal details 
                    if (IsConfirmDetails && objEmployeeModel.userInfoModel.IsRequiredConfirmPersonalDetails == true)
                    {
                        try
                        {
                            objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                            //set values to save into event log table
                            objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.Event_ConfirmPersonalDetails;
                            objUserPolicyDocumentEventLogDTO.UserInfoId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToId = objUserInfoDTO.UserInfoId;
                            objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.UserDocument;

                            using (InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                            {
                                isConfirm = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                            }

                            if (isConfirm)
                            {
                                strConfirmMessage = Common.Common.getResource("usr_msg_11420"); //Personal Details confirm successfully.

                                return RedirectToAction("Create", "Employee", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoID = objLoginUserDetails.LoggedInUserID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
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
                    }
                    objUserInfoDTO = null;
                }
                else
                {
                    using (var objUserInfoSL = new UserInfoSL())
                    {

                        if (TempData["ContactDetails"] == null)
                        {
                            List<ContactDetails> ContactDetails = objUserInfoSL.GetContactDetails(objLoginUserDetails.CompanyDBConnectionString, objEmployeeModel.userInfoModel.UserInfoId);
                            ViewBag.mobileno = ContactDetails;
                            TempData["ContactDetails"] = bindDataTable(ContactDetails, ContactDetails[0].UserInfoID, 0);
                        }
                        else
                        {
                            ViewBag.mobileno = ConvertFromDT_ToList((DataTable)TempData["ContactDetails"]);
                            TempData.Keep("ContactDetails");
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                sMsgException = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                isError = true;
                if (TempData["ContactDetails"] != null)
                {
                    List<ContactDetails> ContactDetails = new List<ContactDetails>();
                    using (var objUserInfoSL = new UserInfoSL())
                    {

                        DataTable dt_Ex = (DataTable)TempData["ContactDetails"];
                        for (int i = 0; i < dt_Ex.Rows.Count; i++)
                        {
                            ContactDetails objContactDetails = new ContactDetails();

                            objContactDetails.MobileNumber = dt_Ex.Rows[i]["MobileNumber"].ToString();
                            ContactDetails.Add(objContactDetails);
                        }
                        ViewBag.mobileno = ContactDetails;
                        TempData.Keep("ContactDetails");
                    }
                }
                else
                {

                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        TempData["ContactDetails"] = null;
                        List<ContactDetails> ContactDetails = objUserInfoSL.GetContactDetails(objLoginUserDetails.CompanyDBConnectionString, objEmployeeModel.userInfoModel.UserInfoId);
                        ViewBag.mobileno = ContactDetails;

                        if (TempData["ContactDetails"] == null)
                        {
                            TempData["ContactDetails"] = bindDataTable(ContactDetails, ContactDetails[0].UserInfoID, 0);
                        }
                    }
                }

            }
            finally
            {


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
                if (ContactDetailsdata.DuplicateMobileNo != null)
                {
                    ModelState.AddModelError("Error", "Mobile number " + ContactDetailsdata.DuplicateMobileNo + " is already exists");

                    if (TempData["ContactDetails"] != null)
                    {
                        List<ContactDetails> ContactDetails = new List<ContactDetails>();
                        using (var objUserInfoSL = new UserInfoSL())
                        {
                            DataTable dt_Exi = (DataTable)TempData["ContactDetails"];
                            TempData.Keep("ContactDetails");
                            for (int i = 0; i < dt_Exi.Rows.Count; i++)
                            {
                                ContactDetails objContactDetails = new ContactDetails();
                                objContactDetails.MobileNumber = dt_Exi.Rows[i]["MobileNumber"].ToString();
                                ContactDetails.Add(objContactDetails);
                            }
                            ViewBag.mobileno = ContactDetails;
                        }
                    }
                }
                //check mobile pattern

                if (MobileValidaton)
                {
                    if (!MobileNumberOnly)
                        ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_11342"));

                }
                if (MobileNumberOnly)
                {
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54064"));
                }
                if (TempData["ContactDetails"] != null)
                {
                    ViewBag.mobileno = ConvertFromDT_ToList((DataTable)TempData["ContactDetails"]);
                    TempData.Keep("ContactDetails");
                }
                //check if user has selected role and assign those role 
                if (objEmployeeModel.userInfoModel.SubmittedRole != null)
                {
                    lstSelectedRole = new List<PopulateComboDTO>();
                    PopulateComboDTO objPopulateComboDTO = null;
                    for (int cnt = 0; cnt < objEmployeeModel.userInfoModel.SubmittedRole.Count; cnt++)
                    {
                        objPopulateComboDTO = new PopulateComboDTO();
                        objPopulateComboDTO.Key = objEmployeeModel.userInfoModel.SubmittedRole[cnt];
                        lstSelectedRole.Add(objPopulateComboDTO);
                        objPopulateComboDTO = null;
                    }
                }

                //check if user already saved and set non editable property with already saved valued in DB 
                if (objEmployeeModel.userInfoModel.UserInfoId != 0)
                {
                    //get saved info from DB 
                    UserInfoDTO objExistingDetails_UserInfoDTO = new UserInfoDTO();
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objExistingDetails_UserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objEmployeeModel.userInfoModel.UserInfoId);
                    }

                    //copy editable property into DTO so we get existing property and change property
                    Common.Common.CopyObjectPropertyByNameAndActivity(objEmployeeModel.userInfoModel, objExistingDetails_UserInfoDTO);

                    //copy DTO to new model which can be pass to view with already saved details with newly change details
                    UserInfoModel objNewUserInfoModel = new UserInfoModel();
                    objExistingDetails_UserInfoDTO.ResidentTypeId = objEmployeeModel.userInfoModel.ResidentTypeId;
                    objExistingDetails_UserInfoDTO.UIDAI_IdentificationNo = objEmployeeModel.userInfoModel.UIDAI_IdentificationNo;
                    objExistingDetails_UserInfoDTO.IdentificationTypeId = objEmployeeModel.userInfoModel.IdentificationTypeId;
                    Common.Common.CopyObjectPropertyByName(objExistingDetails_UserInfoDTO, objNewUserInfoModel);

                    //set user info model to employee model which content edited info and already save info
                    objEmployeeModel.userInfoModel = objNewUserInfoModel;
                    objExistingDetails_UserInfoDTO = null;
                    objNewUserInfoModel = null;
                }

                PopulateCombo();

                PopulateSubCategoryCombo(objEmployeeModel.userInfoModel.Category);

                PopulateSubDesignationCombo(objEmployeeModel.userInfoModel.DesignationId);

                objEmployeeModel.userInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.EmployeeType.ToString(), null, null, null, null, true);

                //check if user has selected role and assign those role 
                if (lstSelectedRole != null && lstSelectedRole.Count > 0)
                {
                    objEmployeeModel.userInfoModel.AssignedRole = lstSelectedRole;
                }
                else
                {
                    objEmployeeModel.userInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.EmployeeType.ToString(), objEmployeeModel.userInfoModel.UserInfoId.ToString(), null, null, null, false);
                }

                //set implementing company id and name 
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }

                objEmployeeModel.userInfoModel.CompanyId = objImplementedCompanyDTO.CompanyId;
                objEmployeeModel.userInfoModel.CompanyName = objImplementedCompanyDTO.CompanyName;

                //check if dmat details model is set or not
                if (objEmployeeModel.dmatDetailsModel == null)
                {
                    objEmployeeModel.dmatDetailsModel = new DMATDetailsModel();

                    if (objEmployeeModel.userInfoModel.UserInfoId != 0)
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

                    if (objEmployeeModel.userInfoModel.UserInfoId != 0)
                    {
                        objEmployeeModel.documentDetailsModel.MapToId = objEmployeeModel.userInfoModel.UserInfoId;
                    }
                }
                lstSelectedRole = null;
                objLoginUserDetails = null;
                objImplementedCompanyDTO = null;



                return View("Create", objEmployeeModel);
            }

            ArrayList lst = new ArrayList();

            //before showing success message check if first name and last name is NOT NULL
            string fname = objEmployeeModel.userInfoModel.FirstName == null ? "" : objEmployeeModel.userInfoModel.FirstName.Replace("'", "\'").Replace("\"", "\"");
            string lname = objEmployeeModel.userInfoModel.LastName == null ? "" : objEmployeeModel.userInfoModel.LastName.Replace("'", "\'").Replace("\"", "\"");

            lst.Add(fname + " " + lname);
            string AlertMessage = Common.Common.getResource("usr_msg_11266", lst);
            objLoginUserDetails = null;

            objImplementedCompanyDTO = null;
            return RedirectToAction("Create", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoID = nUserInfoID, isPPD_Details_Saved = true }).Success(HttpUtility.UrlEncode(AlertMessage));
        }
        #endregion Create

        #region ConfirmDetails
        [AuthorizationPrivilegeFilter]
        public ActionResult ConfirmPersonalDetails(int acid, int nUserInfoID = 0, int nParentID = 0, bool nRelativeDetailsSaved = false, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            LoginUserDetails objLoginUserDetails = null;
            EmployeeRelativeModel objEmployeeModel = new EmployeeRelativeModel();
            RelativeInfoModel objUserInfoModel = new RelativeInfoModel();
            Relative_DMATDetailsModel objDMATDetailsModel = new Relative_DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            //int DoYouHaveDMATEAccountFlag = 0;

            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (nParentID != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nParentID), objLoginUserDetails.LoggedInUserID))
                {
                    objLoginUserDetails = null;
                    return RedirectToAction("Unauthorised", "Home");
                }


                if (nUserInfoID != 0)
                {
                    if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                    {
                        objLoginUserDetails = null;
                        return RedirectToAction("Unauthorised", "Home");
                    }
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                    nParentID = Common.Common.ConvertToInt32(objUserInfoDTO.ParentId);
                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                    objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objDocumentDetailsModel.MapToId = nUserInfoID;
                    objDocumentDetailsModel.PurposeCodeId = null;
                    //objEmployeeModel.userInfoModel.DoYouHaveDMATEAccount = objUserInfoDTO.DoYouHaveDMATEAccountFlag;
                }
                else
                {
                    ViewBag.NewRelativeRegistration = true;
                }

                objUserInfoModel.DoYouHaveDMATEAccount = objUserInfoDTO.DoYouHaveDMATEAccountFlag;
                ViewBag.RelPANNumber = objUserInfoModel.PAN;

                if (nParentID != 0)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nParentID);
                    }
                    objUserInfoModel.EmployeeId = objUserInfoDTO.EmployeeId;
                    objUserInfoModel.ParentFirstName = objUserInfoDTO.FirstName;
                    objUserInfoModel.ParentLastName = objUserInfoDTO.LastName;
                    objUserInfoModel.CompanyName = objUserInfoDTO.CompanyName;
                    objUserInfoModel.CategoryName = objUserInfoDTO.CategoryName;
                    objUserInfoModel.ParentId = nParentID;
                    objUserInfoModel.UserTypeCodeId = Convert.ToInt32(objUserInfoDTO.UserTypeCodeId);
                    //objUserInfoModel.DoYouHaveDMATEAccount = nHaveDmateAccFlag;
                }
                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;
                ViewBag.userInfoId = nParentID;
                PopulateCombo();

                ViewBag.user_action = acid;

                ViewBag.show_confirm_personal_details_btn = nShowPersonalDetailsConfirmButtonRequired;

                ViewBag.user_action_EditDetails = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT;
                ViewBag.RelativeDetailsSaved = nRelativeDetailsSaved;
                ViewBag.Confirm_PersonalDetails_Required = nConfirmPersonalDetailsRequired;
                return View("ConfirmPersonalDetails", objEmployeeModel);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoModel = null;
                objDMATDetailsModel = null;
                objDocumentDetailsModel = null;
                objUserInfoDTO = null;
            }
            return View("");

        }
        #endregion ConfirmDetails

        #region ViewDetails
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewDetails(int acid, int nUserInfoID = 0, string sCalledFrom = "", int nUserInfoID_ForBack = 0)
        {
            EmployeeModel objEmployeeModel = new EmployeeModel();

            bool show_not_login_user_details = true;
            bool show_confirm_personal_details_btn = false;

            int user_action_ViewDetails = 0;
            UserInfoModel objUserInfoModel = new UserInfoModel();
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();

            //UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                {
                    objLoginUserDetails = null;
                    return RedirectToAction("Unauthorised", "Home");
                }

                ViewBag.sCalledFrom = sCalledFrom;
                ViewBag.nUserInfoID_ForBack = nUserInfoID_ForBack;
                if (nUserInfoID != 0)
                {
                    UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                    objUserInfoDTO = null;
                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                    objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objDocumentDetailsModel.MapToId = nUserInfoID;
                    objDocumentDetailsModel.PurposeCodeId = null;
                }

                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;
                ViewBag.LoggedInUserID = objLoginUserDetails.LoggedInUserID;
                ViewBag.UserInfoID = nUserInfoID;
                @ViewBag.GridType = Common.ConstEnum.GridType.UserRelativeList;

                /*
                 Change done by Raghvendra. Fix for bug no 8516, the selected role is not seen selected on the View details page, 
                 * as the list box on the view details page is disabled and if the selected role is outside the viewable area then 
                 * it cannot be seen. Did the change to show the roles applied to user at top so that those can be seen in disabled 
                 * mode also.
                */

                List<PopulateComboDTO> lstDefaultRoleListToUse = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstAssignedRoleList = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstDefaultRoleList = new List<PopulateComboDTO>();
                List<string> lstSelectedRolesKey = new List<string>();

                //All the roles for selected user type
                lstDefaultRoleList = FillComboValues(ConstEnum.ComboType.RoleList, objUserInfoModel.UserTypeCodeId.ToString(), null, null, null, null, false);

                //Roles assigned to selected user
                lstAssignedRoleList = FillComboValues(ConstEnum.ComboType.RoleList, objUserInfoModel.UserTypeCodeId.ToString(), nUserInfoID.ToString(), null, null, null, false);
                foreach (PopulateComboDTO ojPopulateComboDTO in lstAssignedRoleList)
                {
                    lstSelectedRolesKey.Add(ojPopulateComboDTO.Key);
                }
                lstDefaultRoleListToUse.AddRange(lstAssignedRoleList);
                foreach (PopulateComboDTO ojPopulateComboDTO in lstDefaultRoleList)
                {
                    if (!lstSelectedRolesKey.Contains(ojPopulateComboDTO.Key))
                    {
                        lstDefaultRoleListToUse.Add(ojPopulateComboDTO);
                    }
                }
                objUserInfoModel.DefaultRole = lstDefaultRoleListToUse;
                objUserInfoModel.AssignedRole = lstAssignedRoleList;
                lstDefaultRoleList = null;
                lstAssignedRoleList = null;
                lstDefaultRoleListToUse = null;
                lstSelectedRolesKey = null;

                //set flag to show applicability define or not msg 
                if (nUserInfoID != 0 && nUserInfoID != objLoginUserDetails.LoggedInUserID)
                {
                    //check if user has policy document and trading policy appliable by checking count and set flag to show warning msg if applicabiliyt not define
                    //ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
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

                bool showMsgConfirmPersonalDetails = false;

                //check if details being shown for login user then set flag to do not show create role link 
                //also check if login user is employee then set flag to show confirm button 
                if (nUserInfoID != 0 && nUserInfoID == objLoginUserDetails.LoggedInUserID)
                {
                    show_not_login_user_details = false;

                    //check if login user has already confirm personal details - if user has confirm personal details then do not show confirm button 
                    if (objUserInfoModel.IsRequiredConfirmPersonalDetails != null && (bool)objUserInfoModel.IsRequiredConfirmPersonalDetails)
                    {
                        show_confirm_personal_details_btn = true;
                        showMsgConfirmPersonalDetails = true;
                    }
                }

                ViewBag.IsShowMsgConfirmDetails = showMsgConfirmPersonalDetails;

                ViewBag.show_not_login_user_details = show_not_login_user_details;

                ViewBag.user_action = acid;

                ViewBag.show_confirm_personal_details_btn = show_confirm_personal_details_btn;

                switch (objLoginUserDetails.UserTypeCodeId)
                {
                    case ConstEnum.Code.Admin:
                    case ConstEnum.Code.COUserType:
                        user_action_ViewDetails = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW;
                        break;
                    case ConstEnum.Code.EmployeeType:
                        user_action_ViewDetails = ConstEnum.UserActions.VIEW_DETAILS_PERMISSION_FOR_EMPLOYEE_INSIDER;
                        break;
                    case ConstEnum.Code.NonEmployeeType:
                        user_action_ViewDetails = ConstEnum.UserActions.VIEW_DETAILS_PERMISSION_FOR_NON_EMPLOYEE_USER;
                        break;
                }

                ViewBag.user_action_ViewDetails = user_action_ViewDetails;

            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objDocumentDetailsModel = null;
                objDMATDetailsModel = null;

            }
            return View("View", objEmployeeModel);
        }
        #endregion ViewDetails

        #region CreateRelative
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult CreateRelative(int acid, int nUserInfoID = 0, int nParentID = 0, bool nUserEducationSaved = false, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            LoginUserDetails objLoginUserDetails = null;
            EmployeeRelativeModel objEmployeeModel = new EmployeeRelativeModel();
            RelativeInfoModel objUserInfoModel = new RelativeInfoModel();
            Relative_DMATDetailsModel objDMATDetailsModel = new Relative_DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            List<ContactDetails> RelativeContactdata = new List<ContactDetails>();
            TempData["RelativeMobileDetail"] = null;
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (nParentID != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nParentID), objLoginUserDetails.LoggedInUserID))
                {
                    objLoginUserDetails = null;
                    return RedirectToAction("Unauthorised", "Home");
                }

                if (!nUserEducationSaved)
                {
                    UserEducationDTO objUserEducationDTO = new UserEducationDTO();
                    objUserEducationDTO.UserInfoId = (nUserInfoID == 0) ? nParentID : nUserInfoID;
                    objUserEducationDTO.Operation = "UPDATE_NO_EDU_WORK";

                    //update no education/work details
                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        objUserEducationDTO = objUserInfoSL.InsertUpdateUserEducationDetails(objLoginUserDetails.CompanyDBConnectionString, objUserEducationDTO);
                        nUserEducationSaved = true;
                    }
                }
                System.Web.Routing.RouteValueDictionary objRouteValueDictionary = InsiderTrading.Common.Common.IsEditable("MobileNumber", "usr_lbl_11364", null, 1);
                if (nUserInfoID != 0)
                {
                    if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                    {
                        objLoginUserDetails = null;
                        return RedirectToAction("Unauthorised", "Home");
                    }
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                    nParentID = Common.Common.ConvertToInt32(objUserInfoDTO.ParentId);
                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                    objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    objDocumentDetailsModel.MapToId = nUserInfoID;
                    objDocumentDetailsModel.PurposeCodeId = null;

                    using (var objUserInfoSL = new UserInfoSL())
                    {

                        if (TempData["RelativeMobileDetail"] == null)
                        {
                            RelativeContactdata = objUserInfoSL.GetRelativeDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);

                            if (RelativeContactdata.Count > 0)
                            {
                                if (RelativeContactdata.Count == 1)
                                {
                                    foreach (var UsrContact in RelativeContactdata)
                                    {
                                        foreach (var objRouteValue in objRouteValueDictionary)
                                        {
                                            if (objRouteValue.Value == "disabled" && objUserInfoModel.MobileNumber == null)
                                            {
                                                objUserInfoModel.MobileNumber = null;
                                            }
                                            else if (objRouteValue.Value != "disabled" && objUserInfoModel.MobileNumber == null)
                                            {
                                                objUserInfoModel.MobileNumber = "+91";
                                                UsrContact.MobileNumber = "+91";
                                            }
                                        }

                                    }
                                }
                                TempData["RelativeMobileDetail"] = bindDataTableRelative(RelativeContactdata, nUserInfoID, 0);

                            }
                            else
                            {
                                ContactDetails objContactRelative = new ContactDetails();
                                objContactRelative.MobileNumber = objUserInfoDTO.MobileNumber;
                                RelativeContactdata.Add(objContactRelative);
                            }
                            ViewBag.RelativeContact = RelativeContactdata;
                        }

                    }
                }
                else
                {
                    ContactDetails objContactRelative = new ContactDetails();
                    objContactRelative.MobileNumber = null;

                    if (objRouteValueDictionary.Values.Count != 0)
                    {
                        foreach (var objRouteValue in objRouteValueDictionary)
                        {
                            if (objRouteValue.Value == "disabled")
                            {
                                objUserInfoModel.MobileNumber = null;
                            }
                            else
                            {
                                objUserInfoModel.MobileNumber = "+91";
                            }
                        }
                    }
                    else
                    {
                        objUserInfoModel.MobileNumber = null;
                    }
                    RelativeContactdata.Add(objContactRelative);
                    ViewBag.RelativeContact = RelativeContactdata;
                    ViewBag.NewRelativeRegistration = true;
                }
                objUserInfoModel.DoYouHaveDMATEAccount = objUserInfoDTO.DoYouHaveDMATEAccountFlag;
                ViewBag.RelPANNumber = objUserInfoModel.PAN;
                if (nParentID != 0)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nParentID);
                    }
                    objUserInfoModel.EmployeeId = objUserInfoDTO.EmployeeId;
                    objUserInfoModel.ParentFirstName = objUserInfoDTO.FirstName;
                    objUserInfoModel.ParentLastName = objUserInfoDTO.LastName;
                    objUserInfoModel.CompanyName = objUserInfoDTO.CompanyName;
                    objUserInfoModel.CategoryName = objUserInfoDTO.CategoryName;
                    objUserInfoModel.ParentId = nParentID;
                    objUserInfoModel.UserTypeCodeId = Convert.ToInt32(objUserInfoDTO.UserTypeCodeId);
                }
                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;
                ViewBag.userInfoId = nParentID;
                PopulateCombo();

                ViewBag.user_action = acid;

                ViewBag.show_confirm_personal_details_btn = nShowPersonalDetailsConfirmButtonRequired;

                ViewBag.user_action_EditDetails = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT;
                ViewBag.nUserEducationSaved = nUserEducationSaved;
                ViewBag.Confirm_PersonalDetails_Required = nConfirmPersonalDetailsRequired;
                return View("CreateRelative", objEmployeeModel);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoModel = null;
                objDMATDetailsModel = null;
                objDocumentDetailsModel = null;
                objUserInfoDTO = null;
            }
            return View("");

        }
        #endregion CreateRelative

        #region Save/Update Relative Details
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        public ActionResult CreateRelative(EmployeeRelativeModel employeeModel, int acid, string returnUrl, bool IsChecked = false, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            int nUserInfoID = 0;
            int? nParentID = 0;

            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            Relative_DMATDetailsModel objRelative_DMATDetailsModel = null;
            objRelative_DMATDetailsModel = new Relative_DMATDetailsModel();
            ContactDetails ContactDetailsRelative = new ContactDetails();
            //UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            bool isError = false;
            string sErrMessage = "";

            try
            {
                if (employeeModel.userInfoModel.RelationTypeCodeId == 0)
                {
                    sErrMessage = Common.Common.getResource("usr_msg_11366"); //"Relation with Employee field is required";
                    isError = true;
                }

                //check if there is no error before saving details
                if (!isError)
                {
                    if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(employeeModel.userInfoModel.ParentId), objLoginUserDetails.LoggedInUserID))
                    {
                        objLoginUserDetails = null;
                        return RedirectToAction("Unauthorised", "Home");
                    }
                    if (employeeModel.userInfoModel.UserInfoId != 0)
                    {
                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, employeeModel.userInfoModel.UserInfoId);
                        }
                        if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(employeeModel.userInfoModel.UserInfoId), objLoginUserDetails.LoggedInUserID))
                        {
                            objLoginUserDetails = null;
                            return RedirectToAction("Unauthorised", "Home");
                        }
                    }

                    Common.Common.CopyObjectPropertyByNameAndActivity(employeeModel.userInfoModel, objUserInfoDTO, ConstEnum.IsRelative.Relative);

                    objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.RelativeType;
                    objUserInfoDTO.IsInsider = ConstEnum.UserType.Insider;
                    objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                    objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objUserInfoDTO.ParentId = employeeModel.userInfoModel.ParentId;
                    objUserInfoDTO.RelativeStatus = employeeModel.userInfoModel.RelativeStatus;
                    objUserInfoDTO.DoYouHaveDMATEAccountFlag = employeeModel.userInfoModel.DoYouHaveDMATEAccount;
                    objUserInfoDTO.IdentificationTypeId = employeeModel.userInfoModel.IdentificationTypeId;
                    objUserInfoDTO.UIDAI_IdentificationNo = employeeModel.userInfoModel.UIDAI_IdentificationNo;
                    if (objUserInfoDTO.CompanyId == 0)
                        objUserInfoDTO.CompanyId = null;

                    if (objUserInfoDTO.StateId == 0)
                        objUserInfoDTO.StateId = null;

                    if (objUserInfoDTO.CountryId == 0)
                        objUserInfoDTO.CountryId = null;

                    if (objUserInfoDTO.Category == 0)
                        objUserInfoDTO.Category = null;

                    if (objUserInfoDTO.GradeId == 0)
                        objUserInfoDTO.GradeId = null;

                    if (objUserInfoDTO.DesignationId == 0)
                        objUserInfoDTO.DesignationId = null;

                    if (objUserInfoDTO.DepartmentId == 0)
                        objUserInfoDTO.DepartmentId = null;

                    if (objUserInfoDTO.RelationTypeCodeId == 0)
                        objUserInfoDTO.RelationTypeCodeId = null;


                    ViewBag.Confirm_PersonalDetails_Required = nShowPersonalDetailsConfirmButtonRequired;
                    //save relative details
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                        DataTable dt = new DataTable();

                        dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
                        dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
                        dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
                        if (employeeModel.userInfoModel.UserInfoId == 0)// only excute first time relative createion
                        {

                            int rowCount = 0;
                            DataRow dr = dt.NewRow();
                            dt.Rows.Add(dr);
                            dt.Rows[rowCount]["MobileNumber"] = employeeModel.userInfoModel.MobileNumber;
                            dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(employeeModel.userInfoModel.ParentId);
                            dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(objUserInfoDTO.UserInfoId);
                            ContactDetailsRelative = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
                            TempData["RelativeMobileDetail"] = null;
                        }
                    }
                    System.Web.Routing.RouteValueDictionary objRouteValueDictionary = InsiderTrading.Common.Common.IsEditable("MobileNumber", "usr_lbl_11364", null, 1);
                    if (objUserInfoDTO.UserInfoId != 0)
                    {
                        nUserInfoID = objUserInfoDTO.UserInfoId;
                        nParentID = employeeModel.userInfoModel.ParentId;

                        if (TempData["RelativeMobileDetail"] != null)
                        {
                            using (var objUserInfoSL = new UserInfoSL())
                            {
                                MobileNumberOnly = false;
                                MobileValidaton = false;
                                DataTable dt = (DataTable)TempData["RelativeMobileDetail"];
                                TempData.Keep("RelativeMobileDetail");
                                System.Text.RegularExpressions.Regex re = new System.Text.RegularExpressions.Regex(@"^(?:\d{1,15}|(\+91\d{10}|\+[1-8]\d{1,13}|\+(9[987654320])\d{1,12}))$");
                                System.Text.RegularExpressions.Regex reIsText = new System.Text.RegularExpressions.Regex(@"^[+0-9]*$");
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    if (objRouteValueDictionary.Count != 0)
                                    {
                                        foreach (var objRouteValue in objRouteValueDictionary)
                                        {
                                            if (objRouteValue.Value != "disabled")
                                            {
                                                if (!re.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                                {
                                                    isError = true;
                                                    MobileValidaton = true;
                                                }
                                                if (!reIsText.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                                {
                                                    isError = true;
                                                    MobileNumberOnly = true;
                                                }
                                            }

                                        }

                                    }
                                    else
                                    {
                                        if (dt.Rows[i]["MobileNumber"].ToString().Contains("+") && (dt.Rows[i]["MobileNumber"].ToString()).Length > 3)
                                        {
                                            if (!re.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                            {
                                                isError = true;
                                                MobileValidaton = true;
                                            }
                                            if (!reIsText.IsMatch(dt.Rows[i]["MobileNumber"].ToString()))
                                            {
                                                isError = true;
                                                MobileNumberOnly = true;
                                            }
                                        }
                                        else if (dt.Rows[i]["MobileNumber"].ToString().Contains("+") && (dt.Rows[i]["MobileNumber"].ToString()).Length <= 3)
                                        {
                                            dt.Rows[i]["MobileNumber"] = null;
                                        }
                                    }
                                    dt.Rows[i]["MobileNumber"] = dt.Rows[i]["MobileNumber"].ToString();
                                    dt.Rows[i]["UserInfoID"] = Convert.ToInt32(nParentID);
                                    dt.Rows[i]["UserRelativeID"] = Convert.ToInt32(nUserInfoID);
                                    if ((dt.Rows[i]["MobileNumber"].ToString() == "" || dt.Rows[i]["MobileNumber"].ToString() == null) && dt.Rows.Count > 1)
                                    {
                                        dt.Rows[i].Delete();
                                    }
                                }


                                if (!isError)
                                {
                                    ContactDetailsRelative = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
                                    if (ContactDetailsRelative.DuplicateMobileNo != "0")
                                    {
                                        isError = true;
                                    }
                                    else
                                    {

                                        TempData["RelativeMobileDetail"] = null;
                                    }
                                }
                            }
                        }
                    }


                }
            }
            catch (Exception exp)
            {
                sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                isError = true;
                if (TempData["RelativeMobileDetail"] != null)
                {

                    ViewBag.RelativeContact = ConvertFromDT_ToListRelative((DataTable)TempData["RelativeMobileDetail"]);
                    TempData.Keep("RelativeMobileDetail");
                }
                else
                {
                    if (objUserInfoDTO.UserInfoId != 0)
                    {
                        using (var objUserInfoSL = new UserInfoSL())
                        {

                            List<ContactDetails> RelativeContact = objUserInfoSL.GetRelativeDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO.UserInfoId);
                            ViewBag.RelativeContact = RelativeContact;
                            TempData["RelativeMobileDetail"] = bindDataTableRelative(RelativeContact, nUserInfoID, 0); ;

                        }
                    }
                }


            }

            //check if error is occured or not
            if (isError)
            {
                //get insider information for the relative
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(employeeModel.userInfoModel.ParentId));
                }

                //set insider information which is shown on relative page
                employeeModel.userInfoModel.EmployeeId = objUserInfoDTO.EmployeeId;
                employeeModel.userInfoModel.ParentFirstName = objUserInfoDTO.FirstName;
                employeeModel.userInfoModel.ParentLastName = objUserInfoDTO.LastName;
                employeeModel.userInfoModel.CompanyName = objUserInfoDTO.CompanyName;
                employeeModel.userInfoModel.CategoryName = objUserInfoDTO.CategoryName;
                employeeModel.userInfoModel.UserTypeCodeId = Convert.ToInt32(objUserInfoDTO.UserTypeCodeId);

                //check if dmat details model is set or not
                if (employeeModel.dmatDetailsModel == null)
                {
                    employeeModel.dmatDetailsModel = new Relative_DMATDetailsModel();
                    employeeModel.dmatDetailsModel.UserInfoID = employeeModel.userInfoModel.UserInfoId;
                }

                //check if document details are set or not
                if (employeeModel.documentDetailsModel == null)
                {
                    employeeModel.documentDetailsModel = new DocumentDetailsModel();

                    employeeModel.documentDetailsModel.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                    employeeModel.documentDetailsModel.MapToId = employeeModel.userInfoModel.UserInfoId;
                    employeeModel.documentDetailsModel.PurposeCodeId = null;
                }


                ViewBag.DupEmailChk = false;
                PopulateCombo();

                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                ModelState.AddModelError("Error", sErrMessage);
                if (ContactDetailsRelative.DuplicateMobileNo != null)
                {

                    ModelState.AddModelError("Error", "Mobile number " + ContactDetailsRelative.DuplicateMobileNo + " is already exists");


                }
                if (TempData["RelativeMobileDetail"] != null)
                {
                    ViewBag.RelativeContact = ConvertFromDT_ToListRelative((DataTable)TempData["RelativeMobileDetail"]);
                    TempData.Keep("RelativeMobileDetail");
                }

                if (MobileValidaton)
                {
                    if (!MobileNumberOnly)
                        ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54065"));
                }
                if (MobileNumberOnly)
                {
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54066"));
                }

                objLoginUserDetails = null;

                return View("CreateRelative", employeeModel);
            }
            objLoginUserDetails = null;
            return RedirectToAction("CreateRelative", new { acid = acid, nUserInfoID = 0, nParentID = employeeModel.userInfoModel.ParentId, nConfirmPersonalDetailsRequired, nShowPersonalDetailsConfirmButtonRequired }).Success(Common.Common.getResource("usr_msg_11280"));
        }
        #endregion Save/Update Relative Details

        #region SaveDMATDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult SaveDMATDetails(DMATDetailsModel objDMATDetailsModel, int acid, string callfrom = "")
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            bool bRefreshDematList = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(objDMATDetailsModel.UserInfoID), objLoginUserDetails.LoggedInUserID))
                {
                    // return PartialView("~/Views/Home/UnauthorizedAcess.cshtml");
                    return Json(new
                    {
                        status = false,
                        Message = "You dont have permission to access this page.", //"DMAT Details Save Successfully",
                        type = false,
                        DMATDetailsID = 0

                    }, JsonRequestBehavior.AllowGet);
                }


                Common.Common.CopyObjectPropertyByName(objDMATDetailsModel, objDMATDetailsDTO);

                //check DEMAT account type(CDSL, NSDL, Others)
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
                else if (objDMATDetailsModel.DPBank == "0")
                {
                    objDMATDetailsDTO.DPBank = "";
                    objDMATDetailsDTO.DPBankCodeId = null;
                }
                else
                {
                    objDMATDetailsDTO.DPBank = "";
                    objDMATDetailsDTO.DPBankCodeId = Convert.ToInt32(objDMATDetailsModel.DPBank);
                }

                bool getList = false;
                if (objDMATDetailsDTO.AccountTypeCodeId == ConstEnum.Code.Joint)
                {
                    getList = true;
                }
                else if (objDMATDetailsModel.DPBank == "Select")
                {
                    objDMATDetailsDTO.DPBank = "";
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
                ////For Act/inact
                //int PendingPeriodEndCount = 0;
                //int PendingTransactionsCountPNT = 0;
                //int PendingTransactionsCountPCL = 0;

                //using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                //{
                //    objDMATDetailsSL.GetPendingTransactionforSecurityTransfer(objLoginUserDetails.CompanyDBConnectionString,
                //    2, out PendingPeriodEndCount, out PendingTransactionsCountPNT, out PendingTransactionsCountPCL);
                //}

                //string sErrMessage1 = Common.Common.getResource("usr_msg_50067");
                //ModelState.AddModelError("Error", sErrMessage1);
                //return Json(new
                //{
                //    status = false,
                //    Message = sErrMessage1,
                //}, JsonRequestBehavior.AllowGet);

                //
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsDTO = objDMATDetailsSL.SaveDMATDetails(objLoginUserDetails.CompanyDBConnectionString, objDMATDetailsDTO, objLoginUserDetails.LoggedInUserID);
                    if (objDMATDetailsDTO.DMATDetailsID == 0)
                    {
                        string sErrMessage = "";

                        if (objDMATDetailsDTO.PendingTransactionsCountPCL > 0 || objDMATDetailsDTO.PendingTransactionsCountPNT > 0)
                        {
                            sErrMessage = Common.Common.getResource("usr_msg_51026");
                        }
                        else
                        {
                            sErrMessage = Common.Common.getResource("usr_msg_50067");
                        }

                        ModelState.AddModelError("", "");
                        return Json(new
                        {
                            status = false,
                            Message = sErrMessage,
                        }, JsonRequestBehavior.AllowGet);
                    }
                    //else if (objDMATDetailsDTO.PendingTransactionsCountPNT > 0 || objDMATDetailsDTO.PendingTransactionsCountPCL > 0)
                    //{
                    //    string sErrMessage = Common.Common.getResource("usr_msg_50067");
                    //    ModelState.AddModelError("", "");
                    //    return Json(new
                    //    {
                    //        status = false,
                    //        Message = sErrMessage,
                    //    }, JsonRequestBehavior.AllowGet);
                    //}
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
        #endregion SaveDMATDetails

        #region SaveDMATHolderDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult SaveDMATHolderDetails(DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            //DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL();
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
                    Message = Common.Common.getResource("usr_msg_11345") //"DMAT Joint Account Holder Details Save Successfully"

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
        #endregion SaveDMATHolderDetails

        #region DeleteDMATDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteDMATDetails(int acid, int nDMATDetailsID)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            //DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            //DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID, objLoginUserDetails.LoggedInUserID);
                }
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11346"));
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
                //objDMATDetailsDTO = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);

        }
        #endregion DeleteDMATDetails

        #region DeleteDMATHolderDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteDMATHolderDetails(int nDMATAccountHolderID, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            //DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            //DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL();
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.DeleteDMATHolder(objLoginUserDetails.CompanyDBConnectionString, nDMATAccountHolderID, objLoginUserDetails.LoggedInUserID);
                }
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11347")); //"DMAT Joint Account Holder Details Deleted Successfully"

                return Json(new
                {
                    status = true,
                    Message = ErrorDictionary

                }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                ErrorDictionary = null;
            }

        }
        #endregion DeleteDMATHolderDetailss

        #region Delete Relative Details
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DelateRelative(int acid, int nUserInfoID)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, objLoginUserDetails.LoggedInUserID);
                }
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11367")); //Relation Details Deleted Sucessfully
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
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion Delet eRelative Details

        #region EditDMATDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public PartialViewResult EditDMATDetails(int acid, int nDMATDetailsID = 0, int nUserInfoID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new DMATAccountHolderDetailsModel();

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstDPNameList = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDPBankDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstAccountTypeList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstUserDmatStatusList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstRelationTypeList = new List<PopulateComboDTO>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";


                lstDPNameList.Add(objPopulateComboDTO);
                lstDPNameList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DPName).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());

                //objPopulateComboDPBankDTO.Key = "Other";
                //objPopulateComboDPBankDTO.Value = "Other";
                //lstDPNameList.Add(objPopulateComboDPBankDTO);
                //ViewBag.DPBankDropdown = lstDPNameList;
                if (nDMATDetailsID != 0)
                {
                    objPopulateComboDPBankDTO.Key = "1";
                    objPopulateComboDPBankDTO.Value = "Other";
                    lstDPNameList.Add(objPopulateComboDPBankDTO);
                    ViewBag.DPBankDropdown = lstDPNameList;
                }
                else
                {
                    objPopulateComboDPBankDTO.Key = "1";
                    objPopulateComboDPBankDTO.Value = "Other";
                    lstDPNameList.Add(objPopulateComboDPBankDTO);
                    ViewBag.DPBankDropdown = lstDPNameList;

                }

                //lstAccountTypeList.Add(objPopulateComboDTO);
                lstAccountTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DMATAccountType).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                if (lstAccountTypeList.Select(elem => elem.Key == "121002").Count() > 0)
                {
                    lstAccountTypeList.RemoveAll(elem => elem.Key == "121002");
                }
                ViewBag.AccountTypeDropdown = lstAccountTypeList;


                //lstUserDmatStatusList.Add(objPopulateComboDTO);
                lstUserDmatStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                ViewBag.UserDmatStatusDropdown = lstUserDmatStatusList;


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
                    Common.Common.CopyObjectPropertyByName(objDMATDetailsDTO, objDMATDetailsModel);
                    bool flag = false;
                    foreach (PopulateComboDTO kvp in lstDPNameList)
                    {
                        if (objDMATDetailsDTO.DPBank == "" || kvp.Value == objDMATDetailsDTO.DPBank)
                        {
                            objDMATDetailsModel.DPBank = objDMATDetailsDTO.DPBankCodeId.ToString();
                            objDMATDetailsModel.DPBankName = null;
                            flag = true;
                            break;
                        }
                    }
                    if (!flag)
                    {
                        objDMATDetailsModel.DPBank = "Other";
                        objDMATDetailsModel.DPBankName = objDMATDetailsDTO.DPBank;
                    }
                }
                else
                {
                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                }

                ViewBag.user_action = acid;

                return PartialView("~/Views/Common/DMATDetailsModal.cshtml", objDMATDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATDetailsDTO = null;
                objDMATAccountHolderDetailsModel = null;

                objPopulateComboDTO = null;
                lstDPNameList = null;
                objPopulateComboDPBankDTO = null;
                lstAccountTypeList = null;
                lstUserDmatStatusList = null;
                lstRelationTypeList = null;
            }

        }
        #endregion EditDMATDetails

        #region EditDMATHolderDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public PartialViewResult EditDMATHolderDetails(int acid, int nDMATAccountHolderID = 0, int nDMATDetailsID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new DMATAccountHolderDetailsModel();

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
                return PartialView("~/Views/Common/DMATHolderDetails.cshtml", objDMATAccountHolderDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATAccountHolderDTO = null;
                objPopulateComboDTO = null;
                lstRelationTypeList = null;
            }

        }
        #endregion EditDMATHolderDetails

        #region DeleteUser
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        //public JsonResult DeleteUser(int acid, int nDeleteUserId,string __RequestVerificationToken, int formId)
        public JsonResult DeleteUser(int acid, int nDeleteUserId)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (UserInfoSL objUser = new UserInfoSL())
                {
                    objUser.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, nDeleteUserId, objLoginUserDetails.LoggedInUserID);
                }
                statusFlag = true;
                ErrorDictionary.Add("success", "Record deleted");

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
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteUser
        #region Education Details
        /// <summary>
        /// Render view for Education/work details
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="nUserInfoID"></param>
        /// <param name="UEW_id"></param>
        /// <param name="Flag"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult EducationDetails(int acid, int nUserInfoID = 0, int UEW_id = 0, string Flag = "DEFAULT", bool nUserDematSaved = false, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            ViewBag.FromEducationPost = false;
            ViewBag.FromWorkPost = false;

            if (Flag != "DEFAULT")
                ViewBag.acid = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT;
            else
                ViewBag.acid = acid;

            ViewBag.ISEducation = (Flag == "EDUCATION") ? "1" : (Flag == "WORK") ? "2" : "-1";
            EmployeeModel objEmployeeModel = new EmployeeModel();
            objEmployeeModel.userEducationModel = new EducationDetailModel();
            UserEducationDTO objUserEducationDTO = new UserEducationDTO();
            LoginUserDetails objLoginUserDetails = null;
            objEmployeeModel.userEducationModel.UserInfoID = nUserInfoID;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            if (objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME_DCMShriram))
            {
                ViewBag.CompanyName = true;
            }

            if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
            {
                return RedirectToAction("Unauthorised", "Home");
            }

            if (nUserInfoID != 0 && UEW_id != 0)
            {
                objEmployeeModel.userEducationModel.UEW_id = UEW_id;
                using (var objUserInfoSL = new UserInfoSL())
                {
                    objUserEducationDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID, UEW_id);
                }

                Common.Common.CopyObjectPropertyByName(objUserEducationDTO, objEmployeeModel.userEducationModel);


                if (Flag == "WORK")
                {
                    objEmployeeModel.userEducationModel.From_Month = objUserEducationDTO.PMonth;
                    objEmployeeModel.userEducationModel.From_Year = objUserEducationDTO.PYear.ToString();

                    objEmployeeModel.userEducationModel.Employer = objUserEducationDTO.EmployerName;
                    objEmployeeModel.userEducationModel.Designation = objUserEducationDTO.Designation;
                    objEmployeeModel.userEducationModel.To_Month = objUserEducationDTO.ToMonth;
                    objEmployeeModel.userEducationModel.To_Year = objUserEducationDTO.ToYear.ToString();
                }
                else if (Flag == "EDUCATION")
                {
                    objEmployeeModel.userEducationModel.InstituteName = objUserEducationDTO.InstituteName;
                    objEmployeeModel.userEducationModel.CourseName = objUserEducationDTO.CourseName;
                    objEmployeeModel.userEducationModel.PassingMonth = objUserEducationDTO.PMonth;
                    objEmployeeModel.userEducationModel.PassingYear = objUserEducationDTO.PYear.ToString();
                }

            }


            ViewBag.show_confirm_personal_details_btn = nShowPersonalDetailsConfirmButtonRequired;
            ViewBag.UserDematSaved = nUserDematSaved;
            ViewBag.Confirm_PersonalDetails_Required = nConfirmPersonalDetailsRequired;



            //  objEmployeeModel.userInfoModel.ParentId = nParentID;
            return View(objEmployeeModel);
        }

        /// <summary>
        ///  Save & Update Education details into DB
        /// </summary>
        /// <param name="objEmployeeModel"></param>
        /// <param name="acid"></param>
        /// <param name="nUserInfoID"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult EducationDetails(EmployeeModel objEmployeeModel, int acid, int nUserInfoID = 0, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            try
            {
                UserEducationDTO objUserEducationDTO = new UserEducationDTO();
                //ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
                UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                LoginUserDetails objLoginUserDetails = null;
                objEmployeeModel.userEducationModel.UserInfoID = nUserInfoID;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);



                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                if (nUserInfoID != 0)
                {
                    //add all model value to DTO object for insertation into DB
                    objUserEducationDTO.UEW_id = objEmployeeModel.userEducationModel.UEW_id;
                    objUserEducationDTO.InstituteName = objEmployeeModel.userEducationModel.InstituteName;
                    objUserEducationDTO.UserInfoId = objEmployeeModel.userEducationModel.UserInfoID;
                    objUserEducationDTO.CourseName = objEmployeeModel.userEducationModel.CourseName;
                    objUserEducationDTO.PMonth = objEmployeeModel.userEducationModel.PassingMonth;
                    objUserEducationDTO.PYear = Convert.ToInt16(objEmployeeModel.userEducationModel.PassingYear);
                    objUserEducationDTO.Flag = 1;
                    objUserEducationDTO.Operation = (objEmployeeModel.userEducationModel.UEW_id == 0) ? "INSERT" : "UPDATE";


                    //save records into DB
                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        objUserEducationDTO = objUserInfoSL.InsertUpdateUserEducationDetails(objLoginUserDetails.CompanyDBConnectionString, objUserEducationDTO);
                    }

                }

            }
            catch (Exception exp)
            {
                ViewBag.acid = acid;
                ViewBag.FromEducationPost = true;
                //string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                ModelState.AddModelError("Error", Common.Common.getResource(exp.InnerException.Data[0].ToString()));

                return View("EducationDetails", objEmployeeModel);

            }



            return RedirectToAction("EducationDetails", new { acid = acid, nUserInfoID = nUserInfoID, nUserDematSaved = true, nConfirmPersonalDetailsRequired = nConfirmPersonalDetailsRequired, nShowPersonalDetailsConfirmButtonRequired = nShowPersonalDetailsConfirmButtonRequired }).Success(HttpUtility.UrlEncode(Common.Common.getResource("usr_msg_54031")));
        }
        /// <summary>
        /// Save & Update Work details into DB
        /// </summary>
        /// <param name="objEmployeeModel"></param>
        /// <param name="acid"></param>
        /// <param name="nUserInfoID"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult WorkDetails(EmployeeModel objEmployeeModel, int acid, int nUserInfoID = 0, bool nConfirmPersonalDetailsRequired = false, bool nShowPersonalDetailsConfirmButtonRequired = false)
        {
            try
            {
                UserEducationDTO objUserEducationDTO = new UserEducationDTO();
                //ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
                UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                LoginUserDetails objLoginUserDetails = null;
                objEmployeeModel.userEducationModel.UserInfoID = nUserInfoID;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nUserInfoID), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                if (nUserInfoID != 0)
                {
                    //add all model value to DTO object for insertation into DB
                    objUserEducationDTO.UEW_id = objEmployeeModel.userEducationModel.UEW_id;
                    objUserEducationDTO.UserInfoId = objEmployeeModel.userEducationModel.UserInfoID;
                    objUserEducationDTO.PMonth = objEmployeeModel.userEducationModel.From_Month;
                    objUserEducationDTO.PYear = Convert.ToInt16(objEmployeeModel.userEducationModel.From_Year);
                    objUserEducationDTO.Flag = 0;

                    objUserEducationDTO.EmployerName = objEmployeeModel.userEducationModel.Employer;
                    objUserEducationDTO.Designation = objEmployeeModel.userEducationModel.Designation;
                    objUserEducationDTO.ToMonth = objEmployeeModel.userEducationModel.To_Month;
                    objUserEducationDTO.ToYear = Convert.ToInt16(objEmployeeModel.userEducationModel.To_Year);

                    objUserEducationDTO.Operation = (objEmployeeModel.userEducationModel.UEW_id == 0) ? "INSERT" : "UPDATE";


                    //save records into DB
                    using (var objUserInfoSL = new UserInfoSL())
                    {
                        objUserEducationDTO = objUserInfoSL.InsertUpdateUserEducationDetails(objLoginUserDetails.CompanyDBConnectionString, objUserEducationDTO);
                    }

                }

            }
            catch (Exception exp)
            {
                ViewBag.FromWorkPost = true;
                ViewBag.acid = acid;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                ModelState.AddModelError("Error", Common.Common.getResource(exp.InnerException.Data[0].ToString()));
                return View("EducationDetails", objEmployeeModel);

            }


            return RedirectToAction("EducationDetails", new { acid = acid, nUserInfoID = nUserInfoID, nUserDematSaved = true, nConfirmPersonalDetailsRequired = nConfirmPersonalDetailsRequired, nShowPersonalDetailsConfirmButtonRequired = nShowPersonalDetailsConfirmButtonRequired }).Success(HttpUtility.UrlEncode(Common.Common.getResource("usr_msg_54032")));
        }
        /// <summary>
        /// Delete Education/Work details from DB
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="UEW_id"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteEducation(int acid, int UEW_id)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            UserEducationDTO objUserEducationDTO = new UserEducationDTO();
            objUserEducationDTO.Operation = "DELETE";
            objUserEducationDTO.UEW_id = UEW_id;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserEducationDTO = objUserInfoSL.InsertUpdateUserEducationDetails(objLoginUserDetails.CompanyDBConnectionString, objUserEducationDTO);
                }
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_54033")); // Details Deleted Sucessfully
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
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }

        #endregion
        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        #region Add
        [AuthorizationPrivilegeFilter]
        public ActionResult Add(int acid)
        {
            return View();
        }
        #endregion Add

        #region PopulateCombo
        private void PopulateCombo()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstCompanyList = new List<PopulateComboDTO>();
            lstCompanyList.Add(objPopulateComboDTO);
            lstCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                null, null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
            ViewBag.CompanyDropdown = lstCompanyList;

            List<PopulateComboDTO> lstStateList = new List<PopulateComboDTO>();
            lstStateList.Add(objPopulateComboDTO);
            lstStateList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.StateDropDown = lstStateList;

            List<PopulateComboDTO> lstCountryList = new List<PopulateComboDTO>();
            lstCountryList.Add(objPopulateComboDTO);
            lstCountryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CountryDropDown = lstCountryList;

            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
            lstCategoryList.Add(objPopulateComboDTO);
            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.CategoryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown = lstCategoryList;

            List<PopulateComboDTO> lstGradeList = new List<PopulateComboDTO>();
            lstGradeList.Add(objPopulateComboDTO);
            lstGradeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.GradeMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.GradeDropDown = lstGradeList;

            List<PopulateComboDTO> lstDesignationList = new List<PopulateComboDTO>();
            lstDesignationList.Add(objPopulateComboDTO);
            lstDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.DesignationDropDown = lstDesignationList;

            List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
            lstDepartmentList.Add(objPopulateComboDTO);
            lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DepartmentMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.DepartmentDropDown = lstDepartmentList;

            List<PopulateComboDTO> lstRelationList = new List<PopulateComboDTO>();
            lstRelationList.Add(objPopulateComboDTO);
            lstRelationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.RelationWithEmployee).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.RelationDropDown = lstRelationList;

            List<PopulateComboDTO> lstUserTypeList = new List<PopulateComboDTO>();
            lstUserTypeList.Add(objPopulateComboDTO);
            lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserType,
                null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.UserTypeDropDown = lstUserTypeList;

            List<PopulateComboDTO> lstUserStatusList = new List<PopulateComboDTO>();
            //lstUserStatusList.Add(objPopulateComboDTO);
            lstUserStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.UserStatusDropDown = lstUserStatusList;

            List<PopulateComboDTO> lstInsiderStatusList = new List<PopulateComboDTO>();
            lstInsiderStatusList.Add(objPopulateComboDTO);
            lstInsiderStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.InsiderStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.InsiderStatusDropDown = lstInsiderStatusList;
            List<PopulateComboDTO> lstResidentTypeList = new List<PopulateComboDTO>();
            lstResidentTypeList.Add(objPopulateComboDTO);
            lstResidentTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.ResidentType).ToString(), null, null, null, null, "usr_msg_").OrderByDescending(x => x.Value).ToList<PopulateComboDTO>());
            ViewBag.ResidentTypeDropDown = lstResidentTypeList;

            List<PopulateComboDTO> lstIdentificationTypeList = new List<PopulateComboDTO>();
            lstIdentificationTypeList.Add(objPopulateComboDTO);
            lstIdentificationTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.IdentificationType).ToString(), null, null, null, null, "usr_msg_").OrderByDescending(x => x.Value).ToList<PopulateComboDTO>());
            ViewBag.IdentificationTypeIdTypeDropDown = lstIdentificationTypeList;

            List<PopulateComboDTO> lstIdentificationTypeRelativeList = new List<PopulateComboDTO>();
            lstIdentificationTypeRelativeList.Add(objPopulateComboDTO);
            lstIdentificationTypeRelativeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.IdentificationTypeRelative).ToString(), null, null, null, null, "usr_msg_").OrderByDescending(x => x.Value).ToList<PopulateComboDTO>());
            ViewBag.IdentificationTypeIdTypeRelativeDropDown = lstIdentificationTypeRelativeList;

            lstCategoryList = null;
            lstCompanyList = null;
            lstCountryList = null;
            lstDepartmentList = null;
            lstDesignationList = null;
            lstGradeList = null;
            lstInsiderStatusList = null;
            lstRelationList = null;
            lstStateList = null;
            lstUserStatusList = null;
            lstUserTypeList = null;
            lstUserStatusList = null;
            lstInsiderStatusList = null;
            objLoginUserDetails = null;
            lstResidentTypeList = null;
            lstIdentificationTypeList = null;
            lstIdentificationTypeRelativeList = null;
            //List<PopulateComboDTO> lstUserStatusList = new List<PopulateComboDTO>();
            //lstUserTypeList.Add(objPopulateComboDTO);
            //lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            //    Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            //ViewBag.UserStatusDropDown = lstUserStatusList;
        }
        #endregion PopulateCombo

        #region PopulateSubCategoryCombo
        private void PopulateSubCategoryCombo(int? CategoryID = null)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "0";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstSubCategoryList = new List<PopulateComboDTO>();
            lstSubCategoryList.Add(objPopulateComboDTO);
            if (CategoryID != null && CategoryID != 0)
                lstSubCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    ConstEnum.CodeGroup.SubCategoryMaster, CategoryID.ToString(), null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
            ViewBag.SubCategoryDropDown = lstSubCategoryList;
            lstSubCategoryList = null;
            objLoginUserDetails = null;

        }
        #endregion PopulateSubCategoryCombo

        #region PopulateSubDesignationCombo
        private void PopulateSubDesignationCombo(int? DesignationID = null)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "0";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstSubDesignationList = new List<PopulateComboDTO>();
            lstSubDesignationList.Add(objPopulateComboDTO);
            if (DesignationID != null && DesignationID != 0)
                lstSubDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    ConstEnum.CodeGroup.SubDesignationMaster, DesignationID.ToString(), null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
            ViewBag.SubDesignationDropDown = lstSubDesignationList;
            lstSubDesignationList = null;
            objLoginUserDetails = null;

        }
        #endregion PopulateSubDesignationCombo

        #region Download
        [AuthorizationPrivilegeFilter]
        public FileStreamResult Download(int nDocumentDetailsID, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();

            using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
            {
                objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentDetailsID);
            }
            objLoginUserDetails = null;
            string directory = ConfigurationManager.AppSettings["Document"] + objDocumentDetailsDTO.MapToTypeCodeId + "\\" + objDocumentDetailsDTO.GUID;
            return File(new FileStream(directory, FileMode.Open), objDocumentDetailsDTO.FileType, objDocumentDetailsDTO.DocumentName);
        }
        #endregion PopulateCombo

        #region EmployeeExcel
        public void DownloadExcel(int ReportType)
        {
            string exlFilename = string.Empty;
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string workSheetName = string.Empty;
            string cellRange = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            con.Open();
            DataTable dt = new DataTable();
            if (ReportType == 1)
            {
                spName = "st_rpt_DownloadEmployeeDetailsInExcel";
                exlFilename = "Employee Details.xls";
                workSheetName = "Employee Details";
            }
            else if (ReportType == 2)
            {
                spName = "st_rpt_EmployeeDematwiseHoldings";
                exlFilename = "Employee DEMATwise.xls";
                workSheetName = "Employee DMATwise";
            }
            else if (ReportType == 3)
            {
                spName = "st_rpt_DepartmentwiseRestricedListDetails";
                exlFilename = "Departmentwise Restricted list Report.xls";
                workSheetName = "Departmentwise Restricted List";
            }
            else if (ReportType == 4)
            {
                spName = "st_rpt_DigitalDatabase";
                exlFilename = "Digital Database Report.xls";
                workSheetName = "Digital Database";
            }

            cellRange = "A1:AH1";
            cmd = new SqlCommand(spName, con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adp = new SqlDataAdapter(cmd);
            adp.Fill(dt);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.Charset = "";
            Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
            StringWriter sWriter = new StringWriter();
            System.Web.UI.HtmlTextWriter hWriter = new System.Web.UI.HtmlTextWriter(sWriter);
            System.Web.UI.WebControls.GridView dtGrid = new System.Web.UI.WebControls.GridView();
            dtGrid.DataSource = dt;
            if (dt.Rows.Count > 0)
            {
                dtGrid.DataBind();
                dtGrid.RenderControl(hWriter);
                Response.Write(@"<style> TD { mso-number-format:\@; } </style>");
            }
            else
            {
                Response.Write("Record is not exist");
            }

            Response.Output.Write(sWriter.ToString());
            Response.Flush();
            Response.End();
        }
        #endregion EmployeeExcel

        #region GetParentDetails
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult GetParentDetails(int acid, int nParentID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoModel objUserInfoModel = new UserInfoModel();
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (nParentID != 0)
                {

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nParentID);
                    }
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                }
                return Json(new
                {
                    status = true,
                    data = objUserInfoModel

                }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objUserInfoDTO = null;
                objUserInfoModel = null;
                objLoginUserDetails = null;
            }

        }
        #endregion GetParentDetails

        #region GETDMATList
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>        
        [AuthorizationPrivilegeFilter]
        public PartialViewResult GETDMATList(int acid, int nDMATDetailsID = 0)
        {
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            try
            {
                objDMATDetailsModel.DMATDetailsID = nDMATDetailsID;
                return PartialView("~/Views/Common/DMATHolderList.cshtml", objDMATDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }

        }
        #endregion GETDMATList

        #region UploadSeparation
        [AuthorizationPrivilegeFilter]
        public ActionResult UploadSeparation(int acid)
        {
            PopulateCombo();
            ViewBag.GridType = ConstEnum.GridType.UserSeparationList;
            ViewBag.Param1 = ConstEnum.Code.EmployeeType.ToString();

            return View();
        }
        #endregion UploadSeparation

        #region Edit Separation
        [HttpGet]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditSepration(int acid, int UserInfoId)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            UserInfoModel objUserInfoModel = new UserInfoModel();
            //UserInfoSL objUserInfoSL = new UserInfoSL();
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();

            ViewBag.UserInfoId = UserInfoId;
            ViewBag.GridType = ConstEnum.GridType.UserSeparationList;
            if (UserInfoId > 0)
            {
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserSeparationDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                }
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);

            }
            objUserInfoDTO = null;
            objLoginUserDetails = null;
            return PartialView("EditSeparation", objUserInfoModel);

        }
        #endregion Edit Separation

        #region SaveUserSeparation

        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult SaveUserSeparation(UserInfoModel userInfoModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            //UserInfoSL objUserInfoSL = new UserInfoSL();
            List<UserInfoDTO> lstUserInfoDTO = new List<UserInfoDTO>();
            DataTable tblUserSeparationType = new DataTable("UserSeparationType");
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        Message = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                bool bReturn = false;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();

                tblUserSeparationType.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                tblUserSeparationType.Columns.Add(new DataColumn("DateOfSeparation", typeof(DateTime)));
                tblUserSeparationType.Columns.Add(new DataColumn("ReasonForSeparation", typeof(string)));
                tblUserSeparationType.Columns.Add(new DataColumn("NoOfDaysToBeActive", typeof(int)));
                tblUserSeparationType.Columns.Add(new DataColumn("DateOfInactivation", typeof(DateTime)));

                if (userInfoModel != null)
                {
                    DataRow row = tblUserSeparationType.NewRow();
                    row["UserInfoId"] = userInfoModel.UserInfoId;
                    row["DateOfSeparation"] = userInfoModel.DateOfSeparation;
                    row["ReasonForSeparation"] = userInfoModel.ReasonForSeparation;
                    row["NoOfDaysToBeActive"] = userInfoModel.NoOfDaysToBeActive;
                    if (userInfoModel.DateOfInactivation != null)
                    {
                        row["DateOfInactivation"] = userInfoModel.DateOfInactivation;
                    }
                    tblUserSeparationType.Rows.Add(row);
                    row = null;
                    //foreach (var index in userInfoModel)
                    //{
                    //    DataRow row = tblUserSeparationType.NewRow();
                    //    row["UserInfoId"] = index.UserInfoId;
                    //    row["DateOfSeparation"] = index.DateOfSeparation;
                    //    row["ReasonForSeparation"] = index.ReasonForSeparation;
                    //    tblUserSeparationType.Rows.Add(row);
                    //}
                    if (userInfoModel.DateOfInactivation < (Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)).Date)
                    {
                        ModelState.AddModelError("DateOfInactivation", "Date of Inactivation should be greter or equals to todays date.");
                        //return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                        return Json(new
                        {
                            status = false,
                            //Message = "Date of Inactivation should be greter or equals to todays date."
                            error = ModelState.ToSerializedDictionary()

                        }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            bReturn = objUserInfoSL.SaveUserSeparation(objLoginUserDetails.CompanyDBConnectionString, tblUserSeparationType, objLoginUserDetails.LoggedInUserID);
                        }
                        return Json(new
                        {
                            status = true,
                            Message = "User separation detatils saved Successfully"

                        }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(new
                    {
                        status = false,
                        Message = "No selections found."

                    }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                tblUserSeparationType = null;
                lstUserInfoDTO = null;
                objLoginUserDetails = null;
            }
        }
        #endregion SaveUserSeparation

        #region Reactivate User

        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult ReactivateUser(UserInfoModel userInfoModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        Message = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                bool bReturn = false;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                //UserInfoSL objUserInfoSL = new UserInfoSL();
                //List<UserInfoDTO> lstUserInfoDTO = new List<UserInfoDTO>();


                if (userInfoModel != null)
                {

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        bReturn = objUserInfoSL.ReactivateUser(objLoginUserDetails.CompanyDBConnectionString, userInfoModel.UserInfoId, objLoginUserDetails.LoggedInUserID);
                    }
                    return Json(new
                    {
                        status = true,
                        Message = "User Reactivated Successfully"

                    }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new
                    {
                        status = false,
                        Message = "No record found."

                    }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return Json(new
                {
                    status = false,
                    error = ModelState.ToSerializedDictionary(),
                    Message = sErrMessage

                }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Reactivate User

        #region GetSubCategories
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public PartialViewResult GetSubCategories(int categoryID, int acid)
        {

            EmployeeModel objEmployeeModel = new EmployeeModel();
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstSubCategoryList = new List<PopulateComboDTO>();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return PartialView("~/Views/Home/Unauthorised.cshtml");
                }
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";


                lstSubCategoryList.Add(objPopulateComboDTO);
                lstSubCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    ConstEnum.CodeGroup.SubCategoryMaster, categoryID.ToString(), null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                ViewBag.SubCategoryDropDown = lstSubCategoryList;

                return PartialView("~/Views/Employee/SubCategories.cshtml", objEmployeeModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstSubCategoryList = null;
            }
        }
        #endregion GetSubCategories

        #region GetSubDesignation
        [AuthorizationPrivilegeFilter]
        public PartialViewResult GetSubDesignation(int DesignationID, int acid)
        {
            EmployeeModel objEmployeeModel = new EmployeeModel();
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstSubDesignationList = new List<PopulateComboDTO>();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return PartialView("~/Views/Home/Unauthorised.cshtml");
                }
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                lstSubDesignationList.Add(objPopulateComboDTO);
                lstSubDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    ConstEnum.CodeGroup.SubDesignationMaster, DesignationID.ToString(), null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());
                ViewBag.SubDesignationDropDown = lstSubDesignationList;

                return PartialView("~/Views/Employee/SubDesignation.cshtml", objEmployeeModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                lstSubDesignationList = null;
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
            }
        }
        #endregion GetSubDesignation

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
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
            }
        }
        #endregion FillComboValues

        #region DMAT Functionality for Relative
        #region Edit DMAT Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult EditRelativeDMATDetails(int acid, EmployeeRelativeModel employeeRelativeModel, int nDMATDetailsID = 0, int nUserInfoID = 0, int utype = 0, int nSaveNAddDematflag = 1)
        {
            Relative_DMATDetailsModel objRelative_DMATDetailsModel = null;
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new DMATAccountHolderDetailsModel();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            PopulateComboDTO objPopulateComboDPBankDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstDPNameList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAccountTypeList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstRelationTypeList = new List<PopulateComboDTO>();
            EmployeeRelativeModel employeeModel = new EmployeeRelativeModel();
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();

            bool isError = false;
            string sErrMessage = "";

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objRelative_DMATDetailsModel = new Relative_DMATDetailsModel();

                if (nDMATDetailsID == 0 && nUserInfoID == 0)
                {

                    if (!isError)
                    {
                        //if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(employeeModel.userInfoModel.ParentId), objLoginUserDetails.LoggedInUserID))
                        //{
                        //    objLoginUserDetails = null;
                        //    return RedirectToAction("Unauthorised", "Home");
                        //}
                        //if (employeeRelativeModel.userInfoModel.UserInfoId != 0)
                        //{
                        //    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        //    {
                        //        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, employeeRelativeModel.userInfoModel.UserInfoId);
                        //    }
                        //    if (!Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(employeeRelativeModel.userInfoModel.UserInfoId), objLoginUserDetails.LoggedInUserID))
                        //    {
                        //        objLoginUserDetails = null;
                        //        return RedirectToAction("Unauthorised", "Home");
                        //    }
                        //}

                        Common.Common.CopyObjectPropertyByNameAndActivity(employeeRelativeModel.userInfoModel, objUserInfoDTO, ConstEnum.IsRelative.Relative);

                        objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.RelativeType;
                        objUserInfoDTO.IsInsider = ConstEnum.UserType.Insider;
                        objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                        objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                        objUserInfoDTO.ParentId = employeeRelativeModel.userInfoModel.ParentId;
                        objUserInfoDTO.RelativeStatus = employeeRelativeModel.userInfoModel.RelativeStatus;
                        objUserInfoDTO.DoYouHaveDMATEAccountFlag = employeeRelativeModel.userInfoModel.DoYouHaveDMATEAccount;
                        objUserInfoDTO.SaveNAddDematflag = nSaveNAddDematflag;



                        if (objUserInfoDTO.CompanyId == 0)
                            objUserInfoDTO.CompanyId = null;

                        if (objUserInfoDTO.StateId == 0)
                            objUserInfoDTO.StateId = null;

                        if (objUserInfoDTO.CountryId == 0)
                            objUserInfoDTO.CountryId = null;

                        if (objUserInfoDTO.Category == 0)
                            objUserInfoDTO.Category = null;

                        if (objUserInfoDTO.GradeId == 0)
                            objUserInfoDTO.GradeId = null;

                        if (objUserInfoDTO.DesignationId == 0)
                            objUserInfoDTO.DesignationId = null;

                        if (objUserInfoDTO.DepartmentId == 0)
                            objUserInfoDTO.DepartmentId = null;

                        if (objUserInfoDTO.RelationTypeCodeId == 0)
                            objUserInfoDTO.RelationTypeCodeId = null;


                        //ViewBag.Confirm_PersonalDetails_Required = nShowPersonalDetailsConfirmButtonRequired;
                        //save relative details
                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);

                        }
                    }
                }

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                lstDPNameList.Add(objPopulateComboDTO);
                lstDPNameList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DPName).ToString(), null, null, null, null, sLookUpPrefix).ToList<PopulateComboDTO>());

                if (nDMATDetailsID != 0)
                {
                    objPopulateComboDPBankDTO.Key = "1";
                    objPopulateComboDPBankDTO.Value = "Other";
                    lstDPNameList.Add(objPopulateComboDPBankDTO);
                    ViewBag.DPBankDropdown = lstDPNameList;
                }
                else
                {
                    objPopulateComboDPBankDTO.Key = "1";
                    objPopulateComboDPBankDTO.Value = "Other";
                    lstDPNameList.Add(objPopulateComboDPBankDTO);
                    ViewBag.DPBankDropdown = lstDPNameList;

                }
                //lstAccountTypeList.Add(objPopulateComboDTO);
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

                List<PopulateComboDTO> lstUserStatusList = new List<PopulateComboDTO>();
                //lstUserStatusList.Add(objPopulateComboDTO);
                lstUserStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.UserStatusDropDown = lstUserStatusList;

                if (nDMATDetailsID != 0)
                {
                    using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                    {
                        objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID);
                    }
                    ViewBag.DPBankCodeId = objDMATDetailsDTO.DPBankCodeId;

                    Common.Common.CopyObjectPropertyByName(objDMATDetailsDTO, objRelative_DMATDetailsModel); //copy property for corporate dmat details model

                    bool flag = false;
                    foreach (PopulateComboDTO kvp in lstDPNameList)
                    {
                        if (objDMATDetailsDTO.DPBank == "" || kvp.Value == objDMATDetailsDTO.DPBank)
                        {
                            objRelative_DMATDetailsModel.DPBank = objDMATDetailsDTO.DPBankCodeId.ToString();
                            objRelative_DMATDetailsModel.DPBankName = null;

                            flag = true;
                            break;
                        }
                    }
                    if (!flag)
                    {
                        objRelative_DMATDetailsModel.DPBank = "Other";
                        objRelative_DMATDetailsModel.DPBankName = objDMATDetailsDTO.DPBank;
                    }
                }
                else
                {
                    objRelative_DMATDetailsModel.UserInfoID = nUserInfoID;
                }
                TempData["Employee"] = employeeRelativeModel;
                //set user type into viewbag 
                employeeModel.dmatDetailsModel = objRelative_DMATDetailsModel;
                ViewBag.user_type = utype;
                //return PartialView("~/Views/Employee/Relative_DMATDetailsModal.cshtml", objRelative_DMATDetailsModel);
            }
            catch (Exception exp)
            {
                sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                ModelState.AddModelError("Error", sErrMessage);


                return Json(new
                {
                    status = false,
                    Message = sErrMessage,
                }, JsonRequestBehavior.AllowGet);

            }

            //finally
            //{
            //    objLoginUserDetails = null;
            objDMATDetailsDTO = null;
            objDMATAccountHolderDetailsModel = null;
            objPopulateComboDTO = null;
            objPopulateComboDPBankDTO = null;
            lstDPNameList = null;
            lstAccountTypeList = null;
            lstRelationTypeList = null;

            //}

            return PartialView("~/Views/Employee/Relative_DMATDetailsModal.cshtml", objRelative_DMATDetailsModel);

        }
        #endregion Edit DMAT Details

        #region Save DMAT Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult SaveRelativeDMATDetails(Relative_DMATDetailsModel objDMATDetailsModel, int acid, string callfrom = "")
        {
            bool getList = false;
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            bool bRefreshDematList = false;
            bool UpdateDMAT = false;
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            ContactDetails ContactDetailsRelativedemat = new ContactDetails();
            bool isError = false;
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
                else if (objDMATDetailsModel.DPBank == "0")
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

                //Novit
                EmployeeRelativeModel employeeRelativeModel = TempData["Employee"] as EmployeeRelativeModel;
                if (objDMATDetailsModel.DMATDetailsID != null || objDMATDetailsModel.UserInfoID != 0)
                {
                    //objDMATDetailsDTO.UserInfoID = objUserInfoDTO.UserInfoId;
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
                                UpdateDMAT = true,
                                RefreshDematList = bRefreshDematList
                            }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                else
                {
                    if (!isError)
                    {
                        if (employeeRelativeModel.userInfoModel.UserInfoId != 0)
                        {
                            using (UserInfoSL objUserInfoSL = new UserInfoSL())
                            {
                                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, employeeRelativeModel.userInfoModel.UserInfoId);
                            }
                        }

                        Common.Common.CopyObjectPropertyByNameAndActivity(employeeRelativeModel.userInfoModel, objUserInfoDTO, ConstEnum.IsRelative.Relative);

                        objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.RelativeType;
                        objUserInfoDTO.IsInsider = ConstEnum.UserType.Insider;
                        objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                        objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                        objUserInfoDTO.ParentId = employeeRelativeModel.userInfoModel.ParentId;
                        objUserInfoDTO.RelativeStatus = employeeRelativeModel.userInfoModel.RelativeStatus;
                        objUserInfoDTO.DoYouHaveDMATEAccountFlag = employeeRelativeModel.userInfoModel.DoYouHaveDMATEAccount;
                        objUserInfoDTO.IdentificationTypeId = employeeRelativeModel.userInfoModel.IdentificationTypeId;
                        objUserInfoDTO.UIDAI_IdentificationNo = employeeRelativeModel.userInfoModel.UIDAI_IdentificationNo;

                        if (objUserInfoDTO.CompanyId == 0)
                            objUserInfoDTO.CompanyId = null;

                        if (objUserInfoDTO.StateId == 0)
                            objUserInfoDTO.StateId = null;

                        if (objUserInfoDTO.CountryId == 0)
                            objUserInfoDTO.CountryId = null;

                        if (objUserInfoDTO.Category == 0)
                            objUserInfoDTO.Category = null;

                        if (objUserInfoDTO.GradeId == 0)
                            objUserInfoDTO.GradeId = null;

                        if (objUserInfoDTO.DesignationId == 0)
                            objUserInfoDTO.DesignationId = null;

                        if (objUserInfoDTO.DepartmentId == 0)
                            objUserInfoDTO.DepartmentId = null;

                        if (objUserInfoDTO.RelationTypeCodeId == 0)
                            objUserInfoDTO.RelationTypeCodeId = null;

                        //save relative details
                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                            DataTable dt = new DataTable();

                            dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
                            dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
                            dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));

                            int rowCount = 0;
                            DataRow dr = dt.NewRow();
                            dt.Rows.Add(dr);
                            dt.Rows[rowCount]["MobileNumber"] = employeeRelativeModel.userInfoModel.MobileNumber;
                            dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(employeeRelativeModel.userInfoModel.ParentId);
                            dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(objUserInfoDTO.UserInfoId);
                            ContactDetailsRelativedemat = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
                        }
                    }

                    objDMATDetailsDTO.UserInfoID = objUserInfoDTO.UserInfoId;
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
                                Message = Common.Common.getResource("usr_msg_50754"), //"Relative Details And DMAT Details Save Successfully",
                                type = getList,
                                DMATDetailsID = objDMATDetailsDTO.DMATDetailsID,
                                url = Url.Action("CreateRelative", "Employee", new { acid = acid, nParentID = employeeRelativeModel.userInfoModel.ParentId }),
                                UpdateDMAT = false,
                                RefreshDematList = bRefreshDematList
                            }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                //end
            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objDMATDetailsDTO = null;
                objUserInfoDTO = null;
                objLoginUserDetails = null;
                TempData["Employee"] = null;
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
        [TokenVerification]
        public JsonResult DeleteRelativeDMATDetails(int acid, int nDMATDetailsID)
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
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11381"));
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
        [AuthorizationPrivilegeFilter]
        public PartialViewResult GETRelativeDMATList(int acid, int nDMATDetailsID = 0)
        {
            Relative_DMATDetailsModel objDMATDetailsModel = new Relative_DMATDetailsModel();
            try
            {
                objDMATDetailsModel.DMATDetailsID = nDMATDetailsID;
                return PartialView("~/Views/Employee/Relative_DMATHolderList.cshtml", objDMATDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }

        }
        #endregion GET Joint DMAT List

        #region Save Joint DMAT Holder Details
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult SaveRelativeDMATHolderDetails(Relative_DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel, int acid)
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
                    Message = Common.Common.getResource("usr_msg_11380"), //"DMAT Joint Account Holder Details Save Successfully"

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
        [AuthorizationPrivilegeFilter]
        public PartialViewResult EditRelativeDMATHolderDetails(EmployeeRelativeModel employeeModel, int acid, int nDMATAccountHolderID = 0, int nDMATDetailsID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();

            Relative_DMATAccountHolderDetailsModel objDMATAccountHolderDetailsModel = new Relative_DMATAccountHolderDetailsModel();

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

                return PartialView("~/Views/Employee/Relative_DMATHolderDetails.cshtml", objDMATAccountHolderDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATAccountHolderDTO = null;
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
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteRelativeDMATHolderDetails(int nDMATAccountHolderID, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            //DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL();
            var ErrorDictionary = new Dictionary<string, string>();

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsSL.DeleteDMATHolder(objLoginUserDetails.CompanyDBConnectionString, nDMATAccountHolderID, objLoginUserDetails.LoggedInUserID);
                }

                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11382")); //"DMAT Joint Account Holder Details Deleted Successfully"

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
                ErrorDictionary = null;
                objDMATAccountHolderDTO = null;
                objLoginUserDetails = null;
            }

        }
        #endregion Delete Joint DMAT Holder Details
        #endregion DMAT Functionality for Relative

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
                bool isConfirm = false;
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                //set values to save into event log table
                objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.Event_ConfirmPersonalDetails;
                objUserPolicyDocumentEventLogDTO.UserInfoId = Convert.ToInt32(Session["UserInfoId"]);
                objUserPolicyDocumentEventLogDTO.MapToId = Convert.ToInt32(Session["UserInfoId"]);
                objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.UserDocument;
                UserInfoID = Convert.ToInt32(Session["UserInfoId"]);
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

                    // return RedirectToAction("Create", "Employee", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT, nUserInfoID = objLoginUserDetails.LoggedInUserID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
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
            return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE, UserInfoId = UserInfoID, ReqModuleId = RequiredModuleID }).Success(HttpUtility.UrlEncode(strConfirmMessage));
        }
        #endregion Confirm Personal Details
        #region Insert Customer Details
        [HttpPost]
        public JsonResult InsertCustomers(List<MobileDetails> ContactDetails, int UserInfoId = 0, int UserRelativeID = 0)
        {
            TempData.Remove("ContactDetails");
            EmployeeModel objEmployeeModel = new EmployeeModel();
            TradingTransactionModel objTransactionModel = new TradingTransactionModel();
            UserInfoSL objUserInfoSL = new UserInfoSL();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ContactDetails objMobileDetails = new ContactDetails();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
            dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
            dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
            int rowCount = 0;


            foreach (var UsrContact in ContactDetails)
            {
                if (!string.IsNullOrEmpty(UsrContact.UserInfoID.ToString()))
                {
                    DataRow dr = dt.NewRow();
                    dt.Rows.Add(dr);
                    dt.Rows[rowCount]["MobileNumber"] = UsrContact.MobileNumber;
                    dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(UserInfoId);
                    dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(UserRelativeID);
                    rowCount = rowCount + 1;
                }
            }

            if (UserInfoId != 0)
            {
                objMobileDetails = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
            }
            else
            {
                TempData["ContactDetails"] = dt;
                //TempData.Keep();
            }

            var FirstMoContact = ContactDetails.FirstOrDefault();

            return Json(new
            {
                data = FirstMoContact
                //Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);


        }

        private DataTable bindDataTable(List<ContactDetails> ContactDetails, int UserInfoId = 0, int UserRelativeID = 0)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
            dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
            dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
            int rowCount = 0;


            foreach (var UsrContact in ContactDetails)
            {
                if (!string.IsNullOrEmpty(UsrContact.UserInfoID.ToString()))
                {
                    if (UsrContact.MobileNumber != null)
                    {
                        DataRow dr = dt.NewRow();
                        dt.Rows.Add(dr);
                        dt.Rows[rowCount]["MobileNumber"] = (UsrContact.MobileNumber == null) ? "+91" : UsrContact.MobileNumber;
                        dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(UserInfoId);
                        dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(UserRelativeID);
                        rowCount = rowCount + 1;
                    }


                }
            }

            return dt;
        }
        private List<ContactDetails> ConvertFromDT_ToList(DataTable dt)
        {
            List<ContactDetails> ContactDetails = new List<ContactDetails>();
            ContactDetails objContactDetails;
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        objContactDetails = new ContactDetails();
                        if (!string.IsNullOrEmpty(dt.Rows[i]["MobileNumber"].ToString()))
                        {
                            objContactDetails.MobileNumber = dt.Rows[i]["MobileNumber"].ToString();

                        }
                        ContactDetails.Add(objContactDetails);
                    }
                }
            }
            return ContactDetails;
        }
        #endregion Insert Customer Details

        #region Insert Relative Details
        [HttpPost]
        public JsonResult RelativeCustomers(List<RelativeMobileDetail> MobileDetails, int UserInfoId = 0, int UserRelativeID = 0)
        {
            TempData.Remove("RelativeMobileDetail");
            EmployeeRelativeModel objEmployeeModel = new EmployeeRelativeModel();
            ContactDetails objDetailsRelative = new ContactDetails();
            UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
            dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
            dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
            int rowCount = 0;
            foreach (var UsrContact in MobileDetails)
            {
                if (!string.IsNullOrEmpty(UsrContact.UserInfoID.ToString()))
                {
                    DataRow dr = dt.NewRow();
                    dt.Rows.Add(dr);
                    dt.Rows[rowCount]["MobileNumber"] = UsrContact.MobileNumber;
                    dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(UserInfoId);
                    dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(UserRelativeID);
                    rowCount = rowCount + 1;
                }
            }

            if (UserInfoId != 0)
            {
                objDetailsRelative = objUserInfoSL.InsertUpdatecontactDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
            }
            else
            {
                TempData["RelativeMobileDetail"] = dt;

            }
            var FirstMoRelative = MobileDetails.FirstOrDefault();
            return Json(new
            {
                data = FirstMoRelative
                //Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        private DataTable bindDataTableRelative(List<ContactDetails> ContactDetails, int UserInfoId = 0, int UserRelativeID = 0)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("MobileNumber", typeof(string)));
            dt.Columns.Add(new DataColumn("UserInfoID", typeof(int)));
            dt.Columns.Add(new DataColumn("UserRelativeID", typeof(int)));
            int rowCount = 0;


            foreach (var UsrContact in ContactDetails)
            {
                if (!string.IsNullOrEmpty(UsrContact.UserInfoID.ToString()))
                {
                    if (UsrContact.MobileNumber != null)
                    {
                        DataRow dr = dt.NewRow();
                        dt.Rows.Add(dr);
                        dt.Rows[rowCount]["MobileNumber"] = UsrContact.MobileNumber;
                        dt.Rows[rowCount]["UserInfoID"] = Convert.ToInt32(UsrContact.UserInfoID);
                        dt.Rows[rowCount]["UserRelativeID"] = Convert.ToInt32(UsrContact.UserRelativeID);
                        rowCount = rowCount + 1;
                    }

                }
            }

            return dt;
        }
        private List<ContactDetails> ConvertFromDT_ToListRelative(DataTable dt)
        {
            List<ContactDetails> ContactDetails = new List<ContactDetails>();
            ContactDetails objContactDetails;
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        objContactDetails = new ContactDetails();
                        if (!string.IsNullOrEmpty(dt.Rows[i]["MobileNumber"].ToString()))
                        {
                            objContactDetails.MobileNumber = dt.Rows[i]["MobileNumber"].ToString();

                        }
                        ContactDetails.Add(objContactDetails);
                    }
                }
            }
            return ContactDetails;
        }
        #endregion Insert Customer Details

        [AuthorizationPrivilegeFilter]
        public ActionResult UnblockUser(int acid, UserInfoModel objUserInfoModel)
        {
            try
            {
                LoginUserDetails objLoginUserDetails = null;
                UserInfoDTO objUserInfoDTO = new UserInfoDTO();

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                //  objUserInfoDTO.UserInfoId= Convert.ToInt32(Request["UserInfoID"]);
                using (var objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.BlockUnblockUser(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(Request["UserInfoID"]), objUserInfoModel.objUnblockUser.IsBlocked, objUserInfoModel.objUnblockUser.Block_Unblock_Reasion, objLoginUserDetails.LoggedInUserID);

                }
            }
            catch (Exception ex)
            {

            }

            return RedirectToAction("Index", "Employee", new { acid = ConstEnum.UserActions.INSIDER_INSIDERUSER_VIEW });
        }
        #region Dispose
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose
    }
}


