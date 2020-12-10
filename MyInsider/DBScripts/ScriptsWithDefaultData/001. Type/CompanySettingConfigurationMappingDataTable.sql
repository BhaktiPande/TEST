/*
	Script from Parag on 13 September 2016
	Create Data table to save company configuration
*/

IF NOT EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'CompanySettingConfigurationMappingDataTable')
BEGIN
	CREATE TYPE CompanySettingConfigurationMappingDataTable AS TABLE
	(
		MapToTypeCodeId INT NOT NULL,
		ConfigurationMapToId INT NOT NULL,
		ConfigurationValueId INT NULL, 
		ConfigurationValueOptional VARCHAR(1000) NULL, 
		ModifiedBy INT NOT NULL
	)
END
GO