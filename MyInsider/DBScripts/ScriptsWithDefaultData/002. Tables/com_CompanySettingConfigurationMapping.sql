IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'com_CompanySettingConfigurationMapping'))
BEGIN
	CREATE TABLE com_CompanySettingConfigurationMapping
	(
		MapToTypeCodeId INT NOT NULL CONSTRAINT FK_com_CompanySettingConfigurationMapping_MapToTypeCodeId_com_Code_CodeID FOREIGN KEY(MapToTypeCodeId)REFERENCES com_Code(CodeID),
		ConfigurationMapToId INT NOT NULL,
		ConfigurationValueId INT NULL, 
		ConfigurationValueOptional VARCHAR(1000) NULL, 
		CreatedBy INT NOT NULL CONSTRAINT FK_com_CompanySettingConfigurationMapping_CreatedBy_UserInfo_UserINfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserINfo(UserInfoId),
		CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
		ModifiedBy INT NOT NULL CONSTRAINT FK_com_CompanySettingConfigurationMapping_ModifiedBy_UserInfo_UserINfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserINfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL DEFAULT GETDATE()
	)
END
GO