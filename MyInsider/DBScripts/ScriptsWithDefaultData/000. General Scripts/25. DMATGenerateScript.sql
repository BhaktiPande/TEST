/*
	Created By  :	ANIKET SHINGATE
	Created On 	:	24-MAY-2016
	Description :	THIS SCRIPT IS USED TO SAVE VALUES IN mst_Resource TABLES FOR VALIDATION MASSAGE.
*/

/* INSERT INTO mst_Resource TABLE ---- START */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50063)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50063, 'usr_msg_50063', 'The Demat Account Type is required.', 'en-US', 103001, 104001, 122001, 'The Demat Account Type is required.', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50064)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50064, 'usr_msg_50064', 'CDSL, Please update your 16 digit Demat Account number.', 'en-US', 103001, 104001, 122001, 'CDSL, Please update your 16 digit Demat Account number.', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50065)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50065, 'usr_msg_50065', 'NSDL, please update your 8 digit Demat account number.', 'en-US', 103001, 104001, 122001, 'NSDL, please update your 8 digit Demat account number.', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50066)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50066, 'usr_msg_50066', 'DP ID number should start with IN followed by 6 digits.', 'en-US', 103001, 104001, 122001, 'DP ID number should start with IN followed by 6 digits.', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50067)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50067, 'usr_msg_50067', 'Client ID Number already exists..', 'en-US', 103001, 104001, 122001, 'Client ID Number already exists.', 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50068)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50068, 'usr_msg_50068', 'The Depository Participant Name is required.', 'en-US', 103001, 104001, 122001, 'The Depository Participant Name is required.', 1, GETDATE())
END

/* INSERT INTO mst_Resource TABLE ---- START */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50073)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES (50073, 'usr_msg_50073', 'The DP Name is required.', 'en-US', 103001, 104001, 122001, 'The DP Name is required.', 1, GETDATE())
END