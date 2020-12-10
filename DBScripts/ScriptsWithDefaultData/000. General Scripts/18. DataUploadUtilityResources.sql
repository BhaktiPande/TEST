/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	04-APR-2016
	Description :	THIS SCRIPT IS USED TO SAVE VALUES IN com_CodeGroup/com_Code/mst_Resource TABLES
*/



/* INSERT INTO com_CodeGroup TABLE ---- START */
IF NOT EXISTS (SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 503)
BEGIN
	INSERT INTO com_CodeGroup (CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable, ParentCodeGroupId)
	VALUES (503, 'Data Upload Utility', 'Data upload Utility', 1, 0, NULL)
END
/* INSERT VALUES INTO com_CodeGroup TABLE ---- END */

/* INSERT VALUES INTO com_Code TABLE ---- END */
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 503001)
BEGIN
	INSERT INTO com_Code (CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES (503001, 'DataUploadUtilityMails', 503, 'Data Upload Utility Mails Alerts', 1, 1,1, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 503002)
BEGIN
	INSERT INTO com_Code (CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES (503002, 'DataUploadUtilityErrors', 503, 'Data Upload Utility Mails Errors', 1, 1,1, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 503003)
BEGIN
	INSERT INTO com_Code (CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES (503003, 'DataUploadUtilityMessages', 503, 'Data Upload Utility Mails Messages', 1, 1,1, NULL, NULL, 1, GETDATE())
END
/* INSERT VALUES INTO com_Code TABLE ---- END */

/* INSERT VALUES INTO mst_Resource TABLE ---- START */
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50037)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50037, 
	'usr_msg_50037', 
	' <html><body><font face="Calibri" size="3">Hi,<p>This is to notify that there has been a change in the data for the following company.</p><p><b>Client Name: </b>@Company_Name<br /><p>Please refer the attached "Log.txt" for more details.</p><p>Please note that the data changes have been updated in the base data.</p>Regards,<br />ESOP Direct Team<p><font color="red"><b>Note:</b> This is a system-generated email, please do not reply!</font></p></font></body></html>', 
	'en-US',
	'103008',
	'104001',
	'122032',
	' <html><body><font face="Calibri" size="3">Hi,<p>This is to notify that there has been a change in the data for the following company.</p><p><b>Client Name: </b>@Company_Name<br /><p>Please refer the attached "Log.txt" for more details.</p><p>Please note that the data changes have been updated in the base data.</p>Regards,<br />ESOP Direct Team<p><font color="red"><b>Note:</b> This is a system-generated email, please do not reply!</font></p></font></body></html>', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50038)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50038, 
	'usr_msg_50038', 
	'Error occured while getting company details', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while getting company details', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50039)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50039, 
	'usr_msg_50039', 
	'Error occured while downloading excel sheet', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while downloading excel sheet', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50040)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50040, 
	'usr_msg_50040', 
	'Mapping details not found for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Mapping details not found for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50041)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50041, 
	'usr_msg_50041', 
	'Error occured while getting mapping details for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while getting mapping details for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50042)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50042, 
	'usr_msg_50042', 
	'Error occured while getting mapping fields for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while getting mapping fields for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50043)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50043, 
	'usr_msg_50043', 
	'Mapping fields not found for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Mapping fields not found for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50044)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50044, 
	'usr_msg_50044', 
	'Error occured while preparing columns', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while preparing columns', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50045)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50045, 
	'usr_msg_50045', 
	'Error occured while preparing rows and upload data for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Error occured while preparing rows and upload data for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50046)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50046, 
	'usr_msg_50046', 
	' Intimation of change in data for {0}', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Intimation of change in data for {0}', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50047)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50047, 
	'usr_msg_50047', 
	'Read mappings from DataBase - Completed', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Read mappings from DataBase - Completed', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50048)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50048, 
	'usr_msg_50048', 
	'Read data from Excel/Query - Completed', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Read data from Excel/Query - Completed', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50049)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50049, 
	'usr_msg_50049', 
	'Mapping fields based on settings - Start', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Mapping fields based on settings - Start', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50050)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50050, 
	'usr_msg_50050', 
	'Mapping fields based on settings - Completed', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Mapping fields based on settings - Completed', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50051)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50051, 
	'usr_msg_50051', 
	'Data Uploading - Start', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Data Uploading - Start', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50052)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50052, 
	'usr_msg_50052', 
	'Data Uploading - Completed', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Data Uploading - Completed', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50053)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50053, 
	'usr_msg_50053', 
	'Total time taken to upload data {0} mins', 
	'en-US',
	'503003',
	'104001',
	'122032',
	'Total time taken to upload data {0} mins', 
	1,
	GETDATE() )

END
/* INSERT VALUES INTO mst_Resource TABLE ---- END */

