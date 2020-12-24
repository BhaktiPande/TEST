USE [MyInsider_OwnSecurities]
GO

/****** Object:  StoredProcedure [dbo].[st_usr_RelativesUsernameList]    Script Date: 15-12-2020 06:50:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list LoginId's of relatives of a user.

Usage:
EXEC st_usr_RelativesLoginIDList
-------------------------------------------------------------------------------------------------*/

CREATE OR ALTER PROCEDURE [dbo].[st_usr_RelativesLoginIDList] 
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
