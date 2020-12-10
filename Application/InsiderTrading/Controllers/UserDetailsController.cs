using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.SL;
using InsiderTrading.Models;
using System.Text.RegularExpressions;
using System.Collections;
using System.Xml;
using System.Xml.Linq;
using System.Web.Services.Protocols;
using System.Collections.Specialized;
using System.Reflection;
using InsiderTradingDAL.UserDetails;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using InsiderTradingEncryption;
using System.Text;
using System.IO;
using System.Security.Cryptography;
using System.Net.Mime;


namespace InsiderTrading
{
  //  [HandleError()]
    [RolePrivilegeFilter]
    public class UserDetailsController : Controller
    {
        //
        // GET: /UserDetails/
        #region Index
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, true);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                ViewBag.RoleList = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                FillGrid(ConstEnum.GridType.COUserList, ConstEnum.Code.COUserType.ToString(), null, null);
                return View("Index");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {
                objLoginUserDetails = null;
            }

        }
        #endregion Index

        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
       
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid)
        {
            COUserInfoModel objUserInfoModel = new COUserInfoModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, false);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), "0", null, null, null, false);
                ViewBag.UserAction = acid;
                ViewBag.NewCORegistration = true;
                return View("Create", objUserInfoModel); 
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, true);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                ViewBag.RoleList = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                FillGrid(ConstEnum.GridType.COUserList, ConstEnum.Code.COUserType.ToString(), null, null);
                return View("index");
            }
            finally
            {
                objUserInfoModel = null;
                objLoginUserDetails = null;
            }


        }
        #endregion Create

        #region Edit
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int UserInfoId, string CalledFrom, int acid)
        {   
            string o_sPassword = string.Empty;
            bool show_not_login_user_details = true; //flag used to show/hide details on page for login user and other user since for both page is same
            UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = null;
            try
            {
                //Check for not allowing one CO to View personal details of Other CO user, when called from the "View My Details" link
                if (CalledFrom == "View" && acid == 192 && objLoginUserDetails.LoggedInUserID != UserInfoId)
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, false);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                //check if page is show for view mode and if page is shown for logged in user as view details page then do not show role list
                if (CalledFrom != "Edit")
                {
                    //check if details being shown for login user then set flag to do not show role list
                    //also check activity id to know if page is shown to user as users view details page
                    if (objUserInfoDTO != null && objUserInfoDTO.UserInfoId == objLoginUserDetails.LoggedInUserID && 
                            acid == ConstEnum.UserActions.VIEW_DETAILS_PERMISSION_FOR_CO_USER)
                    {
                        show_not_login_user_details = false; //set flag to do not show role list
                    }
                }

                ViewBag.show_not_login_user_details = show_not_login_user_details;

                if (objUserInfoDTO != null)
                {
                    COUserInfoModel objUserInfoModel = new COUserInfoModel();
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                    objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                    objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), UserInfoId.ToString(), null, null, null, false);
                    ViewBag.UserAction = acid;
                    if (CalledFrom == "Edit")
                    {
                        return View("Create", objUserInfoModel);
                    }
                    else
                    {
                        return View("View", objUserInfoModel);
                    }
                }
                if (CalledFrom == "Edit")
                {
                    return View("Create");
                }
                else
                {
                    return View("View");
                }

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, true);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                return View("index");
            }
            finally
            {
                objUserInfoSL = null;
                objLoginUserDetails = null;
                objUserInfoDTO = null;
            }
        }
        #endregion Edit

        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userInfoModel"></param>
        /// <returns></returns>
        [HttpPost]
       
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        [Button(ButtonName = "Create"/*,acid=2*/)]
        [ActionName("Create")]      
        public ActionResult Create(int acid,InsiderTrading.Models.COUserInfoModel objUserInfoModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstSelectedRole = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            try
            {
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoModel, objUserInfoDTO);
                    objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.COUserType;
                    objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    //Encrypt Password
                    string o_sPassword = string.Empty;
                    if (objUserInfoModel.SubmittedRole != null && objUserInfoModel.SubmittedRole.Count() > 0)
                    {
                        var sSubmittedRoleList = String.Join(",", objUserInfoModel.SubmittedRole);
                        objUserInfoDTO.SubmittedRoleIds = sSubmittedRoleList;
                    }
                    objUserInfoDTO.Password = "";
                    objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                    ArrayList lst = new ArrayList();
                    //before showing success message check if first name and last name is NOT NULL
                    string fname = objUserInfoDTO.FirstName == null ? "" : objUserInfoDTO.FirstName.Replace("'", "\'").Replace("\"", "\"");
                    string lname = objUserInfoDTO.LastName == null ? "" : objUserInfoDTO.LastName.Replace("'", "\'").Replace("\"", "\"");
                    lst.Add(fname + " " + lname);
                    string AlertMessage = Common.Common.getResource("usr_msg_11266", lst);
                    TempData.Remove("SearchArray");
                    return RedirectToAction("Index", "UserDetails",
                        new { acid = Common.ConstEnum.UserActions.CRUSER_COUSER_VIEW }).
                        Success(HttpUtility.UrlEncode(AlertMessage));
            }
            catch (Exception exp)
            {
                //check if user has selected role and assign those role 
                if (objUserInfoModel.SubmittedRole != null)
                {
                    lstSelectedRole = new List<PopulateComboDTO>();
                    for (int cnt = 0; cnt < objUserInfoModel.SubmittedRole.Count; cnt++)
                    {
                        PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                        objPopulateComboDTO.Key = objUserInfoModel.SubmittedRole[cnt];
                        lstSelectedRole.Add(objPopulateComboDTO);
                    }
                }
                ModelState.AddModelError("Warning", Common.Common.GetErrorMessage(exp));
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, false);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                //check if user has selected role and assign those role 
                if (lstSelectedRole != null && lstSelectedRole.Count > 0)
                {
                    objUserInfoModel.AssignedRole = lstSelectedRole;
                    objUserInfoModel.SubmittedRole = null;
                }
                else
                {
                    objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), objUserInfoModel.UserInfoId.ToString(), null, null, null, false);
                }
                ViewBag.UserAction = InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_EDIT;
                return View("Create", objUserInfoModel);
            }
            finally
            {
                objLoginUserDetails = null;
                lstSelectedRole = null;
                objUserInfoSL = null;
                objUserInfoDTO = null;
            }
          
        }
        #endregion Create

        #region delete
        /// <summary>
        /// Delete User.
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "Delete")]
        [ActionName("Create")]
        public ActionResult Delete(int acid, int UserInfoId, InsiderTrading.Models.COUserInfoModel objUserInfoModel)
        {
            UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                    objUserInfoSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId,objLoginUserDetails.LoggedInUserID);
                    return RedirectToAction("Index", "UserDetails", new { acid = Common.ConstEnum.UserActions.CRUSER_COUSER_VIEW });
             }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.StatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, false);
                ViewBag.CompanyDropDown = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                objUserInfoModel.DefaultRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), null, null, null, null, true);
                objUserInfoModel.AssignedRole = FillComboValues(ConstEnum.ComboType.RoleList, ConstEnum.Code.COUserType.ToString(), objUserInfoModel.UserInfoId.ToString(), null, null, null, false);
                ViewBag.UserAction = InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_EDIT;
                return View("Create", objUserInfoModel);
            }
            finally
            {
                objUserInfoSL = null;
                objLoginUserDetails = null;
            }
        }
        #endregion delete

        #region delete
        /// <summary>
        /// Delete User.
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteFromGrid(int UserInfoId,int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            UserInfoSL objUserInfoSL = new UserInfoSL();
            try
            {
                objUserInfoSL.DeleteUserDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.LoggedInUserID);
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_11267"));//"User deleted Successfully.");
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
                objUserInfoSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion delete

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
        [ActionName("Create")]
        public ActionResult Cancel()
        {
            return RedirectToAction("Index", "UserDetails", new { acid = Common.ConstEnum.UserActions.CRUSER_COUSER_VIEW });
        }
        #endregion Cancel

        #region Private Method

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
                objPopulateComboDTO.Key = "0";
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
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion FillComboValues

        #region FillGrid
        /// <summary>
        /// 
        /// </summary>
        /// <param name="m_nGridType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
        }
        #endregion FillGrid

        #endregion Private Method

        #region ChangePassword   
        [AuthorizationPrivilegeFilter]
        public ActionResult ChangePassword(int acid)
        {
            PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
            objPassConfigModel = GetPasswordConfigDetails();
            TempData["PasswordConfigModel"] = objPassConfigModel;
            ViewBag.IsChangePassword = Common.Common.GetSessionValue("IsChangePassword") == null ? false : Common.Common.GetSessionValue("IsChangePassword");
            ViewBag.PasswordExpireAlert = Common.Common.getResource("pc_msg_50570");
            return View("ChangePassword");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "Create")]
        [ActionName("ChangePassword")]
        [AllowAnonymous]
        [AuthorizationPrivilegeFilter]
        public ActionResult ChangePassword(int formId,int acid, PasswordManagementModel objPwdMgmtModel)
        {
            bool bErrorOccurred = false;
            string i_ErrorMessage = "";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PasswordManagementDTO objPwdMgmtDTO = new PasswordManagementDTO();
            PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
            UserInfoSL objUserInfoSL = new UserInfoSL();
            UserPolicyDocumentEventLogDTO objChangePasswordEventLogDTO = null;
            PasswordExpiryReminderDTO objPassExpiryReminderDTO = null;
           

            InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
            try
            {
                DataSecurity objDataSecurity = new DataSecurity();
                string sOldPassword = string.Empty;
                string sNewPassword = string.Empty;
                string sConfirmNewPassword = string.Empty;
                string sPasswordHash = string.Empty;
                string sPasswordHashWithSalt = string.Empty;
                string sSaltValue = string.Empty;
                string javascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;
                string userPasswordHashSalt = Common.ConstEnum.User_Password_Encryption_Key;

                if (objPwdMgmtModel.OldPassword == null || objPwdMgmtModel.OldPassword == "" || objPwdMgmtModel.NewPassword == null || objPwdMgmtModel.NewPassword == "" ||
                    objPwdMgmtModel.ConfirmNewPassword == null || objPwdMgmtModel.ConfirmNewPassword == "")
                {
                    i_ErrorMessage = "All fields are required fields.";
                    bErrorOccurred = true;
                }
                else if (objPwdMgmtModel.NewPassword == null || objPwdMgmtModel.NewPassword == "" || objPwdMgmtModel.ConfirmNewPassword == null || objPwdMgmtModel.ConfirmNewPassword == "")
                {
                    i_ErrorMessage = "Please enter new password and confirm new password.";
                    bErrorOccurred = true;
                }
                else if (objPwdMgmtModel.NewPassword != objPwdMgmtModel.ConfirmNewPassword)
                {
                    i_ErrorMessage = "New password and Confirm password are not matching.";
                    bErrorOccurred = true;
                }
                else if (objPwdMgmtModel.OldPassword == objPwdMgmtModel.NewPassword)
                {
                    i_ErrorMessage = "New password should not be same as old password.";
                    bErrorOccurred = true;
                }

                else if (!string.IsNullOrEmpty(objPwdMgmtModel.OldPassword) && !string.IsNullOrEmpty(objPwdMgmtModel.NewPassword) &&
                   !string.IsNullOrEmpty(objPwdMgmtModel.ConfirmNewPassword))
                {
                    sOldPassword = DecryptStringAES(objPwdMgmtModel.OldPassword, javascriptEncryptionKey, javascriptEncryptionKey);
                    sNewPassword = DecryptStringAES(objPwdMgmtModel.NewPassword, javascriptEncryptionKey, javascriptEncryptionKey);
                    sConfirmNewPassword = DecryptStringAES(objPwdMgmtModel.ConfirmNewPassword, javascriptEncryptionKey, javascriptEncryptionKey);
                    sPasswordHashWithSalt = objPwdHash.CreateSaltandHash(sNewPassword);
                    sPasswordHash = sPasswordHashWithSalt.Split('~')[0].ToString();
                    sSaltValue = sPasswordHashWithSalt.Split('~')[1].ToString();  
                }                

                //Check if the new password follows Password policy
                if (!bErrorOccurred)
                {
                    Common.Common objCommon = new Common.Common();
                    bool isPasswordValid = objCommon.ValidatePassword(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserName, sNewPassword, sPasswordHash, objLoginUserDetails.LoggedInUserID, out i_ErrorMessage);
                    if (!isPasswordValid)
                    {
                        bErrorOccurred = true;
                    }
                }
                if (bErrorOccurred)
                {
                    ViewBag.LoginError = i_ErrorMessage;
                    return View("ChangePassword");
                }
           
                objPwdMgmtModel.UserInfoID = objLoginUserDetails.LoggedInUserID;

                string saltValue = string.Empty; 
                string calledFrom ="ChangPwd";

                using (UserInfoSL ObjUserInfoSL = new UserInfoSL())
                {
                    List<AuthenticationDTO> lstUserDetails = ObjUserInfoSL.GetUserLoginDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToString(objLoginUserDetails.LoggedInUserID), calledFrom);
                    foreach (var UserDetails in lstUserDetails)
                    {
                        saltValue = UserDetails.SaltValue;
                    }
                }

                string usrSaltValue = (saltValue == null || saltValue == string.Empty) ? userPasswordHashSalt : saltValue;

                if (saltValue != null && saltValue != "")
                    objPwdMgmtModel.OldPassword = objPwdHash.CreateHashToVerify(sOldPassword, usrSaltValue);
                else
                    objPwdMgmtModel.OldPassword = objPwdHash.CreateHash(sOldPassword, usrSaltValue); 
                
                
                objPwdMgmtModel.NewPassword = sPasswordHash;
                objPwdMgmtModel.ConfirmNewPassword = sPasswordHash;
                objPwdMgmtModel.SaltValue = sSaltValue;
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objPwdMgmtModel, objPwdMgmtDTO);
                objUserInfoSL.ChangePassword(objLoginUserDetails.CompanyDBConnectionString, ref objPwdMgmtDTO);
                objLoginUserDetails.PasswordChangeMessage = Common.Common.getResource("usr_msg_11271");
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                Common.Common.SetSessionValue("IsChangePassword",false);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ViewBag.LoginError = sErrMessage;
                objPassConfigModel = GetPasswordConfigDetails();
                return View("ChangePassword");
            }
            finally
            {
                objLoginUserDetails = null;
                objPwdMgmtDTO = null;
                objUserInfoSL = null;
                objPwdHash = null;
            }
            return RedirectToAction("Index", "Home", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD) });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("ChangePassword")]
        [AllowAnonymous]
        public ActionResult Cancel(PasswordManagementModel objPwdMgmtModel)
        {
            try
            {
                RedirectToAction("Index", "Home", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD) });
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
            }
            return RedirectToAction("Index", "Home", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD) });
        }

        #endregion ChangePassword

        #region DisplayUserConsent
        [AuthorizationPrivilegeFilter]
        public ActionResult UserConsent(int acid, int DocumentID)
        {
            DocumentDetailsSL objDocumentDetailsSL = null;
            EULAAcceptanceModel objEULAAcceptanceModel = new EULAAcceptanceModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            try
            {
                objDocumentDetailsSL = new DocumentDetailsSL();

                //check if document has uploaded or not -- by checking document id - in case of not uploaded document id is "0"
                if (DocumentID > 0)
                {
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, DocumentID);
                }

                //copy document details DTO into User policy document model
                objEULAAcceptanceModel.DocumentID = objDocumentDetailsDTO.DocumentId;
                objEULAAcceptanceModel.DocumentName = objDocumentDetailsDTO.DocumentName;
                objEULAAcceptanceModel.DocumentFileType = objDocumentDetailsDTO.FileType;
                objEULAAcceptanceModel.DocumentPath = objDocumentDetailsDTO.DocumentPath;
                objEULAAcceptanceModel.EULAAcceptanceFlag = false;

                ViewBag.UserAction = acid;

                return View("~/Views/UserDetails/UserConsent.cshtml", objEULAAcceptanceModel);
            }
            catch (Exception ex)
            {
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("~/Views/UserDetails/UserConsent.cshtml");
            }
            finally
            {
                objDocumentDetailsSL = null;
                objEULAAcceptanceModel = null;
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
            }
        }
        #endregion DisplayUserConsent

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

        public PasswordConfigModel GetPasswordConfigDetails()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PasswordConfigSL objPassConfigSL = new PasswordConfigSL();
            PasswordConfigDTO objPassConfigDTO = new PasswordConfigDTO();
            objPassConfigDTO = objPassConfigSL.GetPasswordConfigDetails(objLoginUserDetails.CompanyDBConnectionString);
            PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
            InsiderTrading.Common.Common.CopyObjectPropertyByName(objPassConfigDTO, objPassConfigModel);
            return objPassConfigModel;
        }

        
        /// <summary>
        /// This function will be used for decrypting the encrypted from Javascript using AES algorithem
        /// </summary>
        /// <param name="cipherText"></param>
        /// <returns></returns>
        private string DecryptStringAES(string i_sCipherText, string i_sKey, string i_sIv)
        {
            var keybytes = Encoding.UTF8.GetBytes(i_sKey);
            var iv = Encoding.UTF8.GetBytes(i_sIv);

            var encrypted = Convert.FromBase64String(i_sCipherText);
            var decriptedFromJavascript = DecryptStringFromBytes(encrypted, keybytes, iv);
            return decriptedFromJavascript;
        }
        
        
        /// <summary>
        /// This function will be used for decrypting the encrypted from Javascript using AES algorithem
        /// </summary>
        /// <param name="cipherText"></param>
        /// <param name="key"></param>
        /// <param name="iv"></param>
        /// <returns></returns>
        private string DecryptStringFromBytes(byte[] cipherText, byte[] key, byte[] iv)
        {
            // Check arguments.  
            if (cipherText == null || cipherText.Length <= 0)
            {
                throw new ArgumentNullException("cipherText");
            }
            if (key == null || key.Length <= 0)
            {
                throw new ArgumentNullException("key");
            }
            if (iv == null || iv.Length <= 0)
            {
                throw new ArgumentNullException("key");
            }

            // Declare the string used to hold  
            // the decrypted text.  
            string plaintext = null;

            // Create an RijndaelManaged object  
            // with the specified key and IV.  
            using (var rijAlg = new RijndaelManaged())
            {
                //Settings  
                rijAlg.Mode = CipherMode.CBC;
                rijAlg.Padding = PaddingMode.PKCS7;
                rijAlg.FeedbackSize = 128;

                rijAlg.Key = key;
                rijAlg.IV = iv;

                // Create a decrytor to perform the stream transform.  
                var decryptor = rijAlg.CreateDecryptor(rijAlg.Key, rijAlg.IV);

                try
                {
                    // Create the streams used for decryption.  
                    using (var msDecrypt = new MemoryStream(cipherText))
                    {
                        using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                        {

                            using (var srDecrypt = new StreamReader(csDecrypt))
                            {
                                // Read the decrypted bytes from the decrypting stream  
                                // and place them in a string.  
                                plaintext = srDecrypt.ReadToEnd();

                            }

                        }
                    }
                }
                catch
                {
                    plaintext = "keyError";
                }
            }

            return plaintext;
        }

        #region Generate EULA Acceptance Document
        [AuthorizationPrivilegeFilter]
        public void Generate(EULAAcceptanceModel objEULAAcceptanceModel, int acid, int nDocumentId = 0)
        {
            String mimeType = "application/unknown";
            DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL();
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            System.IO.FileInfo fFile = null;

            try
            {
                Dictionary<String, String> mtypes = new Dictionary<string, string>()
               {
                   {".pdf", "application/pdf"},
                   {".png", "application/png"},
                   {".jpeg", "application/jpeg"},
                   {".jpg", "application/jpeg"},
                   {".txt", "text/plain"},
                   {".xls", "application/vnd.ms-excel"},
                   {".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet "},
                   {".doc", "application/msword"},
                   {".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
                   {".html", "text/html"},
                   {".htm","text/html"},
               };
                if (nDocumentId != 0)
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentId);

                fFile = new System.IO.FileInfo(objDocumentDetailsDTO.DocumentPath);
                Response.Clear();

                // ContentDisposition Value and Parameter are used. 
                // Meaning of Value [inline]        : Displayed automatically
                // Meaning of Parameter [filename]	: Name to be used when creating file 
                ContentDisposition contentDisposition = new ContentDisposition
                {
                    FileName = objDocumentDetailsDTO.DocumentName,
                    Inline = true
                };
                Response.AppendHeader("Content-Disposition", contentDisposition.ToString());

                String filetype = fFile.Extension.ToLower();
                if (mtypes.Keys.Contains<String>(filetype))
                {
                    mimeType = mtypes[filetype];
                }

                Response.ContentType = mimeType;
                Response.WriteFile(fFile.FullName);
                Response.End();




                //NOTE - ADDED ABOVE CODE TO HANDLE DIFFERENT FILE TYPE
                ////Response.AddHeader("Content-Length", fFile.Length.ToString());
                //if (fFile.Extension.ToLower() == ".pdf")
                //{
                //    Response.ContentType = "application/pdf";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".xls" || fFile.Extension.ToLower() == ".xlsx")
                //{
                //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".png" || fFile.Extension.ToLower() == ".jpg")
                //{
                //    Response.ContentType = "image/png";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".docx" || fFile.Extension.ToLower() == ".doc")
                //{
                //    Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //    //NOTE - Following code is commented because to make functionality similar to other file types
                //    //START COMMENT ===>
                //    //Microsoft.Office.Interop.Word.Application objWordApp = new Microsoft.Office.Interop.Word.Application();
                //    //object objWordFile = objUsersPolicyDocumentModel.PolicyDocumentPath;
                //    //object objNull = System.Reflection.Missing.Value;
                //    //Microsoft.Office.Interop.Word.Document WordDoc = objWordApp.Documents.Open(
                //    //ref objWordFile, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull, ref objNull, ref objNull, ref objNull, ref objNull);

                //    //WordDoc.ActiveWindow.Selection.WholeStory();
                //    //WordDoc.ActiveWindow.Selection.Copy();
                //    //string strWordText = WordDoc.Content.Text;
                //    //WordDoc.Close(ref objNull, ref objNull, ref objNull);
                //    //objWordApp.Quit(ref objNull, ref objNull, ref objNull);
                //    //Response.Write(strWordText);
                //    //END COMMENT <===
                //}
                //else if (fFile.Extension.ToLower() == ".txt")
                //{
                //    Response.ContentType = "application/text";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();
                //}


                //byte[] bytes = System.IO.File.ReadAllBytes(objUsersPolicyDocumentModel.PolicyDocumentPath);                
                //return File(bytes, "application/pdf");             
            }
            catch (Exception exp)
            {
                @ViewBag.ErrorMsg = exp.Message;

                //throw exp;
            }
            finally
            {
                objDocumentDetailsSL = null;
                objDocumentDetailsDTO = null;
                objLoginUserDetails = null;
                fFile = null;
            }
        }

        #endregion Generate EULA Acceptance Document

        #region PartialViewDocument
        [AuthorizationPrivilegeFilter]
        public ActionResult PartialViewDocument(EULAAcceptanceModel objEULAAcceptanceModel, int acid)
        {
            return PartialView(objEULAAcceptanceModel);
        }
        #endregion PartialViewDocument

        #region DisplayUserConsent
        [AuthorizationPrivilegeFilter]
        public ActionResult ShowUserConsent(int acid, int DocumentID)
        {
            DocumentDetailsSL objDocumentDetailsSL = null;
            EULAAcceptanceModel objEULAAcceptanceModel = new EULAAcceptanceModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            try
            {
                objDocumentDetailsSL = new DocumentDetailsSL();

                //check if document has uploaded or not -- by checking document id - in case of not uploaded document id is "0"
                if (DocumentID > 0)
                {
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, DocumentID);
                }

                //copy document details DTO into User policy document model
                objEULAAcceptanceModel.DocumentID = objDocumentDetailsDTO.DocumentId;
                objEULAAcceptanceModel.DocumentName = objDocumentDetailsDTO.DocumentName;
                objEULAAcceptanceModel.DocumentFileType = objDocumentDetailsDTO.FileType;
                objEULAAcceptanceModel.DocumentPath = objDocumentDetailsDTO.DocumentPath;
                objEULAAcceptanceModel.UserInfoID = objLoginUserDetails.LoggedInUserID;
                objEULAAcceptanceModel.EULAAcceptanceFlag = false;

                ViewBag.UserAction = acid;

                return View("~/Views/UserDetails/UserConsent.cshtml", objEULAAcceptanceModel);
            }
            catch (Exception ex)
            {
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("~/Views/UserDetails/UserConsent.cshtml");
            }
            finally
            {
                objDocumentDetailsSL = null;
                objEULAAcceptanceModel = null;
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
            }
        }
        #endregion DisplayUserConsent

        #region Accept Button
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "Accept")]
        [ActionName("PartialViewDocument")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Accept(EULAAcceptanceModel objEulaAcceptanceModel, int acid)
        {
            bool bReturn = false;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                objEulaAcceptanceModel.EULAAcceptanceFlag = true;
                bReturn = objUserInfoSL.SaveUserEulaAcceptance(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, objEulaAcceptanceModel.DocumentID, objEulaAcceptanceModel.EULAAcceptanceFlag);

                if (bReturn)
                {
                    return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });
                }
                else
                {
                    return RedirectToAction("ShowUserConsent", "UserDetails", new { acid = Common.ConstEnum.UserActions.USER_EULACONSENT, nDocumentId = objEulaAcceptanceModel.DocumentID });
                }
            }
            catch
            {
                return View();
            }
            finally
            {
                objUserInfoSL = null;
                objLoginUserDetails = null;
            }
        }

        #endregion Accept Button

        #region Next Button
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Next")]
        [ActionName("PartialViewDocument")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Next()
        {
            return RedirectToAction("LogOut","Account");
        }
        #endregion Next Button
    }
}