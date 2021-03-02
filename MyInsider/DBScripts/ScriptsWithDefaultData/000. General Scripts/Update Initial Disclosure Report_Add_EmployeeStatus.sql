IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81006)
BEGIN
    insert into mst_Resource values(81006, 'rpt_grd_81006','Employee Status','en-US',103011, 104003, 122063,'Employee Status', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114050 and ResourceKey = 'rpt_grd_81006')
BEGIN
    insert into com_GridHeaderSetting values(114050, 'rpt_grd_81006',1, 55000, 0, 155001, NULL, NULL)
END
