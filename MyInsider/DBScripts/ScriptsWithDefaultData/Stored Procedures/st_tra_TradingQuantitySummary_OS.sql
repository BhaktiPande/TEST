IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingQuantitySummary_OS')
DROP PROCEDURE [dbo].[st_tra_TradingQuantitySummary_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Calculates summary of preclearance, trading and pending quantities

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		15-Mar-2019

Usage:
DECLARE @RC int
EXEC st_tra_PreclearanceRequestSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingQuantitySummary_OS] 
	@inp_iTransactionMasterId BIGINT,
	@inp_iPreclearanceId BIGINT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEQUANTITY	INT = 17359
	
	DECLARE @nPreclearanceQuantity DECIMAL(15,4) = 0
	DECLARE @nTradedQuantity DECIMAL(10,0) = 0
	DECLARE @nPendingQuantity DECIMAL(15,4) = 0

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF @inp_iPreclearanceId IS NULL
		BEGIN
			SELECT @inp_iPreclearanceId = PreclearanceRequestId
			FROM tra_TransactionMaster_OS 
			WHERE TransactionMasterId = @inp_iTransactionMasterId
		END

		IF @inp_iPreclearanceId IS NULL
		BEGIN
			SELECT @nTradedQuantity = ISNULL(SUM(TD.Quantity * (CASE WHEN TD.LotSize = 0 or TD.LotSize IS NULL THEN 1 ELSE TD.LotSize END)), 0)
			FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TransactionStatusCodeId <> 148002
				AND TM.TransactionMasterId = @inp_iTransactionMasterId
		END
		ELSE
		BEGIN
			SELECT @nPreclearanceQuantity = SecuritiesToBeTradedQty
			FROM tra_PreclearanceRequest_NonImplementationCompany 
			WHERE PreclearanceRequestId = @inp_iPreclearanceId
			
			SELECT @nTradedQuantity = ISNULL(SUM(TD.Quantity * (CASE WHEN TD.LotSize = 0 or TD.LotSize IS NULL THEN 1 ELSE TD.LotSize END)), 0)
			FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TransactionStatusCodeId <> 148002
				AND PreclearanceRequestId = @inp_iPreclearanceId
				
			IF @nTradedQuantity < @nPreclearanceQuantity
			BEGIN
				SET @nPendingQuantity = @nPreclearanceQuantity - @nTradedQuantity
			END
		END

		SELECT @nPreclearanceQuantity ApprovedQuantity, @nTradedQuantity TradedQuantity, @nPendingQuantity PendingQuantity

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEQUANTITY, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END