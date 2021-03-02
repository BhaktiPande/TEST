IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 81008)
BEGIN
    insert into mst_Resource values(81008, 'rpt_grd_81008','Relation With Insider','en-US',103011, 104003, 122062,'Relation With Insider', 1, GETDATE())
END

 

-- Insert into GridHeaderSetting table
IF NOT EXISTS(Select 1 from com_GridHeaderSetting where GridTypeCodeId = 114059 and ResourceKey = 'rpt_grd_81008')
BEGIN
    insert into com_GridHeaderSetting values(114059, 'rpt_grd_81008',1, 65000, 0, 155001, NULL, NULL)
END
