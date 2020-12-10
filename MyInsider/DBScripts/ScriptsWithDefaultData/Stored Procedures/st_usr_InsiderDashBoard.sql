IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_InsiderDashBoard')
DROP PROCEDURE [dbo].[st_usr_InsiderDashBoard]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to fetch insider Dashboard

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		16-JUNE-2015

Modification History:
Modified By		Modified On		Description
Ashish			07-July-2015	Count changed as per the Preclearace Status
Ashish			15-July-2015	Changed the holding counts
Arundhati		18-Jul-2015		Query for Holding count is corrected
Arundhati		20-Jul-2015		TradeDetail counts are corrected, Initial details last submission date or submission date corrected, count of continuous soft copy pending corrected
Arundhati		21-Jul-2015		Period end date on dashboard
Arundhati		24-Jul-2015		Changes to handle Disclosure pannel conditions
Arundhati		04-Sep-2015		Counts are corrected
Arundhati		26-Oct-2015		Trade details counts are corrected
Parag			17-Nov-2015		Made change to show correct period end date as per TP applicable
Parag			23-Nov-2015		Made change to handle condition when period end disclosure is not applicable for user
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
ED				01-Mar-2016		Code merging done on 01-Mar-2016
Tushar			10-Mar-2016		Change Logic for Set Last Submission Date & evaluating Comment on the basis of Last Submission Date		
								1. If User Is Employee (Non Insider)
									If DateOfJoining <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfJoining + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)	
								2. If User Is Employee (Insider)
									If DateOfBecomingInsider <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfBecomingInsider + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)
