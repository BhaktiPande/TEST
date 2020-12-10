IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DashBoardForCO')
DROP PROCEDURE [dbo].[st_tra_DashBoardForCO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get DashBoard Count for CO.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		12-JUNE-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	12-Sept-2015	Changes for Co dashboard configuration values
Gaurishankar	15-Sept-2015	Added Comments and constants
Arundhati		19-Oct-2015		Added logic for defaulter counts, and fetched those columns in output
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Gaurishankar	19-Nov-2015		Chnages for submitted to stockExchange count displayed to CO (initialy only Continous Disclosure transactions are considered and the SftCopy HardCopy Req and submitted are not checked)
Gaurishankar	25-Nov-2015		Change the code to @CODE_DISCLOSURE_TYPE_XXX
Gaurishankar	25-Nov-2015		Fix the bug for Partially traded flag 
ED				22-Jan-2016		Code merging on Jan-22-2016
ED			4-Feb-2016	Code integration done on 4-Feb-2016
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Shubhangi    07-02-2018   Moved logic of updating dashboard count in tra_CoDashboardCount table from st_tra_DashBoardForCO to st_tra_CreateJob_CODashboardCntUpdate
Usage:
EXEC st_tra_DashBoardForCO
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_DashBoardForCO]
	@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN	
	DECLARE @nInsiderInitialDisclosureCount INT = 0
	DECLARE @nCOInitialDisclosureCount INT = 0	
	DECLARE @nCOTradeDetailsCount INT = 0	
	DECLARE @nInsiderTradeDetailsCount INT = 0	
	DECLARE @nCOContinuousDisclosuresCount INT = 0	
	DECLARE @nInsiderContinuousDisclosuresCount INT = 0	
	
	DECLARE @nCOSubmissiontoStockExchangeCount INT = 0	
	DECLARE @nCOPeriodEndDisclosuresCount INT = 0	
	DECLARE @nInsiderPeriodEndDisclosuresCount INT = 0	
	DECLARE @nPolicyDocumentAssociationtoUserCount INT = 0 
	DECLARE @nTradingPolicyAssociationtoUserCount INT = 0
	DECLARE @nLoginCredentialsMailtoNewUserCount INT = 0
	DECLARE @nDefaultersCount INT = 0
	DECLARE @nTradingPolicydueforExpiryCount INT = 0
	DECLARE @nPolicyDocumentdueforExpiryCount INT = 0
	DECLARE @nCount INT = 0
	DECLARE @nCOPreclearanceCount INT = 0	
	DECLARE @nSoftCopyPendingCount INT = 0
	DECLARE @nHardCopyPendingCount INT = 0
	DECLARE @nSoftCopySubmittedCount INT
	DECLARE @nHardCopySubmittedCount INT = 0
	DECLARE @nTradingPolicyExpiryDays INT = 30
	DECLARE @nPolicyDocumentExpiryDays INT = 30	
	DECLARE @sTradingWindowSettingforFinancialResultDeclarationCurrentYear VARCHAR (15)
	DECLARE @sTradingWindowSettingforFinancialResultDeclarationNextYear VARCHAR (15)
	DECLARE @nTradingWindowSettingforFinancialResultDeclarationCurrentYearId INT
	DECLARE @nTradingWindowSettingforFinancialResultDeclarationNextYearId INT
	DECLARE @nIsCurrentFinancialResultDeclared BIT
	DECLARE @nIsNextFinancialResultDeclared BIT	
	
	DECLARE @CODE_CO_DASHBOARD_CONTACT_NUMBER INT = 168003,
			@CODE_CO_DASHBOARD_EMAIL INT = 168004,	
	   	    @CODE_TRADING_WINDOW_EVENT_TYPE_FINANCIAL_RESULT INT = 126001, --  Trading Window Event Type - Financial Result 126001
			@CODEGROUP_FINANCIAL_YEAR INT = 125 --  CodeGroup Financial Year 125	

	DECLARE @nDefaulter_Initial BIGINT,
			@nDefaulter_Continuous BIGINT = 0,
			@nDefaulter_PE BIGINT,
			@nDefaulter_Preclearance BIGINT,
			@nDefaulter_TradingPlan BIGINT = 0,
			@nDefaulter_ContraTrade BIGINT,
			@nDefaulter_TradedWithNonDesignatedDMAT BIGINT = 0
			
	BEGIN TRY				

		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''		
		
		SELECT @sTradingWindowSettingforFinancialResultDeclarationCurrentYear = YEAR(dbo.uf_com_GetServerDate())
		SELECT @sTradingWindowSettingforFinancialResultDeclarationCurrentYear = @sTradingWindowSettingforFinancialResultDeclarationCurrentYear + '-'

		SELECT @sTradingWindowSettingforFinancialResultDeclarationNextYear = YEAR(DateAdd(year,1,dbo.uf_com_GetServerDate()))
		SELECT @sTradingWindowSettingforFinancialResultDeclarationNextYear = @sTradingWindowSettingforFinancialResultDeclarationNextYear + '-'
		SELECT TOP 1 @sTradingWindowSettingforFinancialResultDeclarationCurrentYear = C.CodeName 
		,@nTradingWindowSettingforFinancialResultDeclarationCurrentYearId = CodeID
		,@nIsCurrentFinancialResultDeclared = CASE WHEN TWE.TradingWindowEventId IS NOT NULL THEN   1 ELSE  0 END
		FROM com_Code C
		LEFT JOIN rul_TradingWindowEvent TWE ON C.CodeID = TWE.FinancialYearCodeId AND TWE.EventTypeCodeId = @CODE_TRADING_WINDOW_EVENT_TYPE_FINANCIAL_RESULT
		where CodeGroupId = @CODEGROUP_FINANCIAL_YEAR AND [Description] like  @sTradingWindowSettingforFinancialResultDeclarationCurrentYear+'%'

		SELECT TOP 1 @sTradingWindowSettingforFinancialResultDeclarationNextYear = C.CodeName 
		,@nTradingWindowSettingforFinancialResultDeclarationNextYearId = CodeID
		,@nIsNextFinancialResultDeclared = CASE WHEN TWE.TradingWindowEventId IS NOT NULL THEN   1 ELSE  0 END
		 FROM com_Code C
		LEFT JOIN rul_TradingWindowEvent TWE ON C.CodeID = TWE.FinancialYearCodeId  AND TWE.EventTypeCodeId = @CODE_TRADING_WINDOW_EVENT_TYPE_FINANCIAL_RESULT
		where CodeGroupId = @CODEGROUP_FINANCIAL_YEAR AND [Description] like  @sTradingWindowSettingforFinancialResultDeclarationNextYear+'%'	
				
		SELECT @nCOInitialDisclosureCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 1
		SELECT @nInsiderInitialDisclosureCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 2
		SELECT @nCOPreclearanceCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 3
		SELECT @nCOTradeDetailsCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 4
		SELECT @nInsiderTradeDetailsCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 5
		SELECT @nCOContinuousDisclosuresCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 6
		SELECT @nInsiderContinuousDisclosuresCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 7
		SELECT @nCOSubmissiontoStockExchangeCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 8		
		SELECT @nCOPeriodEndDisclosuresCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 9
		SELECT @nInsiderPeriodEndDisclosuresCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 10
		SELECT @nPolicyDocumentAssociationtoUserCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 11
		SELECT @nTradingPolicyAssociationtoUserCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId = 12
		SELECT @nLoginCredentialsMailtoNewUserCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =13
		SELECT @nDefaultersCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =14
		SELECT @nTradingPolicydueforExpiryCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =15
		SELECT @nPolicyDocumentdueforExpiryCount=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =16
		SELECT @nTradingWindowSettingforFinancialResultDeclarationCurrentYearId=[Count] from tra_CoDashboardCount WHERE DashboardCountId =17
		SELECT @nTradingWindowSettingforFinancialResultDeclarationNextYearId=[Count] from tra_CoDashboardCount WHERE DashboardCountId =18
		SELECT @nDefaulter_Initial=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =19
		SELECT @nDefaulter_Continuous=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =20
		SELECT @nDefaulter_PE=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =21
		SELECT @nDefaulter_Preclearance=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =22
		SELECT @nDefaulter_TradingPlan=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =23
		SELECT @nDefaulter_ContraTrade=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =24
		SELECT @nDefaulter_TradedWithNonDesignatedDMAT=[Count] FROM tra_CoDashboardCount WHERE DashboardCountId =25			
		
		SELECT @nCOInitialDisclosureCount  AS InitialDisclosuresCOCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 1) AS IsChangedInitialDisclosuresCOCount
		,@nInsiderInitialDisclosureCount AS InitialDisclosuresInsiderCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 2) AS IsChangedInitialDisclosuresInsiderCount		
		,@nCOPreclearanceCount AS PreClearancesCOCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 3)  AS IsChangedPreClearancesCOCount		
		,@nCOTradeDetailsCount AS TradeDetailsCoCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 4)  AS IsChangedTradeDetailsCoCount		
		,@nInsiderTradeDetailsCount AS TradeDetailsInsiderCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 5)  AS IsChangedTradeDetailsInsiderCount		
		,@nCOContinuousDisclosuresCount AS ContinuousDisclosuresCOCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 6)  AS IsChangedContinuousDisclosuresCOCount
		,@nInsiderContinuousDisclosuresCount AS ContinuousDisclosuresInsiderCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 7)  AS IsChangedContinuousDisclosuresInsiderCount
		,@nCOSubmissiontoStockExchangeCount AS SubmissionToStockExchangeCOCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 8)  AS IsChangedSubmissionToStockExchangeCOCount
		,@nCOPeriodEndDisclosuresCount AS PeriodEndDisclosuresCOCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 9)  AS IsChangedPeriodEndDisclosuresCOCount
		,@nInsiderPeriodEndDisclosuresCount AS PeriodEndDisclosuresInsiderCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 10)  AS IsChangedPeriodEndDisclosuresInsiderCount
		,@nPolicyDocumentAssociationtoUserCount AS PolicyDocumentAssociationtoUserCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 11)  AS IsChangedPolicyDocumentAssociationtoUserCount
		,@nTradingPolicyAssociationtoUserCount AS TradingPolicyAssociationtoUserCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 12)  AS IsChangedTradingPolicyAssociationtoUserCount
		,@nLoginCredentialsMailtoNewUserCount AS LoginCredentialsMailtoNewUserCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 13)  AS IsChangedLoginCredentialsMailtoNewUserCount
		,@nDefaultersCount AS DefaultersCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 14)  AS IsChangedDefaultersCount
		,@nTradingPolicydueforExpiryCount AS TradingPolicydueforExpiryCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 15)  AS IsChangedTradingPolicydueforExpiryCount
		,@nPolicyDocumentdueforExpiryCount AS PolicyDocumentdueforExpiryCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 16)  AS IsChangedPolicyDocumentdueforExpiryCount
		,@sTradingWindowSettingforFinancialResultDeclarationCurrentYear AS TradingWindowSettingforFinancialResultDeclarationCurrentYear
		,@nTradingWindowSettingforFinancialResultDeclarationCurrentYearId AS TradingWindowSettingforFinancialResultDeclarationCurrentYearId
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 17)  AS IsChangedTradingWindowSettingforFinancialResultDeclarationCurrentYear
		,@sTradingWindowSettingforFinancialResultDeclarationNextYear AS TradingWindowSettingforFinancialResultDeclarationNextYear
		,@nTradingWindowSettingforFinancialResultDeclarationNextYearId AS TradingWindowSettingforFinancialResultDeclarationNextYearId
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 18)  AS IsChangedTradingWindowSettingforFinancialResultDeclarationNextYear
		,(SELECT CodeName FROM com_Code where CodeId = @CODE_CO_DASHBOARD_CONTACT_NUMBER) AS Contact
		,(SELECT CodeName FROM com_Code where CodeId = @CODE_CO_DASHBOARD_EMAIL) AS Email
		-- Defaulters count on dashboard
		,@nDefaulter_Initial AS DefaulterInitialDisclosureCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 19)  AS IsChangedDefaulterInitialDisclosureCount
		,@nDefaulter_Continuous AS DefaulterContinuousCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 20)  AS IsChangedDefaulterContinuousCount
		,@nDefaulter_PE AS DefaulterPECount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 21)  AS IsChangedDefaulterPECount
		,@nDefaulter_Preclearance AS DefaulterPCLCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 22)  AS IsChangedDefaulterPCLCount
		,@nDefaulter_TradingPlan AS DefaulterTrdPlanCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 23)  AS IsChangedDefaulterTrdPlanCount
		,@nDefaulter_ContraTrade AS DefaulterContraCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 24)  AS IsChangedDefaulterContraCount
		,@nDefaulter_TradedWithNonDesignatedDMAT AS DefaulterNonDesCount
		,(SELECT [Status] FROM tra_CoDashboardCount WHERE DashboardCountId = 25)  AS IsChangedDefaulterNonDesCount		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ''
	END CATCH
END
GO
