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
                HttpContext.GetOwinContext().Authentication.Challenge(
                    new AuthenticationProperties { RedirectUri = "/" },
                    OpenIdConnectAuthenticationDefaults.AuthenticationType);

                return View();
            }
            else
            {
                var userClaims = User.Identity as System.Security.Claims.ClaimsIdentity;
                var emailAddress = userClaims?.FindFirst("preferred_username")?.Value;
                string companyName = ConfigurationManager.AppSettings["CompanyName"].ToString();
                Hashtable ht_Parmeters = new Hashtable();

                ht_Parmeters.Add(CommonConstant.s_AttributeEmail, emailAddress);
                ht_Parmeters.Add(CommonConstant.s_AttributeComapnyName, companyName);

                ViewBag.IsRequestValid = false;
                using (SSOModel SSOModel = new SSOModel())
                {
                    SSOModel.SetupLoginDetails(ht_Parmeters);
                    ViewBag.IsRequestValid = true;
                    Session["loginStatus"] = 1;
                    HttpContext.Session.Add("UserCaptchaText", string.Empty);
                    HttpContext.Session.Add(ConstEnum.SessionValue.CookiesValidationKey, "");
                    HttpContext.Session.Add("formField", "130");
                    return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0) });
                }
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