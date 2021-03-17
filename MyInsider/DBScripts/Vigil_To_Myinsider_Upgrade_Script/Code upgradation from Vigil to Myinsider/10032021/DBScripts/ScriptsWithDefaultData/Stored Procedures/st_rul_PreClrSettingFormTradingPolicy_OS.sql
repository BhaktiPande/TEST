IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PreClrSettingFormTradingPolicy_OS')
DROP PROCEDURE [dbo].[st_rul_PreClrSettingFormTradingPolicy_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the Trading Policy configuration setting details for configuration type

Created by:		Rajashri
Created on:		02-Feb-2020

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_PreClrSettingFormTradingPolicy_OS]
	@inp_iUserInfoID					INT,
    @out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
    DECLARE @ERR_COMPANYCONFIGURATION_ERROR INT = 13164 --Error occured while fetching company configuration
	DECLARE @ERR_COMPANYCONFIGURATION_NOTFOUND INT = 13165 --Company configuration not found
	DECLARE @TradingPolicyId INT=0
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
					
		SET @TradingPolicyId = (SELECT MAX(MapToId) FROM vw_ApplicableTradingPolicyForUser_OS WHERE UserInfoId=@inp_iUserInfoID);	
		SELECT IsPreClearanceRequired,PreClrTradesApprovalReqFlag FROM rul_TradingPolicy_OS WHERE TradingPolicyId=@TradingPolicyId					
				
		
        SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY

	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANYCONFIGURATION_ERROR, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END