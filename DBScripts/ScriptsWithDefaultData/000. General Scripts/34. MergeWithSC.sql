/*
	Script from Parag on 4-Aug-2016
	Added table to stored configuration related to security type
*/

-- ADD if not exists statement for every statement 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SecurityConfiguration]') AND type in (N'U'))
BEGIN
	CREATE TABLE SecurityConfiguration
	(
		SecurityTypeCodeId INT CONSTRAINT FK_SecurityConfiguration_SecurityTypeCodeId_com_Code_CodeID FOREIGN KEY(SecurityTypeCodeId)REFERENCES com_Code(CodeID),
		SecurityValueConstraint INT CONSTRAINT FK_SecurityConfiguration_SecurityValueConstraint_com_Code_CodeID FOREIGN KEY(SecurityValueConstraint)REFERENCES com_Code(CodeID),
	)
END
/*Added group and code for allowed negative value or not

GroupId: 179
Security configuration for values 
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 179)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(179, NULL, 'Security Configuraiton - Security values constraint', 'Security Configuraiton - Security values constraint', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 179001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(179001, NULL, 'Allowed positive values only', NULL, 179, 'Allowed positive values only', 1, 1, GETDATE(), 1)		
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 179002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES		
		(179002, NULL, 'Allowed positive and negative values', NULL, 179, 'Allowed positive and negative values', 1, 1, GETDATE(), 2)
END

/*
	Script received from Tushar 9 Aug 2016
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16444)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(16444, 'tra_msg_16444', 'Error occurred while checking negative balance for secuirty.', 'en-US', 103008, 104001, 122036, 'Error occurred while checking negative balance for secuirty.', 1, GETDATE())
END
/*
Added configuration values for security type
*/
IF NOT EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139001, 179001) -- Shares
END

IF NOT EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = 139002)
BEGIN
	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139002, 179001) -- Warrants
END

IF NOT EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = 139003)
BEGIN
	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139003, 179001) -- Convertible Debentures
END

IF NOT EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = 139004)
BEGIN
	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139004, 179001) -- Future Contracts
END

IF NOT EXISTS(SELECT SecurityTypeCodeId FROM SecurityConfiguration WHERE SecurityTypeCodeId = 139005)
BEGIN
	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139005, 179001) -- Option Contracts
END

/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Map the resources with the grid and the Overriden grid*/

/*
Add security type column to default transaction grid i.e. 114031
*/
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL) 
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',NULL,1,0,0,155001,NULL)
END

