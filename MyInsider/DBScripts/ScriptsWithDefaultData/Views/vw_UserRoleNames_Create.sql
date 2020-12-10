IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_UserRoleNames]'))
DROP VIEW [dbo].[vw_UserRoleNames]
GO

CREATE VIEW [dbo].[vw_UserRoleNames]
AS
SELECT UR.UserInfoID,
STUFF((
          SELECT ',' + Rm.RoleName
          FROM usr_UserRole URIn JOIN usr_RoleMaster RM
          ON URIn.RoleID = RM.RoleId
          WHERE URIn.UserInfoID = UR.UserInfoID
          ORDER BY RoleName
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS RoleName,
',' + STUFF((
          SELECT ',' + CONVERT(VARCHAR(10),URIn.RoleId)
          FROM usr_UserRole URIn
          WHERE URIn.UserInfoID = UR.UserInfoID
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') + ',' AS RoleIds
FROM usr_UserRole UR
GROUP BY UR.UserInfoID
