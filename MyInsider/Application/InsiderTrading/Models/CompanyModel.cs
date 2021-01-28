
using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace InsiderTrading.Models
{
    public class CompanyModel
    {

        public int CompanyId { get; set; }


        [Required]
        [StringLength(100)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13060")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "cmp_msg_50501")]
        public string CompanyName { get; set; }


        [Required]
        [StringLength(200)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13061")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "cmp_msg_50501")]
        public string Address { get; set; }

        [Required]
        [StringLength(1024)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13062")]
        [RegularExpression(ConstEnum.DataValidation.Website, ErrorMessage = "cmp_msg_13097")]
        //[RegularExpressionWithOptions(@"^(?:(www|WWW)[.][A-Za-z0-9-]{1,200}([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "cmp_msg_13097", RegexOptions = RegexOptions.IgnoreCase)]
        public string Website { get; set; }

        [Required]
        // [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
        //                                       @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
        //                                           @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "cmp_msg_13064")]
        // [RegularExpression("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(?i)(.com|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO|.in|.IN)$", ErrorMessage = "cmp_msg_13064")]
        [RegularExpressionWithOptions(@"^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "cmp_msg_13064", RegexOptions = RegexOptions.IgnoreCase)]
        //  [IgnorecaseRegularExpression(@"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)[.](ac|academy|accountants|ag|agency|airforce|am|as|army|asia|at|az|bargains|be|best|bike|biz|blue|bz|build|builders|business|buzz|boutique|cab|camera|careers|cc|cd|ch|cheap|click|club|cn|clothing|cool|coat|cogg|coil|coin|coje|conz|cotm|cott|couk|covi|coza|codes|coffee|company|computer|construction|contractors|com|comag|comaz|comcn|comes|comfr|comgr|comhr|comph|comro|comtw|comvn|cooking|country|cruises|de|dental|diamonds|diet|digital|directory|dk|domains|engineering|enterprises|email|equipment|es|estate|eu|exchange|farm|fi|fishing|flights|florist|fo|fr|gallery|gent|gg|gift|graphics|gs|guitars|guru|healthcare|help|hk|holdings|holiday|hosting|house|info|international|it|immo|io|je|jp|kg|kitchen|kiwi|koeln|land|li|lighting|limo|link|london|management|marketing|me|menu|mobi|ms|name|navy|net|netag|netcn|netnz|netpl|netru|network|ninja|nl|no|nu|ooo|org|orguk|ph|photo|photos|photography|pink|pizza|pl|plumbing|property|pt|recipes|red|rentals|restaurant|ro|rodeo|ru|se|sh|shoes|singles|solar|support|systems|tc|tattoo|tel|technology|tips|tm|to|today|top|tt|training|tv|us|vacations|ventures|vc|villas|vg|vodka|voyage|vu|ws|watch|wiki|zone)$", ErrorMessage = "cmp_msg_13064")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        [DisplayName("cmp_lbl_13063")]
        [StringLength(500)]
        public string EmailId { get; set; }

        public bool IsImplementing { get; set; }

        [Required]
        [StringLength(30)]
        [DisplayName("cmp_lbl_13105")]
        [RegularExpression(ConstEnum.DataValidation.ISINNumber, ErrorMessage = "cmp_msg_50517")]
        public string ISINNumber { get; set; }

        [Required]
        [StringLength(30)]
        [DisplayName("dis_lbl_50612")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string SmtpServer { get; set; }

        [Required]
        [StringLength(30)]
        [DisplayName("dis_lbl_50613")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string SmtpPortNumber { get; set; }

        [Required]
        [StringLength(30)]
        [DisplayName("dis_lbl_50614")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string SmtpUserName { get; set; }

        [Required]
        [Display(Name = "dis_lbl_50615")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string SmtpPassword { get; set; }

    }

    public class NonImplementingCompanyModel
    {
        public int CompanyId { get; set; }


        [Required]
        [StringLength(100)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13060")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "cmp_msg_50501")]
        public string CompanyName { get; set; }


        [Required]
        [StringLength(200)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13061")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "cmp_msg_50501")]
        public string Address { get; set; }

        [Required]
        [StringLength(1024)]
        [DataType(DataType.Text)]
        [DisplayName("cmp_lbl_13062")]
        [RegularExpressionWithOptions(@"^(?:(www|WWW)[.][A-Za-z0-9-]{1,200}([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "cmp_msg_13097", RegexOptions = RegexOptions.IgnoreCase)]
        public string Website { get; set; }

        [Required]
        [RegularExpressionWithOptions(@"^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "cmp_msg_13064", RegexOptions = RegexOptions.IgnoreCase)]
        [DataType(DataType.EmailAddress)]
        [DisplayName("cmp_lbl_13063")]
        [StringLength(500)]
        public string EmailId { get; set; }

        public bool IsImplementing { get; set; }
    }

    public class CompanyFaceValueModel
    {
        [DefaultValue(0)]
        public int? CompanyFaceValueID { get; set; }

        public int CompanyID { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13065")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "Current", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13098")]
        public DateTime? FaceValueDate { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13066")]
        [Range(0, 999999.99, ErrorMessage = "cmp_msg_13106")]//Enter face value max 6 digit number")]
        public decimal FaceValue { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "cmp_msg_13068")]
        [DisplayName("cmp_lbl_13067")]
        public int? CurrencyID { get; set; }

        private DateTime _joined = DateTime.Now;

        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "FaceValueDate", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13098")]
        public DateTime Current
        {
            get
            {
                return _joined;
            }
            set
            {
                _joined = value;
            }
        }

    }

    public class CompanyAuthorizedShareCapitalModel
    {
        [DefaultValue(0)]
        public int? CompanyAuthorizedShareCapitalID { get; set; }

        public int CompanyID { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13065")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "Current", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13099")]
        public DateTime? AuthorizedShareCapitalDate { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13070")]
        [Range(1, 999999999999999, ErrorMessage = "cmp_msg_13101")]
        public decimal AuthorizedShares { get; set; }

        private DateTime _joined = DateTime.Now;
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "AuthorizedShareCapitalDate", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13099")]
        public DateTime Current
        {
            get
            {
                return _joined;
            }
            set
            {
                _joined = value;
            }
        }

    }

    public class CompanyPaidUpAndSubscribedShareCapitalModel
    {

        [DefaultValue(0)]
        public int? CompanyPaidUpAndSubscribedShareCapitalID { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13065")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "Current", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "% Paid Up And Subscribed Share Capital Date must be less than or equal current date.")]
        public DateTime? PaidUpAndSubscribedShareCapitalDate { get; set; }

        [Required]
        [Range(1, 999999999999999, ErrorMessage = "cmp_msg_13100")]
        [DisplayName("cmp_lbl_13070")]
        public decimal PaidUpShare { get; set; }

        public int CompanyID { get; set; }

        private DateTime _joined = DateTime.Now;
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "Current", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "% Paid Up And Subscribed Share Capital Date must be less than or equal current date.")]

        public DateTime Current
        {
            get
            {
                return _joined;
            }
            set
            {
                _joined = value;
            }
        }

    }

    public class CompanyListingDetailsModel
    {
        [DefaultValue(0)]
        public int? CompanyListingDetailsID { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "cmp_msg_13072")]
        [DisplayName("cmp_lbl_13071")]
        public int? StockExchangeID { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13073")]
        [DataType(DataType.DateTime)]
        //  [DateCompare(CompareToPropertyName = "DateOfListingTo", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13095")]
        [DateCompare(CompareToPropertyName = "Current", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13103")]
        public DateTime? DateOfListingFrom { get; set; }

        [DisplayName("cmp_lbl_13074")]
        [DataType(DataType.DateTime)]
        //  [DateCompare(CompareToPropertyName = "DateOfListingFrom", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13094")]
        [DateCompare(CompareToPropertyName = "Current1", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13104")]
        public DateTime? DateOfListingTo { get; set; }

        public int CompanyID { get; set; }

        private DateTime _joined = DateTime.Now.Date;


        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "DateOfListingFrom", OperatorName = DateCompareOperator.GreaterThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13103")]
        public DateTime Current
        {
            get
            {
                return _joined;
            }
            set
            {
                _joined = value;
            }
        }

        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "DateOfListingTo", OperatorName = DateCompareOperator.LessThanOrEqual, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13104")]
        public DateTime Current1
        {
            get
            {
                return _joined;
            }
            set
            {
                _joined = value;
            }
        }

    }

    public class CompanyComplianceOfficerModel
    {
        [DefaultValue(0)]
        public int? CompanyComplianceOfficerId { get; set; }

        public int CompanyId { get; set; }

        [StringLength(200)]
        [Required]
        [DisplayName("cmp_lbl_13075")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "cmp_msg_50501")]
        public string ComplianceOfficerName { get; set; }

        [DisplayName("cmp_lbl_13076")]
        public int? DesignationId { get; set; }

        [StringLength(510)]
        [DisplayName("cmp_lbl_13061")]
        [RegularExpression(ConstEnum.DataValidation.DescriptionType, ErrorMessage = "cmp_msg_50501")]
        public string Address { get; set; }

        [StringLength(20)]
        [DisplayName("cmp_lbl_13077")]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "cmp_msg_13083")]
        public string PhoneNumber { get; set; }

        [StringLength(510)]
        [DisplayName("cmp_lbl_13063")]
        [RegularExpressionWithOptions(@"^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$", ErrorMessage = "cmp_msg_13064", RegexOptions = RegexOptions.IgnoreCase)]
        [DataType(DataType.EmailAddress)]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmailId { get; set; }

        [Required]
        [DisplayName("cmp_lbl_13079")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableToDate", OperatorName = DateCompareOperator.LessThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13093")]
        public DateTime? ApplicableFromDate { get; set; }

        [DisplayName("cmp_lbl_13078")]
        [DataType(DataType.DateTime)]
        [DateCompare(CompareToPropertyName = "ApplicableFromDate", OperatorName = DateCompareOperator.GreaterThan, CompareType = DateCompareType.Date, CompareDateFormat = AnnotationDateCompareFormat.DDMMYYYY, ErrorMessage = "cmp_msg_13092")]
        public DateTime? ApplicableToDate { get; set; }

        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "cmp_msg_13081")]
        [DisplayName("cmp_lbl_13080")]
        public int StatusCodeId { get; set; }

    }

    public class CompanyConfigurationModel
    {
        [DisplayName("cmp_lbl_13125")]
        public EnterUploadSettingCode InitialDisclosure { get; set; }

        [DisplayName("cmp_lbl_13126")]
        public EnterUploadSettingCode ContinuousDisclosure { get; set; }

        [DisplayName("cmp_lbl_13127")]
        public EnterUploadSettingCode PeriodEndDisclosure { get; set; }


        [DisplayName("cmp_lbl_13144")]
        public DematAccountSettingCode PreClearanceImplementingCompany { get; set; }
        public List<CommonListCheckbox> AllDematAccountList_PreClearanceImplementingCompany { get; set; }

        [DisplayName("cmp_lbl_13148")]
        public DematAccountSettingCode PreClearanceNonImplementingCompany { get; set; }
        public List<CommonListCheckbox> AllDematAccountList_PreClearanceNonImplementingCompany { get; set; }

        [DisplayName("cmp_lbl_13152")]
        public DematAccountSettingCode InitialDisclosureTransaction { get; set; }
        public List<CommonListCheckbox> AllDematAccountList_InitialDisclosureTransaction { get; set; }

        [DisplayName("cmp_lbl_13156")]
        public DematAccountSettingCode ContinuousDisclosureTransaction { get; set; }
        public List<CommonListCheckbox> AllDematAccountList_ContinuousDisclosureTransaction { get; set; }

        [DisplayName("cmp_lbl_13160")]
        public DematAccountSettingCode PeriodEndDisclosureTransaction { get; set; }
        public List<CommonListCheckbox> AllDematAccountList_PeriodEndDisclosureTransaction { get; set; }

        [DisplayName("cmp_lbl_53098")]
        public EULAAcceptanceSettingCode EULAAcceptanceSettings { get; set; }

        [DisplayName("cmp_lbl_53099")]
        public EULARecomfirmationSettingCode ReqiuredEULAReconfirmation { get; set; }

        public int EULAAcceptance_DocumentId { get; set; }

        [DisplayName("cmp_lbl_55081")]
        public UPSISettingCode UPSISetting { get; set; }


        [DisplayName("cmp_lbl_55084")]
        public string InformationSharedby { get; set; }

        [DisplayName("cmp_lbl_54178")]
        public UPSIEmailUpdateSettingCode TriggerEmailsUPSIUpdated { get; set; }

        [DisplayName("cmp_lbl_54179")]
        public UPSIEmailPublishedSettingCode TriggerEmailsUPSIpublished { get; set; }
        [DisplayName("cmp_lbl_54180")]
        public string MailTO { get; set; }
        public List<PopulateComboDTO> AssignedSetting { get; set; }
        public List<PopulateComboDTO> DefaultSetting { get; set; }
        public List<string> DefaultMailTo { get; set; }
      

        [DisplayName("cmp_lbl_54181")]
        public string MailCC { get; set; }
        public List<PopulateComboDTO> AssignedSettingCC { get; set; }
        public List<PopulateComboDTO> DefaultSettingCC { get; set; }
        public List<string> DefaultMailCC { get; set; }

    }

    public enum EnterUploadSettingCode
    {
        EnterDetails = ConstEnum.Code.EnterUploadSetting_EnterDetails,
        UploadDetails = ConstEnum.Code.EnterUploadSetting_UploadDetails,
        EnterAndUploadDetails = ConstEnum.Code.EnterUploadSetting_EnterAndUploadDetails,
        EnterOrUploadDetails = ConstEnum.Code.EnterUploadSetting_EnterOrDetails,
        EnterAndOrUploadDetails = ConstEnum.Code.EnterUploadSetting_EnterAndOrDetails
    }

    public enum DematAccountSettingCode
    {
        AllDemat = ConstEnum.Code.DematAccountSetting_AllDemat,
        SelectedDemat = ConstEnum.Code.DematAccountSetting_SelectedDemat
    }

    public enum EULAAcceptanceSettingCode
    {
        YesSetting = ConstEnum.Code.CompanyConfig_YesNoSettings_Yes,
        NoSetting = ConstEnum.Code.CompanyConfig_YesNoSettings_No
    }


    public enum UPSISettingCode
    {
        YesSetting = ConstEnum.Code.UPSI_YesNoSettings_Yes,
        NoSetting = ConstEnum.Code.UPSI_YesNoSettings_No
    }
    public enum UPSIEmailUpdateSettingCode
    {
        YesSetting = ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_Yes,
        NoSetting = ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_No
    }
    public enum UPSIEmailPublishedSettingCode
    {
        YesSetting = ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_Yes,
        NoSetting = ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_No
    }
    public enum EULARecomfirmationSettingCode
    {
        All = ConstEnum.Code.CompanyConfig_EULAReconfirmation_All,
        NotAccepted = ConstEnum.Code.CompanyConfig_EULAReconfirmation_NotAccepted
    }

    public class CommonListCheckbox
    {
        public int id { get; set; }

        public bool selected { get; set; }

        public string checkboxText { get; set; }
    }

    public class PersonalDetailsConfirmationModel
    {
        public int? CompanyId { get; set; }

        [DisplayName("cmp_lbl_50733")]
        public int? ReconfirmationFrequencyId { get; set; }
    }

    public class WorkandEducationModel
    {
        public int? CompanyId { get; set; }

        [DisplayName("cmp_ttl_59004")]
        public int? WorkandEducationMandatoryId { get; set; }
    }

}
