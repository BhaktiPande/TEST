using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
    public class Recipient
    {
        #region Variable Declaration
        string m_sEmailSubject = "";
        string m_sEmailAddress = "";
        string m_sRecipientEmployeeName = "";
        string m_sEmailBody = "";
        string m_sSignature = "";
        int m_nNotificationQueueID;
        string m_sDocumentPath = "";
        string m_sDocumentName = "";
        string m_sCommunicationFrom= "";
        #endregion  Variable Declaration

        #region Constructor
        public Recipient()
        {
            try
            {
               
            }
            catch (Exception exp)
            {
               
            }
        }
        #endregion Recipient

        #region EmailSubject
        /// Gets or Sets EmailSubject
        public string EmailSubject
        {
            get
            {
                return m_sEmailSubject;
            }
            set
            {
                m_sEmailSubject = value;
            }
        }
        #endregion EmailSubject

        #region EmailAddress
        /// Gets or Sets EmailAddress
        public string EmailAddress
        {
            get
            {
                return m_sEmailAddress;
            }
            set
            {
                m_sEmailAddress = value;
            }
        }
        #endregion EmailAddress

        #region RecipientEmployeeName
        /// Gets or Sets RecipientEmployeeName
        public string RecipientEmployeeName
        {
            get
            {
                return m_sRecipientEmployeeName;
            }
            set
            {
                m_sRecipientEmployeeName = value;
            }
        }
        #endregion RecipientEmployeeName

        #region EmailBody
        /// Gets or Sets EmailBody
        public string EmailBody
        {
            get
            {
                return m_sEmailBody;
            }
            set
            {
                m_sEmailBody = value;
            }
        }
        #endregion EmailBody

        #region Signature
        /// Gets or Sets Signature
        public string Signature
        {
            get
            {
                return m_sSignature;
            }
            set
            {
                m_sSignature = value;
            }
        }
        #endregion Signature

        #region NotificationQueueID
        /// Gets or Sets NotificationQueueID
        public int NotificationQueueID
        {
            get
            {
                return m_nNotificationQueueID;
            }
            set
            {
                m_nNotificationQueueID = value;
            }
        }
        #endregion NotificationQueueID

        #region Document Path
        /// Gets or Sets DocumentPath
        public string DocumentPath
        {
            get
            {
                return m_sDocumentPath;
            }
            set
            {
                m_sDocumentPath = value;
            }
        }
        #endregion Document Path

        #region Document Name
        /// Gets or Sets Document Name
        public string DocumentName
        {
            get
            {
                return m_sDocumentName;
            }
            set
            {
                m_sDocumentName = value;
            }
        }
        #endregion Document Name

        #region CommunicationFrom
        //Gets or Sets Communication From
        public string CommunicationFrom
        {
            get
            {
                return m_sCommunicationFrom;
            }
            set
            {
                m_sCommunicationFrom = value;
            }
        #endregion CommunicationFrom
        }
    }
}
