IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetImpactOnPostQuantity')
	DROP PROCEDURE [dbo].[st_tra_GetImpactOnPostQuantity]
GO

-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 10-JUN-2016																						                =
--	PURPOSE			: THIS STORE PROCEDURE IS USED TO GET THE IMPACT ON POST QUANTITY.													=
-- ======================================================================================================================================


CREATE PROCEDURE [dbo].[st_tra_GetImpactOnPostQuantity]
	@nTransTypeCodeId		        INT,
	@nModeOfAcquisCodeId            INT,
	@nSecurityTypeCodeId            INT,
	@out_nImpactOnPostQuantity		INT = 0 OUTPUT,
	@out_nReturnValue 				INT = 0 OUTPUT,
	@out_nSQLErrCode 				INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CURRENTYEARCODE		INT = 17053  -- Error occurred while fetching current disclosure year code.
	
	DECLARE @nImptPostShareQtyCodeId INT;
    
    --Impact on Post Share quantity        
    DECLARE @nAdd INT = 505001
    DECLARE @nLess INT = 505002
    DECLARE @nBoth INT = 505003
    DECLARE @nNo INT = 505004         
    
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT TOP 1 @nImptPostShareQtyCodeId = impt_post_share_qty_code_id FROM tra_TransactionTypeSettings WHERE mode_of_acquis_code_id = @nModeOfAcquisCodeId AND trans_type_code_id = @nTransTypeCodeId AND security_type_code_id = @nSecurityTypeCodeId

		IF(@nImptPostShareQtyCodeId = @nNo)
		BEGIN		
			SET @out_nImpactOnPostQuantity = @nNo			 
		END
		ELSE
		BEGIN     
			SET @out_nImpactOnPostQuantity = CASE @nImptPostShareQtyCodeId WHEN @nAdd THEN @nAdd WHEN @nLess THEN @nLess WHEN @nBoth THEN @nBoth ELSE @nNo END	
		END
		
		SELECT TOP 1 @out_nImpactOnPostQuantity
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  dbo.uf_com_GetErrorCode(@ERR_CURRENTYEARCODE, ERROR_NUMBER())
	END CATCH
END



