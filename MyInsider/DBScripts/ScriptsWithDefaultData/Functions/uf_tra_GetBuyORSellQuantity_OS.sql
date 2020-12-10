IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_GetBuyORSellQuantity_OS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[uf_tra_GetBuyORSellQuantity_OS]
GO

-- ======================================================================================================================================
												
-- ======================================================================================================================================

CREATE FUNCTION [dbo].[uf_tra_GetBuyORSellQuantity_OS]
(
	@Type                    VARCHAR(50), 
	@Quantity                INT,
	@PartialSellQuantity     INT,	
	@nModeOfAcquisCodeId     INT,
	@nTransTypeCodeId		 INT,
	@nSecurityTypeCodeId     INT,
	@LotSize                 INT
)
RETURNS 
@ReturnTable TABLE 
(
	OtherBuyQuantity        INT,
	OtherSellQuantity       INT,
	PledgeBuyQuantity       INT,
	PledgeSellQuantity      INT,
	NotImpactedBuyQuantity  INT,
	NotImpactedSellQuantity INT
)
AS
BEGIN

    DECLARE @nTransactionType_CashlessPartial INT = 143005
	DECLARE @ImptPostShareQtyCodeId INT;
	DECLARE @ActionCodeId       INT;	
	DECLARE @OtherBuyQuantity   INT = 0;
	DECLARE @OtherSellQuantity  INT = 0;
	DECLARE @PledgeBuyQuantity  INT = 0;
	DECLARE @PledgeSellQuantity INT = 0;
	DECLARE @NotImpactedBuyQuantity INT = 0;
	DECLARE @NotImpactedSellQuantity INT = 0
	
    --Action 
    DECLARE @nBuy  INT = 504001
    DECLARE @nSell INT = 504002   
    
    --Impact on Post Share quantity        
    DECLARE @nAdd  INT = 505001
    DECLARE @nLess INT = 505002
    DECLARE @nBoth INT = 505003
    DECLARE @nNo   INT = 505004
	
	--Mode Of Acquisition		
	DECLARE @nPledgeCreationMOA     INT = 149012
	DECLARE @nRevokationOfPledgeMOA INT = 149013
	DECLARE @nInvocationOfPledgeMOA INT = 149014
	
	IF(@LotSize = 0)
    BEGIN
		SET @LotSize = 1
    END

	SELECT @ImptPostShareQtyCodeId = impt_post_share_qty_code_id, @ActionCodeId = action_code_id FROM tra_TransactionTypeSettings_OS WHERE mode_of_acquis_code_id = @nModeOfAcquisCodeId  AND trans_type_code_id = @nTransTypeCodeId and security_type_code_id = @nSecurityTypeCodeId

	IF(@Type = 'PledgeBuy')
	BEGIN
	     IF (@nModeOfAcquisCodeId = @nPledgeCreationMOA OR @nModeOfAcquisCodeId = @nRevokationOfPledgeMOA OR @nModeOfAcquisCodeId = @nInvocationOfPledgeMOA)
		 BEGIN
			if(@ImptPostShareQtyCodeId = @nNo AND @ActionCodeId = @nBuy)
			BEGIN		
				  SET @PledgeBuyQuantity = (@Quantity * @LotSize)
			END
		END
	END
	ELSE IF(@Type = 'PledgeSell')	
	BEGIN
	    IF (@nModeOfAcquisCodeId = @nPledgeCreationMOA OR @nModeOfAcquisCodeId = @nRevokationOfPledgeMOA OR @nModeOfAcquisCodeId = @nInvocationOfPledgeMOA)
		BEGIN
			if(@ImptPostShareQtyCodeId = @nNo AND @ActionCodeId = @nSell)
			BEGIN		
				  SET @PledgeSellQuantity = (@Quantity * @LotSize)		
			END
		END
	END	
	ELSE IF(@Type = 'OtherBuy')	
	BEGIN
		IF((@ImptPostShareQtyCodeId != @nNo AND @ImptPostShareQtyCodeId = @nAdd) OR (@ImptPostShareQtyCodeId != @nNo AND @ImptPostShareQtyCodeId = @nBoth))
		BEGIN				   
			SET @OtherBuyQuantity = (@Quantity * @LotSize) 	
		END
	END		
	ELSE IF(@Type = 'OtherSell')	
	BEGIN
		IF((@ImptPostShareQtyCodeId != @nNo AND @ImptPostShareQtyCodeId = @nLess) OR (@ImptPostShareQtyCodeId != @nNo AND @ImptPostShareQtyCodeId = @nBoth))
		BEGIN
		     IF(@nTransTypeCodeId = @nTransactionType_CashlessPartial)
		     BEGIN
			   SET @OtherSellQuantity = (@PartialSellQuantity * @LotSize)
		     END
		     ELSE
		     BEGIN
				SET @OtherSellQuantity = (@Quantity * @LotSize)
		     END
		END
	END	
	ELSE IF(@Type = 'NotTradedBuy')
	BEGIN
	    IF (@nModeOfAcquisCodeId != @nPledgeCreationMOA AND @nModeOfAcquisCodeId != @nRevokationOfPledgeMOA AND @nModeOfAcquisCodeId != @nInvocationOfPledgeMOA)
		BEGIN
			if(@ImptPostShareQtyCodeId = @nNo AND @ActionCodeId = @nBuy)
			BEGIN
				  SET @NotImpactedBuyQuantity = (@Quantity * @LotSize)
			END
		END
	END
	ELSE IF(@Type = 'NotTradedSell')	
	BEGIN
		IF (@nModeOfAcquisCodeId != @nPledgeCreationMOA AND @nModeOfAcquisCodeId != @nRevokationOfPledgeMOA AND @nModeOfAcquisCodeId != @nInvocationOfPledgeMOA)
		BEGIN
			if(@ImptPostShareQtyCodeId = @nNo AND @ActionCodeId = @nSell)
			BEGIN		
				  SET @NotImpactedSellQuantity = (@Quantity * @LotSize)		
			END
		END
	END	


	INSERT INTO @ReturnTable
	SELECT @OtherBuyQuantity, @OtherSellQuantity, @PledgeBuyQuantity, @PledgeSellQuantity,@NotImpactedBuyQuantity, @NotImpactedSellQuantity

RETURN 
END
