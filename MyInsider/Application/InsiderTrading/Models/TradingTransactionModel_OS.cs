
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
    public class TradingTransactionModel_OS
    {

        //public int? TransactionTypeCodeId { get; set; }

        //public int? SecurityTypeCodeId { get; set; }

        public int? DematAccountNumberList { get; set; }

        public int? NumberOfSecurities { get; set; }

        [DefaultValue(0)]
        public int? RLCompanyId { get; set; }

        [StringLength(300)]
        [DataType(DataType.Text)]
        [DisplayName("tra_lbl_52051")]
        public string CompanyName { get; set; }

        public Int64 TransactionDetailsId { get; set; }

        public Int64 TransactionMasterId { get; set; }

        [DisplayName("tra_lbl_52049")]
        public int SecurityTypeCodeId { get; set; }

        [DisplayName("tra_lbl_52048")]
        public int ForUserInfoId { get; set; }

        [DisplayName("tra_lbl_52050")]
        public int DMATDetailsID { get; set; }

        public int CompanyId { get; set; }

        [DisplayName("tra_lbl_16026")]
        [Range(-9999999999.99, 9999999999.99, ErrorMessage = "tra_msg_16136")]
        public Decimal? SecuritiesPriorToAcquisition { get; set; }

        [DisplayName("tra_lbl_16027")]
        [Range(-100.00, 100.00, ErrorMessage = "tra_msg_50519")]// "tra_msg_16137")]
        public double PerOfSharesPreTransaction { get; set; }

        [DisplayName("tra_lbl_52103")]
        public DateTime? DateOfAcquisition { get; set; }

        [DisplayName("tra_lbl_16031")]
        public DateTime? DateOfInitimationToCompany { get; set; }

        [DisplayName("tra_lbl_52104")]
        public int ModeOfAcquisitionCodeId { get; set; }

        [DisplayName("tra_lbl_16033")]
        [Range(-100.00, 100.00, ErrorMessage = "tra_msg_50519")]//"tra_msg_16138")]
        public double PerOfSharesPostTransaction { get; set; }

        [DisplayName("tra_lbl_52105")]
        public int ExchangeCodeId { get; set; }

        [DisplayName("tra_lbl_52106")]
        public int TransactionTypeCodeId { get; set; }

        [DisplayName("tra_lbl_52052")]
        [Range(-9999999999.99, 9999999999.99, ErrorMessage = "tra_msg_16139")]
        public Decimal? Quantity { get; set; }

        [DisplayName("tra_lbl_52107")]
        [Range(0, 9999999999.99, ErrorMessage = "tra_msg_16140")]
        public Decimal? Value { get; set; }

        [DisplayName("tra_lbl_16097")]
        [Range(0, 9999999999.99, ErrorMessage = "tra_msg_16141")]
        public Decimal? Quantity2 { get; set; }

        [DisplayName("tra_lbl_16098")]
        [Range(0, 9999999999.99, ErrorMessage = "tra_msg_16142")]
        public Decimal? Value2 { get; set; }

        public Int64? TransactionLetterId { get; set; }

        [DisplayName("tra_lbl_52053")]
        public int? LotSize { get; set; }

        [DataType(DataType.Date)]
        [DisplayName("tra_lbl_16147")]
        public DateTime? DateOfBecomingInsider { get; set; }

        public List<DocumentDetailsModel> TradingTransactionUpload { get; set; }

        [DisplayName("tra_lbl_16320")]
        public bool SegregateESOPAndOtherExcerciseOptionQtyFalg { get; set; }

        [DisplayName("tra_lbl_16321")]
        public Decimal? ESOPExcerciseOptionQtyModel { get; set; }

        [DisplayName("tra_lbl_16322")]
        public Decimal? OtherExcerciseOptionQtyModel { get; set; }

        [DisplayName("tra_lbl_16323")]
        public bool ESOPExcerseOptionQtyFlag { get; set; }

        [DisplayName("tra_lbl_16324")]
        public bool OtherESOPExcerseOptionFlag { get; set; }

        [StringLength(50, ErrorMessage = "tra_msg_16325")]
        [DisplayName("tra_lbl_52054")]
        [RegularExpression(ConstEnum.DataValidation.AlphanumericWithSpace, ErrorMessage = "tra_msg_50520")]
        public string ContractSpecification { get; set; }

        public bool b_IsInitialDisc { get; set; }

        //New column added on 2-Jun-2016(YES BANK customization)
        [DisplayName("rul_lbl_50070")]
        public bool Chk_DeclarationFromInsiderAtTheTimeOfContinuousDisclosures { get; set; }
        public int UserTypeCodeId { get; set; }
    }
}
