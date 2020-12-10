IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyForTransactionSecurityList')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyForTransactionSecurityList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the List of Transaction Security Map Configuaration

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		24-Aug-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_rul_TradingPolicyForTransactionSecurityList 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicyForTransactionSecurityList]
	@inp_iTradingPolicyId				INT,						-- Id of the Policy
	@inp_iMapToTypeCodeId				INT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TransactionSecurityMapConfigList INT = 15423 -- Error occurred while fetching details for a company.

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
		SELECT TransactionModeCodeId,SecurityTypeCodeId 
		FROM rul_TradingPolicyForTransactionSecurity
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

