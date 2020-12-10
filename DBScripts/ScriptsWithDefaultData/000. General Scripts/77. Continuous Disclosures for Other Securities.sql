-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 12-Mar-2019
-- Description : Script for Continuous Disclouser - other securities Functionality.
-- ======================================================================================================

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='240' AND RoleID ='1')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(240,1,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT TTTS_ID FROM tra_TransactionTypeSettings_OS WHERE TTTS_ID =7)
BEGIN
	UPDATE tra_TransactionTypeSettings_OS SET EXEMPT_PRE_FOR_MODE_OF_ACQUISITION =1 where TTTS_ID=7
END

IF NOT EXISTS (SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID =515)
BEGIN			
		INSERT INTO com_CodeGroup VALUES(515,'Reason for not trading for other securities','Reason for not trading for other securities',1,1,NULL)	
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 515001)
BEGIN			
		INSERT INTO com_Code VALUES(515001,'non trading reason1',515,'non trading reason1',1,1,145002,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 122107)
BEGIN			
		INSERT INTO com_Code VALUES(122107,'Transaction Details List For Other security',122,'Screen - Transaction Details List For Other Security',1,1,145002,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53052)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53052,'dis_msg_53052','Are you sure that you and your dependents donot have any $2 holdings.','en-US',103303,104001,122107,'Are you sure that you and your dependents donot have any $2 holdings.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53053)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53053,'dis_msg_53053','Not traded submitted.','en-US',103303,104001,122107,'Not traded submitted.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53054)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53054,'tra_lbl_53054','Pre-Clearance Approved Qty:','en-US',103303,104002,122107,'Pre-Clearance Approved Qty:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53055)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53055,'tra_lbl_53055','Traded Qty:','en-US',103303,104002,122107,'Traded Qty:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53056)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53056,'tra_lbl_53056','Pending Qty:','en-US',103303,104002,122107,'Pending Qty:',1,GETDATE())
END

--Trading transaction details list (Other Securities)-SELF
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114120)
BEGIN
	INSERT INTO com_Code VALUES(114120,	'Trading transaction details list (Other Securities)',114,'Trading transaction details list (Other Securities)',1,1,117,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53057)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53057, 'tra_grd_53057', 'Name, Address, Mobile Number', 'Name, Address, Mobile Number', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 53058)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53058, 'tra_grd_53058', 'PAN Number', 'PAN', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53059)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53059, 'tra_grd_53059', 'Relation with Insider', 'Relation with insider', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53060)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53060, 'tra_grd_53060', 'Demat A/c Number', 'Demat A/c No.', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53061)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53061, 'tra_grd_53061', 'Security Name', 'Security Name', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53064)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53064, 'tra_grd_53064', 'Date of Acquisition', 'Date of Acquisition', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53065)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53065, 'tra_grd_53065', 'Date of Intimation to Company', 'Date of Intimation to Company', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53066)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53066, 'tra_grd_53066', 'Mode of Acquisition', 'Mode of Acquisition', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53067)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53067, 'tra_grd_53067', 'Stock Exchange', 'Stock Exchange', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53068)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53068, 'tra_grd_53068', 'Transaction Type', 'Transaction Type', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53069)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53069, 'tra_grd_53069', 'Securities', 'Securities', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53070)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53070, 'tra_grd_53070', 'Value', 'Value', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53071)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53071, 'tra_grd_53071', 'Lot Size', 'Lot Size', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53072)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53072, 'tra_grd_53072', 'Contract Specification', 'Contract Specification', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
--com_GridHeaderSetting
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53057')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53057',1,0,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53058')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53058',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53059')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53059',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53060')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53060',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53061')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53061',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53064')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53064',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53065')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53065',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53066')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53066',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53067')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53067',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53068')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53068',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53069')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53069',1,10,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53070')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53070',1,11,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53071')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53071',1,12,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53072')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53072',1,13,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' AND GridTypeCodeId = 114120)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'usr_grd_11073',1,15,0,155001,NULL,NULL)
END
-----------------------------------------------------------
--Trading transaction details list (Other Securities)-SELF
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114121)
BEGIN
	INSERT INTO com_Code VALUES(114121,	'Trading transaction details list for Relative (Other Securities)',114,'Trading transaction details list for Relative (Other Securities)',1,1,118,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53073)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53073, 'tra_grd_53073', 'Name, Address, Mobile Number', 'Name, Address, Mobile Number', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 53074)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53074, 'tra_grd_53074', 'PAN Number', 'PAN', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53075)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53075, 'tra_grd_53075', 'Relation with Insider', 'Relation with insider', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53076)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53076, 'tra_grd_53076', 'Demat A/c Number', 'Demat A/c No.', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53077)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	 VALUES(53077, 'tra_grd_53077', 'Security Name', 'Security Name', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53080)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53080, 'tra_grd_53080', 'Date of Acquisition', 'Date of Acquisition', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53081)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53081, 'tra_grd_53081', 'Date of Intimation to Company', 'Date of Intimation to Company', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53082)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53082, 'tra_grd_53082', 'Mode of Acquisition', 'Mode of Acquisition', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53083)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53083, 'tra_grd_53083', 'Stock Exchange', 'Stock Exchange', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53084)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53084, 'tra_grd_53084', 'Transaction Type', 'Transaction Type', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53085)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53085, 'tra_grd_53085', 'Securities', 'Securities', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53086)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53086, 'tra_grd_53086', 'Value', 'Value', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53087)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53087, 'tra_grd_53087', 'Lot Size', 'Lot Size', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53088)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53088, 'tra_grd_53088', 'Contract Specification', 'Contract Specification', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END
