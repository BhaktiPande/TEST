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
    public class ADFSController : Controller
    {
        // GET: ADFS
        public ActionResult Index()
        {
            string airtelAdfsUrl = ConfigurationManager.AppSettings["AirtelADFSURL"].ToString();
            return Redirect(airtelAdfsUrl);
        }

        public ActionResult AssertionConsumerAirtel(FormCollection response)
        {
            try
            {
                WriteToFileLog.Instance(ConfigurationManager.AppSettings["Airtel"].ToString()).Write("Here Calling the AssertionConsumerAirtel Method on ADFSController ");
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
                //string empId = empployeeId = "Halt1";
                Hashtable ht_Parmeters = new Hashtable();
                ht_Parmeters.Add(CommonConstant.s_AttributeEmployeeId, empployeeId);
                ht_Parmeters.Add(CommonConstant.s_AttributeEmail, "");
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
            catch (Exception exception)
            {
                ViewBag.RequestStatus = exception.Message.ToString();
            }

            return View();
        }
    }
}