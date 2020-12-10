using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PreclearanceRequestNonImplCompanyDTO
    {
        [PetaPoco.Column("PreclearanceRequestId")]
        public Int64 PreclearanceRequestId { get; set; }

        [PetaPoco.Column("RlSearchAuditId")]
        public int RlSearchAuditId { get; set; }

        [PetaPoco.Column("DisplaySequenceNo")]
        public Int64 DisplaySequenceNo { get; set; }

        [PetaPoco.Column("PreclearanceRequestForCodeId")]
        public int PreclearanceRequestForCodeId { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("UserInfoIdRelative")]
        public int? UserInfoIdRelative { get; set; }

        [PetaPoco.Column("TransactionTypeCodeId")]
        public int TransactionTypeCodeId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("SecuritiesToBeTradedQty")]
        public decimal SecuritiesToBeTradedQty { get; set; }

        [PetaPoco.Column("SecuritiesToBeTradedValue")]
        public decimal SecuritiesToBeTradedValue { get; set; }

        [PetaPoco.Column("PreclearanceStatusCodeId")]
        public int PreclearanceStatusCodeId { get; set; }

        [PetaPoco.Column("PreclearanceStatusText")]
        public string PreclearanceStatusText { get; set; }

        [PetaPoco.Column("CompanyId")]
        public int CompanyId { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("DMATDetailsID")]
        public int DMATDetailsID { get; set; }

        [PetaPoco.Column("ModeOfAcquisitionCodeId")]
        public int ModeOfAcquisitionCodeId { get; set; }

        [PetaPoco.Column("ReasonForRejection")]
        public string ReasonForRejection { get; set; }

        [PetaPoco.Column("PreclearanceCreatedOn")]
        public DateTime PreclearanceDate { get; set; }

        [PetaPoco.Column("PreclearanceCreatedBy")]
        public int PreclearanceBy { get; set; }

        [PetaPoco.Column("ApproveOrRejectedBy")]
        public int? ApprovedBy { get; set; }

        [PetaPoco.Column("ApprovedByName")]
        public string ApprovedByName { get; set; }

        [PetaPoco.Column("ApproveOrRejectOn")] //event date on which approve/reject date
        public DateTime? ApproveOrRejectOn { get; set; }

        [PetaPoco.Column("ReasonForNotTradingCodeText")]
        public string ReasonForNotTradingCodeText { get; set; }

        [PetaPoco.Column("ReasonForNotTradingText")]
        public string ReasonForNotTradingText { get; set; }

        [PetaPoco.Column("ReasonForApproval")]
        public string ReasonForApproval { get; set; }

        [PetaPoco.Column("ReasonForApprovalCodeId")]
        public string ReasonForApprovalCodeId { get; set; }
    }

    public class BalancePoolOSDTO
    {
        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("CompanyID")]
        public decimal CompanyID { get; set; }

        [PetaPoco.Column("VirtualQuantity")]
        public decimal VirtualQuantity { get; set; }

        [PetaPoco.Column("ActualQuantity")]
        public decimal ActualQuantity { get; set; }

        [PetaPoco.Column("PledgeQuantity")]
        public decimal PledgeQuantity { get; set; }
    }
}
