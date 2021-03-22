using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class PeriodEndDisclosure_OSController : Controller
    {
        private string sLookupPrefix = "tra_msg_";
        //
        // GET: /PeriodEndDisclosure_OS/
        #region Period Status- Other Securities
        public ActionResult PeriodStatusOS(int acid, int year = 0, int uid = 0, int PeriodEndDisCheck = 0, int IsIDPending = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            bool backToCOList = false;

            //int activity_id_disclosure = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS;
            //int activity_id_disclosure_letter = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                ViewBag.activity_id = acid;

                if (IsIDPending > 0)
                    ModelState.AddModelError("IsIDPending", Common.Common.getResource("dis_msg_53145"));

                if (PeriodEndDisCheck > 0)
                    ModelState.AddModelError("PEDisclosureStatus", Common.Common.getResource("dis_msg_53140"));

                //if login user is CO or admin then show back button on view which redirect back to CO screen for user list
                if (acid == ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS || objLoginUserDetails.UserTypeCodeId == 101001 || objLoginUserDetails.UserTypeCodeId == 101002)
                {
                    backToCOList = true; //set flag to show back button 

                    //activity_id_disclosure = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS;
                    //activity_id_disclosure_letter = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;

                    //if activity id is for CO then fetch employee insider details 
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, uid);

                        ViewBag.EmployeeId = objUserInfoDTO.EmployeeId;
                        ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                    }
                }
                //get current year 
                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                //show last period end year as default selected
                int lastPeriodEndYearCode = CurrentYearCode;

                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                //NOTE -- this year list should be from year when user has become insider. 
                //user should be not be able to see ealier year as there won't be any records for earlier year or date from system is implemeted which ever is later 
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();


                //in dropdown list include years less then current year
                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosurePeriodStatusList_OS;

                ViewBag.backToCOList = backToCOList;

                //ViewBag.activity_id_disclosure = activity_id_disclosure;
                //ViewBag.activity_id_disclosure_letter = activity_id_disclosure_letter;
                ViewBag.uid = uid;
            }
            catch (Exception)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoDTO = null;
            }
            return View("PeriodStatusOS");
        }
        #endregion Period Status- Other Securities


        #region UserStatusOS View
        [AuthorizationPrivilegeFilter]
        public ActionResult UserStatusOS(int acid, int year = 0, int period = 0, int Uid = 0)
        {
            LoginUserDetails objLoginUserDetails = null;

            int period_type_code = 0;
            try
            {
                ViewBag.activity_id = acid;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                //get financial year list
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();

                //get current year 
                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                //in dropdown list include years less then current year
                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                //show last period end year as default selected
                int lastPeriodEndYearCode = CurrentYearCode;
                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                //get configuation code for period type 
                period_type_code = Common.Common.GetConfiguartionCode(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PeriodType);

                //get period type list 
                List<PopulateComboDTO> Periodlist = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialPeriod, period_type_code.ToString(), null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();
                ViewBag.PeriodDropDown = Periodlist;

                //show last period end year as default selected
                using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                {
                    int lastPeriodEndPeriodCode = objPeriodEndDisclosureSL.GetLastestPeriodEndPeriodCode(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.LastPeriodEndPeriod = (period == 0) ? lastPeriodEndPeriodCode : period;
                }

                // get trading submission status list
                ViewBag.TradingSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, true, sLookupPrefix);

                //get soft copy submission status list
                ViewBag.SoftCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get hard copy submission status list
                ViewBag.HardCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get stock exchange submission status list
                ViewBag.StockExchangeSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.EmployeeStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosure_OS_UsersStatusList;

                //int activity_id_disclosure_letter = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
                //ViewBag.activity_id_disclosure_letter = CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS;

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

            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("UserStatusOS");
        }
        #endregion UserStatusOS View

        #region FillComboValues
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sDBConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="i_bIsDefaultValue"></param>
        /// <param name="i_sLookupPrefix"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(string i_sDBConnectionString, int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue, string i_sLookupPrefix)
        {
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;

            try
            {
                objPopulateComboDTO = new PopulateComboDTO();
                lstPopulateComboDTO = new List<PopulateComboDTO>();

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }

                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(i_sDBConnectionString, i_nComboType, i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, i_sLookupPrefix).ToList<PopulateComboDTO>());

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objPopulateComboDTO = null;
            }

            return lstPopulateComboDTO;
        }
        #endregion FillComboValues

        //#region User Status- Other Securities
        //public ActionResult UserStatusOS(int acid, int year = 0, int period = 0, int Uid = 0)
        //{
        //   // ViewBag.activity_id_disclosure = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS;
        //    int activity_id_disclosure_letter = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
        //    ViewBag.activity_id_disclosure_letter = activity_id_disclosure_letter;
        //    return View();
        //}
        //#endregion User Status- Other Securities

        #region Summary- Other Securities
        [AuthorizationPrivilegeFilter]
        public ActionResult SummaryOS(int acid, int period, int year, int pdtype, int uid = 0, int tmid = 0)
        {
            List<DocumentDetailsModel> lstDocumentDetailsDTO = new List<DocumentDetailsModel>();
            PeriodEndDisclosureModel_OS periodEndDisclosure = new PeriodEndDisclosureModel_OS();
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            ViewBag.showAddTransactionBtn = false;
            DateTime dtEndDate = DateTime.Now;
            ViewBag.isAllEdit = true;

            Dictionary<string, object> dicPeriodStartEnd = null;
            ViewBag.UserAction = acid;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                //set activity id for summary page as this page is access from both menu - insider and CO
                ViewBag.activity_id = acid;

                using (PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                {
                    dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtype);

                    DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                    dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                    String dtFormat = "dd MMM yyyy";
                    ViewBag.Period = dtStartDate.ToString(dtFormat) + " - " + dtEndDate.ToString(dtFormat);
                }
                //set input vaules for period end summary grid
                ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                ViewBag.YearCode = year;
                ViewBag.PeriodCode = period;
                ViewBag.PeriodType = pdtype;
                ViewBag.TransactionMasterId = (tmid == 0) ? "" : tmid.ToString();

                //if activity id is for CO then fetch employee insider details 
                if (acid == ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, uid);

                        ViewBag.EmployeeId = objUserInfoDTO.EmployeeId;
                        ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                    }
                }
                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureSummaryList_OS;

                int PEDisStatusCount = 0;
                int IsIDPending = 0;

                //Get taransaction details & if transaction not submitted then set showAddTransactionBtn button panel true else false
                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    List<ContinuousDisclosureStatusDTO> lstPEDisclosureStatus = objTradingTransactionSL_OS.Get_PEDisclosureStatus(objLoginUserDetails.CompanyDBConnectionString, uid, dtEndDate);
                    foreach (var periodEndStatus in lstPEDisclosureStatus)
                    {
                        PEDisStatusCount = periodEndStatus.PEDisPendingStatus;
                        IsIDPending = periodEndStatus.IsRelativeFound;
                    }
                    if (IsIDPending > 0)
                    {
                        return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid, year, uid, PEDisStatusCount, IsIDPending });
                    }
                    if (PEDisStatusCount > 0)
                    {
                        int PeriodEndDisCheck = PEDisStatusCount;
                        return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid, year, uid, PeriodEndDisCheck });
                    }
                    else
                    {
                        TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_Details = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, tmid);
                        if (objTradingTransactionMasterDTO_Details.TransactionStatusCodeId == 148002)
                        {
                            periodEndDisclosure.PeriodEndDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PeriodEndDisclosure_OS, ViewBag.UserId, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PeriodEndDocumentUpload);
                            ViewBag.showAddTransactionBtn = true;
                            ViewBag.isAllEdit = false;
                        }
                        else
                        {
                            periodEndDisclosure.PeriodEndDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PeriodEndDisclosure_OS, ViewBag.UserId, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PeriodEndDocumentUpload);
                            ViewBag.isAllEdit = true;
                        }
                    }
                }
            }
            catch (Exception)
            {

            }
            finally
            {
                dicPeriodStartEnd = null;
                objLoginUserDetails = null;
                objUserInfoDTO = null;
            }

            return View(periodEndDisclosure);
        }
        #endregion Summary- Other Securities

        #region DownloadDetails- Other Securities
        public ActionResult DownloadDetails(int acid, int period, int year, int pdtype, int uid = 0, int tmid = 0)
        {
            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            int periodType = period;
            int yearCode = year;
            int userId = uid;
            int transactionMasterId = tmid;
            string exlFilename = string.Empty;
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string workSheetName1 = string.Empty;
            string workSheetName2 = string.Empty;
            string cellRange = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            SqlCommand cmd1 = new SqlCommand();
            con.Open();
            DataTable dtPeriodSummaryComapnyWise = new DataTable();
            DataTable dtDematTotal = new DataTable();
            DataTable dtSecurityTypeTotal = new DataTable();
            DataTable dtPeriodTransactionDetails = new DataTable();
            Dictionary<string, object> dicPeriodStartEnd = null;
            DateTime dtEndDate = DateTime.Now;
            String periodStartEndDate = string.Empty;
            int tempDematCount = 0;
            bool tempDematFlag = false;
            int tempSecurityCount = 0;
            bool tempSecurityFlag = false;
            ViewBag.isAllEdit = true;
            PeriodEndDisclosureModel_OS periodEndDisclosure = new PeriodEndDisclosureModel_OS();
            var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;

            try
            {
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);

                exlFilename = "Period End Summary-Other Securities.xls";
                workSheetName1 = "Holding Summary";
                for (int reportNo = 1; reportNo <= 3; reportNo++)
                {
                    spName = "st_tra_PeriodEndDisclosurePeriodSummaryComapnyWise_OS";
                    cmd = new SqlCommand(spName, con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@inp_iUserInfoId", userId);
                    cmd.Parameters.Add("@inp_iYearCodeId", yearCode);
                    cmd.Parameters.Add("@inp_iPeriodCodeID", periodType);
                    cmd.Parameters.Add("@inp_iReportType", reportNo);
                    SqlDataAdapter adp = new SqlDataAdapter(cmd);
                    if (reportNo == 1)
                        adp.Fill(dtPeriodSummaryComapnyWise);
                    else if (reportNo == 2)
                        adp.Fill(dtDematTotal);
                    else
                        adp.Fill(dtSecurityTypeTotal);
                }
                spName = "st_tra_PeriodEndDisclosureTransactionDetails_OS";
                workSheetName2 = "Transaction Details";
                cmd1 = new SqlCommand(spName, con);
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@inp_iTransactionMasterId", transactionMasterId);
                cmd1.Parameters.Add("@inp_iUserInfoId", userId);
                SqlDataAdapter adp1 = new SqlDataAdapter(cmd1);
                adp1.Fill(dtPeriodTransactionDetails);

                //Get Period End Dates
                using (PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                {
                    dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtype);

                    DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                    dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                    String dtFormat = "dd MMM yyyy";
                    periodStartEndDate = dtStartDate.ToString(dtFormat) + " - " + dtEndDate.ToString(dtFormat);
                }
                //set input vaules for period end summary grid
                ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                ViewBag.YearCode = year;
                ViewBag.PeriodCode = period;
                ViewBag.PeriodType = pdtype;
                ViewBag.TransactionMasterId = (tmid == 0) ? "" : tmid.ToString();
                ViewBag.activity_id = acid;
                ViewBag.UserAction = acid;
                ViewBag.showAddTransactionBtn = true;
                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureSummaryList_OS;
                ViewBag.Period = periodStartEndDate;

                if ((dtPeriodSummaryComapnyWise == null || dtPeriodSummaryComapnyWise.Rows.Count == 0) && (dtPeriodTransactionDetails == null || dtPeriodTransactionDetails.Rows.Count == 0))
                {

                    ViewBag.ErrorFound = true;
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_Details = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, tmid);
                        if (objTradingTransactionMasterDTO_Details.TransactionStatusCodeId == 148002)
                        {
                            ModelState.AddModelError("DataNotFound", Common.Common.getResource("dis_msg_53136"));
                            ViewBag.showAddTransactionBtn = true;
                        }
                        else
                        {
                            ModelState.AddModelError("DataNotFound", Common.Common.getResource("dis_msg_54176"));
                            ViewBag.showAddTransactionBtn = false;
                        }
                    }
                    return View("SummaryOS");
                }

                if ((dtPeriodSummaryComapnyWise != null || dtPeriodSummaryComapnyWise.Rows.Count != 0) && (dtPeriodTransactionDetails != null || dtPeriodTransactionDetails.Rows.Count != 0))
                {
                    ExcelPackage excel = new ExcelPackage();
                    //Bind worksheet- PeriodSummaryComapnyWise
                    var worksheetSummery = excel.Workbook.Worksheets.Add(workSheetName1);
                    var totalColsSheetOne = dtPeriodSummaryComapnyWise.Columns.Count;
                    var totalRowsSheetOne = dtPeriodSummaryComapnyWise.Rows.Count;

                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                    {
                        worksheetSummery.Cells["A1:H1"].Merge = true;
                        worksheetSummery.Cells["A1:H1"].Value = "Summary of holdings of other securities";
                        worksheetSummery.Cells["A1:H1"].Style.Border.Top.Style = worksheetSummery.Cells["A1:H1"].Style.Border.Bottom.Style = worksheetSummery.Cells["A1:H1"].Style.Border.Left.Style = worksheetSummery.Cells["A1:H1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheetSummery.Cells["A1:H1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetSummery.Cells["A1:H1"].Style.Font.Bold = true;
                        worksheetSummery.Cells["A1:H1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        worksheetSummery.Cells["A1:H1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        //Bind Period Dates
                        worksheetSummery.Cells["A2:H2"].Merge = true;
                        worksheetSummery.Cells["A2:H2"].Value = "Period:   " + periodStartEndDate;
                        worksheetSummery.Cells["A2:H2"].Style.Font.Bold = true;
                        worksheetSummery.Cells["A2:H2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        worksheetSummery.Cells["A2:H2"].Style.Border.Top.Style = worksheetSummery.Cells["A2:H2"].Style.Border.Bottom.Style = worksheetSummery.Cells["A2:H2"].Style.Border.Left.Style = worksheetSummery.Cells["A2:H2"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        worksheetSummery.Cells["A1:E1"].Merge = true;
                        worksheetSummery.Cells["A1:E1"].Value = "Summary of holdings of other securities";
                        worksheetSummery.Cells["A1:E1"].Style.Border.Top.Style = worksheetSummery.Cells["A1:E1"].Style.Border.Bottom.Style = worksheetSummery.Cells["A1:E1"].Style.Border.Left.Style = worksheetSummery.Cells["A1:E1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheetSummery.Cells["A1:E1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetSummery.Cells["A1:E1"].Style.Font.Bold = true;
                        worksheetSummery.Cells["A1:E1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        worksheetSummery.Cells["A1:E1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        //Bind Period Dates
                        worksheetSummery.Cells["A2:E2"].Merge = true;
                        worksheetSummery.Cells["A2:E2"].Value = "Period:   " + periodStartEndDate;
                        worksheetSummery.Cells["A2:E2"].Style.Font.Bold = true;
                        worksheetSummery.Cells["A2:E2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        worksheetSummery.Cells["A2:E2"].Style.Border.Top.Style = worksheetSummery.Cells["A2:E2"].Style.Border.Bottom.Style = worksheetSummery.Cells["A2:E2"].Style.Border.Left.Style = worksheetSummery.Cells["A2:E2"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    //Bind Table Column
                    for (var col = 1; col <= totalColsSheetOne; col++)
                    {
                        if (col < 10)
                        {
                            worksheetSummery.Cells[3, col].Value = dtPeriodSummaryComapnyWise.Columns[col - 1].ColumnName;
                            worksheetSummery.Cells[3, col].Style.Font.Name = "Arial";
                            worksheetSummery.Cells[3, col].Style.Font.Size = 10;
                            worksheetSummery.Cells[3, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                            if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                            {
                                cellRange = "A3:H3";
                            }
                            else
                            {
                                cellRange = "A3:E3";
                            }
                            using (ExcelRange rng = worksheetSummery.Cells[cellRange])
                            {
                                rng.Style.WrapText = true;
                                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                rng.Style.Font.Bold = true;
                                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                            }
                        }
                    }

                    //Bind Table Data
                    int excelRow = 3;
                    if (dtPeriodSummaryComapnyWise.Rows.Count == 0)
                    {
                        worksheetSummery.Cells["A4:H4"].Merge = true;
                        worksheetSummery.Cells["A4:H4"].Value = Common.Common.getResource("dis_msg_54175");
                        worksheetSummery.Cells["A4:H4"].Style.Font.Name = "Arial";
                        worksheetSummery.Cells["A4:H4"].Style.Font.Size = 10;
                        worksheetSummery.Cells["A4:H4"].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        worksheetSummery.Cells["A4:H4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetSummery.Cells["A4:H4"].Style.Border.Top.Style = worksheetSummery.Cells["A4:H4"].Style.Border.Bottom.Style = worksheetSummery.Cells["A4:H4"].Style.Border.Left.Style = worksheetSummery.Cells["A4:H4"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        for (var row = 0; row < totalRowsSheetOne; row++)
                        {
                            for (var col = 0; col < totalColsSheetOne; col++)
                            {
                                if (col < 9)
                                {
                                    worksheetSummery.Cells[excelRow + 1, col + 1].Value = dtPeriodSummaryComapnyWise.Rows[row][col].ToString();
                                    worksheetSummery.Cells[excelRow + 1, col + 1].Style.Border.Top.Style = worksheetSummery.Cells[excelRow + 1, col + 1].Style.Border.Bottom.Style = worksheetSummery.Cells[excelRow + 1, col + 1].Style.Border.Left.Style = worksheetSummery.Cells[excelRow + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                    worksheetSummery.Cells[excelRow + 1, col + 1].Style.WrapText = true;
                                    worksheetSummery.Cells[excelRow + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                    worksheetSummery.Cells[excelRow + 1, col + 1].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                }
                            }
                            if (tempDematFlag == false)
                                tempDematCount = row;
                            else
                                tempDematCount++;

                            if (tempSecurityFlag == false)
                                tempSecurityCount = row;
                            else
                                tempSecurityCount++;
                            for (var rowDemat = 0; rowDemat < (dtDematTotal.Rows.Count); rowDemat++)
                            {
                                if ((dtPeriodSummaryComapnyWise.Rows[row][3].ToString() == dtDematTotal.Rows[rowDemat][4].ToString()) //dematID
                                    && (dtPeriodSummaryComapnyWise.Rows[row][2].ToString() == dtDematTotal.Rows[rowDemat][3].ToString())//SecurityType
                                    && ((tempDematCount + 1).ToString() == dtDematTotal.Rows[rowDemat][0].ToString()))// rowno == count
                                {
                                    excelRow = excelRow + 1;
                                    worksheetSummery.Cells[excelRow + 1, 4].Value = "Total Demat " + dtDematTotal.Rows[rowDemat][4].ToString();
                                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                                    {
                                        //worksheetSummery.Cells[excelRow + 1, 6].Value = dtDematTotal.Rows[rowDemat][5].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 6].Value = dtDematTotal.Rows[rowDemat][6].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 7].Value = dtDematTotal.Rows[rowDemat][7].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 8].Value = dtDematTotal.Rows[rowDemat][8].ToString();
                                    }
                                    worksheetSummery.Cells[excelRow + 1, 9].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 1].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 2].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 3].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 5].Value = string.Empty;
                                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                                    {
                                        cellRange = "D" + (excelRow + 1) + ":H" + (excelRow + 1);
                                    }
                                    else
                                    {
                                        cellRange = "D" + (excelRow + 1) + ":E" + (excelRow + 1);
                                    }
                                    using (ExcelRange rng = worksheetSummery.Cells[cellRange])
                                    {
                                        rng.Style.WrapText = true;
                                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                        rng.Style.Font.Bold = true;
                                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                                    }
                                    cellRange = "A" + (excelRow + 1) + ":C" + (excelRow + 1);
                                    using (ExcelRange rng = worksheetSummery.Cells[cellRange])
                                    {
                                        rng.Style.WrapText = true;
                                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                    }
                                    tempDematCount = -1;
                                    tempDematFlag = true;
                                    break;
                                }
                            }
                            for (var rowSecurity = 0; rowSecurity < (dtSecurityTypeTotal.Rows.Count); rowSecurity++)
                            {
                                if ((dtPeriodSummaryComapnyWise.Rows[row][0].ToString() == dtSecurityTypeTotal.Rows[rowSecurity][1].ToString()) //UserName
                                   && (dtPeriodSummaryComapnyWise.Rows[row][2].ToString() == dtSecurityTypeTotal.Rows[rowSecurity][3].ToString())//SecurityType
                                   && ((tempSecurityCount + 1).ToString() == dtSecurityTypeTotal.Rows[rowSecurity][0].ToString()))// rowno == count
                                {
                                    excelRow = excelRow + 1;
                                    worksheetSummery.Cells[excelRow + 1, 1].Value = dtSecurityTypeTotal.Rows[rowSecurity][1].ToString();
                                    worksheetSummery.Cells[excelRow + 1, 2].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 3].Value = "Total " + dtSecurityTypeTotal.Rows[rowSecurity][3].ToString();
                                    worksheetSummery.Cells[excelRow + 1, 4].Value = string.Empty;
                                    worksheetSummery.Cells[excelRow + 1, 5].Value = string.Empty;
                                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                                    {
                                        //worksheetSummery.Cells[excelRow + 1, 6].Value = dtSecurityTypeTotal.Rows[rowSecurity][4].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 6].Value = dtSecurityTypeTotal.Rows[rowSecurity][5].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 7].Value = dtSecurityTypeTotal.Rows[rowSecurity][6].ToString();
                                        worksheetSummery.Cells[excelRow + 1, 8].Value = dtSecurityTypeTotal.Rows[rowSecurity][7].ToString();
                                    }
                                    worksheetSummery.Cells[excelRow + 1, 9].Value = string.Empty;
                                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                                    {
                                        cellRange = "A" + (excelRow + 1) + ":H" + (excelRow + 1);
                                    }
                                    else
                                    {
                                        cellRange = "A" + (excelRow + 1) + ":E" + (excelRow + 1);
                                    }
                                    using (ExcelRange rng = worksheetSummery.Cells[cellRange])
                                    {
                                        rng.Style.WrapText = true;
                                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                                        rng.Style.Font.Bold = true;
                                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                        rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightBlue);
                                    }
                                    tempSecurityCount = -1;
                                    tempSecurityFlag = true;
                                    break;
                                }
                            }
                            excelRow++;
                        }
                    }
                    //Set all column width
                    worksheetSummery.Column(1).Width = 20;
                    worksheetSummery.Column(2).Width = 12;
                    worksheetSummery.Column(3).Width = 25;
                    worksheetSummery.Column(4).Width = 25;
                    worksheetSummery.Column(5).Width = 30;
                    worksheetSummery.Column(6).Width = 18;
                    worksheetSummery.Column(7).Width = 18;
                    worksheetSummery.Column(8).Width = 18;
                    worksheetSummery.Column(9).Width = 18;
                    //Set numeric column to right align
                    worksheetSummery.Column(4).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    worksheetSummery.Column(6).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    worksheetSummery.Column(7).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    worksheetSummery.Column(8).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    worksheetSummery.Column(9).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    //Bind worksheet- PeriodTransactionDetails
                    var worksheetDetails = excel.Workbook.Worksheets.Add(workSheetName2);
                    var totalColsSheetTwo = dtPeriodTransactionDetails.Columns.Count;
                    var totalRowsSheetTwo = dtPeriodTransactionDetails.Rows.Count;

                    if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                    {
                        worksheetDetails.Cells["A1:N1"].Merge = true;
                        worksheetDetails.Cells["A1:N1"].Value = "Transaction Details for the period ";
                        worksheetDetails.Cells["A1:N1"].Style.Border.Top.Style = worksheetDetails.Cells["A1:N1"].Style.Border.Bottom.Style = worksheetDetails.Cells["A1:N1"].Style.Border.Left.Style = worksheetDetails.Cells["A1:N1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheetDetails.Cells["A1:N1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetDetails.Cells["A1:N1"].Style.Font.Bold = true;
                        worksheetDetails.Cells["A1:N1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        worksheetDetails.Cells["A1:N1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        //Bind Period Dates
                        worksheetDetails.Cells["A2:N2"].Merge = true;
                        worksheetDetails.Cells["A2:N2"].Value = "Period:   " + periodStartEndDate;
                        worksheetDetails.Cells["A2:N2"].Style.Font.Bold = true;
                        worksheetDetails.Cells["A2:N2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        worksheetDetails.Cells["A2:N2"].Style.Border.Top.Style = worksheetDetails.Cells["A2:N2"].Style.Border.Bottom.Style = worksheetDetails.Cells["A2:N2"].Style.Border.Left.Style = worksheetDetails.Cells["A2:N2"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        worksheetDetails.Cells["A1:J1"].Merge = true;
                        worksheetDetails.Cells["A1:J1"].Value = "Transaction Details for the period ";
                        worksheetDetails.Cells["A1:J1"].Style.Border.Top.Style = worksheetDetails.Cells["A1:J1"].Style.Border.Bottom.Style = worksheetDetails.Cells["A1:J1"].Style.Border.Left.Style = worksheetDetails.Cells["A1:J1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        worksheetDetails.Cells["A1:J1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetDetails.Cells["A1:J1"].Style.Font.Bold = true;
                        worksheetDetails.Cells["A1:J1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        worksheetDetails.Cells["A1:J1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        //Bind Period Dates
                        worksheetDetails.Cells["A2:J2"].Merge = true;
                        worksheetDetails.Cells["A2:J2"].Value = "Period:   " + periodStartEndDate;
                        worksheetDetails.Cells["A2:J2"].Style.Font.Bold = true;
                        worksheetDetails.Cells["A2:J2"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        worksheetDetails.Cells["A2:J2"].Style.Border.Top.Style = worksheetDetails.Cells["A2:J2"].Style.Border.Bottom.Style = worksheetDetails.Cells["A2:J2"].Style.Border.Left.Style = worksheetDetails.Cells["A2:J2"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    //Bind Table Column
                    for (var col = 1; col <= totalColsSheetTwo; col++)
                    {
                        worksheetDetails.Cells[3, col].Value = dtPeriodTransactionDetails.Columns[col - 1].ColumnName;
                        worksheetDetails.Cells[3, col].Style.Font.Name = "Arial";
                        worksheetDetails.Cells[3, col].Style.Font.Size = 10;
                        worksheetDetails.Cells[3, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        string cellRange1 = "";
                        if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue != 400003)
                        {
                            cellRange1 = "A3:N3";
                        }
                        else
                        {
                            cellRange1 = "A3:J3";
                        }
                        using (ExcelRange rng1 = worksheetDetails.Cells[cellRange1])
                        {
                            rng1.Style.WrapText = true;
                            rng1.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                            rng1.Style.Font.Bold = true;
                            rng1.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                            rng1.Style.Border.Top.Style = rng1.Style.Border.Bottom.Style = rng1.Style.Border.Left.Style = rng1.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            rng1.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            rng1.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                        }
                    }
                    //Bind table rows
                    int excelRow1 = 3;
                    if (dtPeriodTransactionDetails.Rows.Count == 0)
                    {
                        worksheetDetails.Cells["A4:N4"].Merge = true;
                        worksheetDetails.Cells["A4:N4"].Value = Common.Common.getResource("dis_msg_54175");
                        worksheetDetails.Cells["A4:N4"].Style.Font.Name = "Arial";
                        worksheetDetails.Cells["A4:N4"].Style.Font.Size = 10;
                        worksheetDetails.Cells["A4:N4"].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        worksheetDetails.Cells["A4:N4"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        worksheetDetails.Cells["A4:N4"].Style.Border.Top.Style = worksheetDetails.Cells["A4:N4"].Style.Border.Bottom.Style = worksheetDetails.Cells["A4:N4"].Style.Border.Left.Style = worksheetDetails.Cells["A4:N4"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        for (var row = 0; row < totalRowsSheetTwo; row++)
                        {
                            for (var col = 0; col < totalColsSheetTwo; col++)
                            {
                                worksheetDetails.Cells[excelRow1 + 1, col + 1].Value = dtPeriodTransactionDetails.Rows[row][col].ToString();
                                worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.Border.Top.Style = worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.Border.Bottom.Style = worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.Border.Left.Style = worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                                worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.WrapText = true;
                                worksheetDetails.Cells[excelRow1 + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                            }
                            excelRow1++;
                        }

                        //Set Column width
                        worksheetDetails.Column(1).Width = 30;
                        worksheetDetails.Column(2).Width = 12;
                        worksheetDetails.Column(3).Width = 22;
                        worksheetDetails.Column(4).Width = 18;
                        worksheetDetails.Column(5).Width = 30;
                        worksheetDetails.Column(6).Width = 12;
                        worksheetDetails.Column(7).Width = 20;
                        worksheetDetails.Column(8).Width = 18;
                        worksheetDetails.Column(9).Width = 15;
                        worksheetDetails.Column(10).Width = 15;
                        worksheetDetails.Column(11).Width = 12;
                        worksheetDetails.Column(12).Width = 18;
                        worksheetDetails.Column(13).Width = 12;
                        worksheetDetails.Column(14).Width = 20;
                        //Set column alignment 
                        worksheetDetails.Column(3).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                        worksheetDetails.Column(11).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                        worksheetDetails.Column(12).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                        worksheetDetails.Column(13).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    }
                    //Download Excel
                    using (var memoryStream = new MemoryStream())
                    {
                        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                        Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
                        excel.SaveAs(memoryStream);
                        memoryStream.WriteTo(Response.OutputStream);
                        Response.Flush();
                        Response.End();
                    }

                    periodEndDisclosure.PeriodEndDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PeriodEndDisclosure_OS, ViewBag.UserId, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentFile);

                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                con = null;
                cmd = null;
                cmd1 = null;
                dtPeriodSummaryComapnyWise = null;
                dtDematTotal = null;
                dtSecurityTypeTotal = null;
                dtPeriodTransactionDetails = null;
            }
            return View("SummaryOS", periodEndDisclosure);
        }
        #endregion DownloadDetails- Other Securities
        #region DownloadForm G Other Securities
        [ValidateInput(false)]
        [AuthorizationPrivilegeFilter]
        public ActionResult DownloadFormGOS(int acid, int MapToTypeCodeId = 0, int tmid = 0)
        {

            LoginUserDetails objLoginUserDetails = null;

            FormGDetails_OSDTO objFormGDetails_OSDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                using (PeriodEndDisclosureSL_OS objInsiderInitialDisclosureSL_OS = new PeriodEndDisclosureSL_OS())
                {
                    objFormGDetails_OSDTO = objInsiderInitialDisclosureSL_OS.GetFormGOSDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.DisclosureTransactionforOS, Convert.ToInt32(tmid));


                    Response.Clear();
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.ContentType = "application/pdf";
                    Response.AppendHeader("content-disposition", "attachment;filename=" + Common.Common.getResource("dis_lbl_54173") + ".pdf");
                    Response.Flush();
                    Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                    Response.Buffer = true;

                    string LetterHTMLContent = objFormGDetails_OSDTO.GeneratedFormContents;
                    System.Text.RegularExpressions.Regex rReplaceScript = new System.Text.RegularExpressions.Regex(@"<br>");
                    LetterHTMLContent = rReplaceScript.Replace(LetterHTMLContent, "<br />");


                    using (var ms = new MemoryStream())
                    {
                        using (var doc = new Document(PageSize.A4, 20f, 20f, 20f, 20f))
                        {
                            using (var writer = PdfWriter.GetInstance(doc, Response.OutputStream))
                            {
                                doc.Open();
                                doc.NewPage();

                                using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                {
                                    using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                    {
                                        iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                    }
                                }

                                doc.Close();
                            }

                            Response.Write(doc);
                            Response.End();

                        }
                    }


                }
                return null;
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Warning", Common.Common.GetErrorMessage(exp));
                return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS }).Success(Common.Common.getResource("dis_msg_54171"));
            }

        }
        #endregion DownloadForm G Other Securities

        #region Period End Disclosures Insider OtherSecurities
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosuresInsiderDashnoardOtherSecurities(String inp_sParam, String isInsider, int acid, int year = 0, int period = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;

            int period_type_code = 0;
            try
            {
                ViewBag.activity_id = acid;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                //get financial year list
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();

                //get current year 
                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                //in dropdown list include years less then current year
                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                //show last period end year as default selected
                int lastPeriodEndYearCode = CurrentYearCode;
                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                //get configuation code for period type 
                period_type_code = Common.Common.GetConfiguartionCode(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PeriodType);

                //get period type list 
                List<PopulateComboDTO> Periodlist = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialPeriod, period_type_code.ToString(), null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();
                ViewBag.PeriodDropDown = Periodlist;

                //show last period end year as default selected
                using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                {
                    int lastPeriodEndPeriodCode = objPeriodEndDisclosureSL.GetLastestPeriodEndPeriodCode(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.LastPeriodEndPeriod = (period == 0) ? lastPeriodEndPeriodCode : period;
                }

                // get trading submission status list
                ViewBag.TradingSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, true, sLookupPrefix);

                //get soft copy submission status list
                ViewBag.SoftCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get hard copy submission status list
                ViewBag.HardCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get stock exchange submission status list
                ViewBag.StockExchangeSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.EmployeeStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosure_OS_UsersStatusList;

                //int activity_id_disclosure_letter = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
                //ViewBag.activity_id_disclosure_letter = CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS;

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

            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("UserStatusOS");
        }
        #endregion Period End Disclosures Insider

        #region Upload Documents
        public ActionResult UploadDocuments(int acid, int nParentID = 0, int uid = 0, int period = 0, int year = 0, int pdtype = 0, int tmid = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            ViewBag.showAddTransactionBtn = false;
            DateTime dtEndDate = DateTime.Now;
            Dictionary<string, object> dicPeriodStartEnd = null;

            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            ViewBag.UserAction = acid;
            objLoginUserDetails = null;
            EmployeeRelativeModel objEmployeeModel = new EmployeeRelativeModel();
            UserInfoDTO objUserInfoDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                //set activity id for summary page as this page is access from both menu - insider and CO
                ViewBag.activity_id = acid;

                //using (PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                //{
                //    dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtype);

                //    DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                //    dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                //    String dtFormat = "dd MMM yyyy";
                //    ViewBag.Period = dtStartDate.ToString(dtFormat) + " - " + dtEndDate.ToString(dtFormat);
                //}
                ////set input vaules for period end summary grid
                //ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                //ViewBag.YearCode = year;
                //ViewBag.PeriodCode = period;
                //ViewBag.PeriodType = pdtype;
                //ViewBag.TransactionMasterId = (tmid == 0) ? "" : tmid.ToString();

                //if activity id is for CO then fetch employee insider details 
                if (acid == ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, uid);

                        ViewBag.EmployeeId = objUserInfoDTO.EmployeeId;
                        ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                    }
                }
                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureSummaryList_OS;

                if (nParentID != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.UserDocument, Convert.ToInt64(nParentID), objLoginUserDetails.LoggedInUserID))
                {
                    objLoginUserDetails = null;
                    return RedirectToAction("Unauthorised", "Home");
                }
                //objEmployeeModel.DocumentUploadFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PersonalDocumentUpload, nParentID, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PerDocumentFileUploadCount);

                return View("UploadDocuments", objEmployeeModel);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;

            }
            return View("");


        }
        #endregion
    }
}