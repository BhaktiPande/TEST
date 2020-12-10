/*
Script from Parag on 25 May 2016 -  resources for error message for security post acquisition on transcation details page
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16443)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16443, 'tra_msg_16443' ,'Can not trade more then security held' ,'Can not trade more then security held' , 'en-US', 103008, 104001, 122036, 1, GETDATE())
END
GO
