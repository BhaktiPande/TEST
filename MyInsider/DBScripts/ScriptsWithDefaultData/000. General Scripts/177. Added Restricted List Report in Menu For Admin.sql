IF NOT EXISTS(SELECT 1 FROM usr_RoleActivity WHERE ActivityID=201 AND RoleID=1)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(201,1,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityID=210 AND UserTypeCodeId=101001)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(210,101001)
END
IF NOT EXISTS(SELECT 1 FROM usr_UserTypeActivity WHERE ActivityID=210 AND UserTypeCodeId=101002)
BEGIN
	INSERT INTO usr_UserTypeActivity VALUES(210,101002)
END

IF NOT EXISTS(SELECT 1 FROM usr_RoleActivity WHERE ActivityID=210 AND RoleID=1)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(210,1,1,GETDATE(),1,GETDATE())
END
IF NOT EXISTS(SELECT 1 FROM usr_RoleActivity WHERE ActivityID=210 AND RoleID=6)
BEGIN
	INSERT INTO usr_RoleActivity VALUES(210,6,1,GETDATE(),1,GETDATE())
END
