using InsiderTrading.Common;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingEncryption;
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography.Xml;
using System.Text;
using System.Web;
using System.Xml;

namespace InsiderTrading.Models
{
    public class SSOModel : IDisposable
    {
        #region private members
        private DataSet DS_AuthnRequest = new DataSet();
        private string _companyID = string.Empty;
        #endregion

        #region internal members
        internal string IDPUrl = string.Empty;
        internal string SAMLRequest = string.Empty;
        #endregion

        #region enums

        internal enum CompanyIDList
        {
            TGBL = 1
        }
        #endregion

        #region Internal methods
        /// <summary>
        /// This method is to check whether the SSO is activated.
        /// </summary>
        /// <param name="companyIDList">Current CompanyName</param>
        /// <returns>True for Yes and False for No</returns>
        internal bool IsSSOActivated(CompanyIDList companyIDList)
        {
            bool IsSSOActivated = false;
            using (CompaniesSL objCompaniesSL = new CompaniesSL())
            {
                IsSSOActivated = objCompaniesSL.getSingleCompanies(InsiderTrading.Common.Common.getSystemConnectionString(), "Vigilante_" + companyIDList.ToString()).bIsSSOActivated;
            }

            return IsSSOActivated;
        }
        internal bool IsSSOActivated(string companyName)
        {
            bool IsSSOActivated = false;
            using (CompaniesSL objCompaniesSL = new CompaniesSL())
            {
                IsSSOActivated = objCompaniesSL.getSingleCompanies(InsiderTrading.Common.Common.getSystemConnectionString(), companyName).bIsSSOActivated;
            }

            return IsSSOActivated;
        }

        /// <summary>
        /// This method is used to Initiate SSO (considering as Audience URL)
        /// </summary>
        /// <param name="companyID">Current CompanyID to whom to initiate SSO.</param>
        /// <returns>returns True for Sucessfull and false for Failure</returns>
        internal bool InitiateSSO(CompanyIDList companyID)
        {
            bool IsSSOInitiated = true;
            try
            {
                _companyID = companyID.ToString();
                WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).Start);

