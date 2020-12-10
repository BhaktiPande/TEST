using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class ReportHeaderKeyValueDTO
    {
        [PetaPoco.Column("Id")]
        public string Id { get; set; }
        [PetaPoco.Column("RKey")]
        public string Key { get; set; }
        [PetaPoco.Column("Value")]
        public string Value { get; set; }
        [PetaPoco.Column("DataType")]
        public int DataType { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public int TransactionMasterId { get; set; }
        [PetaPoco.Column("DisclosureTypeCodeId")]
        public int DisclosureTypeCodeId { get; set; }
        [PetaPoco.Column("LetterForCodeId")]
        public int LetterForCodeId { get; set; }
        [PetaPoco.Column("Acid")]
        public int Acid { get; set; }
        [PetaPoco.Column("LetterType")]
        public string LetterType { get; set; } 
    }
}
