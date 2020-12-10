IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanySettingConfigurationUpdate')
DROP PROCEDURE [dbo].[st_com_CompanySettingConfigurationUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Update the Company configuration setting and add/update/delete company configuraiton mapping details

Returns:		0, if Success.
				
Created by:		Parag
Created on:		13-Sept-2016

Modification History:
Modified By		Modified On		Description
Parag			13-Oct-2016		Made change to update restricted list setting Form F doc id 

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanySettingConfigurationUpdate]
	@inp_tblUpdateConfiguration			CompanySettingConfigurationDataTable READONLY,
	@inp_tblDeleteConfigurationMapping	CompanySettingConfigurationMappingDataTable READONLY,
	@inp_tblAddConfigurationMapping		CompanySettingConfigurationMappingDataTable READONLY,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANYCONFIGURATION_UPDATE_ERROR INT = 13168 --Error occurred while saving company configuration details

	DECLARE @ConfigType_RestrictedList INT = 180003
	DECLARE @Config_PCL_Form_F_Template INT = 185005

	DECLARE @MAPTOTYPE_Form_F INT = 132016

	DECLARE @PurposeCodeId_Form_F INT = 133004

	DECLARE @ConfigTypeCount INT = 0
	DECLARE @Form_F_Doc_Id INT = 0
	DECLARE @Modified_By_Id INT = 0

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
		
		--update company setting configuration from data table
		UPDATE csc 
		SET
			csc.ConfigurationValueCodeId = dt.ConfigurationValueCodeId, 
			csc.ConfigurationValueOptional = dt.ConfigurationValueOptional,
			csc.IsMappingCode = dt.IsMappingCode,
			csc.ModifiedBy = dt.ModifiedBy,			
			csc.RLSearchLimit= dt.RLSearchLimit,
			csc.ModifiedOn = dbo.uf_com_GetServerDate()
		FROM 
		com_CompanySettingConfiguration csc
		INNER JOIN @inp_tblUpdateConfiguration dt ON csc.ConfigurationTypeCodeId = dt.ConfigurationTypeCodeId AND csc.ConfigurationCodeId = dt.ConfigurationCodeId

		-- check if restricted list setting is being updated
		SELECT @ConfigTypeCount = COUNT(ConfigurationTypeCodeId) FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = @ConfigType_RestrictedList
		IF(@ConfigTypeCount > 0)
		BEGIN
			SELECT @Form_F_Doc_Id = MAX(DocumentId) FROM com_DocumentObjectMapping 
			WHERE MapToTypeCodeId = @MAPTOTYPE_Form_F AND PurposeCodeId = @PurposeCodeId_Form_F

			IF (@Form_F_Doc_Id IS NOT NULL)
			BEGIN
				-- get modified by 
				SELECT TOP 1 @Modified_By_Id = ModifiedBy FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = @ConfigType_RestrictedList
				
				-- update restricted list setting for Form F template Id
				UPDATE csc2 
				SET
					csc2.ConfigurationValueOptional = @Form_F_Doc_Id,
					csc2.IsMappingCode = 0,
					csc2.ModifiedBy = @Modified_By_Id,
					csc2.ModifiedOn = dbo.uf_com_GetServerDate(),
					csc2.RLSearchLimit=0
				FROM 
					com_CompanySettingConfiguration csc2
				WHERE 
					csc2.ConfigurationTypeCodeId = @ConfigType_RestrictedList AND csc2.ConfigurationCodeId = @Config_PCL_Form_F_Template
			END
		END

		-- check company setting configuration mapping data table for deletion and delete records 
		IF EXISTS(SELECT MapToTypeCodeId FROM @inp_tblDeleteConfigurationMapping)
		BEGIN
			DELETE cscm 
			FROM com_CompanySettingConfigurationMapping cscm
			INNER JOIN @inp_tblDeleteConfigurationMapping dt ON cscm.MapToTypeCodeId = dt.MapToTypeCodeId AND cscm.ConfigurationMapToId = dt.ConfigurationMapToId
		END

		-- check company setting configuration mapping data table for insertion and insert records 
		IF EXISTS(SELECT MapToTypeCodeId FROM @inp_tblAddConfigurationMapping)
		BEGIN
			INSERT INTO com_CompanySettingConfigurationMapping
			(MapToTypeCodeId, ConfigurationMapToId, ConfigurationValueId, ConfigurationValueOptional, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			SELECT MapToTypeCodeId, ConfigurationMapToId, ConfigurationValueId,  ConfigurationValueOptional, ModifiedBy, dbo.uf_com_GetServerDate(), ModifiedBy, dbo.uf_com_GetServerDate()
			FROM @inp_tblAddConfigurationMapping
		END

		SELECT 1 -- this select statement is for PetaPoco

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANYCONFIGURATION_UPDATE_ERROR, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