                GetAuthnRequest();
                IDPUrl = DS_AuthnRequest.Tables[_companyID].Rows[0]["IDPUrl"].ToString();
                SAMLRequest = CreateAuthnRequest();

            }
            catch (Exception exception)
            {
                IsSSOInitiated = false;
                WriteToFileLog.Instance(_companyID).Write("Error Occurred:-" + exception.Message.ToString() + "\n" + "Stack Trace:-" + exception.StackTrace.ToString());
            }
            finally
            {
                WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).End);
                WriteToFileLog.Instance(_companyID).Write("");
            }
            return IsSSOInitiated;
        }

        internal bool InitiateSPSSO(string companyID)
        {
            bool IsSSOInitiated = true;
            try
            {
                _companyID = companyID.ToString();
                WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).Start);

                GetAuthnRequest();
                IDPUrl = DS_AuthnRequest.Tables[_companyID].Rows[0]["IDPUrl"].ToString();
                //SAMLRequest = CreateNewAuthnRequest();

            }
            catch (Exception exception)
            {
                IsSSOInitiated = false;
                WriteToFileLog.Instance(_companyID).Write("Error Occurred:-" + exception.Message.ToString() + "\n" + "Stack Trace:-" + exception.StackTrace.ToString());
            }
            finally
            {
                WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).End);
                WriteToFileLog.Instance(_companyID).Write("");
            }
            return IsSSOInitiated;
        }

        /// <summary>
        /// This process is used to process SSO for SAML response
        /// </summary>
        /// <param name="SAMLResponse">SAML reponse in enctrypted format</param>
        /// <returns>returns True for Sucessfull and false for Failure</returns>
        internal bool ProcessSSO(string SAMLResponse)
        {
            bool IsSSOProcessed = true;
            StringBuilder sb_WebParameters = new StringBuilder();
            try
            {
                Hashtable ht_SAMLParameters;

                sb_WebParameters.AppendLine("SAMLResponse=" + SAMLResponse);

                using (SAMLResponse samlResponse = new SAMLResponse())
                {
                    samlResponse.LoadXmlFromBase64(SAMLResponse);
                    _companyID = samlResponse.CompanyID;

                    if (!IsSSOActivated((CompanyIDList)System.Enum.Parse(typeof(CompanyIDList), samlResponse.CompanyID, true)))
                    {
                        sb_WebParameters.AppendLine(CommonConstant.s_SSONotActivated);
                        throw new Exception(CommonConstant.sRequestStatusSSO_DEACTIVATED);
                    }

                    WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).Start);

                    if (samlResponse.IsValid(out ht_SAMLParameters, ref sb_WebParameters))
                    {
                        if (SetupLoginDetails(ht_SAMLParameters))
                            sb_WebParameters.AppendLine(CommonConstant.s_RedirectToVigilante);
                        else
                        {
                            IsSSOProcessed = false;
                            sb_WebParameters.AppendLine(CommonConstant.s_LoginSetupFailed);
                        }
                    }
                    else
                    {
                        IsSSOProcessed = false;
                        sb_WebParameters.AppendLine(CommonConstant.s_InvalidResponse);
                    }
                }
            }
            catch (Exception exception)
            {
                IsSSOProcessed = false;
                if (exception.Message.ToString().Equals(CommonConstant.sRequestStatusSSO_DEACTIVATED))
                    throw exception;
                else
                    sb_WebParameters.AppendLine("Error Occurred:-" + exception.Message.ToString() + "\n" + "Stack Trace:-" + exception.StackTrace.ToString());
            }
            finally
            {
                WriteToFileLog.Instance(_companyID).Write(sb_WebParameters.ToString());
                WriteToFileLog.Instance(_companyID).Write(WriteToFileLog.Instance(_companyID).End);
                WriteToFileLog.Instance(_companyID).Write("");
            }

            return IsSSOProcessed;
        }

        /// <summary>
        /// This method is used to setup all the pre-requisite for Login to applicaton
        /// </summary>
        /// <param name="HT_Params">Collection of EmailID and CompanyName</param>
        /// <returns>returns True for Sucessfull and false for Failure</returns>
        internal bool SetupLoginDetails(Hashtable HT_Params)
        {
            bool IsLoginSetupSucceed = false;
            using (CompaniesSL objCompaniesSL = new CompaniesSL())
            {
                LoginUserDetails objLoginUserDetails = new LoginUserDetails();
                CompanyDTO objSelectedCompany = new CompanyDTO();
                objSelectedCompany = objCompaniesSL.getSingleCompanies(InsiderTrading.Common.Common.getSystemConnectionString(), HT_Params[CommonConstant.s_AttributeComapnyName].ToString());
                objLoginUserDetails.CompanyDBConnectionString = objSelectedCompany.CompanyConnectionString;

                using (DataSecurity objDataSecurity = new DataSecurity())
                {
                    UserInfoDTO userInfoDTO = new UserInfoDTO();
                    UserInfoDAL objUserInfoDAL = new UserInfoDAL();
                    userInfoDTO = objUserInfoDAL.LoginSSOUserInfo(objLoginUserDetails.CompanyDBConnectionString, HT_Params);

                    if (userInfoDTO.LoginID == null)
                    {
                        foreach (string perKey in HT_Params.Keys)
                        {
                            if (!perKey.Equals("CompanyName"))
                                throw new Exception(string.Format(CommonConstant.s_InvalidAttribute, perKey));
                        }
                    }


                    objLoginUserDetails.UserName = userInfoDTO.LoginID;
                    objLoginUserDetails.Password = userInfoDTO.Password;
                    objLoginUserDetails.CompanyDBConnectionString = objSelectedCompany.CompanyConnectionString;
                    objLoginUserDetails.CompanyName = objSelectedCompany.sCompanyDatabaseName;

                    objLoginUserDetails.IsUserLogin = false; //this flag indicate that user is not yet login sucessfully
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    IsLoginSetupSucceed = true;
                }
            }
            return IsLoginSetupSucceed;
        }
        #endregion

        #region //Private methods
        /// <summary>
        /// This method is used to get All the Authention request parameters from the XML
        /// </summary>
        private void GetAuthnRequest()
        {
            WriteToFileLog.Instance(_companyID).Write("GetAuthnRequest Initiated");
            DS_AuthnRequest.ReadXml(Convert.ToString(ConfigurationManager.AppSettings["ClientPublicCertificate"]) + @"\AuthnRequest.xml");
        }

        /// <summary>
        /// This method is used to create Authentication Request for SAML Authentication request 
        /// </summary>
        /// <returns>Returns SAML request with URLEncode</returns>
        private string CreateAuthnRequest()
        {
            WriteToFileLog.Instance(_companyID).Write("CreateAuthnRequest Initiated");
            using (StringWriter sw = new StringWriter())
            {
                XmlWriterSettings xws = new XmlWriterSettings();
                xws.OmitXmlDeclaration = true;
                string id;
                string issue_instant;
                id = "_" + System.Guid.NewGuid().ToString();
                issue_instant = DateTime.Now.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ");

                using (XmlWriter xw = XmlWriter.Create(sw, xws))
                {
                    xw.WriteStartElement("samlp", "AuthnRequest", "urn:oasis:names:tc:SAML:2.0:protocol");

                    xw.WriteAttributeString("xmlns", "saml", null, "urn:oasis:names:tc:SAML:2.0:assertion");
                    xw.WriteAttributeString("ID", id);
                    xw.WriteAttributeString("Version", "2.0");
                    xw.WriteAttributeString("IssueInstant", issue_instant);
                    xw.WriteAttributeString("ProtocolBinding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST");
                    xw.WriteAttributeString("Destination", DS_AuthnRequest.Tables[_companyID].Rows[0]["Destination"].ToString());
                    xw.WriteAttributeString("AssertionConsumerServiceURL", DS_AuthnRequest.Tables[_companyID].Rows[0]["AssertionConsumerServiceURL"].ToString());

                    xw.WriteStartElement("saml", "Issuer", null);
                    xw.WriteString(DS_AuthnRequest.Tables[_companyID].Rows[0]["Issuer"].ToString());
                    xw.WriteEndElement();

                    //xw.WriteStartElement("samlp", "NameIDPolicy", "urn:oasis:names:tc:SAML:2.0:protocol");
                    //xw.WriteAttributeString("Format", "urn:oasis:names:tc:SAML:2.0:nameid-format:unspecified");
                    //xw.WriteAttributeString("AllowCreate", "true");
                    //xw.WriteEndElement();

                    xw.WriteEndElement();
                }

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (StreamWriter writer = new StreamWriter(new DeflateStream(memoryStream, CompressionMode.Compress, true), new UTF8Encoding(false)))
                    {
                        writer.Write(sw.ToString());
                        writer.Close();
                        string result = Convert.ToBase64String(memoryStream.GetBuffer(), 0, (int)memoryStream.Length, Base64FormattingOptions.None);
                        result = HttpUtility.UrlEncode(result) + "&RelayState=" + HttpUtility.UrlEncode(DS_AuthnRequest.Tables[_companyID].Rows[0]["RelayState"].ToString());

                        WriteToFileLog.Instance(_companyID).Write("SAMLRequest=" + result);

                        return result;
                    }
                }
            }
        }

        internal string CreateNewAuthnRequest(ESOP.SSO.Library.SSO sSOFields)
        {
            WriteToFileLog.Instance(sSOFields.CompanyName).Write("CreateAuthnRequest Initiated");
            using (StringWriter sw = new StringWriter())
            {
                XmlWriterSettings xws = new XmlWriterSettings();
                xws.OmitXmlDeclaration = true;
                string id;
                string issue_instant;
                id = "_" + System.Guid.NewGuid().ToString();
                issue_instant = DateTime.Now.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ");

                using (XmlWriter xw = XmlWriter.Create(sw, xws))
                {
                    xw.WriteStartElement("samlp", "AuthnRequest", "urn:oasis:names:tc:SAML:2.0:protocol");

                    xw.WriteAttributeString("xmlns", "saml", null, "urn:oasis:names:tc:SAML:2.0:assertion");
                    xw.WriteAttributeString("ID", id);
                    xw.WriteAttributeString("Version", "2.0");
                    xw.WriteAttributeString("IssueInstant", issue_instant);
                    xw.WriteAttributeString("ProtocolBinding", "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST");
                    xw.WriteAttributeString("Destination", sSOFields.DestinationURL.Trim());
                    xw.WriteAttributeString("AssertionConsumerServiceURL", sSOFields.AssertionConsumerServiceURL.Trim());
                    xw.WriteStartElement("saml", "Issuer", null);
                    xw.WriteString(sSOFields.IssuerURL.Trim());
                    xw.WriteEndElement();
                }
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (StreamWriter writer = new StreamWriter(new DeflateStream(memoryStream, CompressionMode.Compress, true), new UTF8Encoding(false)))
                    {
                        writer.Write(sw.ToString());
                        writer.Close();
                        string result = Convert.ToBase64String(memoryStream.GetBuffer(), 0, (int)memoryStream.Length, Base64FormattingOptions.None);
                        result = HttpUtility.UrlEncode(result) + "&RelayState=" + HttpUtility.UrlEncode(sSOFields.RelayState.Trim());

                        WriteToFileLog.Instance(sSOFields.CompanyName).Write("SAMLRequest=" + result);

                        return result;
                    }
                }
            }
        }
        #endregion

        #region Destructors
        /// <summary>
        /// Default Destructors
        /// </summary>
        ~SSOModel()
        {
            Dispose();
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

    #region Response
    public class SAMLResponse : IDisposable
    {
        private string _companyID = string.Empty;
        public string CompanyID
        {
            get
            {
                return _companyID;
            }
            set
            {
                _companyID = value.ToUpper();
            }
        }

        private XmlDocument xmlDoc;

        private Certificate certificate;

        /// <summary>
        /// LoadXml
        /// </summary>
        /// <param name="xml">xml</param>
        public void LoadXml(string xml)
        {
            xmlDoc = new XmlDocument();
            xmlDoc.PreserveWhitespace = true;
            xmlDoc.XmlResolver = null;
            xmlDoc.LoadXml(xml);
        }

        /// <summary>
        /// LoadXmlFromBase64
        /// </summary>
        /// <param name="response">response</param>
        protected internal void LoadXmlFromBase64(string response)
        {
            LoadXml(new System.Text.ASCIIEncoding().GetString(Convert.FromBase64String(response)));
            ExtractX509Certificate();
            LoadCertificate(CompanyID);
        }

        private void ExtractX509Certificate()
        {
            foreach (XmlNode item in xmlDoc.GetElementsByTagName("ds:X509Certificate").Item(0).ChildNodes)
            {
                foreach (string perFile in Directory.GetFiles(Convert.ToString(ConfigurationManager.AppSettings["ClientPublicCertificate"]), "*.cer"))
                {
                    if (ExtensionsMethods.ReplaceSpecialChars(File.ReadAllText(perFile)).Equals(ExtensionsMethods.ReplaceSpecialChars(item.InnerText)))
                    {
                        CompanyID = perFile.Split('\\').Last().Replace(".cer", "");
                        _companyID = CompanyID;
                        break;
                    }
                }
                break;
            }
        }

        /// <summary>
        /// This method is used to Load client specific Public Certificate 
        /// </summary>
        /// <param name="CompanyID"></param>
        private void LoadCertificate(string CompanyID)
        {
            certificate = new Certificate();
            certificate.LoadCertificate(Convert.ToString(ConfigurationManager.AppSettings["ClientPublicCertificate"]) + CompanyID + ".cer");
        }

        /// <summary>
        /// Validate SAML response
        /// </summary>
        /// <param name="ht_SAMLParameters">Hashtable for SAML parameters</param>
        /// <param name="sb_WebParameters">StringBuilder to trace execution</param>
        /// <returns>bool</returns>
        public bool IsValid(out Hashtable ht_SAMLParameters, ref StringBuilder sb_WebParameters)
        {
            try
            {
                ht_SAMLParameters = new Hashtable();

                bool status = true;

                sb_WebParameters.AppendLine(CommonConstant.s_SelectNodesSignStart);

                XmlNamespaceManager manager = new XmlNamespaceManager(xmlDoc.NameTable);
                manager.AddNamespace("ds", SignedXml.XmlDsigNamespaceUrl);
                manager.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
                manager.AddNamespace("samlp", "urn:oasis:names:tc:SAML:2.0:protocol");
                XmlNodeList nodeList = xmlDoc.SelectNodes("//ds:Signature", manager);

                sb_WebParameters.AppendLine(CommonConstant.s_SelectNodesSignCompleted);
                using (DataSet DS_AuthnRequest = new DataSet())
                {
                    try
                    {
                        DS_AuthnRequest.ReadXml(Convert.ToString(ConfigurationManager.AppSettings["ClientPublicCertificate"]) + @"\AuthnRequest.xml");
                        sb_WebParameters.AppendLine(CommonConstant.s_SelectNodesAttrStatStart);

                        foreach (XmlNode item in xmlDoc.GetElementsByTagName("AttributeStatement").Item(0).ChildNodes)
                        {
                            if (item.Attributes.Item(0).Value.Split('/').Last().ToUpper().Equals(DS_AuthnRequest.Tables[CompanyID].Rows[0]["Atribute1ForEmail"].ToString().ToUpper()))
                            {
                                ht_SAMLParameters.Add(CommonConstant.s_AttributeEmail, item.InnerText);
                                sb_WebParameters.AppendLine("   " + CommonConstant.s_AttributeEmail + "-" + item.InnerText);
                            }
                        }
                        ht_SAMLParameters.Add(CommonConstant.s_AttributeComapnyName, "Vigilante_" + CompanyID);
                        sb_WebParameters.AppendLine("   " + CommonConstant.s_AttributeComapnyName + "-" + "Vigilante_" + CompanyID);
                        sb_WebParameters.AppendLine(CommonConstant.s_SelectNodesAttrStatCompleted);
                    }
                    catch (Exception exception)
                    {
                        throw new Exception(CommonConstant.s_SSONotImplemented + " " + CompanyID + ". Error Message : " + exception.Message.ToString());
                    }
                }


                sb_WebParameters.AppendLine(CommonConstant.s_CheckSignatureStart);

                SignedXml signedXml = new SignedXml(xmlDoc);
                signedXml.LoadXml((XmlElement)nodeList[0]);

                status &= signedXml.CheckSignature(certificate.cert, true);
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_CheckSignatureStatus, status));
                sb_WebParameters.AppendLine(CommonConstant.s_CheckSignatureCompleted);

                sb_WebParameters.AppendLine(CommonConstant.s_ValidateDateStart);
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_CurrentDate, Convert.ToDateTime(DateTime.Now)));

                var notBefore = NotBefore();
                status &= !notBefore.HasValue || (Convert.ToDateTime(notBefore) <= Convert.ToDateTime(DateTime.Now.AddMinutes(10)));
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_NotBeforeDate, notBefore));
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_NotBeforeStatus, status));

                var notOnOrAfter = NotOnOrAfter();
                status &= !notOnOrAfter.HasValue || (Convert.ToDateTime(notOnOrAfter) > Convert.ToDateTime(DateTime.Now));
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_NotBeforeDate, notOnOrAfter));
                sb_WebParameters.AppendLine(string.Format(CommonConstant.s_NotOnOrAfterStatus, status));
                sb_WebParameters.AppendLine(CommonConstant.s_ValidateDateCompleted);

                return status;
            }
            catch (Exception ex)
            {
                sb_WebParameters.AppendLine(CommonConstant.s_ErrorOccured + ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Extract "NotBefore" from SAML response
        /// </summary>
        /// <returns>DateTime</returns>
        public DateTime? NotBefore()
        {
            XmlNamespaceManager manager = new XmlNamespaceManager(xmlDoc.NameTable);
            manager.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
            manager.AddNamespace("samlp", "urn:oasis:names:tc:SAML:2.0:protocol");

            var nodes = xmlDoc.SelectNodes("/samlp:Response/saml:Assertion/saml:Conditions", manager);
            string value = null;
            if (nodes != null && nodes.Count > 0 && nodes[0] != null && nodes[0].Attributes != null && nodes[0].Attributes["NotBefore"] != null)
            {
                value = nodes[0].Attributes["NotBefore"].Value;
            }
            return value != null ? DateTime.Parse(value) : (DateTime?)null;
        }

        /// <summary>
        /// Extract "NotOnOrAfter" from SAML response
        /// </summary>
        /// <returns>DateTime</returns>
        public DateTime? NotOnOrAfter()
        {
            XmlNamespaceManager manager = new XmlNamespaceManager(xmlDoc.NameTable);
            manager.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
            manager.AddNamespace("samlp", "urn:oasis:names:tc:SAML:2.0:protocol");

            var nodes = xmlDoc.SelectNodes("/samlp:Response/saml:Assertion/saml:Conditions", manager);
            string value = null;
            if (nodes != null && nodes.Count > 0 && nodes[0] != null && nodes[0].Attributes != null && nodes[0].Attributes["NotOnOrAfter"] != null)
            {
                value = nodes[0].Attributes["NotOnOrAfter"].Value;
            }
            return value != null ? DateTime.Parse(value) : (DateTime?)null;
        }

        /// <summary>
        /// Extract "NameID"
        /// </summary>
        /// <returns>string</returns>
        public string GetNameID()
        {
            XmlNamespaceManager manager = new XmlNamespaceManager(xmlDoc.NameTable);
            manager.AddNamespace("ds", SignedXml.XmlDsigNamespaceUrl);
            manager.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
            manager.AddNamespace("samlp", "urn:oasis:names:tc:SAML:2.0:protocol");

            XmlNode node = xmlDoc.SelectSingleNode("/samlp:Response/saml:Assertion/saml:Subject/saml:NameID", manager);
            return node.InnerText;
        }


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
        /// virtual dispose method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
    #endregion

    #region Extract Certificate
    public class Certificate
    {
        public X509Certificate2 cert;

        /// <summary>
        /// LoadCertificate
        /// </summary>
        /// <param name="certificate">Certificate path</param>
        public void LoadCertificate(string certificate)
        {
            cert = new X509Certificate2();
            cert.Import(certificate);
        }

        /// <summary>
        /// Import certificate
        /// </summary>
        /// <param name="certificate">certificate byte</param>
        public void LoadCertificate(byte[] certificate)
        {
            cert = new X509Certificate2();
            cert.Import(certificate);
        }

        /// <summary>
        /// Convert string certificate to byte array
        /// </summary>
        /// <param name="st">certificate</param>
        /// <returns>byte</returns>
        private byte[] StringToByteArray(string st)
        {
            byte[] bytes = new byte[st.Length];
            for (int i = 0; i < st.Length; i++)
            {
                bytes[i] = (byte)st[i];
            }
            return bytes;
        }
    }
    #endregion

    #region ExtensionsMethods
    public static class ExtensionsMethods
    {
        internal static string ReplaceSpecialChars(string strValue)
        {
            return strValue.Replace("-----BEGIN CERTIFICATE-----", "").Replace("-----END CERTIFICATE-----", "").Replace("\n", "").Replace("\r", "");
        }
    }
    #endregion

    #region Common Constant Class
    public class CommonConstant
    {
        #region Common 
        public const string s_AttributeEmployeeId = "EmployeeId";
        public const string s_AttributeEmail = "EmailId";
        public const string s_AttributeComapnyName = "CompanyName";
        public const string s_SSOComapnyNameTGBL = "TGBL";
        public const string s_SSONotImplemented = "SSO Not Yet Implemented for company";
        #endregion

        #region Log messages                
        public const string s_SSORedirecting = "    Redirecting to Vigilanté application";
        public const string s_SSONotActivated = "  SSO is not activated for you. Please contact administrator.";
        public const string s_SSOProcessing = "Processing your request. Please wait...";

        public const string s_SelectNodesSignStart = "  Select Nodes '//ds:Signature' - Started";
        public const string s_SelectNodesSignCompleted = "  Select Nodes '//ds:Signature' - Completed\n";
        public const string s_SelectNodesAttrStatStart = "  Get Elements By TagName 'AttributeStatement' - Started";
        public const string s_SelectNodesAttrStatCompleted = "  Get Elements By TagName 'AttributeStatement' - Completed\n";
        public const string s_CheckSignatureStart = "  Check Signature - Started";
        public const string s_CheckSignatureStatus = "    Check Signature - status: {0}";
        public const string s_CheckSignatureCompleted = "  Check Signature - Completed\n";
        public const string s_ValidateDateStart = "  Validate data based on Date - Started";
        public const string s_CurrentDate = "    Validate data based on Date - Convert.ToDateTime(DateTime.Now): {0}";
        public const string s_ValidateDateCompleted = "  Validate data based on Date - Completed\n";
        public const string s_NotBeforeDate = "    Validate data based on Date - notBefore: {0}";
        public const string s_NotBeforeStatus = "    Validate data based on Date - status(notBefore): {0}";
        public const string s_NotOnOrAfterDate = "    Validate data based on Date - notOnOrAfter: {0}";
        public const string s_NotOnOrAfterStatus = "    Validate data based on Date - status(notOnOrAfter): {0}";
        public const string s_ErrorOccured = "Error occurred while validating SAML response : ";
        public const string s_RedirectToVigilante = "  Redirect to Vigilante Initiated";
        public const string s_LoginSetupFailed = "  Login Setup Failed";
        public const string s_InvalidResponse = "  Invalid SAML response";
        public const string s_InvalidAttribute = "  Invalid {0} found.";
        #endregion

        #region Request Messages
        public const string sRequestStatusNONE = "NONE";
        public const string sRequestStatusSSO_DEACTIVATED = "SSO_DEACTIVATED";
        public const string sRequestStatusSAML_REQUEST = "SAML_REQUEST";
        public const string sRequestStatusSAML_RESPONSE = "SAML_RESPONSE";

        #endregion
    }
    #endregion
}


