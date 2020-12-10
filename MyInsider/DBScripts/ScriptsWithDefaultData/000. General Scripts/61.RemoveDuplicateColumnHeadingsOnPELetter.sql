/*-------------------------------------------------------------------------------------------------
Description:	This script is used for deleting data for "OverrideGridTypeCodeId = 114087" 
                and adding the unique resourekey entries.
Scenario:       There was multiple resourekey entries in table "com_GridHeaderSetting" 
                which causes displaying duplicate grid header name on period end transction create letter page.                
			
Created by:		Tushar Wakchaure
Created on:		28-June-2018

-------------------------------------------------------------------------------------------------*/


DELETE FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND OverrideGridTypeCodeId = 114087

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16001',1,0,0,155001,114087,'tra_grd_16397')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16002',1,1,0,155001,114087,'tra_grd_16398')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16003',1,2,0,155001,114087,'tra_grd_16399')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16004',1,3,0,155001,114087,'tra_grd_16400')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16005',1,4,0,155001,114087,'tra_grd_16401')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16429',1,5,0,155001,114087,'tra_grd_16402')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16006',1,6,0,155001,114087,'tra_grd_16403')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16007',1,7,0,155001,114087,'tra_grd_16404')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16008',1,8,0,155001,114087,'tra_grd_16405')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16009',1,9,0,155001,114087,'tra_grd_16406')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16010',1,10,0,155001,114087,'tra_grd_16407')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16011',1,11,0,155001,114087,'tra_grd_16408')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16012',1,12,0,155001,114087,'tra_grd_16409')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16013',1,13,0,155001,114087,'tra_grd_16410')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16014',1,14,0,155001,114087,'tra_grd_16411')
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114087)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114031,'tra_grd_16015',1,15,0,155001,114087,'tra_grd_16412')
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17530)
BEGIN
	UPDATE mst_Resource SET ResourceValue='Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whose date of acquisition earlier than current transcation''s date of acquistion.'
	,OriginalResourceValue='Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whose date of acquisition earlier than current transcation''s date of acquistion.'
	WHERE ResourceId=17530
END



