/*
For grid type code id 114083
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16333')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16001',114083,1,0,0,155001,'tra_grd_16333')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16334')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114083,1,1,0,155001,'tra_grd_16334')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16335')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114083,1,2,0,155001,'tra_grd_16335')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16336')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114083,1,3,0,155001,'tra_grd_16336')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16337')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114083,1,4,0,155001,'tra_grd_16337')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16338')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114083,1,5,0,155001,'tra_grd_16338')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16339')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114083,1,6,0,155001,'tra_grd_16339')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16340')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114083,1,7,0,155001,'tra_grd_16340')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16341')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114083,1,8,0,155001,'tra_grd_16341')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16342')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114083,1,9,0,155001,'tra_grd_16342')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16343')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16010',114083,1,10,0,155001,'tra_grd_16343')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16344')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114083,1,11,0,155001,'tra_grd_16344')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16345')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114083,1,12,0,155001,'tra_grd_16345')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16346')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114083,1,13,0,155001,'tra_grd_16346')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16347')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114083,1,14,0,155001,'tra_grd_16347')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114083 AND OverrideResourceKey = 'tra_grd_16348')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114083,1,15,0,155001,'tra_grd_16348')
END


/*
For grid type code id 114084
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16349')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16001',114084,1,0,0,155001,'tra_grd_16349')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16350')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114084,1,1,0,155001,'tra_grd_16350')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16351')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114084,1,2,0,155001,'tra_grd_16351')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16352')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114084,1,3,0,155001,'tra_grd_16352')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16353')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114084,1,4,0,155001,'tra_grd_16353')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16354')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114084,1,5,0,155001,'tra_grd_16354')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16355')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114084,1,6,0,155001,'tra_grd_16355')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16356')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114084,1,7,0,155001,'tra_grd_16356')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16357')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114084,1,8,0,155001,'tra_grd_16357')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16358')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114084,1,9,0,155001,'tra_grd_16358')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16359')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16010',114084,1,10,0,155001,'tra_grd_16359')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16360')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114084,1,11,0,155001,'tra_grd_16360')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16361')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114084,1,12,0,155001,'tra_grd_16361')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16362')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114084,1,13,0,155001,'tra_grd_16362')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16363')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114084,1,14,0,155001,'tra_grd_16363')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114084 AND OverrideResourceKey = 'tra_grd_16364')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114084,1,15,0,155001,'tra_grd_16364')
END

/*
For grid type code id 114085
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16365')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
   (114031,'tra_grd_16001',114085,1,0,0,155001,'tra_grd_16365')
END   
   
   
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16366')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114085,1,1,0,155001,'tra_grd_16366')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16367')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114085,1,2,0,155001,'tra_grd_16367')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16368')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114085,1,3,0,155001,'tra_grd_16368')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16369')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114085,1,4,0,155001,'tra_grd_16369')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16370')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114085,1,5,0,155001,'tra_grd_16370')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16371')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114085,1,6,0,155001,'tra_grd_16371')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16372')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114085,1,7,0,155001,'tra_grd_16372')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16373')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114085,1,8,0,155001,'tra_grd_16373')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16374')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114085,1,9,0,155001,'tra_grd_16374')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16375')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16010',114085,1,10,0,155001,'tra_grd_16375')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16376')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114085,1,11,0,155001,'tra_grd_16376')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16377')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114085,1,12,0,155001,'tra_grd_16377')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16378')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114085,1,13,0,155001,'tra_grd_16378')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16379')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114085,1,14,0,155001,'tra_grd_16379')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114085 AND OverrideResourceKey = 'tra_grd_16380')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114085,1,15,0,155001,'tra_grd_16380')
END

/*
For grid type code id 114086
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16381')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
   (114031,'tra_grd_16001',114086,1,0,0,155001,'tra_grd_16381')
END


IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16382')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114086,1,1,0,155001,'tra_grd_16382')
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16383')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114086,1,2,0,155001,'tra_grd_16383')
END
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16384')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114086,1,3,0,155001,'tra_grd_16384')
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16385')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114086,1,4,0,155001,'tra_grd_16385')
END
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16386')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114086,1,5,0,155001,'tra_grd_16386')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16387')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114086,1,6,0,155001,'tra_grd_16387')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16388')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114086,1,7,0,155001,'tra_grd_16388')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16389')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114086,1,8,0,155001,'tra_grd_16389')
ENd	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16390')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114086,1,9,0,155001,'tra_grd_16390')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16391')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
(114031,'tra_grd_16010',114086,1,10,0,155001,'tra_grd_16391')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16392')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114086,1,11,0,155001,'tra_grd_16392')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16393')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114086,1,12,0,155001,'tra_grd_16393')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16394')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114086,1,13,0,155001,'tra_grd_16394')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16395')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114086,1,14,0,155001,'tra_grd_16395')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114086 AND OverrideResourceKey = 'tra_grd_16396')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114086,1,15,0,155001,'tra_grd_16396')
END


/*
For grid type code id 114087
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16397')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16001',114087,1,0,0,155001,'tra_grd_16397')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16398')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114087,1,1,0,155001,'tra_grd_16398')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16399')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114087,1,2,0,155001,'tra_grd_16399')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16400')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114087,1,3,0,155001,'tra_grd_16400')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16401')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114087,1,4,0,155001,'tra_grd_16401')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16402')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114087,1,5,0,155001,'tra_grd_16402')
ENd	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16403')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114087,1,6,0,155001,'tra_grd_16403')
ENd

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16404')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114087,1,7,0,155001,'tra_grd_16404')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16405')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114087,1,8,0,155001,'tra_grd_16405')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16406')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114087,1,9,0,155001,'tra_grd_16406')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16407')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16010',114087,1,10,0,155001,'tra_grd_16407')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16408')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114087,1,11,0,155001,'tra_grd_16408')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16409')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114087,1,12,0,155001,'tra_grd_16409')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16410')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114087,1,13,0,155001,'tra_grd_16410')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16411')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114087,1,14,0,155001,'tra_grd_16411')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114087 AND OverrideResourceKey = 'tra_grd_16412')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114087,1,15,0,155001,'tra_grd_16412')
END

/*
For grid type code id 114088
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16001' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16413')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16001',114088,1,0,0,155001,'tra_grd_16413')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16002' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16414')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16002',114088,1,1,0,155001,'tra_grd_16414')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16003' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16415')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16003',114088,1,2,0,155001,'tra_grd_16415')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16004' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16416')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16004',114088,1,3,0,155001,'tra_grd_16416')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16005' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16417')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16005',114088,1,4,0,155001,'tra_grd_16417')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16429' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16418')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16429',114088,1,5,0,155001,'tra_grd_16418')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16006' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16419')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16006',114088,1,6,0,155001,'tra_grd_16419')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16007' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16420')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16007',114088,1,7,0,155001,'tra_grd_16420')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16008' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16421')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16008',114088,1,8,0,155001,'tra_grd_16421')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16009' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16422')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16009',114088,1,9,0,155001,'tra_grd_16422')
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16010' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16423')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16010',114088,1,10,0,155001,'tra_grd_16423')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16011' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16424')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16011',114088,1,11,0,155001,'tra_grd_16424')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16012' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16425')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16012',114088,1,12,0,155001,'tra_grd_16425')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16013' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16426')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16013',114088,1,13,0,155001,'tra_grd_16426')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16014' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16427')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16014',114088,1,14,0,155001,'tra_grd_16427')
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey = 'tra_grd_16015' AND OverrideGridTypeCodeId = 114088 AND OverrideResourceKey = 'tra_grd_16428')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	VALUES
	(114031,'tra_grd_16015',114088,1,15,0,155001,'tra_grd_16428')
END


/*
For grid type code id 114049
Script received from Tushar on 2 May 2016 -- Change for show Total Traded Quantity (Stock Exchange Submission)
*/
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114049 AND ResourceKey = 'dis_grd_17448' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
	INSERT INTO com_GridHeaderSetting 
	(GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	values
	(114049,'dis_grd_17448',NULL,1,9,0,155001,NULL)
END


/*
Script received from Gaurishankar on 12 May 2016 - Resources & Grid Header Settings for applicability.
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15448' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114023,'rul_grd_15448',1,7,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15449' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES	
	(114023,'rul_grd_15449',1,8,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114023 AND ResourceKey = 'rul_grd_15450' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114023,'rul_grd_15450',1,9,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15451' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES	
	(114032,'rul_grd_15451',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15452' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114032,'rul_grd_15452',1,6,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114032 AND ResourceKey = 'rul_grd_15453' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114032,'rul_grd_15453',1,7,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'usr_grd_11228' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15046' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15046',1,2,0,155001,NULL,NULL)
END
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15047' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15047',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15048' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15048',1,4,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15049' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15049',1,5,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15050' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey) 
VALUES
	(114089,'rul_grd_15050',1,6,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15448' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15448',1,7,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15449' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15449',1,8,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114089 AND ResourceKey = 'rul_grd_15450' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114089,'rul_grd_15450',1,9,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'usr_grd_11228' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES	
	(114090,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15339' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15339',1,2,0,155001,NULL,NULL)
END
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15340' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15340',1,3,0,155001,NULL,NULL)
END
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15341' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15341',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15451' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15451',1,5,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15452' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15452',1,6,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114090 AND ResourceKey = 'rul_grd_15453' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114090,'rul_grd_15453',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'usr_grd_11228' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15046' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'rul_grd_15046',1,2,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15047' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'rul_grd_15047',1,3,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15048' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'rul_grd_15048',1,4,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15049' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'rul_grd_15049',1,5,0,155001,NULL,NULL)
END	
	
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114091 AND ResourceKey = 'rul_grd_15050' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)  
VALUES
	(114091,'rul_grd_15050',1,6,0,155001,NULL,NULL)
END

	
/*
Script from Parag on 16 May 2016 -  Grid heaader for employee details for policy document list
*/

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092 AND ResourceKey = 'tra_grd_16438' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114092, 'tra_grd_16438', 1, 1, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092 AND ResourceKey = 'tra_grd_16439' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114092, 'tra_grd_16439', 1, 2, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092 AND ResourceKey = 'tra_grd_16440' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114092, 'tra_grd_16440', 1, 3, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092 AND ResourceKey = 'tra_grd_16441' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114092, 'tra_grd_16441', 1, 4, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092 AND ResourceKey = 'tra_grd_16442' AND OverrideGridTypeCodeId IS NULL AND OverrideResourceKey IS NULL)
BEGIN
INSERT INTO com_GridHeaderSetting
	(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
VALUES
	(114092, 'tra_grd_16442', 1, 5, 0, 155001, NULL ,NULL)
END
	
	
/*
Script from Parag on 17 May 2016 - hide column "E-Mail sent Date" from list 
*/
update com_GridHeaderSetting set IsVisible = 0 where GridTypeCodeId = 114048 and ResourceKey = 'dis_grd_17250'



/*
Script from Raghvendra on 25-Apr-2016 -- 
Resource for the tooltip to be shown on mouse over of the Tabs seen on Personal details confirmation screen when personal details are not confirmed.
*/
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 11438)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11438,'usr_ttl_11438','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','en-US',103002,104005,122004,1, GETDATE())
END
/*
Script received from Tushar on 2 May 2016 -- 
Change for:- Tool tip to be provided for informing user to click on "Action" button to view his Demat details
*/
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 11439)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11439,'usr_ttl_11439','View DEMAT Details','View DEMAT Details','en-US',103002,104005,122015,1 , GETDATE())
END
/*
Script received from Raghvendra on 4-May-2016
Added the new resource message to be shown when user tries to add duplicate PAN number when creating/editing Employee/insider details
*/
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 11440)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(11440,'usr_msg_11440','The entered PAN number is used by another user, change the PAN number and try again.','en-US','103013','104001','122076','The entered PAN number is used by another user, change the PAN number and try again.',1,GETDATE())
END

