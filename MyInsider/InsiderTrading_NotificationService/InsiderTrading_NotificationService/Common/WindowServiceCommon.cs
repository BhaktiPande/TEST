using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
   public  class WindowServiceCommon
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
                throw exp;
            }

            return sSystemDBConnectionString;
        }
        #endregion getSystemConnectionString

        #region GetTimeDurationInMilliSeconds
        /// <summary>
        /// Gets the time duration in milli seconds
        /// </summary>
        /// <param name="i_nTimeDuration">The time duration which must be converted to milli seconds</param>
        /// <param name="i_enTimeDurationType">Duration Type (Second, Minutes, Hours etc) in which param 'i_nTimeDuration' is specified</param>
        /// <returns>The time converted to milliseconds</returns>
        public static int GetTimeDurationInMilliSeconds(int i_nTimeDuration, InsiderTrading_NotificationService.WindowServiceConstEnum.TimeDurationType i_enTimeDurationType)
        {
            int nTimeDurationInMilliSeconds = 10000;//Default the time duration to 10secs
            try
            {

                switch (i_enTimeDurationType)
                {
                    case WindowServiceConstEnum.TimeDurationType.Days:
                        nTimeDurationInMilliSeconds = i_nTimeDuration * 24 * 60 * 60 * 1000;
                        break;
                    case WindowServiceConstEnum.TimeDurationType.Hours:
                        nTimeDurationInMilliSeconds = i_nTimeDuration * 60 * 60 * 1000;
                        break;
                    case WindowServiceConstEnum.TimeDurationType.Minutes:
                        nTimeDurationInMilliSeconds = i_nTimeDuration * 60 * 1000;
                        break;

                    case WindowServiceConstEnum.TimeDurationType.Seconds:
                        nTimeDurationInMilliSeconds = i_nTimeDuration * 1000;
                        break;
                    case WindowServiceConstEnum.TimeDurationType.Milliseconds:
                        nTimeDurationInMilliSeconds = i_nTimeDuration;
                        break;
                    default: break;
                }
            }
            catch (Exception exp)
            {

              //  AppException ae = new AppException("Error occurred while converting time to milliseconds.", exp);
                throw exp;
            }
            return nTimeDurationInMilliSeconds;
        }
        #endregion GetTimeDurationInMilliSeconds


       public static void WriteErrorLog(string i_sMessage){

           StreamWriter sw;
           try
           {    
            
            string Year =DateTime.Now.ToString("yyyyMMdd");
            string sFileName = Year + ".txt";
            sw=new StreamWriter(ConfigurationManager.AppSettings.Get(WindowServiceConstEnum.AppSettingsKey.LoggingFilePath).ToString() + 
            sFileName ,true);
            sw.WriteLine(DateTime.Now.ToString() + ": "+ i_sMessage);
            sw.Flush();
            sw.Close();
           }
           catch (Exception e)
           {

           }
       }
    }
}
