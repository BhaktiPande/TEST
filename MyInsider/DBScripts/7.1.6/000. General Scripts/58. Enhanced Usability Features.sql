/*Script By Tushar Dated- 11 Oct 2017 */
/*Added the new resource message For search continuous disclosure records by PAN Number */

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50597)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50597,'dis_grd_50597','PAN','en-US',103009,104003,122057,'PAN',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50597')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114049,'dis_grd_50597',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50598)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50598,'dis_lbl_50598','PAN','en-US',103009,104002,122057,'PAN',1,GETDATE())
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 505796)
BEGIN
	DELETE FROM mst_Resource where ResourceId=505796
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50596)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50596,'pc_msg_50596','Expiry reminder can not be greater than password validity','en-US','103302','104001','122096','Expiry reminder can not be greater than password validity',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50599)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50599,'com_btn_50599','Upload Hardcopy','en-US',103003,104004,122034,'Upload Hardcopy',1,GETDATE())
END
