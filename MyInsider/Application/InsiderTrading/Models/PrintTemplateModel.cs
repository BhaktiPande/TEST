using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class PrintTemplateModel
    {


        public TransactionLetterModel transactionLetterModel { get; set; }

        public List<DocumentDetailsModel> StockExchangeDocument { get; set; }
    }
}