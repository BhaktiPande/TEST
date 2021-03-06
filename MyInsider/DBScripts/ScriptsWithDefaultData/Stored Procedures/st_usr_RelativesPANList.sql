IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RelativesPANList')
DROP PROCEDURE [dbo].[st_usr_RelativesPANList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list PAN no's of relatives of a user.

Usage:
EXEC st_usr_RelativesPANList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_RelativesPANList]
	 @UserInfoId					INT
	
AS
BEGIN
 
  SELECT uf.PAN AS PAN
		FROM usr_UserRelation UR
		INNER JOIN usr_UserInfo UF  ON UF.UserInfoId = UR.UserInfoIdRelative
		WHERE ur.UserInfoId = @UserInfoId and uf.RelativeStatus = 102001
	
END
