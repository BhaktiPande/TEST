using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CODashboardDTO
    {
        [PetaPoco.Column("InitialDisclosuresCOCount")]
        public int InitialDisclosuresCOCount { get; set; }

        [PetaPoco.Column("IsChangedInitialDisclosuresCOCount")]
        public int IsChangedInitialDisclosuresCOCount { get; set; }

        [PetaPoco.Column("InitialDisclosuresInsiderCount")]
        public int InitialDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("IsChangedInitialDisclosuresInsiderCount")]
        public int IsChangedInitialDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("PreClearancesCOCount")]
        public int PreClearancesCOCount { get; set; }

        [PetaPoco.Column("IsChangedPreClearancesCOCount")]
        public int IsChangedPreClearancesCOCount { get; set; }

        [PetaPoco.Column("TradeDetailsCoCount")]
        public int TradeDetailsCoCount { get; set; }

        [PetaPoco.Column("IsChangedTradeDetailsCoCount")]
        public int IsChangedTradeDetailsCoCount { get; set; }

        [PetaPoco.Column("TradeDetailsInsiderCount")]
        public int TradeDetailsInsiderCount { get; set; }

        [PetaPoco.Column("IsChangedTradeDetailsInsiderCount")]
        public int IsChangedTradeDetailsInsiderCount { get; set; }

        [PetaPoco.Column("ContinuousDisclosuresCOCount")]
        public int ContinuousDisclosuresCOCount { get; set; }

        [PetaPoco.Column("IsChangedContinuousDisclosuresCOCount")]
        public int IsChangedContinuousDisclosuresCOCount { get; set; }

        [PetaPoco.Column("ContinuousDisclosuresInsiderCount")]
        public int ContinuousDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("IsChangedContinuousDisclosuresInsiderCount")]
        public int IsChangedContinuousDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("SubmissionToStockExchangeCOCount")]
        public int SubmissionToStockExchangeCOCount { get; set; }

        [PetaPoco.Column("IsChangedSubmissionToStockExchangeCOCount")]
        public int IsChangedSubmissionToStockExchangeCOCount { get; set; }

        [PetaPoco.Column("PeriodEndDisclosuresCOCount")]
        public int PeriodEndDisclosuresCOCount { get; set; }

        [PetaPoco.Column("IsChangedPeriodEndDisclosuresCOCount")]
        public int IsChangedPeriodEndDisclosuresCOCount { get; set; }

        [PetaPoco.Column("PeriodEndDisclosuresInsiderCount")]
        public int PeriodEndDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("IsChangedPeriodEndDisclosuresInsiderCount")]
        public int IsChangedPeriodEndDisclosuresInsiderCount { get; set; }

        [PetaPoco.Column("PolicyDocumentAssociationtoUserCount")]
        public int PolicyDocumentAssociationtoUserCount { get; set; }

        [PetaPoco.Column("IsChangedPolicyDocumentAssociationtoUserCount")]
        public int IsChangedPolicyDocumentAssociationtoUserCount { get; set; }

        [PetaPoco.Column("TradingPolicyAssociationtoUserCount")]
        public int TradingPolicyAssociationtoUserCount { get; set; }

        [PetaPoco.Column("IsChangedTradingPolicyAssociationtoUserCount")]
        public int IsChangedTradingPolicyAssociationtoUserCount { get; set; }

        [PetaPoco.Column("LoginCredentialsMailtoNewUserCount")]
        public int LoginCredentialsMailtoNewUserCount { get; set; }

        [PetaPoco.Column("IsChangedLoginCredentialsMailtoNewUserCount")]
        public int IsChangedLoginCredentialsMailtoNewUserCount { get; set; }

        [PetaPoco.Column("DefaultersCount")]
        public int DefaultersCount { get; set; }

        [PetaPoco.Column("IsChangedDefaultersCount")]
        public int IsChangedDefaultersCount { get; set; }

        [PetaPoco.Column("TradingPolicydueforExpiryCount")]
        public int TradingPolicydueforExpiryCount { get; set; }

        [PetaPoco.Column("IsChangedTradingPolicydueforExpiryCount")]
        public int IsChangedTradingPolicydueforExpiryCount { get; set; }

        [PetaPoco.Column("PolicyDocumentdueforExpiryCount")]
        public int PolicyDocumentdueforExpiryCount { get; set; }

        [PetaPoco.Column("IsChangedPolicyDocumentdueforExpiryCount")]
        public int IsChangedPolicyDocumentdueforExpiryCount { get; set; }

        [PetaPoco.Column("TradingWindowSettingforFinancialResultDeclarationCurrentYear")]
        public string TradingWindowSettingforFinancialResultDeclarationCurrentYear { get; set; }

        [PetaPoco.Column("TradingWindowSettingforFinancialResultDeclarationCurrentYearId")]
        public int TradingWindowSettingforFinancialResultDeclarationCurrentYearId { get; set; }

        [PetaPoco.Column("TradingWindowSettingforFinancialResultDeclarationNextYear")]
        public string TradingWindowSettingforFinancialResultDeclarationNextYear { get; set; }

        [PetaPoco.Column("TradingWindowSettingforFinancialResultDeclarationNextYearId")]
        public int TradingWindowSettingforFinancialResultDeclarationNextYearId { get; set; }

        [PetaPoco.Column("IsChangedTradingWindowSettingforFinancialResultDeclarationCurrentYear")]
        public int IsChangedTradingWindowSettingforFinancialResultDeclarationCurrentYear { get; set; }

        [PetaPoco.Column("IsChangedTradingWindowSettingforFinancialResultDeclarationNextYear")]
        public int IsChangedTradingWindowSettingforFinancialResultDeclarationNextYear { get; set; }
        [PetaPoco.Column("Contact")]
        public string Contact { get; set; }

        [PetaPoco.Column("Email")]
        public string Email { get; set; }

        [PetaPoco.Column("DefaulterInitialDisclosureCount")]
        public int DefaulterInitialDisclosureCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterInitialDisclosureCount")]
        public int IsChangedDefaulterInitialDisclosureCount { get; set; }

        [PetaPoco.Column("DefaulterContinuousCount")]
        public int DefaulterContinuousCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterContinuousCount")]
        public int IsChangedDefaulterContinuousCount { get; set; }

        [PetaPoco.Column("DefaulterPECount")]
        public int DefaulterPECount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterPECount")]
        public int IsChangedDefaulterPECount { get; set; }

        [PetaPoco.Column("DefaulterPCLCount")]
        public int DefaulterPCLCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterPCLCount")]
        public int IsChangedDefaulterPCLCount { get; set; }

        [PetaPoco.Column("DefaulterTrdPlanCount")]
        public int DefaulterTrdPlanCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterTrdPlanCount")]
        public int IsChangedDefaulterTrdPlanCount { get; set; }

        [PetaPoco.Column("DefaulterContraCount")]
        public int DefaulterContraCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterContraCount")]
        public int IsChangedDefaulterContraCount { get; set; }

        [PetaPoco.Column("DefaulterNonDesCount")]
        public int DefaulterNonDesCount { get; set; }
        [PetaPoco.Column("IsChangedDefaulterNonDesCount")]
        public int IsChangedDefaulterNonDesCount { get; set; }

    }
}
