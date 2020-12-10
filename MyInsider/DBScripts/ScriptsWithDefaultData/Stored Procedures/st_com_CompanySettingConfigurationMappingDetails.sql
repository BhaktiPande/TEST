IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanySettingConfigurationMappingDetails')
DROP PROCEDURE [dbo].[st_com_CompanySettingConfigurationMappingDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Company configuration mapping details

Returns:		0, if Success.
				
Created by:		Parag
Created on:		08-Sept-2016

Modification History:
Modified By		Modified On	Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanySettingConfigurationMappingDetails]
	@inp_iMapToTypeCodeId			INT,						-- Map to type code id 
	@inp_iConfigurationMapToId		INT,						-- configuration id
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_CONFIGURATIONMAP_ERROR INT = 13166 --Error occured while fetching company configuration mapping details
	DECLARE @ERR_CONFIGURATIONMAP_NOTFOUND INT = 13167 --Company configuration mapping details not found

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
		
		-- check if configuration mapping exists for configuration
		--IF NOT EXISTS(SELECT ConfigurationMapToId FROM com_CompanySettingConfigurationMapping WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND ConfigurationMapToId = @inp_iConfigurationMapToId)
		--BEGIN
		--	SET @out_nReturnValue = @ERR_CONFIGURATIONMAP_NOTFOUND
		--	RETURN @out_nReturnValue
		--END

		-- get configuration details for configuration type
		SELECT cscm.MapToTypeCodeId, cscm.ConfigurationMapToId, cscm.ConfigurationValueId, cscm.ConfigurationValueOptional
		FROM com_CompanySettingConfigurationMapping cscm
		WHERE cscm.MapToTypeCodeId = @inp_iMapToTypeCodeId AND cscm.ConfigurationMapToId = @inp_iConfigurationMapToId
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_CONFIGURATIONMAP_ERROR, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

