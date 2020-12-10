using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class InsiderInitialDisclosureCountModel
    {
        public int InsiderCount { get; set; }
        public int SoftCopyPendingCount { get; set; }
        public int HardCopyPendingCount { get; set; }
        public int SoftCopySubmittedCount { get; set; }
        public int HardCopySubmittedCount { get; set; }
    }
}