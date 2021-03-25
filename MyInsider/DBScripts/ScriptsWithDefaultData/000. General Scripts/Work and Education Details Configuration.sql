
IF NOT EXISTS (SELECT * from com_Code where CodeID=122101)
BEGIN
 INSERT INTO com_Code(CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,
 ParentCodeId,	ModifiedBy,	ModifiedOn)
 Values(
	122101,	'Personal Details Confirmation',	122,'Personal Details Confirmation Setting- Screen',	1,	1,	110,	
	NULL,	103005,	1,	GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=59001)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (59001,'cmp_ttl_59001','Work and Education Details Setting','en-US',103005,104006,122101,'Work and Education Details Setting',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=59002)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (59002,'com_btn_59002','Add/Save','en-US','103003','104004','122034','Add/Save',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=59003)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (59003,'com_btn_59003','Back','en-US',103003,104004,122034,'Back',1,GETDATE())
END


IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID=539)
BEGIN
	 INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,[Description],IsVisible,IsEditable,ParentCodeGroupId)
	 VALUES
	 (539,'Work and Education Details Configuration','Work and Education Details Configuration',1,0,NULL)
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=539001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (539001,'Yes',539,'Yes',1,1,'1',null,null,1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=539002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (539002,'No',539,'No',1,1,'2',null,null,1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=59004)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (59004,'cmp_ttl_59004','Work and Education Details Setting','en-US','103005','104006','122101','Work and Education Details Setting',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=59005)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (59005,'cmp_msg_59005','Work and Education Details Configuration saved successfully','en-US','103005','104002','122101','Work and Education Details Configuration saved successfully',1,GETDATE())
END


IF NOT EXISTS (SELECT * FROM com_WorkandEducationDetailsConfiguration where CompanyId = 1)
BEGIN
		INSERT INTO com_WorkandEducationDetailsConfiguration(CompanyId, WorkandEducationDetailsConfigurationId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		VALUES(1, 539001, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())
END







