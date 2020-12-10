
/*
Added group and code for Company configuration type
GroupId: 180 : Company configuration type
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 180)
BEGIN
	INSERT INTO com_CodeGroup 
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(180, NULL, 'Company Configuraiton Type', 'Company Configuraiton Type', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 180001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(180001, NULL, 'Enter Upload Settings', NULL, 180, 'Enter Upload Settings for each disclosure type', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 180002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(180002, NULL, 'Demat Accounts Settings', NULL, 180, 'Demat Accounts Settings for implementing and non-implementing company', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 180003)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(180003, NULL, 'Restricted List Settings', NULL, 180, 'Restricted List Settings', 1, 1, GETDATE(), 3)
END


/*
Added group and code for Company configuration - Enter upload setting values
GroupId: 182 : Company configuration - Enter upload setting values
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 182)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(182, NULL, 'Enter Upload Setting Values', 'Enter Upload Setting Values', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 182001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(182001, NULL, 'Enter Details', NULL, 182, 'Enter Details', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 182002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(182002, NULL, 'Upload Details', NULL, 182, 'Upload Details', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 182003)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(182003, NULL, 'Enter Details & Upload Details', NULL, 182, 'Enter Details & Upload Details', 1, 1, GETDATE(), 3)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 182004)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(182004, NULL, 'Enter Details or Upload Details', NULL, 182, 'Enter Details or Upload Details', 1, 1, GETDATE(), 4)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 182005)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(182005, NULL, 'Enter Details &\or Upload Details', NULL, 182, 'Enter Details &\or Upload Details', 1, 1, GETDATE(), 5)
END


/*
Added group and code for Company configuration - demat accounts setting for
GroupId: 183 : Company configuration - demat accounts setting for
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 183)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(183, NULL, 'Pre-clearance type', 'Pre-clearance type', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 183001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(183001, NULL, 'Pre-clearance of implementing company', NULL, 183, 'Pre-clearance of implementing company', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 183002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(183002, NULL, 'Pre-clearance other than implementing company', NULL, 183, 'Pre-clearance other than implementing company', 1, 1, GETDATE(), 2)
END


/*
Added group and code for Company configuration - demat accounts setting values
GroupId: 184 : Company configuration - demat accounts setting values
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 184)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(184, NULL, 'Demat Accounts Setting Values', 'Demat Accounts Setting Values', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 184001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(184001, NULL, 'Consider All Demat Account', NULL, 184, 'Consider All Demat Account', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 184002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(184002, NULL, 'Consider Selected DP Name Demat Account', NULL, 184, 'Consider Selected DP Name Demat Account', 1, 1, GETDATE(), 2)
END


/*
Added group and code for Company configuration - restricted list setting
GroupId: 185 : Company configuration - restricted list setting
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 185)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(185, NULL, 'Restricted List Setting', 'Restricted List Setting', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(185001, NULL, 'Pre-clearance required', NULL, 185, 'Pre-clearance required', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(185002, NULL, 'Pre-clearance approval', NULL, 185, 'Pre-clearance approval', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185003)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(185003, NULL, 'Pre-clearance allow if zero balance', NULL, 185, 'All pre-clearance if non implementing company Demat account is zero(0)', 1, 1, GETDATE(), 3)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185004)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(185004, NULL, 'Pre-clearance Form F required', NULL, 185, 'Pre-clearance Form required for restricted company', 1, 1, GETDATE(), 4)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185005)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(185005, NULL, 'Pre-clearance Form F template file', NULL, 185, 'Pre-clearance Form F template file', 1, 1, GETDATE(), 5)
END


/*
Added group and code for yes/no setting
GroupId: 186 : yes/no setting
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 186)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(186, NULL, 'Yes/No Setting', 'Yes/No Setting', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 186001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(186001, NULL, 'Yes', NULL, 186, 'Yes', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 186002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(186002, NULL, 'No', NULL, 186, 'No', 1, 1, GETDATE(), 2)
END


/*
Added group and code for Non-implementing Company Pre-clearance approval setting
GroupId: 187 : Non-implementing Company Pre-clearance approval setting
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 187)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(187, NULL, 'Non-implementing Company Pre-clearance approval setting', 'Non-implementing Company Pre-clearance approval setting', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 187001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(187001, NULL, 'Auto Approval', NULL, 187, 'Auto Approval', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 187002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(187002, NULL, 'Manual Approval', NULL, 187, 'Manual Approval', 1, 1, GETDATE(), 2)
END


/*
Default Insert for com_CompanySettingConfiguration table
*/
IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180001 AND ConfigurationCodeId = 147001)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180001, 147001, 182001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180001 AND ConfigurationCodeId = 147002)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180001, 147002, 182001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180001 AND ConfigurationCodeId = 147003)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180001, 147003, 182001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180002 AND ConfigurationCodeId = 183001)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180002, 183001, 184001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180002 AND ConfigurationCodeId = 183002)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180002, 183002, 184001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180002 AND ConfigurationCodeId = 147001)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180002, 147001, 184001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180002 AND ConfigurationCodeId = 147002)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180002, 147002, 184001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180002 AND ConfigurationCodeId = 147003)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180002, 147003, 184001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180003 AND ConfigurationCodeId = 185001)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180003, 185001, 186002, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180003 AND ConfigurationCodeId = 185002)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180003, 185002, 187001, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180003 AND ConfigurationCodeId = 185003)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180003, 185003, 186002, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180003 AND ConfigurationCodeId = 185004)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, ConfigurationValueCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180003, 185004, 186002, 1, 1)
END

IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180003 AND ConfigurationCodeId = 185005)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
		(ConfigurationTypeCodeId, ConfigurationCodeId, CreatedBy, ModifiedBy)
	VALUES
		(180003, 185005, 1, 1)
END


-- add map to type code id for demat
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 132014)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(132014, NULL, 'Demat Account', NULL, 132, 'Map to Type - Demat Account', 1, 1, GETDATE(), 14)
END


/*
	Script from Parag on 1 September 2016
	Alter trading policy table to add new column
*/

/*
Added group and code for new column add into trading policy table for pre-clearance setting 
GroupId: 188 : Enable Pre-clearance without submitting Period End Disclosure
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 188)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(188, NULL, 'Enable Pre-clearance without submitting Period End Disclosure', 'Enable Pre-clearance without submitting Period End Disclosure', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 188001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(188001, NULL, 'Allow before & after period end last submission date', NULL, 188, 'Allow before & after period end last submission date', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 188002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(188002, NULL, 'Allow till period end last submission date', NULL, 188, 'Allow till period end last submission date', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 188003)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(188003, NULL, 'No', NULL, 188, 'No', 1, 1, GETDATE(), 3)
END


IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'IsPreclearanceFormForImplementingCompany' AND object_id = OBJECT_ID(N'rul_TradingPolicy'))
BEGIN
	ALTER TABLE rul_TradingPolicy ADD IsPreclearanceFormForImplementingCompany BIT NOT NULL DEFAULT 0 
END
GO

IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'PreclearanceWithoutPeriodEndDisclosure' AND object_id = OBJECT_ID(N'rul_TradingPolicy'))
BEGIN
	ALTER TABLE rul_TradingPolicy 
		ADD PreclearanceWithoutPeriodEndDisclosure INT NOT NULL DEFAULT 188003
		CONSTRAINT FK_rul_TradingPolicy_PreclearanceWithoutPeriodEndDisclosure_com_Code_CodeID FOREIGN KEY(PreclearanceWithoutPeriodEndDisclosure)REFERENCES com_Code(CodeID)  
END
GO


/*
	Script from Parag on 1 September 2016
	Alter user info table to add new column
*/
IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'PeriodEndDisclosureUploaded' AND object_id = OBJECT_ID(N'usr_UserInfo'))
BEGIN
	ALTER TABLE usr_UserInfo 
		ADD PeriodEndDisclosureUploaded INT NULL DEFAULT NULL 
		CONSTRAINT FK_usr_UserInfo_PeriodEndDisclosureUploaded_com_Code_CodeID FOREIGN KEY(PeriodEndDisclosureUploaded)REFERENCES com_Code(CodeID)  
END
GO


/*
	Script from Parag on 2 September 2016
	Alter demat details table to add new column to save code for dp name
*/
IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'DPBankCodeId' AND object_id = OBJECT_ID(N'usr_DMATDetails'))
BEGIN
	ALTER TABLE usr_DMATDetails 
		ADD DPBankCodeId INT NULL DEFAULT NULL 
		CONSTRAINT FK_usr_DMATDetails_DPBankCodeId_com_Code_CodeID FOREIGN KEY(DPBankCodeId)REFERENCES com_Code(CodeID)  
END
GO

/*
	Script from Parag on 6 September 2016
	Add resource for Company configuration tab on company edit page
*/

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122084)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122084, 103005, 'Company Level Configuration', NULL, 122, 'Screen - Company Level Configuration', 1, 1, GETDATE(), 96)
END


IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13123)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13123, 'cmp_ttl_13123', 'Company Level Configuration', 'en-US', 103005, 104006, 122084, 'Company Level Configuration', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13124)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13124, 'cmp_lbl_13124', 'Enter Upload Settings', 'en-US', 103005, 104006, 122084, 'Enter Upload Settings', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13125)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13125, 'cmp_lbl_13125', 'Initial Disclosures trade submission', 'en-US', 103005, 104006, 122084, 'Initial Disclosures trade submission', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13126)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13126, 'cmp_lbl_13126', 'Continuous Disclosures trade submission', 'en-US', 103005, 104006, 122084, 'Continuous Disclosures trade submission', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13127)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13127, 'cmp_lbl_13127', 'Period End Disclosures trade submission', 'en-US', 103005, 104006, 122084, 'Period End Disclosures trade submission', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13128)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13128, 'cmp_lbl_13128', 'Enter Details', 'en-US', 103005, 104006, 122084, 'Enter Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13129)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13129, 'cmp_lbl_13129', 'Upload Details', 'en-US', 103005, 104006, 122084, 'Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13130)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13130, 'cmp_lbl_13130', 'Enter Details & Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details & Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13131)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13131, 'cmp_lbl_13131', 'Enter Details or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details or Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13132)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13132, 'cmp_lbl_13132', 'Enter Details &/or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details &/or Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13133)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13133, 'cmp_lbl_13133', 'Enter Details', 'en-US', 103005, 104006, 122084, 'Enter Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13134)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13134, 'cmp_lbl_13134', 'Upload Details', 'en-US', 103005, 104006, 122084, 'Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13135)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13135, 'cmp_lbl_13135', 'Enter Details & Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details & Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13136)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13136, 'cmp_lbl_13136', 'Enter Details or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details or Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13137)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13137, 'cmp_lbl_13137', 'Enter Details &/or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details &/or Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13138)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13138, 'cmp_lbl_13138', 'Enter Details', 'en-US', 103005, 104006, 122084, 'Enter Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13139)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13139, 'cmp_lbl_13139', 'Upload Details', 'en-US', 103005, 104006, 122084, 'Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13140)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13140, 'cmp_lbl_13140', 'Enter Details & Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details & Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13141)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13141, 'cmp_lbl_13141', 'Enter Details or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details or Upload Details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13142)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13142, 'cmp_lbl_13142', 'Enter Details &/or Upload Details', 'en-US', 103005, 104006, 122084, 'Enter Details &/or Upload Details', 1, GETDATE())
END

/*
	Script from Parag on 7 September 2016
	Add resource for Company configuration tab on company edit page
*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13143)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13143, 'cmp_lbl_13143', 'Demat Accounts Settings', 'en-US', 103005, 104006, 122084, 'Demat Accounts Settings', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13144)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13144, 'cmp_lbl_13144', 'For Pre-clearances of Implementing company', 'en-US', 103005, 104006, 122084, 'For Pre-clearances of Implementing company', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13145)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13145, 'cmp_lbl_13145', 'Consider All Demat accounts for pre-clearances', 'en-US', 103005, 104006, 122084, 'Consider All Demat accounts for pre-clearances', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13146)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13146, 'cmp_lbl_13146', 'Consider Selected DP Name demat accounts for pre-clearances', 'en-US', 103005, 104006, 122084, 'Consider Selected DP Name demat accounts for pre-clearances', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13147)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13147, 'cmp_lbl_13147', 'DP Name', 'en-US', 103005, 104006, 122084, 'DP Name', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13148)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13148, 'cmp_lbl_13148', 'For Pre-clearances other than Implementing company', 'en-US', 103005, 104006, 122084, 'For Pre-clearances other than Implementing company', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13149)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13149, 'cmp_lbl_13149', 'Consider All Demat accounts for pre-clearances', 'en-US', 103005, 104006, 122084, 'Consider All Demat accounts for pre-clearances', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13150)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13150, 'cmp_lbl_13150', 'Consider Selected DP Name demat accounts for pre-clearances', 'en-US', 103005, 104006, 122084, 'Consider Selected DP Name demat accounts for pre-clearances', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13151)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13151, 'cmp_lbl_13151', 'DP Name', 'en-US', 103005, 104006, 122084, 'DP Name', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13152)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13152, 'cmp_lbl_13152', 'For Transaction of Implementing company Initial Disclosure', 'en-US', 103005, 104006, 122084, 'For Transaction of Implementing company Initial Disclosure', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13153)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13153, 'cmp_lbl_13153', 'Consider All Demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider All Demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13154)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13154, 'cmp_lbl_13154', 'Consider Selected DP Name demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider Selected DP Name demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13155)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13155, 'cmp_lbl_13155', 'DP Name', 'en-US', 103005, 104006, 122084, 'DP Name', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13156)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13156, 'cmp_lbl_13156', 'For Transaction of Implementing company Continuous Disclosure', 'en-US', 103005, 104006, 122084, 'For Transaction of Implementing company Continuous Disclosure', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13157)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13157, 'cmp_lbl_13157', 'Consider All Demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider All Demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13158)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13158, 'cmp_lbl_13158', 'Consider Selected DP Name demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider Selected DP Name demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13159)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13159, 'cmp_lbl_13159', 'DP Name', 'en-US', 103005, 104006, 122084, 'DP Name', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13160)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13160, 'cmp_lbl_13160', 'For Transaction of Implementing company Period End Disclosure', 'en-US', 103005, 104006, 122084, 'For Transaction of Implementing company Period End Disclosure', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13161)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13161, 'cmp_lbl_13161', 'Consider All Demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider All Demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13162)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13162, 'cmp_lbl_13162', 'Consider Selected DP Name demat accounts for transactions', 'en-US', 103005, 104006, 122084, 'Consider Selected DP Name demat accounts for transactions', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13163)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13163, 'cmp_lbl_13163', 'DP Name', 'en-US', 103005, 104006, 122084, 'DP Name', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13164)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13164, 'cmp_msg_13164', 'Error occured while fetching company configuration', 'en-US', 103005, 104006, 122084, 'Error occured while fetching company configuration', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13165)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13165, 'cmp_msg_13165', 'Company configuration not found', 'en-US', 103005, 104006, 122084, 'Company configuration not found', 1, GETDATE())
END

/*	
	Author:-Tushar
	Created On- 06-Sept-2016
	Description:- Demat wise pool maintained
					1. Rename Table tra_ExerciseBalancePool to tra_ExerciseBalancePool_old
					2. Delete constraints for tra_ExerciseBalancePool table
*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tra_ExerciseBalancePool_old'))
BEGIN
	EXEC sp_rename 'tra_ExerciseBalancePool', 'tra_ExerciseBalancePool_old'
END	

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId' AND TABLE_NAME = 'tra_ExerciseBalancePool_old')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool_old DROP CONSTRAINT fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId
END

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId' AND TABLE_NAME = 'tra_ExerciseBalancePool_old')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool_old DROP CONSTRAINT fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId
END

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'PK_tra_ExerciseBalancePool' AND TABLE_NAME = 'tra_ExerciseBalancePool_old')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool_old DROP CONSTRAINT PK_tra_ExerciseBalancePool
END

/*
	1. Create tra_ExerciseBalancePool table with DMATDetailsID change
*/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tra_ExerciseBalancePool'))
BEGIN
	CREATE TABLE tra_ExerciseBalancePool(
		UserInfoId int NOT NULL,
		DMATDetailsID INT NOT NULL,
		SecurityTypeCodeId int NOT NULL,
		ESOPQuantity decimal(15, 0) NOT NULL DEFAULT ((0)),
		OtherQuantity decimal(15, 0) NOT NULL DEFAULT ((0)),
		PledgeQuantity [decimal](15, 0) NOT NULL DEFAULT ((0)),
		NotImpactedQuantity decimal(15, 0) NOT NULL DEFAULT ((0))
	)
END


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'fk_tra_ExerciseBalancePool_Usr_UserInfo_UserInfoId' AND TABLE_NAME = 'tra_ExerciseBalancePool')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT fk_tra_ExerciseBalancePool_Usr_UserInfo_UserInfoId FOREIGN KEY(UserInfoId) 
	REFERENCES usr_UserINfo(UserInfoId)
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId' AND TABLE_NAME = 'tra_ExerciseBalancePool')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId FOREIGN KEY(SecurityTypeCodeId)
	REFERENCES com_Code(CodeId)
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'FK_tra_ExerciseBalancePool_usr_DMATDetails' AND TABLE_NAME = 'tra_ExerciseBalancePool')
BEGIN
	ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT FK_tra_ExerciseBalancePool_usr_DMATDetails FOREIGN KEY(DMATDetailsID)
	REFERENCES usr_DMATDetails(DMATDetailsID)
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
	CONSTRAINT_NAME = 'PK_tra_ExerciseBalancePool' AND TABLE_NAME = 'tra_ExerciseBalancePool')
BEGIN
		ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT PK_tra_ExerciseBalancePool PRIMARY KEY (UserInfoId, SecurityTypeCodeId,DMATDetailsID)
END


