/* --- Add Com_CodeGroup And Resorce Key ------*/
IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 64)
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(64 ,'Upsi','Upsi','/UpsiDigital/Index',5000,NULL,102001,'icon icon-users',NULL,11,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 122108)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 122108,'Upsi Sharing',122,'Upsi Sharing',1,1,1,NULL,NULL,1,getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 103304)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 103304,'Upsi',103,'Upsi',1,1,1,NULL,NULL,1,getdate())
END


IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 103305)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 103305,'Upsi Sharing Document',103,'Upsi Sharing Document',1,1,1,NULL,NULL,1,getdate())
END
------- Add Grid type----------------------
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 114122)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 114122,'Upsi Sharing',114,'Upsi Sharing',1,1,1,NULL,NULL,1,getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 114123)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 114123,'Upsi Sharing Data',114,'Upsi Sharing Data',1,1,1,NULL,NULL,1,getdate())
END

-------------------------114122 Grid Resorce Open-------------------------------

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55001)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55001,'dis_grd_55001','Document Id','en-US',103304,104003, 122108,'Document Id',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55002)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55002,'dis_grd_55002','Name Of Receiver','en-US',103304,104003, 122108,'Name Of Receiver',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55003)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55003,'dis_grd_55003','Company Name','en-US',103304,104003, 122108,'Company Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55004)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55004,'dis_grd_55004','Pan Number','en-US',103304,104003, 122108,'Pan Number',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55005)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55005,'dis_grd_55005','Category of Infonmation Shared','en-US',103304,104003, 122108,'Category of Infonmation Shared',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55006)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55006,'dis_grd_55006','Reson For Sharing Information','en-US',103304,104003, 122108,'Reson For Sharing Information',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55007)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55007,'dis_grd_55007','Information Sent By','en-US',103304,104003, 122108,'Information Sent By',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55008)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55008,'dis_grd_55008','Information Updated By','en-US',103304,104003, 122108,'Information Updated By',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55009)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55009,'dis_grd_55009','Date And Time Of Sharing','en-US',103304,104003, 122108,'Date And Time Of Sharing',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55010)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55010,'dis_grd_55010','Mode Of Communication','en-US',103304,104003, 122108,'Mode Of Communication',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55011)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55011,'dis_grd_55011','Date Of Publishing','en-US',103304,104003, 122108,'Date Of Publishing',1,GETDATE())
END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55038)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (55038,'dis_grd_55038','Action','en-US',103304,104003, 122108,'Action',1,GETDATE())
--END
-------------------------114122 Grid Resorce Close-------------------------------

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55012)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55012,'cmp_btn_55012','Add UPSI','en-US',103304,104004, 122108,'Add UPSI',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55013)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55013,'usr_lbl_55013','Add UPSI Sharing Information','en-US',103304,104002, 122108,'Add UPSI Sharing Information',1,GETDATE())
END


-------------------------114122 Grid Header Open-------------------------------
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55001')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55001',	1,	1,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55002')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55002',	1,	2,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55003')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55003',	1,	3,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55004')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55004',	1,	4,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55005')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55005',	1,	5,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55006')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55006',	1,	6,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55007')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55007',	1,	7,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55008')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55008',	1,	8,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55009')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55009',	1,	9,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55010')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55010',	1,	10,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55011')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114122,	'dis_grd_55011',	1,	11,	0,	155001,	NULL,NULL)
END


--IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114122 and ResourceKey='dis_grd_55038')
--BEGIN
--INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
--VALUES (114122,	'dis_grd_55038',	1,	12,	0,	155001,	NULL,NULL)
--END
-------------------------114122 Grid Header Open-------------------------------
---------- Add  114123 Upsi Sharing Data Header-------------------

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55015')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55015',	1,	1,	0,	155001,	NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55016')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55016',	1,	2,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55017')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55017',	1,	3,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55018')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55018',	1,	4,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55019')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55019',	1,	5,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55020')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55020',	1,	6,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55021')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55021',	1,	7,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55022')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55022',	1,	8,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55023')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55023',	1,	9,	0,	155001,	NULL,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114123 and ResourceKey='dis_grd_55024')
BEGIN
INSERT INTO com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
VALUES (114123,	'dis_grd_55024',	1,	10,	0,	155001,	NULL,NULL)
END

-------------------------114123 Grid Header Close-------------------------------

