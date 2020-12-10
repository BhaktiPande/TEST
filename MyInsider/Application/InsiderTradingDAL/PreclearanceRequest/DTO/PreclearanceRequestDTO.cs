using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PreclearanceRequestDTO
    {
        [PetaPoco.Column("PreclearanceRequestId")]
        public long PreclearanceRequestId { get; set; }

        [PetaPoco.Column("PreclearanceRequestForCodeId")]
        public int? PreclearanceRequestForCodeId { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int? UserInfoId { get; set; }

        [PetaPoco.Column("UserInfoIdRelative")]
        public int? UserInfoIdRelative { get; set; }

        [PetaPoco.Column("TransactionTypeCodeId")]
        public int? TransactionTypeCodeId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int? SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("SecuritiesToBeTradedQty")]
        public decimal? SecuritiesToBeTradedQty { get; set; }

        [PetaPoco.Column("SecuritiesToBeTradedValue")]
        public decimal? SecuritiesToBeTradedValue { get; set; }

        [PetaPoco.Column("PreclearanceStatusCodeId")]
        public int? PreclearanceStatusCodeId { get; set; }

        [PetaPoco.Column("CompanyId")]
        public int? CompanyId { get; set; }

        [PetaPoco.Column("ProposedTradeRateRangeFrom")]
        public decimal? ProposedTradeRateRangeFrom { get; set; }

        [PetaPoco.Column("ProposedTradeRateRangeTo")]
        public decimal? ProposedTradeRateRangeTo { get; set; }

        [PetaPoco.Column("DMATDetailsID")]
        public int? DMATDetailsID { get; set; }

        [PetaPoco.Column("ReasonForNotTradingCodeId")]
        public int? ReasonForNotTradingCodeId { get; set; }

        [PetaPoco.Column("ReasonForNotTradingText")]
        public string ReasonForNotTradingText { get; set; }

        [PetaPoco.Column("CreatedBy")]
        public int? CreatedBy { get; set; }

        [PetaPoco.Column("CreatedOn")]
        public DateTime? PreClearanceRequestedDate { get; set; }

        public bool PreclearanceNotTakenFlag { get; set; }

        public long TransactionMasterId { get; set; }

        public int LoggedInUserId { get; set; }

        [PetaPoco.Column("TradingPolicyId")]
        public int TradingPolicyId { get; set; }

        [PetaPoco.Column("EmployeeId")]
        public string EmployeeId { get; set; }

        [PetaPoco.Column("UserName")]
        public string UserName { get; set; }

        [PetaPoco.Column("SecurityTypeText")]
        public string SecurityTypeText { get; set; }

        [PetaPoco.Column("TransactionTypeText")]
        public string TransactionTypeText { get; set; }

        [PetaPoco.Column("ReasonForRejection")]
        public string ReasonForRejection { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("PreClearanceFor")]
        public string PreClearanceFor { get; set; }

        [PetaPoco.Column("RelativeName")]
        public string RelativeName { get; set; }

        [PetaPoco.Column("ReasonForNotTradingCodeText")]
        public string ReasonForNotTradingCodeText { get; set; }

        [PetaPoco.Column("PreclearanceStatusName")]
        public string PreclearanceStatusName { get; set; }

        [PetaPoco.Column("EventDate")]
        public DateTime? EventDate { get; set; }

        [PetaPoco.Column("ContraTradePeriod")]
        public int? ContraTradePeriod { get; set; }

        [PetaPoco.Column("ESOPExcerciseOptionQtyFlag")]
        public bool ESOPExcerciseOptionQtyFlag { get; set; }

        [PetaPoco.Column("OtherESOPExcerciseOptionQtyFlag")]
        public bool OtherESOPExcerciseOptionQtyFlag { get; set; }

        [PetaPoco.Column("ESOPExcerciseOptionQty")]
        public decimal ESOPExcerciseOptionQty { get; set; }

        [PetaPoco.Column("OtherExcerciseOptionQty")]
        public decimal OtherExcerciseOptionQty { get; set; }

        [PetaPoco.Column("QtyRemainForTrade")]
        public decimal QtyRemainForTrade { get; set; }

        [PetaPoco.Column("ModeOfAcquisitionCodeId")]
        public int ModeOfAcquisitionCodeId { get; set; }

        public string PreClrUPSIDeclaration { get; set; }
        [PetaPoco.Column("ReasonForApprovalCodeId")]
        public int? ReasonForApprovalCodeId { get; set; }

        [PetaPoco.Column("ReasonForApproval")]
        public string ReasonForApproval { get; set; }

        public string ReasonForApprovalText { get; set; }
        public bool PreClrApprovalReasonReqFlag { get; set; }

        public DateTime? PreclearanceValidityDate { get; set; }

        public decimal? SecuritiesApproved { get; set; }

        public DateTime? PreclearanceValidityDateChanged { get; set; }

        public string PreclearanceTakenQtyOld { get; set; }
   
        public DateTime? DisplayPreclearanceValidityDate { get; set; }

        public DateTime? DisplayPreclearanceValidityDateChanged { get; set; }     
    }

    public class ExerciseBalancePoolDTO
    {
        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("SecurityTypeCodeId")]
        public int SecurityTypeCodeId { get; set; }

        [PetaPoco.Column("ESOPQuantity")]
        public decimal ESOPQuantity { get; set; }

        [PetaPoco.Column("OtherQuantity")]
        public decimal OtherQuantity { get; set; }
    }

    public class FormEDetailsDTO
    {
        [PetaPoco.Column("GeneratedFormDetailsId")]
        public long GeneratedFormDetailsId { get; set; }

        [PetaPoco.Column("TemplateMasterId")]
        public int TemplateMasterId { get; set; }

        [PetaPoco.Column("MapToTypeCodeId")]
        public int MapToTypeCodeId { get; set; }

        [PetaPoco.Column("MapToId")]
        public int MapToId { get; set; }

        [PetaPoco.Column("GeneratedFormContents")]
        public string GeneratedFormContents { get; set; }
     
    }

    public class GetPendingEmployees
    {
        public int TransactionMasterID { get; set; }
        public int UserInfoId { get; set; }
        public int RowNum { get; set; }
        public string Name { get; set; }
    }
}
