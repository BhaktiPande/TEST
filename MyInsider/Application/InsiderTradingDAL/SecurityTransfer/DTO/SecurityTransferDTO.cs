using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class SecurityTransferDTO
    {
        [PetaPoco.Column("SecurityTransaferID")]
        public long SecurityTransaferID { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        [PetaPoco.Column("ForUserInfoId")]
        public int ForUserInfoId { get; set; }

        [PetaPoco.Column("SecurityTransferOption")]
        public int SecurityTransferOption { get; set; }

        [PetaPoco.Column("TransferQuantity")]
        public Decimal? TransferQuantity { get; set; }

        [PetaPoco.Column("FromDEMATAcountID")]
        public int FromDEMATAcountID { get; set; }

        [PetaPoco.Column("SecurityTypeCodeID")]
        public int SecurityTypeCodeID { get; set; }

        [PetaPoco.Column("ToDEMATAcountID")]
        public int ToDEMATAcountID { get; set; }

        [PetaPoco.Column("TransferFor")]
        public int TransferFor { get; set; }

        [PetaPoco.Column("TransferESOPQuantity")]
        public Decimal? TransferESOPQuantity { get; set; }
       
    }
}
