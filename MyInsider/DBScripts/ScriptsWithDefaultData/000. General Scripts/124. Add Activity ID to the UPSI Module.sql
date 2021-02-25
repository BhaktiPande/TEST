

BEGIN		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='UPSI Submission' and UPPER(ActivityName)='VIEW' and ActivityID=361)
	BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(361,'UPSI Submission','View','103304',NULL,'UPSI Submission',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (344,'101002')
	END
END


BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='UPSI Submission' and UPPER(ActivityName)='VIEW' and ActivityID=362)
	BEGIN	
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(362,'UPSI Submission','View','103304',NULL,'UPSI Submission',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (362,'101003')
	END
END

update mst_MenuMaster set MenuURL='/UpsiDigital/Index?acid=362',MenuName='UPSI Sharing',ActivityID=362 where MenuID=64


IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 73)
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(73 ,'Upsi','Upsi Sharing','/UpsiDigital/Index?acid=361',5001,NULL,102001,'icon icon-users',NULL,361,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'INDEX') AND (UPPER(ControllerName) = 'UpsiDigital') AND ActivityID=361)
BEGIN			
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(361,'UpsiDigital','Index',NULL,1,getdate(),1,getdate())	
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'INDEX') AND (UPPER(ControllerName) = 'UpsiDigital') AND ActivityID=362)
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(362,'UpsiDigital','Index',NULL,1,getdate(),1,getdate())		
END

CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType1
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='361' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(361,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1



CREATE TABLE #RolesByUserType(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId not in (101002,101001)
DECLARE @nCount INT = 1
DECLARE @nTotCount INT = 0
DECLARE @nRoleID INT = 0
SELECT @nTotCount = COUNT(RoleID) FROM #RolesByUserType

WHILE @nCount <= @nTotCount
BEGIN
	SET @nRoleID = (SELECT RoleID FROM #RolesByUserType WHERE ID = @nCount)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='362' AND RoleID = @nRoleID)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(362,@nRoleID,1,GETDATE(),1,GETDATE())
	END

	SET @nCount = @nCount + 1
	SET @nRoleID = 0
END
DROP TABLE #RolesByUserType

