/*Script By Tushar Dated- 26 Sept 2017 */
/*Added the new resource message For PAN Number validation when Demat details available through UI and Mass Upload*/

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50593)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50593,'usr_msg_50593','PAN Number is required to add Demat details','en-US',103013,104001,122076,'PAN Number is required to add Demat details',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50594)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50594,'usr_msg_50594','Cannot delete PAN number as Demat details are available','en-US',103002,104001,122076,'Cannot delete PAN number as Demat details are available',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50595)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50595,'usr_msg_50595','Cannot add Demat details as PAN number is not available','en-US',103002,104001,122076,'Cannot add Demat details as PAN number is not available',1,GETDATE())
END