
IF NOT EXISTS(SELECT * FROM usr_Activity WHERE ActivityID = 344)
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, DisplayOrder, CreatedBy,CreatedOn, ModifiedBy,
	ModifiedOn,ApplicableFor) 
	VALUES(344,'Mass Upload','Perform Mass Upload',103013,NULL,'Rights to perform Mass Upload',105001,'',1,GETDATE(),1,GETDATE(),513001)
END

IF NOT EXISTS(SELECT * FROM mst_MenuMaster WHERE MenuID = 72)
BEGIN
	INSERT INTO mst_MenuMaster(MenuID, MenuName, Description, MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn,
					ModifiedBy, ModifiedOn) 
	VALUES (72,'MassUpload','MassUpload','MassUpload/AllMassUpload?acid=344',34,NULL,105001,'icon icon-reports',NULL,344,1, GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 344 AND UserTypeCodeId=101003)
BEGIN					
	INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (344, 101003)
END

IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 344 AND UserTypeCodeId=101004)
BEGIN
	INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (344, 101004)
END

IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 344 AND UserTypeCodeId=101006)
BEGIN
	INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (344, 101006)
END


--CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
--INSERT INTO #RolesByUserType1
--SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
--DECLARE @nCount1 INT = 1
--DECLARE @nTotCount1 INT = 0
--DECLARE @nRoleID1 INT = 0
--SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

--WHILE @nCount1 <= @nTotCount1
--BEGIN
--	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
--	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='344' AND RoleID = @nRoleID1)
--	BEGIN
--			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--			VALUES(344,@nRoleID1,1,GETDATE(),1,GETDATE())
--	END

--	SET @nCount1 = @nCount1 + 1
--	SET @nRoleID1 = 0
--END
--DROP TABLE #RolesByUserType1

CREATE TABLE #RolesByUserType2(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType2
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId not in (101002,101001)
DECLARE @nCount2 INT = 1
DECLARE @nTotCount2 INT = 0
DECLARE @nRoleID2 INT = 0
SELECT @nTotCount2 = COUNT(RoleID) FROM #RolesByUserType2

WHILE @nCount2 <= @nTotCount2
BEGIN
	SET @nRoleID2 = (SELECT RoleID FROM #RolesByUserType2 WHERE ID = @nCount2)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='344' AND RoleID = @nRoleID2)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(344,@nRoleID2,1,GETDATE(),1,GETDATE())
	END

	SET @nCount2 = @nCount2 + 1
	SET @nRoleID2 = 0
END
DROP TABLE #RolesByUserType2

IF NOT EXISTS(SELECT * FROM usr_Activity WHERE ActivityID = 345)
BEGIN
	INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, DisplayOrder, CreatedBy,CreatedOn, ModifiedBy,
	ModifiedOn,ApplicableFor) VALUES(345,'Mass Upload - Other Securities','Perform Mass Upload - Other Securities',103013,NULL,'Rights to perform Mass Upload',105001,'',1,GETDATE(),1,GETDATE(),513002)
END

IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 345 AND UserTypeCodeId=101003)
BEGIN	
	INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101003)
END
IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 345 AND UserTypeCodeId=101004)
BEGIN
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101004)
END
IF NOT EXISTS(SELECT * FROM usr_UserTypeActivity WHERE ActivityId = 345 AND UserTypeCodeId=101006)
BEGIN
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101006)
END


CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType1
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId NOT in (101002,101001)
DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='345' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(345,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1