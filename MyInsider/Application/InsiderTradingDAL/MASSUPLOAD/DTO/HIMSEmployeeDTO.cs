
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    /// <summary>
    /// This DTO will be used for fetching the data from the given Employees view 
    /// </summary>
    public class HIMSEmployeeDTO
    {
        [PetaPoco.Column("UserId")]
        public string UserId { get; set; }

        [PetaPoco.Column("UserName")]
        public string UserName { get; set; }

        [PetaPoco.Column("CompanyName")]
        public string CompanyName { get; set; }

        [PetaPoco.Column("FirstName")]
        public string FirstName { get; set; }

        [PetaPoco.Column("Middlename")]
        public string Middlename { get; set; }

        [PetaPoco.Column("LastName")]
        public string LastName { get; set; }

        [PetaPoco.Column("Address")]
        public string Address { get; set; }

        [PetaPoco.Column("Pincode")]
        public string Pincode { get; set; }

        [PetaPoco.Column("Country")]
        public string Country { get; set; }

        [PetaPoco.Column("MobileNumber")]
        public string MobileNumber { get; set; }

        [PetaPoco.Column("EmailAddress")]
        public string EmailAddress { get; set; }

        [PetaPoco.Column("PAN")]
        public string PAN { get; set; }

        [PetaPoco.Column("Role")]
        public string Role { get; set; }

        [PetaPoco.Column("DateOfJoining")]
        public string DateOfJoining { get; set; }

        [PetaPoco.Column("DateOfBecomingInsider")]
        public string DateOfBecomingInsider { get; set; }

        [PetaPoco.Column("Category")]
        public string Category { get; set; }

        [PetaPoco.Column("SubCategory")]
        public string SubCategory { get; set; }

        [PetaPoco.Column("Grade")]
        public string Grade { get; set; }

        [PetaPoco.Column("Designation")]
        public string Designation { get; set; }

        [PetaPoco.Column("SubDesignation")]
        public string SubDesignation { get; set; }

        [PetaPoco.Column("Location")]
        public string Location { get; set; }

        [PetaPoco.Column("Department")]
        public string Department { get; set; }

        [PetaPoco.Column("DIN")]
        public string DIN { get; set; }


    }
}
