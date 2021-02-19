IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81004)
BEGIN
    insert into mst_Resource values(81004, 'rpt_grd_81004','Email ID','en-US',103011, 104003, 122060,'Email ID', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114053 and ResourceKey = 'rpt_grd_81004')
BEGIN
    insert into com_GridHeaderSetting values(114053, 'rpt_grd_81004',1, 180000, 0, 155001, NULL, NULL)
END