------------------------resorce 114123 key Add create UPSI Record ---------------------------------

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55015)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55015,'dis_grd_55015','Company Name','en-US',103305,104003, 122108,'Company Name',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55016)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55016,'dis_grd_55016','Company Address','en-US',103305,104003, 122108,'Company Address',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55017)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55017,'dis_grd_55017','Shared by','en-US',103305,104003, 122108,'Shared by',1,GETDATE())
END

--IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55018)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (55018,'dis_grd_55018','Reason sharing','en-US',103305,104003, 122108,'Reason sharing',1,GETDATE())
--END

--IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55019)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (55019,'dis_grd_55019','Address','en-US',103305,104003, 122108,'Address',1,GETDATE())
--END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55020)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55020,'dis_grd_55020','PAN','en-US',103305,104003, 122108,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55021)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55021,'dis_grd_55021','Name','en-US',103305,104003, 122108,'Name',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55022)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55022,'dis_grd_55022','Phone','en-US',103305,104003, 122108,'Phone',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55023)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55023,'dis_grd_55023','Email','en-US',103305,104003, 122108,'Email',1,GETDATE())
END

--IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = 55024)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (55024,'dis_grd_55024','Shared by','en-US',103305,104003, 122108,'Shared by',1,GETDATE())
--END

------------------------resorce 114123 key End Add create UPSI Record END ---------------------------------

-----------------------Upsi create label Resorce Key -----------------------------------------------

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55027)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55027,'usr_lbl_55027','Company Name','en-US',103304,104002, 122108,'Company Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55028)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55028,'usr_lbl_55028','Company Address','en-US',103304,104002, 122108,'Company Address',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55029)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55029,'usr_lbl_55029','Category Shared','en-US',103304,104002, 122108,'Category Shared',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55030)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55030,'usr_lbl_55030','Reason Sharing','en-US',103304,104002, 122108,'Reason Sharing',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55031)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55031,'usr_lbl_55031','Comments','en-US',103304,104002, 122108,'Comments',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55032)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55032,'usr_lbl_55032','PAN','en-US',103304,104002, 122108,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55033)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55033,'usr_lbl_55033','Name','en-US',103304,104002, 122108,'Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55034)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55034,'usr_lbl_55034','Phone','en-US',103304,104002, 122108,'Phone',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55035)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55035,'usr_lbl_55035','Email','en-US',103304,104002, 122108,'Email',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55036)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55036,'usr_lbl_55036','Sharing Date','en-US',103304,104002, 122108,'Sharing Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55037)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55037,'usr_lbl_55037','Publish Date','en-US',103304,104002, 122108,'Publish Date',1,GETDATE())
END


-----------------------Upsi label Resorce Key Close -----------------------------------------------

-----------------------  Code grup -----------------------------------------------
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 518)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 518,'Category Of financial','Category Of financial',1,1,NULL)
END

IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 519)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 519,'Reason For Sharing','Reason For Sharing',1,1,NULL)
END

IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 520)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 520,'Mode Of Sharing','Mode Of Sharing',1,1,NULL)
END

-----------------------  Code grup END-----------------------------------------------

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 518001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 518001,'Financials',518,'Financials',1,1,1,NULL,NULL,1,getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 518002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 518002,'Financials1',518,'Financials1',1,1,2,NULL,NULL,1,getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 518003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 518003,'Financials2',518,'Financials2',1,1,3,NULL,NULL,1,getdate())
END
-----------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 519001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 519001,'Board Meeting',519,'Board Meeting',1,1,1,NULL,NULL,1,getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 519002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 519002,'Defect Document',519,'Defect Document',1,1,2,NULL,NULL,1,getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 519003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 519003,'Defect Document1',519,'Defect Document1',1,1,3,NULL,NULL,1,getdate())
END
-----------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 520001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 520001,'Email',520,'Email',1,1,1,NULL,NULL,1,getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 520002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 520002,'Email1',520,'Email1',1,1,2,NULL,NULL,1,getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 520003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 520003,'Email3',520,'Email3',1,1,3,NULL,NULL,1,getdate())
END

