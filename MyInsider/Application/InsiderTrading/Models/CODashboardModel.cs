using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class CODashboardModel
    {
      
        public int InitialDisclosuresCOCount { get; set; }
        public int IsChangedInitialDisclosuresCOCount { get; set; }
        public int InitialDisclosuresInsiderCount { get; set; }
        public int IsChangedInitialDisclosuresInsiderCount { get; set; }
        public int PreClearancesCOCount { get; set; }
        public int IsChangedPreClearancesCOCount { get; set; }

        public int TradeDetailsCoCount { get; set; }
        public int IsChangedTradeDetailsCoCount { get; set; }
        public int TradeDetailsInsiderCount { get; set; }
        public int IsChangedTradeDetailsInsiderCount { get; set; }
        public int ContinuousDisclosuresCOCount { get; set; }
        public int IsChangedContinuousDisclosuresCOCount { get; set; }

        public int ContinuousDisclosuresInsiderCount { get; set; }
        public int IsChangedContinuousDisclosuresInsiderCount { get; set; }
        public int SubmissionToStockExchangeCOCount { get; set; }
        public int IsChangedSubmissionToStockExchangeCOCount { get; set; }
        public int PeriodEndDisclosuresCOCount { get; set; }

        public int IsChangedPeriodEndDisclosuresCOCount { get; set; }
        public int PeriodEndDisclosuresInsiderCount { get; set; }
        public int IsChangedPeriodEndDisclosuresInsiderCount { get; set; }
        public int PolicyDocumentAssociationtoUserCount { get; set; }

        public int IsChangedPolicyDocumentAssociationtoUserCount { get; set; }
        public int TradingPolicyAssociationtoUserCount { get; set; }
        public int IsChangedTradingPolicyAssociationtoUserCount { get; set; }

        public int LoginCredentialsMailtoNewUserCount { get; set; }
        public int IsChangedLoginCredentialsMailtoNewUserCount { get; set; }
        public int DefaultersCount { get; set; }
        public int IsChangedDefaultersCount { get; set; }

        public int TradingPolicydueforExpiryCount { get; set; }
        public int IsChangedTradingPolicydueforExpiryCount { get; set; }
        public int PolicyDocumentdueforExpiryCount { get; set; }
        public int IsChangedPolicyDocumentdueforExpiryCount { get; set; }
        public string TradingWindowSettingforFinancialResultDeclarationCurrentYear { get; set; }
        public int TradingWindowSettingforFinancialResultDeclarationCurrentYearId { get; set; }

        public string TradingWindowSettingforFinancialResultDeclarationNextYear { get; set; }
        public int TradingWindowSettingforFinancialResultDeclarationNextYearId { get; set; }
        public int IsChangedTradingWindowSettingforFinancialResultDeclarationCurrentYear { get; set; }
        public int IsChangedTradingWindowSettingforFinancialResultDeclarationNextYear { get; set; }
        public string Contact { get; set; }
        public string Email { get; set; }

        public int DefaulterInitialDisclosureCount { get; set; }
        public int IsChangedDefaulterInitialDisclosureCount { get; set; }
        public int DefaulterContinuousCount { get; set; }
        public int IsChangedDefaulterContinuousCount { get; set; }
        public int DefaulterPECount { get; set; }
        public int IsChangedDefaulterPECount { get; set; }
        public int DefaulterPCLCount { get; set; }
        public int IsChangedDefaulterPCLCount { get; set; }
        public int DefaulterTrdPlanCount { get; set; }
        public int IsChangedDefaulterTrdPlanCount { get; set; }
        public int DefaulterContraCount { get; set; }
        public int IsChangedDefaulterContraCount { get; set; }
        public int DefaulterNonDesCount { get; set; }
        public int IsChangedDefaulterNonDesCount { get; set; }
        
        //Other sercurities dashboard properties
        public int PersonalDetailsConfirmation { get; set; }
        public int PersonalDetailsReconfirmation { get; set; }
        public int InitialDisclosures_OS { get; set; }
        public int InitialDisclosuresRelative_OS { get; set; }
        public int TradeDetails_OS { get; set; }
        public int PeriodendDisclosures_OS { get; set; }
        public int PreclearanceApproval_OS { get; set; }
        public int TradingPolicydueforExpiry_OS { get; set; }
        public int PolicyDocumentdueforExpiry { get; set; }

        public CODashboardModel_OS objCODashboardModel_OS { get; set; }
    }

    public class CODashboardModel_OS
    {
        public int PersonalDetailsConfirmation { get; set; }
        public int PersonalDetailsReconfirmation { get; set; }
        public int InitialDisclosures_OS { get; set; }
        public int InitialDisclosuresRelative_OS { get; set; }
        public int TradeDetails_OS { get; set; }
        public int PeriodendDisclosures_OS { get; set; }
        public int PreclearanceApproval_OS { get; set; }
        public int TradingPolicydueforExpiry_OS { get; set; }
        public int PolicyDocumentdueforExpiry { get; set; }
    }
}