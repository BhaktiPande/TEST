IF NOT EXISTS(SELECT * FROM  INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'tra_TransactionDetails'
			    AND COLUMN_NAME='CurrencyID')
BEGIN
ALTER TABLE tra_TransactionDetails ADD CurrencyID INT
END

IF NOT EXISTS(SELECT * FROM  INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'rpt_ClawBackReport'
			    AND COLUMN_NAME='Currency')
BEGIN
ALTER TABLE rpt_ClawBackReport ADD Currency NVARCHAR(50)
END

IF NOT EXISTS(SELECT * FROM  INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'tra_TransactionSummaryDMATWise'
			    AND COLUMN_NAME='CurrencyID')
BEGIN
ALTER TABLE tra_TransactionSummaryDMATWise ADD CurrencyID  INT
END


IF NOT EXISTS(SELECT * FROM  INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'tra_PreclearanceRequest'
			    AND COLUMN_NAME='CurrencyID')
BEGIN
ALTER TABLE tra_PreclearanceRequest ADD CurrencyID  INT
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54229)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54229,'rpt_grd_54229','Currency','en-US',103009,104001, 122052,'Currency',1,GETDATE())
END


IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=122100 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 122100,'rpt_grd_54229',1,7,0,155001,NULL,NULL
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114058 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114058,'rpt_grd_54229',1,80007,0,155001,NULL,NULL
END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114046 AND ResourceKey='rpt_grd_54229')--Correct
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114046,'rpt_grd_54229',1,89999,0,155001,NULL,NULL
END
IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114038 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114038,'rpt_grd_54229',1,8,0,155001,NULL,NULL
END


IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114080 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114080,'rpt_grd_54229',1,30002,0,155003,NULL,NULL
END
IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114071 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114071,'rpt_grd_54229',1,9,0,155001,NULL,NULL

END

IF NOT EXISTS(select GridTypeCodeId from com_GridHeaderSetting where GridTypeCodeId=114102 AND ResourceKey='rpt_grd_54229')
BEGIN
 INSERT INTO com_GridHeaderSetting
 (
	GridTypeCodeId,	ResourceKey,	IsVisible,	SequenceNumber,	ColumnWidth,	ColumnAlignment,	OverrideGridTypeCodeId,	OverrideResourceKey
 )
 SELECT 114102,'rpt_grd_54229',1,9,0,155001,NULL,NULL

END
