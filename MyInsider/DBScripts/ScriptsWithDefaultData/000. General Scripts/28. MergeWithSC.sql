/*
	Script from Raghvendra on 17-May-2016
	Change to increase the field size for the column PreClrUPSIDeclaration in table rul_TradingPolicy to allow user to save text upto 5000 characters.
*/

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rul_TradingPolicy' AND COLUMN_NAME = 'PreClrUPSIDeclaration')
BEGIN
	ALTER TABLE rul_TradingPolicy ALTER COLUMN PreClrUPSIDeclaration VARCHAR(5000) NULL
END
GO



/*
	Script from Tushar on 18 May 2016
	Description :-  Alter Table tra_TransactionMaster Add Column DisplayRollingNumber
*/
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tra_TransactionMaster' AND COLUMN_NAME = 'DisplayRollingNumber')
BEGIN
	ALTER TABLE tra_TransactionMaster ADD DisplayRollingNumber BIGINT NULL
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
Script received from Tushar on 16 May 2016 - 
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17452)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17452,'dis_grd_17452','Policy is accepted','Policy is accepted','en-US',103009,104001,122048,1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17453)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17453,'dis_grd_17453','Error occurred while fetching initial disclosure details.','Error occurred while fetching initial disclosure details.','en-US',103009,104001,122048,1 , GETDATE())
END
	



IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16433)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16433 ,'tra_msg_16433' ,'Error occured while saving user details for transaction details submitted' ,'Error occured while saving user details for transaction details submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16433)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16434 ,'tra_msg_16434' ,'Error occured while saving user details for form submitted' ,'Error occured while saving user details for form submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END


/*
Script from Parag on 16 May 2016 -  new grid type for employee details for policy document list
*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114092)
BEGIN
	INSERT INTO com_Code 
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(114092, 'Policy Document Applicability List for Employee NOT Insider', 114, 'Policy Document Applicability List for Employee NOT Insider', 1, 1, 92, NULL, NULL, 1, GETDATE())
END


/*
Script from Parag on 16 May 2016 -  resources for grid type for employee details for policy document list
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16435)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16435, 'tra_lbl_16435' ,'Employee' ,'Employee' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16436)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16436, 'tra_lbl_16436' ,'Employee ID' ,'Employee ID' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16437)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16437, 'tra_lbl_16437' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16438)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16438, 'tra_grd_16438' ,'Employee Id' ,'Employee Id' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16439)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16439, 'tra_grd_16439' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16440)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16440, 'tra_grd_16440' ,'Designation' ,'Designation' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16441)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16441, 'tra_grd_16441' ,'Document Viewed' ,'Document Viewed' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END		

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16442)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16442, 'tra_grd_16442' ,'Document Accepted' ,'Document Accepted' , 'en-US', 103008, 104002, 122043, 1, GETDATE())
END




/*
Script from Parag on 16 May 2016 -  Grid heaader for employee details for policy document list
*/
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114092)
BEGIN
	INSERT INTO com_GridHeaderSetting
		(GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES
		(114092, 'tra_grd_16438', 1, 1, 0, 155001, NULL ,NULL),
		(114092, 'tra_grd_16439', 1, 2, 0, 155001, NULL ,NULL),
		(114092, 'tra_grd_16440', 1, 3, 0, 155001, NULL ,NULL),
		(114092, 'tra_grd_16441', 1, 4, 0, 155001, NULL ,NULL),
		(114092, 'tra_grd_16442', 1, 5, 0, 155001, NULL ,NULL)
END


/*
Script from Parag on 17 May 2016 - hide column "E-Mail sent Date" from list 
*/
update com_GridHeaderSetting set IsVisible = 0 where GridTypeCodeId = 114048 and ResourceKey = 'dis_grd_17250'



/*
Script from Parag on 25 May 2016 -  resources for error message for security post acquisition on transcation details page
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16443)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES
		(16443, 'tra_msg_16443' ,'Can not trade more then security held' ,'Can not trade more then security held' , 'en-US', 103008, 104001, 122036, 1, GETDATE())
END


/*
	Delete existing primary key on userinfo column and added primary key on userinfo and security type 
	This change is done because now we stroe all security for user
*/

-- remove existing primary key 
ALTER TABLE tra_ExerciseBalancePool DROP CONSTRAINT PK_tra_ExerciseBalancePool
GO

ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT PK_tra_ExerciseBalancePool PRIMARY KEY (UserInfoId, SecurityTypeCodeId)
GO