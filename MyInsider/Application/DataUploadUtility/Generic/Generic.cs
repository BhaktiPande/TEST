using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using SFTPFileDownload;
using System.Collections;

namespace DataUploadUtility.Generic
{
    class Generic : IDisposable
    {
        #region Implementation of Singleton Pattern
        /// <summary>
        /// This is a singleton Pattern used for Facade
        /// </summary>
        private static Generic _instance;

        /// <summary>
        /// Constructors of Facade class
        /// </summary>
        protected Generic()
        {
            HT_ColumnsListForContDisc.Add("TransactionMasterId", "SequenceNo");
            HT_ColumnsListForContDisc.Add("UserLoginName", "UserName");
            HT_ColumnsListForContDisc.Add("RelationCodeId", "Relation");
            HT_ColumnsListForContDisc.Add("FirstLastName", "FirstNameLastName");
            HT_ColumnsListForContDisc.Add("DateOfAcquisition", "DateOfAcquisition");
            HT_ColumnsListForContDisc.Add("ModeOfAcquisitionCodeId", "ModeOfAcquisition");
            HT_ColumnsListForContDisc.Add("DateOfInitimationToCompany", "DateOfIntimitionToCompany");
            HT_ColumnsListForContDisc.Add("SecuritiesHeldPriorToAcquisition", "SecurityHeldPriorToAcquisition");
            HT_ColumnsListForContDisc.Add("DEMATAccountNo", "DematAccountNo");
            HT_ColumnsListForContDisc.Add("ExchangeCodeId", "StockExchange");
            HT_ColumnsListForContDisc.Add("TransactionTypeCodeId", "TransactionType");
            HT_ColumnsListForContDisc.Add("SecurityTypeCodeId", "Security Type");
            HT_ColumnsListForContDisc.Add("PerOfSharesPreTransaction", "%Share PreTransaction");
            HT_ColumnsListForContDisc.Add("PerOfSharesPostTransaction", "%Share Post Transaction");
            HT_ColumnsListForContDisc.Add("Quantity", "NoOfSharesOrUnits");
            HT_ColumnsListForContDisc.Add("Value", "Value");
            HT_ColumnsListForContDisc.Add("ESOPQuantity", "ESOPQuantity");
            HT_ColumnsListForContDisc.Add("OtherQuantity", "OtherQuantity");
            HT_ColumnsListForContDisc.Add("Quantity2", "NoOfSecuritiesSoldForCashless");
            HT_ColumnsListForContDisc.Add("Value2", "Value2");
            HT_ColumnsListForContDisc.Add("LotSize", "LotSize");
            HT_ColumnsListForContDisc.Add("ContractSpecification", "ContractSpecification");
            HT_ColumnsListForContDisc.Add("Category", "Category");
        }

        /// <summary>
        /// Destructors of Facade class
        /// </summary>
        ~Generic()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a DBUtility class
        /// </summary>
        /// <returns>returning the instance of an object</returns>
        public static Generic Instance()
        {
            if (_instance == null)
            {
                _instance = new Generic();
            }
            return _instance;
        }
        #endregion

        #region Private variable declaration
        Dictionary<string, string> dictLstResources = new Dictionary<string, string>();
        private Dictionary<string, string> DataUploadedDetails = new Dictionary<string, string>();
        private string s_ErrorMessageCode = "";
        private string s_ConnectionString = string.Empty;
        Dictionary<string, int> m_objCompanyNamesDisct = new Dictionary<string, int>();
        Dictionary<string, int> m_objRolesNameWiseDisct = new Dictionary<string, int>();
        private string b_IsWriteToConsole = string.Empty;
        private string s_SendMailWithAttachment = string.Empty;

        private DataTable DT_ColumnNames = new DataTable("DT_ColumnNames");

        private int n_RowNumber = 0;

        private Hashtable HT_ColumnsListForContDisc = new Hashtable();


        #endregion

        #region Public Variable Declaration
        int s_Kotak_HRMS_Integration = 0;
        #endregion

