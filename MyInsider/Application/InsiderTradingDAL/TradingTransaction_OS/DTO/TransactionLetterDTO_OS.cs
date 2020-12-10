using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("tra_TransactionLetter")]
    public class TransactionLetterDTO_OS
    {
        [PetaPoco.Column("TransactionLetterId")]
        public int TransactionLetterId { get; set; }

        [PetaPoco.Column("DisclosureTypeCodeId")]
        public int DisclosureTypeCodeId { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public int TransactionMasterId { get; set; }

        [PetaPoco.Column("LetterForCodeId")]
        public int LetterForCodeId { get; set; }

        [PetaPoco.Column("Date")]
        public DateTime Date { get; set; }

        [PetaPoco.Column("ToAddress1")]
        public string ToAddress1 { get; set; }

        [PetaPoco.Column("ToAddress2")]
        public string ToAddress2 { get; set; }

        [PetaPoco.Column("Subject")]
        public string Subject { get; set; }

        [PetaPoco.Column("Contents")]
        public string Contents { get; set; }

        [PetaPoco.Column("Signature")]
        public string Signature { get; set; }
        public int MapToTypeCodeId { get; set; }     
        public Int64? MapToId { get; set; }
        public int LoggedInUserId { get; set; }
        public int @inp_iYearCodeId { get; set; }
        public int @inp_iPeriodCodeID { get; set; }
    }

    public class FormGDetails_OSDTO
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
