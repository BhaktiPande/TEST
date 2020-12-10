using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("tra_NSEGroup")]
    public class NSEGroupDTO
    {
        [PetaPoco.Column("GroupId")]
        public int GroupId { get; set; }

        [PetaPoco.Column("DownloadedDate")]
        public DateTime? DownloadedDate { get; set; }

        [PetaPoco.Column("SubmissionDate")]
        public DateTime? SubmissionDate { get; set; }

        [PetaPoco.Column("StatusCodeId")]
        public int StatusCodeId { get; set; }

        [PetaPoco.Column("TypeOfDownload")]
        public int? TypeOfDownload { get; set; }

        [PetaPoco.Column("DownloadStatus")]
        public bool? DownloadStatus { get; set; }

        public int LoggedInUserId { get; set; }
    }

    [PetaPoco.TableName("tra_NSEGroupDetails")]
    public class NSEGroupDetailsDTO
    {
        [PetaPoco.Column("NSEGroupDetailsId")]
        public int NSEGroupDetailsId { get; set; }

        [PetaPoco.Column("GroupId")]
        public int GroupId { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int? UserInfoId { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public int? TransactionMasterId { get; set; }

        public int LoggedInUserId { get; set; }
        public int transId { get; set; }
    }

    [PetaPoco.TableName("tra_NSEDocumentDetails")]
    public class NSEGroupDocumentMappingDTO
    {
        [PetaPoco.Column("DocumentDetailsID")]
        public int GroupDocumentId { get; set; }

        [PetaPoco.Column("NSEGroupDetailsId")]
        public int NSEGroupDetailsId { get; set; }

        [PetaPoco.Column("DocumentObjectMapId")]
        public int DocumentObjectMapId { get; set; }

        public int LoggedInUserId { get; set; }
        public string DocumentName { get; set; }
        public string GUID { get; set; }
        public int GroupId { get; set; }
        public int MapToTypeCodeId { get; set; }
        public int MapToId { get; set; }
        public DateTime DownloadedDate { get; set; }
    }
}
