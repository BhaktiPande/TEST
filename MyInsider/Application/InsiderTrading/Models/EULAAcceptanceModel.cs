using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class EULAAcceptanceModel
    {
        public int UserInfoID { get; set; }

        public int DocumentID { get; set; }

        public string DocumentName { get; set; }

        public string DocumentPath { get; set; }

        public string DocumentFileType { get; set; }

        public bool EULAAcceptanceFlag { get; set;}
    }
}