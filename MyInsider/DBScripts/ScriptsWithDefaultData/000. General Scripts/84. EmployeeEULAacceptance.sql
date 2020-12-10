-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 10-June-2019
-- Description : Script for Employee EULA acceptance
-- ======================================================================================================
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 180005)
BEGIN			
	INSERT INTO com_Code VALUES(180005,'Employee EULA Acceptance Settings',180,'Employee EULA Acceptance Settings',1,1,5,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS(SELECT * FROM com_CodeGroup WHERE CodeGroupID = 523)
BEGIN
	INSERT INTO com_CodeGroup VALUES(523,'EULA Reconfirmation Setting','EULA Reconfirmation Setting',1,1,NULL)
END

IF NOT EXISTS(SELECT * FROM com_Code WHERE CodeID = 523001)
BEGIN
	INSERT INTO com_Code VALUES(523001,'All',523,'EULA Reconfirmation Setting-All',1,1,1,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM com_Code WHERE CodeID = 523002)
BEGIN
	INSERT INTO com_Code VALUES(523002,'Not Accepted',523,'EULA Reconfirmation Setting-Not Accepted',1,1,2,NULL,NULL,1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53098)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53098,'cmp_lbl_53098','Employee EULA acceptance','en-US',103005,104002,122084,'Employee EULA acceptance',1,GETDATE())
END

IF NOT EXISTS (SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180005)
BEGIN
	INSERT INTO [dbo].[com_CompanySettingConfiguration] VALUES (180005, 180005, 186002, NULL, 0 ,1 ,GETDATE() ,1 ,GETDATE(), 0)
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 132021)
BEGIN			
	INSERT INTO com_Code VALUES(132021,'EULA Acceptance Document',132,'Map To Type - EULA Acceptance Document',1,1,21,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53099)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53099,'cmp_lbl_53099','Required Reconfirmation','en-US',103005,104002,122084,'Required Reconfirmation',1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 180006)
BEGIN			
	INSERT INTO com_Code VALUES(180006,'Required EULA Reconfirmation',180,'Required EULA Reconfirmation',1,1,6,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS (SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180006)
BEGIN
	INSERT INTO [dbo].[com_CompanySettingConfiguration] VALUES (180006, 180006, 523001, NULL, 0 ,1 ,GETDATE() ,1 ,GETDATE(), 0)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53100)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53100,'cmp_lbl_53100','Yes','en-US',103005,104002,122084,'Yes',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53101)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53101,'cmp_lbl_53101','No','en-US',103005,104002,122084,'No',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53102)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53102,'cmp_lbl_53102','Employee EULA Acceptance Settings','en-US',103005,104002,122084,'Employee EULA Acceptance Settings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53103)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53103,'cmp_msg_53103','Please upload EULA acceptance document.','en-US',103005,104001,122084,'Please upload EULA acceptance document.',1,GETDATE())
END

--INSERT SCRIPT FOR EULA Acceptance Report on usr_Activity	
IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Report' and UPPER(ActivityName)='EULA Acceptance Report')
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(331,'Report','EULA Acceptance Report','103011',NULL,'View right to EULA Acceptance Report',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (331,'101001')
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (331,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='331' AND RoleID =1)
BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(331,1,1,GETDATE(),1,GETDATE())
END

--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='331' AND RoleID =3)
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(331,3,1,GETDATE(),1,GETDATE())
--END

CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType1
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002)
DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='331' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(331,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1

--INSERT SCRIPT FOR EULA Acceptance on usr_Activity	
IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='EULA Acceptance' and UPPER(ActivityName)='EULA Acceptance View')
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(334,'EULA Acceptance','EULA Acceptance View','103002',NULL,'View right to EULA Acceptance Page',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (334,'101003')
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (334,'101004')
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (334,'101006')
END


--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='334' AND RoleID =2)
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(334,2,1,GETDATE(),1,GETDATE())
--END
--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='334' AND RoleID =4)
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(334,4,1,GETDATE(),1,GETDATE())
--END
--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='334' AND RoleID =5)
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(334,5,1,GETDATE(),1,GETDATE())
--END

