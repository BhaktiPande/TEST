USE [MyInsider_OwnSecurities]
GO
/****** Object:  StoredProcedure [dbo].[st_usr_RelativesPANList]    Script Date: 16-12-2020 10:12:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list PAN no's of relatives of a user.

Usage:
EXEC st_usr_RelativesPANList
-------------------------------------------------------------------------------------------------*/

CREATE OR ALTER PROCEDURE [dbo].[st_usr_RelativesPANList]
	 @UserInfoId					INT
	
AS
BEGIN
 
  SELECT uf.PAN AS PAN
		FROM usr_UserRelation UR
		INNER JOIN usr_UserInfo UF  ON UF.UserInfoId = UR.UserInfoIdRelative
		WHERE ur.UserInfoId = @UserInfoId and uf.RelativeStatus = 102001
	
END
