using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class PDFGenerationModel
    {
        public string Heading { get; set; }
        public Dictionary<string, string> Items { get; set; }
    }
}