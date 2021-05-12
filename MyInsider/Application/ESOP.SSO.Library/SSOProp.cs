using System;

namespace ESOP.SSO.Library
{
    public class SSO
    {
        public int SSOId { get; set; }
        public int? GroupID { get; set; }
        public string GroupName { get; set; }
        public string InsertionType { get; set; }
        public string CompanyName { get; set; }
        public string IDP_SP_URL { get; set; }
        public string DestinationURL { get; set; }
        public string AssertionConsumerServiceURL { get; set; }
        public string IssuerURL { get; set; }
        public string RelayState { get; set; }
        public string CertificateName { get; set; }
        public string Certificate { get; set; }
        public bool Status { get; set; }
        public string Parameters { get; set; }

        public bool? IsSSOLoginActiveForEmployee { get; set; }

        public bool? IsSSOLoginActiveForCO { get; set; }

        public bool? IsSSOLoginActiveForNonEmployee { get; set; }

        public bool? IsSSOLoginActiveForCorporateUser { get; set; }

        public string X509CertificateFromSAMLResponse { get; set; }

        public string SignatureValueFromSAMLResponse { get; set; }

        public DateTime? NotBeforeSAMLResponse { get; set; }
        public DateTime? NotOnOrAfterSAMLResponse { get; set; }
        public string AttributeCompanyFromSAMLResponse { get; set; }
        public string AttributeEmailFromSAMLResponse { get; set; }
        public string AttributeEmployeeIDFromSAMLResponse { get; set; }
        public string NameIDFromSAMLResponse { get; set; }
        public bool IsValidateSSO { get; set; }
        public string Message { get; set; }
        public string UPNFromSAMALResponse { get; set; }
        
    }
}
