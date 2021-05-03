using InsiderTradingDAL;
using InsiderTrading_NotificationService.Interface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Reflection;
using System.IO;
using System.Net.Mime;
using InsiderTradingEncryption;

namespace InsiderTrading_NotificationService
{
   public class EmailSend
   {
       string sSystemAdmin = ConfigurationManager.AppSettings.Get(WindowServiceConstEnum.AppSettingsKey.SMTPSystemAdmin);
      // private WindowsServiceEventLog m_objWindowsServiceEventLog = null;

         #region Constructor
        /// <summary>
        /// Constructor
        /// </summary>
       public EmailSend()
        {
            try
            {
             //   m_objWindowsServiceEventLog = new WindowsServiceEventLog();

                WindowServiceCommon.WriteErrorLog("INFO : Call Constructor..........." + MethodBase.GetCurrentMethod());
             
            }
            catch (Exception exp)
            {

                //#region Event Log
                //m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                //    "Error while intializing BusinessLayer Email object." + exp.Message + ":" + exp.StackTrace);
                //#endregion

                //if (m_objWindowsServiceEventLog != null)
                //{
                //    #region Event Log
                //    m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                //        "Error while intializing BusinessLayer Email object." + exp.Message + ":" + exp.StackTrace);
                //    #endregion
                //}

            }
            finally
            {
              
            }
        }
        #endregion Constructor

