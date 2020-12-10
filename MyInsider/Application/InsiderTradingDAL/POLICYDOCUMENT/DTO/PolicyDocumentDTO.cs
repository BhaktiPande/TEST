using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("rul_PolicyDocument")]
    public class PolicyDocumentDTO
    {	
		[PetaPoco.Column("PolicyDocumentId")]
		public int? PolicyDocumentId { get; set; }

		[PetaPoco.Column("PolicyDocumentName")]
		public string PolicyDocumentName { get; set; }

		[PetaPoco.Column("DocumentCategoryCodeId")]
		public int? DocumentCategoryCodeId { get; set; }

		[PetaPoco.Column("DocumentSubCategoryCodeId")]
		public int? DocumentSubCategoryCodeId { get; set; }

		[PetaPoco.Column("ApplicableFrom")]
		public DateTime? ApplicableFrom { get; set; }

		[PetaPoco.Column("ApplicableTo")]
		public DateTime? ApplicableTo { get; set; }

		[PetaPoco.Column("CompanyId")]
		public int? CompanyId { get; set; }

		[PetaPoco.Column("DisplayInPolicyDocumentFlag")]
		public bool DisplayInPolicyDocumentFlag { get; set; }

		[PetaPoco.Column("SendEmailUpdateFlag")]
		public bool SendEmailUpdateFlag { get; set; }

        [PetaPoco.Column("DocumentViewFlag")]
        public bool DocumentViewFlag { get; set; }

        [PetaPoco.Column("DocumentViewAgreeFlag")]
        public bool DocumentViewAgreeFlag { get; set; }

		[PetaPoco.Column("WindowStatusCodeId")]
		public int? WindowStatusCodeId { get; set; }

        [PetaPoco.Column("DBCurrentDate")]
        public DateTime? DBCurrentDate { get; set; }

        [PetaPoco.Column("DocumentCategoryName")]
        public String DocumentCategoryName { get; set; }

        [PetaPoco.Column("DocumentSubCategoryName")]
        public String DocumentSubCategoryName { get; set; }

        [PetaPoco.Column("CompanyName")]
        public String CompanyName { get; set; }

        public int LoggedInUserId { get; set; }
    }
}
