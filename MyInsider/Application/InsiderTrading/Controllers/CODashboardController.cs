using InsiderTrading.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Models;
using InsiderTradingDAL;
using InsiderTrading.SL;
using InsiderTrading.Common;
using System.Collections;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class CODashboardController : Controller
    {
        CODashboardModel objInsiderDashboardModel = null; 
        //
        // GET: /CODashboard/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
           {
            int RequiredModuleID=0;
            LoginUserDetails objLoginUserDetails = null; 
            
            CODashboardDTO objInsiderDashboardDTO = null;
            PasswordExpiryReminderDTO objPassExpiryReminderDTO = null;
            DateTime CurrentDate;
            ArrayList lst = new ArrayList();
            UserPolicyDocumentEventLogDTO objChangePasswordEventLogDTO = null;
            int noOfDays = 0;            

            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                // check IsUserLogin flag in session, and set flag true -- this will indicate user is login and redirect here for first time 
                if (!objLoginUserDetails.IsUserLogin)
                {
                    objLoginUserDetails.IsUserLogin = true;

                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }

                objInsiderDashboardModel = new CODashboardModel();
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }

                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                objInsiderDashboardModel.objCODashboardModel_OS = new CODashboardModel_OS();
                switch (RequiredModuleID)
                {
                    case ConstEnum.Code.RequiredModuleOwnSecurity:
                        ViewBag.RequiredModuleOwn = true;
                        ViewBag.RequiredModuleBoth = false;
                        ViewBag.RequiredModuleOther = false;
                        break;
                    case ConstEnum.Code.RequiredModuleOtherSecurity:
                        ViewBag.RequiredModuleOwn = false;
                        ViewBag.RequiredModuleBoth = false;
                        ViewBag.RequiredModuleOther = true;
                        objInsiderDashboardModel.objCODashboardModel_OS = BindCODashboardForOtherSecurities();

                        break;
                    case ConstEnum.Code.RequiredModuleBoth:
                            ViewBag.RequiredModuleOwn = true;
                            ViewBag.RequiredModuleBoth = true;
                            ViewBag.RequiredModuleOther = true;
                        objInsiderDashboardModel.objCODashboardModel_OS = BindCODashboardForOtherSecurities();
                        break;

                }


                using (CODashboardSL objInsiderDashboardSL = new CODashboardSL())
                {
                    objInsiderDashboardDTO = objInsiderDashboardSL.GetDashboardDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    
                    Common.Common.CopyObjectPropertyByName(objInsiderDashboardDTO, objInsiderDashboardModel);
                }
                using (InsiderDashboardSL objInsiderDashboardSL = new InsiderDashboardSL())
                {                    
                    CurrentDate = Convert.ToDateTime(DateTime.Now.Date.ToString("dd/MM/yyyy"), System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);
                    objPassExpiryReminderDTO = objInsiderDashboardSL.GetPasswordExpiryReminder(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    if (objLoginUserDetails.LoggedInUserID == objPassExpiryReminderDTO.UserID
                        && objPassExpiryReminderDTO.ValidityDate.Date >= CurrentDate
                        && objPassExpiryReminderDTO.ExpiryReminderDate.Date <= CurrentDate)
                    {
                        if ((objPassExpiryReminderDTO.ValidityDate.Date - CurrentDate.Date).Days == 1)
                        {
                            noOfDays = (objPassExpiryReminderDTO.ValidityDate.Date - CurrentDate.Date).Days;
                        }
                        else
                        {
                            noOfDays = (objPassExpiryReminderDTO.ValidityDate.Date - CurrentDate.Date).Days + 1;
                        }
                        lst.Add(noOfDays);
                        lst.Add(objPassExpiryReminderDTO.ValidityDate.Date.ToString("dd/MM/yyyy"));
                        ViewBag.PasswordReminderMsg = Common.Common.getResource("pc_msg_50569", lst);
                    }
                    else if (objPassExpiryReminderDTO.ValidityDate.Date < CurrentDate)
                    {
                        Common.Common.SetSessionValue("IsChangePassword", true);
                        return RedirectToAction("ChangePassword", "UserDetails", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CHANGE_PASSWORD) });
                    }
                }
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
            }
            finally
            {
                objLoginUserDetails = null;
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return View(objInsiderDashboardModel);
        }

        private CODashboardModel_OS BindCODashboardForOtherSecurities()
        {
            LoginUserDetails objLoginUserDetails = null;
            CODashboardDTO_OS objCODashboardDTO_OS = new CODashboardDTO_OS();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            using (CODashboardSL_OS objCODashboardSL_OS = new CODashboardSL_OS())
            {
                objCODashboardDTO_OS = objCODashboardSL_OS.GetDashboardDetails_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                Common.Common.CopyObjectPropertyByName(objCODashboardDTO_OS, objInsiderDashboardModel.objCODashboardModel_OS);
            }

            return objInsiderDashboardModel.objCODashboardModel_OS;

        }

        public ActionResult PendingCount(int acid, int DashboardId, int count, int NotificationQueueId, int inp_sParam)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objLoginUserDetails.BackURL = Url.Action("index", "CODashboard", new { acid = 18 });
                
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                using (CODashboardSL objInsiderDashboardSL = new CODashboardSL())
                {
                    bool bDashboardCountReturn = objInsiderDashboardSL.UpdateStatus(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, DashboardId);
                }

                switch (DashboardId)
                {
                    case 1://PENDING TRANSACTIONS Dashboard : Initial Disclosures-CO
                        return RedirectToAction("ContinuousDisclosuresCODashnoard", "COInitialDisclosure", new { acid = acid, inp_sParam = inp_sParam, isInsider = "ContiDisCO" });

                    case 2://PENDING TRANSACTIONS Dashboard : Initial Disclosures-Insider
                        return RedirectToAction("InitialDisclosuresInsiderDashnoard", "COInitialDisclosure", new { acid = acid, inp_sParam = inp_sParam, isInsider = "InitialDisInsider" });

                    case 3://PENDING TRANSACTIONS Dashboard : Pre-clearances-CO
                        return RedirectToAction("PreClearancesCODashboard", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PreClearancesCO" });

                    case 4://PENDING TRANSACTIONS Dashboard : Trade details-CO
                        return RedirectToAction("TradeDetailsCO", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "TradeDetailsCO" });

                    case 5://PENDING TRANSACTIONS Dashboard : Trade details-Insider
                        return RedirectToAction("TradeDetailsInsider", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "TradeDetailsInsider" });

                    case 6://PENDING TRANSACTIONS Dashboard : Continuous Disclosures-CO
                        return RedirectToAction("ContinuousDisclosuresCODashnoard", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "ContinouseDisCO" });

                    case 7://PENDING TRANSACTIONS Dashboard : Continuous Disclosures-Insider
                        return RedirectToAction("ContinuousDisclosuresInsiderDashnoard", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "ContiDisInsider" });

                    case 8://PENDING TRANSACTIONS Dashboard : Submission to Stock Exchange-CO
                        return RedirectToAction("SubmissionToStockExchangeCODashnoard", "PreclearanceRequest", new { acid = acid, inp_sParam = inp_sParam, isInsider = "SubToStckExCO" });

                    case 9://PENDING TRANSACTIONS Dashboard : Period End Disclosures-CO
                        //return RedirectToAction("UsersStatus", "PeriodEndDisclosure", new { acid = acid });
                        return RedirectToAction("PeriodEndDisclosuresInsiderDashnoard", "PeriodEndDisclosure", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PeriodEndDisCO" });

                    case 10://PENDING TRANSACTIONS Dashboard : Period End Disclosures-Insider
                        return RedirectToAction("PeriodEndDisclosuresInsiderDashnoard", "PeriodEndDisclosure", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PeriodEndDisInsider" });

                    case 11://Policy Document Association to User
                        return RedirectToAction("index", "Employee", new { acid = acid });

                    case 12://Trading Policy Association to User
                        return RedirectToAction("index", "Employee", new { acid = acid });

                    case 13://Login Credentials Mail to New User
                        return RedirectToAction("index", "Employee", new { acid = acid });

                    case 14://PENDING ACTIVITIES Dashboard : Defaulters
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid });

                    case 15://Trading Policy due for Expiry
                        return RedirectToAction("index", "TradingPolicy", new { acid = acid });

                    case 16://PENDING ACTIVITIES Dashboard : Policy Document due for Expiry
                        return RedirectToAction("index", "PolicyDocuments", new { acid = acid });

                    case 17://PENDING ACTIVITIES Dashboard : Trading Window Setting for Financial Result Declaration
                        return RedirectToAction("index", "TradingWindowEvent", new { acid = acid, FinancialYearId = count });

                    case 18://Trading Window Setting for Financial Result Declaration
                        return RedirectToAction("index", "TradingWindowEvent", new { acid = acid, FinancialYearId = count });

                    case 19://MAILS Details Dashboard
                        return RedirectToAction("View", "Notification", new { acid = acid, NotificationId = NotificationQueueId });

                    case 20://Defaulters Dashboard : Initial Disclosures
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid, inp_sParam = inp_sParam });

                    case 21://Defaultes Dashboard : Continouse Disclosures
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid, inp_sParam = inp_sParam });

                    case 22://Defaulters Dashboard : Period End Disclosures
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid, inp_sParam = inp_sParam });

                    case 23://Defaulters Dashboard : Pre-Clearance
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid, inp_sParam = inp_sParam });

                    case 24://Defaulters Dashboard : Pre-Clearance
                        return RedirectToAction("DefaulterReport", "Reports", new { acid = acid, inp_sParam = inp_sParam });
                    case 25://Email Dashboard : other Securities
                        return RedirectToAction("ViewNofication_OS", "Notification", new { acid = acid, NotificationId = NotificationQueueId });
                    case 26://PENDING TRANSACTIONS Dashboard : Initial Disclosures-Other Securities
                        return RedirectToAction("InitialDisclosuresInsiderDashnoardOtherSecurities", "COInitialDisclosure", new { acid = acid, inp_sParam = inp_sParam , isInsider = "InitialDisInsider" });
                    case 27://PENDING TRANSACTIONS Dashboard : Period End Disclosures-Insider Other Securities
                        return RedirectToAction("PeriodEndDisclosuresInsiderDashnoardOtherSecurities", "PeriodEndDisclosure_OS", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PeriodEndDisInsider" });
                    case 28://PENDING TRANSACTIONS Dashboard : Pre-clearances-CO Other Securities
                        return RedirectToAction("PreClearancesCODashboardOtherSecurities", "PreclearanceRequestNonImplCompany", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PreClearancesCO_OS" });
                    case 29://PENDING TRANSACTIONS Dashboard : Trade details for Other Securities
                        return RedirectToAction("PreClearancesCODashboardOtherSecurities", "PreclearanceRequestNonImplCompany", new { acid = acid, inp_sParam = inp_sParam, isInsider = "PreClearancesCO_OS" });
                    case 30://PENDING TRANSACTIONS Dashboard : Initial Disclosures Relative-Other Securities
                        return RedirectToAction("InitialDisclosuresInsiderDashnoardOtherSecurities", "COInitialDisclosure", new { acid = acid, inp_sParam = inp_sParam, isInsider = "InitialDisInsider-Relative" });
                    default:
                        return RedirectToAction("index", "CODashboard", new { acid = 18 });
                }
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}