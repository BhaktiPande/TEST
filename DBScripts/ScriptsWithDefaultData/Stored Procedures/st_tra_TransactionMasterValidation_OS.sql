IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionMasterValidation_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionMasterValidation_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check whether the disclosure data to be entered for new entry or updation is valid.

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		16-Aug-2019
 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionMasterValidation_OS]
	@inp_iTransactionMasterId	INT,
	@inp_iUserInfoId	INT,
	@inp_iDisclosureTypeCodeId	INT,
	@inp_dtPeriodEndDate	DATETIME,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRANSACTIONDETAILS_VALIDATION INT = 53137 -- Error occurred while validating transaction master entry.
	
	--- Error codes
	DECLARE @ERR_ContiDisclosureNotAllowed_PEExists INT = 53138 -- Cannot save/submit Continuous disclosure, since period end disclosure for the future period is made.
	DECLARE @ERR_ContiDisclosureNotAllowed_PastPENotSubmited INT = 53139 -- Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_PastPENotSubmited INT = 53140 -- Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.
	DECLARE @ERR_PeriodEndDisclosureNotAllowed_PreClearanceIsOpen INT = 53141 -- Cannot submit Period End disclosure, since pre-clearance is open.
	
	DECLARE @nDisclosureType_Continuous INT = 147002
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	DECLARE @nTransStatus_DocumentUploaded INT = 148001
	DECLARE @nTransStatus_NotConfirmed INT = 148002

	-- Variables
	DECLARE @nDisclosureType INT
	DECLARE @dtAcqusition DATETIME
	DECLARE @dtPeriodEndForContinuous DATETIME
	DECLARE @nPreclearanceId INT
	DECLARE @nPeriodType INT
	DECLARE @nYear INT
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
		FROM tra_TransactionMaster_OS 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		print '@nDisclosureType'print @nDisclosureType
		IF @nDisclosureType = @nDisclosureType_Continuous
		BEGIN
			print 'Continuous'
			IF @inp_iTransactionMasterId > 0
			BEGIN
				-- While submitting/saving Continuous disclosure, check if PE disclosure for the previous period is not there. 
				-- If such record is found, do not allow the user to save/submit the continuous disclosure until all previous period end disclosure are submitted
				IF EXISTS(SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
								WHERE 
									TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
									AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
									AND CONVERT(date, TM.PeriodEndDate) < (SELECT CONVERT(date, MIN(TD.DateOfAcquisition)) FROM tra_TransactionDetails_OS TD WHERE TD.TransactionMasterId = @inp_iTransactionMasterId)
									AND TM.UserInfoId = @inp_iUserInfoId)
				BEGIN 
					SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PastPENotSubmited
					RETURN @out_nReturnValue
				END
				
				-- While submitting/saving Continuous disclosure, check if PE disclosure for the same period or any period after that is not there. If such record is found, do not allow the user to save/submit the continuous disclosure
				SELECT @dtAcqusition = MAX(DateOfAcquisition) FROM tra_TransactionDetails_OS WHERE TransactionMasterId = @inp_iTransactionMasterId
					
				SELECT @nPeriodType = CASE 
											WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
											WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
											WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
											WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
											ELSE TP.DiscloPeriodEndFreq 
										 END 
				FROM tra_TransactionMaster_OS TM 
				JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId 
				AND TM.TransactionMasterId = @inp_iTransactionMasterId
				JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId 

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
								FROM tra_TransactionMaster_OS TM
									JOIN eve_EventLog EL ON EL.UserInfoId = TM.UserInfoId AND EL.EventCodeId IN (153062,153063)
										AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
								WHERE TM.PeriodEndDate >= @dtPeriodEndForContinuous AND EL.UserInfoId = @inp_iUserInfoId)
					BEGIN
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PEExists
						RETURN @out_nReturnValue
					END
				END

			END
			ELSE IF @nDisclosureType = @nDisclosureType_PeriodEnd
			BEGIN
				print 'Period End Disclosure checks'
				-- While submitting/saving period end disclosure, check if PE disclosure for the previous period is not there. 
				-- If such record is found, do not allow the user to save/submit the period end disclosure until all previous period end disclosure are submitted
				
				IF EXISTS(SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
							WHERE TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
								AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed) 
								AND CONVERT(date, TM.PeriodEndDate) < CONVERT(date, @inp_dtPeriodEndDate)
								AND TM.UserInfoId = @inp_iUserInfoId)
				BEGIN 
					SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_PastPENotSubmited
					RETURN @out_nReturnValue
				END
				-- While submitting/saving period end disclosure, check if pre-clearance request are open. 
				-- If such record is found, do not allow the user to save/submit the period end disclosure until all pre-clearance request are close
				
				-- pre-clearance is open when preclearance is requested OR preclearance is approve and does not have not trading reason and trading quantity is less then approve quantity 
				IF EXISTS(SELECT PCR.PreclearanceRequestId FROM tra_PreclearanceRequest_NonImplementationCompany PCR
							WHERE PCR.PreclearanceRequestId in (SELECT PreclearanceRequestId FROM tra_TransactionMaster_OS where PreclearanceRequestId is not null) AND 
							(PCR.PreclearanceStatusCodeId = 144001 
							OR (PCR.PreclearanceStatusCodeId = 144002 AND PCR.ReasonForNotTradingText IS NULL AND 
										PCR.SecuritiesToBeTradedQty > (SELECT COALESCE(SUM(Quantity),0) FROM tra_TransactionMaster_OS TM 
																		JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
																		WHERE TM.PreclearanceRequestId = PCR.PreclearanceRequestId)))
								AND PCR.UserInfoId = @inp_iUserInfoId)
				BEGIN					
					SET @out_nReturnValue = @ERR_PeriodEndDisclosureNotAllowed_PreClearanceIsOpen
					RETURN @out_nReturnValue
				END
			END
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_VALIDATION
	END CATCH
END
