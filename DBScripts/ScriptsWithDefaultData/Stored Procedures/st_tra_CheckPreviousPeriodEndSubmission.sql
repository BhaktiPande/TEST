IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckPreviousPeriodEndSubmission')
DROP PROCEDURE [dbo].[st_tra_CheckPreviousPeriodEndSubmission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for check Previous perriod end is closed or not.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		16-Sep-2016
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_tra_CheckPreviousPeriodEndSubmission 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_CheckPreviousPeriodEndSubmission]
	@inp_iUserInfoID										INT,
	@out_nIsPreviousPeriodEndSubmission						INT = 0 OUTPUT,
	@out_sSubsequentPeriodEndOrPreciousPeriodEndResource	VARCHAR(20) OUTPUT,
	@out_sSubsequentPeriodEndResourceOwnSecurity			VARCHAR(20) OUTPUT,
	@out_nReturnValue										INT = 0 OUTPUT,
	@out_nSQLErrCode										INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage										NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_CheckPreviousPeriodEndSubmission INT = 17476 -- Error occurred while check last period end is submitted.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		DECLARE @nPeriodEndDisclosureUploaded INT
		DECLARE @nYesPeriodEndDisclosureSubmission INT = 186001
		DECLARE @nNoPeriodEndDisclosureSubmission INT = 186002
		DECLARE @nTradingPolicyID INT
		DECLARE @nDiscloPeriodEndFreq INT
		DECLARE @dtTodayDate DATETIME = dbo.uf_com_GetServerDate()
		
		DECLARE @nTransactionMasterId BIGINT
		DECLARE @nPeriodEndDate DATETIME
		DECLARE @nTransStatus_DocumentUploaded INT = 148001
		DECLARE @nTransStatus_NotConfirmed INT = 148002
		
		DECLARE @nPreclearanceWithoutPeriodEndDisclosure INT
		DECLARE @nDiscloPeriodEndToCOByInsdrLimit INT
		
		DECLARE @LastSubmissionDate DATETIME
		DECLARE @nExchangeTypeCodeId_NSE INT = 116001
		
		DECLARE @nPeriodEndDisclosureTypeCodeId INT = 147003
		DECLARE @nTransactionStatusCodeIdNotCOnfirmed INT = 148002
		DECLARE @nAllowbeforeAndafterperiodendlastsubmissiondate INT = 188001
		DECLARE @nAllowTillperiodendlastsubmissiondate INT = 188002
		DECLARE @nNotAllow INT = 188003
		--DECLARE @sSubsequentPeriodEndOrPreciousPeriodEndResource VARCHAR(10)
		
		--Fetch Last Previous Period Transaction Master
		SELECT @nTransactionMasterId = MAX(TransactionMasterId) 
		FROM tra_TransactionMaster
		WHERE UserInfoId = @inp_iUserInfoID AND DisclosureTypeCodeId = @nPeriodEndDisclosureTypeCodeId 
		
		--Check Last Transaction master exists for Period End.
		IF @nTransactionMasterId IS NOT NULL 
		BEGIN
		
			IF EXISTS(SELECT TransactionMasterId 
			FROM tra_TransactionMaster 
			WHERE TransactionMasterId = @nTransactionMasterId
			AND TransactionStatusCodeId > @nTransactionStatusCodeIdNotCOnfirmed)
			BEGIN
				SET @out_nIsPreviousPeriodEndSubmission = 0
			END
			ELSE
			BEGIN
				
				SELECT @nPeriodEndDate = PeriodEndDate,
					   @nTradingPolicyID = TradingPolicyId 
				FROM tra_TransactionMaster 
				WHERE TransactionMasterId = @nTransactionMasterId
				
				SELECT @nPreclearanceWithoutPeriodEndDisclosure =  PreclearanceWithoutPeriodEndDisclosure,
				@nDiscloPeriodEndToCOByInsdrLimit =  DiscloPeriodEndToCOByInsdrLimit
				FROM rul_TradingPolicy
				WHERE TradingPolicyId = @nTradingPolicyID
				
				IF @nPreclearanceWithoutPeriodEndDisclosure = @nAllowbeforeAndafterperiodendlastsubmissiondate
				BEGIN
					SET @out_nIsPreviousPeriodEndSubmission = 0
				END
				ELSE IF @nPreclearanceWithoutPeriodEndDisclosure = @nAllowTillperiodendlastsubmissiondate
				BEGIN
					SET @LastSubmissionDate = CONVERT(DATE, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@nPeriodEndDate, @nDiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) 
					--select CONVERT(DATE, @LastSubmissionDate, 101) AS 'LSD',CONVERT(DATE, @dtTodayDate, 101) AS 'TD'
					IF CONVERT(DATE, @LastSubmissionDate, 101)  >= CONVERT(DATE, @dtTodayDate, 101)
					BEGIN
						SET @out_nIsPreviousPeriodEndSubmission = 0
					END
					ELSE
					BEGIN
						SET @out_nIsPreviousPeriodEndSubmission = 1
						SET @out_sSubsequentPeriodEndOrPreciousPeriodEndResource = 'dis_msg_17478'
						SET @out_sSubsequentPeriodEndResourceOwnSecurity = 'dis_msg_53144'
					END
				END
				ELSE IF @nPreclearanceWithoutPeriodEndDisclosure = @nNotAllow
				BEGIN
					SET @out_nIsPreviousPeriodEndSubmission = 1
					SET @out_sSubsequentPeriodEndOrPreciousPeriodEndResource = 'dis_msg_17478'
					SET @out_sSubsequentPeriodEndResourceOwnSecurity = 'dis_msg_53144'
				END
			END
		END 
		ELSE
		BEGIN
				
			SELECT @nPeriodEndDisclosureUploaded = PeriodEndDisclosureUploaded 
			FROM usr_UserInfo 
			WHERE UserInfoId = @inp_iUserInfoID
			select @nPeriodEndDisclosureUploaded as PeriodEndDisclosureUploaded
			IF(@nPeriodEndDisclosureUploaded = @nYesPeriodEndDisclosureSubmission)
			BEGIN
				SET @out_nIsPreviousPeriodEndSubmission = 0
			END
			ELSE IF @nPeriodEndDisclosureUploaded IS NULL OR @nPeriodEndDisclosureUploaded = @nNoPeriodEndDisclosureSubmission  
			BEGIN
				--IF NOT EXISTS(SELECT PreclearanceRequestId FROM tra_PreclearanceRequest WHERE UserInfoId = @inp_iUserInfoID)
				--BEGIN
					SET @out_sSubsequentPeriodEndOrPreciousPeriodEndResource = 'dis_msg_17477'
					SET @out_nIsPreviousPeriodEndSubmission = 1
					SET @out_sSubsequentPeriodEndResourceOwnSecurity = 'dis_msg_53143'
				--END
				--ELSE
				--BEGIN
					--SET @out_nIsPreviousPeriodEndSubmission = 0
				--END
			END
		END
		--SET @out_nIsPreviousPeriodEndSubmission = 0
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_CheckPreviousPeriodEndSubmission, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END