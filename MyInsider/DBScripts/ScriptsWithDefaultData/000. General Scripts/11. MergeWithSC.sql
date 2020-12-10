/*	Start: Changes Made Soft-corner since 11-Apr2016  */

/*
Scripts received from Raghvendra on 13-Apr-2016
Scripts for adding the resources for the button text, labels and messages seen on Insider Dashboard screen
*/
IF NOT EXISTS (SELECT CodeId FROM com_Code WHERE CodeId = 122083)
BEGIN
	INSERT INTO com_Code (CodeId, CodeName,CodeGroupId,Description, IsVisible, IsActive, DisplayOrder,DisplayCode,ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(122083, 'Insider Dashboard',122,'Screen - Insider Dashboard', 1, 1, 95, NULL, 103008, 1, GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17429)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17429,'dis_btn_17429','New Pre-clearance Request','en-US',103008,104004,122083,'New Pre-clearance Request',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17430)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17430,'dis_btn_17430','Submit Disclosure','en-US',103008,104004,122083,'Submit Disclosure',1,GETDATE())
END	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17431)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17431,'dis_btn_17431','Preclearance Requests','en-US',103008,104004,122083,'Preclearance Requests',1,GETDATE())
END		

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17432)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17432,'dis_btn_17432','Trade Details','en-US',103008,104004,122083,'Trade Details',1,GETDATE())
END	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17433)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17433,'dis_btn_17433','Holding On ','en-US',103008,104004,122083,'Holding On ',1,GETDATE())
END	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17434)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17434,'dis_btn_17434','Disclosures','en-US',103008,104004,122083,'Disclosures',1,GETDATE())
END	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17435)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17435,'dis_btn_17435','Trading Window','en-US',103008,104004,122083,'Trading Window',1,GETDATE())
END
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17436)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17436,'dis_lbl_17436','Initial','en-US',103008,104002,122083,'Initial',1,GETDATE())
END	
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17437)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17437,'dis_lbl_17437','Continuous','en-US',103008,104002,122083,'Continuous',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17438)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17438,'dis_lbl_17438','Period End','en-US',103008,104002,122083,'Period End',1,GETDATE())
END	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17439)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17439,'dis_lbl_17439','Initial Disclosures submitted on ','en-US',103008,104002,122083,'Initial Disclosures submitted on ',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17440)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17440,'dis_lbl_17440','Last date of submitting the Initial Disclosures was ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures was ',1,GETDATE())
END	
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17441)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17441,'dis_lbl_17441','Last date of submitting the Initial Disclosures is ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures is ',1,GETDATE())
END
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17442)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17442,'dis_lbl_17442','Trading policy not found for the user.','en-US',103008,104002,122083,'Trading policy not found for the user.',1,GETDATE())
END
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17443)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17443,'dis_lbl_17443','Continuous Disclosure(s) pending for submission','en-US',103008,104002,122083,'Continuous Disclosure(s) pending for submission',1,GETDATE())
END
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17444)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17444,'dis_lbl_17444','Next submission of Period End Disclosure is from ','en-US',103008,104002,122083,'Next submission of Period End Disclosure is from ',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17445)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17445,'dis_lbl_17445','Last date of submitting Period End Disclosure is ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure is ',1,GETDATE())
END	
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17446)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17446,'dis_lbl_17446','Last date of submitting Period End Disclosure was ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure was ',1,GETDATE())
END
	
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17447)
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES 
	(17447,'dis_lbl_17447','Period End Disclosure is not required','en-US',103008,104002,122083,'Period End Disclosure is not required',1,GETDATE())
END	
	
/*	End: Changes Made Soft-corner since 11-Apr2016  */


BEGIN TRAN
 UPDATE rul_TradingPolicySecuritywiseLimits  SET ValueOfShares = '999999.0000' where TradingPolicyId >= 3 AND ValueOfShares IS NOT NULL
 SELECT * FROM rul_TradingPolicy
 SELECT * FROM rul_TradingPolicySecuritywiseLimits where TradingPolicyId >= 3 AND ValueOfShares is not null
 SELECT * FROM rul_TradingPolicySecuritywiseLimits 
COMMIT TRAN