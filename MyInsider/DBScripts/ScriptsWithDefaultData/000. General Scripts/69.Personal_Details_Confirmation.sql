-- ======================================================================================================
-- Author      : Tushar Wakchaure
-- CREATED DATE: 10-Oct-2018
-- Description : Script for Personal Details Confirmation Functionality.
-- ======================================================================================================

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50732)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50732,'cmp_ttl_50732','Personal Details Confirmation Setting','en-US',103005,104006,122084,'Personal Details Confirmation Setting',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50733)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50733,'cmp_lbl_50733','Reconfirmation Frequency','en-US',103005,104006,122084,'Reconfirmation Frequency',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50737)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50737,'cmp_msg_50737','Personal Details Confirmation saved successfully','en-US',103005,104006,122084,'Personal Details Confirmation saved successfully',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50738)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50738,'cmp_msg_50738','Error occurred while fetching Personal Details Confirmation data.','en-US',103005,104001,122084,'Error occurred while fetching Personal Details Confirmation data.',1,GETDATE())
END