/*	
	Author:-Tushar
	Created On- 08-Sept-2016
	Description:- Resource script for Demat wise pool maintained
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16445)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16445, 'tra_msg_16445','Error occurred while update balance pool.','en-US',103008,104001,122036,'Error occurred while update balance pool.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17454)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17454, 'dis_lbl_17454','Total ESOP Exercise qty:','en-US',103009,104002,122051,'Total ESOP Exercise qty:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17455)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17455, 'dis_lbl_17455','Total Other than ESOP Exercise qty:','en-US',103009,104002,122051,'Total Other than ESOP Exercise qty:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16446)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16446, 'tra_lbl_16446','Total ESOP Excercise Qty','en-US',103008,104002,122036,'Total ESOP Excercise Qty',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16447)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16447, 'tra_lbl_16447','Total Other than ESOP Excercise Qty','en-US',103008,104002,122036,'Total Other than ESOP Excercise Qty',1,GETDATE())
END


IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 156007)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(156007, 166002, 'Pre-clearance form for Implementing Company', 'Pre-clearance form for Implementing Company', 156, 'Pre-clearance form for Implementing Company - Form E', 0, 1, GETDATE(), 7)
END
GO

/*
	Author:- Tushar
	Description:- Add Validation for View And View Agree flag at least select one check box.
				  Note: File sent to ED by Mail and also commit change in development branch 09 Sep 2016
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15459)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15459, 'rul_msg_15459','Select at least one value for View & View Agree.','en-US',103006,104001,122038,'Select at least one value for View & View Agree.',1,GETDATE())
END

/*
	Script from Parag on 8 September 2016
	Add resource for Company configuration tab on company edit page
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13166)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13166, 'cmp_msg_13166', 'Error occured while fetching company configuration mapping details', 'en-US', 103005, 104006, 122084, 'Error occured while fetching company configuration mapping details', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13167)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13167, 'cmp_msg_13167', 'Company configuration mapping details not found', 'en-US', 103005, 104006, 122084, 'Company configuration mapping details not found', 1, GETDATE())
END

/*
	Author:- Tushar
	Description:- Insert Resource script for 
	1. Set the configuration of pre-clearance form for Implementing company required 
	   for the insiders/ employees to be generated
	2. Enable Pre-clearance without submitting the Period End Disclosures: User selection radio button for:
		Allow before & after period end last submission date: If selected then pre-clearance is allowed even after period end and after period end last submission date
		Allow till period end last submission date: If selected, then allow pre-clearance till period end last submission date and do not allow pre-clearance after period end last submission date 
		No: Do not allow pre-clearance after period end date

*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15460)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15460, 'rul_lbl_15460','FORM for implementing company Required','en-US',103006,104002,122040,'FORM for implementing company Required',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15461)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15461, 'rul_lbl_15461','Enable Pre-clearance without submitting the Period End Disclosures','en-US',103006,104002,122040,'Enable Pre-clearance without submitting the Period End Disclosures',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15462)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15462, 'rul_lbl_15462','Allow before & after period end last submission date','en-US',103006,104002,122040,'Allow before & after period end last submission date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15463)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15463, 'rul_lbl_15463','Allow till period end last submission date','en-US',103006,104002,122040,'Allow till period end last submission date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15464)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15464, 'rul_lbl_15464','No','en-US',103006,104002,122040,'No',1,GETDATE())
END

/*
	Author:-Tushar
	Description:- Add Column PreclearanceApprovedBy,PreclearanceApprovedOn for showing data on form E
*/
IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'PreclearanceApprovedBy' AND object_id = OBJECT_ID(N'tra_PreclearanceRequest'))
BEGIN
	ALTER TABLE tra_PreclearanceRequest 
		ADD PreclearanceApprovedBy INT NULL DEFAULT NULL 
		CONSTRAINT FK_tra_PreclearanceRequest_PreclearanceApprovedBy_usr_UserInfo_UserInfoId FOREIGN KEY(PreclearanceApprovedBy)
		REFERENCES usr_UserInfo(UserInfoId)
END

IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'PreclearanceApprovedOn' AND object_id = OBJECT_ID(N'tra_PreclearanceRequest'))
BEGIN
	ALTER TABLE tra_PreclearanceRequest 
		ADD PreclearanceApprovedOn DATETIME DEFAULT NULL  
END

/*
	Author:-Tushar
	Description:- Add Resource script for fetch FORM E details.
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17456)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17456, 'dis_msg_17456','Error occurred while fetching FORM E details.','en-US',103009,104001,122046,'Error occurred while fetching FORM E details.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17457)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17457, 'dis_msg_17457','FORM E not generated.','en-US',103009,104001,122046,'FORM E not generated.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17458)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17458, 'dis_msg_17458','Error occurred while generating form E details','en-US',103009,104001,122046,'Error occurred while generating form E details',1,GETDATE())
END

/*
	Script from Parag on 12 September 2016
	Add acid-url mapping for saving company configuration 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 12 AND ControllerName = 'Company' AND ActionName = 'SaveCompanyConfiguration')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(12, 'Company', 'SaveCompanyConfiguration', NULL, 1, GETDATE(), 1, GETDATE())
END




IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13168)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13168, 'cmp_msg_13168', 'Error occurred while saving company configuration details', 'en-US', 103005, 104006, 122084, 'Error occurred while saving company configuration details', 1, GETDATE())
END

/*
	Change datatype of table from NVARCHAR(4000) to NVARCHAR(MAX)
*/
ALTER TABLE tra_TemplateMaster ALTER COLUMN Contents NVARCHAR(MAX)
GO



/*
Scripts added by Raghvendra on 13-Sep-2016
The scripts are arred for the functionality of providing a Mass upload for User Period End Performed Yes/No
*/
IF NOT EXISTS(SELECT * FROM com_MassUploadExcel WHERE MassUploadExcelId = 6)
BEGIN
	INSERT INTO [dbo].[com_MassUploadExcel] ([MassUploadExcelId] ,[MassUploadName] ,[HasMultipleSheets] ,[TemplateFileName])
	VALUES (6 ,'Employee Period End Mass Upload' ,0 ,'EmployeePeriodEndMassUpload')
END

GO

IF NOT EXISTS(SELECT * FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 15 AND MassUploadExcelId = 6)
BEGIN
	INSERT INTO [dbo].[com_MassUploadExcelSheets] ([MassUploadExcelSheetId] ,[MassUploadExcelId] ,[SheetName] ,[IsPrimarySheet] ,[ParentSheetName] ,[ProcedureUsed] ,[ColumnCount])
	VALUES (15 ,6 ,'EmployeePeriodEnd' ,1 ,NULL ,'st_com_MassUploadCommonProcedureExecution' ,3)
END
GO


IF NOT EXISTS(SELECT * FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 11)
BEGIN
	INSERT INTO [dbo].[com_MassUploadDataTable] ([MassUploadDataTableId] ,[MassUploadDataTableName])
	VALUES (11 ,'MassEmployeePeriodEndDataTable')
END
GO


/*Entries in com_MassUploadExcelDataTableColumnMapping*/

