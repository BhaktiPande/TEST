using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PopulateComboDTO
    {
        [PetaPoco.Column("ID")]
        public string Key { get; set; }
        [PetaPoco.Column("Value")]
        public string Value { get; set; }
        [PetaPoco.Column("Width")]
        public string Width { get; set; }
        [PetaPoco.Column("Align")]
        public string Align { get; set; }
        [PetaPoco.Column("SequenceNumber")]
        public string SequenceNumber { get; set; }
        [PetaPoco.Column("OptionAttribute")]
        public string OptionAttribute { get; set; }
        
    }
}
