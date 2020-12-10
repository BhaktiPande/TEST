using System;
using System.IO;
using System.Web;
using System.Web.Configuration;

namespace InsiderTradingSSO.Common
{
    public class Common
    {
        #region getSystemConnectionString
        /// <summary>
        /// This function will return the Connection string for the system database which is mentioned in the Web.config file
        /// </summary>
        /// <returns></returns>
        public static string getSystemConnectionString()
        {
            string sSystemDBConnectionString = "";
            try
            {
                sSystemDBConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            }
            catch (Exception exp)
            {

            }

            return sSystemDBConnectionString;
        }
        #endregion getSystemConnectionString

        #region Write Debug Log to File
        /// <summary>
        /// This method is used to write debug log to file. Log will be written when debug flag is set true in web config
        /// </summary>         
        public static void WriteLogToFile(string sLogMessage, Exception ObjException = null)
        {
            CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

            string LogFilePath = System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs");

            string LogFileName = "SSOLog_" + string.Format("{0:ddMMMMyyyy}", DateTime.Now) + ".txt";

            string LogSperator = " \t ";
            string LogString = "";

            try
            {

                LogString += sLogMessage + LogSperator;

                if (ObjException != null)
                {
                    LogString += "Exception Message - " + ObjException.Message + LogSperator;
                    LogString += "Exception Trace - " + ObjException.ToString() + LogSperator;
                }

                //check if debug is true
                if (compilationSection.Debug == true)
                {
                    //check and create debug folder, if not exists, to write log
                    if (!Directory.Exists(LogFilePath))
                    {
                        Directory.CreateDirectory(LogFilePath);
                    }

                    // write log into file
                    using (FileStream objFileStream = new FileStream(Path.Combine(LogFilePath, LogFileName), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter objStreamWriter = new StreamWriter(objFileStream);

                        objStreamWriter.WriteLine(LogString);

                        objStreamWriter.Close();
                        objStreamWriter.Dispose();

                        objFileStream.Close();
                        objFileStream.Dispose();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                compilationSection = null;
            }
        }
        #endregion Write Debug Log to File

        #region Set Session Value
        /// <summary>
        /// This method is used to Set value into session.
        /// </summary>
        /// <param name="i_SessionKey"></param>
        /// <param name="i_sSessionValue"></param>
        public static void SetSessionValue(string i_sSessionKey, object i_sSessionValue)
        {
            try
            {
                HttpContext.Current.Session[i_sSessionKey] = i_sSessionValue;
            }
            catch
            {
            }
        }

        #endregion Set Session Value
    }
}