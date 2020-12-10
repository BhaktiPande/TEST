IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterDelete_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterDelete_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Deletes the TradingTransaction master

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		02-Apl-2019

Usage:
DECLARE @RC int
EXEC [st_tra_TradingTransactionMasterDelete] 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterDelete_OS]
	-- Add the parameters for the stored procedure here
	@inp_iTransactionMasterId	BIGINT,							-- Id of the TradingTransaction to be deleted
	@inp_iLoggedInUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_TRADINGTRANSACTIONDETAILS_DELETE INT,
			@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT,
			@CONST_DISCLOSURETYPE_CONTINUOUS INT,
			@nPCLId INT
	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_DELETE = 16187,
		        @CONST_DISCLOSURETYPE_CONTINUOUS = 147002
				
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF (EXISTS(SELECT TransactionMasterId FROM tra_TransactionDetails_OS WHERE TransactionMasterId = @inp_iTransactionMasterId))
		BEGIN print 'in'
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue
		END
		
		SELECT @nPCLId = PreclearanceRequestId FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iTransactionMasterId
		print @nPCLId
		IF (EXISTS(SELECT TransactionMasterId 
					FROM tra_TransactionMaster_OS 
					WHERE TransactionMasterId = @inp_iTransactionMasterId 
					AND DisclosureTypeCodeId = @CONST_DISCLOSURETYPE_CONTINUOUS
					AND (PreclearanceRequestId IS NULL OR ParentTransactionMasterId IS NOT NULL)
		))
		BEGIN
		print 'if'
			DELETE TM
			FROM tra_TransactionMaster_OS TM LEFT JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			--LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToId = TM.TransactionMasterId AND PurposeCodeId = 133003 AND MapToTypeCodeId = 132005
			WHERE TM.TransactionMasterId = @inp_iTransactionMasterId AND TransactionStatusCodeId = 148002 
			AND (TM.PreclearanceRequestId IS NULL OR (TM.PreclearanceRequestId IS NOT NULL AND TM.ParentTransactionMasterId IS NOT NULL)) AND TD.TransactionMasterId IS NULL --AND DOM.DocumentObjectMapId IS NULL
			
			IF @nPCLId IS NOT NULL
				AND EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest_NonImplementationCompany WHERE PreclearanceRequestId = @nPCLId AND ReasonForNotTradingCodeId IS NULL)
			BEGIN
				UPDATE tra_PreclearanceRequest_NonImplementationCompany
				SET ShowAddButton = 1
				WHERE PreclearanceRequestId = @nPCLId
			END
		END
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END

