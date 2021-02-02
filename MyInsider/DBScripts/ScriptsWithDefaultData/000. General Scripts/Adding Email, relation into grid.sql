IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = 'dis_grd_71003' AND ResourceId = 71003)
BEGIN
INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
VALUES (71003, 'dis_grd_71003', 'Email ID', 'en-US', 103009, 104003, 122056, 'Email ID' , 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = 'dis_grd_71004' AND ResourceId = 71004)
BEGIN
INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
VALUES (71004, 'dis_grd_71004', 'Relation', 'en-US', 103009, 104003, 122056, 'Relation' , 1, GETDATE())
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114048 AND ResourceKey='dis_grd_71003')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey, IsVisible,	SequenceNumber,	ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey
 )
 SELECT 114048, 'dis_grd_71003', 1, 11, 0, 155001, NULL, NULL
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = 'dis_grd_71005' AND ResourceId = 71005)
BEGIN
INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
VALUES (71005, 'dis_grd_71005', 'Email ID', 'en-US', 103009, 104003, 122057, 'Email ID' , 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = 'dis_grd_71006' AND ResourceId = 71006)
BEGIN
INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
VALUES (71006, 'dis_grd_71006', 'Relation', 'en-US', 103009, 104003, 122057, 'Relation' , 1, GETDATE())
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114049 AND ResourceKey='dis_grd_71005')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey, IsVisible,	SequenceNumber,	ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey
 )
 SELECT 114049, 'dis_grd_71005', 1, 15, 0, 155001, NULL, NULL
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114049 AND ResourceKey='dis_grd_71006')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey, IsVisible, SequenceNumber,	ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey
 )
 SELECT 114049, 'dis_grd_71006', 1, 16, 0, 155001, NULL, NULL
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = 'dis_grd_71007' AND ResourceId = 71007)
BEGIN
INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
VALUES (71007, 'dis_grd_71007', 'Email ID', 'en-US', 103009, 104003, 122055, 'Email ID' , 1, GETDATE())
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114045 AND ResourceKey='dis_grd_71007')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey, IsVisible,	SequenceNumber,	ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey
 )
 SELECT 114045, 'dis_grd_71007', 1, 11, 0, 155001, NULL, NULL
END