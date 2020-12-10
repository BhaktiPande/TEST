-- ======================================================================================================
-- Author      : Tushar Wakchaure
-- CREATED DATE: 14-June-2019
-- Description : Script for Vedanta Preclearance Enhancement.
-- ======================================================================================================

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for CO' and UPPER(ActivityName)='Edit Pre-clearance Quantity' and ActivityID = 332)
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
		        [Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(332,'Disclosure Details for CO','Edit Pre-clearance Quantity','103008',NULL,'Edit Pre-clearance Quantity',105001,' ',1,GETDATE(),1,GETDATE())
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (332,'101001')
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (332,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for CO' and UPPER(ActivityName)='Edit Pre-clearance Validity' and ActivityID = 333)
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
		        [Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(333,'Disclosure Details for CO','Edit Pre-clearance Validity','103008',NULL,'Edit Pre-clearance Validity',105001,' ',1,GETDATE(),1,GETDATE())
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (333,'101001')
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (333,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='332' AND RoleID = '1')
BEGIN
	INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(332,1,1,GETDATE(),1,GETDATE())		
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='333' AND RoleID = '1')
BEGIN
	INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(333,1,1,GETDATE(),1,GETDATE())		
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52112)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52112,'tra_lbl_52112','Securities approved to be traded','en-US',103009,104002,122051,'Securities approved to be traded',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52113)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52113,'tra_lbl_52113','Change Preclearance Validity Date','en-US',103009,104002,122051,'Change Preclearance Validity Date',1,GETDATE())
END

IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 524)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES (524,'PreClearance Editable Functionality','PreClearance Editable Functionality',1,1,NULL)
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 524001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES (524001,'PreClearanceEditable Required',524,'PreClearanceEditable Required',1,1,1,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 524002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES (524002,'PreClearanceEditable Not Required',524,'PreClearanceEditable Not Required',1,1,1,NULL,NULL,1,GETDATE())
END

--Add column in mst_company
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'mst_company' AND SYSCOL.NAME = 'IsPreClearanceEditable')
BEGIN
	ALTER TABLE mst_company ADD IsPreClearanceEditable INT NOT NULL DEFAULT(524002)
END

--Add column in tra_PreclearanceRequest
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'tra_PreclearanceRequest' AND SYSCOL.NAME = 'SecuritiesToBeTradedQtyOld')
BEGIN
	ALTER TABLE tra_PreclearanceRequest ADD SecuritiesToBeTradedQtyOld DECIMAL(15,4) NOT NULL DEFAULT(0)
END
GO
--Copy data from column "SecuritiesToBeTradedQty" to "SecuritiesToBeTradedQtyOld" of tra_PreclearanceRequest table.
--------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT SecuritiesToBeTradedQtyOld FROM tra_PreclearanceRequest WHERE SecuritiesToBeTradedQtyOld = 0.0000)
BEGIN
  UPDATE tra_PreclearanceRequest SET SecuritiesToBeTradedQtyOld = SecuritiesToBeTradedQty WHERE SecuritiesToBeTradedQtyOld = 0.0000
END
--------------------------------------------------------------------------------------------------------------------------------------

--Add column in tra_PreclearanceRequest
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'tra_PreclearanceRequest' AND SYSCOL.NAME = 'PreclearanceValidityDateOld')
BEGIN
	ALTER TABLE tra_PreclearanceRequest ADD PreclearanceValidityDateOld DATETIME NULL
END

