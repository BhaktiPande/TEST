IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransaction_Auto_Submit')
	DROP PROCEDURE [dbo].[st_tra_TradingTransaction_Auto_Submit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to auto submit trasaction 
				Intitial disclosure is submitted by user mannually, in that case continuous disclosure prior to inital disclosure enter are auto submitted
				auto submit is also done for mass upload - on going contintinuous disclosure 
				auto sumbit for on going continusous disclosure and at initial disclousre is depends on flag set for implementing company 

Returns:		0, if Success.
				
Created by:		Parag
Created on:		03-May-2016

Modification History:
Modified By		Modified On		Description
Parag			20-Jun-2016		Made change to auto-submit base on flag only - for initial and on-going continuous disclosure
								
Usage:
EXEC [st_tra_TradingTransactionMasterCreate] 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransaction_Auto_Submit]
	@inp_sTransactionMasterId		BIGINT,
	@inp_bIsMassUpload				BIT, 
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRAN_AUTO_SUBMIT_FAIL				INT = 16431
	DECLARE @ERR_TRAN_AUTO_SUBMIT_FAIL_INITIAL_PNT	INT = 16432
	
	DECLARE @nDisclosureType_Initial	INT = 147001
	DECLARE @nDisclosureType_Continuous INT = 147002
	DECLARE @nDisclosureType_PeriodEnd	INT = 147003
	
	DECLARE @nTranscationStatus_DocUpload	INT = 148001
	DECLARE @nTranscationStatus_NotConfirm	INT = 148002
	DECLARE @nTranscationStatus_Submitted	INT = 148007
	
	DECLARE @nEventCode_InitialDisclosureEnter	INT = 153007
	DECLARE @nEventMapToTypeCode_Disclosure		INT = 132005
	
	DECLARE @nAutoSubmit_no_auto_submit			INT = 178001
	DECLARE @nAutoSubmit_transaction			INT = 178002
	
	DECLARE @nUserInfoId INT 
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @dtInitialDisclosureEnterEvent DATETIME
	
	DECLARE @nAutoSubmitTransaction_Code INT
	
	-- variable to submit transcation 
	DECLARE @nTranscationMasterId BIGINT
	DECLARE @nPreclearanceRequestId BIGINT = NULL
	DECLARE @nTMDisclosureTypeCodeId INT 
	DECLARE @nTransactionStatusCodeId INT = @nTranscationStatus_Submitted
	DECLARE @bNoHoldingFlag BIT = 0 
	DECLARE @nTradingPolicyId INT
	DECLARE @dtPeriodEndDate DATETIME = NULL
	DECLARE @bPartiallyTradedFlag bit
	DECLARE @bSoftCopyReq bit
	DECLARE @bHardCopyReq bit
	DECLARE @dtHCpByCOSubmission DATETIME
	DECLARE @sCalledFrom VARCHAR(20) = ''
	DECLARE @inp_nTransactionMasterId BIGINT
	DECLARE @out_nDisclosureCompletedFlag INT
	DECLARE @dtDateOfAcquisition DATETIME
	DECLARE @nInsiderIDFlag INT
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		
		-- get transcation details from transcation master id
		-- if transcation is for initial disclosure, then check all previously saved PNT for user and submit those PNT (all PNT before intial disclosure enter)
		
		SELECT @nUserInfoId = tm.UserInfoId, @nDisclosureTypeCodeId = tm.DisclosureTypeCodeId,@nInsiderIDFlag=InsiderIDFlag
		FROM tra_TransactionMaster tm WHERE TransactionMasterId = @inp_sTransactionMasterId
		
		-- get flag from implementing company to check if auto submit is allowed or not 
		SELECT @nAutoSubmitTransaction_Code = AutoSubmitTransaction FROM mst_Company WHERE IsImplementing = 1
		
		-- check if initial disclousure is enter(submitted by user)
		SELECT @dtInitialDisclosureEnterEvent = el.EventDate FROM eve_EventLog el 
		WHERE el.UserInfoId = @nUserInfoId AND el.MapToTypeCodeId = @nEventMapToTypeCode_Disclosure
		AND el.EventCodeId = @nEventCode_InitialDisclosureEnter 
		
		IF(@nDisclosureTypeCodeId = @nDisclosureType_Initial)
		BEGIN
			print 'auto submit disclosure type - initial disclosure'
			
			IF (@nAutoSubmitTransaction_Code = @nAutoSubmit_transaction AND 
					@dtInitialDisclosureEnterEvent IS NOT NULL AND @dtInitialDisclosureEnterEvent <> '')
			BEGIN
				-- check if user has transaction which are not submitted - submit such transaction 
				IF EXISTS(SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm 
							WHERE tm.UserInfoId = @nUserInfoId AND tm.TransactionStatusCodeId = @nTranscationStatus_NotConfirm 
							AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous)
				BEGIN
					
					-- try catch block to get error while committing initial disclosure
					BEGIN TRY
						-- get all transaction which are not submitted whos date of acquisition is less or equal to intial disclosure enter date
						-- and submit 
						
						DECLARE TransMaster_Cursor CURSOR LOCAL FOR 
							SELECT tm.TransactionMasterId, tm.DisclosureTypeCodeId, tm.TradingPolicyId 
							FROM tra_TransactionMaster tm  WHERE tm.UserInfoId = @nUserInfoId  
								AND tm.TransactionStatusCodeId = @nTranscationStatus_NotConfirm AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
						
						OPEN TransMaster_Cursor
						
						FETCH NEXT FROM TransMaster_Cursor INTO @nTranscationMasterId, @nTMDisclosureTypeCodeId, @nTradingPolicyId
						
						WHILE @@FETCH_STATUS = 0
						BEGIN
							
							EXEC st_tra_TradingTransactionMasterCreate_Override 
									@nTranscationMasterId, 
									@nPreclearanceRequestId, 
									@nUserInfoId, 
									@nTMDisclosureTypeCodeId, 
									@nTransactionStatusCodeId, 
									@bNoHoldingFlag, 
									@nTradingPolicyId, 
									@dtPeriodEndDate, 
									@bPartiallyTradedFlag, 
									@bSoftCopyReq, 
									@bHardCopyReq, 
									@dtHCpByCOSubmission, 
									@nUserInfoId,
									@sCalledFrom,
									NULL,
									0,
									@nInsiderIDFlag,
									@inp_nTransactionMasterId OUTPUT, 
									@out_nDisclosureCompletedFlag OUTPUT, 
									@out_nReturnValue OUTPUT, 
									@out_nSQLErrCode OUTPUT, 
									@out_sSQLErrMessage OUTPUT	
							
							IF @out_nReturnValue <> 0
							BEGIN
								SET @out_nReturnValue = @out_nReturnValue
								RETURN @out_nReturnValue
							END
							
							print 'transaction submitted : transcation master id - '+convert(varchar, @inp_nTransactionMasterId)
							+',  disclosure complete flag - '+convert(varchar, @out_nDisclosureCompletedFlag)
							
							FETCH NEXT FROM TransMaster_Cursor INTO @nTranscationMasterId, @nTMDisclosureTypeCodeId, @nTradingPolicyId
						END
						
						CLOSE TransMaster_Cursor
						DEALLOCATE TransMaster_Cursor;
					END TRY
					BEGIN CATCH
						SET @out_nSQLErrCode    =  ERROR_NUMBER()
						SET @out_sSQLErrMessage =   ERROR_MESSAGE()
						SET @out_nSQLErrCode = @ERR_TRAN_AUTO_SUBMIT_FAIL_INITIAL_PNT
						
						-- Return common error if required, otherwise specific error.		
						SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRAN_AUTO_SUBMIT_FAIL_INITIAL_PNT, ERROR_NUMBER())
						RETURN @out_nReturnValue		
					END CATCH
					
				END
			END
			
		END
		ELSE IF(@nDisclosureTypeCodeId = @nDisclosureType_Continuous AND @inp_bIsMassUpload = 1)
		BEGIN
		
			-- check if auto submit allowed or not by checking company flag
			-- also check if user has enter intital disclosure
			IF(@nAutoSubmitTransaction_Code = @nAutoSubmit_transaction AND 
				@dtInitialDisclosureEnterEvent IS NOT NULL AND @dtInitialDisclosureEnterEvent <> '')
			BEGIN
				
				-- check if period end disclosure is pending or not
				-- in case period end disclosure is pending then do not submit transaction
				IF(NOT EXISTS(SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm 
					WHERE tm.UserInfoId = @nUserInfoId AND tm.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd AND 
					(tm.TransactionStatusCodeId = @nTranscationStatus_DocUpload OR tm.TransactionStatusCodeId = @nTranscationStatus_NotConfirm) ))
				BEGIN
					
					-- try catch block - there if any error then do not return error code
					BEGIN TRY
						print 'auto submit disclosure type - continuous disclosure from mass upload'
						
						SELECT @nPreclearanceRequestId = tm.PreclearanceRequestId, @nTMDisclosureTypeCodeId = tm.DisclosureTypeCodeId,
								@nTradingPolicyId = tm.TradingPolicyId, @bPartiallyTradedFlag = tm.PartiallyTradedFlag
						FROM tra_TransactionMaster tm WHERE tm.TransactionMasterId = @inp_sTransactionMasterId
						
						EXEC st_tra_TradingTransactionMasterCreate_Override 
								@inp_sTransactionMasterId, 
								@nPreclearanceRequestId, 
								@nUserInfoId, 
								@nTMDisclosureTypeCodeId, 
								@nTransactionStatusCodeId, 
								@bNoHoldingFlag, 
								@nTradingPolicyId, 
								@dtPeriodEndDate, 
								@bPartiallyTradedFlag, 
								@bSoftCopyReq, 
								@bHardCopyReq, 
								@dtHCpByCOSubmission, 
								@nUserInfoId,
								@sCalledFrom,
								NULL,
								0,
								@nInsiderIDFlag,
								@inp_nTransactionMasterId OUTPUT, 
								@out_nDisclosureCompletedFlag OUTPUT, 
								@out_nReturnValue OUTPUT, 
								@out_nSQLErrCode OUTPUT, 
								@out_sSQLErrMessage OUTPUT	
						
						print 'transaction submitted : transcation master id - '+convert(varchar, @inp_nTransactionMasterId)
						+',  disclosure complete flag - '+convert(varchar, @out_nDisclosureCompletedFlag)
					END TRY
					BEGIN CATCH
					END CATCH
					
				END
				
			END
			
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nSQLErrCode = @ERR_TRAN_AUTO_SUBMIT_FAIL
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRAN_AUTO_SUBMIT_FAIL, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END