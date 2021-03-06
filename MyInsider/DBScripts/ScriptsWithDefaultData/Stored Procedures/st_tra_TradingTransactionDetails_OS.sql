IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionDetails_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TradingTransaction details

Returns:		0, if Success.
				
Created by:		gaurishankar
Created on:		15-Apr-2015
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionDetails_OS]
	@inp_iTransactionDetailsId	BIGINT,							-- Id of the TradingTransaction whose details are to be fetched.
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS INT
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT

	DECLARE @nTransactionMasterId BIGINT
	DECLARE @nTradingPolicy INT
	DECLARE @nDisclosureType_Continuous INT = 147002

	DECLARE @nTransStatus_DocumentUploaded INT = 148001,
			@nTransStatus_NotConfirmed INT = 148002


	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = -1,
				@ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS = -1

		--Check if the RoleMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails_OS WHERE TransactionDetailsId = @inp_iTransactionDetailsId	))
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		--Fetch the RoleMaster details
		Select TD.TransactionMasterId
					,TD.SecurityTypeCodeId
					,ForUserInfoId
					,DMATDetailsID
					,CompanyId
					,DateOfAcquisition
					,ISNULL(DateOfInitimationToCompany,dbo.uf_com_GetServerDate()) AS DateOfInitimationToCompany
					,ModeOfAcquisitionCodeId
					,ExchangeCodeId
					,TransactionTypeCodeId
					,CASE WHEN (TM.DisclosureTypeCodeId = 147001 AND TD.TransactionTypeCodeId = 143002) THEN Quantity * (-1) ELSE Quantity END AS Quantity
					,Value
					,LotSize					
					,ContractSpecification
					,TransactionDetailsId
			From tra_TransactionDetails_OS TD
			INNER JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId =  TD.TransactionMasterId
			Where TransactionDetailsId = @inp_iTransactionDetailsId	
		

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