/* Send by Tushar on 22-Mar-2015 */
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15447)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(15447,'rul_msg_15447', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'en-US', 103006, 104001,122040, 1, GETDATE())
END

/*
Script received from Gaurishankar on 12 May 2016 - Resources & Grid Header Settings for applicability.
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15448)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15448, 'rul_grd_15448', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1	,GETDATE())
END	

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15449)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15449, 'rul_grd_15449', 'Sub Category', 'Sub Category', 'en-US', 103006 , 104003 , 122041 , 1, GETDATE())
END	

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15450)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15450, 'rul_grd_15450', 'Role', 'Role', 'en-US', 103006, 104003 , 122041, 1, GETDATE())
END	

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15451)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15451, 'rul_grd_15451', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1, GETDATE())
END		

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15452)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15452, 'rul_grd_15452', 'Sub Category', 'Sub Category','en-US', 103006, 104003, 122041, 1, GETDATE())
END	
	
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15453)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(15453, 'rul_grd_15453', 'Role', 'Role', 'en-US', 103006, 104003, 122041, 1, GETDATE())
END		
	

	
/* Send by Tushar on 22-Apr-2015 */

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15454)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15454,'rul_ttl_15454', 'Contra Trade', 'Contra Trade', 'en-US', 103006, 104006,122040,1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15455)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15455,'rul_lbl_15455', 'Contra Trade Based On', 'Contra Trade Based On', 'en-US', 103006, 104002,122040,1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15456)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15456,'rul_lbl_15456', 'All Security Type', 'All Security Type', 'en-US', 103006, 104002,122040,1, GETDATE())
END
	
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15457)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15457,'rul_lbl_15457', 'Individual Security Type', 'Individual Security Type', 'en-US', 103006, 104002,122040,1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 15458)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15458,'rul_msg_15458', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'en-US', 103006, 104001,122040,1, GETDATE())
END


