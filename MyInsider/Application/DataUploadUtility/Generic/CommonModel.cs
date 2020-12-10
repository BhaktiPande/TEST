using InsiderTrading;
using InsiderTrading.SL;
using InsiderTradingDAL;
using SFTPFileDownload.AppData;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace DataUploadUtility.Generic
{
    class CommonModel
    {
        #region Collection Objects
        public static Hashtable HT_Modules = new Hashtable();
        #endregion
        #region constant general variabls
        public const string s_SelectStatement = "SELECT * FROM [{0}$]";
        public const string s_StarLine = "/*********************************************************************************************************************/";
        public const string s_LogfileCompanyName = "Log file for company: {0}";
        public const string s_LogfileGeneratedOn = "Generated on: {0}";
        public const string s_LookUpPrefix = "usr_msg_";
        public const string s_FieldCannotBlank = "{0} cannot be blank.";
        public const string s_ErrorMessage = "Error message: {0}";
        public const string s_Start = "Start";
        public const string s_OperErrorMessage = "Cannot perform operation due to internal error";
        public static StringBuilder sbString = new StringBuilder();
        public static bool b_IsErrorOccured = false;

        /* Stored procedure names */
        public static string s_SP_GetEmployeeDetails = "st_du_GetEmployeeDetails";
        public static string s_SP_GetOnGngDiscDetails = "st_du_OnGoingContDiscData";
        public static string s_SP_GetOnGngDiscDetails_Esop = "st_du_OnGoingContDiscData_Esop";

        /* Table type names */
        public static string s_TPYE_EmployeeDetailsAxisBank = "@EmployeeDetailsAxisBank";
        public static string s_TPYE_OnGngDiscDetails = "@OnGoingContDiscData";
        public static string s_TPYE_OnGngDiscDetails_Esop = "@OnGoingContDiscData_Esop";

        public const string s_AXISDIRECTFEED = "AXISDIRECTFEED";
        public const string s_ESOPDIRECTFEED = "ESOPDIRECTFEED";
        public const string s_HRMS = "HRMS";
        public const string s_KARVY = "KARVY";
        #endregion

        #region constant ResourceID
        public const string s_ResID_GetEmail = "50037";
        public const string s_ResID_GetCompDetails = "50038";
        public const string s_ResID_DownloadExcel = "50039";
        public const string s_ResID_GetMappingDetails = "50040";
        public const string s_ResID_ErrorMappingDetails = "50041";
        public const string s_ResID_ErrorMappingFields = "50042";
        public const string s_ResID_GetMappingFields = "50043";
        public const string s_ResID_ErrorPrepareColumns = "50044";
        public const string s_ResID_ErrorPrepareRowsAndUpload = "50045";
        public const string s_ResID_UploadedSuccessfully = "50046";
        public const string s_ResID_ReadMappings = "50047";
        public const string s_ResID_ReadExcelOrQuery = "50048";
        public const string s_ResID_MappingFields = "50049";
        public const string s_ResID_MappingFieldsComplited = "50050";
        public const string s_ResID_DataUploading = "50051";
        public const string s_ResID_DataUploadingCompleted = "50052";
        public const string s_ResID_TotalTimeTaken = "50053";
        #endregion

        #region Get Company Details
        /// <summary>
        /// This method is used to get single company connection string
        /// </summary>
        /// <param name="s_CompanyName">string: Name of the company</param>
        /// <returns>CompanyDTO</returns>
        public static CompanyDTO GetCompanyDetials(string s_CompanyName)
        {
            CompaniesSL objCompanySL = new CompaniesSL();
            InsiderTradingDAL.CompanyDTO objSelectedCompany = objCompanySL.getSingleCompanies(CommonModel.getSystemConnectionString(), s_CompanyName);
            return objSelectedCompany;
        }
        #endregion

        #region getSystemConnectionString
        /// <summary>
        /// This function will return the Connection string for the system database which is mentioned in the Web.config file
        /// </summary>
        /// <returns>string</returns>
        public static string getSystemConnectionString()
        {
            try
            {
                return ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            }
            catch
            {

            }
            return string.Empty;
        }
        #endregion getSystemConnectionString

        #region Get Resource Message For Selected Company
        /// <summary>
        /// This method is used to get all Resource
        /// </summary>
        /// <param name="s_sConnectionString">string: connection string</param>
        /// <param name="o_lstResources">out Dictionary: Resources list</param>
        public static void getResource(string s_sConnectionString, out Dictionary<string, string> o_lstResources)
        {
            ResourcesSL resourcesSL = new ResourcesSL();
            resourcesSL.GetAllResources(s_sConnectionString, out o_lstResources);
        }
        #endregion Get Resource Message For Selected Company

        #region Common Methods
        /// <summary>
        /// This method is used to get connection string object
        /// </summary>
        /// <param name="s_FilePath">string: Source File path</param>
        /// <returns>string: ConnectionString</returns>
        public static string GetConnectionString(string s_FilePath)
        {
            Dictionary<string, string> o_Dictionary = new Dictionary<string, string>();
            o_Dictionary["Provider"] = "Microsoft.ACE.OLEDB.12.0";
            o_Dictionary["Extended Properties"] = "Excel 12.0 XML";
            o_Dictionary["Data Source"] = s_FilePath;

            StringBuilder sb_StringBuilder = new StringBuilder();
            foreach (KeyValuePair<string, string> prop in o_Dictionary)
            {
                sb_StringBuilder.Append(prop.Key);
                sb_StringBuilder.Append('=');
                sb_StringBuilder.Append(prop.Value);
                sb_StringBuilder.Append(';');
            }

            return sb_StringBuilder.ToString();
        }

        /// <summary>
        /// This method is used for check SSO login hash matching or not.
        /// </summary>
        /// <param name="o_SFTPFileProperties">SFTPFileProperties</param>
        /// <param name="n_case">Encryption algorithum selection 1: SHA 1 Encryption algorithum</param>
        /// <returns>string</returns>
        public static string EncryptedKey(SFTPFileProperties o_SFTPFileProperties, int n_case)
        {
            string s_input = o_SFTPFileProperties.s_HostName + o_SFTPFileProperties.s_UserName + o_SFTPFileProperties.s_Password + o_SFTPFileProperties.n_PortNumber + o_SFTPFileProperties.s_SshHostKeyFingerprint;
            string s_returnValue = string.Empty;
            switch (n_case)
            {
                //SHA 1 Encryption algorithum
                case 1:
                    using (SHA1 SHA1Hasher = SHA1.Create())
                    {
                        byte[] data1 = SHA1Hasher.ComputeHash(Encoding.Default.GetBytes(s_input));
                        StringBuilder returnValue = new StringBuilder(data1.Length * 2);
                        for (int i = 0; i < data1.Length; i++)
                        {
                            returnValue.Append(data1[i].ToString("X2"));
                        }
                        s_returnValue = returnValue.ToString();
                    }
                    break;
            }
            return s_returnValue.ToUpper();
        }
        #endregion
		
		#region Static Variables
        public static DateTime d_StartDate = new DateTime();
        public static DateTime d_EndDate = new DateTime();
		#endregion
    }
}
