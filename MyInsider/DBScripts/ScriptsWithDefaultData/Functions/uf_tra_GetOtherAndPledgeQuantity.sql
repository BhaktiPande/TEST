/*
	AUTHOR NAME :	AMOL KADAMM
	CREATE DATE	:	18-May-2016
	DESCRIPTION	:	THIS FUNCTION IS USED TO GETTING THE SHARE AND PLEDGE QUANTITY.
					
*/



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_GetOtherAndPledgeQuantity]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[uf_tra_GetOtherAndPledgeQuantity]
GO


CREATE FUNCTION [dbo].[uf_tra_GetOtherAndPledgeQuantity]
(
	@nOtherQuantity					INT,
    @nPledgeQuantity				INT,
    @nNotImpactedQuantity			INT,
    @nTDOtherExcerciseOptionQty		INT,
    @nModeOfAcquisCodeId			INT,
    @nTransTypeCodeId				INT,
    @nESOPQuanity                   INT,
    @nTDESOPExcerciseOptionQty      INT,
    @nContraTradeOption             INT,
    @nSecurityTypeCodeId            INT,
    @nLotSize                       INT    
)
RETURNS 
@ReturnTable TABLE 
(
	nOtherQuantity       INT,
	nPledgeQuantity      INT,
	nNotImpactedQuantity INT,
	nESOPQuanity         INT
)
AS
BEGIN
        DECLARE @nTransactionType_CashlessPartial INT = 143005
        DECLARE @nContraTradeQuantityBase INT = 175002
		DECLARE @ImptPostShareQtyCodeId INT;
		DECLARE @ActionCodeId INT;
		
		--Mode Of Acquisition		
		DECLARE @nPledgeCreationMOA     INT = 149012
		DECLARE @nRevokationOfPledgeMOA INT = 149013
		DECLARE @nInvocationOfPledgeMOA INT = 149014

        --Action 
        DECLARE @nBuy        INT = 504001
        DECLARE @nSell       INT = 504002
        DECLARE @nBuyANDSell INT = 504003
        
        --Impact on Post Share quantity        
        DECLARE @nAdd  INT = 505001
        DECLARE @nLess INT = 505002
        DECLARE @nBoth INT = 505003
        DECLARE @nNo   INT = 505004
        
        IF(@nLotSize = 0)
        BEGIN
			SET @nLotSize = 1
        END   

		SELECT @ImptPostShareQtyCodeId = impt_post_share_qty_code_id, @ActionCodeId = action_code_id FROM tra_TransactionTypeSettings WHERE mode_of_acquis_code_id = @nModeOfAcquisCodeId AND trans_type_code_id = @nTransTypeCodeId AND security_type_code_id = @nSecurityTypeCodeId


		IF(@ImptPostShareQtyCodeId = @nNo)
		BEGIN		
			  IF (@nModeOfAcquisCodeId = @nPledgeCreationMOA OR @nModeOfAcquisCodeId = @nRevokationOfPledgeMOA OR @nModeOfAcquisCodeId = @nInvocationOfPledgeMOA)
			  BEGIN
					IF(@ActionCodeId = @nBuy)
					BEGIN
					  SET @nPledgeQuantity = @nPledgeQuantity + (@nTDOtherExcerciseOptionQty * @nLotSize);
					END
					ELSE IF(@ActionCodeId = @nSell)
					BEGIN
					  SET @nPledgeQuantity = @nPledgeQuantity - (@nTDOtherExcerciseOptionQty * @nLotSize);
					END
					ELSE IF(@ActionCodeId = @nBuyANDSell)
					BEGIN
					  SET @nPledgeQuantity = @nPledgeQuantity;
					END
			 END
			 ELSE
			 BEGIN
			        IF(@ActionCodeId = @nBuy)
					BEGIN
					  SET @nNotImpactedQuantity = @nNotImpactedQuantity + (@nTDOtherExcerciseOptionQty * @nLotSize);
					END
					ELSE IF(@ActionCodeId = @nSell)
					BEGIN
					  SET @nNotImpactedQuantity = @nNotImpactedQuantity - (@nTDOtherExcerciseOptionQty * @nLotSize);
					END
					ELSE IF(@ActionCodeId = @nBuyANDSell)
					BEGIN
					  SET @nNotImpactedQuantity = @nNotImpactedQuantity;
					END
			 END
		END
		ELSE
		BEGIN
			 IF(@nContraTradeOption = @nContraTradeQuantityBase)
			 BEGIN
				 IF(@nTransTypeCodeId = @nTransactionType_CashlessPartial)
				 BEGIN
					 SET @nESOPQuanity = @nESOPQuanity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDESOPExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDESOPExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN (@nTDESOPExcerciseOptionQty * @nLotSize) ELSE 0 END			     
				     SET @nOtherQuantity = @nOtherQuantity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN (@nTDOtherExcerciseOptionQty * @nLotSize) ELSE 0 END
				 END
				 ELSE
				 BEGIN		     
					SET @nESOPQuanity = @nESOPQuanity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDESOPExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDESOPExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN 0 ELSE 0 END	
				    SET @nOtherQuantity = @nOtherQuantity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN 0 ELSE 0 END	
				 END
			 END
			 ELSE
			 BEGIN
				 IF(@nTransTypeCodeId = @nTransactionType_CashlessPartial)
				 BEGIN
					SET @nOtherQuantity = @nOtherQuantity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN (@nTDOtherExcerciseOptionQty * @nLotSize) ELSE 0 END
				 END
				 ELSE
				 BEGIN
					SET @nOtherQuantity = @nOtherQuantity + CASE @ImptPostShareQtyCodeId WHEN @nAdd THEN (@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nLess THEN -(@nTDOtherExcerciseOptionQty * @nLotSize) WHEN @nBoth THEN 0 ELSE 0 END	
				 END
			 END
		END

        INSERT INTO @ReturnTable
        SELECT @nOtherQuantity, @nPledgeQuantity, @nNotImpactedQuantity, @nESOPQuanity
		  
		RETURN;

END

