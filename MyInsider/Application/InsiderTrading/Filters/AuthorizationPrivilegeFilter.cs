using ImageGenerator;
using InsiderTrading.Common;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;


namespace InsiderTrading.Filters
{
    public class AuthorizationPrivilegeFilter : ActionFilterAttribute
    {
        string CaptchaDirServerPath = string.Empty;
        string ActualText = string.Empty;
        string loginStatusFlag = string.Empty;
        string callForTwoFactor = string.Empty;

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            //filterContext.HttpContext.Session["GUIDSessionID"] = HttpContext.Current.Request.Cookies.Get("v_au").Value;
            if (filterContext.HttpContext.Session["loginStatus"] != null)
                loginStatusFlag = filterContext.HttpContext.Session["loginStatus"].ToString();

            if (filterContext.HttpContext.Session["TwoFactor"] != null)
                callForTwoFactor = filterContext.HttpContext.Session["TwoFactor"].ToString();

            if (loginStatusFlag == "1")
            {
                if (filterContext.HttpContext.Session["CaptchaValue"] != null)
                {
                    ActualText = filterContext.HttpContext.Session["CaptchaValue"].ToString();
                }
                else
                {
                    ActualText = string.Empty;
                }

                if (filterContext.HttpContext.Session["SerCaptchaPath"] != null)
                {
                    CaptchaDirServerPath = filterContext.HttpContext.Session["SerCaptchaPath"].ToString();
                }
                else
                {
                    CaptchaDirServerPath = string.Empty;
                }
            }
            bool bReturn = false;

            LoginUserDetails objLoginUserDetails = null;

            AuthenticationDTO objAuthenticationDTO = null;
            UserInfoDTO objUserAfterValidationObject = null;
            UserInfoDTO objUserAunthentication = null;
            PasswordConfigDTO objPasswordConfig = null;

            List<string> lstAuthorizationActionLinks = null;
            List<int> lstAuthorisedActionId = null;