/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Add column resources for each of the new grids added

Resources for grid type codeid 114083
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16333)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16333 ,'tra_grd_16333' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16334)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16334 ,'tra_grd_16334' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16335)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16335 ,'tra_grd_16335' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16336)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16336 ,'tra_grd_16336' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16337)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16337 ,'tra_grd_16337' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16338)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16338 ,'tra_grd_16338' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16339)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16339 ,'tra_grd_16339' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16340)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16340 ,'tra_grd_16340' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16341)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16341 ,'tra_grd_16341' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16342)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16342 ,'tra_grd_16342' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16343)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16343 ,'tra_grd_16343' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16344)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16344 ,'tra_grd_16344' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16345)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16345 ,'tra_grd_16345' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16346)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16346 ,'tra_grd_16346' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16347)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16347 ,'tra_grd_16347' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16348)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16348 ,'tra_grd_16348' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE())
END


/*
Resources for grid type codeid 114084
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16349)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16349 ,'tra_grd_16349' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END
  
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16350)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16350 ,'tra_grd_16350' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16351)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16351 ,'tra_grd_16351' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16352)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16352 ,'tra_grd_16352' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16353)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16353 ,'tra_grd_16353' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END


IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16354)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16354 ,'tra_grd_16354' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16355)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16355 ,'tra_grd_16355' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16356)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16356 ,'tra_grd_16356' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16357)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16357 ,'tra_grd_16357' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16358)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16358 ,'tra_grd_16358' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16359)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16359 ,'tra_grd_16359' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16360)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16360 ,'tra_grd_16360' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16361)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16361 ,'tra_grd_16361' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16362)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16362 ,'tra_grd_16362' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16363)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16363 ,'tra_grd_16363' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16364)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16364 ,'tra_grd_16364' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE())
END


/*
Resources for grid type codeid 114085
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16365)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16365 ,'tra_grd_16365' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16366)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16366 ,'tra_grd_16366' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16367)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16367 ,'tra_grd_16367' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16368)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16368 ,'tra_grd_16368' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16369)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16369 ,'tra_grd_16369' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16370)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16370 ,'tra_grd_16370' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16371)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16371 ,'tra_grd_16371' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16372)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16372 ,'tra_grd_16372' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16373)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16373 ,'tra_grd_16373' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16374)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16374 ,'tra_grd_16374' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16375)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16375 ,'tra_grd_16375' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16376)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16376 ,'tra_grd_16376' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16377)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16377 ,'tra_grd_16377' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16378)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16378 ,'tra_grd_16378' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16379)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16379 ,'tra_grd_16379' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16380)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16380 ,'tra_grd_16380' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE())
END


/*
Resources for grid type codeid 114086
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16381)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16381 ,'tra_grd_16381' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16382)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16382 ,'tra_grd_16382' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16383)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16383 ,'tra_grd_16383' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16384)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16384 ,'tra_grd_16384' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16385)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16385 ,'tra_grd_16385' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16386)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16386 ,'tra_grd_16386' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16387)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16387 ,'tra_grd_16387' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16388)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16388 ,'tra_grd_16388' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16389)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16389 ,'tra_grd_16389' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16390)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16390 ,'tra_grd_16390' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16391)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16391 ,'tra_grd_16391' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16392)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16392 ,'tra_grd_16392' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16393)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16393 ,'tra_grd_16393' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16394)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16394 ,'tra_grd_16394' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16395)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16395 ,'tra_grd_16395' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16396)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16396 ,'tra_grd_16396' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE())
END

/*
Resources for grid type codeid 114087
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16397)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16397 ,'tra_grd_16397' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16398)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16398 ,'tra_grd_16398' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16399)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16399 ,'tra_grd_16399' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16400)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16400 ,'tra_grd_16400' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16401)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16401 ,'tra_grd_16401' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16402)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16402 ,'tra_grd_16402' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16403)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16403 ,'tra_grd_16403' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16404)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16404 ,'tra_grd_16404' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16405)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16405 ,'tra_grd_16405' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16406)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16406 ,'tra_grd_16406' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16407)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16407 ,'tra_grd_16407' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16408)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16408 ,'tra_grd_16408' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16409)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16409 ,'tra_grd_16409' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16410)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16410 ,'tra_grd_16410' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16411)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16411 ,'tra_grd_16411' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16412)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16412 ,'tra_grd_16412' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE())
END

/*
Resources for grid type codeid 114088
*/
IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16413)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16413 ,'tra_grd_16413' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16414)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16414 ,'tra_grd_16414' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16415)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16415 ,'tra_grd_16415' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16416)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16416 ,'tra_grd_16416' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16417)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16417 ,'tra_grd_16417' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16418)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16418 ,'tra_grd_16418' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16419)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16419 ,'tra_grd_16419' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16420)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16420 ,'tra_grd_16420' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16421)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16421 ,'tra_grd_16421' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16422)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16422 ,'tra_grd_16422' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16423)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16423 ,'tra_grd_16423' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16424)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16424 ,'tra_grd_16424' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16425)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16425 ,'tra_grd_16425' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16426)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16426 ,'tra_grd_16426' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16427)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16427 ,'tra_grd_16427' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16428)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16428 ,'tra_grd_16428' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE())
END

