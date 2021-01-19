
using InsiderTrading.Common;
using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace InsiderTrading.Models
{
    public class TemplateMasterModel
    {

        public int TemplateMasterId { get; set; }

        [Required]
        [System.Web.Mvc.AllowHtml]
        [DisplayName("tra_lbl_16154")]
        // [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "tra_msg_50531")]
        public string TemplateName { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50527")]
        [DisplayName("tra_lbl_16155")]
        public int CommunicationModeCodeId { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50528")]
        [DisplayName("tra_lbl_16157")]
        public int? DisclosureTypeCodeId { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "usr_msg_50529")]
        [DisplayName("tra_lbl_16158")]
        public int? LetterForCodeId { get; set; }

        [Required]
        [DisplayName("tra_lbl_16156")]
        public bool IsActive { get; set; }
        [Required]
        [DisplayName("tra_lbl_16159")]
        public DateTime? Date { get; set; }

        [Required]
        [StringLength(500, ErrorMessage = "tra_lbl_16160")]
        [DisplayName("tra_lbl_16160")]
        //  [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "tra_msg_50531")]
        public string ToAddress1 { get; set; }

        //[Required]
        [StringLength(500, ErrorMessage = "tra_lbl_16161")]
        [DisplayName("tra_lbl_16161")]
        //[RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "tra_msg_50531")]
        public string ToAddress2 { get; set; }

        [Required]
        [System.Web.Mvc.AllowHtml]
        [StringLength(300, ErrorMessage = "tra_lbl_16162")]
        [DisplayName("tra_lbl_16162")]
        //[RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "tra_msg_50531")]
        public string Subject { get; set; }

        [Required]
        [System.Web.Mvc.AllowHtml]
        //[StringLength(4000, ErrorMessage = "tra_lbl_16163")]
        [DisplayName("tra_lbl_16163")]
        //[RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "rpt_msg_50521")]
        //[RegularExpression(ConstEnum.DataValidation.LetterContent, ErrorMessage = "tra_msg_50531")]
        public string Contents { get; set; }

        [Required]
        [System.Web.Mvc.AllowHtml]
       // [StringLength(400, ErrorMessage = "tra_lbl_16164")]
        [DisplayName("tra_lbl_16164")]
        //[RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "tra_msg_50531")]
        public string Signature { get; set; }

        [Required]
        [RegularExpression("^[^()<>]+$", ErrorMessage = "rpt_msg_50521")]
        [DisplayName("tra_lbl_16165")]
        public string CommunicationFrom { get; set; }

        [Required]
        [RegularExpressionWithOptions(@"^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "usr_msg_11341", RegexOptions = RegexOptions.IgnoreCase)]
        [DisplayName("tra_lbl_16165")]
        public string CommunicationFromEmail { get; set; }

        [Required]
        [StringLength(50, ErrorMessage = "tra_lbl_16171")]
        [RegularExpression(@"^\d+(\.\d+)*$", ErrorMessage = "usr_msg_50533")]
        [DisplayName("tra_lbl_16171")]
        public string SequenceNo { get; set; }

        //NOTE - In case communication type as "Letter" this field is used to stored if "ToAddress2" field is required or not
        // and in case of communication type as "Email", "SMS", "Text Alert", "Popup Alert" - this field is set to "True" in DB procedure by default
        public bool IsCommunicationTemplate { get; set; }
    }
}
