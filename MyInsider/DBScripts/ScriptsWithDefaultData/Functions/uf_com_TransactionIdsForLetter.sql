IF EXISTS (SELECT * FROM SYS.all_objects WHERE NAME = 'uf_com_TransactionIdsForLetter' AND Type = 'FN')
	DROP FUNCTION uf_com_TransactionIdsForLetter
GO

/*-------------------------------------------------------------------------------------------------
Author:			Sanjay patle
Create date:	29-March-2018
Description:	This function will returns only TransactionMasterIds for Form C
				Also Added new conditions for Year and Period wise check for return TransactionMasterIds
-- exec st_tra_TransactionIdsForLetter '1092'
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_TransactionIdsForLetter]
(
	@inp_iTransactionMasterId INT
)
RETURNS 
@tmpTransactions TABLE 
(
	TransactionMasterId INT
)
AS
BEGIN

	DECLARE @dtPeriodEndDate DATETIME, @nTradingPolicyId INT, @dtSubmissionDate DATETIME, @dtLastSubmissionDate DATETIME
	DECLARE @nMultiTransTradeFlagCodeId INT,@nSecurityTypeCodeId INT, @nDisclosureTypeCodeId INT, @nUserInfoId INT
	DECLARE @nTransactionTrade_Multiple INT = 136002
	DECLARE @nSoftCopyReq INT
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153007
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153019
	DECLARE @nEventCodeID_PEDetailsSubmitted INT = 153029
	DECLARE @nDisclosure_Initial INT = 147001
	DECLARE @nDisclosure_Continuous INT = 147002
	DECLARE @nDisclosure_PeriodEnd INT = 147003

	
	DECLARE @nIsLimitSetForAllSecurities INT -- 1: For all, 0: For indiv security
	DECLARE @StExMultiTradeFreq varchar(50)
	DECLARE @Month int
	DECLARE @Year int
	DECLARE @MonthForQuaterFrom varchar(15)
	DECLARE @MonthForQuaterTo varchar(15)
	DECLARE @MonthForHalfyearlyFrom varchar(15)
	DECLARE @MonthForHalfyearlyTo varchar(15)
	DECLARE @YearForQuater int
	
		
		SELECT @dtPeriodEndDate = PeriodEndDate, @nTradingPolicyId = TM.TradingPolicyId, @nSoftCopyReq = SoftCopyReq,
			   @nMultiTransTradeFlagCodeId = StExSingMultiTransTradeFlagCodeId,			
			   @dtSubmissionDate = EL.EventDate,
			   @nDisclosureTypeCodeId = DisclosureTypeCodeId,
			   @nSecurityTypeCodeId = SecurityTypeCodeId,
			   @nUserInfoId = TM.UserInfoId,
			   @StExMultiTradeFreq=(case when TP.StExMultiTradeFreq=137003 then 'Monthly'
				 when TP.StExMultiTradeFreq=137002 then 'Quarterly'
				 when TP.StExMultiTradeFreq=137004 then 'Half Yearly'
				 when TP.StExMultiTradeFreq=137001 then 'Yearly' end),
			   @Month=MONTH(EL.EventDate),
			   @Year=YEAR(EL.EventDate),
			   @MonthForQuaterFrom=MONTH(DATEADD (month ,-2 , PeriodEndDate)),
			   @MonthForQuaterTo=MONTH(PeriodEndDate),
			   @MonthForHalfyearlyFrom=MONTH(DATEADD (month ,-5 , PeriodEndDate)),
			   @MonthForHalfyearlyTo=MONTH(PeriodEndDate),
			   @YearForQuater=YEAR(DATEADD (month ,-5 , EL.EventDate))
			
		FROM tra_TransactionMaster TM JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			LEFT JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.MapToId = @inp_iTransactionMasterId
		WHERE TransactionMasterId = @inp_iTransactionMasterId

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

				
					IF(@dtLastSubmissionDate IS NULL)
					BEGIN
							
							if(@StExMultiTradeFreq='Monthly')
							BEGIN
									INSERT INTO @tmpTransactions(TransactionMasterId)		
									SELECT TransactionMasterId
									FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
									WHERE TM.UserInfoId = @nUserInfoId
									AND EL.EventDate <= @dtSubmissionDate
									AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
									AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
									AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)
									AND MONTH(EL.EventDate) = MONTH(GETDATE()) and YEAR(EL.EventDate) = YEAR(GETDATE())
							END
							if(@StExMultiTradeFreq='Quarterly')
							BEGIN
									INSERT INTO @tmpTransactions(TransactionMasterId)		
									SELECT TransactionMasterId
									FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
									WHERE TM.UserInfoId = @nUserInfoId
									AND EL.EventDate <= @dtSubmissionDate
									AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
									AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
									AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)									
									AND  MONTH(DATEADD (month ,-2 , EL.EventDate)) <= @MonthForQuaterFrom  and MONTH(EL.EventDate) >=  @MonthForQuaterTo 

							END
							if(@StExMultiTradeFreq='Half Yearly')
							BEGIN
									INSERT INTO @tmpTransactions(TransactionMasterId)		
									SELECT TransactionMasterId
									FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
									WHERE TM.UserInfoId = @nUserInfoId
									AND EL.EventDate <= @dtSubmissionDate
									AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
									AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
									AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)									
									AND  MONTH(DATEADD (month ,-5 , EL.EventDate)) <= @MonthForHalfyearlyFrom  and MONTH(EL.EventDate) >=  @MonthForHalfyearlyTo 
							END
							if(@StExMultiTradeFreq='Yearly')
							BEGIN
									INSERT INTO @tmpTransactions(TransactionMasterId)		
									SELECT TransactionMasterId
									FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
									WHERE TM.UserInfoId = @nUserInfoId
									AND EL.EventDate <= @dtSubmissionDate
									AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
									AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
									AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)									
									AND YEAR(EL.EventDate) = YEAR(GETDATE())
							END

							
					END
					ELSE
					BEGIN
							INSERT INTO @tmpTransactions(TransactionMasterId)		
							SELECT TransactionMasterId
							FROM tra_TransactionMaster TM  JOIN eve_EventLog EL ON EL.EventCodeId = @nEventCodeID_ContiDetailsSubmitted AND EL.UserInfoId = TM.UserInfoId AND EL.MapToId = TM.TransactionMasterId
							WHERE TM.UserInfoId = @nUserInfoId
							AND EL.EventDate <= @dtSubmissionDate
							AND ((@dtPeriodEndDate IS NOT NULL AND TM.PeriodEndDate = @dtPeriodEndDate) OR @dtPeriodEndDate IS NULL)
							AND (@nIsLimitSetForAllSecurities = 1 OR SecurityTypeCodeId = @nSecurityTypeCodeId)
							AND (@dtLastSubmissionDate IS NULL OR EL.EventDate > @dtLastSubmissionDate)
							

					END
					
			END
			ELSE
			BEGIN
				INSERT INTO @tmpTransactions(TransactionMasterId) VALUES(@inp_iTransactionMasterId)
			END
		END
		
		RETURN 
	
END
	