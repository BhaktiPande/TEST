using LogLibraryClass;
using System;

namespace ESOP.SSO.Library
{
    public class WriteLog : IDisposable
    {
        /// <summary>
        /// Here Use LogLibraryClass (for write log in Database and file) Which is developed by ESOP Direct.
        /// </summary>
        public LogHelper logHelper = new LogHelper();

        #region Implementation of Singleton Pattern
        /// <summary>
        /// This is a singleton Pattern used for CommonMethods
        /// </summary>
        private static WriteLog _instance;
        /// <summary>
        /// Constructor of CommonMethods class
        /// </summary>
        public WriteLog()
        {
            // TODO: Add constructor logic here        
        }

        /// <summary>
        /// Destructors of Generic class
        /// </summary>
        ~WriteLog()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a WriteToFileLog class
        /// </summary>
        /// <returns>returning the instance of an object</returns>       
        public static WriteLog Instance()
        {
            if (_instance == null)
            {
                _instance = new WriteLog();
            }
            return _instance;
        }

        #endregion

        #region Write Log in DataBase
        /// <summary>
        /// Write Log message in DataBase
        /// </summary>
        /// <param name="message"></param>
        public void WriteLogInDb(LogHelper logHelperData)
        {
            logHelper = new LogHelper();
            logHelper.logProp.dataBaseConnectionString = Generic.Instance().ConnectionStringValue;
            logHelper.logProp.UserId = logHelperData.logProp.UserId;
            logHelper.logProp.logTarget = LogTarget.Database;
            logHelper.logProp.logLevel = logHelperData.logProp.logLevel;
            logHelper.logProp.Message = logHelperData.logProp.Message;
            logHelper.logProp.Stacks = logHelperData.logProp.Stacks;
            LogHelper.Log(logHelper.logProp);
        }
        #endregion

        #region Write Log in DataBase
        /// <summary>
        /// Write Log message in Text File.
        /// </summary>
        /// <param name="message"></param>
        public void WriteLogInFile(LogHelper logHelperData)
        {
            string logFilePath = Generic.Instance().SsoLogFilePath; // ConfigurationManager.AppSettings["SSOLogStoreLocation"].ToString(); // This Path getting from main Config file of main application
            logHelper = new LogHelper();
            logHelper.logProp.filePath = logFilePath;
            logHelper.logProp.UserId = logHelperData.logProp.UserId;
            logHelper.logProp.logTarget = LogTarget.File;
            logHelper.logProp.logLevel = logHelperData.logProp.logLevel;
            logHelper.logProp.Message = logHelperData.logProp.Message;
            logHelper.logProp.Stacks = logHelperData.logProp.Stacks;
            LogHelper.Log(logHelper.logProp);
        }
        #endregion
        private void SaveLogInTargetLocation()
        {
            string targetLocation = Generic.Instance().SsoLogStoreLocation.ToLower();
            if (targetLocation == "sqldatabase")
            {
                WriteLogInDb(logHelper);
            }
            else if (targetLocation == "textfileandsqldatabase")
            {
                WriteLogInDb(logHelper);
                WriteLogInFile(logHelper);

            }
            else
            {
                WriteLogInFile(logHelper);
            }
        }

        public void ExceptionErrorLog(Exception ex)
        {
            logHelper.logProp.logLevel = LogLevel.ERROR;
            logHelper.logProp.Message = ex.Message;
            logHelper.logProp.Stacks = ex.StackTrace;
            logHelper.logProp.UserId = "";
            SaveLogInTargetLocation();
        }

        public void CustomErrorLog(string errorMessage)
        {
            logHelper.logProp.logLevel = LogLevel.ERROR;
            logHelper.logProp.Message = errorMessage;
            logHelper.logProp.Stacks = "";
            logHelper.logProp.UserId = "";
            SaveLogInTargetLocation();
        }

        public void InfoLog(string infoMessage)
        {
            logHelper.logProp.logLevel = LogLevel.INFO;
            logHelper.logProp.Message = infoMessage;
            logHelper.logProp.Stacks = "";
            logHelper.logProp.UserId = "";
            SaveLogInTargetLocation();
        }


        #region Implementing IDisposible
        /// <summary>
        /// Method to Dispose the class
        /// </summary>
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }

        #endregion
    }
}
