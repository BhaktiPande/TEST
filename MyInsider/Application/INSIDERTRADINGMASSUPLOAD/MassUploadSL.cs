using InsiderTradingDAL;
using InsiderTradingExcelWriter.ExcelFacade;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace InsiderTradingMassUpload
{

    /// <summary>
    /// This emumerator contains the Excel column names
    /// </summary>
    enum EXCELColumnNumber
    {
        A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, AA, AB, AC, AD, AE, AF
    }
    /// <summary>
    /// This enumn is used for specifying which type of validation to be performed for
    /// </summary>
    enum ValidationTypes
    {
        REQUIREDVALIDATION,
        REGULAREXPRESSIONVALIDATION,
        MAXLENGTHVALIDATION,
        MINLENGTHVALIDATION,
        COMPANYVALIDATION,
        ROLEVALIDATION,
        MASTERCODEVALIDATION,
        DEPENDENTCOLUMN,
        DEPENDENTCOLUMNVALUE
    }

    enum MASSUPLOADEXCELSHEET
    {
        EMPLOYEEINSIDER = 1,
        NONEMPLOYEEINSIDER = 2,
        CORPORATEINSIDER = 3,
        EMPLOYEEINSIDER_RELATIVES = 4,
        NONEMPLOYEEINSIDER_RELATIVES = 5,
        EMPLOYEEINSIDER_DEMAT = 6,
        NONEMPLOYEEINSIDER_DEMAT = 7,
        CORPORATEINSIDER_DEMAT = 8,
        EMPLOYEEINSIDER_RELATIVES_DEMAT = 9,
        NONEMPLOYEEINSIDER_RELATIVES_DEMAT = 10,
        INITIALDISCLOSURE = 11,
        PASTPRECLEARANCE = 12,
        PASTTRANSACTION = 13,
        ONGOINGTRANSACTIONS = 14
    }
    /// <summary>
    /// This class will be used for performing the Mass upload activity for given Mass Upload Type.
    /// This class will have methods to fetch the configuration information for Mass Upload of the data
    /// from Excel file and insert in corresponding tables using Procedure calls as configured.
    /// </summary>
    public class MassUploadSL : IDisposable
    {
        #region Member Variables


        private string[] m_sExcelColumnNames = new string[] { "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
        private string ERROR_EXCEL_COLUMN1_HEADER = "Row Number(Sequence Number)";
        private string ERROR_EXCEL_COLUMN2_HEADER = "Column Header(Column Name)";
        private string ERROR_EXCEL_COLUMN3_HEADER = "Error Message";
        private const string MASSUPLOAD_ERROR_EXCEL_SHEET_NAME = "MassUploadErrors";

        private string m_sUploadedFileGUID;
        private bool m_bErrorPresentInExcelSheets = false;
        private int m_nMassUploadId;
        private string m_sConnectionString;
        private string m_sExcelFileFullPath;
        private string m_sCurrentCompanyDBName;
        private string m_sEncryptionSaltValue;
        private int m_nLoggedInUserID;



        private MassUploadExcel m_objMassUploadExcel;
        private MassUploadExcelSheets m_objMassUploadExcelSheets;

        private List<CodesDTO> m_objCodesDTOList;
        Dictionary<string, int> m_objCodesNameWiseDisct;
        private List<CompanyNamesDTO> m_objCompanyNamesDTOList;
        Dictionary<string, int> m_objCompanyNamesDisct;
        private List<RolesDTO> m_objRolesDTOList;
        Dictionary<string, int> m_objRolesNameWiseDisct;

        private List<MassUploadExcelSheets> m_lstMassUploadSheets;

        private Dictionary<string, string> m_objSheetRelatedColumnMapping;
        private Dictionary<string, Dictionary<string, List<string>>> m_objExcelData =
            new Dictionary<string, Dictionary<string, List<string>>>();
        private Dictionary<string, MassUploadExcelSheets> m_objMassUploadExcelSheetList;
        private Dictionary<string, MassUploadExcelSheets> m_objMassUploadExcelResponseSheetList;

        private Dictionary<string, List<MassUploadExcelSheetErrors>> m_nExcelsheetUIValidationsErrors = new Dictionary<string, List<MassUploadExcelSheetErrors>>();

        private Dictionary<string, string> m_lstResourcesList = new Dictionary<string, string>();

        private Dictionary<string, List<int>> m_lstSheetWiseDateColumnNumbers = new Dictionary<string, List<int>>();
        #region To be used for UI validations

        /// <summary>
        /// This will contain all the data from all the excel sheets which are configured in the system
        /// </summary>
        private Dictionary<string, List<List<string>>> m_objExcelSheetWiseData = new Dictionary<string, List<List<string>>>();

        /// <summary>
        /// This will contain the sheet wise column names, these will be used for showing the error column name in the error report.
        /// </summary>
        private Dictionary<string, List<string>> m_objSheetWiseColumnsNames = new Dictionary<string, List<string>>();

        /// <summary>
        /// This will contain the sheet wise list of columns which are required mandatorily without which the data will not be imported
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseRequiredColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();
        /// <summary>
        /// This will contain the sheet wise columns which require regular expression check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseRegExpression = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();
        /// <summary>
        /// This will contain sheet wise column which require max length check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseMaxLengthColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();
        /// <summary>
        /// This will contain sheet wise column which require min length check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseMinLengthColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();

        /// <summary>
        /// This will contain sheet wise column which require company validation check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseCompanyColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();

        /// <summary>
        /// This will contain sheet wise column which require role validation check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseRoleColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();

        /// <summary>
        /// This will contain sheet wise column which require master code validation check
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseMasterCodeColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();

        /// <summary>
        /// This will contain sheet wise column which are dependent on other columns data
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseDependentColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();

        /// <summary>
        /// This will contain sheet wise column which requirement is dependent on other columns selective value
        /// </summary>
        private Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>> m_objSheetWiseDependentValueColumns = new Dictionary<string, Dictionary<int, MassUploadExcelDataTableColumnMapping>>();


        #endregion To be used for UI validations

        /// <summary>
        /// This will contain the parent row number which have been removed because of error. When copying the dependent data from parent sheet this
        /// list will be used to eleminate the corresponding child sheet records also.
        /// </summary>
        private Dictionary<string, List<int>> m_objMassUploadExcelSheetRemovedRowsList;
        /// <summary>
        /// This collection will contain the sheet wise errors occurred
        /// </summary>
        Dictionary<string, List<MassUploadResponseDTO>> m_objSheetWiseError = new Dictionary<string, List<MassUploadResponseDTO>>();

        /// <summary>
        /// This flage will have value true if non of the sheets from the excel are valid and so the excel cannot be imported.
        /// </summary>
        private bool m_bInvalidExcelSheets = false;

        #endregion Member Variables

        #region GetAllResourcesForCompany
        /// <summary>
        /// This function will give a call to the ResourceDAL for fetching al lthe resources for the given company.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="o_lstResources"></param>
        public void GetAllResourcesForCompany()
        {
            //InsiderTradingDAL.ResourcesDAL objResourcesDAL = new ResourcesDAL();
            try
            {
                using (var objResourcesDAL = new ResourcesDAL())
                {
                    objResourcesDAL.GetAllResources(m_sConnectionString, out m_lstResourcesList);
                }
            }
            catch (Exception exp)
            {

            }
        }
        #endregion 

        #region Get Resource Message
        /// <summary>
        /// This function is used for fetching the resource message, for given resource key, from the contect collection.
        /// This function will fetch the company for the login user from the session and based on the company will fetch 
        /// the resource from corresponding company database. If resource is not found then it returns empty string.
        /// The resource string can be only the resource code whthout the code or else with the prefix for the code.
        /// </summary>
        /// <param name="i_sResourceKey"></param>
        /// <returns></returns>
        private string getResource(string i_sResourceKey)
        {
            string sResourceMessage = "";
            string sOriginalResourceKey = i_sResourceKey;
            try
            {
                if (i_sResourceKey != null)
                {
                    if (i_sResourceKey.Contains("_"))
                        i_sResourceKey = i_sResourceKey.Substring(i_sResourceKey.LastIndexOf("_") + 1);
                    if (m_lstResourcesList != null)
                    {
                        if (m_lstResourcesList.Any(kvp => kvp.Key.Contains(i_sResourceKey)))
                        {
                            Dictionary<string, string> objSelectedDict = m_lstResourcesList.Where(kvp => kvp.Key.Contains(i_sResourceKey)).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
                            List<string> lstValue = objSelectedDict.Values.ToList();
                            sResourceMessage = lstValue[0];
                        }
                        else
                        {
                            sResourceMessage = "";
                            //throw new Exception("Resource not available for company " + sCompanyName + " for resource key " + i_sResourceKey);
                        }

                    }
                }
            }
            catch (Exception exp)
            {
                // throw exp;
            }
            return sResourceMessage;
        }
        #endregion Get Resource Message


        #region Variables for Excel Reading
        //System.Data.OleDb.OleDbConnection objOledbConnection = null;
        //System.Data.DataSet dtDataSet;
        //System.Data.DataSet dtDataSetHeader;
        //System.Data.OleDb.OleDbDataAdapter objCommand;
        #endregion Variables for Excel Reading

        #region MassUploadSL Constructor

        /// <summary>
        /// Contructor for the MassUpload for initializing the objects and variables
        /// </summary>
        /// <param name="i_nMassUploadId"></param>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sExcelFileFullPath"></param>
        public MassUploadSL(int i_nMassUploadId, string i_sConnectionString, string i_sCompanyDBName, int i_nLoggedInUserID)
        {
            m_objMassUploadExcel = new MassUploadExcel();
            m_objMassUploadExcelSheets = new MassUploadExcelSheets();
            m_objMassUploadExcelSheetList = new Dictionary<string, MassUploadExcelSheets>();
            m_nMassUploadId = i_nMassUploadId;
            m_sConnectionString = i_sConnectionString;
            m_nLoggedInUserID = i_nLoggedInUserID;
            m_lstMassUploadSheets = new List<MassUploadExcelSheets>();
            m_objSheetRelatedColumnMapping = new Dictionary<string, string>();
            m_objMassUploadExcelResponseSheetList = new Dictionary<string, MassUploadExcelSheets>();
            m_objMassUploadExcelSheetRemovedRowsList = new Dictionary<string, List<int>>();
            m_objCodesDTOList = new List<CodesDTO>();
            m_objCodesNameWiseDisct = new Dictionary<string, int>();
            m_objCompanyNamesDTOList = new List<CompanyNamesDTO>();
            m_objCompanyNamesDisct = new Dictionary<string, int>();
            m_objRolesDTOList = new List<RolesDTO>();
            m_objRolesNameWiseDisct = new Dictionary<string, int>();
            m_objSheetWiseError = new Dictionary<string, List<MassUploadResponseDTO>>();
            m_bErrorPresentInExcelSheets = false;
            m_sCurrentCompanyDBName = i_sCompanyDBName;
        }


        /// <summary>
        /// Contructor for the MassUpload for initializing the objects and variables
        /// </summary>
        /// <param name="i_nMassUploadId"></param>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sExcelFileFullPath"></param>
        public MassUploadSL(int i_nMassUploadId, string i_sConnectionString, string i_sExcelFileFullPath, string i_sCompanyDBName, int i_nLoggedInUserID)
        {
            m_objMassUploadExcel = new MassUploadExcel();
            m_objMassUploadExcelSheets = new MassUploadExcelSheets();
            m_objMassUploadExcelSheetList = new Dictionary<string, MassUploadExcelSheets>();
            m_nMassUploadId = i_nMassUploadId;
            m_sConnectionString = i_sConnectionString;
            m_sExcelFileFullPath = i_sExcelFileFullPath;
            m_nLoggedInUserID = i_nLoggedInUserID;
            m_lstMassUploadSheets = new List<MassUploadExcelSheets>();
            m_objSheetRelatedColumnMapping = new Dictionary<string, string>();
            m_objMassUploadExcelResponseSheetList = new Dictionary<string, MassUploadExcelSheets>();
            m_objMassUploadExcelSheetRemovedRowsList = new Dictionary<string, List<int>>();
            m_objCodesDTOList = new List<CodesDTO>();
            m_objCodesNameWiseDisct = new Dictionary<string, int>();
            m_objCompanyNamesDTOList = new List<CompanyNamesDTO>();
            m_objCompanyNamesDisct = new Dictionary<string, int>();
            m_objRolesDTOList = new List<RolesDTO>();
            m_objRolesNameWiseDisct = new Dictionary<string, int>();
            m_objSheetWiseError = new Dictionary<string, List<MassUploadResponseDTO>>();
            m_bErrorPresentInExcelSheets = false;
            m_sCurrentCompanyDBName = i_sCompanyDBName;
        }

        /// <summary>
        /// Empty constructor
        /// </summary>
        public MassUploadSL()
        {
            //m_objMassUploadDAL = new MassUploadDAL();
        }

        #endregion MassUploadSL Constructor

        #region SetEncryptionSaltValue
        /// <summary>
        /// This will set the enctyption salt value to be used when generating the encryption string to be used for first time password change when new user is 
        /// created.
        /// </summary>
        /// <param name="i_sEncryptionSaltValue"></param>
        public void SetEncryptionSaltValue(string i_sEncryptionSaltValue)
        {
            m_sEncryptionSaltValue = i_sEncryptionSaltValue;
        }
        #endregion 

        #region ReadDataFrom Excel File
        #region ReadExcelFileIntoCollection
        /// <summary>
        /// Based on the type of file call corresponding method for reading the data from the excel file and add it in the collection to be used further 
        /// for validating and adding data to database.
        /// </summary>
        public void ReadExcelFileIntoCollection()
        {
            string fileExtenshion = Path.GetExtension(m_sExcelFileFullPath);
            if (fileExtenshion == ".xlsx")
            {
                ReadXLSXFileIntoCollection();

            }
            else if (fileExtenshion == ".xls")
            {
                ReadXLSFileIntoCollection();
            }
        }
        #endregion ReadExcelFileIntoCollection

        #region ReadXLSFileIntoCollection
        /// <summary>
        /// This function will be used for reading all the sheets data from the uploaded excel and save it in the collection 
        /// m_objExcelSheetWiseData for to be used for validating and importing the data to Database.
        /// This functipon will read the XLS file.
        /// </summary>
        /// 
        public void ReadXLSFileIntoCollection()
        {
            #region Variables for Excel Reading
            System.Data.OleDb.OleDbConnection objOledbConnection = null;
            System.Data.DataSet dtDataSet;
            System.Data.OleDb.OleDbDataAdapter objCommand;
            #endregion Variables for Excel Reading
            List<string> lstSheetnames = new List<string>();
            List<List<string>> lstRows = new List<List<string>>();
            List<string> lstColumns = new List<string>();
            List<string> lstColumnHeaders = new List<string>();
            try
            {
                objOledbConnection =
                        new System.Data.OleDb.OleDbConnection("provider=Microsoft.Jet.OLEDB.4.0;Data Source='" + m_sExcelFileFullPath + "';Extended Properties=\"Excel 4.0;HDR=YES;\"");
                objOledbConnection.Open();
                lstSheetnames = m_objMassUploadExcelSheetList.Keys.ToList<string>();
                foreach (string sSheetName in lstSheetnames)
                {
                    DataTable objSheetNames = objOledbConnection.GetOleDbSchemaTable(System.Data.OleDb.OleDbSchemaGuid.Tables, null);
                    bool o_bSheetPresent = CheckSheetPresent(objSheetNames, sSheetName);
                    if (o_bSheetPresent)
                    {
                        objCommand = new System.Data.OleDb.OleDbDataAdapter("select * from [" + sSheetName + "$]", objOledbConnection);
                        DataTable objDataTable = new DataTable();
                        dtDataSet = new System.Data.DataSet();
                        objCommand.Fill(objDataTable);
                        if (m_nMassUploadId == 56 && sSheetName == "CompanyDetails")
                        {
                            DataColumn newColumn = new DataColumn("MassCounter", typeof(int));
                            newColumn.DefaultValue = Convert.ToString(GetMassCounter(m_sConnectionString));
                            objDataTable.Columns.Add(newColumn);
                        }
                        o_bSheetPresent = true;
                        lstColumnHeaders = new List<string>();
                        for (int nColumnCounter = 0; nColumnCounter < objDataTable.Columns.Count; nColumnCounter++)
                        {
                            string sColumnName = Convert.ToString(objDataTable.Columns[nColumnCounter]).Trim();
                            lstColumnHeaders.Add(sColumnName);
                        }
                        m_objSheetWiseColumnsNames[sSheetName] = lstColumnHeaders;
                        lstRows = new List<List<string>>();
                        foreach (DataRow drRecordRow in objDataTable.Rows)
                        {
                            lstColumns = new List<string>();

                            foreach (DataColumn drRecordColumn in drRecordRow.Table.Columns)
                            {
                                lstColumns.Add(Convert.ToString(drRecordRow[drRecordColumn.Ordinal]).Trim());
                            }

                            lstRows.Add(lstColumns);
                        }
                        m_objExcelSheetWiseData[sSheetName] = lstRows;
                        objDataTable = null;
                        dtDataSet = null;
                        objCommand = null;
                    }
                }
                objOledbConnection.Close();
            }
            catch (Exception exp)
            {

            }
        }
        #endregion ReadXLSFileIntoCollection

        #region ReadXLSXFileIntoCollection
        /// <summary>
        /// This function will be used for reading all the sheets data from the uploaded excel and save it in the collection 
        /// m_objExcelSheetWiseData for to be used for validating and importing the data to Database.
        /// This functipon will read the XLSX file.
        /// </summary>
        public void ReadXLSXFileIntoCollection()
        {
            //Open spreadsheet document
            CommonOpenXML.OpenFile(m_sExcelFileFullPath, false);

            List<string> lstSheetnames = m_objMassUploadExcelSheetList.Keys.ToList<string>();

            try
            {

                foreach (string sSheetName in lstSheetnames)
                {
                    //int nEmptyRowLimit = 4;
                    //int nEmptyRows = 0;
                    List<int> lstDateColumnNumbers = m_lstSheetWiseDateColumnNumbers[sSheetName];
                    int nActualRowIndex = 0;
                    int m_nDataStartRow = 1;
                    int nActualColumnIndex = 0;
                    int nColumnCount = m_objMassUploadExcelSheetList[sSheetName].ColumnCount;
                    string sValue = "";
                    List<List<string>> lstRows = new List<List<string>>();
                    // Get first sheet data from SpearSheet document.
                    CommonOpenXML.GetWorkbookSheetDataObject(sSheetName);
                    lstRows = new List<List<string>>();
                    if (CommonOpenXML.TotalRows == 0)
                    {
                        continue;
                    }

                    // read rows from sheetdata
                    for (int nRow = 0; (nRow < CommonOpenXML.TotalRows)/* && (nEmptyRows != nEmptyRowLimit)*/; nRow++)
                    {
                        // This index is needed to display actual row no in the error table.
                        nActualRowIndex = CommonOpenXML.GetRow(nRow);

                        if (nActualRowIndex >= m_nDataStartRow)
                        {

                            List<string> lstColumns = new List<string>();
                            // Read excel column one by one and save account & account data
                            int nIncrementDifference = 0;
                            nActualColumnIndex = 0;
                            int nOldActual = 0;
                            int nTotalIncrement = 0;//This is used to skip the blank cells when requesting the new cell value
                            for (int nColumnCounter = 0; nColumnCounter < nColumnCount; nColumnCounter++)
                            {
                                bool isDate = false;
                                if (lstDateColumnNumbers.Contains(nColumnCounter))
                                    isDate = true;
                                sValue = "";
                                nOldActual = nActualColumnIndex;
                                nActualColumnIndex = CommonOpenXML.GetCellValue(nActualColumnIndex, nTotalIncrement, isDate, out sValue);
                                if (nActualColumnIndex - nOldActual > 0)
                                {
                                    nIncrementDifference = nActualColumnIndex - nOldActual;
                                    nTotalIncrement = nTotalIncrement + nIncrementDifference;
                                    for (int counter = 0; counter < (nActualColumnIndex - nOldActual); counter++)
                                    {
                                        lstColumns.Add("");
                                        nColumnCounter++;
                                    }
                                    nActualColumnIndex = nActualColumnIndex + 1;
                                }
                                else
                                {
                                    nActualColumnIndex++;
                                }
                                if (nRow == 0 && sValue == "" && m_nMassUploadId == 56 && sSheetName == "CompanyDetails")
                                {
                                    lstColumns.Add("MassCounter");
                                }
                                else if (nRow != 0 && sValue == "" && m_nMassUploadId == 56 && sSheetName == "CompanyDetails")
                                {
                                    lstColumns.Add(Convert.ToString(GetMassCounter(m_sConnectionString)));
                                }
                                else
                                {
                                    lstColumns.Add(sValue);
                                }

                            }

                            if (nRow == 0)
                            {
                                m_objSheetWiseColumnsNames[sSheetName] = lstColumns;
                            }
                            else
                            {
                                lstRows.Add(lstColumns);
                            }
                            lstColumns = null;
                        }
                    }
                    //Skip if the sheet contains only headers and no data as data starts from second row.
                    if (CommonOpenXML.TotalRows < 2)
                    {
                        m_objExcelSheetWiseData[sSheetName] = new List<List<string>>();
                        continue;
                    }

                    m_objExcelSheetWiseData[sSheetName] = lstRows;
                    lstRows = null;
                }
            }
            catch (Exception exp) { }
            finally
            {
                CommonOpenXML.ReleaseObjects();
            }

        }
        #endregion ReadXLSXFileIntoCollection
        #endregion ReadDataFrom Excel File

        #region SetUploadedfileGUID
        /// <summary>
        /// This function will set the Uploaded file GUID to the member variable to be used creating the excel file containing the mass upload row wise error 
        /// </summary>
        /// <param name="i_sUploadedfileGUID"></param>
        public void SetUploadedfileGUID(string i_sUploadedfileGUID)
        {
            m_sUploadedFileGUID = i_sUploadedfileGUID;
        }
        #endregion 

        #region GetSingleMassUploadDetails
        /// <summary>
        /// This function will return the mass upload detail for given mass upload id in the system
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public MassUploadDTO GetSingleMassUploadDetails(string i_sConnectionString, int i_nMassUploadId)
        {
            MassUploadDTO objMassUploadDTO = null;
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    objMassUploadDTO = objMassUploadDAL.GetSingleMassUploadsDetails(i_sConnectionString, i_nMassUploadId);
                }
            }
            catch (Exception exp)
            {
                string message = exp.Message;
            }
            return objMassUploadDTO;
        }
        #endregion GetSingleMassUploadDetails

        #region GetAllMassUpload
        /// <summary>
        /// This function will return all the mass uploads in the system
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public List<MassUploadDTO> GetAllMassUpload(string i_sConnectionString)
        {
            List<MassUploadDTO> lstMassUploadDTO = new List<MassUploadDTO>();
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    lstMassUploadDTO = (List<InsiderTradingDAL.MassUploadDTO>)objMassUploadDAL.GetAllMassUploads(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {

            }
            return lstMassUploadDTO;
        }
        #endregion GetAllMassUpload



        #region FetchAllCodes
        /// <summary>
        /// This method will be used for fetching all the codes from com_code table and maintain the list of CodesDTO and a dictionary containing the collection
        /// of CodeDisplayCode+"_"+CodeGroupid or  Codename+"_"+CodeGroupid if CodeDisplayCode is null, against the CodeNo. This will be used for cnverting the 
        /// code values as added in the excel to code as to be saved in the table.
        /// </summary>
        public void FetchAllCodes()
        {
            CodesDTO objCodesDTOTmp;
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    m_objCodesDTOList = objMassUploadDAL.GetAllComCodes(m_sConnectionString);
                }
                foreach (CodesDTO objCodesDTO in m_objCodesDTOList)
                {
                    objCodesDTOTmp = objCodesDTO;
                    try
                    {
                        if (objCodesDTO.DisplayCode == null || objCodesDTO.DisplayCode == "")
                        {
                            m_objCodesNameWiseDisct.Add((objCodesDTO.CodeName.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)), Convert.ToInt32(objCodesDTO.CodeID));
                        }
                        else
                        {
                            m_objCodesNameWiseDisct.Add((objCodesDTO.DisplayCode.ToLower() + "_" + Convert.ToString(objCodesDTO.CodeGroupId)), Convert.ToInt32(objCodesDTO.CodeID));
                        }
                    }
                    catch (Exception e) { string seeorMessage = e.Message; }
                }
            }
            catch (Exception exp)
            {
                string errormessage = exp.Message;
            }
        }
        #endregion FetchAllCodes

        #region FetchAllCompanyNames
        /// <summary>
        /// This method will be used for fetching all the company names from mst_company table and maintain the list of CompanynameDTO and a dictionary containing the collection
        /// of CompanyName against the CompanyId. This will be used for cnverting the company name values as added in the excel to company id as to be saved in the table.
        /// </summary>
        public void FetchAllCompanyNames()
        {
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    m_objCompanyNamesDTOList = objMassUploadDAL.GetAllCompanyNames(m_sConnectionString);
                }
                foreach (CompanyNamesDTO objCompanyNameDTO in m_objCompanyNamesDTOList)
                {
                    m_objCompanyNamesDisct.Add((objCompanyNameDTO.CompanyName.ToLower()), objCompanyNameDTO.CompanyId);
                }
            }
            catch (Exception exp)
            {

            }
        }
        #endregion FetchAllCompanyNames

        #region FetchAllRoleNames
        /// <summary>
        /// This method will be used for fetching all the Role names from usr_RoleMaster table and maintain the list of RolesDTO and a dictionary containing the collection
        /// of RoleName against the RoleId. This will be used for converting the role name values as added in the excel to role id as to be saved in the table.
        /// </summary>
        /// 
        public void FetchAllRoleNames()
        {
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    m_objRolesDTOList = objMassUploadDAL.GetAllRoles(m_sConnectionString);
                }
                foreach (RolesDTO objRoleNameDTO in m_objRolesDTOList)
                {
                    m_objRolesNameWiseDisct.Add((objRoleNameDTO.RoleName).ToLower(), objRoleNameDTO.RoleId);
                }
            }
            catch (Exception exp)
            {

            }
        }
        #endregion FetchAllRoleNames

        #region FetchConfigurationData
        /// <summary>
        /// This function will be used for fetching the configuration data to be used for fetching the data from excel file and 
        /// send to corresponding procedure for performing mass upload.
        /// </summary>
        public void FetchConfigurationData()
        {
            //Fetch the configuration data from the table and save it in the corresponding objects
            List<InsiderTradingDAL.MassUploadDTO> lstMassUploadDTO;

            int nCounter = 0;
            int nOldExcelSheetId = 0;
            Dictionary<string, List<MassUploadExcelDataTableColumnMapping>>
                dictDataTableColumnMapping = new Dictionary<string, List<MassUploadExcelDataTableColumnMapping>>();
            m_objMassUploadExcelSheets = null;
            List<MassUploadExcelDataTableColumnMapping> lstColumnsMapping = new List<MassUploadExcelDataTableColumnMapping>();
            List<int> lstSheetDateExcelColumnsNumbers = new List<int>();
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    lstMassUploadDTO = (List<InsiderTradingDAL.MassUploadDTO>)objMassUploadDAL.GetMassUploadConfiguration(m_nMassUploadId, m_sConnectionString);
                }

                foreach (InsiderTradingDAL.MassUploadDTO objMassUploadDTO in lstMassUploadDTO)
                {
                    if (nCounter == 0)
                    {
                        m_objMassUploadExcel.MassUploadExcelId = objMassUploadDTO.MassUploadExcelId;
                        m_objMassUploadExcel.MassUploadName = objMassUploadDTO.MassUploadName;
                        m_objMassUploadExcel.HasMultipleSheet = objMassUploadDTO.HasMultipleSheets;
                        dictDataTableColumnMapping = new Dictionary<string, List<MassUploadExcelDataTableColumnMapping>>();
                        lstSheetDateExcelColumnsNumbers = new List<int>();
                    }
                    if (objMassUploadDTO.MassUploadExcelSheetId != nOldExcelSheetId)
                    {
                        //start with new sheet
                        if (m_objMassUploadExcelSheets != null)
                        {
                            dictDataTableColumnMapping[m_objMassUploadExcelSheets.SheetName.ToString()] = lstColumnsMapping;
                            m_objMassUploadExcelSheets.DataTableColumnMapping = dictDataTableColumnMapping;
                            m_lstMassUploadSheets.Add(m_objMassUploadExcelSheets);
                            m_objMassUploadExcelSheetList[m_objMassUploadExcelSheets.SheetName] = m_objMassUploadExcelSheets;
                            m_lstSheetWiseDateColumnNumbers[m_objMassUploadExcelSheets.SheetName] = lstSheetDateExcelColumnsNumbers;
                            dictDataTableColumnMapping = new Dictionary<string, List<MassUploadExcelDataTableColumnMapping>>();
                            lstSheetDateExcelColumnsNumbers = new List<int>();
                        }
                        m_objMassUploadExcelSheets = new MassUploadExcelSheets();
                        m_objMassUploadExcelSheets.MassUploadExcelSheetId = objMassUploadDTO.MassUploadExcelSheetId;
                        m_objMassUploadExcelSheets.MassUploadExcelId = objMassUploadDTO.MassUploadExcelId;
                        m_objMassUploadExcelSheets.SheetName = objMassUploadDTO.SheetName;
                        m_objMassUploadExcelSheets.IsPrimarySheet = objMassUploadDTO.IsPrimarySheet;
                        m_objMassUploadExcelSheets.ProcedureUsed = objMassUploadDTO.ProcedureUsed;
                        m_objMassUploadExcelSheets.ParentSheetName = objMassUploadDTO.ParentSheetName;
                        m_objMassUploadExcelSheets.ColumnCount = objMassUploadDTO.ColumnCount;
                        //
                        if (!dictDataTableColumnMapping.ContainsKey(m_objMassUploadExcelSheets.MassUploadExcelSheetId.ToString()))
                        {
                            lstColumnsMapping = new List<MassUploadExcelDataTableColumnMapping>();
                        }
                        else
                        {
                            lstColumnsMapping = dictDataTableColumnMapping[m_objMassUploadExcelSheets.MassUploadExcelSheetId.ToString()];
                        }
                    }


                    if (objMassUploadDTO.RelatedMassUploadRelatedSheetId != 0)
                    {
                        m_objSheetRelatedColumnMapping.Add(objMassUploadDTO.MassUploadExcelSheetId + ":" + objMassUploadDTO.ExcelColumnNo, objMassUploadDTO.RelatedMassUploadRelatedSheetId + ":" + objMassUploadDTO.RelatedMassUploadExcelSheetColumnNo);
                    }
                    MassUploadExcelDataTableColumnMapping objMassUploadExcelDataTableColumnMapping = new MassUploadExcelDataTableColumnMapping();
                    objMassUploadExcelDataTableColumnMapping.MassUploadExcelDataTableColumnMappingId = objMassUploadDTO.MassUploadExcelDataTableColumnMappingId;
                    objMassUploadExcelDataTableColumnMapping.MassUploadExcelSheetId = objMassUploadDTO.MassUploadExcelSheetId;
                    objMassUploadExcelDataTableColumnMapping.ExcelColumnNo = objMassUploadDTO.ExcelColumnNo;
                    objMassUploadExcelDataTableColumnMapping.MassUploadDataTableId = objMassUploadDTO.MassUploadDataTableId;
                    objMassUploadExcelDataTableColumnMapping.MassUploadDataTablePropertyNo = objMassUploadDTO.MassUploadDataTablePropertyNo;
                    objMassUploadExcelDataTableColumnMapping.MassUploadDataTablePropertyName = objMassUploadDTO.MassUploadDataTablePropertyName;
                    objMassUploadExcelDataTableColumnMapping.MassUploadDataTablePropertyDataType = objMassUploadDTO.MassUploadDataTablePropertyDataType;
                    if (objMassUploadDTO.MassUploadDataTablePropertyDataType != null && objMassUploadDTO.MassUploadDataTablePropertyDataType.ToLower() == "datetime")
                    {
                        lstSheetDateExcelColumnsNumbers.Add(objMassUploadDTO.ExcelColumnNo);
                    }
                    objMassUploadExcelDataTableColumnMapping.MassUploadDataTablePropertySataSize = objMassUploadDTO.MassUploadDataTablePropertyDataSize;
                    objMassUploadExcelDataTableColumnMapping.RelatedMassUploadExcelSheetId = objMassUploadDTO.RelatedMassUploadRelatedSheetId;
                    objMassUploadExcelDataTableColumnMapping.RelatedMassUploadExcelSheetColumnNo = objMassUploadDTO.RelatedMassUploadExcelSheetColumnNo;
                    objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId = objMassUploadDTO.ApplicableDataCodeGroupId;
                    objMassUploadExcelDataTableColumnMapping.IsRequired = objMassUploadDTO.IsRequired;
                    objMassUploadExcelDataTableColumnMapping.ValidationRegExpress = objMassUploadDTO.ValidationRegExpress;
                    objMassUploadExcelDataTableColumnMapping.MaxLength = objMassUploadDTO.MaxLength;
                    objMassUploadExcelDataTableColumnMapping.MinLength = objMassUploadDTO.MinLength;

                    objMassUploadExcelDataTableColumnMapping.IsRequiredErrorCode = objMassUploadDTO.IsRequiredErrorCode;
                    objMassUploadExcelDataTableColumnMapping.ValidationRegExpErrorcode = objMassUploadDTO.ValidationRegExpErrorcode;
                    objMassUploadExcelDataTableColumnMapping.MaxLengthErrorCode = objMassUploadDTO.MaxLengthErrorCode;
                    objMassUploadExcelDataTableColumnMapping.MinLengthErrorCode = objMassUploadDTO.MinLengthErrorCode;
                    objMassUploadExcelDataTableColumnMapping.DependentColumnNumber = objMassUploadDTO.DependentColumnNo;
                    objMassUploadExcelDataTableColumnMapping.DependentColumnErrorCode = objMassUploadDTO.DependentColumnErrorCode;

                    objMassUploadExcelDataTableColumnMapping.DependentValueColumnNumber = objMassUploadDTO.DependentValueColumnNumber;
                    objMassUploadExcelDataTableColumnMapping.DependentValueColumnValue = objMassUploadDTO.DependentValueColumnValue;
                    objMassUploadExcelDataTableColumnMapping.DependentValueColumnErrorCode = objMassUploadDTO.DependentValueColumnErrorCode;
                    objMassUploadExcelDataTableColumnMapping.DefaultValue = objMassUploadDTO.DefaultValue;

                    if (objMassUploadDTO.RelatedMassUploadRelatedSheetId != 0)
                    {
                        m_objMassUploadExcelSheets.ColumnNoToUpdateFromParent = objMassUploadDTO.RelatedMassUploadRelatedSheetId;
                    }

                    lstColumnsMapping.Add(objMassUploadExcelDataTableColumnMapping);




                    nOldExcelSheetId = objMassUploadDTO.MassUploadExcelSheetId;
                    nCounter++;
                }
                if (m_objMassUploadExcelSheets != null)
                {
                    dictDataTableColumnMapping[m_objMassUploadExcelSheets.SheetName.ToString()] = lstColumnsMapping;
                    m_objMassUploadExcelSheets.DataTableColumnMapping = dictDataTableColumnMapping;
                    m_objMassUploadExcelSheetList[m_objMassUploadExcelSheets.SheetName] = m_objMassUploadExcelSheets;
                    m_lstSheetWiseDateColumnNumbers[m_objMassUploadExcelSheets.SheetName] = lstSheetDateExcelColumnsNumbers;
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion

        #region CheckBasedOnDependentcolumnValue
        /// <summary>
        /// This function will be used to check if the validation on the given column should be applied or not based on the depencent column value.
        /// </summary>
        /// <param name="i_sExcelSheetName"></param>
        /// <param name="i_nColumnCount"></param>
        /// <param name="i_objRowArray"></param>
        /// <returns></returns>
        private bool CheckBasedOnDependentcolumnValue(string i_sExcelSheetName, int i_nColumnCount, object[] i_objRowArray)
        {
            bool isShouldCheckForRequired = false;
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollectionColumnValue = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

            if (m_objSheetWiseDependentValueColumns.ContainsKey(i_sExcelSheetName))
            {
                objCollectionColumnValue = m_objSheetWiseDependentValueColumns[i_sExcelSheetName];
            }
            if (objCollectionColumnValue.ContainsKey(i_nColumnCount))
            {
                MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollectionColumnValue[i_nColumnCount];
                int? iDependentColumnValueNumber = objColumnMappingObj.DependentValueColumnNumber;
                string sDependentColumnValue = objColumnMappingObj.DependentValueColumnValue.ToLower();
                List<string> objDependentColumnValues = sDependentColumnValue.Split(new char[] { ',' }).ToList<string>();
                //o_sErrorCode = objColumnMappingObj.DependentValueColumnErrorCode;

                if (iDependentColumnValueNumber != null)
                {
                    if (objDependentColumnValues.Contains(i_objRowArray[(int)iDependentColumnValueNumber].ToString().ToLower()))
                    {
                        isShouldCheckForRequired = true;
                    }
                }
            }
            else
            {
                isShouldCheckForRequired = true;
            }
            objCollectionColumnValue = null;
            return isShouldCheckForRequired;
        }
        #endregion CheckBasedOnDependentcolumnValue

        #region ValidateData
        /// <summary>
        /// This function will be used for validating the data based on the validation type given for given sheet and given column no. 
        /// This function will be called for every column in the given column.
        /// </summary>
        /// <param name="n_sExcelSheetName"></param>
        /// <param name="i_nColumnCount"></param>
        /// <param name="i_nValidationType"></param>
        /// <param name="i_sData"></param>
        /// <param name="?"></param>

        private void ValidateData(string i_sExcelSheetName, int i_nColumnCount, ValidationTypes i_nValidationType, string i_sData, object[] i_objRowArray, out bool o_bIsValid, out string o_sErrorCode, out string o_sErrorMessage)
        {
            o_bIsValid = true;
            o_sErrorCode = "";
            o_sErrorMessage = "";
            try
            {




                //if (!isDependentColumnValueColumn)
                //{
                if (i_nValidationType == ValidationTypes.REQUIREDVALIDATION)//For is required validation
                {

                    bool isShouldCheckForRequired = false;
                    isShouldCheckForRequired = CheckBasedOnDependentcolumnValue(i_sExcelSheetName, i_nColumnCount, i_objRowArray);

                    if (isShouldCheckForRequired)
                    {
                        //To check if the column is Required conditionally based on value from a given column
                        Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
                        if (m_objSheetWiseRequiredColumns.ContainsKey(i_sExcelSheetName))
                        {
                            objCollection = m_objSheetWiseRequiredColumns[i_sExcelSheetName];
                        }
                        if (objCollection.ContainsKey(i_nColumnCount))
                        {
                            //If the concerned column is not a dependent column and is not required based on value of other column then validate for required field.

                            MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                            if (i_sData == null || i_sData == "")
                            {
                                o_bIsValid = false;
                                o_sErrorCode = objColumnMappingObj.IsRequiredErrorCode;
                                if (o_sErrorCode == null || o_sErrorCode == "")
                                {
                                    o_sErrorMessage = "The " + m_objSheetWiseColumnsNames[i_sExcelSheetName][(int)i_nColumnCount] + " is required.";
                                }
                            }
                        }
                        objCollection = null;
                    }
                }
                else if (i_nValidationType == ValidationTypes.REGULAREXPRESSIONVALIDATION)//For Regular expression 
                {
                    Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
                    if (m_objSheetWiseRegExpression.ContainsKey(i_sExcelSheetName))
                    {
                        objCollection = m_objSheetWiseRegExpression[i_sExcelSheetName];
                    }

                    if (i_sData != "")
                    {
                        if (objCollection.ContainsKey(i_nColumnCount))
                        {
                            MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                            string sRgularExpression = objColumnMappingObj.ValidationRegExpress;
                            //Regex regex = new Regex(sRgularExpression, RegexOptions.IgnoreCase);
                            //Match match = regex.Match(i_sData);
                            if (!Regex.IsMatch(i_sData as string, sRgularExpression, RegexOptions.IgnoreCase))
                            {
                                o_bIsValid = false;
                                o_sErrorCode = objColumnMappingObj.ValidationRegExpErrorcode;
                                if (o_sErrorCode == null || o_sErrorCode == "")
                                {
                                    o_sErrorMessage = "Regular expression failure for " + i_sData;
                                }
                            }
                        }
                        objCollection = null;
                    }
                }
                else if (i_nValidationType == ValidationTypes.MAXLENGTHVALIDATION)//For max length of data
                {
                    Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

                    if (m_objSheetWiseMaxLengthColumns.ContainsKey(i_sExcelSheetName))
                    {
                        objCollection = m_objSheetWiseMaxLengthColumns[i_sExcelSheetName];
                    }

                    if (objCollection.ContainsKey(i_nColumnCount))
                    {
                        MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                        if (i_sData != null && i_sData.Length > objColumnMappingObj.MaxLength)
                        {
                            o_bIsValid = false;
                            o_sErrorCode = objColumnMappingObj.MaxLengthErrorCode;
                            if (o_sErrorCode == null || o_sErrorCode == "")
                            {
                                o_sErrorMessage = "The field " + m_objSheetWiseColumnsNames[i_sExcelSheetName][(int)i_nColumnCount] + " must be a string with a maximum length of " + objColumnMappingObj.MaxLength + ".";
                            }
                        }
                    }
                    objCollection = null;
                }
                else if (i_nValidationType == ValidationTypes.COMPANYVALIDATION)//For Company 
                {
                    Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

                    if (m_objSheetWiseCompanyColumns.ContainsKey(i_sExcelSheetName))
                    {
                        objCollection = m_objSheetWiseCompanyColumns[i_sExcelSheetName];
                    }
                    if (i_sData != "")
                    {
                        if (objCollection.ContainsKey(i_nColumnCount))
                        {
                            MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                            if (!m_objCompanyNamesDisct.ContainsKey(Convert.ToString(i_sData).ToLower()))
                            {
                                o_bIsValid = false;
                                o_sErrorMessage = i_sData + " company is invalid";
                            }
                        }
                    }
                    objCollection = null;
                }
                else if (i_nValidationType == ValidationTypes.ROLEVALIDATION)//For Role 
                {
                    Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

                    if (m_objSheetWiseRoleColumns.ContainsKey(i_sExcelSheetName))
                    {
                        objCollection = m_objSheetWiseRoleColumns[i_sExcelSheetName];
                    }
                    if (i_sData != "")
                    {
                        if (objCollection.ContainsKey(i_nColumnCount))
                        {
                            MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                            if (!m_objRolesNameWiseDisct.ContainsKey(Convert.ToString(i_sData).ToLower()))
                            {
                                o_bIsValid = false;
                                o_sErrorMessage = i_sData + " role is invalid";
                            }
                        }
                    }
                    objCollection = null;
                }
                else if (i_nValidationType == ValidationTypes.MASTERCODEVALIDATION)//For Master codes 
                {
                    bool isShouldCheckForRequired = false;
                    isShouldCheckForRequired = CheckBasedOnDependentcolumnValue(i_sExcelSheetName, i_nColumnCount, i_objRowArray);

                    if (isShouldCheckForRequired)
                    {
                        if (i_sData != "")
                        {
                            Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

                            if (m_objSheetWiseMasterCodeColumns.ContainsKey(i_sExcelSheetName))
                            {
                                objCollection = m_objSheetWiseMasterCodeColumns[i_sExcelSheetName];
                            }


                            if (objCollection.ContainsKey(i_nColumnCount))
                            {
                                MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                                if (!m_objCodesNameWiseDisct.ContainsKey(Convert.ToString(i_sData).ToLower() + "_" + objColumnMappingObj.ApplicableDataCodeGroupId))
                                {
                                    o_bIsValid = false;
                                    o_sErrorMessage = i_sData + " value is invalid";
                                }
                            }
                            objCollection = null;
                        }
                    }
                }
                else if (i_nValidationType == ValidationTypes.DEPENDENTCOLUMN)//For dependent column  validation
                {
                    Dictionary<int, MassUploadExcelDataTableColumnMapping> objCollection = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();

                    if (m_objSheetWiseDependentColumns.ContainsKey(i_sExcelSheetName))
                    {
                        objCollection = m_objSheetWiseDependentColumns[i_sExcelSheetName];
                    }


                    if (objCollection.ContainsKey(i_nColumnCount))
                    {
                        MassUploadExcelDataTableColumnMapping objColumnMappingObj = objCollection[i_nColumnCount];
                        int? iDependentColumnNo = objColumnMappingObj.DependentColumnNumber;

                        if (i_sData != null && i_sData != "" && iDependentColumnNo != null)
                        {
                            if (i_objRowArray[(int)iDependentColumnNo].ToString() == "")
                            {
                                o_bIsValid = false;
                                o_sErrorCode = objColumnMappingObj.IsRequiredErrorCode;
                                if (o_sErrorCode == null || o_sErrorCode == "")
                                {
                                    string nExcelColumnName = "";
                                    if (iDependentColumnNo != 0)
                                    {
                                        EXCELColumnNumber enumDisplayStatus = (EXCELColumnNumber)((int)iDependentColumnNo);
                                        nExcelColumnName = enumDisplayStatus.ToString();
                                    }
                                    o_sErrorMessage = "This value can be selected only when there is value in column \"" + m_objSheetWiseColumnsNames[i_sExcelSheetName][(int)iDependentColumnNo] + "\" (" + nExcelColumnName + ")";
                                }
                            }
                        }
                    }
                    objCollection = null;
                }
                // }
            }
            catch (Exception exp)
            {

            }
        }

        #endregion

        #region ManageAllValidationsForAllSheets
        /// <summary>
        /// This function will be used for sheet wise grouping the columns which require different types of validations.
        /// </summary>
        private void ManageAllValidationsForAllSheets()
        {
            try
            {
                foreach (string sExcelSheetName in m_objMassUploadExcelSheetList.Keys)
                {
                    MassUploadExcelSheets objExcelSheet = m_objMassUploadExcelSheetList[sExcelSheetName];
                    Dictionary<string, List<MassUploadExcelDataTableColumnMapping>> objExcelSheetColumns = objExcelSheet.DataTableColumnMapping;
                    List<MassUploadExcelDataTableColumnMapping> lstSheetColumnMapping = objExcelSheetColumns[sExcelSheetName];
                    //int nColumnCounter = 0;
                    foreach (MassUploadExcelDataTableColumnMapping objSheetColumnMapping in lstSheetColumnMapping)
                    {
                        ManageIsRequiredValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageIsMaxLengthValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageRegularExpressionValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageCompanyValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageRoleValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageMasterCodeValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageDependentValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        ManageDependentColumnValueValidationColumn(sExcelSheetName, objSheetColumnMapping.ExcelColumnNo, objSheetColumnMapping);
                        //nColumnCounter++;
                    }
                    lstSheetColumnMapping = null;
                }
            }
            catch (Exception exp)
            {

            }
        }
        #endregion ManageAllValidationsForAllSheets

        #region Column Level Required, Regular Expression Max Length and Min length, Company, Roles and Codes Validation Methods
        /// <summary>
        /// This function will be used for checking if the corresponding column should be check for max length for data and add it in the m_objSheetWiseMaxLengthColumns collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageIsMaxLengthValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnMaxLengthValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                //There is an assumption that all the string type fields will have max length set against it.
                if (i_objMassUploadExcelDataTableColumnMapping.MaxLength != null && i_objMassUploadExcelDataTableColumnMapping.MaxLength > 0)
                {
                    if (m_objSheetWiseMaxLengthColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnMaxLengthValidation = m_objSheetWiseMaxLengthColumns[i_sSheetName];
                    }
                    objColumnMaxLengthValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseMaxLengthColumns[i_sSheetName] = objColumnMaxLengthValidation;
                }
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has IsRequired flag true then add it in the m_objSheetWiseRequiredColumns collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageIsRequiredValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnRequiredValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.IsRequired)
                {
                    if (m_objSheetWiseRequiredColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnRequiredValidation = m_objSheetWiseRequiredColumns[i_sSheetName];
                    }
                    objColumnRequiredValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseRequiredColumns[i_sSheetName] = objColumnRequiredValidation;
                }
                objColumnRequiredValidation = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has RegularExpression defined flag true then add it in the m_objSheetWiseRegExpression collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageRegularExpressionValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnRegularExpressionValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.ValidationRegExpress != null && i_objMassUploadExcelDataTableColumnMapping.ValidationRegExpress != "")
                {
                    if (m_objSheetWiseRegExpression.ContainsKey(i_sSheetName))
                    {
                        objColumnRegularExpressionValidation = m_objSheetWiseRegExpression[i_sSheetName];
                    }
                    objColumnRegularExpressionValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseRegExpression[i_sSheetName] = objColumnRegularExpressionValidation;
                }
                objColumnRegularExpressionValidation = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has Country code then add it in the m_objSheetWiseCompanyColumns collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageCompanyValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnCountryValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId != null && i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId == -1)
                {
                    if (m_objSheetWiseCompanyColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnCountryValidation = m_objSheetWiseCompanyColumns[i_sSheetName];
                    }
                    objColumnCountryValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseCompanyColumns[i_sSheetName] = objColumnCountryValidation;
                }
                objColumnCountryValidation = null;
            }
            catch (Exception exp)
            {

            }
        }


        /// <summary>
        /// This function will be used for checking if the corresponding column has Roles code then add it in the m_objSheetWiseRoleColumns collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageRoleValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnRoleValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId != null && i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId == -2)
                {
                    if (m_objSheetWiseRoleColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnRoleValidation = m_objSheetWiseRoleColumns[i_sSheetName];
                    }
                    objColumnRoleValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseRoleColumns[i_sSheetName] = objColumnRoleValidation;
                }
                objColumnRoleValidation = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has Roles code then add it in the m_objSheetWiseMasterCodeColumns collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageMasterCodeValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnMasterCodeValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId != null && i_objMassUploadExcelDataTableColumnMapping.ApplicableDataCodeGroupId > 0)
                {
                    if (m_objSheetWiseMasterCodeColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnMasterCodeValidation = m_objSheetWiseMasterCodeColumns[i_sSheetName];
                    }
                    objColumnMasterCodeValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseMasterCodeColumns[i_sSheetName] = objColumnMasterCodeValidation;
                }
                objColumnMasterCodeValidation = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will maintain a collection of the Property names for the column. This will be used for showing the column names in the error report.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_nColumnCount"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageSheetWiseColumnNames(string i_sSheetName, int i_nColumnCount, string i_sColumnName)
        {
            List<string> objColumnNames = new List<string>();
            try
            {
                if (m_objSheetWiseColumnsNames.ContainsKey(i_sSheetName))
                {
                    objColumnNames = m_objSheetWiseColumnsNames[i_sSheetName];
                }
                objColumnNames.Add(i_sColumnName);
                m_objSheetWiseColumnsNames[i_sSheetName] = objColumnNames;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has dependent column mentioned and will add it in m_objSheetWiseDependentColumn collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageDependentValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnDependentColumnValidation = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.DependentColumnNumber != null)
                {
                    if (m_objSheetWiseDependentColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnDependentColumnValidation = m_objSheetWiseDependentColumns[i_sSheetName];
                    }
                    objColumnDependentColumnValidation.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseDependentColumns[i_sSheetName] = objColumnDependentColumnValidation;
                }
                objColumnDependentColumnValidation = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will be used for checking if the corresponding column has dependent column value mentioned and will add it in m_objSheetWiseDependentValueColumn collection.
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_objMassUploadExcelDataTableColumnMapping"></param>
        private void ManageDependentColumnValueValidationColumn(string i_sSheetName, int i_nColumnCount, MassUploadExcelDataTableColumnMapping i_objMassUploadExcelDataTableColumnMapping)
        {
            Dictionary<int, MassUploadExcelDataTableColumnMapping> objColumnDependentValueColumn = new Dictionary<int, MassUploadExcelDataTableColumnMapping>();
            try
            {
                if (i_objMassUploadExcelDataTableColumnMapping.DependentValueColumnNumber != null)
                {
                    if (m_objSheetWiseDependentValueColumns.ContainsKey(i_sSheetName))
                    {
                        objColumnDependentValueColumn = m_objSheetWiseDependentValueColumns[i_sSheetName];
                    }
                    objColumnDependentValueColumn.Add(i_nColumnCount, i_objMassUploadExcelDataTableColumnMapping);
                    m_objSheetWiseDependentValueColumns[i_sSheetName] = objColumnDependentValueColumn;
                }
                objColumnDependentValueColumn = null;
            }
            catch (Exception exp)
            {

            }
        }

        #endregion Column Level Required, Regular Expression Max Length and Min length, Company, Roles and Codes Validation Methods

        #region CheckSheetPresent
        /// <summary>
        /// This function will be used for checking if the given sheet name is present in the DataTable of the sheet names
        /// received from the excel. This if to check if the required sheet is present in the Excel.
        /// </summary>
        /// <param name="i_objSheetTable"></param>
        /// <param name="i_sCheckSheetName"></param>
        /// <returns></returns>
        private bool CheckSheetPresent(DataTable i_objSheetTable, string i_sCheckSheetName)
        {
            bool bIsSheetPresent = false;

            try
            {
                foreach (DataRow objDatarow in i_objSheetTable.Rows)
                {
                    if (objDatarow.ItemArray[2].ToString().Replace("$", "").CompareTo(i_sCheckSheetName) == 0)
                    {
                        bIsSheetPresent = true;
                        break;
                    }
                }
            }
            catch (Exception exp)
            {

            }
            return bIsSheetPresent;
        }
        #endregion CheckSheetPresent

        #region CreateHIMSExcelFromView
        /// <summary>
        /// This method will fetch the data from database view and convert it into corresponding Excel to be used for mass upload
        /// </summary>
        /// <param name="?"></param>
        /// <returns></returns>
        public void CreateHIMSExcelFromView(string i_sViewDatabaseConnectionString, string i_sViewName, string i_sDocumentPath, out string o_sExcelFileName)
        {
            List<List<object>> lstRows = new List<List<object>>();
            //m_objMassUploadDAL = new MassUploadDAL();
            IEnumerable<HIMSEmployeeDTO> lstHimsEmployeeDTO;
            MassUploadFromViewSL<HIMSEmployeeDTO> objMassUploadFromViewSL = new MassUploadFromViewSL<HIMSEmployeeDTO>();
            try
            {
                lstHimsEmployeeDTO = objMassUploadFromViewSL.FetchFromView(i_sViewDatabaseConnectionString, i_sViewName);//"data source=ATLANTIX\\SQLExpress;initial catalog=TestingEmployeeDetailsDatabase;persist security info=True;user id=sa;Password=softcorner;MultipleActiveResultSets=True;", i_sViewName);

                int nRowCounter = 1;
                string sDatePart = Common.ApplyFormatting(DateTime.Now, ConstEnum.DataFormatType.DateTime12_ForFileName);
                o_sExcelFileName = i_sDocumentPath + "HIMSImportExcel_" + sDatePart + ".xlsx";
                ArrayList arrColumnWidth = new ArrayList();

                InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject objCommonOpenXMLObject;
                objCommonOpenXMLObject = new InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject();
                objCommonOpenXMLObject.OpenFile(o_sExcelFileName, true);
                objCommonOpenXMLObject.OpenXMLObjectCreation();
                objCommonOpenXMLObject.OpenXMLCreateWorkSheetPartSheetData();
                arrColumnWidth.Add("1:40:25");
                objCommonOpenXMLObject.AssignColumnWidth(arrColumnWidth);

                int nSequencenumber = 1;
                foreach (HIMSEmployeeDTO objHIMSEmployeeDTO in lstHimsEmployeeDTO)
                {
                    int nColumnCounter = 1;
                    if (nRowCounter == 1)
                    {



                        objCommonOpenXMLObject.CreateNewRow(nRowCounter);
                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column1", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column2", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column3", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column4", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column5", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column6", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column7", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column8", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column9", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column10", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column11", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column12", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column13", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column14", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column15", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column16", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column17", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column18", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column19", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column20", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column21", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column22", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column23", nRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nColumnCounter++;

                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], "Column24", nRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nRowCounter++;

                        objCommonOpenXMLObject.AddToSheetData();

                    }
                    nColumnCounter = 1;
                    objCommonOpenXMLObject.CreateNewRow(nRowCounter);
                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], Convert.ToString(nSequencenumber), nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.UserId, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.UserName, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.CompanyName, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.FirstName, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Middlename, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.LastName, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Address, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Pincode, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Country, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.MobileNumber, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.EmailAddress, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.PAN, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Role, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.DateOfJoining, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.DateOfBecomingInsider, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Category, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.SubCategory, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Grade, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Designation, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.SubDesignation, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Location, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.Department, nRowCounter,
                       (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nColumnCounter++;

                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nColumnCounter], objHIMSEmployeeDTO.DIN, nRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                    nRowCounter++;
                    nSequencenumber++;

                    objCommonOpenXMLObject.AddToSheetData();

                }

                lstHimsEmployeeDTO = null;

                objCommonOpenXMLObject.OpenXMLWorksheetAssignment("EmpInsider", "", false);
                objCommonOpenXMLObject.SaveWorkSheet();
                objCommonOpenXMLObject.CloseSpreadSheet();
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion CreateHIMSExcelFromView

        #region ValidateAllExcelSheets
        /// <summary>
        /// This function will be validating all the sheets present in the excel getting uploaded for Massupload
        /// </summary>
        public void ValidateAllExcelSheets()
        {
            bool bSheetMatched = false;
            foreach (string sExcelSheetName in m_objExcelSheetWiseData.Keys)
            {
                ValidateSingleExcelSheet(sExcelSheetName, out bSheetMatched);
                if (m_objMassUploadExcelSheetList[sExcelSheetName].MassUploadExcelSheetId == 11)
                {
                    List<MassUploadExcelSheetErrors> lstSheetWiseErrors = new List<MassUploadExcelSheetErrors>();
                    MassUploadConditionalWiseValidations.ValidationsForInitialDisclosureMassUpload
                        (m_objExcelSheetWiseData[sExcelSheetName], m_objSheetWiseColumnsNames[sExcelSheetName], ref lstSheetWiseErrors);
                    if (lstSheetWiseErrors.Count > 0)
                    {
                        List<MassUploadExcelSheetErrors> lstExistingErrors = m_nExcelsheetUIValidationsErrors[sExcelSheetName];
                        lstExistingErrors.AddRange(lstSheetWiseErrors);
                        m_nExcelsheetUIValidationsErrors[sExcelSheetName] = lstExistingErrors;
                        m_bErrorPresentInExcelSheets = true;
                        bSheetMatched = true;
                        lstExistingErrors = null;
                    }
                }
                else if (m_objMassUploadExcelSheetList[sExcelSheetName].MassUploadExcelSheetId == 14)
                {
                    List<MassUploadExcelSheetErrors> lstSheetWiseErrors = new List<MassUploadExcelSheetErrors>();
                    MassUploadConditionalWiseValidations.ValidationsForOnGoingContinuousDisclosureMassUpload
                        (m_objExcelSheetWiseData[sExcelSheetName], m_objSheetWiseColumnsNames[sExcelSheetName], ref lstSheetWiseErrors);
                    if (lstSheetWiseErrors.Count > 0)
                    {
                        List<MassUploadExcelSheetErrors> lstExistingErrors = m_nExcelsheetUIValidationsErrors[sExcelSheetName];
                        lstExistingErrors.AddRange(lstSheetWiseErrors);
                        m_nExcelsheetUIValidationsErrors[sExcelSheetName] = lstExistingErrors;
                        m_bErrorPresentInExcelSheets = true;
                        bSheetMatched = true;
                        lstExistingErrors = null;
                    }
                }
                else if (m_objMassUploadExcelSheetList[sExcelSheetName].MassUploadExcelSheetId == 13)
                {
                    List<MassUploadExcelSheetErrors> lstSheetWiseErrors = new List<MassUploadExcelSheetErrors>();
                    MassUploadConditionalWiseValidations.ValidationsForPastPreclearanceAndTransactionsMassUpload
                        (m_objExcelSheetWiseData[sExcelSheetName], m_objSheetWiseColumnsNames[sExcelSheetName], ref lstSheetWiseErrors);
                    if (lstSheetWiseErrors.Count > 0)
                    {
                        List<MassUploadExcelSheetErrors> lstExistingErrors = m_nExcelsheetUIValidationsErrors[sExcelSheetName];
                        lstExistingErrors.AddRange(lstSheetWiseErrors);
                        m_nExcelsheetUIValidationsErrors[sExcelSheetName] = lstExistingErrors;
                        m_bErrorPresentInExcelSheets = true;
                        bSheetMatched = true;
                        lstExistingErrors = null;
                    }
                }
            }
            if (!bSheetMatched)
            {
                m_bErrorPresentInExcelSheets = true;
                m_bInvalidExcelSheets = true;
            }
        }
        #endregion ValidateAllExcelSheets

        #region IsExcelValid
        /// <summary>
        /// This flag will specify if all the excel sheets present in the uploaded excel are invalid
        /// </summary>
        /// <returns></returns>
        public bool IsExcelValid()
        {
            return m_bInvalidExcelSheets;
        }
        #endregion IsExcelValid

        #region Add Update Log Entry
        /// <summary>
        /// This function will used for adding/updating a log entry based on the value of i_nMassUploadLogId for the mass upload performed.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="i_nMassUploadLogId"></param>
        /// <param name="i_nMassUploadTypeId"></param>
        /// <param name="i_nStatusCodeId"></param>
        /// <param name="i_sErrorReportFileName"></param>
        /// <param name="i_nLoginUserId"></param>
        /// <param name="o_nSavedMassUploadLogId"></param>
        public void AddUpdateLogEntry(string sConnectionString, int i_nMassUploadLogId, int i_nMassUploadTypeId, int i_nStatusCodeId, int? i_nUploadedDocumentId, string i_sErrorReportFileName, string i_sErrorMessage,
            int i_nLoginUserId, out int o_nSavedMassUploadLogId)
        {
            string sErrCode = string.Empty;
            o_nSavedMassUploadLogId = 0;
            //m_objMassUploadDAL = new MassUploadDAL();
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    objMassUploadDAL.AddUpdateLogEntry(sConnectionString, i_nMassUploadLogId, i_nMassUploadTypeId, i_nStatusCodeId, i_nUploadedDocumentId, i_sErrorReportFileName, i_sErrorMessage, i_nLoginUserId, out o_nSavedMassUploadLogId);
                }
            }
            catch (Exception exp)
            {

            }
        }
        #endregion Add Update Log Entry

        #region ValidateSingleExcelSheet
        /// <summary>
        /// This function will be validating a single sheet present in the excel file uploaded for mass upload.
        /// </summary>
        public void ValidateSingleExcelSheet(string i_sSheetNameToValidate, out bool o_bSheetPresent)
        {
            List<object> lstRowData = null;
            List<List<object>> lstRows = new List<List<object>>();
            Dictionary<string, List<List<object>>> ExcelSheetData = new Dictionary<string, List<List<object>>>();
            MassUploadExcelSheets objMassUploadExcelSheet = null;
            o_bSheetPresent = false;
            try
            {
                if (m_objExcelSheetWiseData.ContainsKey(i_sSheetNameToValidate))
                    o_bSheetPresent = true;

                objMassUploadExcelSheet = m_objMassUploadExcelSheetList[i_sSheetNameToValidate];

                if (o_bSheetPresent)
                {
                    //o_bSheetPresent = true;
                    List<MassUploadExcelSheetErrors> objResponsesForError = new List<MassUploadExcelSheetErrors>();
                    int nCounter = 0;
                    bool nColumnCountErrorOccurred = false;
                    bool nNoRecordsFound = false;
                    if (m_objSheetWiseColumnsNames[i_sSheetNameToValidate].Count != objMassUploadExcelSheet.ColumnCount)
                    {
                        objResponsesForError.Add(new MassUploadExcelSheetErrors(0, 0, "", "There should be " + objMassUploadExcelSheet.ColumnCount + " columns in the sheet.", "", "", ""));
                        //m_bErrorPresentInExcelSheets = true;
                        nColumnCountErrorOccurred = true;
                    }
                    List<List<string>> lstSheetDataRows = m_objExcelSheetWiseData[i_sSheetNameToValidate];
                    if (lstSheetDataRows.Count == 0)
                    {
                        nNoRecordsFound = true;
                        //m_bErrorPresentInExcelSheets = true;
                        objResponsesForError.Add(new MassUploadExcelSheetErrors(0, 0, "", "There are no records present.", "", "", ""));
                    }
                    //This is the row counter and it starts from 1 and not 0 because the first row is for header
                    nCounter = 1;
                    if (!nColumnCountErrorOccurred && !nNoRecordsFound)
                    {
                        int nColumnCounter = 0;
                        foreach (List<string> drRecordRow in m_objExcelSheetWiseData[i_sSheetNameToValidate])
                        {
                            nColumnCounter = 0;
                            bool bIsDataValid = false;
                            string sErrorCode = "", sErrorMessage = "";
                            foreach (string drRecordColumn in drRecordRow)
                            {
                                string sDataValue = drRecordColumn.Trim();
                                string sRowSequenceNumber = Convert.ToString(drRecordRow[0]).Trim();
                                object[] objRowArray = drRecordRow.ToArray<object>();

                                ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.MAXLENGTHVALIDATION, sDataValue, objRowArray, out bIsDataValid, out sErrorCode, out sErrorMessage);

                                if (!bIsDataValid)
                                {
                                    if (sErrorCode != null && sErrorCode != "")
                                        sErrorMessage = getResource(sErrorCode);
                                    else if (sErrorMessage == "")
                                        sErrorMessage = "The size of the data exceeds max length.";
                                    objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                    m_bErrorPresentInExcelSheets = true;
                                }
                                else
                                {
                                    ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.DEPENDENTCOLUMN, sDataValue, objRowArray, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                    if (!bIsDataValid)
                                    {
                                        if (sErrorCode != null && sErrorCode != "")
                                            sErrorMessage = getResource(sErrorCode);
                                        else if (sErrorMessage == "")
                                            sErrorMessage = "This value can be added only when its dependent column contains values.";
                                        objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                        m_bErrorPresentInExcelSheets = true;
                                    }
                                    else
                                    {
                                        ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.REQUIREDVALIDATION, sDataValue, objRowArray, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                        if (!bIsDataValid)
                                        {
                                            if (sErrorCode != null && sErrorCode != "")
                                                sErrorMessage = getResource(sErrorCode);
                                            objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                            m_bErrorPresentInExcelSheets = true;
                                        }
                                        else
                                        {
                                            ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.REGULAREXPRESSIONVALIDATION, sDataValue, null, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                            if (!bIsDataValid)
                                            {
                                                if (sErrorCode != null && sErrorCode != "")
                                                    sErrorMessage = getResource(sErrorCode);
                                                objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                                m_bErrorPresentInExcelSheets = true;
                                            }
                                            else
                                            {
                                                ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.COMPANYVALIDATION, sDataValue, null, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                                if (!bIsDataValid)
                                                {
                                                    if (sErrorCode != null && sErrorCode != "")
                                                        sErrorMessage = getResource(sErrorCode);
                                                    objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                                    m_bErrorPresentInExcelSheets = true;
                                                }
                                                else
                                                {
                                                    ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.ROLEVALIDATION, sDataValue, null, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                                    if (!bIsDataValid)
                                                    {
                                                        if (sErrorCode != null && sErrorCode != "")
                                                            sErrorMessage = getResource(sErrorCode);
                                                        objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                                        m_bErrorPresentInExcelSheets = true;
                                                    }
                                                    else
                                                    {
                                                        ValidateData(i_sSheetNameToValidate, nColumnCounter, ValidationTypes.MASTERCODEVALIDATION, sDataValue, objRowArray, out bIsDataValid, out sErrorCode, out sErrorMessage);
                                                        if (!bIsDataValid)
                                                        {
                                                            if (sErrorCode != null && sErrorCode != "")
                                                                sErrorMessage = getResource(sErrorCode);
                                                            objResponsesForError.Add(new MassUploadExcelSheetErrors(nCounter + 1, (nColumnCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColumnCounter)], sRowSequenceNumber));
                                                            m_bErrorPresentInExcelSheets = true;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                nColumnCounter++;
                            }
                            nCounter++;
                        }
                        if (i_sSheetNameToValidate == "RestrictedMasterCompany")
                        {
                            List<int> checkedRows = new List<int>();
                            List<List<string>> lstDataRows = m_objExcelSheetWiseData[i_sSheetNameToValidate];
                            int nRowCounter = 0;
                            int nRow = 0;
                            for (nRow = 0; nRow < lstDataRows.Count; nRow++)
                            {
                                if (!checkedRows.Contains(nRow))
                                {
                                    for (nRowCounter = 0; nRowCounter < lstDataRows.Count; nRowCounter++)
                                    {
                                        if (nRow != nRowCounter)
                                        {
                                            if (lstDataRows[nRow][0].Trim() == lstDataRows[nRowCounter][0].Trim())
                                            {
                                                string sErrorCode = "", sErrorMessage = "";
                                                string sDataValue = lstDataRows[nRowCounter][0].Trim();
                                                int nColCounter = 0;
                                                checkedRows.Add(nRowCounter);
                                                if (sErrorMessage == "")
                                                    sErrorMessage = "The company name have duplicate entry";
                                                objResponsesForError.Add(new MassUploadExcelSheetErrors(nRowCounter + 1, (nColCounter + 1), sErrorCode, sErrorMessage, "", m_objSheetWiseColumnsNames[i_sSheetNameToValidate][(nColCounter)], sDataValue.ToString()));
                                                m_bErrorPresentInExcelSheets = true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    m_nExcelsheetUIValidationsErrors[i_sSheetNameToValidate] = objResponsesForError;
                }
                objMassUploadExcelSheet = null;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ValidateSingleExcelSheet

        #region CreateDataTable
        /// <summary>
        /// This function will create the datatable to be passed to the given Procedure for performing the insert task. 
        /// </summary>
        /// <param name="i_sDatatableName"></param>
        /// <param name="i_objColumnHeaderDataType"></param>
        /// <param name="i_objRowWiseData"></param>
        public DataTable CreateDataTable(string i_sExcelSheetName, List<MassUploadExcelDataTableColumnMapping> i_lstColumnHeaderDataType,
            List<List<string>> i_lstRowWiseData)
        {
            //GetDataTableName      --to get the datatable name
            List<string> lstDataTableProperties = new List<string>();
            List<System.Type> lstDataTypeList = new List<System.Type>();
            string sDataTableName = "";
            int iCounter = 0;
            Dictionary<int, int?> objColsWithCodes = new Dictionary<int, int?>();

            DataTable tblMassUploadDataTable = null;
            Dictionary<int, object> lstColumnWiseDefaultValues = new Dictionary<int, object>();

            try
            {
                List<string> objRowsTemp = new List<string>();
                foreach (MassUploadExcelDataTableColumnMapping objMassUploadExcelObject in i_lstColumnHeaderDataType)
                {
                    if (iCounter == 0)
                    {
                        sDataTableName = GetDataTableName(objMassUploadExcelObject.MassUploadDataTableId);
                        tblMassUploadDataTable = new DataTable(sDataTableName);
                    }
                    if (objMassUploadExcelObject.DefaultValue == null ||
                        (objMassUploadExcelObject.DefaultValue == "NULL" || objMassUploadExcelObject.DefaultValue == "null"))
                    {
                        lstColumnWiseDefaultValues.Add(iCounter, System.DBNull.Value);
                    }
                    else
                    {
                        if (objMassUploadExcelObject.MassUploadDataTablePropertyDataType.ToLower() == "int")
                        {
                            lstColumnWiseDefaultValues.Add(iCounter, Convert.ToInt32(objMassUploadExcelObject.DefaultValue));
                        }
                        else if (objMassUploadExcelObject.MassUploadDataTablePropertyDataType.ToLower() == "string")
                        {
                            lstColumnWiseDefaultValues.Add(iCounter, objMassUploadExcelObject.DefaultValue);
                        }
                        else if (objMassUploadExcelObject.MassUploadDataTablePropertyDataType.ToLower() == "datetime")
                        {
                            lstColumnWiseDefaultValues.Add(iCounter, Convert.ToDateTime(objMassUploadExcelObject.DefaultValue));
                        }
                        else if (objMassUploadExcelObject.MassUploadDataTablePropertyDataType.ToLower() == "decimal")
                        {
                            lstColumnWiseDefaultValues.Add(iCounter, Convert.ToDecimal(objMassUploadExcelObject.DefaultValue));
                        }
                        else if (objMassUploadExcelObject.MassUploadDataTablePropertyDataType.ToLower() == "bigint")
                        {
                            lstColumnWiseDefaultValues.Add(iCounter, Convert.ToInt64(objMassUploadExcelObject.DefaultValue));
                        }
                    }
                    lstDataTableProperties.Add(objMassUploadExcelObject.MassUploadDataTablePropertyName);
                    lstDataTypeList.Add(GetTypeOf(objMassUploadExcelObject.MassUploadDataTablePropertyDataType));
                    tblMassUploadDataTable.Columns.Add(new DataColumn(objMassUploadExcelObject.MassUploadDataTablePropertyName, GetTypeOf(objMassUploadExcelObject.MassUploadDataTablePropertyDataType)));
                    if (objMassUploadExcelObject.ApplicableDataCodeGroupId != null)
                    {
                        objColsWithCodes.Add(iCounter, objMassUploadExcelObject.ApplicableDataCodeGroupId);
                    }
                    iCounter++;
                }

                object loginUserDetails = HttpContext.Current.Session["UserDetails"];
                System.Reflection.PropertyInfo usrTypeCode = loginUserDetails.GetType().GetProperty("UserTypeCodeId");
                System.Reflection.PropertyInfo conString = loginUserDetails.GetType().GetProperty("CompanyDBConnectionString");
                System.Reflection.PropertyInfo usrInfoId = loginUserDetails.GetType().GetProperty("LoggedInUserID");
                System.Reflection.PropertyInfo usrName = loginUserDetails.GetType().GetProperty("UserName");
                int userTypeCodeId = (int)usrTypeCode.GetValue(loginUserDetails);
                string connectionString = (string)conString.GetValue(loginUserDetails);
                int userInfoID = (int)usrInfoId.GetValue(loginUserDetails);
                string userName = (string)usrName.GetValue(loginUserDetails);
                MassUploadDAL massUploadDAL = new MassUploadDAL();
                UserInfoSL objUserInfoSL = new UserInfoSL();
                UserInfoDTO objUserInfoDTO = objUserInfoSL.GetUserDetails(connectionString, userInfoID);
                List<string> panList = new List<string>();
                List<string> userList = new List<string>();
                if (objUserInfoDTO != null)
                {
                    panList = massUploadDAL.GetAllRelativePAN(connectionString, userInfoID);
                    panList.Add(objUserInfoDTO.PAN);
                    userList = massUploadDAL.GetAllRelativeLoginId(connectionString, userInfoID);
                    userList.Add(userName);
                }


                List<MassUploadResponseDTO> lstResponse = new List<MassUploadResponseDTO>();
                lstResponse = new List<MassUploadResponseDTO>();
                int nRowCounter = 1;
                foreach (List<string> objRowsColumns in i_lstRowWiseData)
                {
                    bool bErrorInRow = false;
                    if ((userTypeCodeId == 101003 || userTypeCodeId == 101004 || userTypeCodeId == 101006) && i_sExcelSheetName.Contains("InitialDisclosure"))
                    {
                        string value = Convert.ToString(objRowsColumns[2]);
                        bool isValid = panList.Any(c => c.Contains(value));
                        if (!isValid)
                        {
                            lstResponse.Add(new MassUploadResponseDTO(-999, Convert.ToString(value) + " is not valid value"));
                            bErrorInRow = true;
                            AddSheetWiseErrors(i_sExcelSheetName, lstResponse);
                            m_bErrorPresentInExcelSheets = true;
                            List<MassUploadExcelSheetErrors> excelSheetErrors = new List<MassUploadExcelSheetErrors>
                            {
                                new MassUploadExcelSheetErrors((nRowCounter + 1), 3, "", "Invalid PAN Number", "", "PAN", objRowsColumns[0])
                            };
                            m_nExcelsheetUIValidationsErrors[i_sExcelSheetName] = excelSheetErrors;
                            return tblMassUploadDataTable;
                        }
                    }
                    else if ((userTypeCodeId == 101003 || userTypeCodeId == 101004 || userTypeCodeId == 101006) && i_sExcelSheetName.Contains("OnGoingContDisc"))
                    {
                        string value = Convert.ToString(objRowsColumns[1]);
                        bool isValid = userList.Any(c => c.Equals(value));
                        if (!isValid)
                        {
                            lstResponse.Add(new MassUploadResponseDTO(-999, Convert.ToString(value) + " is not valid value"));
                            bErrorInRow = true;
                            AddSheetWiseErrors(i_sExcelSheetName, lstResponse);
                            m_bErrorPresentInExcelSheets = true;
                            List<MassUploadExcelSheetErrors> excelSheetErrors = new List<MassUploadExcelSheetErrors>
                            {
                                new MassUploadExcelSheetErrors((nRowCounter + 1), 2, "", "Invalid User Name", "", "UserName", objRowsColumns[0])
                            };
                            m_nExcelsheetUIValidationsErrors[i_sExcelSheetName] = excelSheetErrors;
                            return tblMassUploadDataTable;
                        }
                    }

                    objRowsTemp = objRowsColumns;
                    DataRow objDataTableRow = tblMassUploadDataTable.NewRow();
                    iCounter = 0;

                    if (objRowsColumns != null && !bErrorInRow)
                    {
                        foreach (object objData in objRowsColumns)
                        {
                            int? iColumnWithCode = objColsWithCodes.ContainsKey(iCounter) ? (int?)objColsWithCodes[iCounter] : null;

                            if (iColumnWithCode != null)
                            {
                                if (iColumnWithCode == -1) //FetchAllRoleNames the company CodesDTO from company name
                                {
                                    if (Convert.ToString(objData) != null && Convert.ToString(objData) != "")
                                    {
                                        if (m_objCompanyNamesDisct.ContainsKey(Convert.ToString(objData).ToLower()))
                                            objDataTableRow[lstDataTableProperties[iCounter]] = m_objCompanyNamesDisct[Convert.ToString(objData).ToLower()];
                                        else
                                        {
                                            lstResponse.Add(new MassUploadResponseDTO(-999, Convert.ToString(objData) + " is not valid value"));
                                            bErrorInRow = true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        objDataTableRow[lstDataTableProperties[iCounter]] = System.DBNull.Value;
                                    }
                                }
                                else if (iColumnWithCode == -2) //Fetch the Role id from the role name
                                {
                                    if (Convert.ToString(objData) != null && Convert.ToString(objData) != "")
                                    {
                                        if (m_objRolesNameWiseDisct.ContainsKey(Convert.ToString(objData).ToLower()))
                                            objDataTableRow[lstDataTableProperties[iCounter]] = m_objRolesNameWiseDisct[Convert.ToString(objData).ToLower()];
                                        else
                                        {
                                            lstResponse.Add(new MassUploadResponseDTO(-999, Convert.ToString(objData) + " is not valid value"));
                                            bErrorInRow = true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        objDataTableRow[lstDataTableProperties[iCounter]] = System.DBNull.Value;
                                    }
                                }
                                else
                                {
                                    if (Convert.ToString(objData) != null && Convert.ToString(objData) != "")
                                    {
                                        if (m_objCodesNameWiseDisct.ContainsKey((Convert.ToString(objData) + "_" + Convert.ToString(objColsWithCodes[iCounter])).ToLower()))
                                            objDataTableRow[lstDataTableProperties[iCounter]] = m_objCodesNameWiseDisct[Convert.ToString(objData).ToLower() + "_" + Convert.ToString(objColsWithCodes[iCounter])];
                                        else
                                        {
                                            lstResponse.Add(new MassUploadResponseDTO(-999, Convert.ToString(objData) + " is not valid value"));
                                            bErrorInRow = true;
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        objDataTableRow[lstDataTableProperties[iCounter]] = System.DBNull.Value;
                                    }
                                }
                            }
                            else
                            {
                                if (objData != null && (objData.ToString() == "" || objData.ToString() == "null"))
                                {
                                    objDataTableRow[lstDataTableProperties[iCounter]] = lstColumnWiseDefaultValues[iCounter];
                                }
                                else
                                {
                                    objDataTableRow[lstDataTableProperties[iCounter]] = objData;
                                }
                            }

                            iCounter++;
                        }
                    }
                    else
                    {
                        bErrorInRow = true;
                        lstResponse.Add(null);
                    }
                    if (!bErrorInRow)
                    {
                        tblMassUploadDataTable.Rows.Add(objDataTableRow);
                        lstResponse.Add(new MassUploadResponseDTO(0, ""));
                    }
                    else
                    {
                        AddSheetWiseRemovedParentRows(i_sExcelSheetName, nRowCounter - 2);
                    }
                    nRowCounter++;
                }
                AddSheetWiseErrors(i_sExcelSheetName, lstResponse);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return tblMassUploadDataTable;

        }
        #endregion CreateDataTable

        #region ExecuteMassUploadCall
        /// <summary>
        /// This function will give a call to upload the mass uploaded records in database.
        /// </summary>
        /// <param name="i_objMassUploadDataTable"></param>
        /// <param name="i_sDataTableName"></param>
        /// <param name="i_sProcedureName"></param>
        /// <param name="i_sConnectionString"></param>
        /// <param name="o_objResponseList"></param>
        public void ExecuteMassUploadCall(int i_nMassuploadType, DataTable i_objMassUploadDataTable, string i_sDataTableName, string i_sProcedureName, string i_sConnectionString,
           int LoggedInUserID,out List<MassUploadResponseDTO> o_objResponseList, out string o_sSheetErrorMessageCode)
        {
            //MassUploadDAL objMassUploadDAL = new MassUploadDAL();
            o_objResponseList = new List<MassUploadResponseDTO>();
            try
            {
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    objMassUploadDAL.ExecuteMassUploadCall(i_nMassuploadType, i_objMassUploadDataTable, i_sDataTableName, i_sProcedureName, i_sConnectionString,
                        LoggedInUserID,out o_objResponseList, out o_sSheetErrorMessageCode);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion

        #region fillExcelWithDependantData for dependent sheets
        /// <summary>
        /// This function will be used for filling the related column values with the actual values for the dependent sheets to be saved
        /// </summary>
        public void fillExcelWithDependantData(string i_sCopyFromSheetName, string i_sCopyToSheet, int i_nCopyToColumnNo,
            Dictionary<string, List<List<string>>> i_objCurrentDataFromExcelSheet, int nMassUploadExcelId,
            out Dictionary<string, List<List<string>>> o_objReturnDataFromExcelSheet)
        {
            List<List<string>> objReturnDataFromExcelSheet = new List<List<string>>();
            o_objReturnDataFromExcelSheet = new Dictionary<string, List<List<string>>>();
            List<MassUploadResponseDTO> lstParentResponse = new List<MassUploadResponseDTO>();
            if (m_objMassUploadExcelResponseSheetList.ContainsKey(i_sCopyFromSheetName))
            {
                lstParentResponse = m_objMassUploadExcelResponseSheetList[i_sCopyFromSheetName].ResponseList;
            }
            if ((lstParentResponse.Count == 0 && nMassUploadExcelId == Convert.ToInt32(MASSUPLOADEXCELSHEET.PASTTRANSACTION)) || lstParentResponse.Count > 0)
            {
                List<int> lstRemovedRows = new List<int>();

                if (m_objMassUploadExcelSheetRemovedRowsList.ContainsKey(i_sCopyFromSheetName))
                    lstRemovedRows = m_objMassUploadExcelSheetRemovedRowsList[i_sCopyFromSheetName];
                List<int> lstRemovedRowsList = new List<int>();
                try
                {

                    //foreach (KeyValuePair<string, List<List<string>>> objExcelSheet in i_objCurrentDataFromExcelSheet)
                    //{
                    //Dictionary<string, List<List<string>>>  objExcelSheet = m_objExcelSheetWiseData[i_sCopyToSheet];
                    int RowCounter = 0;
                    List<List<string>> objCurrentDataFromExcelSheet = m_objExcelSheetWiseData[i_sCopyToSheet];
                    foreach (List<string> lstRow in objCurrentDataFromExcelSheet)
                    {
                        if (lstRow[i_nCopyToColumnNo] == "")
                        {
                            lstRow[i_nCopyToColumnNo] = "null";
                            objReturnDataFromExcelSheet.Add(lstRow);
                        }
                        else
                        {
                            if (!lstRemovedRows.Contains(Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1))
                            {
                                if (lstParentResponse.Count > (Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1) && lstParentResponse[Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1] == null)
                                {
                                    lstRemovedRowsList.Add(RowCounter);
                                    objReturnDataFromExcelSheet.Add(null);
                                }
                                else
                                {
                                    if (lstParentResponse.Count > (Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1) && lstParentResponse[Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1].ErrorCode == 0 && lstParentResponse[Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1].ReturnValue == 0)
                                    {
                                        lstRow[i_nCopyToColumnNo] = lstParentResponse[Convert.ToInt32(lstRow[i_nCopyToColumnNo]) - 1].MassUploadResponseId;
                                        objReturnDataFromExcelSheet.Add(lstRow);
                                    }
                                    else
                                    {
                                        objReturnDataFromExcelSheet.Add(lstRow);
                                    }
                                }
                            }
                            else
                            {
                                lstRemovedRowsList.Add(RowCounter);
                                objReturnDataFromExcelSheet.Add(null);
                                //Add the child sheet row in the corresponding removed row list

                            }
                        }
                        RowCounter++;
                    }

                    objCurrentDataFromExcelSheet = null;

                    if (objReturnDataFromExcelSheet.Count > 0)
                    {
                        o_objReturnDataFromExcelSheet[i_sCopyToSheet] = objReturnDataFromExcelSheet;
                    }
                    else
                    {
                        o_objReturnDataFromExcelSheet[i_sCopyToSheet] = new List<List<string>>();
                    }

                    //}
                    m_objMassUploadExcelSheetRemovedRowsList[i_sCopyToSheet] = lstRemovedRowsList;
                }
                catch (Exception exp)
                {
                    throw exp;
                }
            }

        }
        #endregion fillExcelWithDependantData for dependent sheets

        #region CheckIfErrorExistInExcelSheets
        /// <summary>
        /// This will return the boolean variable which specifies if atleast one excel sheet contains error
        /// </summary>
        /// <returns></returns>
        public bool CheckIfErrorExistInExcelSheets()
        {
            return m_bErrorPresentInExcelSheets;
        }
        #endregion CheckIfErrorExistInExcelSheets

        #region GetExcelSheetWiseErrors
        /// <summary>
        /// This function will return the sheet wise error, to be shown on the screen and to be written in excel to be downloaded.
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, List<MassUploadExcelSheetErrors>> GetExcelSheetWiseErrors()
        {
            return m_nExcelsheetUIValidationsErrors;
        }
        #endregion GetExcelSheetWiseErrors

        #region ExecuteMassUploadCall
        /// <summary>
        /// This will get the datatable created and then will actually give the petapoco call to execute the said procedure.
        /// </summary>
        /// <param name="o_sSheetErrorMessage"></param>
        /// <param name="o_objSheetWiseErrors">This is a dictionary containing row wise errors for wash record in each sheet. 
        /// The key is the sheet name in which error has occurred.
        /// </param>
        //public void ExecuteMassUploadCall(out string o_sSheetErrorMessage, out Dictionary<string, List<MassUploadResponseDTO>> o_objSheetWiseErrors)
        public void ExecuteMassUploadCall()
        {
            DataTable objMassUploadDataTable = null;
            MassUploadExcelSheets objMassUploadExcelSheets = null;
            Dictionary<string, List<List<string>>> objDataFromExcelSheet = null;
            Dictionary<string, List<List<string>>> objDependentUpdatedDataFromParentExcelSheet = null;
            string sErrorMessageCode = "";
            //o_sSheetErrorMessage = "";
            bool bSheetPresent = true;
            try
            {
                //o_objSheetWiseErrors = new Dictionary<string,List<MassUploadResponseDTO>>();
                FetchConfigurationData();
                FetchAllCodes();
                FetchAllCompanyNames();
                FetchAllRoleNames();
                GetAllResourcesForCompany();

                ReadExcelFileIntoCollection();

                ManageAllValidationsForAllSheets();
                ValidateAllExcelSheets();

                //Dictionary<string,string> objSheetWiseExcelError = getSheetInvlaidColumnErrors();
                if (!m_bErrorPresentInExcelSheets)
                {
                    foreach (KeyValuePair<string, MassUploadExcelSheets> objExcelSheet in m_objMassUploadExcelSheetList)
                    {
                        string sExcelSheetName = objExcelSheet.Key;
                        objMassUploadExcelSheets = objExcelSheet.Value;
                        int nMassUploadExcelSheetId = objMassUploadExcelSheets.MassUploadExcelSheetId;
                        objDataFromExcelSheet = new Dictionary<string, List<List<string>>>();
                        if (m_objExcelSheetWiseData.ContainsKey(sExcelSheetName))
                        {
                            objDataFromExcelSheet = m_objExcelSheetWiseData;
                            bSheetPresent = true;
                        }
                        else
                        {
                            objDataFromExcelSheet = new Dictionary<string, List<List<string>>>();
                            bSheetPresent = false;
                        }
                        List<MassUploadResponseDTO> objResponseList = new List<MassUploadResponseDTO>();

                        //objDataFromExcelSheet = FetchDataFromExcelSheet(sExcelSheetName, out bSheetPresent);
                        //objDataFromExcelSheet = m_objExcelSheetWiseData[sExcelSheetName];

                        if (bSheetPresent)
                        {
                            if (objMassUploadExcelSheets.ParentSheetName != null)
                            {
                                objDependentUpdatedDataFromParentExcelSheet = new Dictionary<string, List<List<string>>>();
                                fillExcelWithDependantData(objMassUploadExcelSheets.ParentSheetName, sExcelSheetName, objMassUploadExcelSheets.ColumnNoToUpdateFromParent, objDataFromExcelSheet
                                    , nMassUploadExcelSheetId, out objDependentUpdatedDataFromParentExcelSheet);
                                if (objDependentUpdatedDataFromParentExcelSheet.ContainsKey(sExcelSheetName))
                                    objDataFromExcelSheet[sExcelSheetName] = objDependentUpdatedDataFromParentExcelSheet[sExcelSheetName];
                                else
                                    objDataFromExcelSheet[sExcelSheetName] = new List<List<string>>();
                            }
                            if (objDataFromExcelSheet[sExcelSheetName].Count > 0)
                            {
                                objMassUploadDataTable = CreateDataTable(sExcelSheetName, objMassUploadExcelSheets.DataTableColumnMapping[sExcelSheetName], objDataFromExcelSheet[sExcelSheetName]);
                                ExecuteMassUploadCall(objMassUploadExcelSheets.MassUploadExcelSheetId, objMassUploadDataTable, objMassUploadDataTable.TableName, objMassUploadExcelSheets.ProcedureUsed,
                                     m_sConnectionString, m_nLoggedInUserID, out objResponseList, out sErrorMessageCode);
                                objMassUploadExcelSheets.ResponseList = objResponseList;
                                m_objMassUploadExcelResponseSheetList[sExcelSheetName] = objMassUploadExcelSheets;

                                #region Update the Sheet and row wise Serverside exceptions
                                List<MassUploadExcelSheetErrors> objResponsesForError = new List<MassUploadExcelSheetErrors>();
                                if (m_nExcelsheetUIValidationsErrors.ContainsKey(sExcelSheetName))
                                {
                                    int nCount = objMassUploadDataTable.Rows.Count;

                                    objResponsesForError = m_nExcelsheetUIValidationsErrors[sExcelSheetName];
                                    if (nCount > 0 && objResponsesForError.Count > 0)
                                    {
                                        HttpContext.Current.Session["PartialError"] = 1;
                                    }
                                }
                                int nResponceCounter = 1;//First row from the excel is ignored as header row
                                foreach (MassUploadResponseDTO objResponceDTO in objResponseList)
                                {
                                    if (objResponceDTO.ReturnValue != 0)
                                    {
                                        string sErrorMessage = getResource(Convert.ToString(objResponceDTO.ReturnValue));
                                        if (sErrorMessage == "")
                                        {
                                            sErrorMessage = objResponceDTO.ErrorMessage;
                                        }
                                        objResponsesForError.Add(new MassUploadExcelSheetErrors(nResponceCounter + 1, 0, Convert.ToString(objResponceDTO.ReturnValue), sErrorMessage, "", "", ""));
                                        m_bErrorPresentInExcelSheets = true;
                                    }
                                    nResponceCounter++;
                                }
                                m_nExcelsheetUIValidationsErrors[sExcelSheetName] = objResponsesForError;
                                #endregion Update the Sheet and row wise Serverside exceptions

                                //Add null entries for the records which were removed because of invalid data
                                if (m_objMassUploadExcelSheetRemovedRowsList.ContainsKey(sExcelSheetName))
                                {
                                    List<int> removedRows = m_objMassUploadExcelSheetRemovedRowsList[sExcelSheetName];
                                    foreach (int nRemovedRow in removedRows)
                                    {
                                        objResponseList.Insert(nRemovedRow, null);
                                    }
                                    int nErrorRowCounter = 0;
                                    foreach (MassUploadResponseDTO objResponseDTO in objResponseList)
                                    {
                                        //The value for Errorcode is set to -999 if the data added in the columns, which has Com codes associated with it, contains incorrect data
                                        if (objResponseDTO != null && ((objResponseDTO.ErrorCode < 0) || (objResponseDTO.ReturnValue < 0)))
                                        {
                                            removedRows.Add(nErrorRowCounter);
                                        }
                                        nErrorRowCounter++;
                                    }
                                    m_objMassUploadExcelSheetRemovedRowsList[sExcelSheetName] = removedRows;
                                }

                                //this call will only be given when excel sheet named EmployeeInfo is getting imported. This if for adding the hascode for the successfully added 
                                //user records. This will be used by the communication module for creating the url to be sent in the Welcome email for the newly created user.
                                if (nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.EMPLOYEEINSIDER) ||
                                    nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.NONEMPLOYEEINSIDER) ||
                                    nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.CORPORATEINSIDER))
                                {
                                    int nUserTypeCodeId = 0;
                                    if (nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.EMPLOYEEINSIDER))
                                    {
                                        nUserTypeCodeId = ConstEnum.UserTypeCodeId.EmployeeType;
                                    }
                                    else if (nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.NONEMPLOYEEINSIDER))
                                    {
                                        nUserTypeCodeId = ConstEnum.UserTypeCodeId.NonEmployeeType;
                                    }
                                    else if (nMassUploadExcelSheetId == Convert.ToInt32(MASSUPLOADEXCELSHEET.CORPORATEINSIDER))
                                    {
                                        nUserTypeCodeId = ConstEnum.UserTypeCodeId.CorporateUserType;
                                    }

                                    UserInfoSL objUserSL = new UserInfoSL();
                                    int nRowCounter = 2;
                                    foreach (MassUploadResponseDTO objResponseDTO in objResponseList)
                                    {
                                        if (objResponseDTO != null && (objResponseDTO.ErrorCode == 0 && objResponseDTO.ErrorMessage == ""))
                                        { }
                                        else
                                        {
                                            AddSheetWiseRemovedParentRows(sExcelSheetName, nRowCounter - 2);
                                        }
                                        nRowCounter++;
                                    }
                                    //Generate the Hash code for all the newly added users to be used for sending the Set Password link in the Welcome email
                                    GenerateHashStringsForUsers(objResponseList, m_sConnectionString, m_sCurrentCompanyDBName, m_sEncryptionSaltValue, nUserTypeCodeId);
                                }
                                AddSheetWiseErrors(sExcelSheetName, objResponseList);
                            }
                            objResponseList = null;
                            objResponseList = new List<MassUploadResponseDTO>();
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        #endregion

        #region Generate HashString For Employees
        /// <summary>
        /// This function is used for generating the Hash Code for the users created during Mass Upload. The Hash code will be saved in 
        /// usr_UserResetPassword table.
        /// </summary>
        /// <param name="i_lstEmployeeList"></param>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sCompanyDBName"></param>
        /// <param name="i_sEncryptionSalt"></param>
        /// <param name="i_nUserTypeCodeId"></param>
        private void GenerateHashStringsForUsers(List<MassUploadResponseDTO> i_lstEmployeeList, string i_sConnectionString, string i_sCompanyDBName,
            string i_sEncryptionSalt, int i_nUserTypeCodeId)
        {
            DataTable tblHashCodeDataTable = null;
            string sDataTableName = "dbo.EmployeeHashCode";
            //UserInfoSL objUserSL = new UserInfoSL();
            //MassUploadDAL objMassUploadDAL = new MassUploadDAL();
            Dictionary<int, UserInfoDTO> lstUserList = new Dictionary<int, UserInfoDTO>();
            try
            {
                tblHashCodeDataTable = new DataTable(sDataTableName);
                tblHashCodeDataTable.Columns.Add(new DataColumn("LoginId", GetTypeOf("string")));
                tblHashCodeDataTable.Columns.Add(new DataColumn("HashCode", GetTypeOf("string")));
                //Fetch all the users with given user type for requcing the query for each userinfoid
                lstUserList = GetSelectedUserTypeList(i_sConnectionString, i_nUserTypeCodeId);
                foreach (MassUploadResponseDTO objMassUploadResponseDTO in i_lstEmployeeList)
                {
                    if (objMassUploadResponseDTO != null && (objMassUploadResponseDTO.ErrorCode == 0 && objMassUploadResponseDTO.ErrorMessage == ""))
                    {
                        UserInfoDTO objSelectedUserDTO = lstUserList[Convert.ToInt32(objMassUploadResponseDTO.MassUploadResponseId)];
                        string sUserLoginName = objSelectedUserDTO.LoginID;
                        InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
                        string sHashCode = objPwdHash.CreateHash(sUserLoginName + i_sCompanyDBName, i_sEncryptionSalt);
                        DataRow objDataTableRow = tblHashCodeDataTable.NewRow();
                        objDataTableRow["LoginId"] = sUserLoginName;
                        objDataTableRow["HashCode"] = sHashCode;
                        tblHashCodeDataTable.Rows.Add(objDataTableRow);
                    }
                }
                lstUserList = new Dictionary<int, UserInfoDTO>();//Free the resources once used
                using (var objMassUploadDAL = new MassUploadDAL())
                {
                    objMassUploadDAL.GenerateHashCodesForUsers(i_sConnectionString, tblHashCodeDataTable);
                }
                tblHashCodeDataTable = null;
            }
            catch (Exception exp)
            {
                string message = exp.Message;
            }
        }
        #endregion Generate HashString For Employees

        #region Get Select User Type List
        /// <summary>
        /// This function will return a Dictionary containing key as the UserInfoId and the value as the UserInfoIdDTO
        /// </summary>
        /// <param name="i_nUserTypeCodeId"></param>
        public Dictionary<int, UserInfoDTO> GetSelectedUserTypeList(string i_sConnectionString, int i_nUserTypeCodeId)
        {
            Dictionary<int, UserInfoDTO> lstUsersList = new Dictionary<int, UserInfoDTO>();
            //UserInfoDAL objUserInfoDAL = new UserInfoDAL();
            List<UserInfoDTO> lstUserInfoDTO;
            try
            {
                using (var objUserInfoDAL = new UserInfoDAL())
                {
                    lstUserInfoDTO = objUserInfoDAL.FetchUserTypeList(i_sConnectionString, i_nUserTypeCodeId);
                }
                foreach (UserInfoDTO objUserInfoDTO in lstUserInfoDTO)
                {
                    lstUsersList[objUserInfoDTO.UserInfoId] = objUserInfoDTO;
                }
                lstUserInfoDTO = null;
            }
            catch (Exception exp)
            {
                string sMessage = exp.Message;
            }
            return lstUsersList;
        }
        #endregion Get Select User Type List



        #region WriteErrorsToExcel
        /// <summary>
        /// This function will be called when all the excel sheets have been processed. The errors created during import 
        /// of the records from various sheets from the excel, i.e. from m_objSheetWiseError collection, will be written to 
        /// an excel and will be available for download.
        /// This function will return the guid for the file name containing the error report.
        /// </summary>
        public string WriteErrorsToExcel(string i_sExportDocumentFolderPath, string i_sDocumentFolderPath)
        {

            int nRowCounter = 1;
            int nExcelRowCounter = 1;
            bool sErrorOccurred = true;
            string sTmpFileName = m_sUploadedFileGUID + "_Error";
            ArrayList arrColumnWidth = new ArrayList();

            Dictionary<string, List<MassUploadExcelSheetErrors>> objSheetWiseErrors = m_nExcelsheetUIValidationsErrors;

            InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject objCommonOpenXMLObject;
            objCommonOpenXMLObject = new InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject();
            objCommonOpenXMLObject.OpenFile(i_sExportDocumentFolderPath + sTmpFileName + ".xlsx", true);
            objCommonOpenXMLObject.OpenXMLObjectCreation();
            objCommonOpenXMLObject.OpenXMLCreateWorkSheetPartSheetData();
            arrColumnWidth.Add("1:40:25");
            objCommonOpenXMLObject.AssignColumnWidth(arrColumnWidth);


            foreach (string sKey in objSheetWiseErrors.Keys)
            {
                List<MassUploadExcelSheetErrors> objSheetResponse = objSheetWiseErrors[sKey];
                if (objSheetResponse != null && objSheetResponse.Count > 0)
                {
                    #region Add Sheet Name
                    objCommonOpenXMLObject.CreateNewRow(nExcelRowCounter);
                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], "Excel Sheet Name:" + sKey, nExcelRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS);
                    nExcelRowCounter++;
                    objCommonOpenXMLObject.AddToSheetData();
                    #endregion

                    #region Add the column headers

                    objCommonOpenXMLObject.CreateNewRow(nExcelRowCounter);
                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], ERROR_EXCEL_COLUMN1_HEADER, nExcelRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS);
                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], ERROR_EXCEL_COLUMN2_HEADER, nExcelRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS);
                    objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[3], ERROR_EXCEL_COLUMN3_HEADER, nExcelRowCounter,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS);
                    nExcelRowCounter++;
                    objCommonOpenXMLObject.AddToSheetData();

                    #endregion






                    m_objMassUploadExcelResponseSheetList = null;
                    m_objMassUploadExcelSheetRemovedRowsList = null;
                    m_objMassUploadExcel = null;
                    m_objMassUploadExcelSheets = null;
                    m_objMassUploadExcelSheetList = null;
                    m_lstMassUploadSheets = null;
                    m_objSheetRelatedColumnMapping = null;
                    m_objMassUploadExcelResponseSheetList = null;
                    m_objMassUploadExcelSheetRemovedRowsList = null;
                    m_objCodesDTOList = null;
                    m_objCodesNameWiseDisct = null;
                    m_objCompanyNamesDTOList = null;
                    m_objCompanyNamesDisct = null;
                    m_objRolesDTOList = null;
                    m_objRolesNameWiseDisct = null;
                    m_objSheetWiseError = null;

                    m_objSheetWiseDependentValueColumns = null;
                    m_objSheetWiseDependentColumns = null;
                    m_objSheetWiseMasterCodeColumns = null;
                    m_objSheetWiseRoleColumns = null;
                    m_objSheetWiseCompanyColumns = null;
                    m_objSheetWiseMinLengthColumns = null;
                    m_objSheetWiseMaxLengthColumns = null;
                    m_objSheetWiseRegExpression = null;
                    m_objSheetWiseRequiredColumns = null;
                    m_objSheetWiseColumnsNames = null;
                    m_objExcelData = null;
                    m_objCodesDTOList = null;
                    m_objCodesNameWiseDisct = null;
                    m_objCompanyNamesDTOList = null;
                    m_objCompanyNamesDisct = null;
                    m_objRolesDTOList = null;
                    m_objRolesNameWiseDisct = null;
                    GC.Collect();
                    GC.WaitForFullGCComplete();



                    nRowCounter = 2;//First row is reserved for the column headers so it starts from 2
                    foreach (MassUploadExcelSheetErrors objRowResponse in objSheetResponse)
                    {
                        if (objRowResponse != null)
                        {
                            objCommonOpenXMLObject.CreateNewRow(nExcelRowCounter);
                            if (objRowResponse.sRowSequenceNumber == "")
                            {
                                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], Convert.ToString(objRowResponse.nRowNumber), nExcelRowCounter,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            }
                            else
                            {
                                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], Convert.ToString(objRowResponse.nRowNumber) + "(" + objRowResponse.sRowSequenceNumber + ")", nExcelRowCounter,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            }
                            if (objRowResponse.nExcelColumnName == "")
                            {
                                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], Convert.ToString(objRowResponse.sErrorColumnName), nExcelRowCounter,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            }
                            else
                            {
                                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], Convert.ToString(objRowResponse.sErrorColumnName) + "(" + objRowResponse.nExcelColumnName + ")", nExcelRowCounter,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            }
                            objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[3], Convert.ToString(objRowResponse.sResourceMessage), nExcelRowCounter,
                                (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            nExcelRowCounter++;
                            objCommonOpenXMLObject.AddToSheetData();
                        }
                        nRowCounter++;
                    }
                }
                objSheetResponse = null;
                objSheetResponse = new List<MassUploadExcelSheetErrors>();
            }
            if (sErrorOccurred)
            {
                objCommonOpenXMLObject.OpenXMLWorksheetAssignment(MASSUPLOAD_ERROR_EXCEL_SHEET_NAME, "", false);
                objCommonOpenXMLObject.SaveWorkSheet();
                objCommonOpenXMLObject.CloseSpreadSheet();

                System.IO.File.Copy(i_sExportDocumentFolderPath + sTmpFileName + ".xlsx", i_sDocumentFolderPath + "MassUploadError/" + sTmpFileName + ".xlsx");
            }
            else
            {
                sTmpFileName = "";
            }

            return sTmpFileName;
        }
        #endregion

        #region getSheetWiseErrors
        public Dictionary<string, List<MassUploadResponseDTO>> getSheetWiseErrors()
        {
            return m_objSheetWiseError;
        }
        #endregion getSheetWiseErrors

        #region AddSheetWiseRemovedParentRows
        private void AddSheetWiseRemovedParentRows(string i_sParentSheetName, int i_nRemovedRowNo)
        {
            List<int> lstRemovedRowNumberList = new List<int>();
            if (m_objMassUploadExcelSheetRemovedRowsList.ContainsKey(i_sParentSheetName))
            {
                lstRemovedRowNumberList = m_objMassUploadExcelSheetRemovedRowsList[i_sParentSheetName];
                if (!lstRemovedRowNumberList.Contains(i_nRemovedRowNo))
                {
                    lstRemovedRowNumberList.Add(i_nRemovedRowNo);
                }
                m_objMassUploadExcelSheetRemovedRowsList[i_sParentSheetName] = lstRemovedRowNumberList;
            }
            else
            {
                lstRemovedRowNumberList.Add(i_nRemovedRowNo);
                m_objMassUploadExcelSheetRemovedRowsList.Add(i_sParentSheetName, lstRemovedRowNumberList);
            }
            lstRemovedRowNumberList = null;
        }
        #endregion AddSheetWiseRemovedParentRows

        #region AddSheetWiseErrors
        private void AddSheetWiseErrors(string i_sSheetName, List<MassUploadResponseDTO> i_lstErrorObjectList)
        {
            if (m_objSheetWiseError.ContainsKey(i_sSheetName))
            {
                List<MassUploadResponseDTO> lstExistingSheetResponseList = m_objSheetWiseError[i_sSheetName];
                List<MassUploadResponseDTO> lstUpdatedList = new List<MassUploadResponseDTO>();

                if (lstExistingSheetResponseList.Count > 0)
                {
                    int nCounter = 0;
                    foreach (MassUploadResponseDTO objMassUploadResponceDTO in lstExistingSheetResponseList)
                    {
                        if (objMassUploadResponceDTO != null && objMassUploadResponceDTO.ErrorCode == -999)
                        {
                            lstUpdatedList.Add(objMassUploadResponceDTO);
                        }
                        else
                        {
                            if (i_lstErrorObjectList.Count > 0)
                                lstUpdatedList.Add(i_lstErrorObjectList[nCounter]);
                        }
                        nCounter++;
                    }
                }
                //lstExistingSheetResponseList.AddRange(i_lstErrorObjectList);
                m_objSheetWiseError[i_sSheetName] = lstUpdatedList;
                lstUpdatedList = null;
            }
            else
            {
                m_objSheetWiseError.Add(i_sSheetName, i_lstErrorObjectList);
            }

        }
        #endregion

        #region GetTypeOf
        /// <summary>
        /// This method will return the type of the data based on the given string
        /// </summary>
        /// <param name="i_sTypeString"></param>
        /// <returns></returns>
        /// 
        private System.Type GetTypeOf(string i_sTypeString)
        {
            try
            {
                if (i_sTypeString.ToLower() == "int")
                {
                    return typeof(int);
                }
                else if (i_sTypeString.ToLower() == "string")
                {
                    return typeof(string);
                }
                else if (i_sTypeString.ToLower() == "datetime")
                {
                    return typeof(DateTime);
                }
                else if (i_sTypeString.ToLower() == "decimal")
                {
                    return typeof(decimal);
                }
                else if (i_sTypeString.ToLower() == "float")
                {
                    return typeof(float);
                }
                else if (i_sTypeString.ToLower() == "bigint")
                {
                    return typeof(Int64);
                }
                else
                {
                    return null;
                }
            }
            catch (Exception exp)
            {
                return null;
            }
        }
        #endregion GetTypeOf

        #region GetDataTableName
        /// <summary>
        /// This function will be used for getting the table name for given Datatable id
        /// </summary>
        /// <param name="i_nDataTableId"></param>
        /// <returns></returns>
        public string GetDataTableName(int i_nDataTableId)
        {
            //MassUploadDAL objMassUploadDAL = new MassUploadDAL();
            using (var objMassUploadDAL = new MassUploadDAL())
            {
                return objMassUploadDAL.GetDataTableName(i_nDataTableId, m_sConnectionString);
            }
        }
        #endregion GetDataTableName

        #region SetExcelFilePath
        public void SetExcelFilePath(string i_sExcelFilePath)
        {
            m_sExcelFileFullPath = i_sExcelFilePath;
        }
        #endregion SetExcelFilePath
        #region GetRnTMassuploadDayCount
        /// <summary>
        /// This function will be used for getting current date massupload count
        /// </summary>
        /// <param name="i_nDataTableId"></param>
        /// <returns></returns>
        public int GetRnTMassuploadDayCount(string sConnectionString)
        {
            //MassUploadDAL objMassUploadDAL = new MassUploadDAL();
            using (var objMassUploadDAL = new MassUploadDAL())
            {
                return objMassUploadDAL.GetRnTMassuploadDayCount(sConnectionString);
            }
        }
        #endregion GetDataTableName

        #region GetMassCounter
        /// <summary>
        /// This function will be used for getting current date massupload count
        /// </summary>
        /// <param name="i_nDataTableId"></param>
        /// <returns></returns>
        public int GetMassCounter(string sConnectionString)
        {
            //MassUploadDAL objMassUploadDAL = new MassUploadDAL();
            using (var objMassUploadDAL = new MassUploadDAL())
            {
                return objMassUploadDAL.GetMassCounter(sConnectionString);
            }
        }
        #endregion GetDataTableName

        #region GetSequenceMassUploadList
        /// <summary>
        /// This function will return sequenced mass uploads list
        /// </summary>
        /// <param name="lstMassUploadDTO"></param>
        /// <returns></returns>
        public List<MassUploadDTO> GetSequenceMassUploadList(List<MassUploadDTO> lstMassUploadDTO)
        {
            try
            {
                bool isDataAvailable = lstMassUploadDTO.Any(c => c.MassUploadExcelId == 57);
                if (isDataAvailable)
                {
                    var initialDisclosure = lstMassUploadDTO.First(c => c.MassUploadName == "Initial Disclosure Mass Upload - Other Securities");
                    int oneposition = lstMassUploadDTO.FindIndex(c => c.MassUploadName == "Initial Disclosure Mass Upload");
                    lstMassUploadDTO.Remove(initialDisclosure);
                    lstMassUploadDTO.Insert(oneposition + 1, initialDisclosure);
                }

                bool isOngoingAvailable = lstMassUploadDTO.Any(c => c.MassUploadExcelId == 58);
                if (isOngoingAvailable)
                {
                    var continuousDisclosure = lstMassUploadDTO.FirstOrDefault(c => c.MassUploadName == "On Going Continuous Disclosure Mass Upload - Other Securities");
                    int secondPosition = lstMassUploadDTO.FindIndex(c => c.MassUploadName == "On Going Continuous Disclosure Mass Upload");
                    lstMassUploadDTO.Remove(continuousDisclosure);
                    lstMassUploadDTO.Insert(secondPosition + 1, continuousDisclosure);
                }
            }
            catch (Exception exp)
            {

            }
            return lstMassUploadDTO;
        }
        #endregion GetSequenceMassUploadList

        #region GetUploadMassList
        /// <summary>
        /// This function will return list of upload mass uploads list
        /// </summary>
        /// <param name="lstMassUploadDTO"></param>
        /// <returns></returns>
        public List<MassUploadDTO> GetUploadMassList(List<MassUploadDTO> lstMassUploadDTO, bool isOwnUnable, bool isOtherEnable, int userTypeCodeId)
        {
            try
            {
                if (userTypeCodeId == 101004 || userTypeCodeId == 101006)
                {
                    lstMassUploadDTO = lstMassUploadDTO.Where(c => c.MassUploadExcelId == 2 || c.MassUploadExcelId == 5).ToList();
                }
                else if (isOwnUnable && isOtherEnable)
                {
                    lstMassUploadDTO = lstMassUploadDTO.Where(c => c.MassUploadExcelId == 2 || c.MassUploadExcelId == 5 || c.MassUploadExcelId == 57 || c.MassUploadExcelId == 58).ToList();
                }
                else if (isOwnUnable)
                {
                    lstMassUploadDTO = lstMassUploadDTO.Where(c => c.MassUploadExcelId == 2 || c.MassUploadExcelId == 5).ToList();
                }
                else if (isOtherEnable)
                {
                    lstMassUploadDTO = lstMassUploadDTO.Where(c => c.MassUploadExcelId == 57 || c.MassUploadExcelId == 58).ToList();
                }
            }
            catch (Exception exp)
            {

            }
            return lstMassUploadDTO;
        }
        #endregion 

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            m_lstMassUploadSheets = null;
            m_objExcelSheetWiseData = null;
            m_objMassUploadExcelResponseSheetList = null;
            m_objMassUploadExcelSheetRemovedRowsList = null;
            m_objMassUploadExcel = null;
            m_objMassUploadExcel = null;
            m_objMassUploadExcelSheets = null;
            m_objMassUploadExcelSheetList = null;
            m_lstMassUploadSheets = null;
            m_objSheetRelatedColumnMapping = null;
            m_objMassUploadExcelResponseSheetList = null;
            m_objMassUploadExcelSheetRemovedRowsList = null;
            m_objCodesDTOList = null;
            m_objCodesNameWiseDisct = null;
            m_objCompanyNamesDTOList = null;
            m_objCompanyNamesDisct = null;
            m_objRolesDTOList = null;
            m_objRolesNameWiseDisct = null;
            m_objSheetWiseError = null;


            m_objSheetWiseDependentValueColumns = null;
            m_objSheetWiseDependentColumns = null;
            m_objSheetWiseMasterCodeColumns = null;
            m_objSheetWiseRoleColumns = null;
            m_objSheetWiseCompanyColumns = null;
            m_objSheetWiseMinLengthColumns = null;
            m_objSheetWiseMaxLengthColumns = null;
            m_objSheetWiseRegExpression = null;
            m_objSheetWiseRequiredColumns = null;
            m_objSheetWiseColumnsNames = null;
            m_objExcelData = null;
            m_objCodesDTOList = null;
            m_objCodesNameWiseDisct = null;
            m_objCompanyNamesDTOList = null;
            m_objCompanyNamesDisct = null;
            m_objRolesDTOList = null;
            m_objRolesNameWiseDisct = null;
            GC.SuppressFinalize(this);
            GC.Collect();
            GC.WaitForPendingFinalizers();
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
            m_lstMassUploadSheets = null;
            m_objExcelSheetWiseData = null;
            m_objMassUploadExcelResponseSheetList = null;
            m_objMassUploadExcelSheetRemovedRowsList = null;
            m_objMassUploadExcel = null;
            m_objMassUploadExcelSheets = null;
            m_objMassUploadExcelSheetList = null;
            m_lstMassUploadSheets = null;
            m_objSheetRelatedColumnMapping = null;
            m_objMassUploadExcelResponseSheetList = null;
            m_objMassUploadExcelSheetRemovedRowsList = null;
            m_objCodesDTOList = null;
            m_objCodesNameWiseDisct = null;
            m_objCompanyNamesDTOList = null;
            m_objCompanyNamesDisct = null;
            m_objRolesDTOList = null;
            m_objRolesNameWiseDisct = null;
            m_objSheetWiseError = null;

            m_objSheetWiseDependentValueColumns = null;
            m_objSheetWiseDependentColumns = null;
            m_objSheetWiseMasterCodeColumns = null;
            m_objSheetWiseRoleColumns = null;
            m_objSheetWiseCompanyColumns = null;
            m_objSheetWiseMinLengthColumns = null;
            m_objSheetWiseMaxLengthColumns = null;
            m_objSheetWiseRegExpression = null;
            m_objSheetWiseRequiredColumns = null;
            m_objSheetWiseColumnsNames = null;
            m_objExcelData = null;
            m_objCodesDTOList = null;
            m_objCodesNameWiseDisct = null;
            m_objCompanyNamesDTOList = null;
            m_objCompanyNamesDisct = null;
            m_objRolesDTOList = null;
            m_objRolesNameWiseDisct = null;
            GC.SuppressFinalize(this);
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }

        #endregion
    }

    #region Class Declarations
    #region MassUploadExcel Declaration
    /// <summary>
    /// This object will contain the information of the excel columns and its mapping with the DataTable properties
    /// </summary>
    public class MassUploadExcel
    {
        public int MassUploadExcelId { get; set; }
        public string MassUploadName { get; set; }
        public bool HasMultipleSheet { get; set; }
    }
    #endregion MassUploadExcel Declaration

    #region MassUploadExcelSheets Declaration
    public class MassUploadExcelSheets
    {
        public int MassUploadExcelSheetId { get; set; }
        public int MassUploadExcelId { get; set; }
        public string SheetName { get; set; }
        public bool IsPrimarySheet { get; set; }
        public string ProcedureUsed { get; set; }
        public string ParentSheetName { get; set; }
        public int ColumnNoToUpdateFromParent { get; set; }
        public Dictionary<string, List<MassUploadExcelDataTableColumnMapping>> DataTableColumnMapping { get; set; }
        public Dictionary<string, List<object>> ExcelRowWiseData { get; set; }
        public List<MassUploadResponseDTO> ResponseList { get; set; }
        public int ColumnCount { get; set; }
    }
    #endregion MassUploadExcelSheets Declaration

    #region MassUploadExcelDataTableColumnMapping Declaration
    public class MassUploadExcelDataTableColumnMapping
    {
        public int MassUploadExcelDataTableColumnMappingId { get; set; }
        public int MassUploadExcelSheetId { get; set; }
        public int ExcelColumnNo { get; set; }
        public int MassUploadDataTableId { get; set; }
        public int MassUploadDataTablePropertyNo { get; set; }
        public string MassUploadDataTablePropertyName { get; set; }
        public string MassUploadDataTablePropertyDataType { get; set; }
        public string MassUploadDataTablePropertySataSize { get; set; }
        public int RelatedMassUploadExcelSheetId { get; set; }
        public int RelatedMassUploadExcelSheetColumnNo { get; set; }
        public int? ApplicableDataCodeGroupId { get; set; }
        public bool IsRequired { get; set; }
        public string ValidationRegExpress { get; set; }
        public int MaxLength { get; set; }
        public int MinLength { get; set; }
        public string IsRequiredErrorCode { get; set; }
        public string ValidationRegExpErrorcode { get; set; }
        public string MaxLengthErrorCode { get; set; }
        public string MinLengthErrorCode { get; set; }
        public int? DependentColumnNumber { get; set; }
        public string DependentColumnErrorCode { get; set; }
        public int? DependentValueColumnNumber { get; set; }
        public string DependentValueColumnValue { get; set; }
        public string DependentValueColumnErrorCode { get; set; }
        public string DefaultValue { get; set; }
    }
    #endregion MassUploadExcelDataTableColumnMapping Declaration

    #region MassUploadExcelSheetErrors
    /// <summary>
    /// This will hold the error related information for the sheet.
    /// </summary>
    public class MassUploadExcelSheetErrors
    {
        public int nRowNumber;
        public int nColumnCount;
        public string nResourceCode;
        public string sResourceMessage;
        public string sErrorRowKeyColumnValue;
        public string sErrorColumnName;
        public string sRowSequenceNumber;
        public string nExcelColumnName;

        public MassUploadExcelSheetErrors(int i_nRowNo, int i_nColumnCount, string i_sResourceCode, string i_sResourceMessage,
                string i_sErrorRowKeyColumnValue, string i_sErrorColumnName, string sRowSequenceNumber)
        {
            this.nRowNumber = i_nRowNo;
            this.nColumnCount = i_nColumnCount;
            this.nResourceCode = i_sResourceCode;
            this.sResourceMessage = i_sResourceMessage;
            this.sErrorRowKeyColumnValue = i_sErrorRowKeyColumnValue;
            this.sErrorColumnName = i_sErrorColumnName;
            this.sRowSequenceNumber = sRowSequenceNumber;
            if (i_nColumnCount != 0)
            {
                EXCELColumnNumber enumDisplayStatus = (EXCELColumnNumber)(i_nColumnCount - 1);
                this.nExcelColumnName = enumDisplayStatus.ToString();
            }
        }
    }
    #endregion MassUploadExcelSheetErrors
    #endregion

    public class MassUploadConditionalWiseValidations
    {
        /// <summary>
        /// This function will be used for perform additional validations for the Initial Disclosure type Mass Upload.
        /// These validations are specific to this type of mass upload only.
        /// </summary>
        public static void ValidationsForInitialDisclosureMassUpload
            (List<List<string>> i_lstExcelSheetData, List<string> i_lstColumnNames, ref List<MassUploadExcelSheetErrors> o_lstMassUploadExcelSheetErrors)
        {
            try
            {
                int nRowCounter = 1;//There is one header row present so
                int SECURITYTYPE_COLUMN_NO = 4;
                int LOTSIZE = 12; 

                List<MassUploadExcelSheetErrors> lstErrors = new List<MassUploadExcelSheetErrors>();

                foreach (List<string> drRecordRow in i_lstExcelSheetData)
                {
                    string sRowSequenceNumber = Convert.ToString(drRecordRow[0]).Trim();
                    object[] objRowArray = drRecordRow.ToArray<object>();

                    if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "future contracts" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "option contracts")
                    {
                        if (objRowArray[LOTSIZE].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (LOTSIZE + 1), "", "The " + i_lstColumnNames[LOTSIZE] + " is a required.", "", i_lstColumnNames[LOTSIZE], sRowSequenceNumber));
                        }
                    }
                    nRowCounter++;
                }
                if (lstErrors.Count > 0)
                {
                    o_lstMassUploadExcelSheetErrors.AddRange(lstErrors);
                }
            }
            catch (Exception exp)
            {
                string sErrorMessage = exp.Message;
            }
        }
        /// <summary>
        /// This function will be used for perform additional validations for the Continuous Disclosure type Mass Upload.
        /// These validations are specific to this type of mass upload
        /// </summary>
        public static void ValidationsForPastPreclearanceAndTransactionsMassUpload
            (List<List<string>> i_lstExcelSheetData, List<string> i_lstColumnNames, ref List<MassUploadExcelSheetErrors> o_lstMassUploadExcelSheetErrors)
        {
            try
            {
                int nRowCounter = 1;//There is one header row present so
                int SECURITYTYPE_COLUMN_NO = 12;
                int TRANSACTION_TYPE = 11;
                int QUANTITY1 = 15;//This is used in case of Cashless
                int VALUE1 = 16;
                int QUANTITY2 = 17;
                int VALUE2 = 18;
                int PREPERCENT = 13;
                int POSTPERCENT = 14;
                int LOTSIZE = 19;
                int CONTRACTSPECIFICATION = 20;

                List<MassUploadExcelSheetErrors> lstErrors = new List<MassUploadExcelSheetErrors>();

                foreach (List<string> drRecordRow in i_lstExcelSheetData)
                {
                    string sRowSequenceNumber = Convert.ToString(drRecordRow[0]).Trim();
                    object[] objRowArray = drRecordRow.ToArray<object>();

                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless all" || objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless partial")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (QUANTITY2 + 1), "", "The " + i_lstColumnNames[QUANTITY2] + " is a required.", "", i_lstColumnNames[QUANTITY2], sRowSequenceNumber));
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (VALUE2 + 1), "", "The " + i_lstColumnNames[VALUE2] + " is a required.", "", i_lstColumnNames[VALUE2], sRowSequenceNumber));
                        }
                    }


                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless all")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() != "")
                        {
                            int nQuantity1 = Convert.ToInt32(objRowArray[QUANTITY1].ToString());
                            int nQuantity2 = Convert.ToInt32(objRowArray[QUANTITY2].ToString());
                            if (nQuantity1 != nQuantity2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[QUANTITY1] + " should be equal to " + i_lstColumnNames[QUANTITY2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() != "")
                        {
                            int nValue1 = Convert.ToInt32(objRowArray[VALUE1].ToString());
                            int nValue2 = Convert.ToInt32(objRowArray[VALUE2].ToString());
                            if (nValue1 != nValue2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[VALUE1] + " should be equal to " + i_lstColumnNames[VALUE2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                    }

                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless partial")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() != "")
                        {
                            int nQuantity1 = Convert.ToInt32(objRowArray[QUANTITY1].ToString());
                            int nQuantity2 = Convert.ToInt32(objRowArray[QUANTITY2].ToString());
                            if (nQuantity1 >= nQuantity2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[QUANTITY1] + " should be greater than " + i_lstColumnNames[QUANTITY2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() != "")
                        {
                            int nValue1 = Convert.ToInt32(objRowArray[VALUE1].ToString());
                            int nValue2 = Convert.ToInt32(objRowArray[VALUE2].ToString());
                            if (nValue1 >= nValue2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[VALUE1] + " should be greater than " + i_lstColumnNames[VALUE2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                    }


                    if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "equity shares" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "preference shares" ||
                        objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "convertible debentures" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "shares" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "warrants")
                    {
                        //Removed by Raghvendra on request from Deepak on 5-Feb-2016 on Phone
                        //if (objRowArray[PREPERCENT].ToString().ToLower() == "")
                        //{
                        //    lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (PREPERCENT + 1), "", "The " + i_lstColumnNames[PREPERCENT] + " is a required.", "", i_lstColumnNames[PREPERCENT], sRowSequenceNumber));
                        //}
                        //if (objRowArray[POSTPERCENT].ToString().ToLower() == "")
                        //{
                        //    lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (POSTPERCENT + 1), "", "The " + i_lstColumnNames[POSTPERCENT] + " is a required.", "", i_lstColumnNames[POSTPERCENT], sRowSequenceNumber));
                        //}
                    }
                    else if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "future contracts" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "option contracts")
                    {
                        if (objRowArray[LOTSIZE].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (LOTSIZE + 1), "", "The " + i_lstColumnNames[LOTSIZE] + " is a required.", "", i_lstColumnNames[LOTSIZE], sRowSequenceNumber));
                        }
                        if (objRowArray[CONTRACTSPECIFICATION].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (CONTRACTSPECIFICATION + 1), "", "The " + i_lstColumnNames[CONTRACTSPECIFICATION] + " is a required.", "", i_lstColumnNames[CONTRACTSPECIFICATION], sRowSequenceNumber));
                        }
                    }
                    nRowCounter++;
                }
                if (lstErrors.Count > 0)
                {
                    o_lstMassUploadExcelSheetErrors.AddRange(lstErrors);
                }
            }
            catch (Exception exp)
            {
                string sErrorMessage = exp.Message;
            }
        }

        /// <summary>
        /// This function will be used for perform additional validations for the Continuous Disclosure type Mass Upload.
        /// These validations are specific to this type of mass upload
        /// 
        /// </summary>
        public static void ValidationsForOnGoingContinuousDisclosureMassUpload
            (List<List<string>> i_lstExcelSheetData, List<string> i_lstColumnNames, ref List<MassUploadExcelSheetErrors> o_lstMassUploadExcelSheetErrors)
        {
            try
            {
                int nRowCounter = 1;//There is one header row present so
                int SECURITYTYPE_COLUMN_NO = 11;
                int TOTAL_QUANTITY_COLUMN_NO = 14;//This is used in case of non Cashless
                int QUANTITY1 = 14;//This is used in case of Cashless
                int VALUE1 = 15;
                int ESOPQUANTITY_COLUMN_NO = 16;
                int OTHERQUANTITY_COLUMN_NO = 17;
                int TRANSACTION_TYPE = 10;
                int QUANTITY2 = 18;
                int VALUE2 = 19;
                int PREPERCENT = 12;
                int POSTPERCENT = 13;
                int LOTSIZE = 20;
                int CONTRACTSPECIFICATION = 21;

                List<MassUploadExcelSheetErrors> lstErrors = new List<MassUploadExcelSheetErrors>();

                foreach (List<string> drRecordRow in i_lstExcelSheetData)
                {
                    string sRowSequenceNumber = Convert.ToString(drRecordRow[0]).Trim();
                    object[] objRowArray = drRecordRow.ToArray<object>();
                    if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "equity shares" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "shares")
                    {
                        if (objRowArray[ESOPQUANTITY_COLUMN_NO].ToString() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (ESOPQUANTITY_COLUMN_NO + 1), "", "The " + i_lstColumnNames[ESOPQUANTITY_COLUMN_NO] + " is a required.", "", i_lstColumnNames[ESOPQUANTITY_COLUMN_NO], sRowSequenceNumber));
                        }
                        if (objRowArray[OTHERQUANTITY_COLUMN_NO].ToString() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (OTHERQUANTITY_COLUMN_NO + 1), "", "The " + i_lstColumnNames[OTHERQUANTITY_COLUMN_NO] + " is a required.", "", i_lstColumnNames[OTHERQUANTITY_COLUMN_NO], sRowSequenceNumber));
                        }
                        if (objRowArray[ESOPQUANTITY_COLUMN_NO].ToString() != "" && objRowArray[OTHERQUANTITY_COLUMN_NO].ToString() != "")
                        {
                            int nTotalQuantity = Convert.ToInt32(objRowArray[TOTAL_QUANTITY_COLUMN_NO]);
                            int nESOPQuantity = Convert.ToInt32(objRowArray[ESOPQUANTITY_COLUMN_NO]);
                            int nOtherQuantity = Convert.ToInt32(objRowArray[OTHERQUANTITY_COLUMN_NO]);
                            if (nTotalQuantity != (nESOPQuantity + nOtherQuantity))
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The Sum of " + i_lstColumnNames[ESOPQUANTITY_COLUMN_NO] + " and " + i_lstColumnNames[OTHERQUANTITY_COLUMN_NO] + " should be equal to " + i_lstColumnNames[TOTAL_QUANTITY_COLUMN_NO], "", "", sRowSequenceNumber));
                            }
                        }
                    }
                    else
                    {
                        if (objRowArray[ESOPQUANTITY_COLUMN_NO].ToString() != "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (ESOPQUANTITY_COLUMN_NO + 1), "", "The " + i_lstColumnNames[ESOPQUANTITY_COLUMN_NO] + " is a required only when " + i_lstColumnNames[SECURITYTYPE_COLUMN_NO] + " contains " + objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() + ".", "", i_lstColumnNames[ESOPQUANTITY_COLUMN_NO], sRowSequenceNumber));
                        }
                        if (objRowArray[OTHERQUANTITY_COLUMN_NO].ToString() != "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (OTHERQUANTITY_COLUMN_NO + 1), "", "The " + i_lstColumnNames[ESOPQUANTITY_COLUMN_NO] + " is a required only when " + i_lstColumnNames[SECURITYTYPE_COLUMN_NO] + " contains " + objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() + ".", "", i_lstColumnNames[OTHERQUANTITY_COLUMN_NO], sRowSequenceNumber));
                        }
                    }
                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless all" || objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless partial")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (QUANTITY2 + 1), "", "The " + i_lstColumnNames[QUANTITY2] + " is a required.", "", i_lstColumnNames[QUANTITY2], sRowSequenceNumber));
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (VALUE2 + 1), "", "The " + i_lstColumnNames[VALUE2] + " is a required.", "", i_lstColumnNames[VALUE2], sRowSequenceNumber));
                        }
                    }

                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless all")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() != "")
                        {
                            int nQuantity1 = Convert.ToInt32(objRowArray[QUANTITY1].ToString());
                            int nQuantity2 = Convert.ToInt32(objRowArray[QUANTITY2].ToString());
                            if (nQuantity1 != nQuantity2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[QUANTITY1] + " should be equal to " + i_lstColumnNames[QUANTITY2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() != "")
                        {
                            int nValue1 = Convert.ToInt32(objRowArray[VALUE1].ToString());
                            int nValue2 = Convert.ToInt32(objRowArray[VALUE2].ToString());
                            if (nValue1 != nValue2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[VALUE1] + " should be equal to " + i_lstColumnNames[VALUE2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                    }

                    if (objRowArray[TRANSACTION_TYPE].ToString().ToLower() == "cashless partial")
                    {
                        if (objRowArray[QUANTITY2].ToString().ToLower() != "")
                        {
                            int nQuantity1 = Convert.ToInt32(objRowArray[QUANTITY1].ToString());
                            int nQuantity2 = Convert.ToInt32(objRowArray[QUANTITY2].ToString());
                            if (nQuantity1 >= nQuantity2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[QUANTITY1] + " should be greater than " + i_lstColumnNames[QUANTITY2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                        if (objRowArray[VALUE2].ToString().ToLower() != "")
                        {
                            int nValue1 = Convert.ToInt32(objRowArray[VALUE1].ToString());
                            int nValue2 = Convert.ToInt32(objRowArray[VALUE2].ToString());
                            if (nValue1 >= nValue2)
                            {
                                lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), 0, "", "The " + i_lstColumnNames[VALUE1] + " should be greater than " + i_lstColumnNames[VALUE2] + ".", "", "", sRowSequenceNumber));
                            }
                        }
                    }

                    if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() != "equity shares" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() != "shares")
                    {

                        if (objRowArray[PREPERCENT].ToString().ToLower() != "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (PREPERCENT + 1), "", "The " + i_lstColumnNames[PREPERCENT] + " is not applicable for this security.", "", i_lstColumnNames[PREPERCENT], sRowSequenceNumber));
                        }
                        if (objRowArray[POSTPERCENT].ToString().ToLower() != "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (POSTPERCENT + 1), "", "The " + i_lstColumnNames[POSTPERCENT] + " is not applicable for this security.", "", i_lstColumnNames[POSTPERCENT], sRowSequenceNumber));
                        }
                    }
                    if (objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "future contracts" || objRowArray[SECURITYTYPE_COLUMN_NO].ToString().ToLower() == "option contracts")
                    {
                        if (objRowArray[LOTSIZE].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (LOTSIZE + 1), "", "The " + i_lstColumnNames[LOTSIZE] + " is a required.", "", i_lstColumnNames[LOTSIZE], sRowSequenceNumber));
                        }
                        if (objRowArray[CONTRACTSPECIFICATION].ToString().ToLower() == "")
                        {
                            lstErrors.Add(new MassUploadExcelSheetErrors((nRowCounter + 1), (CONTRACTSPECIFICATION + 1), "", "The " + i_lstColumnNames[CONTRACTSPECIFICATION] + " is a required.", "", i_lstColumnNames[CONTRACTSPECIFICATION], sRowSequenceNumber));
                        }
                    }
                    nRowCounter++;
                }
                if (lstErrors.Count > 0)
                {
                    o_lstMassUploadExcelSheetErrors.AddRange(lstErrors);
                }
            }
            catch (Exception exp)
            {
                string sErrorMessage = exp.Message;
            }
        }
    }
}