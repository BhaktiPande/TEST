
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'com_CompanySettingConfiguration'))
BEGIN
	CREATE TABLE com_CompanySettingConfiguration
	(
		ConfigurationTypeCodeId INT NOT NULL CONSTRAINT FK_com_CompanySettingConfiguration_ConfigurationTypeCodeId_com_Code_CodeID FOREIGN KEY(ConfigurationTypeCodeId)REFERENCES com_Code(CodeID),
		ConfigurationCodeId INT NOT NULL CONSTRAINT FK_com_CompanySettingConfiguration_ConfigurationCodeId_com_Code_CodeID FOREIGN KEY(ConfigurationCodeId)REFERENCES com_Code(CodeID),
		ConfigurationValueCodeId INT DEFAULT NULL,
		ConfigurationValueOptional VARCHAR(1000) DEFAULT NULL,
		IsMappingCode BIT NOT NULL DEFAULT 0,
		CreatedBy INT NOT NULL CONSTRAINT FK_com_CompanySettingConfiguration_CreatedBy_UserInfo_UserINfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserINfo(UserInfoId),
		CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
		ModifiedBy INT NOT NULL CONSTRAINT FK_com_CompanySettingConfiguration_ModifiedBy_UserInfo_UserINfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserINfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL DEFAULT GETDATE()
	)
END
GO