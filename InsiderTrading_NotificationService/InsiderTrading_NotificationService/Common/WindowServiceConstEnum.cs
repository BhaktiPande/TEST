using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
    public class WindowServiceConstEnum
    {
        #region AppSettingsKey
        //Stores the AppSettings Keys in Web.Config.
        public class AppSettingsKey
        {
            public const string ServiceStartUpDay = "ServiceStartUpDay";//Stores the Service Start day.
            public const string ServicePollTime = "ServicePollTime";//Stores the polling time for Reminder Service.
            public const string ServicePollTimeUnit = "ServicePollTimeUnit";
            public const string EmailScheduledTime = "EmailScheduledTime";
            public const string LoggedInUserID = "LoggedInUserID"; //Set LoggedInUserID required to save sent mails history 
            public const string WriteEventLogFlag = "WriteEventLogFlag"; // Set this flag to indicate whether Event Logs are to be written for this service
            public const string EnableSsl = "EnableSsl";
            public const string UseDefaultCredentials = "UseDefaultCredentials";
            public const string SMTPHostName = "SMTPHostName";
            public const string SMTPSystemAdmin = "SMTPSystemAdmin";
            public const string SMTPSystemAdminPassword = "SMTPSystemAdminPassword";
            public const string EmailTemplateFetchURL = "EmailTemplateFetchURL";
            public const string EmailTemplatePath = "EmailTemplatePath";
            public const string EmailGroupTemplatePath = "EmailGroupTemplatePath";
            public const string EmailGroupTemplateStylesPath = "EmailGroupTemplateStylesPath";
            public const string EmailStylesFileName = "EmailStylesFileName";
            public const string SendEmails = "SendEmails";
            public const string LiveService = "LiveService";
            public const string TestingUserEmailAddress = "TestingUserEmailAddress";
            public const string SiteLoginURL = "SiteLoginURL";
            public const string EmailServiceForCompanies = "EmailServiceForCompanies";
            public const string LoggingFilePath = "LoggingFilePath";
        }
        #endregion AppSettingsKey

        #region TimeDurationType
        public enum TimeDurationType
        {
            Milliseconds = 1,
            Seconds = 2,
            Minutes = 3,
            Hours = 4,
            Days = 5
        }
        #endregion TimeDurationType

       
        public enum NotificationType
        {
            EmailNotificationType = 156002,
            SMSNotifactionType = 156003
        }

        #region Code
        public enum Code
        {
            EmailBroadcast = 156002,
            SMSBroadcast = 156003,

            //Response Code
            BroadcastResponseSuccess = 161001,
            BroadcastResponseError = 161002,
            BroadcastResponseOther = 161002,

        }
        #endregion Code

        #region BroadcastErrorMessages
        public class BroadcastErrorMessages
        {
            public const string EmptyEmailBody = "Cannot send email, as email body content is empty";
            public const string NoEmailAddress = "Cannot send email, as email address for recipient employee was not found. Recipient Employee ID = ";
            public const string EmptySubjectLine = "Cannot send email, as subject line is empty.";

        }
        #endregion


    
    }
}
