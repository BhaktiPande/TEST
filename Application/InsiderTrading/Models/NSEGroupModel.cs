using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel;
using System.Text;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Threading.Tasks;
using InsiderTrading.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;


namespace InsiderTrading.Models
{
    public class NSEGroupModel
    {
        public int GroupId { get; set; }
   
        public DateTime DownloadedDate { get; set; }
   
        public DateTime SubmissionDate { get; set; }

        public int StatusCodeId { get; set; }
     
        public int TypeOfDownload { get; set; }
    
        public bool DownloadStatus { get; set; }   
    }

    public class NSEGroupDetailsModel
    {        
        public int NSEGroupDetailsId { get; set; }
      
        public int GroupId { get; set; }

        public int UserInfoId { get; set; }
    }

    public class NSEGroupDocumentMappingModel
    {     
        public int GroupDocumentId { get; set; }

        public int GroupId { get; set; }

        public int DocumentObjectMapId { get; set; }


        public String DocumentCategoryName { get; set; }

        public String DocumentSubCategoryName { get; set; }

        public String CompanyName { get; set; }

        public List<DocumentDetailsModel> NSEGroupDocumentFile { get; set; }

        public List<DocumentDetailsModel> EmailAttachment { get; set; }



        public bool isSaveAllowed { get; set; }
 
      
       
    }

    
}