       #region broadCast
       /// <summary>
       /// 
       /// </summary>
       /// <returns></returns>
       public bool broadCast()
        {
            bool bReturn = false;
            string sEmailServiceForCompanies = ""; 
            try
            {

                WindowServiceCommon.WriteErrorLog("INFO : Enter broadCast fuction..........");

                sEmailServiceForCompanies = ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.EmailServiceForCompanies);

               string [] splitCompanyName =  sEmailServiceForCompanies.Split(',');

                EmailNotificationSL objEmailNotificationSL = new EmailNotificationSL();
                string dbConnectionString = InsiderTrading_NotificationService.WindowServiceCommon.getSystemConnectionString();

                WindowServiceCommon.WriteErrorLog("INFO: Connection string : -" + dbConnectionString);

                IEnumerable<InsiderTradingDAL.CompanyIDListDTO> lstCompanyIDListDTO = objEmailNotificationSL.GetCompanyIds(dbConnectionString);

                foreach (var item in lstCompanyIDListDTO)
                {

                    WindowServiceCommon.WriteErrorLog("INFO: Company ID is : - " + item.CompanyId + " Company Name:- " + item.CompanyName);

                    if (ContainsString(splitCompanyName, item.ConnectionDatabaseName))
                    {

                        WindowServiceCommon.WriteErrorLog("INFO: If Company Exists in Config Company ID is : - " + item.CompanyId + " Company Name:- " + item.CompanyName);

                        DataTable tblNotificationQueueResponse = new DataTable("NotificationQueueResponse");
                        tblNotificationQueueResponse.Columns.Add(new DataColumn("RowId", typeof(int)));
                        tblNotificationQueueResponse.Columns.Add(new DataColumn("NotificationQueueId", typeof(int)));
                        tblNotificationQueueResponse.Columns.Add(new DataColumn("CompanyIdentifierCodeId", typeof(int)));
                        tblNotificationQueueResponse.Columns.Add(new DataColumn("ResponseStatusCodeId", typeof(int)));
                        tblNotificationQueueResponse.Columns.Add(new DataColumn("ResponseMessage", typeof(string)));

                        IEnumerable<InsiderTradingDAL.CompanyDetailsForNotificationDTO> lstCompanyDetailsForNotificationDTO = objEmailNotificationSL.GetCompanyDetailsForNotification(dbConnectionString, item.CompanyId);

                       

                        if (lstCompanyDetailsForNotificationDTO != null)
                        {

                            

                            CompanyDetailsForNotificationDTO objCompanyDetailsForNotificationDTO = lstCompanyDetailsForNotificationDTO.FirstOrDefault();
                            if (objCompanyDetailsForNotificationDTO != null)
                            {

                                WindowServiceCommon.WriteErrorLog("INFO: Fetching Company Details SMTP :- " + objCompanyDetailsForNotificationDTO.SmtpServer);
                                WindowServiceCommon.WriteErrorLog("INFO: Fetching Company Details User :- " + objCompanyDetailsForNotificationDTO.SmtpUserName);

                                ConfigurationModel objConfigurationModel = new ConfigurationModel();
                                objConfigurationModel.SmtpServer = objCompanyDetailsForNotificationDTO.SmtpServer;
                                objConfigurationModel.SmtpUserName = objCompanyDetailsForNotificationDTO.SmtpUserName;
                                objConfigurationModel.SmtpPortNumber = objCompanyDetailsForNotificationDTO.SmtpPortNumber;
                                objConfigurationModel.SmtpPassword = objCompanyDetailsForNotificationDTO.SmtpPassword;

                                //using (DataSecurity ds = new DataSecurity())
                                //{                                                                        
                                //    objConfigurationModel.SmtpPassword = ds.DecryptData(objCompanyDetailsForNotificationDTO.SmtpPassword); ;
                                //}
                               
                                IEnumerable<InsiderTradingDAL.NotificationSendListDTO> lstNotificationSendListDTO = objEmailNotificationSL.GetNotificationSendList(dbConnectionString, item.CompanyId);

                                WindowServiceCommon.WriteErrorLog("INFO: Fetch Notification Send List");

                                if (lstNotificationSendListDTO != null)
                                {


                                    WindowServiceCommon.WriteErrorLog("INFO: Record found in Notification Send List");

                                    int nRowIDCount = 1;
                                    foreach (var mailPart in lstNotificationSendListDTO)
                                    {
                                        if (Convert.ToInt32(mailPart.ModeCodeId) == Convert.ToInt32(WindowServiceConstEnum.NotificationType.EmailNotificationType))
                                        {

                                            WindowServiceCommon.WriteErrorLog("INFO: Only Email Type Record Select");

                                            DataRow row = tblNotificationQueueResponse.NewRow();

                                            Recipient objRecipient = new Recipient();
                                            objRecipient.EmailAddress = mailPart.UserContactInfo;
                                            objRecipient.EmailSubject = mailPart.Subject;
                                            objRecipient.EmailBody = mailPart.Contents;
                                            objRecipient.Signature = mailPart.Signature;
                                            objRecipient.DocumentName = mailPart.DocumentName;
                                            objRecipient.DocumentPath = mailPart.DocumentPath;
                                            objRecipient.CommunicationFrom = mailPart.CommunicationFrom;

                                            WindowServiceCommon.WriteErrorLog("INFO: Mail Sending Details:- " + item.CompanyId + " NotificationQueueId :- " + mailPart.NotificationQueueId);
                                            

                                            WindowServiceCommon.WriteErrorLog("INFO: Email Address :-" + mailPart.UserContactInfo);
                                            WindowServiceCommon.WriteErrorLog("INFO: Subject :- " + mailPart.Subject);
                                            WindowServiceCommon.WriteErrorLog("INFO: Email Body:- " + mailPart.Contents);
                                            WindowServiceCommon.WriteErrorLog("INFO: Signature: -" + mailPart.Signature);

                                            //objRecipient.NotificationQueueID
                                            //Add in Datatable
                                            row["RowId"] = nRowIDCount;
                                            row["NotificationQueueId"] = mailPart.NotificationQueueId;
                                            if (mailPart.CompanyIdentifierCodeId != null && mailPart.CompanyIdentifierCodeId > 0)
                                            {
                                                row["CompanyIdentifierCodeId"] = mailPart.CompanyIdentifierCodeId;
                                            }
                                            else
                                            {
                                                row["CompanyIdentifierCodeId"] = DBNull.Value;
                                            }

                                            int o_nResponseCode = 0;
                                            
                                            string o_sResponseMessage = "";

                                            WindowServiceCommon.WriteErrorLog("INFO: Call Send Mail Function............");

                                            bool bResult = SendMail(objRecipient, objConfigurationModel, out o_nResponseCode, out o_sResponseMessage);
                                            if (o_nResponseCode != null && o_nResponseCode > 0)
                                            {
                                                row["ResponseStatusCodeId"] = o_nResponseCode;
                                            }
                                            else
                                            {
                                                row["ResponseStatusCodeId"] = DBNull.Value;
                                            }
                                            row["ResponseMessage"] = o_sResponseMessage;
                                            tblNotificationQueueResponse.Rows.Add(row);

                                            WindowServiceCommon.WriteErrorLog("INFO: Response Code :-" + o_nResponseCode + " Response Message:- " + o_sResponseMessage);


                                        }
                                        else if (Convert.ToInt32(mailPart.ModeCodeId) == Convert.ToInt32(WindowServiceConstEnum.NotificationType.SMSNotifactionType))
                                        {

                                            DataRow row = tblNotificationQueueResponse.NewRow();

                                            WindowServiceCommon.WriteErrorLog("INFO: Only SMS Type Record Select");

                                            row["RowId"] = nRowIDCount;
                                            row["NotificationQueueId"] = mailPart.NotificationQueueId;
                                            if (mailPart.CompanyIdentifierCodeId != null && mailPart.CompanyIdentifierCodeId > 0)
                                            {
                                                row["CompanyIdentifierCodeId"] = mailPart.CompanyIdentifierCodeId;
                                            }
                                            else
                                            {
                                                row["CompanyIdentifierCodeId"] = DBNull.Value;
                                            }

                                            int o_nResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseSuccess);
                                            string o_sResponseMessage = "SMS Part is remaining....";
                                            //Send Message part is remaining
                                            //  bool bResult = SendMessage();
                                            if (o_nResponseCode != null && o_nResponseCode > 0)
                                            {
                                                row["ResponseStatusCodeId"] = o_nResponseCode;
                                            }
                                            else
                                            {
                                                row["ResponseStatusCodeId"] = DBNull.Value;
                                            }
                                            row["ResponseMessage"] = o_sResponseMessage;
                                            tblNotificationQueueResponse.Rows.Add(row);

                                        }
                                        nRowIDCount++;

                                    }
                                }
                            }

                            WindowServiceCommon.WriteErrorLog("INFO: Update Response Started for Company ID............" + item.CompanyId);


                            bool bUpdateResponseCode = UpdateResponseCode(dbConnectionString, item.CompanyId, tblNotificationQueueResponse);

                            WindowServiceCommon.WriteErrorLog("INFO: Update Response End for Company ID............" + item.CompanyId);

                        }
                    }
                }

