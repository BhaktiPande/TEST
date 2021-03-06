IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterGenerate_Initial')
DROP PROCEDURE [dbo].[st_rpt_DefaulterGenerate_Initial]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to generate data for initial disclousre defaulter. This procedure will populate the table for defaulters.
				1) Users who have not submitted initila disclousres after the last submission date for initial disclosure
				2) USers who have submitted initial disclosure, but after last submission date

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		21-Sep-2015

Modification History:
Modified By		Modified On		Description
Arundhati		09-Oct-2015		Document uploaded condition is not considered while considering defaulter.
Arundhati		15-Oct-2015		If not submitted after last date is over, record was getting inserted again.
Tushar			13-Jan-2016		1. Employee(Non Insider) is displayed in "Report".
								2. set last submission date if user created before Initial Disclosure before go live then
										SET last submission date = Initial Disclosure before go live
									if user created after Initial Disclosure before go live then add days for 
									    Last Submission date  = created date + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)
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
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DefaulterGenerate_Initial]
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
	DECLARE @nDiscloInitLimitMin INT = 0
	DECLARE @nDiscloInitLimitMax INT = 0

	DECLARE @nEventCodeId_BecomesInsider INT = 153003
	DECLARE @nEventCodeId_UserCreated INT = 153001
	DECLARE @nEventCodeId_DocumentUploaded INT = 153008
	DECLARE @nEventCodeId_DetailsEntered INT = 153007

	DECLARE @iCommentsId_NotSubmittedInTime INT = 169002
	DECLARE @iCommentsId_NotSubmitted INT = 169001
	
	DECLARE @iDisclosure_Required INT = 165001
	DECLARE @iDisclosure_NotRequired INT = 165002

	DECLARE @iNonComplianceType_Initial INT = 170001
	
	DECLARE @tmpNewUserId TABLE(UserInfoId INT, TradingPolicyId INT, LastSubmissionDate DATETIME, IsNew INT DEFAULT 0)
	DECLARE @tmpNewUserIdOld TABLE(UserInfoId INT)
	
	DECLARE @nMaxDefaulterId INT
	DECLARE @dtToday DATETIME = dbo.uf_com_GetServerDate()--'2015-10-01'--
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print 'st_rpt_DefaulterGenerate_Initial'
		
		SELECT @nDiscloInitLimitMin = MIN(DiscloInitLimit),
				@nDiscloInitLimitMax = MAX(DiscloInitLimit)
		FROM rul_TradingPolicy

		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END

		INSERT INTO @tmpNewUserId(UserInfoId)
		SELECT DISTINCT EL.UserInfoId
		FROM eve_EventLog EL JOIN usr_UserInfo UF ON EL.UserInfoId = UF.UserInfoId
		WHERE (EventCodeId = @nEventCodeId_BecomesInsider OR EventCodeId = @nEventCodeId_UserCreated )--AND UF.DateOfBecomingInsider IS NOT NULL))
			AND (@inp_dtLastRunDate IS NULL
				 OR	(@inp_dtLastRunDate IS NOT NULL
					AND EventDate >= DATEADD(D, -@nDiscloInitLimitMax, @dtToday)
					AND EventDate <= DATEADD(D, -@nDiscloInitLimitMin, @dtToday)))
		
			
		-- Delete those records for which submission / document upload is done
		DELETE tmp
		FROM @tmpNewUserId tmp JOIN eve_EventLog EL ON tmp.UserInfoId = EL.UserInfoId 
			AND EventCodeId IN (/*@nEventCodeId_DocumentUploaded, */@nEventCodeId_DetailsEntered) AND MapToTypeCodeId = 132005
		
		
		
		-- The records of users remaining in temp table needs to be checked for last submission date
		-- Update tradingpolicy for those users
		UPDATE tmpUser
		SET TradingPolicyId = vwTP.TradingPolicyId
		FROM @tmpNewUserId tmpUser
			JOIN (SELECT vwTP.UserInfoId, MAX(MapToId) TradingPolicyId 
					FROM vw_ApplicableTradingPolicyForUser vwTP JOIN @tmpNewUserId tmpUser ON vwTP.UserInfoId = tmpUser.UserInfoId
					GROUP by vwTP.UserInfoId) vwTP ON tmpUser.UserInfoId = vwTP.UserInfoId

		UPDATE tmpUser
		SET LastSubmissionDate =
		CASE WHEN UF.DateOfBecomingInsider IS NULL
		  THEN CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
		ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
		FROM @tmpNewUserId tmpUser JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
			JOIN rul_TradingPolicy TP ON tmpUser.TradingPolicyId = TP.TradingPolicyId
		
		-- Delete those users for which last submission date is not yet reached, or not got evaluated
		DELETE FROM @tmpNewUserId 
		WHERE LastSubmissionDate > @dtToday
			OR LastSubmissionDate IS NULL
		
		
		
		-- Delete the users for which record aleardy exist in Non-Compliance report
		DELETE tmpUser
		FROM @tmpNewUserId tmpUser JOIN rpt_DefaulterReport DefRpt ON tmpUser.UserInfoId = DefRpt.UserInfoID AND NonComplainceTypeCodeId = @iNonComplianceType_Initial

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport
		
		-- Put records for all the users in the temp table to the defaulter report table for the case Initial Disclosure Not Done
		INSERT INTO rpt_DefaulterReport
		(UserInfoID, InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, NonComplainceTypeCodeId)
		SELECT tmpUser.UserInfoId, @iDisclosure_Required, LastSubmissionDate, @iNonComplianceType_Initial
		FROM @tmpNewUserId tmpUser JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
		
		
		
		---- Insert records in comment table
		INSERT INTO rpt_DefaulterReportComments(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NotSubmitted
		FROM rpt_DefaulterReport WHERE DefaulterReportID > @nMaxDefaulterId
		
		INSERT INTO @tmpNewUserIdOld(UserInfoId)
		SELECT UserInfoId FROM @tmpNewUserId


		DELETE FROM @tmpNewUserId		
		----------------------------- Fill up table for Initial disclousre - Not Submitted in stipulated time -------------------------------------

		SELECT @nMaxDefaulterId = ISNULL(MAX(DefaulterReportID), 0) FROM rpt_DefaulterReport
		
		-- Find out users who have submitted initial disclosure after the last run of report generation
		INSERT INTO @tmpNewUserId(UserInfoId)
		SELECT UserInfoId
		FROM eve_EventLog
		WHERE (@dtLastRunDate IS NULL OR EventDate >= @dtLastRunDate)
			AND EventCodeId = @nEventCodeId_DetailsEntered
		
		--select * from @tmpNewUserId
		
		-- Update LastSubmissionDate from the earlier "Not Submitted" comment record which has to be there in DefaulterReport table 
		UPDATE tmpUser
		SET LastSubmissionDate = DfRpt.LastSubmissionDate
		FROM @tmpNewUserId tmpUser JOIN rpt_DefaulterReport DfRpt ON tmpUser.UserInfoId = DfRpt.UserInfoID AND NonComplainceTypeCodeId = @iNonComplianceType_Initial
		
		-- Update Defaulter report, change comment from 'Not submitted' to 'Not submitted within stipulated time'
		UPDATE DfRptComment
		SET CommentCodeId = @iCommentsId_NotSubmittedInTime
		FROM @tmpNewUserId tmpUser JOIN rpt_DefaulterReport DfRpt ON tmpUser.UserInfoId = DfRpt.UserInfoID AND NonComplainceTypeCodeId = @iNonComplianceType_Initial
		JOIN rpt_DefaulterReportComments DfRptComment ON DfRpt.DefaulterReportID = DfRptComment.DefaulterReportID
		WHERE tmpUser.LastSubmissionDate IS NOT NULL

		-- Evaluate LastSubmissionDate of the records for which "Not Submitted" was not evaluated
		UPDATE tmpUser
		SET TradingPolicyId = TM.TradingPolicyId
		FROM @tmpNewUserId tmpUser JOIN tra_TransactionMaster TM ON tmpUser.UserInfoId = TM.UserInfoId AND TM.DisclosureTypeCodeId = 147001
		WHERE LastSubmissionDate IS NULL
		
		UPDATE tmpUser
		SET LastSubmissionDate = CASE WHEN UF.DateOfBecomingInsider IS NULL
		  THEN CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
		ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END,
			IsNew = 1
		FROM @tmpNewUserId tmpUser JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
			JOIN rul_TradingPolicy TP ON tmpUser.TradingPolicyId = TP.TradingPolicyId
		WHERE LastSubmissionDate IS NULL
		
		--select * from @tmpNewUserId
		
		-- Delete those users for which last submission date is not yet reached, or not got evaluated
		DELETE FROM @tmpNewUserId 
		WHERE LastSubmissionDate > @dtToday
			OR LastSubmissionDate IS NULL

		-- Insert the remaining records in Defaulter report table
		INSERT INTO rpt_DefaulterReport
		(UserInfoID, InitialContinousPeriodEndDisclosureRequired, LastSubmissionDate, NonComplainceTypeCodeId)
		SELECT tmpUser.UserInfoId, @iDisclosure_Required, LastSubmissionDate, @iNonComplianceType_Initial
		FROM @tmpNewUserId tmpUser JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
		WHERE IsNew = 1
		
			
		-- Insert records in comment table
		INSERT INTO rpt_DefaulterReportComments(DefaulterReportID, CommentCodeId)
		SELECT DefaulterReportID, @iCommentsId_NotSubmittedInTime
		FROM rpt_DefaulterReport WHERE DefaulterReportID > @nMaxDefaulterId

		INSERT INTO @tmpNewUserIdOld(UserInfoId)
		SELECT UsrNew.UserInfoId FROM @tmpNewUserId UsrNew LEFT JOIN @tmpNewUserIdOld UsrOld ON UsrNew.UserInfoId = UsrOld.UserInfoId
		WHERE UsrOld.UserInfoId IS NULL

		-- Insert records in details table for security wise summary
		--INSERT INTO rpt_DefaulterReportDetails
		----(DefaulterReportID,TransactionDetailsId,TransactionTypeCodeId,SecurityTypeCodeId,TradeBuyTransactionQty,TradeSellTransactionQty,Quantity,Value)
		--(DefaulterReportID,SecurityTypeCodeId,Quantity,Value)
		--SELECT Defrpt.DefaulterReportID/*, tmpUsr.UserInfoId*/, TD.SecurityTypeCodeId, SUM(TD.Quantity), SUM(TD.Value)
		--FROM @tmpNewUserIdOld tmpUsr JOIN rpt_DefaulterReport Defrpt ON tmpUsr.UserInfoId = Defrpt.UserInfoID AND Defrpt.NonComplainceTypeCodeId = @iNonComplianceType_Initial
		--JOIN tra_TransactionMaster TM ON tmpUsr.UserInfoId = TM.UserInfoId
		--JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
		--WHERE DisclosureTypeCodeId = 147001
		--GROUP BY Defrpt.DefaulterReportID/*, tmpUsr.UserInfoId*/, TD.SecurityTypeCodeId
		
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
