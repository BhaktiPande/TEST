IF EXISTS(select * from mst_MenuMaster where MenuID in(44,45) )
BEGIN
		Update mst_MenuMaster set ImageURL='fa fa-question-circle' where  MenuID in(44,45)
END

-- Change the ColumnAlignment on Intial Disclosures Grid
IF EXISTS(select * from com_GridHeaderSetting where GridTypeCodeId =  114048 and ResourceKey='dis_grd_17251')
BEGIN
		Update com_GridHeaderSetting set ColumnAlignment=155003
		where GridTypeCodeId =  114048 and ResourceKey='dis_grd_17251'
END

