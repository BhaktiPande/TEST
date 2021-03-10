IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81006)
BEGIN
    insert into mst_Resource values(81006, 'rpt_grd_81006','Email ID','en-US',103011, 104003, 122075,'Email ID', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select * from com_GridHeaderSetting where GridTypeCodeId = 114078 and ResourceKey = 'rpt_grd_81006')
BEGIN
    insert into com_GridHeaderSetting values(114078, 'rpt_grd_81006',1, 420000, 0, 155001, NULL, NULL)
END

If EXISTS(select * from com_GridHeaderSetting where ResourceKey='rpt_grd_81006' and GridTypeCodeId=114078 )
BEGIN
        UPDATE com_GridHeaderSetting SET ResourceKey='rpt_grd_810010' where ResourceKey='rpt_grd_81006' and GridTypeCodeId=114078
END

If EXISTS(select * from mst_Resource where ResourceKey='rpt_grd_81006' and ResourceId='81006' )
BEGIN
        UPDATE mst_Resource SET ResourceValue='Employee Status' , OriginalResourceValue='Employee Status' where ResourceId='81006'
END