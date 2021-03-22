using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using System.Data.SqlClient;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Web.UI.WebControls;
using System.Drawing;



namespace InsiderTrading.Controllers
{
    public class Reports_OSController : Controller
    {
        public Dictionary<int, string> objReportFileNames = new Dictionary<int, string>(){
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
        };

        public Dictionary<int, string> objReportTitles = new Dictionary<int, string>()
        {
            {ConstEnum.GridType.Report_InitialDisclosureEmployeeWise, Common.Common.getResource("rpt_ttl_51013")},
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
            {ConstEnum.GridType.SecuritiesTransferReportEmployee, Common.Common.getResource("rpt_ttl_19350")}
        };

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
                {ConstEnum.GridType.SecuritiesTransferReportEmployee,"SecuritiesTransferReportEmployee"}
        };

        public ActionResult Index(int acid)
        {

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            TradingTransactionReportModel_OS TradingTransactionReportModel_OS = new TradingTransactionReportModel_OS();
            ViewBag.Title = objReportTitles[ConstEnum.GridType.Report_InitialDisclosureEmployeeWise];
            ViewBag.YearTypeCode = GetYearCodeTypeDropDown(objLoginUserDetails);
            ViewBag.FinancialPeriods = GetFinancialPeriodCodeDropDown(objLoginUserDetails);
            return View(TradingTransactionReportModel_OS);
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

        private List<PopulateComboDTO> GetInsiderStatusDropDown(LoginUserDetails objLoginUserDetails)
        {

            List<PopulateComboDTO> PreclearenceStatusTypeCode = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstInsiderStatusList = new List<PopulateComboDTO>();
            lstInsiderStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.InsiderStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstInsiderStatusList;
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

        [HttpPost]
        public ActionResult ExportReport(TradingTransactionReportModel_OS TradingTransactionReportModel_OS, string ReportType = "1", int acid = 326)
        {
            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            string EmpID = TradingTransactionReportModel_OS.EmpID;
            string EmpName = TradingTransactionReportModel_OS.InsiderName;
            string EmpPAN = TradingTransactionReportModel_OS.PAN;
            string CompanyName = TradingTransactionReportModel_OS.CompanyName;
            string EmpDesignation = TradingTransactionReportModel_OS.Designation;
            DateTime? FromDate = TradingTransactionReportModel_OS.TransactionFromDate;
            DateTime? ToDate = TradingTransactionReportModel_OS.TransactionToDate;
            string YearCodeId = TradingTransactionReportModel_OS.YearCodeId;
            string PeriodCodeId = TradingTransactionReportModel_OS.PeriodCodeId;
            string exlFilename = string.Empty;
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string spName1 = string.Empty;
            string workSheetName = string.Empty;
            string cellRange = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.YearTypeCode = GetYearCodeTypeDropDown(objLoginUserDetails);
            ViewBag.FinancialPeriods = GetFinancialPeriodCodeDropDown(objLoginUserDetails);
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;

            var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);


            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            SqlCommand cmd1 = new SqlCommand();
            con.Open();
            DataTable dt = new DataTable();
            DataTable dt1 = new DataTable();
            if (ReportType == "1")
            {
                spName = "st_rpt_InitialDisclosureEmployeeWise_OS";
                spName1 = "st_rpt_InitialDisclosureEmployeeWiseSummary_OS";
                exlFilename = "Initial Disclosure Report OS.xls";
                workSheetName = "Initial Disclosure Report OS";
                cmd = new SqlCommand(spName, con);
                cmd1 = new SqlCommand(spName1, con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd.Parameters.Add("@inp_sPan", EmpPAN);
                cmd.Parameters.Add("@inp_sCompanyName", CompanyName);
                cmd.Parameters.Add("@EnableDisableQuantityValue", objInsiderInitialDisclosureDTO.EnableDisableQuantityValue);
                cmd1.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd1.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd1.Parameters.Add("@inp_sPan", EmpPAN);
                cmd1.Parameters.Add("@inp_sCompanyName", CompanyName);
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                SqlDataAdapter adp1 = new SqlDataAdapter(cmd1);
                adp.Fill(dt);
                adp1.Fill(dt1);

                if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue == 400003)
                {
                    dt1.Columns.Remove("Holdings");
                }
            }

            if (ReportType == "4")
            {
                spName = "st_rpt_PeriodEndDisclosurePeriodSummary_OS";
                spName1 = "st_rpt_PeriodEndDisclosureTransactionDetailsSummary_OS";
                exlFilename = "Period End Disclosure Report OS.xls";
                workSheetName = "Period End Disclosure Report";
                cmd = new SqlCommand(spName, con);
                cmd1 = new SqlCommand(spName1, con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd.Parameters.Add("@inp_sPan", EmpPAN);
                cmd.Parameters.Add("@inp_sCompanyName", CompanyName);
                cmd.Parameters.Add("@inp_iYearCodeId", YearCodeId);
                cmd.Parameters.Add("@inp_iPeriodCodeId", PeriodCodeId);

                cmd1.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd1.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd1.Parameters.Add("@inp_sPan", EmpPAN);
                cmd1.Parameters.Add("@inp_sCompanyName", CompanyName);
                cmd1.Parameters.Add("@inp_iYearCodeId", YearCodeId);
                cmd1.Parameters.Add("@inp_iPeriodCodeId", PeriodCodeId);
                cmd1.Parameters.Add("@EnableDisableQuantityValue", objInsiderInitialDisclosureDTO.EnableDisableQuantityValue);

                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                SqlDataAdapter adp1 = new SqlDataAdapter(cmd1);
                adp.Fill(dt);
                adp1.Fill(dt1);

                if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue == 400003)
                {
                    dt1.Columns.Remove("Holdings");
                }
            }

            else if (ReportType == "2")
            {
                spName = "st_rpt_PreclearanceEmployeeWise_OS";
                exlFilename = "Preclearance Report For OS.xls";
                workSheetName = "Preclearance Report OS";
                cmd = new SqlCommand(spName, con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd.Parameters.Add("@inp_sPan", EmpPAN);
                cmd.Parameters.Add("@inp_sCompanyName", CompanyName);
                cmd.Parameters.Add("@inp_dtDateOfTransactionFrom", FromDate);
                cmd.Parameters.Add("@inp_dtDateOfTransactionTo", ToDate);
                cmd.Parameters.Add("@EnableDisableQuantityValue", objInsiderInitialDisclosureDTO.EnableDisableQuantityValue);
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(dt);

                if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue == 400003)
                {
                    dt.Columns.Remove("Number of Securities");
                    dt.Columns.Remove("Value");
                    dt.Columns.Remove("BUY");
                    dt.Columns.Remove("SELL");
                    dt.Columns.Remove("Trade Value");
                }
            }

            else if (ReportType == "3")
            {
                spName = "st_rpt_ContinuousDisclosureEmployeeWise_OS";
                exlFilename = "Continuous Disclosure Report OS.xls";
                workSheetName = "Continuous Disclosure Report OS";
                cmd = new SqlCommand(spName, con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd.Parameters.Add("@inp_sPan", EmpPAN);
                cmd.Parameters.Add("@inp_sCompanyName", CompanyName);
                cmd.Parameters.Add("@inp_dtDateOfTransactionFrom", FromDate);
                cmd.Parameters.Add("@inp_dtDateOfTransactionTo", ToDate);
                cmd.Parameters.Add("@EnableDisableQuantityValue", objInsiderInitialDisclosureDTO.EnableDisableQuantityValue);
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(dt);

                if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue == 400003)
                {
                    dt.Columns.Remove("Trades");
                    dt.Columns.Remove("Value");

                }
            }
            else if (ReportType == "5")
            {
                spName = "st_rpt_DefaulterReport_OS";
                exlFilename = "Defaulter Report OS.xls";
                workSheetName = "Defaulter Report OS";
                cmd = new SqlCommand(spName, con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@inp_sEmployeeID", EmpID);
                cmd.Parameters.Add("@inp_sInsiderName", EmpName);
                cmd.Parameters.Add("@inp_sDesignation", EmpDesignation);
                cmd.Parameters.Add("@inp_sCompanyName", CompanyName);
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(dt);

                //if (objInsiderInitialDisclosureDTO.EnableDisableQuantityValue == 400003)
                //{
                //    dt.Columns.Remove("Trades");
                //    dt.Columns.Remove("Value");

                //}
            }

            if ((dt == null) || (dt.Rows.Count == 0))
            {
                ModelState.AddModelError("SearchFieldForOS_RPT", Common.Common.getResource("usr_msg_51012"));
                return View("Index", TradingTransactionReportModel_OS);
            }
            if (ReportType == "4" && ((dt != null) || (dt.Rows.Count != 0)))
            {
                ExcelPackage excel = new ExcelPackage();
                var workSheet1 = excel.Workbook.Worksheets.Add(workSheetName);
                var workSheet = excel.Workbook.Worksheets.Add("Summary");
                var totalCols = dt.Columns.Count;
                var totalRows = dt.Rows.Count;
                var totalCols1 = dt1.Columns.Count;
                var totalRows1 = dt1.Rows.Count;

                workSheet.Cells["A1:K1"].Merge = true;
                workSheet.Cells["A1:K1"].Value = "Summary - Period end Disclosures";
                workSheet.Cells["A1:K1"].Style.Border.Top.Style = workSheet.Cells["A1:K1"].Style.Border.Bottom.Style = workSheet.Cells["A1:K1"].Style.Border.Left.Style = workSheet.Cells["A1:K1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                workSheet.Cells["A1:K1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                workSheet.Cells["A1:K1"].Style.Font.Bold = true;
                workSheet.Cells["A1:K1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                workSheet.Cells["A1:K1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);

                workSheet1.Cells["A1:AB1"].Merge = true;
                workSheet1.Cells["A1:AB1"].Value = "Period End Disclosures Report- Other Securities";
                workSheet1.Cells["A1:AB1"].Style.Border.Top.Style = workSheet1.Cells["A1:AB1"].Style.Border.Bottom.Style = workSheet1.Cells["A1:AB1"].Style.Border.Left.Style = workSheet1.Cells["A1:AB1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                workSheet1.Cells["A1:AB1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                workSheet1.Cells["A1:AB1"].Style.Font.Bold = true;
                workSheet1.Cells["A1:AB1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                workSheet1.Cells["A1:AB1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);

                for (var col = 1; col <= totalCols; col++)
                {
                    workSheet.Cells[2, col].Value = dt.Columns[col - 1].ColumnName;
                    workSheet.Cells[2, col].Style.Font.Name = "Arial";
                    workSheet.Cells[2, col].Style.Font.Size = 10;
                    workSheet.Cells[2, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);

                    cellRange = "A2:K2";
                    using (ExcelRange rng = workSheet.Cells[cellRange])
                    {
                        //rng.Style.WrapText = true;
                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        rng.Style.Font.Bold = true;
                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    }
                }

                workSheet.Cells["A2:K2"].Style.WrapText = false;
                for (var col = 1; col <= totalCols1; col++)
                {
                    workSheet1.Cells[2, col].Value = dt1.Columns[col - 1].ColumnName;
                    workSheet1.Cells[2, col].Style.Font.Name = "Arial";
                    workSheet1.Cells[2, col].Style.Font.Size = 10;
                    workSheet1.Cells[2, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    string cellRange1 = "A2:AB2";
                    using (ExcelRange rng1 = workSheet1.Cells[cellRange1])
                    {
                        // rng1.Style.WrapText = true;
                        rng1.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        rng1.Style.Font.Bold = true;
                        rng1.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng1.Style.Border.Top.Style = rng1.Style.Border.Bottom.Style = rng1.Style.Border.Left.Style = rng1.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng1.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        rng1.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    }
                }

                int excelRow = 2;
                for (var row = 0; row < totalRows; row++)
                {
                    for (var col = 0; col < totalCols; col++)
                    {
                        workSheet.Cells[excelRow + 1, col + 1].Value = dt.Rows[row][col].ToString();
                        workSheet.Cells[excelRow + 1, col + 1].Style.Border.Top.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Bottom.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Left.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        //workSheet.Cells[excelRow + 1, col + 1].Style.WrapText = true;
                        workSheet.Cells[excelRow + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    excelRow++;
                }
                int excelRow1 = 2;
                for (var row = 0; row < totalRows1; row++)
                {
                    for (var col = 0; col < totalCols1; col++)
                    {
                        workSheet1.Cells[excelRow1 + 1, col + 1].Value = dt1.Rows[row][col].ToString();
                        workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Top.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Bottom.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Left.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        // workSheet1.Cells[excelRow1 + 1, col + 1].Style.WrapText = true;
                        workSheet1.Cells[excelRow1 + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    excelRow1++;
                }

                //Set all column width to summary
                workSheet.Column(1).Width = 25;
                workSheet.Column(2).Width = 40;
                workSheet.Column(3).Width = 7;
                workSheet.Column(4).Width = 17;
                workSheet.Column(5).Width = 16;
                workSheet.Column(6).Width = 20;
                workSheet.Column(7).Width = 12;
                workSheet.Column(8).Width = 12;
                workSheet.Column(9).Width = 12;
                workSheet.Column(10).Width = 13;
                workSheet.Column(11).Width = 30;

                //Set all column width to TrasactionSummary
                workSheet1.Column(1).Width = 25;
                workSheet1.Column(2).Width = 40;
                workSheet1.Column(3).Width = 12;
                workSheet1.Column(4).Width = 14;
                workSheet1.Column(5).Width = 18;
                workSheet1.Column(6).Width = 7;
                workSheet1.Column(7).Width = 15;
                workSheet1.Column(8).Width = 20;
                workSheet1.Column(9).Width = 15;
                workSheet1.Column(10).Width = 15;
                workSheet1.Column(11).Width = 15;
                workSheet1.Column(12).Width = 15;
                workSheet1.Column(13).Width = 15;
                workSheet1.Column(14).Width = 30;
                workSheet1.Column(15).Width = 16;
                workSheet1.Column(16).Width = 15;
                workSheet1.Column(17).Width = 20;
                workSheet1.Column(18).Width = 12;
                workSheet1.Column(19).Width = 12;
                workSheet1.Column(20).Width = 12;
                workSheet1.Column(21).Width = 30;
                workSheet1.Column(22).Width = 20;
                workSheet1.Column(23).Width = 25;
                workSheet1.Column(24).Width = 18;
                workSheet1.Column(25).Width = 12;
                workSheet1.Column(26).Width = 13;
                workSheet1.Column(27).Width = 20;
                workSheet1.Column(28).Width = 12;


                workSheet1.Column(22).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                workSheet1.Column(28).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                using (var memoryStream = new MemoryStream())
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
                    excel.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    Response.End();
                }
                return View("Index", TradingTransactionReportModel_OS);
            }


            if (ReportType == "1" && ((dt != null) || (dt.Rows.Count != 0)))
            {
                ExcelPackage excel = new ExcelPackage();
                var workSheet1 = excel.Workbook.Worksheets.Add("Summary");
                var workSheet = excel.Workbook.Worksheets.Add(workSheetName);
                var totalCols = dt.Columns.Count;
                var totalRows = dt.Rows.Count;
                var totalCols1 = dt1.Columns.Count;
                var totalRows1 = dt1.Rows.Count;

                workSheet.Cells["A1:Z1"].Merge = true;
                workSheet.Cells["A1:Z1"].Value = "Initial Disclosures Report For Other Security";
                workSheet.Cells["A1:Z1"].Style.Border.Top.Style = workSheet.Cells["A1:Z1"].Style.Border.Bottom.Style = workSheet.Cells["A1:Z1"].Style.Border.Left.Style = workSheet.Cells["A1:Z1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                workSheet.Cells["A1:Z1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                workSheet.Cells["A1:Z1"].Style.Font.Bold = true;
                workSheet.Cells["A1:Z1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                workSheet.Cells["A1:Z1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);

                workSheet1.Cells["A1:J1"].Merge = true;
                workSheet1.Cells["A1:J1"].Value = "Initial Disclosures Report For Other Security";
                workSheet1.Cells["A1:J1"].Style.Border.Top.Style = workSheet1.Cells["A1:J1"].Style.Border.Bottom.Style = workSheet1.Cells["A1:J1"].Style.Border.Left.Style = workSheet1.Cells["A1:J1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                workSheet1.Cells["A1:J1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                workSheet1.Cells["A1:J1"].Style.Font.Bold = true;
                workSheet1.Cells["A1:J1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                workSheet1.Cells["A1:J1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                for (var col = 1; col <= totalCols; col++)
                {
                    workSheet.Cells[2, col].Value = dt.Columns[col - 1].ColumnName;
                    workSheet.Cells[2, col].Style.Font.Name = "Arial";
                    workSheet.Cells[2, col].Style.Font.Size = 10;
                    workSheet.Cells[2, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    cellRange = "A2:Z2";
                    using (ExcelRange rng = workSheet.Cells[cellRange])
                    {
                        //rng.Style.WrapText = true;
                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        rng.Style.Font.Bold = true;
                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    }
                }

                workSheet.Cells["A2:Z2"].Style.WrapText = false;
                for (var col = 1; col <= totalCols1; col++)
                {
                    workSheet1.Cells[2, col].Value = dt1.Columns[col - 1].ColumnName;
                    workSheet1.Cells[2, col].Style.Font.Name = "Arial";
                    workSheet1.Cells[2, col].Style.Font.Size = 10;
                    workSheet1.Cells[2, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    string cellRange1 = "A2:J2";
                    using (ExcelRange rng1 = workSheet1.Cells[cellRange1])
                    {
                        // rng1.Style.WrapText = true;
                        rng1.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        rng1.Style.Font.Bold = true;
                        rng1.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng1.Style.Border.Top.Style = rng1.Style.Border.Bottom.Style = rng1.Style.Border.Left.Style = rng1.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng1.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        rng1.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    }
                }
                int excelRow = 2;
                for (var row = 0; row < totalRows; row++)
                {
                    for (var col = 0; col < totalCols; col++)
                    {
                        workSheet.Cells[excelRow + 1, col + 1].Value = dt.Rows[row][col].ToString();
                        workSheet.Cells[excelRow + 1, col + 1].Style.Border.Top.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Bottom.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Left.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        //workSheet.Cells[excelRow + 1, col + 1].Style.WrapText = true;
                        workSheet.Cells[excelRow + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    excelRow++;
                }
                int excelRow1 = 2;
                for (var row = 0; row < totalRows1; row++)
                {
                    for (var col = 0; col < totalCols1; col++)
                    {
                        workSheet1.Cells[excelRow1 + 1, col + 1].Value = dt1.Rows[row][col].ToString();
                        workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Top.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Bottom.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Left.Style = workSheet1.Cells[excelRow1 + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        // workSheet1.Cells[excelRow1 + 1, col + 1].Style.WrapText = true;
                        workSheet1.Cells[excelRow1 + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    excelRow1++;
                }
                //Set all column width to ID Summary
                workSheet1.Column(1).Width = 25;
                workSheet1.Column(2).Width = 14;
                workSheet1.Column(3).Width = 7;
                workSheet1.Column(4).Width = 15;
                workSheet1.Column(5).Width = 20;
                workSheet1.Column(6).Width = 13;
                workSheet1.Column(7).Width = 13;
                workSheet1.Column(8).Width = 13;
                workSheet1.Column(9).Width = 13;
                workSheet1.Column(10).Width = 30;

                //Set all column width to ID Details
                workSheet.Column(1).Width = 25;
                workSheet.Column(2).Width = 25;
                workSheet.Column(3).Width = 13;
                workSheet.Column(4).Width = 18;
                workSheet.Column(5).Width = 8;
                workSheet.Column(6).Width = 17;
                workSheet.Column(7).Width = 12;
                workSheet.Column(8).Width = 10;
                workSheet.Column(9).Width = 10;
                workSheet.Column(10).Width = 14;
                workSheet.Column(11).Width = 10;
                workSheet.Column(12).Width = 15;
                workSheet.Column(13).Width = 15;
                workSheet.Column(14).Width = 20;
                workSheet.Column(15).Width = 10;
                workSheet.Column(16).Width = 10;
                workSheet.Column(17).Width = 10;
                workSheet.Column(18).Width = 30;
                workSheet.Column(19).Width = 23;
                workSheet.Column(20).Width = 25;
                workSheet.Column(21).Width = 20;
                workSheet.Column(22).Width = 13;
                workSheet.Column(23).Width = 14;
                workSheet.Column(24).Width = 16;
                workSheet.Column(25).Width = 40;
                workSheet.Column(26).Width = 12;

                using (var memoryStream = new MemoryStream())
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
                    excel.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    Response.End();
                }
                return View("Index", TradingTransactionReportModel_OS);
            }
            else
            {
                ExcelPackage excel = new ExcelPackage();
                var workSheet = excel.Workbook.Worksheets.Add(workSheetName);
                var totalCols = dt.Columns.Count;
                var totalRows = dt.Rows.Count;

                if (ReportType == "2")
                {
                    workSheet.Cells["A1:AH1"].Merge = true;
                    workSheet.Cells["A1:AH1"].Value = "Preclearance Report For Other Security";
                    workSheet.Cells["A1:AH1"].Style.Border.Top.Style = workSheet.Cells["A1:AH1"].Style.Border.Bottom.Style = workSheet.Cells["A1:AH1"].Style.Border.Left.Style = workSheet.Cells["A1:AH1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    workSheet.Cells["A1:AH1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    workSheet.Cells["A1:AH1"].Style.Font.Bold = true;
                    workSheet.Cells["A1:AH1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    workSheet.Cells["A1:AH1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    cellRange = "A2:AH2";
                }
                if (ReportType == "3")
                {
                    workSheet.Cells["A1:AF1"].Merge = true;
                    workSheet.Cells["A1:AF1"].Value = "Continuous Disclosure Report For Other Security";
                    workSheet.Cells["A1:AF1"].Style.Border.Top.Style = workSheet.Cells["A1:AF1"].Style.Border.Bottom.Style = workSheet.Cells["A1:AF1"].Style.Border.Left.Style = workSheet.Cells["A1:AF1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    workSheet.Cells["A1:AF1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    workSheet.Cells["A1:AF1"].Style.Font.Bold = true;
                    workSheet.Cells["A1:AF1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    workSheet.Cells["A1:AF1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    cellRange = "A2:AF2";
                }
                if (ReportType == "5")
                {
                    workSheet.Cells["A1:AS1"].Merge = true;
                    workSheet.Cells["A1:AS1"].Value = "Defaulter Report For Other Security";
                    workSheet.Cells["A1:AS1"].Style.Border.Top.Style = workSheet.Cells["A1:AS1"].Style.Border.Bottom.Style = workSheet.Cells["A1:AS1"].Style.Border.Left.Style = workSheet.Cells["A1:AS1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    workSheet.Cells["A1:AS1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    workSheet.Cells["A1:AS1"].Style.Font.Bold = true;
                    workSheet.Cells["A1:AS1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    workSheet.Cells["A1:AS1"].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    cellRange = "A2:AS2";
                }

                for (var col = 1; col <= totalCols; col++)
                {
                    workSheet.Cells[2, col].Value = dt.Columns[col - 1].ColumnName;
                    workSheet.Cells[2, col].Style.Font.Name = "Arial";
                    workSheet.Cells[2, col].Style.Font.Size = 10;
                    workSheet.Cells[2, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);

                    using (ExcelRange rng = workSheet.Cells[cellRange])
                    {
                        //rng.Style.WrapText = true;
                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                        rng.Style.Font.Bold = true;
                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        rng.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkGray);
                    }
                }

                int excelRow = 2;
                for (var row = 0; row < totalRows; row++)
                {
                    for (var col = 0; col < totalCols; col++)
                    {
                        workSheet.Cells[excelRow + 1, col + 1].Value = dt.Rows[row][col].ToString();
                        workSheet.Cells[excelRow + 1, col + 1].Style.Border.Top.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Bottom.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Left.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                        //workSheet.Cells[excelRow + 1, col + 1].Style.WrapText = true;
                        workSheet.Cells[excelRow + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    }
                    excelRow++;
                }

                using (var memoryStream = new MemoryStream())
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    //Response.AddHeader("content-disposition", exlFilename);
                    Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
                    excel.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    Response.End();
                }
                return View("Index", TradingTransactionReportModel_OS);
            }
        }
    }
}