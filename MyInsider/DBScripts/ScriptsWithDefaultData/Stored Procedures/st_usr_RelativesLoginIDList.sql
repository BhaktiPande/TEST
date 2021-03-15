IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RelativesLoginIDList')
DROP PROCEDURE [dbo].[st_usr_RelativesLoginIDList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list LoginId's of relatives of a user.

Usage:
EXEC st_usr_RelativesLoginIDList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_RelativesLoginIDList] 
	 @UserInfoId					INT
	
AS
BEGIN
 
  SELECT UA.LoginID AS LoginID
		FROM usr_UserRelation UR
		INNER JOIN usr_UserInfo UF  ON UF.UserInfoId = UR.UserInfoIdRelative
		INNER JOIN usr_Authentication UA ON UA.UserInfoID = UR.UserInfoId
		WHERE ur.UserInfoId = @UserInfoId and uf.RelativeStatus = 102001
	
END
GO
