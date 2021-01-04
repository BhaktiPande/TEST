using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography.Xml;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace ESOP.SSO.Library
{
    #region Response
    public class SAMLResponse : IDisposable
    {
        private string CompanyID { get; set; }
        private string NotBeforeDateTime { get; set; }
        private string NotOnAfterDateTime { get; set; }
        private string SignatureValue { get; set; }
        private string Email { get; set; }
        private string EmployeeId { get; set; }
        private string NameId { get; set; }
        public bool IsSSOValidate { get; set; }
        public SSO SsoProperty { get; set; }
        private DataTable dataTableSSOCompanyDetails { get; set; }
        private string CertificateKey { get; set; }
        private byte[] StoredCertificateKeyFromDatabase { get; set; }
        private StringBuilder stringBuilderForCustomMessage = new StringBuilder();
        private XmlDocument requestXmlDocument;
        private Certificate certificate;
        /// <summary>
        /// LoadXml And Extract from XML into DataSet
        /// </summary>
        /// <param name="responseXml">xml</param>
        private void LoadXml(string responseXml)
        {
            WriteLog.Instance().InfoLog("Load xml: ESOP.SSO.Library \n");
            requestXmlDocument = new XmlDocument();
            requestXmlDocument.PreserveWhitespace = true;
            requestXmlDocument.XmlResolver = null;
            requestXmlDocument.LoadXml(responseXml);
            ConvertXMLDataToDataSet(responseXml);
        }

        /// <summary>
        /// Here XML data extract into DataSet
        /// </summary>
        /// <param name="xml"></param>
        private void ConvertXMLDataToDataSet(string responseXml)
        {
            try
            {
                if (!string.IsNullOrEmpty(responseXml))
                {
                    string pattern = @"(</?)(\w+:)";
                    string output = Regex.Replace(responseXml, pattern, "$1");
                    StringReader reader = new StringReader(output);
                    GetSSOAttributeValue(reader);
                    FillSsoProperty();
                }
                else
                {
                    WriteLog.Instance().InfoLog("SAML Response not found. ConvertXMLDataToDataSet(): ESOP.SSO.Library \n");
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }

        private void GetSSOAttributeValue(StringReader reader)
        {
            using (DataSet ds = new DataSet())
            {
                ds.ReadXml(reader);
                if (!ds.Equals(null) && ds.Tables.Count > 0)
                {
                    for (int i = 0; i < ds.Tables.Count; i++)
                    {
                        switch (ds.Tables[i].ToString().ToUpper())
                        {
                            case "ATTRIBUTE":
                                GetAttributeNameValue(ds.Tables[i]);
                                break;
                            case "CONDITIONS": // Here Getting NotBefore and NotOnOrAfter dateTime value
                                GetConditionNotBeforeNotAfter(ds.Tables[i]);
                                break;
                            case "SIGNATURE": // Here Getting signature value
                                GetSignatureValue(ds.Tables[i]);
                                break;
                            case "NAMEID": // Here Getting NameID value
                                GetNameID(ds.Tables[i]);
                                break;
                            case "X509DATA": // Here Getting NameID value
                                GetX509Certificate(ds.Tables[i]);
                                break;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Here Fill the All SSO Properties getting By SAML Response and SSOConfiguration
        /// </summary>
        private void FillSsoProperty()
        {
            try
            {
                SsoProperty = new SSO();
                SsoProperty.CompanyName = CompanyID;
                SsoProperty.AttributeCompanyFromSAMLResponse = CompanyID;
                SsoProperty.AttributeEmailFromSAMLResponse = Email;
                SsoProperty.AttributeEmployeeIDFromSAMLResponse = EmployeeId;
                SsoProperty.NameIDFromSAMLResponse = NameId;
                SsoProperty.NotBeforeSAMLResponse = DateTime.Parse(NotBeforeDateTime);
                SsoProperty.NotOnOrAfterSAMLResponse = DateTime.Parse(NotOnAfterDateTime);
                SsoProperty.SignatureValueFromSAMLResponse = SignatureValue;
                SsoProperty.X509CertificateFromSAMLResponse = CertificateKey;
                //=== Fetch SSO Company List From ESOP Manager DB in SSOConfiguration Table ===//
                GetSSOCompanyList();

            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }

        private void GetSSOCompanyList()
        {
            DataTable dataTableSSOCompanyList = new DataTable();
            dataTableSSOCompanyList = Generic.Instance().GetAllSsoCompanyList();
            if (dataTableSSOCompanyList != null && dataTableSSOCompanyList.Rows.Count > 0)
            {
                FilterSSOConfigurationData(dataTableSSOCompanyList);
            }
            else
            {
                SetCustomMessage(false, "SSO Details are not found in the data base.\n");
            }
        }

        private void FilterSSOConfigurationData(DataTable dataTableSSOCompanyList)
        {
            try
            {
                string _sqlWhere = null; string idfcFirstbankName = "IDFC FIRST Bank Limited";
                if (!string.IsNullOrEmpty(CompanyID))
                {
                    if (idfcFirstbankName.ToLower() == CompanyID.ToLower())
                    {
                        SsoProperty.CompanyName = CompanyID = "IDFCFIRSTBANK";
                    }
                    _sqlWhere = "CompanyName = '" + CompanyID.Trim() + "'";
                }
                else if (!string.IsNullOrEmpty(CertificateKey))
                {
                    _sqlWhere = "Certificate = '" + ExtensionsMethods.ReplaceSpecialChars(SsoProperty.X509CertificateFromSAMLResponse) + "'";
                }
                if (!string.IsNullOrEmpty(_sqlWhere))
                {
                    dataTableSSOCompanyDetails = new DataTable();
                    dataTableSSOCompanyDetails = dataTableSSOCompanyList.Select(_sqlWhere).CopyToDataTable();
                    //IF SAML response have X509Certificate then Compare CertificateKey from database and get CompanyID from Database===//
                    if (!string.IsNullOrEmpty(SsoProperty.X509CertificateFromSAMLResponse))
                    {
                        if (ExtensionsMethods.ReplaceSpecialChars(SsoProperty.X509CertificateFromSAMLResponse) == ExtensionsMethods.ReplaceSpecialChars(dataTableSSOCompanyDetails.Rows[0]["Certificate"].ToString()))
                        {
                            if (!string.IsNullOrEmpty(dataTableSSOCompanyDetails.Rows[0]["CompanyName"].ToString()))
                            {
                                FillSSOAllDetails(dataTableSSOCompanyDetails.Rows[0]);
                            }
                        }
                    }
                    else
                    {
                        //Whenever Call IDFC FIRST BANK then Change the CompanyID due to as per Database name, This is special case due not provide X509Certificate.
                        WithoutX509Crtificate();
                    }
                }
                else
                {
                    WriteLog.Instance().CustomErrorLog("SSO Configuration Data not found.");
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }

        private void WithoutX509Crtificate()
        {
            try
            {
                if (SsoProperty.CompanyName.ToUpper() == dataTableSSOCompanyDetails.Rows[0]["CompanyName"].ToString().ToUpper())
                {
                    FillSSOAllDetails(dataTableSSOCompanyDetails.Rows[0]);
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }

        /// <summary>
        /// Filter Company and get All details of SSO Configuration of that company .
        /// </summary>
        /// <param name="dataRow"></param>
        //private void FillSSOAllDetails(DataRow dataRow)
        //{
        //    try
        //    {
        //        //  TBD_Jeet
        //        /*
        //        SSO ssoDetails = CommonMethod.GetItemByDataRow<SSO>(dataRow);
        //        SsoProperty.CompanyName = CompanyID = ssoDetails.CompanyName;
        //        SsoProperty.Certificate = ssoDetails.Certificate;
        //        SsoProperty.CertificateName = ssoDetails.CertificateName;
        //        SsoProperty.Status = ssoDetails.Status;
        //        SsoProperty.SSOId = ssoDetails.SSOId;
        //        SsoProperty.RelayState = ssoDetails.RelayState;
        //        SsoProperty.Parameters = ssoDetails.Parameters;
        //        SsoProperty.IssuerURL = ssoDetails.IssuerURL;
        //        SsoProperty.IsSSOLoginActiveForEmp = ssoDetails.IsSSOLoginActiveForEmp;
        //        SsoProperty.IsSSOLoginActiveForCR = ssoDetails.IsSSOLoginActiveForCR;
        //        SsoProperty.InsertionType = ssoDetails.InsertionType;
        //        SsoProperty.IDP_SP_URL = ssoDetails.IDP_SP_URL;
        //        SsoProperty.DestinationURL = ssoDetails.DestinationURL;
        //        SsoProperty.AssertionConsumerServiceURL = ssoDetails.AssertionConsumerServiceURL;
        //        SsoProperty.GroupName = ssoDetails.GroupName;
        //        SsoProperty.GroupID = ssoDetails.GroupID; */



        //        WriteMessage();
        //    }
        //    catch (Exception ex)
        //    {
        //        WriteLog.Instance().ExceptionErrorLog(ex);
        //    }
        //}

        /// <summary>
        /// Filter Company and get All details of SSO Configuration of that company .
        /// </summary>
        /// <param name="dataRow"></param>
        private void FillSSOAllDetails(DataRow dataRow)
        {
            try
            {
                SsoProperty.CompanyName = CompanyID = string.IsNullOrEmpty(Convert.ToString(dataRow["CompanyName"])) ? string.Empty : Convert.ToString(dataRow["CompanyName"]);
                SsoProperty.Certificate = string.IsNullOrEmpty(Convert.ToString(dataRow["Certificate"])) ? string.Empty : Convert.ToString(dataRow["Certificate"]);
                SsoProperty.CertificateName = string.IsNullOrEmpty(Convert.ToString(dataRow["CertificateName"])) ? string.Empty : Convert.ToString(dataRow["CertificateName"]);
                SsoProperty.Status = Convert.ToBoolean(dataRow["Status"]);
                SsoProperty.SSOId = Convert.ToInt32(dataRow["SSOId"].ToString());
                SsoProperty.RelayState = string.IsNullOrEmpty(Convert.ToString(dataRow["RelayState"])) ? string.Empty : Convert.ToString(dataRow["RelayState"]);
                SsoProperty.Parameters = string.IsNullOrEmpty(Convert.ToString(dataRow["Parameters"])) ? string.Empty : Convert.ToString(dataRow["Parameters"]);
                SsoProperty.IssuerURL = string.IsNullOrEmpty(Convert.ToString(dataRow["IssuerURL"])) ? string.Empty : Convert.ToString(dataRow["IssuerURL"]);

                //IsSSOLoginActiveForEmployee
                if (dataRow["IsSSOLoginActiveForEmployee"].ToString().Equals(null))
                {
                    SsoProperty.IsSSOLoginActiveForEmployee = false;
                }
                else
                {
                    SsoProperty.IsSSOLoginActiveForEmployee = Convert.ToBoolean(dataRow["IsSSOLoginActiveForEmployee"].ToString());
                }
                //IsSSOLoginActiveForCO
                if (dataRow["IsSSOLoginActiveForCO"].ToString().Equals(null))
                {
                    SsoProperty.IsSSOLoginActiveForCO = false;
                }
                else
                {
                    SsoProperty.IsSSOLoginActiveForCO = Convert.ToBoolean(dataRow["IsSSOLoginActiveForCO"].ToString());
                }
                //  IsSSOLoginActiveForNonEmployee
                if (dataRow["IsSSOLoginActiveForNonEmployee"].ToString().Equals(null))
                {
                    SsoProperty.IsSSOLoginActiveForNonEmployee = false;
                }
                else
                {
                    SsoProperty.IsSSOLoginActiveForNonEmployee = Convert.ToBoolean(dataRow["IsSSOLoginActiveForNonEmployee"].ToString());
                }
                // IsSSOLoginActiveForCorporateUser
                if (dataRow["IsSSOLoginActiveForCorporateUser"].ToString().Equals(null))
                {
                    SsoProperty.IsSSOLoginActiveForCorporateUser = false;
                }
                else
                {
                    SsoProperty.IsSSOLoginActiveForCorporateUser = Convert.ToBoolean(dataRow["IsSSOLoginActiveForCorporateUser"].ToString());
                }


                SsoProperty.InsertionType = string.IsNullOrEmpty(Convert.ToString(dataRow["InsertionType"])) ? string.Empty : Convert.ToString(dataRow["InsertionType"]);
                SsoProperty.IDP_SP_URL = string.IsNullOrEmpty(Convert.ToString(dataRow["IDP_SP_URL"])) ? string.Empty : Convert.ToString(dataRow["IDP_SP_URL"]);
                SsoProperty.DestinationURL = string.IsNullOrEmpty(Convert.ToString(dataRow["DestinationURL"])) ? string.Empty : Convert.ToString(dataRow["DestinationURL"]);
                SsoProperty.AssertionConsumerServiceURL = string.IsNullOrEmpty(Convert.ToString(dataRow["AssertionConsumerServiceURL"])) ? string.Empty : Convert.ToString(dataRow["AssertionConsumerServiceURL"]);
                SsoProperty.GroupName = string.IsNullOrEmpty(Convert.ToString(dataRow["GroupName"])) ? string.Empty : Convert.ToString(dataRow["GroupName"]);
                SsoProperty.GroupID = SsoProperty.GroupID.HasValue ? SsoProperty.GroupID.Value : 0;
                WriteMessage();
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private void WriteMessage()
        {
            stringBuilderForCustomMessage.AppendLine("**********************====================================================== SSO Details =============================================================**********************\n");
            stringBuilderForCustomMessage.AppendLine("CompanyID: " + SsoProperty.CompanyName + "\n");
            stringBuilderForCustomMessage.AppendLine("AttributeEmailFromSAMLResponse: " + Email + "\n");
            stringBuilderForCustomMessage.AppendLine("NameIDFromSAMLResponse: " + SsoProperty.NameIDFromSAMLResponse + "\n");
        }

        #region Get assential Details from Saml Response after Convert Xml into DataSet
        private void GetX509Certificate(DataTable dataTable)
        {
            try
            {
                if (!dataTable.Equals(null) && dataTable.Rows.Count > 0)
                {
                    CertificateKey = dataTable.Rows[0]["X509Certificate"].ToString();
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private void GetNameID(DataTable dataTable)
        {
            try
            {
                if (!dataTable.Equals(null) && dataTable.Rows.Count > 0)
                {
                    NameId = dataTable.Rows[0]["NameID_Text"].ToString();
                    if (NameId.Contains('@'))
                    {
                        Email = NameId;
                    }
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private void GetSignatureValue(DataTable dataTable)
        {
            try
            {
                if (!dataTable.Equals(null) && dataTable.Rows.Count > 0)
                {
                    SignatureValue = dataTable.Rows[0]["SignatureValue"].ToString();
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private void GetConditionNotBeforeNotAfter(DataTable dataTable)
        {
            try
            {
                if (!dataTable.Equals(null) && dataTable.Rows.Count > 0)
                {
                    NotBeforeDateTime = dataTable.Rows[0]["NotBefore"].ToString();
                    NotOnAfterDateTime = dataTable.Rows[0]["NotOnOrAfter"].ToString();
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private void GetAttributeNameValue(DataTable dataTable)
        {
            try
            {
                string attributeName = "";
                string attributevalue = "";
                if (!dataTable.Equals(null) && dataTable.Rows.Count > 0)
                {
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {

                        attributeName = dataTable.Rows[i]["Name"].ToString();
                        attributevalue = dataTable.Rows[i]["AttributeValue"].ToString();
                        MatchingKeyWordOfSSoAttributeName(attributeName, attributevalue);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
        }
        private bool IsContainsAttributeKey(string source, params string[] values)
        {
            bool iSmatched = false;
            foreach (var item in values)
            {
                if (source.ToLower().Contains(item.ToLower()))
                {
                    return iSmatched = true;
                }
            }
            return iSmatched;
            //return values.All(x => source.ToUpper().Contains(x));
        }
        private void MatchingKeyWordOfSSoAttributeName(string attributeName, string attributevalue)
        {
            bool iSAttributeNameMatched = IsSSOEmailAttributeNameMatched(attributeName, attributevalue);
            if (!iSAttributeNameMatched.Equals(true))
            {
                iSAttributeNameMatched = IsSSOCompanyAttributeNameMatched(attributeName, attributevalue);
                if (!iSAttributeNameMatched.Equals(true))
                {
                    iSAttributeNameMatched = IsSSOEmployeeAttributeNameMatched(attributeName, attributevalue);
                }
            }
        }

        private bool IsSSOEmployeeAttributeNameMatched(string attributeName, string attributevalue)
        {
            string[] employeeKeyWord = new string[] { "EMPLOYEEID", "EMPLOYEE", "EMPLOYEENAME", "USERID", "USERNAME" };
            bool iSEmployeeAttributeNameMatched = IsContainsAttributeKey(attributeName, employeeKeyWord);
            if (iSEmployeeAttributeNameMatched.Equals(true))
            {
                EmployeeId = attributevalue;
            }
            return iSEmployeeAttributeNameMatched;
        }

        private bool IsSSOCompanyAttributeNameMatched(string attributeName, string attributevalue)
        {
            string[] companyKeyWord = new string[] { "COMPANY", "COMPANYNAME", "COMPANYID", "COMPANYIDNAME" };
            bool iSCompanyAttributeNameMatched = IsContainsAttributeKey(attributeName, companyKeyWord);
            if (iSCompanyAttributeNameMatched.Equals(true))
            {
                CompanyID = attributevalue;
            }
            return iSCompanyAttributeNameMatched;
        }

        private bool IsSSOEmailAttributeNameMatched(string attributeName, string attributevalue)
        {
            string[] emailsKeyWord = new string[] { "MAIL", "EMAILID", "EMAIL", "EMAILADDRESS", "MAILID", "MAILADDRESS" };
            bool iSEmailAttributeNameMatched = IsContainsAttributeKey(attributeName, emailsKeyWord);
            if (iSEmailAttributeNameMatched.Equals(true))
            {
                Email = attributevalue;
            }
            return iSEmailAttributeNameMatched;
        }
        #endregion

        /// <summary>
        /// Sequencelly Execute Functions LoadXmlFromBase64, CertificateKey Into Byte[],LoadCertificate(StoredCertificateKeyInDB),
        ///  ValidateSignature() and  ValidateNotBeforeAndNotOnAfter(NotBeforeDateTime, NotOnAfterDateTime)
        /// </summary>
        /// <param name="response">response</param>
        public void LoadXmlFromBase64(string response)
        {
            WriteLog.Instance().InfoLog("Load xml FromBase64");
            stringBuilderForCustomMessage.AppendLine("SAMALResponse:" + response);
            if (!string.IsNullOrEmpty(response))
            {
                LoadXml(new System.Text.ASCIIEncoding().GetString(Convert.FromBase64String(response)));
                StoredCertificateKeyFromDatabase = StringToByteArray(SsoProperty.Certificate);
                if (StoredCertificateKeyFromDatabase != null)
                {
                    LoadCertificate(StoredCertificateKeyFromDatabase);
                    ValidateSignature();
                    ValidateNotBeforeAndNotOnAfter(NotBeforeDateTime, NotOnAfterDateTime);
                    SetCustomMessage(IsSSOValidate, "");
                }
                else
                {
                    SetCustomMessage(false, "Certificate Key is Null/Empty/Mismatch.");
                }
            }
            else
            {
                SetCustomMessage(false, "LoadXmlFromBase64 parameter is Null or Empty.");
            }
        }

        private void SetCustomMessage(bool iSValidateSSO, string message)
        {
            WriteLog.Instance().InfoLog(stringBuilderForCustomMessage.ToString());
        }

        /// <summary>
        /// Signature Key validate.
        /// If Signature key validate successfull then IsSSOValidate true otherwise false.
        /// </summary>
        private void ValidateSignature()
        {
            XmlNamespaceManager manager = new XmlNamespaceManager(requestXmlDocument.NameTable);
            manager.AddNamespace("ds", SignedXml.XmlDsigNamespaceUrl);
            manager.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
            manager.AddNamespace("samlp", "urn:oasis:names:tc:SAML:2.0:protocol");
            XmlNodeList nodeList = requestXmlDocument.SelectNodes("//ds:Signature", manager);
            SignedXml signedXml = new SignedXml(requestXmlDocument);
            signedXml.LoadXml((XmlElement)nodeList[0]);
            IsSSOValidate = signedXml.CheckSignature(certificate.cert, true);
            if (IsSSOValidate.Equals(true))
            {
                stringBuilderForCustomMessage.AppendLine("Signature Key validate successfull.");
            }
            else
            {
                stringBuilderForCustomMessage.AppendLine("Signature Key is not validate.");
            }
        }
        /// <summary>
        /// Convert certificate key(string) into Byte[]
        /// </summary>
        /// <param name="certificateKey"></param>
        /// <returns>Byte[] array</returns>
        private byte[] StringToByteArray(string certificateKey)
        {
            byte[] bytes = null;
            try
            {
                if (!string.IsNullOrEmpty(certificateKey))
                {
                    bytes = new byte[certificateKey.Length];
                    for (int i = 0; i < certificateKey.Length; i++)
                    {
                        bytes[i] = (byte)certificateKey[i];
                    }
                }
                else
                {
                    bytes = null;
                }
            }
            catch (Exception ex)
            {
                WriteLog.Instance().ExceptionErrorLog(ex);
            }
            return bytes;
        }
        /// <summary>
        /// Here Validate Not Before and NotOnAfter datetime, which is given by SAML Response.
        /// If Validate Not Before and NotOnAfter datetime successfull then IsSSOValidate true otherwise false.
        /// </summary>
        /// <param name="notBeforeVal"></param>
        /// <param name="notOnAfterVal"></param>
        private void ValidateNotBeforeAndNotOnAfter(string notBeforeVal, string notOnAfterVal)
        {
            if (string.IsNullOrEmpty(notBeforeVal))
            {
                stringBuilderForCustomMessage.AppendLine("NotBefore is null or empty. \n");
                IsSSOValidate = false;
            }
            else if (string.IsNullOrEmpty(notOnAfterVal))
            {
                stringBuilderForCustomMessage.AppendLine("NotOnAfter is null or empty Before.\n");
                IsSSOValidate = false;
            }
            else
            {
                var notBefore = NotBefore(notBeforeVal);
                SsoProperty.NotBeforeSAMLResponse = notBefore;
                IsSSOValidate &= !notBefore.HasValue || (Convert.ToDateTime(notBeforeVal) <= Convert.ToDateTime(DateTime.Now.AddMinutes(10)));
                stringBuilderForCustomMessage.AppendLine(string.Format(CommonConstant.s_NotBeforeDate, notBefore));
                stringBuilderForCustomMessage.AppendLine(string.Format(CommonConstant.s_NotBeforeStatus, IsSSOValidate));
                var notOnOrAfter = NotOnOrAfter(notOnAfterVal);
                SsoProperty.NotOnOrAfterSAMLResponse = notOnOrAfter;
                IsSSOValidate &= !notOnOrAfter.HasValue || (Convert.ToDateTime(notOnOrAfter) > Convert.ToDateTime(DateTime.Now.AddMinutes(-5)));
                stringBuilderForCustomMessage.AppendLine(string.Format(CommonConstant.s_NotOnOrAfterDate, notOnOrAfter));
                stringBuilderForCustomMessage.AppendLine(string.Format(CommonConstant.s_NotOnOrAfterStatus, IsSSOValidate));
            }

        }

        /// <summary>
        /// Convert Certificate Byte into certificate(cer).
        /// </summary>
        /// <param name="byteArray"></param>
        private void LoadCertificate(byte[] byteArray)
        {
            if (!byteArray.Equals(null))
            {
                certificate = new Certificate();
                certificate.LoadCertificate(byteArray);
            }
            else
            {
                stringBuilderForCustomMessage.AppendLine("Certificate Key is Null or Empty.");
            }

        }

        /// <summary>
        /// Extract "NotBefore"
        /// </summary>
        /// <returns>DateTime</returns>
        private DateTime? NotBefore(string value)
        {
            return value != null ? DateTime.Parse(value) : (DateTime?)null;
        }

        /// <summary>
        /// Extract "NotOnOrAfter"
        /// </summary>
        /// <returns>DateTime</returns>
        private DateTime? NotOnOrAfter(string value)
        {
            return value != null ? DateTime.Parse(value) : (DateTime?)null;
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
            if (!certificate.Equals(null))
            {
                cert = new X509Certificate2();
                cert.Import(certificate);
            }
            else
            {

            }
        }

        /// <summary>
        /// Convert string certificate to byte array
        /// </summary>
        /// <param name="st">certificate</param>
        /// <returns>byte</returns>
        public byte[] StringToByteArray(string st)
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
    class CommonConstant
    {
        #region Common Constants
        public const string s_AttributeEmail = "EmailID";
        public const string s_AttributeComapnyName = "CompanyName";
        #endregion

        #region Log messages
        public const string s_NotBeforeDate = "****************** Validate data based on Date - notBefore: {0} *********";
        public const string s_NotBeforeStatus = "****************** Validate data based on Date - status(notBefore): {0} *********\n";
        public const string s_NotOnOrAfterDate = "****************** Validate data based on Date - notOnOrAfter: {0} *********\n";
        public const string s_NotOnOrAfterStatus = "****************** Validate data based on Date - status(notOnOrAfter): {0} *********";
        #endregion
    }
    #endregion
}
