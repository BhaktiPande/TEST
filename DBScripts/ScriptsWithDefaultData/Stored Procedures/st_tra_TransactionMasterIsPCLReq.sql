IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionMasterIsPCLReq')
DROP PROCEDURE [dbo].[st_tra_TransactionMasterIsPCLReq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to decide if PCL was req. This procedure is called from st_tra_TradingTransactionMasterCreate, when the transaction is getting 
				submitted, i.e. TransactionMasterId <> 0, NoHolding option is not selected i.e. some details are present for this transaction

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		07-Sep-2015

Modification History:
Modified By		Modified On		Description
Arundhati		07-Sep-2015		Procedure to decide if preclearance was required for this transaction
Arundhati		06-Oct-2015		Logic is shifted to st_tra_TransactionMasterIsPCLReqOverride. And it is called from this procedure with default value for new parameter

Usage:
EXEC [st_tra_TradingTransactionMasterCreate] 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionMasterIsPCLReq]
	@inp_nTransactionMasterId		BIGINT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @nUpdateTD INT = 1
	DECLARE @RC INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Initialize variables
		SET @out_nReturnValue = 0

		EXECUTE @RC = st_tra_TransactionMasterIsPCLReqOverride
			   @inp_nTransactionMasterId
			  ,@nUpdateTD
			  ,@out_nReturnValue OUTPUT
			  ,@out_nSQLErrCode OUTPUT
			  ,@out_sSQLErrMessage OUTPUT

		
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		RETURN @out_nReturnValue		
	END CATCH
END