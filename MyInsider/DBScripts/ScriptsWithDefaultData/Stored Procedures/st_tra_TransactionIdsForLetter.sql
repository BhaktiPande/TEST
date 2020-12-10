IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionIdsForLetter')
DROP PROCEDURE [dbo].[st_tra_TransactionIdsForLetter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list transaction master ids which should be included in the letter for this transaction

Returns:		0, if Success.
				
Created by:		Arundahti
Created on:		16-Jul-2015

Modification History:
Modified By		Modified On		Description
Arundhati		17-Jul-2015		Join is changed to Left JOIN to fetch period end date
Parag			15-Feb-2015		Made change to fix issue of employee not able to view letter when period end date is null 
Usage:

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionIdsForLetter]
	@inp_iTransactionMasterId INT
AS
BEGIN

	DECLARE @dtPeriodEndDate DATETIME, @nTradingPolicyId INT, @dtSubmissionDate DATETIME, @dtLastSubmissionDate DATETIME,@dtAcquisitionDate DATETIME
	DECLARE @nMultiTransTradeFlagCodeId INT,@nSecurityTypeCodeId INT, @nDisclosureTypeCodeId INT, @nUserInfoId INT
	DECLARE @nTransactionTrade_Multiple INT = 136002
	DECLARE @nSoftCopyReq INT
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153007
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153019
	DECLARE @nEventCodeID_PEDetailsSubmitted INT = 153029
	DECLARE @nDisclosure_Initial INT = 147001
	DECLARE @nDisclosure_Continuous INT = 147002
	DECLARE @nDisclosure_PeriodEnd INT = 147003

	DECLARE @tmpTransactions TABLE(TransactionMasterId INT)
	DECLARE @nIsLimitSetForAllSecurities INT -- 1: For all, 0: For indiv security
	
	DECLARE @nPeriodType INT	
	DECLARE @nPeriodTypeThreshold INT					
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @dtStartDate DATETIME
	DECLARE @dtEndDate DATETIME = NULL
	declare @out_nReturnValue				INT = 0 
	declare @out_nSQLErrCode				INT = 0				-- Output SQL Error Number, if error occurred.
    declare @out_sSQLErrMessage				NVARCHAR(500) = '' 
	
	BEGIN TRY
		SET NOCOUNT ON;

		SELECT @dtPeriodEndDate = PeriodEndDate, @nTradingPolicyId = TM.TradingPolicyId, @nSoftCopyReq = SoftCopyReq,
			@nMultiTransTradeFlagCodeId = StExSingMultiTransTradeFlagCodeId,
			@dtSubmissionDate = EL.EventDate,
			@nDisclosureTypeCodeId = DisclosureTypeCodeId,
			@nSecurityTypeCodeId = SecurityTypeCodeId,
			@nUserInfoId = TM.UserInfoId
		FROM tra_TransactionMaster TM JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			LEFT JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.MapToId = @inp_iTransactionMasterId
		WHERE TransactionMasterId = @inp_iTransactionMasterId

		SELECT @dtAcquisitionDate= MAX(DateOfAcquisition) from tra_TransactionDetails where TransactionMasterId=@inp_iTransactionMasterId
		
		SELECT @nIsLimitSetForAllSecurities = CASE WHEN SecurityTypeCodeId IS NULL THEN 1 ELSE 0 END -- 1: For all, 0: For indiv security
		FROM rul_TradingPolicySecuritywiseLimits
		WHERE TradingPolicyId = @nTradingPolicyId
		AND MapToTypeCodeId = 132005
		AND (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @nSecurityTypeCodeId)

		IF @nDisclosureTypeCodeId = @nDisclosure_Initial
		BEGIN
			-- Take only the current transaction for initial
			INSERT INTO @tmpTransactions(TransactionMasterId) VALUES(@inp_iTransactionMasterId)
		END
		ELSE IF @nDisclosureTypeCodeId = @nDisclosure_PeriodEnd
		BEGIN
			-- Take all transactions which are entered in this period
			INSERT INTO @tmpTransactions(TransactionMasterId)
			SELECT TransactionMasterId
			FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted, @nEventCodeID_ContiDetailsSubmitted, @nEventCodeID_PEDetailsSubmitted) AND EL.MapToId = TM.TransactionMasterId
			WHERE TM.PeriodEndDate = @dtPeriodEndDate
				AND TM.UserInfoId = @nUserInfoId
		END
		ELSE
		BEGIN
			--print 'For continuous'
			--print '@nMultiTransTradeFlagCodeId = ' + CONVERT(VARCHAR(10), @nMultiTransTradeFlagCodeId)
			--print '@@nIsLimitSetForAllSecurities = ' + CONVERT(VARCHAR(10), @nIsLimitSetForAllSecurities)
			IF @nMultiTransTradeFlagCodeId = @nTransactionTrade_Multiple
			BEGIN
				SELECT @dtLastSubmissionDate = EL.EventDate
				FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
				WHERE EL.EventDate < @dtSubmissionDate
					AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
					AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
					AND SoftCopyReq = 1 AND TM.UserInfoId = @nUserInfoId

				--print '@dtLastSubmissionDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtLastSubmissionDate, ''))
				--print '@dtPeriodEndDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtPeriodEndDate, ''))
				--print '@dtSubmissionDate = ' + CONVERT(VARCHAR(30), ISNULL(@dtSubmissionDate, ''))
				--print '@nSecurityTypeCodeId = ' + CONVERT(VARCHAR(10), @nSecurityTypeCodeId) 
				
				SELECT @nPeriodType = CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.DiscloPeriodEndFreq 
						 END,
					   @nPeriodTypeThreshold = CASE 
							WHEN TP.StExMultiTradeFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.StExMultiTradeFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.StExMultiTradeFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.StExMultiTradeFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.StExMultiTradeFreq 
						 END				
				FROM rul_TradingPolicy TP WHERE TP.TradingPolicyId = @nTradingPolicyId
				
				EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
				   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtAcquisitionDate, /*@nPeriodType*/@nPeriodTypeThreshold, 0, 
				   @dtStartDate OUTPUT, @dtEndDate OUTPUT, 
				   @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
				
				INSERT INTO @tmpTransactions(TransactionMasterId)		
				
				SELECT DISTINCT TM.TransactionMasterId
				FROM tra_TransactionMaster TM  
				join tra_TransactionDetails TD on TM.TransactionMasterId=TD.TransactionMasterId
				JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
				WHERE TM.UserInfoId = @nUserInfoId
					AND EL.EventDate <= @dtSubmissionDate
					AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
					AND (@nIsLimitSetForAllSecurities = 1 OR TM.SecurityTypeCodeId = @nSecurityTypeCodeId)
					AND TD.DateOfAcquisition >= @dtStartDate AND TD.DateOfAcquisition <= @dtEndDate
					AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)				
			END
			ELSE
			BEGIN
				INSERT INTO @tmpTransactions(TransactionMasterId) VALUES(@inp_iTransactionMasterId)
			END
		END
		
		SELECT * FROM @tmpTransactions
	END TRY
	BEGIN CATCH	
	END CATCH
END
	