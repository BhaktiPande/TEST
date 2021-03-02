IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81001)
BEGIN
    insert into mst_Resource values(81001, 'rpt_grd_81001','Email ID','en-US',103011, 104003, 122061,'Email ID', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114050 and ResourceKey = 'rpt_grd_81001')
BEGIN
    insert into com_GridHeaderSetting values(114050, 'rpt_grd_81001',1, 180000, 0, 155001, NULL, NULL)
END