--Add column in tra_PreclearanceRequest
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'tra_PreclearanceRequest' AND SYSCOL.NAME = 'PreclearanceValidityDateUpdatedByCO')
BEGIN
	ALTER TABLE tra_PreclearanceRequest ADD PreclearanceValidityDateUpdatedByCO DATETIME NULL
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52114)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52114,'tra_lbl_52114','Preclearance Validity Date','en-US',103009,104002,122051,'Preclearance Validity Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52115)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52115,'tra_msg_52115','The Securities Approve field is required','en-US',103009,104001,122051,'The Securities Approve field is required',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52116)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52116,'tra_msg_52116','Change Preclearance Validity Date field is required','en-US',103009,104001,122051,'Change Preclearance Validity Date field is required',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52117)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52117,'tra_msg_52117','Updated Securities To Be Traded quantity should not be same or greater than actual Securities To Be Traded quantity.','en-US',103009,104001,122051,'Updated Securities To Be Traded quantity should not be same or greater than actual Securities To Be Traded quantity.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52118)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52118,'tra_msg_52118','Updated Preclearance Validity Date should be after Preclearance Approval date and before the actual Preclearance Validity Date.','en-US',103009,104001,122051,'Updated Preclearance Validity Date should not be same or before the actual Preclearance Validity Date.',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52119)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52119,'tra_msg_52119','Error occurred while getting Preclearance Validity Date Request.','en-US',103009,104001,122051,'Error occurred while getting Preclearance Validity Date Request.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52120)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52120,'tra_msg_52120','Error occurred while validating Preclearance Validity Date Request.','en-US',103009,104001,122051,'Error occurred while validating Preclearance Validity Date Request.',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52121)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52121,'tra_msg_52121','Updated Preclearance Validity Date should not be in between window close and open date.','en-US',103009,104001,122051,'Updated Preclearance Validity Date should not be in between window close and open date.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52122)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52122,'tra_msg_52122','Updated Preclearance Validity Date should not be in non trading days.','en-US',103009,104001,122051,'Updated Preclearance Validity Date should not be in non trading days.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52123)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52123,'dis_grd_52123','Preclearance Approved Qty','en-US',103009,104003,122051,'Preclearance Approved Qty',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_52123')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114049,'dis_grd_52123',1,8,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52124)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52124,'dis_grd_52124','Preclearance Approved Qty','en-US',103009,104003,122051,'Preclearance Approved Qty',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_52124')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114038,'dis_grd_52124',1,7,0,155001,NULL,NULL)
END

--Add column in tra_ContinuousDisc
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'tra_ContinuousDisc' AND SYSCOL.NAME = 'PreClearance_Qty_Old')
BEGIN
	ALTER TABLE tra_ContinuousDisc ADD PreClearance_Qty_Old DECIMAL(15,4) NULL
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52126)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52126,'tra_lbl_52126','Change Preclearance Validity Date','en-US',103009,104002,122051,'Change Preclearance Validity Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52127)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52127,'tra_lbl_52127','Preclearance Taken Qty','en-US',103009,104002,122051,'Preclearance Taken Qty',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52128)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52128,'tra_lbl_52128','Preclearance Validity Date','en-US',103009,104002,122051,'Preclearance Validity Date',1,GETDATE())
END

--Novit
--Add column on preclearance report

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52131)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52131,'usr_grd_52131','Updated Number of Securities','en-US',103011,104003,122063,'Updated Number of Securities',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52132)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52132,'usr_grd_52132','Preclearance Comments','en-US',103011,104003,122063,'Preclearance Comments',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52133)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52133,'usr_grd_52133','Updated Validity','en-US',103011,104003,122063,'Updated Validity',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_52131')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114062,'usr_grd_52131',1,80001,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_52132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114062,'usr_grd_52132',1,100001,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_52133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114062,'usr_grd_52133',1,120001,0,155001,NULL,NULL)
END

------------  Added PlaceHolders for Preclearance Mail----------------

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_SECURITY_TO_BE_TRADE_QTY_UPDATEDBY_CO|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES ('|~|PRE_CLEAR_SECURITY_TO_BE_TRADE_QTY_UPDATEDBY_CO|~|', 'Preclearance Approved Quantity updatded by CO', 156002, 'Preclearance Approved Quantity updatded by CO for editable preclearance', 1, 52, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_EXPIRY_DATE_UPDATEDBY_CO|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES ('|~|PRE_CLEAR_EXPIRY_DATE_UPDATEDBY_CO|~|', 'Preclearance expiry date updatded by CO', 156002, 'Preclearance expiry date updatded by CO for editable preclearance', 1, 53, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_COMMENTS_UPDATEDBY_CO|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES ('|~|PRE_CLEAR_COMMENTS_UPDATEDBY_CO|~|', 'Preclearance comments updatded by CO', 156002, 'Preclearance comments updatded by CO for editable preclearance', 1, 54, 1, GETDATE(), 1, GETDATE())
END