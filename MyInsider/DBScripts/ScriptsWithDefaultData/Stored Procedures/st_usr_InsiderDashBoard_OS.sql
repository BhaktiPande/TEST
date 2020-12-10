IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_InsiderDashBoard_OS')
DROP PROCEDURE [dbo].[st_usr_InsiderDashBoard_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to fetch insider Dashboard

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		2-December-20119

Modification History:
Modified By		Modified On		Description
Usage:
EXEC st_usr_InsiderDashBoard_OS 44
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_InsiderDashBoard_OS] 
	@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @nPreclearanceDisclosureType INT = 147002 
	DECLARE @nPreclearanceRequestMapToType INT	= 132015 
	DECLARE @nEventPreclearanceApproved INT = 153046	
	DECLARE @nEventPreclearanceRejected INT = 153047 
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
	DECLARE @nContiCountWithinLimitFlag INT = 0 
	DECLARE @dtPeriodEndDateTo DATETIME = NULL
	DECLARE @Contact VARCHAR(100)
	DECLARE @Email VARCHAR(100)


	DECLARE @tmpInsiderTable TABLE(PreclearanceSubmittedCount INT, PreclearanceApprovedCount INT, PreclearancePendingCount INT, PreclearanceRejectedCount INT,
								   TradeDetailsSubmittedCount INT, TradeDetailsNotTradedCount INT, TradeDetailsPendingCount INT, TradeDetailsSubmittedWithoutPreclearanceCount INT,
								   HoldingSharesCount INT, HoldingWarrantsCount INT, HoldingDebenturesCount INT, HoldingFuturesCount INT, HoldingOptionsCount INT, HoldingDate DateTime,
								   InitialDisclosureFlag INT, InitialDisclosureDate DateTime, ContinuousDisclosureSoftCopyPendingCount INT, ContiCountWithinLimitFlag INT, PeriodEndDisclosureFlag INT,
								   PeriodEndDate DateTime, PeriodEndDateTo DateTime, Contact VARCHAR(100), Email VARCHAR (100))						   
	
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
		
		DECLARE  @tmpUser AS TABLE
		(
		UserInfoId INT,
		DateOfBecomingInsider DATETIME,
		DateOfJoining DATETIME
		)
		INSERT @tmpUser(UserInfoId,DateOfBecomingInsider,DateOfJoining)
		SELECT UserInfoId,DateOfBecomingInsider,DateOfJoining FROM usr_UserInfo WHERE UserInfoId=@inp_iLoggedInUserId
			
		
		
		SELECT @nPreclearanceSubmittedCount = COUNT(PreclearanceRequestId)
		FROM 
		tra_PreclearanceRequest_NonImplementationCompany
		WHERE 
		UserInfoId = @inp_iLoggedInUserId
		
		SELECT @nPreclearanceApprovedCount = COUNT(DISTINCT PR.PreclearanceRequestId)
		FROM 
		tra_TransactionMaster_OS TM join tra_PreclearanceRequest_NonImplementationCompany PR 
		ON TM.PreclearanceRequestId = PR.PreclearanceRequestId join #tmpEventLog EL 
		ON TM.PreclearanceRequestId = EL.MapToId AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId AND EL.EventCodeId = @nEventPreclearanceApproved AND TM.DisclosureTypeCodeId = @nPreclearanceDisclosureType
			  
		SELECT @nPreclearanceRejectedCount = COUNT(TM.TransactionMasterId)
		FROM 
		tra_TransactionMaster_OS TM join tra_PreclearanceRequest_NonImplementationCompany PR 
		ON TM.PreclearanceRequestId = PR.PreclearanceRequestId join #tmpEventLog EL 
		ON TM.PreclearanceRequestId = EL.MapToId AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType
		WHERE 
		TM.UserInfoId  = @inp_iLoggedInUserId AND EL.EventCodeId = @nEventPreclearanceRejected AND TM.DisclosureTypeCodeId = @nPreclearanceDisclosureType
			  

		SELECT @nPreclearancePendingCount = (@nPreclearanceSubmittedCount - (@nPreclearanceApprovedCount + @nPreclearanceRejectedCount))	  
		----------------------------------------------
		
		-- Trade Details
		----------------------------------------------
		
		
		SELECT @nTradeDetailsNotTradedCount = COUNT(*)--need to ask
		FROM tra_TransactionMaster_OS TM
			JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TM.UserInfoId = @inp_iLoggedInUserId
			AND DisclosureTypeCodeId = 147002
			AND IsPartiallyTraded = 2


		SELECT @nTradeDetailsSubmittedCount = COUNT(*)
		FROM
		(
		SELECT 
		TM.TransactionMasterId
		FROM 
		tra_TransactionMaster_OS TM JOIN #tmpEventLog EL ON EventCodeId IN (153057) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId
		AND DisclosureTypeCodeId = 147002
		AND PreclearanceRequestId IS NOT NULL
		UNION ALL					
		SELECT 
		TM.TransactionMasterId 
		FROM 
		tra_TransactionMaster_OS TM
		JOIN tra_PreclearanceRequest_NonImplementationCompany TP 
		ON TM.PreclearanceRequestId=TP.PreclearanceRequestId
		WHERE 
		TP.PreclearanceStatusCodeId=144002 AND TP.ReasonForNotTradingCodeId IS  NOT NULL
		AND TP.UserInfoId=@inp_iLoggedInUserId AND TP.IsPartiallyTraded=1
		) InsiderTradeSubmitted


		SELECT @nTradeDetailsSubmittedWithoutPreclearanceCount = COUNT(*)
		FROM
		tra_TransactionMaster_OS TM JOIN #tmpEventLog EL 
		ON EventCodeId IN (153057) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
		WHERE 
		TM.UserInfoId = @inp_iLoggedInUserId
		AND DisclosureTypeCodeId = 147002
		AND PreclearanceRequestId IS NULL

		SELECT @nTradeDetailsPendingCount = 
			(SELECT COUNT(TransactionMasterId)
			FROM tra_TransactionMaster_OS TM LEFT JOIN #tmpEventLog EL ON EventCodeId IN (153057) AND TM.TransactionMasterId = EL.MapToId AND TM.UserInfoId = EL.UserInfoId
			WHERE TM.UserInfoId = @inp_iLoggedInUserId
				AND EL.EventLogId IS NULL
				AND DisclosureTypeCodeId = 147002
				AND PreclearanceRequestId IS NULL)
			+
			
			(SELECT COUNT(PreclearanceRequestId) 
				FROM tra_PreclearanceRequest_NonImplementationCompany 
				WHERE IsPartiallyTraded = 1 AND UserInfoId = @inp_iLoggedInUserId 
					AND PreclearanceStatusCodeId = 144002 AND ReasonForNotTradingCodeId IS NULL)
		
	
		
		INSERT INTO @tmpInsiderTable(PreclearanceSubmittedCount, PreclearanceApprovedCount,
									 PreclearancePendingCount, PreclearanceRejectedCount, 
									 TradeDetailsSubmittedCount, TradeDetailsNotTradedCount, 
									 TradeDetailsPendingCount, TradeDetailsSubmittedWithoutPreclearanceCount,
									 HoldingSharesCount, HoldingWarrantsCount, HoldingDebenturesCount, 
									 HoldingFuturesCount, HoldingOptionsCount, HoldingDate,
									 InitialDisclosureFlag, InitialDisclosureDate, ContinuousDisclosureSoftCopyPendingCount, 
									 ContiCountWithinLimitFlag, PeriodEndDisclosureFlag, PeriodEndDate, PeriodEndDateTo, Contact, Email
									 )

		VALUES(						
									 @nPreclearanceSubmittedCount, @nPreclearanceApprovedCount,
									 @nPreclearancePendingCount, @nPreclearanceRejectedCount, 
									 @nTradeDetailsSubmittedCount, @nTradeDetailsNotTradedCount,
									 @nTradeDetailsPendingCount, @nTradeDetailsSubmittedWithoutPreclearanceCount,	
									 @nHoldingSharesCount, @nHoldingWarrantsCount, @nHoldingDebenturesCount, 
									 @nHoldingFuturesCount, @nHoldingOptionsCount, dbo.uf_com_GetServerDate(),
									 @nInitialDisclosureFlag, @dtInitialDisclosureDate, @nContinuousDisclosureSoftCopyPendingCount,
									 @nContiCountWithinLimitFlag, @nPeriodEndDisclosureFlag, @dtPeriodEndDate, @dtPeriodEndDateTo, @Contact, @Email)

		SELECT * FROM @tmpInsiderTable 
		
		DROP TABLE #tmpEventLog
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ''
	END CATCH
END