using ImageGenerator;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingEncryption;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace InsiderTrading.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        #region Login
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login()
        {
            LoginUserDetails objLoginUserDetails = null;
            CompaniesSL objCompaniesSL = null;
            List<InsiderTradingDAL.CompanyDTO> lstCompanies = null;
            Dictionary<string, string> objCompaniesDictionary = null;
            PasswordConfigDTO objPasswordConfig = null;
            int loginCount = 0;
            Session["TwoFactor"] = 0;
            Session["IsOTPAuthPage"] = null;
            try
            {
                //Clear browser cache
                //Response.Cache.SetNoStore();
                //Response.Cache.SetCacheability(HttpCacheability.NoCache);
                //Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));

                
                //For company specific url.. auto fill company name
                string ClientName = "";
                string currentURL = HttpContext.Request.Url.AbsoluteUri;
                int index = currentURL.IndexOf("//");
                string RemoveProtocol = "";
                RemoveProtocol = currentURL.Substring(index + 2);
                ClientName = RemoveProtocol.Split('.')[0].ToLower();
                if (ClientName == "axisbank")
                {
                    ClientName = "axis bank";
                }

                Random random = new Random();
                int num = random.Next();
                Session["randomNumber"] = num;

                if (ConfigurationManager.AppSettings["ActivateWaterMark"].ToString() == "true")
                {
                    string DomainName = System.Net.NetworkInformation.IPGlobalProperties.GetIPGlobalProperties().DomainName;

                    if (DomainName == ConfigurationManager.AppSettings["DomainName"])
                    {
                        ViewData["WaterMarkCompanyName"] = ConfigurationManager.AppSettings["WaterMarkTextForCompanyName"];
                        ViewData["WaterMarkLoginId"] = ConfigurationManager.AppSettings["WaterMarkTextForLoginId"];
                        ViewData["WaterMarkPassword"] = "*******";
                    }
                }

                //set session validation value
                Common.Common.SetSessionAndCookiesValidationValue(ConstEnum.SessionAndCookiesKeyBeforeLogin);

                //create new cookies for login page
                string cookies_value = Common.Common.GetSessionValue(ConstEnum.SessionValue.CookiesValidationKey).ToString();

                //Response.Cookies.Add(new HttpCookie(ConstEnum.CookiesValue.ValidationCookies, cookies_value) { Path = Request.ApplicationPath /*, Expires = DateTime.Now.AddDays(1)*/ });

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                //set session key to null 
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, null);

                using (objCompaniesSL = new CompaniesSL())
                {
                    lstCompanies = objCompaniesSL.getAllCompanies(Common.Common.getSystemConnectionString());

                    objCompaniesDictionary = new Dictionary<string, string>();

                    //List<SelectListItem> lstCompaniesListBox = new List<SelectListItem>(); //commented unused variable

                    objCompaniesDictionary.Add("", "Select Company");

                    foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompanies)
                    {
                        objCompaniesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
                    }
                    if (objCompaniesDictionary.ContainsValue(ClientName.ToLower()))
                    {
                        ViewBag.URLCompanyName = ClientName;
                    }
                    else
                    {
                        ViewBag.URLCompanyName = "IgnoreCompanyName";
                    }
                }

                ViewBag.JavascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;

                ViewBag.CompaniesDropDown = objCompaniesDictionary;

                if (objLoginUserDetails != null)
                {
                    ViewBag.LoginError = objLoginUserDetails.ErrorMessage;
                    ViewBag.SuccessMessage = objLoginUserDetails.SuccessMessage;
                }
                else
                {
                    ViewBag.LoginError = "";
                }
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
            }
            finally
            {
                objLoginUserDetails = null;
                lstCompanies = null;
            }

            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryTokenOnAllPosts]
        [AllowAnonymous]
        public async Task<ActionResult> Login(UserDetailsModel model)
        {
            LoginUserDetails objLoginUserDetails = null;
            InsiderTradingEncryption.DataSecurity objPwdHash = null;

            CompanyDTO objSelectedCompany = null;
            DataSecurity objDataSecurity = new DataSecurity();
            PasswordConfigDTO objPasswordConfig = null;
            int loginCount = 0;
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());
            bool IsEmailOTPActive = false;
            try
            {
                Session["UserCaptchaText"] = (model.sCaptchaText == null) ? string.Empty : model.sCaptchaText;
                TempData["ShowDupTransPopUp"] = 1;
                objLoginUserDetails = new LoginUserDetails();
                string formUsername = string.Empty;
                string formPassword = string.Empty;
                string formEncryptedUsername = string.Empty;
                string formEncryptedPassword = string.Empty;

                string sPasswordHash = string.Empty;
                string javascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;
                string userPasswordHashSalt = Common.ConstEnum.User_Password_Encryption_Key;
                string EncryptedRandomNo = string.Empty;

                if (model.sCalledFrom != objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), userPasswordHashSalt))
                {
                    objPwdHash = new InsiderTradingEncryption.DataSecurity();

                    formEncryptedUsername = model.sUserName;
                    formEncryptedPassword = model.sPassword;

                    formEncryptedUsername = DecryptStringAES(formEncryptedUsername, javascriptEncryptionKey, javascriptEncryptionKey);
                    formEncryptedPassword = DecryptStringAES(formEncryptedPassword, javascriptEncryptionKey, javascriptEncryptionKey);

                    EncryptedRandomNo = formEncryptedUsername.Split('~')[1].ToString();

                    if (EncryptedRandomNo != Convert.ToString(Session["randomNumber"]))
                    {
                        throw new System.Web.HttpException(401, "Unauthorized access");
                    }

                    formUsername = formEncryptedUsername.Split('~')[0].ToString();
                    formPassword = formEncryptedPassword.Split('~')[0].ToString();
                }
                else
                {
                    Session["IsSSOActivated"] = "1";
                    formUsername = model.sUserName;
                    sPasswordHash = string.IsNullOrEmpty(model.sPassword) ? "" : model.sPassword;
                }

                using (CompaniesSL objCompanySL = new CompaniesSL())
                {
                    if (System.Configuration.ConfigurationManager.AppSettings["CompanyType"] == "Textbox")
                    {
                        Dictionary<string, string> objCompaniesDictionary = null;

                        objCompaniesDictionary = new Dictionary<string, string>();

                        foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString()))
                        {
                            objCompaniesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
                        }

                        if (objCompaniesDictionary.ContainsValue(model.sCompanyName.ToLower()))
                        {
                            model.sCompanyName = (from entry in objCompaniesDictionary
                                                  where entry.Value.ToLower() == model.sCompanyName.ToLower()
                                                  select entry.Key).FirstOrDefault();
                        }
                        else
                        {
                            objLoginUserDetails.ErrorMessage = "Invalid company name";
                            objLoginUserDetails.IsAccountValidated = false;
                            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                            Common.Common.WriteLogToFile("Invalid company name");
                            Session["IsSSOActivated"] = null;
                            return RedirectToAction("Login", "Account");
                        }
                    }

                    objSelectedCompany = objCompanySL.getSingleCompanies(Common.Common.getSystemConnectionString(), model.sCompanyName);

                    Session["SelectedCompanyName"] = objSelectedCompany.sCompanyName.ToLower();
                    if (model.sCalledFrom != objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), userPasswordHashSalt))
                    {
                        string saltValue = string.Empty;
                        string calledFrom = "Login";

                        using (UserInfoSL ObjUserInfoSL = new UserInfoSL())
                        {
                            List<AuthenticationDTO> lstUserDetails = ObjUserInfoSL.GetUserLoginDetails(objSelectedCompany.CompanyConnectionString, formUsername, calledFrom);
                            foreach (var UserDetails in lstUserDetails)
                            {
                                saltValue = UserDetails.SaltValue;
                            }
                        }
                        using (TwoFactorAuthSL objIsOTPEnable = new TwoFactorAuthSL())
                        {
                            IsEmailOTPActive = objIsOTPEnable.CheckIsOTPActived(objSelectedCompany.CompanyConnectionString, formUsername);
                        }

                        string usrSaltValue = (saltValue == null || saltValue == string.Empty) ? userPasswordHashSalt : saltValue;

                        if (saltValue != null && saltValue != "")
                            sPasswordHash = objPwdHash.CreateHashToVerify(formPassword, usrSaltValue);
                        else
                            sPasswordHash = objPwdHash.CreateHash(formPassword, usrSaltValue);

                    }
                    objLoginUserDetails.UserName = formUsername;
                    objLoginUserDetails.Password = sPasswordHash;
                    objLoginUserDetails.CompanyDBConnectionString = objSelectedCompany.CompanyConnectionString;
                    objLoginUserDetails.CompanyName = model.sCompanyName;

                    objLoginUserDetails.IsUserLogin = false; //this flag indicate that user is not yet login sucessfully
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    using (var objPassConfigSL = new PasswordConfigSL())
                    {
                        objPasswordConfig = objPassConfigSL.GetPasswordConfigDetails(objSelectedCompany.CompanyConnectionString);
                        loginCount = (Session["UserLgnCount"] == null) ? 0 : Convert.ToInt32(Session["UserLgnCount"].ToString());
                        TempData["ShowCaptcha"] = false;
                        if (loginCount >= (objPasswordConfig.LoginAttempts - 1))
                        {
                            TempData["ShowCaptcha"] = true;
                            Session["DisplayCaptcha"] = true;
                        }
                        if ((loginCount >= objPasswordConfig.LoginAttempts && model.sCaptchaText == "") || loginCount >= objPasswordConfig.LoginAttempts && model.sCaptchaText != Session["CaptchaValue"].ToString())
                        {
                            TempData["ShowCaptcha"] = true;
                            TempData["ErrorMessage"] = "Please provide valid text";
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                //If User is trying to login with a loginID which is being logged-in into the system. Then show the message and don't allow to login.
                string sErrMessage = exp.Message;
                objLoginUserDetails.ErrorMessage = sErrMessage;
                objLoginUserDetails.IsAccountValidated = false;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                Session["IsSSOActivated"] = null;
                ClearAllSessions();
                return RedirectToAction("Login", "Account");
            }
            finally
            {
                objLoginUserDetails = null;
                objPwdHash = null;
                objSelectedCompany = null;
            }
            if (IsEmailOTPActive)
            {
                Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
                Session["TwoFactor"] = 1;
                Session["IsOTPAuthPage"] = "TwoFactorAuthentication";
                return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
            }
            else
            {
                Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
                Session["loginStatus"] = 1;
                return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0), calledFrom = "Login" });
            }
        }
        #endregion Login

        #region LogOut
        [AllowAnonymous]
        [UpdateResourcesFilter(Order = 1)]
        public ActionResult LogOut()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            if (objLoginUserDetails != null)
            {
                Dictionary<string, DocumentDetailsDTO> dicDocumentDetailsDTO = objLoginUserDetails.DocumentDetails;
                if (dicDocumentDetailsDTO != null && dicDocumentDetailsDTO.Count > 0)
                {
                    string directory = ConfigurationManager.AppSettings["Document"];
                    foreach (KeyValuePair<string, DocumentDetailsDTO> objDocumentDetailsDTO in dicDocumentDetailsDTO)
                    {
                        if (System.IO.File.Exists(Path.Combine(directory, "temp", objDocumentDetailsDTO.Key)))
                        {
                            FileInfo file = new FileInfo(Path.Combine(directory, "temp", objDocumentDetailsDTO.Key));
                            file.Delete();
                        }
                    }
                }
                using (SessionManagement sessionManagement = new SessionManagement())
                {
                    //sessionManagement.CheckCookiesSessions(objLoginUserDetails, false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                    sessionManagement.BindCookiesSessions(objLoginUserDetails, false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                }

                using (var objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoSL.DeleteFormToken(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), 0);
                    objUserInfoSL.DeleteCookiesStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), "Delete");
                }
            }

            //expire cookies use for validation
            Response.Cookies[ConstEnum.CookiesValue.ValidationCookies].Expires = DateTime.Now.AddYears(-1);

            //expire all other cookies, if any 
            if (Response.Cookies.Count > 0)
            {
                foreach (string cookies_name in Response.Cookies.AllKeys)
                {
                    if (cookies_name != ConstEnum.CookiesValue.ValidationCookies)
                    {
                        Response.Cookies[cookies_name].Expires = DateTime.Now.AddYears(-1);
                    }
                }
            }

            if (Session["IsSSOActivated"] != null && Session["IsSSOActivated"].ToString() == "1")
            {
                CompanyDTO objSelectedCompany = null;
                using (CompaniesSL objCompanySL = new CompaniesSL())
                {
                    objSelectedCompany = objCompanySL.getSingleCompanies(Common.Common.getSystemConnectionString(), objLoginUserDetails.CompanyName);
                    ViewBag.SSOUrl = objSelectedCompany.sSSOUrl;
                }

                ClearAllSessions();
                return View("Logout");

            }
            ClearAllSessions();

            TempData["ShowCaptcha"] = false;
            TempData.Remove("ContactDetails");
            TempData.Remove("RelativeMobileDetail");
            return RedirectToAction("Login", "Account");
        }

        /// <summary>
        /// Clearing all application sessions 
        /// </summary>
        private void ClearAllSessions()
        {
            Session.Clear();
            Session.RemoveAll();
        }

        #endregion LogOut

        #region ForgetPassword
        [AllowAnonymous]
        public ActionResult ForgetPassword()
        {
            //For company specific url.. auto fill company name
            string ClientName = "";
            string currentURL = HttpContext.Request.Url.AbsoluteUri;
            int index = currentURL.IndexOf("//");
            string RemoveProtocol = "";
            RemoveProtocol = currentURL.Substring(index + 2);
            ClientName = RemoveProtocol.Split('.')[0].ToLower();
            if (ClientName == "axisbank")
            {
                ClientName = "axis bank";
            }

            if (ConfigurationManager.AppSettings["ActivateWaterMark"].ToString() == "true")
            {
                string DomainName = System.Net.NetworkInformation.IPGlobalProperties.GetIPGlobalProperties().DomainName;

                if (DomainName == ConfigurationManager.AppSettings["DomainName"])
                {
                    ViewData["WaterMarkCompanyName"] = ConfigurationManager.AppSettings["WaterMarkTextForCompanyName"];
                    ViewData["WaterMarkLoginId"] = ConfigurationManager.AppSettings["WaterMarkTextForLoginId"];
                    ViewData["WaterMarkEmailId"] = ConfigurationManager.AppSettings["WaterMarkTextForEmailId"];
                }
            }

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            if (objLoginUserDetails != null)
            {
                if (!(objLoginUserDetails.LoggedInUserID == 0 && objLoginUserDetails.ErrorMessage == null))
                {
                    ModelState.AddModelError("", objLoginUserDetails.ErrorMessage);
                    objLoginUserDetails.ErrorMessage = string.Empty;
                }
            }

            Dictionary<string, string> objCompaiesDictionary = new Dictionary<string, string>();
            objCompaiesDictionary.Add("", "Select Company");
            CompaniesSL objCompanySL = new CompaniesSL();
            List<InsiderTradingDAL.CompanyDTO> lstCompanies = new List<InsiderTradingDAL.CompanyDTO>();
            lstCompanies = objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString());
            foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompanies)
            {
                objCompaiesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
            }
            if (objCompaiesDictionary.ContainsValue(ClientName.ToLower()))
            {
                ViewBag.URLCompanyName = ClientName;
            }
            else
            {
                ViewBag.URLCompanyName = "IgnoreCompanyName";
            }
            ViewBag.CompaniesDropDown = objCompaiesDictionary;

            PasswordManagementModel objPwdMgmtModel = new PasswordManagementModel();
            DeleteCaptcha();
            CaptchaValidation();
            return View("ForgetPassword");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [AllowAnonymous]
        [Button(ButtonName = "Create")]
        [ActionName("ForgetPassword")]
        public ActionResult ForgetPassword(PasswordManagementModel objPwdMgmtModel)
        {
            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            Session["UserCaptchaTextForgotPwd"] = (objPwdMgmtModel.sCaptchaText == null) ? string.Empty : objPwdMgmtModel.sCaptchaText;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objLoginUserDetails == null)
                    objLoginUserDetails = new LoginUserDetails();

                PasswordManagementDTO objPwdMgmtDTO = new PasswordManagementDTO();
                UserInfoSL objUserInfoSL = new UserInfoSL();
                CompaniesSL objCompanySL = new CompaniesSL();

                if (System.Configuration.ConfigurationManager.AppSettings["CompanyType"] == "Textbox")
                {
                    Dictionary<string, string> objCompaniesDictionary = null;

                    objCompaniesDictionary = new Dictionary<string, string>();

                    foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString()))
                    {
                        objCompaniesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName.ToLower());
                    }

                    if (objCompaniesDictionary.ContainsValue(objPwdMgmtModel.CompanyID.ToLower()))
                    {
                        objPwdMgmtModel.CompanyID = (from entry in objCompaniesDictionary
                                                     where entry.Value.ToLower() == objPwdMgmtModel.CompanyID.ToLower()
                                                     select entry.Key).FirstOrDefault();
                    }
                }

                InsiderTradingDAL.CompanyDTO objSelectedCompany = objCompanySL.getSingleCompanies(Common.Common.getSystemConnectionString(), objPwdMgmtModel.CompanyID);


                string SaltValue = Common.ConstEnum.User_Password_Encryption_Key;

                InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
                string sHashCode = objPwdHash.CreateHash(objPwdMgmtModel.LoginID.ToString() + objPwdMgmtModel.CompanyID.ToString(), SaltValue);
                objPwdMgmtModel.HashValue = sHashCode;
                var CallBackUrl = Url.Action("SetPassword", "Account", new { @code = sHashCode });

                string sLoginID = string.Empty;
                string sEmailID = string.Empty;
                string javascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;

                sLoginID = DecryptStringAES(objPwdMgmtModel.LoginID, javascriptEncryptionKey, javascriptEncryptionKey);
                sEmailID = DecryptStringAES(objPwdMgmtModel.EmailID, javascriptEncryptionKey, javascriptEncryptionKey);

                if (!string.IsNullOrEmpty(sEmailID))
                {
                    string emailRegex = @"^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$";
                    Regex re = new Regex(emailRegex);
                    if (!re.IsMatch(sEmailID))
                    {
                        ModelState.AddModelError("EmailID", "Please provide valid Email ID");
                    }
                }

                objPwdMgmtModel.LoginID = sLoginID;
                objPwdMgmtModel.EmailID = sEmailID;

                InsiderTrading.Common.Common.CopyObjectPropertyByName(objPwdMgmtModel, objPwdMgmtDTO);
                objPwdMgmtDTO = objUserInfoSL.ForgetPassword(objSelectedCompany.CompanyConnectionString, objPwdMgmtDTO);
                if (objPwdMgmtDTO.EmailID != null)
                {
                    if (objPwdMgmtModel.sCaptchaText != Session["CaptchaValueForgotPwd"].ToString())
                    {
                        TempData["ShowCaptchaForgotPwd"] = true;
                        TempData["ErrorMessageForgotPwd"] = "Please provide valid Text";
                        @ViewBag.ErrorMessage = "Please provide valid Text";
                        objLoginUserDetails.ErrorMessage = "Please provide valid Text";
                        return RedirectToAction("ForgetPassword", "Account");
                    }
                    Common.Common.SendMail(CallBackUrl, objPwdMgmtDTO, objSelectedCompany.sCompanyDatabaseName);
                }
                objLoginUserDetails.SuccessMessage = Common.Common.getResourceForGivenCompany("usr_msg_11270", objSelectedCompany.sCompanyDatabaseName);
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                return RedirectToAction("Login", "Account");//.Success(Common.Common.getResourceForGivenCompany("usr_msg_11270", objSelectedCompany.sCompanyDatabaseName));
            }
            catch (Exception exp)
            {
                string sErrMessage = exp.Message;
                if (exp.InnerException != null && exp.InnerException.Data != null && exp.InnerException.Data.Count > 0)
                {
                    sErrMessage = Common.Common.getResourceForGivenCompany(exp.InnerException.Data[0].ToString(), objPwdMgmtModel.CompanyID);
                }
                @ViewBag.ErrorMessage = sErrMessage;
                objPwdMgmtModel.LoginID = null;
                objPwdMgmtModel.EmailID = null;
                Dictionary<string, string> objCompaiesDictionary = new Dictionary<string, string>();
                objCompaiesDictionary.Add("", "Select Company");
                CompaniesSL objCompanySL = new CompaniesSL();
                List<InsiderTradingDAL.CompanyDTO> lstCompanies = new List<InsiderTradingDAL.CompanyDTO>();
                lstCompanies = objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString());
                foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompanies)
                {
                    objCompaiesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
                }
                ViewBag.CompaniesDropDown = objCompaiesDictionary;
                objLoginUserDetails.ErrorMessage = sErrMessage;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                return RedirectToAction("ForgetPassword", "Account");
            }

        }
        #endregion ForgetPassword

        #region SetPassword
        [AllowAnonymous]
        public ActionResult SetPassword(string Code)
        {
            //For company specific url.. auto fill company name
            string ClientName = "";
            string currentURL = HttpContext.Request.Url.AbsoluteUri;
            int index = currentURL.IndexOf("//");
            string RemoveProtocol = "";
            RemoveProtocol = currentURL.Substring(index + 2);
            ClientName = RemoveProtocol.Split('.')[0].ToLower();
            if (ClientName == "axisbank")
            {
                ClientName = "axis bank";
            }

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PasswordPolicyDTO objPasswordPolicy = new PasswordPolicyDTO();
            //When the Hash code contains + in it then it gets encoded to space because of which the HshCode gets changed and further when changing password for user it gives invalid Link error.
            //So as space is not generated in the generated hash code so we can assume that when there is sapce in the hash code it should be + there and so are replacing it before using it.
            Code = Code.Replace(" ", "+");
            if (objLoginUserDetails != null)
            {
                ViewBag.ErrorMessage = objLoginUserDetails.ErrorMessage;
                objLoginUserDetails.ErrorMessage = "";
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            }
            Dictionary<string, string> objCompaiesDictionary = new Dictionary<string, string>();
            objCompaiesDictionary.Add("", "Select Company");
            CompaniesSL objCompanySL = new CompaniesSL();
            List<InsiderTradingDAL.CompanyDTO> lstCompanies = new List<InsiderTradingDAL.CompanyDTO>();
            lstCompanies = objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString());
            foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompanies)
            {
                objCompaiesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
            }
            if (objCompaiesDictionary.ContainsValue(ClientName.ToLower()))
            {
                ViewBag.URLCompanyName = ClientName;
            }
            else
            {
                ViewBag.URLCompanyName = "IgnoreCompanyName";
            }
            ViewBag.CompaniesDropDown = objCompaiesDictionary;

            PasswordManagementModel objPwdMgmtModel = new PasswordManagementModel();
            objPwdMgmtModel.HashValue = Code;
            ViewBag.Hashcode = Code;
            ViewBag.CalledFrom = "ForgetPassword";
            return View("SetPassword", objPwdMgmtModel);
        }


        [ValidateAntiForgeryToken]
        [HttpPost, ValidateInput(false)]
        [Button(ButtonName = "Create")]
        [ActionName("SetPassword")]
        [AllowAnonymous]
        public ActionResult SetPassword(PasswordManagementModel objPwdMgmtModel)
        {
            bool bErrorOccurred = false;
            string i_ErrorMessage = "";
            string NewPassword = null;
            InsiderTradingDAL.CompanyDTO objSelectedCompany = new CompanyDTO();
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objLoginUserDetails == null) objLoginUserDetails = new LoginUserDetails();

                if (objPwdMgmtModel.CompanyID == null || objPwdMgmtModel.CompanyID == "")
                {
                    i_ErrorMessage = "Company is required field.";
                    bErrorOccurred = true;
                }
                else if (objPwdMgmtModel.NewPassword == null || objPwdMgmtModel.NewPassword == "" || objPwdMgmtModel.ConfirmNewPassword == null || objPwdMgmtModel.ConfirmNewPassword == "")
                {
                    i_ErrorMessage = "Please enter new password and confirm password.";
                    bErrorOccurred = true;
                }
                else if (objPwdMgmtModel.NewPassword != objPwdMgmtModel.ConfirmNewPassword)
                {
                    i_ErrorMessage = "New password and Confirm password are not matching.";
                    bErrorOccurred = true;
                }

                if (System.Configuration.ConfigurationManager.AppSettings["CompanyType"] == "Textbox")
                {
                    Dictionary<string, string> objCompaniesDictionary = null;

                    objCompaniesDictionary = new Dictionary<string, string>();

                    using (CompaniesSL objCompanySL = new CompaniesSL())
                    {
                        foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in objCompanySL.getAllCompanies(Common.Common.getSystemConnectionString()))
                        {
                            objCompaniesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName.ToLower());
                        }
                    }

                    if (objCompaniesDictionary.ContainsValue(objPwdMgmtModel.CompanyID.ToLower()))
                    {
                        objPwdMgmtModel.CompanyID = (from entry in objCompaniesDictionary
                                                     where entry.Value.ToLower() == objPwdMgmtModel.CompanyID.ToLower()
                                                     select entry.Key).FirstOrDefault();
                    }
                    else
                    {
                        objLoginUserDetails.ErrorMessage = "Invalid Company Name";
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                        return RedirectToAction("SetPassword", "Account", new { code = objPwdMgmtModel.HashValue });
                    }
                }

                //hashed password to check password history
                InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();

                string saltValue = string.Empty;
                if (objPwdMgmtModel.NewPassword != null)
                {

                    //NewPassword = objPwdHash.CreateSaltandHash(objPwdMgmtModel.NewPassword);
                    string sPasswordHashWithSalt = objPwdHash.CreateSaltandHash(objPwdMgmtModel.NewPassword);
                    NewPassword = sPasswordHashWithSalt.Split('~')[0].ToString();
                    saltValue = sPasswordHashWithSalt.Split('~')[1].ToString();
                }
                using (CompaniesSL objCompanySL = new CompaniesSL())
                {
                    objSelectedCompany = objCompanySL.getSingleCompanies(Common.Common.getSystemConnectionString(), objPwdMgmtModel.CompanyID);
                }
                //Check if the new password follows Password policy
                if (!bErrorOccurred)
                {
                    Common.Common objCommon = new Common.Common();
                    PasswordManagementDTO objPasswordManagementUserFromHashCodeDTO = new PasswordManagementDTO();

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objPasswordManagementUserFromHashCodeDTO = objUserInfoSL.GetUserFromHashCode(objSelectedCompany.CompanyConnectionString, objPwdMgmtModel.HashValue);
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objSelectedCompany.CompanyConnectionString, objPasswordManagementUserFromHashCodeDTO.UserInfoID);
                    }
                    bool isPasswordValid = objCommon.ValidatePassword(objSelectedCompany.CompanyConnectionString, objUserInfoDTO.LoginID, objPwdMgmtModel.NewPassword, NewPassword, objUserInfoDTO.UserInfoId, out i_ErrorMessage);
                    if (!isPasswordValid)
                    {
                        bErrorOccurred = true;
                    }
                }
                if (bErrorOccurred)
                {
                    //ModelState.AddModelError("Error", i_ErrorMessage);
                    if (objLoginUserDetails == null)
                        objLoginUserDetails = new LoginUserDetails();
                    objLoginUserDetails.ErrorMessage = i_ErrorMessage;
                    objLoginUserDetails.CompanyName = objPwdMgmtModel.CompanyID;
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                    PasswordConfigSL objPassConfigSL = new PasswordConfigSL();
                    PasswordConfigDTO objPassConfigDTO = new PasswordConfigDTO();
                    objPassConfigDTO = objPassConfigSL.GetPasswordConfigDetails(objSelectedCompany.CompanyConnectionString);
                    PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objPassConfigDTO, objPassConfigModel);
                    TempData["PasswordConfigModel"] = objPassConfigModel;
                    return RedirectToAction("SetPassword", "Account", new { code = objPwdMgmtModel.HashValue });
                    //return View("SetPassword", objPwdMgmtModel);
                }

                PasswordManagementDTO objPwdMgmtDTO = new PasswordManagementDTO();

                if (objLoginUserDetails == null)
                    objLoginUserDetails = new LoginUserDetails();
                if (objSelectedCompany == null)
                {
                    objLoginUserDetails.ErrorMessage = "Entered company is incorrect, please enter correct company and try again.";
                }
                else
                {
                    objPwdMgmtModel.NewPassword = NewPassword;
                    objPwdMgmtModel.ConfirmNewPassword = NewPassword;
                    objPwdMgmtModel.SaltValue = saltValue;
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objPwdMgmtModel, objPwdMgmtDTO);
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objPwdMgmtDTO.UserInfoID = objUserInfoDTO.UserInfoId;
                        objUserInfoSL.ChangePassword(objSelectedCompany.CompanyConnectionString, ref objPwdMgmtDTO);
                    }
                    //InsiderTradingDAL.UserInfoDTO objUserInfo = objUserInfoSL.GetUserDetails(objSelectedCompany.CompanyConnectionString, objPwdMgmtDTO.UserInfoID);
                    objLoginUserDetails.SuccessMessage = Common.Common.getResourceForGivenCompany("usr_msg_11271", objSelectedCompany.sCompanyDatabaseName);
                }


                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                return RedirectToAction("Login", "Account");
                //return RedirectToAction("Index", "Home", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD) });
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResourceForGivenCompany(exp.InnerException.Data[0].ToString(), objSelectedCompany.sCompanyDatabaseName);
                if (objLoginUserDetails == null)
                    objLoginUserDetails = new LoginUserDetails();
                objLoginUserDetails.ErrorMessage = sErrMessage;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                return RedirectToAction("Login", "Account");
                //ModelState.AddModelError("Error", sErrMessage);
                //return View("SetPassword", objPwdMgmtModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }

        }
        #endregion SetPassword

        public void DeleteCaptcha()
        {
            string CaptchaDirServerPath = string.Empty;
            string ActualText = string.Empty;
            if (Directory.Exists(CaptchaDirServerPath))
            {
                if (HttpContext.Session["CaptchaPathForgotPwd"] != null)
                {
                    string fileName = HttpContext.Session["CaptchaFileNameForgotPwd"].ToString();


                    string CaptchaDirPath = CaptchaDirServerPath + fileName;


                    if (!string.IsNullOrEmpty(CaptchaDirPath))
                    {
                        if ((System.IO.File.Exists(CaptchaDirPath)))
                        {
                            System.IO.File.Delete(CaptchaDirPath);
                        }
                    }

                }
            }
        }

        public void CaptchaValidation()
        {
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            string strServerPath = string.Empty;
            string ActualText = string.Empty;
            using (ImageGenrator generateImage = new ImageGenrator())
            {
                using (Image image = generateImage.DrawText(ref ActualText))
                {

                    strServerPath = ConfigurationManager.AppSettings["Document"].ToString() + @"captcha\";
                    if (!Directory.Exists(strServerPath))
                        Directory.CreateDirectory(strServerPath);
                    string captchaImage = Guid.NewGuid().ToString() + ".png";
                    image.Save(strServerPath + captchaImage, ImageFormat.Png);

                    HttpContext.Session["CaptchaValueForgotPwd"] = ActualText;

                    string strImagePath = string.Empty;
                    strImagePath = strServerPath;
                    strImagePath = HttpRuntime.AppDomainAppVirtualPath.ToString().ToUpper() + "" + strImagePath.Substring(strImagePath.IndexOf("Document")).Replace("\\", "/");
                    string ImagePath = strImagePath + captchaImage;

                    //string ImagePath = strServerPath + captchaImage;

                    HttpContext.Session["CaptchaPathForgotPwd"] = ImagePath;
                    HttpContext.Session["CaptchaFileNameForgotPwd"] = captchaImage;
                }


                string CaptchaDirServerPath = string.Empty;
                CaptchaDirServerPath = strServerPath;
                HttpContext.Session["SerCaptchaPathForgotPwd"] = CaptchaDirServerPath;


                objLoginUserDetails = new LoginUserDetails();
                objLoginUserDetails.IsAccountValidated = false;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                //filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", "Login" } });

            }

        }


        #region Cancel
        [HttpPost]
        [ValidateAntiForgeryToken]
        [AllowAnonymous]
        [Button(ButtonName = "Cancel")]
        [ActionName("ForgetPassword")]
        public ActionResult Cancel()
        {

            return RedirectToAction("Login", "Account");

        }
        #endregion Cancel

        #region Helpers

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

        // Used for XSRF protection when adding external logins
        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        public enum ManageMessageId
        {
            ChangePasswordSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
            Error
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }

        #endregion

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