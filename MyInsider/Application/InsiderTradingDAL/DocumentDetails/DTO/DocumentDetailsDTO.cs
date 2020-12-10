
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_DocumentDetails")]
    public class DocumentDetailsDTO
    {
        [PetaPoco.Column("DocumentId")]
        public int DocumentId { get; set; }

        [PetaPoco.Column("GUID")]
        public string GUID { get; set; }

        [PetaPoco.Column("DocumentName")]
        public string DocumentName { get; set; }

        [PetaPoco.Column("Description")]
        public string Description { get; set; }

        [PetaPoco.Column("DocumentPath")]
        public string DocumentPath { get; set; }

        [PetaPoco.Column("FileSize")]
        public Int64 FileSize { get; set; }

        [PetaPoco.Column("FileType")]
        public string FileType { get; set; }

        [PetaPoco.Column("MapToTypeCodeId")]
        public int MapToTypeCodeId { get; set; }

        [PetaPoco.Column("MapToId")]
        public int MapToId { get; set; }

        [PetaPoco.Column("PurposeCodeId")]
        public int? PurposeCodeId { get; set; }
    }
}