IF NOT EXISTS(SELECT * FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 203)
BEGIN
	INSERT INTO [dbo].[com_MassUploadExcelDataTableColumnMapping] ([MassUploadExcelDataTableColumnMappingId] ,[MassUploadExcelSheetId],[ExcelColumnNo] ,[MassUploadDataTableId] ,[MassUploadDataTablePropertyNo] ,[MassUploadDataTablePropertyName] ,[MassUploadDataTablePropertyDataType],[MassUploadDataTablePropertyDataSize] ,[RelatedMassUploadRelatedSheetId] ,[RelatedMassUploadExcelSheetColumnNo] ,[ApplicableDataCodeGroupId],[IsRequiredField] ,[ValidationRegularExpression] ,[MaxLength] ,[MinLength] ,[IsRequiredErrorCode] ,[ValidationRegExpressionErrorCode] ,[MaxLengthErrorCode],[MinLengthErrorCode] ,[DependentColumnNo] ,[DependentColumnErrorCode] ,[DependentValueColumnNumber] ,[DependentValueColumnValue] ,[DependentValueColumnErrorCode] ,[DefaultValue])
	VALUES (203 ,15 ,0 ,11,1 ,'UserInfoId' ,'INT',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

GO

IF NOT EXISTS(SELECT * FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 204)
BEGIN
	INSERT INTO [dbo].[com_MassUploadExcelDataTableColumnMapping] ([MassUploadExcelDataTableColumnMappingId] ,[MassUploadExcelSheetId],[ExcelColumnNo] ,[MassUploadDataTableId] ,[MassUploadDataTablePropertyNo] ,[MassUploadDataTablePropertyName] ,[MassUploadDataTablePropertyDataType],[MassUploadDataTablePropertyDataSize] ,[RelatedMassUploadRelatedSheetId] ,[RelatedMassUploadExcelSheetColumnNo] ,[ApplicableDataCodeGroupId],[IsRequiredField] ,[ValidationRegularExpression] ,[MaxLength] ,[MinLength] ,[IsRequiredErrorCode] ,[ValidationRegExpressionErrorCode] ,[MaxLengthErrorCode],[MinLengthErrorCode] ,[DependentColumnNo] ,[DependentColumnErrorCode] ,[DependentValueColumnNumber] ,[DependentValueColumnValue] ,[DependentValueColumnErrorCode] ,[DefaultValue])
	VALUES (204 ,15 ,1 ,11,2 ,'LoginId' ,'string',100,0,0,NULL,1,NULL,100,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

GO

IF NOT EXISTS(SELECT * FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 205)
BEGIN
	INSERT INTO [dbo].[com_MassUploadExcelDataTableColumnMapping] ([MassUploadExcelDataTableColumnMappingId] ,[MassUploadExcelSheetId],[ExcelColumnNo] ,[MassUploadDataTableId] ,[MassUploadDataTablePropertyNo] ,[MassUploadDataTablePropertyName] ,[MassUploadDataTablePropertyDataType],[MassUploadDataTablePropertyDataSize] ,[RelatedMassUploadRelatedSheetId] ,[RelatedMassUploadExcelSheetColumnNo] ,[ApplicableDataCodeGroupId],[IsRequiredField] ,[ValidationRegularExpression] ,[MaxLength] ,[MinLength] ,[IsRequiredErrorCode] ,[ValidationRegExpressionErrorCode] ,[MaxLengthErrorCode],[MinLengthErrorCode] ,[DependentColumnNo] ,[DependentColumnErrorCode] ,[DependentValueColumnNumber] ,[DependentValueColumnValue] ,[DependentValueColumnErrorCode] ,[DefaultValue])
	VALUES (205 ,15 ,2 ,11,3 ,'PeriodEndPerformed' ,'INT',0,0,0,186,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

GO


/*Entries in com_MassUploadProcedureParameterDetails*/
IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 367)
BEGIN
	INSERT INTO [dbo].[com_MassUploadProcedureParameterDetails] ([MassUploadProcedureParameterDetailsId] ,[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES (367 ,15 ,1 ,11,203,NULL)
END
GO

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 368)
BEGIN
	INSERT INTO [dbo].[com_MassUploadProcedureParameterDetails] ([MassUploadProcedureParameterDetailsId] ,[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES (368 ,15 ,2 ,11,204,NULL)
END
GO


IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 369)
BEGIN
	INSERT INTO [dbo].[com_MassUploadProcedureParameterDetails] ([MassUploadProcedureParameterDetailsId] ,[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES (369 ,15 ,3 ,11,205,NULL)
END
GO



IF NOT EXISTS(SELECT * FROM [mst_Resource] WHERE [ResourceId] = 11441)
BEGIN
	INSERT INTO [dbo].[mst_Resource] ([ResourceId] ,[ResourceKey] ,[ResourceValue] ,[ResourceCulture] ,[ModuleCodeId] ,[CategoryCodeId] ,[ScreenCodeId] ,[OriginalResourceValue] ,[ModifiedBy] ,[ModifiedOn])
	VALUES (11441 ,'usr_msg_11441' ,'User has Performed preclearance so value cannot be updated' ,'en-US' ,103002 ,104001 ,122004 ,'User has Performed preclearance so value cannot be updated' ,1 ,GETDATE())
END
GO

/*
	Script from Parag on 14 September 2016
	Added resource to show success message
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13169)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13169, 'cmp_msg_13169', 'Company configuration saved successfully', 'en-US', 103005, 104006, 122084, 'Company configuration saved successfully', 1, GETDATE())
END

/*
	Scripts for displaying transactions related uploaded document list on 15 September 2016
*/

--Insert new screencode for transaction uploaded document list
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122085)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122085, 103008, 'Transaction Details Document Uploaded List', NULL, 122, 'Screen - Transaction Details Document Uploaded List', 1, 1, GETDATE(), 97)
END
GO

--Insert new code for grid type displaying uploaded document list
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114093)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114093,NULL,'Transaction Details - Uploaded Document list',NULL,114,'Transaction Details - Uploaded Document list',1,1,GETDATE(),93)
END
GO

--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16448)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16448, 'tra_grd_16448','Sr. No.','en-US',103008,104003,122085,'Sr. No.',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16449)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16449, 'tra_grd_16449','Filename','en-US',103008,104003,122085,'Filename',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16450)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16450, 'tra_grd_16450','Upload Date','en-US',103008,104003,122085,'Upload Date',1,GETDATE())
END
GO


/*
	Script from Parag on 15 September 2016
	Add new events for pre-clearance of non-implemention company
*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 153045)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(153045, NULL, 'Pre-clearance requested - Non-Implementation company', NULL, 153, '163001', 0, 1, GETDATE(), 45)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 153046)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(153046, NULL, 'Pre-clearance approved - Non-Implementation company', NULL, 153, '163001', 0, 1, GETDATE(), 46)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 153047)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(153047, NULL, 'Pre-clearance rejected - Non-Implementation company', NULL, 153, '163001', 0, 1, GETDATE(), 47)
END

/*
	Script from Parag on 16 September 2016
	Add new screen code and activity id, user activity mapping for pre-clearance of non implementation company 
*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122086)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122086, 103009, 'Pre-clearance Request Detail - Non-Implmentation company', NULL, 122, 'Screen - PreClearance Request Details - Non-Implmentation company', 1, 1, GETDATE(), 98)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122087)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122087, 103009, 'Pre-clearance Request List - Non-Implmentation company', NULL, 122, 'Screen - PreClearance Request List - Non-Implmentation company', 1, 1, GETDATE(), 99)
END

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 216)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(216, 'Disclosure Details for Insider', 'Preclearance Request - NonImplementation Company', 103008, NULL, 
		'Disclosure Details for Insider - Preclearance Request - NonImplementation Company', 105001, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 217)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(217, 'Disclosure Details for CO', 'Preclearance Request List - NonImplementation Company', 103008, NULL, 
		'Disclosure Details for Insider - Preclearance Request List - NonImplementation Company', 105001, 1, GETDATE(), 1, GETDATE())
END


IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101002 AND ActivityId = 217)
BEGIN
	-- add activity for CO
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101002, ActivityId FROM usr_Activity WHERE ActivityID = 217
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101003 AND ActivityId = 216)
BEGIN
	-- add activity for employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101003, ActivityId FROM usr_Activity WHERE ActivityID = 216
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101006 AND ActivityId = 216)
BEGIN
	-- add activity for non-employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101006, ActivityId FROM usr_Activity WHERE ActivityID = 216
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101004 AND ActivityId = 216)
BEGIN
	-- add activity for corporate
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101004, ActivityId FROM usr_Activity WHERE ActivityID = 216
END

/*
Scripts added by Raghvendra on 17-Sep-2016
The scripts for adding a resource for showing message for invalid demat number used
*/

IF NOT EXISTS(SELECT * FROM [mst_Resource] WHERE [ResourceId] = 11442)
BEGIN
	INSERT INTO [dbo].[mst_Resource] ([ResourceId] ,[ResourceKey] ,[ResourceValue] ,[ResourceCulture] ,[ModuleCodeId] ,[CategoryCodeId] ,[ScreenCodeId] ,[OriginalResourceValue] ,[ModifiedBy] ,[ModifiedOn])
	VALUES (11442 ,'usr_msg_11442' ,'The selected DEMAT account is not allowed as correspodning DP is not allowed as per the configuration' ,'en-US' ,103002 ,104001 ,122004 ,'The selected DEMAT account is not allowed as correspodning DP is not allowed as per the configuration' ,1 ,GETDATE())
END
GO

/*
	19 September 2016
	Scripts for mapping resource keys to grid columns when displaying transactions related uploaded document list on 19 September 2016
*/
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114093 AND ResourceKey = 'tra_grd_16448')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114093, 'tra_grd_16448', 1, 1, 0, 155002, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114093 AND ResourceKey = 'tra_grd_16449')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114093, 'tra_grd_16449', 1, 2, 0, 155001, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114093 AND ResourceKey = 'tra_grd_16450')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114093, 'tra_grd_16450', 1, 3, 0, 155001, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114093 AND ResourceKey = 'usr_grd_11073')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114093, 'usr_grd_11073', 1, 4, 0, 155001, NULL ,NULL)
END
GO

/*
	19 September 2016
	Error message when fetching the documents uploaded for a transaction
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16451)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(16451, 'tra_msg_16451','Error occurred while fetching list of uploaded document corresponding to a transaction','en-US',103008,104001,122085,'Error occurred while fetching list of uploaded document corresponding to a transaction',1,GETDATE())
END
GO

/*
	19 September 2016
	ActivityURLMappinf entries for transaction document download/view
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 165 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(165, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 165 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(165, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 167 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(167, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 167 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(167, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 169 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(169, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 169 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(169, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 155 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(155, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 155 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(155, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 157 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(157, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 157 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(157, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 159 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'DisplayPolicy')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(159, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 159 AND ControllerName = 'InsiderInitialDisclosure' AND ActionName = 'Generate')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(159, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	Script from Gaurishankar on 19 September 2016
	Add resource for Transaction confirmation popup and TransactionMaster table Alter.
	Added codegroup 189 and 190 for Confirmation for transaction enter upload for.
*/


IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'ConfirmCompanyHoldingsFor' AND object_id = OBJECT_ID(N'tra_TransactionMaster'))
BEGIN
	ALTER TABLE tra_TransactionMaster ADD ConfirmCompanyHoldingsFor INT NULL
END
GO

IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'ConfirmNonCompanyHoldingsFor' AND object_id = OBJECT_ID(N'tra_TransactionMaster'))
BEGIN
	ALTER TABLE tra_TransactionMaster ADD ConfirmNonCompanyHoldingsFor INT NULL
