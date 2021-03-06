IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionDelete')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Deletes the TradingTransaction details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		15-Apr-2015

Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC [st_tra_TradingTransactionDelete] 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionDelete]
	-- Add the parameters for the stored procedure here
	@inp_iTransactionDetailsId	BIGINT,							-- Id of the TradingTransaction to be deleted
	@inp_iLoggedInUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_TRADINGTRANSACTIONDETAILS_DELETE INT,
			@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT,
			@ERR_DEPENDENTINFOEXISTS INT
	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = -1,
				@ERR_TRADINGTRANSACTIONDETAILS_DELETE = -1,
				@ERR_DEPENDENTINFOEXISTS = 12048
				
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		--Check if the RoleMaster being deleted exists
		IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId))
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM tra_TransactionDetails
		WHERE TransactionDetailsId = @inp_iTransactionDetailsId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		IF ERROR_NUMBER() = 547 -- Dependent info exists
			SET @out_nReturnValue = @ERR_DEPENDENTINFOEXISTS
		ELSE
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END

