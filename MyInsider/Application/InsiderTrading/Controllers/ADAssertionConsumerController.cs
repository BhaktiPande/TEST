using ESOP.SSO.Library;
using ESOP.Utility;
using InsiderTrading.Common;
using InsiderTrading.Models;
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Security.Claims;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class ADAssertionConsumerController : Controller
    {
        // GET: ADAssertionConsumer
        // GET: ADAssertionConsumer
        public ActionResult Index()
        {
            string adfsUrl = ConfigurationManager.AppSettings["ADFSUrl"].ToString();
            return Redirect(adfsUrl);
            //return View();
        }

        [AllowAnonymous]
        public ActionResult AssertionConsumerOldForShardul()
        {
            try
            {
                string emailId = string.Empty;
                string companyName = string.Empty;
                string employeeId = string.Empty;
                string windowsAccountName = string.Empty;
                string Emplist = string.Empty;
                //string empEmail = "anand.kulkarni@esopdirect.com";
                //string empId = empployeeId = "Halt1";

                WriteToFileLog.Instance("ADFS").Write("Called AssertionConsumer Method on ADAssertionConsumerController.");

                ClaimsIdentity principal = HttpContext.User.Identity as ClaimsIdentity;

                if (null != principal.Claims)
                {
                    int countClaims = 0;
                    foreach (Claim claim in principal.Claims)
                    {

                        Emplist += "CLAIM TYPE: " + claim.Type + "; CLAIM VALUE: " + claim.Value + "</br>";

                        if (claim.Type == null)
                        {
                            WriteToFileLog.Instance("ADFS").Write("Claim Types are null");
                        }

                        if (claim.Type.Contains("name"))
                        {
                            if (countClaims == 0)
                            {
                                employeeId = claim.Value;
                                countClaims++;
                            }
                        }
                        if (claim.Type.Contains("emailaddress"))
                        {
                            emailId = claim.Value;
                        }
                        if (claim.Type.Contains("windowsaccountname"))
                        {
                            windowsAccountName = claim.Value;
                        }
                    }
                }
                else
                {
                    WriteToFileLog.Instance("ADFS").Write("Claims are null");
                }
                WriteToFileLog.Instance("ADFS").Write(Emplist);
                WriteToFileLog.Instance("ADFS").Write("Claims: " + "Employee Id- " + employeeId + " Email Id- " + emailId + " Windows Account Name- " + windowsAccountName);
                Hashtable ht_Parmeters = new Hashtable();
                //employeeId = "Halt1";
                companyName = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.AppSettings["ADFSCompanyDBName"].ToString()));
                ht_Parmeters.Add(CommonConstant.s_AttributeEmployeeId, employeeId);
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
                    WriteToFileLog.Instance("ADFS").Write("Before Redirect.");
                    return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0) });
                }
            }
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View();

        }

        #region // POST: /ADAssertionConsumer/AssertionConsumer
        [HttpPost]
        [AllowAnonymous]
        public ActionResult AssertionConsumer(FormCollection response)
        {
            try
            {
                WriteToFileLog.Instance("ADFS").Write("Called AssertionConsumer Method on ADAssertionConsumerController.");
                WriteToFileLog.Instance("ADFS").Write(" Start SamlKey: " + response["SAMLResponse"] + " End SamlKey. ");
                string DBConnection = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));
                Generic.Instance().ConnectionStringValue = DBConnection;
                Generic.Instance().SsoLogFilePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString();
                Generic.Instance().SsoLogStoreLocation = ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString();

                if (response["SAMLResponse"] != null)
                {
                    using (ESOP.SSO.Library.SAMLResponse samlResponse = new ESOP.SSO.Library.SAMLResponse())
                    {
                        WriteToFileLog.Instance("ADFS").Write("Called SSO Library and validating.");

                        samlResponse.LoadXmlFromBase64(response["SAMLResponse"]);
                        samlResponse.SsoProperty.IsValidateSSO = Convert.ToBoolean(samlResponse.IsSSOValidate);
                        TempData["samlResponseData"] = samlResponse.SsoProperty;
                        Session["IsSSOLogin"] = true;
                        return RedirectToAction("InitiateIDPOrSP", "ADAssertionConsumer");
                    }
                }
                else
                {
                    WriteToFileLog.Instance("ADFS").Write(" SAMLResponse is null or empty.");
                }

            }
            catch (Exception exception)
            {
                WriteToFileLog.Instance("ADFS").Write("Exception: " + exception.Message.ToString());
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("AssertionConsumer");
        }
        #endregion

        #region // POST: /ADAssertionConsumer/InitiateIDPOrSP
        // [HttpPost]
        [AllowAnonymous]
        public ActionResult InitiateIDPOrSP(Hashtable response)
        {
            try
            {
                WriteToFileLog.Instance("ADFS").Write("Calling InitiateIDPOrSP Methon on ADAssertionController.");
                ESOP.SSO.Library.SSO sSoData = TempData["samlResponseData"] as ESOP.SSO.Library.SSO;
                Hashtable ht_Parmeters = new Hashtable();
                //ht_Parmeters.Add(CommonConstant.s_AttributeEmail, sSoData.AttributeEmailFromSAMLResponse);
                //ht_Parmeters.Add(CommonConstant.s_AttributeEmail, "anand.kulkarni@esopdirect.com");
                // For Testing//
                //sSoData.IsValidateSSO = true;
                // End and comment above line After manual testing//
                if (!string.IsNullOrEmpty(sSoData.UPNFromSAMALResponse))
                {
                    WriteToFileLog.Instance("ADFS").Write(" sSoData UPNFromSAMALResponse:  " + sSoData.UPNFromSAMALResponse);
                    if (sSoData.UPNFromSAMALResponse.Contains("@"))
                    {
                        WriteToFileLog.Instance("ADFS").Write("Contains @:  ");
                        string[] strArrayForUPNValue = sSoData.UPNFromSAMALResponse.Split('@');
                        sSoData.UPNFromSAMALResponse = strArrayForUPNValue[0].ToString();
                        // For Manual testing By EmployeeId//
                        //sSoData.UPNFromSAMALResponse = "1";
                        ht_Parmeters.Add(CommonConstant.s_AttributeEmployeeId, sSoData.UPNFromSAMALResponse);
                        WriteToFileLog.Instance("ADFS").Write(" CommonConstant.s_AttributeEmployeeId: " + CommonConstant.s_AttributeEmployeeId);
                        WriteToFileLog.Instance("ADFS").Write(" After Split UPM @:  " + sSoData.UPNFromSAMALResponse);
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(sSoData.NameIDFromSAMLResponse))
                    {
                        ht_Parmeters.Add(CommonConstant.s_AttributeEmployeeId, sSoData.NameIDFromSAMLResponse);
                        WriteToFileLog.Instance("ADFS").Write(" sSoData.NameIDFromSAMLResponse Founded: " + sSoData.NameIDFromSAMLResponse);
                    }
                    else
                    {
                        WriteToFileLog.Instance("ADFS").Write(" sSoData.NameIDFromSAMLResponse Not Found " + sSoData.NameIDFromSAMLResponse);
                    }

                }

                ht_Parmeters.Add(CommonConstant.s_AttributeComapnyName, sSoData.CompanyName);
                WriteToFileLog.Instance("ADFS").Write(" CommonConstant.s_AttributeComapnyName: " + CommonConstant.s_AttributeComapnyName + " : " + sSoData.CompanyName);
                if (!string.IsNullOrEmpty(sSoData.CompanyName))
                {
                    WriteToFileLog.Instance("ADFS").Write(" Company Name  " + sSoData.CompanyName);
                    if (ht_Parmeters == null)
                    {
                        WriteToFileLog.Instance("ADFS").Write(" ht_Parmeters is NULL  ");
                        using (SSOModel SSOModel = new SSOModel())
                        {
                            if (!SSOModel.IsSSOActivated(sSoData.CompanyName))
                            {
                                ViewBag.RequestStatus = CommonConstant.sRequestStatusSSO_DEACTIVATED;
                                ViewBag.IsRequestValid = false;
                                WriteToFileLog.Instance("ADFS").Write(" CommonConstant.sRequestStatusSSO_DEACTIVATED:  " + CommonConstant.sRequestStatusSSO_DEACTIVATED);
                            }
                            else
                            {
                                WriteToFileLog.Instance("ADFS").Write(" Before CreateNewAuthnRequest   ");
                                string getSamalRequest = SSOModel.CreateNewAuthnRequest(sSoData);
                                Response.Redirect(sSoData.IDP_SP_URL + "?SAMLRequest=" + getSamalRequest, true);
                                WriteToFileLog.Instance("ADFS").Write(" After CreateNewAuthnRequest  ");
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
                                WriteToFileLog.Instance("ADFS").Write(" SSO not activated  ");
                            }
                            else
                            {
                                if (sSoData.IsValidateSSO)
                                {
                                    WriteToFileLog.Instance("ADFS").Write(" Before SetupLoginDetails  ");
                                    bool isSuccess = SSOModel.SetupLoginDetails(ht_Parmeters);
                                    if (isSuccess)
                                    {
                                        WriteToFileLog.Instance("ADFS").Write(" After SetupLogin Success and  Redirecting Dashboard ");
                                        ViewBag.IsRequestValid = true;
                                        Session["loginStatus"] = 1;
                                        HttpContext.Session.Add("UserCaptchaText", string.Empty);
                                        HttpContext.Session.Add(ConstEnum.SessionValue.CookiesValidationKey, "");
                                        return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0) });
                                    }
                                    else
                                    {
                                        WriteToFileLog.Instance("ADFS").Write(" Login details could'not find. ");
                                    }
                                }
                                else
                                {
                                    WriteToFileLog.Instance("ADFS").Write(" SSO is not Validate from ESOP Library ");
                                }


                            }

                        }
                    }
                }
                else
                {
                    ViewBag.RequestStatus = CommonConstant.s_SSONotActivated;
                    ViewBag.IsRequestValid = false;
                    WriteToFileLog.Instance("ADFS").Write(" SSO is not activited for this company. ");
                }
            }
            catch (Exception exception)
            {
                WriteToFileLog.Instance("ADFS").Write(" Exception: " + exception.Message.ToString());
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("AssertionConsumer");
        }
        #endregion

        #region  //Create New Authentication Using SP to IDP
        // [HttpPost]
        [AllowAnonymous]
        public ActionResult CreateNewAuthByShardul()
        {
            try
            {
                WriteToFileLog.Instance("ADFS").Write(" Calling Creating new authentication  On SSO Controller ");
                WriteToFileLog.Instance("ADFS").Write(" Calling SSO Library on SSO Controller ");
                DataTable dataTableSSODetails = new DataTable();
                string DBConnection = Convert.ToString(Cryptography.DecryptData(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString));
                Generic.Instance().ConnectionStringValue = DBConnection;
                Generic.Instance().SsoLogFilePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString();
                Generic.Instance().SsoLogStoreLocation = ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString();
                ESOP.SSO.Library.SSO sSoData=new ESOP.SSO.Library.SSO();
                using (ESOP.SSO.Library.SAMLResponse samlResponse = new ESOP.SSO.Library.SAMLResponse())
                {
                    WriteToFileLog.Instance("ADFS").Write(" Called SSO Library and validating... ");
                    dataTableSSODetails = samlResponse.GetSSODetailsByCompanyName(ConfigurationManager.AppSettings["ShardulDBName"].ToString());
                    if (dataTableSSODetails.Rows.Count > 0 && dataTableSSODetails != null)
                    {
                        sSoData = samlResponse.SsoProperty;
                       
                    }
                    else
                    {
                        WriteToFileLog.Instance("ADFS").Write(" Data not found in the database on SSO Controller ");
                    }

                }

                //ESOP.SSO.Library.SSO sSoData = TempData["ssoDataFromDb"] as ESOP.SSO.Library.SSO;
                using (SSOModel SSOModel = new SSOModel())
                {
                    if (!SSOModel.IsSSOActivated(sSoData.CompanyName))
                    {
                        ViewBag.RequestStatus = CommonConstant.sRequestStatusSSO_DEACTIVATED;
                        ViewBag.IsRequestValid = false;
                        WriteToFileLog.Instance("ADFS").Write(" " + CommonConstant.sRequestStatusSSO_DEACTIVATED + "  ");
                    }
                    else
                    {
                        string getSamalRequest = SSOModel.CreateNewAuthnRequest(sSoData);
                        WriteToFileLog.Instance("ADFS").Write(" SAML Request: " + sSoData.IDP_SP_URL + "?SAMLRequest=" + getSamalRequest + "  ");
                        Response.Redirect(sSoData.IDP_SP_URL + "?SAMLRequest=" + getSamalRequest, true);
                    }

                }

            }
            catch (Exception exception)
            {
                WriteToFileLog.Instance("ADFS").Write(exception.Message.ToString());
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View("SSO");
        }
        #endregion
    }
}