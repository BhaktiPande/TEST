IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uf_tra_CheckForContraTrade_OS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].uf_tra_CheckForContraTrade_OS
GO

-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 03-JUN-2016																								        =
--	PURPOSE			: THIS FUNCTION IS USED TO CHECK FOR CONTRATRADE.																    =
-- ======================================================================================================================================

CREATE FUNCTION [dbo].[uf_tra_CheckForContraTrade_OS]
(
	@nTransTypeCodeId		INT,
	@nModeOfAcquisCodeId    INT,
	@nSecurityTypeCodeId    INT	
)
RETURNS BIT
AS
BEGIN
      
     DECLARE @contra_trade_code_id INT
     DECLARE @contratrade_yes INT = 506001
     DECLARE @bIsContraTrade BIT
     
     select @contra_trade_code_id = contra_trade_code_id from tra_TransactionTypeSettings_OS where mode_of_acquis_code_id = @nmodeofacquiscodeid  and trans_type_code_id = @ntranstypecodeid AND security_type_code_id = @nSecurityTypeCodeId

     IF(@contra_trade_code_id = @contratrade_yes)
     BEGIN
       SET @bIsContraTrade = 0
     END
     ELSE
     BEGIN
       SET @bIsContraTrade = 1
     END
     
     return @bIsContraTrade
END
GO
