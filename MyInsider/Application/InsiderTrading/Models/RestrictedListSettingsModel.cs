using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class RestrictedListSettingsModel
    {
        [Required]
        [DisplayName("rl_lbl_50369")]
        public Configuration_YesNo Preclearance_Required { get; set; }

        [Required]
        [DisplayName("rl_lbl_50370")]
        public PreClearance_Approval Preclearance_Approval { get; set; }

        [Required]
        [DisplayName("rl_lbl_50371")]
        public Configuration_YesNo Preclearance_AllowZeroBalance { get; set; }

        [Required]
        [DisplayName("rl_lbl_50372")]
        public Configuration_YesNo Preclearance_FORM_Required_Restricted_company { get; set; }

        public int? FormFDocId { get; set; }

        public List<DocumentDetailsModel> Preclearance_Form_F_NewFile { get; set; }

        public List<DocumentDetailsModel> Preclearance_Form_F_Existing { get; set; }

        [Required]
        [DisplayName("rl_lbl_50380")]
        public RestrictedListSearch_Allow Allow_Restricted_List_Search { get; set; }

        [Required]
        [DisplayName("rl_lbl_50386")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "rl_msg_50385")]
        [Range(1, 99, ErrorMessage = "rl_msg_50627")]
        public int? RLSearchLimit { get; set; }
    }

    public enum Configuration_YesNo
    {
        Config_Yes = ConstEnum.Code.CompanyConfig_YesNoSettings_Yes,
        Config_No = ConstEnum.Code.CompanyConfig_YesNoSettings_No
    }

    public enum PreClearance_Approval
    {
        Auto = ConstEnum.Code.RestrictedList_PreclearanceApproval_Auto,
        Manual = ConstEnum.Code.RestrictedList_PreclearanceApproval_Manual
    }

    public enum RestrictedListSearch_Allow
    {
        Perpetual = ConstEnum.Code.RestrictedList_Search_Perpetual,
        Limited = ConstEnum.Code.RestrictedList_Search_Limited
    }
}