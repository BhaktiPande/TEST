-- ======================================================================================================
-- Author      : Novit Magare
-- CREATED DATE: 08-May-2019
-- Description : Script for Other Security Report Functionality.
-- ======================================================================================================

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Other Security Report' and UPPER(ActivityName)='VIEW')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Other Security Report','View','103011',NULL,'Other Security Report Details',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
	END
END

--INSERT SCRIPT FOR mst_MenuMaster
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE UPPER(MenuName) ='Other Security Report' and ParentMenuID='36')
	BEGIN
		INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		(SELECT MAX(MenuID) + 1 from mst_MenuMaster),'Other Security Report','Other Security Report',
		'/Reports_OS/Index?acid=326',3509,36,513001,NULL,NULL,326,1,GETDATE(),1,GETDATE()  
	)			
END

--INSERT SCRIPT FOR usr_RoleActivity
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='326' AND RoleID ='1')
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(326,1,1,GETDATE(),1,GETDATE())
	END

----INSERT SCRIPT FOR usr_RoleActivity
--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='326' AND RoleID ='3')
--	BEGIN			
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(326,3,1,GETDATE(),1,GETDATE())	
--	END

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
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='326' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(326,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1



IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'INDEX') AND (UPPER(ControllerName) = 'Reports_OS'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(326,'Reports_OS','Index',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51004)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51004,'usr_lbl_51004','Initial Disclosures','en-US',103011,104002, 122058,'Initial Disclosures',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51005)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51005,'usr_lbl_51005','Pre Clearance','en-US',103011,104002, 122058,'Pre Clearance',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51006)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51006,'usr_lbl_51006','Continous Disclosures','en-US',103011,104002, 122058,'Continous Disclosures',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51007)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51007,'usr_lbl_51007','Period End Disclosures','en-US',103011,104002, 122058,'Period End Disclosures',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51008)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51008,'usr_lbl_51008','Defaulter','en-US',103011,104002, 122058,'Defaulter',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51009)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51009,'usr_lbl_51009','Transaction From','en-US',103011,104002, 122058,'Transaction From',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51010)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51010,'usr_lbl_51010','Transaction To','en-US',103011,104002, 122058,'Transaction To',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51011)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51011,'usr_lbl_51011','Other Security Report','en-US',103011,104002, 122058,'Other Security Report',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51012)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51012,'usr_msg_51012','No data available to download','en-US',103011,104001, 122058,'No data available to download',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51013)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51013,'rpt_ttl_51013','Other Securities Reports','en-US',103011,104006, 122058,'Other Securities Reports',1,GETDATE())
END