END
GO

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 189)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(189, 'Confirmation for Company holdings', 'Confirmation for Company holdings', 1, 1)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 189001)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, [Description], DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(189001, 'Only Self (Dependents do not hold any KMBL securities)', 189, 'Only Self (Dependents do not hold any KMBL securities)',null, 1, 1, GETDATE(), 1)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 189002)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(189002, 'Only Dependents (I do not hold any KMBL securities)', 189, 'Only Dependents (I do not hold any KMBL securities)',null, 1, 1, GETDATE(), 2)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 189003)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(189003, 'Self and Dependents (Both me and my dependents hold KMBL securities)', 189, 'Self and Dependents (Both me and my dependents hold KMBL securities)',null, 1, 1, GETDATE(), 3)

END
GO

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 190)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable)
	VALUES
	(190, 'Confirmation for non Company holdings', 'Confirmation for non Company holdings', 1, 1)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 190001)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, [Description], DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(190001, 'Only Self (Dependents do not hold any non KMBL securities)', 190, 'Only Self (Dependents do not hold any non KMBL securities)',null, 1, 1, GETDATE(), 1)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 190002)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, [Description], DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(190002, 'Only Dependents (I do not hold any non KMBL securities)', 190, 'Only Dependents (I do not hold any non KMBL securities)',null, 1, 1, GETDATE(), 2)
END
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 190003)
BEGIN
INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, [Description], DisplayCode, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(190003, 'Self and Dependents (Both me and my dependents hold non KMBL securities)', 190, 'Self and Dependents (Both me and my dependents hold non KMBL securities)',null, 1, 1, GETDATE(), 3)

END

GO


/*
	Script from Parag on 16 September 2016
	Add acid-url mapping for create pre-clearance of non-implemention company request page 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'Create')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'Create', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	Script from Parag on 16 September 2016
	Add resources for pre-clearance of non-implemention company request page
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17459)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17459, 'dis_ttl_17459', 'Preclearance Request of Non-implementation Company', 'Preclearance Request of Non-implementation Company', 'en-US', 103009, 104005, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17460)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17460, 'dis_lbl_17460', 'Self', 'Self', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17461)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17461, 'dis_lbl_17461', 'Relative', 'Relative', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17462)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17462, 'dis_lbl_17462', 'If Relatives', 'If Relatives', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17463)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17463, 'dis_lbl_17463', 'Date of Pre-Clearance', 'Date of Pre-Clearance', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17464)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17464, 'dis_lbl_17464', 'Transaction', 'Transaction', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17465)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17465, 'dis_lbl_17465', 'Type of secuity to be traded', 'Type of secuity to be traded', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17466)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17466, 'dis_lbl_17466', 'For Company', 'For Company', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17467)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17467, 'dis_lbl_17467', 'Securities proposed to be traded', 'Securities proposed to be traded', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17468)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17468, 'dis_lbl_17468', 'Value proposed to be traded', 'Value proposed to be traded', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17469)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17469, 'dis_lbl_17469', 'Mode of acquisition', 'Mode of acquisition', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17470)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17470, 'dis_lbl_17470', 'Demat Account Number', 'Demat Account Number', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17471)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17471, 'dis_btn_17471', 'New Demat Account - ADD', 'New Demat Account - ADD', 'en-US', 103009, 104004, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17472)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17472, 'dis_btn_17472', 'Confirm', 'Confirm', 'en-US', 103009, 104004, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17473)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17473, 'dis_btn_17473', 'Cancel', 'Cancel', 'en-US', 103009, 104004, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17474)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17474, 'dis_lbl_17474', 'Status :', 'Status :', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17475)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17475, 'dis_lbl_17475', 'Date :', 'Date :', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END


/*
	20-September-2016 : New CodeId for MapToType for preclearance of NonImplementing company
*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 132015)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(132015, NULL, 'Preclearance - NonImplementing Company', NULL, 132, 'Map To Type - Preclearance - NonImplementing Company', 1, 1, GETDATE(), 15)
END
GO
/*
	Author:- Tushar 20 Sep 2016
	Description:- Resources add for previous Period end is submitted or not.
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17476)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17476, 'dis_msg_17476','Error occurred while check last period end is submitted.','en-US',103009,104001,122051,'Error occurred while check last period end is submitted.',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17477)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17477, 'dis_msg_17477','You can''t create preclearance request, Previous period end is not submitted, please contact you Complaince Officer.','en-US',103009,104001,122051,'You can''t create preclearance request, Previous period end is not submitted, please contact you Complaince Officer.',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17478)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17478, 'dis_msg_17478','You can''t create preclearance request, Please submit your previous period end disclosures.','en-US',103009,104001,122051,'You can''t create preclearance request, Please submit your previous period end disclosures.',1,GETDATE())
END
GO


/*
	Script added By: Raghvendra		20-Sep-2016
	Alter table script to increase the Column size for com_Code.DisplayCode from NVARCHAR(50) to NVARCHAR(1000)
*/

ALTER TABLE com_Code ALTER COLUMN DisplayCode NVARCHAR(1000)


/*
	Script from Parag on 20 September 2016
	Add resources for restricted list company
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50082)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50082, 'rl_msg_50082', 'Error occured while fetching company details', 'Error occured while fetching company details', 'en-US', 103301, 104001, 122076, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50083)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50083, 'rl_msg_50083', 'Company details not found', 'Company details not found', 'en-US', 103301, 104001, 122076, 1, GETDATE())
END


/*
	Script from Parag on 21 September 2016
	Add acid-url mapping for create pre-clearance of non-implemention company request page 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'DematList')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'DematList', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	Script from Parag on 21 September 2016
	Add resources for pre-clearance of non-implemention company request page
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17479)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17479, 'dis_lbl_17479', 'I hereby declare that the above inforamtion is true and correct', 'I hereby declare that the above inforamtion is true and correct', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17480)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17480, 'dis_lbl_17480', 'Are you sure want to submit the Pre-Clearance request?', 'Are you sure want to submit the Pre-Clearance request?', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17481)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17481, 'dis_lbl_17481', 'Please accept the terms and conditions to submit your Pre Clearance request.', 'Please accept the terms and conditions to submit your Pre Clearance request.', 'en-US', 103009, 104002, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17482)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17482, 'dis_msg_17482', 'Enter Securities proposed to be traded max 11 digit number', 'Enter Securities proposed to be traded max 11 digit number', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17483)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17483, 'dis_msg_17483', 'Enter Value proposed to be traded max 11 digit number', 'Enter Value proposed to be traded max 11 digit number', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

/*
	Script from - Gaurishankar on 21 September 2016
	Add resource for Transaction confirmation popup.
	Update DisplayCode for codegroup 189 and 190 for Confirmation for transaction enter upload for.
*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16452)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16452, 'tra_msg_16452', 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 'en-US', 103008, 104001, 122071, 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16453)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16453, 'tra_msg_16453', 'I hereby confirm that I have $1 the $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16454)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16454, 'tra_msg_16454', 'I hereby confirm that I have $1 the other than $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the other than $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16455)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16455, 'tra_msg_16455', 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 'en-US', 103008, 104001, 122071, 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16456)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16456, 'tra_msg_16456', 'I confirm that myself and my dependent don''t have $2 holdings.', 'en-US', 103008, 104001, 122071, 'I confirm that myself and my dependent don''t have $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16457)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16457, 'tra_msg_16457', 'Please Enter and/or upload $2 and other than $2 holdings.', 'en-US', 103008, 104001, 122071, 'Please Enter and/or upload $2 and other than $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16458)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16458, 'tra_btn_16458', 'Ok', 'en-US', 103008, 104004, 122071, 'Ok', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16459)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16459, 'tra_btn_16459', 'Yes I Confirm', 'en-US', 103008, 104004, 122071, 'Yes I Confirm', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16460)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16460, 'tra_btn_16460', 'No', 'en-US', 103008, 104004, 122071, 'No', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16461)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16461, 'tra_btn_16461', 'Upload details', 'en-US', 103008, 104004, 122071, 'Upload details', 1, GETDATE())
END
/* ----------------- Continuous Disclosure------------------------------------------------------------------------*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16462)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16462, 'tra_msg_16462', 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 'en-US', 103008, 104001, 122071, 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16463)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16463, 'tra_msg_16463', 'I hereby confirm that I have $1 the $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16464)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16464, 'tra_msg_16464', 'I hereby confirm that I have $1 the other than $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the other than $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16465)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16465, 'tra_msg_16465', 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 'en-US', 103008, 104001, 122071, 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16466)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16466, 'tra_msg_16466', 'I confirm that myself and my dependent don''t have $2 holdings.', 'en-US', 103008, 104001, 122071, 'I confirm that myself and my dependent don''t have $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16467)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16467, 'tra_msg_16467', 'Please Enter and/or upload $2 and other than $2 holdings.', 'en-US', 103008, 104001, 122071, 'Please Enter and/or upload $2 and other than $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16468)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16468, 'tra_btn_16468', 'Ok', 'en-US', 103008, 104004, 122071, 'Ok', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16469)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16469, 'tra_btn_16469', 'Yes I Confirm', 'en-US', 103008, 104004, 122071, 'Yes I Confirm', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16470)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16470, 'tra_btn_16470', 'No', 'en-US', 103008, 104004, 122071, 'No', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16471)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16471, 'tra_btn_16471', 'Upload details', 'en-US', 103008, 104004, 122071, 'Upload details', 1, GETDATE())
END

/* ----------------- Period End Disclosure ------------------------------------------------------------------------*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16472)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16472, 'tra_msg_16472', 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 'en-US', 103008, 104001, 122071, 'You have successfully $1 the $2 holdings.
Please confirm the below option button to submit details. You will not be able to update details after submission.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16473)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16473, 'tra_msg_16473', 'I hereby confirm that I have $1 the $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16474)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16474, 'tra_msg_16474', 'I hereby confirm that I have $1 the other than $2 holdings for :', 'en-US', 103008, 104001, 122071, 'I hereby confirm that I have $1 the other than $2 holdings for :', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16475)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
(16475, 'tra_msg_16475', 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 'en-US', 103008, 104001, 122071, 'You have not $1 the $2 holdings. 
Are you sure that you and your dependents donot have $2 holdings? if Yes then check on below checkbox and Confirm so that you can proceed to submit details.
If you want to $3 $2 holdings then click on below "$4" button.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16476)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16476, 'tra_msg_16476', 'I confirm that myself and my dependent don''t have $2 holdings.', 'en-US', 103008, 104001, 122071, 'I confirm that myself and my dependent don''t have $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16477)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16477, 'tra_msg_16477', 'Please Enter and/or upload $2 and other than $2 holdings.', 'en-US', 103008, 104001, 122071, 'Please Enter and/or upload $2 and other than $2 holdings.', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16478)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16478, 'tra_btn_16478', 'Ok', 'en-US', 103008, 104004, 122071, 'Ok', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16479)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16479, 'tra_btn_16479', 'Yes I Confirm', 'en-US', 103008, 104004, 122071, 'Yes I Confirm', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16480)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16480, 'tra_btn_16480', 'No', 'en-US', 103008, 104004, 122071, 'No', 1, GETDATE())
END
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16481)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16481, 'tra_btn_16481', 'Upload details', 'en-US', 103008, 104004, 122071, 'Upload details', 1, GETDATE())
END


UPDATE mst_Resource
SET ResourceValue = 'Are you sure that you and your dependents donot have any $2 holdings.'
WHERE ResourceKey  = 'tra_msg_16106'

  
UPDATE [com_Code]
SET [DisplayCode] = [CodeName]
where CodeGroupId in (189,190)


--Insert new code for grid type displaying preclearance list of Non-Implementing Company, for Insider users
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114094)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114094,NULL,'Preclearance List (Non Implementing Company) - For Insider',NULL,114,'Preclearance List (Non Implementing Company) - For Insider',1,1,GETDATE(),94)
END
GO

--Insert new code for grid type displaying preclearance list of Non-Implementing Company, for CO users
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114095)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114095,NULL,'Preclearance List (Non Implementing Company) - For CO',NULL,114,'Preclearance List (Non Implementing Company) - For CO',1,1,GETDATE(),95)
END
GO

/*

22-September-2016 : Resources related to Preclearance for Non Implementing company, preclearance list page

*/
--Mark screen for Insider by renaming the Codename
UPDATE com_Code
SET CodeName = 'Pre-clearance Request List - Non-Implmentation company (For Insider)',
[Description] = 'Screen - PreClearance Request List - Non-Implmentation company (For Insider)'
WHERE CodeID = 122087

