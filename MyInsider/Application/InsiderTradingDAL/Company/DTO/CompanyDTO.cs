using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("Companies")]
    public class CompanyDTO
    {
        [PetaPoco.Column("CompanyId")]
        public int nCompanyId { get; set; }
        [PetaPoco.Column("CompanyName")]
        public string sCompanyName { get; set; }
        [PetaPoco.Column("ConnectionServer")]
        public string sCompanyServer { get; set; }
        [PetaPoco.Column("ConnectionDatabaseName")]
        public string sCompanyDatabaseName { get; set; }
        [PetaPoco.Column("ConnectionUserName")]
        public string sCompanySAUser { get; set; }
        [PetaPoco.Column("ConnectionPassword")]
        public string sCompanySAPassword { get; set; }
        [PetaPoco.Column("UpdateResources")]
        public int nUpdateResources { get; set; }

        [PetaPoco.Column("HIMSConnectionServer")]
        public string sHIMSConnectionServer { get; set; }

        [PetaPoco.Column("HIMSConnectionDatabaseName")]
        public string sHIMSConnectionDatabaseName { get; set; }

        [PetaPoco.Column("HIMSConnectionUserName")]
        public string sHIMSConnectionUserName { get; set; }

        [PetaPoco.Column("HIMSConnectionPassword")]
        public string sHIMSConnectionPassword { get; set; }

        [PetaPoco.Column("HIMSViewName")]
        public string sHIMSViewName { get; set; }

        public string sCompanyConnectionString;

        public string sHIMSConnectionString;

        [PetaPoco.Column("IsSSOActivated")]
        public bool bIsSSOActivated { get; set; }

        [PetaPoco.Column("SSOUrl")]
        public string sSSOUrl { get; set; }


        #region Properties
        #region CompanyConnectionString
        /// Gets or CompanyConnectionString
        public string CompanyConnectionString
        {
            get
            {
                sCompanyConnectionString = "data source="+this.sCompanyServer+";initial catalog="+this.sCompanyDatabaseName+";persist security info=True;user id="+this.sCompanySAUser+";Password="+this.sCompanySAPassword+";MultipleActiveResultSets=True;";
                return sCompanyConnectionString;
            }
            set
            {
                sCompanyConnectionString = value;
            }
        }
        /// <summary>
        /// This will create the connection string for the given company and will add the Connection Timeout as specified.
        /// </summary>
        /// <param name="nConnectionTimeOutInSeconds"></param>
        /// <returns></returns>
        public string CompanyConnectionStringWithTimeout(int nConnectionTimeOutInSeconds)
        {
            return "data source=" + this.sCompanyServer + ";initial catalog=" + this.sCompanyDatabaseName + ";persist security info=True;user id=" + this.sCompanySAUser + ";Password=" + this.sCompanySAPassword + ";MultipleActiveResultSets=True;Connect Timeout=" + nConnectionTimeOutInSeconds;
        }
        #endregion CompanyConnectionString

        #region HIMSConnectionString
        /// Gets or CompanyConnectionString
        public string HIMSConnectionString
        {
            get
            {
                sHIMSConnectionString = "data source=" + this.sHIMSConnectionServer + ";initial catalog=" + this.sHIMSConnectionDatabaseName + ";persist security info=True;user id=" + this.sHIMSConnectionUserName + ";Password=" + this.sHIMSConnectionPassword + ";MultipleActiveResultSets=True;";
                return sHIMSConnectionString;
            }
            set
            {
                sHIMSConnectionString = value;
            }
        }

        /// <summary>
        /// This will create the connection string for the given HIMS company and will add the Connection Timeout as specified.
        /// </summary>
        /// <param name="nConnectionTimeOutInSeconds"></param>
        /// <returns></returns>
        public string HIMSConnectionStringWithTimeout(int nConnectionTimeOutInSeconds)
        {
            return "data source=" + this.sHIMSConnectionServer + ";initial catalog=" + this.sHIMSConnectionDatabaseName + ";persist security info=True;user id=" + this.sHIMSConnectionUserName + ";Password=" + this.sHIMSConnectionPassword + ";MultipleActiveResultSets=True;Connection Timeout=" + nConnectionTimeOutInSeconds;
        }
        #endregion HIMSConnectionString

        #endregion Properties
    }

    [PetaPoco.TableName("mst_Company")]
    public class ImplementedCompanyDTO
    {
        [PetaPoco.Column("CompanyId")]
        public int? CompanyId { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("Address")]
        public string Address { get; set; }

        [PetaPoco.Column("Website")]
        public string Website { get; set; }

        [PetaPoco.Column("EmailId")]
        public string EmailId { get; set; }

        public int LoggedInUserId { get; set; }

        [PetaPoco.Column("IsImplementing")]
        public bool IsImplementing { get; set; }

        [PetaPoco.Column("ISINNumber")]
        public string ISINNumber { get; set; }

        [PetaPoco.Column("ContraTradeOption")]
        public int? ContraTradeOption { get; set; }

        [PetaPoco.Column("AutoSubmitTransaction")]
        public int? AutoSubmitTransaction { get; set; }
                
        [PetaPoco.Column("SmtpServer")]
        public string SmtpServer { get; set; }
        
        [PetaPoco.Column("SmtpPortNumber")]
        public string SmtpPortNumber { get; set; }

        [PetaPoco.Column("SmtpUserName")]
        public string SmtpUserName { get; set; }

        [PetaPoco.Column("SmtpPassword")]
        public string SmtpPassword { get; set; }

        [PetaPoco.Column("IsMCQRequired")]
        public int IsMCQRequired { get; set; }

        [PetaPoco.Column("IsPreClearanceEditable")]
        public int? IsPreClearanceEditable { get; set; }
        
    }

    [PetaPoco.TableName("com_CompanyFaceValue")]
    public class CompanyFaceValueDTO
    {
        [PetaPoco.Column("CompanyFaceValueID")]
        public int? CompanyFaceValueID { get; set; }

        [PetaPoco.Column("CompanyID")]
        public int? CompanyID { get; set; }

        [PetaPoco.Column("FaceValueDate")]
        public DateTime? FaceValueDate { get; set; }

        [PetaPoco.Column("FaceValue")]
        public Decimal FaceValue { get; set; }

        [PetaPoco.Column("CurrencyID")]
        public int? CurrencyID { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("CurrencyName")]
        public string CurrencyName { get; set; }


        public int LoggedInUserId { get; set; }

    }

    [PetaPoco.TableName("com_CompanyAuthorizedShareCapital")]
    public class CompanyAuthorizedShareCapitalDTO
    {
        [PetaPoco.Column("CompanyAuthorizedShareCapitalID")]
        public int? CompanyAuthorizedShareCapitalID { get; set; }

        [PetaPoco.Column("CompanyID")]
        public int? CompanyID { get; set; }

        [PetaPoco.Column("AuthorizedShareCapitalDate")]
        public DateTime? AuthorizedShareCapitalDate { get; set; }

        [PetaPoco.Column("AuthorizedShares")]
        public Decimal AuthorizedShares { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        public int LoggedInUserId { get; set; }

    }

    [PetaPoco.TableName("com_CompanyPaidUpAndSubscribedShareCapital")]
    public class CompanyPaidUpAndSubscribedShareCapitalDTO
    {
        [PetaPoco.Column("CompanyPaidUpAndSubscribedShareCapitalID")]
        public int? CompanyPaidUpAndSubscribedShareCapitalID { get; set; }

        [PetaPoco.Column("PaidUpAndSubscribedShareCapitalDate")]
        public DateTime? PaidUpAndSubscribedShareCapitalDate { get; set; }

        [PetaPoco.Column("PaidUpShare")]
        public Decimal PaidUpShare { get; set; }

        [PetaPoco.Column("CompanyID")]
        public int? CompanyID { get; set; }

        public int LoggedInUserId { get; set; }

    }

    [PetaPoco.TableName("com_CompanyListingDetails")]
    public class CompanyListingDetailsDTO
    {
        [PetaPoco.Column("CompanyListingDetailsID")]
        public int? CompanyListingDetailsID { get; set; }

        [PetaPoco.Column("StockExchangeID")]
        public int? StockExchangeID { get; set; }

        [PetaPoco.Column("DateOfListingFrom")]
        public DateTime? DateOfListingFrom { get; set; }

        [PetaPoco.Column("DateOfListingTo")]
        public DateTime? DateOfListingTo { get; set; }

        [PetaPoco.Column("CompanyID")]
        public int? CompanyID { get; set; }

        public int LoggedInUserId { get; set; }
    }

    [PetaPoco.TableName("com_CompanyComplianceOfficer")]
    public class CompanyComplianceOfficerDTO
    {
        [PetaPoco.Column("CompanyComplianceOfficerId")]
        public int? CompanyComplianceOfficerId { get; set; }

        [PetaPoco.Column("CompanyId")]
        public int? CompanyId { get; set; }

        [PetaPoco.Column("ComplianceOfficerName")]
        public string ComplianceOfficerName { get; set; }

        [PetaPoco.Column("DesignationId")]
        public int? DesignationId { get; set; }

        [PetaPoco.Column("Address")]
        public string Address { get; set; }

        [PetaPoco.Column("PhoneNumber")]
        public string PhoneNumber { get; set; }

        [PetaPoco.Column("EmailId")]
        public string EmailId { get; set; }

        [PetaPoco.Column("ApplicableFromDate")]
        public DateTime? ApplicableFromDate { get; set; }

        [PetaPoco.Column("ApplicableToDate")]
        public DateTime? ApplicableToDate { get; set; }

        [PetaPoco.Column("StatusCodeId")]
        public int? StatusCodeId { get; set; }

        public int LoggedInUserId { get; set; }
    }

    [PetaPoco.TableName("com_CompanySettingConfiguration")]
    public class CompanySettingConfigurationDTO
    {
        [PetaPoco.Column("ConfigurationTypeCodeId")]
        public int ConfigurationTypeCodeId { get; set; }

        [PetaPoco.Column("ConfigurationCodeId")]
        public int ConfigurationCodeId { get; set; }

        [PetaPoco.Column("ConfigurationValueCodeId")]
        public int? ConfigurationValueCodeId { get; set; }

        [PetaPoco.Column("ConfigurationValueOptional")]
        public String ConfigurationValueOptional { get; set; }

        [PetaPoco.Column("IsMappingCode")]
        public bool IsMappingCode { get; set; }

        [PetaPoco.Column("RLSearchLimit")]
        public int RLSearchLimit { get; set; }
    }

    [PetaPoco.TableName("com_CompanySettingConfigurationMapping")]
    public class CompanySettingConfigurationMappingDTO
    {
        [PetaPoco.Column("MapToTypeCodeId")]
        public int MapToTypeCodeId { get; set; }

        [PetaPoco.Column("ConfigurationMapToId")]
        public int ConfigurationMapToId { get; set; }

        [PetaPoco.Column("ConfigurationValueId")]
        public int? ConfigurationValueId { get; set; }

        [PetaPoco.Column("ConfigurationValueOptional")]
        public String ConfigurationValueOptional { get; set; }
    }

    public class CompanyConfigurationDTO
    {
        public int InitialDisclosure { get; set; }

        public int ContinuousDisclosure { get; set; }

        public int PeriodEndDisclosure { get; set; }

        public int PreClearanceImplementingCompany { get; set; }
        public List<int> PreClearanceImplementingCompany_Mapping { get; set; }

        public int PreClearanceNonImplementingCompany { get; set; }
        public List<int> PreClearanceNonImplementingCompany_Mapping { get; set; }

        public int InitialDisclosureTransaction { get; set; }
        public List<int> InitialDisclosureTransaction_Mapping { get; set; }

        public int ContinuousDisclosureTransaction { get; set; }
        public List<int> ContinuousDisclosureTransaction_Mapping { get; set; }

        public int PeriodEndDisclosureTransaction { get; set; }
        public List<int> PeriodEndDisclosureTransaction_Mapping { get; set; }

        public int EULAAcceptanceSettings { get; set; }

        public int ReqiuredEULAReconfirmation { get; set; }

        public int? EULAAcceptance_DocumentId { get; set; }

        public int UPSISetting { get; set; }

        public int TriggerEmailsUPSIUpdated { get; set; }
        public int TriggerEmailsUPSIpublished { get; set; }
        public string SubmittedDefaultMailTo { get; set; }
        public string SubmittedDefaultMailCC { get; set; }
    }


    [PetaPoco.TableName("com_PersonalDetailsConfirmation")]
    public class PersonalDetailsConfirmationDTO
    {
        [PetaPoco.Column("CompanyId")]
        public int? CompanyId { get; set; }

        [PetaPoco.Column("ReConfirmationFreqId")]
        public int? ReconfirmationFrequencyId { get; set; }

        public int LoggedInUserId { get; set; }

    }
}
