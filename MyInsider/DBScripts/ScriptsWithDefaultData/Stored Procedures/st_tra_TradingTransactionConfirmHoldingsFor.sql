IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionConfirmHoldingsFor')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionConfirmHoldingsFor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the TradingTransaction Confirm holdings for

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		19-Sept-2016
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_tra_TradingTransactionConfirmHoldingsFor 269 ,null,null,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionConfirmHoldingsFor] 
	@inp_iTransactionMasterId BIGINT,
	@inp_iConfirmCompanyHoldingsFor INT,
	@inp_iConfirmNonCompanyHoldingsFor		INT,	
	@inp_iLoggedInUserId	INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_SAVE INT = 17328
	DECLARE @out_nSavedTransactionDetailsId INT
	
	BEGIN TRY
	IF(@inp_iConfirmCompanyHoldingsFor = 0)
	BEGIN
		SET @inp_iConfirmCompanyHoldingsFor = NULL 
	END
	IF(@inp_iConfirmNonCompanyHoldingsFor = 0)
	BEGIN
		SET @inp_iConfirmNonCompanyHoldingsFor = NULL 
	END
	
	UPDATE tra_TransactionMaster
	SET
	ConfirmCompanyHoldingsFor = @inp_iConfirmCompanyHoldingsFor,
	ConfirmNonCompanyHoldingsFor = @inp_iConfirmNonCompanyHoldingsFor,
	ModifiedBy	= @inp_iLoggedInUserId,
	ModifiedOn = dbo.uf_com_GetServerDate()
	WHERE TransactionMasterId = @inp_iTransactionMasterId
	
	SELECT 0

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END