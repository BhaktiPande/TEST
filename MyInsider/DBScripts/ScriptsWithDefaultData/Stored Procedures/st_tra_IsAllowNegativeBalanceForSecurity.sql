IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_IsAllowNegativeBalanceForSecurity')
DROP PROCEDURE [dbo].[st_tra_IsAllowNegativeBalanceForSecurity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for finding the security type has allow negative balance or not.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		19-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_tra_IsAllowNegativeBalanceForSecurity 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_IsAllowNegativeBalanceForSecurity]
	@inp_iSecuirtyTypeCodeID					INT,		-- Security Type code id
	@out_bIsAllowNegatibeBalance				BIT = 0 OUTPUT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
		DECLARE @iAllowNegativeValue INT = 179002
		DECLARE @ERR_CHECKISALLOWNEGATIVEBALANCE	INT = 16444
	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''	
	
		IF(EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = @inp_iSecuirtyTypeCodeID 
		AND SecurityValueConstraint = @iAllowNegativeValue))
		BEGIN
			SET @out_bIsAllowNegatibeBalance = 0
		END
		ELSE
		BEGIN
			SET @out_bIsAllowNegatibeBalance = 1
		END

		SET @out_nReturnValue = 0
		SELECT 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_CHECKISALLOWNEGATIVEBALANCE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END

