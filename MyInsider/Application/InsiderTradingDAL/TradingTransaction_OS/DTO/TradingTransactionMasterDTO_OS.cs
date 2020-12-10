using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("tra_TransactionMaster_OS")]
    public class TradingTransactionMasterDTO_OS
    {
        [PetaPoco.Column("TransactionMasterId")]
        public Int64? TransactionMasterId { get; set; }

        [PetaPoco.Column("PreclearanceRequestId")]
        public Int64? PreclearanceRequestId { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int? UserInfoId { get; set; }

        [PetaPoco.Column("DisclosureTypeCodeId")]
        public int? DisclosureTypeCodeId { get; set; }

        [PetaPoco.Column("TransactionStatusCodeId")]
        public int? TransactionStatusCodeId { get; set; }

        [PetaPoco.Column("NoHoldingFlag")]
        public bool? NoHoldingFlag { get; set; }

        [PetaPoco.Column("TradingPolicyId")]
        public int? TradingPolicyId { get; set; }

        [PetaPoco.Column("PeriodEndDate")]
        public DateTime? PeriodEndDate { get; set; }

        [PetaPoco.Column("PartiallyTradedFlag")]
        public bool? PartiallyTradedFlag { get; set; }

        [PetaPoco.Column("SoftCopyReq")]
        public bool? SoftCopyReq { get; set; }

        [PetaPoco.Column("HardCopyReq")]
        public bool? HardCopyReq { get; set; }

        //[PetaPoco.Column("SecurityTypeCodeId")]
        //public int? SecurityTypeCodeId { get; set; }

        //[PetaPoco.Column("HardCopyByCOSubmissionDate")]
        //public DateTime? HardCopyByCOSubmissionDate { get; set; }

        //New column added on 2-Jun-2016(YES BANK customization)        
        [PetaPoco.Column("SeekDeclarationFromEmpRegPossessionOfUPSIFlag")]
        public bool SeekDeclarationFromEmpRegPossessionOfUPSIFlag { get; set; }

        [PetaPoco.Column("CDDuringPE")]
        public bool CDDuringPE { get; set; }

        [PetaPoco.Column("InsiderIDFlag")]
        public bool InsiderIDFlag { get; set; }

        public string PAN { get; set; }
        public string DateOfAcquisition { get; set; }
        public string DateOfIntimation { get; set; }
        [PetaPoco.Column("DeclarationFromInsiderAtTheTimeOfContinuousDisclosures")]
        public string DeclarationFromInsiderAtTheTimeOfContinuousDisclosures { get; set; }

        [PetaPoco.Column("DeclarationToBeMandatoryFlag")]
        public bool DeclarationToBeMandatoryFlag { get; set; }

        //[PetaPoco.Column("DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag")]
        //public bool DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag { get; set; }
        ////End column added on 2-Jun-2016

        //[PetaPoco.Column("ConfirmCompanyHoldingsFor")]
        //public int? ConfirmCompanyHoldingsFor { get; set; }

        //[PetaPoco.Column("ConfirmNonCompanyHoldingsFor")]
        //public int? ConfirmNonCompanyHoldingsFor { get; set; }

    }

    public class TradingTransactionSummaryDTO_OS
    {
        [PetaPoco.Column("ApprovedQuantity")]
        public double ApprovedQuantity { get; set; }

        [PetaPoco.Column("TradedQuantity")]
        public double TradedQuantity { get; set; }

        [PetaPoco.Column("PendingQuantity")]
        public double PendingQuantity { get; set; }
    }

    //public class ContinuousDisclosureStatusDTO
    //{
    //    public int ContDisPendingStatus { get; set; }
    //    public int PEDisPendingStatus { get; set; }
    //}

    public class DuplicateTransactionDetailsDTO_OS
    {
        public int TransactionStatus { get; set; }

        public int TransactionType { get; set; }

        public int SecurityType { get; set; }

        public DateTime DateOfAcquisition { get; set; }

        public double Quantity { get; set; }

        public double Value { get; set; }

        public string DMATAccountNo { get; set; }

        public string DPID { get; set; }

        public string DPName { get; set; }

        public string TMID { get; set; }

        public int TransactionID { get; set; }

        public int ModeOfAcquisition { get; set; }

        public int ExchangeCode { get; set; }

        public string Relation { get; set; }

        public int UserInfoID { get; set; }
        public int DMATDetailsID { get; set; }
        public string UserType { get; set; }
        public string UserName { get; set; }
    }
}