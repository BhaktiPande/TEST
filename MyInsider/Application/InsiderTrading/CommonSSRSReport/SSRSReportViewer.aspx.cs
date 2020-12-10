using InsiderTrading.Common;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using InsiderTrading.Common;
using System.Web;
using InsiderTradingEncryption;

namespace InsiderTrading.CommonSSRSReport
{
    public partial class SSRSReportViewer : System.Web.UI.Page
    {        
        #region All Vairables
        InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
        private string UID = string.Empty;
        private string PASS = string.Empty;
        private string DomainName = string.Empty;
        private string SSRSReportPath = ConfigurationManager.AppSettings["SSRSReportPath"].ToString();
        private string ReportName = string.Empty;
        private string TitleName = string.Empty;
        private string RptID = string.Empty;
        #endregion

        #region User Session
        /// <summary>
        /// User Session 
        /// </summary>
        LoginUserDetails objLoginUserDetails = null;
        public SSRSReportViewer()
        {
            
        }
        #endregion

        #region Set Parameters
        /// <summary>
        /// Set Report Parameter
        /// </summary>
        /// <param name="para"></param>
        private void SetParameter(List<string> para)
        {
            switch (RptID)
            {
                case "1":
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add(Convert.ToString(objLoginUserDetails.LoggedInUserID));
                    break;

                case "2":
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "3":
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "4":
                    //Initial Disclosures Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    Common.Common.WriteLogToFile(" SetParameter CompanyDBConnectionString :- " + objLoginUserDetails.CompanyDBConnectionString, null);
                    para.Add("0");
                    break;

                case "5":
                    //Continuous Disclosures Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "6":
                    //Period End Disclosures Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "7":
                    //Pre Clearance Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "8":
                    //Defaulter Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "9":
                    //View Error Log Report
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;

                case "10":
                    //Separation Massupload
                    para.Add(objLoginUserDetails.CompanyDBConnectionString);
                    para.Add("0");
                    break;
            }
        }
        #endregion

        #region Set Report and Page title name
        /// <summary>
        /// Set Report Title Name
        /// </summary>
        /// <param name="ReportID"></param>
        private void SetTitleRptName(string ReportID)
        {
            Common.Common.WriteLogToFile("SetTitleRptName method called and ReportID " + ReportID, null);
            switch (ReportID)
            {
                // Employee RL Report, ReportID: EJLIsEY9uZo=
                case "1":
                    ReportName = "RestrictedListSearchReport";
                    TitleName = "Restricted List Search Report";
                    break;

                // CO RL Report, ReportID: EJLIsEY9uZo=
                case "2":
                    ReportName = "CORLSearchReport";
                    TitleName = "CO Restricted List Search Report";
                    break;

                // Admin & CO R&T Report, ReportID: /EFMo9hRx5g=
                case "3":
                    ReportName = "RnTReport";
                    TitleName = "Register and Transfer Report";
                    break;

                // Admin & CO Initial Disclosure Report, ReportID: J9MtTZ0cpQY=
                case "4":
                    ReportName = "Initial_Disclosures_Report";
                    TitleName = "Initial Disclosure Report";
                    Common.Common.WriteLogToFile("Initial_Disclosures_Report called Report Name " + ReportName + " TitleName " + TitleName + " ReportID " + ReportID, null);
                    break;

                // Admin & CO Continuous Disclosure Report, ReportID: v/iigWwtI48=
                case "5":
                    ReportName = "Continuous_Disclosures_Report";
                    TitleName = "Continuous Disclosures Report";
                    break;

                // Admin & CO Period End Disclosure Report, ReportID: Zq+1ET/1+08=
                case "6":
                    ReportName = "Period_End_Disclosures_Report";
                    TitleName = "Period End Disclosure Report";
                    break;

                // Admin & CO Pre Clearance Report, ReportID: wRDResAWb9I=
                case "7":
                    ReportName = "Pre-clearance_Report";
                    TitleName = "Pre Clearance Report";
                    break;

                // Admin & CO Defaulter Report, ReportID: N+LZyU1gCYE=
                case "8":
                    ReportName = "Defaulter_Report";
                    TitleName = "Defaulter Report";
                    break;

                // Admin & CO View Error Log Report, ReportID: 06p6JFH6prI=
                case "9":
                    ReportName = "View_Error_Log_Report";
                    TitleName = "View Error Log Report";
                    break;

                // Admin & CO View Separation Massupload Report Template, ReportID: j/aFOxpM0M8=
                case "10":
                    ReportName = "SeparationMassUploadTemplate";
                    TitleName = "SeparationMassUploadTemplate";
                    break;
            }
        }
        #endregion

