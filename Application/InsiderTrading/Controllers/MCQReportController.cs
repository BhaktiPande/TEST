using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
	[RolePrivilegeFilter]
    [AuthorizationPrivilegeFilter]
    public class MCQReportController : Controller
    {
        // GET: MCQReport
        LoginUserDetails objLoginUserDetails = null;

        public ActionResult MCQ_Report()
        {
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            MCQReportModel obMCQ_ReportModel = new MCQReportModel();
            PopulateCombo();
            return View(obMCQ_ReportModel);
        }
        #region PopulateCombo
        private void PopulateCombo()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstMCQ_StatusList = new List<PopulateComboDTO>();
            lstMCQ_StatusList.Add(objPopulateComboDTO);
            lstMCQ_StatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.MCQStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

            ViewBag.MCQ_Status = lstMCQ_StatusList;

            lstMCQ_StatusList = null;

        }

        #endregion PopulateCombo
        [HttpPost]
        public ActionResult MCQ_Report(MCQReportModel objMCQReportModel)
        {
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            MCQ_REPORT_DTO objMCQ_REPORT_DTO = new MCQ_REPORT_DTO();
            objMCQ_REPORT_DTO.StartDate = Convert.ToDateTime(objMCQReportModel.From_Date);
            objMCQ_REPORT_DTO.EndDate = Convert.ToDateTime(objMCQReportModel.To_Date);
            objMCQ_REPORT_DTO.EmployeeId = objMCQReportModel.EmployeeId;
            objMCQ_REPORT_DTO.Name = objMCQReportModel.Name;
            objMCQ_REPORT_DTO.Designation = objMCQReportModel.Designation;
            objMCQ_REPORT_DTO.Department = objMCQReportModel.Department;
            objMCQ_REPORT_DTO.MCQ_Status = objMCQReportModel.MCQ_Status;
            List<MCQ_REPORT_DTO> objMCQ_REPORT_DTOList = new List<MCQ_REPORT_DTO>();
            using (var objMCQSL = new MCQSL())
            {
                objMCQ_REPORT_DTOList = objMCQSL.GetMCQReportList(objLoginUserDetails.CompanyDBConnectionString, objMCQ_REPORT_DTO).ToList();

            }
            if (objMCQ_REPORT_DTOList.Count == 0)
            {
                ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54159"));
            }
            

            ExportReport(Convert.ToString(objMCQReportModel.From_Date), Convert.ToString(objMCQReportModel.To_Date), ToDataTable(objMCQ_REPORT_DTOList));
            PopulateCombo();
            return View(objMCQReportModel);
        }
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties by using reflection   
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names  

                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {

                    values[i] = (Props[i].GetValue(item, null) == "01/01/0001 12:00 AM") ? null : Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }

            return dataTable;
        }
        private void ExportReport(string StartDate, string EndDate, DataTable dt)
        {

            dt.Columns["EmployeeId"].SetOrdinal(1);
            dt.Columns["Name"].SetOrdinal(2);
            dt.Columns["Department"].SetOrdinal(3);
            dt.Columns["Designation"].SetOrdinal(4);
            dt.Columns["MCQ_Status"].SetOrdinal(5);
            dt.Columns["PAN_Number"].SetOrdinal(6);
            dt.Columns["ActivationPeriod"].SetOrdinal(7);
            dt.Columns["MCQ_ExamDate"].SetOrdinal(8);
            dt.Columns["MCQ_ExamDate"].ColumnName = "Login Date And Time";
            dt.Columns["EmployeeId"].ColumnName = "Employee Id";
            dt.Columns["Name"].ColumnName = "Employee Name";
            dt.Columns["MCQ_Status"].ColumnName = "MCQ Status";
            dt.Columns["PAN_Number"].ColumnName = "PAN Number";
            dt.Columns["ActivationPeriod"].ColumnName = "Activation Period";
            dt.Columns["FrequencyOfMCQ"].ColumnName = "Frequency Of MCQ";
            dt.Columns["LastDateOfMCQ"].ColumnName = "Last Date Of MCQ";
            dt.Columns["AttemptNo"].ColumnName = "Attempt No";
            dt.Columns["AccountBlocked"].ColumnName = "Account Blocked";
            dt.Columns["Dateofblocking"].ColumnName = "Date of blocking";
            dt.Columns["Reasonforblocking"].ColumnName = "Reason for blocking";
          

            dt.Columns.Remove("UserInfoID");
            dt.Columns.Remove("From_Date");
            dt.Columns.Remove("To_Date");
            dt.Columns.Remove("StartDate");
            dt.Columns.Remove("EndDate"); 
            dt.Columns.Remove("Action"); 
            dt.Columns.Remove("DepartmentID");
            dt.Columns.Remove("DesignationID");
            dt.Columns.Remove("LoginDateAndTime"); 


            string exlFilename = "MCQ_Report " + Convert.ToDateTime(StartDate).ToString("dd-MMM-yyyy") + " _ " + Convert.ToDateTime(EndDate).ToString("dd-MMM-yyyy") + ".xls";
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string workSheetName = "MCQ Result";
            string cellRange = string.Empty;


            if (dt != null && dt.Rows.Count>0)
            {

                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.Charset = "";
                Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");
                StringWriter sWriter = new StringWriter();
                System.Web.UI.HtmlTextWriter hWriter = new System.Web.UI.HtmlTextWriter(sWriter);
                System.Web.UI.WebControls.GridView dtGrid = new System.Web.UI.WebControls.GridView();
                dtGrid.DataSource = dt;
                dtGrid.DataBind();
                dtGrid.RenderControl(hWriter);
                Response.Write(@"<style> TD { mso-number-format:\@; } </style>");
                Response.Output.Write(sWriter.ToString());
                Response.Flush();
                Response.End();
            }
        }

        #region AutoComplete methods
        public JsonResult GetEmployeeList(string term = "")
        {
            try
            {
                return Json(GeSearchResult("SEARCH_BY_EMPLOYEEID", term).Select(m => new
                {
                    EmployeeId = m.EmployeeId
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        public JsonResult GetNameList(string term = "")
        {
            try
            {
                return Json(GeSearchResult("SEARCH_BY_NAME", term).Select(m => new
                {
                    Name = m.Name
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        public JsonResult GetDepartmentList(string term = "")
        {
            try
            {
                return Json(GeSearchResult("SEARCH_BY_DEPARTMENT", term).Select(m => new
                {
                    Department = m.Department,
                    DepartMentID=m.DepartmentID
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        public JsonResult GetDesignationList(string term = "")
        {
            try
            {
                return Json(GeSearchResult("SEARCH_BY_DESIGNATION", term).Select(m => new
                {
                    Designation = m.Designation,
                    DesignationID=m.DesignationID
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        private MCQ_REPORT_DTO[] GeSearchResult(string Action, string term)
        {
            MCQ_REPORT_DTO[] matching = null;

            MCQ_REPORT_DTO mCQ_REPORTListModel = new MCQ_REPORT_DTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            mCQ_REPORTListModel.Action = Action;
            switch (Action)
            {
                case "SEARCH_BY_EMPLOYEEID":
                    mCQ_REPORTListModel.EmployeeId = term;
                    break;
                case "SEARCH_BY_NAME":
                    mCQ_REPORTListModel.Name = term;
                    break;
                case "SEARCH_BY_DEPARTMENT":
                    mCQ_REPORTListModel.Department = term;
                    break;
                case "SEARCH_BY_DESIGNATION":
                    mCQ_REPORTListModel.Designation = term;
                    break;
                default:
                    Console.WriteLine("Default case");
                    break;
            }



            using (var objMCQSL = new MCQSL())
            {

                matching = String.IsNullOrEmpty(term) ? objMCQSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(mCQ_REPORTListModel)).ToArray() :
                         objMCQSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(mCQ_REPORTListModel)).ToArray();
            }
            return matching;
        }
        private Hashtable AutoCompleteSearchParameters(MCQ_REPORT_DTO rlm)
        {
            Hashtable HT_SearchParam = new Hashtable();
            HT_SearchParam.Add("Action", rlm.Action);
            HT_SearchParam.Add("EmployeeId", rlm.EmployeeId);
            HT_SearchParam.Add("Name", rlm.Name);
            HT_SearchParam.Add("Department", rlm.Department);
            HT_SearchParam.Add("Designation", rlm.Designation);
            return HT_SearchParam;
        }
        #endregion
    }
}