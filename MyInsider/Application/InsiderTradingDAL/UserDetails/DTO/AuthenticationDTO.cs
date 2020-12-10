using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading
{   
    [PetaPoco.TableName("usr_Authentication")]
    public class AuthenticationDTO
    {	
		[PetaPoco.Column("AuthenticationId")]
		public int AuthenticationId { get; set; }

		[PetaPoco.Column("UserInfoID")]
		public int UserInfoID { get; set; }

		[PetaPoco.Column("LoginID")]
		public string LoginID { get; set; }

		[PetaPoco.Column("Password")]
		public string Password { get; set; }

		[PetaPoco.Column("UserTypeCodeId")]
		public int UserTypeCodeId { get; set; }

		[PetaPoco.Column("StatusCodeId")]
		public int StatusCodeId { get; set; }

		[PetaPoco.Column("CreatedOn")]
		public DateTime CreatedOn { get; set; }

		[PetaPoco.Column("ModifiedBy")]
		public int ModifiedBy { get; set; }

		[PetaPoco.Column("ModifiedOn")]
		public DateTime ModifiedOn { get; set; }

        [PetaPoco.Column("SaltValue")]
        public string SaltValue { get; set; }              
    }
}
