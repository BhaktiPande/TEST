/*
Script received from Gaurishankar on 12 May 2016 

Applicability Changes - 
1 Added All Co functionality.
2 Added All Corporate insider functionality. 
3 Added All Non Employee insider functionality. 
4 Added All Employee non insider functionality. 
5 Added new filter Category, SubCategory & Role for Employee applicability.
6 Added select Employee non insider functionality.
*/

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'RoleId')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  RoleId INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'Category')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  Category INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'SubCategory')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  SubCategory INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'AllCo')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  AllCo BIT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'AllCorporateEmployees')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  AllCorporateEmployees BIT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'AllNonEmployee')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  AllNonEmployee BIT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrDepartmentCodeId')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrDepartmentCodeId INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrGradeCodeId')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrGradeCodeId INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrDesignationCodeId')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrDesignationCodeId INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrRoleId')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrRoleId INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrCategory')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrCategory INT  null 
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_ApplicabilityDetails' AND COLUMN_NAME = 'NonInsFltrSubCategory')
BEGIN
	ALTER TABLE rul_ApplicabilityDetails ADD  NonInsFltrSubCategory INT  null 
END
GO




/*
Script received from Gaurishankar on 12 May 2016 - Resources & Grid Header Settings for applicability.
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15448)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15448, 'rul_grd_15448', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1	,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15449)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15449, 'rul_grd_15449', 'Sub Category', 'Sub Category', 'en-US', 103006 , 104003 , 122041 , 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15450)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15450, 'rul_grd_15450', 'Role', 'Role', 'en-US', 103006, 104003 , 122041, 1, GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15451)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15451, 'rul_grd_15451', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15452)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15452, 'rul_grd_15452', 'Sub Category', 'Sub Category','en-US', 103006, 104003, 122041, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15453)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15453, 'rul_grd_15453', 'Role', 'Role', 'en-US', 103006, 104003, 122041, 1, GETDATE())
END		
		
		
		
		




/*
	Script received from Gaurishankar on 12 May 2016 -  Code Grid Ids for applicability.
*/


IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114089)
BEGIN
	INSERT INTO com_Code 
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(114089 , 'Applicability Search List - Employee', 114, 'Applicability Search List - Employee', 1, 1, 89, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114090)
BEGIN
	INSERT INTO com_Code 
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(114090, 'Applicability association Employee filter list',114,'Applicability association Employee filter list',1,1,90,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114091)
BEGIN
	INSERT INTO com_Code 
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(114091, 'Applicability Association - Non Insider Employee List', 114, '0Applicability Association - Non Insider Employee List', 1, 1, 91, NULL, NULL, 1, GETDATE())
END


IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15448')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114023,'rul_grd_15448',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15449')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114023,'rul_grd_15449',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15450')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114023,'rul_grd_15450',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15451')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114032,'rul_grd_15451',1,5,0,155001,NULL,NULL)
END
		
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15452')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114032,'rul_grd_15452',1,6,0,155001,NULL,NULL)
END		
		
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15453')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114032,'rul_grd_15453',1,7,0,155001,NULL,NULL)
END		
		
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'usr_grd_11228')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END		

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15046')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15046',1,2,0,155001,NULL,NULL)
END		

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15047')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15047',1,3,0,155001,NULL,NULL)
END				

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15048')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15048',1,4,0,155001,NULL,NULL)
END		
		
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15049')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15049',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15050')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15050',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15448')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15448',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15449')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15449',1,8,0,155001,NULL,NULL)
END		
		
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15450')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114089,'rul_grd_15450',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'usr_grd_11228')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15339')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15339',1,2,0,155001,NULL,NULL)
END	

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15340')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15340',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15341')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15341',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15451')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15451',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15452')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15452',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15453')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114090,'rul_grd_15453',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'usr_grd_11228')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15046')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'rul_grd_15046',1,2,0,155001,NULL,NULL)
END	

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15047')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'rul_grd_15047',1,3,0,155001,NULL,NULL)
END		

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15048')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'rul_grd_15048',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15049')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'rul_grd_15049',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15050')
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114091,'rul_grd_15050',1,6,0,155001,NULL,NULL)
END	



