using ESOP.SSO.Library;
using ESOP.Utility;
using InsiderTrading.Common;
using InsiderTrading.Models;
using System;
using System.Collections;
using System.Configuration;
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