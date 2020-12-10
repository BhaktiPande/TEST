
-- ======================================================================================================
-- Author      : Rohit Katkar
-- CREATED DATE: 22-08-2019
-- Description : Script for Configuration of shared by on UPSISetting Functionality.
-- ======================================================================================================

--Add Screen

----com_CodeGroup entry for UPSI Setting Open--
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 192)
BEGIN
	INSERT INTO com_CodeGroup ([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES(192,'UPSI Settings','UPSI Settings',1,1,NULL)
END
----com_CodeGroup entry for UPSI Setting close--

----Com code entry for UPSI Setting Open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 180007)
BEGIN
	INSERT INTO com_Code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES(180007,'UPSI Settings',180,'UPSI Settings',1,1,7,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192001)
BEGIN
	INSERT INTO com_Code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES(192001,'Yes',192,'Yes',1,1,1,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192002)
BEGIN
	INSERT INTO com_Code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES(192002,'No',192,'No',1,1,1,NULL,NULL,1,GETDATE())
END
----Com code entry for grid close--


--Add new reourcekey for "UPSI Setting"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55081)
BEGIN
	INSERT INTO mst_Resource ([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES(55081,'usr_lbl_55081','UPSI Settings','en-US',103005,104002,122084,'UPSI Settings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55082)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55082,'cmp_lbl_55082','Yes','en-US',103005,104002,122084,'Yes',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55083)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55083,'cmp_lbl_55083','No','en-US',103005,104002,122084,'No',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55084)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55084,'cmp_lbl_55084','Information Shared by','en-US',103005,104002,122084,'Information Shared by',1,GETDATE())
END
--mst Resource entry close--

--Add new Company Configuration Setting 
IF NOT EXISTS(SELECT ConfigurationTypeCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180007)
BEGIN
	INSERT INTO com_CompanySettingConfiguration([ConfigurationTypeCodeId],[ConfigurationCodeId],[ConfigurationValueCodeId],[ConfigurationValueOptional],[IsMappingCode],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[RLSearchLimit])
	VALUES(180007,	180007,	192001,	NULL,	0	,1	,GETDATE(),	1,	GETDATE(),	NULL)
END
-- com CompanySettingConfiguration close

