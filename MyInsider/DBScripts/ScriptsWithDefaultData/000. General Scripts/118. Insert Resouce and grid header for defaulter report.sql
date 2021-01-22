
-- Insert into resource table
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61009)
BEGIN
	insert into mst_Resource values(61009, 'rpt_grd_61009','Override Reason','en-US',103011, 104003, 122075,'Override Reason', 1, GETDATE())
END

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114078 and ResourceKey = 'rpt_grd_61009')
BEGIN
	insert into com_GridHeaderSetting values(114078, 'rpt_grd_61009',1, 405000, 0, 155001, NULL, NULL)
END