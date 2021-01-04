
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("tra_TransactionDetails")]
    public class TradingTransactionDTO
    {
        [PetaPoco.Column("TransactionDetailsId")]
        public Int64 TransactionDetailsId { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public Int64 TransactionMasterId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("ForUserInfoId")]
        public int ForUserInfoId { get; set; }

        [PetaPoco.Column("DMATDetailsID")]
        public int DMATDetailsID { get; set; }

        [PetaPoco.Column("CompanyId")]
        public int CompanyId { get; set; }

        [PetaPoco.Column("SecuritiesPriorToAcquisition")]
        public Decimal? SecuritiesPriorToAcquisition { get; set; }

        [PetaPoco.Column("PerOfSharesPreTransaction")]
        public double PerOfSharesPreTransaction { get; set; }

        [PetaPoco.Column("DateOfAcquisition")]
        public DateTime? DateOfAcquisition { get; set; }

        [PetaPoco.Column("DateOfInitimationToCompany")]
        public DateTime? DateOfInitimationToCompany { get; set; }

        [PetaPoco.Column("ModeOfAcquisitionCodeId")]
        public int ModeOfAcquisitionCodeId { get; set; }

        [PetaPoco.Column("PerOfSharesPostTransaction")]
        public double PerOfSharesPostTransaction { get; set; }

        [PetaPoco.Column("ExchangeCodeId")]
        public int ExchangeCodeId { get; set; }

        [PetaPoco.Column("TransactionTypeCodeId")]
        public int TransactionTypeCodeId { get; set; }

        [PetaPoco.Column("Quantity")]
        public Decimal? Quantity { get; set; }

        [PetaPoco.Column("Value")]
        public Decimal? Value { get; set; }

        [PetaPoco.Column("Quantity2")]
        public Decimal? Quantity2 { get; set; }

        [PetaPoco.Column("Value2")]
        public Decimal? Value2 { get; set; }

        [PetaPoco.Column("TransactionLetterId")]
        public Int64? TransactionLetterId { get; set; }

        [PetaPoco.Column("LotSize")]
        public int? LotSize { get; set; }

        [PetaPoco.Column("DateOfBecomingInsider")]
        public DateTime? DateOfBecomingInsider { get; set; }

        [PetaPoco.Column("SegregateESOPAndOtherExcerciseOptionQtyFalg")]
        public bool SegregateESOPAndOtherExcerciseOptionQtyFalg { get; set; }

        [PetaPoco.Column("ESOPExcerciseOptionQty")]
        public Decimal? ESOPExcerciseOptionQty { get; set; }

        [PetaPoco.Column("OtherExcerciseOptionQty")]
        public Decimal? OtherExcerciseOptionQty { get; set; }

        [PetaPoco.Column("ESOPExcerseOptionQtyFlag")]
        public bool ESOPExcerseOptionQtyFlag { get; set; }

        [PetaPoco.Column("OtherESOPExcerseOptionFlag")]
        public bool OtherESOPExcerseOptionFlag { get; set; }

        [PetaPoco.Column("ContractSpecification")]
        public string ContractSpecification { get; set; }
    }

    public class ApprovedPCLDTO
    {
        public int ApprovedPCLCnt { get; set; }
    }

    public class DataItemForDemat
    {
        public string tra_grd_16190 { get; set; }
        public string tra_grd_16191 { get; set; }
        public string tra_grd_16192 { get; set; }
        public string tra_grd_16193 { get; set; }
        public string tra_grd_16194 { get; set; }
        public string tra_grd_16195 { get; set; }
        public string tra_grd_16196 { get; set; }
        public string tra_grd_16197 { get; set; }
        public string tra_grd_16198 { get; set; }
        public string tra_grd_16199 { get; set; }
        public string tra_grd_16200 { get; set; }
        public string dmatId { get; set; }
        public string UserInfoId { get; set; }
        public int rpt_grd_54229 { get; set; }
    }

    public class DataItemForRelative
    {
        public string tra_grd_50741 { get; set; }
        public string tra_grd_50742 { get; set; }
        public string tra_grd_50743 { get; set; }
        public string tra_grd_50744 { get; set; }
        public string tra_grd_50745 { get; set; }
        public string tra_grd_50746 { get; set; }
        public string tra_grd_50747 { get; set; }
        public string tra_grd_50748 { get; set; }
        public string tra_grd_50749 { get; set; }
        public string tra_grd_50750 { get; set; }
        public string tra_grd_50783 { get; set; }
        public string tra_grd_50784 { get; set; }
        public string relDmatId { get; set; }
        public string RelUserInfoId { get; set; }
        public int rpt_grd_54229 { get; set; }
    }


}
