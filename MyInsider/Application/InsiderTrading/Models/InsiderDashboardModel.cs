using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    #region Own Securities Dashboard
    public class InsiderDashboardModel
    {
        public int PreclearanceSubmittedCount { get; set; }
        public int PreclearanceApprovedCount { get; set; }
        public int PreclearancePendingCount { get; set; }
        public int PreclearanceRejectedCount { get; set; }

        public int TradeDetailsSubmittedCount { get; set; }
        public int TradeDetailsNotTradedCount { get; set; }
        public int TradeDetailsPendingCount { get; set; }
        public int TradeDetailsSubmittedWithoutPreclearanceCount { get; set; }

        public int HoldingSharesCount { get; set; }
        public int HoldingWarrantsCount { get; set; }
        public int HoldingDebenturesCount { get; set; }
        public int HoldingFuturesCount { get; set; }
        public int HoldingOptionsCount { get; set; }
        public DateTime HoldingDate { get; set; }

        public int InitialDisclosureFlag { get; set; } // 0: Not done but last date not passed. 1: Not done and last date passed. 2: Done. 3: No trading policy is found.
        public DateTime InitialDisclosureDate { get; set; }
        public int ContinuousDisclosureSoftCopyPendingCount { get; set; }
        public int ContiCountWithinLimitFlag { get; set; }
        public int PeriodEndDisclosureFlag { get; set; } // 1: Last date for next period. 2: Lst date of disclosure (date id not passed), 3: Last date of submission (date has passed), 4: Trading policy not found
        public DateTime PeriodEndDate { get; set; }
        public DateTime PeriodEndDateTo { get; set; }

        public string Contact { get; set; }
        public string Email { get; set; }
        public InsiderDashboardOtherModel objInsiderDashboardOtherModel { get; set; }
    }
    #endregion  Own Securities Dashboard

    #region  Other Securities Dashboard
    public class InsiderDashboardOtherModel
    {
        public int PreclearanceSubmittedCount { get; set; }
        public int PreclearanceApprovedCount { get; set; }
        public int PreclearancePendingCount { get; set; }
        public int PreclearanceRejectedCount { get; set; }

        public int TradeDetailsSubmittedCount { get; set; }
        public int TradeDetailsNotTradedCount { get; set; }
        public int TradeDetailsPendingCount { get; set; }
        public int TradeDetailsSubmittedWithoutPreclearanceCount { get; set; }

        public int HoldingSharesCount { get; set; }
        public int HoldingWarrantsCount { get; set; }
        public int HoldingDebenturesCount { get; set; }
        public int HoldingFuturesCount { get; set; }
        public int HoldingOptionsCount { get; set; }
        public DateTime HoldingDate { get; set; }

        public int InitialDisclosureFlag { get; set; } // 0: Not done but last date not passed. 1: Not done and last date passed. 2: Done. 3: No trading policy is found.
        public DateTime InitialDisclosureDate { get; set; }
        public int ContinuousDisclosureSoftCopyPendingCount { get; set; }
        public int ContiCountWithinLimitFlag { get; set; }
        public int PeriodEndDisclosureFlag { get; set; } // 1: Last date for next period. 2: Lst date of disclosure (date id not passed), 3: Last date of submission (date has passed), 4: Trading policy not found
        public DateTime PeriodEndDate { get; set; }
        public DateTime PeriodEndDateTo { get; set; }

        public string Contact { get; set; }
        public string Email { get; set; }
        public bool IsChangePassword { get; set; }
    }
    #endregion  Other Securities Dashboard
}