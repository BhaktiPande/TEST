IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81005)
BEGIN
    insert into mst_Resource values(81005, 'rpt_grd_81005','Email ID','en-US',103011, 104003, 122063,'Email ID', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114061 and ResourceKey = 'rpt_grd_81005')
BEGIN
    insert into com_GridHeaderSetting values(114061, 'rpt_grd_81005',1, 170000, 0, 155001, NULL, NULL)
END