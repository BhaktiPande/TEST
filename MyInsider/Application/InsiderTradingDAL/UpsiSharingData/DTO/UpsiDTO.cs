using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("usr_UpsiSharingData")]
    public class UpsiDTO
    {
        [PetaPoco.Column("Company_Name")]
        public string Company_Name { get; set; }

        [PetaPoco.Column("Company_Address")]
        public string Company_Address { get; set; }

        [PetaPoco.Column("Category_Shared")]
        public string Category_Shared { get; set; }

        [PetaPoco.Column("Reason_sharing")]
        public string Reason_sharing { get; set; }

        [PetaPoco.Column("Comments")]
        public string Comments { get; set; }

        [PetaPoco.Column("PAN")]
        public string PAN { get; set; }

        [PetaPoco.Column("Name")]
        public string Name { get; set; }

        [PetaPoco.Column("Phone")]
        public string Phone { get; set; }

        [PetaPoco.Column("E_mail")]
        public string E_mail { get; set; }

        [PetaPoco.Column("SharingDate")]
        public DateTime? SharingDate { get; set; }

        [PetaPoco.Column("PublishDate")]
        public DateTime? PublishDate { get; set; }

        [PetaPoco.Column("UserInfoId")]
        public int UserInfoId { get; set; }

        public string CompanyName { get; set; }

        public string CompanyAddress { get; set; }

        public int Category { get; set; }

        public int Reason { get; set; }

        public int ModeOfSharing { get; set; }

        public TimeSpan SharingTime { get; set; }

        public string Temp1 { get; set; }

        public string Temp2 { get; set; }

        public string Temp3 { get; set; }

        public string Temp4 { get; set; }

        public string Temp5 { get; set; }

        public string DocumentNo { get; set; }

        public int UPSIDocumentId { get; set; }

        public int Listofmultipleuser { get; set; }

        public string MobileNumber { get; set; }

        public string FirstName { get; set; }

        public string Address { get; set; }

        public string EmailId { get; set; }

        public string ContactPerson { get; set; }


    }

}

