IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50553)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50553, 
	'usr_msg_50553', 
	'Depository ID is mandatory to insert Demat Account Number.', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'Depository ID is mandatory to insert Demat Account Number ', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50554)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50554, 
	'usr_msg_50554', 
	'New Demat Account Number added in system ', 
	'en-US',
	'503002',
	'104001',
	'122032',
	'New Demat Account Number added in system: {0}.', 
	1,
	GETDATE() )
END

IF NOT EXISTS (SELECT 1 FROM SYS.columns WHERE NAME = 'Is_UploadDematFromFile')
BEGIN
	ALTER TABLE du_MappingTables ADD Is_UploadDematFromFile BIT DEFAULT 0
END
