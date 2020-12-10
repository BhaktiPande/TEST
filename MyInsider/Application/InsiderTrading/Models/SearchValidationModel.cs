using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace InsiderTrading.Models
{
    // Rohit
    public class COUserInfoSearchViewModel
        {
            [DefaultValue(0)]
            public int UserInfoId { get; set; }

           
            [DisplayName("usr_lbl_11001")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string EmailId { get; set; }

           
            [DisplayName("usr_lbl_11047")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string LoginID { get; set; }

            
            [DisplayName("usr_lbl_11010")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? StatusCodeId { get; set; }

            [PetaPoco.Column("usr_lbl_11010")]
            public string Status { get; set; }

            [PetaPoco.Column("usr_lbl_11010")]
            public string StatusCodeName { get; set; }

            public int UserTypeCodeId { get; set; }

           
            [DisplayName("usr_lbl_11002")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string FirstName { get; set; }

            [DisplayName("usr_lbl_11003")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string MiddleName { get; set; }

           
            [DisplayName("usr_lbl_11004")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string LastName { get; set; }

           
            [DisplayName("usr_lbl_11058")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string EmployeeId { get; set; }

            
            [DisplayName("usr_lbl_11005")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string MobileNumber { get; set; }

           
            [DisplayName("usr_lbl_11006")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? CompanyId { get; set; }
            public string CompanyName { get; set; }

            public int RoleID { get; set; }

            [DisplayName("usr_lbl_11252")]
            public List<PopulateComboDTO> AssignedRole { get; set; }
            public List<PopulateComboDTO> DefaultRole { get; set; }
            public List<string> SubmittedRole { get; set; }

            public bool? IsConfirmPersonalDetails { get; set; }
        }
    public class UserInfoSearchViewModel
        {
            [DefaultValue(0)]
            public int UserInfoId { get; set; }

            
            [ResourceKey("EmailId")]
            [ActivityResourceKey("usr_lbl_11330")]
            [DisplayName("usr_lbl_11330")]
            [StringLength(500)]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string EmailId { get; set; }

            [DataType(DataType.Text)]
            [ResourceKey("LoginID")]
            [ActivityResourceKey("usr_lbl_11336")]
            [DisplayName("usr_lbl_11336")]
            [StringLength(100)]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string LoginID { get; set; }


           
            [DisplayName("usr_grd_11080")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int UserTypeCodeId { get; set; }

            [DataType(DataType.Text)]
            [ResourceKey("FirstName")]
            [ActivityResourceKey("usr_lbl_11331")]
            [DisplayName("usr_lbl_11331")]
            [StringLength(100)]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string FirstName { get; set; }

            [ResourceKey("EmployeeId")]
            [ActivityResourceKey("usr_lbl_11337")]
            [DisplayName("usr_lbl_11337")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string EmployeeId { get; set; }


            [DataType(DataType.PhoneNumber)]
            [ResourceKey("MobileNumber")]
            [ActivityResourceKey("usr_lbl_11334")]
            [DisplayName("usr_lbl_11334")]
            [StringLength(30)]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string MobileNumber { get; set; }


            [DataType(DataType.Text)]
            [ResourceKey("PAN")]
            [ActivityResourceKey("usr_lbl_11019")]
            [DisplayName("usr_lbl_11019")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]

            [StringLength(100)]
            public string PAN { get; set; }


            [ResourceKey("Category")]
            [ActivityResourceKey("usr_lbl_11050")]
            [DisplayName("usr_lbl_11050")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? Category { get; set; }

            [ResourceKey("CategoryName")]
            [ActivityResourceKey("usr_lbl_11427")]
            [DisplayName("usr_lbl_11427")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string CategoryName { get; set; }


           
            [ResourceKey("GradeId")]
            [ActivityResourceKey("usr_lbl_11052")]
            [DisplayName("usr_lbl_11052")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? GradeId { get; set; }

            [ResourceKey("GradeName")]
            [ActivityResourceKey("usr_lbl_11431")]
            [DisplayName("usr_lbl_11431")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string GradeName { get; set; }

            
            [ResourceKey("DesignationId")]
            [ActivityResourceKey("usr_lbl_11053")]
            [DisplayName("usr_lbl_11053")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? DesignationId { get; set; }

            [ResourceKey("DesignationName")]
            [ActivityResourceKey("usr_lbl_11430")]
            [DisplayName("usr_lbl_11430")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string DesignationName { get; set; }


            [ResourceKey("Location")]
            [ActivityResourceKey("usr_lbl_11054")]
            [DisplayName("usr_lbl_11054")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string Location { get; set; }

           
            [ResourceKey("DepartmentId")]
            [ActivityResourceKey("usr_lbl_11055")]
            [DisplayName("usr_lbl_11055")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public int? DepartmentId { get; set; }

            
            [ResourceKey("DepartmentName")]
            [ActivityResourceKey("usr_lbl_11432")]
            [DisplayName("usr_lbl_11432")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "usr_msg_50524")]
            public string DepartmentName { get; set; }

            [DisplayName("usr_chk_55064")]
            public bool AllowUpsiUser { get; set; }
            public UnblockUser objUnblockUser { get; set; } 
        }
    public class RoleMasterSearchViewModel
        {
            [ScaffoldColumn(false)]
            public int RoleId { get; set; }


            [DataType(DataType.Text)]
            [DisplayName("usr_lbl_12038")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
            public string RoleName { get; set; }

            [StringLength(510)]
            [DataType(DataType.Text)]
            [DisplayName("usr_lbl_12039")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
            public string Description { get; set; }


            [DisplayName("usr_lbl_12040")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
            public int? StatusCodeId { get; set; }


            [DisplayName("usr_lbl_12041")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
            public int? UserTypeCodeId { get; set; }

            [DisplayName("usr_lbl_12042")]
            [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
            public bool IsDefault { get; set; }

          
        }
    public class CompanyModelSearchViewModel
    {

        public int CompanyId { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13060")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string CompanyName { get; set; }

       
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13061")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string Address { get; set; }

        
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13062")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string Website { get; set; }

       
        [DisplayName("cmp_lbl_13063")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string EmailId { get; set; }

        public bool IsImplementing { get; set; }

       
        [DisplayName("cmp_lbl_13105")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string ISINNumber { get; set; }

      
        [DisplayName("dis_lbl_50612")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string SmtpServer { get; set; }

        
        [DisplayName("dis_lbl_50613")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string SmtpPortNumber { get; set; }

       
        [DisplayName("dis_lbl_50614")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string SmtpUserName { get; set; }

       
        [Display(Name = "dis_lbl_50615")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "mst_msg_50502")]
        public string SmtpPassword { get; set; }
 
    }
    public class ResourceModelSearchViewModel
    {

        public int? ResourceId { get; set; }

        
        [DisplayName("mst_lbl_10029")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string ResourceKey { get; set; }

        
        [DisplayName("mst_lbl_10030")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string ResourceValue { get; set; }

     
        [DisplayName("mst_lbl_10031")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string ResourceCulture { get; set; }

       
        [DisplayName("mst_lbl_10032")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? ModuleCodeId { get; set; }

       
        [DisplayName("mst_lbl_10033")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? CategoryCodeId { get; set; }

      
        [DisplayName("mst_lbl_10034")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? ScreenCodeId { get; set; }

        
        [DisplayName("mst_lbl_10035")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string OriginalResourceValue { get; set; }

        [DisplayName("mst_lbl_10032")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string ModuleCodeName { get; set; }

        [DisplayName("mst_lbl_10033")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string CategoryCodeName { get; set; }

        [DisplayName("mst_lbl_10034")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string ScreenName { get; set; }

        [DisplayName("mst_lbl_10039")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? GridTypeCodeId { get; set; }

        [DisplayName("mst_lbl_10039")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public string GridHeaderListName { get; set; }

        [DisplayName("mst_lbl_10040")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public bool IsVisible { get; set; }

       
        [DisplayName("mst_lbl_10041")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? SequenceNumber { get; set; }

        [DisplayName("mst_lbl_10045")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? ColumnWidth { get; set; }

        
        [DisplayName("mst_lbl_10046")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "role_msg_50493")]
        public int? ColumnAlignment { get; set; }
    }
    public class TemplateMasterModelSearchViewModel
    {
        public int TemplateMasterId { get; set; }

       
        [DisplayName("tra_lbl_16154")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string TemplateName { get; set; }

     
        [DisplayName("tra_lbl_16155")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int CommunicationModeCodeId { get; set; }

       
        [DisplayName("tra_lbl_16157")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? DisclosureTypeCodeId { get; set; }

       
        [DisplayName("tra_lbl_16158")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? LetterForCodeId { get; set; }

       
        [DisplayName("tra_lbl_16156")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public bool IsActive { get; set; }
        

        [DisplayName("tra_lbl_16159")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public DateTime? Date { get; set; }

       
        [DisplayName("tra_lbl_16160")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string ToAddress1 { get; set; }

       
        [DisplayName("tra_lbl_16161")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string ToAddress2 { get; set; }

      
      
        [DisplayName("tra_lbl_16162")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Subject { get; set; }

      
        [System.Web.Mvc.AllowHtml]
        [DisplayName("tra_lbl_16163")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Contents { get; set; }

      
        [DisplayName("tra_lbl_16164")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Signature { get; set; }

        
        [DisplayName("tra_lbl_16165")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string CommunicationFrom { get; set; }

        
        [DisplayName("tra_lbl_16165")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string CommunicationFromEmail { get; set; }

       
        [DisplayName("tra_lbl_16171")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string SequenceNo { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public bool IsCommunicationTemplate { get; set; }
    }
    public class CommunicationRuleMasterSearchViewModel
    {
        public int RuleId { get; set; }

       
        [DisplayName("cmu_lbl_18021")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string RuleName { get; set; }

        
        [DisplayName("cmu_lbl_18023")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string RuleDescription { get; set; }

       
       
        [DisplayName("cmu_lbl_18027")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string RuleForCodeId { get; set; }

      
        [DisplayName("cmu_lbl_18022")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? RuleCategoryCodeId { get; set; }

        
        [DisplayName("cmu_lbl_18028")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public YesNo? InsiderPersonalize { get; set; }
        public bool InsiderPersonalizeFlag { get; set; }

       
        [DisplayName("cmu_lbl_18024")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string TriggerEventCodeId { get; set; }

       
        [DisplayName("cmu_lbl_18025")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string OffsetEventCodeId { get; set; }
        [DisplayName("cmu_lbl_18026")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int EventsApplyToCodeId { get; set; }

       
        [DisplayName("cmu_lbl_18029")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? RuleStatusCodeId { get; set; }
        [DisplayName("cmu_lbl_18057")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public YesNo? RuleForCodeId_bool { get; set; }
        [DisplayName("cmu_lbl_18058")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public YesNo? EventsApplyToCodeId_bool { get; set; }

        public List<PopulateComboDTO> AssignedTriggerEventCodeId { get; set; }

        public List<string> SelectTriggerEventCodeId { get; set; }

        public List<CommunicationRuleModeMasterModel> CommunicationRuleModeMasterModelList { get; set; }
        public List<PopulateComboDTO> AssignedOffsetEventCodeId { get; set; }

        public List<string> SelectOffsetEventCodeId { get; set; }

        [DisplayName("cmu_lbl_18029")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public RuleStatusCode? RuleStatus { get; set; }

        public enum RuleStatusCode
        {
            Active = Common.ConstEnum.Code.CommunicationRuleStatusActive,
            Inactive = Common.ConstEnum.Code.CommunicationRuleStatusInactive
        }

        public bool? IsApplicabilityDefined { get; set; }

        public int? UserId { get; set; }
    }
    public class NotificationModelSearchViewModel
    {
        
        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string NotificationQueueId { get; set; }

        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? CompanyIdentifierCodeId { get; set; }

       
        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? RuleModeId { get; set; }

        [DisplayName("cmu_lbl_18041")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? ModeCodeId { get; set; }

        [DisplayName("cmu_lbl_18041")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string ModeCodeName { get; set; }

        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string EventLogId { get; set; }

       
        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? UserId { get; set; }

       
        [DisplayName("cmu_lbl_18042")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string UserContactInfo { get; set; }

        
        [DisplayName("cmu_lbl_18037")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Subject { get; set; }

       
        [DisplayName("cmu_lbl_18038")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Contents { get; set; }

        
        [DisplayName("cmu_lbl_18043")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string Signature { get; set; }

       
        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string CommunicationFrom { get; set; }

        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public int? ResponseStatusCodeId { get; set; }

       
        [DisplayName("XXXX")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public string ResponseMessage { get; set; }

        [DisplayName("cmu_lbl_18039")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public DateTime FromDate { get; set; }

        [DisplayName("cmu_lbl_18040")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public DateTime ToDate { get; set; }

        [DisplayName("cmu_lbl_18044")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "tra_msg_50531")]
        public DateTime CreatedOn { get; set; }
    }
    public class SecurityTransferSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DematAccountNumber { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DepositoryName { get; set; }
        public string TransferFromDate { get; set; }
        public string TransferToDate { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DPID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DepositoryParticipantName { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string TransferFromQuantity { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string TransferToQuantity { get; set; }


    }


    //NOVIT
    public class IDReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Grade { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }


    }
    public class CDReportSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Grade { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }
    }
    public class PEReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Grade { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }


    }
    public class PreReportSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Grade { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }
    }
    public class DefaulterReportSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string DematAccountNumber { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string AccountHolder { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string PreClearanceID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public int RequestedQtyFrom { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public int RequestedQtyTo { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public int TradeQtyFrom { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public int TradeQtyTo { get; set; }

    }
    public class ClawBackReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmpID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmpName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmpPAN { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmpDematDetails { get; set; }



    }
    public class IDIndividualReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string AccountHolder { get; set; }



    }
    public class CDIndividualReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string AccountHolder { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string ScriptName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string ISIN { get; set; }
    }
    public class PEIndividualReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string AccountHolder { get; set; }

    }
    public class PreIndividualReportSearchViewModel
    {

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string PreclearenceId { get; set; }

    }
    public class RestrictedListSearchReportSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string PreClearanceID { get; set; }
    }
    public class SecurityReportSearchViewModel
    {
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmployeeName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }
               
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Grade { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Location { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string PAN { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string DematAccountNumber { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string DepositoryName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string DPID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string DepositoryParticipantName { get; set; }
    }

    //PRIYANKA
    public class PreclearanceSearchViewModel
    {
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmployeeId { get; set; }

        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmployeeName { get; set; }

        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string Designation { get; set; }

        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string PreClearanceID { get; set; }

        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string PAN { get; set; }

        public string RequestStatus { get; set; }
        public string TransactionType { get; set; }
        public string TradeDetails { get; set; }
        public string DisclosureDetailsSoftcopy { get; set; }
        public string SubmissionDate { get; set; }
        public string SubmissionDateTo { get; set; }
        public string SoftcopySubmissionFromDate { get; set; }
        public string SoftcopySubmissionDateTo { get; set; }
        public string DisclosureDetailsHardcopy { get; set; }
        public string hardcopySubmissionFromDate { get; set; }
        public string HardcopySubmissionDateTo { get; set; }
        public string Stockexchangesubmissionstatus { get; set; }
        public string StockExchangesubmissionFromDate { get; set; }
        public string StockExchangesubmissionToDate { get; set; }
        public string EmployeeStatus { get; set; }
        public bool ContinuousDisclosureRequired { get; set; }
    }
    public class PreclearanceOSSearchViewModel
    {
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmployeeId { get; set; }

        //[RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string CompanyName { get; set; }
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string PreClearanceID { get; set; }
        public string RequestStatus { get; set; }
        public string TransactionType { get; set; }
    }
    public class PriodEndSearchViewModel
    {
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string employeeid { get; set; }
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string insidername { get; set; }
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string designation { get; set; }
        public string tradingsubmittedfrom { get; set; }
        public string tradingsubmittedto { get; set; }
        public string tradingsubmittedstatus { get; set; }
        public string softcopysubmittedfrom { get; set; }
        public string softcopysubmittedto { get; set; }
        public string softcopysubmittedstatus { get; set; }
        public string hardcopysubmittedfrom { get; set; }
        public string hardcopysubmittedto { get; set; }
        public string hardcopysubmittedstatus { get; set; }
        public string stockexchangesubmittedfrom { get; set; }
        public string stockexchangesubmittedto { get; set; }
        public string stockexchangesubmittedstatus { get; set; }
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string EmpPAN { get; set; }
        public string EmployeeStatus { get; set; }
    }
    public class NscDownloadSearchViewModel
    {
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string GroupNo { get; set; }
        public string DownloadFromDate { get; set; }
        public string DownloadDateTo { get; set; }
        public string SubmissionFromDate { get; set; }
        public string SubmissionDateTo { get; set; }
        public string GrpSubmissionStatus { get; set; }
    }
    public class PreclearanceUserSearchViewModel
    {
        [RegularExpression(Common.ConstEnum.DataValidation.SearchValidation, ErrorMessage = "dis_msg_50505")]
        public string PreClearanceID { get; set; }
    }

    //Tushar
    public class PolicyDocumentSearchViewModel
    {
        [DisplayName("rul_lbl_15107")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rul_msg_50498")]
        public string PolicyDocumentName { get; set; }

        [DisplayName("rul_lbl_15110")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableTo", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15126")]
        public DateTime? ApplicableFrom { get; set; }

        [DisplayName("rul_lbl_15111")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableFrom", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15127")]
        public DateTime? ApplicableTo { get; set; }

        [DisplayName("rul_lbl_15108")]
        public int? DocumentCategoryCodeId { get; set; }
    }
    public class TradingPolicySearchViewModel
    {
        [DisplayName("rul_lbl_15218")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rul_msg_50498")]
        public string PolicyName { get; set; }

        [DisplayName("rul_lbl_15153")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableToDate", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15044")]
        public DateTime? ApplicableFromDate { get; set; }

        [DisplayName("rul_lbl_15154")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableFromDate", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "rul_msg_15044")]
        public DateTime? ApplicableToDate { get; set; }

    }
    public class TradingWindowEventSearchViewModel
    {
        [DisplayName("rul_grd_15010")]
        public string TradingWindowEvent { get; set; }

        public int? EventTypeCodeId { get; set; }

        [DisplayName("rul_grd_15009")]
        public string TradingWindowId { get; set; }

        [DisplayName("rul_lbl_15019")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rul_msg_50498")]
        public int? TradingWindowEventId { get; set; }

        [DisplayName("rul_lbl_15431")]
        public DateTime? WindowCloseDate { get; set; }

        [DisplayName("rul_lbl_15432")]
        public DateTime? WindowOpenDate { get; set; }
    }
}