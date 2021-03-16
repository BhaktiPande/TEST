IF EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rpt_grd_81001')
BEGIN
		update com_GridHeaderSetting set SequenceNumber = 35000
		where GridTypeCodeId = 114050 and ResourceKey = 'rpt_grd_81001'
END


IF EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rpt_grd_81002')
BEGIN
		update com_GridHeaderSetting set SequenceNumber = 45000
		where GridTypeCodeId = 114050 and ResourceKey = 'rpt_grd_81002'
END

