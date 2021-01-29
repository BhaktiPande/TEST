INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, DisplayOrder, CreatedBy,CreatedOn, ModifiedBy,
	ModifiedOn,ApplicableFor) VALUES(345,'Mass Upload - Other Securities','Perform Mass Upload - Other Securities',103013,NULL,'Rights to perform Mass Upload',105001,'',1,GETDATE(),1,GETDATE(),513002)

INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101003)
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101004)
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (345, 101006)


INSERT INTO usr_RoleActivity(ActivityID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) VALUES (345,7,1,GETDATE(),1,GETDATE())