/*
Add resource for default Trading Transaction grid
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16429)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16429 ,'tra_grd_16429' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122036 ,1 ,GETDATE())
END


/*
Script from Tushar on 21 Apr 2016 -- for showing error message on validation negative balance
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16430)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(16430,'tra_msg_16430', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'en-US', 103008, 104001,122036,1, GETDATE())
END

/*
Script from Parag on 4 May 2016 -- 
Add resource for auto submit transaction error messages
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16431)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16431 ,'tra_msg_16431' ,'Error occured while auto submitting transaction' ,'Error occured while auto submitting transaction' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16432)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16432 ,'tra_msg_16432' ,'Error occured while auto submitting transaction initial disclosure' ,'Error occured while auto submitting transaction initial disclosure' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

/*
Script received from Parag on 12 May 2016 - Add resource for error messages when save user details on transaction details save
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16433)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16433 ,'tra_msg_16433' ,'Error occured while saving user details for transaction details submitted' ,'Error occured while saving user details for transaction details submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16434)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16434 ,'tra_msg_16434' ,'Error occured while saving user details for form submitted' ,'Error occured while saving user details for form submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

/*
Script from Parag on 16 May 2016 -  resources for grid type for employee details for policy document list
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16435)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16435, 'tra_lbl_16435' ,'Employee' ,'Employee' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16436)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16436, 'tra_lbl_16436' ,'Employee ID' ,'Employee ID' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16437)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16437, 'tra_lbl_16437' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16438)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16438, 'tra_grd_16438' ,'Employee Id' ,'Employee Id' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16439)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16439, 'tra_grd_16439' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16440)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16440, 'tra_grd_16440' ,'Designation' ,'Designation' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16441)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16441, 'tra_grd_16441' ,'Document Viewed' ,'Document Viewed' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16442)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16442, 'tra_grd_16442' ,'Document Accepted' ,'Document Accepted' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

/*
Script from Parag on 25 May 2016 -  resources for error message for security post acquisition on transcation details page
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16443)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16443, 'tra_msg_16443' ,'Can not trade more then security held' ,'Can not trade more then security held' , 'en-US', 103008, 104001, 122036, 1, GETDATE())
END

/*
	Script received from Tushar 9 Aug 2016
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 16444)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
    (16444, 'tra_msg_16444', 'Error occurred while checking negative balance for secuirty.', 'Error occurred while checking negative balance for secuirty.', 'en-US', 103008, 104001, 122036, 1, GETDATE())
END


/*
Scripts received from Raghvendra on 13-Apr-2016
Scripts for adding the resources for the button text, labels and messages seen on Insider Dashboard screen
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17429)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17429,'dis_btn_17429','New Pre-clearance Request','en-US',103008,104004,122083,'New Pre-clearance Request',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17430)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17430,'dis_btn_17430','Submit Disclosure','en-US',103008,104004,122083,'Submit Disclosure',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17431)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17431,'dis_btn_17431','Preclearance Requests','en-US',103008,104004,122083,'Preclearance Requests',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17432)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17432,'dis_btn_17432','Trade Details','en-US',103008,104004,122083,'Trade Details',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17433)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17433,'dis_btn_17433','Holding On ','en-US',103008,104004,122083,'Holding On ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17434)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17434,'dis_btn_17434','Disclosures','en-US',103008,104004,122083,'Disclosures',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17435)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17435,'dis_btn_17435','Trading Window','en-US',103008,104004,122083,'Trading Window',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17436)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17436,'dis_lbl_17436','Initial','en-US',103008,104002,122083,'Initial',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17437)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17437,'dis_lbl_17437','Continuous','en-US',103008,104002,122083,'Continuous',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17438)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17438,'dis_lbl_17438','Period End','en-US',103008,104002,122083,'Period End',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17439)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17439,'dis_lbl_17439','Initial Disclosures submitted on ','en-US',103008,104002,122083,'Initial Disclosures submitted on ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17440)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17440,'dis_lbl_17440','Last date of submitting the Initial Disclosures was ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures was ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17441)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17441,'dis_lbl_17441','Last date of submitting the Initial Disclosures is ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures is ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17442)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17442,'dis_lbl_17442','Trading policy not found for the user.','en-US',103008,104002,122083,'Trading policy not found for the user.',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17443)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17443,'dis_lbl_17443','Continuous Disclosure(s) pending for submission','en-US',103008,104002,122083,'Continuous Disclosure(s) pending for submission',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17444)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17444,'dis_lbl_17444','Next submission of Period End Disclosure is from ','en-US',103008,104002,122083,'Next submission of Period End Disclosure is from ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17445)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17445,'dis_lbl_17445','Last date of submitting Period End Disclosure is ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure is ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17446)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17446,'dis_lbl_17446','Last date of submitting Period End Disclosure was ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure was ',1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17447)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17447,'dis_lbl_17447','Period End Disclosure is not required','en-US',103008,104002,122083,'Period End Disclosure is not required',1,GETDATE())
END

/*
Script received from Tushar on 2 May 2016 -- Change for show Total Traded Quantity (Stock Exchange Submission)
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17448)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17448,'dis_grd_17448','Total Traded Quantity','Total Traded Quantity','en-US',103008,104003,122057,1 , GETDATE())
END

/*
Script received from Raghvendra on 11-May-2016 -- 
Added resource for the error message to be shown on the Stock Exchange Submission page. 
The resource can be seen under (Module)Disclosures>(Screen)TransactionLetter on the Resources screen.
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17449)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17449, 'dis_msg_17449', 'Submission Date can not be after today''s date', 'Submission Date can not be after today''s date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17450)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17450, 'dis_msg_17450', 'Please Upload Document', 'Please Upload Document', 'en-Us', 103009, 104001, 122052, 1 , GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17451)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17451, 'dis_msg_17451', 'Enter Submission Date', 'Enter Submission Date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE())
END

/*
Script received from Tushar on 16 May 2016 - 
*/

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17452)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17452,'dis_grd_17452','Policy is accepted','Policy is accepted','en-US',103009,104001,122048,1 , GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 17453)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
    (17453,'dis_grd_17453','Error occurred while fetching initial disclosure details.','Error occurred while fetching initial disclosure details.','en-US',103009,104001,122048,1 , GETDATE())
