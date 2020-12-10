using InsiderTradingDAL;
using InsiderTradingEncryption;
using InsiderTradingSSO.Common;
using InsiderTradingSSO.SL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace InsiderTradingSSO.Models
{
    public class AuthenticateUserModel : IDisposable
    {
        CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

        #region
        /// <summary>
        /// AuthenticateUser
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <param name="LdapPath"></param>
        /// <param name="Errmsg"></param>
        /// <returns></returns>
        public Dictionary<string, object> AuthenticateUser(string domain, string username, string password, string LdapPath, out string Errmsg, out Dictionary<string, object> DictDetails)
        {
            CompanyDTO objSelectedCompany = null;            
            UserInfoDTO ObjuserDTO = null;
            UserPrincipal userPrincipal = null;            
            Errmsg = "";
            string domainAndUsername = domain + @"\" + username;
            DirectoryEntry entry = new DirectoryEntry(LdapPath, domainAndUsername, password);            
            DictDetails = new Dictionary<string, object>();

            try
            {
                using (PrincipalContext ctx = new PrincipalContext(ContextType.Domain))
                {                    
                    userPrincipal = UserPrincipal.FindByIdentity(ctx, username);

                    if (compilationSection.Debug)
                    {
                        Common.Common.WriteLogToFile("ConnectedServer " + ctx.ConnectedServer + "Container " + ctx.Container + "ContextType " + ctx.ContextType + "Name " + ctx.Name + "Options " + ctx.Options + "UserName " + ctx.UserName, null);
                        if (userPrincipal == null)
                            Common.Common.WriteLogToFile("userPrincipal null ", null);                        
                    }

                    if (userPrincipal != null)
                    {                        
                        using (LoginUserDetails objLoginUserDetails = new LoginUserDetails())
                        {                            
                            using (SSOSL objSSOSL = new SSOSL())
                            {                                
                                using (DataSecurity objDataSecurity = new DataSecurity())
                                {                                    
                                    // Bind to the native AdsObject to force authentication.                                                                                                            
                                    Object obj = entry.NativeObject;
                                                                                                                                                
                                    DirectorySearcher search = new DirectorySearcher(entry);
                                    
                                    search.Filter = "(SAMAccountName=" + username + ")";                                    
                                    search.PropertiesToLoad.Add("cn");                                    
                                    SearchResult result = search.FindOne();

                                    if (result == null)
                                    {                                        
                                        //return false;
                                        DictDetails = null;
                                        return DictDetails;
                                    }
                                    // Update the new path to the user in the directory
                                    LdapPath = result.Path;                                    
                                    string _filterAttribute = (String)result.Properties["cn"][0];                                    

                                    objSelectedCompany = new CompanyDTO();

                                    objSelectedCompany = objSSOSL.getSingleCompanies(InsiderTradingSSO.Common.Common.getSystemConnectionString(), ConfigurationManager.AppSettings["DBName"].ToString());
                                    objLoginUserDetails.CompanyDBConnectionString = objSelectedCompany.CompanyConnectionString;
                                    
                                    Hashtable ht_Param = new Hashtable();

                                    if (username != null && !username.Length.Equals(0))
                                        ht_Param.Add("EmployeeId", username);
                                        if (compilationSection.Debug)
                                        {
                                            Common.Common.WriteLogToFile("Get EmployeeID as " + userPrincipal.EmployeeId, null);
                                        }
                                    else
                                        ht_Param.Add("EmployeeId", null);
                                        ht_Param.Add("EmailId", userPrincipal.EmailAddress);
                                        if (compilationSection.Debug)
                                        {
                                            Common.Common.WriteLogToFile("Get EmailID as " + userPrincipal.EmailAddress, null);
                                        }

                                    ObjuserDTO = objSSOSL.LoginSSOUserInfo(objLoginUserDetails.CompanyDBConnectionString, ht_Param);

                                    DictDetails.Add("sUserName", ObjuserDTO.LoginID);
                                    DictDetails.Add("sPassword", ObjuserDTO.Password);
                                    DictDetails.Add("sCompanyName", objSelectedCompany.sCompanyDatabaseName);
                                    DictDetails.Add("sCalledFrom", objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), Common.ConstEnum.User_Password_Encryption_Key));

                                    if (compilationSection.Debug)
                                    {
                                        if(DictDetails.Count >= 0)
                                            Common.Common.WriteLogToFile("Diction object with all details ", null);
                                    }

                                    return DictDetails;
                                }
                            }
                        }
                    }
                }               
            }

            catch (Exception ex)
            {
                Errmsg = ex.Message;

                if (compilationSection.Debug)
                {
                    Common.Common.WriteLogToFile("Exception occurred (AuthenticateUser failed ", ex);
                }

                DictDetails = null;
                throw new Exception("Error authenticating user." + ex.Message);
            }

            return DictDetails;            
        }
        #endregion        

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