                bReturn = true;
            }
            catch (Exception exp)
            {
              //  WindowServiceCommon.WriteErrorLog("Eroor Occured in Send Mail Function " + exp.Message);

                WindowServiceCommon.WriteErrorLog("ERROR: " + MethodBase.GetCurrentMethod() + " " + exp.Message);

                bReturn = false;
                throw exp;
            }
            return bReturn;
        }
       #endregion broadCast

       #region SendMail
       /// <summary>
       /// 
       /// </summary>
       /// <param name="m_objRecipient"></param>
       /// <param name="m_objobjConfigurationModel"></param>
       /// <param name="o_enBroadcastResponseCode"></param>
       /// <param name="o_sBroadcastResponseMessage"></param>
       /// <returns></returns>
       public bool SendMail(Recipient m_objRecipient, ConfigurationModel m_objobjConfigurationModel, out int o_enBroadcastResponseCode,
           out string o_sBroadcastResponseMessage)
        {
            #region Variables
            bool bReturn = false;
            string[] sSeprator = { "," };
            string[] arrAttachment = null;
            string[] arrAttachment1 = null;
            string i_sAttachmentFiles = "";
            StringBuilder o_sSystemAdminPassword = new StringBuilder();
            string sAdminEmailAccPassword = "";
            string sSendEmailConfig = "";
            string sLiveServiceConfig = "";
            string sTestingUserEmailAddress = "";
            MailMessage objMailMessage = new MailMessage();
            o_enBroadcastResponseCode = 0; ;
            o_sBroadcastResponseMessage = string.Empty;
            bool bAttachmentError = false;
            string sAttachedProblemFileName = ""; 
            #endregion Variables

            try
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                WindowServiceCommon.WriteErrorLog("INFO: ================================================================================================");

                WindowServiceCommon.WriteErrorLog("INFO: Enter in Send Mail function...");

                sSendEmailConfig = ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.SendEmails);
                sLiveServiceConfig = ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.LiveService);
                sTestingUserEmailAddress = ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.TestingUserEmailAddress);
                sAdminEmailAccPassword = ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.SMTPSystemAdminPassword);

                //SMTP credintional.
                SmtpClient objSmtpClient = new SmtpClient(m_objobjConfigurationModel.SmtpServer);
               // SmtpClient objSmtpClient = new SmtpClient("smtp.mail.yahoo.com");//"smtp.gmail.com");
                objSmtpClient.Timeout = int.MaxValue;//(60 * 5 * 1000);
                objSmtpClient.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.EnableSsl));
                WindowServiceCommon.WriteErrorLog("INFO: EnableSsl :-" + objSmtpClient.EnableSsl);
                objSmtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                objSmtpClient.UseDefaultCredentials = Convert.ToBoolean(ConfigurationManager.AppSettings.Get(InsiderTrading_NotificationService.WindowServiceConstEnum.AppSettingsKey.UseDefaultCredentials));
                WindowServiceCommon.WriteErrorLog("INFO: UseDefaultCredentials :-" + objSmtpClient.UseDefaultCredentials);
                m_objobjConfigurationModel.SmtpPassword = m_objobjConfigurationModel.SmtpPassword;
                //objSmtpClient.Port = 587;

                //using (DataSecurity ds = new DataSecurity())
                //{
                //    m_objobjConfigurationModel.SmtpPassword = ds.DecryptData(m_objobjConfigurationModel.SmtpPassword); ;
                //}

                if (m_objobjConfigurationModel.SmtpUserName != null && m_objobjConfigurationModel.SmtpUserName != "" && m_objobjConfigurationModel.SmtpPassword != null && m_objobjConfigurationModel.SmtpPassword != "")
                 {
                   //  Decrypt System Admin Password which encrypted in App.confif file.
                   //  DecryptPassword(sSystemAdminPassword, out o_sSystemAdminPassword);
                     WindowServiceCommon.WriteErrorLog("INFO: SMTP User :-" + m_objobjConfigurationModel.SmtpUserName);
                     objSmtpClient.Credentials = new NetworkCredential(m_objobjConfigurationModel.SmtpUserName, m_objobjConfigurationModel.SmtpPassword);
                 }
                 else 
                 {
                     objSmtpClient.Credentials = null;
                 }
                if (m_objobjConfigurationModel.SmtpPortNumber != null && m_objobjConfigurationModel.SmtpPortNumber != "")
                {
                    objSmtpClient.Port = Convert.ToInt32(m_objobjConfigurationModel.SmtpPortNumber);
                    WindowServiceCommon.WriteErrorLog("INFO: SMTP Port Number : -" + m_objobjConfigurationModel.SmtpPortNumber);
                }
                else
                {
                    WindowServiceCommon.WriteErrorLog("INFO: Default SMTP Port Number is used....");
                }

                objMailMessage.IsBodyHtml = true;
                
                // From Address
                if (m_objRecipient.CommunicationFrom != null && m_objRecipient.CommunicationFrom!="")//m_objobjConfigurationModel.SmtpUserName != null && m_objobjConfigurationModel.SmtpUserName != "")
                {

                    WindowServiceCommon.WriteErrorLog("INFO: Email From Adress :-" + m_objRecipient.CommunicationFrom);

                    objMailMessage.From = new MailAddress(m_objRecipient.CommunicationFrom);
                }
                else {
                    objMailMessage.From = new MailAddress(m_objobjConfigurationModel.SmtpUserName);
                }
                
                // To Address
                if (sLiveServiceConfig == "true")
                {
                    objMailMessage.To.Add(m_objRecipient.EmailAddress);

                    WindowServiceCommon.WriteErrorLog("INFO: Send Live EMail Address : -" + m_objRecipient.EmailAddress);

                }
                else
                {
                    objMailMessage.To.Add(sTestingUserEmailAddress);

                    WindowServiceCommon.WriteErrorLog("INFO: Send Test EMail Address : -" + sTestingUserEmailAddress);

                }

                //send attch file

                //i_sAttachmentFiles = "C:\\Users\\lankesh.zade\\Desktop\\Insider Trading_List of issues 18-Jun-15.xlsx";
            
                if (m_objRecipient.DocumentPath != null && m_objRecipient.DocumentPath != "")
                {
                    arrAttachment = m_objRecipient.DocumentPath.Split(sSeprator, StringSplitOptions.None);
                    arrAttachment1 = m_objRecipient.DocumentName.Split(sSeprator, StringSplitOptions.None);

                    for (int nCount = 0; nCount < arrAttachment.Length; nCount++)
                    {
                        if (File.Exists(arrAttachment[nCount]))
                        {
                            Attachment objAttachment = new Attachment(arrAttachment[nCount]);
                            objAttachment.Name = arrAttachment1[nCount];
                           // objAttachment.ContentType.MediaType.All
                            objMailMessage.Attachments.Add(objAttachment);
                        }
                        else
                        {
                            bAttachmentError = true;
                            if (sAttachedProblemFileName == "")
                            {
                                sAttachedProblemFileName = arrAttachment1[nCount];
                            }
                            else
                            {
                                sAttachedProblemFileName = sAttachedProblemFileName + ", " + arrAttachment1[nCount];
                            }
                        }
                      
                    }

                }
                
              //  FileStream fs = new FileStream(i_sAttachmentFiles, FileMode.Open, FileAccess.Read);
             //  Attachment objAttachment = new Attachment(i_sAttachmentFiles);

              /*  byte[] bytes = File.ReadAllBytes(i_sAttachmentFiles);
                MemoryStream memAttachment = new MemoryStream(bytes);
                Attachment attachment = new Attachment(memAttachment, "Insider Trading_List of issues 18-Jun-15.xlsx");
                attachment.TransferEncoding = System.Net.Mime.TransferEncoding.QuotedPrintable;
                objMailMessage.Attachments.Add(attachment);*/

              //  objMailMessage.Attachments.Add(new Attachment(fs, "Screenshot_1 (2).jpg", MediaTypeNames.Application.Octet));
               
                objMailMessage.Subject = m_objRecipient.EmailSubject.Trim();
                string sBody = "";
                if (m_objRecipient.Signature != null)
                {
                     sBody = m_objRecipient.EmailBody.Replace(@"\r\n", "<br/>") + "<br/><br/><br/>" + m_objRecipient.Signature.Replace(@"\r\n", "<br/>");
                }
                else
                {
                     sBody = m_objRecipient.EmailBody.Replace(@"\r\n", "<br/>");
                }
                

                objMailMessage.Body = sBody;

                WindowServiceCommon.WriteErrorLog("INFO: Body : -" + sBody);
               
                if (sSendEmailConfig == "true")
                {

                    WindowServiceCommon.WriteErrorLog("INFO: Send Mail Flag True ");

                    if (sBody == null && sBody == "")
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                        o_sBroadcastResponseMessage = Convert.ToString(WindowServiceConstEnum.BroadcastErrorMessages.EmptyEmailBody);
                    }
                    else if (m_objRecipient.EmailSubject == null && m_objRecipient.EmailSubject == "")
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                        o_sBroadcastResponseMessage = Convert.ToString(WindowServiceConstEnum.BroadcastErrorMessages.EmptySubjectLine);
                    }
                    else if (m_objRecipient.EmailAddress == null && m_objRecipient.EmailAddress == "")
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                        o_sBroadcastResponseMessage = Convert.ToString(WindowServiceConstEnum.BroadcastErrorMessages.NoEmailAddress) + m_objRecipient.NotificationQueueID;
                    }
                    else if (bAttachmentError)
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                        o_sBroadcastResponseMessage = "Email Attachement Problem for File Name:-" + sAttachedProblemFileName;
                    }
                    else
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseSuccess);
                        o_sBroadcastResponseMessage = "";

                    }

                    

                    //send mail.
                    if (sBody != null && sBody != "" && m_objRecipient.EmailSubject != null && m_objRecipient.EmailSubject != "" &&
                        m_objRecipient.EmailAddress != null && m_objRecipient.EmailAddress != "" && !bAttachmentError)
                    {

                        WindowServiceCommon.WriteErrorLog("INFO: Call Send Mail");

                        objSmtpClient.Send(objMailMessage);

                       // memAttachment.Close();

                        WindowServiceCommon.WriteErrorLog("INFO: Send Mail Successfully");

                      


                    }
                    else
                    {
                        o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);

                        
                    }


                }
                
                //cleanup.
                objMailMessage.Dispose();
                m_objRecipient = null;
                WindowServiceCommon.WriteErrorLog("INFO: Exit in Send Mail function...");

                WindowServiceCommon.WriteErrorLog("INFO: ================================================================================================");

                bReturn = true;
            }
            catch (System.Net.Mail.SmtpFailedRecipientsException exp)
            {
                WindowServiceCommon.WriteErrorLog("Eroor Occured While Sending Mail " + MethodBase.GetCurrentMethod() + exp.Message);
                o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                o_sBroadcastResponseMessage = exp.InnerException + " : " + exp.Message;

            }
            catch (System.Net.Mail.SmtpException exp)
            {
                bReturn = false;

                WindowServiceCommon.WriteErrorLog("Eroor Occured While Sending Mail " + MethodBase.GetCurrentMethod() + exp.Message);
                o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                o_sBroadcastResponseMessage = exp.InnerException + " : " + exp.Message;
            }
            catch (Exception exp)
            {
                bReturn = false;

                WindowServiceCommon.WriteErrorLog("ERROR: " + MethodBase.GetCurrentMethod() + " " + exp.Message);

                o_enBroadcastResponseCode = Convert.ToInt32(WindowServiceConstEnum.Code.BroadcastResponseError);
                o_sBroadcastResponseMessage = exp.InnerException + " : " + exp.Message;

            }
            
            return bReturn;
        }
       #endregion SendMail

       #region UpdateResponseCode
       /// <summary>
       /// 
       /// </summary>
       /// <param name="i_nResponseCode"></param>
       /// <param name="i_sResponseMessage"></param>
       /// <returns></returns>
       public bool UpdateResponseCode(string i_sConnectionString, int i_nCompanyId,DataTable m_tblNotificationResponse)
        {
            bool bReturn = false;
            try
            {
                WindowServiceCommon.WriteErrorLog("INFO: Enter Update Response Code function.........");

                EmailNotificationSL objEmailNotificationSL=new EmailNotificationSL();

                bReturn = objEmailNotificationSL.UpdateNotificationResponse(i_sConnectionString, i_nCompanyId, m_tblNotificationResponse);

                WindowServiceCommon.WriteErrorLog("INFO: Exit Update Response Code function.........");
            }
            catch (Exception exp)
            {

                WindowServiceCommon.WriteErrorLog("ERROR: " + MethodBase.GetCurrentMethod() + " " + exp.Message);

                bReturn = false;
                throw exp;
            }
            return bReturn;
        }
       #endregion UpdateResponseCode

       #region SendMessage
       public bool SendMessage()
        {
            bool bReturn = false;
            try
            {
                bReturn = true;

            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }
            return bReturn;
        }
        #endregion SendMessage

       public bool ContainsString(string[] arr, string testval)
       {
           if (arr == null)
               return false;
           for (int i = arr.Length - 1; i >= 0; i--)
               if (arr[i].ToUpper() == testval.ToUpper())
                   return true;
           return false;
       }

    }
}
