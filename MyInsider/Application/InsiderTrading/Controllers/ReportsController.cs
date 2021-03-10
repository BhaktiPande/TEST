using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Packaging;
using System.Collections;
using InsiderTradingDAL;
using InsiderTrading.SL;
using InsiderTrading.Common;
using System.Configuration;
using System.Web.Script.Serialization;
using InsiderTrading.Filters;
using InsiderTrading.Models;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    [ValidateInput(false)]
    public class ReportsController : Controller
    {
        /// <summary>
        /// This will have the filenames to be used for the exported reports
        /// </summary>
        /// 
        #region Report wise Excel File Names
        public Dictionary<int, string> objReportFileNames = new Dictionary<int, string> (){ 
                {ConstEnum.GridType.Report_InitialDisclosureEmployeeWise,"InitialDisclosure_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual,"InitialDisclosureIndividual_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise,"PDDisclosureEmployeeWise_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual,"PDDisclosureIndividual_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails,"PDDisclosureIndividualDetails_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_ContinuousReportEmployeeWise,"ContinuousDisclosureEmployeeWise_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual,"ContinuousDisclosureIndividual_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_PreclearenceReportEmployeeWise,"PreclearenceEmployeeWise_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual,"PreclearenceEmployeeIndividual_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_Defaulter,"Defaulter_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_RestrictedListSearch_CO,"Report_RestrictedListSearch_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_RestrictedListSearch_Insider,"Report_RestrictedListSearch_<DATE>.xlsx"},
                {ConstEnum.GridType.SecuritiesTransferReportCO,"Report_SecurityTransferReportAll_<DATE>.xlsx"},
                {ConstEnum.GridType.SecuritiesTransferReportEmployee,"Report_SecurityTransferReport_Employee_<DATE>.xlsx"},
                {ConstEnum.GridType.Report_EULAAcceptanceReport,"Report_EULAAcceptanceReport_<DATE>.xlsx"},
        };

        #endregion Report wise Excel File Names
        #region Report wise Excel File Sheet Names
        public Dictionary<int, string> objReportSheetNames = new Dictionary<int, string>(){ 
                {ConstEnum.GridType.Report_InitialDisclosureEmployeeWise,"IDEmployeeWise"},
                {ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual,"IDisclosureIndividual"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise,"PDDisclosureEmployeeWise"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual,"PDIndividual"},
                {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails,"PDIndividualDetail"},
                {ConstEnum.GridType.Report_ContinuousReportEmployeeWise,"CDisclosureEmployee"},
                {ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual,"CDisclosureEmployeeIndividual"},
                {ConstEnum.GridType.Report_PreclearenceReportEmployeeWise,"PreclearenceEmployeeWise"},
                {ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual,"PreclearenceEmployeeIndividual"},
                {ConstEnum.GridType.Report_Defaulter,"Defaulter"},
                {ConstEnum.GridType.Report_RestrictedListSearch_CO,"RestrictedList"},
                {ConstEnum.GridType.Report_RestrictedListSearch_Insider,"RestrictedList"},
                {ConstEnum.GridType.SecuritiesTransferReportCO,"SecuritiesTransferReportCO"},
                {ConstEnum.GridType.SecuritiesTransferReportEmployee,"SecuritiesTransferReportEmployee"},
                {ConstEnum.GridType.Report_EULAAcceptanceReport,"UserEulaAcceptanceReport"}
        };
        #endregion Report wise Excel File Sheet Names
        #region Report Titles
        public Dictionary<int, string> objReportTitles = new Dictionary<int, string>()
        {
            {ConstEnum.GridType.Report_InitialDisclosureEmployeeWise, Common.Common.getResource("rpt_ttl_19153")},
            {ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual, Common.Common.getResource("rpt_ttl_19154")},
            {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise, Common.Common.getResource("rpt_ttl_19157")},
            {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual, Common.Common.getResource("rpt_ttl_19158")},
            {ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails, Common.Common.getResource("rpt_ttl_19159")},
            {ConstEnum.GridType.Report_ContinuousReportEmployeeWise, Common.Common.getResource("rpt_ttl_19155")},
            {ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual, Common.Common.getResource("rpt_ttl_19156")},
            {ConstEnum.GridType.Report_PreclearenceReportEmployeeWise, Common.Common.getResource("rpt_ttl_19189")},
            {ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual, Common.Common.getResource("rpt_ttl_19190")},
            {ConstEnum.GridType.Report_Defaulter, Common.Common.getResource("rpt_ttl_19267")},
            {ConstEnum.GridType.Report_RestrictedListSearch_CO, Common.Common.getResource("rl_ttl_50341")},
            {ConstEnum.GridType.Report_RestrictedListSearch_Insider, Common.Common.getResource("rl_ttl_50357")},
            {ConstEnum.GridType.SecuritiesTransferReportCO, Common.Common.getResource("rpt_ttl_19350")},
            {ConstEnum.GridType.SecuritiesTransferReportEmployee, Common.Common.getResource("rpt_ttl_19350")},
            {ConstEnum.GridType.Report_EULAAcceptanceReport, Common.Common.getResource("rpt_ttl_53116")}
        };
        #endregion Report Titles
        //
        // GET: /Reports/
        public ActionResult Index()
        {
            return View();
        }

        //[AuthorizationPrivilegeFilter]
        //Authorization filter will not be required at this place as there are redirections handled internally and each of the individual redirection will have Authorization set on it.
        public ActionResult RedirectToDisclosureLetter(int acid, int nTransactionLetterId, int nDisclosureTypeCodeId, int nLetterForCodeId,
            int nTransactionMasterId, int EmployeeId, string LetterType, int GridType, string YearCode = "", string PeriodCode = "", string StockExchange = "",int PeriodTypeId=0,string PeriodType=null, string CalledFrom = "")
        {

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual)
                objLoginUserDetails.BackURL = @Url.Action("InitialDisclosureEmployeeIndividual", "Reports", new { acid = ConstEnum.UserActions.REPORTS_INITIALDISCLOSURE, EmployeeId = EmployeeId });
            else if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeWise)
                objLoginUserDetails.BackURL = @Url.Action("InitialDisclosureEmployeeWise", "Reports", new { acid = ConstEnum.UserActions.REPORTS_INITIALDISCLOSURE, EmployeeId = EmployeeId });
            else if (GridType == ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual)
                objLoginUserDetails.BackURL = @Url.Action("PeriodEndDisclosureEmployeeIndividual", "Reports", new { acid = ConstEnum.UserActions.REPORTS_PERIODENDDISCLOSURE, EmployeeId = EmployeeId, YearCode = YearCode, PeriodCode = PeriodCode });
            else if (GridType == ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual)
                objLoginUserDetails.BackURL = @Url.Action("ContinuousDisclosureEmployeeIndividual", "Reports", new { acid = ConstEnum.UserActions.REPORTS_CONTINUOUSDISCLOSURE, EmployeeId = EmployeeId });

            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            if (LetterType == "S")
            {

                if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual)
                    return RedirectToAction("ViewLetter", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId });
                else if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeWise)
                    return RedirectToAction("ViewLetter", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId });
                else if (GridType == ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual)
                    return RedirectToAction("ViewLetter", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId, year = YearCode, period = PeriodCode, pdtypeId=PeriodTypeId,pdtype=PeriodType });
                else if (GridType == ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual)
                {
                    if (StockExchange != "" && StockExchange == "true")
                    {
                        return RedirectToAction("ViewLetter", "TradingTransaction", new { sStockExchange = true, acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId });
                    }
                    else
                    {
                        return RedirectToAction("ViewLetter", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId });
                    }

                }
            }
            else if (LetterType == "H")
            {
                if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual)
                    return RedirectToAction("ViewHardCopy", "TradingTransaction", new { acid = acid, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nTransactionMasterId = nTransactionMasterId });
                else if (GridType == ConstEnum.GridType.Report_InitialDisclosureEmployeeWise)
                    return RedirectToAction("ViewHardCopy", "TradingTransaction", new { acid = acid, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nTransactionMasterId = nTransactionMasterId });
                else if (GridType == ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual)
                    return RedirectToAction("ViewHardCopy", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId, year = YearCode, Period = PeriodCode ,CalledFrom = "PeriodEndInsider" });
                else if (GridType == ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual)
                    return RedirectToAction("ViewHardCopy", "TradingTransaction", new { acid = acid, nTransactionLetterId = nTransactionLetterId, nDisclosureTypeCodeId = nDisclosureTypeCodeId, nLetterForCodeId = nLetterForCodeId, nTransactionMasterId = nTransactionMasterId});
            }

            return null;
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult InitialDisclosureEmployeeWise(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.GridType = Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeWise);
                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_InitialDisclosureEmployeeWise];
                ViewBag.UserTypeDropDown = GetUserTypeDropDown(objLoginUserDetails);
                ViewBag.CommentsDropDown = GetCommentsDropDown(objLoginUserDetails);
                ViewBag.InsiderStatusDropDown = GetInsiderStatusDropDown(objLoginUserDetails);
                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
                ViewBag.SSRSRptId = "zJIWkTIKWAc=";//4
                ViewBag.Rights = true;
                TempData.Remove("ReportSearchArray");
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult InitialDisclosureEmployeeIndividual(int acid,int EmployeeId)
        {
            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData2;
            string[] arrParameters = new string[20];
            try
            {
                arrParameters[0] = Convert.ToString(1);
                arrParameters[1] = Convert.ToString(EmployeeId);
                arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = ""; arrParameters[8] = "";
                arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = "";
                arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

                ViewBag.GridType = nGridType;
                ViewBag.EmployeeId = EmployeeId;

                ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
                ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;

                arrParameters = new string[20];
                arrParameters[0] = Convert.ToString(2);
                arrParameters[1] = Convert.ToString(EmployeeId);
                arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = ""; arrParameters[8] = "";
                arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = "";
                arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

                ViewBag.ReportHeaderKeyValueData2JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData2);

                ViewBag.ReportHeaderKeyValueData2 = objReportHeaderKeyValueData2;

                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual];

                ViewBag.UserDmatDropDown = GetEmployeeDMATDetails(objLoginUserDetails, EmployeeId);


                ViewBag.UserRelativesDropDown = GetEmployeeRelatives(objLoginUserDetails, EmployeeId);


                ViewBag.SecutiryTypeDropDown = GetSecutiryTypeDropDown(objLoginUserDetails);

                ViewBag.ShowBackButton = true;
                ViewBag.BackButtonUrl = Url.Action("InitialDisclosureEmployeeWise", "Reports", new {@acid=Convert.ToString(Common.ConstEnum.UserActions.REPORTS_INITIALDISCLOSURE) });
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosureEmployeeWise(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.GridType = Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise);
                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise];

                ViewBag.YearTypeCode = GetYearCodeTypeDropDown(objLoginUserDetails);
                ViewBag.FinancialPeriods = GetFinancialPeriodCodeDropDown(objLoginUserDetails);
                ViewBag.UserTypeDropDown = GetUserTypeDropDown(objLoginUserDetails);
                ViewBag.CommentsDropDown = GetCommentsDropDown(objLoginUserDetails);
                ViewBag.InsiderStatusDropDown = GetInsiderStatusDropDown(objLoginUserDetails);
                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;

                ViewBag.SSRSRptId = "h/jfF5gBzZQ=";//6
                ViewBag.Rights = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosureEmployeeIndividual(int acid,int EmployeeId,int YearCode, int PeriodCode,int PeriodTypeId=0,string PeriodType=null)
        {
            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData2;
            string[] arrParameters = new string[20];
            try
            {
                ViewBag.GridType = nGridType;
                ViewBag.EmployeeId = EmployeeId;

                arrParameters[0] = Convert.ToString(1);
                arrParameters[1] = Convert.ToString(YearCode); arrParameters[2] = Convert.ToString(PeriodCode); arrParameters[3] = Convert.ToString(EmployeeId); arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = "";
                arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = "";
                arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = ""; 

                ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
                ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;
                
                arrParameters = new string[20];
                arrParameters[0] = Convert.ToString(2);
                arrParameters[1] = Convert.ToString(YearCode); arrParameters[2] = Convert.ToString(PeriodCode); arrParameters[3] = Convert.ToString(EmployeeId); arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = "";
                arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = "";
                arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

                ViewBag.ReportHeaderKeyValueData2JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData2);
                ViewBag.ReportHeaderKeyValueData2 = objReportHeaderKeyValueData2;

                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual];


                ViewBag.YearTypeCode = GetYearCodeTypeDropDown(objLoginUserDetails);

                ViewBag.FinancialPeriods = GetFinancialPeriodCodeDropDown(objLoginUserDetails);

                ViewBag.UserDmatDropDown = GetEmployeeDMATDetails(objLoginUserDetails, EmployeeId);

                ViewBag.UserRelativesDropDown = GetEmployeeRelatives(objLoginUserDetails, EmployeeId);

                ViewBag.SecutiryTypeDropDown = GetSecutiryTypeDropDown(objLoginUserDetails);

                ViewBag.YearCode = Convert.ToString(YearCode);

                ViewBag.PeriodCode = Convert.ToString(PeriodCode);
                ViewBag.PeriodTypeId = PeriodTypeId;
                ViewBag.PeriodType = PeriodType;

                ViewBag.ShowBackButton = true;
                ViewBag.BackButtonUrl = Url.Action("PeriodEndDisclosureEmployeeWise", "Reports", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.REPORTS_PERIODENDDISCLOSURE) });
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosureEmployeeIndividualDetails(int acid, int EmployeeId, int YearCode, int PeriodCode, int RelativeUserId, int SecurityTypeId, int DmatId)
        {
            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData2;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            string[] arrParameters = new string[20];

            try
            {
                ViewBag.GridType = nGridType;
                ViewBag.EmployeeId = EmployeeId;
                
                ViewBag.RelativeUserId = RelativeUserId;
                ViewBag.SecurityTypeId = SecurityTypeId;
                ViewBag.DmatId = DmatId;

                arrParameters[0] = Convert.ToString(1);
                arrParameters[1] = Convert.ToString(YearCode); arrParameters[2] = Convert.ToString(PeriodCode); arrParameters[3] = Convert.ToString(EmployeeId); arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = "";
                arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = "";
                arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = ""; 

                ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
                ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;

                arrParameters = new string[20];
                arrParameters[0] = Convert.ToString(2);
                arrParameters[1] = Convert.ToString(YearCode); arrParameters[2] = Convert.ToString(PeriodCode); arrParameters[3] = Convert.ToString(EmployeeId); arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = "";
                arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = "";
                arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = ""; 

                ViewBag.ReportHeaderKeyValueData2JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData2);
                ViewBag.ReportHeaderKeyValueData2 = objReportHeaderKeyValueData2;

                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails];

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                ViewBag.YearTypeCode = YearCode;

                ViewBag.PeriodType = PeriodCode;

                ViewBag.ShowBackButton = true;
                ViewBag.BackButtonUrl = Url.Action("PeriodEndDisclosureEmployeeIndividual", "Reports", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.REPORTS_PERIODENDDISCLOSURE), @EmployeeId = EmployeeId, @YearCode = YearCode, @PeriodCode = PeriodCode });
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = false;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosureEmployeeWise(int acid)
        {
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.GridType = Convert.ToInt32(ConstEnum.GridType.Report_ContinuousReportEmployeeWise);
                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_ContinuousReportEmployeeWise];

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                ViewBag.UserTypeDropDown = GetUserTypeDropDown(objLoginUserDetails);

                ViewBag.TransactionType = GetTransactionTypeDropDown(objLoginUserDetails);

                ViewBag.SecutiryTypeDropDown = GetSecutiryTypeDropDown(objLoginUserDetails);
                ViewBag.InsiderStatusDropDown = GetInsiderStatusDropDown(objLoginUserDetails);
                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;

                ViewBag.SSRSRptId = "M/2BHyNrAc4=";//5
                ViewBag.Rights = true;
                TempData.Remove("ReportSearchArray");
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosureEmployeeIndividual(int acid, int EmployeeId)
        {
            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            PopulateComboDTO objPopulateComboDTOSelf = new PopulateComboDTO();
            string[] arrParameters = new string[20];

            try
            {
                ViewBag.GridType = nGridType;
                ViewBag.EmployeeId = EmployeeId;

                arrParameters[0] = Convert.ToString(1);
                arrParameters[1] = Convert.ToString(EmployeeId);
                arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = ""; arrParameters[8] = "";
                arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = "";
                arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

                ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
                ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;

                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual];

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                objPopulateComboDTOSelf.Key = "0";
                objPopulateComboDTOSelf.Value = "Self";

                ViewBag.UserDmatDropDown = GetEmployeeDMATDetails(objLoginUserDetails, EmployeeId);

                ViewBag.UserRelativesDropDown = GetEmployeeRelatives(objLoginUserDetails, EmployeeId);

                ViewBag.SecutiryTypeDropDown = GetSecutiryTypeDropDown(objLoginUserDetails);

                ViewBag.TransactionType = GetTransactionTypeDropDown(objLoginUserDetails);

                ViewBag.Comments = GetCommentsDropDown(objLoginUserDetails);

                ViewBag.CODRequiredStatusDropDown = GetCODRequiredtypeDropDown(objLoginUserDetails);

                ViewBag.ShowBackButton = true;
                ViewBag.BackButtonUrl = Url.Action("ContinuousDisclosureEmployeeWise", "Reports", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.REPORTS_CONTINUOUSDISCLOSURE) });
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult PreclearenceEmployeeWise(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.GridType = Convert.ToInt32(ConstEnum.GridType.Report_PreclearenceReportEmployeeWise);
                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_PreclearenceReportEmployeeWise];
                ViewBag.UserTypeDropDown = GetUserTypeDropDown(objLoginUserDetails);
                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
                ViewBag.InsiderStatusDropDown = GetInsiderStatusDropDown(objLoginUserDetails);
                ViewBag.SSRSRptId = "0lVrlV/e0rU=";//7
                ViewBag.Rights = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        public ActionResult PreclearenceEmployeeIndividual(int acid, int EmployeeId)
        {
            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            string[] arrParameters = new string[20];

            try
            {
                arrParameters[0] = Convert.ToString(1);
                arrParameters[1] = Convert.ToString(EmployeeId);
                arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = ""; arrParameters[8] = "";
                arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = "";
                arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

                ViewBag.GridType = nGridType;
                ViewBag.EmployeeId = EmployeeId;

                ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
                ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;

                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual];

                ViewBag.PreclearenceStatusDropDown = GetPreclearenceStatusTypeDropDown(objLoginUserDetails);
                ViewBag.CommentsDropDown = GetCommentsDropDown(objLoginUserDetails, ConstEnum.CodeGroup.PreclearenceComments);
                //ViewBag.UserTypeDropDown = GetUserTypeDropDown(objLoginUserDetails);
                ViewBag.SecutiryTypeDropDown = GetSecutiryTypeDropDown(objLoginUserDetails);
                ViewBag.TransactionType = GetTransactionTypeDropDown(objLoginUserDetails);

                ViewBag.ShowBackButton = true;
                ViewBag.BackButtonUrl = Url.Action("PreclearenceEmployeeWise", "Reports", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.REPORTS_PRECLEARENCE) });
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult RestrictedListSearchReport(int acid)
        {
            int nGridType = 0;
            string nOverrideGridType = "";
            LoginUserDetails objLoginUserDetails = null;
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1 = null;
            string[] arrParameters = new string[20];
            int loginUserId;
            bool isCOUserReport = true;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                isCOUserReport = acid == ConstEnum.UserActions.RESTRICTED_LIST_REPORT_CO ? true : false;

                nGridType = ConstEnum.GridType.Report_RestrictedListSearch_CO;
                nOverrideGridType = (isCOUserReport) ? "" : ConstEnum.GridType.Report_RestrictedListSearch_Insider.ToString();
                
                loginUserId = objLoginUserDetails.LoggedInUserID;

                arrParameters[0] = Convert.ToString(loginUserId);
                arrParameters[1] = ""; arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; 
                arrParameters[7] = ""; arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; 
                arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; 
                arrParameters[19] = "";

                ViewBag.GridType = nGridType;
                ViewBag.OverrideGridType = nOverrideGridType;
                ViewBag.IsOverrideGrid = isCOUserReport; //in case of CO, there is not override grid

                ViewBag.Title = (isCOUserReport) ? objReportTitles[ConstEnum.GridType.Report_RestrictedListSearch_CO] : objReportTitles[ConstEnum.GridType.Report_RestrictedListSearch_Insider];

                //set drop down list
                ViewBag.TradingAllowedOptionList = GetTradingAllowedOptionDropDown();
                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, false);

                ViewBag.loginUserId = loginUserId;
                ViewBag.SSRSRptId = (isCOUserReport) ? "b4czFb/7oAQ=" : "EJLIsEY9uZo=";
                ViewBag.Rights = true;

                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objReportHeaderKeyValueData1 = null;
            }

            return View("ReportView");
        }
        
        [AuthorizationPrivilegeFilter]
        [HttpPost]
        public FileStreamResult ExportReport(int acid, int GridType, string Search, string SearchCriteria, string[] HeaderSummary, string OverrideGridType="")
        {

            string sExportDocumentPath = ConfigurationManager.AppSettings["ExportDocument"];
            string sTmpFileName = Convert.ToString(Guid.NewGuid());
            string sReportDownloadfileName = objReportFileNames[GridType];
            DateTime objCurrentDate = DateTime.Now;
            string sFormattedCurrentDate = Common.Common.ApplyFormatting(objCurrentDate, ConstEnum.DataFormatType.Date);
            sReportDownloadfileName = sReportDownloadfileName.Replace("<DATE>", sFormattedCurrentDate);

            ReportsSL objReportSL = new ReportsSL(GridType, OverrideGridType, (sExportDocumentPath + sTmpFileName + ".xlsx"));

            objReportSL.GenerateSheet(objReportTitles[GridType], sFormattedCurrentDate);

            objReportSL.AddReportHeaderSummary(HeaderSummary);

            objReportSL.AddReportSearchCriteria(SearchCriteria);

            objReportSL.GenerateReportTableHeader();
            
            objReportSL.SetColumnWidth();
            objReportSL.AddTableinSheet(Search);
            objReportSL.SaveToSheet(objReportSheetNames[GridType], "", false);
            objReportSL.SaveReport();
            
            /*Delete the old exported files which have been created one hours before*/
            string[] sFilesfromExportFolder = Directory.GetFiles(sExportDocumentPath);

            foreach (string sOldExportFile in sFilesfromExportFolder)
            {
                FileInfo fi = new FileInfo(sOldExportFile);
                if (fi.LastAccessTime < DateTime.Now.AddHours(-1))
                {
                    fi.Delete();
                }
            }
            /*Delete the old exported files which have been created two hours gefore*/

            string sFilePathToDownload = sExportDocumentPath + sTmpFileName + ".xlsx";
            //Download the file with given name in format "<Reportname>_<dd-MMM-YYYY>.xlsx"
            return File(new FileStream(sFilePathToDownload, FileMode.Open), ".xlsx", sReportDownloadfileName);
        }

        #region DefaulterReport
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult DefaulterReport(int acid, String inp_sParam)
        {

            int nGridType = Convert.ToInt32(ConstEnum.GridType.Report_Defaulter);
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1;
            string[] arrParameters = new string[20];
         
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, false);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, false);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, false);

            ViewBag.GradeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.GradeMaster, null, null, null, null, false);
            ViewBag.DepartmentList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.DepartmentMaster, null, null, null, null, false);
            ViewBag.CompanyList = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, false);
            ViewBag.UserTypeList = FillComboValues(ConstEnum.ComboType.UserType, null, null, null, null, null, false);
            ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
            ViewBag.NonComplainceTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.NonComplianceType, null, null, null, null, false);
            ViewBag.DefaulterReportCommentsList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.DefaulterReportComments, null, null, null, null, false);

            ViewBag.InsiderStatusDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.InsiderStatus).ToString(), null, null, null, null, false);

            arrParameters[0] = Convert.ToString(1);
            arrParameters[1] = "";
            arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = ""; arrParameters[7] = ""; arrParameters[8] = "";
            arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = ""; arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = "";
            arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = ""; arrParameters[19] = "";

            ViewBag.GridType = nGridType;
          //  ViewBag.EmployeeId = EmployeeId;

            ViewBag.ReportHeaderKeyValueData1JSON = FetchReportHeaderForReports(objLoginUserDetails, arrParameters, nGridType, out objReportHeaderKeyValueData1);
            ViewBag.ReportHeaderKeyValueData1 = objReportHeaderKeyValueData1;

            ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_Defaulter];


            ViewBag.ShowBackButton = false;
            //ViewBag.BackButtonUrl = Url.Action("Index", "CODashboard", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD) });
            ViewBag.acid = acid;
            ViewBag.ShowFilterSection = true;
            ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            FillGrid(Common.ConstEnum.GridType.Report_Defaulter, "0", null, null);

            ViewBag.SSRSRptId = "P5Mkjyvo+j4=";//8
            ViewBag.Rights = true;

            ViewData["inp_sParam"] = inp_sParam;
            return View("ReportView");
        }
        #endregion DefaulterReport

        #region SecurityTransferReport
        public ActionResult TransferReportCO(int acid)
        {
            ViewBag.CompanyList = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, false);
            ViewBag.UserTypeList = FillComboValues(ConstEnum.ComboType.UserType, null, null, null, null, null, false);
            ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
            ViewBag.acid = acid;
            ViewBag.ShowFilterSection = true;
            ViewBag.Title = objReportTitles[ConstEnum.GridType.SecuritiesTransferReportCO];
            ViewBag.OverrideGridType = "";
            FillGrid(Common.ConstEnum.GridType.SecuritiesTransferReportCO, "0", null, null);
            return View("ReportView");
        }
    	#endregion 

        #region SecurityTransferReport
        public ActionResult TransferReport(int acid)
        {
            string nOverrideGridType = "";
            int loginUserId;
            string[] arrParameters = new string[30];
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
            ViewBag.acid = acid;
            ViewBag.ShowFilterSection = true;
            nOverrideGridType = ConstEnum.GridType.SecuritiesTransferReportEmployee.ToString();
            ViewBag.OverrideGridType = nOverrideGridType;// ConstEnum.GridType.SecuritiesTransferReportCO;
            ViewBag.Title = objReportTitles[ConstEnum.GridType.SecuritiesTransferReportEmployee];

            loginUserId = objLoginUserDetails.LoggedInUserID;

            arrParameters[0] = Convert.ToString(loginUserId);
            arrParameters[1] = ""; arrParameters[2] = ""; arrParameters[3] = ""; arrParameters[4] = ""; arrParameters[5] = ""; arrParameters[6] = "";
            arrParameters[7] = ""; arrParameters[8] = ""; arrParameters[9] = ""; arrParameters[10] = ""; arrParameters[11] = ""; arrParameters[12] = "";
            arrParameters[13] = ""; arrParameters[14] = ""; arrParameters[15] = ""; arrParameters[16] = ""; arrParameters[17] = ""; arrParameters[18] = "";
            arrParameters[19] = ""; arrParameters[20] = ""; arrParameters[21] = ""; arrParameters[22] = ""; arrParameters[23] = ""; arrParameters[24] = "";
            arrParameters[25] = ""; arrParameters[26] = ""; arrParameters[27] = ""; arrParameters[28] = ""; arrParameters[29] = "";
            FillGrid(Common.ConstEnum.GridType.SecuritiesTransferReportCO, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
            ViewBag.ShowBackButton = true;
            ViewBag.BackButtonUrl = Url.Action("Index", "SecurityTransfer", new { @acid = Convert.ToString(Common.ConstEnum.UserActions.Security_Transfer_Holding_List) });
            return View("ReportView");
        }
        #endregion 

        [AuthorizationPrivilegeFilter]
        public ActionResult MarkOverride(long DefaulterReportID, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DefaulterReportOverrideDTO objDefaulterReportOverrideDTO = null;
            ReportsSL objReportsSL = new ReportsSL();
            try
            {
                objDefaulterReportOverrideDTO = objReportsSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, DefaulterReportID);
                DefaulterReportOverrideModel objDefaulterReportOverrideModel = new DefaulterReportOverrideModel();
                if (objDefaulterReportOverrideDTO != null)
                {
                    if (objDefaulterReportOverrideDTO.IsRemovedFromNonCompliance==1)
                    {
                        objDefaulterReportOverrideModel.IsRemovedFromNonCompliance = true;
                    }
                    else
                    {
                        objDefaulterReportOverrideModel.IsRemovedFromNonCompliance = false;
                    }
                    objDefaulterReportOverrideModel.Reason = objDefaulterReportOverrideDTO.Reason;
                   
                }
                objDefaulterReportOverrideModel.OverrideUpload = Common.Common.GenerateDocumentList(ConstEnum.Code.DefaulterReportMapType, Convert.ToInt32(DefaulterReportID), 0, null, ConstEnum.Code.DefaulterReportMapType, false, 0, 1);

                objDefaulterReportOverrideModel.DefaulterReportID = DefaulterReportID;
                return PartialView("~/Views/Reports/OverrideNonCompliance.cshtml", objDefaulterReportOverrideModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return RedirectToAction("DefaulterReport", "Reports", new { acid = InsiderTrading.Common.ConstEnum.UserActions.DEFAULTERREPORT_LIST});
            }

        }

        public JsonResult RemoveFromList(DefaulterReportOverrideModel objDefaulterReportOverrideModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DefaulterReportOverrideDTO objDefaulterReportOverrideDTO = null;
            ReportsSL objReportsSL = new ReportsSL();
            try
            {
                int iIsRemovedFromNonCompliance = 0;
                //if (objDefaulterReportOverrideModel.IsRemovedFromNonCompliance == null)
                //{
                //    ModelState.AddModelError("IsRemovedFromNonCompliance", "Please Select checkbox");
                //}
                //if (!ModelState.IsValid)
                //{
                //    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                //}
                if(objDefaulterReportOverrideModel.IsRemovedFromNonCompliance)
                {
                    iIsRemovedFromNonCompliance = 1;
                }
                objDefaulterReportOverrideDTO = objReportsSL.UpdateNonComplainceOverided(objLoginUserDetails.CompanyDBConnectionString, objDefaulterReportOverrideModel.DefaulterReportID, objDefaulterReportOverrideModel.Reason, iIsRemovedFromNonCompliance);
           
                return Json(new
                {
                    status = true,
                    Message = InsiderTrading.Common.Common.getResource("rpt_msg_19317") //"Mark Override Successfully."

                }, JsonRequestBehavior.AllowGet);
                
            }
            catch (Exception exp)
            {
                  ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                  return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }

        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

        #region Private Methods

        #region Populate Combo Methods

        private List<PopulateComboDTO> GetCODRequiredtypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";
            List<PopulateComboDTO> lstUserTypeList = new List<PopulateComboDTO>();
            //lstUserTypeList.Add(objPopulateComboDTO);
            lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                "165", null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstUserTypeList;
        }

        private List<PopulateComboDTO> GetUserTypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";
            List<PopulateComboDTO> lstUserTypeList = new List<PopulateComboDTO>();
            //lstUserTypeList.Add(objPopulateComboDTO);
            lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserType,
                null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstUserTypeList;
        }

        private List<PopulateComboDTO> GetCommentsDropDown(LoginUserDetails objLoginUserDetails, string Param1 = null)
        {
            List<PopulateComboDTO> lstComments = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";
            
            //lstComments.Add(objPopulateComboDTO);
            lstComments.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CommentType,
                Param1, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstComments;
        }

        private List<PopulateComboDTO> GetEmployeeDMATDetails(LoginUserDetails objLoginUserDetails, int nEmployeeId)
        {
            List<PopulateComboDTO> lstUserDmatList = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";

            //lstUserDmatList.Add(objPopulateComboDTO);
            lstUserDmatList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList,
                Convert.ToString(nEmployeeId), null, "WithRelativeDetails", null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstUserDmatList;
        }

        private List<PopulateComboDTO> GetEmployeeRelatives(LoginUserDetails objLoginUserDetails, int nEmployeeId)
        {
            List<PopulateComboDTO> lstUserRelationList = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            PopulateComboDTO objPopulateComboDTOSelf = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";
            objPopulateComboDTOSelf.Key = "0";
            objPopulateComboDTOSelf.Value = "Self";

            //lstUserRelationList.Add(objPopulateComboDTO);
            lstUserRelationList.Add(objPopulateComboDTOSelf);
            lstUserRelationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RelationshipWithInsider,
                Convert.ToString(nEmployeeId), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstUserRelationList;
        }

        private List<PopulateComboDTO> GetSecutiryTypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            List<PopulateComboDTO> lstSecurityType = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";

            //lstSecurityType.Add(objPopulateComboDTO);
            lstSecurityType.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                ConstEnum.CodeGroup.SecurityType, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstSecurityType;
        }

        private List<PopulateComboDTO> GetYearCodeTypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            List<PopulateComboDTO> lstYearTypeCode = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstYearTypeCodeUptoCurrentYear = new List<PopulateComboDTO>();
            lstYearTypeCode.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                ConstEnum.CodeGroup.FinancialYear, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

            //get current year 
            int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();

            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "";

            lstYearTypeCodeUptoCurrentYear.Add(objPopulateComboDTO);

            //in dropdown list include years less then current year
            foreach (PopulateComboDTO yr in lstYearTypeCode)
            {
                if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                {
                    lstYearTypeCodeUptoCurrentYear.Add(yr);
                }
            }
            return lstYearTypeCodeUptoCurrentYear;
        }

        private List<PopulateComboDTO> GetFinancialPeriodCodeDropDown(LoginUserDetails objLoginUserDetails)
        {
            //int period_type_code = 0;
            List<PopulateComboDTO> lstFinancialPeriods = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstYearTypeCodeUptoCurrentYear = new List<PopulateComboDTO>();
            //period_type_code = Common.Common.GetConfiguartionCode(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PeriodType);

            lstFinancialPeriods = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialPeriod, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>();

            //get current year 
            int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();

            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "";

            lstYearTypeCodeUptoCurrentYear.Add(objPopulateComboDTO);

            //in dropdown list include years less then current year
            foreach (PopulateComboDTO yr in lstFinancialPeriods)
            {
                //if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                //{
                    lstYearTypeCodeUptoCurrentYear.Add(yr);
                //}
            }

            return lstYearTypeCodeUptoCurrentYear;
        }

        private List<PopulateComboDTO> GetTransactionTypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            List<PopulateComboDTO> lstTransactionType = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";

            //lstTransactionType.Add(objPopulateComboDTO);
            lstTransactionType.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                ConstEnum.CodeGroup.TransactionType, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstTransactionType;
        }

        private List<PopulateComboDTO> GetPreclearenceStatusTypeDropDown(LoginUserDetails objLoginUserDetails)
        {
            List<PopulateComboDTO> PreclearenceStatusTypeCode = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "All";

            //PreclearenceStatusTypeCode.Add(objPopulateComboDTO);
            PreclearenceStatusTypeCode.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return PreclearenceStatusTypeCode;
        }

        private List<PopulateComboDTO> GetInsiderStatusDropDown(LoginUserDetails objLoginUserDetails)
        {
            
            List<PopulateComboDTO> PreclearenceStatusTypeCode = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstInsiderStatusList = new List<PopulateComboDTO>();
            lstInsiderStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.InsiderStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstInsiderStatusList;
        }

        private string FetchReportHeaderForReports(LoginUserDetails objLoginUserDetails, string[] arrParameters, int nGridType, 
            out IEnumerable<ReportHeaderKeyValueDTO> objReportHeaderKeyValueData1)
        {
            ReportsSL objReportsSL = new ReportsSL();
            objReportHeaderKeyValueData1 = objReportsSL.FetchReportHeaderKeyValueDetails(objLoginUserDetails.CompanyDBConnectionString, nGridType, arrParameters);
            JavaScriptSerializer ser = new JavaScriptSerializer();
            string objReportHeaderKeyValueData1JSON = ser.Serialize(objReportHeaderKeyValueData1);
            return objReportHeaderKeyValueData1JSON;
        }

        private List<PopulateComboDTO> GetTradingAllowedOptionDropDown()
        {
            List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();

            //PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            //objPopulateComboDTO.Key = "";
            //objPopulateComboDTO.Value = "Select"; 
            //lstPopulateComboDTO.Add(objPopulateComboDTO);

            PopulateComboDTO objPopulateComboDTO2 = new PopulateComboDTO();
            objPopulateComboDTO2.Key = ConstEnum.RestrictedListTrading.Allowed.ToString();
            objPopulateComboDTO2.Value = ConstEnum.RestrictedListTrading.Allowed_Display;
            lstPopulateComboDTO.Add(objPopulateComboDTO2);

            PopulateComboDTO objPopulateComboDTO3 = new PopulateComboDTO();
            objPopulateComboDTO3.Key = ConstEnum.RestrictedListTrading.NotAllowed.ToString();
            objPopulateComboDTO3.Value = ConstEnum.RestrictedListTrading.NotAllowed_Display;
            lstPopulateComboDTO.Add(objPopulateComboDTO3);

            return lstPopulateComboDTO;
        }

        private List<PopulateComboDTO> GetEmployeeIDDropdown(LoginUserDetails objLoginUserDetails)
        {
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "All";
            List<PopulateComboDTO> lstEmployeeIDList = new List<PopulateComboDTO>();
            lstEmployeeIDList.Add(objPopulateComboDTO);
            lstEmployeeIDList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfEmployeeID,
                null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstEmployeeIDList;
        }

        #endregion Populate Combo Methods

        #region FillComboValues
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }



                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, i_nComboType,
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "cmp_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion FillComboValues

        #region FillGrid
        /// <summary>
        /// 
        /// </summary>
        /// <param name="m_nGridType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
        }
        #endregion FillGrid

        #endregion Private Methods
        //public File

        [AuthorizationPrivilegeFilter]
        public ActionResult UserEULAAcceptance(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.GridType = Convert.ToInt32(ConstEnum.GridType.Report_EULAAcceptanceReport);
                ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_EULAAcceptanceReport];
                ViewBag.EmployeeIDDropdown = GetEmployeeIDDropdown(objLoginUserDetails);
                ViewBag.ShowBackButton = false;
                ViewBag.acid = acid;
                ViewBag.ShowFilterSection = true;
                ViewBag.Rights = true;
            }
            catch (Exception exp)
            {

            }
            return View("ReportView");
        }
	}
}