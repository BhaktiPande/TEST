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
    public class UserInfoModel
    {
        [DefaultValue(0)]
        public int UserInfoId { get; set; }

        [RegularExpressionWithOptions(ConstEnum.DataValidation.Email, ErrorMessage = "usr_msg_11341", RegexOptions = RegexOptions.IgnoreCase)]
        [ResourceKey("EmailId")]
        [ActivityResourceKey("usr_lbl_11330")]
        [DisplayName("usr_lbl_11330")]
        [StringLength(500)]
        public string EmailId { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [ResourceKey("LoginID")]
        [ActivityResourceKey("usr_lbl_11336")]
        [DisplayName("usr_lbl_11336")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string LoginID { get; set; }

        [DataType(DataType.Password)]
        [ResourceKey("Password")]
        [DisplayName("usr_lbl_11057")]
        [StringLength(200)]
        public string Password { get; set; }

        [Required]
        [ResourceKey("StatusCodeId")]
        [DisplayName("usr_lbl_11010")]
        public int? StatusCodeId { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string Status { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string StatusCodeName { get; set; }

        [DisplayName("usr_grd_11080")]
        public int UserTypeCodeId { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("FirstName")]
        [ActivityResourceKey("usr_lbl_11331")]
        [DisplayName("usr_lbl_11331")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string FirstName { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("MiddleName")]
        [ActivityResourceKey("usr_lbl_11332")]
        [DisplayName("usr_lbl_11332")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string MiddleName { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("LastName")]
        [ActivityResourceKey("usr_lbl_11333")]
        [DisplayName("usr_lbl_11333")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string LastName { get; set; }

        [ResourceKey("EmployeeId")]
        [ActivityResourceKey("usr_lbl_11337")]
        [DisplayName("usr_lbl_11337")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmployeeId { get; set; }

        [ResourceKey("CompanyId")]
        [ActivityResourceKey("usr_lbl_11335")]
        [DisplayName("usr_lbl_11335")]
        public int? CompanyId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50491")]
        public string CompanyName { get; set; }

        [ResourceKey("CountryId")]
        [ActivityResourceKey("usr_lbl_11009")]
        [DisplayName("usr_lbl_11009")]
        public int? CountryId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50491")]
        public string CountryName { get; set; }

        [DataType(DataType.PhoneNumber)]
        [ResourceKey("MobileNumber")]
        [ActivityResourceKey("usr_lbl_11334")]
        [DisplayName("usr_lbl_11334")]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_11342")]
        public string MobileNumber { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("AddressLine1")]
        [ActivityResourceKey("usr_lbl_11007")]
        [DisplayName("usr_lbl_11007")]
        [StringLength(1000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string AddressLine1 { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("AddressLine2")]
        [DisplayName("usr_lbl_11008")]
        [StringLength(1000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string AddressLine2 { get; set; }

        [ResourceKey("StateId")]
        [DisplayName("usr_lbl_11056")]
        public int StateId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string StateName { get; set; }

        [ResourceKey("City")]
        [DisplayName("usr_lbl_11011")]
        [StringLength(200)]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string City { get; set; }

        [ResourceKey("PinCode")]
        [ActivityResourceKey("usr_lbl_11012")]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11012")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        public string PinCode { get; set; }

        [ResourceKey("ContactPerson")]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11013")]
        [StringLength(200)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string ContactPerson { get; set; }

        [DataType(DataType.DateTime)]
        [ResourceKey("DateOfJoining")]
        [ActivityResourceKey("usr_lbl_11014")]
        [DisplayName("usr_lbl_11014")]
        public DateTime? DateOfJoining { get; set; }

        [DataType(DataType.DateTime)]
        [ResourceKey("DateOfBecomingInsider")]
        [ActivityResourceKey("usr_lbl_11015")]
        [DisplayName("usr_lbl_11015")]
        public DateTime? DateOfBecomingInsider { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("LandLine1")]
        [DisplayName("usr_lbl_11016")]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_50490")]
        public string LandLine1 { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("LandLine2")]
        [DisplayName("usr_lbl_11017")]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_55506")]
        public string LandLine2 { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("Website")]
        [RegularExpressionWithOptions(ConstEnum.DataValidation.Website, ErrorMessage = "usr_msg_11340", RegexOptions = RegexOptions.IgnoreCase)]
        [DisplayName("usr_lbl_11018")]
        [StringLength(1000)]
        public string Website { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("PAN")]
        [ActivityResourceKey("usr_lbl_11019")]
        [DisplayName("usr_lbl_11019")]
        [RegularExpression(ConstEnum.DataValidation.PAN, ErrorMessage = "usr_msg_11343")]
        [StringLength(100)]
        public string PAN { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("TAN")]
        [DisplayName("usr_lbl_11020")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.TAN, ErrorMessage = "dis_msg_50518")]
        public string TAN { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("Description")]
        [DisplayName("usr_lbl_11021")]
        [StringLength(2048)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string Description { get; set; }

        [ResourceKey("Category")]
        [ActivityResourceKey("usr_lbl_11050")]
        [DisplayName("usr_lbl_11050")]
        public int? Category { get; set; }

        [ResourceKey("CategoryName")]
        [ActivityResourceKey("usr_lbl_11427")]
        [DisplayName("usr_lbl_11427")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string CategoryName { get; set; }

        [ResourceKey("SubCategory")]
        [ActivityResourceKey("usr_lbl_11051")]
        [DisplayName("usr_lbl_11051")]
        public int? SubCategory { get; set; }


        [DisplayName("usr_lbl_11428")]
        [ResourceKey("SubCategoryName")]
        [ActivityResourceKey("usr_lbl_11428")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string SubCategoryName { get; set; }


        [ResourceKey("GradeId")]
        [ActivityResourceKey("usr_lbl_11052")]
        [DisplayName("usr_lbl_11052")]
        public int? GradeId { get; set; }

        [ResourceKey("GradeName")]
        [ActivityResourceKey("usr_lbl_11431")]
        [DisplayName("usr_lbl_11431")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string GradeName { get; set; }

        [ResourceKey("DesignationId")]
        [ActivityResourceKey("usr_lbl_11053")]
        [DisplayName("usr_lbl_11053")]
        public int? DesignationId { get; set; }

        [ResourceKey("DesignationName")]
        [ActivityResourceKey("usr_lbl_11430")]
        [DisplayName("usr_lbl_11430")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string DesignationName { get; set; }

        [DisplayName("usr_lbl_11253")]
        [ActivityResourceKey("usr_lbl_11253")]
        [ResourceKey("SubDesignationId")]
        public int? SubDesignationId { get; set; }

        [DisplayName("usr_lbl_11429")]
        [ActivityResourceKey("usr_lbl_11429")]
        [ResourceKey("SubDesignationName")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string SubDesignationName { get; set; }

        [ResourceKey("Location")]
        [ActivityResourceKey("usr_lbl_11054")]
        [DisplayName("usr_lbl_11054")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string Location { get; set; }

        [ResourceKey("DepartmentId")]
        [ActivityResourceKey("usr_lbl_11055")]
        [DisplayName("usr_lbl_11055")]
        public int? DepartmentId { get; set; }

        [ResourceKey("DepartmentName")]
        [ActivityResourceKey("usr_lbl_11432")]
        [DisplayName("usr_lbl_11432")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string DepartmentName { get; set; }

        [ResourceKey("UPSIAccessOfCompanyID")]
        [ActivityResourceKey("usr_lbl_11022")]
        [DisplayName("usr_lbl_11022")]
        public int? UPSIAccessOfCompanyID { get; set; }
        public string UPSIAccessOfCompanyName { get; set; }

        [ResourceKey("RelationTypeCodeId")]
        [DisplayName("usr_lbl_11023")]
        public int? RelationTypeCodeId { get; set; }

        public int? ParentId { get; set; }
        public string ParentFirstName { get; set; }
        public string ParentLastName { get; set; }

        public int? IsInsider { get; set; }

        [Required]
        public DateTime? DateOfSeparation { get; set; }

        [Required]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string ReasonForSeparation { get; set; }

        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50491")]
        public string CIN { get; set; }

        [ResourceKey("DIN")]
        [ActivityResourceKey("usr_lbl_11260")]
        [DisplayName("usr_lbl_11260")]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50491")]
        public string DIN { get; set; }

        public int RoleID { get; set; }

        [ResourceKey("UserRoleId")]
        [ActivityResourceKey("usr_lbl_11338")]
        [DisplayName("usr_lbl_11338")]
        public List<PopulateComboDTO> AssignedRole { get; set; }
        public List<PopulateComboDTO> DefaultRole { get; set; }
        public List<string> SubmittedRole { get; set; }

        public bool? IsRequiredConfirmPersonalDetails { get; set; }

        [Required]
        public int? NoOfDaysToBeActive { get; set; }

        [Required]
        public DateTime? DateOfInactivation { get; set; }

        [ResourceKey("Resident Type")]
        [ActivityResourceKey("usr_lbl_54050")]
        [DisplayName("usr_lbl_54050")]
        public int? ResidentTypeId { get; set; }


        [DisplayName("usr_lbl_54051")]
        [ResourceKey("Identification Number")]
        [ActivityResourceKey("usr_lbl_54051")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        public string UIDAI_IdentificationNo { get; set; }
       
        [ResourceKey("Identification Type")]
        [ActivityResourceKey("usr_lbl_54067")]
        [DisplayName("usr_lbl_54067")]
        public int? IdentificationTypeId { get; set; }

        [DisplayName("usr_chk_55064")]
        public bool AllowUpsiUser { get; set; }
		public UnblockUser objUnblockUser { get; set; } 
    }

    public class COUserInfoModel
    {
        [DefaultValue(0)]
        public int UserInfoId { get; set; }

        [Required]
        [RegularExpressionWithOptions(ConstEnum.DataValidation.Email, ErrorMessage = "usr_msg_11046", RegexOptions = RegexOptions.IgnoreCase)]
        [DisplayName("usr_lbl_11001")]
        public string EmailId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11047")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string LoginID { get; set; }

        [Required]
        [DisplayName("usr_lbl_11010")]
        public int? StatusCodeId { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string Status { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string StatusCodeName { get; set; }

        public int UserTypeCodeId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11002")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string FirstName { get; set; }

        [DisplayName("usr_lbl_11003")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string MiddleName { get; set; }

        [Required]
        [DisplayName("usr_lbl_11004")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string LastName { get; set; }

        [Required]
        [DisplayName("usr_lbl_11058")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmployeeId { get; set; }

        [Required]
        [DisplayName("usr_lbl_11005")]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_11048")]
        public string MobileNumber { get; set; }

        [Required]
        [DisplayName("usr_lbl_11006")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_11049")]
        public int? CompanyId { get; set; }
        public string CompanyName { get; set; }

        public int RoleID { get; set; }

        [DisplayName("usr_lbl_11252")]
        public List<PopulateComboDTO> AssignedRole { get; set; }
        public List<PopulateComboDTO> DefaultRole { get; set; }
        public List<string> SubmittedRole { get; set; }

        public bool? IsConfirmPersonalDetails { get; set; }
    }

    public class CorporateUSerModel
    {
        [DefaultValue(0)]
        public int UserInfoId { get; set; }

        //[Required]
        [RegularExpressionWithOptions(ConstEnum.DataValidation.Email, ErrorMessage = "usr_msg_11322", RegexOptions = RegexOptions.IgnoreCase)]
        [DisplayName("usr_lbl_11292")]
        [ActivityResourceKey("usr_lbl_11292")]
        [ResourceKey("Email (Corporate User)")]
        [StringLength(500)]
        public string EmailId { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11287")]
        [ActivityResourceKey("usr_lbl_11287")]
        [ResourceKey("User Name (Corporate User)")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string LoginID { get; set; }

        //[Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_11323")]
        [DisplayName("usr_lbl_11286")]
        [ActivityResourceKey("usr_lbl_11286")]
        [ResourceKey("Company (Corporate User)")]
        public int? CompanyId { get; set; }
        public string CompanyName { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11295")]
        [ActivityResourceKey("usr_lbl_11295")]
        [ResourceKey("Address (Corporate User)")]
        [StringLength(1000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string AddressLine1 { get; set; }

        [DisplayName("usr_lbl_11297")]
        [ActivityResourceKey("usr_lbl_11297")]
        [ResourceKey("Country (Corporate User)")]
        public int CountryId { get; set; }
        public string CountryName { get; set; }

        public int StateId { get; set; }
        public string StateName { get; set; }

        [StringLength(200)]
        public string City { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11296")]
        [ActivityResourceKey("usr_lbl_11296")]
        [ResourceKey("Pincode (Corporate User)")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        public string PinCode { get; set; }

        //[Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11290")]
        [ActivityResourceKey("usr_lbl_11290")]
        [ResourceKey("Contact Person (Corporate User)")]
        [StringLength(200)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string ContactPerson { get; set; }

        //[Required]
        [DataType(DataType.DateTime)]
        [DisplayName("usr_lbl_11288")]
        [ActivityResourceKey("usr_lbl_11288")]
        [ResourceKey("Date Of Becoming Insider (Corporate User)")]
        public DateTime? DateOfBecomingInsider { get; set; }

        [StringLength(30)]
        [DisplayName("usr_lbl_11293")]
        [ActivityResourceKey("usr_lbl_11293")]
        [ResourceKey("LandLine1 (Corporate User)")]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_50490")]
        public string LandLine1 { get; set; }

        [DataType(DataType.Text)]
        [StringLength(30)]
        [DisplayName("usr_lbl_11294")]
        [ActivityResourceKey("usr_lbl_11294")]
        [ResourceKey("LandLine2 (Corporate User)")]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_55506")]
        public string LandLine2 { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11298")]
        [ActivityResourceKey("usr_lbl_11298")]
        [ResourceKey("Website (Corporate User)")]
        [RegularExpressionWithOptions(ConstEnum.DataValidation.Website, ErrorMessage = "usr_msg_11324", RegexOptions = RegexOptions.IgnoreCase)]
        [StringLength(1000)]
        public string Website { get; set; }

        //[Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11300")]
        [ActivityResourceKey("usr_lbl_11300")]
        [ResourceKey("PAN (Corporate User)")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.PAN, ErrorMessage = "usr_msg_11325")]
        public string PAN { get; set; }

        //[Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11299")]
        [ActivityResourceKey("usr_lbl_11299")]
        [ResourceKey("TAN (Corporate User)")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.TAN, ErrorMessage = "usr_msg_11325")]
        public string TAN { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11301")]
        [ActivityResourceKey("usr_lbl_11301")]
        [ResourceKey("Description (Corporate User)")]
        [StringLength(2048)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string Description { get; set; }


        [DisplayName("usr_lbl_11291")]
        //[ActivityResourceKey("usr_lbl_11291")]
        //[ResourceKey("Designation (Corporate User)")]
        public int? DesignationId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        [ActivityResourceKey("usr_lbl_11291")]
        [ResourceKey("Designation (Corporate User)")]
        public string DesignationName { get; set; }

        public int RoleID { get; set; }

        [DisplayName("usr_lbl_11302")]
        public List<PopulateComboDTO> AssignedRole { get; set; }
        public List<PopulateComboDTO> DefaultRole { get; set; }
        public List<string> SubmittedRole { get; set; }

        //[Required]
        [DisplayName("usr_lbl_11289")]
        [ActivityResourceKey("usr_lbl_11289")]
        [ResourceKey("CIN (Corporate User)")]
        //[StringLength(21, MinimumLength = 7, ErrorMessage = "usr_msg_11423")]
        [RegularExpression( ConstEnum.DataValidation.CIN, ErrorMessage = "usr_msg_11423")]
        public string CIN { get; set; }

        [ResourceKey("Category (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11427")]
        [DisplayName("usr_lbl_11427")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string CategoryName { get; set; }

        [DisplayName("usr_lbl_11428")]
        [ResourceKey("SubCategory (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11428")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string SubCategoryName { get; set; }

        public Corporate_DMATDetailsModel dmatDetailsModel { get; set; }

        public bool? IsConfirmPersonalDetails { get; set; }
        [DisplayName("usr_chk_55065")]
        public bool AllowUpsiUser { get; set; }

    }


    public class RelativeInfoModel
    {
        [DefaultValue(0)]
        public int UserInfoId { get; set; }

        [RegularExpressionWithOptions(ConstEnum.DataValidation.Email, ErrorMessage = "usr_msg_11341", RegexOptions = RegexOptions.IgnoreCase)]
        [ResourceKey("EmailId")]
        [ActivityResourceKey("usr_lbl_11363")]
        [DisplayName("usr_lbl_11363")]
        [StringLength(500)]
        //[Required]
        public string EmailId { get; set; }

        //[Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11354")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string LoginID { get; set; }

        [DataType(DataType.Password)]
        [StringLength(200)]
        public string Password { get; set; }

        [Required]
        [DisplayName("usr_lbl_50774")]
        public int? DoYouHaveDMATEAccount { get; set; }

        [Required]
        [ResourceKey("RelativeStatus")]
        [ActivityResourceKey("usr_lbl_11010")]
        [DisplayName("usr_lbl_11010")]
        public int? RelativeStatus { get; set; }

        //[Required]
        public int? StatusCodeId { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string Status { get; set; }

        [PetaPoco.Column("usr_lbl_11010")]
        public string StatusCodeName { get; set; }

        public int UserTypeCodeId { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("FirstName")]
        [ActivityResourceKey("usr_lbl_11357")]
        [DisplayName("usr_lbl_11357")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        //[Required]
        public string FirstName { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("MiddleName")]
        [ActivityResourceKey("usr_lbl_11358")]
        [DisplayName("usr_lbl_11358")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        //[Required]
        public string MiddleName { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("LastName")]
        [ActivityResourceKey("usr_lbl_11359")]
        [DisplayName("usr_lbl_11359")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        //[Required]
        public string LastName { get; set; }

        [DisplayName("usr_lbl_11353")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50491")]
        public string EmployeeId { get; set; }

        [DisplayName("usr_lbl_11355")]
        public int? CompanyId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50491")]
        public string CompanyName { get; set; }

        [ResourceKey("CountryId")]
        [ActivityResourceKey("usr_lbl_11362")]
        [DisplayName("usr_lbl_11362")]
        public int? CountryId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50491")]
        public string CountryName { get; set; }

        [DataType(DataType.PhoneNumber)]
        [ResourceKey("MobileNumber")]
        [ActivityResourceKey("usr_lbl_11364")]
        [DisplayName("usr_lbl_11364")]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_11342")]
        public string MobileNumber { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("AddressLine1")]
        [ActivityResourceKey("usr_lbl_11360")]
        [DisplayName("usr_lbl_11360")]
        [StringLength(1000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string AddressLine1 { get; set; }

        [DataType(DataType.Text)]
        [StringLength(1000)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string AddressLine2 { get; set; }

        public int StateId { get; set; }
        public string StateName { get; set; }

        [StringLength(200)]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string City { get; set; }

        [ResourceKey("PinCode")]
        [ActivityResourceKey("usr_lbl_11361")]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_11361")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        //[Required]
        public string PinCode { get; set; }

        [DataType(DataType.Text)]
        [StringLength(200)]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50489")]
        public string ContactPerson { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? DateOfJoining { get; set; }

        [DataType(DataType.DateTime)]
        public DateTime? DateOfBecomingInsider { get; set; }

        [DataType(DataType.Text)]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_50490")]
        public string LandLine1 { get; set; }

        [DataType(DataType.Text)]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_55506")]
        public string LandLine2 { get; set; }

        [DataType(DataType.Text)]
        [RegularExpressionWithOptions(ConstEnum.DataValidation.Website, ErrorMessage = "usr_msg_11340", RegexOptions = RegexOptions.IgnoreCase)]
        [StringLength(1000)]
        public string Website { get; set; }

        [DataType(DataType.Text)]
        [ResourceKey("PAN")]
        [ActivityResourceKey("usr_lbl_11365")]
        [DisplayName("usr_lbl_11365")]
        [RegularExpression(ConstEnum.DataValidation.PAN, ErrorMessage = "usr_msg_11343")]
        [StringLength(100)]
        public string PAN { get; set; }

        [DataType(DataType.Text)]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.TAN, ErrorMessage = "dis_msg_50518")]
        public string TAN { get; set; }

        [DataType(DataType.Text)]
        [StringLength(2048)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "dis_msg_50513")]
        public string Description { get; set; }

        public int? Category { get; set; }

        public string CategoryName { get; set; }

        public int? SubCategory { get; set; }
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string SubCategoryName { get; set; }

        public int? GradeId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50489")]
        public string GradeName { get; set; }

        public int? DesignationId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string DesignationName { get; set; }

        public int? SubDesignationId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string SubDesignationName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string Location { get; set; }

        public int? DepartmentId { get; set; }

        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "usr_msg_50489")]
        public string DepartmentName { get; set; }

        public int? UPSIAccessOfCompanyID { get; set; }
        public string UPSIAccessOfCompanyName { get; set; }

        [Required]
        [ResourceKey("RelationTypeCodeId")]
        [ActivityResourceKey("usr_lbl_11023")]
        [DisplayName("usr_lbl_11023")]
        public int? RelationTypeCodeId { get; set; }

        public int? ParentId { get; set; }
        public string ParentFirstName { get; set; }
        public string ParentLastName { get; set; }

        public int? IsInsider { get; set; }

        public DateTime? DateOfSeparation { get; set; }

        public string ReasonForSeparation { get; set; }

        public string CIN { get; set; }

        public string DIN { get; set; }

        public int RoleID { get; set; }

        public List<PopulateComboDTO> AssignedRole { get; set; }
        public List<PopulateComboDTO> DefaultRole { get; set; }
        public List<string> SubmittedRole { get; set; }

        public bool? IsConfirmPersonalDetails { get; set; }

        public int? NoOfDaysToBeActive { get; set; }

        public DateTime? DateOfInactivation { get; set; }

        [ResourceKey("Identification Type")]
        [ActivityResourceKey("usr_lbl_54068")]
        [DisplayName("usr_lbl_54068")]
        public int? IdentificationTypeId { get; set; }

        [DisplayName("usr_lbl_54069")]
        [ResourceKey("Identification Number")]
        [ActivityResourceKey("usr_lbl_54069")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        public string UIDAI_IdentificationNo { get; set; }

    }
    public class MobileDetails
    {
        public string MobileNumber { get; set; }

        public int UserInfoID { get; set; }

        public int UserRelativeID { get; set; }

        public int CreatedBy { get; set; }

        public DateTime CreatedOn { get; set; }

        public int UpdatedBy { get; set; }

        public DateTime UpdatedOn { get; set; }

        public string DuplicateMobileNo { get; set; }
        
    }

    public class RelativeMobileDetail
    {
        public string MobileNumber { get; set; }

        public int UserInfoID { get; set; }

        public int UserRelativeID { get; set; }

        public int CreatedBy { get; set; }
        
        public DateTime CreatedOn { get; set; }
        
        public int UpdatedBy { get; set; }
        
        public DateTime UpdatedOn { get; set; }



    }


    public class EducationDetailModel
    {
        [ActivityResourceKey("usr_lbl_54003")]
        [ResourceKey("Institute Name")]
        [DisplayName("usr_lbl_54003")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]
        public string InstituteName { get; set; }

        [ActivityResourceKey("usr_lbl_54004")]
        [ResourceKey("Course Name")]
        [DisplayName("usr_lbl_54004")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_54035")]
        public string CourseName { get; set; }

        [ActivityResourceKey("usr_lbl_54005")]
        [ResourceKey("Passing Month")]
        [DisplayName("usr_lbl_54005")]
        // [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_54036")]
        public string PassingMonth { get; set; }

        [ActivityResourceKey("usr_lbl_54006")]
        [ResourceKey("Passing Year")]
        [DisplayName("usr_lbl_54006")]
        //[RegularExpression(ConstEnum.DataValidation.NumbersOnly, ErrorMessage = "usr_msg_54037")]
        public string PassingYear { get; set; }



        [DisplayName("usr_lbl_54008")]
        [DefaultValue(1)]
        public int EducationWorkTypeFlag { get; set; }

        [ActivityResourceKey("usr_lbl_54010")]
        [ResourceKey("Employer")]
        [DisplayName("usr_lbl_54010")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumWithoutLessthanGreaterthanNAsterisc, ErrorMessage = "usr_msg_52089")]

        public string Employer { get; set; }

        [ActivityResourceKey("usr_lbl_54011")]
        [ResourceKey("Designation")]
        [DisplayName("usr_lbl_54011")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_54039")]
        public string Designation { get; set; }


        [ActivityResourceKey("usr_lbl_54024")]
        [ResourceKey("From Month")]
        [DisplayName("usr_lbl_54024")]
        public string From_Month { get; set; }

        [ActivityResourceKey("usr_lbl_54025")]
        [ResourceKey("From Year")]
        [DisplayName("usr_lbl_54025")]
        public string From_Year { get; set; }

        [ActivityResourceKey("usr_lbl_54026")]
        [ResourceKey("To Month")]
        [DisplayName("usr_lbl_54026")]
        public string To_Month { get; set; }

        [ActivityResourceKey("usr_lbl_54027")]
        [ResourceKey("To Year")]
        [DisplayName("usr_lbl_54027")]
        public string To_Year { get; set; }



        public IEnumerable<SelectListItem> MonthList
        {
            get
            {
                return DateTimeFormatInfo
                       .InvariantInfo
                       .MonthNames
                       .Select((monthName, index) => new SelectListItem
                       {
                           Value = monthName,
                           Text = monthName
                       }).Where(x=>x.Value!="");
            }
        }


        public int UserInfoID { get; set; }

        public int UEW_id { get; set; }
    }
    public class UnblockUser
    {
        public int UserInfoID { get; set; }
        [ActivityResourceKey("usr_lbl_54109")]
        [ResourceKey("usr_lbl_54109")]
        [DisplayName("usr_lbl_54109")]
        public bool IsBlocked { get; set; }
        [ActivityResourceKey("usr_lbl_54110")]
        [ResourceKey("usr_lbl_54110")]
        [DisplayName("usr_lbl_54110")]
        public string Block_Unblock_Reasion { get; set; }
    
    }


}
