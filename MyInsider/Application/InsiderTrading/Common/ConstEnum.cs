using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Common
{
    public class ConstEnum
    {
        #region Encryption Passwords
        /// <summary>
        /// This key is used as salt when hashing the user password
        /// </summary>
        public const string User_Password_Encryption_Key = "99-102-245-9-16-230-97-24-80-31-38-64-146-69-177-4-98-105-64-153-1-215-64-056-103-130-168-64-242-133";

        /// <summary>
        /// This key is used to valid the POST action came from InsiderTradingSSO
        /// </summary>
        public const string s_SSO = "~{0}~IT~POWEREDBYESOPDIRECT~SSOLOGIN~IT~{0}~";

        /// <summary>
        /// This is used when encrypting / decrypting the user name and password in javascript
        /// Changing the key value should also be changed in Scripts/Login/Login.js
        /// </summary>
        public const string Javascript_Encryption_Key = "8080808080808080";

        #endregion Encryption Passwords

        #region Client Database Name
        public const string CLIENT_DB_NAME = "Vigilante_Axisbank";
        public const string CLIENT_DB_NAME_DCMShriram = "Vigilante_DCMShriram";
        public const string CLIENT_DB_NAME_IGNORE_IP = "RBL";
        public const string CLIENT_DB_NAME_IGNORE_DATABASE = "YES";
        #endregion Client Database Name

        #region SessionValue
        /// <summary>
        /// This class is used to define session variables
        /// </summary>
        public class SessionValue
        {
            public const string UserDetails = "UserDetails";

            public const string SessionValidationKey = "SessionValidationKey";

            public const string CookiesValidationKey = "CookiesValidationKey";
        }
        #endregion SessionValue

        #region Cookies Value
        public class CookiesValue
        {
            // session cookies use for validation
            public const string ValidationCookies = "v_au2";
        }
        #endregion Cookies Value

        #region Header Variable for AntiForgery Token
        public const string AntiForgeryTokenHeader = "version";
        #endregion Header Variable for AntiForgery Token

        #region ComboType
        /// <summary>
        /// This class is used to define Combo Type
        /// </summary>
        public class ComboType
        {
            public const int ListOfCode = 1;
            public const int CompanyList = 2;
            public const int CodeParentList = 3;
            public const int ColumnHeader = 4;
            public const int RoleList = 5;
            public const int COUserList = 6;
            public const int UserPANList = 7;
            public const int UserDMATList = 8;
            public const int UserRelativeList = 9;
            public const int UserType = 10;
            public const int EventStatusList = 11;
            public const int TradingPolicySecuitywiseLimits = 12;
            public const int TemplateList = 13;
            public const int DesignationList = 14;
            public const int SecurityTypeList = 15;
            public const int CommentType = 16;
            public const int TransactionTypeByTradingPolicy = 17;
            public const int RestrictedList = 18;
            public const int ListofSecurityTypeapplicableTradingPolicy = 19;
            public const int ListofEventsWithUserTypeForCommunicatioTriggerEvent = 20;
            public const int RelationshipWithInsider = 21;
            public const int TradingPolicyContraTradeSelectedSecurity = 22;
            public const int TemplateMasterPlaceholderList = 23;
            public const int NSEdownloadEventList = 24;
            public const int NSEGroupNumber = 25;
            public const int EventGroupStatusList = 30;
            public const int RestrictedListStatus = 26;
            public const int EmpStatusList = 27;
            public const int ListofModeOfAcquisitionapplicableTradingPolicy = 28;
            public const int RelUserPANList = 29;
            public const int ListofModeOfAcquisitionapplicableTradingPolicyOS = 31;
            public const int UserPANListForCD = 32;
            public const int SecurityTypeListOS = 33;
            public const int TransactionTypeByTradingPolicy_OS = 34;
            public const int ListofSecurityTypeapplicableTradingPolicyOS = 35;
            public const int TransactionType_PNT_OS = 36;
			public const int Listofmultipleuser = 40;
			public const int ListofMCQ = 37;
            public const int ListofMCQAtempts = 38;
            public const int ListofAnswerType = 39;
            public const int ListOfEmployeeID = 41;
            public const int ListOfResidentialStatus = 42;
            public const int TradingPolicySecuitywiseLimitsOS = 43;
        }

        #endregion ComboType

        #region CodeGroup
        /// <summary>
        /// This class is used to define Code Group
        /// </summary>
        public class CodeGroup
        {
            public const string RelationWithEmployee = "100";
            public const string UserType = "101";
            public const string UserStatus = "102";
            public const string ResourceModules = "103";
            public const string ResourceCategory = "104";
            public const string ActivityStatus = "105";
            public const string RoleStatus = "106";
            public const string CountryMaster = "107";
            public const string StateMaster = "108";
            public const string DesignationMaster = "109";
            public const string DepartmentMaster = "110";
            public const string GradeMaster = "111";
            public const string CategoryMaster = "112";
            public const string SubCategoryMaster = "113";
            public const string StockExchangeMaster = "116";
            public const string CurrencyMaster = "117";
            public const string SubDesignationMaster = "118";
            public const string DesignationMasterForAutoHelp = "119";
            public const string DPName = "120";
            public const string DMATAccountType = "121";
            public const string ResourceScreenType = "122";
            public const string FinancialPeriodType = "123";
            public const string FinancialPeriod = "124";
            public const string FinancialYear = "125";
            public const string TradingWindowEventType = "126";
            public const string TradingWindowEvent = "127";

            public const string PolicyDocumentCategory = "129";
            public const string PolicyDocumentSubCategory = "130";
            public const string PolicyDocumentWindowStatus = "131";


            public const string RecordType = "134";
            public const string PolicyGroup = "135";
            public const string TransactionTradeSingleOrMultiple = "136";
            public const string OccurrenceFrequency = "137";
            public const string CalendarOrFinancialYear = "138";
            public const string SecurityType = "139";
            public const string TradingPolicyExceptionFor = "140";
            public const string TradingPolicyStatus = "141";
            public const string PreclearanceRequestor = "142";
            public const string TransactionType = "143";
            public const string PreclearanceStatus = "144";
            public const string ReasonForNotTrading = "145";
            //  public const string SecurityType = "146";
            public const string DisclosureType = "147";
            public const string DisclosureStatus = "148";
            public const string ModeOfAcquisition = "149";
            public const string WorkandEducationDetailsConfiguration = "539";

            public const string DisclosureLetterForUserType = "151";

            public const string Events = "153";
            public const string DisclosureAndTradeDetailsStatus = "154";
            public const string ColumnAlignment = "155";
            public const string CommunicationModes = "156";
            public const string CommunicationRuleCategory = "157";
            public const string CommunicationExecutionFrequency = "158";
            public const string CommunicationRuleForUserType = "159";
            public const string CommunicationRuleStatus = "160";
            public const string CommunicationNotificationStatus = "161";
            public const string CommentsType = "162";
            public const string TemplateCategoryforTemplateMaster = "166";
            public const string PreclearenceComments = "167";
            public const string DefaulterReportComments = "169";
            public const string NonComplianceType = "170";
            public const string MassUploadStatus = "171";
            public const string CashAndCashlessPartialExciseOptionForContraTrade = "172";
            public const string InsiderStatus = "173";

            public const string ContraTradeOption = "175";
            public const string EnablePreclearanceWithoutSubmittingPeriodEndDisclosure = "188";
            public const string ConfirmationForCompanyHoldings = "189";
            public const string ConfirmationForNonCompanyHoldings = "190";
            public const string SecurityTransferOption = "190";
            public const string RestrictedList = "193";
            public const string NSEDownloadOptions = "508";
            public const string ReasonforApproval = "509";
            public const string EmployeeStatus = "510";
            public const string ResidentType = "514";
            public const string ReasonForNotTradingOS = "515";
            public const string IdentificationType = "516";
            public const string IdentificationTypeRelative = "517";
            public const string CategoryOffinancial = "518";  
            public const string ReasonforSharing = "519";
            public const string ModeOfSharing = "520";
            public const string MCQStatus = "522";
            public const string UPSIUserType = "525";
        }
        #endregion CodeGroup

        #region GridType
        /// <summary>
        /// This class is used for defined Grid Type.
        /// </summary>
        public class GridType
        {
            public const int COUserList = 114001;
            public const int EmployeeUserList = 114002;
            public const int ActivityList = 114003;
            public const int MenuList = 114004;
            public const int DMATList = 114005;
            public const int DocumentList = 114006;
            public const int Companyist = 114007;
            public const int ComCodeList = 114008;
            public const int RoleMasterList = 114009;
            public const int UserRelativeList = 114010;
            public const int CompanyFaceValueList = 114011;
            public const int CompanyAuthorisedSharedCapitalList = 114012;
            public const int CompanyPaidUpSubscribeShareCapitalList = 114013;
            public const int CompanyListingDetailsList = 114014;
            public const int CompanyComplianceOfficerList = 114015;
            public const int DelegateMasterList = 114016;
            public const int DMATAccountHolderList = 114017;
            public const int ResourcesList = 114018;
            public const int UserSeparationList = 114019;
            public const int TradingWindowEventListForFinancialPeriod = 114020;
            public const int TradingWindowsOtherList = 114021;
            public const int PoliycDocumentsList = 114022;
            public const int Applicability_Search_EmployeeInsider = 114023;
            public const int TradingPolicyList = 114024;
            public const int TradingPolicyHistoryList = 114025;
            public const int TradingPolicyHistoryList_OS = 114130;
            public const int Applicability_Association_EmployeeInsider = 114026;
            public const int Applicability_Search_Non_Employee = 114027;
            public const int Applicability_Association_Non_Employee = 114028;
            public const int Applicability_Search_Corporate = 114029;
            public const int Applicability_Association_Corporate = 114030;
            public const int TradingTransactionDetails = 114031;
            public const int Applicability_Filter_EmployeeInsider = 114032;
            public const int PolicyAgreedByUserList = 114033;
            public const int PolicyDocumentApplicablityList_Corporate = 114034;
            public const int PolicyDocumentApplicablityList_NonEmployee = 114035;
            public const int PolicyDocumentApplicablityList_Employee = 114036;
            public const int PeriodEndDisclosurePeriodStatusList = 114037;
            public const int ContinousDisclosureStatusList = 114038;
            public const int InitialDisclosureListForEmployee = 114103;
            public const int InitialDisclosureListForInsider = 114104;
            public const int InitialDisclosureListForCO_OS = 114117;

            public const int PeriodEndDisclosurePeriodSummary = 114039;
            public const int TemplateMasteList = 114040;
            public const int TradingPolicySecuritywiseValueList = 114041;
            public const int InitialDisclosureLetterList = 114042;
            public const int CommunicationRuleMasterList = 114043;
            public const int CommunicationRuleModesMasterList = 114044;
            public const int PeriodEndDisclosureUsersStatusList = 114045;
            public const int ContinuousDisclosureDataForLetterForEmployeeInsider = 114046;
            public const int ContinuousDisclosureDataForLetterForNonEmployeeInsider = 114047;
            public const int InitialDisclosureListForCO = 114048;
            public const int ContinuousDisclosureListForCO = 114049;
            public const int Report_InitialDisclosureEmployeeWise = 114050;
            public const int NotificationList = 114051;
            public const int Report_InitialDisclosureEmployeeIndividual = 114052;
            public const int Report_PeriodEndDisclosureEmployeeWise = 114053;
            public const int Report_PeriodEndDisclosureEmployeeIndividual = 114054;
            public const int Applicability_Search_COInsider = 114055;
            public const int Applicability_Association_COInsider = 114056;
            public const int DashBboardNotificationList = 114057;
            public const int Report_PeriodEndDisclosureEmployeeIndividualDetails = 114058;
            public const int Report_ContinuousReportEmployeeWise = 114059;
            public const int Report_ContinuousReportEmployeeIndividual = 114060;
            public const int Report_PreclearenceReportEmployeeWise = 114061;
            public const int Report_PreclearenceReportEmployeeIndividual = 114062;

            public const int OverlappingTradingPolicyList = 114064;
            public const int TradingTransaction_InitialDisclosure_Insider = 114071;
            public const int RelativeInitialDisclosureList = 114102;
            public const int TradingTransaction_InitialDisclosure_CO = 114068;
            public const int TradingTransaction_ContinuousDisclosure_Insider = 114066;
            public const int TradingTransaction_ContinuousDisclosure_CO = 114069;
            public const int TradingTransaction_PeriodEndDisclosure_Insider = 114067;
            public const int TradingTransaction_PeriodEndDisclosure_CO = 114070;
            public const int TradingTransaction_InitialDisclosure_Insider_OptionContract = 114105;
            public const int TradingTransaction_InitialDisclosure_Relative_OptionContract = 114106;
            public const int PeriodEndDisclosure_OS_UsersStatusList = 114128;


            public const int TradingPolicyOtherSecurityList = 114129;

            //GridType for Initial disclosure for Other Securities
            public const int TradingTransaction_InitialDisclosure_for_Other_Securities_Self = 114109;
            public const int TradingTransaction_InitialDisclosure_for_Other_Securities_Relatives = 114110;


            public const int TradingTransaction_ForLetter_ContinuousDisclosure_Insider = 114083;
            public const int TradingTransaction_ForLetter_PeriodEndDisclosure_Insider = 114084;
            public const int TradingTransaction_ForLetter_InitialDisclosure_CO = 114085;
            public const int TradingTransaction_ForLetter_ContinuousDisclosure_CO = 114086;
            public const int TradingTransaction_ForLetter_PeriodEndDisclosure_CO = 114087;
            public const int TradingTransaction_ForLetter_InitialDisclosure_Insider = 114088;

            public const int CorporateDMATList = 114072;
            public const int CorporateDMATAccountHolderList = 114073;
            public const int RelativeDMATList = 114074;
            public const int RelativeDMATAccountHolderList = 114075;

            public const int PreClearanceDetailsList_CO = 114076;
            public const int PreClearanceDetailsList_Insider = 114077;
            public const int Report_Defaulter = 114078;

            public const int RestrictedList = 114079;
            public const int InitialDisclosureLetterListGrid2 = 114080;
            public const int ContinuousDisclosureDataForLetterForEmployeeInsiderGrid2 = 114081;
            public const int ContinuousDisclosureDataForLetterForNonEmployeeInsiderGrid2 = 114082;
            public const int Applicability_Search_Employee = 114089;
            public const int Applicability_Filter_Employee = 114090;
            public const int Applicability_Association_Employee = 114091;

            public const int PolicyDocumentApplicablityList_EmployeeNotInsider = 114092;
            public const int TransactionUploadedDocumentList = 114093;
            public const int InsiderNonImplementingPrelclearanceList = 114094;
            public const int CONonImplementingPrelclearanceList = 114095;

            public const int Report_RestrictedListSearch_CO = 114096;
            public const int Report_RestrictedListSearch_Insider = 114097;
            public const int SecuritiesHoldingList = 114098;
            public const int SecuritiesTransferReportCO = 114099;
            public const int SecuritiesTransferReportEmployee = 114100;

            public const int PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid1 = 507004;
            public const int PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid2 = 507003;

            public const int NSEDownload = 508005;
            public const int NSEDownloadDeleteGroupDetails = 508008;
            public const int RestrictedListMultiplePreClearanceRequestDetails = 507005;
            public const int Report_ClawBack = 122098;
            public const int Report_ClawBack_Individual = 122100;

            public const int Education_List = 114115;
            public const int Work_List = 114116;

            public const int PreclearanceList_OS_ForInsider = 114118;
            public const int PreclearanceList_OS_ForCO = 114119;

            public const int TradingTransaction_ContDisclosure_for_Other_Securities_Self = 114120;
            public const int TradingTransaction_ContDisclosure_for_Other_Securities_Relatives = 114121;
            public const int UpsiSharing_data = 114122;
            public const int UpsiSharing_dataTemp = 114123;
 			public const int MCQ_Questions_List = 114124;

            public const int Report_EULAAcceptanceReport = 114125;
            public const int PeriodEndDisclosurePeriodStatusList_OS = 114126;
            public const int PeriodEndDisclosureSummaryList_OS = 114127;



            public const int TradingPolicySecuritywiseValueList_OS = 114131;
            public const int Applicability_Search_EmployeeInsider_OS = 114132;
            public const int Applicability_Association_EmployeeInsider_OS = 114133;
            public const int Applicability_Filter_EmployeeInsider_OS = 114139;
            public const int Applicability_Search_Non_Employee_OS = 114135;
            public const int Applicability_Association_Non_Employee_OS = 114136;
            public const int Applicability_Search_Corporate_OS = 114137;
            public const int Applicability_Association_Corporate_OS = 114138;
            public const int Applicability_Search_COInsider_OS = 114143;
            public const int Applicability_Association_COInsider_OS = 114144;
            public const int Applicability_Search_Employee_OS = 114145;
            public const int Applicability_Filter_Employee_OS = 114146;
            public const int Applicability_Association_Employee_OS = 114147;
            public const int OverlappingTradingPolicyList_OS = 114150;
        }
        #endregion GridType

        #region Code
        /// <summary>
        /// This class is used to define Code
        /// </summary>
        public class Code
        {
            //User Type
            public const int Admin = 101001;
            public const int COUserType = 101002;
            public const int EmployeeType = 101003;
            public const int CorporateUserType = 101004;
            public const int SuperAdminType = 101005;
            public const int NonEmployeeType = 101006;
            public const int RelativeType = 101007;

            //Stock Exchange
            public const int StockExchange_NSE = 116001;
            public const int StockExchange_BSE = 116002;

            //DMATAccount Holder ype
            public const int Single = 121001;
            public const int Joint = 121002;


            public const int TradingPolicy_OS = 132022;
            public const int PreclearanceRequest_OS = 132023;
            public const int DisclosureTransaction_OS = 132024;

            public const int PeriodEndDisclosure_OS = 132026;

            //Restricted List setting - Pre-clearance Approval
            public const int RestrictedList_Search_Perpetual_OS = 528001;
            public const int RestrictedList_Search_Limited_OS = 528002;

            public const int RestrictedList_Type_Auto_OS = 535001;
            public const int RestrictedList_Type_Manual_OS = 535002;



            // This code is used as configuration values
            public const int PeriodType = 128002;

            //Policy document window status
            public const int PolicyDocumentWindowStatusIncomplete = 131001;
            public const int PolicyDocumentWindowStatusActive = 131002;
            public const int PolicyDocumentWindowStatusDeactive = 131003;

            // This code is used to map the document to Type ID
            public const int PolicyDocument = 132001;
            public const int TradingPolicy = 132002;
            public const int UserDocument = 132003;
            public const int PreclearanceRequest = 132004;
            public const int DisclosureTransaction = 132005;
            public const int CommunicationRule = 132006;
            public const int ProhibitPreclearanceDuringNonTrading = 132007;
            public const int TradingPolicyExceptionforTransactionMode = 132008;
            public const int TradingWindowOther = 132009;
            public const int MassUpload = 132010;
            public const int DefaulterReportMapType = 132011;
            public const int RestrictedList = 132012;
            public const int ContraTradeSelectedSecurity = 132013;
            public const int DematAccount = 132014;
            public const int PreclearanceRequestNonImplementingCompany = 132015;
            public const int FormF = 132016;
            public const int NseDocumentFormC = 132017;
            public const int UploadNseDocument = 132018;
            public const int ChangePassword = 132019;
            public const int DisclosureTransactionforOS = 132020;
            // This code is used to map the document to Purpose ID
            public const int EmailAttachment = 133001;
            public const int HardCopyByCOToExchange = 133002;
            public const int TransactionDetailsUpload = 133003;
            public const int FormFforRestrictedList = 133004;
            public const int EULAAcceptanceDocument = 132021;

            //Record type as current/history record
            public const int CurrentRecord = 134001;
            public const int HistoryRecord = 134002;

            //Trading Policy Group
            public const int TradingPolicyInsiderType = 135001;
            public const int TradingPolicyEmployeeType = 135002;

            //Transaction trade single/multiple
            public const int SingleTransactionTrade = 136001;
            public const int MultipleTransactionTrade = 136002;

            //Occurrence frequency as yearly/quarterly/monthly/weekly
            public const int Yearly = 137001;
            public const int Quarterly = 137002;
            public const int Monthly = 137003;
            public const int Weekly = 137004;

            //Year to be considered as Calendar/Financial
            public const int CalendarYear = 138001;
            public const int FinancialYear = 138002;

            //Security type - Equity/Derivatives
            public const int SecurityTypeShares = 139001;
            public const int SecurityTypeWarrants = 139002;
            public const int SecurityTypeConvertibleDebentures = 139003;
            public const int SecurityTypeFutureContract = 139004;
            public const int SecurityTypeOptionContract = 139005;

            //Trading policy Exception For
            public const int ExerciseofOptions = 140001;

            //Trading Policy Status
            public const int TradingPolicyStatusIncomplete = 141001;
            public const int TradingPolicyStatusActive = 141002;
            public const int TradingPolicyStatusInactive = 141003;

            //Preclearance request for 
            public const int PreclearanceRequestForSelf = 142001;
            public const int PreclearanceRequestForRelative = 142002;

            //Preclearance Request Status
            public const int PreclearanceRequestStatusConfirmed = 144001;
            public const int PreclearanceRequestStatusApproved = 144002;
            public const int PreclearanceRequestStatusRejected = 144003;

            //Disclosure Type
            public const int DisclosureTypeInitial = 147001;
            public const int DisclosureTypeContinuous = 147002;
            public const int DisclosureTypePeriodEnd = 147003;

            //Disclosure Status
            public const int DisclosureStatusForDocumentUploaded = 148001;
            public const int DisclosureStatusForNotConfirmed = 148002;
            public const int DisclosureStatusForConfirmed = 148003;
            public const int DisclosureStatusForSoftCopySubmitted = 148004;
            public const int DisclosureStatusForHardCopySubmitted = 148005;
            public const int DisclosureStatusForHardCopySubmittedByCO = 148006;
            public const int DisclosureStatusForSubmitted = 148007;

            //ModeOfAcquisitipon
            public const int ModeOfAcquisition_MarketPurchase = 149001;
            public const int ModeOfAcquisition_MarketSale = 149010;


            //Transaction Type
            public const int TransactionTypeBuy = 143001;
            public const int TransactionTypeSell = 143002;
            public const int TransactionTypeCashExercise = 143003;
            public const int TransactionTypeCashlessAll = 143004;
            public const int TransactionTypeCashlessPartial = 143005;
            public const int TransactionTypePledge = 143006;
            public const int TransactionTypePledgeRevoke = 143007;
            public const int TransactionTypePledgeInvoke = 143008;

            //Include Excluded type code.
            public const int ExcludeTypeCode = 150002;
            public const int IncludeTypeCode = 150001;

            //Disclosure letter user type
            public const int DisclosureLetterUserInsider = 151001;
            public const int DisclosureLetterUserCO = 151002;

            //Events
            public const int PolicyDocumentViewd = 153027;
            public const int PolicyDocumentAgreed = 153028;
            public const int Event_ConfirmPersonalDetails = 153043;
            public const int EventPasswordExpire = 153048;
            public const int EventPasswordChanged = 153049;

            //Event Status For Trade Details
            public const int EventStatusCompleted = 154001;
            public const int EventStatusPending = 154002;
            public const int EventStatusDoNotShow = 154003;
            public const int EventStatusPartiallyTraded = 154004;
            public const int EventStatusNotTraded = 154005;
            public const int EventStatusUploaded = 154006;
            public const int EventStatusNotRequired = 154007;

            //Communication Mode
            public const int CommunicationModeForLetter = 156001;
            public const int CommunicationModeForEmail = 156002;
            public const int CommunicationModeForSMS = 156003;
            public const int CommunicationModeForTextAlert = 156004;
            public const int CommunicationModeForPopupAlert = 156005;
            public const int CommunicationModeForFAQ = 156006;
            public const int CommunicationModeForFormE = 156007;

            //Communication Rule Category
            public const int CommunicationRuleCategoryAuto = 157001;
            public const int CommunicationRuleCategoryManual = 157002;

            public const int CommunicationRuleForUserTypeInsider = 159001;
            public const int CommunicationRuleForUserTypeCO = 159002;

            //Communication Rule status
            public const int CommunicationRuleStatusActive = 160001;
            public const int CommunicationRuleStatusInactive = 160002;

            public const int CommunicationRuleEventsToApplyUserTypeInsider = 163001;
            public const int CommunicationRuleEventsToApplyUserTypeCO = 163002;

            public const int CommunicationCategory = 166001;
            public const int NonCommunicationCategory = 166002;

            //MassUpload Status
            public const int MassUploadStarted = 171001;
            public const int MassUploadCompleted = 171002;
            public const int MassUploadFailed = 171003;
            public const int MassUploadPartlyFailed = 171004;

            //Cash And Cashless Partial Excise Option For Contra Trade
            public const int ESOPExciseOptionFirstandThenOtherShares = 172001;
            public const int OtherSharesFirstThenESOPExciseOption = 172002;
            public const int UserSelectionOnPreClearanceAndTradeDetailsSubmission = 172003;

            //Contra Trade Option
            public const int ContraTradeWithoutQuantiy = 175001;
            public const int ContraTradeQuantiyBase = 175002;

            //Contra Trade Based On
            public const int ContraTradeBasedOnAllSecurityType = 177001;
            public const int ContraTradeBasedOnIndividualSecurityType = 177002;

            //Company configuraiton - Type
            public const int CompanyConfigType_EnterUploadSetting = 180001;
            public const int CompanyConfigType_DematAccountSetting = 180002;
            public const int CompanyConfigType_RestrictedListSetting = 180003;
            public const int CompanyConfigType_EnterSettingOtherSecurities = 180004;
            public const int CompanyConfigType_EULAAcceptanceSetting = 180005;
            public const int CompanyConfigType_ReqiuredEULAReconfirmation = 180006;
            public const int CompanyConfigType_UPSISetting = 180007;
            public const int CompanyConfigType_MailSetting = 180008;
            public const int CompanyConfigType_MailSettingTo = 180009;
            public const int CompanyConfigType_MailSettingCC = 180010;
            //Email Setting
            public const int CompanyConfigType_TriggerEmailsUPSIUpdated = 526001;
            public const int CompanyConfigType_TriggerEmailsUPSIPublished = 526002;
            public const int CompanyConfigType_UPSIInformationSharedby = 530001;
            public const int CompanyConfigType_UPSIRecidentNonRecidentDropdown = 530002;

            //Company configuraiton - Enter uplaod Setting 
            public const int EnterUploadSetting_EnterDetails = 182001;
            public const int EnterUploadSetting_UploadDetails = 182002;
            public const int EnterUploadSetting_EnterAndUploadDetails = 182003;
            public const int EnterUploadSetting_EnterOrDetails = 182004;
            public const int EnterUploadSetting_EnterAndOrDetails = 182005;

            //Preclearance type
            public const int PreClearanceType_ImplementingCompany = 183001;
            public const int PreClearanceType_NonImplementingCompany = 183002;

            //Company configuraiton - Demat Account Setting 
            public const int DematAccountSetting_AllDemat = 184001;
            public const int DematAccountSetting_SelectedDemat = 184002;

            //Company configuraiton - Restricted List Setting
            public const int RestrictedListSetting_Preclearance_required = 185001;
            public const int RestrictedListSetting_Preclearance_Approval = 185002;
            public const int RestrictedListSetting_Preclearance_Allow_Zero_Balance = 185003;
            public const int RestrictedListSetting_Preclearance_Form_F_Required = 185004;
            public const int RestrictedListSetting_Preclearance_Form_F_TemplateFile = 185005;
            public const int RestrictedListSetting_Allow_Restricted_List_Search = 185006;

            //Company configuraiton - Yes/No Setting
            public const int CompanyConfig_YesNoSettings_Yes = 186001;
            public const int CompanyConfig_YesNoSettings_No = 186002;

            //UPSI Settings -Yes/No Settings
            public const int UPSI_YesNoSettings_Yes = 192001;
            public const int UPSI_YesNoSettings_No = 192002;
            //UPSI Email Settings -Yes/No Settings
            public const int UPSI_TEmailUpdate_YesNoSettings_Yes = 192003;
            public const int UPSI_TEmailUpdate_YesNoSettings_No = 192004;
            public const int UPSI_TEmailPublished_YesNoSettings_Yes = 192005;
            public const int UPSI_TEmailPublished_YesNoSettings_No = 192006;
            //Restricted List setting - Pre-clearance Approval
            public const int RestrictedList_PreclearanceApproval_Auto = 187001;
            public const int RestrictedList_PreclearanceApproval_Manual = 187002;

            //Restricted List setting - Pre-clearance Approval
            public const int RestrictedList_Search_Perpetual = 507001;
            public const int RestrictedList_Search_Limited = 507002;

            //Enable Pre-clearance without submitting Period End Disclosure
            public const int Allow_Before_And_After_Period_End_LastSubmissionDate = 188001;
            public const int Allow_Till_Period_End_LastSubmissionDate = 188002;
            public const int Allow_No = 188003;

            //Security Transfer Option
            public const int SecurityTransferfromselectedDemataccount = 191001;
            public const int SecurityTransferfromAllDemataccount = 191002;

            // Role status 
            public const int RoleStatusActive = 106001;
            public const int RoleStatusInactive = 106002;

            //FAQ
            public const int FAQInsiderPolicyDocumentID = 6;
            public const int FAQDocumentID = 20;
            public const int FAQEmployeePolicyDocumentID = 7;

            //Company Required Module
            public const int RequiredModuleOwnSecurity = 513001;
            public const int RequiredModuleOtherSecurity = 513002;
            public const int RequiredModuleBoth = 513003;

            //Company Settings
            public const int EnableQunatityValue = 400001;
            public const int DisabaleShowQuantityValue = 400002;
            public const int DisabaleHideQuantityValue = 400003;

            //Company configuraiton - EULAReconfirmation Setting
            public const int CompanyConfig_EULAReconfirmation_All = 523001;
            public const int CompanyConfig_EULAReconfirmation_NotAccepted = 523002;

            public const int frmCreateEmployee=1;
            public const int frmCreateRelative = 2;
            public const int frmAddEducationDetails = 3;
            public const int frmAddUserDetails = 4;
            public const int frmChangePassword = 7;
            public const int frmPreclearanceRequest = 8;
            public const int frmApproveRejectPreclearanceRequest =9;
            public const int frmSaveOwnTradingTransaction = 10;
            public const int frmOtherPreclearanceRequest = 11;
            public const int frmSaveOtherTradingTransaction = 12;
            public const int frmAddRole = 13;
            public const int frmAddDelegate = 14;
            public const int frmMasterCode = 15;
            public const int frmPwdConfiguration = 16;
            public const int frmUpdateResource = 17;
            public const int frmSaveCompany = 18;
            public const int frmCompanyPaidupandsubscribe = 22;
            public const int frmSaveComplianceOfficer = 24;
            public const int frmSavePersonalDetailsConfirmation = 26;
            public const int frmSavePolicyDocument = 28;          
            public const int frmSaveTradingWindow=30;
            public const int frmSaveTradingWindowOther = 31;
            public const int frmSaveTemplatemaster = 32;
            public const int frmSaveCommunicationRule = 33;
            public const int frmSaveMCQSetting = 34;
            public const int frmSaveMCQQuestions = 35;
            public const int frmSaveDelegate = 36;
            public const int frmSaveNseGroup = 37;
            public const int frmSaveOwnId = 38;
            public const int frmCreateCorpEmployee = 63;
            public const int frmCreateNonEmployee = 64;

            public const int UPSI_UpdateTemplateCode = 156011;
            public const int UPSI_PublishTemplateCode = 156012;
            //MCQ Email template
            public const int MCQ_UnBlockUserTemplate = 156015;
            public const int MCQ_BlockUserTemplate = 156014;
            //On the fly Email Module Type
            public const int ModuleType_MCQ = 527002;
            public const int ModuleType_UPSI = 527001;
            //UPSI Required
            public const int UPSIReqiured_Yes = 528001;
            public const int UPSIReqiured_No = 528002;
            public const int IsPreClearanceEditable = 524002;
            public const int CurrentRecordCodeID = 134001;

        }
        #endregion Code

        public const string Yes = "Yes";
        public const string No = "No";
        public const string Date_Default = "01/01/0001";
        public const int One = 1;
        public const int Zero = 0;
        public const string ConnectionString = "";
        public const string ResidencyScotland = "SCOTLAND";

        public const string SessionAndCookiesKeyBeforeLogin = "0";
        public const string LogoutUrl = "~/Account/Logout";
        public const string CountryCode = "+91";

        #region DataFormatType
        //Define data format type.
        public enum DataFormatType
        {
            Date,
            Time12,
            DateTime,
            DateTime12,
            DateTime24,
            Decimal2,
            Money,
            MoneyWithOutDecimalPoint,
            StandardDate
        }
        #endregion DataFormatType

        #region TimeFormatType
        //Define data format type.
        public class TimeFormatType
        {
            public const int TIMEFORMAT_12HRS = 12;
            public const int TIMEFORMAT_24HRS = 24;
            public const int TIMEFORMAT_MIN = 60;
        }
        #endregion TimeFormatType

        #region DataFormatString
        //Stores the actual data format string required for formatting - used in the function ApplyFormatting (Common.cs)
        public class DataFormatString
        {
            public const string Date = "dd'/'MMM'/'yyyy";
            public const string Time12 = "hh:mm:ss tt";
            public const string Time24 = "hh:mm:ss";
            public const string DateTime = "dd'/'MM'/'yyyy HH:mm";
            public const string DateTime12 = "dd'/'MMM'/'yyyy hh:mm:ss tt";
            public const string DateTime24 = "dd'/'MM'/'yyyy HH:mm:ss";
            public const string DecimalFormat = "{0:0.00}";
            public const string MoneyFormat = "{0:#,##0.00}";
            public const string MoneyWithOutDecimalPointFormat = "{0}";
            public const string StandardDate = "yyyy'-'MM'-'dd";
            public const string BootstrapUIDateFormat = "dd'/'mm'/'yyyy";
            public const string BootstrapUIDateTimeFormat = "dd'/'mm'/'yyyy-hh:ii";
            public const string DateFormat = "ddd dd MMM yyyy";
        }
        #endregion DataFormatString

        #region UserType
        /// <summary>
        /// 
        /// </summary>
        public class UserType
        {
            public const int NonInsider = 0;
            public const int Insider = 1;
        }
        #endregion UserType

        #region UserStatus
        /// <summary>
        /// 
        /// </summary>
        public class UserStatus
        {
            public const int Active = 102001;
            public const int Inactive = 102002;
        }
        #endregion UserStatus

        #region UserActions
        /// <summary>
        /// This class will contain all the actions/activities defined in the system. This actionid will be used for 
        /// checking if the login user has access to this corresponding action. This enum needs to be updated when new
        /// activities are added in system.
        /// </summary>
        public class UserActions
        {
            public const int CRUSER_COUSER_VIEW = 1;
            public const int CRUSER_COUSER_CREATE = 2;
            public const int CRUSER_COUSER_EDIT = 3;
            public const int CRUSER_COUSER_DELETE = 4;

            public const int INSIDER_INSIDERUSER_VIEW = 5;
            public const int INSIDER_INSIDERUSER_CREATE = 6;
            public const int INSIDER_INSIDERUSER_EDIT = 7;
            public const int INSIDER_INSIDERUSER_DELETE = 8;
            public const int INSIDER_INSIDERUSER_MASSUPLOAD = 9;

            public const int COMPANY_VIEW = 10;
            public const int COMPANY_CREATE = 11;
            public const int COMPANY_EDIT = 12;
            public const int COMPANY_DELETE = 13;

            public const int OTHERMASTER_COMCODE_VIEW = 14;
            public const int OTHERMASTER_COMCODE_CREATE = 15;
            public const int OTHERMASTER_COMCODE_EDIT = 16;
            public const int OTHERMASTER_COMCODE_DELETE = 17;

            public const int CRUSER_COUSERDASHBOARD_DASHBOARD = 18;

            public const int CRUSER_ROLEMASTER_VIEW = 19;
            public const int CRUSER_ROLEMASTER_CREATE = 20;
            public const int CRUSER_ROLEMASTER_EDIT = 21;
            public const int CRUSER_ROLEMASTERE_DELETE = 22;

            public const int RESOURCE_VIEW = 23;
            public const int RESOURCE_EDIT = 24;

            public const int INSIDER_DMAT_VIEW = 25;
            public const int INSIDER_DMAT_CREATE = 26;
            public const int INSIDER_DMAT_EDIT = 27;
            public const int INSIDER_DMAT_DELETE = 28;

            public const int INSIDER_DOCUMENT_VIEW = 29;
            public const int INSIDER_DOCUMENT_CREATE = 30;
            public const int INSIDER_DOCUMENT_EDIT = 31;
            public const int INSIDER_DOCUMENT_DELETE = 32;

            public const int INSIDER_RELATIVEUSER_VIEW = 33;
            public const int INSIDER_RELATIVEUSER_CREATE = 34;
            public const int INSIDER_RELATIVEUSER_EDIT = 35;
            public const int INSIDER_RELATIVEUSER_DELETE = 36;

            public const int INSIDER_USERSEPARATION_VIEW = 37;
            public const int INSIDER_USERSEPARATION_CREATE = 38;
            public const int INSIDER_USERSEPARATION_REACTIVATE = 40;

            public const int DELEGATION_MASTER_VIEW = 41;
            public const int DELEGATION_MASTER_CREATE = 42;
            public const int DELEGATION_MASTER_EDIT = 43;
            public const int DELEGATION_MASTER_DELETE = 44;

            //Employee / Insider - view details permission 
            public const int VIEW_DETAILS_PERMISSION_FOR_EMPLOYEE_INSIDER = 81;
            public const int VIEW_DETAILS_PERMISSION_FOR_CORPORATE_USER = 82;
            public const int VIEW_DETAILS_PERMISSION_FOR_NON_EMPLOYEE_USER = 83;

            public const int TRADING_POLICY_OTHER_SECURITY_VIEW = 337;
            public const int TRADING_POLICY_OTHER_SECURITY_CREATE = 338;
            public const int TRADING_POLICY_OTHER_SECURITY_EDIT = 339;
            public const int TRADING_POLICY_OTHER_SECURITY_DELETE = 340;


            //Change Password
            public const int CHANGE_PASSWORD = 84;

            //CO Users - view details permission
            public const int VIEW_DETAILS_PERMISSION_FOR_CO_USER = 192;

            //policy document 
            public const int RULES_POLICY_DOCUMENT_LIST = 140;
            public const int POLICY_DOCUMENT_VIEW = 117;
            public const int POLICY_DOCUMENT_CREATE = 118;
            public const int POLICY_DOCUMENT_EDIT = 119;
            public const int POLICY_DOCUMENT_DELETE = 120;

            public const int TRADING_POLICY_VIEW = 121;
            public const int TRADING_POLICY_CREATE = 122;
            public const int TRADING_POLICY_EDIT = 123;
            public const int TRADING_POLICY_DELETE = 124;


            public const int Trading_Window_VIEW = 125;
            public const int Trading_Window_CREATE = 126;
            public const int Trading_Window_EDIT = 127;
            public const int Trading_Window_DELETE = 128;

            public const int TRADING_WINDOW_OTHER_VIEW = 134;
            public const int TRADING_WINDOW_OTHER_CREATE = 135;
            public const int TRADING_WINDOW_OTHER_EDIT = 136;
            public const int TRADING_WINDOW_OTHER_DELETE = 137;

            public const int TRANSACTION_POLICY_DOCUMENT_LIST = 138;
            public const int TRANSACTION_POLICY_DOCUMENT_VIEW = 139;

            //Disclosure details for insider 
            public const int INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST = 153;
            public const int INSIDER_DISCLOSURE_DETAILS_POLICY_DOCUMENT_LIST = 154;
            public const int INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE = 155;
            public const int INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION = 156;
            public const int INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE = 157;
            public const int INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION = 158;
            public const int INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE = 159;
            public const int INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION = 160;
            public const int INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION = 216;

            //Disclosure details for CO
            public const int CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE = 165;
            public const int CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION = 166;
            public const int CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE = 167;
            public const int CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION = 168;
            public const int CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE = 169;
            public const int CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION = 170;
            public const int CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION = 171;
            public const int CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION = 172;
            public const int CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION = 173;
            public const int CO_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION = 217;
            public const int CO_DISCLOSURE_DETAILS_EDIT_PRECLEARANCE_QUANTITY = 332;
            public const int CO_DISCLOSURE_DETAILS_EDIT_PRECLEARANCE_VALIDITY = 333;

            //Template
            public const int TEMPLATE_LIST_RIGHT = 174;
            public const int TEMPLATE_VIEW_RIGHT = 175;
            public const int TEMPLATE_ADD_RIGHT = 176;
            public const int TEMPLATE_EDIT_RIGHT = 177;
            public const int TEMPLATE_DELETE_RIGHT = 178;

            //Communication
            public const int COMMUNICATION_RULES_LIST_RIGHT = 179;
            public const int COMMUNICATION_RULES_VIEW_RIGHT = 180;
            public const int COMMUNICATION_RULES_ADD_RIGHT = 181;
            public const int COMMUNICATION_RULES_EDIT_RIGHT = 182;
            public const int COMMUNICATION_RULES_DELETE_RIGHT = 183;
            public const int COMMUNICATION_RULES_PERSONALIZE_RIGHT = 190;

            //Notification
            public const int NOTIFICATION_LIST_RIGHT = 184;
            public const int NOTIFICATION_VIEW_RIGHT = 185;

            //Reports
            public const int REPORTS_INITIALDISCLOSURE = 186;
            public const int REPORTS_CONTINUOUSDISCLOSURE = 187;
            public const int REPORTS_PERIODENDDISCLOSURE = 188;
            public const int REPORTS_PRECLEARENCE = 189;

            //DashBoard
            public const int DASHBOARD_INSIDERUSER = 191;

            //FAQ
            public const int FAQ_COList = 193;
            public const int FAQ_InsiderList = 194;

            //Mass Upload
            public const int MASSUPLOAD_LIST = 9;

            //DefaulterReport
            public const int DEFAULTERREPORT_LIST = 196;

            //Restricted List
            public const int RESTRICTED_VIEW = 197;
            public const int RESTRICTED_CREATE = 198;
            public const int RESTRICTED_EDIT = 199;
            public const int RESTRICTED_HISTORY = 200;

            //Restricted List Report 
            public const int RESTRICTED_LIST_REPORT_CO = 201;
            public const int RESTRICTED_LIST_REPORT_INSIDER = 211;

            //Restricted List 
            public const int INSIDER_RESTRICTED_LIST_SEARCH = 210;

            //CO Role to approve & reject Pre-clearance
            public const int CO_ROLE_APPROVE_REJECT = 214;

            //View Trading Window Calender for Insider
            public const int INSIDER_TRADING_WINDOW_CALENDER_VIEW = 215;

            public const int Security_Transfer_Holding_List = 219;
            public const int Security_Transfer_Transfer_View = 220;
            public const int Security_Transfer_Insider_Report = 221;
            public const int Security_Transfer_CO_Report = 222;

            public const int NSEDownload = 223;

            public const int ClawBack_Report = 230;

            public const int OS_Report = 326;

            //Multiple PreclearanceRequestNonImplementingCompany
            public const int PRECLEARANCEREQUESTNONIMPLEMENTINGCOMPANY_EDIT = 225;
            public const int PRECLEARANCEREQUESTNONIMPLEMENTINGCOMPANY_DELETE = 226;
            public const int PRECLEARANCEREQUESTNONIMPLEMENTINGCOMPANY_DELETEALL = 227;
            public const int PRECLEARANCEREQUESTNONIMPLEMENTINGCOMPANY_SAVEALL = 228;
            public const int PRECLEARANCEREQUESTNONIMPLEMENTINGCOMPANY_CANCEL = 229;

            //Preclearance request other security
            public const int PreclearanceRequestOtherSecurities = 239;
            public const int PreclearanceRequestListCOOtherSecurities = 240;

            public const int INSIDER_EDUCATION_VIEW = 242;
            public const int INSIDER_EDUCATION_CREATE = 243;
            public const int INSIDER_EDUCATION_EDIT = 244;
            public const int INSIDER_EDUCATION_DELETE = 245;

            public const int INSIDER_WORK_VIEW = 246;
            public const int INSIDER_WORK_CREATE = 247;
            public const int INSIDER_WORK_EDIT = 248;
            public const int INSIDER_WORK_DELETE = 249;
            //Restricted List
            public const int MCQ_VIEW = 327;
            public const int MCQ_CREATE = 328;
            public const int MCQ_EDIT = 329;
            public const int MCQ_DELETE = 330;

            public const int USER_EULACONSENT = 334;
            public const int INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS = 335;
            public const int CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS = 336;
}
        #endregion UserActions

        #region Resource Category Code
        /// <summary>
        /// This code is which type resource category in common code.
        /// </summary>
        public class ResourceCategoryCode
        {
            public const int ErrorMessage = 104001;
            public const int Label = 104002;
            public const int Grid = 104003;
            public const int Button = 104004;
            public const int ToolTip = 104005;
        }
        #endregion Resource Category Code

        #region ResourceEditableCode
        /// <summary>
        /// This code is used to check the code for editable.
        /// </summary>
        public class ResourceEditableCode
        {
            public const int NotEditable = 0;
            public const int Editable = 1;
        }
        #endregion ResourceEditableCode

        #region ResourceManditoryCode
        /// <summary>
        /// This code is used to check the code for manditory.
        /// </summary>
        public class ResourceManditoryCode
        {
            public const int NotManditory = 0;
            public const int Manditory = 1;
        }
        #endregion ResourceManditoryCode

        #region IsRelativeFlag
        /// <summary>
        /// This code is used to check whether it is a relative.
        /// </summary>
        public class IsRelative
        {
            public const int NotRelative = 0;
            public const int Relative = 1;
        }
        #endregion IsRelativeFlag

        #region RedirectTo
        /// <summary>
        /// This class is used for the initial check method to be called.
        /// Combination of Controller name + Action name
        /// </summary>
        public class RedirectTo
        {
            public string controller { get; set; }
            public string action { get; set; }
            public int acid { get; set; }
        }
        #endregion RedirectTo

        #region Dictinary ValidateTo
        public static Dictionary<string, int> ValidateTo = new Dictionary<string, int>()
        {
            {"HomeIndex",1},   
            {"InsiderInitialDisclosureIndex",2},
            {"PreclearanceRequestIndex",3},
            {"PeriodEndDisclosurePeriodStatus",4}
        };
        #endregion Dictinary ValidateTo

        #region Dictionary Redirect
        public static Dictionary<int, ConstEnum.RedirectTo> Redirect = new Dictionary<int, ConstEnum.RedirectTo>()
        {
            {1, new ConstEnum.RedirectTo {controller="InsiderInitialDisclosure", action="FilterIndex", acid=155}},
            {2, new ConstEnum.RedirectTo {controller="InsiderInitialDisclosure", action="DisplayPolicy", acid=155}},        
        };
        #endregion Dictionary Redirect

        #region Multiple File Upload control count
        public class FileUploadControlCount
        {
            public const int PolicyDocumentFile = 1;
            public const int PolicyDocumentEmailAttachment = 5;
            public const int TradingPolicyFile = 5;
            public const int NSEUploadFile = 10;
            public const int PeriodEndDocumentUpload = 2;
        }
        #endregion Multiple File Upload control count

        public class MenuID
        {
            public const string CODASHBOARD = "43-MENU";
            public const string INSIDERDASHBOARD = "41-MENU";
            public const string COFAQLIST = "44-MENU";
            public const string INSIDERFAQLIST = "45-MENU";
        }

        /// <summary>
        /// The various mass upload supported in the system
        /// </summary>
        public class MassUploadTypes
        {
            public const int MASSUPLOAD_EMPLOYEE = 1;
            public const int MASSUPLOAD_INITIALDISCLOSURE = 2;
            public const int MASSUPLOAD_REGISTERANDTRANSFER = 51;
            public const int MASSUPLOAD_HISTORY_PRECLEARANCEANDTRANSACTIONS = 4;
        }

        public class ReportIDMaster
        {
            public const int COReportId = 201;
            public const string encryptCOID = "b4czFb/7oAQ=";
            public const int EmpReportId = 211;
            public const string encryptEMPID = "EJLIsEY9uZo=";
            public const int RnTReportId = 212;
            public const string encrypRnTId = "/EFMo9hRx5g=";
            public const int n_ViewErrorLogReportId = 213;
            public const string s_ViewEncrypErrorLogReportId = "06p6JFH6prI=";
        }

        public class RestrictedListTrading
        {
            public const int Allowed = 50015;
            public const string Allowed_Display = "Yes";

            public const int NotAllowed = 50016;
            public const string NotAllowed_Display = "No";
        }

        public class DataValidation
        {
            public const string UserNameType = @"^[a-zA-Z0-9'. ]*$";
            public const string NumbersOnly = @"^[0-9]*$";
            public const string Alphanumeric = @"^[a-zA-Z0-9_]*$";
            public const string DescriptionType = @"^[^*<>()]*$";
            public const string Email = @"^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$";
            public const string PAN = @"[A-Z]{5}\d{4}[A-Z]{1}";
            public const string TAN = @"^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$";
            public const string CIN = @"^([a-zA-Z0-9]{7}|([a-zA-Z0-9]{21}))?$";
            public const string MobileNo = @"^(?:\d{1,15}|(\+91\d{10}|\+[1-8]\d{1,13}|\+(9[987654320])\d{1,12}))$";
            //public const string Website = @"^(?:(www|WWW)[.][A-Za-z0-9-]{1,200}([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$";
            public const string Website = @"^(?:(www|WWW)[.][A-Za-z0-9-]{1,200}([^-](.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,2}.[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,2}[\]])|([0-9]{1,2}.[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,2}))$";
            public const string AlphanumericWithSpace = @"^(([a-zA-Z0-9_ ])|(?=.* [()<>]))*$";
            public const string ISINNumber = @"^(BE|BM|FR|BG|VE|DK|HR|DE|JP|HU|HK|JO|BR|XS|FI|GR|IS|RU|LB|PT|NO|TW|UA|TR|LK|LV|LU|TH|NL|PK|PH|RO|EG|PL|AA|CH|CN|CL|EE|CA|IR|IT|ZA|CZ|CY|AR|AU|AT|IN|CS|CR|IE|ID|ES|PE|TN|PA|SG|IL|US|MX|SK|KR|SI|KW|MY|MO|SE|GB|GG|KY|JE|VG|NG|SA|MU)([0-9A-Z]{9})([0-9])$";
            //public const string LetterContent = @"^[^<>]*$";
            public const string CharactersWithSpace = @"^[a-zA-Z ]+$";
            public const string Password = @"^[^""'()+,-./:;<=>?_`{|}~\[\]\\]+$";
            public const string AlphanumericWithDash = @"^[a-zA-Z0-9-]*$";
            public const string AlphanumWithoutLessthanGreaterthanNAsterisc = @"^[^*<>()]*$";
            public const string SearchValidation = @"^[^()<>]*$";
           
        }
    }
}