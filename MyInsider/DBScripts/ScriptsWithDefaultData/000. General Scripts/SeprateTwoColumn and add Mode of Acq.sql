-------------------------------------------------Other Security-------------------------------------------------------

IF EXISTS(SELECT * FROM mst_Resource where ResourceKey='dis_grd_54164' )
BEGIN
	Update mst_Resource set ResourceValue='Bought during the period' ,OriginalResourceValue='Bought during the period' where ResourceKey='dis_grd_54164'
END

UPDATE com_GridHeaderSetting set IsVisible=1 where ResourceKey='dis_grd_54163' and GridTypeCodeId='114127'


-------------------------------------------------Own Security----------------------------------------------------------


IF EXISTS(SELECT * FROM mst_Resource where ResourceKey='dis_grd_17038' )
BEGIN
	Update mst_Resource set ResourceValue='Bought during the period' ,OriginalResourceValue='Bought during the period' where ResourceKey='dis_grd_17038'
END

UPDATE com_GridHeaderSetting set IsVisible=1 where ResourceKey='dis_grd_17037' and GridTypeCodeId='114039'

-----------------------------------------Insert Mode of Acq ------------------------------------------------
IF NOT EXISTS(SELECT * FROM tra_TransactionTypeSettings_OS WHERE MODE_OF_ACQUIS_CODE_ID=149020 and SECURITY_TYPE_CODE_ID=139002)
BEGIN
		INSERT INTO tra_TransactionTypeSettings_OS VALUES('139002','143001','149020','504001','505001','506001',1,GETDATE(),1,GETDATE(),1)
END

IF NOT EXISTS(SELECT * FROM tra_TransactionTypeSettings_OS WHERE MODE_OF_ACQUIS_CODE_ID=149020 and SECURITY_TYPE_CODE_ID=139003)
BEGIN
	INSERT INTO tra_TransactionTypeSettings_OS VALUES('139003','143001','149020','504001','505001','506001',1,GETDATE(),1,GETDATE(),1)
END

IF NOT EXISTS(SELECT * FROM tra_TransactionTypeSettings_OS WHERE MODE_OF_ACQUIS_CODE_ID=149020 and SECURITY_TYPE_CODE_ID=139004)
BEGIN
	INSERT INTO tra_TransactionTypeSettings_OS VALUES('139004','143001','149020','504001','505001','506001',1,GETDATE(),1,GETDATE(),1)
END

IF NOT EXISTS(SELECT * FROM tra_TransactionTypeSettings_OS WHERE MODE_OF_ACQUIS_CODE_ID=149020 and SECURITY_TYPE_CODE_ID=139005)
BEGIN
	INSERT INTO tra_TransactionTypeSettings_OS VALUES('139005','143001','149020','504001','505001','506001',1,GETDATE(),1,GETDATE(),1)
END