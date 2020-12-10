
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading.Models
{
    public class TradingTransactionReportModel_OS
    {

        public int? ReportTypeID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string EmpID { get; set; }

        //[RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string CompanyName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string InsiderName { get; set; }

        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string PAN { get; set; }

        public DateTime? TransactionFromDate { get; set; }

        public DateTime? TransactionToDate { get; set; }

        public string YearCodeId { get; set; }

        public string PeriodCodeId { get; set; }


    }
}
