-- ======================================================================================================
-- Author      : Priyanka Bhangale, Rutuja Purandare													=
-- CREATED DATE: 13-DEC-2016                                                 							=
-- Description : SCRIPTS FOR RESTRICTED LIST SEARCH     
/*Modification History:
	Modified By		Modified On		Description
	Vivek 28-Jul-2017	Added the check if not exists for RLSearchLimit column												=
-- ======================================================================================================
*/
/* INSERT INTO com_CodeGroup */
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 507)
BEGIN
	INSERT INTO com_CodeGroup(CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable, ParentCodeGroupId) 
	VALUES (507,'Allow Restricted List Search','Allow Restricted List Search',1,0,null)
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 185006)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (185006,'Allow Restricted List Search',185,'Allow Restricted List Search',1,1,6,null,null,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 507001)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (507001,'Perpetual',507,'Perpetual',1,1,1,null,null,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 507002)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (507002,'Limited',507,'Limited',1,1,2,null,null,1,GETDATE())
END

/* ADD COLUMN INTO com_CompanySettingConfiguration */
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'com_CompanySettingConfiguration' AND SYSCOL.NAME = 'RLSearchLimit')
BEGIN
	ALTER TABLE com_CompanySettingConfiguration ADD RLSearchLimit INT null
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50380)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50380,'rl_lbl_50380','Allow Restricted List Search','en-US',103301,104002,122091,'Allow Restricted List Search',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50381)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50381,'rl_lbl_50381','Perpetual','en-US',103301,104002,122091,'Perpetual',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50382)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50382,'rl_lbl_50382','Limited','en-US',103301,104002,122091,'Limited',1,GETDATE())
END

/*Insert default value in com_CompanySettingConfiguration*/
IF NOT EXISTS(SELECT ConfigurationCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationCodeId = 185006)
BEGIN
	INSERT INTO [com_CompanySettingConfiguration]([ConfigurationTypeCodeId],[ConfigurationCodeId],[ConfigurationValueCodeId],[ConfigurationValueOptional],[IsMappingCode],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[RLSearchLimit])
	VALUES(180003,185006,507001,null,0,1,GETDATE(),1,GETDATE(),0)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50383)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50383,'rl_msg_50383','You are not allowed to search as you have exceeded the restricted list search limit for today.Please come back tomorrow.','en-US',103301,104001,122091,'You are not allowed to search as you have exceeded the restricted list search limit for today.Please come back tomorrow.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50386)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50386,'rl_lbl_50386','Restricted list limited search','en-US',103301,104002,122091,'Restricted list limited search',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50385)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50385,'rl_msg_50385','Restricted list limited search field must be numeric','en-US',103301,104001,122091,'Restricted list limited search field must be numeric',1,GETDATE())
END

