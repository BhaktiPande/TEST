using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Principal;
using System.Web;
using Microsoft.Reporting.WebForms;

namespace InsiderTrading.Common
{

    public static class SSRSReportObjects
    {
        private static int gRptID;
        internal static IReportServerCredentials MyReportServerCredentials(string UID, string PASS, string DomainName)
        {
            return new MyReportServerCredentials(UID, PASS, DomainName); //Set the credential of Report Server
        }

        //RptId = 1 means  Set or Get Sending report id by Controllers
        internal static IEnumerable<ReportParameter> SetParametersToReport(int RptID, ReportViewer spReportViewer, List<string> para)
        {
            Common.WriteLogToFile(" SetParametersToReport called Report ID " + RptID , null);
            var dataSourceCredentials = new DataSourceCredentials();
            ReportParameter[] reportParameterCollection = null;
            int intCnt = 0;
            gRptID = RptID;
            Common.WriteLogToFile(" set gRptID :- " + RptID, null);
            try
            {
                // Datasource being used by report
                try
                {
                    foreach (var dataSource in spReportViewer.ServerReport.GetDataSources())
                    {
                        dataSourceCredentials.Name = dataSource.Name;
                        Common.WriteLogToFile(" Datasource being used by report :- " + "data Source Credentials Name " + dataSourceCredentials.Name, null);
                        dataSourceCredentials.UserId = ExtractConnectionStringFor(para[0].ToString(), "user id=");
                        Common.WriteLogToFile(" Datasource being used by report :- " + "data Source Credentials UserId " + dataSourceCredentials.UserId, null);
                        dataSourceCredentials.Password = ExtractConnectionStringFor(para[0].ToString(), "Password=");
                        Common.WriteLogToFile(" Datasource being used by report :- " + "data Source Credentials Password " + dataSourceCredentials.Password, null);
                        spReportViewer.ServerReport.SetDataSourceCredentials(new DataSourceCredentials[1] { dataSourceCredentials });
                        spReportViewer.ShowCredentialPrompts = false;
                    }
                }
                catch (Exception ex) 
                {
                    Common.WriteLogToFile(" Exception occured in spReportViewer.ServerReport.GetDataSources() :- ", null, ex);
                }                                            

                switch (RptID)
                {
                    case 2:
                    case 3:					
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10:
                        reportParameterCollection = new ReportParameter[2];
                        break;
                    default:
                        reportParameterCollection = new ReportParameter[3];
                        break;
                }
                
                //Setting Datasource Server Name 
                reportParameterCollection[intCnt] = new ReportParameter();
                reportParameterCollection[intCnt].Name = "SERVER_NAME";
                Common.WriteLogToFile(" --Server Name -- ", null);
                Common.WriteLogToFile(" --set Server Name -- " + ExtractConnectionStringFor(para[0].ToString(), "data source=").ToString(), null);
                reportParameterCollection[intCnt].Values.Add(ExtractConnectionStringFor(para[0].ToString(), "data source="));
                Common.WriteLogToFile(" --set Server Name -- " + ExtractConnectionStringFor(para[0].ToString(), "data source=").ToString(), null);
                reportParameterCollection[intCnt].Visible = false;
                intCnt++;
                Common.WriteLogToFile(" Setting Datasource Server Name called ", null);                

                //Setting Datasource Database Name
                reportParameterCollection[intCnt] = new ReportParameter();
                reportParameterCollection[intCnt].Name = "DATABASE_NAME";
                Common.WriteLogToFile(" --DATABASE_NAME-- ", null);
                Common.WriteLogToFile(" --set DATABASE NAME -- " + ExtractConnectionStringFor(para[0].ToString(), "initial catalog=").ToString(), null);
                reportParameterCollection[intCnt].Values.Add(ExtractConnectionStringFor(para[0].ToString(), "initial catalog="));
                Common.WriteLogToFile(" --set DATABASE NAME -- " + ExtractConnectionStringFor(para[0].ToString(), "initial catalog=").ToString(), null);
                reportParameterCollection[intCnt].Visible = false;
                intCnt++;
                Common.WriteLogToFile(" Setting Datasource Database Name called ", null);

                switch (gRptID)
                {
                    case 1:
                        {
                            reportParameterCollection[intCnt] = new ReportParameter();
                            reportParameterCollection[intCnt].Name = "LoggedInUserId";
                            reportParameterCollection[intCnt].Values.Add(Convert.ToString(para[1].ToString()));
                            intCnt++;
                            break;
                        }

                    case 2:
                        {
                            reportParameterCollection[intCnt] = new ReportParameter();
                            reportParameterCollection[intCnt].Name = "LoggedInUserId";
                            reportParameterCollection[intCnt].Values.Add(Convert.ToString(para[1].ToString()));
                            intCnt++;
                            break;
                        }
                    #region
                    //case 2:
                    //    {
                    //        //Setting 
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "FromDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "ToDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        break;
                    //    }
                    //case 3:
                    //    {
                    //        reportParameterCollection[intCnt] = new ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "ListedStatus";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "PublicStatus";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "IndustryType";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "CompanyGroupName";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++; 
                    //        break;
                    //    }
                    //case 4:
                    //    {
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "FromDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "ToDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        break;
                    //    }
                    //case 5:
                    //    {
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "FromDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "ToDate";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        reportParameterCollection[intCnt] = new Microsoft.Reporting.WebForms.ReportParameter();
                    //        reportParameterCollection[intCnt].Name = "CompanyName";
                    //        reportParameterCollection[intCnt].Values.Add(null);
                    //        intCnt++;
                    //        break;
                    //    }
                    #endregion
                }
            }
            catch (Exception ex)
            {
                Common.WriteLogToFile(" Exception occued in SetParametersToReport method ", null, ex);
            }

            spReportViewer.ShowParameterPrompts = true;
            spReportViewer.ShowPrintButton = true;
            spReportViewer.ShowExportControls = true;
            return reportParameterCollection;
        }

