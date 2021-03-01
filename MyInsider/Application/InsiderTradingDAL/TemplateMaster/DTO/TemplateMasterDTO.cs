
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using System.ComponentModel.DataAnnotations;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("tra_TemplateMaster")]
    public class TemplateMasterDTO
    {	
		[PetaPoco.Column("TemplateMasterId")]
		public int TemplateMasterId { get; set; }
  
		[PetaPoco.Column("TemplateName")]
		public string TemplateName { get; set; }
                
		[PetaPoco.Column("CommunicationModeCodeId")]
		public int CommunicationModeCodeId { get; set; }

		[PetaPoco.Column("DisclosureTypeCodeId")]
		public int? DisclosureTypeCodeId { get; set; }

		[PetaPoco.Column("LetterForCodeId")]
		public int? LetterForCodeId { get; set; }

		[PetaPoco.Column("IsActive")]
		public bool IsActive { get; set; }

		[PetaPoco.Column("Date")]
		public DateTime? Date { get; set; }

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

        [PetaPoco.Column("CommunicationFrom")]
		public string CommunicationFrom { get; set; }

        [PetaPoco.Column("TransactionMasterId")]
        public Int64 TransactionMasterId { get; set; }

        [PetaPoco.Column("TransactionLetterId")]
        public Int64 TransactionLetterId { get; set; }

        [PetaPoco.Column("SequenceNo")]
        public string SequenceNo { get; set; }
        
        public int WarningMessage { get; set; }

        //NOTE - In case communication type as "Letter" this field is used to stored if "ToAddress2" field is required or not
        // and in case of communication type as "Email", "SMS", "Text Alert", "Popup Alert" - this field is set to "True" in DB procedure by default
        [PetaPoco.Column("IsCommunicationTemplate")]
        public bool IsCommunicationTemplate { get; set; }

        [PetaPoco.Column("LetterForUserDesignation")]
        public string LetterForUserDesignation { get; set; }
    }

	public class GenrateFormDetailsDTO
	{
		[PetaPoco.Column("GeneratedFormDetailsId")]
		public int GeneratedFormDetailsId { get; set; }
		public int DisclosuerTypeId { get; set; }

	}
}
