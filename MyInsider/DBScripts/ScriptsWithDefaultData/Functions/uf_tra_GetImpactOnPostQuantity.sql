IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_GetImpactOnPostQuantity]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].uf_tra_GetImpactOnPostQuantity
GO

-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 19-JULY-2016																								        =
--	PURPOSE			: THIS FUNCTION IS USED TO GET THE IMPACT ON POST QUANTITY.															=
-- ======================================================================================================================================

CREATE FUNCTION [dbo].[uf_tra_GetImpactOnPostQuantity]
(
	@nTransTypeCodeId		        INT,
	@nModeOfAcquisCodeId            INT,
	@nSecurityTypeCodeId            INT	
)
RETURNS INT

AS
BEGIN
		DECLARE @ERR_CURRENTYEARCODE		INT = 17053  -- Error occurred while fetching current disclosure year code.
		
		DECLARE @nImptPostShareQtyCodeId INT;
			
		--Impact on Post Share quantity        
		DECLARE @nAdd INT = 505001
		DECLARE @nLess INT = 505002
		DECLARE @nBoth INT = 505003
		DECLARE @nNo INT = 505004 
    
		DECLARE @nImpactOnPostQuantity INT = 0  
		
		SELECT TOP 1 @nImptPostShareQtyCodeId = impt_post_share_qty_code_id FROM tra_TransactionTypeSettings WHERE mode_of_acquis_code_id = @nModeOfAcquisCodeId AND trans_type_code_id = @nTransTypeCodeId AND security_type_code_id = @nSecurityTypeCodeId

		IF(@nImptPostShareQtyCodeId = @nNo)
		BEGIN	
			SET @nImpactOnPostQuantity = @nNo
		END
		ELSE
		BEGIN     
			SET @nImpactOnPostQuantity = CASE @nImptPostShareQtyCodeId WHEN @nAdd THEN @nAdd WHEN @nLess THEN @nLess WHEN @nBoth THEN @nBoth ELSE @nNo END	
		END
		
		RETURN @nImpactOnPostQuantity
END
