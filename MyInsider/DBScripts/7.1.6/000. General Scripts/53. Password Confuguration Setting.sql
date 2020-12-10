-- ======================================================================================================
-- Author      : Priyanka Bhangale												=
-- CREATED DATE: 17-JUL-2017                                                 							=
-- Description : SCRIPTS FOR PASSWORD CONFIGURATION FUNCTIONALITY     												=
-- ======================================================================================================

/*INSERT INTO COM_CODE-INSERT MODULE CODE*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 103302)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (103302,'Password Configuration',103,'Resource Module - Password Configuration',1,1,302,NULL,NULL,1,GETDATE())
END

/*INSERT SCRIPT FOR usr_Activity*/	
BEGIN
	DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Password Configuration' and UPPER(ActivityName)='Enable Password Configuration')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Password Configuration','Enable Password Configuration','103302',NULL,'Rights to Enable Password Configuration',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
END

/*INSERT SCRIPT FOR mst_MenuMaster*/
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE UPPER(MenuName) ='Password Configuration' and ParentMenuID='1')
	BEGIN
		INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		(SELECT MAX(MenuID) + 1 from mst_MenuMaster),'Password Configuration','Password Configuration',
		'/PasswordConfiguration/Index?acid=224',1500,1,102001,NULL,NULL,224,1,GETDATE(),1,GETDATE()  
	)			
END

/*INSERT SCRIPT FOR usr_RoleActivity*/
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='224' AND RoleID ='1')
BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(224,1,1,GETDATE(),1,GETDATE())
END

/*INSERT INTO COM_CODE-INSERT SCREEN CODE*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122096)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (122096,'Screen - Password Configuration',122,'Screen - Password Configuration',1,1,107,NULL,103302,1,GETDATE())
END

/*INSERT INTO MST_RESOURCE*/
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50555')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50555,'pc_ttl_50555','Password Configuration','en-US','103302','104006','122096','Password Configuration',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50556')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50556,'pc_lbl_50556','Minimum Length','en-US','103302','104002','122096','Minimum Length',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50557')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50557,'pc_lbl_50557','Maximum Length','en-US','103302','104002','122096','Maximum Length',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50558')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50558,'pc_lbl_50558','Minimum Alphabets','en-US','103302','104002','122096','Minimum Alphabets',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50559')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50559,'pc_lbl_50559','Minimum Numbers','en-US','103302','104002','122096','Minimum Numbers',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50560')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50560,'pc_lbl_50560','Minimum Special Character','en-US','103302','104002','122096','Minimum Special Character',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50561')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50561,'pc_lbl_50561','Minimum Upper Case Character','en-US','103302','104002','122096','Minimum Upper Case Character',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50562')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50562,'pc_lbl_50562','Count Of Password History','en-US','103302','104002','122096','Count Of Password History',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50563')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50563,'pc_lbl_50563','Password Validity','en-US','103302','104002','122096','Password Validity',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50564')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50564,'pc_lbl_50564','Expiry Reminder Before','en-US','103302','104002','122096','Expiry Reminder Before',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50565')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50565,'pc_msg_50565','If value is 0(zero) then the corresponding feature is disabled.','en-US','103302','104001','122096','If value is 0(zero) then the corresponding feature is disabled.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50566')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50566,'pc_btn_50566','Save','en-US','103302','104004','122096','Save',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50567')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50567,'pc_btn_50567','Reset','en-US','103302','104004','122096','Reset',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50568')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50568,'pc_btn_50568','Login Attempts','en-US','103302','104004','122096','Login Attempts',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50569')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50569,'pc_msg_50569','Your password will expire in $1 days (Valid till-$2). Please change your password','en-US','103302','104001','122096','Your password will expire in $1 days (Valid till-$2). Please change your password',1,GETDATE())
END

--INSERT INTO com_GlobalRedirectToURL
IF NOT EXISTS(SELECT ID FROM com_GlobalRedirectToURL WHERE ID = 6)
BEGIN
	INSERT INTO com_GlobalRedirectToURL([ID],[Controller],[Action],[Parameter],[ModifiedBy],[ModifiedOn])
	VALUES (6,'UserDetails','ChangePassword','acid,84',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50570')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50570,'pc_msg_50570','Your password has expired. Please change your password.','en-US','103302','104001','122096','Your password will expire in $1 days (Valid till-$2). Please change your password',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50571')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50571,'pc_msg_50571','Password Configuration saved successfully','en-US','103302','104001','122096','Password Configuration saved successfully',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50572')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50572,'pc_msg_50572','Minimun Length is not less than 4','en-US','103302','104001','122096','Minimun Length is not less than 4',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50573')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50573,'pc_msg_50573','Maximum Length should be greater than minimum length','en-US','103302','104001','122096','Maximum Length should be greater than minimum length',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50574')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50574,'pc_msg_50574','Login Attempts can not be zero','en-US','103302','104001','122096','Login Attempts can not be zero',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50575')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50575,'pc_msg_50575','Sum of alphabet, numbers, special characters and upper case should be equal to or more than minimum length and less than or equal to maximum length','en-US','103302','104001','122096','Sum of alphabet, numbers, special characters and upper case should be equal to or more than minimum length and less than or equal to maximum length',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50596')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(505796,'pc_msg_50596','Expiry reminder can not be greater than password validity','en-US','103302','104001','122096','Expiry reminder can not be greater than password validity',1,GETDATE())
END