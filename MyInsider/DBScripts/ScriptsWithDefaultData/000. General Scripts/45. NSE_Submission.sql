
-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 03-JAN-2017                                                 							=
-- Description : SCRIPTS FOR DOWNLOAD NSE DATA WITH     												=
-- ======================================================================================================

/* INSERT INTO com_CodeGroup */
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 508)
BEGIN
	INSERT INTO com_CodeGroup(CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable, ParentCodeGroupId) 
	VALUES (508,'Download NSE Data With','Download NSE Data With',1,0,null)
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508001)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508001,'Form C Softcopy',508,'Download NSE Data With - Form C Softcopy',1,1,1,'Download NSE Data With - Form C Softcopy',null,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508002)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508002,'Form C Hardcopy',508,'Download NSE Data With - Form C Hardcopy',1,1,1,'Download NSE Data With - Form C Hardcopy',null,1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50423)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50423,'dis_lbl_50423','Download NSE Data With','en-US',103009,104002,122057,'Download NSE Data With',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50424)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50424,'dis_btn_50424','Proceed','en-US',103009,104004,122057,'Proceed',1,GETDATE())
END


-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 04-JAN-2017                                                 							=
-- Description : SCRIPTS FOR DOWNLOAD NSE DATA WITH     												=
-- ======================================================================================================

/* last com code id=507006  code group id=508*/
/* module code id is 507007 */
/* Category Id is 104002 label */
/* Screen Code id is 507008*/
/* last mst_Resource id is 50424 */

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508003)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508003,'Download NSE Data With',508,'Resource Module - Download NSE Data With',1,1,1,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 154008)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,Description,IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	VALUES(154008,'In Progress',154,'Event Status - In Progress',1,1,8,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508004)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508004,'NSE Submission-For CO',508,'Screen - NSE Submission',1,1,1,NULL,NULL,1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50425)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50425,'nse_lbl_50425','Group Number','en-US',508003,104002,508004,'Group Number',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50426)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50426,'nse_lbl_50426','Download From Date','en-US',508003,104002,508004,'Download From Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50427)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50427,'nse_lbl_50427','Download To Date','en-US',508003,104002,508004,'Download To Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50428)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50428,'nse_lbl_50428','Submission From Date','en-US',508003,104002,508004,'Submission From Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50441)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50441,'nse_lbl_50441','Submission to Date','en-US',508003,104002,508004,'Submission To Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50429)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50429,'nse_lbl_50429','Submission Status','en-US',508003,104002,508004,'Submission Status',1,GETDATE())
END

-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 05-JAN-2017                                                 							=
-- Description : SCRIPTS FOR DOWNLOAD NSE DATA WITH     												=
-- ======================================================================================================


/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508005)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508005,'NSE Submission-Group Grid',508,'NSE Submission-For CO Group Grid',1,1,1,NULL,NULL,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508006)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508006,'Pending',508,'NSE Submission Status - Pending',1,1,2,NULL,NULL,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508007)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508007,'Submitted',508,'NSE Submission Status - Submitted',1,1,3,NULL,NULL,1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50430)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50430,'nse_grd_50430','Group No.','en-US',508003,104003,508004,'Group No',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50431)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50431,'nse_grd_50431','No.of Employees','en-US',508003,104003,508004,'No.of Employees',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50432)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50432,'nse_grd_50432','Download Date','en-US',508003,104003,508004,'Download Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50433)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50433,'nse_grd_50433','Submission Date','en-US',508003,104003,508004,'Submission Date',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'nse_grd_50430')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508005,'nse_grd_50430',1,1,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'nse_grd_50431')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508005,'nse_grd_50431',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'nse_grd_50432')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508005,'nse_grd_50432',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'nse_grd_50433')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508005,'nse_grd_50433',1,4,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' and GridTypeCodeId=508005)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508005,'usr_grd_11073',1,5,26,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50435)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50435,'nse_msg_50435','Group value does not exist','en-US',508003,104001,508004,'Group value does not exist',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50436)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50436,'nse_msg_50436','Error occurred while Group master creation','en-US',508003,104001,508004,'Error occurred while Group master creation',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50437)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50437,'nse_msg_50437','Group details does not exist','en-US',508003,104001,508004,'Group details does not exist',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50438)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50438,'nse_msg_50438','Error occurred while saving group details','en-US',508003,104001,508004,'Error occurred while saving group details',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50439)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50439,'nse_msg_50439','Error occurred while deleting group details','en-US',508003,104001,508004,'Error occurred while deleting group details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50440)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50440,'nse_msg_50440','Error occurred while fetching group creation data','en-US',508003,104001,508004,'Error occurred while fetching group creation data',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50443)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50443,'dis_btn_50443','In Progress','en-US',103009,104004,122044,'In Progress',1,GETDATE())
END

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='NSE Submission' and UPPER(ActivityName)='VIEW')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'NSE Submission','View','508003',NULL,'View NSE Submission Details',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
END

--INSERT SCRIPT FOR mst_MenuMaster
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE UPPER(MenuName) ='NSE Submission' and ParentMenuID='22')
	BEGIN
		INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		(SELECT MAX(MenuID) + 1 from mst_MenuMaster),'NSE Submission','NSE Submission',
		'/NSEDownload/Index?acid=223',2604,22,102001,NULL,NULL,223,1,GETDATE(),1,GETDATE()  
	)			
END

