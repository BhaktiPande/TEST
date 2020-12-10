using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;

namespace InsiderTrading.Common
{
    /// <summary>
    /// This Class is used to write all the log messages into a file.
    /// </summary>
    public class WriteToFileLog : IDisposable
    {
        #region private declaration
        private static string _companyName = string.Empty;

        private const string _star = "*";

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string Star
        {
            get { return _star; }
        }

        private const string _hyphen = "-";

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string Hyphen
        {
            get { return _hyphen; }
        }

        private const string _start = "START";

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string Start
        {
            get { return _start; }
        }

        private const string _end = "END";

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string End
        {
            get { return _end; }
        }

        private const string _close = "CLOSE";

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string Close
        {
            get { return _close; }
        }

        /// <summary>
        /// Public varaible with string DataType
        /// </summary>
        public string FileName
        {
            get { return _fileName; }
        }

        private static string _filePath = string.Empty;
        private static string _fileName = string.Empty;

        #endregion

        #region Implementation of Singleton Pattern

        /// <summary>
        /// This is a singleton Pattern used for CommonMethods
        /// </summary>

        private static WriteToFileLog _instance;

        /// <summary>
        /// Constructor of CommonMethods class
        /// </summary>

        public WriteToFileLog()
        {
            // TODO: Add constructor logic here        
        }

        /// <summary>
        /// Destructors of Generic class
        /// </summary>

        ~WriteToFileLog()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a WriteToFileLog class
        /// </summary>
        /// <param name="perCompany">Need to pass the perCompany Datarw for whom the log need to maintain</param>
        /// <returns>returning the instance of an object</returns>       
        public static WriteToFileLog Instance(string perCompany)
        {
            if (_instance == null)
            {
                _instance = new WriteToFileLog();
            }
            if (!_companyName.Equals(perCompany.ToString()))
            {

                if (!Directory.Exists(ConfigurationManager.AppSettings["SSOLogfilePath"].ToString() + @"\" + perCompany.ToString()))
                    Directory.CreateDirectory(ConfigurationManager.AppSettings["SSOLogfilePath"].ToString() + @"\" + perCompany.ToString());

                _companyName = perCompany.ToString();
            }
			_fileName = @"\SSOLogs_" + DateTime.Now.ToString("dd") + "_" + DateTime.Now.ToString("MMM") + "_" + DateTime.Now.ToString("yyyy") + ".log";

            if (string.IsNullOrEmpty(_filePath))
                _filePath = ConfigurationManager.AppSettings["SSOLogfilePath"].ToString() + @"\" + perCompany.ToString() + _fileName;

            return _instance;
        }

        #endregion

        /// <summary>
        /// This Method is used to write the detailed log messages
        /// </summary>
        /// <param name="Message">message the you need to log in the log file (* = print star, START = start the log message for a company, END = end the log message for a company, CLOSE = to close the log file, else message that you need to log in a file</param>
        public void Write(string Message)
        {
            switch (Message.ToUpper())
            {
                case _star:
                    File.AppendAllText(_filePath, "***********************************************************\n");
                    break;

                case _start:
                    File.AppendAllText(_filePath, "************************ " + _companyName + " Started at " + DateTime.Now.ToString("dd") + "_" + DateTime.Now.ToString("MMM") + "_" + DateTime.Now.ToString("yyyy") + "_" + DateTime.Now.ToString("hh") + ":" + DateTime.Now.ToString("mm") + ":" + DateTime.Now.ToString("ss") + ":" + DateTime.Now.ToString("tt") + " ************************ \n");
                    break;

                case _end:
                    File.AppendAllText(_filePath, "************************ " + _companyName + " Ended at " + DateTime.Now.ToString("dd") + "_" + DateTime.Now.ToString("MMM") + "_" + DateTime.Now.ToString("yyyy") + "_" + DateTime.Now.ToString("hh") + ":" + DateTime.Now.ToString("mm") + ":" + DateTime.Now.ToString("ss") + ":" + DateTime.Now.ToString("tt") + " ************************ \n");
                    File.AppendAllText(_filePath, "");
                    break;

                case _hyphen:
                    File.AppendAllText(_filePath, "----------------------------------------------------------------------------------------------------------------------\n");
                    break;

                default:
                    File.AppendAllText(_filePath, "  " + Message + "\n");
                    break;
            }
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