using InsiderTrading.Common;
using InsiderTrading.Models;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OpenIdConnect;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class ADFSController : Controller
    {       
        [AllowAnonymous]
        public ActionResult Index()
        {
            if (!Request.IsAuthenticated)
            {
                ADFSAuthentication();
                return View();
            }
            else
            {
                Hashtable hashtable = ReadADFSClaim();
                return ADFSLogin(hashtable);
            }
        } 

        private void ADFSAuthentication()
        {
            HttpContext.GetOwinContext().Authentication.Challenge(
                    new AuthenticationProperties { RedirectUri = "/" },
                    OpenIdConnectAuthenticationDefaults.AuthenticationType);
        }

        private Hashtable ReadADFSClaim()
        {
            var userClaims = User.Identity as System.Security.Claims.ClaimsIdentity;
            var employeeId = userClaims?.FindFirst("name")?.Value;
            var emailAddress = userClaims?.FindFirst("preferred_username")?.Value;
            string companyName = ConfigurationManager.AppSettings["CompanyName"].ToString();

            Hashtable hashtable = new Hashtable();
            if (ConfigurationManager.AppSettings["ADFSLoginBasedOn"].ToString().ToLower() == "employeeid")
            {
                hashtable.Add(CommonConstant.s_AttributeEmployeeId, employeeId);
            }
            else
            {
                hashtable.Add(CommonConstant.s_AttributeEmail, emailAddress);
            }

            hashtable.Add(CommonConstant.s_AttributeComapnyName, companyName);

            return hashtable;
        }

        private ActionResult ADFSLogin(Hashtable parameter)
        {
            ViewBag.IsRequestValid = false;

            using (SSOModel SSOModel = new SSOModel())
            {
                SSOModel.SetupLoginDetails(parameter);
                ViewBag.IsRequestValid = true;
                Session["loginStatus"] = 1;
                HttpContext.Session.Add("UserCaptchaText", string.Empty);
                HttpContext.Session.Add(ConstEnum.SessionValue.CookiesValidationKey, "");
                HttpContext.Session.Add("formField", "130");
                return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0) });
            }
        }

        /// <summary>
        /// Send an OpenID Connect sign-out request.
        /// </summary>
        public void SignOut()
        {
            HttpContext.GetOwinContext().Authentication.SignOut(
                    OpenIdConnectAuthenticationDefaults.AuthenticationType,
                    CookieAuthenticationDefaults.AuthenticationType);
        }
    }
}