------------------------Add Resorce label key On Create records Open-------------------------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55039)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55039,'usr_lbl_55039','Document Number','en-US',103304,104002, 122108,'Document Number',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55040)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55040,'usr_lbl_55040','Category Of Financial','en-US',103304,104002, 122108,'Category Of Financial',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55041)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55041,'usr_lbl_55041','Reason For Sharing','en-US',103304,104002, 122108,'Reason For Sharing',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55042)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55042,'usr_lbl_55042','Comments','en-US',103304,104002, 122108,'Comments',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55043)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55043,'usr_lbl_55043','Mode Of Sharing','en-US',103304,104002, 122108,'Mode Of Sharing',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55044)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55044,'usr_lbl_55044','Sharing Date','en-US',103304,104002, 122108,'Sharing Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55045)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55045,'usr_lbl_55045','Sharing Time','en-US',103304,104002, 122108,'Sharing Time',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55046)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55046,'usr_lbl_55046','Publish Date','en-US',103304,104002, 122108,'Publish Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55047)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55047,'usr_lbl_55047','Multi Select User','en-US',103304,104002, 122108,'Multi Select User',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55048)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55048,'usr_lbl_55048','Name Of Person','en-US',103304,104002, 122108,'Name Of Person',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55049)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55049,'usr_lbl_55049','PAN','en-US',103304,104002, 122108,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55050)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55050,'usr_lbl_55050','Company Name','en-US',103304,104002, 122108,'Company Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55051)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55051,'usr_lbl_55051','Company Address','en-US',103304,104002, 122108,'Company Address',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55052)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55052,'usr_lbl_55052','Phone','en-US',103304,104002, 122108,'Phone',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55053)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55053,'usr_lbl_55053','Email','en-US',103304,104002, 122108,'Email',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55054)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55054,'usr_lbl_55054','Shared By','en-US',103304,104002, 122108,'Shared By',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55055)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55055,'usr_lbl_55055','Other User ','en-US',103304,104002, 122108,'Other User',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55056)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55056,'usr_lbl_55056',' Me ','en-US',103304,104002, 122108,'Me',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55057)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55057,'usr_lbl_55057','Other User','en-US',103304,104002, 122108,'Other User',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55058)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55058,'usr_lbl_55058','Add','en-US',103304,104002, 122108,'Add',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55059)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55059,'usr_lbl_55059','UPSI Sharing','en-US',103304,104002, 122108,'UPSI Sharing',1,GETDATE())   
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55060)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55060,'cmp_btn_55060','Save All','en-US',103304,104004, 122108,'Save All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55061)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55061,'usr_lbl_55061','UPSI Publish Date','en-US',103304,104002, 122108,'UPSI Publish Date',1,GETDATE())   
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55062)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55062,'cmp_btn_55062','Save','en-US',103304,104004, 122108,'Save',1,GETDATE())
END

------------------------Add Resorce label key On Create records Close-------------------------------------------------------

------------------------Add Resorce label key On Create Sharing records Open-------------------------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55063)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55063,'usr_msg_55063','Date of Sharing should not be greater than todays date','en-US',103304,104001, 122108,'Date of Sharing should not be greater than todays date',1,GETDATE())
END
------------------------Add Resorce label key On Create Sharing records Close-------------------------------------------------------
------------------------Add Resorce label key On Employee And Co Non-Employee Chk Box records Open--------------------------

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55064)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55064,'usr_chk_55064','Allow sharing UPSI Information','en-US',103002,104002, 122004,'Allow sharing UPSI Information',1,GETDATE())   
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55065)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55065,'usr_chk_55065','Allow sharing UPSI Information','en-US',103002,104002, 122065,'Allow sharing UPSI Information',1,GETDATE())   
END
------------------------Add Resorce label key On Employee And Co Non-Employee Chk Box records Close--------------------------

-----------------------Delete unUsed Lable Resorse Key Open-----------------------------------------------
IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55027 AND ResourceValue='Company Name')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55027
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55028 AND ResourceValue='Company Address')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55028
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55029 AND ResourceValue='Category Shared')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55029
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55030 AND ResourceValue='Reason Sharing')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55030
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55031 AND ResourceValue='Comments')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55031
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55032 AND ResourceValue='PAN')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55032
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55033 AND ResourceValue='Name')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55033
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55034 AND ResourceValue='Phone')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55034
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55035 AND ResourceValue='Email')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55035
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55036 AND ResourceValue='Sharing Date')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55036
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55037 AND ResourceValue='Publish Date')
BEGIN
DELETE From mst_Resource  WHERE ResourceId = 55037
END

