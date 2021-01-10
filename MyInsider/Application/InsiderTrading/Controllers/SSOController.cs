using ESOP.SSO.Library;
using ESOP.Utility;
using InsiderTrading.Common;
using InsiderTrading.Models;
using System;
using System.Collections;
using System.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [Authorize]
    public class SSOController : Controller
    {
        #region // GET: /SSO/
        [HttpGet]
        [AllowAnonymous]
        public ActionResult Login()
        {
            ViewBag.RequestStatus = CommonConstant.sRequestStatusNONE;
            ViewBag.IsRequestValid = false;
            return View("SSO");
        }
        #endregion

        #region // GET: /SSO/TGBL
        [HttpGet]
        [AllowAnonymous]
        public ActionResult TGBL()
        {
            SSOFacade(SSOModel.CompanyIDList.TGBL);
            return View("SSO");
        }
        #endregion

        #region // POST: /SSO/AssertionConsumer
        [HttpPost]
        [AllowAnonymous]
        public ActionResult AssertionConsumer(FormCollection response)
        {
            try
            {
                string DBConnection = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));
                Generic.Instance().ConnectionStringValue = DBConnection;
                Generic.Instance().SsoLogFilePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString();
                Generic.Instance().SsoLogStoreLocation = ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString();
                using (ESOP.SSO.Library.SAMLResponse samlResponse = new ESOP.SSO.Library.SAMLResponse())
                {
                    ViewBag.RequestStatus = CommonConstant.s_SSOProcessing;
                    samlResponse.LoadXmlFromBase64(response["SAMLResponse"]);
                    if (samlResponse.SsoProperty.IsValidateSSO)
                    {
                        //samlResponse.SsoProperty.IsValidateSSO = samlResponse.IsSSOValidate;
                        TempData["samlResponseData"] = samlResponse.SsoProperty;
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

        //[HttpPost]
        //[AllowAnonymous]
        public ActionResult AssertionConsumerNew(FormCollection response)
        {
            try
            {
                string empnumber = HttpContext.User.Identity.Name;
                var prinicpal = (ClaimsPrincipal)Thread.CurrentPrincipal;

                if (prinicpal != null)
                {
                    StringBuilder stringBuilder = new StringBuilder();
                    foreach (var item in prinicpal.Claims)
                    {
                        stringBuilder.AppendLine(item.Type.ToString() + ": " + item.Value);
                        //LogWriter.LogMessage(item.Type.ToString() + ": " + item.Value, true);
                    }
                }

            }
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }
        #region // POST: /SSO/AssertionConsumer
        [HttpPost]
        [AllowAnonymous]
        public ActionResult AssertionConsumerAirtel(FormCollection response)
        {
            try
            {
                WriteToFileLog.Instance(ConfigurationManager.AppSettings["Airtel"].ToString()).Write("Here Calling the AssertionConsumerAirtel Method on SSOController ");
                string EmailId = string.Empty;
                string CompanyName = string.Empty;
                string empployeeId = HttpContext.User.Identity.Name;
                WriteToFileLog.Instance(ConfigurationManager.AppSettings["Airtel"].ToString()).Write("HttpContext.User.Identity.Name :-" + empployeeId);
                string strOLMID = HttpContext.User.Identity.Name;
                if (strOLMID.Contains('\\'))
                {
                    string[] userName = strOLMID.Split('\\');
                    if (userName.Count() > 0)
                    {
                        strOLMID = userName[1];
                        WriteToFileLog.Instance(ConfigurationManager.AppSettings["Airtel"].ToString()).Write("OLMID :-" + strOLMID);
                    }
                }
                var prinicpal = (ClaimsPrincipal)Thread.CurrentPrincipal;
                string companyName = ConfigurationManager.AppSettings["Airtel"].ToString();
                if (prinicpal != null)
                {
                    StringBuilder claimBuilder = new StringBuilder();
                    foreach (var item in prinicpal.Claims)
                    {
                        claimBuilder.AppendLine(item.Type.ToString() + ": " + item.Value);
                        //LogWriter.LogMessage(item.Type.ToString() + ": " + item.Value, true);
                    }
                    WriteToFileLog.Instance(ConfigurationManager.AppSettings["Airtel"].ToString()).Write("Claim Principle :-" + claimBuilder.ToString());
                }
                //string empEmail = "anand.kulkarni@esopdirect.com";
                //string empId = "Halt1";
                Hashtable ht_Parmeters = new Hashtable();
                ht_Parmeters.Add(CommonConstant.s_AttributeEmployeeId, empployeeId);
                ht_Parmeters.Add(CommonConstant.s_AttributeEmail, "");
                ht_Parmeters.Add(CommonConstant.s_AttributeComapnyName, companyName);

                ViewBag.RequestStatus = CommonConstant.sRequestStatusSAML_RESPONSE;
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
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }
        #endregion

        #endregion

        #region // POST: /SSO/AssertionConsumer
        [HttpGet]
        [AllowAnonymous]
        public ActionResult AssertionConsumerTGBL()
        {
            try
            {
                string EmailId = string.Empty;
                string CompanyName = string.Empty;
                EmailId = Request.QueryString["EmailId"];
                CompanyName = Request.QueryString["CompanyName"];

                Hashtable ht_Parmeters = new Hashtable();

                ht_Parmeters.Add(CommonConstant.s_AttributeEmail, EmailId);
                ht_Parmeters.Add(CommonConstant.s_AttributeComapnyName, CompanyName);

                ViewBag.RequestStatus = CommonConstant.sRequestStatusSAML_RESPONSE;
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
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }
        #endregion

        #region // POST: /SSO/AssertionConsumer
        // [HttpPost]
        [AllowAnonymous]
        public ActionResult InitiateIDPOrSP(Hashtable response)
        {
            try
            {
                ESOP.SSO.Library.SSO sSoData = TempData["samlResponseData"] as ESOP.SSO.Library.SSO;
                Hashtable ht_Parmeters = new Hashtable();
                ht_Parmeters.Add(CommonConstant.s_AttributeEmail, sSoData.AttributeEmailFromSAMLResponse);
                //ht_Parmeters.Add(CommonConstant.s_AttributeEmail, "anand.kulkarni@esopdirect.com");
                ht_Parmeters.Add(CommonConstant.s_AttributeComapnyName, sSoData.CompanyName);

                if (!string.IsNullOrEmpty(sSoData.CompanyName))
                {
                    if (ht_Parmeters == null)
                    {
                        using (SSOModel SSOModel = new SSOModel())
                        {
                            if (!SSOModel.IsSSOActivated(sSoData.CompanyName))
                            {
                                ViewBag.RequestStatus = CommonConstant.sRequestStatusSSO_DEACTIVATED;
                                ViewBag.IsRequestValid = false;
                            }
                            else
                            {
                                ViewBag.RequestStatus = CommonConstant.sRequestStatusSAML_REQUEST;
                                string getSamalRequest = SSOModel.CreateNewAuthnRequest(sSoData);
                                Response.Redirect(sSoData.IDP_SP_URL + "?SAMLRequest=" + getSamalRequest, true);
                            }

                        }
                    }
                    else
                    {
                        using (SSOModel SSOModel = new SSOModel())
                        {
                            if (!SSOModel.IsSSOActivated(sSoData.CompanyName))
                            {
                                ViewBag.RequestStatus = CommonConstant.sRequestStatusSSO_DEACTIVATED;
                                ViewBag.IsRequestValid = false;
                            }
                            else
                            {
                                if (sSoData.IsValidateSSO)
                                {
                                    bool isSuccess = SSOModel.SetupLoginDetails(ht_Parmeters);
                                    if (isSuccess)
                                    {
                                        ViewBag.IsRequestValid = true;
                                        Session["loginStatus"] = 1;
                                        HttpContext.Session.Add("UserCaptchaText", string.Empty);
                                        HttpContext.Session.Add(ConstEnum.SessionValue.CookiesValidationKey, "");
                                        return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0) });
                                    }
                                }
                                else
                                {
                                    ViewBag.RequestStatus = CommonConstant.s_InvalidResponse;
                                    ViewBag.IsRequestValid = false;
                                }

                            }

                        }
                    }
                }
                else
                {
                    ViewBag.RequestStatus = CommonConstant.s_SSONotActivated;
                    ViewBag.IsRequestValid = false;
                }
            }
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }
        #endregion

        #region Facade method
        private void SSOFacade(SSOModel.CompanyIDList companyIDList)
        {
            using (SSOModel sSOModel = new SSOModel())
            {
                if (!sSOModel.IsSSOActivated(companyIDList))
                {
                    ViewBag.RequestStatus = CommonConstant.sRequestStatusSSO_DEACTIVATED;
                    ViewBag.IsRequestValid = false;
                }
                else
                {
                    ViewBag.RequestStatus = CommonConstant.sRequestStatusSAML_REQUEST;
                    ViewBag.IsRequestValid = sSOModel.InitiateSSO(companyIDList);

                    if (Convert.ToBoolean(ViewBag.IsRequestValid))
                        Response.Redirect(sSOModel.IDPUrl + "?SAMLRequest=" + sSOModel.SAMLRequest, true);
                }
            }
        }
        #endregion
    }
}