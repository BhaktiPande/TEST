IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81003)
BEGIN
    insert into mst_Resource values(81003, 'rpt_grd_81003','Email ID','en-US',103011, 104003, 122062,'Email ID', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114059 and ResourceKey = 'rpt_grd_81003')
BEGIN
    insert into com_GridHeaderSetting values(114059, 'rpt_grd_81003',1, 180000, 0, 155001, NULL, NULL)
END