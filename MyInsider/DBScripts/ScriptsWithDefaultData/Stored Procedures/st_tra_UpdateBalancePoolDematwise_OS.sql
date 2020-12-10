IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateBalancePoolDematwise_OS')
DROP PROCEDURE [dbo].[st_tra_UpdateBalancePoolDematwise_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for Update ESOP pool dematwise

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		25-FEB-2019
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_UpdateBalancePoolDematwise_OS]
	@inp_UserInfoID								INT,
	@inp_iDMATDetailsID						    INT,
	@inp_CompanyID                              INT,
	@inp_iSecuirtyTypeCodeID					INT,						-- Security Type code id
	@inp_iVirtualQty						    DECIMAL(15,0),	
	@inp_iActualQty								DECIMAL(15,0),
	@inp_iPledgeQuantity						DECIMAL(15,0),	
	@inp_iNotImpactedQuantity					DECIMAL(15,0),	
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
		DECLARE @ERR_UPDATEPOOL	INT = 53005
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
		
		IF NOT EXISTS(SELECT * FROM tra_BalancePool_OS WHERE UserInfoId = @inp_UserInfoID 
			AND SecurityTypeCodeId = @inp_iSecuirtyTypeCodeID AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_CompanyID)
		BEGIN
			INSERT INTO tra_BalancePool_OS(UserInfoId,DMATDetailsID,CompanyID,SecurityTypeCodeId,VirtualQuantity,ActualQuantity,PledgeQuantity,NotImpactedQuantity)
			VALUES(@inp_UserInfoID,@inp_iDMATDetailsID,@inp_CompanyID, @inp_iSecuirtyTypeCodeID,@inp_iVirtualQty,@inp_iActualQty,@inp_iPledgeQuantity,@inp_iNotImpactedQuantity)
		END
		ELSE
		BEGIN
			UPDATE tra_BalancePool_OS
			SET VirtualQuantity = @inp_iVirtualQty,
				ActualQuantity = @inp_iActualQty,
				PledgeQuantity = @inp_iPledgeQuantity,
				NotImpactedQuantity = @inp_iNotImpactedQuantity
			WHERE UserInfoId = @inp_UserInfoID 
				AND SecurityTypeCodeId = @inp_iSecuirtyTypeCodeID AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_CompanyID
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_UPDATEPOOL, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END

