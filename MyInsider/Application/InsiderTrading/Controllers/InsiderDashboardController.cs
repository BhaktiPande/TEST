using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class InsiderDashboardController : Controller
    {


        InsiderDashboardModel objInsiderDashboardModel = null;

        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            TempData.Remove("SearchArray");
            LoginUserDetails objLoginUserDetails = null;
            InsiderDashboardDTO objInsiderDashboardDTO = null;
            UserInfoDTO objUserInfoDTO = null;
            ApprovedPCLDTO objApprovedPCLDTO = null;
            PasswordExpiryReminderDTO objPassExpiryReminderDTO = null;
            DateTime CurrentDate;
            ArrayList lst = new ArrayList();
            UserPolicyDocumentEventLogDTO objChangePasswordEventLogDTO = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;
            int RequiredModuleID = 0;
            int noOfDays = 0;
            object path;
            ViewBag.dupTransCnt = false;
            ViewBag.ApprovedPCLCnt = false;
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
                if (objLoginUserDetails.CompanyName == "DCBBank")
                {
                    ViewBag.IsVisible = 0;
                }
                else
                {
                    ViewBag.IsVisible = 1;
                }

                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }


                objInsiderDashboardModel = new InsiderDashboardModel();
                objInsiderDashboardModel.objInsiderDashboardOtherModel = new InsiderDashboardOtherModel();
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
                        objInsiderDashboardModel.objInsiderDashboardOtherModel = BindDashboardForOtherSecurities();

                        break;
                    case ConstEnum.Code.RequiredModuleBoth:
                        ViewBag.RequiredModuleOwn = true;
                        int? TradingPolicyID_OS;
                        //check other sericity model is applicable for user or not 
                        InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                        using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                        {
                            objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_TradingPolicyID_forOS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                            TradingPolicyID_OS = objInsiderInitialDisclosureDTO.TradingPolicyID_OS;
                        }

                        if (TradingPolicyID_OS == null || TradingPolicyID_OS == 0)
                        {
                            ViewBag.RequiredModuleBoth = false;
                            ViewBag.RequiredModuleOther = false;
                        }
                        else
                        {
                            ViewBag.RequiredModuleBoth = true;
                            ViewBag.RequiredModuleOther = true;
                        }

                        objInsiderDashboardModel.objInsiderDashboardOtherModel = BindDashboardForOtherSecurities();
                        break;

                }
                if (objInsiderDashboardModel.objInsiderDashboardOtherModel.IsChangePassword)
                {
                    Common.Common.SetSessionValue("IsChangePassword", true);
                    return RedirectToAction("ChangePassword", "UserDetails", new { acid = Convert.ToString(Common.ConstEnum.UserActions.CHANGE_PASSWORD) });
                }
                using (InsiderDashboardSL objInsiderDashboardSL = new InsiderDashboardSL())
                {
                    objInsiderDashboardDTO = objInsiderDashboardSL.GetTradingCalenderDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    if (objInsiderDashboardDTO.IsActivated == 1)
                    {
                        ViewBag.hideTrading = 0;
                    }
                    else
                    {
                        ViewBag.hideTrading = 1;
                    }

                    objInsiderDashboardDTO = objInsiderDashboardSL.GetDashboardDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    Common.Common.CopyObjectPropertyByName(objInsiderDashboardDTO, objInsiderDashboardModel);
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

                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {

                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    if (objUserInfoDTO.DateOfBecomingInsider != null)
                    {
                        ViewBag.InsiderTypeUser = 1;
                    }
                    else
                    {
                        ViewBag.InsiderTypeUser = 0;
                    }
                }

                int SecurityTypeCodeIdCnt = 0;
                int TransactionTypeCodeIdCnt = 0;
                int DateOfAcquisitionCnt = 0;
                using (InsiderDashboardSL objInsiderDashboardSL = new InsiderDashboardSL())
                {
                    List<DupTransCntDTO> lstDupTransCnt = objInsiderDashboardSL.Get_DupTransCnt(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    foreach (var dupTransCnt in lstDupTransCnt)
                    {
                        SecurityTypeCodeIdCnt = dupTransCnt.SecurityTypeCodeIdCnt;
                        TransactionTypeCodeIdCnt = dupTransCnt.TransactionTypeCodeIdCnt;
                        DateOfAcquisitionCnt = dupTransCnt.DateOfAcquisitionCnt;
                    }
                }
                if (SecurityTypeCodeIdCnt != 0 && TransactionTypeCodeIdCnt != 0 && DateOfAcquisitionCnt != 0)
                {
                    ViewBag.dupTransCnt = true;
                    TempData["TradingTransactionModel"] = null;
                    TempData["DuplicateTransaction"] = null;

                }

                int localApprovedPCLCnt = 0;
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    List<ApprovedPCLDTO> lstApprovedPCLCnt = objTradingTransactionSL.GetApprovedPCLCntSL(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    foreach (var ApprovedPCLCnt in lstApprovedPCLCnt)
                    {
                        localApprovedPCLCnt = ApprovedPCLCnt.ApprovedPCLCnt;
                    }
                }
                if (localApprovedPCLCnt != 0)
                {
                    ViewBag.ApprovedPCLCnt = true;
                }

            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
            }
            finally
            {
                objLoginUserDetails = null;
                objInsiderDashboardDTO = null;
                objUserInfoDTO = null;
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return View(objInsiderDashboardModel);
        }

        private InsiderDashboardOtherModel BindDashboardForOtherSecurities()
        {
            LoginUserDetails objLoginUserDetails = null;
            InsiderDashboardDTO_OS objInsiderDashboardDTO_OS = null;
            UserInfoDTO objUserInfoDTO = null;
            ApprovedPCLDTO objApprovedPCLDTO = null;
            PasswordExpiryReminderDTO objPassExpiryReminderDTO = null;
            DateTime CurrentDate;
            ArrayList lst = new ArrayList();
            UserPolicyDocumentEventLogDTO objChangePasswordEventLogDTO = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;
            int noOfDays;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            using (InsiderDashboardSL_OS objInsiderDashboardSL_OS = new InsiderDashboardSL_OS())
            {
                objInsiderDashboardDTO_OS = objInsiderDashboardSL_OS.GetDashboardDetails_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                Common.Common.CopyObjectPropertyByName(objInsiderDashboardDTO_OS, objInsiderDashboardModel.objInsiderDashboardOtherModel);
                CurrentDate = Convert.ToDateTime(DateTime.Now.Date.ToString("dd/MM/yyyy"), System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);
                objPassExpiryReminderDTO = objInsiderDashboardSL_OS.GetPasswordExpiryReminder(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
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
                    objInsiderDashboardModel.objInsiderDashboardOtherModel.IsChangePassword = true;

                }

            }

            return objInsiderDashboardModel.objInsiderDashboardOtherModel;
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}