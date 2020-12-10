IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15459)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(15459, 'rul_msg_15459','Select at least one value for View & View Agree.','en-US',103006,104001,122038,'Select at least one value for View & View Agree.',1,GETDATE())
END