--select * from mst_Resource where ResourceKey in('tra_grd_16190','tra_grd_16191','tra_grd_16192','tra_grd_16193',
--'tra_grd_16194','tra_grd_16195','tra_grd_16196','tra_grd_16197','tra_grd_16198','tra_grd_16199',
--'tra_grd_16200','tra_grd_16201','tra_grd_16202','tra_grd_16203','tra_grd_16204','tra_grd_16205')

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114102)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(114102, NULL, 'Initial disclosure transaction list for Relative', null, 114, 'Initial disclosure transaction list for Relativ', 1, 1, GETDATE(), 102)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16190 AND ResourceValue='Demat A/C number')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Demat A/C number',OriginalResourceValue='Demat A/C number' WHERE ResourceId=16190
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16191 AND ResourceValue='DP Name')
BEGIN
	UPDATE mst_Resource SET ResourceValue='DP Name',OriginalResourceValue='DP Name' WHERE ResourceId=16191
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16192 AND ResourceValue='DP ID')
BEGIN
	UPDATE mst_Resource SET ResourceValue='DP ID',OriginalResourceValue='DP ID' WHERE ResourceId=16192
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16193 AND ResourceValue='TM ID')
BEGIN
	UPDATE mst_Resource SET ResourceValue='TM ID',OriginalResourceValue='TM ID' WHERE ResourceId=16193
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16194 AND ResourceValue='% Holding')
BEGIN
	UPDATE mst_Resource SET ResourceValue='% Holding',OriginalResourceValue='% Holding' WHERE ResourceId=16194
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16195 AND ResourceValue='Number of Securities')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Number of Securities',OriginalResourceValue='Number of Securities' WHERE ResourceId=16195
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16196 AND ResourceValue='ESOPs')
BEGIN
	UPDATE mst_Resource SET ResourceValue='ESOPs',OriginalResourceValue='ESOPs' WHERE ResourceId=16196
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16197 AND ResourceValue='Other than ESOPs')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Other than ESOPs',OriginalResourceValue='Other than ESOPs' WHERE ResourceId=16197
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16198 AND ResourceValue='Value')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Value',OriginalResourceValue='Value' WHERE ResourceId=16198
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16199 AND ResourceValue='Lot size')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Lot size',OriginalResourceValue='Lot size' WHERE ResourceId=16199
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16200 AND ResourceValue='Contract Specification')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Contract Specification',OriginalResourceValue='Contract Specification' WHERE ResourceId=16200
END


/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16190')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16190',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16191')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16191',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16192')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16192',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16193')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16193',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16194')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16194',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16195')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16195',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16196')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16196',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16197')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16197',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16199')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16199',0,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16200')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16200',0,10,0,155001,NULL,NULL)
END


IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16198')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16198',1,11,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50741)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50741,'tra_grd_50741','Relative Name','en-US',103008,104003,122071,'Relative Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50742)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50742,'tra_grd_50742','Relation with Employee','en-US',103008,104003,122071,'Relation with Employee',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50743)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50743,'tra_grd_50743','PAN','en-US',103008,104003,122071,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50744)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50744,'tra_grd_50744','Demat A/C number','en-US',103008,104003,122071,'Demat A/C number',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50745)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50745,'tra_grd_50745','DP Name','en-US',103008,104003,122071,'DP Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50746)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50746,'tra_grd_50746','DP ID','en-US',103008,104003,122071,'DP ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50747)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50747,'tra_grd_50747','TM ID','en-US',103008,104003,122071,'TM ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50748)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50748,'tra_grd_50748','% Holding','en-US',103008,104003,122071,'% Holding',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50749)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50749,'tra_grd_50749','Number of Securities','en-US',103008,104003,122071,'Number of Securities',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50750)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50750,'tra_grd_50750','Value','en-US',103008,104003,122071,'Value',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50783)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50783,'tra_grd_50783','Lot size','en-US',103008,104003,122071,'Lot size',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50784)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50784,'tra_grd_50784','Contract Specification','en-US',103008,104003,122071,'Contract Specification',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50741')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50741',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50742')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50742',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50743')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50743',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50744')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50744',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50745')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50745',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50746')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50746',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50747')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50747',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50748')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50748',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50749')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50749',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50783')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50783',0,10,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50784')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50784',0,11,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50750')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50750',1,12,0,155001,NULL,NULL)
END

