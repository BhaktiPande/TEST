using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace InsiderTrading.Common
{ /// <summary>
  /// This class is used to set email properties
  /// </summary>
    public class EmailProperties : IDisposable
    {
        #region private variables
        private string _MailFrom;
        private bool _IsBodyHtml;
        private string _MailTo;
        private string _MailCC;
        private string _MailBCC;
        private string _MailSubject;
        private string _MailBody;
        private List<string> _Attachments;
        private string _UserInfoId;
        private string _Signature;
        private List<string> _s_MailToList;

        #endregion

        public EmailProperties(EmailPropertiesDTO objEmailPropertiesDTO, List<string> s_Attachment)
        {
            this.s_MailTo = objEmailPropertiesDTO.s_MailTo;
            this.s_MailFrom = objEmailPropertiesDTO.s_MailFrom;
            this.s_MailCC = objEmailPropertiesDTO.s_MailCC;
            this.s_MailBCC = objEmailPropertiesDTO.s_MailBCC;
            this.UserInfoId = objEmailPropertiesDTO.UserInfoId;
            this.Signature = objEmailPropertiesDTO.Signature;
            this.b_IsBodyHtml = true;

            if (Convert.ToString(ConfigurationManager.AppSettings["SendMailWithAttachment"]).Equals("1"))
            {
                long AttachmentSize = 0;
                foreach (string AttachmentPath in s_Attachment)
                {
                    FileInfo fileInfo = new FileInfo(AttachmentPath);
                    AttachmentSize += fileInfo.Length;
                }

                if (AttachmentSize <= 4194304)                              // Attachment size is not more than 4 MB.
                    this.Attachments = s_Attachment;
            }


            this.s_MailSubject = objEmailPropertiesDTO.s_MailSubject;
            this.s_MailBody = objEmailPropertiesDTO.s_MailBody;
        }
        #region properties
        /// <summary>
        /// Email From
        /// </summary>
        public string s_MailFrom
        {
            get { return _MailFrom; }
            set { _MailFrom = value; }
        }

        /// <summary>
        /// Email body IsHTML
        /// </summary>
        public bool b_IsBodyHtml
        {
            get { return _IsBodyHtml; }
            set { _IsBodyHtml = value; }
        }

        /// <summary>
        /// Mait send to
        /// </summary>
        public string s_MailTo
        {
            get { return _MailTo; }
            set { _MailTo = value; }
        }

        /// <summary>
        /// Email cc
        /// </summary>
        public string s_MailCC
        {
            get { return _MailCC; }
            set { _MailCC = value; }
        }

        /// <summary>
        /// Email bcc
        /// </summary>
        public string s_MailBCC
        {
            get { return _MailBCC; }
            set { _MailBCC = value; }
        }

        /// <summary>
        /// Email subject
        /// </summary>
        public string s_MailSubject
        {
            get { return _MailSubject; }
            set { _MailSubject = value; }
        }

        /// <summary>
        /// Email body
        /// </summary>
        public string s_MailBody
        {
            get { return _MailBody; }
            set { _MailBody = value; }
        }

        /// <summary>
        /// List of attachment
        /// </summary>
        public List<string> Attachments
        {
            get { return _Attachments; }
            set { _Attachments = value; }
        }

        public string UserInfoId
        {
            get { return _UserInfoId; }
            set { _UserInfoId = value; }
        }
       
        public string Signature
        {
            get { return _Signature; }
            set { _Signature = value; }
        }
        public List<string> S_MailToList
        {
            get { return _s_MailToList; }
            set { _s_MailToList = value; }
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

    class SendMail : IDisposable
    {
        #region Implementation of Singleton Pattern

        /// <summary>
        /// This is a singleton Pattern used for MailAlerts
        /// </summary>
        private static SendMail _instance;

        /// <summary>
        /// Constructors of MailAlerts class
        /// </summary>        
        protected SendMail()
        { }

        /// <summary>
        /// Destructors of MailAlerts class
        /// </summary>        
        ~SendMail()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a MailAlerts class
        /// </summary>
        /// <returns>returning the instance of an object</returns>
        public static SendMail Instance()
        {
            if (_instance == null)
            {
                _instance = new SendMail();
            }
            return _instance;
        }
        #endregion

        /// <summary>
        /// This method is used to send email
        /// </summary>
        /// <param name="s_CompanyName">string: company name</param>
        /// <param name="objEmailProperties">EmailProperties object with all details</param>
        /// <returns>is mail send or not</returns>
        public bool SendMailAlerts(string s_CompanyName, EmailProperties objEmailProperties)
        {
            bool bReturn = false;
           
            NotificationSL objNotificationSL = new NotificationSL();
            CompanyDetailsForNotificationDTO objCompanyDetailsForNotificationDTO;
            objCompanyDetailsForNotificationDTO = objNotificationSL.GetCompanyDetailsForNotification(Common.getSystemConnectionString(), 0, s_CompanyName);

            using (SmtpClient client = new SmtpClient(objCompanyDetailsForNotificationDTO.SmtpServer))
            {
                //Set the port for the SMTP client if available otherwise the default will be considered.
                if (objCompanyDetailsForNotificationDTO.SmtpPortNumber != null && objCompanyDetailsForNotificationDTO.SmtpPortNumber != "")
                {
                    client.Port = Convert.ToInt32(objCompanyDetailsForNotificationDTO.SmtpPortNumber);
                }

                string FromEmaild = objCompanyDetailsForNotificationDTO.SmtpUserName;
                string pwd = objCompanyDetailsForNotificationDTO.SmtpPassword;
                using (MailMessage mailMessage = new MailMessage())
                {
                    if (!string.IsNullOrEmpty(pwd))
                    {
                        client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                        client.UseDefaultCredentials = false;
                        client.EnableSsl = true;
                        NetworkCredential nCredentials = new NetworkCredential(FromEmaild, pwd);
                        client.Credentials = nCredentials;
                    }
                    mailMessage.From = new MailAddress(FromEmaild);
                   
                    if (!string.IsNullOrEmpty(objEmailProperties.s_MailTo))
                    {
                        mailMessage.To.Add(objEmailProperties.s_MailTo);
                    }
                    if (!string.IsNullOrEmpty(objEmailProperties.s_MailCC))
                    {
                        mailMessage.CC.Add(objEmailProperties.s_MailCC);
                    }
                    if (!string.IsNullOrEmpty(objEmailProperties.s_MailBCC))
                    {
                        mailMessage.Bcc.Add(objEmailProperties.s_MailBCC);
                    }
                    mailMessage.Subject = objEmailProperties.s_MailSubject;
                    mailMessage.Body = objEmailProperties.s_MailBody;
                    mailMessage.IsBodyHtml = objEmailProperties.b_IsBodyHtml;

                    if (objEmailProperties.Attachments != null)
                    {
                        foreach (string s_FilePath in objEmailProperties.Attachments)
                        {
                            mailMessage.Attachments.Add(new Attachment(s_FilePath));
                        }
                    }

                    try
                    {
                        client.Send(mailMessage);
                        
                           
                        
                             bReturn = true;
                    }
                    catch (Exception ex)
                    {
                        bReturn = false;
                        throw ex;
                    }
                }
            }
            return bReturn;
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