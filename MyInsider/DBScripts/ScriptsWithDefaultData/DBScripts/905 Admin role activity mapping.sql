/*Arundhati 5-Feb 2015*/

/* 
Script to assign all activities to admin role
*/

SET IDENTITY_INSERT usr_RoleMaster ON

INSERT INTO usr_RoleMaster
(RoleId, RoleName, Description, StatusCodeId, LandingPageURL, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
(1, 'AdminRole', 'Role for admin', 106001, '', 1, GETDATE(), 1, GETDATE())

SET IDENTITY_INSERT usr_RoleMaster OFF

INSERT INTO usr_UserRole(UserInfoID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES (1, 1, 1, GETDATE(), 1, GETDATE())


-- This query is moved to script number 907, and also it is modified, now the activities are inserted using UserTypeActivity association table
--INSERT INTO usr_RoleActivity(RoleID, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
--SELECT 1, A.ActivityID, 1, GETDATE(), 1, GETDATE()
--FROM usr_Activity A LEFT JOIN usr_RoleActivity UR ON A.ActivityID = UR.ActivityID AND UR.RoleID = 1 
--WHERE UR.ActivityID IS NULL
--AND A.ActivityID NOT IN (81, 82, 83)
