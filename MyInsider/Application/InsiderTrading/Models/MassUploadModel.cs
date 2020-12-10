using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class MassUploadModel
    {
        [Required]
        public List<DocumentDetailsModel> MassUploadFile { get; set; }

       
    }
}