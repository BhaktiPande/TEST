using ESOP.SSO.Library;
using ESOP.Utility;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class AzureSSOController : Controller
    {
        // GET: AzureSSO
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult AssertionConsumer(FormCollection response)
        {
            try
            {
                string DBConnection = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));
                Generic.Instance().ConnectionStringValue = DBConnection;
                Generic.Instance().SsoLogFilePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString();
                Generic.Instance().SsoLogStoreLocation = ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString();

                if (response["SAMLResponse"] != null)
                {
                    using (ESOP.SSO.Library.SAMLResponse samlResponse = new ESOP.SSO.Library.SAMLResponse())
                    {
                        samlResponse.LoadXmlFromBase64(response["SAMLResponse"]);
                        TempData["samlResponseData"] = samlResponse.SsoProperty;
                        Session["IsSSOLogin"] = true;
                        return RedirectToAction("InitiateIDPOrSP", "SSO");
                    }
                }

            }
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }

    }
}