CREATE TABLE #RolesByUserType(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101003,101004,101006)
DECLARE @nCount INT = 1
DECLARE @nTotCount INT = 0
DECLARE @nRoleID INT = 0
SELECT @nTotCount = COUNT(RoleID) FROM #RolesByUserType

WHILE @nCount <= @nTotCount
BEGIN
	SET @nRoleID = (SELECT RoleID FROM #RolesByUserType WHERE ID = @nCount)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='334' AND RoleID = @nRoleID)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(334,@nRoleID,1,GETDATE(),1,GETDATE())
	END

	SET @nCount = @nCount + 1
	SET @nRoleID = 0
END
DROP TABLE #RolesByUserType




IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53104)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53104,'cmp_lbl_53104','User Consent','en-US',103005,104002,122084,'User Consent',1,GETDATE())
END

IF NOT EXISTS(SELECT ID FROM com_GlobalRedirectToURL WHERE ID = 8)
BEGIN
	INSERT INTO com_GlobalRedirectToURL VALUES(8,'UserDetails','ShowUserConsent','acid,334',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53105)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53105,'cmp_lbl_53105','All','en-US',103005,104002,122084,'All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53106)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53106,'cmp_lbl_53106','Require acceptancy','en-US',103005,104002,122084,'Not Accepted',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53107)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53107,'cmp_msg_53107','I have read the terms and conditions as mentioned above.','en-US',103005,104001,122084,'I have read the terms and conditions as mentioned above.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53108)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53108,'cmp_btn_53108','AGREE','en-US',103005,104004,122084,'AGREE',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53109)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53109,'cmp_btn_53109','DISAGREE','en-US',103005,104004,122084,'DISAGREE',1,GETDATE())
END
--EULA Acceptance report 
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 114125)
BEGIN			
	INSERT INTO com_Code VALUES(114125,'EULA Acceptance Report',114,'EULA Acceptance Report',1,1,122,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = 122110)
BEGIN			
	INSERT INTO com_Code VALUES(122110,'EULA Acceptance Report',122,'Screen - EULA Acceptance Report',1,1,119,NULL,NULL,1,GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53110)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53110,'rpt_grd_53110','Sr. No','en-US',103011,104003,122110,'Sr. No',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53111)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53111,'rpt_grd_53111','User ID / Login ID','en-US',103011,104003,122110,'User ID / Login ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53112)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53112,'rpt_grd_53112','Employee Name','en-US',103011,104003,122110,'Employee Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53113)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53113,'rpt_grd_53113','Date of Acceptance','en-US',103011,104003,122110,'Date of Acceptance',1,GETDATE())
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114125 AND ResourceKey = 'rpt_grd_53110')--Sr. No
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114125, 'rpt_grd_53110', 1, 1, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114125 AND ResourceKey = 'rpt_grd_53111')--Login ID
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114125, 'rpt_grd_53111', 1, 2, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114125 AND ResourceKey = 'rpt_grd_53112')--Employee Name
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114125, 'rpt_grd_53112', 1, 3, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114125 AND ResourceKey = 'rpt_grd_53113')--Date of Acceptance
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114125, 'rpt_grd_53113', 1, 4, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53114)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53114,'rpt_grd_53114','Employee ID','en-US',103011,104002,122110,'Employee ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53115)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53115,'rpt_grd_53115','EULA Acceptance Date','en-US',103011,104002,122110,'EULA Acceptance Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53116)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53116,'rpt_ttl_53116','EULA Acceptance Report','en-US',103011,104006,122110,'EULA Acceptance Report',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_MenuMaster WHERE MenuID = 68)
BEGIN
	INSERT INTO mst_MenuMaster VALUES(68,'EULA Acceptance Report','EULA Acceptance Report',	'/Reports/UserEULAAcceptance?acid=331',	3510,36,102001,	NULL,NULL,331,1,GETDATE(),1,GETDATE())
END