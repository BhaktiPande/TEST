IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81007)
BEGIN
    insert into mst_Resource values(81007, 'rpt_grd_81007','Relation With Insider','en-US',103011, 104003, 122063,'Relation With Insider', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114050 and ResourceKey = 'rpt_grd_81007')
BEGIN
    insert into com_GridHeaderSetting values(114050, 'rpt_grd_81007',1, 65000, 0, 155001, NULL, NULL)
END
