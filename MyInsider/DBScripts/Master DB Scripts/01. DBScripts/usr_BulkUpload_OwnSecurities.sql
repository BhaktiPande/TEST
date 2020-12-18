INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, DisplayOrder, CreatedBy,CreatedOn, ModifiedBy,
	ModifiedOn,ApplicableFor) VALUES(337,'Mass Upload','Perform Mass Upload',103013,NULL,'Rights to perform Mass Upload',105001,'',1,GETDATE(),1,GETDATE(),513001)

INSERT INTO mst_MenuMaster(MenuID, MenuName, Description, MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn,
					ModifiedBy, ModifiedOn) VALUES (71,'MassUpload','MassUpload','MassUpload/AllMassUpload?acid=337',34,NULL,105001,'icon icon-reports',NULL,337,1,
					GETDATE(),1,GETDATE())
					
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (337, 101003)
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (337, 101004)
INSERT INTO usr_UserTypeActivity(ActivityId, UserTypeCodeId) VALUES (337, 101006)


INSERT INTO usr_RoleActivity(ActivityID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) VALUES (337,7,1,GETDATE(),1,GETDATE())

