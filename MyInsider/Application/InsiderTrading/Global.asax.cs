using InsiderTrading.Common;
using InsiderTrading.Controllers;
using InsiderTrading.SL;
using InsiderTradingEncryption;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace InsiderTrading
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            System.Security.Cryptography.CryptoConfig.AddAlgorithm(typeof(System.Deployment.Internal.CodeSigning.RSAPKCS1SHA256SignatureDescription), "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256");

            MvcHandler.DisableMvcResponseHeader = true;
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            ModelMetadataProviders.Current = new Mvc2Templates.Providers.CustomModelMetadataProvider();
            System.Globalization.CultureInfo.DefaultThreadCurrentCulture = new System.Globalization.CultureInfo("en-IN");
            //  ModelBinders.Binders.Add(typeof(decimal), new DecimalModelBinder());
            //   ModelBinders.Binders.Add(typeof(decimal?), new DecimalModelBinder());
            /*
             * Update the resources for all the companies available in the master when starting the application so that 
             * resources will be available to be used.
             */
            CompaniesSL objCompaniesSL = new CompaniesSL();
            List<InsiderTradingDAL.CompanyDTO> lstCompaniesDTO = objCompaniesSL.getAllCompanies(Common.Common.getSystemConnectionString());

            foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompaniesDTO)
            {
                Common.Common.UpdateCompanyResources(objCompanyDTO.CompanyConnectionString, objCompanyDTO.sCompanyDatabaseName);
            }
            // ModelBinders.Binders.DefaultBinder = new DecimalModelBinder();

            ModelBinders.Binders.Add(typeof(int), new DecimalModelBinder());
            ModelBinders.Binders.Add(typeof(long), new DecimalModelBinder());
            ModelBinders.Binders.Add(typeof(int?), new DecimalModelBinder());
            ModelBinders.Binders.Add(typeof(long?), new DecimalModelBinder());
            ModelBinders.Binders.Add(typeof(decimal), new DecimalModelBinderNew());
            ModelBinders.Binders.Add(typeof(decimal?), new DecimalModelBinderNew());

        }

        protected void Application_Error()
        {
            Common.Common.WriteLogToFile("Start method", System.Reflection.MethodBase.GetCurrentMethod());

            Response.TrySkipIisCustomErrors = true;
            Response.StatusCode = 404;

            Exception exception = Server.GetLastError();
            var httpException = exception as HttpException;

            Common.Common.WriteLogToFile("server exception ", System.Reflection.MethodBase.GetCurrentMethod(), exception);

            Server.ClearError();

            RouteData routeData = new RouteData();

            routeData.Values.Add("controller", "Error");

            if (httpException == null)
            {
                if (exception.Message.ToLower().Contains("did not return a controller for the name"))
                {
                    routeData.Values.Add("action", "HttpError404");
                }
                else
                {
                    routeData.Values.Add("action", "Index");
                }
            }
            else //It's an Http Exception, Let's handle it.
            {

                switch (httpException.GetHttpCode())
                {
                    case 404:
                        // Page not found.                        
                        routeData.Values.Add("action", "HttpError404");
                        routeData.Values.Add("statusCode", 404);
                        break;
                    case 505:
                        // Server error.                        
                        routeData.Values.Add("action", "HttpError505");
                        routeData.Values.Add("statusCode", 505);
                        break;
                    case 401:
                        // Page not found.                        
                        routeData.Values.Add("action", "HttpError401");
                        routeData.Values.Add("statusCode", 401);
                        break;
                    // Here you can handle Views to other error codes.
                    // I choose a General error template  
                    default:
                        routeData.Values.Add("action", "Index");
                        routeData.Values.Add("statusCode", 404);
                        break;
                }
            }

            Common.Common.WriteLogToFile("exception status code return as " + routeData.Values["statusCode"], System.Reflection.MethodBase.GetCurrentMethod());

            IController errorController = new ErrorController();
            errorController.Execute(new RequestContext(new HttpContextWrapper(Context), routeData));

            Common.Common.WriteLogToFile("End method", System.Reflection.MethodBase.GetCurrentMethod());

            Response.End();
        }

        void Application_BeginRequest(object sender, EventArgs e)
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            //Added parameters in header for security
            HttpContext.Current.Response.AddHeader("x-frame-options", "SAMEORIGIN");
            //Set this value to 90 days in seconds
            HttpContext.Current.Response.AddHeader("Strict-Transport-Security", "max-age=7776000");
            //To avoid Cross site scripting
            HttpContext.Current.Response.AddHeader("X-Content-Type-Options", "nosniff");
            HttpContext.Current.Response.AddHeader("X-XSS-Protection", "1;mode=block");

            //Remove the extra information send in Response Header
            HttpContext.Current.Response.Headers.Remove("Server");
            HttpContext.Current.Response.Headers.Remove("X-AspNetMvc-Version");
            HttpContext.Current.Response.Headers.Remove("X-AspNet-Version");

            //Set the paramter for not cashing the data on client side
            //HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            #region Changes for Rewriting the Request URL with encrypted query string
            //Add URL encoding only in Release mode
            if (!HttpContext.Current.IsDebuggingEnabled)
            {
                HttpContext context = HttpContext.Current;
                var objContextWrapper = new HttpContextWrapper(Context);
                InsiderTrading.Common.Common objCommon = new InsiderTrading.Common.Common();
                if (!objContextWrapper.Request.IsAjaxRequest())
                {
                    Common.Common.WriteLogToFile("Ajax request condition", System.Reflection.MethodBase.GetCurrentMethod());

                    if (context.Request.RawUrl.Contains("?"))
                    {
                        string query = ExtractQuery(context.Request.RawUrl);
                        string path = GetVirtualPath();
                        DataSecurity objDataSecurity = new DataSecurity();
                        string sStartStringPart = query.Substring(0, 3);

                        Common.Common.WriteLogToFile("Raw url content ? ", System.Reflection.MethodBase.GetCurrentMethod());

                        if (objCommon.CheckIfStringIsCorrect(sStartStringPart))
                        {
                            // Decrypts the query string and rewrites the path.
                            string rawQuery = query.Replace(sStartStringPart, string.Empty);
                            string decryptedQuery = "";
                            try
                            {
                                decryptedQuery = objDataSecurity.DecryptData(HttpUtility.UrlDecode(rawQuery));
                            }
                            catch (Exception exp)
                            {
                                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                            }
                            context.RewritePath(path, string.Empty, decryptedQuery);
                        }
                        else if (context.Request.HttpMethod == "GET")
                        {
                            if (context.Request.RawUrl.Contains("elmah.axd") == false)
                            {
                                // Encrypt the query string and redirects to the encrypted URL.
                                // Remove if you don't want all query strings to be encrypted automatically.
                                string encryptedQuery = "";
                                string sStartString = objCommon.getRandomString();
                                try
                                {
                                    encryptedQuery = "?" + sStartString + HttpUtility.UrlEncode(objDataSecurity.EncryptData(query));
                                }
                                catch (Exception exp)
                                {
                                    Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                                }
                                context.Response.Redirect(path + encryptedQuery, false);
                            }
                        }
                    }
                }
                else
                {
                    Common.Common.WriteLogToFile("HTTP request condition", System.Reflection.MethodBase.GetCurrentMethod());

                    if (context.Request.RawUrl.Contains("?"))
                    {
                        string query = ExtractQuery(context.Request.RawUrl);
                        string path = GetVirtualPath();
                        DataSecurity objDataSecurity = new DataSecurity();
                        string sStartStringPart = query.Substring(0, 3);

                        Common.Common.WriteLogToFile("Raw url content ? ", System.Reflection.MethodBase.GetCurrentMethod());

                        if (objCommon.CheckIfStringIsCorrect(sStartStringPart))
                        {
                            // Decrypts the query string and rewrites the path.
                            string rawQuery = query.Replace(sStartStringPart, string.Empty);
                            string decryptedQuery = "";
                            try
                            {
                                decryptedQuery = objDataSecurity.DecryptData(HttpUtility.UrlDecode(rawQuery));
                            }
                            catch (Exception exp)
                            {
                                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                            }
                            context.RewritePath(path, string.Empty, decryptedQuery);
                        }
                    }
                }
            }
            #endregion Changes for Rewriting the Request URL with encrypted query string

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
        }

        #region Methods for Encrypt Decrypt Query String
        /// <summary>
        /// Parses the current URL and extracts the virtual path without query string.
        /// </summary>
        /// <returns>The virtual path of the current URL.</returns>
        private static string GetVirtualPath()
        {
            string path = HttpContext.Current.Request.RawUrl;
            path = path.Substring(0, path.IndexOf("?"));
            path = path.Substring(path.LastIndexOf("/") + 1);
            return path;
        }

        /// <summary>
        /// Parses a URL and returns the query string.
        /// </summary>
        /// <param name="url">The URL to parse.</param>
        /// <returns>The query string without the question mark.</returns>
        private static string ExtractQuery(string url)
        {
            int index = url.IndexOf("?") + 1;
            return url.Substring(index);
        }
        #endregion Methods for Encrypt Decrypt Query String

        protected void Application_EndRequest()
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            var context = new HttpContextWrapper(Context);

            // If we're an ajax request, and doing a 302, then we actually need to do a 401                  
            //This is to handle the ajax request when session time out occurs
            if (Context.Response.StatusCode == 302 && context.Request.IsAjaxRequest())
            {
                Context.Response.Clear(); Context.Response.StatusCode = 401;
            }

            // for the cookies created/modified during request, set path for other cookies, if any
            if (Response.Cookies.Count > 0)
            {
                foreach (string cookies_name in Response.Cookies.AllKeys)
                {
                    if (cookies_name != ConstEnum.CookiesValue.ValidationCookies)
                    {
                        Response.Cookies[cookies_name].Path = Request.ApplicationPath;
                        Response.Cookies[cookies_name].Secure = ((HttpCookiesSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/httpCookies")).RequireSSL;
                    }
                }

                Common.Common.WriteLogToFile("Application path set for cookies ", System.Reflection.MethodBase.GetCurrentMethod());
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            //Clear browser cache
            //Response.Cache.SetNoStore();
            //Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            //add session variable on session start
            HttpContext.Current.Session.Add(ConstEnum.SessionValue.UserDetails, null);
            HttpContext.Current.Session.Add(ConstEnum.SessionValue.SessionValidationKey, "");
            HttpContext.Current.Session.Add(ConstEnum.SessionValue.CookiesValidationKey, "");



            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            bool _isInvalid_Request_Session = true;
            bool _isInvalid_Request_Cookies = true;

            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            try
            {
                if (HttpContext.Current.Request.Form["sUserName"] != null)
                    if (Convert.ToString(Session["sUserName"]).Equals(string.Empty) && HttpContext.Current.Request.Form["sUserName"] != Session["sUserName"])
                        Session["sUserName"] = HttpContext.Current.Request.Form["sUserName"];

                //check if there is session
                if (HttpContext.Current.Session != null)
                {
                    //check if current session is new or not 
                    if (HttpContext.Current.Session.IsNewSession)
                    {

                        Common.Common.WriteLogToFile("New session start - clear session", System.Reflection.MethodBase.GetCurrentMethod());

                        //check if current request is for login page or not - in case current request is for any other page redirect to login page
                        if (Request.RawUrl.ToString() != "/" && Request.RawUrl.ToLower().ToString().Contains("account/") == false)
                        {
                            // clear and remove all session variable
                            Session.Clear();
                            Session.RemoveAll();

                            if (!Request.RawUrl.ToString().Contains("SSO"))
                                Response.Redirect("~/account/login", false);
                        }
                    }
                    else // code for existing session 
                    {
                        //check if user is login and authorise user
                        if (Session[ConstEnum.SessionValue.UserDetails] != null)
                        {
                            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Session[ConstEnum.SessionValue.UserDetails];

                            var context = new HttpContextWrapper(Context);


                            #region Third Level of validation
                            using (SessionManagement sessionManagement = new SessionManagement())
                            {
                                if (Session["GUIDSessionID"] != null)
                                {
                                    if (Session["IsOTPAuthPage"] == null)
                                        sessionManagement.CheckCookiesSessions((LoginUserDetails)HttpContext.Current.Session[ConstEnum.SessionValue.UserDetails], false, Request, Response, string.Empty);
                                }
                            }
                            #endregion Third Level of validation


                            //check valid user is already login
                            if (objLoginUserDetails.IsAccountValidated)
                            {
                                Common.Common.WriteLogToFile("Valid user is login - session and cookies validation done next", System.Reflection.MethodBase.GetCurrentMethod());

                                #region Validate Session

                                string _sessionBrowserInfo = string.Empty;
                                string _sessionBrowserPlatform = string.Empty;
                                string _sessionBrowserMajorVersion = string.Empty;
                                string _sessionBrowserMinorVersion = string.Empty;
                                string _sessionIPAddress = string.Empty;
                                string _session_Value = string.Empty;

                                string _encryptedString = "";

                                Common.Common.WriteLogToFile("HttpContext.Current.Session started");
                                Common.Common.WriteLogToFile("HttpContext.Current != null - " + Convert.ToString(HttpContext.Current != null));
                                Common.Common.WriteLogToFile("HttpContext.Current.Session != null - " + Convert.ToString(HttpContext.Current.Session != null));
                                Common.Common.WriteLogToFile("HttpContext.Current.Session.Count " + HttpContext.Current.Session.Count);
                                _encryptedString = Convert.ToString(HttpContext.Current.Session[ConstEnum.SessionValue.SessionValidationKey]);
                                Common.Common.WriteLogToFile("_encryptedString:" + _encryptedString, System.Reflection.MethodBase.GetCurrentMethod());
                                byte[] _encodeAsByte = System.Convert.FromBase64String(_encryptedString);
                                string _decryptedString = System.Text.ASCIIEncoding.ASCII.GetString(_encodeAsByte);

                                char[] _separator = new char[] { '^' };
                                if (_decryptedString != string.Empty && _decryptedString != "" && _decryptedString != null)
                                {
                                    string[] _splitStrings = _decryptedString.Split(_separator);
                                    if (_splitStrings.Count() > 0)
                                    {
                                        _session_Value = _splitStrings[0];
                                        string Tricks = _splitStrings[1];
                                        string dummyGuid = _splitStrings[3];

                                        if (_splitStrings[2].Count() > 0)
                                        {
                                            string[] _userBrowserInfo = _splitStrings[2].Split('~');
                                            if (_userBrowserInfo.Count() > 0)
                                            {
                                                _sessionBrowserInfo = _userBrowserInfo[0];
                                                _sessionBrowserPlatform = _userBrowserInfo[1];
                                                _sessionBrowserMajorVersion = _userBrowserInfo[2];
                                                _sessionBrowserMinorVersion = _userBrowserInfo[3];
                                                _sessionIPAddress = _userBrowserInfo[4];
                                            }
                                        }
                                    }
                                }

                                string _currentUserIPAddress;
                                if (string.IsNullOrEmpty(Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
                                {
                                    _currentUserIPAddress = string.IsNullOrEmpty(Request.UserHostAddress) ? Request.ServerVariables["REMOTE_ADDR"] : Request.UserHostAddress;
                                }
                                else
                                {
                                    _currentUserIPAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();
                                }
                                System.Net.IPAddress result;
                                if (!System.Net.IPAddress.TryParse(_currentUserIPAddress, out result))
                                {
                                    result = System.Net.IPAddress.None;
                                }
                                Common.Common.WriteLogToFile("_session_Value:" + _session_Value, System.Reflection.MethodBase.GetCurrentMethod());
                                Common.Common.WriteLogToFile("_sessionIPAddress:" + _sessionIPAddress, System.Reflection.MethodBase.GetCurrentMethod());
                                Common.Common.WriteLogToFile("_sessionBrowserPlatform:" + _sessionBrowserPlatform, System.Reflection.MethodBase.GetCurrentMethod());
                                Common.Common.WriteLogToFile("_sessionBrowserMajorVersion:" + _sessionBrowserMajorVersion, System.Reflection.MethodBase.GetCurrentMethod());
                                Common.Common.WriteLogToFile("_sessionBrowserMinorVersion:" + _sessionBrowserMinorVersion, System.Reflection.MethodBase.GetCurrentMethod());
                                Common.Common.WriteLogToFile("_sessionBrowserInfo:" + _sessionBrowserInfo, System.Reflection.MethodBase.GetCurrentMethod());

                                if (_session_Value != "" && _session_Value != string.Empty
                                        && _sessionIPAddress != "" && _sessionIPAddress != string.Empty
                                        && _sessionBrowserPlatform != "" && _sessionBrowserPlatform != string.Empty
                                        && _sessionBrowserMajorVersion != "" && _sessionBrowserMajorVersion != string.Empty
                                        && _sessionBrowserMinorVersion != "" && _sessionBrowserMinorVersion != string.Empty
                                        && _sessionBrowserInfo != "" && _sessionBrowserInfo != string.Empty)
                                {
                                    string _currentBrowserInfo = Request.Browser.Browser + Request.Browser.Version + Request.UserAgent;
                                    string _currentBrowserPlatform = Request.Browser.Platform;
                                    string _currentBrowserMajorVersion = Request.Browser.MajorVersion.ToString();
                                    string _currentBrowserMinorVersion = Request.Browser.MinorVersion.ToString();
                                    string _current_Value = (Session[ConstEnum.SessionValue.UserDetails] == null) ? ConstEnum.SessionAndCookiesKeyBeforeLogin : objLoginUserDetails.UserName;

                                    #region to fix Reverse routing issue.
                                    if (_sessionIPAddress.IndexOf(':') > 0)
                                        _sessionIPAddress = _sessionIPAddress.Substring(0, _sessionIPAddress.IndexOf(':'));

                                    if (_currentUserIPAddress.IndexOf(':') > 0)
                                        _currentUserIPAddress = _currentUserIPAddress.Substring(0, _currentUserIPAddress.IndexOf(':'));
                                    #endregion

                                    // check value, ip address, browser platform, major version, minor version and broswer platform                                    
                                    //if (objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME_IGNORE_IP))
                                    //{
                                    if (_session_Value == _current_Value && _sessionBrowserPlatform == _currentBrowserPlatform
                                            && _sessionBrowserMajorVersion == _currentBrowserMajorVersion && _sessionBrowserMinorVersion == _currentBrowserMinorVersion
                                            && _sessionBrowserInfo == _currentBrowserInfo)
                                    {
                                        //valid user so no action 
                                        _isInvalid_Request_Session = false;
                                    }
                                    //}
                                    //else
                                    //{
                                    //    if (_session_Value == _current_Value && _sessionIPAddress == _currentUserIPAddress && _sessionBrowserPlatform == _currentBrowserPlatform
                                    //            && _sessionBrowserMajorVersion == _currentBrowserMajorVersion && _sessionBrowserMinorVersion == _currentBrowserMinorVersion
                                    //            && _sessionBrowserInfo == _currentBrowserInfo)
                                    //    {
                                    //        //valid user so no action 
                                    //        _isInvalid_Request_Session = false;
                                    //    }
                                    //}


                                    string sSLogVal = " Session: Value=" + _session_Value + " IP Address= " + _sessionIPAddress
                                                        + " Browser Platform+=" + _sessionBrowserPlatform + " Browser Major Version"
                                                        + _sessionBrowserMajorVersion + " Browser Minor Version" + _sessionBrowserMinorVersion
                                                        + " BrowserInfoBrowserInfo " + _sessionBrowserInfo;

                                    string sSLogVal2 = " Compare: Value=" + _current_Value + " IP Address= " + _currentUserIPAddress
                                                        + " Browser Platform+=" + _currentBrowserPlatform + " Browser Major Version"
                                                        + _currentBrowserMajorVersion + " Browser Minor Version" + _currentBrowserMinorVersion
                                                        + " BrowserInfoBrowserInfo " + _currentBrowserInfo;

                                    Common.Common.WriteLogToFile("Session details: " + sSLogVal + sSLogVal2, System.Reflection.MethodBase.GetCurrentMethod());
                                }

                                #endregion Validate Session

                                #region Validate Cookies

                                string _sessionCookiesBrowserInfo = string.Empty;
                                string _sessionCookiesBrowserPlatform = string.Empty;
                                string _sessionCookiesBrowserMajorVersion = string.Empty;
                                string _sessionCookiesBrowserMinorVersion = string.Empty;
                                string _sessionCookiesIPAddress = string.Empty;
                                string _sessionCookies_Value = string.Empty;

                                string _sessionCookiesEncryptedKey = _sessionCookiesEncryptedKey = Convert.ToString(HttpContext.Current.Session[ConstEnum.SessionValue.CookiesValidationKey]);

                                string _decryptedCookiesKey = "";

                                Common.Common.dencryptData(_sessionCookiesEncryptedKey, out _decryptedCookiesKey);

                                char[] _cookies_separator = new char[] { '^' };
                                if (_decryptedCookiesKey != string.Empty && _decryptedCookiesKey != "" && _decryptedCookiesKey != null)
                                {
                                    string[] _splitCookiesKey = _decryptedCookiesKey.Split(_cookies_separator);
                                    if (_splitCookiesKey.Count() > 0)
                                    {
                                        _sessionCookies_Value = _splitCookiesKey[0];
                                        string Tricks = _splitCookiesKey[1];
                                        string dummyGuid = _splitCookiesKey[3];

                                        if (_splitCookiesKey[2].Count() > 0)
                                        {
                                            string[] _cookies_UserBrowserInfo = _splitCookiesKey[2].Split('~');
                                            if (_cookies_UserBrowserInfo.Count() > 0)
                                            {
                                                _sessionCookiesBrowserInfo = _cookies_UserBrowserInfo[0];
                                                _sessionCookiesBrowserPlatform = _cookies_UserBrowserInfo[1];
                                                _sessionCookiesBrowserMajorVersion = _cookies_UserBrowserInfo[2];
                                                _sessionCookiesBrowserMinorVersion = _cookies_UserBrowserInfo[3];
                                                _sessionCookiesIPAddress = _cookies_UserBrowserInfo[4];
                                            }
                                        }
                                    }
                                }

                                string _currentCookiesUserIPAddress = string.Empty;
                                string _currentCookiesBrowserInfo = string.Empty;
                                string _currentCookiesBrowserPlatform = string.Empty;
                                string _currentCookiesBrowserMajorVersion = string.Empty;
                                string _currentCookiesBrowserMinorVersion = string.Empty;
                                string _currentCookies_Value = string.Empty;

                                if (Request.Cookies[ConstEnum.CookiesValue.ValidationCookies] != null)
                                {
                                    string _CookiesEncryptedKey = string.Empty;

                                    _CookiesEncryptedKey = Request.Cookies[ConstEnum.CookiesValue.ValidationCookies].Value;

                                    string _decryptedCookiesString = "";

                                    Common.Common.dencryptData(_CookiesEncryptedKey, out _decryptedCookiesString);

                                    string _UserIPAddress = (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"])) ?
                                            (string.IsNullOrEmpty(HttpContext.Current.Request.UserHostAddress) ?
                                                HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] : HttpContext.Current.Request.UserHostAddress) :
                                        HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();

                                    string _browserInfo = HttpContext.Current.Request.Browser.Browser + HttpContext.Current.Request.Browser.Version + HttpContext.Current.Request.UserAgent
                                    + "~" + HttpContext.Current.Request.Browser.Platform
                                    + "~" + HttpContext.Current.Request.Browser.MajorVersion
                                    + "~" + HttpContext.Current.Request.Browser.MinorVersion
                                    + "~" + _UserIPAddress;

                                    //set common string used for validation
                                    string _session_cookies_common_value = _sessionCookies_Value + "^" + DateTime.Now.Ticks + "^" + _browserInfo + "^" + System.Guid.NewGuid();
                                    _decryptedCookiesString = _session_cookies_common_value + "^" + _decryptedCookiesString + '~' + DateTime.Now.DayOfWeek.ToString().ToUpper();
                                    if (_decryptedCookiesString != string.Empty && _decryptedCookiesString != "" && _decryptedCookiesString != null)
                                    {
                                        string[] _splitCookiesString = _decryptedCookiesString.Split(_cookies_separator);
                                        if (_splitCookiesString.Count() > 0)
                                        {
                                            _currentCookies_Value = _splitCookiesString[0];
                                            string Tricks = _splitCookiesString[1];
                                            string dummyGuid = _splitCookiesString[3];

                                            if (_splitCookiesString[2].Count() > 0)
                                            {
                                                string[] _cookies_UserBrowserInfo = _splitCookiesString[2].Split('~');
                                                if (_cookies_UserBrowserInfo.Count() > 0)
                                                {
                                                    _currentCookiesBrowserInfo = _cookies_UserBrowserInfo[0];
                                                    _currentCookiesBrowserPlatform = _cookies_UserBrowserInfo[1];
                                                    _currentCookiesBrowserMajorVersion = _cookies_UserBrowserInfo[2];
                                                    _currentCookiesBrowserMinorVersion = _cookies_UserBrowserInfo[3];
                                                    _currentCookiesUserIPAddress = _cookies_UserBrowserInfo[4];
                                                }
                                            }
                                        }
                                    }
                                }

                                if (_sessionCookies_Value != "" && _sessionCookies_Value != string.Empty
                                        && _sessionCookiesIPAddress != "" && _sessionCookiesIPAddress != string.Empty
                                        && _sessionCookiesBrowserPlatform != "" && _sessionCookiesBrowserPlatform != string.Empty
                                        && _sessionCookiesBrowserMajorVersion != "" && _sessionCookiesBrowserMajorVersion != string.Empty
                                        && _sessionCookiesBrowserMinorVersion != "" && _sessionCookiesBrowserMinorVersion != string.Empty
                                        && _sessionCookiesBrowserInfo != "" && _sessionCookiesBrowserInfo != string.Empty)
                                {

                                    // check value, ip address, browser platform, major version, minor version and broswer platform                                    
                                    if (objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME_IGNORE_IP))
                                    {
                                        if (_sessionCookies_Value == _currentCookies_Value && _sessionCookiesBrowserInfo == _currentCookiesBrowserInfo
                                                && _sessionCookiesBrowserPlatform == _currentCookiesBrowserPlatform
                                                && _sessionCookiesBrowserMajorVersion == _currentCookiesBrowserMajorVersion
                                                && _sessionCookiesBrowserMinorVersion == _currentCookiesBrowserMinorVersion)
                                        {
                                            //valid user so no action 
                                            _isInvalid_Request_Cookies = false;
                                        }
                                    }
                                    else
                                    {
                                        if (_sessionCookies_Value == _currentCookies_Value && _sessionCookiesBrowserInfo == _currentCookiesBrowserInfo
                                                && _sessionCookiesBrowserPlatform == _currentCookiesBrowserPlatform
                                                && _sessionCookiesBrowserMajorVersion == _currentCookiesBrowserMajorVersion
                                                && _sessionCookiesBrowserMinorVersion == _currentCookiesBrowserMinorVersion)
                                        {
                                            //valid user so no action 
                                            _isInvalid_Request_Cookies = false;
                                        }
                                    }


                                    string sCLogVal = " Cookies: Value=" + _sessionCookies_Value + " IP Address= " + _sessionCookiesIPAddress
                                                            + " Browser Platform+=" + _sessionCookiesBrowserPlatform + " Browser Major Version"
                                                            + _sessionCookiesBrowserMajorVersion + " Browser Minor Version" + _sessionCookiesBrowserMinorVersion
                                                            + " BrowserInfoBrowserInfo " + _sessionCookiesBrowserInfo;

                                    string sCLogVal2 = " Compare: Value=" + _currentCookies_Value + " IP Address= " + _currentCookiesUserIPAddress
                                                            + " Browser Platform+=" + _currentCookiesBrowserPlatform + " Browser Major Version"
                                                            + _currentCookiesBrowserMajorVersion + " Browser Minor Version" + _currentCookiesBrowserMinorVersion
                                                            + " BrowserInfoBrowserInfo " + _currentCookiesBrowserInfo;

                                    Common.Common.WriteLogToFile("Cookies Details: " + sCLogVal + sCLogVal2, System.Reflection.MethodBase.GetCurrentMethod());

                                }

                                #region Second level validation of cookies start

                                string s_CookieName = string.Empty;
                                foreach (var perCookie in Request.Cookies)
                                {
                                    if (Convert.ToString(perCookie).ToUpper().Contains("REQUESTVERIFICATIONTOKEN"))
                                    {
                                        s_CookieName = Server.HtmlEncode(Convert.ToString(perCookie));
                                        break;
                                    }
                                }

                                Common.Common.WriteLogToFile("Cookie name " + s_CookieName, System.Reflection.MethodBase.GetCurrentMethod());

                                if (Request.UrlReferrer == null || s_CookieName == "" || ((!Convert.ToString(Session[s_CookieName]).Equals(string.Empty)) && (Convert.ToString(Session["sUserName"]) + Session.SessionID + HttpContext.Current.Request.Cookies[s_CookieName].Value != Convert.ToString(Session[s_CookieName]))))
                                {
                                    if (HttpContext.Current.Session["formField"] == null)
                                    {
                                        Session.RemoveAll();
                                        Session.Abandon();
                                        Response.Redirect(ConfigurationManager.AppSettings["SSOURL"]);
                                    }
                                    else
                                    {
                                        Session.Add(s_CookieName, Convert.ToString(Session["sUserName"]) + Session.SessionID + HttpContext.Current.Request.Cookies[s_CookieName].Value);
                                    }
                                }
                                else if ((!Convert.ToString(Session["sUserName"]).Equals(string.Empty)) && Convert.ToString(Session[s_CookieName]).Equals(string.Empty))
                                    Session.Add(s_CookieName, Convert.ToString(Session["sUserName"]) + Session.SessionID + HttpContext.Current.Request.Cookies[s_CookieName].Value);

                                #endregion Second level validation of cookies end

                                #region Third Level of validation
                                using (SessionManagement sessionManagement = new SessionManagement())
                                {

                                    //Make chnages in the following function

                                    //sessionManagement.CheckCookiesSessions((LoginUserDetails)HttpContext.Current.Session[ConstEnum.SessionValue.UserDetails], false, Request, Response, string.Empty);
                                    sessionManagement.BindCookiesSessions((LoginUserDetails)HttpContext.Current.Session[ConstEnum.SessionValue.UserDetails], false, Request, Response, string.Empty);
                                }
                                #endregion Third Level of validation

                                #endregion Validate Cookies

                                if (Request.RawUrl.ToString() != "/" && Request.RawUrl.ToLower().ToString().Contains("account/login") == false)
                                {
                                    if (_isInvalid_Request_Session || _isInvalid_Request_Cookies)
                                    {
                                        string log_msg = (_isInvalid_Request_Session ? "Session validation fail " : "Session validation success") + " and "
                                                            + (_isInvalid_Request_Cookies ? "Cookies validation fail " : "Cookies validation success");
                                        Common.Common.WriteLogToFile(log_msg, System.Reflection.MethodBase.GetCurrentMethod());

                                        // clear and remove all session variable
                                        Session.Clear();
                                        Session.RemoveAll();

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

                                        Common.Common.WriteLogToFile("Clear session and Expired cookies", System.Reflection.MethodBase.GetCurrentMethod());

                                        if (context.Request.IsAjaxRequest())
                                        {
                                            Common.Common.WriteLogToFile("Ajax request set status code 401", System.Reflection.MethodBase.GetCurrentMethod());

                                            Context.Response.Clear();
                                            Context.Response.StatusCode = 401;
                                        }
                                        else
                                        {
                                            throw new HttpException(401, "Unauthorized access");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.ToString().Equals("Invalid Login"))
                {
                    using (SessionManagement sessionManagement = new SessionManagement())
                    {
                        //sessionManagement.CheckCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                        sessionManagement.BindCookiesSessions((LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails), false, (System.Web.HttpRequest)System.Web.HttpContext.Current.Request, (System.Web.HttpResponse)System.Web.HttpContext.Current.Response, "LOGOUT");
                    }
                }

                Common.Common.WriteLogToFile("Exception occurred " + ex.Message, System.Reflection.MethodBase.GetCurrentMethod(), ex);

                // in case of exception while validation redirect to login page

                if (Request.RawUrl.ToString() != "/" && Request.RawUrl.ToLower().ToString().Contains("account/login") == false)
                {
                    // clear and remove all session variable
                    Session.Clear();
                    Session.RemoveAll();

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
                    if (ex.Message.ToString().Contains("Your last session was terminated incorrectly or is still active"))
                    {
                        LoginUserDetails objLoginUserDetails1 = new LoginUserDetails();
                        objLoginUserDetails1.ErrorMessage = "Your last session was terminated incorrectly or is still active. We are logging you out from all active sessions. Please re-login after 2 minutes.";
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails1);
                        Response.Redirect("~/Account/Login");
                    }

                    Common.Common.WriteLogToFile("Exception - Clear session and Expired cookies", System.Reflection.MethodBase.GetCurrentMethod());

                    var context = new HttpContextWrapper(Context);
                    if (context.Request.IsAjaxRequest())
                    {
                        Common.Common.WriteLogToFile("Ajax request set status code 401", System.Reflection.MethodBase.GetCurrentMethod());

                        Context.Response.Clear();
                        Context.Response.StatusCode = 401;
                    }
                    else
                    {
                        throw new HttpException(401, "Unauthorized access");
                    }
                }

                Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

                if (ex.Message.ToString().Equals("Invalid Login"))
                    throw new HttpException(401, "Unauthorized access");
            }
        }
    }
}