            List<ActivityResourceMappingDTO> lstActivityResourceMappingDTO = null;
            Dictionary<string, List<ActivityResourceMappingDTO>> dicActivityResourceMappingDTO = null;
            int loginCount = 0;
            bool lockFlag = false;
            bool flag = false;

            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (objLoginUserDetails != null)
                {
                    //If IsAccountValidated is true in session abject then again it is not checked and only activity aauthorization
                    //is checked.
                    if (!objLoginUserDetails.IsAccountValidated)
                    {
                        objAuthenticationDTO = new AuthenticationDTO();

                        objAuthenticationDTO.LoginID = objLoginUserDetails.UserName;
                        objAuthenticationDTO.Password = objLoginUserDetails.Password;

                        //string sEncryptedPassword = "";
                        //Common.Common.encryptData(objAuthenticationDTO.Password, out sEncryptedPassword);
                        //objAuthenticationDTO.Password = sEncryptedPassword;
                        objUserAfterValidationObject = new UserInfoDTO();

                        using (var objUserInfoSL = new UserInfoSL())
                        {
                            if (objLoginUserDetails.CompanyDBConnectionString != null)
                            {
                                bReturn = objUserInfoSL.ValidateUser(objLoginUserDetails.CompanyDBConnectionString, objAuthenticationDTO, ref objUserAfterValidationObject);

                                Common.Common.WriteLogToFile("Validated User ", System.Reflection.MethodBase.GetCurrentMethod());
                            }

                            if (bReturn)
                            {
                                lstAuthorizationActionLinks = new List<string>();
                                lstAuthorisedActionId = new List<int>();

                                if (objUserAfterValidationObject.StatusCodeId == ConstEnum.UserStatus.Inactive)
                                {

                                    string sErrMessage = Common.Common.getResourceForGivenCompany("usr_msg_11274", objLoginUserDetails.CompanyName);

                                    if (sErrMessage == null || sErrMessage == "")
                                    {
                                        sErrMessage = "Your account has been inactivated. Please contact the Administrator.";
                                    }

                                    objLoginUserDetails = new LoginUserDetails();
                                    objLoginUserDetails.AuthorisedActionId = lstAuthorisedActionId;
                                    objLoginUserDetails.AuthorizedActions = lstAuthorizationActionLinks;
                                    objLoginUserDetails.ErrorMessage = sErrMessage;
                                    objLoginUserDetails.IsAccountValidated = false;
                                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });
                                }
                                else
                                {
                                    if (callForTwoFactor != "1")
                                    {
                                        string UsrCaptchaText = filterContext.HttpContext.Session["UserCaptchaText"].ToString();
                                        if (ActualText == string.Empty || ActualText == UsrCaptchaText)
                                        {
                                            LoginUser(filterContext);

                                        }
                                        else
                                        {
                                            DeleteCaptcha(filterContext);

                                            CaptchaValidation(filterContext);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (objLoginUserDetails.IsAccountValidated && !checkActionAuthorization(filterContext, objLoginUserDetails))
                    {
                        //If the request is from the Renderaction call and there is unauthorised access then dont redirect the request.
                        if (filterContext.HttpContext.PreviousHandler != null && filterContext.HttpContext.PreviousHandler is MvcHandler)
                        {
                        }
                        else
                        {
                            // filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Home" }, { "action", "Unauthorised" } });
                        }
                    }
                }
                else
                {
                    Common.Common.WriteLogToFile("User is not login ", System.Reflection.MethodBase.GetCurrentMethod());
                    objLoginUserDetails = new LoginUserDetails();
                    objLoginUserDetails.ErrorMessage = "";
                    objLoginUserDetails.IsAccountValidated = false;
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });
                }
            }
            catch (Exception exp)
            {
                using (var objPassConfigSL = new PasswordConfigSL())
                {
                    if (objLoginUserDetails.CompanyDBConnectionString != null)
                    {
                        objPasswordConfig = objPassConfigSL.GetPasswordConfigDetails(objLoginUserDetails.CompanyDBConnectionString);
                        int count = (Convert.ToInt16(Common.Common.GetSessionValue("LoginCount")) == 0) ? loginCount : Convert.ToInt16(Common.Common.GetSessionValue("LoginCount"));
                        if (count < objPasswordConfig.LoginAttempts)
                        {
                            count++;
                            Common.Common.SetSessionValue("LoginCount", count);

                            filterContext.HttpContext.Session["UserLgnCount"] = count;

                            if (count >= objPasswordConfig.LoginAttempts)
                            {

                                DeleteCaptcha(filterContext);
                                CaptchaValidation(filterContext);
                            }
                        }
                        else
                        {
                            DeleteCaptcha(filterContext);
                            CaptchaValidation(filterContext);
                        }
                    }
                }
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);

                // string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                //  objLoginUserDetails.ErrorMessage = sErrMessage;
                string sErrMessage = "";
                if (exp.InnerException != null)
                {
                    sErrMessage = Common.Common.getResourceForGivenCompany(exp.InnerException.Data[0].ToString(), objLoginUserDetails.CompanyName);
                }
                else
                {
                    sErrMessage = exp.Message;
                }


                if (sErrMessage == null || sErrMessage == "")
                {
                    sErrMessage = "Invalid details entered, please try again with correct details.";
                }
                if (Convert.ToBoolean(Common.Common.GetSessionValue("flag")) == true)
                {
                    sErrMessage = "Your account has been locked. Please contact the Administrator.";
                }

                objLoginUserDetails = new LoginUserDetails();

                objLoginUserDetails.ErrorMessage = sErrMessage;
                objLoginUserDetails.IsAccountValidated = false;

                if (exp.Message != Common.Common.getResource("com_lbl_14027"))
                {
                    using (SessionManagement sessionManagement = new SessionManagement())
                    {

                        //sessionManagement.CheckCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                        sessionManagement.BindCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                    }
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });
                }
                else if (exp.Message.ToString().Equals(Common.Common.getResource("com_lbl_14027"))
                    && HttpContext.Current.Request.Cookies["v_au2"] != null
                    && HttpContext.Current.Request.Cookies["v_au2"].Value != "")
                {
                    using (SessionManagement sessionManagement = new SessionManagement())
                    {
                        string decrypteddata = null;
                        Common.Common.dencryptData(HttpContext.Current.Request.Cookies["v_au2"].Value, out decrypteddata);
                        string strCookieName = (false ? string.Empty : decrypteddata + '~' + DateTime.Now.DayOfWeek.ToString().ToUpper());
                        UserInfoSL objUserInfoSL = new UserInfoSL();
                        InsiderTradingDAL.SessionDetailsDTO objSessionDetailsDTO = null;
                        LoginUserDetails loginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                        objSessionDetailsDTO = objUserInfoSL.GetCookieStatus(loginUserDetails.CompanyDBConnectionString, loginUserDetails.LoggedInUserID, Convert.ToString(strCookieName), false, false);
                        if (objSessionDetailsDTO != null)
                        {

                            //sessionManagement.CheckCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "");
                            sessionManagement.BindCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "");
                            objLoginUserDetails.ErrorMessage = string.Empty;
                            objLoginUserDetails.IsAccountValidated = true;
                        }
                        else
                        {
                            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                            filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });
                        }
                    }
                }
            }
            finally
            {
                filterContext.HttpContext.Session["loginStatus"] = 0;
                objLoginUserDetails = null;
                objAuthenticationDTO = null;
                objUserAfterValidationObject = null;

                lstAuthorizationActionLinks = null;
                lstAuthorisedActionId = null;
                lstActivityResourceMappingDTO = null;
                dicActivityResourceMappingDTO = null;

                objUserAunthentication = null;

            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            base.OnActionExecuting(filterContext);
        }


        /// <summary>
        /// This function will check if the login user has access to the action begin performed, i.e. action method to which this 
        /// filter is applied.
        /// </summary>
        /// <param name="i_objFilterContext"></param>
        /// <param name="i_objLoginUserDetails">The login user details object from session</param>
        /// <returns></returns>
        private bool checkActionAuthorization(ActionExecutingContext i_objFilterContext, LoginUserDetails i_objLoginUserDetails)
        {
            /*To be deleted when testing for authorization is done instead replace this line with 
             * bool bEnableAuthorization = true;
             * Also when deleting this remove the app-settings key EnableAuthorization from Web.config file AppSettings file
             */
            bool bEnableAuthorization = Common.Common.getAppSetting("EnableAuthorization") == "" ? true : Convert.ToBoolean(Common.Common.getAppSetting("EnableAuthorization"));
            bool bReturn = !bEnableAuthorization;
            string sControllerName = "";
            string sActionName = "";
            //string sCombinedString = "";
            List<string> lstAuthorizedActions = new List<string>();
            List<int> lstAuthorizedActionIds = new List<int>();
            object objActivityId;
            int nActivityId = 0;

            object objButtonName = null;
            string sButtonName = "";

            string sAcidURLMap = "";

            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            try
            {
                sControllerName = i_objFilterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                sActionName = i_objFilterContext.ActionDescriptor.ActionName;

                if (i_objFilterContext.RouteData.DataTokens.ContainsKey("acid"))
                {
                    i_objFilterContext.RouteData.DataTokens.TryGetValue("acid", out objActivityId);
                    nActivityId = Convert.ToInt32(objActivityId);
                }
                else if (i_objFilterContext.ActionParameters.ContainsKey("acid"))
                {
                    i_objFilterContext.ActionParameters.TryGetValue("acid", out objActivityId);
                    nActivityId = Convert.ToInt32(objActivityId);
                }

                if (i_objFilterContext.RouteData.DataTokens.ContainsKey("ButtonName"))
                {
                    i_objFilterContext.RouteData.DataTokens.TryGetValue("ButtonName", out objButtonName);
                    sButtonName = Convert.ToString(objButtonName);
                }

                lstAuthorizedActions = i_objLoginUserDetails.AuthorizedActions;

                sAcidURLMap = nActivityId.ToString() + "_" + sControllerName.ToLower() + "_" + sActionName.ToLower() + (sButtonName != "" ? "_" + sButtonName.ToLower() : "");

                if (lstAuthorizedActions.Contains(sAcidURLMap))
                {
                    bReturn = true;
                }

                /*Start COMMENT - Following code commented in Security Fixes change */
                //lstAuthorizedActionIds = i_objLoginUserDetails.AuthorisedActionId;

                //if (lstAuthorizedActionIds.Contains(nActivityId))
                //{
                //    bReturn = true;
                //}
                //if (!bReturn)
                //{
                //    if (nActivityId == ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD ||
                //        nActivityId == ConstEnum.UserActions.DASHBOARD_INSIDERUSER)
                //    {
                //        bReturn = true;
                //            i_objFilterContext.Result = new RedirectToRouteResult(new RouteValueDictionary{{ "Controller" , "Home"},{"Action" , "About" }});
                //            base.OnActionExecuting(i_objFilterContext);
                //    }
                //}
                /*End COMMENT - Following code commented in Security Fixes change */
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);

                throw exp;
            }
            finally
            {
                lstAuthorizedActions = null;
                lstAuthorizedActionIds = null;
                objActivityId = null;
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return bReturn;
        }


        public void CaptchaValidation(ActionExecutingContext filterContext)
        {
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            string strServerPath = string.Empty;
            using (ImageGenrator generateImage = new ImageGenrator())
            {
                using (Image image = generateImage.DrawText(ref ActualText))
                {

                    strServerPath = ConfigurationManager.AppSettings["Document"].ToString() + @"captcha\";
                    if (!Directory.Exists(strServerPath))
                        Directory.CreateDirectory(strServerPath);
                    string captchaImage = Guid.NewGuid().ToString() + ".png";
                    image.Save(strServerPath + captchaImage, ImageFormat.Png);

                    filterContext.HttpContext.Session["CaptchaValue"] = ActualText;

                    string strImagePath = string.Empty;
                    strImagePath = strServerPath;
                    strImagePath = HttpRuntime.AppDomainAppVirtualPath.ToString().ToUpper() + "/" + strImagePath.Substring(strImagePath.IndexOf("Document")).Replace("\\", "/");
                    string ImagePath = strImagePath + captchaImage;

                    //string ImagePath = strServerPath + captchaImage;

                    filterContext.HttpContext.Session["CaptchaPath"] = ImagePath;
                    filterContext.HttpContext.Session["CaptchaFileName"] = captchaImage;
                }


                string CaptchaDirServerPath = string.Empty;
                CaptchaDirServerPath = strServerPath;
                filterContext.HttpContext.Session["SerCaptchaPath"] = CaptchaDirServerPath;


                objLoginUserDetails = new LoginUserDetails();
                objLoginUserDetails.IsAccountValidated = false;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });

            }

        }

        public void LoginUser(ActionExecutingContext filterContext)
        {
            DeleteCaptcha(filterContext);

            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            AuthenticationDTO objAuthenticationDTO = new AuthenticationDTO();

            objAuthenticationDTO.LoginID = objLoginUserDetails.UserName;
            objAuthenticationDTO.Password = objLoginUserDetails.Password;

            UserInfoDTO objUserAfterValidationObject = null;
            UserInfoDTO objUserAunthentication = null;
            PasswordConfigDTO objPasswordConfig = null;

            List<string> lstAuthorizationActionLinks = null;
            List<int> lstAuthorisedActionId = null;

            List<ActivityResourceMappingDTO> lstActivityResourceMappingDTO = null;
            Dictionary<string, List<ActivityResourceMappingDTO>> dicActivityResourceMappingDTO = null;
            int loginCount = 0;
            bool lockFlag = false;
            bool flag = false;
            objAuthenticationDTO.Password = null;
            objLoginUserDetails.Password = null;
            objLoginUserDetails.IsAccountValidated = true;
            objLoginUserDetails.ErrorMessage = "";
            UserInfoSL objUserInfoSL = new UserInfoSL();

            //Load the action permissions in the session object for to be used when checking authorization
            objUserAunthentication = objUserInfoSL.GetUserAuthencticationDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserName);

            filterContext.HttpContext.Session["GUIDSessionID"] = HttpContext.Current.Request.Cookies.Get("v_au").Value + objUserAunthentication.UserInfoId;
            objLoginUserDetails.LoggedInUserID = objUserAunthentication.UserInfoId;
            objLoginUserDetails.EmailID = objUserAunthentication.EmailId;
            objLoginUserDetails.FirstName = objUserAunthentication.FirstName;
            objLoginUserDetails.LastName = objUserAunthentication.LastName;

            objUserInfoSL.GetLoginUserApplicableActions(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID.ToString(),
                out lstAuthorizationActionLinks, out lstAuthorisedActionId);

            objLoginUserDetails.AuthorizedActions = lstAuthorizationActionLinks;

            lstAuthorisedActionId.Add(0);

            objLoginUserDetails.AuthorisedActionId = lstAuthorisedActionId;
            objLoginUserDetails.CompanyLogoURL = objUserAunthentication.CompanyLogoURL;
            objLoginUserDetails.UserTypeCodeId = Convert.ToInt32(objUserAunthentication.UserTypeCodeId);
            objLoginUserDetails.LastLoginTime = objUserAunthentication.LastLoginTime;
            objLoginUserDetails.DateOfBecomingInsider = objUserAunthentication.DateOfBecomingInsider;

            using (var objActivitySL = new ActivitySL())
            {
                lstActivityResourceMappingDTO = objActivitySL.GetActivityResourceMappingDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            }

            dicActivityResourceMappingDTO = new Dictionary<string, List<ActivityResourceMappingDTO>>();

            foreach (var objActivityResourceDTO in lstActivityResourceMappingDTO)
            {
                if (!dicActivityResourceMappingDTO.ContainsKey(objActivityResourceDTO.ColumnName))
                    dicActivityResourceMappingDTO.Add(objActivityResourceDTO.ColumnName, new List<ActivityResourceMappingDTO>());

                dicActivityResourceMappingDTO[objActivityResourceDTO.ColumnName].Add(objActivityResourceDTO);
            }
            objLoginUserDetails.ActivityResourceMapping = dicActivityResourceMappingDTO;

            objLoginUserDetails.DocumentDetails = new Dictionary<string, DocumentDetailsDTO>();

            //set login user details into session
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

            Common.Common.WriteLogToFile("Update session with login user details ", System.Reflection.MethodBase.GetCurrentMethod());

            //This will update the login time for the user. So this should be done after setting the Lastlogin time in the session object.
            objUserInfoSL.UpdateUserLastLoginTime(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserName);

            // user is login sucessfully, set validation value set in session and cookies to indicate user is login
            Common.Common.SetSessionAndCookiesValidationValue(objLoginUserDetails.UserName);//set session validation keys

            Common.Common.WriteLogToFile("Set login user name into session and cookies values", System.Reflection.MethodBase.GetCurrentMethod());

            //get new cookies value after login
            //string cookies_value = Common.Common.GetSessionValue(ConstEnum.SessionValue.CookiesValidationKey).ToString();

            //set cookies
            //filterContext.HttpContext.Response.Cookies[ConstEnum.CookiesValue.ValidationCookies].Value = cookies_value;
            //filterContext.HttpContext.Response.Cookies[ConstEnum.CookiesValue.ValidationCookies].Path = HttpContext.Current.Request.ApplicationPath;
            using (SessionManagement sessionManagement = new SessionManagement())
            {
                sessionManagement.CheckCookiesSessions(objLoginUserDetails, true, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, string.Empty);
                sessionManagement.BindCookiesSessions(objLoginUserDetails, true, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, string.Empty);
            }

            Common.Common.WriteLogToFile("Set cookies to response to send back to browser ", System.Reflection.MethodBase.GetCurrentMethod());

        }

        public void DeleteCaptcha(ActionExecutingContext filterContext)
        {
            if (Directory.Exists(CaptchaDirServerPath))
            {
                if (filterContext.HttpContext.Session["CaptchaPath"] != null)
                {
                    string fileName = filterContext.HttpContext.Session["CaptchaFileName"].ToString();


                    string CaptchaDirPath = CaptchaDirServerPath + fileName;


                    if (!string.IsNullOrEmpty(CaptchaDirPath))
                    {
                        if ((System.IO.File.Exists(CaptchaDirPath)))
                        {
                            File.Delete(CaptchaDirPath);
                        }
                    }

                }
            }
        }



    }

    //public class AuthorizeRolesAttribute : AuthorizeAttribute
    //{
    //    public AuthorizeRolesAttribute(params string[] roles)
    //        : base()
    //    {
    //        Roles = string.Join(",", roles);

    //    }
    //}

    //public static class Role
    //{
    //    public const string Administrator = "AdminRole";
    //    public const string Assistant = "Assistant";
    //}
}

