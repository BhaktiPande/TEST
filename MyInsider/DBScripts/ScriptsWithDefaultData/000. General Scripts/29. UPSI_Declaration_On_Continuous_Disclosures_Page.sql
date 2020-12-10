/*
	Created By  :	ANIKET SHINGATE
	Created On 	:	01-JUNE-2016
	Description :	THIS SCRIPT IS USED TO SAVE VALUES IN mst_Resource TABLES FOR VALIDATION MASSAGE.
*/

/* INSERT INTO mst_Resource TABLE ---- START */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50069)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50069, 'rul_lbl_50069', 'Seek declaration from employee regarding possession of UPSI', 'en-US', 103006, 104002, 122040, 'Seek declaration from employee regarding possession of UPSI', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50070)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50070, 'rul_lbl_50070', 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 'en-US', 103006, 104002, 122040, 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50071)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50071, 'rul_lbl_50071', 'Declaration to be Mandatory', 'en-US', 103006, 104002, 122040, 'Declaration to be Mandatory', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50072)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50072, 'rul_lbl_50072', 'Display the declaration post submission of Continuouse Disclosure', 'en-US', 103006, 104002, 122040, 'Display the declaration post submission of Continuouse Disclosure', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50074)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50074, 'tra_msg_50074', 'Please select the confirmation checkbox to submit your trade details.', 'en-US', 103008, 104001, 122036, 'Please select the confirmation checkbox to submit your trade details.', 1, GETDATE())
END

/* ADD NEW COLUMN IN rul_TradingPolicy TABLE ---- START */
IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'SeekDeclarationFromEmpRegPossessionOfUPSIFlag' AND OBJECT_ID = OBJECT_ID('[dbo].[rul_TradingPolicy]'))
BEGIN
	ALTER TABLE rul_TradingPolicy ADD SeekDeclarationFromEmpRegPossessionOfUPSIFlag BIT NULL
END

IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'DeclarationFromInsiderAtTheTimeOfContinuousDisclosures' AND OBJECT_ID = OBJECT_ID('[dbo].[rul_TradingPolicy]'))
BEGIN
	ALTER TABLE rul_TradingPolicy ADD DeclarationFromInsiderAtTheTimeOfContinuousDisclosures VARCHAR(MAX) NULL
END

IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'DeclarationToBeMandatoryFlag' AND OBJECT_ID = OBJECT_ID('[dbo].[rul_TradingPolicy]'))
BEGIN
	ALTER TABLE rul_TradingPolicy ADD DeclarationToBeMandatoryFlag BIT NULL
END

IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag' AND OBJECT_ID = OBJECT_ID('[dbo].[rul_TradingPolicy]'))
BEGIN
	ALTER TABLE rul_TradingPolicy ADD DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag BIT NULL
END

IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'SeekDeclarationFromEmpRegPossessionOfUPSIFlag' AND OBJECT_ID = OBJECT_ID('[dbo].[tra_TransactionMaster]'))
BEGIN
	ALTER TABLE tra_TransactionMaster ADD SeekDeclarationFromEmpRegPossessionOfUPSIFlag BIT NULL
END
/* End COLUMN ADDED IN rul_TradingPolicy TABLE ---- START */