        #region Create log file and folder
        /// <summary>
        /// This method is used to create Log file on local machine
        /// </summary>
        internal void CreateLogFile()
        {
            string s_LogFilePath = ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString().Equals(".") ? Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + "\\" : ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString();

            if (!Directory.Exists(s_LogFilePath + @"\LogFile"))
            {
                Directory.CreateDirectory(s_LogFilePath + @"\LogFile");
            }

            if (File.Exists(s_LogFilePath + @"\LogFile"))
            {
                File.Delete(s_LogFilePath + @"\LogFile");
                File.CreateText(s_LogFilePath + @"\LogFile\" + (CommonModel.HT_Modules.Count.Equals(4) ? string.Empty : Convert.ToString(CommonModel.HT_Modules.Values.OfType<string>().First()) + "_") + DateTime.Now.ToString("ddMMMyyyy") + "_Log.txt");
            }
        }
        #endregion

        #region Add company names to datatable
        /// <summary>
        /// This method is used to get companies form web.config and create DataTable
        /// </summary>
        /// <returns>DataTable</returns>
        internal DataTable GetCompanyList()
        {
            using (DataTable dt_CompanyDetails = new DataTable("DT"))
            {
                dt_CompanyDetails.Columns.Add("CompanyNames", typeof(string));
                dt_CompanyDetails.Columns.Add("LogFileDetails", typeof(string));
                foreach (string perLIne in ConfigurationManager.AppSettings["CompanyNames"].ToString().Split(','))
                {
                    if (perLIne.ToLower() == ("Kotak_UAT").ToLower())
                    {
                        s_Kotak_HRMS_Integration = 1;
                    }
                    DataRow DR = dt_CompanyDetails.NewRow();
                    DR["CompanyNames"] = perLIne;
                    DR["LogFileDetails"] = ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString().Equals(".") ? Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + "\\" : ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString();
                    dt_CompanyDetails.Rows.Add(DR);
                }
                return dt_CompanyDetails;
            }
        }
        #endregion

        #region DefaultTextForLogFile
        /// <summary>
        /// Method is used to set starting default text for LogFile
        /// </summary>
        /// <param name="s_CompanyName">string: Company Name</param>
        internal void DefaultTextForLogFile(string s_CompanyName)
        {
            CommonModel.sbString.AppendLine(CommonModel.s_StarLine);
            CommonModel.sbString.AppendLine(string.Format(CommonModel.s_LogfileCompanyName, s_CompanyName));
            CommonModel.sbString.AppendLine(string.Format(CommonModel.s_LogfileGeneratedOn, DateTime.Now));
            CommonModel.sbString.AppendLine(CommonModel.s_StarLine);
        }
        #endregion

        #region Get Company Information
        /// <summary>
        /// This method is used to get Company Information
        /// </summary>
        /// <param name="s_CompanyName">string: Company Name</param>
        /// <param name="objSelectedCompany">object of CompanyDTO</param>
        internal void GetAllCompanyInfo(string s_CompanyName, ref CompanyDTO objSelectedCompany)
        {
            try
            {
                objSelectedCompany = CommonModel.GetCompanyDetials(s_CompanyName);
            }
            catch (Exception ex)
            {
                CommonModel.sbString.Append(CommonModel.s_LookUpPrefix + CommonModel.s_ResID_GetCompDetails);
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                CommonModel.b_IsErrorOccured = true;
            }
        }
        #endregion

        #region FetchAllCodes
        /// <summary>
        /// This method will be used for fetching all the codes from com_code table and maintain the list of CodesDTO and a dictionary containing the collection
        /// of CodeDisplayCode+"_"+CodeGroupid or  Codename+"_"+CodeGroupid if CodeDisplayCode is null, against the CodeNo. This will be used for cnverting the 
        /// code values as added in the excel to code as to be saved in the table.
        /// </summary>
        internal void FetchAllCodes(ref CompanyDTO objSelectedCompany, ref List<CodesDTO> m_objCodesDTOList, ref Dictionary<string, int> m_objCodesNameWiseDisct)
        {
            CodesDTO objCodesDTOTmp;
            using (MassUploadDAL m_objMassUploadDAL = new MassUploadDAL())
            {
                try
                {
                    m_objCodesDTOList = m_objMassUploadDAL.GetAllComCodes(objSelectedCompany.CompanyConnectionString);
                    foreach (CodesDTO objCodesDTO in m_objCodesDTOList)
                    {
                        objCodesDTOTmp = objCodesDTO;
                        try
                        {
                            if (objCodesDTO.DisplayCode == null || objCodesDTO.DisplayCode == "")
                            {
                                if (!m_objCodesNameWiseDisct.ContainsKey(objCodesDTO.CodeName.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)))
                                    m_objCodesNameWiseDisct.Add((objCodesDTO.CodeName.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)), Convert.ToInt32(objCodesDTO.CodeID));
                            }
                            else
                            {
                                if (!m_objCodesNameWiseDisct.ContainsKey(objCodesDTO.DisplayCode.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)))
                                    m_objCodesNameWiseDisct.Add((objCodesDTO.DisplayCode.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)), Convert.ToInt32(objCodesDTO.CodeID));
                            }
                        }
                        catch (Exception exp)
                        {
                            CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, exp.Message));
                            CommonModel.b_IsErrorOccured = true;
                        }
                    }
                }
                catch (Exception exp)
                {
                    string errormessage = exp.Message;
                }
            }
        }
        #endregion FetchAllCodes

        #region Create mapping and upload data
        /// <summary>
        /// This method is used to create mappings and upload data
        /// </summary>
        /// <param name="ds_DataFromExcelFile">DataSet: Data from excel file</param>
        /// <param name="objDataUploadUtilityDTO">List: DataUploadUtilityDTO</param>
        /// <param name="objMappingFieldsDTO">List: MappingFieldsDTO</param>
        /// <param name="s_CompanyName">string: Company Name</param>
        /// <param name="o_lstResources">Dictionary: collection of resources</param>
        /// <param name="s_ConnectionStringFromDB">string: connection string</param>
        /// <param name="m_objCodesNameWiseDisct">Dictionary: CodesNameWise Disct</param>
        /// <returns>DataSet</returns>
        internal DataSet CreateMappingAndUpload(DataSet ds_DataFromExcelFile, List<DataUploadUtilityDTO> objDataUploadUtilityDTO, List<MappingFieldsDTO> objMappingFieldsDTO, string s_CompanyName, Dictionary<string, string> o_lstResources, string s_ConnectionStringFromDB, Dictionary<string, int> m_objCodesNameWiseDisct)
        {
            try
            {
                CommonModel.d_StartDate = DateTime.Now;

                b_IsWriteToConsole = ConfigurationManager.AppSettings["WriteToConsole"];
                objDataUploadUtilityDTO = new List<DataUploadUtilityDTO>();
                dictLstResources = o_lstResources;
                s_ConnectionString = s_ConnectionStringFromDB;

                WriteToConsole(CommonModel.s_Start, string.Empty);

                objDataUploadUtilityDTO = GetMappingDetails(s_CompanyName);

                if (objDataUploadUtilityDTO.Count >= 1)
                {
                    ds_DataFromExcelFile = GetMappingData(objDataUploadUtilityDTO);

                    WriteToConsole(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ReadExcelOrQuery], s_CompanyName);
                }
                else
                {
                    goto DataNotFound;
                }

                objMappingFieldsDTO = new List<MappingFieldsDTO>();
                objMappingFieldsDTO = GetMappingFieldsDetails(s_CompanyName);

                if (objMappingFieldsDTO.Count >= 1)
                {
                    WriteToConsole(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ReadMappings], s_CompanyName);

                    using (DataTable dt_FinalOutputTable = new DataTable())
                    {
                        CreateFinalDataTableAndUpload(objMappingFieldsDTO, ds_DataFromExcelFile, dt_FinalOutputTable, s_CompanyName, m_objCodesNameWiseDisct);
                    }
                }
                else
                {
                    CommonModel.sbString.AppendLine(string.Format(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_GetMappingFields], s_CompanyName));
                    goto DataNotFound;
                }
            }
            catch (Exception exp)
            {
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, exp.Message));
                CommonModel.b_IsErrorOccured = true;
            }

        /*Go to statement*/
        DataNotFound:

            return ds_DataFromExcelFile;
        }
        #endregion

        #region Get mapping data based on condition as FileBased/QueryBased
        /// <summary>
        /// This method is used to get mapping data
        /// </summary>
        /// <param name="objaDataUploadUtilityDTO">DataUploadUtilityDTO: DTO object</param>
        /// <returns>DataTable</returns>
        private DataSet GetMappingData(List<DataUploadUtilityDTO> objaDataUploadUtilityDTO)
        {
            try
            {
                DataSet ds_MappingTables = new DataSet();
                int n_Count = 1;                
                foreach (DataUploadUtilityDTO perDataUploadUtilityDTO in objaDataUploadUtilityDTO)
                {
                    switch (perDataUploadUtilityDTO.UploadMode.ToUpper())
                    {
                        case "FILEBASED":

                            /* For download file from SFTP server */
                            switch (perDataUploadUtilityDTO.IsSFTPEnable.ToString().ToUpper())
                            {
                                case "TRUE":
                                    string s_ErrorMessage = string.Empty;
                                    using (SFTPFileDownload.SFTPFileDownload o_SFTPFileDownload = new SFTPFileDownload.SFTPFileDownload())
                                    {
                                        SFTPFileDownload.AppData.SFTPFileProperties o_SFTPFileProperties = new SFTPFileDownload.AppData.SFTPFileProperties();
                                        o_SFTPFileProperties.s_HostName = perDataUploadUtilityDTO.HostName;
                                        o_SFTPFileProperties.s_UserName = perDataUploadUtilityDTO.UserName;
                                        o_SFTPFileProperties.s_Password = perDataUploadUtilityDTO.Password;
                                        o_SFTPFileProperties.n_PortNumber = perDataUploadUtilityDTO.PortNumber;
                                        o_SFTPFileProperties.s_SshHostKeyFingerprint = perDataUploadUtilityDTO.SshHostKeyFingerprint;
                                        o_SFTPFileProperties.s_SourceFilePath = perDataUploadUtilityDTO.SourceFilePath;
                                        o_SFTPFileProperties.s_OutputPath = perDataUploadUtilityDTO.FilePath;
                                        o_SFTPFileProperties.s_EncryptedKey = CommonModel.EncryptedKey(o_SFTPFileProperties, 1);
                                        if (o_SFTPFileDownload.DownloadFileFromSFTP(o_SFTPFileProperties, out s_ErrorMessage))
                                        {
                                            WriteToConsole(s_ErrorMessage, string.Empty);
                                        }
                                    }
                                    break;
                            }
                            DT_ColumnNames.Clear();
                            DT_ColumnNames.AcceptChanges();
                            if (perDataUploadUtilityDTO.ExcelSheetDetailsID.Equals(13))
                            {
                                try
                                {
                                    switch (perDataUploadUtilityDTO.DisplayName.ToUpper())
                                    {
                                        case "ESOPDIRECTFEED":
                                            WriteToConsole("Reading to ESOPDIRECTFEED file.", string.Empty);
                                            GetColumnsFromDB("du_type_OnGoingContDiscData_Esop");
                                            ds_MappingTables.Tables.Add(ReadMappedDataBasedOnSettings(DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, string.Empty, string.Empty), CommonModel.s_SP_GetOnGngDiscDetails_Esop, CommonModel.s_TPYE_OnGngDiscDetails_Esop, "OnGoingContDiscData_Esop" + n_Count));
                                            break;

                                        case "AXISDIRECTFEED":
                                            WriteToConsole("Reading to AXISDIRECTFEED file.", string.Empty);
                                            GetColumnsFromDB("du_type_OnGoingContDiscData");
                                            ds_MappingTables.Tables.Add(ReadMappedDataBasedOnSettings(DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, string.Empty, string.Empty), CommonModel.s_SP_GetOnGngDiscDetails, CommonModel.s_TPYE_OnGngDiscDetails, "OnGoingContDiscData_Axis" + n_Count));
                                            break;
                                    }
                                }
                                catch (FileNotFoundException ex)
                                {
                                    ds_MappingTables.Tables.Add(new DataTable(Convert.ToString(n_Count)));
                                    WriteToConsole(ex.Message, string.Empty);
                                }
                                catch (Exception ex)
                                {
                                    WriteToConsole(ex.Message, string.Empty);
                                }
                            }
                            else
                            {
                                try
                                {
                                    ds_MappingTables.Tables.Add(DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, string.Empty, string.Empty));
                                }
                                catch (FileNotFoundException ex)
                                {
                                    ds_MappingTables.Tables.Add(new DataTable(Convert.ToString(n_Count)));
                                    WriteToConsole(ex.Message, string.Empty);
                                }
                                catch (Exception ex)
                                {
                                    WriteToConsole(ex.Message, string.Empty);
                                }
                            }
                            break;

                        case "QUERYBASED":
                            /* Specific to Axis Bank */
                            switch (perDataUploadUtilityDTO.ExcelSheetDetailsID)
                            {
                                case 1:
                                    try
                                    {
                                        WriteToConsole("Reading QUERYBASED data.", string.Empty);
                                        using (DataTable dt_EmployeeDetailsAxisBank = DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, perDataUploadUtilityDTO.ConnectionString, perDataUploadUtilityDTO.Query))
                                        {
                                            WriteToConsole("Get employee details for employees : " + dt_EmployeeDetailsAxisBank.Rows.Count, string.Empty);
                                            GetColumnsFromDB("du_type_EmployeeDetailsAxisBank");
                                            ds_MappingTables.Tables.Add(ReadMappedDataBasedOnSettings(dt_EmployeeDetailsAxisBank, CommonModel.s_SP_GetEmployeeDetails, CommonModel.s_TPYE_EmployeeDetailsAxisBank, "QueryBased_Data" + n_Count));
                                            WriteToConsole("Get employee details completed", string.Empty);
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        WriteToConsole(ex.Message, string.Empty);
                                        throw;
                                    }
                                    break;
                                case 13:

                                    try
                                    {
                                        switch (perDataUploadUtilityDTO.DisplayName.ToUpper())
                                        {
                                            case "ESOPDIRECTFEED":
                                                WriteToConsole("Reading to ESOPDIRECTFEED file.", string.Empty);
                                                GetColumnsFromDB("du_type_OnGoingContDiscData_Esop");
                                                ds_MappingTables.Tables.Add(ReadMappedDataBasedOnSettings(DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, perDataUploadUtilityDTO.ConnectionString, perDataUploadUtilityDTO.Query), CommonModel.s_SP_GetOnGngDiscDetails_Esop, CommonModel.s_TPYE_OnGngDiscDetails_Esop, "OnGoingContDiscData_Esop" + n_Count));
                                                break;

                                            case "AXISDIRECTFEED":
                                                WriteToConsole("Reading to AXISDIRECTFEED file.", string.Empty);
                                                GetColumnsFromDB("du_type_OnGoingContDiscData");
                                                ds_MappingTables.Tables.Add(ReadMappedDataBasedOnSettings(DownloadExcelFileOrFromQuery(perDataUploadUtilityDTO, perDataUploadUtilityDTO.ConnectionString, perDataUploadUtilityDTO.Query), CommonModel.s_SP_GetOnGngDiscDetails, CommonModel.s_TPYE_OnGngDiscDetails, "OnGoingContDiscData_Axis" + n_Count));
                                                break;
                                        }
                                    }
                                    catch (FileNotFoundException ex)
                                    {
                                        ds_MappingTables.Tables.Add(new DataTable(Convert.ToString(n_Count)));
                                        WriteToConsole(ex.Message, string.Empty);
                                    }
                                    catch (Exception ex)
                                    {
                                        WriteToConsole(ex.Message, string.Empty);
                                    }

                                    break;
                                
                            }

                            break;
                    }
                    n_Count++;
                }
                return ds_MappingTables;
            }
            catch (Exception ex)
            {
                CommonModel.sbString.AppendLine(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_DownloadExcel]);
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                CommonModel.b_IsErrorOccured = true;
            }
            return new DataSet();
        }

        private void GetColumnsFromDB(string s_TableTypeName)
        {
            using (SqlConnection conn = new SqlConnection(s_ConnectionString))
            {
                try
                {

                    using (SqlCommand sqlcmd = new SqlCommand("SELECT SYSCOL.NAME FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLE_TYPES SYSTAB ON SYSTAB.type_table_object_id = SYSCOL.object_id AND SYSTAB.name = '" + s_TableTypeName + "'  ORDER BY SYSCOL.column_id", conn))
                    {
                        sqlcmd.CommandType = CommandType.Text;
                        sqlcmd.CommandTimeout = 150000;
                        conn.Open();
                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlcmd))
                        {
                            sqlDataAdapter.Fill(DT_ColumnNames);
                        }

                    }
                }
                catch
                {
                }
                finally
                {
                    conn.Close();
                }
            }
        }
        #endregion

        #region Download Excel file
        /// <summary>
        /// This method is used to download excel file
        /// </summary>
        /// <param name="objDataUploadUtilityDTO">DataUploadUtilityDTO: per company details</param>
        /// <param name="s_QueryConnectionString">string: Connection String if it is query based</param>
        /// <param name="s_Query">string: Query to get records if it is query based</param>
        /// <returns>DataTable</returns>
        private DataTable DownloadExcelFileOrFromQuery(DataUploadUtilityDTO objDataUploadUtilityDTO, string s_QueryConnectionString, string s_Query)
        {
            DataTable dt_ImportDataFromExcel = new DataTable();

            string strConnectionString = string.IsNullOrEmpty(s_QueryConnectionString) ? CommonModel.GetConnectionString(System.IO.Path.GetDirectoryName(objDataUploadUtilityDTO.FilePath + @"\" + objDataUploadUtilityDTO.FileName) + @"\" + objDataUploadUtilityDTO.FileName) : s_QueryConnectionString;
            string[] columns = null;

            if ((!string.IsNullOrEmpty(objDataUploadUtilityDTO.FileName)) && objDataUploadUtilityDTO.FileName.Split('.').Last().ToUpper().Equals("CSV"))
            {
                var lines = File.ReadAllLines(objDataUploadUtilityDTO.FilePath + @"\" + objDataUploadUtilityDTO.FileName);
                int startingNumber = 1;
                // assuming the first row contains the columns information
                if (lines.Count() > 0)
                {
                    if (lines[0].ToString().Contains("Report on transactions "))
                    {
                        //columns = lines[1].Split(new char[] { '|' }); //Kotak
                        columns = lines[1].Split(new char[] { ',' });
                        startingNumber = 2;
                    }
                    else
                        //columns = lines[0].Split(new char[] { '|' }); //Kotak
                        columns = lines[0].Split(new char[] { ',' });

                    foreach (var column in columns)
                        dt_ImportDataFromExcel.Columns.Add(column);
                }

                // reading rest of the data

                for (int i = startingNumber; i < lines.Count(); i++)
                {
                    DataRow dr = dt_ImportDataFromExcel.NewRow();
                    //string[] values = lines[i].Split(new char[] { '|' });
                    string[] values = lines[i].Split(new char[] { ',' }); //Kotak

                    for (int j = 0; j < values.Count() && j < columns.Count(); j++)
                        dr[j] = values[j];

                    dt_ImportDataFromExcel.Rows.Add(dr);
                }

                PrepareColumnsAndSetOrder(dt_ImportDataFromExcel);
            }
            else
            {
                using (OleDbConnection oleDbConnection = new OleDbConnection(strConnectionString))
                {
                    oleDbConnection.Open();
                    try
                    {
                        using (OleDbCommand oleDbCommand = new OleDbCommand())
                        {
                            oleDbCommand.Connection = oleDbConnection;
							oleDbCommand.CommandTimeout = 150000;
                            if (!string.IsNullOrEmpty(s_Query) && s_Query.Split(';').Length > 1)
                            {
                                oleDbCommand.CommandText = s_Query.Split(';')[0].ToString();
                                oleDbCommand.ExecuteNonQuery();
                                s_Query = s_Query.Split(';')[1].ToString();
                            }

                            oleDbCommand.CommandText = string.IsNullOrEmpty(s_Query) ? String.Format(CommonModel.s_SelectStatement, objDataUploadUtilityDTO.ExcelSheetName) : s_Query;

                            OleDbDataAdapter oleDbDataAdapter = new OleDbDataAdapter(oleDbCommand);
                            oleDbDataAdapter.Fill(dt_ImportDataFromExcel);
                            oleDbDataAdapter.Dispose();

                            WriteToConsole("Total record found from query: " + dt_ImportDataFromExcel.Rows.Count, string.Empty);

                            if (string.IsNullOrEmpty(s_Query))
                            {
                                PrepareColumnsAndSetOrder(dt_ImportDataFromExcel);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                        CommonModel.b_IsErrorOccured = true;
                    }
                    finally
                    {
                        oleDbConnection.Close();
                    }
                }
            }
            return dt_ImportDataFromExcel;

        }

        /// <summary>
        /// This method is used to set order of columns and prepare columns as per table type
        /// </summary>
        /// <param name="dt_ImportDataFromExcel">ImportDataFromExcel</param>
        private void PrepareColumnsAndSetOrder(DataTable dt_ImportDataFromExcel)
        {
            if (DT_ColumnNames != null && DT_ColumnNames.Rows.Count > 0)
            {
                string[] s_ColumnList = new string[DT_ColumnNames.Rows.Count];
                int intCount = 0;
                using (DataTable DT_ImportDataFromExcelClone = dt_ImportDataFromExcel.Clone())
                {
                    foreach (DataColumn perColumn in DT_ImportDataFromExcelClone.Columns)
                    {
                        if (DT_ColumnNames.Select("NAME='" + perColumn.ColumnName.ToString() + "'").Length.Equals(0))
                            dt_ImportDataFromExcel.Columns.Remove(perColumn.ColumnName.ToString());
                        else
                        {
                            s_ColumnList[intCount] = DT_ColumnNames.Rows[intCount]["NAME"].ToString();
                            intCount++;
                        }
                    }
                }

                SetColumnsOrder(dt_ImportDataFromExcel, s_ColumnList);
            }
        }

        /// <summary>
        /// This method is used to re-order Datatable columns.
        /// </summary>
        /// <param name="dataTable">orignal datatable</param>
        /// <param name="columnNames">array of column names</param>
        /// <returns>DataTable</returns>
        public static DataTable SetColumnsOrder(DataTable dataTable, params String[] columnNames)
        {
            for (int columnIndex = 0; columnIndex < columnNames.Length; columnIndex++)
            {
                dataTable.Columns[columnNames[columnIndex]].SetOrdinal(columnIndex);
            }
            return dataTable;
        }

        /// <summary>
        /// This method is used to get data based on settings
        /// </summary>
        /// <param name="dt_ActualData">Datatable: Actual data from query</param>
        /// <param name="s_StoredProcedure">string: stored procedure name</param>
        /// <param name="s_TypeName">string: type name</param>
        /// <param name="s_DataTableName">string: DataTableName</param>
        /// <returns>DataTable</returns>
        private DataTable ReadMappedDataBasedOnSettings(DataTable dt_ActualData, string s_StoredProcedure, string s_TypeName, string s_DataTableName)
        {
            using (SqlConnection conn = new SqlConnection(s_ConnectionString))
            {
                using (DataTable dt_FilteredData = new DataTable(s_DataTableName))
                {
                    try
                    {
                        using (SqlCommand sqlcmd = new SqlCommand(s_StoredProcedure, conn))
                        {
                            sqlcmd.CommandType = CommandType.StoredProcedure;
                            sqlcmd.CommandTimeout = 150000;
                            sqlcmd.Parameters.AddWithValue(s_TypeName, dt_ActualData);
                            conn.Open();
                            using (SqlDataAdapter oleDbDataAdapter = new SqlDataAdapter(sqlcmd))
                            {
                                oleDbDataAdapter.Fill(dt_FilteredData);
                            }

                            if (dt_FilteredData != null && dt_FilteredData.Rows.Count > 0)
                            {
                                WriteToConsole("Total records processed : " + dt_FilteredData.Rows.Count, string.Empty);
                            }
                            else
                            {
                                WriteToConsole("No record processed", string.Empty);
                            }
                        }
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Message.Contains("datetime data type resulted in an out-of-range value"))
                        {
                            WriteToConsole("Incorrect date format found in the file.", string.Empty);
                        }

                    }
                    catch (Exception ex)
                    {
                        WriteToConsole(ex.Message.ToString(), string.Empty);
                    }
                    finally
                    {
                        conn.Close();
                    }
                    return dt_FilteredData;
                }
            }
        }
        #endregion

        #region Get mapping details based on condition as FileBased/QueryBased
        /// <summary>
        /// This method is used to get mapping details
        /// </summary>
        /// <param name="s_CompanyName">string: Company Name</param>
        /// <returns>List: DataUploadUtilityDTO</returns>
        private List<DataUploadUtilityDTO> GetMappingDetails(string s_CompanyName)
        {
            List<DataUploadUtilityDTO> objaDataUploadUtilityDTO = new List<DataUploadUtilityDTO>();
            List<DataUploadUtilityDTO> objaDataUploadUtilityDTO_Temp = new List<DataUploadUtilityDTO>();
            try
            {
                using (DataUploadUtilityDAL objDataUploadUtilityDAL = new DataUploadUtilityDAL())
                {
                    objaDataUploadUtilityDTO = objDataUploadUtilityDAL.GetMappingDetails(s_ConnectionString);

                    if (!CommonModel.HT_Modules.Count.Equals(4))
                    {
                        Hashtable HT_ModuleList = new Hashtable();
                        foreach (var item in objaDataUploadUtilityDTO)
                        {
                            if (CommonModel.HT_Modules[item.DisplayName] == null && !HT_ModuleList.Contains(item.DisplayName))
                                HT_ModuleList.Add(item.DisplayName, item.DisplayName);

                        }

                        foreach (var perKey in HT_ModuleList.Keys)
                        {
                            objaDataUploadUtilityDTO_Temp = objaDataUploadUtilityDTO.Where(D => D.DisplayName == perKey.ToString()).ToList();

                            for (int i = 0; i < objaDataUploadUtilityDTO_Temp.Where(D => D.DisplayName == perKey.ToString()).ToList().Count; i++)
                                objaDataUploadUtilityDTO.Remove(objaDataUploadUtilityDTO_Temp[i]);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                CommonModel.sbString.AppendLine(string.Format(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorMappingDetails], s_CompanyName));
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                CommonModel.b_IsErrorOccured = true;
            }
            return objaDataUploadUtilityDTO;
        }
        #endregion

        #region Get mapping fields details
        /// <summary>
        /// This method is used to get mapping fields details
        /// </summary>
        /// <param name="s_CompanyName">string: Company Name</param>
        /// <returns>List: MappingFieldsDTO</returns>
        private List<MappingFieldsDTO> GetMappingFieldsDetails(string s_CompanyName)
        {
            List<MappingFieldsDTO> objMappingFieldsDTO = new List<MappingFieldsDTO>();
            List<MappingFieldsDTO> objMappingFieldsDTO_Temp = new List<MappingFieldsDTO>();

            try
            {
                using (DataUploadUtilityDAL objDataUploadUtilityDAL = new DataUploadUtilityDAL())
                {
                    objMappingFieldsDTO = objDataUploadUtilityDAL.GetMappingFieldsDetails(s_ConnectionString);

                    if (!CommonModel.HT_Modules.Count.Equals(4))
                    {
                        Hashtable HT_ModuleList = new Hashtable();
                        foreach (var item in objMappingFieldsDTO)
                        {
                            if (CommonModel.HT_Modules[item.DisplayName] == null)
                                if (!HT_ModuleList.ContainsKey(item.DisplayName))
                                    HT_ModuleList.Add(item.DisplayName, item.DisplayName);
                        }

                        foreach (var perKey in HT_ModuleList.Keys)
                        {
                            objMappingFieldsDTO_Temp = objMappingFieldsDTO.Where(D => D.DisplayName == perKey.ToString()).ToList();
                            for (int intLoop = 0; intLoop < objMappingFieldsDTO_Temp.Count; intLoop++)
                                objMappingFieldsDTO.Remove(objMappingFieldsDTO_Temp[intLoop]);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                CommonModel.sbString.AppendLine(string.Format(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorMappingFields]));
                CommonModel.sbString.AppendLine(string.Format(CommonModel.s_ErrorMessage, ex.Message));
                CommonModel.b_IsErrorOccured = true;
            }
            return objMappingFieldsDTO;
        }
        #endregion

        #region CreateFinalDataTable and Upload Data
        /// <summary>
        /// This method is used to create final DataTable
        /// </summary>
        /// <param name="objMappingFieldsDTO">List:List of MappingFieldsDTO</param>
        /// <param name="ds_DataFromExcelFile">DataSet: DataFromExcelFile</param>
        /// <param name="dt_FinalOutputTable">DataTable: FinalOutputTable</param>
        /// <param name="s_CompanyName">string: CompanyName</param>
        /// <param name="m_objCodesNameWiseDisct">Dictionary: CodesNameWiseDisct</param>
        private void CreateFinalDataTableAndUpload(List<MappingFieldsDTO> objMappingFieldsDTO, DataSet ds_DataFromExcelFile, DataTable dt_FinalOutputTable, string s_CompanyName, Dictionary<string, int> m_objCodesNameWiseDisct)
        {
            try
            {
                Stopwatch sw_TimeTaken;
                List<MassUploadResponseDTO> objResponseList = new List<MassUploadResponseDTO>();
                List<MassUploadResponseDTO> objResponseListHistory = new List<MassUploadResponseDTO>();
                int n_Counter = 0, n_ExcelSheetDetailsID = 0, n_IsPrimarySheet = 0;
                string s_FilePath = string.Empty;
                Dictionary<string, string> d_RequiredFieldDetails = new Dictionary<string, string>();
                DataTable dtErrorList = new DataTable();
                dtErrorList.Columns.Add("UserID", typeof(string));
                dtErrorList.Columns.Add("Usercategory", typeof(string));
                dtErrorList.Columns.Add("Description", typeof(string));

                foreach (Int32 MappingTableID in (from b in objMappingFieldsDTO select b.MappingTableID).Distinct().ToArray())
                {
                    using (DataTable dt_ExcelSheetDataForMU = new DataTable())
                    {
                        if (ds_DataFromExcelFile.Tables[n_Counter] != null && ds_DataFromExcelFile.Tables[n_Counter].Rows.Count > 0)
                        {
                            Int32 perMassUploadExcelSheetId = 0;
                            foreach (DataRow perRow in objMappingFieldsDTO.ToDataTable().Select("MappingTableID='" + MappingTableID + "'"))
                            {
                                perMassUploadExcelSheetId = Convert.ToInt32(perRow["MassUploadExcelSheetId"].ToString());
                                WriteToConsole("     ", s_CompanyName);
                                WriteToConsole("*********", s_CompanyName);
                                WriteToConsole("Processing data for " + (string.IsNullOrEmpty(perRow["FilePath"].ToString()) ? "HRMS" : Path.GetFileName(perRow["FilePath"].ToString())), s_CompanyName);
                                dt_FinalOutputTable.TableName = (perMassUploadExcelSheetId.Equals(14) ? Path.GetFileName(perRow["FilePath"].ToString()) + "_OnGoingContinuousDisclosuretransactions" : "HRMS");
                                break;
                            }
                            switch (perMassUploadExcelSheetId)
                            {
                                case 1:
                                    ds_DataFromExcelFile.Tables[n_Counter].Columns.Add("CompanyName", typeof(string));
                                    ds_DataFromExcelFile.Tables[n_Counter].Columns["CompanyName"].DefaultValue = GetImplementingCompany(s_ConnectionString);
                                    FetchAllRoleNames(s_ConnectionString);
                                    FetchAllCompanyNames(s_ConnectionString);
                                    break;
                            }

                            using (MassUploadDAL m_objMassUploadDAL = new MassUploadDAL())
                            {
                                List<InsiderTradingDAL.MassUploadDTO> lstMassUploadDTO = (List<InsiderTradingDAL.MassUploadDTO>)m_objMassUploadDAL.GetMassUploadConfiguration(objMappingFieldsDTO.Where(c => c.MassUploadExcelSheetId.Equals(perMassUploadExcelSheetId)).ToList().First().MassUploadExcelId, s_ConnectionString);

                                sw_TimeTaken = Stopwatch.StartNew();
                                /* Convert list to DataTable (.ToDataTable() in an extension method which is used to convert list into DataTable)*/
                                using (DataTable dt_MassUploadDTO = lstMassUploadDTO.ToDataTable())
                                {
                                    DataRow dr;
                                    DataRow dr_MU;

                                    /* Create columns to update data */
                                    CreateColumns(objMappingFieldsDTO.Where(c => c.MassUploadExcelSheetId.Equals(perMassUploadExcelSheetId) && c.MappingTableID.Equals(MappingTableID)).ToList(), dt_FinalOutputTable, dt_ExcelSheetDataForMU);

                                    /* Write to Log */
                                    WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_MappingFields], s_CompanyName);

                                    string _ColumnName = string.Empty;
                                    Console.WriteLine("     " + " Total Number of rows to process are : " + ds_DataFromExcelFile.Tables[n_Counter].Rows.Count);

                                    /* Insert data from excel */
                                    foreach (DataRow perRow in ds_DataFromExcelFile.Tables[n_Counter].Rows)
                                    {
                                        if (ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains("LoginId"))
                                            _ColumnName = "LoginId";
                                        else if (ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains("UserLoginName"))
                                            _ColumnName = "UserLoginName";
                                        else
                                            _ColumnName = ds_DataFromExcelFile.Tables[n_Counter].Columns[0].ColumnName;

                                        Console.WriteLine("     " + " Processing for employee : " + perRow[_ColumnName].ToString());


                                        n_RowNumber = 2;
                                        dr = dt_FinalOutputTable.NewRow();
                                        dr_MU = dt_ExcelSheetDataForMU.NewRow();
                                        /* Map columns as per settings done */
                                        foreach (MappingFieldsDTO perMappingFieldsDTO in objMappingFieldsDTO.Where(c => c.MassUploadExcelSheetId.Equals(perMassUploadExcelSheetId) && c.MappingTableID.Equals(MappingTableID)))
                                        {
                                            n_ExcelSheetDetailsID = perMappingFieldsDTO.MassUploadExcelSheetId;
                                            s_FilePath = perMappingFieldsDTO.FilePath;
                                            n_IsPrimarySheet = Convert.ToInt16(perMappingFieldsDTO.IsPrimarySheet);
                                            /* Update data if excel sheet has multiple sheet based on response get from first mass upload */
                                            if (!perMappingFieldsDTO.IsPrimarySheet)
                                            {
                                                switch (perMassUploadExcelSheetId)
                                                {
                                                    case 2:
                                                    case 3:
                                                        dr[0] = objResponseListHistory[Convert.ToInt32(perRow[1]) - 1].MassUploadResponseId;
                                                        break;

                                                    default:
                                                        dr[1] = objResponseListHistory[Convert.ToInt32(perRow[1]) - 1].MassUploadResponseId;
                                                        break;
                                                }

                                            }

                                            switch (perMappingFieldsDTO.ActualFieldDataType.ToString().ToUpper())
                                            {
                                                case "INT":
                                                    /*
                                                       dt_MassUploadDTO.Select("ApplicableDataCodeGroupId IS NOT NULL AND MassUploadDataTablePropertyName = '" + perMappingFieldsDTO.ActualFieldName + "'").Length > 0
                                   
                                                       Above code check whether Field has any ApplicableDataCodeGroupId and if it is present then get the com_Code based on MassUploadDataTablePropertyName.
                                                       It returns length and if length is greater than one ApplicableDataCodeGroupId is present 
                                                    */
                                                    DataRow[] ApplicableDataCodeGroupId = dt_MassUploadDTO.Select("ApplicableDataCodeGroupId IS NOT NULL AND MassUploadDataTablePropertyName = '" + perMappingFieldsDTO.ActualFieldName + "'");

                                                    if (ApplicableDataCodeGroupId.Length > 0 && ApplicableDataCodeGroupId[0]["ApplicableDataCodeGroupId"].ToString().Equals("-1"))
                                                    {
                                                        dr[perMappingFieldsDTO.ActualFieldName] = m_objCompanyNamesDisct[Convert.ToString(GetImplementingCompany(s_ConnectionString)).ToLower()];
                                                    }
                                                    else
                                                    {
                                                        try
                                                        {
                                                            if (ApplicableDataCodeGroupId.Length > 0)
                                                            {
                                                                dr[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? DBNull.Value : ApplicableDataCodeGroupId.Length > 0 ?
                                                                                                          ApplicableDataCodeGroupId[0]["ApplicableDataCodeGroupId"].ToString().Equals("-2") ? m_objRolesNameWiseDisct[Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName]).ToLower()] : string.IsNullOrEmpty(perRow[perMappingFieldsDTO.DisplayFieldName].ToString()) ? DBNull.Value :
                                                                                                          m_objCodesNameWiseDisct.Keys.Contains(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName]).ToLower() + "_" + ApplicableDataCodeGroupId[0]["ApplicableDataCodeGroupId"]) ? (object)m_objCodesNameWiseDisct[perRow[perMappingFieldsDTO.DisplayFieldName].ToString().ToLower() + "_" + ApplicableDataCodeGroupId[0]["ApplicableDataCodeGroupId"]] : AddKeyToComCode(perMappingFieldsDTO.ActualFieldName, perRow[perMappingFieldsDTO.DisplayFieldName].ToString(), m_objCodesNameWiseDisct) :
                                                                                                          string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? DBNull.Value : (object)Convert.ToInt32(perRow[perMappingFieldsDTO.DisplayFieldName]);
                                                            }
                                                        }
                                                        catch
                                                        {

                                                        }
                                                    }
                                                    dr_MU[perMappingFieldsDTO.ActualFieldName] = !string.IsNullOrEmpty(Convert.ToString(dr_MU[perMappingFieldsDTO.ActualFieldName])) ? dr_MU[perMappingFieldsDTO.ActualFieldName].ToString() + " " + perRow[perMappingFieldsDTO.DisplayFieldName].ToString() : !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? string.Empty : perRow[perMappingFieldsDTO.DisplayFieldName];
                                                    CheckFieldIsRequired(perRow, perMappingFieldsDTO, ref d_RequiredFieldDetails, ds_DataFromExcelFile.Tables[n_Counter]);
                                                    break;

                                                case "STRING":
                                                    dr[perMappingFieldsDTO.ActualFieldName] = !string.IsNullOrEmpty(Convert.ToString(dr[perMappingFieldsDTO.ActualFieldName])) ? dr[perMappingFieldsDTO.ActualFieldName].ToString() + " " + perRow[perMappingFieldsDTO.DisplayFieldName].ToString() : !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? string.Empty : perRow[perMappingFieldsDTO.DisplayFieldName];
                                                    dr_MU[perMappingFieldsDTO.ActualFieldName] = !string.IsNullOrEmpty(Convert.ToString(dr_MU[perMappingFieldsDTO.ActualFieldName])) ? dr_MU[perMappingFieldsDTO.ActualFieldName].ToString() + " " + perRow[perMappingFieldsDTO.DisplayFieldName].ToString() : !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? string.Empty : perRow[perMappingFieldsDTO.DisplayFieldName];
                                                    CheckFieldIsRequired(perRow, perMappingFieldsDTO, ref d_RequiredFieldDetails, ds_DataFromExcelFile.Tables[n_Counter]);
                                                    break;

                                                case "DECIMAL":
                                                    dr[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? 0 : string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? 0 : Convert.ToDecimal(perRow[perMappingFieldsDTO.DisplayFieldName]);
                                                    dr_MU[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? 0 : string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? 0 : Math.Round(Convert.ToDecimal(perRow[perMappingFieldsDTO.DisplayFieldName]), 2);
                                                    CheckFieldIsRequired(perRow, perMappingFieldsDTO, ref d_RequiredFieldDetails, ds_DataFromExcelFile.Tables[n_Counter]);
                                                    break;

                                                case "DATETIME":
                                                    dr[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? DBNull.Value : string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? DBNull.Value : (object)Convert.ToDateTime(perRow[perMappingFieldsDTO.DisplayFieldName]);
                                                    dr_MU[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? DBNull.Value : string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? DBNull.Value : (object)Convert.ToDateTime(perRow[perMappingFieldsDTO.DisplayFieldName]);
                                                    CheckFieldIsRequired(perRow, perMappingFieldsDTO, ref d_RequiredFieldDetails, ds_DataFromExcelFile.Tables[n_Counter]);
                                                    break;

                                                case "BIGINT":
                                                    dr[perMappingFieldsDTO.ActualFieldName] = !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? 0 : string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) ? 0 : Convert.ToInt64(perRow[perMappingFieldsDTO.DisplayFieldName]);
                                                    dr_MU[perMappingFieldsDTO.ActualFieldName] = !string.IsNullOrEmpty(Convert.ToString(dr_MU[perMappingFieldsDTO.ActualFieldName])) ? dr_MU[perMappingFieldsDTO.ActualFieldName].ToString() + " " + perRow[perMappingFieldsDTO.DisplayFieldName].ToString() : !ds_DataFromExcelFile.Tables[n_Counter].Columns.Contains(perMappingFieldsDTO.DisplayFieldName) ? string.Empty : perRow[perMappingFieldsDTO.DisplayFieldName];
                                                    CheckFieldIsRequired(perRow, perMappingFieldsDTO, ref d_RequiredFieldDetails, ds_DataFromExcelFile.Tables[n_Counter]);
                                                    break;
                                            }
                                        }
                                        dt_FinalOutputTable.Rows.Add(dr);
                                        dt_ExcelSheetDataForMU.Rows.Add(dr_MU);

                                        //Checked for Kotak HRMS Integration
                                        if (s_Kotak_HRMS_Integration == 1)
                                        {
                                            //For KMBL Employee's
                                            if (MappingTableID == 2)
                                            {
                                                foreach (DataRow drs in dt_FinalOutputTable.Rows)
                                                {
                                                    drs["RoleId"] = "4";
                                                }
                                            }

                                            //For NON-KMBL Employee's
                                            if (MappingTableID == 3)
                                            {
                                                foreach (DataRow drs in dt_FinalOutputTable.Rows)
                                                {
                                                    drs["RoleId"] = "5";
                                                }
                                            }
                                        }
                                        
                                        n_RowNumber++;
                                    }
                                }
                            }

                            /* Write to Log */
                            WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_MappingFieldsComplited], s_CompanyName);

                            try
                            {
                                if (d_RequiredFieldDetails.Count <= 0)
                                {
                                    /* Write to Log */
                                    WriteToConsole("     ", string.Empty);
                                    WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_DataUploading], s_CompanyName);
                                    using (DataTable dt_SeperationDetails = dt_FinalOutputTable.Columns.Contains("DateOfSeparation") ? GetSeperationDetailsForEmployeeUpload(ds_DataFromExcelFile, dt_FinalOutputTable, n_Counter, perMassUploadExcelSheetId) : new DataTable())
                                    {

                                        #region Upload Data
                                        string _ColumnName = string.Empty;
                                        Console.WriteLine("     " + " Total Number of rows to process are : " + dt_FinalOutputTable.Rows.Count);
                                        if (dt_FinalOutputTable.Columns.Contains("LoginId"))
                                            _ColumnName = "LoginId";
                                        else if (dt_FinalOutputTable.Columns.Contains("UserLoginName"))
                                            _ColumnName = "UserLoginName";
                                        else
                                            _ColumnName = dt_FinalOutputTable.Columns[0].ColumnName;
                                        DataTable _DTcategory = new DataTable();
                                        if (dt_FinalOutputTable.Columns.Contains("LoginId"))
                                        {
                                             _DTcategory = dt_ExcelSheetDataForMU.Copy();
                                        }
                                        else
                                        {
                                             _DTcategory = dt_FinalOutputTable.Copy();
                                        }
                                        if (dt_FinalOutputTable.Columns.Contains("CategoryName"))
                                        dt_FinalOutputTable.Columns.Remove("CategoryName");
                                        DataTable _DT = dt_FinalOutputTable.Clone();                                        
                                       
                                        try
                                        {
                                            using (new System.Runtime.MemoryFailPoint(500)) // 20 megabytes
                                            {
                                                List<MassUploadResponseDTO> _ResponseList = new List<MassUploadResponseDTO>();

                                                //Checked for Kotak HRMS Integration
                                                if (s_Kotak_HRMS_Integration == 1)
                                                {
                                                    using (MassUploadDAL massUploadDAL = new MassUploadDAL())
                                                    {
                                                        massUploadDAL.ExecuteMassUploadCall(n_ExcelSheetDetailsID, dt_FinalOutputTable, string.Empty, "st_com_MassUploadCommonProcedureExecution", s_ConnectionString, out objResponseList, out s_ErrorMessageCode);
                                                        _ResponseList.Add(objResponseList.First());
                                                    }
                                                }
                                                else
                                                {
                                                    foreach (DataRow perRow in dt_FinalOutputTable.Rows)
                                                    {
                                                        Console.WriteLine("     " + " Processing for employee : " + perRow[_ColumnName].ToString());
                                                        _DT.Clear();
                                                        _DT.ImportRow(perRow);
                                                        using (MassUploadDAL massUploadDAL = new MassUploadDAL())
                                                        {
                                                            massUploadDAL.ExecuteMassUploadCall(n_ExcelSheetDetailsID, _DT, string.Empty, "st_com_MassUploadCommonProcedureExecution", s_ConnectionString, out objResponseList, out s_ErrorMessageCode);
                                                            _ResponseList.Add(objResponseList.First());

                                                        }
                                                    }
                                                }                                                
                                                objResponseList.Clear();
                                                objResponseList = _ResponseList;
                                            }
                                        }
                                        catch (InsufficientMemoryException ex)
                                        {
                                            Console.WriteLine("     " + " Unable to Process. Error Message : " + ex.Message.ToString());
                                        }
                                        finally
                                        {
                                            _DT.Dispose();
                                            CommonModel.d_EndDate = DateTime.Now.AddSeconds(50);
                                        }
                                        objResponseListHistory = n_IsPrimarySheet.Equals(1) ? objResponseList : objResponseListHistory;
                                        #endregion

                                        #region Update config in du_MappingTables and get latest Demat Account Number

                                        if (ds_DataFromExcelFile.Tables[n_Counter].TableName.Contains("OnGoingContDiscData_Esop") || ds_DataFromExcelFile.Tables[n_Counter].TableName.Contains("OnGoingContDiscData_Axis"))
                                        {
                                            Hashtable ht_Params = new Hashtable();
                                            DataTable dt_UpdatedDemat = new DataTable();

                                            //Update flag in du_MappingTables
                                            string s_UploadFor = ds_DataFromExcelFile.Tables[n_Counter].TableName.Contains("OnGoingContDiscData_Esop") ? "ESOPDIRECTFEED" : ds_DataFromExcelFile.Tables[n_Counter].TableName.Contains("OnGoingContDiscData_Axis") ? "AXISDIRECTFEED" : string.Empty;
                                            ht_Params.Add("@s_UploadFileFor", s_UploadFor);
                                            UpdateConfigurations("st_du_UpdateUploadDematFlag", ht_Params, "NonQuery");


                                            //Create csv file for new updated demat numbers
                                            ht_Params.Clear();
                                            ht_Params.Add("@FROM_DATE", CommonModel.d_StartDate);
                                            ht_Params.Add("@TO_DATE", CommonModel.d_EndDate);
                                            dt_UpdatedDemat = (DataTable)UpdateConfigurations("st_du_GetInsertedDematNumbers", ht_Params, "sqlAdapter");

                                            if (dt_UpdatedDemat != null && dt_UpdatedDemat.Rows.Count > 0)
                                            {
                                                File.WriteAllText(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\NewDematNumberUpdated.csv", WriteToCSV(dt_UpdatedDemat));

                                                if (!DataUploadedDetails.Keys.Contains("DematDetailsFile"))
                                                    DataUploadedDetails.Add("DematDetailsFile", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\NewDematNumberUpdated.csv");
                                            }
                                        }

                                        #endregion

                                        #region Update employee seperation
                                        if (dt_SeperationDetails.Columns.Contains("DateOfSeparation") && dt_SeperationDetails.Select("DateOfSeparation IS NOT NULL AND DateOfSeparation <>''").Count() > 0)
                                        {
                                            using (DataUploadUtilityDAL objDataUploadUtilityDAL = new DataUploadUtilityDAL())
                                            {
                                                dt_SeperationDetails.Columns["UserName"].ColumnName = "EmployeeId";
                                                objDataUploadUtilityDAL.SaveUserSeparation(s_ConnectionString, dt_SeperationDetails.Select("DateOfSeparation IS NOT NULL AND DateOfSeparation <>''").CopyToDataTable(), 1);
                                            }
                                        }
                                        #endregion

                                        /* Write to Log */
                                        WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_DataUploadingCompleted], s_CompanyName);

                                        #region Get error message
                                        bool b_IsErrorOccured = false;
                                        int lng_RowNumber = 0;

                                        dt_ExcelSheetDataForMU.TableName = dt_FinalOutputTable.TableName;
                                        string s_Prefix = string.Empty;
                                        foreach (MassUploadResponseDTO perMassUploadResponseDTO in objResponseList)
                                        {
                                            DataRow dr = dtErrorList.NewRow();
                                            dtErrorList.Rows.Add(dr);
                                            string Category = string.Empty;
                                            if (dt_FinalOutputTable.Columns.Contains("CategoryName"))
                                                Category = "CategoryName";
                                            else
                                                if (_DTcategory.Columns.Contains("CategoryName"))
                                                    Category = "CategoryName";
                                            else
                                                Category = "Category";
                                            if (!perMassUploadResponseDTO.ReturnValue.Equals(0))
                                            {
                                                s_Prefix = perMassUploadResponseDTO.ResourcePrefix;

                                                if (dictLstResources.ContainsKey(perMassUploadResponseDTO.ResourcePrefix + perMassUploadResponseDTO.ReturnValue))
                                                    s_Prefix = perMassUploadResponseDTO.ResourcePrefix;
                                                else if (dictLstResources.ContainsKey("dis_msg_" + perMassUploadResponseDTO.ReturnValue))
                                                    s_Prefix = "dis_msg_";
                                                else if (dictLstResources.ContainsKey("tra_msg_" + perMassUploadResponseDTO.ReturnValue))
                                                    s_Prefix = "tra_msg_";
                                               
                                                //if (dt_FinalOutputTable.Columns.Contains("CategoryName"))
                                                //    Category = "CategoryName";
                                                //else
                                                //    Category = "Category";
                                                WriteToConsole(("     " + (dictLstResources.ContainsKey(s_Prefix + perMassUploadResponseDTO.ReturnValue) ? dictLstResources[s_Prefix + perMassUploadResponseDTO.ReturnValue] : CommonModel.s_OperErrorMessage) + " for :" + _DTcategory.Rows[lng_RowNumber][Category] + " " + " Employee : " + (dt_FinalOutputTable.Columns.Contains("UserLoginName") ? dt_FinalOutputTable.Rows[lng_RowNumber]["UserLoginName"] : dt_FinalOutputTable.Rows[lng_RowNumber]["LoginId"])), s_CompanyName);

                                                if (dt_FinalOutputTable.Columns.Contains("UserLoginName"))
                                                {
                                                    dtErrorList.Rows[lng_RowNumber]["UserID"] = dt_FinalOutputTable.Rows[lng_RowNumber]["UserLoginName"].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Usercategory"] = _DTcategory.Rows[lng_RowNumber][Category].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Description"] = (dictLstResources.ContainsKey(s_Prefix + perMassUploadResponseDTO.ReturnValue) ? dictLstResources[s_Prefix + perMassUploadResponseDTO.ReturnValue] : CommonModel.s_OperErrorMessage);
                                                }
                                                if (dt_FinalOutputTable.Columns.Contains("LoginID"))
                                                {
                                                    dtErrorList.Rows[lng_RowNumber]["UserID"] = dt_FinalOutputTable.Rows[lng_RowNumber]["LoginID"].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Usercategory"] = _DTcategory.Rows[lng_RowNumber][Category].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Description"] = (dictLstResources.ContainsKey(s_Prefix + perMassUploadResponseDTO.ReturnValue) ? dictLstResources[s_Prefix + perMassUploadResponseDTO.ReturnValue] : CommonModel.s_OperErrorMessage);
                                                }
                                                b_IsErrorOccured = true;
                                            }
                                            else
                                            {
                                                if (dt_FinalOutputTable.Columns.Contains("UserLoginName"))
                                                    dt_ExcelSheetDataForMU.Rows.Remove(dt_ExcelSheetDataForMU.Select("UserLoginName='" + dt_FinalOutputTable.Rows[lng_RowNumber]["UserLoginName"] + "'")[0]);
                                                else
                                                    dt_ExcelSheetDataForMU.Rows.Remove(dt_ExcelSheetDataForMU.Select("LoginId='" + dt_FinalOutputTable.Rows[lng_RowNumber]["LoginId"] + "'")[0]);

                                                if (dt_FinalOutputTable.Columns.Contains("UserLoginName"))
                                                {
                                                    dtErrorList.Rows[lng_RowNumber]["UserID"] = dt_FinalOutputTable.Rows[lng_RowNumber]["UserLoginName"].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Usercategory"] = _DTcategory.Rows[lng_RowNumber][Category].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Description"] = "OK";
                                                }
                                                if (dt_FinalOutputTable.Columns.Contains("LoginID"))
                                                {
                                                    dtErrorList.Rows[lng_RowNumber]["UserID"] = dt_FinalOutputTable.Rows[lng_RowNumber]["LoginID"].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Usercategory"] = _DTcategory.Rows[lng_RowNumber][Category].ToString();
                                                    dtErrorList.Rows[lng_RowNumber]["Description"] = "OK";
                                                }

                                            }
                                            if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + s_FilePath))
                                                DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + s_FilePath, s_FilePath);
                                            lng_RowNumber++;
                                        }
                                        // To generate the log file in csv and excel
                                       

                                        if (dt_ExcelSheetDataForMU.TableName == "_OnGoingContinuousDisclosuretransactions")
                                        {
                                            dtErrorList.TableName = "AXISDIRECTFEED_Log";
                                        }
                                        else if (dt_ExcelSheetDataForMU.TableName == "ESOP_Vigilante_AllotData.CSV_OnGoingContinuousDisclosuretransactions")
                                        {
                                            dtErrorList.TableName = "ESOPDIRECTFEED_Log";
                                        }
                                        else if (perMassUploadExcelSheetId.Equals(1))
                                        {
                                            dtErrorList.TableName = "HRMS_Log";
                                        }
                                        else
                                        {
                                            dtErrorList.TableName = "Log";
                                        }

                                      
                                            WriteToConsole("     " + "Generating CSV for Log file started", s_CompanyName);
                                            File.WriteAllText(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".csv", WriteToCSV(dtErrorList));
                                            WriteToConsole("     " + "Generating CSV for Log file completed", s_CompanyName);

                                            if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString() + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".csv"))
                                                DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".csv", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".csv");
                                       

                                        //if (dt_ExcelSheetDataForMU.Rows.Count > 0 && !string.IsNullOrEmpty(s_FilePath))
                                        if (dt_ExcelSheetDataForMU.Rows.Count > 0)
                                        {
                                            try
                                            {
                                                if (dt_ExcelSheetDataForMU.Columns.Contains("Category"))
                                                dt_ExcelSheetDataForMU.Columns.Remove("Category");
                                                if (dt_ExcelSheetDataForMU.Columns.Contains("CategoryName"))
                                                    dt_ExcelSheetDataForMU.Columns.Remove("CategoryName");
                                               

                                                if (!perMassUploadExcelSheetId.Equals(1))
                                                {
                                                    WriteToConsole("     " + "Generating CSV file started", s_CompanyName);
                                                    foreach (DataColumn perColumn in dt_ExcelSheetDataForMU.Columns)
                                                    {
                                                        perColumn.ColumnName = HT_ColumnsListForContDisc[perColumn.ColumnName].ToString();
                                                    }

                                                    if (dt_ExcelSheetDataForMU.Columns.Contains("DematAccountNo"))
                                                    {
                                                        foreach (DataRow itemRow in dt_ExcelSheetDataForMU.Rows)
                                                        {
                                                            itemRow["DematAccountNo"] = Convert.ToString(itemRow["DematAccountNo"]).Split('|').First();
                                                        }
                                                        dt_ExcelSheetDataForMU.AcceptChanges();
                                                    }
                                                   

                                                    File.WriteAllText(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv", WriteToCSV(dt_ExcelSheetDataForMU));
                                                    //File.WriteAllText(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dtErrorList.TableName + ".csv", WriteToCSV(dtErrorList));
                                                    WriteToConsole("     " + "Generating CSV file completed", s_CompanyName);


                                                    // Type used to check Excel installed on system
                                                    Type officeType = Type.GetTypeFromProgID("Excel.Application");

                                                    if (officeType == null)
                                                    {
                                                        WriteToConsole("     " + "Office not installed on sysytem", s_CompanyName);

                                                        if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv"))
                                                            DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv");
                                                    }
                                                    else
                                                    {
                                                        WriteToConsole("     " + "Converting CSV to XLSX file started", s_CompanyName);

                                                        Microsoft.Office.Interop.Excel.Application application = new Microsoft.Office.Interop.Excel.Application();
                                                        Microsoft.Office.Interop.Excel.Workbook workbook = application.Workbooks.Open(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                                                       // Microsoft.Office.Interop.Excel.Workbook workbook1 = application.Workbooks.Open(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dtErrorList.TableName + ".csv", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                                                        try
                                                        {
                                                            //workbook.Sheets[1].Name = dt_ExcelSheetDataForMU.TableName.Contains("_OnGoingContinuousDisclosuretransactions") ? "OnGoingContDisc" : dt_ExcelSheetDataForMU.TableName;
                                                                                         

                                                            //if (File.Exists(Path.GetDirectoryName(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx"))
                                                            //    File.Delete(Path.GetDirectoryName(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx");
                                                            
                                                            DirectoryInfo di;
                                                            if (!Directory.Exists(Path.Combine(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy")))
                                                                di = Directory.CreateDirectory(Path.Combine(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy"));
                                                                                                                        
                                                            workbook.SaveAs(Path.GetDirectoryName(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx", Microsoft.Office.Interop.Excel.XlFileFormat.xlOpenXMLWorkbook, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlExclusive, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                                                           // workbook1.SaveAs(Path.GetDirectoryName(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString()) + @"\Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".xlsx", Microsoft.Office.Interop.Excel.XlFileFormat.xlOpenXMLWorkbook, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlExclusive, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                                                            
                                                            WriteToConsole("     " + "Converting CSV to XLSX file completed", s_CompanyName);
                                                            File.Delete(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".csv");

                                                        }
                                                        catch (Exception ex)
                                                        {
                                                            WriteToConsole("     " + "Error occured while generating excel file : " + ex.Message, s_CompanyName);
                                                        }
                                                        finally
                                                        {
                                                            workbook.Close();
                                                           // workbook1.Close();
                                                            application.Quit();
                                                        }

                                                        //if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx"))
                                                        //    DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx");
                                                        if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString() + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx"))
                                                            DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx");
                                                        //if (!DataUploadedDetails.Keys.Contains(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString() + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".xlsx"))
                                                          //  DataUploadedDetails.Add(n_ExcelSheetDetailsID + "_" + ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".xlsx", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"Processed\" + Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy") + @"\" + dtErrorList.TableName + ".xlsx");
                                                    }

                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                WriteToConsole("     - " + string.Format(CommonModel.s_ErrorMessage, ex.Message), s_CompanyName);
                                            }
                                            finally
                                            {
                                                #region close the Fiddler instance
                                                var processlist = Process.GetProcesses();
                                                foreach (var theprocess in
                                                    processlist.Where(theprocess => theprocess.ProcessName.ToUpper().Contains("EXCEL")))
                                                {
                                                    theprocess.Kill();
                                                    theprocess.CloseMainWindow();
                                                    theprocess.Dispose();
                                                    theprocess.Close();
                                                    break;
                                                }
                                                #endregion
                                                if (File.Exists(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx"))
                                                    File.Delete(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx");
                                               // File.Move(Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + @"\" + dt_ExcelSheetDataForMU.TableName + ".xlsx", ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\Processed\" + dt_ExcelSheetDataForMU.TableName + ".xlsx");
                                            }
                                        }

                                        if (b_IsErrorOccured)
                                        {
                                            WriteToConsole("     " + "#############################################################################################", s_CompanyName);
                                            WriteToConsole("     " + (dt_ExcelSheetDataForMU.Rows.Count.Equals(dt_FinalOutputTable.Rows.Count) ? "NO " : "PARTIAL ") + "DATA IS UPDATED IN THE SYSTEM.", s_CompanyName);
                                            WriteToConsole("     " + "You need to correct the data and RERUN only the CORRECTED DATA.", s_CompanyName);
                                            WriteToConsole("     " + "#############################################################################################", s_CompanyName);
                                        }


                                        #endregion
                                    }

                                }
                                else
                                {
                                    /* Write to Log */
                                    WriteToConsole("     " + "#############################################################################################", s_CompanyName);
                                    WriteToConsole("     " + "NO DATA IS UPDATED IN THE SYSTEM.", s_CompanyName);
                                    WriteToConsole("     " + "You need to correct the data and RERUN the complete file.", s_CompanyName);
                                    WriteToConsole("     " + "#############################################################################################", s_CompanyName);
                                }
                                sw_TimeTaken.Stop();

                                /* Write to Log */
                                WriteToConsole("     " + string.Format(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_TotalTimeTaken], TimeSpan.FromMilliseconds(sw_TimeTaken.ElapsedMilliseconds).TotalMinutes), s_CompanyName);
                            }
                            catch (Exception ex)
                            {
                                /* Write to Log */
                                WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorPrepareRowsAndUpload], s_CompanyName);
                                WriteToConsole("     " + string.Format(CommonModel.s_ErrorMessage, ex.Message), s_CompanyName);
                                WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorPrepareRowsAndUpload], s_CompanyName);

                                CommonModel.b_IsErrorOccured = true;
                            }

                        }
                        else
                        {
                            WriteToConsole("No records processed", string.Empty);
                        }
                        n_Counter++;
                        dt_FinalOutputTable.Rows.Clear();
                        dt_FinalOutputTable.Columns.Clear();
                        dt_ExcelSheetDataForMU.Rows.Clear();
                        dt_ExcelSheetDataForMU.Columns.Clear();
                        dt_FinalOutputTable.AcceptChanges();
                        dt_ExcelSheetDataForMU.AcceptChanges();
                        d_RequiredFieldDetails.Clear();
                        CommonModel.b_IsErrorOccured = false;

                    }
                }
            }
            catch (Exception ex)
            {
                /* Write to Log */
                WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorPrepareRowsAndUpload], s_CompanyName);
                WriteToConsole("     " + string.Format(CommonModel.s_ErrorMessage, ex.Message), s_CompanyName);
                WriteToConsole("     " + dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorPrepareRowsAndUpload], s_CompanyName);

                CommonModel.b_IsErrorOccured = true;
            }
        }

        /// <summary>
        /// This method is used to update configuration
        /// </summary>
        /// <param name="s_ProcedureName">ProcedureName</param>
        /// <param name="ht_Params">Parameters</param>
        private object UpdateConfigurations(string s_ProcedureName, Hashtable ht_Params, string s_ExecuteFor)
        {
            using (SqlConnection conn = new SqlConnection(s_ConnectionString))
            {
                try
                {
                    using (SqlCommand sqlcmd = new SqlCommand(s_ProcedureName, conn))
                    {
                        sqlcmd.CommandType = CommandType.StoredProcedure;
                        sqlcmd.CommandTimeout = 150000;

                        if (ht_Params.Count > 0)
                        {
                            foreach (var _param in ht_Params.Keys)
                            {
                                sqlcmd.Parameters.AddWithValue(_param.ToString(), ht_Params[_param]);
                            }
                        }

                        conn.Open();

                        switch (s_ExecuteFor)
                        {
                            case "NonQuery":
                                return sqlcmd.ExecuteNonQuery();

                            case "sqlAdapter":

                                using (DataTable dt_Output = new DataTable())
                                {
                                    using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlcmd))
                                    {
                                        sqlDataAdapter.Fill(dt_Output);
                                    }
                                    return dt_Output;
                                }
                        }
                    }
                }
                catch (Exception ex)
                {
                    WriteToConsole(ex.Message.ToString(), string.Empty);
                }
                finally
                {
                    conn.Close();
                }
                return new DataTable();
            }
        }

        /// <summary>
        /// This method is used to export datatable to csv
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public string WriteToCSV(DataTable table)
        {
            var result = new StringBuilder();
            for (int i = 0; i < table.Columns.Count; i++)
            {
                result.Append(table.Columns[i].ColumnName);
                result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
            }

            foreach (DataRow row in table.Rows)
            {
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    result.Append(row[i].ToString());
                    result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// This method is used to get seperation details of employee
        /// </summary>
        /// <param name="ds_DataFromExcelFile">Data from Excel sheet</param>
        /// <param name="dt_FinalOutputTable">Final output datatable</param>
        /// <param name="n_Counter">counter to select datatable</param>
        /// <param name="perMassUploadExcelSheetId">MassUploadExcelSheetId</param>
        /// <returns>DataTable</returns>
        private DataTable GetSeperationDetailsForEmployeeUpload(DataSet ds_DataFromExcelFile, DataTable dt_FinalOutputTable, int n_Counter, Int32 perMassUploadExcelSheetId)
        {
            if (perMassUploadExcelSheetId.Equals(1))
            {
                DataView dv_EmployeeSeperationCol = new DataView(dt_FinalOutputTable);
                using (DataTable dt = dv_EmployeeSeperationCol.ToTable("dt", false, new string[] { "UserName", "DateOfSeparation", "ReasonForSeparation", "NoOfDaysToBeActive" }).Copy())
                {
                    if (dt_FinalOutputTable.Columns.Contains("DateOfSeparation"))
                        dt_FinalOutputTable.Columns.Remove("DateOfSeparation");

                    if (dt_FinalOutputTable.Columns.Contains("ReasonForSeparation"))
                        dt_FinalOutputTable.Columns.Remove("ReasonForSeparation");

                    if (dt_FinalOutputTable.Columns.Contains("NoOfDaysToBeActive"))
                        dt_FinalOutputTable.Columns.Remove("NoOfDaysToBeActive");

                    return dt;
                }
            }
            return new DataTable();
        }

        /* this method is used to create com code if code not exists in database */
        /// <summary>
        /// This method is used to add values in ComCode table
        /// </summary>
        /// <param name="s_FieldName">string: actual field name</param>
        /// <param name="s_FieldValue">string: field value</param>
        /// <param name="m_objCodesNameWiseDisct">Dictionary: CodesNameWiseDisct</param>
        /// <returns>com code</returns>
        private int? AddKeyToComCode(string s_FieldName, string s_FieldValue, Dictionary<string, int> m_objCodesNameWiseDisct)
        {
            try
            {
                ComCodeSL objComCodeSL = new ComCodeSL();
                {
                    ComCodeDTO objComCodeDTO = new ComCodeDTO();
                    if (s_FieldName == "Category" && s_FieldValue == "Designated Employee")
                    {
                        objComCodeDTO.CodeID = 112007;
                    }
                    else if (s_FieldName == "Category" && s_FieldValue == "Non Designated Employee")
                    {
                        objComCodeDTO.CodeID = 112008;
                    }
                    else
                    {
                        objComCodeDTO.CodeID = 0;
                    }
                    objComCodeDTO.CodeName = s_FieldValue;
                    objComCodeDTO.Description = s_FieldValue;
                    objComCodeDTO.DisplayCode = s_FieldValue;
                    objComCodeDTO.IsActive = true;
                    objComCodeDTO.IsVisible = true;
                    objComCodeDTO.LoggedInUserId = 1;

                    switch (s_FieldName)
                    {
                        case "DepartmentId":
                            objComCodeDTO.CodeGroupId = "110";
                            objComCodeDTO = objComCodeSL.Save(s_ConnectionString, objComCodeDTO);
                            m_objCodesNameWiseDisct.Add(objComCodeDTO.CodeName.ToLower() + "_110", Convert.ToInt32(objComCodeDTO.CodeID));
                            break;

                        case "DesignationId":
                            objComCodeDTO.CodeGroupId = "109";
                            objComCodeDTO = objComCodeSL.Save(s_ConnectionString, objComCodeDTO);
                            m_objCodesNameWiseDisct.Add(objComCodeDTO.CodeName.ToLower() + "_109", Convert.ToInt32(objComCodeDTO.CodeID));
                            break;
                    }
                    return objComCodeDTO.CodeID;
                }
            }
            catch
            {

            }
            return 0;
        }

        /// <summary>
        /// This method is used to check field is required or not
        /// </summary>
        /// <param name="perRow">DataRow: actula datatable row(from excel)</param>
        /// <param name="perMappingFieldsDTO">Mapping details list</param>
        /// <param name="d_ReqFieldDetails">Dictionary collection for Missing Fields</param>
        /// <param name="dt_ActualTable">DataTable: Actual datatable</param>
        /// <returns>bool</returns>
        private bool CheckFieldIsRequired(DataRow perRow, MappingFieldsDTO perMappingFieldsDTO, ref Dictionary<string, string> d_ReqFieldDetails, DataTable dt_ActualTable)
        {
            try
            {
                if (perRow.Table.Columns.Contains("LoginID") && perRow.Table.Columns.Contains("TRD_QTY"))
                {
                    if (perMappingFieldsDTO.ActualFieldIsRequired && !dt_ActualTable.Columns.Contains(perMappingFieldsDTO.DisplayFieldName) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName)))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                    if (perMappingFieldsDTO.ActualFieldIsRequired && string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName)) && !perMappingFieldsDTO.DisplayFieldName.Equals("CompanyName"))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["TRD_QTY"]), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                }
                else if (perRow.Table.Columns.Contains("LoginID") && perRow.Table.Columns.Contains("OptionsExercised"))
                {
                    if (perMappingFieldsDTO.ActualFieldIsRequired && !dt_ActualTable.Columns.Contains(perMappingFieldsDTO.DisplayFieldName) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName)))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                    if (perMappingFieldsDTO.ActualFieldIsRequired && string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName)) && !perMappingFieldsDTO.DisplayFieldName.Equals("CompanyName"))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Employee : " + Convert.ToString(perRow["LoginID"]) + ", DEMAT Number: " + Convert.ToString(perRow["DEMATAccountNo"]) + ", Quantity: " + Convert.ToString(perRow["OptionsExercised"]), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                }
                else
                {
                    if (perMappingFieldsDTO.ActualFieldIsRequired && !dt_ActualTable.Columns.Contains(perMappingFieldsDTO.DisplayFieldName) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName)))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                    if (perMappingFieldsDTO.ActualFieldIsRequired && string.IsNullOrEmpty(Convert.ToString(perRow[perMappingFieldsDTO.DisplayFieldName])) && !d_ReqFieldDetails.Keys.Contains(string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName)) && !perMappingFieldsDTO.DisplayFieldName.Equals("CompanyName"))
                    {
                        CommonModel.sbString.AppendLine("     " + string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName));
                        d_ReqFieldDetails.Add(string.Format(CommonModel.s_FieldCannotBlank + " For Row Number : " + Convert.ToString(n_RowNumber), perMappingFieldsDTO.DisplayFieldName), Convert.ToString(perMappingFieldsDTO.ActualFieldIsRequired));
                        CommonModel.b_IsErrorOccured = true;
                        return false;
                    }
                }
                return true;
            }
            catch (Exception)
            {

                throw;
            }
        }
        #endregion

        #region Create columns for datatable
        /// <summary>
        /// This method is used to create columns for DataTable
        /// </summary>
        /// <param name="objMappingFieldsDTO">List: List of MappingFieldsDTO</param>
        /// <param name="dt_FinalOutputTable">DataTable: FinalOutputTable</param>
        private void CreateColumns(List<MappingFieldsDTO> objMappingFieldsDTO, DataTable dt_FinalOutputTable, DataTable dt_ExcelSheetDataForMU)
        {
            DataColumnCollection dataColumnCollection;
            try
            {
                foreach (MappingFieldsDTO item in objMappingFieldsDTO)
                {
                    dataColumnCollection = dt_FinalOutputTable.Columns;
                    if (!dataColumnCollection.Contains(item.ActualFieldName))
                    {
                        switch (item.ActualFieldDataType.ToUpper())
                        {
                            case "INT":
                                dt_FinalOutputTable.Columns.Add(item.ActualFieldName, typeof(Int64));
                                dt_ExcelSheetDataForMU.Columns.Add(item.ActualFieldName, typeof(string));
                                break;

                            case "BIGINT":
                                dt_FinalOutputTable.Columns.Add(item.ActualFieldName, typeof(Int64));
                                dt_ExcelSheetDataForMU.Columns.Add(item.ActualFieldName, typeof(Int64));
                                break;

                            case "STRING":
                                dt_FinalOutputTable.Columns.Add(item.ActualFieldName, typeof(string));
                                dt_ExcelSheetDataForMU.Columns.Add(item.ActualFieldName, typeof(string));
                                break;

                            case "DECIMAL":
                                dt_FinalOutputTable.Columns.Add(item.ActualFieldName, typeof(decimal));
                                dt_ExcelSheetDataForMU.Columns.Add(item.ActualFieldName, typeof(decimal));
                                break;

                            case "DATETIME":
                                dt_FinalOutputTable.Columns.Add(item.ActualFieldName, typeof(DateTime));
                                dt_ExcelSheetDataForMU.Columns.Add(item.ActualFieldName, typeof(DateTime));
                                break;
                        }
                        dt_FinalOutputTable.Columns[item.ActualFieldName].DefaultValue = DBNull.Value;
                        dt_ExcelSheetDataForMU.Columns[item.ActualFieldName].DefaultValue = DBNull.Value;
                    }
                }
            }
            catch (Exception ex)
            {
                WriteToConsole(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_ErrorPrepareColumns], string.Empty);
                WriteToConsole(string.Format(CommonModel.s_ErrorMessage, ex.Message), string.Empty);
                CommonModel.b_IsErrorOccured = true;
            }
        }
        #endregion

        #region FetchAllRoleNames
        /// <summary>
        /// This method will be used for fetching Implementing company Name
        /// </summary>
        /// <returns>string</returns>
        public string GetImplementingCompany(string s_ConnectionString)
        {
            try
            {
                using (DataUploadUtilityDAL dataUploadUtilityDAL = new DataUploadUtilityDAL())
                {
                    List<ImplementingCompanyDetails> implementedCompanyDTO = dataUploadUtilityDAL.GetImplementingCompany(s_ConnectionString);
                    foreach (ImplementingCompanyDetails perCompanyName in implementedCompanyDTO)
                    {
                        return perCompanyName.CompanyName;
                    }
                }
            }
            catch
            {

            }
            return string.Empty;
        }
        #endregion FetchAllRoleNames

        #region FetchAllRoleNames
        /// <summary>
        /// This method will be used for fetching all the Role names from usr_RoleMaster table and maintain the list of RolesDTO and a dictionary containing the collection
        /// of RoleName against the RoleId. This will be used for converting the role name values as added in the excel to role id as to be saved in the table.
        /// </summary>
        /// 
        public void FetchAllRoleNames(string s_ConnectionString)
        {
            try
            {
                using (MassUploadDAL m_objMassUploadDAL = new MassUploadDAL())
                {
                    List<RolesDTO> m_objRolesDTOList = m_objMassUploadDAL.GetAllRoles(s_ConnectionString);
                    foreach (RolesDTO objRoleNameDTO in m_objRolesDTOList)
                    {
                        m_objRolesNameWiseDisct.Add((objRoleNameDTO.RoleName).ToLower(), objRoleNameDTO.RoleId);
                    }
                }
            }
            catch
            {

            }
        }
        #endregion FetchAllRoleNames

        #region FetchAllCompanyNames
        /// <summary>
        /// This method will be used for fetching all the company names from mst_company table and maintain the list of CompanynameDTO and a dictionary containing the collection
        /// of CompanyName against the CompanyId. This will be used for cnverting the company name values as added in the excel to company id as to be saved in the table.
        /// </summary>
        public void FetchAllCompanyNames(string s_ConnectionString)
        {
            try
            {
                using (MassUploadDAL m_objMassUploadDAL = new MassUploadDAL())
                {
                    List<CompanyNamesDTO> m_objCompanyNamesDTOList = m_objMassUploadDAL.GetAllCompanyNames(s_ConnectionString);
                    foreach (CompanyNamesDTO objCompanyNameDTO in m_objCompanyNamesDTOList)
                    {
                        m_objCompanyNamesDisct.Add((objCompanyNameDTO.CompanyName.ToLower()), objCompanyNameDTO.CompanyId);
                    }
                }
            }
            catch
            {

            }
        }
        #endregion FetchAllCompanyNames

        #region Send Email
        /// <summary>
        /// This method is used to send email
        /// </summary>
        /// <param name="s_CompanyName">string: CompanyName</param>
        /// <param name="s_Attachment">List: AttachmentFilePath</param>
        internal void SendEmail(string s_CompanyName, List<string> s_Attachment)
        {
            try
            {
                using (EmailProperties emailProperties = new EmailProperties())
                {
                    emailProperties.s_MailTo = ConfigurationManager.AppSettings["MailTo"];
                    emailProperties.s_MailFrom = ConfigurationManager.AppSettings["MailFrom"];
                    emailProperties.s_MailCC = ConfigurationManager.AppSettings["MailCC"];
                    emailProperties.s_MailBCC = ConfigurationManager.AppSettings["MailBCC"];
                    emailProperties.b_IsBodyHtml = true;

                    s_SendMailWithAttachment = Convert.ToString(ConfigurationManager.AppSettings["SendMailWithAttachment"]);

                    if (s_SendMailWithAttachment.Equals("1"))
                    {
                        long AttachmentSize = 0;
                        foreach (string AttachmentPath in s_Attachment)
                        {
                            FileInfo fileInfo = new FileInfo(AttachmentPath);
                            AttachmentSize += fileInfo.Length;
                        }

                        if (AttachmentSize <= 4194304)                              // Attachment size is not more than 4 MB.
                            emailProperties.Attachments = s_Attachment;
                    }

                    emailProperties.s_MailSubject = string.Format(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_UploadedSuccessfully], s_CompanyName);
                    emailProperties.s_MailBody = ReplaceParameters(dictLstResources[CommonModel.s_LookUpPrefix + CommonModel.s_ResID_GetEmail], s_CompanyName);

                    SendMail.Instance().SendMailAlerts(s_CompanyName, emailProperties);
                }
            }
            catch (Exception ex)
            {
                File.WriteAllText(ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString().Equals(".") ? Path.GetDirectoryName(Assembly.GetEntryAssembly().Location) + "\\" : ConfigurationManager.AppSettings["WriteToFileLogPath"].ToString() + @"\LogFile\" + DateTime.Now.ToString("ddMMMyyyy") + "_ErrorLog.txt", "Error occured: " + ex.Message.ToString());
            }

        }

        /// <summary>
        /// This method is used to replace email parameters in email body
        /// </summary>
        /// <param name="s_MailBody">string: mail body</param>
        /// <param name="s_CompanyName">string: company name</param>
        /// <returns>string</returns>
        private string ReplaceParameters(string s_MailBody, string s_CompanyName)
        {
            StringBuilder sb_MailBody = new StringBuilder(s_MailBody);
            sb_MailBody.Replace("@Company_Name", s_CompanyName);
            sb_MailBody.Replace("@SupportMail", ConfigurationManager.AppSettings["SupportMail"]);
            return sb_MailBody.ToString();
        }

        /// <summary>
        /// This method is used to get attachment path in list
        /// </summary>
        /// <param name="s_Attachment">List: Attachment path</param>
        internal void GetAttachmentPath(out List<string> s_Attachment)
        {
            s_Attachment = new List<string>();
            foreach (KeyValuePair<string, string> perDictionaryItem in DataUploadedDetails.Where(c => c.Value != null))
            {
                s_Attachment.Add(perDictionaryItem.Value);
            }
            s_Attachment.Add(ConfigurationManager.AppSettings["WriteToFileLogPath"] + @"\LogFile\" + (CommonModel.HT_Modules.Count.Equals(4) ? string.Empty : Convert.ToString(CommonModel.HT_Modules.Values.OfType<string>().First()) + "_") + DateTime.Now.ToString("ddMMMyyyy") + "_Log.txt");
        }
        #endregion

        #region Write to console and log  file
        /// <summary>
        /// This method is used to write log to console as well as to log file
        /// </summary>
        /// <param name="s_Message">string: message</param>
        /// <param name="s_CompanyName">string Company Name</param>
        private void WriteToConsole(string s_Message, string s_CompanyName)
        {            
            if (b_IsWriteToConsole.Equals("Y"))
            {
                Console.Write(s_Message + "\n");
            }
            CommonModel.sbString.AppendLine(string.Format(s_Message, s_CompanyName));
        }
        #endregion

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