--Add new screen for Pre-clearance Request List - Non-Implmentation company (For CO)
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122088)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122088, 103009, 'Pre-clearance Request List - Non-Implmentation company (For CO)', NULL, 122, 'Screen - PreClearance Request List - Non-Implmentation company (For CO)', 1, 1, GETDATE(), 100)
END
GO

--Add resource for error message when fetching list of preclearance request of NonImplementing Company
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17484)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17484, 'dis_msg_17484', 'Error occurred while fetching list of PreClearance Request details of NonImplementing company.', 'Error occurred while fetching list of PreClearance Request details of NonImplementing company.', 'en-US', 103009, 104001, 122087, 1, GETDATE())
END

--Add resources for grid column headers for screen : Pre-clearance Request List - Non-Implmentation company (For Insider)
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17485)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17485, 'dis_grd_17485','Pre Clearance ID','en-US',103009,104003,122087,'Pre Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17486)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17486, 'dis_grd_17486','Request For','en-US',103009,104003,122087,'Request For',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17487)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17487, 'dis_grd_17487','Request Date','en-US',103009,104003,122087,'Request Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17488)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17488, 'dis_grd_17488','PreClearance Status','en-US',103009,104003,122087,'PreClearance Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17489)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17489, 'dis_grd_17489','Transaction Type','en-US',103009,104003,122087,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17490)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17490, 'dis_grd_17490','Securities','en-US',103009,104003,122087,'Securities',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17491)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17491, 'dis_grd_17491','Preclearance Qty','en-US',103009,104003,122087,'Preclearance Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17492)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17492, 'dis_grd_17492','Trade Qty','en-US',103009,104003,122087,'Trade Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17493)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17493, 'dis_grd_17493','Trading Details Submission','en-US',103009,104003,122087,'Trading Details Submission',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17494)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17494, 'dis_grd_17494','Disclosure Details Submission: Softcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Softcopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17495)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17495, 'dis_grd_17495','Disclosure Details Submission: Hardcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Hardcopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17496)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17496, 'dis_grd_17496','Submission to Stock Exchange','en-US',103009,104003,122087,'Submission to Stock Exchange',1,GETDATE())
END
GO

--Map the grid header column resources to grid type for Pre-clearance Request List - Non-Implmentation company (For Insider)
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17485')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17485', 1, 1, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17486')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17486', 1, 2, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17487')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17487', 1, 3, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17488')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17488', 1, 4, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17489')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17489', 1, 5, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17490')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17490', 1, 6, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17491')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17491', 1, 7, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17492')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17492', 0, 8, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17493')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17493', 0, 9, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17494')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17494', 0, 10, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17495')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17495', 0, 11, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114094 AND ResourceKey = 'dis_grd_17496')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114094, 'dis_grd_17496', 0, 12, 0, 155001, NULL ,NULL)
END
GO

/*
	Author : Tushar 23-Sep-2016
	Description: Add Activity URL for Restricted List Preclerance for CO/Insider
				 Add Resource for CO/Insider List for Restricted List Preclerance for CO/Insider
*/

--Insider Activity URL for Non Implementing Company Preclerance List
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END
GO

--CO Activity URL for Non Implementing Company Preclerance List
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 217 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'COList')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(217, 'PreclearanceRequestNonImplCompany', 'COList', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 217 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(217, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 217 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(217, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END
GO

-- Insider Resources Page Resource for Non Implementing Company Preclerance List
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17497)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17497, 'dis_ttl_17497','Non Implementing Preclearances','en-US',103009,104006,122087,'Non Implementing Preclearances',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17498)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17498, 'dis_lbl_17498','Pre-Clearance ID','en-US',103009,104002,122087,'Pre-Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17499)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17499, 'dis_lbl_17499','Request Status','en-US',103009,104002,122087,'Request Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17500)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17500, 'dis_lbl_17500','Transaction Type','en-US',103009,104002,122087,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17501)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17501, 'dis_btn_17501','Back','en-US',103009,104004,122087,'Back',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17502)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17502, 'dis_btn_17502','View Non Implementing Preclearance List','en-US',103009,104004,122046,'View Non Implementing Preclearance List',1,GETDATE())
END
GO

--CO Page Resource for Non Implementing Company Preclerance List
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17503)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17503, 'dis_ttl_17503','Non Implementing Preclearances','en-US',103009,104006,122088,'Non Implementing Preclearances',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17504)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17504, 'dis_lbl_17504','Pre-Clearance ID','en-US',103009,104002,122088,'Pre-Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17505)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17505, 'dis_lbl_17505','Request Status','en-US',103009,104002,122088,'Request Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17506)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17506, 'dis_lbl_17506','Transaction Type','en-US',103009,104002,122088,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17507)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17507, 'dis_lbl_17507','Employee ID','en-US',103009,104002,122088,'Employee ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17508)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17508, 'dis_lbl_17508','Name','en-US',103009,104002,122088,'Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17509)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17509, 'dis_lbl_17509','Designation','en-US',103009,104002,122088,'Designation',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17510)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17510, 'dis_btn_17510','Back','en-US',103009,104004,122088,'Back',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17511)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17511, 'dis_btn_17511','View Non Implementing Preclearance List','en-US',103009,104004,122057,'View Non Implementing Preclearance List',1,GETDATE())
END
GO

