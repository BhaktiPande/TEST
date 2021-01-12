using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL.InsiderInitialDisclosure.DTO
{
    public class InsiderInitialDisclosureDTO
    {
        [PetaPoco.Column("SequenceNumber")]
        public int SequenceNumber { get; set; }

        [PetaPoco.Column("PolicyDocumentId")]
        public int PolicyDocumentId { get; set; }

        [PetaPoco.Column("DocumentId")]
        public int DocumentId { get; set; }

        [PetaPoco.Column("StatusFlag")]
        public int StatusFlag { get; set; }

        [PetaPoco.Column("EventName")]
        public string EventName { get; set; }

        [PetaPoco.Column("ResourceKey")]
        public string ResourceKey { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public int TransactionMasterId { get; set; }

        [PetaPoco.Column("EventCode")]
        public int? EventCode { get; set; }

        [PetaPoco.Column("EventDate")]
        public DateTime? EventDate { get; set; }

        [PetaPoco.Column("PolicyDocumentView")]
        public int? PolicyDocumentView { get; set; }

        [PetaPoco.Column("PolicyDocumentAgree")]
        public int? PolicyDocumentAgree { get; set; }

        [PetaPoco.Column("EventType")]
        public int EventType { get; set; }

        [PetaPoco.Column("IsEnterAndUploadEvent")]
        public int IsEnterAndUploadEvent { get; set; }

        public int ID { get; set; }
        public int UserInfoID { get; set; }
        public int UserTypeCodeID { get; set; }

        public int CompanyID { get; set; }

        public int RequiredModule { get; set; }

        public int EnableDisableQuantityValue { get; set; }
        public int? TradingPolicyID_OS { get; set; }
        public int ParentUserInfoID { get; set; }
    }

    public class UsersPolicyDocumentDTO
    {
        [PetaPoco.Column("DocumentId")]
        public int DocumentId { get; set; }

        [PetaPoco.Column("PolicyDocumentId")]
        public int PolicyDocumentId { get; set; }

        [PetaPoco.Column("PolicyDocumentName")]
        public string PolicyDocumentName { get; set; }

        [PetaPoco.Column("PolicyDocumentPath")]
        public string PolicyDocumentPath { get; set; }

        [PetaPoco.Column("PolicyDocumentFileType")]
        public string PolicyDocumentFileType { get; set; }

        [PetaPoco.Column("DocumentViewFlag")]
        public bool DocumentViewFlag { get; set; }

        [PetaPoco.Column("DocumentViewAgreeFlag")]
        public bool DocumentViewAgreeFlag { get; set; }

        [PetaPoco.Column("CalledFrom")]
        public string CalledFrom { get; set; }
    }

    public class UserPolicyDocumentEventLogDTO
    {  
        [PetaPoco.Column("EventCodeId")]
        public int? EventCodeId { get; set; }

        [PetaPoco.Column("EventDate")]
        public DateTime? EventDate { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int? UserInfoId { get; set; }

        [PetaPoco.Column("MapToTypeCodeId")]
        public int? MapToTypeCodeId { get; set; }

        [PetaPoco.Column("MapToId")]
        public int? MapToId { get; set; }
        
    }
    public class FormBDetails_OSDTO
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
 
}
