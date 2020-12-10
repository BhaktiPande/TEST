SET IDENTITY_INSERT usr_UserInfo ON

INSERT INTO usr_UserInfo (UserInfoId, FirstName, MobileNumber, UserTypeCodeId, StatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES(1, 'Administrator', '12345', 101001, 102001, 1, GETDATE(), 1, GETDATE())

SET IDENTITY_INSERT usr_UserInfo OFF
--------------------------------------------

INSERT INTO usr_Authentication(UserInfoID, LoginID, Password, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES(1, 'admin', 'OftX6y+kdYiqznbqmTGh5O7hSkE1NSSPOIAP6pg0', 1, GETDATE(), 1, GETDATE())

--------------------------------------------


--------------------------------------------

--INSERT INTO mst_MenuMaster(MenuID, MenuName, Description, MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
--VALUES(1, 'User', 'User Menu', NULL, 0, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
--	(2, 'CR User', 'CR User', NULL, 1, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE())

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (27, '027 AdminUser_Create', 'To add first user', 'Arundhati')
