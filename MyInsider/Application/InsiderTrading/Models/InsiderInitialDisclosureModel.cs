using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace InsiderTrading.Models
{
    public class InsiderInitialDisclosureModel
    {
        public InsiderInitialDisclosureModelEmployee InsiderInitialDisclosureModelEmployee { get; set; }
        public InsiderInitialDisclosureModelInsider InsiderInitialDisclosureModelInsider { get; set; }
        public List<InsiderInitialDisclosureModelEmployee> InsiderInitialDisclosureModelEmployee1 { get; set; }
        public List<InsiderInitialDisclosureModelInsider> InsiderInitialDisclosureModelInsider1 { get; set; }

    }
    public class InsiderInitialDisclosureModelEmployee
    {       
        public int SequenceNumber { get; set; }
        public int PolicyDocumentId { get; set; }
        public int DocumentId { get; set; }
        public int StatusFlag { get; set; }
        public string EventName { get; set; }
        public string ResourceKey { get; set; }
        public int TransactionMasterId { get; set; }
        public int? EventCode { get; set; }
        public DateTime? EventDate { get; set; }
        public int? PolicyDocumentView { get; set; }
        public int? PolicyDocumentAgree { get; set; }
        public int EventType { get; set; }
        public int IsEnterAndUploadEvent { get; set; }
        public int ID { get; set; }
        public int UserInfoID { get; set; }
        public int UserTypeCodeID { get; set; }
        public int ParentUserInfoID { get; set; }
    }

    public class InsiderInitialDisclosureModelInsider
    {
        public int SequenceNumber { get; set; }
        public int PolicyDocumentId { get; set; }
        public int DocumentId { get; set; }
        public int StatusFlag { get; set; }
        public string EventName { get; set; }
        public string ResourceKey { get; set; }
        public int TransactionMasterId { get; set; }
        public int? EventCode { get; set; }
        public DateTime? EventDate { get; set; }
        public int? PolicyDocumentView { get; set; }
        public int? PolicyDocumentAgree { get; set; }
        public int EventType { get; set; }
        public int IsEnterAndUploadEvent { get; set; }
        public int ID { get; set; }
        public int UserInfoID { get; set; }
        public int UserTypeCodeID { get; set; }
        public int ParentUserInfoID { get; set; }
    }

    public class UsersPolicyDocumentModel
    {       
        public int DocumentId { get; set; }
        public int PolicyDocumentId { get; set; }
        public string PolicyDocumentName { get; set; }
        public string PolicyDocumentPath { get; set; }
        public string PolicyDocumentFileType { get; set; }
        public bool DocumentViewFlag { get; set; }
        public bool DocumentViewAgreeFlag { get; set; }
        public string CalledFrom { get; set; }
        public int? RequiredModuleID { get; set; }
    }

    public class UserPolicyDocumentEventLogModel
    {
       
        public int? EventCodeId { get; set; }
        public DateTime? EventDate { get; set; }
        public int? UserInfoId { get; set; }
        public int? MapToTypeCodeId { get; set; }
        public int? MapToId { get; set; }
    }
}