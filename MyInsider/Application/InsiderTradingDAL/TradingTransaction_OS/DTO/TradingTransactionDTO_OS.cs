
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("tra_TransactionDetails_OS")]
    public class TradingTransactionDTO_OS
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

        [PetaPoco.Column("DateOfAcquisition")]
        public DateTime? DateOfAcquisition { get; set; }

        [PetaPoco.Column("DateOfInitimationToCompany")]
        public DateTime? DateOfInitimationToCompany { get; set; }

        [PetaPoco.Column("ModeOfAcquisitionCodeId")]
        public int ModeOfAcquisitionCodeId { get; set; }
        
        [PetaPoco.Column("ExchangeCodeId")]
        public int ExchangeCodeId { get; set; }

        [PetaPoco.Column("TransactionTypeCodeId")]
        public int TransactionTypeCodeId { get; set; }


        [PetaPoco.Column("LotSize")]
        public int? LotSize { get; set; }

        [PetaPoco.Column("Quantity")]
        public Decimal? Quantity { get; set; }

        [PetaPoco.Column("Value")]
        public Decimal? Value { get; set; }

        [PetaPoco.Column("ContractSpecification")]
        public string ContractSpecification { get; set; }

        public int? LoggedInUserId { get; set; }

        public string CompanyName { get; set; }

        public string PAN { get; set; }

        [PetaPoco.Column("OtherExcerciseOptionQty")]
        public Decimal? OtherExcerciseOptionQty { get; set; }
        public int? UserTypeCodeId { get; set; }
    }
   
    public class ApprovedPCLDTO_OS
    {
        public int ApprovedPCLCnt { get; set; }
    }   
}
