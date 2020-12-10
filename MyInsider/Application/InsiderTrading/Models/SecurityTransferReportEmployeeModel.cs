using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class SecurityTransferReportEmployeeModel
    {
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DematAccountNumber { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DepositoryName { get; set; }
        public string TransferFromDate { get; set; }
        public string TransferToDate { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DPID { get; set; }

        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string DepositoryParticipantName { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string TransferFromQuantity { get; set; }
        [RegularExpression(ConstEnum.DataValidation.UserNameType, ErrorMessage = "usr_msg_50524")]
        public string TransferToQuantity { get; set; }
    }
}