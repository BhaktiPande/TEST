using Fluentx.Mvc;
using InsiderTradingDAL;
using InsiderTradingEncryption;
using InsiderTradingSSO.Common;
using InsiderTradingSSO.Models;
using InsiderTradingSSO.SL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.Configuration;
using System.Web.Mvc;

namespace InsiderTradingSSO.Controllers
{
    public class HomeController : Controller
    {
        CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

        public ActionResult Index()
        {
            LoginUserDetails objLoginUserDetails = null;
            SSOSL objSSOSL = null;
            UserInfoDTO ObjuserDTO = null;
            CompanyDTO objSelectedCompany = null;
            DataSecurity objDataSecurity = null;
            UserPrincipal userPrincipal = null;
            string s_debugInfo = string.Empty;
            string PrompSSOCredentials = "1";
            try
            {
                if (PrompSSOCredentials == (ConfigurationManager.AppSettings["PromptSSOCredentials"].ToString()))
                {
                    Dictionary<string, string> objCompaniesDictionary = null;
                    List<InsiderTradingDAL.CompanyDTO> lstCompanies = null;
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        lstCompanies = objCompaniesSL.getAllCompanies(Common.Common.getSystemConnectionString());

                        objCompaniesDictionary = new Dictionary<string, string>();

                        objCompaniesDictionary.Add("", "Select Company");

                        foreach (InsiderTradingDAL.CompanyDTO objCompanyDTO in lstCompanies)
                        {
                            objCompaniesDictionary.Add(objCompanyDTO.sCompanyDatabaseName, objCompanyDTO.sCompanyName);
                        }
                    }
                    ViewBag.JavascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;
                    ViewBag.CompaniesDropDown = objCompaniesDictionary;
                    return View("SSOLogin");
                    //return View("AuthenticationFailed");
                }
                else
                {
                    //Login with Directory Credentials
                    using (DirectoryEntry dirEntry = new DirectoryEntry("WinNT://" + Environment.UserDomainName))
                    {
                        string s_CurrentLoggedInUser = Request.ServerVariables["LOGON_USER"].ToUpper();
                        s_debugInfo = "# Domain Name - " + Environment.UserDomainName + "# Request Server Variables (LOGON_USER) - " + s_CurrentLoggedInUser;

                        if (string.IsNullOrEmpty(s_CurrentLoggedInUser))
                        {
                            s_CurrentLoggedInUser = System.Web.HttpContext.Current.User.Identity.Name;
                            s_debugInfo += "# System.Web.HttpContext.Current.User.Identity.Name - " + s_CurrentLoggedInUser;
                        }

                        if (string.IsNullOrEmpty(s_CurrentLoggedInUser))
                        {
                            s_CurrentLoggedInUser = User.Identity.Name;
                            s_debugInfo += "# User.Identity.Name - " + User.Identity.Name;
                        }

                        foreach (DirectoryEntry item in dirEntry.Children)
                        {
                            using (PrincipalContext ctx = new PrincipalContext(ContextType.Domain))
                            {
                                userPrincipal = UserPrincipal.FindByIdentity(ctx, Request.ServerVariables["LOGON_USER"].Replace(Environment.UserDomainName + @"\", string.Empty));

                                if (userPrincipal != null)
                                {
                                    if (s_CurrentLoggedInUser.Equals((Environment.UserDomainName + @"\" + userPrincipal.SamAccountName).ToUpper()))
                                    {
                                        s_debugInfo += "# User Principal Given Name - " + userPrincipal.GivenName + "# User Principal EmployeeId - " + userPrincipal.EmployeeId + "# User Principal EmailAddress - " + userPrincipal.EmailAddress;

                                        using (objSSOSL = new SSOSL())
                                        {
                                            objLoginUserDetails = new LoginUserDetails();
                                            objSelectedCompany = new CompanyDTO();

                                            objSelectedCompany = objSSOSL.getSingleCompanies(InsiderTradingSSO.Common.Common.getSystemConnectionString(), ConfigurationManager.AppSettings["DBName"].ToString());
                                            objLoginUserDetails.CompanyDBConnectionString = objSelectedCompany.CompanyConnectionString;

                                            Hashtable ht_Param = new Hashtable();

                                            if (userPrincipal.EmployeeId != null && !userPrincipal.EmployeeId.Length.Equals(0))
                                                ht_Param.Add("EmployeeId", userPrincipal.EmployeeId);
                                            else
                                                ht_Param.Add("EmailId", userPrincipal.EmailAddress);

                                            ObjuserDTO = objSSOSL.LoginSSOUserInfo(objLoginUserDetails.CompanyDBConnectionString, ht_Param);

                                            objDataSecurity = new DataSecurity();

                                            Dictionary<string, object> dictUserDetails = new Dictionary<string, object>();
                                            dictUserDetails.Add("sUserName", ObjuserDTO.LoginID);
                                            dictUserDetails.Add("sPassword", ObjuserDTO.Password);
                                            dictUserDetails.Add("sCompanyName", objSelectedCompany.sCompanyDatabaseName);
                                            dictUserDetails.Add("sCalledFrom", objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), Common.ConstEnum.User_Password_Encryption_Key));

                                            return this.RedirectAndPost(ConfigurationManager.AppSettings["VigilanteURL"].ToString(), dictUserDetails);
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
            catch
            {
                s_debugInfo += "# Login Failed. ";
                return View("AuthenticationFailed");
            }
            finally
            {
                if (compilationSection.Debug)
                {
                    if (!Directory.Exists(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs")))
                        Directory.CreateDirectory(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs"));

                    using (FileStream filestream = new FileStream(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/SSODebugLogs.txt"), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter sWriter = new StreamWriter(filestream);

                        sWriter.WriteLine(" SSO Login - " + DateTime.Now);
                        string[] arr_debugInfo = s_debugInfo.Split('#');
                        foreach (string debugInfo in arr_debugInfo)
                        {
                            sWriter.WriteLine(debugInfo);
                        }

                        sWriter.WriteLine("--------------------------------------------------------------------");
                        sWriter.Close();
                        sWriter.Dispose();
                        filestream.Close();
                        filestream.Dispose();
                    }
                }
            }

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(UserDetailsModel model)
        {
            UserPrincipal userPrincipal = null;
            CompanyDTO objSelectedCompany = null;
            InsiderTradingEncryption.DataSecurity objPwdHash = null;
            string dominName = string.Empty;
            string adPath = string.Empty;
            string strError = string.Empty;
            string s_debugInfo = string.Empty;
            Dictionary<string, object> DictDetails = new Dictionary<string, object>();

            try
            {
                if (!ModelState.IsValid)
                {
                    string formUsername = model.sUserName;
                    string formPassword = model.sPassword;
                    string sPasswordHash = string.Empty;
                    string javascriptEncryptionKey = Common.ConstEnum.Javascript_Encryption_Key;
                    string userPasswordHashSalt = Common.ConstEnum.User_Password_Encryption_Key;

                    foreach (string key in ConfigurationManager.AppSettings.Keys)
                    {
                        dominName = key.Contains("DirectoryDomain") ? ConfigurationManager.AppSettings[key] : dominName;

                        adPath = key.Contains("DirectoryPath") ? ConfigurationManager.AppSettings[key] : adPath;

                        if (!String.IsNullOrEmpty(dominName) && !String.IsNullOrEmpty(adPath))
                        {
                            if (compilationSection.Debug)
                            {
                                Common.Common.WriteLogToFile("DominName & adPath read successfully ", null);
                            }

                            using (AuthenticateUserModel AuthenticateUserModel = new AuthenticateUserModel())
                            {
                                formUsername = DecryptStringAES(formUsername, javascriptEncryptionKey, javascriptEncryptionKey);
                                formPassword = DecryptStringAES(formPassword, javascriptEncryptionKey, javascriptEncryptionKey);

                                objPwdHash = new InsiderTradingEncryption.DataSecurity();

                                sPasswordHash = objPwdHash.CreateHash(formPassword, userPasswordHashSalt);

                                if (compilationSection.Debug)
                                {
                                    Common.Common.WriteLogToFile("Created Hash successfully ", null);
                                }

                                AuthenticateUserModel.AuthenticateUser(dominName, formUsername, formPassword, adPath, out strError, out DictDetails);
                                { 
                                    if (DictDetails.Count != 0)
                                    {
                                        return this.RedirectAndPost(ConfigurationManager.AppSettings["VigilanteURL"].ToString(), DictDetails);
                                    }
                                    else
                                    {
                                        return View("AuthenticationFailed");
                                    }
                                }
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(strError))
                    {
                        //lblError.Text = "Invalid user name or Password!";  
                        if (compilationSection.Debug)
                        {
                            Common.Common.WriteLogToFile("Invalid user name or Password!", null);
                        }
                        return View("AuthenticationFailed");
                    }
                }
            }
            catch (Exception ex)
            {
                if (compilationSection.Debug)
                {
                    Common.Common.WriteLogToFile("Exception occured in Index method", ex);
                }
                return View("AuthenticationFailed");
            }
            finally
            {
            }
            return null;
        }

        #region Decrypting the encrypted from Javascript using AES algorithem
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
            return string.Format(decriptedFromJavascript);
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
        #endregion
    }
}
