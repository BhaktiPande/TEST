--usr_msg_50490,usr_msg_11342,usr_msg_11048

ALTER TABLE usr_UserInfo ALTER COLUMN MobileNumber NVARCHAR(30)

IF EXISTS (select * from mst_Resource where ResourceKey='usr_msg_11342')
BEGIN
		Update mst_Resource set ResourceValue='The field Contact No (Phone / Mobile No) must be a string with a minimum length of 3 and maximum length of 30.',
		OriginalResourceValue='The field Contact No (Phone / Mobile No) must be a string with a minimum length of 3 and maximum length of 30.' where ResourceKey='usr_msg_11342' and ResourceId=11342
END


IF EXISTS (select * from mst_Resource where ResourceKey='usr_msg_11048')
BEGIN
		Update mst_Resource set ResourceValue='The field Contact No (Phone / Mobile No) must be a string with a minimum length of 3 and maximum length of 30.',
		OriginalResourceValue='The field Contact No (Phone / Mobile No) must be a string with a minimum length of 3 and maximum length of 30.' where ResourceKey='usr_msg_11048' and ResourceId=11048
END

IF EXISTS (select * from mst_Resource where ResourceKey='usr_msg_50490')
BEGIN
		Update mst_Resource set ResourceValue='The field Landline1 must be a string with a minimum length of 3 and maximum length of 30.',
		OriginalResourceValue='The field Landline1 must be a string with a minimum length of 3 and maximum length of 30.' where ResourceKey='usr_msg_50490' and ResourceId=50490
END

IF NOT EXISTS (select *  from mst_Resource where ResourceKey='usr_msg_55506')
BEGIN

    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55506,'usr_msg_55506','The field Landline2 must be a string with a minimum length of 3 and maximum length of 30.','en-US','103002','104001','122004',
	 'The field Landline2 must be a string with a minimum length of 3 and maximum length of 30.',1,GETDATE())

END

IF EXISTS (select * from mst_Resource where ResourceKey='usr_msg_55069')
BEGIN
		Update mst_Resource set ResourceValue='The field Phone must be a string with a minimum length of 3 and maximum length of 30.',
		OriginalResourceValue='The field Phone must be a string with a minimum length of 3 and maximum length of 30.' where ResourceKey='usr_msg_55069' and ResourceId=55069
END
