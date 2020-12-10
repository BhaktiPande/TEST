using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class EmailPropertiesDTO
    {
        #region private variables
        private int _ID;
        private string _MailFrom;
        private bool _IsBodyHtml;
        private string _MailTo;
        private string _MailCC;
        private string _MailBCC;
        private string _MailSubject;
        private string _MailBody;
        private string _Module;
        private string _Flag;
        private string _TemplateCode;
        private string _UniqueID;
        private string _UserInfoId;
        private string _Signature;

        #endregion
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

        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public string Module
        {
            get { return _Module; }
            set { _Module = value; }
        }
        public string Flag
        {
            get { return _Flag; }
            set { _Flag = value; }
        }
        public string TemplateCode
        {
            get { return _TemplateCode; }
            set { _TemplateCode = value; }
        }
        public string UniqueID
        {
            get { return _UniqueID; }
            set { _UniqueID = value; }
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
        

        #endregion
    }
}
