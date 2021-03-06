IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateCODashboardCnt')
DROP PROCEDURE [dbo].[st_tra_UpdateCODashboardCnt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to update DashBoard Count for CO.

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		07-Feb-2018

Modification History:
Modified By		Modified On		Description
Harish			23/4/2018		Corrected Defaulter Count,Initial Disclosures Count,Continuous Disclosures Count,Period End Disclosures Count,Pre-clearances Count,Contra Trade Count
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_UpdateCODashboardCnt]
AS
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
	DECLARE @TRANS_TYPE_DOC_UPLOADED_CONTINUOUS INT =148001
	DECLARE @TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS INT =148002
	DECLARE @PRE_MAP_TO_TYPE INT =132004
	DECLARE @PRE_APPROVED_TYPE INT =153016
	DECLARE @CODE_TRADING_POLICY_DAYS_FOR_EXPIRY INT = 168001, 
			@CODE_POLICY_DOCUMENT_DAYS_FOR_EXPIRY INT = 168002,
			@CODE_CO_DASHBOARD_CONTACT_NUMBER INT = 168003,
			@CODE_CO_DASHBOARD_EMAIL INT = 168004,
			@CODE_USER_TYPE_ADMIN INT = 101001, -- User type - Admin 101001
			@CODE_USER_TYPE_COMPLIANCE_OFFICER INT = 101002,  -- User type - Compliance Officer 101002
			@CODE_USER_TYPE_SUPER_ADMIN INT = 101005, -- User type - Super Admin 101005
			@CODE_USER_TYPE_RELATIVE INT = 101007, -- User type - Relative 101007
			@CODE_EVENT_INITIAL_DISCLOSURE_DETAILS_ENTERED INT = 153007, -- Event - Initial Disclosure details entered  153007
			@CODE_EVENT_INITIAL_DISCLOSURE_UPLOADED INT = 153008, -- Event - Initial Disclosure - Uploaded  153008
			@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_SOFTCOPY INT = 153009, -- Event - Initial Disclosure submitted - softcopy   153009
			@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_HARDCOPY INT = 153010, -- Event - Initial Disclosure submitted - hardcopy   153010
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED INT = 153019, -- Event - Continuous Disclosure details entered 153019
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED INT = 153020, -- Event - Continuous Disclosure - Uploaded      153020
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY INT = 153021, -- Event - Continuous Disclosure submitted - softcopy 153021
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_HARDCOPY INT = 153022, -- Event - Continuous Disclosure submitted - hardcopy 153022
			@CODE_EVENT_PERIOD_END_DISCLOSURE_DETAILS_ENTERED INT = 153029, -- Event - Period End Disclosure details entered 153029
			@CODE_EVENT_PERIOD_END_DISCLOSURE_UPLOADED INT = 153030, -- Event - Period End Disclosure - Uploaded 153030
			@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_SOFTCOPY INT = 153031, -- Event - Period End Disclosure submitted - softcopy 153031
			@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_HARDCOPY INT = 153032, -- Event - Period End Disclosure submitted - hardcopy 153032
			@CODE_EVENT_INITIAL_DISCLOSURE_CO_SUBMITTED_HARDCOPY_TO_STOCK_EXCHANGE INT = 153012, -- Event - Initial Disclosure - CO submitted hardcopy to Stock Exchange
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_CO_SUBMITTED_HARDCOPY_TO_STOCK_EXCHANGE INT = 153024, -- Event - Continuous Disclosure - CO submitted hardcopy to Stock Exchange 153024
			@CODE_EVENT_PERIOD_END_DISCLOSURE_CO_SUBMITTED_HARDCOPY_TO_STOCK_EXCHANGE INT = 153034, -- Event - Period End Disclosure - CO submitted hardcopy to Stock Exchange 153034
			@CODE_EVENT_CONTINUOUS_DISCLOSURE_CONFIRMED_CO INT = 153036, -- Event - Continuous Disclosure - Confirmed - 153036
			@CODE_MAP_TO_TYPE_DISCLOSURE_TRANSACTION INT = 132005, -- Map To Type - Disclosure Transaction
			@CODE_DISCLOSURE_TYPE_INITIAL INT = 147001, -- Disclosure Type - Initial 147001
			@CODE_DISCLOSURE_TYPE_CONTINUOUS INT = 147002, -- Disclosure Type - Continuous
			@CODE_DISCLOSURE_TYPE_PERIOD_END INT = 147003, -- Disclosure Type - Period End
			@CODE_USER_STATUS_ACTIVE INT = 102001, -- User Status - Active
			@CODE_TRADING_POLICY_STATUS_ACTIVE INT = 141002, -- Trading Policy Status - Active 141002
			@CODE_POLICY_DOCUMENT_WINDOW_STATUS_ACTIVE INT = 131002, -- Policy Document Window Status - Active 131002
			@CODE_COMMUNICATION_NOTIFICATION_STATUS_SUCCESS INT = 161001, -- Communication Notification Status - Success 161001
			@CODE_TRADING_WINDOW_EVENT_TYPE_FINANCIAL_RESULT INT = 126001, --  Trading Window Event Type - Financial Result 126001
			@CODE_PRECLEARANCE_STATUS_APPROVED INT = 144002, --  Preclearance Status - Approved 144002
			@CODEGROUP_FINANCIAL_YEAR INT = 125, --  CodeGroup Financial Year 125
			@CODE_PRECLEARENCE_PENDING INT=144001

	DECLARE @nConst_NonComplianceType_Initial INT = 170001,
			@nConst_NonComplianceType_PE INT = 170003,
			@nConst_NonComplianceType_PCL INT = 170004,
			@nComment_ContraTrade INT = 169007,
			@nDefaulter_Initial BIGINT,
			@nDefaulter_Continuous BIGINT = 0,
			@nDefaulter_PE BIGINT,
			@nDefaulter_Preclearance BIGINT,
			@nDefaulter_TradingPlan BIGINT = 0,
			@nDefaulter_ContraTrade BIGINT,
			@nDefaulter_TradedWithNonDesignatedDMAT BIGINT = 0

	DECLARE @dtYearStart DATETIME,
			@dtYearEnd DATETIME,
			@dtYearStartMinus1 DATETIME,
			@nCurrentYear INT,
			@nPendingTransType INT	

	DECLARE @nUserStatusInActive INT = 102002
						
	SET @nPendingTransType = 148002
		SET NOCOUNT ON;			
			
		SELECT @nTradingPolicyExpiryDays = CAST(CodeName AS INT) FROM com_Code where CodeId = @CODE_TRADING_POLICY_DAYS_FOR_EXPIRY
		SELECT @nPolicyDocumentExpiryDays = CAST(CodeName AS INT) FROM com_Code where CodeId = @CODE_POLICY_DOCUMENT_DAYS_FOR_EXPIRY
		
	
		
		--Defaulter Count
		--CREATE TABLE #DefaulterCountTemp(DefaulterReportID INT
		--, SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterCountTemp (DefaulterReportID, SecurityTypeCodeId)	(
		--		SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--		WHERE DR.InitialContinousPeriodEndDisclosureRequired IS NOT NULL)
								
		--SET @nDefaultersCount = (SELECT COUNT(*) AS DefaultersCount FROM #DefaulterCountTemp)

		CREATE TABLE #TempDefaulterCount
		(
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		)	
		INSERT INTO #TempDefaulterCount
			   EXEC sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=NULL,@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
		SET @nDefaultersCount = (SELECT COUNT(*) AS DefaulterContraTradeCount FROM #TempDefaulterCount)				
		DROP TABLE #TempDefaulterCount
		
		
		--Initial Disclosures 
		--CREATE TABLE #DefaulterIniDis(DefaulterReportID INT
		--,SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterIniDis (DefaulterReportID, SecurityTypeCodeId)(
		--	SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--		WHERE DR.NonComplainceTypeCodeId = 170001 AND DR.InitialContinousPeriodEndDisclosureRequired IS NOT NULL)
				
		--SET @nDefaulter_Initial = (SELECT COUNT(*) AS DefaulterInitialDisclosuresCount FROM #DefaulterIniDis)

		--Initial Disclosures Count getting from Defaulter List SP Output
		CREATE TABLE #TempDefaulterIniDis
		(
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		)	
		INSERT INTO #TempDefaulterIniDis
			   EXEC sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=N'170001',@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
		SET @nDefaulter_Initial = (SELECT COUNT(*) AS DefaulterContraTradeCount FROM #TempDefaulterIniDis)				
		DROP TABLE #TempDefaulterIniDis

		--Continuous Disclosures 
		--CREATE TABLE #DefaulterConDis(DefaulterReportID INT
		--,SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterConDis (DefaulterReportID, SecurityTypeCodeId)(
		--	SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--	WHERE DR.NonComplainceTypeCodeId = 170002 AND DR.InitialContinousPeriodEndDisclosureRequired IS NOT NULL)
			
		--SET @nDefaulter_Continuous = (SELECT COUNT(*) AS DefaulterContinuousDisclosuresCount FROM #DefaulterConDis)

		--Continuous Disclosures Count getting from Defaulter List SP Output
			CREATE TABLE #TempDefaulterConDis
		    (
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		    )	
		INSERT INTO #TempDefaulterConDis
			   EXEC sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=N'170002',@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
		SET @nDefaulter_Continuous = (SELECT COUNT(*) AS DefaulterContraTradeCount FROM #TempDefaulterConDis)		
			
		DROP TABLE #TempDefaulterConDis

		
		--Period End Disclosures
		--CREATE TABLE #DefaulterPerioDis(DefaulterReportID INT
		--,SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterPerioDis (DefaulterReportID, SecurityTypeCodeId)(
		--	SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--	WHERE DR.NonComplainceTypeCodeId = 170003  AND DR.InitialContinousPeriodEndDisclosureRequired IS NOT NULL)
			
		--SET @nDefaulter_PE = (SELECT COUNT(*) AS DefaulterPeriodEndDisclosuresCount FROM #DefaulterPerioDis)

		--Period End Disclosures Count getting from Defaulter List SP Output
			CREATE TABLE #TempDefaulterPerioDis
		    (
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		     )	
		INSERT INTO #TempDefaulterPerioDis
			   exec sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=N'170003',@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
			SET @nDefaulter_PE = (SELECT COUNT(*) AS DefaulterPeriodEndDisclosuresCount FROM #TempDefaulterPerioDis)
			
			
		DROP TABLE #TempDefaulterPerioDis
		
		
		--Pre-clearances 
		--CREATE TABLE #DefaulterPreClerDis(DefaulterReportID INT
		--,SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterPreClerDis (DefaulterReportID, SecurityTypeCodeId)(
		--	SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--	WHERE DR.NonComplainceTypeCodeId = 170004 AND DR.InitialContinousPeriodEndDisclosureRequired IS NOT NULL)
			
		--SET @nDefaulter_Preclearance = (SELECT COUNT(*) AS DefaulterPreclearancesCount FROM #DefaulterPreClerDis)

		--Pre-clearances Count getting from DefaulterList SP output
		CREATE TABLE #TempDefaulterPreClerDis
		(
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		)	
		INSERT INTO #TempDefaulterPreClerDis
			   exec sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=N'170004',@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL

		SET @nDefaulter_Preclearance = (SELECT COUNT(*) AS DefaulterPreclearancesCount FROM #TempDefaulterPreClerDis)	
		
		DROP TABLE #TempDefaulterPreClerDis

		
		--Contra Trade 
		--CREATE TABLE #DefaulterContraTrade(DefaulterReportID INT
		--,SecurityTypeCodeId VARCHAR(100))
		
		--INSERT INTO #DefaulterContraTrade (DefaulterReportID, SecurityTypeCodeId)(
		--	SELECT DR.DefaulterReportID,vwTD.SecurityTypeCodeId
		--		FROM rpt_DefaulterReport DR
		--		JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		--		LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
		--		LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
		--	WHERE DefRptCmt.CommentsID = '170004')
			
		--SET @nDefaulter_ContraTrade = (SELECT COUNT(*) AS DefaulterContraTradeCount FROM #DefaulterContraTrade)

		--Contra Trade Count getting from DefaulterList SP
		CREATE TABLE #TempDefaulterContraTrade
		(
				DefaulterReportID INT,
				rpt_grd_19272 NVARCHAR(50),
				UserInfoID INT,
				rpt_grd_19286 NVARCHAR(500),
				rpt_grd_19273 NVARCHAR(50),
				rpt_grd_19274 NVARCHAR(500),
				rpt_grd_19275 NVARCHAR(500),
				DateOfInactivation NVARCHAR(500),
				rpt_grd_19276 NVARCHAR(50),
				rpt_grd_19277 NVARCHAR(100),
				rpt_grd_19278 NVARCHAR(100),
				rpt_grd_19279 NVARCHAR(500),
				rpt_grd_19280 NVARCHAR(500),
				Category VARCHAR(50),
				SubCategory VARCHAR(50),
				[Status] VARCHAR(50),
				rpt_grd_19281 NVARCHAR(500),
				rpt_grd_19282 NVARCHAR(500) ,
				rpt_grd_19283 NVARCHAR(100), 
				rpt_grd_19284 NVARCHAR(100),
				rpt_grd_19285 NVARCHAR(100),
				rpt_grd_19287 NVARCHAR(500),
				rpt_grd_19288 NVARCHAR(500),
				rpt_grd_19289 NVARCHAR(500),
				rpt_grd_19290 NVARCHAR(100),
				rpt_grd_19291 NVARCHAR(500),
				rpt_grd_19292 NVARCHAR(500),
				rpt_grd_19293 NVARCHAR(500),
				rpt_grd_19294 NVARCHAR(500),
				rpt_grd_19295 NVARCHAR(500),
				rpt_grd_19296 NVARCHAR(500),
				rpt_grd_19298 NVARCHAR(500),
				rpt_grd_19299 NVARCHAR(500),
				rpt_grd_19300 NVARCHAR(500),
				rpt_grd_19301 NVARCHAR(500),
				rpt_grd_19302 NVARCHAR(500),
				rpt_grd_19303 NVARCHAR(500),
				rpt_grd_19304 NVARCHAR(500),
				rpt_grd_19305 NVARCHAR(500),
				rpt_grd_19307 NVARCHAR(500),
				rpt_grd_19308 NVARCHAR(500),
				rpt_grd_19309 NVARCHAR(1000),
				rpt_grd_19310 NVARCHAR(500),
				rpt_grd_19311 NVARCHAR(100),
				ISRemoveFromList INT,
				PreclearanceBlankComment INT,
				AddOtherDetails INT,
				ISParentPreclearance INT,
				IsShowRecord INT
		)	
		INSERT INTO #TempDefaulterContraTrade
			   EXEC sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',@0=114078,@1=0,@2=0,@3=N'rpt_grd_19272',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=NULL,@31=N'169007',@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
		SET @nDefaulter_ContraTrade = (SELECT COUNT(*) AS DefaulterContraTradeCount FROM #TempDefaulterContraTrade)		
		DROP TABLE #TempDefaulterContraTrade
			
	
	---------------------------- Initial Disclosure --------------------------------------------------------
		SELECT @nInsiderInitialDisclosureCount=COUNT(UF.UserInfoId) 
		FROM 
		usr_UserInfo UF 
		WHERE 
		UserInfoId NOT IN(SELECT UserInfoId FROM tra_TransactionMaster WHERE DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_INITIAL AND TransactionStatusCodeId!=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS)
		AND UserTypeCodeId NOT IN (@CODE_USER_TYPE_ADMIN,@CODE_USER_TYPE_COMPLIANCE_OFFICER,@CODE_USER_TYPE_SUPER_ADMIN,@CODE_USER_TYPE_RELATIVE)
		AND StatusCodeId <> @nUserStatusInActive

		SELECT @nCOInitialDisclosureCount=COUNT(EL.UserInfoId) 
		FROM 
		eve_EventLog EL JOIN tra_TransactionMaster TM ON TM.TransactionMasterId=EL.MapToId
		WHERE
		EL.EventCodeId IN(@CODE_EVENT_INITIAL_DISCLOSURE_UPLOADED) AND EL.MapToId NOT IN(SELECT EL.MapToId FROM eve_EventLog EL WHERE EL.EventCodeId IN(@CODE_EVENT_INITIAL_DISCLOSURE_DETAILS_ENTERED))
	---------------------------- End Initial Disclosure --------------------------------------------------------
	
	---------------------------- Preclearance --------------------------------------------------------
		SELECT @nCOPreclearanceCount = Count(PreclearanceRequestId) FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId = @CODE_PRECLEARENCE_PENDING
	---------------------------- End Preclearance --------------------------------------------------------

	---------------------------- Trade Details --------------------------------------------------------	
		SELECT @nInsiderTradeDetailsCount  =COUNT(*) 
		FROM
	    (SELECT tra_TransactionMaster.TransactionMasterId FROM tra_TransactionMaster 			
		WHERE TransactionStatusCodeId=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS AND DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_CONTINUOUS AND PreclearanceRequestId IS NULL	
		UNION		
		SELECT 
		tra_TransactionMaster.TransactionMasterId 
		FROM  tra_TransactionMaster JOIN tra_PreclearanceRequest ON tra_PreclearanceRequest.PreclearanceRequestId=tra_TransactionMaster.PreclearanceRequestId 
		JOIN eve_EventLog ON eve_EventLog.MapToId=tra_PreclearanceRequest.PreclearanceRequestId
		WHERE
		TransactionStatusCodeId=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS AND DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_CONTINUOUS  
		AND MapToTypeCodeId = @PRE_MAP_TO_TYPE AND EventCodeId IN (@PRE_APPROVED_TYPE)AND PreclearanceStatusCodeId=@CODE_PRECLEARANCE_STATUS_APPROVED
		AND IsPartiallyTraded!=2
		UNION
		SELECT TM.TransactionMasterId
		FROM 
		tra_PreclearanceRequest PR 	JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId AND ParentTransactionMasterId IS NULL
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		WHERE 
		IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = @CODE_PRECLEARANCE_STATUS_APPROVED  AND ShowAddButton = 1
		) InsiderTradeDetails

		SELECT @nCOTradeDetailsCount =COUNT(tra_TransactionMaster.TransactionMasterId) 
		FROM 
		tra_TransactionMaster JOIN eve_EventLog ON tra_TransactionMaster.TransactionMasterId=eve_EventLog.MapToId 			
		WHERE 
		TransactionStatusCodeId=@TRANS_TYPE_DOC_UPLOADED_CONTINUOUS AND DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_CONTINUOUS AND 
		MapToTypeCodeId = @CODE_MAP_TO_TYPE_DISCLOSURE_TRANSACTION
		AND EventCodeId = @CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED
-------------------------------- END Trade Details --------------------------------------------------------		

	---------------------------- Continuous Disclosures --------------------------------------------------------	
		SELECT @nCOContinuousDisclosuresCount=COUNT(TM.TransactionMasterId) 
		FROM 
		tra_TransactionMaster TM JOIN eve_EventLog EL
		ON TM.TransactionMasterId=EL.MapToId
		WHERE 
		EventCodeId=(@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED) AND MapToId in(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED))
		AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY))
		AND TM.SoftCopyReq=1
 
		SELECT @nInsiderContinuousDisclosuresCount=COUNT(TM.TransactionMasterId) 
		FROM 
		tra_TransactionMaster TM JOIN eve_EventLog EL
		ON TM.TransactionMasterId=EL.MapToId
		WHERE 
		EventCodeId=(@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED) AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED))
		AND MapToId NOT IN(SELECT MapToId FROM eve_EventLog WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY))
		AND TM.SoftCopyReq=1
		
	-----------------------------End Continuous Disclosures --------------------------------------------------------
	
	---------------------------- Submission to Stock Exchange  --------------------------------------------------------
		SELECT @nCOSubmissiontoStockExchangeCount=COUNT(EL.MapToId) 
		FROM 
		tra_TransactionMaster TM JOIN
		eve_EventLog EL ON TM.TransactionMasterId=EL.MapToId
		WHERE 
		EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_HARDCOPY) AND TM.DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_CONTINUOUS
		AND EL.MapToId NOT IN (SELECT EL.MapToId FROM tra_TransactionMaster TM JOIN eve_EventLog EL ON TM.TransactionMasterId=EL.MapToId
		WHERE EventCodeId IN(@CODE_EVENT_CONTINUOUS_DISCLOSURE_CO_SUBMITTED_HARDCOPY_TO_STOCK_EXCHANGE) AND TM.DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_CONTINUOUS)
		---------------------------- END Submission to Stock Exchange  --------------------------------------------------------

	---------------------------- Start Period End  --------------------------------------------------------	
		declare	@inp_sEmployeeId				NVARCHAR(50) = null,
		@inp_sInsiderName					NVARCHAR(50) = null,
		@inp_iDesignation					NVARCHAR(50) = null,
	
		@inp_dtTradingSubmiitedFrom			NVARCHAR(25) = null,
		@inp_dtTradingSubmiitedTo			NVARCHAR(25) = null,
		@inp_iTradingSubmiitedStatus		INT = null,

		@inp_dtSoftCopySubmiitedFrom		NVARCHAR(25) = null,
		@inp_dtSoftCopySubmiitedTo			NVARCHAR(25) = null,
		@inp_iSoftCopySubmiitedStatus		INT = null,
		
		@inp_dtHardCopySubmiitedFrom		NVARCHAR(25) = null,
		@inp_dtHardCopySubmiitedTo			NVARCHAR(25) = null,
		@inp_iHardCopySubmiitedStatus		INT = null,

		@inp_dtStockExchangeSubmiitedFrom	NVARCHAR(25) = null,
		@inp_dtStockExchangeSubmiitedTo		NVARCHAR(25) = null,
		@inp_iStockExchangeSubmiitedStatus	INT = null
	
	BEGIN
		DECLARE @ERR_PERIODENDDISCLOSURE_USERSSTATUS	INT = 17173 -- Error occurred while fetching users list of period end disclosure.
		DECLARE @dtCurrentDate 							DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
		DECLARE @nPeriodType 							INT
		DECLARE @nPeriodYear 							INT
		DECLARE @dtPeriodStartDate						DATETIME	
		DECLARE @sSQL									NVARCHAR(MAX) = ''	
		DECLARE @nStatusFlag_Complete					INT = 154001
		DECLARE @nStatusFlag_Pending					INT = 154002
		DECLARE @nStatusFlag_DoNotShow					INT = 154003
		DECLARE @nStatusFlag_Uploaded					INT = 154006
		DECLARE @nStatusFlag_NotRequired				INT = 154007
		DECLARE @nTradingPolicyId						INT
		DECLARE @nDiscloPeriodEndToCOByInsdrLimit		INT = 0
		DECLARE @nDiscloPeriodEndSubmitToStExByCOLimit	INT = 0	
		DECLARE @sPeriodEndDisclosure_Pending			VARCHAR(255)
		DECLARE @sPolicyDocumentStatus_NotRequired		VARCHAR(255)
		DECLARE @sUploadedButtonText					VARCHAR(255)	
		DECLARE @nYear									INT
		DECLARE @nYearCodeId							INT		
		DECLARE @nExchangeTypeCodeId_NSE				INT = 116001
		
		DECLARE @nEmployeeStatusLive                                                VARCHAR(100),
				@nEmployeeStatusSeparated                                           VARCHAR(100),
				@nEmployeeStatusInactive                                            VARCHAR(100),
				@nEmpStatusLiveCode                                                 INT = 510001,
				@nEmpStatusSeparatedCode                                            INT = 510002,
				@nEmpStatusInactiveCode                                             INT = 510003,
				@nEmployeeActive                                                    INT = 102001,
				@nEmployeeInActive                                                  INT = 102002		
			
			CREATE TABLE #tmpPeriodEndDisclosureUserList
				(Id INT IDENTITY(1,1), UserInfoId INT, EmployeeId NVARCHAR(512), InsiderName NVARCHAR(512), 
				CompanyId INT, CompanyName NVARCHAR(512), UserType INT, DesignationId INT, Designation NVARCHAR(512),UserPanNumber NVARCHAR(50),EmpStatus INT,
				DateOfBecomingInsider DATETIME, DateOfSeparation DATETIME, TradingPolicyId INT, TransactionMasterId INT, 
				
				SubmissionLastDate DATETIME, SubmissionByCOLastDate DATETIME,
				SubmissionEventDate DATETIME, SubmissionButtonText NVARCHAR(255), SubmissionStatusCodeId INT DEFAULT 154003,
				
				ScpReq INT DEFAULT 0, 
				ScpEventDate DATETIME, ScpButtonText NVARCHAR(255), ScpStatusCodeId INT DEFAULT 154003,
				
				HCpReq INT DEFAULT 0, 
				HcpEventDate DATETIME, HcpButtonText NVARCHAR(255), HcpStatusCodeId INT DEFAULT 154003,
				
				HCpByCOReq INT DEFAULT 0,
				HCpByCOEventDate DATETIME, HCpByCOButtonText NVARCHAR(255), HCpByCOStatusCodeId INT DEFAULT 154003,
				
				DiscloPeriodEndToCOByInsdrLimit INT, DiscloPeriodEndSubmitToStExByCOLimit INT,
				SubmissionDaysRemaining INT DEFAULT -1, SubmissionDaysRemainingByCO INT DEFAULT -1,
				YearCodeId INT, PeriodTypeId INT,PeriodType varchar(50), PeriodCodeId INT, PeriodEndDate DATETIME, IsThisCurrentPeriodEnd INT DEFAULT 0, 
				InitialDisclosureDate DATETIME,IsUploadAndEnterEventGenerate INT DEFAULT 0
				)		
			
			SELECT @sPeriodEndDisclosure_Pending = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
			SELECT @sPolicyDocumentStatus_NotRequired = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17334'
			
			SELECT @sUploadedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17075'
			
			SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode   
				
			SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode  
				
			SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
			
			-- Get list of user who are insider between start and end of period and also apply filter if defined
			INSERT INTO #tmpPeriodEndDisclosureUserList 
				(UserInfoId, EmployeeId, InsiderName, CompanyId, CompanyName, UserType, DesignationId, Designation, UserPanNumber, EmpStatus,DateOfBecomingInsider, 
				DateOfSeparation, PeriodEndDate)
			SELECT 
				UI.UserInfoId, UI.EmployeeId, 
				CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END as InsiderName, 
				UI.CompanyId, Com.CompanyName, UI.UserTypeCodeId as UserType, UI.DesignationId,
				CASE WHEN UI.DesignationId IS NULL THEN UI.DesignationText ELSE 
					(CASE WHEN CD.DisplayCode IS NULL OR CD.DisplayCode = '' THEN CD.CodeName ELSE CD.DisplayCode END) END as Designation,
				UI.PAN AS UserPanNumber,
				CASE WHEN UI.StatusCodeId = @nEmployeeActive AND UI.DateOfSeparation IS NULL THEN @nEmpStatusLiveCode
								WHEN UI.StatusCodeId = @nEmployeeActive AND UI.DateOfSeparation IS NOT NULL THEN @nEmpStatusSeparatedCode
								WHEN UI.StatusCodeId = @nEmployeeInActive THEN @nEmpStatusInactiveCode
								END AS EmpStatus,
				UI.DateOfBecomingInsider, UI.DateOfSeparation, LastPeriodEndUser.PeriodEndDate
			From 
				(
					SELECT UserInfoId, MAX(PeriodEndDate) as PeriodEndDate FROM vw_PeriodEndDisclosureStatus vwPEDS
					GROUP BY UserInfoId
				) AS LastPeriodEndUser LEFT JOIN usr_UserInfo UI ON LastPeriodEndUser.UserInfoId = UI.UserInfoId			
				LEFT JOIN mst_Company Com on UI.CompanyId = Com.CompanyId
				LEFT JOIN com_Code CD on UI.DesignationId IS NOT NULL AND UI.DesignationId = CD.CodeID
			WHERE 
				UI.UserTypeCodeId in (101003, 101004, 101006) 
				AND UI.DateOfBecomingInsider IS NOT NULL 
				AND (@inp_sEmployeeId IS NULL OR (@inp_sEmployeeId <> '' AND UI.EmployeeId LIKE N'%'+@inp_sEmployeeId+'%'))
				AND (@inp_sInsiderName IS NULL OR (@inp_sInsiderName <> '' AND 
					CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END like N'%'+@inp_sInsiderName+'%'))
				AND (@inp_iDesignation IS NULL OR (@inp_iDesignation <> '' AND 
					CASE WHEN UI.DesignationId IS NULL THEN UI.DesignationText ELSE 
						(CASE WHEN CD.DisplayCode IS NULL OR CD.DisplayCode = '' THEN CD.CodeName ELSE CD.DisplayCode END) END LIKE N'%'+@inp_iDesignation+'%'))
						   
			UPDATE Tmp
			SET 
				TransactionMasterId = vwPEDS.TransactionMasterId,
				
				SubmissionEventDate = vwPEDS.DetailsSubmitDate,
				SubmissionStatusCodeId = CASE 
											WHEN vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_Complete 
											WHEN vwPEDS.DetailsSubmitStatus = 2 THEN @nStatusFlag_Uploaded 
											ELSE @nStatusFlag_DoNotShow END,
				
				ScpReq = vwPEDS.SoftCopyReq,
				ScpEventDate = vwPEDS.ScpSubmitDate,
				ScpStatusCodeId = CASE 
									WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.DetailsSubmitStatus = 1 THEN -- if soft copy is required 
										(CASE 
											WHEN vwPEDS.ScpSubmitStatus = 0 THEN @nStatusFlag_Pending
											WHEN vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_Complete
											ELSE @nStatusFlag_DoNotShow END)
									-- if soft copy is NOT required 
									WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_NotRequired 
									ELSE @nStatusFlag_DoNotShow END,
				
				HCpReq = vwPEDS.HardCopyReq,
				HcpEventDate = vwPEDS.HcpSubmitDate,
				HcpStatusCodeId = CASE 
									WHEN vwPEDS.HardCopyReq = 1 AND vwPEDS.DetailsSubmitStatus = 1 THEN -- if hard copy is required 
										(CASE 
											-- if soft copy is required 
											WHEN vwPEDS.SoftCopyReq = 1 THEN 
												(CASE 
													WHEN vwPEDS.ScpSubmitStatus = 0 THEN  @nStatusFlag_DoNotShow
													WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 0 THEN  @nStatusFlag_Pending
													WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 THEN  @nStatusFlag_Complete
													ELSE @nStatusFlag_DoNotShow END)
											-- if soft copy is NOT required 
											ELSE 
												(CASE 
													WHEN vwPEDS.HcpSubmitStatus = 0 THEN @nStatusFlag_Pending 
													WHEN vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_Complete 
													ELSE @nStatusFlag_DoNotShow END)
											END) 
									-- if hard copy is NOT required 
									WHEN vwPEDS.HardCopyReq = 0 AND vwPEDS.DetailsSubmitStatus = 1 THEN
										(CASE 
											-- if soft copy is required 
											WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_NotRequired
											-- if soft copy is NOT required 
											WHEN vwPEDS.SoftCopyReq = 0 THEN @nStatusFlag_NotRequired 
											ELSE @nStatusFlag_DoNotShow END)
									ELSE @nStatusFlag_DoNotShow END,
									
				HCpByCOReq = vwPEDS.HCpByCOReq,
				HCpByCOEventDate = vwPEDS.HCpByCOSubmitDate,
				HCpByCOStatusCodeId = CASE 
										WHEN vwPEDS.DetailsSubmitStatus = 1 THEN 
											(CASE 
												WHEN vwPEDS.HcpByCOReq = 1 THEN 
													(CASE 
														-- if soft copy and hard copy both are required 
														WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 1 THEN 
															(CASE 
																WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
																WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
																ELSE @nStatusFlag_DoNotShow END)
														-- if only soft copy is are required 
														WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 0 THEN 
															(CASE 
																WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
																WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
																ELSE @nStatusFlag_DoNotShow END)
														-- if only hard copy is are required 
														WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 1 THEN 
															(CASE 
																WHEN vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
																WHEN vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
																ELSE @nStatusFlag_DoNotShow END)
														WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 0 THEN @nStatusFlag_Pending
														ELSE @nStatusFlag_DoNotShow END)
												ELSE -- Stock exchange submission not required  
													(CASE 
														-- if soft copy and hard copy both are required 
														WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 1 THEN 
															(CASE 
																WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
																ELSE @nStatusFlag_DoNotShow END)
														-- if only soft copy is are required 
														WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 0 THEN 
															(CASE 
																WHEN vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
																ELSE @nStatusFlag_DoNotShow END)
														-- if only hard copy is are required 
														WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 1 THEN 
															(CASE 
																WHEN vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
																ELSE @nStatusFlag_DoNotShow END)
														ELSE @nStatusFlag_NotRequired END)
												END)
										ELSE @nStatusFlag_DoNotShow END
										
			FROM #tmpPeriodEndDisclosureUserList Tmp JOIN vw_PeriodEndDisclosureStatus vwPEDS ON
					Tmp.UserInfoId = vwPEDS.UserInfoId AND CONVERT(date,Tmp.PeriodEndDate) = CONVERT(date,vwPEDS.PeriodEndDate)
			
			-- Update trading policy id and submission last date for those had transaction 
			UPDATE Tmp
			SET
				TradingPolicyId = UPEMap.TradingPolicyId,
				PeriodTypeId = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
								ELSE TP.DiscloPeriodEndFreq 
							END,
				PeriodType = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN (select CodeName from com_code where codeId='123001') -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN (select CodeName from com_code where codeId='123003') -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN (select CodeName from com_code where codeId='123004') -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN (select CodeName from com_code where codeId='123002') -- half yearly
								ELSE (select CodeName from com_code where codeId=TP.DiscloPeriodEndFreq) 
							END,
				DiscloPeriodEndToCOByInsdrLimit = TP.DiscloPeriodEndToCOByInsdrLimit,
				SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)),-- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), TM.PeriodEndDate),
				DiscloPeriodEndSubmitToStExByCOLimit = TP.DiscloPeriodEndSubmitToStExByCOLimit,
				SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), TM.PeriodEndDate)
			FROM #tmpPeriodEndDisclosureUserList Tmp 
			JOIN tra_TransactionMaster TM ON Tmp.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_UserPeriodEndMapping UPEMap ON CONVERT(date, UPEMap.PEEndDate) = CONVERT(date, TM.PeriodEndDate) AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
			WHERE Tmp.TransactionMasterId IS NOT NULL			
			
			DECLARE @dtLastPeriodEndDate DATETIME
			DECLARE @nTempId INT
		
			DECLARE PE_Cursor CURSOR FOR 
			SELECT Id, PeriodEndDate FROM #tmpPeriodEndDisclosureUserList
			
			OPEN PE_Cursor			
			FETCH NEXT FROM PE_Cursor INTO @nTempId, @dtLastPeriodEndDate
			
			WHILE @@FETCH_STATUS = 0
			BEGIN 
				SELECT @nYear = YEAR(@dtLastPeriodEndDate)
				
				IF MONTH(@dtLastPeriodEndDate) < 4
				BEGIN
					SET @nYear = @nYear - 1
				END
				
				SELECT @nYearCodeId = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'
				-- set period for which period end is done
				UPDATE tmp 
				SET
					YearCodeId = @nYearCodeId,
					PeriodCodeId = CdPeriod.CodeID
				FROM #tmpPeriodEndDisclosureUserList tmp 
				JOIN rul_TradingPolicy TP ON tmp.TradingPolicyId = TP.TradingPolicyId AND tmp.Id = @nTempId
				JOIN com_Code CdPeriod ON CdPeriod.ParentCodeId = tmp.PeriodTypeId and CdPeriod.CodeGroupId = 124 
						and CONVERT(date, tmp.PeriodEndDate) = CONVERT(date, DATEADD(DAY, -1, DATEADD(YEAR, @nYear-1970,convert(datetime, CdPeriod.Description))))
				
				FETCH NEXT FROM PE_Cursor INTO @nTempId, @dtLastPeriodEndDate
			END
			
			CLOSE PE_Cursor;
			DEALLOCATE  PE_Cursor;		
			
			--Update submission date records which does not have Transaction master id
			UPDATE Tmp 
			SET 
				SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), Tmp.PeriodEndDate),
				SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) --DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), Tmp.PeriodEndDate)
			FROM #tmpPeriodEndDisclosureUserList Tmp LEFT JOIN rul_TradingPolicy TP ON Tmp.TradingPolicyId = TP.TradingPolicyId 
			WHERE Tmp.TransactionMasterId IS NULL and Tmp.TradingPolicyId <> 0

			-- Update Initial disclosure date
			UPDATE Tmp
			SET
				InitialDisclosureDate = EL.EventDate
			FROM #tmpPeriodEndDisclosureUserList Tmp LEFT JOIN eve_EventLog EL on 
					Tmp.UserInfoId=EL.UserInfoId AND MapToTypeCodeId = 132005 AND EventCodeId = 153035
			
			-- Update Submission text and status
			UPDATE Tmp
			SET
				SubmissionStatusCodeId = @nStatusFlag_Pending,
				SubmissionButtonText = @sPeriodEndDisclosure_Pending
			FROM #tmpPeriodEndDisclosureUserList Tmp 
			WHERE Tmp.TradingPolicyId <> 0 AND Tmp.PeriodEndDate < @dtCurrentDate 
					AND (Tmp.InitialDisclosureDate IS NOT NULL AND CONVERT(date, Tmp.InitialDisclosureDate) <= Tmp.PeriodEndDate)
					AND Tmp.SubmissionEventDate IS NULL
			
			-- update records whos period end date is today ie last day of month 
			UPDATE Tmp
			SET
				SubmissionStatusCodeId = @nStatusFlag_DoNotShow,
				SubmissionButtonText = NULL
			FROM #tmpPeriodEndDisclosureUserList Tmp
			WHERE Tmp.TradingPolicyId <> 0 AND Tmp.PeriodEndDate = @dtCurrentDate 
					AND (Tmp.InitialDisclosureDate IS NOT NULL AND Tmp.InitialDisclosureDate < Tmp.PeriodEndDate)
					AND Tmp.SubmissionEventDate IS NULL
			
			-- Apply trading filter - from date, to date and status
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE @inp_iTradingSubmiitedStatus IS NOT NULL AND SubmissionStatusCodeId <> @inp_iTradingSubmiitedStatus
			
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE 
				(@inp_dtTradingSubmiitedFrom IS NOT NULL AND SubmissionEventDate < @inp_dtTradingSubmiitedFrom) OR
				(@inp_dtTradingSubmiitedTo IS NOT NULL AND SubmissionEventDate > @inp_dtTradingSubmiitedTo)
			
			
			-- Apply soft copy filter - from date, to date and status
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE @inp_iSoftCopySubmiitedStatus IS NOT NULL AND ScpStatusCodeId <> @inp_iSoftCopySubmiitedStatus
			
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE 
				(@inp_dtSoftCopySubmiitedFrom IS NOT NULL AND ScpEventDate < @inp_dtSoftCopySubmiitedFrom) OR
				(@inp_dtSoftCopySubmiitedTo IS NOT NULL AND ScpEventDate > @inp_dtSoftCopySubmiitedTo)
			
			
			-- Apply hard copy filter - from date, to date and status
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE @inp_iHardCopySubmiitedStatus IS NOT NULL AND HcpStatusCodeId <> @inp_iHardCopySubmiitedStatus
			
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE 
				(@inp_dtHardCopySubmiitedFrom IS NOT NULL AND HcpEventDate < @inp_dtHardCopySubmiitedFrom) OR
				(@inp_dtHardCopySubmiitedTo IS NOT NULL AND HcpEventDate > @inp_dtHardCopySubmiitedTo)			

			-- Apply stock exc filter - from date, to date and status
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE @inp_iStockExchangeSubmiitedStatus IS NOT NULL AND HCpByCOStatusCodeId <> @inp_iStockExchangeSubmiitedStatus
			
			DELETE FROM #tmpPeriodEndDisclosureUserList 
			WHERE 
				(@inp_dtStockExchangeSubmiitedFrom IS NOT NULL AND HCpByCOEventDate < @inp_dtStockExchangeSubmiitedFrom) OR
				(@inp_dtStockExchangeSubmiitedTo IS NOT NULL AND HCpByCOEventDate > @inp_dtStockExchangeSubmiitedTo)

			-- Update Submission days remaining
			UPDATE #tmpPeriodEndDisclosureUserList
			SET SubmissionDaysRemaining = CASE WHEN SubmissionLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtCurrentDate, NULL, SubmissionLastDate, 0, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END, --DATEDIFF(D, @dtCurrentDate, SubmissionLastDate)
				SubmissionDaysRemainingByCO = CASE WHEN SubmissionByCOLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtCurrentDate, NULL, SubmissionByCOLastDate, 0, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END -- DATEDIFF(D, @dtCurrentDate, SubmissionByCOLastDate)
			WHERE PeriodEndDate <= @dtCurrentDate
			
			-- Update button text for fields which has pending status
			UPDATE Tmp
			SET
				SubmissionButtonText = CASE WHEN SubmissionStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
										WHEN SubmissionStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
										WHEN SubmissionStatusCodeId = @nStatusFlag_Uploaded THEN @sUploadedButtonText
										ELSE NULL END,
				ScpButtonText = CASE WHEN ScpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
								WHEN ScpStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
								ELSE NULL END,
				HcpButtonText = CASE WHEN HcpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
								WHEN HcpStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
								ELSE NULL END,
				HCpByCOButtonText = CASE WHEN HCpByCOStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
									WHEN HCpByCOStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
									ELSE NULL END
			FROM #tmpPeriodEndDisclosureUserList Tmp 
			WHERE Tmp.TransactionMasterId IS NOT NULL			
			
			--update IsCurrentPeriodEnd flag 
			UPDATE Tmp 
			SET Tmp.IsThisCurrentPeriodEnd = 1 
			FROM #tmpPeriodEndDisclosureUserList Tmp	
			
			UPDATE Tmp
			SET IsUploadAndEnterEventGenerate = 1
			FROM #tmpPeriodEndDisclosureUserList Tmp
			JOIN eve_EventLog EL ON EL.MapToId = Tmp.TransactionMasterId AND EL.MapToTypeCodeId = 132005
			WHERE SubmissionStatusCodeId = 154001 AND EL.EventCodeId = 153030	
			
			SELECT			
				@nInsiderPeriodEndDisclosuresCount=COUNT(UserInfoId)		
			FROM #tmpPeriodEndDisclosureUserList
			where SubmissionStatusCodeId=154002
			
			select @nCOPeriodEndDisclosuresCount=COUNT( distinct EL.UserInfoId) from #tmpPeriodEndDisclosureUserList tPE join eve_EventLog EL
			on tPE.UserInfoId=EL.UserInfoId
			 where  EventCodeId in(153030) and EventCodeId not in(153031)		
			DROP TABLE #tmpPeriodEndDisclosureUserList	
		END
	---------------------------- END Period End  --------------------------------------------------------	
	
	
	---------------------------- Trading Policy due for Expiry   --------------------------------------------------------	

		SELECT @nTradingPolicydueforExpiryCount = COUNT(TradingPolicyId) 
		FROM [rul_TradingPolicy]
		WHERE ApplicableToDate <  DateAdd(day,@nTradingPolicyExpiryDays,dbo.uf_com_GetServerDate()) AND ApplicableToDate >= dbo.uf_com_GetServerDate()
			AND TradingPolicyStatusCodeId = @CODE_TRADING_POLICY_STATUS_ACTIVE -- Active
	---------------------------- END Trading Policy due for Expiry   --------------------------------------------------------	 
	---------------------------- Policy Document due for Expiry  --------------------------------------------------------	 
		SELECT @nPolicyDocumentdueforExpiryCount = COUNT(PolicyDocumentId) 
		FROM rul_PolicyDocument
		WHERE ApplicableTo <  DateAdd(day,@nPolicyDocumentExpiryDays,dbo.uf_com_GetServerDate()) AND ApplicableTo >= dbo.uf_com_GetServerDate()
			AND WindowStatusCodeId = @CODE_POLICY_DOCUMENT_WINDOW_STATUS_ACTIVE-- Active
	---------------------------- END Policy Document due for Expiry  --------------------------------------------------------	
	
	---------------------------- Login Credentials Mail to New User  --------------------------------------------------------		
		SELECT @nLoginCredentialsMailtoNewUserCount = COUNT(UI.UserInfoId)    
		FROM usr_UserInfo UI
		LEFT JOIN cmu_NotificationQueue NQ ON UI.UserInfoId = NQ.UserId AND ModeCodeId = 156002
		LEFT JOIN cmu_CommunicationRuleMaster CR ON NQ.RuleModeId = CR.RuleId AND CR.TriggerEventCodeId like '%153001%' 
		WHERE UI.StatusCodeId = @CODE_USER_STATUS_ACTIVE
			AND (NQ.UserId IS NULL OR NQ.ResponseStatusCodeId != @CODE_COMMUNICATION_NOTIFICATION_STATUS_SUCCESS)
			AND UI.UserTypeCodeId NOT IN (@CODE_USER_TYPE_ADMIN, @CODE_USER_TYPE_SUPER_ADMIN, @CODE_USER_TYPE_RELATIVE)	
	---------------------------- END Login Credentials Mail to New User  --------------------------------------------------------	
	---------------------------- Policy Document Association to User   --------------------------------------------------------	
		SELECT @nPolicyDocumentAssociationtoUserCount =COUNT(UserInfoId)  FROM usr_UserInfo 
		WHERE UserInfoId NOT IN (SELECT AM.UserId
								  FROM [vw_ApplicabilityMasterCurrentPolicyDocument] VAM
								  INNER JOIN rul_ApplicabilityDetails AM ON  VAM.ApplicabilityId = AM.ApplicabilityMstId  
								  WHERE AM.UserId IS NOT NULL)	
				AND UserTypeCodeId NOT IN (@CODE_USER_TYPE_ADMIN, @CODE_USER_TYPE_COMPLIANCE_OFFICER, @CODE_USER_TYPE_SUPER_ADMIN, @CODE_USER_TYPE_RELATIVE)			
	---------------------------- END Policy Document Association to User   --------------------------------------------------------	
	---------------------------- Trading Document Association to User   --------------------------------------------------------		
		SELECT @nTradingPolicyAssociationtoUserCount =COUNT(UserInfoId) 	
		FROM usr_UserInfo WHERE UserInfoId NOT IN (SELECT AM.UserId
													FROM [vw_ApplicabilityMasterCurrentTradingPolicy] VAM
													INNER JOIN rul_ApplicabilityDetails AM ON  VAM.ApplicabilityId = AM.ApplicabilityMstId  
													WHERE AM.UserId IS NOT NULL)			
		AND UserTypeCodeId NOT IN (@CODE_USER_TYPE_ADMIN, @CODE_USER_TYPE_COMPLIANCE_OFFICER, @CODE_USER_TYPE_SUPER_ADMIN, @CODE_USER_TYPE_RELATIVE)		
	---------------------------- END Trading Document Association to User   --------------------------------------------------------	
	
	---------------------------- Trading Window Setting for Financial Result Declaration   --------------------------------------------------------	
			
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
			
	---------------------------- END Trading Window Setting for Financial Result Declaration   --------------------------------------------------------		
	
		--------------------------- Defaulter counts START -------------------------------------------------------------------------------------
	
		SELECT @nCurrentYear = DATEPART(YEAR, dbo.uf_com_GetServerDate())
		SELECT @dtYearEnd = DATEADD(DAY, -1, DATEADD(YEAR, @nCurrentYear - 1970, Description)) FROM com_Code where CodeId = 124001
		SELECT @dtYearStart = DATEADD(YEAR, -1, DATEADD(D, 1, @dtYearEnd)) --FROM com_Code where CodeId = 124001
		SELECT @dtYearStartMinus1 = DATEADD(D, -1, @dtYearStart)
		--drop table #DefaulterCountTemp
		--drop table #DefaulterIniDis

		--drop table #DefaulterConDis
		--drop table #DefaulterPerioDis
		--drop table #DefaulterPreClerDis
		--drop table #DefaulterContraTrade
	----------------------------  Update Count in tra_CoDashboardCount table   --------------------------------------------------------			

		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOInitialDisclosureCount	,[Status] = 0
		WHERE DashboardCountId = 1	AND [Count] != @nCOInitialDisclosureCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderInitialDisclosureCount	,[Status] = 0
		WHERE DashboardCountId = 2	AND [Count] != @nInsiderInitialDisclosureCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOPreclearanceCount	,[Status] = 0
		WHERE DashboardCountId = 3	AND [Count] != @nCOPreclearanceCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOTradeDetailsCount	,[Status] = 0
		WHERE DashboardCountId = 4	AND [Count] != @nCOTradeDetailsCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderTradeDetailsCount	,[Status] = 0
		WHERE DashboardCountId = 5	AND [Count] != @nInsiderTradeDetailsCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOContinuousDisclosuresCount ,[Status] = 0
		WHERE DashboardCountId = 6	AND [Count] != @nCOContinuousDisclosuresCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderContinuousDisclosuresCount	,[Status] = 0
		WHERE DashboardCountId = 7	AND [Count] != @nInsiderContinuousDisclosuresCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOSubmissiontoStockExchangeCount	,[Status] = 0
		WHERE DashboardCountId = 8	AND [Count] != @nCOSubmissiontoStockExchangeCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOPeriodEndDisclosuresCount	,[Status] = 0
		WHERE DashboardCountId = 9	AND [Count] != @nCOPeriodEndDisclosuresCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderPeriodEndDisclosuresCount	,[Status] = 0
		WHERE DashboardCountId = 10	AND [Count] != @nInsiderPeriodEndDisclosuresCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nPolicyDocumentAssociationtoUserCount	,[Status] = 0
		WHERE DashboardCountId = 11	AND [Count] != @nPolicyDocumentAssociationtoUserCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nTradingPolicyAssociationtoUserCount	,[Status] = 0
		WHERE DashboardCountId = 12	AND [Count] != @nTradingPolicyAssociationtoUserCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nLoginCredentialsMailtoNewUserCount	,[Status] = 0
		WHERE DashboardCountId = 13	AND [Count] != @nLoginCredentialsMailtoNewUserCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaultersCount	,[Status] = 0
		WHERE DashboardCountId = 14	AND [Count] != @nDefaultersCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nTradingPolicydueforExpiryCount	,[Status] = 0
		WHERE DashboardCountId = 15	AND [Count] != @nTradingPolicydueforExpiryCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nPolicyDocumentdueforExpiryCount	,[Status] = 0
		WHERE DashboardCountId = 16	AND [Count] != @nPolicyDocumentdueforExpiryCount			
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nTradingWindowSettingforFinancialResultDeclarationCurrentYearId	,[Status] = @nIsCurrentFinancialResultDeclared
		WHERE DashboardCountId = 17	--AND [Count] != @nTradingWindowSettingforFinancialResultDeclarationCurrentYearId
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nTradingWindowSettingforFinancialResultDeclarationNextYearId	,[Status] = @nIsNextFinancialResultDeclared
		WHERE DashboardCountId = 18	--AND [Count] != @nTradingWindowSettingforFinancialResultDeclarationNextYearId
		
		-- Update count and status for defaulter - Initial Disclosures
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_Initial, [Status] = 0
		WHERE DashboardCountId = 19	AND [Count] != @nDefaulter_Initial

		-- Update count and status for Continuous Disclosures
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_Continuous, [Status] = 0
		WHERE DashboardCountId = 20	AND [Count] != @nDefaulter_Continuous
		
		
		-- Update count and status for defaulter - Pre-clearances
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_Preclearance, [Status] = 0
		WHERE DashboardCountId = 22	AND [Count] != @nDefaulter_Preclearance

		-- Update count and status for defaulter - Period End Disclosures
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_PE, [Status] = 0
		WHERE DashboardCountId = 21	AND [Count] != @nDefaulter_PE
	
		-- Update count and status for defaulter - Trading Plan
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_TradingPlan, [Status] = 0
		WHERE DashboardCountId = 23	AND [Count] != @nDefaulter_TradingPlan

		-- Update count and status for defaulter - Contra Trade
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_ContraTrade, [Status] = 0
		WHERE DashboardCountId = 24	AND [Count] != @nDefaulter_ContraTrade

		-- Update count and status for defaulter - Traded with Non designated demat account
		UPDATE tra_CoDashboardCount
		SET [Count] = @nDefaulter_TradedWithNonDesignatedDMAT, [Status] = 0
		WHERE DashboardCountId = 25	AND [Count] != @nDefaulter_TradedWithNonDesignatedDMAT	

		IF((SELECT RequiredModule FROM mst_Company WHERE IsImplementing=1)=513003)
		BEGIN
		  EXEC st_tra_UpdateCODashboardCnt_OS
		END
GO
	
	
	