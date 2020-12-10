IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterCreate_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_OS]
	@inp_sTransactionMasterId		BIGINT,
	@inp_sPreclearanceRequestId		BIGINT = null,
	@inp_iUserInfoId				INT = null,
	@inp_iDisclosureTypeCodeId		INT = null,
	@inp_iTransactionStatusCodeId	INT = null,
	@inp_sNoHoldingFlag				bit = null,
	@inp_iTradingPolicyId			INT = null,	
	@inp_dtPeriodEndDate			DATETIME = null,
	@inp_bPartiallyTradedFlag		bit = null,
	@inp_bSoftCopyReq				bit = null,
	@inp_bHardCopyReq				bit = null,
	@inp_nUserId					INT,
	@inp_CDDuringPE					BIT=NULL,
	@inp_InsiderIDFlag				BIT=NULL,
	@out_nDisclosureCompletedFlag	INT = 0 OUTPUT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRANSACTIONMASTER_SAVE INT = 16092
	
	DECLARE @bIsMassUpload BIT = 0 -- set flag for mass upload
	
	BEGIN TRY
	
		EXEC st_tra_TradingTransactionMasterCreate_Override_OS
				@inp_sTransactionMasterId, 
				@inp_sPreclearanceRequestId, 
				@inp_iUserInfoId, 
				@inp_iDisclosureTypeCodeId, 
				@inp_iTransactionStatusCodeId, 
				@inp_sNoHoldingFlag, 
				@inp_iTradingPolicyId,	
				@inp_dtPeriodEndDate, 			
				@inp_bPartiallyTradedFlag, 
				@inp_bSoftCopyReq, 
				@inp_bHardCopyReq,				
				@inp_nUserId,
				'',	
				@inp_CDDuringPE,		
				@inp_InsiderIDFlag,
				@inp_sTransactionMasterId out, 
				@out_nDisclosureCompletedFlag OUTPUT, 
				@out_nReturnValue OUTPUT, 
				@out_nSQLErrCode OUTPUT, 
				@out_sSQLErrMessage OUTPUT	
		
		
		IF(@out_nReturnValue = 0)
		BEGIN
			print(1)
			-- auto submit transcation 
			--EXEC st_tra_TradingTransaction_Auto_Submit
			--		@inp_sTransactionMasterId, 
			--		@bIsMassUpload,
			--		@out_nReturnValue OUTPUT, 
			--		@out_nSQLErrCode OUTPUT, 
			--		@out_sSQLErrMessage OUTPUT	
		END
		
		
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END