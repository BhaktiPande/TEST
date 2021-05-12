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