Tushar			10-Mar-2016		above case add in code in missing block.	
TushAR			25-Mar-2016		Change for Holding count appearing.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.	
Usage:
EXEC st_usr_InsiderDashBoard
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_InsiderDashBoard] 
	@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @out_nReturnValue1 INT = 0 
	DECLARE @out_nSQLErrCode1 INT = 0 			
	DECLARE @out_sSQLErrMessage1 VARCHAR(500) = '' 
	DECLARE @nPreclearanceDisclosureType INT = 147002
	DECLARE @nReclearanceStatusConfirmed INT = 144001
	DECLARE @nReclearanceStatusApproved INT = 144002
	DECLARE @nReclearanceStatusRejected INT = 144003
	DECLARE @nHoldingShares INT = 139001
	DECLARE @nHoldingWarrants INT = 139002
	DECLARE @nHoldingDebentures INT = 139003
	DECLARE @nHoldingFutures INT = 139004
	DECLARE @nHoldingOptions INT = 139005
	DECLARE @nPreclearanceRequestMapToType INT	= 132004
	DECLARE @nEventPreclearanceApproved INT = 153016	
	DECLARE @nEventPreclearanceRejected INT = 153017
	DECLARE @nDisclosureMapToType INT = 132005
	DECLARE @nEventContinuousDisclosureUploaded INT = 153020	
	DECLARE @nEventContinuousDisclosureDetailsEntered INT = 153019	
	DECLARE @nApproveStatus INT = 154001
	DECLARE @nPendingStatus INT = 154002
	DECLARE @nPartiallyTradedStatus INT = 154004
	DECLARE @nNotTradedStatus INT = 154005
	DECLARE @nUploadedStatus INT = 154006
	DECLARE @CODE_CO_DASHBOARD_CONTACT_NUMBER INT = 168003
	DECLARE	@CODE_CO_DASHBOARD_EMAIL INT = 168004	
	
	DECLARE @nPreclearanceSubmittedCount INT
	DECLARE @nPreclearanceApprovedCount INT
	DECLARE @nPreclearancePendingCount INT
	DECLARE @nPreclearanceRejectedCount INT
	
	DECLARE @nHoldingSharesCount INT=0
	DECLARE @nHoldingWarrantsCount INT=0
	DECLARE @nHoldingDebenturesCount INT=0
	DECLARE @nHoldingFuturesCount INT=0
	DECLARE @nHoldingOptionsCount INT=0
	
	DECLARE @nTradeDetailsSubmittedCount INT
	DECLARE @nTradeDetailsNotTradedCount INT
	DECLARE @nTradeDetailsPendingCount INT
	DECLARE @nTradeDetailsSubmittedWithoutPreclearanceCount INT	
	
	DECLARE @nInitialDisclosureFlag INT = 0
	DECLARE @dtInitialDisclosureDate DateTime
	DECLARE @nContinuousDisclosureSoftCopyPendingCount INT = 0 
	DECLARE @nPeriodEndDisclosureFlag INT = 0 -- 1: Last date for next period. 2: Lst date of disclosure (date id not passed), 3: Last date of submission (date has passed), 4: Trading policy not found
	DECLARE @dtPeriodEndDate DateTime 
	DECLARE @dtPeriodStartDate DateTime 
	DECLARE @dtCurrentDate DateTime = dbo.uf_com_GetServerDate()
	DECLARE @nTradingPolicyID INT
	DECLARE @out_iTotalRecords INT
	DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @nMonthCnt INT = 0
	DECLARE @nPeriodTypeCodeId INT = 123001
	DECLARE @dtTmp DATETIME
	DECLARE @nContiDisclosureCountLimit INT = 5
	DECLARE @nContiCountWithinLimitFlag INT = 0
	DECLARE @dtPeriodEndDateTo DATETIME = NULL
	DECLARE @Contact VARCHAR(100)
	DECLARE @Email VARCHAR(100)
	
	DECLARE @nTransactionMasterId INT = 0
	DECLARE @dtCurrentDate_For_PE DATETIME = @dtCurrentDate
	
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	
	DECLARE @RC INT
	-- flag to indicate what action to be taken
	-- 0: NO ACTION
	-- 1: add records as per current TP for current period, 
	-- 2: record is already added into tra_UserPeriodEndMapping table
	-- 3: add next period records as per previous TP stored in tra_UserPeriodEndMapping table
	DECLARE @nActinFlag		 		INT
	
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME
	
	
	DECLARE @nYearCodeIdNew INT
	DECLARE @nPeriodCodeIdNew INT
	DECLARE @dtDateOfAcqOld DATETIME
	DECLARE @dtPeriodEndForContinuous DATETIME	
	DECLARE @nPeriodCodeIdForHolding INT = 124001
	DECLARE @nYearCodeIdForHolding INT=0
	DECLARE @nCount INT=0
	DECLARE @TotalRows INT=0
	DECLARE @nHoldingSharesUsrCount BIGINT=0	
	DECLARE @nHoldingWarrantsUsrCount BIGINT=0	
	DECLARE @nHoldingDebenturesUsrCount BIGINT=0	
	DECLARE @nHoldingFuturesUsrCount BIGINT=0	
	DECLARE @nHoldingOptionsUsrCount BIGINT=0	
		
	
	
	DECLARE @tmpInsiderTable TABLE(PreclearanceSubmittedCount INT, PreclearanceApprovedCount INT, PreclearancePendingCount INT, PreclearanceRejectedCount INT,
								   TradeDetailsSubmittedCount INT, TradeDetailsNotTradedCount INT, TradeDetailsPendingCount INT, TradeDetailsSubmittedWithoutPreclearanceCount INT,
								   HoldingSharesCount INT, HoldingWarrantsCount INT, HoldingDebenturesCount INT, HoldingFuturesCount INT, HoldingOptionsCount INT, HoldingDate DateTime,
								   InitialDisclosureFlag INT, InitialDisclosureDate DateTime, ContinuousDisclosureSoftCopyPendingCount INT, ContiCountWithinLimitFlag INT, PeriodEndDisclosureFlag INT, PeriodEndDate DateTime, PeriodEndDateTo DateTime, Contact VARCHAR(100), Email VARCHAR (100))						   
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		-- Preclearance Count --
		----------------------------------------------
		--SELECT @nPreclearanceSubmittedCount = COUNT(DISTINCT(TM.TransactionMasterId))
		--FROM tra_TransactionMaster TM
		--join tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		--join eve_EventLog EL ON TM.PreclearanceRequestId = EL.MapToId AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType
		--WHERE TM.UserInfoId = @inp_iLoggedInUserId AND TM.DisclosureTypeCodeId = @nPreclearanceDisclosureType
		
		CREATE TABLE #tmpEventLog
		(
		EventLogId INT,
		EventCodeId INT,
		EventDate DATETIME,
		UserInfoId INT,
		MapToTypeCodeId INT,
		MapToId INT
		)
		INSERT INTO #tmpEventLog(EventLogId,EventCodeId,EventDate,UserInfoId,MapToTypeCodeId,MapToId)
		SELECT EventLogId,EventCodeId,EventDate,UserInfoId,MapToTypeCodeId,MapToId FROM eve_EventLog WHERE UserInfoId=@inp_iLoggedInUserId
		
		CREATE TABLE #tmpUser
		(
		UserInfoId INT,
		DateOfBecomingInsider DATETIME,
		DateOfJoining DATETIME
		)
		INSERT #tmpUser(UserInfoId,DateOfBecomingInsider,DateOfJoining)
		SELECT UserInfoId,DateOfBecomingInsider,DateOfJoining FROM usr_UserInfo WHERE UserInfoId=@inp_iLoggedInUserId
		
		CREATE TABLE #tmpTradingPolicy
		(
		ApplicabilityMstId INT,
		UserInfoId INT,
		MapToId INT
		)
		INSERT INTO #tmpTradingPolicy(ApplicabilityMstId,UserInfoId,MapToId)
		EXEC st_tra_GetTradingPolicy				
		
		
		SELECT @nPreclearanceSubmittedCount = COUNT(*)
		FROM 
		tra_PreclearanceRequest
		WHERE 
		UserInfoId = @inp_iLoggedInUserId
		
		SELECT @nPreclearanceApprovedCount = COUNT(DISTINCT PR.PreclearanceRequestId)
		FROM 
		tra_TransactionMaster TM join tra_PreclearanceRequest PR 
		ON TM.PreclearanceRequestId = PR.PreclearanceRequestId join #tmpEventLog EL 
		ON TM.PreclearanceRequestId = EL.MapToId AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId AND EL.EventCodeId = @nEventPreclearanceApproved AND TM.DisclosureTypeCodeId = @nPreclearanceDisclosureType
			  
		SELECT @nPreclearanceRejectedCount = COUNT(TM.TransactionMasterId)
		FROM 
		tra_TransactionMaster TM join tra_PreclearanceRequest PR 
		ON TM.PreclearanceRequestId = PR.PreclearanceRequestId join #tmpEventLog EL 
		ON TM.PreclearanceRequestId = EL.MapToId AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType
		WHERE 
		TM.UserInfoId  = @inp_iLoggedInUserId AND EL.EventCodeId = @nEventPreclearanceRejected AND TM.DisclosureTypeCodeId = @nPreclearanceDisclosureType
			  
		SELECT @nPreclearancePendingCount = (@nPreclearanceSubmittedCount - (@nPreclearanceApprovedCount + @nPreclearanceRejectedCount))	  
		----------------------------------------------
		
		-- Trade Details
		----------------------------------------------
		/*
			Create Temp Table for evaluation data
		*/
		--CREATE TABLE #tmpUsers(UserInfoId INT, TransactionMasterID INT,PreClearanceRequestID INT,
		--				ContinuousDisclousureToBeSubmit INT,ContinuousDisclousureCompletion INT default 0,
		--				ContinuousDisclosureStatus INT)		

		----Insert Value in Temporary Table.
		----UserInfoId,TransactionMasterID,TradingPolicyId,PreClearanceRequestID,PreClearanceRequestCode
		--INSERT INTO #tmpUsers(UserInfoId,TransactionMasterID,PreClearanceRequestID)  
		--SELECT TM.UserInfoId,TransactionMasterId,PR.PreclearanceRequestId
		--FROM tra_TransactionMaster TM
		--LEFT JOIN	tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		--WHERE ((@inp_iLoggedInUserId IS NULL OR @inp_iLoggedInUserId = 0) OR (TM.UserInfoId = @inp_iLoggedInUserId)) 
		--	   AND DisclosureTypeCodeId = @nPreclearanceDisclosureType					
		------ Update Continuous disclosure completion flag
		----	This flag is used for check Trading details submissin is required or not
		----	If Flag = 1 Then Trading Details Required.
		--UPDATE T
		--SET ContinuousDisclousureToBeSubmit = 1
		--FROM #tmpUsers T 
		--JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
		--     AND ((T.PreClearanceRequestID IS NULL) OR t.PreClearanceRequestID = EL.MapToId 
		--     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		--     AND EL.EventCodeId IN (@nEventPreclearanceApproved))			

		----1. ContinuousDisclousureCompletion :- This flag 1 if Trading Details Submitted by Insider
		----2. ContinuousDisclosureSubmissionDate: - If Trading Details Submitted then set Submission date
		----3. ContinuousDisclosureStatus :- Update Status like 153019:- Trading details Approved or
		----   15320:- Trading details Uploaded
		--UPDATE t
		--SET ContinuousDisclousureCompletion = 1,
		--	ContinuousDisclosureStatus =  @nUploadedStatus
		--FROM #tmpUsers t 
		--JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		--WHERE EL.EventCodeId = @nEventContinuousDisclosureUploaded   
		
		--UPDATE t
		--SET ContinuousDisclousureCompletion = 1,
		--			ContinuousDisclosureStatus = @nApproveStatus
		--FROM #tmpUsers t 
		--JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		--WHERE EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered
	
		----1. ContinuousDisclosureStatus :- update status if Trading details entered must and insider doesnot entered trade details
		----									then set status Pending
		--UPDATE t
		--SET ContinuousDisclosureStatus =  @nPendingStatus
		--FROM #tmpUsers t 
		--WHERE ContinuousDisclousureToBeSubmit = 1 AND ContinuousDisclousureCompletion = 0
		
		----1. ContinuousDisclosureStatus :- In case Insider Not Traded Then set status @nNotTradedStatus
		--UPDATE T
		--SET	ContinuousDisclosureStatus = @nNotTradedStatus
		--FROM #tmpUsers T
		--LEFT JOIN tra_PreclearanceRequest PR ON t.PreClearanceRequestID = PR.PreclearanceRequestId
		--WHERE PR.ReasonForNotTradingCodeId IS NOT NULL	 	
		
		
		----1. ContinuousDisclosureStatus :- If Insider Traded Partially by checking PartiallyTradedFlag in TransactionMaster
		----   set status Partially Traded
			
		--UPDATE T
		--SET	ContinuousDisclosureStatus = @nPartiallyTradedStatus
		--FROM #tmpUsers T
		--JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE TM.PartiallyTradedFlag = 1
		
		----select * from #tmpUsers
		--SELECT @nTradeDetailsSubmittedCount = COUNT(*) FROM #tmpUsers WHERE ContinuousDisclosureStatus = @nApproveStatus
		--SELECT @nTradeDetailsPendingCount = COUNT(*) FROM #tmpUsers WHERE ContinuousDisclosureStatus = @nPendingStatus
		--SELECT @nTradeDetailsNotTradedCount = COUNT(*) FROM #tmpUsers WHERE ContinuousDisclosureStatus = @nNotTradedStatus
		--SELECT @nTradeDetailsSubmittedWithoutPreclearanceCount = COUNT(*) FROM #tmpUsers WHERE ContinuousDisclosureStatus = @nApproveStatus AND PreClearanceRequestID IS NULL
		--drop table #tmpUsers
		
		SELECT @nTradeDetailsNotTradedCount = COUNT(*)
		FROM tra_TransactionMaster TM
			JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TM.UserInfoId = @inp_iLoggedInUserId
			AND DisclosureTypeCodeId = 147002
			--AND ReasonForNotTradingCodeId IS NOT NULL
			AND IsPartiallyTraded = 2


		SELECT @nTradeDetailsSubmittedCount = COUNT(*)
		FROM
		(
		SELECT 
		TM.TransactionMasterId
		FROM 
		tra_TransactionMaster TM JOIN #tmpEventLog EL ON EventCodeId IN (153019) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId
		AND DisclosureTypeCodeId = 147002
		AND PreclearanceRequestId IS NOT NULL
		UNION ALL					
		SELECT 
		TM.TransactionMasterId 
		FROM 
		tra_TransactionMaster TM
		JOIN tra_PreclearanceRequest TP 
		ON TM.PreclearanceRequestId=TP.PreclearanceRequestId
		WHERE 
		TP.PreclearanceStatusCodeId=144002 AND TP.ReasonForNotTradingCodeId IS  NOT NULL
		AND TP.UserInfoId=@inp_iLoggedInUserId AND TP.IsPartiallyTraded=1
		) InsiderTradeSubmitted


		SELECT @nTradeDetailsSubmittedWithoutPreclearanceCount = COUNT(*)
		FROM
		tra_TransactionMaster TM JOIN #tmpEventLog EL 
		ON EventCodeId IN (153019) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId
		AND DisclosureTypeCodeId = 147002
		AND PreclearanceRequestId IS NULL

		SELECT @nTradeDetailsPendingCount = 
			(SELECT COUNT(*)
			FROM tra_TransactionMaster TM LEFT JOIN #tmpEventLog EL ON EventCodeId IN (153019) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
			WHERE TM.UserInfoId = @inp_iLoggedInUserId
				AND EL.EventLogId IS NULL
				AND DisclosureTypeCodeId = 147002
				AND PreclearanceRequestId IS NULL)
			+
			--(SELECT COUNT(DISTINCT PR.PreclearanceRequestId) 
			--FROM tra_TransactionMaster TM JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
			--	JOIN eve_EventLog ELApproved ON ELApproved.EventCodeId = 153016 AND ELApproved.MapToId = PR.PreclearanceRequestId
			--	LEFT JOIN eve_EventLog EL ON EL.EventCodeId IN (153019) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
			--WHERE TM.UserInfoId = @inp_iLoggedInUserId
			--	AND EL.EventLogId IS NULL
			--	AND DisclosureTypeCodeId = 147002
			--	--AND ReasonForNotTradingCodeId IS NULL
			--	AND IsPartiallyTraded <> 2
			--)
			(SELECT COUNT(PreclearanceRequestId) 
				FROM tra_PreclearanceRequest 
				WHERE IsPartiallyTraded = 1 AND UserInfoId = @inp_iLoggedInUserId 
					AND PreclearanceStatusCodeId = 144002 AND ReasonForNotTradingCodeId IS NULL)
		
		
		----------------------------------------------
		
		-- Holdings Count --
		----------------------------------------------

		
		EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
			   @nYearCodeIdNew OUTPUT
			  ,@nPeriodCodeIdNew OUTPUT
			  ,@dtCurrentDate
			  ,123001
			  ,0
			  ,@dtDateOfAcqOld OUTPUT
			  ,@dtPeriodEndForContinuous OUTPUT
			  ,@out_nReturnValue OUTPUT
			  ,@out_nSQLErrCode OUTPUT
			  ,@out_sSQLErrMessage OUTPUT
		
		DECLARE @tmpUserSecurityMaxRecord TABLE(TransactionSummaryId INT, UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT)
			
		-------------------Total Holding For Shares--------------------------------------------------------------------------------------------
		CREATE TABLE #tmpYearCodeIdForShares(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

		INSERT INTO #tmpYearCodeIdForShares(YearCodeId,UserInfoIdRelative,UserInfoId)

		SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
		WHERE UserInfoId=@inp_iLoggedInUserId and PeriodCodeId=@nPeriodCodeIdForHolding and SecurityTypeCodeId=@nHoldingShares GROUP BY UserInfoIdRelative,UserInfoId

		SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeIdForShares
		WHILE @nCount<@TotalRows
		BEGIN
		SELECT @nHoldingSharesUsrCount = ISNULL(TS.ClosingBalance, 0)
				FROM 
				tra_TransactionSummary TS
				WHERE 
				TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeIdForShares WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=@nHoldingShares AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeIdForShares WHERE ID=@nCount+1)

		
		SET @nHoldingSharesCount=@nHoldingSharesUsrCount +@nHoldingSharesCount
		
		SET @nCount=@nCount+1
		END
		SET @nCount=0
		SET @TotalRows=0
		DROP TABLE #tmpYearCodeIdForShares
		
		----------------------------------------------------------------------------------------------------------------------	

		-------------------Total Holding For Warrants----------
		CREATE TABLE #tmpYearCodeIdForWarrants(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

		INSERT INTO #tmpYearCodeIdForWarrants(YearCodeId,UserInfoIdRelative,UserInfoId)

		SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
		WHERE UserInfoId=@inp_iLoggedInUserId and PeriodCodeId=@nPeriodCodeIdForHolding and SecurityTypeCodeId=@nHoldingWarrants GROUP BY UserInfoIdRelative,UserInfoId

		SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeIdForWarrants
		WHILE @nCount<@TotalRows
		BEGIN
		SELECT  @nHoldingWarrantsUsrCount = ISNULL(TS.ClosingBalance, 0)
				FROM 
				tra_TransactionSummary TS
				WHERE 
				TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeIdForWarrants WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=@nHoldingWarrants AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeIdForWarrants WHERE ID=@nCount+1)

		SET @nHoldingWarrantsCount=@nHoldingWarrantsUsrCount+@nHoldingWarrantsCount	
		SET @nCount=@nCount+1
		END
		SET @nCount=0
		SET @TotalRows=0
		DROP TABLE #tmpYearCodeIdForWarrants
		------------------------------------------------------------------------------------------------------------------
		-------------------Total Holding For Debentures----------
		CREATE TABLE #tmpYearCodeIdForDebentures(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

		INSERT INTO #tmpYearCodeIdForDebentures(YearCodeId,UserInfoIdRelative,UserInfoId)

		SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
		WHERE UserInfoId=@inp_iLoggedInUserId and PeriodCodeId=@nPeriodCodeIdForHolding and SecurityTypeCodeId=@nHoldingDebentures GROUP BY UserInfoIdRelative,UserInfoId

		SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeIdForDebentures
		WHILE @nCount<@TotalRows
		BEGIN
		SELECT  @nHoldingDebenturesUsrCount = ISNULL(TS.ClosingBalance, 0)
				FROM 
				tra_TransactionSummary TS
				WHERE 
				TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeIdForDebentures WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=@nHoldingDebentures AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeIdForDebentures WHERE ID=@nCount+1)

		SET @nHoldingDebenturesCount = @nHoldingDebenturesUsrCount + @nHoldingDebenturesCount
		SET @nCount=@nCount+1
		END
		SET @nCount=0
		SET @TotalRows=0
		DROP TABLE #tmpYearCodeIdForDebentures
		------------------------------------------------------------------------------------------------------------------
		-------------------Total Holding For Futures----------
		CREATE TABLE #tmpYearCodeIdForFutures(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

		INSERT INTO #tmpYearCodeIdForFutures(YearCodeId,UserInfoIdRelative,UserInfoId)

		SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
		WHERE UserInfoId=@inp_iLoggedInUserId and PeriodCodeId=@nPeriodCodeIdForHolding and SecurityTypeCodeId=@nHoldingFutures GROUP BY UserInfoIdRelative,UserInfoId

		SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeIdForFutures
		WHILE @nCount<@TotalRows
		BEGIN
		SELECT  @nHoldingFuturesUsrCount = ISNULL(TS.ClosingBalance, 0)
				FROM 
				tra_TransactionSummary TS
				WHERE 
				TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeIdForFutures WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=@nHoldingFutures AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeIdForFutures WHERE ID=@nCount+1)

		SET @nHoldingFuturesCount = @nHoldingFuturesUsrCount + @nHoldingFuturesCount
		SET @nCount=@nCount+1
		END
		SET @nCount=0
		SET @TotalRows=0
		DROP TABLE #tmpYearCodeIdForFutures
		---------------------------------------------------------------------------------------------------------------

		-------------------Total Holding For Options----------
		CREATE TABLE #tmpYearCodeIdForOption(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

		INSERT INTO #tmpYearCodeIdForOption(YearCodeId,UserInfoIdRelative,UserInfoId)

		SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
		WHERE UserInfoId=@inp_iLoggedInUserId and PeriodCodeId=@nPeriodCodeIdForHolding and SecurityTypeCodeId=@nHoldingOptions GROUP BY UserInfoIdRelative,UserInfoId
		SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeIdForOption
		WHILE @nCount<@TotalRows
		BEGIN
		SELECT  @nHoldingOptionsUsrCount = ISNULL(TS.ClosingBalance, 0)
				FROM 
				tra_TransactionSummary TS
				WHERE 
				TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeIdForOption WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=@nHoldingOptions AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeIdForOption WHERE ID=@nCount+1)

		SET @nHoldingOptionsCount = @nHoldingOptionsUsrCount + @nHoldingOptionsCount
		SET @nCount=@nCount+1
		END
		SET @nCount=0
		SET @TotalRows=0
		DROP TABLE #tmpYearCodeIdForOption	

		--SELECT @nYearCodeIdForHolding=MAX(YearCodeId) 
		--FROM 
		--tra_TransactionSummary 
		--WHERE 
		--UserInfoId=@inp_iLoggedInUserId
				
		--SELECT @nHoldingSharesCount = ISNULL(SUM(ISNULL(TS.ClosingBalance, 0)),0)
		--FROM 
		--tra_TransactionSummary TS
		--WHERE 
		--TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoId=@inp_iLoggedInUserId AND TS.SecurityTypeCodeId=@nHoldingShares AND TS.YearCodeId=@nYearCodeIdForHolding
				
		--SELECT @nHoldingWarrantsCount = ISNULL(SUM(ISNULL(TS.ClosingBalance, 0)),0)
		--FROM 
		--tra_TransactionSummary TS
		--WHERE 
		--TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoId=@inp_iLoggedInUserId AND TS.SecurityTypeCodeId=@nHoldingWarrants AND TS.YearCodeId=@nYearCodeIdForHolding
		
		--SELECT @nHoldingDebenturesCount = ISNULL(SUM(ISNULL(TS.ClosingBalance, 0)),0)
		--FROM 
		--tra_TransactionSummary TS
		--WHERE 
		--TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoId=@inp_iLoggedInUserId AND TS.SecurityTypeCodeId=@nHoldingDebentures AND TS.YearCodeId=@nYearCodeIdForHolding
		
		--SELECT @nHoldingFuturesCount = ISNULL(SUM(ISNULL(TS.ClosingBalance, 0)),0)
		--FROM 
		--tra_TransactionSummary TS
		--WHERE 
		--TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoId=@inp_iLoggedInUserId AND TS.SecurityTypeCodeId=@nHoldingFutures AND TS.YearCodeId=@nYearCodeIdForHolding

		--SELECT @nHoldingOptionsCount = ISNULL(SUM(ISNULL(TS.ClosingBalance, 0)),0)
		--FROM 
		--tra_TransactionSummary TS
		--WHERE 
		--TS.PeriodCodeId=@nPeriodCodeIdForHolding AND TS.UserInfoId=@inp_iLoggedInUserId AND TS.SecurityTypeCodeId=@nHoldingOptions AND TS.YearCodeId=@nYearCodeIdForHolding
		
		--GROUP BY CSecurity.CodeID
		----------------------------------------------
		
		-- Disclosure Count --
		----------------------------------------------
		IF EXISTS(SELECT EL.EventDate 
				  FROM tra_TransactionMaster TM
				  JOIN #tmpEventLog EL on TM.TransactionMasterId = EL.MapToId and MapToTypeCodeId = @nDisclosureMapToType
				  AND EventCodeId = 153007
				  WHERE TM.UserInfoId = @inp_iLoggedInUserId)
		BEGIN
			SELECT @dtInitialDisclosureDate = EL.EventDate 
				  FROM tra_TransactionMaster TM
				  JOIN #tmpEventLog EL on TM.TransactionMasterId = EL.MapToId and MapToTypeCodeId = @nDisclosureMapToType
				  AND EventCodeId = 153007
				  WHERE TM.UserInfoId = @inp_iLoggedInUserId
			SET @nInitialDisclosureFlag = 2
		END 
		ELSE
		BEGIN
			IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
			BEGIN
				SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
			END

			IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE DisclosureTypeCodeId = 147001 AND UserInfoId = @inp_iLoggedInUserId)
			BEGIN
				SELECT @dtInitialDisclosureDate = --DATEADD(DAY, TP.DiscloInitLimit, UI.DateOfBecomingInsider)  
					--CASE WHEN DateOfBecomingInsider < @dtImplementation THEN DiscloInitDateLimit
					--								ELSE  DATEADD(D, DiscloInitLimit, DateOfBecomingInsider) END
					CASE WHEN UI.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UI.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UI.DateOfJoining) END
			               ELSE CASE WHEN UI.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UI.DateOfBecomingInsider) END END
				FROM tra_TransactionMaster TM
					 JOIN #tmpUser UI ON UI.UserInfoId = TM.UserInfoId
					 --JOIN eve_EventLog EL ON tm.TransactionMasterId = EL.MapToId AND MapToTypeCodeId = 132005 AND EventCodeId = 153007
					 JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
				WHERE tm.UserInfoId = @inp_iLoggedInUserId 
			END
			ELSE
			BEGIN
				SELECT @dtInitialDisclosureDate = --CASE WHEN DateOfBecomingInsider < @dtImplementation THEN DiscloInitDateLimit
													--ELSE  DATEADD(D, DiscloInitLimit, DateOfBecomingInsider) END
							CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
			               ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
				FROM #tmpTradingPolicy tmpTP JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = tmpTP.MapToId
					JOIN #tmpUser UF ON tmpTP.UserInfoId = UF.UserInfoId
				WHERE UF.UserInfoId = @inp_iLoggedInUserId
			END
			
			IF @dtInitialDisclosureDate IS NULL
			BEGIN
				SET @nInitialDisclosureFlag = 3
			END
			ELSE IF @dtInitialDisclosureDate <= dbo.uf_com_GetServerDate()
			BEGIN
				SET @nInitialDisclosureFlag = 1
			END
			ELSE
			BEGIN
				SET @nInitialDisclosureFlag = 0
			END
			
		END
		

		-- Disclosure - Period End date & status
		----------------------------------------------
		
		-- get last period end disclosure records 
		SELECT TOP(1) 
			@nTransactionMasterId = TM.TransactionMasterId, 
			@nTradingPolicyID = UPEMap.TradingPolicyId, 
			@dtPeriodStartDate = UPEMap.PEStartDate, 
			@dtPeriodEndDate = UPEMap.PEEndDate 
		FROM tra_TransactionMaster TM 
		JOIN tra_UserPeriodEndMapping UPEMap ON 
			TM.PeriodEndDate = UPEMap.PEEndDate AND TM.UserInfoId = UPEMap.UserInfoId AND TM.UserInfoId = @inp_iLoggedInUserId 
			AND TM.DisclosureTypeCodeId = 147003
		ORDER BY TM.TransactionMasterId DESC
		
		--print '@nTransactionMasterId -- '+convert(varchar, @nTransactionMasterId)
		-- check if PE is already submitted for last PE 
		-- IF already submitted then show next period start end date
		-- IF not submitted then show last submission date
		IF (@nTransactionMasterId <> 0)
		BEGIN
			-- has not submitted period end disclosure for last period
			IF (NOT EXISTS(SELECT * FROM #tmpEventLog EL JOIN tra_TransactionMaster TM ON 
								EL.EventCodeId = 153029 AND MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId
								WHERE TM.TransactionMasterId = @nTransactionMasterId))
			BEGIN
				-- PE is not submitted for last period
				
				SELECT @dtPeriodEndDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(DAY, DiscloPeriodEndToCOByInsdrLimit, @dtPeriodEndDate)  
				FROM rul_TradingPolicy WHERE TradingPolicyId = @nTradingPolicyID
				
				If CONVERT(date, @dtPeriodEndDate) < CONVERT(date, dbo.uf_com_GetServerDate())
				BEGIN
					-- Last submission date not yet passed
					SET @nPeriodEndDisclosureFlag = 3
				END
				ELSE
				BEGIN
					-- Last submission date has already passed
					SET @nPeriodEndDisclosureFlag = 2
				END
			END
			ELSE
			BEGIN
				-- PE submitted for last period show next period PE date
				SELECT @nPeriodEndDisclosureFlag = 1, @dtPeriodEndDate = null
				
				-- check date, if current date is last day of current PE then set current date to next months first day
				IF( CONVERT(date, @dtCurrentDate_For_PE) = CONVERT(date, (SELECT PeriodEndDate FROM tra_TransactionMaster WHERE TransactionMasterId = @nTransactionMasterId)))
				BEGIN
					SET @dtCurrentDate_For_PE = DATEADD(DAY, 1, @dtCurrentDate)
				END
			END
		END
		ELSE
		BEGIN
			-- no records exists for period end - show next period PE date
			SELECT @nPeriodEndDisclosureFlag = 1, @dtPeriodEndDate = null
		END
		
		-- print '@nPeriodEndDisclosureFlag '+convert(varchar, @nPeriodEndDisclosureFlag)
		
		-- calculate next period end date 
		IF (@nPeriodEndDisclosureFlag = 1)
		BEGIN
			SELECT @nTradingPolicyID = MapToId FROM #tmpTradingPolicy WHERE UserInfoId = @inp_iLoggedInUserId
			
			IF @nTradingPolicyID IS NULL
			BEGIN
				-- 'Trading policy not found'
				SELECT @dtPeriodEndDate = null, @nPeriodEndDisclosureFlag = 4
			END
			ELSE
			BEGIN
				EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
									@inp_iLoggedInUserId, 
									@nTradingPolicyID, 
									@dtCurrentDate_For_PE,
									@nActinFlag OUTPUT,
									@nApplicableTP OUTPUT, 
									@nYearCodeId OUTPUT, 
									@nPeriodCodeId OUTPUT, 
									@dtPEStartDate OUTPUT, 
									@dtPEEndDate OUTPUT, 
									@bChangePEDate OUTPUT, 
									@dtPEEndDateToUpdate OUTPUT, 									
									@out_nReturnValue OUTPUT,
									@out_nSQLErrCode OUTPUT,
									@out_sSQLErrMessage OUTPUT
			
				-- check if PE is applicable by checking PE End date
				-- if end date is null then show message that PE not applicable else show start and end date
				IF (@dtPEEndDate IS NULL)
				BEGIN
					-- Period end is not applicable 
					SELECT @nPeriodEndDisclosureFlag = 5, @dtPeriodEndDate = null
				END
				ELSE 
				BEGIN
					SET @dtPeriodEndDate = @dtPEStartDate
					
					SET @dtPeriodEndDateTo = @dtPEEndDate
				END
			END	
		END
		
		
		SELECT @Contact =  CodeName FROM com_Code where CodeId = @CODE_CO_DASHBOARD_CONTACT_NUMBER
		SELECT @Email = CodeName FROM com_Code where CodeId = @CODE_CO_DASHBOARD_EMAIL
		
		--EXEC st_com_PopulateGrid 114038, 10, 1, 'dis_grd_17014', 'asc', @inp_iLoggedInUserId, NULL, NULL, NULL, NULL, NULL, NULL,
		--						 '154002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
		--						 NULL, NULL, NULL, NULL, NULL, NULL, NULL, @out_iTotalRecords OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		--SET @nContinuousDisclosureSoftCopyPendingCount = @out_iTotalRecords
		SELECT @nContinuousDisclosureSoftCopyPendingCount = COUNT(*) FROM tra_TransactionMaster TM JOIN #tmpEventLog ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId AND EventCodeId = 153019
		LEFT JOIN #tmpEventLog ELSoftCopy ON ELSoftCopy.EventCodeId = 153021 AND ELSubmit.MapToId = ELSoftCopy.MapToId
		WHERE TM.UserInfoId = @inp_iLoggedInUserId
		AND SoftCopyReq = 1 AND ELSoftCopy.EventCodeId IS NULL

		IF @nContinuousDisclosureSoftCopyPendingCount < @nContiDisclosureCountLimit
		BEGIN
			SET @nContiCountWithinLimitFlag = 1
		END
		ELSE
		BEGIN
			SET @nContiCountWithinLimitFlag = 0
		END
			
		----------------------------------------------		
		
		INSERT INTO @tmpInsiderTable(PreclearanceSubmittedCount, PreclearanceApprovedCount, PreclearancePendingCount, PreclearanceRejectedCount, 
									 TradeDetailsSubmittedCount, TradeDetailsNotTradedCount, TradeDetailsPendingCount, TradeDetailsSubmittedWithoutPreclearanceCount,
									 HoldingSharesCount, HoldingWarrantsCount, HoldingDebenturesCount, HoldingFuturesCount, HoldingOptionsCount, HoldingDate,
									 InitialDisclosureFlag, InitialDisclosureDate, ContinuousDisclosureSoftCopyPendingCount, ContiCountWithinLimitFlag, PeriodEndDisclosureFlag, PeriodEndDate, PeriodEndDateTo, Contact, Email)
		VALUES(@nPreclearanceSubmittedCount, @nPreclearanceApprovedCount, @nPreclearancePendingCount, @nPreclearanceRejectedCount, 
									 @nTradeDetailsSubmittedCount, @nTradeDetailsNotTradedCount, @nTradeDetailsPendingCount, @nTradeDetailsSubmittedWithoutPreclearanceCount,	
									 @nHoldingSharesCount, @nHoldingWarrantsCount, @nHoldingDebenturesCount, @nHoldingFuturesCount, @nHoldingOptionsCount, dbo.uf_com_GetServerDate(),
									 @nInitialDisclosureFlag, @dtInitialDisclosureDate, @nContinuousDisclosureSoftCopyPendingCount, @nContiCountWithinLimitFlag, @nPeriodEndDisclosureFlag, @dtPeriodEndDate, @dtPeriodEndDateTo, @Contact, @Email)

		SELECT * FROM @tmpInsiderTable 
		
		DROP TABLE #tmpEventLog
		DROP TABLE #tmpUser
		DROP TABLE #tmpTradingPolicy
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ''
	END CATCH
END