/*
23-Sept-2016 : Grid column header resources for : Pre-clearance Request List - Non-Implmentation company (For CO)
*/
--Add resources for grid column headers for screen : Pre-clearance Request List - Non-Implmentation company (For CO)
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17514)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17514, 'dis_grd_17514','Name','en-US',103009,104003,122088,'Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17515)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17515, 'dis_grd_17515','Employee ID','en-US',103009,104003,122088,'Employee ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17516)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17516, 'dis_grd_17516','Pre-Clearance ID','en-US',103009,104003,122088,'Pre-Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17517)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17517, 'dis_grd_17517','Pre-Clearance Request Date','en-US',103009,104003,122088,'Pre-Clearance Request Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17518)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17518, 'dis_grd_17518','Pre-Clearance Status','en-US',103009,104003,122088,'Pre-Clearance Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17519)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17519, 'dis_grd_17519','Transaction Type','en-US',103009,104003,122088,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17520)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17520, 'dis_grd_17520','Securities','en-US',103009,104003,122088,'Securities',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17521)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17521, 'dis_grd_17521','Preclearance Qty','en-US',103009,104003,122088,'Preclearance Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17522)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17522, 'dis_grd_17522','Trade Qty','en-US',103009,104003,122088,'Trade Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17523)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17523, 'dis_grd_17523','Total Traded Value','en-US',103009,104003,122088,'Total Traded Value',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17524)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17524, 'dis_grd_17524','Trading Details Submission','en-US',103009,104003,122088,'Trading Details Submission',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17525)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17525, 'dis_grd_17525','Disclosure Details: SoftCopy','en-US',103009,104003,122088,'Disclosure Details: SoftCopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17526)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17526, 'dis_grd_17526','Disclosure Details: HardCopy','en-US',103009,104003,122088,'Disclosure Details: HardCopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17527)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(17527, 'dis_grd_17527','Submission to Stock Exchange','en-US',103009,104003,122088,'Submission to Stock Exchange',1,GETDATE())
END
GO

--Map the grid header column resources to grid type for Pre-clearance Request List - Non-Implmentation company (For CO)
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17514')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17514', 1, 1, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17515')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17515', 1, 2, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17516')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17516', 1, 3, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17517')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17517', 1, 4, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17518')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17518', 1, 5, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17519')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17519', 1, 6, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17520')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17520', 1, 7, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17521')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17521', 1, 8, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17522')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17522', 0, 9, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17523')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17523', 0, 10, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17524')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17524', 0, 11, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17525')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17525', 0, 12, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17526')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17526', 0, 13, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114095 AND ResourceKey = 'dis_grd_17527')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114095, 'dis_grd_17527', 0, 14, 0, 155001, NULL ,NULL)
END
GO


/*
	Script from - Gaurishankar on 23 September 2016
	Add resource for Transaction Document not submited.
*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 16482)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(16482, 'tra_msg_16482', 'Please save the uploaded documents.', 'en-US', 103008, 104001, 122036, 'Please save the uploaded documents.', 1, GETDATE())
END

/*
	Script from - Tushar on 23 September 2016
	Add Activity URL Mapping for DOWNLOAD FOR E.
*/

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 157 AND ControllerName = 'PreclearanceRequest' AND ActionName = 'DownloadFormE')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(157, 'PreclearanceRequest', 'DownloadFormE', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 167 AND ControllerName = 'PreclearanceRequest' AND ActionName = 'DownloadFormE')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(167, 'PreclearanceRequest', 'DownloadFormE', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'DownloadFormE')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'DownloadFormE', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 217 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'DownloadFormE')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(217, 'PreclearanceRequestNonImplCompany', 'DownloadFormE', NULL, 1, GETDATE(), 1, GETDATE())
END
GO

/*
	Script from Parag on 23 September 2016
	Add resources for pre-clearance of non-implemention company request page
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17512)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17512, 'dis_msg_17512', 'Error occured while saving preclearance for non implementing company', 'Error occured while saving preclearance for non implementing company', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17513)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17513, 'dis_msg_17513', 'Preclearance Request Saved Successfully', 'Preclearance Request Saved Successfully', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17528)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17528, 'dis_msg_17528', 'Error occured while fetching preclearance for non implementing company', 'Error occured while fetching preclearance for non implementing company', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

/*
	Script from Parag on 23 September 2016
	Add acid-url mapping for create pre-clearance of non-implemention company request page 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'SavePreclearanceRequest')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'SavePreclearanceRequest', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 216 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'View')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(216, 'PreclearanceRequestNonImplCompany', 'View', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 217 AND ControllerName = 'PreclearanceRequestNonImplCompany' AND ActionName = 'View')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(217, 'PreclearanceRequestNonImplCompany', 'View', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	26-September-2016 : Codes and Resources related to Restricted List Report for CO.
*/
--Insert new code for grid type displaying Restricted List Report data
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114096)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114096,NULL,'Restricted List Report',NULL,114,'Restricted List Report',1,1,GETDATE(),96)
END
GO

--Add new screen for Restricted List Report
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122089)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122089, 103301, 'Restricted List Report', NULL, 122, 'Screen - Restricted List Report', 1, 1, GETDATE(), 101)
END
GO

--Add new resource for Restricted List Report error message
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50300)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50300, 'rl_msg_50300', 'Error occurred while fetching restricted list report data.', 'Error occurred while fetching restricted list report data.', 'en-US', 103301, 104001, 122089, 1, GETDATE())
END

--Add resources for grid-headers of Restricted List Report
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50301)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50301, 'rl_grd_50301','Employee Id','en-US',103301,104003,122089,'Employee Id',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50302)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50302, 'rl_grd_50302','Employee Name','en-US',103301,104003,122089,'Employee Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50303)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50303, 'rl_grd_50303','Department','en-US',103301,104003,122089,'Department',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50304)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50304, 'rl_grd_50304','Designation','en-US',103301,104003,122089,'Designation',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50305)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50305, 'rl_grd_50305','Grade','en-US',103301,104003,122089,'Grade',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50306)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50306, 'rl_grd_50306','Company Name','en-US',103301,104003,122089,'Company Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50307)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50307, 'rl_grd_50307','ISIN Code','en-US',103301,104003,122089,'ISIN Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50308)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50308, 'rl_grd_50308','BSE Code','en-US',103301,104003,122089,'BSE Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50309)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50309, 'rl_grd_50309','NSE Code','en-US',103301,104003,122089,'NSE Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50310)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50310, 'rl_grd_50310','Search Date','en-US',103301,104003,122089,'Search Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50311)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50311, 'rl_grd_50311','Search Time','en-US',103301,104003,122089,'Search Time',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50312)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50312, 'rl_grd_50312','Trading Allowed','en-US',103301,104003,122089,'Trading Allowed',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50313)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50313, 'rl_grd_50313','Pre Clearance ID','en-US',103301,104003,122089,'Pre Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50314)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50314, 'rl_grd_50314','Request Date','en-US',103301,104003,122089,'Request Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50315)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50315, 'rl_grd_50315','Transaction Type','en-US',103301,104003,122089,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50316)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50316, 'rl_grd_50316','Security Type','en-US',103301,104003,122089,'Security Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50317)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50317, 'rl_grd_50317','Number of Securities','en-US',103301,104003,122089,'Number of Securities',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50318)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50318, 'rl_grd_50318','Value','en-US',103301,104003,122089,'Value',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50319)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50319, 'rl_grd_50319','Pre-Clearance Status','en-US',103301,104003,122089,'Pre-Clearance Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50320)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50320, 'rl_grd_50320','Status Date','en-US',103301,104003,122089,'Status Date',1,GETDATE())
END
GO

--Add the mapping for grid-type and grid-headers for grid of Restricted List Report
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50301')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50301', 1, 1, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50302')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50302', 1, 2, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50303')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50303', 1, 3, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50304')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50304', 1, 4, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50305')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50305', 1, 5, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50306')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50306', 1, 6, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50307')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50307', 1, 7, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50308')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50308', 1, 8, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50309')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50309', 1, 9, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50310')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50310', 1, 10, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50311')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50311', 1, 11, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50312')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50312', 1, 12, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50313')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50313', 1, 13, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50314')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50314', 1, 14, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50315')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50315', 1, 15, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50316')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50316', 1, 16, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50317')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50317', 1, 17, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50318')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50318', 1, 18, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50319')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50319', 1, 19, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50320')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50320', 1, 20, 0, 155001, NULL ,NULL)
END
GO

/*
	Script from Parag on 26 September 2016
	Update menu url link to show restricted search list report for CO 
*/
IF NOT EXISTS(select MenuID from mst_MenuMaster where MenuID = 49 AND MenuURL = '/Reports/RestrictedListSearchReport?acid=201')
BEGIN
	-- old url was MenuURL = '/SSRSReport/RestrictedListSearchReport?acid=201'
	UPDATE mst_MenuMaster SET MenuURL = '/Reports/RestrictedListSearchReport?acid=201'  WHERE MenuID = 49
END

