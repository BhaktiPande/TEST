
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyForTransactionSecurityList_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyForTransactionSecurityList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Get the List of Transaction Security Map Configuaration

Returns:		0, if Success.
				
Created by:		Rajashri Sathe
Created on:		12-Des-2019

Usage:
EXEC st_rul_TradingPolicyForTransactionSecurityList_OS 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicyForTransactionSecurityList_OS]
	@inp_iTradingPolicyId				INT,						-- Id of the Policy
	@inp_iMapToTypeCodeId				INT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TransactionSecurityMapConfigList INT = 55133 -- Error occurred while fetching details for a company.

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
		SELECT TransactionModeCodeId,SecurityTypeCodeId 
		FROM rul_TradingPolicyForTransactionSecurity_OS
		WHERE TradingPolicyId = @inp_iTradingPolicyId
		AND MapToTypeCodeId = @inp_iMapToTypeCodeId 

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TransactionSecurityMapConfigList, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

GO


