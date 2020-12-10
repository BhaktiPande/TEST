using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_DMATAccountHolder")]
    public class DMATAccountHolderDTO
    {
        [PetaPoco.Column("DMATAccountHolderId")]
        public int DMATAccountHolderId { get; set; }

        [PetaPoco.Column("DMATDetailsID")]
        public int DMATDetailsID { get; set; }

        [PetaPoco.Column("AccountHolderName")]
        public string AccountHolderName { get; set; }

        [PetaPoco.Column("PAN")]
        public string PAN { get; set; }

        [PetaPoco.Column("RelationTypeCodeId")]
        public int RelationTypeCodeId { get; set; }
    }
}
