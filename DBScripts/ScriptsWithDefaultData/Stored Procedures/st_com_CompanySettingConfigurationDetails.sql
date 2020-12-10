IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanySettingConfigurationDetails')
DROP PROCEDURE [dbo].[st_com_CompanySettingConfigurationDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Company configuration setting details for configuration type

Returns:		0, if Success.
				
Created by:		Parag
Created on:		07-Sept-2016

Modification History:
Modified By		Modified On	Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanySettingConfigurationDetails]
	@inp_iConfigurationTypeCodeId	INT,						-- type of configuration whose details are to be fetched.
	@inp_iConfigurationCodeId		INT = NULL,					-- configuration code for which values to be fetch
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANYCONFIGURATION_ERROR INT = 13164 --Error occured while fetching company configuration
	DECLARE @ERR_COMPANYCONFIGURATION_NOTFOUND INT = 13165 --Company configuration not found

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
		
		-- check if configuration exists for configuration type
		IF NOT EXISTS(SELECT ConfigurationTypeCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = @inp_iConfigurationTypeCodeId)
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANYCONFIGURATION_NOTFOUND
			RETURN @out_nReturnValue

			-- check if configuration code exists
			IF @inp_iConfigurationCodeId IS NOT NULL AND 
				NOT EXISTS(SELECT ConfigurationTypeCodeId FROM com_CompanySettingConfiguration 
							WHERE ConfigurationTypeCodeId = @inp_iConfigurationTypeCodeId AND ConfigurationCodeId = @inp_iConfigurationCodeId)
			BEGIN
				SET @out_nReturnValue = @ERR_COMPANYCONFIGURATION_NOTFOUND
				RETURN @out_nReturnValue
			END
		END

		IF (@inp_iConfigurationCodeId IS NULL)
		BEGIN 
			-- get configuration details for configuration type
			SELECT csc.ConfigurationTypeCodeId, csc.ConfigurationCodeId, csc.ConfigurationValueCodeId, csc.ConfigurationValueOptional, csc.IsMappingCode,csc.RLSearchLimit
			FROM com_CompanySettingConfiguration csc
			WHERE ConfigurationTypeCodeId = @inp_iConfigurationTypeCodeId
		END
		ELSE
		BEGIN
			-- get configuration details for configuration type and code
			SELECT csc.ConfigurationTypeCodeId, csc.ConfigurationCodeId, csc.ConfigurationValueCodeId, csc.ConfigurationValueOptional, csc.IsMappingCode,csc.RLSearchLimit
			FROM com_CompanySettingConfiguration csc
			WHERE csc.ConfigurationTypeCodeId = @inp_iConfigurationTypeCodeId AND csc.ConfigurationCodeId = @inp_iConfigurationCodeId
		END

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

