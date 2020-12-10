
using System;
namespace InsiderTradingDAL
{
    [PetaPoco.TableName("rl_CompanyMasterList")]
    public class RestrictedListDTO
    {
        [PetaPoco.Column("RlCompanyId")]
        public int? RLCompanyId { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("BSECode")]
        public string BSECode { get; set; }

        [PetaPoco.Column("NSECode")]
        public string NSECode { get; set; }

        [PetaPoco.Column("ISINCode")]
        public string ISINCode { get; set; }

        [PetaPoco.Column("ApplicableFromDate")]
        public DateTime ApplicableFromDate { get; set; }

		[PetaPoco.Column("UserInfoId")]
        public int? UserInfoId { get; set; }

        [PetaPoco.Column("ApplicableToDate")]
        public DateTime ApplicableToDate { get; set; }

        [PetaPoco.Column("RlMasterId")]
        public int? RlMasterId { get; set; }

        [PetaPoco.Column("UserName")]
        public string UserName { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public string CreatedBy { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }
    }

    public class RestrictedSearchAudittDTO
    {
        [PetaPoco.Column("RlSearchAuditId")]
        public int RlSearchAuditId { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("ResourceKey")]
        public string ResourceKey { get; set; }

        [PetaPoco.Column("RlCompanyId")]
        public int RlCompanyId { get; set; }

        [PetaPoco.Column("RlMasterId")]
        public int? RlMasterId { get; set; }

        [PetaPoco.Column("ModuleCodeId")]
        public int ModuleCodeId { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public string CreatedBy { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn { get; set; }
    }

    public class RestrictedListSettingsDTO
    {
        public int Preclearance_Required { get; set; }

        public int Preclearance_Approval { get; set; }

        public int Preclearance_AllowZeroBalance { get; set; }

        public int Preclearance_FORM_Required_Restricted_company { get; set; }

        public int? Preclearance_Form_F_File_Id { get; set; }

        public int Allow_Restricted_List_Search { get; set; }

        public int? RLSearchLimit { get; set; }
    }
}
