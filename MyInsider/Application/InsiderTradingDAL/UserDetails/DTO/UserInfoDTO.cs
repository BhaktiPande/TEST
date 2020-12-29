using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_UserInfo")]
    public class UserInfoDTO
    {
        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("LoginID")]
        public string LoginID { get; set; }

        [PetaPoco.Column("Password")]
        public string Password { get; set; }

        [PetaPoco.Column("UserTypeCodeId")]
        public int? UserTypeCodeId { get; set; }

        [PetaPoco.Column("StatusCodeId")]
        public int? StatusCodeId { get; set; }

        [PetaPoco.Column("Status")]
        public string Status { get; set; }

        [PetaPoco.Column("StatusCodeName")]
        public string StatusCodeName { get; set; }

        [PetaPoco.Column("UserStatusCode")]
        public string UserStatusCode { get; set; }

        [PetaPoco.Column("EmailId")]
        public string EmailId { get; set; }

        [PetaPoco.Column("UserName")]
        public string UserName { get; set; }

        [PetaPoco.Column("FirstName")]
        public string FirstName { get; set; }

        [PetaPoco.Column("MiddleName")]
        public string MiddleName { get; set; }

        [PetaPoco.Column("LastName")]
        public string LastName { get; set; }

        [PetaPoco.Column("EmployeeId")]
        public string EmployeeId { get; set; }

        [PetaPoco.Column("MobileNumber")]
        public string MobileNumber { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("ISINNumber")]
        public string ISINNumber { get; set; }

        [PetaPoco.Column("CompanyId")]
        public int? CompanyId { get; set; }

        [PetaPoco.Column("AddressLine1")]
        public string AddressLine1 { get; set; }

        [PetaPoco.Column("AddressLine2")]
        public string AddressLine2 { get; set; }

        [PetaPoco.Column("PersonalAddress")]
        public string PersonalAddress { get; set; }

        [PetaPoco.Column("CountryId")]
        public int? CountryId { get; set; }
        public string CountryName { get; set; }

        [PetaPoco.Column("StateId")]
        public int? StateId { get; set; }
        public string StateName { get; set; }

        [PetaPoco.Column("City")]
        public string City { get; set; }

        [PetaPoco.Column("PinCode")]
        public string PinCode { get; set; }

        [PetaPoco.Column("ContactPerson")]
        public string ContactPerson { get; set; }

        [PetaPoco.Column("DateOfJoining")]
        public DateTime? DateOfJoining { get; set; }

        [PetaPoco.Column("DateOfBecomingInsider")]
        public DateTime? DateOfBecomingInsider { get; set; }

        [PetaPoco.Column("LandLine1")]
        public string LandLine1 { get; set; }

        [PetaPoco.Column("LandLine2")]
        public string LandLine2 { get; set; }

        [PetaPoco.Column("Website")]
        public string Website { get; set; }

        [PetaPoco.Column("PAN")]
        public string PAN { get; set; }

        [PetaPoco.Column("TAN")]
        public string TAN { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("Category")]
        public int? Category { get; set; }
        public string CategoryName { get; set; }

        [PetaPoco.Column("SubCategory")]
        public int? SubCategory { get; set; }
        public string SubCategoryName { get; set; }

        [PetaPoco.Column("GradeId")]
        public int? GradeId { get; set; }
        public string GradeName { get; set; }

        [PetaPoco.Column("DesignationId")]
        public int? DesignationId { get; set; }
        public string DesignationName { get; set; }

        [PetaPoco.Column("SubDesignationId")]
        public int? SubDesignationId { get; set; }
        public string SubDesignationName { get; set; }

        [PetaPoco.Column("Location")]
        public string Location { get; set; }

        [PetaPoco.Column("DepartmentId")]
        public int? DepartmentId { get; set; }
        public string DepartmentName { get; set; }

        [PetaPoco.Column("UPSIAccessOfCompanyID")]
        public int? UPSIAccessOfCompanyID { get; set; }


        public int LoggedInUserId { get; set; }

        [PetaPoco.Column("ParentId")]
        public int? ParentId { get; set; }

        [PetaPoco.Column("RelationTypeCodeId")]
        public int? RelationTypeCodeId { get; set; }

        [PetaPoco.Column("IsInsider")]
        public int? IsInsider { get; set; }

        [PetaPoco.Column("DateOfSeparation")]
        public DateTime? DateOfSeparation { get; set; }

        [PetaPoco.Column("ReasonForSeparation")]
        public string ReasonForSeparation { get; set; }

        public string SubmittedRoleIds { get; set; }

        [PetaPoco.Column("CIN")]
        public string CIN { get; set; }

        [PetaPoco.Column("DIN")]
        public string DIN { get; set; }

        [PetaPoco.Column("CompanyLogoURL")]
        public string CompanyLogoURL { get; set; }

        [PetaPoco.Column("LastLoginTime")]
        public DateTime LastLoginTime { get; set; }

        [PetaPoco.Column("IsRequiredConfirmPersonalDetails")]
        public bool? IsRequiredConfirmPersonalDetails { get; set; }

        [PetaPoco.Column("NoOfDaysToBeActive")]
        public int? NoOfDaysToBeActive { get; set; }

        [PetaPoco.Column("DateOfInactivation")]
        public DateTime? DateOfInactivation { get; set; }

        [PetaPoco.Column("PeriodEndPerformed")]
        public string PeriodEndPerformed { get; set; }

        [PetaPoco.Column("EmployeeName")]
        public string EmployeeName { get; set; }

        [PetaPoco.Column("RelativeStatus")]
        public int? RelativeStatus { get; set; }

        [PetaPoco.Column("DoYouHaveDMATEAccountFlag")]
        public int? DoYouHaveDMATEAccountFlag { get; set; }

        public int SaveNAddDematflag { get; set; }

        [PetaPoco.Column("ResidentTypeId")]
        public int? ResidentTypeId { get; set; }
        [PetaPoco.Column("UIDAI_IdentificationNo")]
        public string UIDAI_IdentificationNo { get; set; }
        [PetaPoco.Column("IdentificationTypeId")]
        public int? IdentificationTypeId { get; set; }
        [PetaPoco.Column("AllowUpsiUser")]
        public bool? AllowUpsiUser { get; set; }
		[PetaPoco.Column("IsBlocked")]
        public bool IsBlocked { get; set; }

        [PetaPoco.Column("Blocked_UnBlock_Reason")]
        public string Blocked_UnBlock_Reason { get; set; }
        public string MobNumber_WithoutCountyCode { get; set; }
        public string MobNumber_WithCountyCode { get; set; }
    }

    public class PasswordManagementDTO
    {
        [PetaPoco.Column("CompanyID")]
        public string CompanyID { get; set; }
        public string CompanyName { get; set; }

        [PetaPoco.Column("LoginID")]
        public string LoginID { get; set; }

        [PetaPoco.Column("UserInfoID")]
        public int UserInfoID { get; set; }

        [PetaPoco.Column("EmailID")]
        public string EmailID { get; set; }

        [PetaPoco.Column("NewPassword")]
        public string NewPassword { get; set; }

        [PetaPoco.Column("OldPassword")]
        public string OldPassword { get; set; }

        [PetaPoco.Column("ConfirmNewPassword")]
        public string ConfirmNewPassword { get; set; }

        [PetaPoco.Column("HashValue")]
        public string HashValue { get; set; }

        public string SaltValue { get; set; }

    }
    /// <summary>
    /// This class will be used for fetching the data related to Password policy for password validation
    /// </summary>
    public class PasswordPolicyDTO
    {
        [PetaPoco.Column("MaxLength")]
        public int MaxLength { get; set; }

        [PetaPoco.Column("MinLength")]
        public int MinLength { get; set; }

        [PetaPoco.Column("MinNoOfAlphabets")]
        public int MinNoOfAlphabets { get; set; }

        [PetaPoco.Column("MinNoOfNumbers")]
        public int MinNoOfNumbers { get; set; }

        [PetaPoco.Column("MinSpecialCharacters")]
        public int MinSpecialCharacters { get; set; }

        [PetaPoco.Column("MinUpperCaseLetters")]
        public int MinUpperCaseLetters { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
     [PetaPoco.TableName("usr_EducationWorkDetails")]
    public class UserEducationDTO
    {

        [PetaPoco.Column("UEW_id")]
         public int UEW_id { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("InstituteName")]
        public string InstituteName { get; set; }

        [PetaPoco.Column("CourseName")]
        public string CourseName { get; set; }

        [PetaPoco.Column("EmployerName")]
        public string EmployerName { get; set; }

        [PetaPoco.Column("Designation")]
        public string Designation { get; set; }

        [PetaPoco.Column("PMonth")]
        public string PMonth { get; set; }

        [PetaPoco.Column("PYear")]
        public int PYear { get; set; }

        [PetaPoco.Column("ToMonth")]
        public string ToMonth { get; set; }

        [PetaPoco.Column("ToYear")]
        public int ToYear { get; set; }

        [PetaPoco.Column("Flag")]
        public int Flag { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public string CreatedBy { get; set; }

        [PetaPoco.Column("Operation")]
        public string Operation { get; set; }
        [PetaPoco.Column("Updated_By")]
        public string Updated_By { get; set; }
    }
    public class SessionDetailsDTO
    {
        public int UserId { get; set; }

        public string CookieName { get; set; }

        public DateTime ExpireOn { get; set; }
    }

    public class TokenDetailsDTO
    {
        public string UserId { get; set; }

        public int FormId { get; set; }

        public string TokenName { get; set; }

        public DateTime ExpireOn { get; set; }
    }

    public class ContactDetails
    {
        
        public string MobileNumber { get; set; }

        [PetaPoco.Column("UserInfoID")]
        public int UserInfoID { get; set; }

        [PetaPoco.Column("UserRelativeID")]
        public int UserRelativeID { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public int CreatedBy { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }

        [PetaPoco.Column("UpdatedBy")]
        public int UpdatedBy { get; set; }

        [PetaPoco.Column("UpdatedOn")]
        public DateTime UpdatedOn { get; set; }

        public string DuplicateMobileNo { get; set; }

    }

    public class OtherUsersDetails
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public string PAN { get; set; }
        public string CompanyName { get; set; }
        public string CompanyAddress { get; set; }
        public string Phone { get; set; }
    }
}