END


/* Script From ED (Gaurav Ugale) on 05-APR-2016  - SCRIPTS FOR SEPARATION MASS-UPLOAD */

IF NOT EXISTS(SELECT 1 FROM mst_Resource WHERE ResourceId = 50056)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(50056,'mst_lbl_50056','Invalid value provided for LoginId','en-US',103004,104002,122032,'Invalid value provided for LoginId',1,GETDATE())
END

/*
Received from Raghvendra: 21-Mar-2016
Corrected the screen code and module code for the policy document list seen by insiders i.e. not co users
*/
UPDATE mst_Resource SET ModuleCodeId = 103008, ScreenCodeId = 122043 WHERE ResourceId in (15344,15345,15346,15347,15415,15348)


/*
Code sync with ED 25-Apr-2016
*/

IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50057)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50057,'usr_lbl_50057','Depository Name ', 'en-US', 103002, 104002, 122072, 'Depository Name ', 1, GETDATE())	
END

--Demat account note
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50058)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50058,'usr_lbl_50058','1. Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 'en-US', 103002, 104002, 122072, '1. In note we have mentioned: Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '1. Under Depository Name: If you have a demat account, please select NSDL, CDSL. If you have physical shares, select Others' WHERE ResourceId = 50058
	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50059)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50059,'usr_lbl_50059','2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN").', 'en-US', 103002, 104002, 122072, '2. Working should be: If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN")', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP ID Number (DP ID Start with "IN").' WHERE ResourceId = 50059

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50060)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50060,'usr_lbl_50060','3. Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 'en-US', 103002, 104002, 122072, '3. If you have a Demate account with CDSL, Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '3. If you have a Demat account with CDSL, please update your 16 digit Client ID Number (starting 8 digits will be your DP ID number)' WHERE ResourceId = 50060
	
	
IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50061)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50061,'usr_lbl_50061','4. If you have physical shares, select ‚ÄúPhysical Shares‚Äù under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID)', 'en-US', 103002, 104002, 122072, '4. If you have physical shares, select "Physical Shares" under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID) ', 1, GETDATE())	
END	

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '16430')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(16430,'tra_msg_16430', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'en-US', 103008, 104001,122036,1, GETDATE())
END

/* 
Code sync with ED 25-Apr-2016 completed
*/

/* 
Script received from from ED on 11-May-2016
*/

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50062')
BEGIN
	INSERT INTO mst_Resource 
		(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
		(50062, 'tra_lbl_50062', 
		'Note: The number of shares displayed under ìSecuritiesî is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the ìPreclearances / Continuous Disclosuresî webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 
		'en-US', '103008', '104002', '122036', 
		'Note: The number of shares displayed under ìSecuritiesî is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the ìPreclearances / Continuous Disclosuresî webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 1, 
		GETDATE() )
END


/*
	Script ED on 07-June-2016
	by ANIKET SHINGATE (24-MAY-2016) - THIS SCRIPT IS USED TO SAVE VALUES IN mst_Resource TABLES FOR VALIDATION MASSAGE.
*/

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50063')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50063, 'usr_msg_50063', 'The Demat Account Type is required.', 'en-US', 103001, 104001, 122001, 'The Demat Account Type is required.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50064')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50064, 'usr_msg_50064', 'CDSL, Please update your 16 digit Demat Account number.', 'en-US', 103001, 104001, 122001, 'CDSL, Please update your 16 digit Demat Account number.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50065')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50065, 'usr_msg_50065', 'NSDL, please update your 8 digit Demat account number.', 'en-US', 103001, 104001, 122001, 'NSDL, please update your 8 digit Demat account number.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50066')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50066, 'usr_msg_50066', 'DP ID number should start with IN followed by 6 digits.', 'en-US', 103001, 104001, 122001, 'DP ID number should start with IN followed by 6 digits.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50067')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50067, 'usr_msg_50067', 'Client ID Number already exists..', 'en-US', 103001, 104001, 122001, 'Client ID Number already exists.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50068')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50068, 'usr_msg_50068', 'The Depository Participant Name is required.', 'en-US', 103001, 104001, 122001, 'The Depository Participant Name is required.', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50073')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50073, 'usr_msg_50073', 'The DP Name is required.', 'en-US', 103001, 104001, 122001, 'The DP Name is required.', 1, GETDATE())
END

