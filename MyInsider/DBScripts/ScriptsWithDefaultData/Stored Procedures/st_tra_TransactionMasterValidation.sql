IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionMasterValidation')
DROP PROCEDURE [dbo].[st_tra_TransactionMasterValidation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check whether the disclosure data to be entered for new entry or updation is valid.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		12-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		29-May-2015		@nDisclosureType is initialized
Arundhati		02-Jul-2015		Condition for case #3 is changed
Arundhati		11-Jul-2015		Added check to avoid duplicate submission of details/softcopy/hardcopy. Event log was getting generated twice and so the report was shown incoorectly.
Parag			08-Oct-2015		Added validation for period end disclosure - new case #29, #30, #31
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Parag			02-Nov-2015		Made change to get correct TP for period end disclosure validation
Tushar			05-May-2016		Remove Check to validate if initial disclosure has been submitted when saving continuous and PE disclosure.
								This check is removed to allow continuous disclosure transaction to be added by mass upload even though initial disclosure not submitted.
								this change was done after discussing with Deepak on Phone on 5 May 2016
Parag			05-May-2016		Made change in check for initial disclosure is submitted before submitting continuous and period end disclosure
								Instead of checking intial disclosure confirm now check initial disclosure enter event. 
								This is done for auto submit past PNT when submit initial disclosure
Parag			27-Oct-2016		Made change to add validation for continuous disclosure to check if all earlier not submitted transaction whos date of acquisition is less than 
								current transcation's date of acquistion are submitted or not. If not submitted then show error message.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionMasterValidation]
	@inp_iTransactionMasterId	INT,
	--@inp_sPreclearanceRequestId	INT,
	@inp_iUserInfoId	INT,
	@inp_iDisclosureTypeCodeId	INT,
	@inp_iTransactionStatusCodeId	INT = 148002,
	@inp_sNoHoldingFlag	bit = 0,
	@inp_iTradingPolicyId	INT,
	@inp_dtPeriodEndDate	DATETIME,
	@inp_iIsCalledFromTransactionDetails	BIT,
	@inp_nUserId INT,									-- Id of the user inserting/updating the TransactionMaster
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRANSACTIONDETAILS_VALIDATION INT = 17043 -- Error occurred while validating transaction master entry.
	
	/************  Constants  *******************/
	-- Disclosure type {Initial / Continuous / Period End}
	DECLARE @nDisclosureType_Initial INT = 147001
	DECLARE @nDisclosureType_Continuous INT = 147002
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	
	-- Transaction Type {Buy / Sell}
	--DECLARE @nTransaction_Buy INT = 143001
	--DECLARE @nTransaction_Sell INT = 143002
	
	-- Security type {Equity / Derivative}
	--DECLARE @nSecurityType_Equity INT = 139001
	--DECLARE @nSecurityType_Derivative INT = 139002
	
	--- Error codes
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_ContiExists INT = 17049 -- Case #1 - Cannot save/submit Period End disclosure, since continuous disclosure is made for the date after period end date.
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_PEExists INT = 17050 -- Case #2 - Cannot save/submit Period End disclosure, since period end disclosure is made for the date after period end date.
	DECLARE @ERR_ContiDisclosureNotAllowed_PEExists INT = 17048 -- Case #3 - Cannot save/submit Continuous disclosure, since period end disclosure for the future period is made.
	DECLARE @ERR_InitDisclosureNotFound INT = 17051 -- Case #4 -- Cannot save continuous or period end disclosure, as Initial disclsure is not submitted.
	DECLARE @ERR_ContiDisclosureNotAllowed_PreclearanceRejected INT = 17060 -- Case #5 - If Preclearance request is rejected, user should not enter details against it

	DECLARE @ERR_TransactionAlreadySubmitted INT = 17335
	DECLARE @ERR_SoftCopyAlreadySubmitted INT = 17336
	DECLARE @ERR_HardCopyAlreadySubmitted INT = 17337
	DECLARE @ERR_HardCopyToExAlreadySubmitted INT = 17338
	
	DECLARE @ERR_ContiDisclosureNotAllowed_PastPENotSubmited INT = 17390 -- CASE #29 - Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_PastPENotSubmited INT = 17391 -- Case #30 - Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_PreClearanceIsOpen INT = 17392 -- Case #31 - Cannot submit Period End disclosure, since pre-clearance is open.
	
	DECLARE @ERR_ContiDisclosureNotAllowed_PrevTranNOTSubmited INT = 17530 -- Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whos date of acquisition earlier than current transcation's date of acquistion.
	
	DECLARE @nTransStatus_DocumentUploaded INT = 148001,
		@nTransStatus_NotConfirmed INT = 148002,
		@nTransStatus_Confirmed INT = 148003,
		@nTransStatus_SoftCopySubmitted INT = 148004,
		@nTransStatus_HardCopySubmitted INT = 148005,
		@nTransStatus_HardCopySubmittedByCO INT = 148006,
		@nTransStatus_Submitted INT = 148007

	DECLARE @nEventCodeID_InitialDisclosureDetailsEntered INT = 153007
		,@nEventCodeID_InitialDisclosureUploaded INT = 153008
		,@nEventCodeID_InitialDisclosureSubmittedSoftcopy INT = 153009
		,@nEventCodeID_InitialDisclosureSubmittedHardcopy INT = 153010
		,@nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange INT = 153012
		,@nEventCodeID_InitialDisclosureConfirmed INT = 153035

		,@nEventCodeID_ContinuousDisclosureDetailsEntered INT = 153019
		,@nEventCodeID_ContinuousDisclosureUploaded INT = 153020
		,@nEventCodeID_ContinuousDisclosureSubmittedSoftcopy INT = 153021
		,@nEventCodeID_ContinuousDisclosureSubmittedHardcopy INT = 153022
		,@nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange INT = 153024
		,@nEventCodeID_ContinuousDisclosureConfirmed INT = 153036

		,@nEventCodeID_PEDisclosureDetailsEntered INT = 153029
		,@nEventCodeID_PEDisclosureUploaded INT = 153030
		,@nEventCodeID_PEDisclosureSubmittedSoftcopy INT = 153031
		,@nEventCodeID_PEDisclosureSubmittedHardcopy INT = 153032
		,@nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange INT = 153034
		,@nEventCodeID_PEDisclosureConfirmed INT = 153037

	
	-- Variables
	DECLARE @nDisclosureType INT
	DECLARE @dtAcqusition DATETIME
	DECLARE @dtPeriodEndForContinuous DATETIME
	DECLARE @nPreclearanceId INT
	--DECLARE @nTotalTradingQuantity INT
	--DECLARE @nTransactionDetailsIdOld INT

	DECLARE @nPeriodType INT
	DECLARE @nYear INT
	--DECLARE @dtDateOfAcqOld DATETIME
	--DECLARE @nYearCodeIdOld INT
	--DECLARE @nPeriodCodeIdOld INT
	--DECLARE @nYearCodeIdNew INT
	--DECLARE @nPeriodCodeIdNew INT
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''


		SELECT @nDisclosureType = @inp_iDisclosureTypeCodeId
		
		SELECT @nPreclearanceId = PreclearanceRequestId,
			@nDisclosureType = DisclosureTypeCodeId,
			@inp_iUserInfoId = CASE WHEN @inp_iUserInfoId IS NULL THEN UserInfoId ELSE @inp_iUserInfoId END
		FROM tra_TransactionMaster 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		-- Validation checks for resubmission. If transaction is already submitted, and user tries to submit again similar for Scp and Hcp
		IF @inp_iTransactionMasterId <> 0 AND @inp_iTransactionStatusCodeId IN (@nTransStatus_Submitted, @nTransStatus_SoftCopySubmitted, @nTransStatus_HardCopySubmitted, @nTransStatus_HardCopySubmittedByCO)
		BEGIN
			--print 'Check for duplicate status'
			IF @inp_iTransactionStatusCodeId = @nTransStatus_Submitted 
				AND EXISTS(
					SELECT * FROM eve_EventLog
					WHERE EventCodeId IN (@nEventCodeID_InitialDisclosureDetailsEntered, @nEventCodeID_ContinuousDisclosureDetailsEntered, @nEventCodeID_PEDisclosureDetailsEntered)
						AND MapToId = @inp_iTransactionMasterId)
			BEGIN
				--print 'Cannot Submit details'
				SET @out_nReturnValue = @ERR_TransactionAlreadySubmitted
			END
							
			IF @inp_iTransactionStatusCodeId = @nTransStatus_SoftCopySubmitted 
				AND EXISTS(
					SELECT * FROM eve_EventLog
					WHERE EventCodeId IN (@nEventCodeID_InitialDisclosureSubmittedSoftcopy, @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy, @nEventCodeID_PEDisclosureSubmittedSoftcopy)
						AND MapToId = @inp_iTransactionMasterId)
			BEGIN
				--print 'Cannot Submit soft copy'
				SET @out_nReturnValue = @ERR_SoftCopyAlreadySubmitted
			END

			IF @inp_iTransactionStatusCodeId = @nTransStatus_HardCopySubmitted 
				AND EXISTS(
					SELECT * FROM eve_EventLog
					WHERE EventCodeId IN (@nEventCodeID_InitialDisclosureSubmittedHardcopy, @nEventCodeID_ContinuousDisclosureSubmittedHardcopy, @nEventCodeID_PEDisclosureSubmittedHardcopy)
						AND MapToId = @inp_iTransactionMasterId)
			BEGIN
				--print 'Cannot Submit hard copy'
				SET @out_nReturnValue = @ERR_HardCopyAlreadySubmitted
			END

			IF @inp_iTransactionStatusCodeId = @nTransStatus_HardCopySubmittedByCO 
				AND EXISTS(
					SELECT * FROM eve_EventLog
					WHERE EventCodeId IN (@nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange, @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange, @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange)
						AND MapToId = @inp_iTransactionMasterId)
			BEGIN
				--print 'Cannot Submit hard copy to exchange'
				SET @out_nReturnValue = @ERR_HardCopyToExAlreadySubmitted
			END
			IF @out_nReturnValue <> 0
			BEGIN
				RETURN @out_nReturnValue
			END

		END

		
		-- Validation Checks for initial disclosures
		IF @nDisclosureType = @nDisclosureType_Initial
		BEGIN
			-- 
			-- Case #
			print 'Initial'
			--------------------------------------------END Case # ------------------------------------------------------------------			
			
		END
		ELSE 
		BEGIN
			IF @nDisclosureType = @nDisclosureType_Continuous
			BEGIN
				print 'Continuous'
				IF @inp_iTransactionMasterId > 0
				BEGIN
					-- While submitting continuous disclosure, check if all transaction with date of acquisition prior to current transcation's date of acquisition is sumitted
					DECLARE @dtCurAcqusition DATETIME

					SELECT @dtCurAcqusition = MIN(DateOfAcquisition) FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId
					IF EXISTS (SELECT DateOfAcquisition  FROM tra_TransactionDetails td
								LEFT JOIN tra_TransactionMaster tm ON td.TransactionMasterId = tm.TransactionMasterId
								WHERE td.TransactionMasterId <> @inp_iTransactionMasterId AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
								AND tm.UserInfoId = @inp_nUserId AND tm.TransactionStatusCodeId in (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
								AND td.DateOfAcquisition < @dtCurAcqusition)
					BEGIN
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PrevTranNOTSubmited
						RETURN @out_nReturnValue
					END
					--------------------------------------------END------------------------------------------------------------------


					-- While submitting/saving Continuous disclosure, check if PE disclosure for the previous period is not there. 
					-- If such record is found, do not allow the user to save/submit the continuous disclosure untile all previous period end disclosure are submitted
					-- Case #29
					
					IF EXISTS(SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
								WHERE 
									TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
									AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
									AND CONVERT(date, TM.PeriodEndDate) < (SELECT CONVERT(date, MIN(TD.DateOfAcquisition)) FROM tra_TransactionDetails TD WHERE TD.TransactionMasterId = @inp_iTransactionMasterId)
									AND TM.UserInfoId = @inp_iUserInfoId)
					BEGIN 
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PastPENotSubmited
						RETURN @out_nReturnValue
					END
					--------------------------------------------END Case #29 ------------------------------------------------------------------
					
					-- While submitting/saving Continuous disclosure, check if PE disclosure for the same period or any period after that is not there. If such record is found, do not allow the user to save/submit the continuous disclosure
					-- Case #3
					SELECT @dtAcqusition = MAX(DateOfAcquisition) FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId
					
					SELECT @nPeriodType = CASE 
											WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
											WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
											WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
											WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
											ELSE TP.DiscloPeriodEndFreq 
										 END 
					FROM tra_TransactionMaster TM 
					JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId 
																AND TM.TransactionMasterId = @inp_iTransactionMasterId
					JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId 

					-- Find Year
					SELECT @nYear = YEAR(@dtAcqusition)
					
					IF MONTH(@dtAcqusition) < 4
					BEGIN
						SET @nYear = @nYear - 1
					END

					-- Find PeriodEndDate corresponding to the date of acqusition
					SELECT TOP(1) @dtPeriodEndForContinuous = DATEADD(DAY, -1, DATEADD(YEAR, @nYear - 1970, CONVERT(DATETIME, Description))) FROM com_Code 
					WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType AND @dtAcqusition <= DATEADD(DAY, -1, DATEADD(YEAR, @nYear - 1970, CONVERT(DATETIME, Description)))
					ORDER BY CONVERT(DATETIME, Description) ASC
						
					
					IF EXISTS (SELECT TransactionMasterId
								FROM tra_TransactionMaster TM
									JOIN eve_EventLog EL ON EL.UserInfoId = TM.UserInfoId AND EL.EventCodeId IN (153029, 153030)
										AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
								WHERE TM.PeriodEndDate >= @dtPeriodEndForContinuous AND EL.UserInfoId = @inp_iUserInfoId)
					BEGIN
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PEExists
						RETURN @out_nReturnValue
					END
					--------------------------------------------END Case #3 ------------------------------------------------------------------
					
					-- If Preclearance request is rejected, user should not enter details against it
					-- CASE #5
					IF EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest 
								WHERE PreclearanceRequestId = @nPreclearanceId AND PreclearanceStatusCodeId = 144003)
					BEGIN
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PreclearanceRejected
						RETURN @out_nReturnValue					
					END
					----------------------------------------------END Case #5 ----------------------------------------------------------------
				END

			END
			ELSE IF @nDisclosureType = @nDisclosureType_PeriodEnd
			BEGIN
				print 'Period End Disclosure checks'
				
				-- While submitting/saving period end disclosure, check if PE disclosure for the previous period is not there. 
				-- If such record is found, do not allow the user to save/submit the period end disclosure until all previous period end disclosure are submitted
				-- Case #30
				
				IF EXISTS(SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
							WHERE 
								TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
								AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
								AND CONVERT(date, TM.PeriodEndDate) < CONVERT(date, @inp_dtPeriodEndDate)
								AND TM.UserInfoId = @inp_iUserInfoId)
				BEGIN 
					SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_PastPENotSubmited
					RETURN @out_nReturnValue
				END
				--------------------------------------------END Case #30 ------------------------------------------------------------------
				
				-- While submitting/saving period end disclosure, check if pre-clearance request are open. 
				-- If such record is found, do not allow the user to save/submit the period end disclosure until all pre-clearance request are close
				-- Case #31
				
				-- pre-clearance is open when preclearance is requested OR preclearance is approve and does not have not trading reason and trading quantity is less then approve quantity 
				IF EXISTS(SELECT PCR.PreclearanceRequestId FROM tra_PreclearanceRequest PCR
							WHERE 
								(PCR.PreclearanceStatusCodeId = 144001 
								OR (PCR.PreclearanceStatusCodeId = 144002 AND PCR.ReasonForNotTradingText IS NULL AND 
										PCR.SecuritiesToBeTradedQty > (SELECT COALESCE(SUM(Quantity),0) FROM tra_TransactionMaster TM 
																		JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
																		WHERE TM.PreclearanceRequestId = PCR.PreclearanceRequestId)))
								AND PCR.UserInfoId = @inp_iUserInfoId)
				BEGIN 
					SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_PreClearanceIsOpen
					RETURN @out_nReturnValue
				END
				--------------------------------------------END Case #31 ------------------------------------------------------------------
				
				---Removed validation while submitting earlier dated form G softcopy
				-- While submitting/saving period end disclosure, check that continuous disclosure does not exist for the period after the period end date
				-- Case #1
				--IF EXISTS (SELECT TM.TransactionMasterId 
				--			FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
				--				JOIN eve_EventLog EL ON EL.UserInfoId = TM.UserInfoId AND EL.EventCodeId IN (153019, 153020)-- 153036
				--					AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
				--			WHERE DateOfAcquisition > @inp_dtPeriodEndDate
				--				AND TM.UserInfoId = @inp_iUserInfoId)
				--BEGIN
				--	SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_ContiExists
				--	RETURN @out_nReturnValue
				--END
				--------------------------------------------END Case #1 ------------------------------------------------------------------
				
				---Removed validation while submitting earlier dated form G softcopy
				-- While submitting/saving PE disclosure, check if PE disclosure for the same period or any period after that is not there. If such record is found, do not allow the user to save/submit the PE disclosure
				-- Case #2
				--IF EXISTS (SELECT TransactionMasterId
				--			FROM tra_TransactionMaster TM
				--				JOIN eve_EventLog EL ON EL.UserInfoId = TM.UserInfoId AND EL.EventCodeId IN (153029, 153030)-- 153037 
				--					AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
				--			WHERE TM.PeriodEndDate > @inp_dtPeriodEndDate AND EL.UserInfoId = @inp_iUserInfoId)
				--BEGIN
				--	SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_PEExists
				--	RETURN @out_nReturnValue
				--END				
				--------------------------------------------END Case #2 ------------------------------------------------------------------
						
			END
			/*
				Remove Check to validate if initial disclosure has been submitted when saving continuous and PE disclosure.
				This check is removed to allow continous disclosre transaction to be added by mass upload even though inital disclosre not submitted.
				this change was done after discussing with Deepak on Phone on 5 May 2016
				
			*/
			print 'Common checks for Conti & PE disclosure'
			-- Continuous/PE disclosure cannot be added if Initial disclosure is not confirmed by user.
			-- Case #4
			IF @inp_iTransactionMasterId > 0 AND NOT EXISTS(SELECT * FROM eve_EventLog WHERE EventCodeId = 153007 AND UserInfoId = @inp_iUserInfoId)
			BEGIN
				SET @out_nReturnValue = @ERR_InitDisclosureNotFound
				RETURN @out_nReturnValue
			END
			--------------------------------------------END Case #4 ------------------------------------------------------------------
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_VALIDATION
	END CATCH
END
