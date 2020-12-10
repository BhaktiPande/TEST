IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateESOPPoolDematwise')
DROP PROCEDURE [dbo].[st_tra_UpdateESOPPoolDematwise]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for Update ESOP pool dematwise

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		31-Aug-2016

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_tra_UpdateESOPPoolDematwise 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_UpdateESOPPoolDematwise]
	@inp_UserInfoID								INT,
	@inp_iDMATDetailsID						INT,
	@inp_iSecuirtyTypeCodeID					INT,						-- Security Type code id
	@inp_iESOPQty								DECIMAL(15,0),	
	@inp_iOtherQty								DECIMAL(15,0),
	@inp_iPledgeQuantity						DECIMAL(15,0),	
	@inp_iNotImpactedQuantity					DECIMAL(15,0),	
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
		DECLARE @ERR_UPDATEPOOL	INT = 16445
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
		
		IF NOT EXISTS(SELECT * FROM tra_ExerciseBalancePool WHERE UserInfoId = @inp_UserInfoID 
			AND SecurityTypeCodeId = @inp_iSecuirtyTypeCodeID AND DMATDetailsID = @inp_iDMATDetailsID)
		BEGIN
			INSERT INTO tra_ExerciseBalancePool(UserInfoId,DMATDetailsID,SecurityTypeCodeId,ESOPQuantity,OtherQuantity,PledgeQuantity,NotImpactedQuantity)
			VALUES(@inp_UserInfoID,@inp_iDMATDetailsID,@inp_iSecuirtyTypeCodeID,@inp_iESOPQty,@inp_iOtherQty,@inp_iPledgeQuantity,@inp_iNotImpactedQuantity)
		END
		ELSE
		BEGIN
			UPDATE tra_ExerciseBalancePool
			SET ESOPQuantity = @inp_iESOPQty,
				OtherQuantity = @inp_iOtherQty,
				PledgeQuantity = @inp_iPledgeQuantity,
				NotImpactedQuantity = @inp_iNotImpactedQuantity
			WHERE UserInfoId = @inp_UserInfoID 
				AND SecurityTypeCodeId = @inp_iSecuirtyTypeCodeID AND DMATDetailsID = @inp_iDMATDetailsID
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