--INSERT SCRIPT FOR usr_RoleActivity
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='223' AND RoleID ='1')
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(223,1,1,GETDATE(),1,GETDATE())
	END

--INSERT SCRIPT FOR usr_RoleActivity
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='223' AND RoleID ='2')
	BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(223,2,1,GETDATE(),1,GETDATE())	
	END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'SAVENSEGROUP1') AND (UPPER(ControllerName) = 'PRECLEARANCEREQUEST'))
BEGIN			
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(167,'PreclearanceRequest','SaveNSEGroup1',NULL,1,getdate(),1,getdate())	
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'INDEX') AND (UPPER(ControllerName) = 'NSEDOWNLOAD'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(223,'NSEDownload','Index',NULL,1,getdate(),1,getdate())		
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 508008)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (508008,'Delete NSE Group Details',508,'Resource Module - Delete NSE Group Details',1,1,1,NULL,NULL,1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50444)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES(50444,'del_grd_50444','Name','en-US',508008,104002,508004,'Name',1,GETDATE())	
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50445)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50445,'del_grd_50445','Employee ID','en-US',508008,104002,508004,'Employee ID',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50446)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50446,'del_grd_50446','Pre-Clearance ID','en-US',508008,104002,508004,'Pre-Clearance ID',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50447)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50447,'del_grd_50447','Pre-Clearance Request Date','en-US',508008,104002,508004,'Pre-Clearance Request Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50448)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50448,'del_grd_50448','Pre-Clearance Status','en-US',508008,104002,508004,'Pre-Clearance Status',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50449)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50449,'del_grd_50449','Transaction Type','en-US',508008,104002,508004,'Transaction Type',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50450)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50450,'del_grd_50450','Securities','en-US',508008,104002,508004,'Securities',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50451)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50451,'del_grd_50451','Preclearance Qty','en-US',508008,104002,508004,'Preclearance Qty',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50452)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50452,'del_grd_50452','Trade Qty','en-US',508008,104002,508004,'Trade Qty',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50457)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50457,'del_grd_50457','Trading Details Submission','en-US',508008,104002,508004,'Trading Details Submission',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50453)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50453,'del_grd_50453','Disclosure Details: SoftCopy','en-US',508008,104002,508004,'Disclosure Details: SoftCopy',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50454)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50454,'del_grd_50454','Disclosure Details: HardCopy','en-US',508008,104002,508004,'Disclosure Details: HardCopy',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50455)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50455,'del_grd_50455','Submission to Stock Exchange','en-US',508008,104002,508004,'Submission to Stock Exchange',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50456)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50456,'del_grd_50456','Total Traded Value','en-US',508008,104002,508004,'Total Traded Value',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='usr_grd_11228' and GridTypeCodeId=508008)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'usr_grd_11228',1,0,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50444')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50444',1,1,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50445')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50445',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50446')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50446',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50447')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50447',1,4,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50448')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50448',1,5,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50449')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50449',1,6,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50450')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50450',1,7,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50451')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50451',1,8,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50452')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50452',1,9,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50453')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50453',1,11,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50454')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50454',1,12,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50455')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50455',1,13,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'del_grd_50456')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (508008,'del_grd_50456',1,10,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50499)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50499,'nse_btn_50499','Pending','en-US',508003,104002,508004,'Pending',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50500)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50500,'nse_btn_50500','Deleted','en-US',508003,104002,508004,'Deleted',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50506)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES(50506,'nse_lbl_50506','Group No','en-US',508008,104002,508004,'Group No',1,GETDATE())	
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50507)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50507,'nse_lbl_50507','Download Date','en-US',508008,104002,508004,'Download Date',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50508)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50508,'nse_lbl_50508','Submission Date','en-US',508008,104002,508004,'Submission Date',1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 132017)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (132017,'Nse Document-FormC',132,'Map To Type - Nse Document Form C',1,1,17,NULL,NULL,1,GETDATE())
END


/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 132018)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (132018,'Nse Document Upload',132,'Map To Type - Nse Document Upload',1,1,18,NULL,NULL,1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50509)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50509,'nse_lbl_50509','Please Select NSEDownload Data Option','en-US',508003,104002,508004,'Please Select NSEDownload Data Option',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50510)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50510,'nse_lbl_50510','NSE Submission','en-US',508003,104002,508004,'NSE Submission',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50511)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50511,'nse_lbl_50511','Upload Document','en-US',508003,104002,508004,'Upload Document',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50512)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50512,'nse_lbl_50512','Delete Group Details','en-US',508003,104002,508004,'Delete Group Details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50534)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50534,'nse_lbl_50534','Date of submission to NSE cannot be greater than today''s date','en-US',508003,104001,508004,'Date of initimation to company cannot be greater than today''s date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50535)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50535,'nse_lbl_50535','Submission date field is required','en-US',508003,104001,508004,'Submission date field is required',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50536)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50536,'nse_lbl_50536','Date of submission to NSE cannot be smaller than download date','en-US',508003,104001,508004,'Submission date field is required',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50544)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50544,'nse_msg_50544','Are you sure to download the data for the selected transactions?','en-US',103009,104001,122057,'Are you sure to download the data for the selected transactions?',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50545)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50545,'nse_msg_50545','Are you sure you want to submit the documents for the group?','en-US',508003,104001,508004,'Are you sure you want to submit the documents for the group?',1,GETDATE())
END