--com_GridHeaderSetting
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53073')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53073',1,0,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53074')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53074',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53075')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53075',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53076')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53076',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53077')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53077',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53080')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53080',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53081')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53081',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53082')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53082',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53083')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53083',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53084')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53084',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53085')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53085',1,10,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53086')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53086',1,11,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53087')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53087',1,12,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53088')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53088',1,13,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' AND GridTypeCodeId = 114121)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'usr_grd_11073',1,15,0,155001,NULL,NULL)
END
-----------------------------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53078)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53078, 'tra_lbl_53078', 'Add Transaction', 'Add Transaction', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53062)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53062, 'tra_msg_53062', 'Are you sure you want to submit the Continuous Disclosures for Other Securities?', 'Are you sure you want to submit the Continuous Disclosures for Other Securities?', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53063)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53063, 'tra_btn_53063', 'Yes I Confirm', 'Yes I Confirm', 'en-Us', 103303, 104004, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53079)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53079, 'tra_msg_53079', 'Total of preclearance request of transaction type $1 for $2 company is exceeding the available quantity. Please recheck the preclearance request.', 'Total of preclearance request of transaction type $1 for $2 company is exceeding the available quantity. Please recheck the preclearance request.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END
-------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53089)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53089, 'tra_grd_53089', 'Security Type', 'Security Type', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53090)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53090, 'tra_grd_53090', 'Security Type', 'Security Type', 'en-Us', 103303, 104003, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53089')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114120,'tra_grd_53089',1,14,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'tra_grd_53090')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114121,'tra_grd_53090',1,14,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53091)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53091, 'tra_lbl_53091', 'Trade Details', 'Trade Details', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52081)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52081, 'tra_msg_52081', 'Click on submit button below to proceed and add a new transaction.', 'Click on submit button below to proceed and add a new transaction.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52086)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52086, 'tra_msg_52086', 'You cannot add this entry since you have a pending transaction for same company, security type and demat account selected in this transaction. Please submit the details to continue.', 'You cannot add this entry since you have a pending transaction for same company, security type and demat account selected in this transaction. Please submit the details to continue.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52087)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52087, 'tra_msg_52087', 'You do not have sufficient balance in the selected demat account.', 'You do not have sufficient balance in the selected demat account.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53094)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53094, 'tra_msg_53094', 'Please add initial disclosure for relative first', 'Please add initial disclosure for relative first', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END



IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52096)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52096, 'tra_lbl_52096', 'Available Balance', 'Available Balance', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52097)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52097, 'tra_msg_52097', 'Date of acquisition field is required', 'Date of acquisition field is required', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52098)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52098, 'tra_msg_52098', 'Date of acquisition cannot be greater than todays date', 'Date of acquisition cannot be greater than todays date', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52099)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52099, 'tra_msg_52099', 'Mode of acquisition field is required', 'Mode of acquisition field is required', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52100)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52100, 'tra_msg_52100', 'Exchange field is required', 'Exchange field is required', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52101)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52101, 'tra_msg_52101', 'Transaction Type field is required', 'Transaction Type field is required', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52102)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52102, 'tra_msg_52102', 'Buy value field is required', 'Buy value field is required', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52103)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52103, 'tra_lbl_52103', 'Date of acquisition', 'Date of acquisition', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52104)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52104, 'tra_lbl_52104', 'Mode of acquisition', 'Mode of acquisition', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52105)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52105, 'tra_lbl_52105', 'Stock Exchange', 'Stock Exchange', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52106)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52106, 'tra_lbl_52106', 'Transaction type', 'Transaction type', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52107)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52107, 'tra_lbl_52107', 'Value of Securities', 'Value of Securities', 'en-Us', 103303, 104002, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52108)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52108, 'tra_msg_52108', 'Date Of acquisition must be greater than date of approval.', 'Date Of acquisition must be greater than date of approval.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52109)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52109, 'tra_msg_52109', 'Date Of acquisition must be greater than date of initial disclosure.', 'Date Of acquisition must be greater than date of initial disclosure.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52110)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52110, 'tra_msg_52110', 'Please add initial disclosure for relative first', 'Please add initial disclosure for relative first', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53095)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53095, 'tra_msg_53095', 'You cannot submit the transaction as no trade details were entered.', 'You cannot submit the transaction as no trade details were entered.', 'en-Us', 103303, 104001, 122107, 1 , GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53096)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(53096, 'tra_btn_53096', 'OK', 'OK', 'en-Us', 103303, 104004, 122107, 1 , GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 180004)
BEGIN
	INSERT INTO com_Code VALUES(180004,	'Enter Upload Settings (Other Securities)',180,'Enter Upload Settings for each disclosure type (Other Securities)',1,1,4,NULL,NULL,1,GETDATE())
END