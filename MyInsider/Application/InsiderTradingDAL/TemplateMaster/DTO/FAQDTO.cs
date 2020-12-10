using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{   
    [PetaPoco.TableName("tra_TemplateMaster")]
    public class FAQDTO
    {	
		[PetaPoco.Column("TemplateMasterId")]
		public int TemplateMasterId { get; set; }
  
		[PetaPoco.Column("TemplateName")]
		public string FAQName { get; set; }

        [PetaPoco.Column("IsActive")]
		public bool IsActive { get; set; }

		[PetaPoco.Column("Contents")]
		public string Contents { get; set; }

        [PetaPoco.Column("SequenceNo")]
        public string SequenceNo { get; set; }
        
        public int WarningMessage { get; set; }
	      
    }
}
