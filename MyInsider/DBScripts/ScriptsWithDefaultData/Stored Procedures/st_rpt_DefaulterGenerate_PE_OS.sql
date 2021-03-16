IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterGenerate_PE_OS')
DROP PROCEDURE [dbo].[st_rpt_DefaulterGenerate_PE_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to generate data for PE disclousre defaulter. This procedure will populate the table for defaulters for Non-Compliance type = PE.
				1) Users who have not submitted PE disclousres after the last submission date for PE disclosure
				2) USers who have submitted PE disclosure, but after last submission date

Returns:		0, if Success.
				
Created by:		hemant
Created on:		05-Jan-2021

Modification History:
Modified By		Modified On		Description

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DefaulterGenerate_PE_OS]
	@inp_dtLastRunDate		DATETIME
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	--DECLARE @sSQL NVARCHAR(MAX)
	--DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @dtLastRunDate DATETIME = @inp_dtLastRunDate
	--DECLARE @nDiscloInitLimitMin INT = 0
	--DECLARE @nDiscloInitLimitMax INT = 0

	--DECLARE @nEventCodeId_BecomesInsider INT = 153003
	--DECLARE @nEventCodeId_UserCreated INT = 153001
	
	--DECLARE @nEventCodeId_PEDocumentUploaded INT = 153030
	DECLARE @nEventCodeId_PEDetailsEntered INT = 153062

	DECLARE @iCommentsId_NotSubmittedInTime INT = 169002
	DECLARE @iCommentsId_NotSubmitted INT = 169001
	
	DECLARE @iDisclosure_Required INT = 165001
	--DECLARE @iDisclosure_NotRequired INT = 165002

	DECLARE @iNonComplianceType_PE INT = 170003
	
	DECLARE @tmpPESubmissions TABLE(DefaulterReportId BIGINT)
	DECLARE @tmpTransactions TABLE(DefaulterReportId BIGINT, TransactionMasterId BIGINT, DetailsSubmissionDate DATETIME, PeriodEndDate Datetime, UserInfoId INT, LastSubmissionDate DATETIME, CommentExists INT DEFAULT 0, ToBeDeleted INT DEFAULT 0)
	
	--DECLARE @nMaxDefaulterId INT
	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))--'2015-10-01'--
	DECLARE @nMaxDefaulterId INT
	
	BEGIN TRY
		print 'st_rpt_DefaulterGenerate_PE_OS'
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''


		-- DefaulterReport table is populated with the post dates records for PE disclosures with last submission date.
		
		-- Take all submissions for PE type done after last run
		INSERT INTO @tmpTransactions(TransactionMasterId, PeriodEndDate, UserInfoId, DetailsSubmissionDate)
		SELECT TransactionMasterId, PeriodEndDate, TM.UserInfoId, EL.EventDate
		FROM tra_TransactionMaster_OS TM JOIN eve_EventLog EL ON EventCodeId = @nEventCodeId_PEDetailsEntered AND MapToTypeCodeId = 132005 
			AND MapToId = TM.TransactionMasterId 
			AND (@dtLastRunDate IS NULL OR EventDate > @dtLastRunDate)

		-- Update temp table with DefaulterReportId
		UPDATE tmpTM
		SET DefaulterReportId = DefRpt.DefaulterReportID, 
			LastSubmissionDate = DefRpt.LastSubmissionDate,
			tmptm.CommentExists = CASE WHEN DefRptCmt.DefaulterReportID IS NULL THEN 0 ELSE 1 END
		FROM @tmpTransactions tmpTM JOIN rpt_DefaulterReport_OS DefRpt ON tmpTM.UserInfoId = DefRpt.UserInfoID AND tmpTM.PeriodEndDate = DefRpt.PeriodEndDate AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PE
			LEFT JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRpt.DefaulterReportID = DefRptCmt.DefaulterReportID
		
		UPDATE tmpTM
		SET LastSubmissionDate = (SELECT dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate,ISNULL(DiscloPeriodEndToCOByInsdrLimit, 1),null,1,1,0,116001))--DATEADD(D, ISNULL(DiscloPeriodEndToCOByInsdrLimit, 0), TM.PeriodEndDate)
		FROM @tmpTransactions tmpTM JOIN tra_TransactionMaster_OS TM ON tmpTM.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		WHERE LastSubmissionDate IS NULL 
			AND TM.PeriodEndDate IS NOT NULL
		
		
		-- Update tmpTrans, mark the records for deletion for which LastSubmissionDate has not yet come.
		-- Those are the records, for which submission is done in time.
		UPDATE @tmpTransactions
		SET ToBeDeleted = 1
		WHERE (LastSubmissionDate >= @dtToday OR DetailsSubmissionDate < DATEADD(D, 1, LastSubmissionDate))
		
		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport
		-- Insert the records which do not exist in report table but to be reported for "Not submitted in Time"
		INSERT INTO rpt_DefaulterReport_OS
		(UserInfoID, InitialContinousPeriodEndDisclosureRequired, TransactionMasterId, LastSubmissionDate, NonComplainceTypeCodeId, PeriodEndDate)
		SELECT tmpTM.UserInfoId, @iDisclosure_Required, tmpTM.TransactionMasterId, tmpTM.LastSubmissionDate, @iNonComplianceType_PE, tmpTM.PeriodEndDate
		FROM @tmpTransactions tmpTM LEFT JOIN rpt_DefaulterReport_OS DefRpt ON tmpTM.TransactionMasterId = DefRpt.TransactionMasterId AND NonComplainceTypeCodeId = @iNonComplianceType_PE
		WHERE DefRpt.DefaulterReportID IS NULL
			AND ToBeDeleted = 0
			AND tmpTM.PeriodEndDate IS NOT NULL
			AND DetailsSubmissionDate IS NOT NULL

		UPDATE tmpTM
		SET DefaulterReportId = DefRpt.DefaulterReportID
		FROM @tmpTransactions tmpTM JOIN rpt_DefaulterReport_OS DefRpt ON tmpTM.UserInfoId = DefRpt.UserInfoID AND tmpTM.PeriodEndDate = DefRpt.PeriodEndDate AND DefRpt.NonComplainceTypeCodeId = @iNonComplianceType_PE

		-- Delete the records from Defaulter which are marked for deletion in tmpTrans
		DELETE DefRpt
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpTransactions tmpTM ON DefRpt.DefaulterReportID = tmpTM.DefaulterReportId AND ToBeDeleted = 1
		-- Delete the records from tmpTrans which are marked for deletion
		DELETE @tmpTransactions WHERE ToBeDeleted = 1
		
		-- Remaining records in tmpTrans, are not done in stipulated time, so update comment for those records
		-- There should not remain any records in tmpTrans, for which comment does not exist, if exist, insert comment for those records
		UPDATE DefRpt
		SET --defrpt.TradingDetailsSubmissionDate = DetailsSubmissionDate,
			TransactionMasterId = tmpTM.TransactionMasterId,
			defrpt.InitialContinousPeriodEndDisclosureRequired = @iDisclosure_Required
		FROM rpt_DefaulterReport_OS DefRpt JOIN @tmpTransactions tmpTM ON DefRpt.DefaulterReportID = tmpTM.DefaulterReportId
		
		UPDATE DefRptCmt
		SET CommentCodeId = @iCommentsId_NotSubmittedInTime
		FROM rpt_DefaulterReportComments_OS DefRptCmt JOIN @tmpTransactions tmpTM ON DefRptCmt.DefaulterReportID = tmpTM.DefaulterReportId

		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportId, @iCommentsId_NotSubmittedInTime
		FROM @tmpTransactions
		WHERE CommentExists = 0
			AND DefaulterReportId IS NOT NULL
		
		--- insert records for summary
		--INSERT INTO rpt_DefaulterReportDetails(DefaulterReportID, SecurityTypeCodeId, Quantity, Value, TradeBuyTransactionQty, TradeSellTransactionQty)
		--SELECT tmpTS.DefaulterReportId, tmpTS.UserInfoId, SecurityTypeCodeId, SUM(BuyQuantity), SUM(SellQuantity), SUM(ClosingBalance)
		--FROM @tmpTransactions tmpTS JOIN tra_TransactionSummary TS ON tmpTS.UserInfoId = TS.UserInfoId
		--	JOIN vw_TransactionSummaryPeriodEndDate vwTS ON vwTS.TransactionSummaryId = TS.TransactionSummaryId AND tmpTS.PeriodEndDate = vwTS.PeriodEndDate
		--GROUP BY tmpTS.DefaulterReportId, tmpTS.UserInfoId, SecurityTypeCodeId

		
		----------------------------------------------------------------------------------------------------------------------------------
		-- Check the records for which last date > Last run & Last submission date < dbo.uf_com_GetServerDate()
		INSERT INTO @tmpPESubmissions(DefaulterReportId)
		SELECT DefRpt.DefaulterReportID 
		FROM rpt_DefaulterReport_OS DefRpt LEFT JOIN rpt_DefaulterReportComments_OS DefRptCmt ON DefRpt.DefaulterReportID = DefRptCmt.DefaulterReportID
		WHERE NonComplainceTypeCodeId = @iNonComplianceType_PE 
			AND (@dtLastRunDate IS NULL OR LastSubmissionDate >= CONVERT(DATETIME, CONVERT(varchar(11), @dtLastRunDate)))
			AND LastSubmissionDate < @dtToday
			AND CommentCodeId IS NULL			

		-- Since the submission is not found before, the remaining records should be considered as Not Submitted
		INSERT INTO rpt_DefaulterReportComments_OS(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportId, @iCommentsId_NotSubmitted
		FROM @tmpPESubmissions
		WHERE DefaulterReportId IS NOT NULL	
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
