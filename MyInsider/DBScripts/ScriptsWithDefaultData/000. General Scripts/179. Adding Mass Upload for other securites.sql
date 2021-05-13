IF NOT EXISTS(select 1 from usr_Activity where ActivityID = 345)
BEGIN
	Insert INTO usr_Activity Values(345,'Mass Upload - Other Securities','Perform Mass Upload - Other Securities',103013,NULL,'Rights to perform Mass Upload',105001,'',1,GETDATE(),1,GETDATE(),513002)
END
IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityId = 345 and UserTypeCodeId=101003)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(345,101003)
END
IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityId = 345 and UserTypeCodeId=101004)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(345,101004)
END
IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityId = 345 and UserTypeCodeId=101006)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(345,101006)
END

IF NOT EXISTS(SELECT 1 FROM mst_MenuMaster WHERE MenuID = 73)
BEGIN
	INSERT INTO mst_MenuMaster VALUES(73,'MassUpload','MassUpload','MassUpload/AllMassUpload?acid=345',34,NULL,105001,'icon icon-reports',NULL,345,1,GETDATE(),1,GETDATE())
END

----Adding Role In roledetail UI for visible/editable  1=AdminRole,6=Compliance Officer,7=Designated Person 
---So options will come for editing in perticular role.
IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityId = 345 AND RoleID=6)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(345,6,6,GETDATE(),6,GETDATE())
END
IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityId = 345 AND RoleID=7)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(345,7,6,GETDATE(),6,GETDATE())
END
IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityId = 345 AND RoleID=1)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(345,1,6,GETDATE(),6,GETDATE())
END

---1,6,7 is not fixed in usr_RoleActivity 3 is for CO in Saurabh database
IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityId = 345 AND RoleID=3)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(345,3,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityId = 345 and UserTypeCodeId=101002)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(345,101002)
END
--MassUpload For Own Comming so removed one data of mass upload so it not comming for edit.
DELETE FROM usr_UserTypeActivity WHERE ActivityId=9 and UserTypeCodeId=101002 