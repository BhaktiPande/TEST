/*
	AUTHOR NAME :	AMOL KADAMM
	CREATE DATE	:	23-May-2016
	DESCRIPTION	:	THIS FUNCTION IS USED TO GETTING THE SHARE AND PLEDGE QUANTITY FOR VALIDATION.
					
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_GetOtherAndPledgeQuantityForValidation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[uf_tra_GetOtherAndPledgeQuantityForValidation]
GO

CREATE FUNCTION [dbo].[uf_tra_GetOtherAndPledgeQuantityForValidation]
(	
    @nTDOtherExcerciseOptionQty	  INT,
    @nModeOfAcquisCodeId		  INT,
    @nTransTypeCodeId			  INT,
    @nSecurityTypeCodeId          INT,
    @nLotSize                     INT
)
 
RETURNS 
@ReturnTable TABLE 
(
	nOtherQuantity       INT,
	nPledgeQuantity      INT,
	nNotImpactedQuantity INT
)
AS
BEGIN

		DECLARE @nOtherQuantity				   INT = 0
		DECLARE @nPledgeQuantity			   INT = 0
		DECLARE @nNotImpactedQuantity		   INT = 0
		DECLARE @ImptPostShareQtyCodeId        INT
		DECLARE @ActionCodeId                  INT
		
		--Mode Of Acquisition		
		DECLARE @nPledgeCreationMOA            INT = 149012
		DECLARE @nRevokationOfPledgeMOA        INT = 149013
		DECLARE @nInvocationOfPledgeMOA        INT = 149014

        --Action        
        DECLARE @nSell    INT = 504002        
        
        --Impact on Post Share quantity 
        DECLARE @nLess    INT = 505002       
        DECLARE @nNo      INT = 505004     
        
        IF(@nLotSize = 0)
        BEGIN
			SET @nLotSize = 1
        END   

		SELECT @ImptPostShareQtyCodeId = impt_post_share_qty_code_id, @ActionCodeId = action_code_id FROM tra_TransactionTypeSettings WHERE mode_of_acquis_code_id = @nModeOfAcquisCodeId AND trans_type_code_id = @nTransTypeCodeId AND security_type_code_id = @nSecurityTypeCodeId


		if(@ImptPostShareQtyCodeId = @nNo)
		BEGIN		
			  IF (@nModeOfAcquisCodeId = @nPledgeCreationMOA OR @nModeOfAcquisCodeId = @nRevokationOfPledgeMOA OR @nModeOfAcquisCodeId = @nInvocationOfPledgeMOA)
			  BEGIN
					IF(@ActionCodeId = @nSell)
					BEGIN
					  SET @nPledgeQuantity = (@nTDOtherExcerciseOptionQty * @nLotSize);
					END					
			 END
			 ELSE
			 BEGIN			        
					IF(@ActionCodeId = @nSell)
					BEGIN
					  SET @nNotImpactedQuantity = (@nTDOtherExcerciseOptionQty * @nLotSize);
					END					
			 END
		END
		ELSE
		BEGIN
			SET @nOtherQuantity = CASE @ImptPostShareQtyCodeId WHEN @nLess THEN (@nTDOtherExcerciseOptionQty * @nLotSize) ELSE 0 END	
		END

        INSERT INTO @ReturnTable
        SELECT @nOtherQuantity, @nPledgeQuantity, @nNotImpactedQuantity
		  
		RETURN;

END