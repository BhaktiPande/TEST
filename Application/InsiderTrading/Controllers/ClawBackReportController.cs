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



namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class ClawBackReportController : Controller
    {
        
        public ActionResult Index(int acid)
        {
            FillGrid(Common.ConstEnum.GridType.Report_ClawBack, "0", null, null);
            return View();
        }


        public ActionResult ClawBackReportEmployeeWise(int acid, int nUserInfoID = 0, int nTransactionMasterID = 0, int nSecurityTypeID = 0, int nTransactionTypeID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
       
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.GridType = ConstEnum.GridType.Report_ClawBack_Individual;
                ViewBag.ActivityID = acid;
                ViewBag.UserID = nUserInfoID;
                ViewBag.TransactionMasterID = nTransactionMasterID;
                ViewBag.SecurityTypeID = nSecurityTypeID;
                ViewBag.TransactionTypeID = nTransactionTypeID;

                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);

                    ViewBag.EmployeePAN = objUserInfoDTO.PAN;
                    ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View();
        }

        public void DownloadClawBackExcel(int acid)
        {
            string exlFilename = string.Empty;
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string workSheetName = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            con.Open();
            DataTable dt = new DataTable();
         
            spName = "st_rpt_DownloadClawBackReportExcel";
            exlFilename = "Claw Back Report.xls";
            workSheetName = "Claw Back Report";
            cmd = new SqlCommand(spName, con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adp = new SqlDataAdapter(cmd);
            adp.Fill(dt);

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
	}
}