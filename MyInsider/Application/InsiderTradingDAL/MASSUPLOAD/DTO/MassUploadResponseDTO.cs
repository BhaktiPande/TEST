using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class MassUploadResponseDTO
    {
        public MassUploadResponseDTO()
        {

        }

        public MassUploadResponseDTO(int i_nErrorCode, string i_sErrorMessage)
        {
            this.ErrorCode = i_nErrorCode;
            this.ErrorMessage = i_sErrorMessage;
        }

        [PetaPoco.Column("ResponseId")]
        public string MassUploadResponseId { get; set; }

        [PetaPoco.Column("ErrorCode")]
        public int ErrorCode { get; set; }

        [PetaPoco.Column("ErrorMessage")]
        public string ErrorMessage { get; set; }

        [PetaPoco.Column("ReturnValue")]
        public int ReturnValue { get; set; }

        [PetaPoco.Column("ResourcePrefix")]
        public string ResourcePrefix { get; set; }
    }
}
