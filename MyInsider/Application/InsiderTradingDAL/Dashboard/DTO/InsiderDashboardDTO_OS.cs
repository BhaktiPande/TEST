using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class InsiderDashboardDTO_OS
    {
        [PetaPoco.Column("PreclearanceSubmittedCount")]
        public int PreclearanceSubmittedCount { get; set; }

        [PetaPoco.Column("PreclearanceApprovedCount")]
        public int PreclearanceApprovedCount { get; set; }

        [PetaPoco.Column("PreclearancePendingCount")]
        public int PreclearancePendingCount { get; set; }

        [PetaPoco.Column("PreclearanceRejectedCount")]
        public int PreclearanceRejectedCount { get; set; }

        [PetaPoco.Column("TradeDetailsSubmittedCount")]
        public int TradeDetailsSubmittedCount { get; set; }

        [PetaPoco.Column("TradeDetailsNotTradedCount")]
        public int TradeDetailsNotTradedCount { get; set; }

        [PetaPoco.Column("TradeDetailsPendingCount")]
        public int TradeDetailsPendingCount { get; set; }

        [PetaPoco.Column("TradeDetailsSubmittedWithoutPreclearanceCount")]
        public int TradeDetailsSubmittedWithoutPreclearanceCount { get; set; }

        [PetaPoco.Column("HoldingSharesCount")]
        public int HoldingSharesCount { get; set; }

        [PetaPoco.Column("HoldingWarrantsCount")]
        public int HoldingWarrantsCount { get; set; }

        [PetaPoco.Column("HoldingDebenturesCount")]
        public int HoldingDebenturesCount { get; set; }

        [PetaPoco.Column("HoldingFuturesCount")]
        public int HoldingFuturesCount { get; set; }

        [PetaPoco.Column("HoldingOptionsCount")]
        public int HoldingOptionsCount { get; set; }

        [PetaPoco.Column("HoldingDate")]
        public DateTime HoldingDate { get; set; }

        [PetaPoco.Column("InitialDisclosureFlag")]
        public int InitialDisclosureFlag { get; set; }

        [PetaPoco.Column("InitialDisclosureDate")]
        public DateTime InitialDisclosureDate { get; set; }

        [PetaPoco.Column("ContinuousDisclosureSoftCopyPendingCount")]
        public int ContinuousDisclosureSoftCopyPendingCount { get; set; }

        [PetaPoco.Column("ContiCountWithinLimitFlag")]
        public int ContiCountWithinLimitFlag { get; set; }

        [PetaPoco.Column("PeriodEndDisclosureFlag")]
        public int PeriodEndDisclosureFlag { get; set; }

        [PetaPoco.Column("PeriodEndDate")]
        public DateTime PeriodEndDate { get; set; }

        [PetaPoco.Column("PeriodEndDateTo")]
        public DateTime PeriodEndDateTo { get; set; }

        [PetaPoco.Column("Contact")]
        public string Contact { get; set; }

        [PetaPoco.Column("Email")]
        public string Email { get; set; }
    }
    public class DupTransCntDTO_OS
    {
        public int SecurityTypeCodeIdCnt { get; set; }
        public int TransactionTypeCodeIdCnt { get; set; }
        public int DateOfAcquisitionCnt { get; set; }
    }
}
