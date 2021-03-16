IF EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rpt_grd_81003')
BEGIN
		update com_GridHeaderSetting set SequenceNumber = 35000
		where GridTypeCodeId = 114059 and ResourceKey = 'rpt_grd_81003'
END