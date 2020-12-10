using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class UpsiSharingData
    {

        public int Upsi_id { get; set; }
        [Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_55050")]
        public string Company_Name { get; set; }
        [Required]
        [DataType(DataType.Text)]
        [DisplayName("usr_lbl_55051")]
        public string Company_Address { get; set; }
        [Required]
        [DisplayName("usr_lbl_55040")]
        public int? Category_Shared { get; set; }
        public string Category_Shared1 { get; set; }
        [Required]
        [DisplayName("usr_lbl_55041")]
        public int? Reason_sharing { get; set; }

        public string Reason_sharingdata { get; set; }
        [DisplayName("usr_lbl_55042")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_55067")]
        public string Comments { get; set; }
        [Required]
        [DisplayName("usr_lbl_55049")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.PAN, ErrorMessage = "usr_msg_55068")]
	    public string PAN { get; set; }

        [Required]
        [DisplayName("usr_lbl_55048")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_55067")]
		public string Name { get; set; }
        [Required]
        [DisplayName("usr_lbl_55052")]
        [StringLength(30)]
        [RegularExpression(ConstEnum.DataValidation.MobileNo, ErrorMessage = "usr_msg_55069")]
        public string Phone { get; set; }

        [Required]
        [DisplayName("usr_lbl_55053")]
        [StringLength(100)]
        [RegularExpression(ConstEnum.DataValidation.Email, ErrorMessage = "usr_msg_55070")]
        public string E_mail { get; set; }
        [Required]
        [DisplayName("usr_lbl_55044")]
        public DateTime? SharingDate { get; set; }
        [DisplayName("usr_lbl_55046")]
        public DateTime? PublishDate { get; set; }

        public int? UserInfoId { get; set; }

        public int? UPSIDocumentId { get; set; }
        
        public int SequenceNo { get; set; }

        public string Action { get; set; }

       
        [DisplayName("usr_lbl_55039")]
        public string DocumentNumber { get; set; }
        [Required]
        [DisplayName("usr_lbl_55043")]
        public int? ModeOfSharing { get; set; }
        [DisplayName("usr_lbl_55045")]
        public TimeSpan Time { get; set; }  

        public String Address { get; set; }
        [DisplayName("usr_lbl_55054")]
        public String Sharedby { get; set; } 

        public string Temp1 { get; set; }

        public string Temp2 { get; set; }

        public string Temp3 { get; set; }

        public string Temp4 { get; set; }

        public string Temp5 { get; set; }

        public string Me { get; set; }

        [Required]
        [DisplayName("usr_lbl_55055")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_55067")]
        public string Sharedbyname { get; set; }
        public string Other { get; set; }

        [Required]
        [DisplayName("usr_lbl_55047")]
        public int[] Listofmultipleuser { get; set; } 

        public string MobileNumber { get; set; }

        public string FirstName { get; set; }

       

        public string EmailId { get; set; }




        public string CompanyName { get; set; }

        public string CompanyAddress { get; set; }

        public int Category { get; set; }

        public int Reason { get; set; }

        public TimeSpan SharingTime { get; set; }

        public string DocumentNo { get; set; }
        public string ModeOfSharingdata { get; set; }

        [DisplayName("usr_lbl_55076")]
        public String CHKUserAndOther { get; set; }   
        
        [Required]
        [DisplayName("usr_lbl_55055")]
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_55067")]
        public String Sharedbynamea { get; set; }
        [DisplayName("usr_lbl_55054")]
        public String Sharedbyo { get; set; }

        [DisplayName("usr_lbl_55049")]
        [StringLength(100)]        
        public string PANT { get; set; }

        [DisplayName("usr_lbl_55048")]      
        public string NameT { get; set; }

        [DisplayName("usr_lbl_55040")]
        public int? Category_SharedT { get; set; }

        [DisplayName("usr_lbl_55041")]
        public int? Reason_sharingT { get; set; }

        [DisplayName("usr_lbl_55044")]
        public DateTime? SharingDateT { get; set; }
    }
}