IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterDetails')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TradingTransaction Master details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		15-Apr-2015

Modification History:
Modified By		Modified On		Description
Parag			18-Aug-2016		Code merge with ESOP code
Gaurishankar	19-Sept-2016	Added column ConfirmCompanyHoldingsFor & ConfirmNonCompanyHoldingsFor
Usage:
EXEC [st_tra_TradingTransactionMasterDetails] 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterDetails]
	@inp_iTransactionMasterId	BIGINT,							-- Id of the TradingTransaction whose details are to be fetched.
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS INT
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = -1,
				@ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS = -1

		--Check if the RoleMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId	))
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		--Fetch the RoleMaster details
		Select TransactionMasterId
			  ,PreclearanceRequestId
			  ,UserInfoId
			  ,DisclosureTypeCodeId
			  ,TransactionStatusCodeId
			  ,NoHoldingFlag
			  ,tra.TradingPolicyId
			  ,PeriodEndDate
			  ,PartiallyTradedFlag
			  ,SoftCopyReq
			  ,HardCopyReq
			  ,SecurityTypeCodeId,
			  RUL.SeekDeclarationFromEmpRegPossessionOfUPSIFlag,RUL.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures,RUL.DeclarationToBeMandatoryFlag,
			  RUL.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag
			  ,ConfirmCompanyHoldingsFor
			  ,ConfirmNonCompanyHoldingsFor
			  ,CDDuringPE
			From tra_TransactionMaster tra
			LEFT JOIN rul_TradingPolicy RUL ON RUL.TradingPolicyId = tra.TradingPolicyId
			Where TransactionMasterId = @inp_iTransactionMasterId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