--------------------------Initial Disclosure List For Employee-------------------------------

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114103)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(114103, NULL, 'Initial disclosure list for Employee', null, 114, 'Initial disclosure list for Employee', 1, 1, GETDATE(), 101)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52065)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52065,'dis_grd_52065','Submission For','en-US',103009,104002,122044,'Submission For',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52066)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52066,'dis_grd_52066','Trading Code of Conduct','en-US',103009,104002,122044,'Trading Code of Conduct',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50756)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50756,'dis_grd_50756','Initial Holdings','en-US',103009,104002,122044,'Initial Holdings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50757)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50757,'dis_grd_50757','Create Letter and Submit Soft Copy','en-US',103009,104002,122044,'Create Letter and Submit Soft Copy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50758)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50758,'dis_grd_50758','Upload and Submit Scanned Copy','en-US',103009,104002,122044,'Upload and Submit Scanned Copy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_52065')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114103,'dis_grd_52065',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_52066')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114103,'dis_grd_52066',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50756')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114103,'dis_grd_50756',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50757')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114103,'dis_grd_50757',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50758')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114103,'dis_grd_50758',1,5,0,155001,NULL,NULL)
END
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------Initial Disclosure List For Insider--------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114104)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(114104, NULL, 'Initial disclosure list for Insider', null, 114, 'Initial disclosure list for Employee', 1, 1, GETDATE(), 102)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50759)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50759,'dis_grd_50759','Submission For','en-US',103009,104002,122044,'Submission For',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50760)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50760,'dis_grd_50760','Trading Code of Conduct','en-US',103009,104002,122044,'Trading Code of Conduct',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50761)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50761,'dis_grd_50761','Initial Holdings','en-US',103009,104002,122044,'Initial Holdings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50762)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50762,'dis_grd_50762','Create Letter and Submit Soft Copy','en-US',103009,104002,122044,'Create Letter and Submit Soft Copy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50763)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50763,'dis_grd_50763','Upload and Submit Scanned Copy','en-US',103009,104002,122044,'Upload and Submit Scanned Copy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50777)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50777,'tra_msg_50777','Enter initial disclosuer for relative first','en-US',103008,104001,122036,'Enter initial disclosuer for relative first',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50778)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50778,'tra_lbl_50778','Holdings for','en-US',103008,104002,122036,'Holdings for',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50779)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50779,'tra_lbl_50779','Self','en-US',103008,104002,122036,'Self',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50780)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50780,'tra_lbl_50780','Relatives','en-US',103008,104002,122036,'Relatives',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50759')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114104,'dis_grd_50759',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50760')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114104,'dis_grd_50760',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50761')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114104,'dis_grd_50761',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50762')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114104,'dis_grd_50762',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50763')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114104,'dis_grd_50763',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'tra_TransactionMaster' AND SYSCOL.NAME = 'InsiderIDFlag')
BEGIN
	ALTER TABLE [dbo].[tra_TransactionMaster] ADD  [InsiderIDFlag][BIT] null default 0
END
GO

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114105)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(114105, NULL, 'Initial disclosure transaction list for Option Contract and future Contract', null, 114, 'Initial disclosure transaction list for Option Contract and future Contract', 1, 1, GETDATE(), 103)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16190' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16190',1,1,0,155001,114105,'tra_grd_16190')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16191' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16191',1,2,0,155001,114105,'tra_grd_16191')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16192' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16192',1,3,0,155001,114105,'tra_grd_16192')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16193' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16193',1,4,0,155001,114105,'tra_grd_16193')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16194' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16194',1,5,0,155001,114105,'tra_grd_16194')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16195'  and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16195',1,6,0,155001,114105,'tra_grd_16195')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16196' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16196',0,7,0,155001,114105,'tra_grd_16196')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16197' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16197',0,8,0,155001,114105,'tra_grd_16197')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16199' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16199',1,9,0,155001,114105,'tra_grd_16199')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16200' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16200',1,10,0,155001,114105,'tra_grd_16200')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16198' and OverrideGridTypeCodeId=114105)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114071,'tra_grd_16198',1,10,0,155001,114105,'tra_grd_16198')
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114106)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(114106, NULL, 'Initial disclosure transaction list for Option Contract and future Contract for relative', null, 114, 'Initial disclosure transaction list for Option Contract and future Contract for relative', 1, 1, GETDATE(), 103)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50741' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50741',1,1,0,155001,114106,'tra_grd_50741')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50742' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50742',1,2,0,155001,114106,'tra_grd_50742')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50743' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50743',1,3,0,155001,114106,'tra_grd_50743')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50744' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50744',1,4,0,155001,114106,'tra_grd_50744')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50745' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50745',1,5,0,155001,114106,'tra_grd_50745')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50746' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50746',1,6,0,155001,114106,'tra_grd_50746')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50747' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50747',1,7,0,155001,114106,'tra_grd_50747')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50748' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50748',1,8,0,155001,114106,'tra_grd_50748')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50749' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50749',1,9,0,155001,114106,'tra_grd_50749')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50783' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50783',1,10,0,155001,114106,'tra_grd_50783')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50784' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50784',1,11,0,155001,114106,'tra_grd_50784')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_50750' and OverrideGridTypeCodeId=114106)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114102,'tra_grd_50750',1,12,0,155001,114106,'tra_grd_50750')
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52083)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52083,'dis_lbl_52083','I here by declare that the information provided is correct to the best of my knowledge.','en-US',103008,104002,122071,'I here by declare that the information provided is correct to the best of my knowledge.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52084)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52084,'dis_btn_52084','Confirm Details','en-US',103008,104004,122071,'Confirm Details',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52085)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52085,'dis_msg_52085','Please select the confirmation checkbox to submit your own securities.','en-US',103008,104002,122071,'Please select the confirmation checkbox to submit your own securities.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52111)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52111,'dis_lbl_52111','Date of Intimation','en-US',103008,104002,122036,'Date of Intimation',1,GETDATE())
END

ALTER TABLE tra_TransactionDetails
ALTER COLUMN DMATDetailsID int NULL

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52125)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52125,'tra_lbl_52125','Demat Details Not Available','en-US',103008,104002,122036,'Demat Details Not Available',1,GETDATE())
END





