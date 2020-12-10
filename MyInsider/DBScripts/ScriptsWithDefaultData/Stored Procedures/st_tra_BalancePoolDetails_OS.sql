IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_BalancePoolDetails_OS')
DROP PROCEDURE [dbo].[st_tra_BalancePoolDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get security balance details from pool

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		03-Mar-2019

Usage:
EXEC st_tra_BalancePoolDetails_OS <user id> <security type>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_BalancePoolDetails_OS]
	@inp_iUserInfoId				INT,
	@inp_iSecurityTypeCodeId		INT,
	@inp_iDMATDetailsID				INT,
	@inp_iCompanyID                 INT,
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
			IF (NOT EXISTS(SELECT UserInfoId FROM tra_BalancePool_OS WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
			AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyID))
			BEGIN	
					SELECT @inp_iUserInfoId AS UserInfoId, @inp_iSecurityTypeCodeId AS SecurityTypeCodeId, @inp_iCompanyID AS CompanyID, 0 AS VirtualQuantity, 0 AS ActualQuantity, 0 AS PledgeQuantity
			END
			
			--Fetch the PolicyDocument details
			SELECT UserInfoId, SecurityTypeCodeId, CompanyID, VirtualQuantity, ActualQuantity, PledgeQuantity 
			FROM tra_BalancePool_OS 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId 
			AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyID
		END
		ELSE
		BEGIN
			IF (NOT EXISTS(SELECT UserInfoId FROM tra_BalancePool_OS WHERE UserInfoId = @inp_iUserInfoId 
			AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND CompanyID = @inp_iCompanyID))
			BEGIN	
					SELECT @inp_iUserInfoId AS UserInfoId, @inp_iSecurityTypeCodeId AS SecurityTypeCodeId, @inp_iCompanyID AS CompanyID, 0 AS VirtualQuantity, 0 AS ActualQuantity, 0 AS PledgeQuantity
			END
			
			SELECT UserInfoId, SecurityTypeCodeId, CompanyID, ISNULL(SUM(VirtualQuantity),0) AS VirtualQuantity, ISNULL(SUM(ActualQuantity),0) AS ActualQuantity, ISNULL(SUM(PledgeQuantity),0) AS PledgeQuantity
			FROM tra_BalancePool_OS 
			WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND CompanyID = @inp_iCompanyID
			GROUP BY UserInfoId,SecurityTypeCodeId,CompanyID
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

