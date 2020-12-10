IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ExerciseBalancePoolDetails')
DROP PROCEDURE [dbo].[st_tra_ExerciseBalancePoolDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get security balance details from pool

Returns:		0, if Success.
				
Created by:		Parag
Created on:		24-Nov-2015

Modification History:
Modified By		Modified On	Description
Parag			03-Dec-2015		Made change to return balance as "0" if record is not fund
Tushar			06-Sep-2016		Change for maintaining DMAT wise pool and related validation.			

Usage:
EXEC st_tra_ExerciseBalancePoolDetails <user id> <security type>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_ExerciseBalancePoolDetails]
	@inp_iUserInfoId				INT,
	@inp_iSecurityTypeCodeId		INT,
	@inp_iDMATDetailsID				INT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_EXECISE_BALANCE_POOL_DETAILS INT = 17399

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
		
		IF(@inp_iDMATDetailsID IS NOT NULL AND @inp_iDMATDetailsID > 0)
		BEGIN
			--Check if record exists for user and security type whose details are being fetched exists
			IF (NOT EXISTS(SELECT UserInfoId FROM tra_ExerciseBalancePool WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
			AND DMATDetailsID = @inp_iDMATDetailsID))
			BEGIN	
					SELECT @inp_iUserInfoId as UserInfoId, @inp_iSecurityTypeCodeId as SecurityTypeCodeId, 0 as ESOPQuantity, 0 as OtherQuantity
			END
			
			--Fetch the PolicyDocument details
			SELECT UserInfoId, SecurityTypeCodeId, ESOPQuantity, OtherQuantity 
			FROM tra_ExerciseBalancePool 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId 
			AND DMATDetailsID = @inp_iDMATDetailsID
		END
		ELSE
		BEGIN
			IF (NOT EXISTS(SELECT UserInfoId FROM tra_ExerciseBalancePool WHERE UserInfoId = @inp_iUserInfoId 
			AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
			BEGIN	
					SELECT @inp_iUserInfoId as UserInfoId, @inp_iSecurityTypeCodeId as SecurityTypeCodeId, 0 as ESOPQuantity, 0 as OtherQuantity
			END
			
			--Fetch the PolicyDocument details
			SELECT UserInfoId, SecurityTypeCodeId, ISNULL(SUM(ESOPQuantity),0) AS ESOPQuantity, ISNULL(SUM(OtherQuantity),0) AS OtherQuantity
			FROM tra_ExerciseBalancePool 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId 
			GROUP BY UserInfoId,SecurityTypeCodeId
			--AND DMATDetailsID = @inp_iDMATDetailsID
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_EXECISE_BALANCE_POOL_DETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