        #region Set Report Id at Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                Common.Common.WriteLogToFile("Page_Load method called and Got user login details", null);
                if (Request.QueryString.Count.Equals(0)) return;
                string ReportID = Server.UrlEncode(Request.QueryString["ReportID"]).Replace("%3d", "=").Replace("%2f", "/");
                Common.Common.WriteLogToFile("Page_Load :- ReportID " + ReportID, null);
                switch(ReportID)
                {
                    case "EJLIsEY9uZo=":
                         RptID = "1";
                         break;

                    case "b4czFb/7oAQ=":
                         RptID = "2";
                         break;

                    case "/EFMo9hRx5g=":
                         RptID = "3";
                         break;

                    //Initial Disclosures Report
                    case "zJIWkTIKWAc=":
                         RptID = "4";
                         Common.Common.WriteLogToFile("Page_Load :- Initial Disclosures Report " + "RptID " + RptID + " ReportID " + ReportID, null);
                         break;

                    //Continuous Disclosures Report
                    case "M/2BHyNrAc4=":
                         RptID = "5";
                         break;

                    //Period End Disclosures Report
                    case "h/jfF5gBzZQ=":
                         RptID = "6";
                         break;

                    //Pre Clearance Report
                    case "0lVrlV/e0rU=":
                         RptID = "7";
                         break;

                    //Defaulter Report
                    case "P5Mkjyvo+j4=":
                         RptID = "8";
                         break;

                    // View Error Log Report
                    case "06p6JFH6prI=":
                         RptID = "9";
                        break;

                    // Download Separation Massupload template
                    case "j/aFOxpM0M8=":
                        RptID = "10";
                        break;
                }

                SetTitleRptName(RptID);
                List<string> para = new List<string>();
                SetParameter(para);
                Common.Common.WriteLogToFile(" SetParameters set " + "Para 0 :- " + para[0].ToString() + " Para 1 :- " + para[1].ToString(), null);

                if (IsPostBack)
                {
                    SSRSReport.SizeToReportContent = true;
                    return;
                }

                #region EncryptData & DecryptData                
                using(DataSecurity datasecurity = new DataSecurity())
                {
                    UID = datasecurity.DecryptData(ConfigurationManager.AppSettings["SSRS_UID"]);
                    PASS = datasecurity.DecryptData(ConfigurationManager.AppSettings["SSRS_PASS"]);
                    DomainName = datasecurity.DecryptData(ConfigurationManager.AppSettings["SSRS_DomainName"]);
                    Common.Common.WriteLogToFile(" SSRS_UID " + UID + " SSRS_PASS " + PASS + " SSRS_DomainName " + DomainName, null);
                }
                #endregion

                if (!string.IsNullOrEmpty(RptID))
                {                   
                    SSRSReport.ProcessingMode = ProcessingMode.Remote;
                    Common.Common.WriteLogToFile(" ProcessingMode set ", null);
                    SSRSReport.PreRender += (SSRSReportObjects.MyReportViewer_PreRender);
                    Common.Common.WriteLogToFile(" PreRender set ", null);
                    SSRSReport.ServerReport.ReportPath = SSRSReportPath + ReportName;
                    Common.Common.WriteLogToFile(" ReportPath set " + " SSRS Report Path " + SSRSReportPath + " Report Name " + ReportName, null);
                    SSRSReport.ServerReport.ReportServerUrl = new Uri(ConfigurationManager.AppSettings["SSRS_URL"]);                    
                    Common.Common.WriteLogToFile("Report Server Url set " + SSRSReport.ServerReport.ReportServerUrl , null);
                    SSRSReport.ServerReport.ReportServerCredentials = SSRSReportObjects.MyReportServerCredentials(UID, PASS, DomainName); //Set the credential of Report Server                  
                    Common.Common.WriteLogToFile("ReportServerCredentials " + " UserID " + UID + " Password " + PASS + " Domain Name " + DomainName, null);
                    SSRSReport.ShowParameterPrompts = true;
                    Common.Common.WriteLogToFile(" ShowParameterPrompts set true ", null);
                    SSRSReport.AsyncRendering = true;
                    Common.Common.WriteLogToFile(" AsyncRendering set true ", null);
                    SSRSReport.ShowPrintButton = true;
                    Common.Common.WriteLogToFile(" ShowPrintButton set true ", null);
                    SSRSReport.ServerReport.SetParameters(SSRSReportObjects.SetParametersToReport(Convert.ToInt32(RptID), SSRSReport, para));
                    Common.Common.WriteLogToFile(" SetParameters set " + "Para 0 :- " + para[0].ToString() + " Para 1 :- " + para[1].ToString(), null);
                    SSRSReport.ServerReport.DisplayName = TitleName;
                    Common.Common.WriteLogToFile(" DisplayName set ", null);
                    SSRSReport.ServerReport.Refresh();
                    Common.Common.WriteLogToFile(" Refresh() ", null);
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message.ToString());
                Common.Common.WriteLogToFile(" Exception occured on Page_Load ", null, ex);
            }
        }
        #endregion
    }
}