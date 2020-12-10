using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading;
using InsiderTradingDAL;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using InsiderTrading.Models;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class COInitialDisclosureController : Controller
    {
        public string sLookUpPrefix = "dis_msg_";

        #region List
        [AuthorizationPrivilegeFilter]
        public ActionResult List(int acid)
        {
            InsiderInitialDisclosureCountDTO objInsiderInitialDisclosureCountDTO = null;
            InsiderInitialDisclosureCountModel objInsiderInitialDisclosureCountModel = null;
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objInsiderInitialDisclosureCountModel = new InsiderInitialDisclosureCountModel();
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureCountDTO = objInsiderInitialDisclosureSL.GetDashBoardInsiderCount(objLoginUserDetails.CompanyDBConnectionString);

                    Common.Common.CopyObjectPropertyByName(objInsiderInitialDisclosureCountDTO, objInsiderInitialDisclosureCountModel);
                }

                if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                {
                    ViewBag.BackButton = true;
                    ViewBag.BackURL = objLoginUserDetails.BackURL;
                    objLoginUserDetails.BackURL = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }
                else
                {
                    ViewBag.BackButton = false;
                }

                return View(objInsiderInitialDisclosureCountModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");

            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion List

        #region CO initial disclosure For Implementing Company
        [AuthorizationPrivilegeFilter]
        public ActionResult SecuritiesIndex(int acid, int UserInfoId = 0, int RequiredModuleID = 0, int requiredModuleIDOnbtnclick = 0, int TradingPolicyID_OS = 0, string SoftCopySubmitted = "", string HardCopySubmitted = "")
        {
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> HoldingDetailStatus = null;
            List<PopulateComboDTO> SoftCopySubmissionStatus = null;
            List<PopulateComboDTO> HardCopySubmissionStatus = null;
            List<PopulateComboDTO> StockExchangeSubmissionStatus = null;
            List<PopulateComboDTO> EmployeeStatus = null;
            ViewBag.Change_Btn_Color = false;
            try
            {
                ViewBag.GridType = Common.ConstEnum.GridType.InitialDisclosureListForCO;
                ViewData["inp_sParam7"] = null;

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.LoginUserTypeCodeId=Convert.ToInt32(objLoginUserDetails.UserTypeCodeId);

                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                HoldingDetailStatus = new List<PopulateComboDTO>();
                HoldingDetailStatus.Add(objPopulateComboDTO);
                HoldingDetailStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, sLookUpPrefix));
                ViewBag.HoldingDetailStatus = HoldingDetailStatus;

                SoftCopySubmissionStatus = new List<PopulateComboDTO>();
                SoftCopySubmissionStatus.Add(objPopulateComboDTO);
                SoftCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.SoftCopySubmissionStatus = SoftCopySubmissionStatus;

                HardCopySubmissionStatus = new List<PopulateComboDTO>();
                HardCopySubmissionStatus.Add(objPopulateComboDTO);
                HardCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.HardCopySubmissionStatus = HardCopySubmissionStatus;

                StockExchangeSubmissionStatus = new List<PopulateComboDTO>();
                StockExchangeSubmissionStatus.Add(objPopulateComboDTO);
                StockExchangeSubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.StockExchangeSubmissionStatus = StockExchangeSubmissionStatus;
                ViewBag.SoftCopySubmitted = SoftCopySubmitted;
                ViewBag.HardCopySubmitted = HardCopySubmitted;

                EmployeeStatus = new List<PopulateComboDTO>();
                EmployeeStatus.Add(objPopulateComboDTO);
                EmployeeStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.EmployeeStatus = EmployeeStatus;


            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                HoldingDetailStatus = null;
                SoftCopySubmissionStatus = null;
                HardCopySubmissionStatus = null;
                StockExchangeSubmissionStatus = null;
                EmployeeStatus = null;
            }
            ViewBag.RequiredModuleID = RequiredModuleID;

            if (requiredModuleIDOnbtnclick == 513001 || requiredModuleIDOnbtnclick == 513003 || requiredModuleIDOnbtnclick == 0)
            {
                ViewBag.Change_Btn_Color = true;
                return View("InsiderList");
            }
            else
            {
                ViewBag.Change_Btn_Color = true;
                return View("InsiderList_OS");
            }

        }
        #endregion CO initial disclosure For Implementing Company

        #region Index
        [AuthorizationPrivilegeFilter]
        //public ActionResult Index(int acid, string SoftCopySubmitted = "", string HardCopySubmitted = "")
        public ActionResult Index(int acid, int UserInfoId = 0, int ReqModuleId = 0)
        {    
           
            //Checking setting for Required Module For Mst_Company Table
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            UserInfoId = objLoginUserDetails.LoggedInUserID;
            //ImplementedCompanyDTO objImplementedCompanyDTO = null;
           
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {              
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                if (ReqModuleId==0)
                  ReqModuleId = objInsiderInitialDisclosureDTO.RequiredModule; ;

                return RedirectToAction("SecuritiesIndex", "COInitialDisclosure", new { acid = acid, RequiredModuleID = @ViewBag.RequiredModuleID, requiredModuleIDOnbtnclick = ReqModuleId });

            }
            //return View();           
        }
        #endregion Index

        #region CO Dashboard(Pending Initial Disclosure list)
        [AuthorizationPrivilegeFilter]
        public ActionResult InitialDisclosuresInsiderDashnoard(String inp_sParam, int acid, string SoftCopySubmitted = "", string HardCopySubmitted = "")
        {
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> HoldingDetailStatus = null;
            List<PopulateComboDTO> SoftCopySubmissionStatus = null;
            List<PopulateComboDTO> HardCopySubmissionStatus = null;
            List<PopulateComboDTO> StockExchangeSubmissionStatus = null;
            List<PopulateComboDTO> EmployeeStatus = null;

            try
            {
                ViewBag.GridType = Common.ConstEnum.GridType.InitialDisclosureListForCO;
                //string inp_sParam7 = "154002";
                ViewData["inp_sParam"] = inp_sParam;

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO = new PopulateComboDTO();

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                HoldingDetailStatus = new List<PopulateComboDTO>();
                HoldingDetailStatus.Add(objPopulateComboDTO);
                HoldingDetailStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, sLookUpPrefix));
                ViewBag.HoldingDetailStatus = HoldingDetailStatus;

                SoftCopySubmissionStatus = new List<PopulateComboDTO>();
                SoftCopySubmissionStatus.Add(objPopulateComboDTO);
                SoftCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.SoftCopySubmissionStatus = SoftCopySubmissionStatus;

                HardCopySubmissionStatus = new List<PopulateComboDTO>();
                HardCopySubmissionStatus.Add(objPopulateComboDTO);
                HardCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.HardCopySubmissionStatus = HardCopySubmissionStatus;

                StockExchangeSubmissionStatus = new List<PopulateComboDTO>();
                StockExchangeSubmissionStatus.Add(objPopulateComboDTO);
                StockExchangeSubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.StockExchangeSubmissionStatus = StockExchangeSubmissionStatus;
                ViewBag.SoftCopySubmitted = SoftCopySubmitted;
                ViewBag.HardCopySubmitted = HardCopySubmitted;

                EmployeeStatus = new List<PopulateComboDTO>();
                EmployeeStatus.Add(objPopulateComboDTO);
                EmployeeStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.EmployeeStatus = EmployeeStatus;
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                ViewBag.LoginUserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                HoldingDetailStatus = null;
                SoftCopySubmissionStatus = null;
                HardCopySubmissionStatus = null;
                StockExchangeSubmissionStatus = null;
                EmployeeStatus = null;
            }
                return View("InsiderList");  
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosuresCODashnoard(String inp_sParam, int acid, string SoftCopySubmitted = "", string HardCopySubmitted = "")
        {
            ViewBag.GridType = Common.ConstEnum.GridType.InitialDisclosureListForCO;
            //string inp_sParam7 = "154002";
            ViewData["inp_sParam"] = inp_sParam;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "0";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> HoldingDetailStatus = new List<PopulateComboDTO>();
            HoldingDetailStatus.Add(objPopulateComboDTO);
            HoldingDetailStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, sLookUpPrefix));
            ViewBag.HoldingDetailStatus = HoldingDetailStatus;

            List<PopulateComboDTO> SoftCopySubmissionStatus = new List<PopulateComboDTO>();
            SoftCopySubmissionStatus.Add(objPopulateComboDTO);
            SoftCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
            ViewBag.SoftCopySubmissionStatus = SoftCopySubmissionStatus;

            List<PopulateComboDTO> HardCopySubmissionStatus = new List<PopulateComboDTO>();
            HardCopySubmissionStatus.Add(objPopulateComboDTO);
            HardCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
            ViewBag.HardCopySubmissionStatus = HardCopySubmissionStatus;

            List<PopulateComboDTO> StockExchangeSubmissionStatus = new List<PopulateComboDTO>();
            StockExchangeSubmissionStatus.Add(objPopulateComboDTO);
            StockExchangeSubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
            ViewBag.StockExchangeSubmissionStatus = StockExchangeSubmissionStatus;
            ViewBag.SoftCopySubmitted = SoftCopySubmitted;
            ViewBag.HardCopySubmitted = HardCopySubmitted;

            List<PopulateComboDTO> EmployeeStatus = new List<PopulateComboDTO>();
            EmployeeStatus.Add(objPopulateComboDTO);
            EmployeeStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "a", null, null, null, sLookUpPrefix));
            ViewBag.EmployeeStatus = EmployeeStatus;
            ViewBag.LoginUserTypeCodeId = objLoginUserDetails.UserTypeCodeId;

            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;                
            }

            return View("InsiderList");
        }
        #endregion

        #region AutoComplete
        public JsonResult Autocomplete(string sSearchString)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                var suggestions = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.DesignationList, null, null, null, null, null, sLookUpPrefix);
                var result = suggestions.Where(s => s.Value.ToLower().Contains(sSearchString.ToLower())).Select(w => w).ToList();

                return Json(result, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion AutoComplete

        #region CO Dashboard (Pending Initial Disclosure list Other Securities)
        [AuthorizationPrivilegeFilter]
        public ActionResult InitialDisclosuresInsiderDashnoardOtherSecurities(int acid, String inp_sParam, string SoftCopySubmitted = "", string HardCopySubmitted = "")
        {
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> HoldingDetailStatus = null;
            List<PopulateComboDTO> SoftCopySubmissionStatus = null;
            List<PopulateComboDTO> HardCopySubmissionStatus = null;
            List<PopulateComboDTO> StockExchangeSubmissionStatus = null;
            List<PopulateComboDTO> EmployeeStatus = null;

            try
            {
                ViewBag.GridType = Common.ConstEnum.GridType.InitialDisclosureListForCO_OS;
                //string inp_sParam7 = "154002";
                ViewData["inp_sParam"] = inp_sParam;
          
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPopulateComboDTO = new PopulateComboDTO();

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                HoldingDetailStatus = new List<PopulateComboDTO>();
                HoldingDetailStatus.Add(objPopulateComboDTO);
                HoldingDetailStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, sLookUpPrefix));
                ViewBag.HoldingDetailStatus = HoldingDetailStatus;

                SoftCopySubmissionStatus = new List<PopulateComboDTO>();
                SoftCopySubmissionStatus.Add(objPopulateComboDTO);
                SoftCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.SoftCopySubmissionStatus = SoftCopySubmissionStatus;

                HardCopySubmissionStatus = new List<PopulateComboDTO>();
                HardCopySubmissionStatus.Add(objPopulateComboDTO);
                HardCopySubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.HardCopySubmissionStatus = HardCopySubmissionStatus;

                StockExchangeSubmissionStatus = new List<PopulateComboDTO>();
                StockExchangeSubmissionStatus.Add(objPopulateComboDTO);
                StockExchangeSubmissionStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.StockExchangeSubmissionStatus = StockExchangeSubmissionStatus;
                ViewBag.SoftCopySubmitted = SoftCopySubmitted;
                ViewBag.HardCopySubmitted = HardCopySubmitted;

                EmployeeStatus = new List<PopulateComboDTO>();
                EmployeeStatus.Add(objPopulateComboDTO);
                EmployeeStatus.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "a", null, null, null, sLookUpPrefix));
                ViewBag.EmployeeStatus = EmployeeStatus;
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                ViewBag.LoginUserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                HoldingDetailStatus = null;
                SoftCopySubmissionStatus = null;
                HardCopySubmissionStatus = null;
                StockExchangeSubmissionStatus = null;
                EmployeeStatus = null;
            }
            return View("InsiderList_OS");
        }

        # endregion CO Dashboard (Pending Initial Disclosure list Other Securities)

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
	}
}