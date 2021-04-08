IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterGenerate_Preclearance_OS')
DROP PROCEDURE [dbo].[st_rpt_DefaulterGenerate_Preclearance_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to generate data for Preclearance report defaulter. This procedure will populate the table for defaulters for type Preclearance.

Returns:		0, if Success.
				
Created by:		hemant
Created on:		07-JAN-2021

Modification History:
Modified By		Modified On		Description

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DefaulterGenerate_Preclearance_OS]
	@inp_dtLastRunDate		DATETIME
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @dtLastRunDate DATETIME = @inp_dtLastRunDate
	DECLARE @nPCLCOApprovalLimitMin INT = 0
	DECLARE @nPCLCOApprovalLimitMax INT = 0

	DECLARE @iNonComplianceType_PCL INT = 170004
	DECLARE @iNonComplianceType_PNT INT = 170002
	DECLARE @iEventCodeId_ContiDetailsEntered INT = 153057
	DECLARE @iEventCodeId_PEDetailsEntered INT = 153062
	DECLARE @iDisclosure_Required INT = 165001
	
	DECLARE @iCommentsId_NotSubmitted INT = 169001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 169002
	DECLARE @iCommentsId_TradedMoreThanQty INT = 169003
	DECLARE @iCommentsId_TradedMoreThanValue INT = 169004
	DECLARE @iCommentsId_NA INT = 169005
	DECLARE @iCommentsId_TrdAfterPCLDate INT = 169006
	DECLARE @iCommentsId_ContraTrade INT = 169007
	DECLARE @iCommentsId_PCLNotTaken INT = 169008
	DECLARE @iCommentsId_TrdDuringBlackout INT = 169009
	
	DECLARE @nMaxDefaulterId INT
	DECLARE @dtToday DATETIME = dbo.uf_com_GetServerDate()--'2015-10-01'--

	DECLARE @nTransactionMasterId BIGINT
	DECLARE @RC INT
	DECLARE @inp_UpdateTD int = 0
	
	DECLARE @nTransactionDetailsId BIGINT
	
	DECLARE @tmpPCLIds TABLE(PreclearanceId BIGINT, DefaulterReportId BIGINT, PreApplicableTill DATETIME, LastSubmissionDate DATETIME, PreclearanceStatusDate DATETIME)
	DECLARE @tmpPCLQty TABLE(PreclearanceId BIGINT, PCLQty INT, PCLValue DECIMAL(25,4), TradeQty INT, TradeValue DECIMAL(25,4), ValueExceds INT, QtyExceeds INT,TransactionMasterID INT,TransactionDetailsID INT)
	DECLARE @tmpTransactionDetailsAll TABLE(TransactionMasterId BIGINT, TransactionDetailsId BIGINT, PreclearanceId BIGINT, LastSubmissionDate DATETIME, SubmissionDate DATETIME)
	DECLARE @tmpTransactionDetails TABLE(DefaulterReportId BIGINT, TransactionMasterId BIGINT, TransactionDetailsId BIGINT, PreclearanceId BIGINT, TradingPolicyId INT, PCLApplicableTill DATETIME, LastSubmissionDate DATETIME, IsDefaulter INT DEFAULT 0, ContraTradeQty DECIMAL(10,0), CompanyId INT NULL)
	DECLARE @tmpUserTrans TABLE(UserInfoId INT, MinAcqDate DATETIME)
	DECLARE @tmpTMIds TABLE(TransactionMasterId BIGINT)

	DECLARE @tmpIsContraTradeForTd TABLE(TransactionDetailsId BIGINT, IsContraTrade INT, ContraTradeQty DECIMAL(10,0), CompanyId INT NULL)

	DECLARE curTmpTMIds CURSOR FOR 
	SELECT TransactionMasterId FROM @tmpTMIds

	DECLARE curTDds CURSOR FOR 
	SELECT TransactionDetailsId FROM @tmpTransactionDetails

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print 'st_rpt_DefaulterGenerate_Preclearance_OS'
		SELECT @nPCLCOApprovalLimitMin = MIN(PreClrCOApprovalLimit),
				@nPCLCOApprovalLimitMax = MAX(PreClrCOApprovalLimit)
		FROM rul_TradingPolicy_OS
		
			--SET PreApplicableTill = DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
	--	select @dtToday
		--SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtToday,@nPCLCOApprovalLimitMax,null,1,1,1,116001)
		--SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtToday,@nPCLCOApprovalLimitMin,null,1,1,1,116001)
		
		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END

		-- #1 Handle the case Trade Details Not Submitted
		-- Find the preclearances approved between (Today-Min) and (Today-Max)
		INSERT INTO @tmpPCLIds(PreclearanceId)
		SELECT DISTINCT MapToId 
		FROM eve_EventLog ELApp 
		WHERE EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 --AND ELApp.MapToId = TM.PreclearanceRequestId
			AND (@inp_dtLastRunDate IS NULL
				 OR	(@inp_dtLastRunDate IS NOT NULL
					AND EventDate >= (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtToday,@nPCLCOApprovalLimitMax,null,1,1,1,116001))--DATEADD(D, -@nPCLCOApprovalLimitMax, @dtToday)
					AND EventDate <= (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtToday,@nPCLCOApprovalLimitMin,null,1,1,1,116001))))--DATEADD(D, -@nPCLCOApprovalLimitMin, @dtToday)))

		-- Delete those records from temp table which already exists in defulter report
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL JOIN rpt_DefaulterReport_OS DefRpt ON tmpPCL.PreclearanceId = DefRpt.PreclearanceRequestId

		-- Delete those records from temp table for which details are entered, since the "Not Submitted" comment is not applicable to those records
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL --JOIN tra_TransactionMaster_OS TM ON tmpPCL.PreclearanceId = TM.PreclearanceRequestId
			JOIN eve_EventLog EL ON EL.EventCodeId = 153038 AND EL.MapToId = tmpPCL.PreclearanceId AND MapToTypeCodeId = 132004
		
		-- Delete those records from temp table for which Not-Traded reason is provided
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId
		WHERE IsPartiallyTraded = 2
		
		-- Update temp table with for PreclearanceApplicable till date
		UPDATE tmpPCL
		SET PreclearanceStatusDate = ELApp.EventDate,
			PreApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
			--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
			LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
		FROM @tmpPCLIds tmpPCL JOIN tra_TransactionMaster_OS TM ON tmpPCL.PreclearanceId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				
		
		-- Delete the records for which ApplicableTillDate > GETDATE
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL
		WHERE PreApplicableTill > dbo.uf_com_GetServerDate()
		
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		
		-- Insert those records in Defaulter report as "Not Submitted"
		INSERT INTO rpt_DefaulterReport_OS
			(UserInfoID, UserInfoIdRelative, PreclearanceRequestId,
			InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, NonComplainceTypeCodeId)
		SELECT PR.UserInfoId, PR.UserInfoIdRelative, PreclearanceId, 
			@iDisclosure_Required, LastSubmissionDate, CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId
			JOIN usr_UserInfo UF ON PR.UserInfoId = UF.UserInfoId
		
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NotSubmitted
		FROM rpt_DefaulterReport_OS WHERE DefaulterReportID > @nMaxDefaulterId
		-- #1 END
		
		print '#1 END'		
		

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		
		DELETE FROM @tmpPCLIds

		-- #2 Not Submitted within time
		-- Populate @tmpPCLIds with the preclearance ids for which submission is done after last run		
		INSERT INTO @tmpPCLIds(PreclearanceId)
		SELECT distinct TM.PreclearanceRequestId 
		FROM eve_EventLog EL JOIN tra_TransactionMaster_OS TM ON EL.EventCodeId = @iEventCodeId_ContiDetailsEntered AND EL.MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId
		WHERE (@dtLastRunDate IS NULL OR EventDate >= @dtLastRunDate)
			AND PreclearanceRequestId IS NOT NULL

		-- Populate @tmpPCLIds with the preclearance ids for which Not traded reason is provided
		INSERT INTO @tmpPCLIds(PreclearanceId)
		SELECT PreclearanceRequestId 
		FROM tra_PreclearanceRequest_NonImplementationCompany
		WHERE (@dtLastRunDate IS NULL OR ModifiedOn >= @dtLastRunDate)
			AND IsPartiallyTraded = 2
			
		-- Update temp table with for PreclearanceApplicable till date
		UPDATE tmpPCL
		SET PreclearanceStatusDate = ELApp.EventDate,
			PreApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
			LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
			--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
		FROM @tmpPCLIds tmpPCL JOIN tra_TransactionMaster_OS TM ON tmpPCL.PreclearanceId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				
		
		-- Delete those records from temp table for which details are entered, since the "Not Submitted" comment is not applicable to those records
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL --JOIN tra_TransactionMaster_OS TM ON tmpPCL.PreclearanceId = TM.PreclearanceRequestId
			JOIN eve_EventLog EL ON EL.EventCodeId = 153038 AND EL.MapToId = tmpPCL.PreclearanceId AND MapToTypeCodeId = 132004 AND EventDate <= LastSubmissionDate
		
		-- Delete those records from temp table, for which Not traded reason is given and within stipulated time.
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId AND IsPartiallyTraded = 2
			AND ModifiedOn <= LastSubmissionDate

		---------------------------- Not submitted in stipulated time for Preclearance (if all are submitted after Preclearance valid till is passed
		UPDATE tmpPCL
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpPCLIds tmpPCL JOIN rpt_DefaulterReport_OS DefRpt ON tmpPCL.PreclearanceId = DefRpt.PreclearanceRequestId AND DefRpt.TransactionMasterId IS NULL AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PCL
		
		-- Update comment from Not Submitted to Not Submitted within time
		UPDATE DefRptCmt
		SET CommentCodeId = @iCommentsId_NotSubmittedInTime
		FROM rpt_DefaulterReportComments_OS DefRptCmt JOIN @tmpPCLIds tmpPCL ON DefRptCmt.DefaulterReportID = tmpPCL.DefaulterReportId
		WHERE CommentCodeId = @iCommentsId_NotSubmitted
		
		DELETE FROM @tmpPCLIds WHERE DefaulterReportId IS NOT NULL
		
		-- Insert the remaining records into defaulter report
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		
		-- Insert those records in Defaulter report as "Not Submitted"
		INSERT INTO rpt_DefaulterReport_OS
			(UserInfoID, UserInfoIdRelative, PreclearanceRequestId,
			InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, NonComplainceTypeCodeId)
		SELECT PR.UserInfoId, PR.UserInfoIdRelative, PreclearanceId, 
			@iDisclosure_Required, LastSubmissionDate, CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId
			JOIN usr_UserInfo UF ON PR.UserInfoId = UF.UserInfoId
		
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NotSubmittedInTime
		FROM rpt_DefaulterReport_OS WHERE DefaulterReportID > @nMaxDefaulterId
		
		
		-- #2 END
		print '#2 END'
		-- #3 Value and/Or Qty exceeds
		---------------------------- Value Exceeds / Quantity Exceeds
		DELETE FROM @tmpPCLIds

		-- #2 Not Submitted within time
		-- Populate @tmpPCLIds with the preclearance ids for which submission is done after last run		
		INSERT INTO @tmpPCLIds(PreclearanceId)
		SELECT distinct TM.PreclearanceRequestId 
		FROM eve_EventLog EL JOIN tra_TransactionMaster_OS TM ON EL.EventCodeId = @iEventCodeId_ContiDetailsEntered AND EL.MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId
		WHERE (@dtLastRunDate IS NULL OR EventDate >= @dtLastRunDate)
			 AND PreclearanceRequestId IS NOT NULL
			 
		-- Populate @tmpPCLIds with the preclearance ids for which Not traded reason is provided
		INSERT INTO @tmpPCLIds(PreclearanceId)
		SELECT PreclearanceRequestId 
		FROM tra_PreclearanceRequest_NonImplementationCompany
		WHERE (@dtLastRunDate IS NULL OR ModifiedOn >= @dtLastRunDate)
			AND IsPartiallyTraded = 2

		-- Delete those records from temp table, for which Not traded reason is given and within stipulated time.
		DELETE tmpPCL
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId AND IsPartiallyTraded = 2
			AND ModifiedOn <= LastSubmissionDate

		UPDATE tmpPCL
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpPCLIds tmpPCL JOIN rpt_DefaulterReport_OS DefRpt ON tmpPCL.PreclearanceId = DefRpt.PreclearanceRequestId AND DefRpt.TransactionMasterId IS NULL AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PCL

		INSERT INTO @tmpPCLQty(PreclearanceId, TradeQty, TradeValue)
		SELECT distinct PreclearanceId, 0, 0
		FROM @tmpPCLIds
		
		UPDATE PCL
		SET TradeQty = PCLQty.TradeQty,
			TradeValue = PCLQty.TradeValue,
			TransactionMasterID = PCLQty.TMID,
			TransactionDetailsID = PCLQty.TDID
		FROM @tmpPCLQty PCL JOIN
		(SELECT PreclearanceId, SUM(Quantity) TradeQty, SUM(Value) TradeValue, MIN(TM.TradingPolicyId) AS TradingPolicyId,  MIN(DateOfAcquisition) AS DateOfAcquisition
		,MIN(TM.TransactionMasterId) AS TMID,MIN(TD.TransactionDetailsId) AS TDID
		FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			JOIN @tmpPCLQty PCL ON TM.PreclearanceRequestId = PCL.PreclearanceId
		WHERE TM.TransactionStatusCodeId > 148002
		GROUP BY PreclearanceId) AS PCLQty ON PCL.PreclearanceId = PCLQty.PreclearanceId

		--UPDATE PCL
		--SET TradeQty = PCLQty.TradeQty,
		--	TradeValue = PCLQty.TradeValue
		--FROM @tmpPCLQty PCL JOIN
		--(SELECT PreclearanceId, SUM(Quantity) TradeQty, SUM(Value) TradeValue, MIN(TM.TradingPolicyId) AS TradingPolicyId, MIN(TM.SecurityTypeCodeId) AS SecurityTypeCodeId, MIN(DateOfAcquisition) AS DateOfAcquisition
		--FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		--	JOIN @tmpPCLQty PCL ON TM.PreclearanceRequestId = PCL.PreclearanceId
		--WHERE TM.TransactionStatusCodeId > 148002
		--GROUP BY PreclearanceId) AS PCLQty ON PCL.PreclearanceId = PCLQty.PreclearanceId

		UPDATE tmpPCLQty
		SET PCLQty = PR.SecuritiesToBeTradedQty,
			PCLValue = PR.SecuritiesToBeTradedValue
		FROM @tmpPCLQty tmpPCLQty JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCLQty.PreclearanceId = PR.PreclearanceRequestId
		
		-- Delete those records for which trade quantity/value does not exceed
		DELETE tmpPCLQty 
		FROM @tmpPCLQty tmpPCLQty
		WHERE tmpPCLQty.TradeQty <= PCLQty
			AND tmpPCLQty.TradeValue <= PCLValue
		
		UPDATE tmpPCLQty
		SET QtyExceeds = 1
		FROM @tmpPCLQty tmpPCLQty
		WHERE TradeQty > PCLQty

		UPDATE tmpPCLQty
		SET ValueExceds = 1
		FROM @tmpPCLQty tmpPCLQty
		WHERE TradeValue > PCLValue
		
		DELETE FROM @tmpPCLQty WHERE ValueExceds = 0 AND QtyExceeds = 0
		
		--INSERT comment for exesting defaulter ids
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT tmpPCL.DefaulterReportId, @iCommentsId_TradedMoreThanQty
		FROM  @tmpPCLIds tmpPCL
		JOIN @tmpPCLQty qty ON tmpPCL.PreclearanceId=qty.PreclearanceId AND tmpPCL.DefaulterReportId is not null
		WHERE Qty.QtyExceeds = 1 

		--INSERT comment for exesting defaulter ids
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT tmpPCL.DefaulterReportId, @iCommentsId_TradedMoreThanValue
		FROM  @tmpPCLIds tmpPCL
		JOIN @tmpPCLQty qty ON tmpPCL.PreclearanceId=qty.PreclearanceId AND tmpPCL.DefaulterReportId is not null
		WHERE Qty.ValueExceds = 1 

		--delete exesting preclearance id for which defaulter ids is exists
		DELETE FROM @tmpPCLQty WHERE PreclearanceId IN(SELECT q.PreclearanceId FROM @tmpPCLQty q JOIN @tmpPCLIds id ON id.PreclearanceId=q.PreclearanceId and id.DefaulterReportId is not null)
				
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		-- Insert those records in Defaulter report as "Value Exceeds", Quantity Exceeds
		INSERT INTO rpt_DefaulterReport_OS
			(UserInfoID, UserInfoIdRelative, PreclearanceRequestId,TransactionMasterId, TransactionDetailsId,
			InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, NonComplainceTypeCodeId)
		SELECT PR.UserInfoId, PR.UserInfoIdRelative, tmpPCL.PreclearanceId,tmpPCLQty.TransactionMasterID,tmpPCLQty.TransactionDetailsID,
			@iDisclosure_Required, LastSubmissionDate, CASE WHEN tmpPCL.PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END
		FROM @tmpPCLIds tmpPCL JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON tmpPCL.PreclearanceId = PR.PreclearanceRequestId
			JOIN usr_UserInfo UF ON PR.UserInfoId = UF.UserInfoId
			JOIN @tmpPCLQty tmpPCLQty ON tmpPCL.PreclearanceId = tmpPCLQty.PreclearanceId
		WHERE tmpPCL.DefaulterReportID IS NULL

		-- Update DefaulterReportId in tmpPCL for the newly inserted records
		UPDATE tmpPCL
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpPCLIds tmpPCL JOIN rpt_DefaulterReport_OS DefRpt ON tmpPCL.PreclearanceId = DefRpt.PreclearanceRequestId AND DefRpt.TransactionMasterId IS NOT NULL AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PCL

		-- Insert comment if not already exists		
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefRpt.DefaulterReportID, @iCommentsId_TradedMoreThanQty
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpPCLIds tmpPCL ON tmpPCL.DefaulterReportId = DefRpt.DefaulterReportID
			JOIN @tmpPCLQty tmpPCLQty ON DefRpt.PreclearanceRequestId = tmpPCLQty.PreclearanceId
			LEFT JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRpt.DefaulterReportID = DefRptCmt.DefaulterReportID AND DefRptCmt.CommentCodeId = @iCommentsId_TradedMoreThanQty
		WHERE DefRptCmt.DefaulterReportID IS NULL
			AND tmpPCLQty.QtyExceeds = 1
		
		-- Insert comment if not already exists
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefRpt.DefaulterReportID, @iCommentsId_TradedMoreThanValue
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpPCLIds tmpPCL ON tmpPCL.DefaulterReportId = DefRpt.DefaulterReportID
			JOIN @tmpPCLQty tmpPCLQty ON DefRpt.PreclearanceRequestId = tmpPCLQty.PreclearanceId
			LEFT JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRpt.DefaulterReportID = DefRptCmt.DefaulterReportID AND DefRptCmt.CommentCodeId = @iCommentsId_TradedMoreThanValue
		WHERE DefRptCmt.DefaulterReportID IS NULL
			AND tmpPCLQty.ValueExceds = 1

		-- Delete NA comment if exists for the above records
		DELETE DefRptCmt
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpPCLIds tmpPCL ON tmpPCL.DefaulterReportId = DefRpt.DefaulterReportID
			JOIN @tmpPCLQty tmpPCLQty ON DefRpt.PreclearanceRequestId = tmpPCLQty.PreclearanceId
			JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRptCmt.DefaulterReportID = DefRpt.DefaulterReportID
		WHERE CommentCodeId = @iCommentsId_NA

		-- #3 END - Value and Qty exceeds
		print '#3 END'

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		
		DELETE FROM @tmpTransactionDetails
		
		INSERT INTO @tmpTransactionDetailsAll(TransactionDetailsId, TransactionMasterId, PreclearanceId, SubmissionDate)
		SELECT TD.TransactionDetailsId, TM.TransactionMasterId, TM.PreclearanceRequestId, EL.EventDate
		FROM eve_EventLog EL JOIN tra_TransactionMaster_OS TM ON EL.EventCodeId IN (@iEventCodeId_ContiDetailsEntered, @iEventCodeId_PEDetailsEntered) AND EL.MapToTypeCodeId = 132005 AND EL.MapToId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE (@dtLastRunDate IS NULL OR EventDate >= @dtLastRunDate)
--SELECT 'TMAll', * FROM @tmpTransactionDetailsAll order by TransactionMasterId, TransactionDetailsId
		-- #4 Traded After preclearance Date
		INSERT INTO @tmpTransactionDetails(TransactionDetailsId, TransactionMasterId, PreclearanceId, TradingPolicyId)
		SELECT TransactionDetailsId, TDAll.TransactionMasterId, PreclearanceRequestId, TM.TradingPolicyId
		FROM @tmpTransactionDetailsAll TDAll JOIN tra_TransactionMaster_OS TM ON TDAll.TransactionMasterId = TM.TransactionMasterId
			--JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE PreclearanceRequestId IS NOT NULL
		
		UPDATE tmpTD
		SET PCLApplicableTill =(SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),-- DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
			--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
			LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.PreclearanceId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				

		-- Delete those records for which date of acquisition is before Preclearance validity date
		DELETE tmpTD
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		WHERE tmpTD.PCLApplicableTill > DateOfAcquisition
		
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS

		-- Remaining details are considered for traded after preclearance
		-- Insert records in defaulter report table for preclearance if not exists
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, UserInfoID, UserInfoIdRelative)
		SELECT DISTINCT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, null, null, null, tmpTD.LastSubmissionDate, TM.UserInfoId, ForUserInfoId
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON ISNULL(DefRpt.PreclearanceRequestId, 0) = ISNULL(tmpTD.PreclearanceId, 0) AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
		WHERE DefRpt.DefaulterReportID IS NULL
		
		-- Insert comment as blank for for this records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NA
		FROM rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		-- Insert records for trade details
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, UserInfoID, UserInfoIdRelative)
		SELECT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, tmpTD.TransactionMasterId, tmpTD.TransactionDetailsId, @iDisclosure_Required, LastSubmissionDate, TM.UserInfoId, ForUserInfoId
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			--LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
		--WHERE DefRpt.DefaulterReportID IS NULL
		
		-- Insert comment as traded after PCL date for these records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_TrdAfterPCLDate
		FROM rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId				
		-- #4 END - Traded After preclearance Date
		print '#4 END'
		
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		
		-- #5 Traded during blackout
		--DELETE FROM @tmpTransactionDetails
		
		--INSERT INTO @tmpTransactionDetails(TransactionMasterId, TransactionDetailsId, PreclearanceId)
		--SELECT tmpTDAll.TransactionMasterId, TransactionDetailsId, PreclearanceId
		--FROM @tmpTransactionDetailsAll tmpTDAll JOIN tra_TransactionMaster_OS TM ON tmpTDAll.TransactionMasterId = TM.TransactionMasterId
		--WHERE DisclosureTypeCodeId <> 147001

		--UPDATE tmpTD 
		--SET IsDefaulter = 1
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		--	JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = TD.TransactionMasterId
		--	JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.UserInfoId = TM.UserInfoId
		--	JOIN rul_TradingWindowEvent TWE ON vwTWE.MapToId = TWE.TradingWindowEventId
		--WHERE TWE.WindowCloseDate <= DateOfAcquisition AND DateOfAcquisition <= TWE.WindowOpenDate

		--UPDATE tmpTD 
		--SET IsDefaulter = 1
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		--	JOIN rul_TradingWindowEvent TWE ON TWE.EventTypeCodeId = 126001
		--WHERE TWE.WindowCloseDate <= DateOfAcquisition AND DateOfAcquisition <= TWE.WindowOpenDate

		--DELETE FROM @tmpTransactionDetails
		--WHERE IsDefaulter = 0
		
		---- Update last submission date where preclearance is taken
		--UPDATE tmpTD
		--SET PCLApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
		--	--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
		--	LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.PreclearanceId = TM.PreclearanceRequestId
		--	JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		--	JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				

		---- Update last submission date where preclearance is not taken
		--UPDATE tmpTD
		--SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(DateOfAcquisition,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 1),null,1,1,0,116001))--DATEADD(D, ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 0), DateOfAcquisition)
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		--	JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
		--	JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		--WHERE /*TM.DisclosureTypeCodeId = 147002 AND*/ PreclearanceRequestId IS NULL
		
		---- Insert transaction details records in defaulter report
		--SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS

		---- Insert records in defaulter report table for preclearance if not exists
		--INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate)
		--SELECT DISTINCT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, null, null, null, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
		--	JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		--	LEFT JOIN rpt_DefaulterReport_OS DefRpt ON ISNULL(DefRpt.PreclearanceRequestId, 0) = ISNULL(tmpTD.PreclearanceId, 0) AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
		--WHERE DefRpt.DefaulterReportID IS NULL
		--	AND PreclearanceId IS NOT NULL
		
		---- Insert comment as blank for for this records
		--INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		--SELECT DefaulterReportID, @iCommentsId_NA
		--FROM rpt_DefaulterReport_OS 
		--WHERE DefaulterReportID > @nMaxDefaulterId

		--SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		---- Insert records for trade details
		--INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate)
		--SELECT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, tmpTD.TransactionMasterId, tmpTD.TransactionDetailsId, @iDisclosure_Required, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate
		--FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
		--	JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
		--	LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
		--WHERE DefRpt.DefaulterReportID IS NULL

		--UPDATE tmpTD
		--SET DefaulterReportId = DefRpt.DefaulterReportID
		--FROM @tmpTransactionDetails tmpTD JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
				
		---- Insert comment as traded after PCL date for these records
		--INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		--SELECT DefaulterReportID, @iCommentsId_TrdDuringBlackout
		--FROM @tmpTransactionDetails--rpt_DefaulterReport_OS 
		----WHERE DefaulterReportID > @nMaxDefaulterId
		---- #5 END - Traded during blackout period
		--print '#5 END'

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		
		-- #6 Contra Trade
		INSERT INTO @tmpUserTrans(UserInfoId, MinAcqDate)
		SELECT UserInfoId, MIN(DateOfAcquisition)
		FROM @tmpTransactionDetailsAll tmpTDAll JOIN tra_TransactionDetails_OS TD ON tmpTDAll.TransactionDetailsId = TD.TransactionDetailsId
			JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
		WHERE DisclosureTypeCodeId <> 147001
		GROUP BY UserInfoId
		
		DELETE FROM @tmpTransactionDetails
		
		INSERT INTO @tmpTransactionDetails(PreclearanceId, TransactionMasterId, TransactionDetailsId)
		SELECT PreclearanceRequestId, TM.TransactionMasterId, TransactionDetailsId
		FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			JOIN @tmpUserTrans tmpUFTD ON TM.UserInfoId = tmpUFTD.UserInfoId AND TD.DateOfAcquisition >= tmpUFTD.MinAcqDate
		WHERE TransactionStatusCodeId > 148002 AND DisclosureTypeCodeId <> 147001

		-- Run cursor here
		OPEN curTDds

		FETCH NEXT FROM  curTDds
		INTO @nTransactionDetailsId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @tmpIsContraTradeForTd(TransactionDetailsId, IsContraTrade, ContraTradeQty,CompanyId)
			SELECT TransactionDetailsId, IsContraTrade, ContraTradeQty,CompanyID FROM dbo.uf_tra_IsContraTrade_OS(@nTransactionDetailsId)
			
			FETCH NEXT FROM curTDds 
			INTO @nTransactionDetailsId
		END

		CLOSE curTDds;
		DEALLOCATE curTDds;
		
		UPDATE tmpTD
		SET IsDefaulter = 1,
			ContraTradeQty =  CASE WHEN tmpContraTDIds.ContraTradeQty > 0 THEN tmpContraTDIds.ContraTradeQty ELSE NULL END,
			CompanyId = tmpContraTDIds.CompanyId
		FROM @tmpTransactionDetails tmpTD JOIN @tmpIsContraTradeForTd tmpContraTDIds ON tmpTD.TransactionDetailsId = tmpContraTDIds.TransactionDetailsId
		WHERE IsContraTrade = 1
		
		DELETE FROM @tmpTransactionDetails WHERE IsDefaulter = 0

		-- Update last submission date where preclearance is taken
		UPDATE tmpTD
		SET PCLApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
			--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
			LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.PreclearanceId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				

		-- Update last submission date where preclearance is not taken
		UPDATE tmpTD
		SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(DateOfAcquisition,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 1),null,1,1,0,116001))--DATEADD(D, ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 0), DateOfAcquisition)
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		WHERE /*TM.DisclosureTypeCodeId = 147002 AND*/ PreclearanceRequestId IS NULL
		
		-- Insert transaction details records in defaulter report
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS

		-- Insert records in defaulter report table for preclearance if not exists
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate, RLCompanyId)
		SELECT DISTINCT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, null, null, null, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate,tmpTD.CompanyId
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.PreclearanceRequestId = tmpTD.PreclearanceId AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
		WHERE DefRpt.DefaulterReportID IS NULL
			AND PreclearanceId IS NOT NULL
		
		-- Insert comment as blank for for this records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NA
		FROM rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		-- Insert records for trade details
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate, RLCompanyId)
		SELECT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, tmpTD.TransactionMasterId, tmpTD.TransactionDetailsId, @iDisclosure_Required, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate,tmpTD.CompanyId
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
		WHERE DefRpt.DefaulterReportID IS NULL

		UPDATE tmpTD
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpTransactionDetails tmpTD JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
				
		-- Insert comment as traded after PCL date for these records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId, ContraTradeQty)
		SELECT DefaulterReportID, @iCommentsId_ContraTrade, ContraTradeQty
		FROM @tmpTransactionDetails--rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId
		-- #6 END - Contra trade
		print '#6 END'

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		-- #7 - Not submitted in stipulated time
		DELETE FROM @tmpTransactionDetails
		
		INSERT INTO @tmpTransactionDetails(TransactionDetailsId, TransactionMasterId, PreclearanceId, TradingPolicyId)
		SELECT TransactionDetailsId, TDAll.TransactionMasterId, PreclearanceRequestId, TM.TradingPolicyId
		FROM @tmpTransactionDetailsAll TDAll JOIN tra_TransactionMaster_OS TM ON TDAll.TransactionMasterId = TM.TransactionMasterId
		WHERE DisclosureTypeCodeId <> 147001

		-- Update last submission date where preclearance is taken
		UPDATE tmpTD
		SET PCLApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
			--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
			LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.PreclearanceId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				

		-- Update last submission date where preclearance is not taken
		UPDATE tmpTD
		SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(DateOfAcquisition,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 1),null,1,1,0,116001))--DATEADD(D, ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 0), DateOfAcquisition)
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
		WHERE /*TM.DisclosureTypeCodeId = 147002 AND*/ PreclearanceRequestId IS NULL
		
		 
		
		DELETE tmpTD
		FROM @tmpTransactionDetails tmpTD JOIN @tmpTransactionDetailsAll tmpTDAll ON tmpTD.TransactionDetailsId = tmpTDAll.TransactionDetailsId
		WHERE tmpTD.LastSubmissionDate >= SubmissionDate

		-- Insert transaction details records in defaulter report
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS

		-- Insert records in defaulter report table for preclearance if not exists
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate)
		SELECT DISTINCT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, null, null, null, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON ISNULL(DefRpt.PreclearanceRequestId, 0) = ISNULL(tmpTD.PreclearanceId, 0) AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
		WHERE DefRpt.DefaulterReportID IS NULL
			AND PreclearanceId IS NOT NULL
		
		-- Insert comment as blank for for this records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NA
		FROM rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		-- Insert records for trade details
		-- Insert records for trade details
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate)
		SELECT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, tmpTD.TransactionMasterId, tmpTD.TransactionDetailsId, @iDisclosure_Required, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate
		FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
			LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
		WHERE DefRpt.DefaulterReportID IS NULL

		UPDATE tmpTD
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpTransactionDetails tmpTD JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
	
		-- Insert comment as traded after PCL date for these records
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NotSubmittedInTime
		FROM @tmpTransactionDetails--rpt_DefaulterReport_OS 
		--WHERE DefaulterReportID > @nMaxDefaulterId
		
		print '#7 END'
		-- #7 END - Not submitted in stipulated time

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		-- #8 - Preclearance not taken
		
		DELETE FROM @tmpTransactionDetails
		-- Table @tmpUserTrans is populated in #6 Contra trde.
		INSERT INTO @tmpTMIds(TransactionMasterId)
		SELECT DISTINCT TM.TransactionMasterId
		FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		JOIN @tmpUserTrans tmpUF ON UF.UserInfoId = tmpUF.UserInfoId
		WHERE DateOfAcquisition >= MinAcqDate
		AND PreclearanceRequestId IS NULL

		-- Run cursor here
		OPEN curTmpTMIds

		FETCH NEXT FROM curTmpTMIds 
		INTO @nTransactionMasterId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @tmpTransactionDetails(TransactionDetailsId)
			EXECUTE @RC = st_tra_TransactionMasterIsPCLReqOverride_OS
			   @nTransactionMasterId
			  ,@inp_UpdateTD
			  ,@out_nReturnValue OUTPUT
			  ,@out_nSQLErrCode OUTPUT
			  ,@out_sSQLErrMessage OUTPUT

			FETCH NEXT FROM curTmpTMIds 
			INTO @nTransactionMasterId
		END

		CLOSE curTmpTMIds;
		DEALLOCATE curTmpTMIds;

		-- Delete transaction detail ids from from temp table for which PCL NOt taken comment already exists
		DELETE tmpTD
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpTransactionDetails tmpTD ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
			JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRpt.DefaulterReportID = DefRptCmt.DefaulterReportID
		WHERE CommentCodeId = @iCommentsId_PCLNotTaken
		
		-- If records exist in temp table, insert them into Reprot table
		IF EXISTS(SELECT * FROM @tmpTransactionDetails)
		BEGIN

			-- Update last submission date where preclearance is taken
			UPDATE tmpTD
			SET PCLApplicableTill = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001)),--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate),
				--LastSubmissionDate = DATEADD(D, TP.StExTradeDiscloSubmitLimit, ELApp.EventDate)
				LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(ELApp.EventDate,TP.PreClrApprovalValidityLimit,null,0,1,0,116001))--DATEADD(D, TP.PreClrCOApprovalLimit, ELApp.EventDate)
			FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionMaster_OS TM ON tmpTD.PreclearanceId = TM.PreclearanceRequestId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
				JOIN eve_EventLog ELApp ON EventCodeId = 153046 AND ELApp.MapToTypeCodeId = 132015 AND ELApp.MapToId = TM.PreclearanceRequestId				

			-- Update last submission date where preclearance is not taken
			UPDATE tmpTD
			SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(DateOfAcquisition,ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 1),null,1,1,0,116001))--DATEADD(D, ISNULL(TP.StExTradePerformDtlsSubmitToCOByInsdrLimit, 0), DateOfAcquisition)
			FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
				JOIN tra_TransactionMaster_OS TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			WHERE /*TM.DisclosureTypeCodeId = 147002 AND*/ PreclearanceRequestId IS NULL

			-- Insert transaction details records in defaulter report
			SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS

			-- Insert records in defaulter report table for preclearance if not exists
			INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, LastSubmissionDate)
			SELECT DISTINCT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, null, null, null, TM.UserInfoId, ForUserInfoId, tmpTD.LastSubmissionDate
			FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
				JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId				
				LEFT JOIN rpt_DefaulterReport_OS DefRpt ON ISNULL(DefRpt.PreclearanceRequestId, 0) = ISNULL(tmpTD.PreclearanceId, 0) AND DefRpt.TransactionMasterId IS NULL AND NonComplainceTypeCodeId = @iNonComplianceType_PCL
			WHERE DefRpt.DefaulterReportID IS NULL
				AND PreclearanceId IS NOT NULL
			
			-- Insert comment as blank for for this records
			INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
			SELECT DefaulterReportID, @iCommentsId_NA
			FROM rpt_DefaulterReport_OS 
			WHERE DefaulterReportID > @nMaxDefaulterId

			SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
			-- Insert records for trade details
			INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, PreclearanceRequestId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative)
			SELECT CASE WHEN PreclearanceId IS NULL THEN @iNonComplianceType_PNT ELSE @iNonComplianceType_PCL END, PreclearanceId, TM.TransactionMasterId, tmpTD.TransactionDetailsId, @iDisclosure_Required, TM.UserInfoId, ForUserInfoId
			FROM @tmpTransactionDetails tmpTD JOIN tra_TransactionDetails_OS TD ON tmpTD.TransactionDetailsId = TD.TransactionDetailsId
				JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
				LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
			WHERE DefRpt.DefaulterReportID IS NULL

			UPDATE tmpTD
			SET DefaulterReportId = DefRpt.DefaulterReportID
			FROM @tmpTransactionDetails tmpTD JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = tmpTD.TransactionDetailsId
		
			-- Insert comment as traded after PCL date for these records
			INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
			SELECT DefaulterReportID, @iCommentsId_PCLNotTaken
			FROM @tmpTransactionDetails--rpt_DefaulterReport_OS 
			--WHERE DefaulterReportID > @nMaxDefaulterId
		
		END
		-- #8 END - Preclearance not taken
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		-- #9 Traded Restricted List company
		--Declare @nMaxDefaulterId int
		DECLARE @iCommentsId_RL INT = 169010

		CREATE TABLE #tempRLDetails(ID INT IDENTITY(1,1),RlCompanyId INT, UserId INT,MaptoId INT,ApplicableFromDate DATETIME,
							ApplicableToDate DATETIME,ApplicabilityID INT)
	
		INSERT INTO #tempRLDetails (RlCompanyId, UserId,MaptoId)
		SELECT 	RlCompanyId,ar.UserInfoId,Min(rl.MaptoId) AS MaptoId
		FROM vw_ApplicabilityMasterCurrentRL  rl JOIN vw_ApplicableRLForUser AR ON --rl.RlCompanyId = AR.RlCompanyId 
		  rl.ApplicabilityId=AR.ApplicabilityMstId AND rl.MaptoId=AR.MaptoId  
		GROUP BY RlCompanyId, ar.UserInfoId--,MaptoId

		UPDATE tmp
		SET ApplicableFromDate=Viwin.ApplicableFromDate,
		ApplicableToDate=Viwin.ApplicableToDate,
		ApplicabilityID=Viwin.ApplicabilityId
		FROM #tempRLDetails tmp JOIN vw_ApplicabilityMasterCurrentRL Viwin
		ON tmp.MaptoId = Viwin.MapToId AND tmp.RlCompanyId=Viwin.RlCompanyId 

		CREATE TABLE #tempRLDefaulter(ID INT IDENTITY(1,1), UserId INT,CompanyId INT)

		INSERT INTO #tempRLDefaulter
		SELECT ForUserInfoId,CompanyId FROM tra_TransactionDetails_OS WHERE CompanyId IN(
		SELECT tm.RlCompanyId
		FROM #tempRLDetails tm 
		WHERE DateOfAcquisition  BETWEEN tm.ApplicableFromDate AND tm.ApplicableToDate)

		DELETE tm1
		FROM #tempRLDefaulter tm1 
		JOIN #tempRLDetails tm ON tm.RlCompanyId = tm1.CompanyId --AND tm.UserId=tm1.UserId 
		JOIN tra_TransactionDetails_OS TOS ON TOS.CompanyId = tm1.CompanyId AND TOS.ForUserInfoId = tm1.UserId
		JOIN rpt_DefaulterReport_OS  DR ON tm1.CompanyId = DR.RlCompanyId AND tm1.UserId = DR.UserInfoIdRelative AND DR.TransactionDetailsId=TOS.TransactionDetailsId
			AND DR.TransactionMasterId = TOS.TransactionMasterId and DR.RLApplicableFromDate = tm.ApplicableFromDate AND DR.RLApplicableToDate = tm.ApplicableToDate

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport_OS
		
		INSERT INTO rpt_DefaulterReport_OS(NonComplainceTypeCodeId, TransactionMasterId, TransactionDetailsId, InitialContinousPeriodEndDisclosureRequired, UserInfoID, UserInfoIdRelative, RLCompanyId, LastSubmissionDate, RLApplicableFromDate, RLApplicableToDate, PeriodEndDate)
		SELECT  170005, TOS.TransactionMasterId, TOS.TransactionDetailsId, 165001, TMO.UserInfoId,TOS.ForUserInfoId, tm1.CompanyId, tm.ApplicableToDate, tm.ApplicableFromDate, tm.ApplicableToDate, TMO.PeriodEndDate
	 
		FROM #tempRLDefaulter tm1 JOIN #tempRLDetails tm ON tm.RlCompanyId = tm1.CompanyId --AND tm.UserId=tm1.UserId 
		JOIN tra_TransactionDetails_OS TOS ON TOS.CompanyId = tm1.CompanyId AND TOS.ForUserInfoId = tm1.UserId
		JOIN tra_TransactionMaster_OS TMO ON TMO.TransactionMasterId = TOS.TransactionMasterId AND tm.UserId=TMO.UserInfoId
		--LEFT JOIN rpt_DefaulterReport_OS DefRpt ON DefRpt.TransactionDetailsId = TOS.TransactionDetailsId
		--WHERE DefRpt.DefaulterReportID IS NULL

		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_RL
		FROM rpt_DefaulterReport_OS 
		WHERE DefaulterReportID > @nMaxDefaulterId

		DROP TABLE #tempRLDetails
		DROP TABLE #tempRLDefaulter

		-- #9 END - Traded Restricted List company
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
