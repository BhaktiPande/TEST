/*
Script received from Raghvendra on 4-May-2016
Added the new resource message to be shown when user tries to add duplicate PAN number when creating/editing Employee/insider details
*/
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = '11440')
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(11440,'usr_msg_11440','The entered PAN number is used by another user, change the PAN number and try again.','en-US','103013','104001','122076','The entered PAN number is used by another user, change the PAN number and try again.',1,GETDATE())
END
GO