/*
	Script from Parag on 27 September 2016
	Add acid-url mapping for report of restricted search list report for CO 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 201 AND ControllerName = 'Reports' AND ActionName = 'RestrictedListSearchReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(201, 'Reports', 'RestrictedListSearchReport', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 201 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(201, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 201 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(201, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 201 AND ControllerName = 'Reports' AND ActionName = 'ExportReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(201, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	Script from Parag on 27 September 2016
	Add resources for report of restricted search list report for CO 
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50341)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50341, 'rl_ttl_50341', 'Restricted List', 'Restricted List', 'en-US', 103301, 104006, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50342)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50342, 'rl_lbl_50342', 'Employee ID', 'Employee ID', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50343)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50343, 'rl_lbl_50343', 'Employee Name', 'Employee Name', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50344)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50344, 'rl_lbl_50344', 'Department', 'Department', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50345)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50345, 'rl_lbl_50345', 'Designation', 'Designation', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50346)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50346, 'rl_lbl_50346', 'Grade', 'Grade', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50347)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50347, 'rl_lbl_50347', 'Company Name', 'Company Name', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50348)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50348, 'rl_lbl_50348', 'Search From Date', 'Search From Date', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50349)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50349, 'rl_lbl_50349', 'Search To Date', 'Search To Date', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50350)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50350, 'rl_lbl_50350', 'Trading Allowed', 'Trading Allowed', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50351)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50351, 'rl_lbl_50351', 'Preclearance ID', 'Preclearance ID', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50352)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50352, 'rl_lbl_50352', 'PCL Request From Date', 'PCL Request From Date', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50353)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50353, 'rl_lbl_50353', 'PCL Request To Date', 'PCL Request To Date', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50354)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50354, 'rl_lbl_50354', 'Transaction Type', 'Transaction Type', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50355)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50355, 'rl_lbl_50355', 'Security Type', 'Security Type', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50356)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50356, 'rl_lbl_50356', 'Preclearance Status', 'Preclearance Status', 'en-US', 103301, 104002, 122089, 1, GETDATE())
END

/*
	27-September-2016 : Codes and Resources related to Restricted List Report for Insider.
*/
--Insert new code for grid type displaying Restricted List Report data
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114097)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114097,NULL,'Restricted List Report (For Insider)',NULL,114,'Restricted List Report (For Insider)',1,1,GETDATE(),97)
END
GO

--Add new screen for Restricted List Report
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122090)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122090, 103301, 'Restricted List Report (For Insider)', NULL, 122, 'Screen - Restricted List Report (For Insider)', 1, 1, GETDATE(), 102)
END
GO

--Add resources for grid-headers of Restricted List Report
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50321)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50321, 'rl_grd_50321','Employee Id','en-US',103301,104003,122090,'Employee Id',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50322)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50322, 'rl_grd_50322','Employee Name','en-US',103301,104003,122090,'Employee Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50323)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50323, 'rl_grd_50323','Department','en-US',103301,104003,122090,'Department',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50324)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50324, 'rl_grd_50324','Designation','en-US',103301,104003,122090,'Designation',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50325)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50325, 'rl_grd_50325','Grade','en-US',103301,104003,122090,'Grade',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50326)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50326, 'rl_grd_50326','Company Name','en-US',103301,104003,122090,'Company Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50327)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50327, 'rl_grd_50327','ISIN Code','en-US',103301,104003,122090,'ISIN Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50328)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50328, 'rl_grd_50328','BSE Code','en-US',103301,104003,122090,'BSE Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50329)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50329, 'rl_grd_50329','NSE Code','en-US',103301,104003,122090,'NSE Code',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50330)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50330, 'rl_grd_50330','Search Date','en-US',103301,104003,122090,'Search Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50331)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50331, 'rl_grd_50331','Search Time','en-US',103301,104003,122090,'Search Time',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50332)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50332, 'rl_grd_50332','Trading Allowed','en-US',103301,104003,122090,'Trading Allowed',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50333)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50333, 'rl_grd_50333','Pre Clearance ID','en-US',103301,104003,122090,'Pre Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50334)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50334, 'rl_grd_50334','Request Date','en-US',103301,104003,122090,'Request Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50335)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50335, 'rl_grd_50335','Transaction Type','en-US',103301,104003,122090,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50336)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50336, 'rl_grd_50336','Security Type','en-US',103301,104003,122090,'Security Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50337)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50337, 'rl_grd_50337','Number of Securities','en-US',103301,104003,122090,'Number of Securities',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50338)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50338, 'rl_grd_50338','Value','en-US',103301,104003,122090,'Value',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50339)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50339, 'rl_grd_50339','Pre-Clearance Status','en-US',103301,104003,122090,'Pre-Clearance Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50340)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50340, 'rl_grd_50340','Status Date','en-US',103301,104003,122090,'Status Date',1,GETDATE())
END
GO

--Add the mapping for grid-type and grid-headers for grid of Restricted List Report for Insider
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50301' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50321')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50301', 0, 1, 0, 155001, 114097 ,'rl_grd_50321')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50302' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50322')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50302', 0, 2, 0, 155001, 114097 ,'rl_grd_50322')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50303' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50323')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50303', 0, 3, 0, 155001, 114097 ,'rl_grd_50323')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50304' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50324')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50304', 0, 4, 0, 155001, 114097 ,'rl_grd_50324')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50305' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50325')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50305', 0, 5, 0, 155001, 114097 ,'rl_grd_50325')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50306' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50326')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50306', 1, 6, 0, 155001, 114097 ,'rl_grd_50326')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50307' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50327')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50307', 1, 7, 0, 155001, 114097 ,'rl_grd_50327')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50308' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50328')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50308', 1, 8, 0, 155001, 114097 ,'rl_grd_50328')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50309' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50329')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50309', 1, 9, 0, 155001, 114097 ,'rl_grd_50329')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50310' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50330')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50310', 1, 10, 0, 155001, 114097 ,'rl_grd_50330')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50311' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50331')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50311', 1, 11, 0, 155001, 114097 ,'rl_grd_50331')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50312' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50332')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50312', 1, 12, 0, 155001, 114097 ,'rl_grd_50332')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50313' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50333')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50313', 1, 13, 0, 155001, 114097 ,'rl_grd_50333')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50314' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50334')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50314', 1, 14, 0, 155001, 114097 ,'rl_grd_50334')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50315' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50335')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50315', 1, 15, 0, 155001, 114097 ,'rl_grd_50335')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50316' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50336')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50316', 1, 16, 0, 155001, 114097 ,'rl_grd_50336')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50317' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50337')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50317', 1, 17, 0, 155001, 114097 ,'rl_grd_50337')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50318' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50338')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50318', 1, 18, 0, 155001, 114097 ,'rl_grd_50338')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50319' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50339')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50319', 1, 19, 0, 155001, 114097 ,'rl_grd_50339')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114096 AND ResourceKey = 'rl_grd_50320' AND OverrideGridTypeCodeId = 114097 AND OverrideResourceKey = 'rl_grd_50340')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114096, 'rl_grd_50320', 1, 20, 0, 155001, 114097 ,'rl_grd_50340')
END
GO

/*
Script from - Gaurishankar on 27 September 2016
Added ComCode for Form F  132016 & 133004
*/

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 132016)
BEGIN

INSERT INTO [dbo].[com_Code]
           ([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
     VALUES
           (132016,'Form F',132,'Map to Type - Form F',1,1,16,null,null,1,GETDATE())        
END  
GO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 133004)
BEGIN
INSERT INTO [dbo].[com_Code]
           ([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
     VALUES
           (133004,'Form F for Restricted List',133,'Document Purpose - Form F for Restricted List',1,1,4,null,null,1,GETDATE())         
END 
GO
/*
	Script from Parag on 27 September 2016
	Update menu url link to show restricted search list report for insider
*/
IF NOT EXISTS(select MenuID from mst_MenuMaster where MenuID = 51 AND MenuURL = '/Reports/RestrictedListSearchReport?acid=211')
BEGIN
	-- old url was MenuURL = '/SSRSReport/RestrictedListSearchReport?acid=211'
	UPDATE mst_MenuMaster SET MenuURL = '/Reports/RestrictedListSearchReport?acid=211'  WHERE MenuID = 51
END

/*
	Script from Parag on 27 September 2016
	Add acid-url mapping for report of restricted search list report for insider 
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 211 AND ControllerName = 'Reports' AND ActionName = 'RestrictedListSearchReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(211, 'Reports', 'RestrictedListSearchReport', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 211 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(211, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 211 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(211, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 211 AND ControllerName = 'Reports' AND ActionName = 'ExportReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(211, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE())
END

/*
	Script from Parag on 27 September 2016
	Add resources for report of restricted search list report for insider 
*/
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50357)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50357, 'rl_ttl_50357', 'Restricted List', 'Restricted List', 'en-US', 103301, 104006, 122090, 1, GETDATE())
END


IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50358)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50358, 'rl_lbl_50358', 'Company Name', 'Company Name', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50359)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50359, 'rl_lbl_50359', 'Search From Date', 'Search From Date', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50360)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50360, 'rl_lbl_50360', 'Search To Date', 'Search To Date', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50361)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50361, 'rl_lbl_50361', 'Trading Allowed', 'Trading Allowed', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50362)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50362, 'rl_lbl_50362', 'Preclearance ID', 'Preclearance ID', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50363)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50363, 'rl_lbl_50363', 'PCL Request From Date', 'PCL Request From Date', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50364)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50364, 'rl_lbl_50364', 'PCL Request To Date', 'PCL Request To Date', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50365)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50365, 'rl_lbl_50365', 'Transaction Type', 'Transaction Type', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50366)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50366, 'rl_lbl_50366', 'Security Type', 'Security Type', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50367)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50367, 'rl_lbl_50367', 'Preclearance Status', 'Preclearance Status', 'en-US', 103301, 104002, 122090, 1, GETDATE())
END

/*
	Gaurishankar 2016-Oct-05
	Modified the resource value.

*/

  UPDATE [mst_Resource]
  SET [ResourceValue] = 'Please upload and save the uploaded document.' 
where ResourceKey = 'tra_msg_16482'