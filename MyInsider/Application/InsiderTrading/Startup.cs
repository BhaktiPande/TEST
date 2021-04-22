using ESOP.SSO.Library;
using ESOP.Utility;
using InsiderTrading.Common;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.Notifications;
using Microsoft.Owin.Security.OpenIdConnect;
using Owin;
using System;
using System.Configuration;
using System.Data;
using System.Threading.Tasks;
using System.Web;



[assembly: OwinStartupAttribute(typeof(InsiderTrading.Startup))]
namespace InsiderTrading
{
    public partial class Startup
    {
        
        public void Configuration(IAppBuilder app)
        {
            if (System.Configuration.ConfigurationManager.AppSettings["IsAzureADFSEnabled"] == "1")
            {
                DataTable dtSSODetails = new DataTable();
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                // http://localhost:1302/TESTERS/Default6.aspx
                string DBConnection = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));
                Generic.Instance().ConnectionStringValue = DBConnection;
                Generic.Instance().SsoLogFilePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString();
                Generic.Instance().SsoLogStoreLocation = ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString();
                if (!string.IsNullOrEmpty(url))
                {
                    WriteToFileLog.Instance("ADFS").Write("url: "+ url);
                    using (ESOP.SSO.Library.SAMLResponse samlResponse = new ESOP.SSO.Library.SAMLResponse())
                    {
                      dtSSODetails = samlResponse.GetSSODetailsByIDPUrl(url);
                        //TempData["samlResponseData"] = samlResponse.SsoProperty;
                        //Session["IsSSOLogin"] = true;
                        //return RedirectToAction("InitiateIDPOrSP", "SSO");
                    }
                }
                else
                {
                    WriteToFileLog.Instance("ADFS").Write(" IDPSP url is blank. ");
                }
                if (dtSSODetails.Rows.Count > 0 && dtSSODetails != null)
                {
                    string clientId = dtSSODetails.Rows[0]["ClientId"].ToString(); //System.Configuration.ConfigurationManager.AppSettings["ClientId"];

                    // RedirectUri is the URL where the user will be redirected to after they sign in.
                    string redirectUri = dtSSODetails.Rows[0]["IDP_SP_URL"].ToString(); // System.Configuration.ConfigurationManager.AppSettings["RedirectUri"];

                    // Tenant is the tenant ID (e.g. contoso.onmicrosoft.com, or 'common' for multi-tenant)
                    string tenant = dtSSODetails.Rows[0]["Tenant"].ToString();  //System.Configuration.ConfigurationManager.AppSettings["Tenant"];

                    // Authority is the URL for authority, composed by Microsoft identity platform endpoint and the tenant name (e.g. https://login.microsoftonline.com/contoso.onmicrosoft.com/v2.0)
                    // string authority = String.Format(System.Globalization.CultureInfo.InvariantCulture, System.Configuration.ConfigurationManager.AppSettings["Authority"], tenant);
                    string authority = String.Format(System.Globalization.CultureInfo.InvariantCulture, dtSSODetails.Rows[0]["Authority"].ToString(), tenant);
                }
                else
                {
                    WriteToFileLog.Instance("ADFS").Write(" The matching url's data not find in SSOconfiguration table. ");
                }
                app.SetDefaultSignInAsAuthenticationType(CookieAuthenticationDefaults.AuthenticationType);
                app.UseCookieAuthentication(new CookieAuthenticationOptions());
                app.UseOpenIdConnectAuthentication(
                new OpenIdConnectAuthenticationOptions
                {
                // Sets the ClientId, authority, RedirectUri as obtained from web.config
                ClientId = clientId,
                    Authority = authority,
                    RedirectUri = redirectUri,
                // PostLogoutRedirectUri is the page that users will be redirected to after sign-out. In this case, it is using the home page
                PostLogoutRedirectUri = redirectUri,
                    Scope = OpenIdConnectScope.OpenIdProfile,
                // ResponseType is set to request the id_token - which contains basic information about the signed-in user
                ResponseType = OpenIdConnectResponseType.IdToken,
                // ValidateIssuer set to false to allow personal and work accounts from any organization to sign in to your application
                // To only allow users from a single organizations, set ValidateIssuer to true and 'tenant' setting in web.config to the tenant name
                // To allow users from only a list of specific organizations, set ValidateIssuer to true and use ValidIssuers parameter 
                TokenValidationParameters = new TokenValidationParameters()
                    {
                        ValidateIssuer = false
                    },
                // OpenIdConnectAuthenticationNotifications configures OWIN to send notification of failed authentications to OnAuthenticationFailed method
                Notifications = new OpenIdConnectAuthenticationNotifications
                    {
                        AuthenticationFailed = OnAuthenticationFailed
                    }
                }
            );

            }
            else
            {
                ConfigureAuth(app);
            }
        }
        /// <summary>
        /// Handle failed authentication requests by redirecting the user to the home page with an error in the query string
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        private Task OnAuthenticationFailed(AuthenticationFailedNotification<OpenIdConnectMessage, OpenIdConnectAuthenticationOptions> context)
        {
            context.HandleResponse();
            context.Response.Redirect("/?errormessage=" + context.Exception.Message);
            return Task.FromResult(0);
        }
    }
}