        #region Disable format for Download Report
        /// <summary>
        /// Render Report 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public static void MyReportViewer_PreRender(object sender, EventArgs e)
        {
            Common.WriteLogToFile(" MyReportViewer_PreRender start ", null);
            DisableUnwantedExportFormat((ReportViewer)sender, "PDF");
            DisableUnwantedExportFormat((ReportViewer)sender, "IMAGE"); 
            DisableUnwantedExportFormat((ReportViewer)sender, "XML"); 
            DisableUnwantedExportFormat((ReportViewer)sender, "CSV"); 
            DisableUnwantedExportFormat((ReportViewer)sender, "MHTML");
            DisableUnwantedExportFormat((ReportViewer)sender, "WORD");
            DisableUnwantedExportFormat((ReportViewer)sender, "WORDOPENXML");
            Common.WriteLogToFile(" MyReportViewer_PreRender end ", null);
        }
        #endregion

        /// <summary>
        /// Hidden the special SSRS rendering format in ReportViewer control
        /// </summary>
        /// <param name="ReportViewerID">The ID of the relevant ReportViewer control</param>
        /// <param name="strFormatName">Format Name</param>
        private static void DisableUnwantedExportFormat(ReportViewer ReportViewerID, string strFormatName)
        {
            FieldInfo info;
            foreach (RenderingExtension extension in ReportViewerID.ServerReport.ListRenderingExtensions())
            {
                if (extension.Name == strFormatName)
                {
                    info = extension.GetType().GetField("m_isVisible", BindingFlags.Instance | BindingFlags.NonPublic);
                    info.SetValue(extension, false);
                }
            }
        }

        /// <summary>
        /// For using Conncetion String
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        private static string ExtractConnectionStringFor(string strConString, string param)
        {
            var result = string.Empty;
            foreach (var value in strConString.Split(';').Where(value => value.Contains(param)))
            {
                result = value.Replace(param, string.Empty);
            }
            return result;
        }
    }


    /// <summary>
    /// Property of MyReportServer Credentials
    /// </summary>
    public class MyReportServerCredentials : IReportServerCredentials
    {
        private string _UserName;
        private string _PassWord;
        private string _DomainName;

        public MyReportServerCredentials(string UserName, string PassWord, string DomainName)
        {
            _UserName = UserName;
            _PassWord = PassWord;
            _DomainName = DomainName;
        }

        /// <summary>
        /// Not use ImpersonationUser
        /// </summary>
        public WindowsIdentity ImpersonationUser
        {
            get
            {
                return null;
            }
        }

        /// <summary>
        /// Use NetworkCredentials
        /// </summary>
        public ICredentials NetworkCredentials
        {
            get
            {
                return new NetworkCredential(_UserName, _PassWord, _DomainName);
            }
        }

        /// <summary>
        /// Not use FormsCredentials unless you have implements a custom autentication.
        /// </summary>
        /// <param name="authCookie"></param>
        /// <param name="user"></param>
        /// <param name="password"></param>
        /// <param name="authority"></param>
        /// <returns></returns>
        public bool GetFormsCredentials(out Cookie authCookie, out string user, out string password, out string authority)
        {
            authCookie = null;
            user = password = authority = null;
            return false;
        }
    }
}