-----------------------Delete unUsed Lable Resorse Key Close-----------------------------------------------
-----------------------Update Lable And Button Resorse Key Open-----------------------------------------------

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55058)
BEGIN
	UPDATE mst_Resource SET ResourceKey='usr_btn_55058', CategoryCodeId=104004 WHERE ResourceId=55058
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55061)
BEGIN
	UPDATE mst_Resource SET ResourceKey='usr_ttl_55061', CategoryCodeId=104006 WHERE ResourceId=55061
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55013)
BEGIN
	UPDATE mst_Resource SET ResourceKey='usr_ttl_55013', CategoryCodeId=104006 WHERE ResourceId=55013
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55059)
BEGIN
	UPDATE mst_Resource SET ResourceKey='usr_ttl_55059', CategoryCodeId=104006 WHERE ResourceId=55059
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55040)
BEGIN
	UPDATE mst_Resource SET ResourceValue='Category Of Financial Information', OriginalResourceValue='Category Of Financial Information' WHERE ResourceId=55040
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55055)
BEGIN
	UPDATE mst_Resource SET ResourceValue='Name of Other User', OriginalResourceValue='Name of Other User' WHERE ResourceId=55055
END
-----------------------Update Lable And Button Resorse Key Close-----------------------------------------------

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'usr_UserInfo' AND COLUMN_NAME = 'AllowUpsiUser')
BEGIN
  ALTER TABLE usr_UserInfo ADD AllowUpsiUser bit; 
END
GO
----------------------------Add Back Button Resorce Name ------------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55066)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55066,'usr_btn_55066','Back','en-US',103304,104004, 122108,'Back',1,GETDATE())
END
-------------------------------------------------------------------------------------------------------
----------------------Update Menu Name -------------------------------------------------------
IF EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 64 AND MenuName='Upsi')
BEGIN
	UPDATE mst_MenuMaster SET MenuName='UPSI Sharing', Description='UPSI Sharing' WHERE MenuID=64
END

---------------------------Update Menu Name Close-------------------------------------------------
---------------------------Update Grid Lable Name open-------------------------------------------------

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55005 AND ResourceKey='dis_grd_55005')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Category of Information Shared', OriginalResourceValue='Category of Information Shared' WHERE ResourceId=55005
END
---------------------------Update Grid Lable Name Close-------------------------------------------------

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55048 AND ResourceKey='usr_lbl_55048')
BEGIN
	UPDATE mst_Resource SET ResourceValue='Name Of Receiver', OriginalResourceValue='Name Of Receiver' WHERE ResourceId=55048
END
-------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55067)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55067,'usr_msg_55067','Please enter characters only','en-US',103304,104001, 122108,'Please enter characters only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55068)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55068,'usr_msg_55068','Enter Valid PAN Card Number.','en-US',103304,104001, 122108,'Enter Valid PAN Card Number.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55069)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55069,'usr_msg_55069','Mobile no. should be min. 3 & max. 15 digits (including +)','en-US',103304,104001, 122108,'Mobile no. should be min. 3 & max. 15 digits (including +)',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55070)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55070,'usr_msg_55070','Please enter a valid e-mail address.','en-US',103304,104001, 122108,'Please enter a valid e-mail address.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55071)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55071,'usr_msg_55071','Publish Date should not be less than Sharing Date','en-US',103304,104001, 122108,'Publish Date should not be less than Sharing Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55072)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55072,'usr_msg_55072','Publish Date saved successfully','en-US',103304,104001, 122108,'Publish Date saved successfully',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55073)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55073,'usr_msg_55073','The Publish Date field is required.','en-US',103304,104001, 122108,'The Publish Date field is required.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55074)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55074,'usr_lbl_55074','Registered User','en-US',103304,104002, 122108,'Registered User',1,GETDATE())   
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55075)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55075,'usr_lbl_55075','Other User','en-US',103304,104002, 122108,'Other User',1,GETDATE())   
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55076)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55076,'usr_lbl_55076','Select User Type','en-US',103304,104002, 122108,'Select User Type',1,GETDATE())   
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5706)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5706,4,51,4,NULL,NULL)
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5707)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5707,4,52,4,NULL,NULL)
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5708)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5708,4,53,4,NULL,NULL)
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5709)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5709,4,54,4,NULL,NULL)
END



IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55077)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55077,'usr_msg_55077','UPSI Sharing details saved successfully','en-US',103304,104001, 122108,'UPSI Sharing details saved successfully',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55078)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55078,'rl_btn_55078','Download','en-US',103304,104004, 122108,'Download',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55079)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55079,'usr_msg_55079','No records found for download','en-US',103304,104001, 122108,'No records found for download',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55080)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55080,'usr_btn_55080','Download Digital Database','en-US',103304,104004, 122108,'Download Digital Database',1,GETDATE())
END