/*
	Script ED on 04-Aug-2016
	Code Merge from SVN "From ED" branch
*/

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50069')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50069, 'rul_lbl_50069', 'Seek declaration from employee regarding possession of UPSI', 'en-US', 103006, 104002, 122040, 'Seek declaration from employee regarding possession of UPSI', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50070')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50070, 'rul_lbl_50070', 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 'en-US', 103006, 104002, 122040, 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50071')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50071, 'rul_lbl_50071', 'Declaration to be Mandatory', 'en-US', 103006, 104002, 122040, 'Declaration to be Mandatory', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50072')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50072, 'rul_lbl_50072', 'Display the declaration post submission of Continuouse Disclosure', 'en-US', 103006, 104002, 122040, 'Display the declaration post submission of Continuouse Disclosure', 1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50074')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50074, 'tra_msg_50074', 'Please select the confirmation checkbox to submit your trade details.', 'en-US', 103008, 104001, 122036, 'Please select the confirmation checkbox to submit your trade details.', 1, GETDATE())
END


/*
Script received from Tushar on 2 May 2016 --  Change for show date in contra trade message
*/
UPDATE mst_Resource
SET ResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.',
    OriginalResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.'
WHERE ResourceId = 17343

/*
Script received from Tushar on 2 May 2016 --  
*/
UPDATE mst_Resource SET ResourceValue = 'Total Traded Value', OriginalResourceValue = 'Total Traded Value'
WHERE ResourceId = 17448




/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Enter new grid types for Disclosure letters for CO and Insider
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114083)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114083 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,83 ,NULL ,NULL ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114084)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114084 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,84 ,NULL ,NULL ,1 ,GETDATE())
END


IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114085)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114085 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,114,'Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,85 ,NULL ,NULL ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114086)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114086 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,86 ,NULL ,NULL ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114087)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114087 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,114 ,'Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,87 ,NULL ,NULL ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114088)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(114088 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,88 ,NULL ,NULL ,1 ,GETDATE())
END


/*
Script received from Gaurishankar on 12 May 2016 -  Code Grid Ids for applicability.
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114089)
BEGIN
	INSERT INTO com_Code(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(114089, 'Applicability Search List - Employee', 114, 'Applicability Search List - Employee', 1, 1, 89, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114090)
BEGIN
	INSERT INTO com_Code(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(114090, 'Applicability association Employee filter list',114,'Applicability association Employee filter list',1,1,90,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114091)
BEGIN
	INSERT INTO com_Code(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(114091, 'Applicability Association - Non Insider Employee List', 114, '0Applicability Association - Non Insider Employee List', 1, 1, 91, NULL, NULL, 1, GETDATE())
END


/*
Script from Parag on 16 May 2016 -  new grid type for employee details for policy document list
*/
IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 114092)
BEGIN
	INSERT INTO com_Code 
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(114092, 'Policy Document Applicability List for Employee NOT Insider', 114, 'Policy Document Applicability List for Employee NOT Insider', 1, 1, 92, NULL, NULL, 1, GETDATE())
END

/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Enter new screen codes for the Transaction Data for Letter screen
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122077)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122077 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,89 ,NULL ,103008 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122078)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122078 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,90 ,NULL ,103008 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122079)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122079 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,122,'Screen - Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,91 ,NULL ,103008 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122080)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122080 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,92 ,NULL ,103008 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122081)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122081 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,93 ,NULL ,103008 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122082)
BEGIN
	INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
	VALUES 
	(122082 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,94 ,NULL ,103008 ,1 ,GETDATE())
END


/*
Scripts received from Raghvendra on 13-Apr-2016
Scripts for adding the resources for the button text, labels and messages seen on Insider Dashboard screen
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 122083)
BEGIN
	INSERT INTO com_Code (CodeId, CodeName,CodeGroupId,Description, IsVisible, IsActive, DisplayOrder,DisplayCode,ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(122083, 'Insider Dashboard',122,'Screen - Insider Dashboard', 1, 1, 95, NULL, 103008, 1, GETDATE())
END

/* 
Received from Tushar: 22 Apr 2016
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 132013)
BEGIN
	INSERT INTO com_Code
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(132013, 'Contra Trade', 132, 'Contra Trade', 1, 1, GETDATE(), 13)
END

/* 22-Mar-2016: Script received from Tushar */
/****************   
GroupId: 175
Trading Contra Trade Option
******************/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 175)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(175, 'Contra Trade Option', 'Contra Trade Without Quantiy(General Option) & Quantity Base', 1, 0)
END


IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 175001)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(175001, 'Contra Trade Without Quantiy(General Option)', 175, 'Contra Trade Without Quantiy(General Option)', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 175002)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(175002, 'Contra Trade Quantiy Base', 175, 'Contra Trade Quantiy Base', 1, 1, GETDATE(), 2)
END

/*Code Integration with ED code on 22-March-2016*/
UPDATE com_Code SET CodeName = 'ESOP' WHERE CodeID = 143003

/* 
Received from Tushar: 23 Mar 2016
Script for Transaction identification code, like PCL,PNT,PNR etc..
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 176)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(176, 'Transaction Identification Code', 'Transaction Identification Code like PCL,PNT,PNR etc.', 1, 0)
END


IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 176001)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(176001, 'PCL', 176, 'This code is Used when Insider taken Preclerance', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 176002)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(176002, 'PNT', 176, 'This code is Used when Insider not taken Preclerance', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 176003)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(176003, 'PNR', 176, 'This code is Used for employee those are non insider', 1, 1, GETDATE(), 3)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 176004)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
	(176004, 'PE', 176, 'This code is Used for Period End Transaction', 1, 1, GETDATE(), 4)
END


/* 
Code sync with ED 25-Apr-2016 started
*/

UPDATE com_Code set CodeName = 'Public Right', Description = 'Mode Of Acquisition - Public Right' where CodeID = '149002'
UPDATE com_Code set CodeName = 'Preferential Offer', Description = 'Mode Of Acquisition - Preferential Offer' where CodeID = '149003'
UPDATE com_Code set CodeName = 'Gift', Description = 'Mode Of Acquisition - Gift' where CodeID = '149004'

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149005)
BEGIN
	INSERT INTO com_Code VALUES
	(149005, 'Inter-se-Transfer', 149, 'Mode Of Acquisition - Inter-se-Transfer',1,1,5,NULL,NULL,1, GETDATE())	
END

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149006)
BEGIN
	INSERT INTO com_Code VALUES
	(149006, 'Conversion of security', 149, 'Mode Of Acquisition - Conversion of security',1,1,6,NULL,NULL,1, GETDATE())
END

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149007)
BEGIN
	INSERT INTO com_Code VALUES
	(149007, 'Scheme of Amalgamation/Merger/Demerger/Arrangement', 149, 'Mode Of Acquisition - Scheme of Amalgamation/Merger/Demerger/Arrangement',1,1,7,NULL,NULL,1, GETDATE())
END

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149008)
BEGIN
	INSERT INTO com_Code VALUES
	(149008, 'Off Market', 149, 'Mode Of Acquisition - Off Market',1,1,8,NULL,NULL,1, GETDATE())
END

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149009)
BEGIN
	INSERT INTO com_Code VALUES
	(149009, 'ESOP', 149, 'Mode Of Acquisition - ESOP',1,1,9,NULL,NULL,1, GETDATE())
END

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149010)
BEGIN
	INSERT INTO com_Code VALUES
	(149010, 'Market Sale', 149, 'Mode Of Acquisition - Market Sale',1,1,10,NULL,NULL,1, GETDATE())
END


/* 
Code sync with ED 25-Apr-2016 completed
*/

/* 
Received from Tushar: 22 Apr 2016
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 177)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
		(177, ' Contra Trade Based On', ' Contra Trade Based On', 1, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 177001)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(177001, 'All Security Type', 177, 'All Security Type', 1, 1, GETDATE(), 1)
END	
	
IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 177002)
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(177002, 'Individual Security Type', 177, 'Individual Security Type', 1, 1, GETDATE(), 2)
END		
	
/*
Script received from Raghvendra on 3-May-2016
Added a new Mode of acquisiton i.e. Bonus. This mode of acquisiton was added as per the request send by Deepak on 2-May-2016 in email.
*/

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 149011)
BEGIN
	INSERT INTO com_Code VALUES (149011, 'Bonus', 149, 'Mode Of Acquisition - Bonus',1,1,11,NULL,NULL,1, GETDATE())
END


/*
Script from Parag on 4-May-2016
Added group and code for auto submit transcation 

GroupId: 178
Auto submit transaction configuration
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 178)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(178, NULL, 'Auto submit transaction', 'Auto submit transaction', 1, 0)
END


IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 178001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(178001, NULL, 'No Auto Submit', NULL, 178, 'No auto submit transaction', 1, 1, GETDATE(), 1)
END	

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 178002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(178002, NULL, 'Auto Submit - Continuous Disclosure from Mass Upload', NULL, 178, 'Auto Submit - Continuous Disclosure from Mass Upload', 1, 1, GETDATE(), 2)
END	
	
/*
Script from Parag on 4-Aug-2016
Added group and code for allowed negative value or not

GroupId: 179
Security configuration for values 
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 179)
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(179, NULL, 'Security Configuraiton - Security values constraint', 'Security Configuraiton - Security values constraint', 1, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 179001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(179001, NULL, 'Allowed positive values only', NULL, 179, 'Allowed positive values only', 1, 1, GETDATE(), 1)
END	
	
IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 179002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(179002, NULL, 'Allowed positive and negative values', NULL, 179, 'Allowed positive and negative values', 1, 1, GETDATE(), 2)
END	
	
	