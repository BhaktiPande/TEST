
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading.Models
{
    public class DMATDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATDetailsID { get; set; }

        public int? UserInfoID { get; set; }

        [StringLength(500)]
        [DisplayName("usr_lbl_50057")]
        public string DepositoryName { get; set; }

        [StringLength(500)]
        [Required]
        [ResourceKey("DEMATAccountNumber")]
        [ActivityResourceKey("usr_lbl_11205")]
        [DisplayName("usr_lbl_11205")]
        [RegularExpression(@"^[0-9]{16}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50064")]
        public string DEMATAccountNumber { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        [RegularExpression(@"^[0-9]{8}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50065")]
        public string DEMATAccountNumberNSDL { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50522")]
        public string DEMATAccountNumberOthers { get; set; }

        [Required]
        [ResourceKey("DPBank")]
        [DisplayName("usr_lbl_11206")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50068")]
        public string DPBank { get; set; }

        [Required(ErrorMessage = "usr_msg_50073")]
        [ResourceKey("DPBank")]
        [ActivityResourceKey("usr_lbl_11284")]
        [DisplayName("usr_lbl_11284")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50523")]
        public string DPBankName { get; set; }

        [StringLength(50)]
        [Required]
        [ResourceKey("DPID")]
        [ActivityResourceKey("usr_lbl_11207")]
        [DisplayName("usr_lbl_11207")]
        [RegularExpression(@"^[I][N][0-9]{6}?$", ErrorMessage = "usr_msg_50066")]
        public string DPID { get; set; }

        [StringLength(50)]
        [ResourceKey("DPID")]
        [ActivityResourceKey("usr_lbl_11207")]
        [DisplayName("usr_lbl_11207")]
        public string DPIDCDSL { get; set; }

        [StringLength(50)]
        [ResourceKey("TMID")]
        [ActivityResourceKey("usr_lbl_11208")]
        [DisplayName("usr_lbl_50384")]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50522")]
        public string TMID { get; set; }

        [StringLength(400)]
        [ActivityResourceKey("usr_lbl_11209")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50524")]
        public string Description { get; set; }

        [Required]
        [DisplayName("usr_lbl_11254")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50063")]
        public int AccountTypeCodeId { get; set; }

        [Required]
        [DisplayName("usr_lbl_50751")]
        public int DmatAccStatusCodeId { get; set; }
    }

    public class Corporate_DMATDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATDetailsID { get; set; }

        public int? UserInfoID { get; set; }

        [StringLength(500)]
        [DisplayName("usr_lbl_50057")]
        public string DepositoryName { get; set; }

        [StringLength(500)]
        [Required]
        [DisplayName("usr_lbl_11306")]
        [ResourceKey("DMAT account Number (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11306")]
        [RegularExpression(@"^[0-9]{16}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50064")]
        public string DEMATAccountNumber { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        [RegularExpression(@"^[0-9]{8}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50065")]
        public string DEMATAccountNumberNSDL { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        public string DEMATAccountNumberOthers { get; set; }

        [Required]
        [DisplayName("usr_lbl_11307")]
        [ResourceKey("DP Name (Corporate User)")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50068")]
        public string DPBank { get; set; }

        [Required(ErrorMessage = "usr_msg_50073")]
        [DisplayName("usr_lbl_11312")]
        [ResourceKey("DP Name (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11307")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50523")]
        public string DPBankName { get; set; }

        [StringLength(50)]
        [Required]
        [DisplayName("usr_lbl_11308")]
        [ResourceKey("DPID (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11308")]
        [RegularExpression(@"^[I][N][0-9]{6}?$", ErrorMessage = "usr_msg_50066")]
        public string DPID { get; set; }

        [Required(ErrorMessage = "usr_lbl_11308")]
        [StringLength(50)]
        [ResourceKey("DPID (Corporate User)")]
        [ActivityResourceKey("usr_lbl_11207")]
        [DisplayName("usr_lbl_11207")]
        public string DPIDCDSL { get; set; }

        [StringLength(50)]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50522")]
        [ResourceKey("TMID (Corporate User)")]
        [ActivityResourceKey("usr_lbl_52092")]
        [DisplayName("usr_lbl_52092")]
        public string TMID { get; set; }

        [StringLength(400)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50524")]
        [ResourceKey("DMAT Description (Corporate User)")]
        [ActivityResourceKey("usr_lbl_52093")]
        [DisplayName("usr_lbl_52093")]
        public string Description { get; set; }

        [Required]
        [DisplayName("usr_lbl_11311")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50063")]
        public int AccountTypeCodeId { get; set; }
    }

    public class Relative_DMATDetailsModel
    {
        [DefaultValue(0)]
        public int? DMATDetailsID { get; set; }

        public int? UserInfoID { get; set; }

        [StringLength(500)]
        [DisplayName("usr_lbl_50057")]
        public string DepositoryName { get; set; }

        [StringLength(500)]
        [Required]
        [ResourceKey("DMATAccountNumber")]
        [ActivityResourceKey("usr_lbl_11368")]
        [DisplayName("usr_lbl_11368")]
        [RegularExpression(@"^[0-9]{16}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50064")]
        public string DEMATAccountNumber { get; set; }



        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        [RegularExpression(@"^[0-9]{8}([.][0-9]{0,9})?$", ErrorMessage = "usr_msg_50065")]
        public string DEMATAccountNumberNSDL { get; set; }

        [Required]
        [StringLength(500)]
        [DisplayName("usr_lbl_11306")]
        public string DEMATAccountNumberOthers { get; set; }

        [Required]
        [DisplayName("usr_lbl_11369")]
        [ResourceKey("DPBank")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50068")]
        public string DPBank { get; set; }

        [Required(ErrorMessage = "usr_msg_50073")]
        [ResourceKey("DPBank")]
        [ActivityResourceKey("usr_lbl_11370")]
        [DisplayName("usr_lbl_11370")]
        [RegularExpression(ConstEnum.DataValidation.CharactersWithSpace, ErrorMessage = "usr_msg_50523")]
        public string DPBankName { get; set; }

        [StringLength(50)]
        [Required]
        [ResourceKey("DPID")]
        [ActivityResourceKey("usr_lbl_11371")]
        [DisplayName("usr_lbl_11371")]
        [RegularExpression(@"^[I][N][0-9]{6}?$", ErrorMessage = "usr_msg_50066")]
        public string DPID { get; set; }

        [StringLength(50)]
        [ResourceKey("DPID")]
        [DisplayName("usr_lbl_11207")]
        public string DPIDCDSL { get; set; }

        [StringLength(50)]
        [RegularExpression(ConstEnum.DataValidation.Alphanumeric, ErrorMessage = "usr_msg_50522")]
        [ResourceKey("TMID")]
        [ActivityResourceKey("usr_lbl_11208")]
        [DisplayName("usr_lbl_52090")]
        public string TMID { get; set; }

        [StringLength(400)]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "usr_msg_50524")]
        [DisplayName("usr_lbl_52091")]
        public string Description { get; set; }

        [Required]
        [DisplayName("usr_lbl_11374")]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50063")]
        public int AccountTypeCodeId { get; set; }

        [Required]
        [DisplayName("usr_lbl_50751")]
        public int DmatAccStatusCodeId { get; set; }
    }
}
