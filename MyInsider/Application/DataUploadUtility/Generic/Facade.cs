using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using DataUploadUtility.Generic;
using System.Configuration;
using System.Linq;

namespace DataUploadUtility
{
    class Facade : IDisposable
    {
        #region Implementation of Singleton Pattern
        /// <summary>
        /// This is a singleton Pattern used for Facade
        /// </summary>
        private static Facade _instance;

        /// <summary>
        /// Constructors of Facade class
        /// </summary>
        protected Facade()
        {
        }

        /// <summary>
        /// Destructors of Facade class
        /// </summary>
        ~Facade()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a DBUtility class
        /// </summary>
        /// <returns>returning the instance of an object</returns>
        public static Facade Instance()
        {
            if (_instance == null)
            {
                _instance = new Facade();
            }
            return _instance;
        }
        #endregion

        #region private variable declaration
        private InsiderTradingDAL.CompanyDTO objSelectedCompany;
        private List<CodesDTO> m_objCodesDTOList = new List<CodesDTO>();
        private Dictionary<string, int> m_objCodesNameWiseDisct = new Dictionary<string, int>();
        private Dictionary<string, string> o_lstResources = new Dictionary<string, string>();
        #endregion

        /// <summary>
        /// This method is used to Upload Data
        /// </summary>
        internal void UploadData()
        {
            try
            {
                using (DataSet ds_DataFromExcelFile = new DataSet("ds_DataFromExcelFile"))
                {
                    List<DataUploadUtilityDTO> objDataUploadUtilityDTO;
                    List<MappingFieldsDTO> objMappingFieldsDTO;
                    List<string> s_Attachment = new List<string>();

                    #region Create or Delete existing Log file
                    Generic.Generic.Instance().CreateLogFile();
                    #endregion

                    /* Get all company details into DataTable*/
                    using (DataTable dt_allCompanies = Generic.Generic.Instance().GetCompanyList())
                    {
                        if (dt_allCompanies.Rows.Count.Equals(0))
                            return;

                        foreach (DataRow perCompanyData in dt_allCompanies.Rows)
                        {
                            #region Upload data

                            /*  Create a log file to write. */
                            using (StreamWriter streamWriter = new StreamWriter(perCompanyData["LogFileDetails"] + @"\LogFile\" + (CommonModel.HT_Modules.Count.Equals(4) ? string.Empty : Convert.ToString(CommonModel.HT_Modules.Values.OfType<string>().First()) + "_") + DateTime.Now.ToString("ddMMMyyyy") + "_Log.txt"))
                            {
                                try
                                {
                                    objDataUploadUtilityDTO = new List<DataUploadUtilityDTO>();
                                    objMappingFieldsDTO = new List<MappingFieldsDTO>();

                                    /* Add default text to Log file */
                                    Generic.Generic.Instance().DefaultTextForLogFile(perCompanyData["CompanyNames"].ToString());

                                    /* Get all information regarding company */
                                    Generic.Generic.Instance().GetAllCompanyInfo(perCompanyData["CompanyNames"].ToString(), ref objSelectedCompany);

                                    /* Get all codes used in MassUpload */
                                    Generic.Generic.Instance().FetchAllCodes(ref objSelectedCompany, ref m_objCodesDTOList, ref m_objCodesNameWiseDisct);

                                    /* Get messages used in the application */
                                    CommonModel.getResource(objSelectedCompany.CompanyConnectionString, out o_lstResources);

                                    /* Create mapping and upload data */
                                    Generic.Generic.Instance().CreateMappingAndUpload(ds_DataFromExcelFile, objDataUploadUtilityDTO, objMappingFieldsDTO, perCompanyData["CompanyNames"].ToString(), o_lstResources, objSelectedCompany.CompanyConnectionString, m_objCodesNameWiseDisct);

                                }
                                catch (Exception exp)
                                {
                                    CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, exp.Message));
                                    CommonModel.b_IsErrorOccured = true;
                                }
                                streamWriter.Write(CommonModel.sbString);
                            }

                            /* Send Email -- Start */
                            // if (!(s_Attachment.Count == 0))
                            //{
                            Generic.Generic.Instance().GetAttachmentPath(out s_Attachment);
                            if (!(s_Attachment.Count == 0))
                            {
                                Generic.Generic.Instance().SendEmail(perCompanyData["CompanyNames"].ToString(), s_Attachment);
                            }
                            if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["WriteToFileLogPath"]))
                            {

                                string s_destinationPath = string.Empty;
                                string s_SourceLogFilePath = string.Empty;
                                s_SourceLogFilePath = ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\LogFile\";
                                string s_DestFilePath = ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
                                if (!Directory.Exists(s_DestFilePath))
                                {
                                    Directory.CreateDirectory(s_DestFilePath);
                                }

                                foreach (string s_AttachmentPath in s_Attachment)
                                {
                                    if (Path.GetFileName(s_AttachmentPath).Contains("AXISDIRECTFEED_Log.csv"))
                                    {
                                        s_destinationPath = s_DestFilePath + @"\AXISDIRECTFEED\";
                                        break;
                                    }
                                    if (Path.GetFileName(s_AttachmentPath).Contains("HRMS_Log.csv"))
                                    {
                                        s_destinationPath = s_DestFilePath + @"\HRMS\";
                                        break;
                                    }
                                    if (Path.GetFileName(s_AttachmentPath).Contains("ESOPDIRECTFEED_Log.csv"))
                                    {
                                        s_destinationPath = s_DestFilePath + @"\ESOPDIRECTFEED\";
                                        break;
                                    }
                                }
                                if (s_destinationPath == null || s_destinationPath == "")
                                {
                                    s_destinationPath = s_DestFilePath + @"\KARVI\";
                                    break;
                                }
                                foreach (string s_AttachmentPath in s_Attachment)
                                {
                                    if (!Directory.Exists(s_destinationPath))
                                    {
                                        Directory.CreateDirectory(s_destinationPath);
                                    }
                                    try
                                    {
                                        if (File.Exists(s_DestFilePath + @"\" + Path.GetFileName(s_AttachmentPath)))
                                        {
                                            if (File.Exists(s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath)))
                                            {
                                                File.Delete(s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath));
                                            }
                                            File.Move(s_AttachmentPath, s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath));
                                            File.Delete(s_DestFilePath + @"\" + Path.GetFileName(s_AttachmentPath));
                                        }
                                       	else if (File.Exists(s_SourceLogFilePath + @"\" + Path.GetFileName(s_AttachmentPath)))
                                        {
                                            if (File.Exists(s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath)))
                                            {
                                                File.Delete(s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath));
                                            }
                                            File.Move(s_AttachmentPath, s_destinationPath + @"\" + Path.GetFileName(s_AttachmentPath));
                                            File.Delete(s_SourceLogFilePath + @"\" + Path.GetFileName(s_AttachmentPath));
                                        }
                                        else
                                        {
                                            if (File.Exists(s_AttachmentPath))
                                            {
                                                File.Delete(s_AttachmentPath);
                                            }
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                                        CommonModel.b_IsErrorOccured = true;
                                    }
                                }
                            }

                            /* Send Email -- End */

                            #endregion
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                CommonModel.b_IsErrorOccured = true;
            }
        }

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }

        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
