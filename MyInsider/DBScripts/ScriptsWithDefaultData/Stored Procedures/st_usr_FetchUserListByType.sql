SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_FetchUserListByType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_usr_FetchUserListByType]
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure will return the list of the user siwth given user type. This procedure is used in Mass upload of 
				the Insiders for fetching the Login names for the users which is used for generating the HashCode for the user
				when user is created.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		03-Dec-2016

Modification History:
Modified By		Modified On		Description

Usage:
DECLARE @RC int
EXEC st_usr_CreateHashCodesForUsers
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_FetchUserListByType] 
	@inp_nUserTypeCodeId		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS

BEGIN

	BEGIN TRY
		SET NOCOUNT ON;
		
		SELECT A.UserInfoId, A.LoginId FROM usr_Authentication A join usr_UserInfo UI ON UI.UserInfoId = A.UserInfoId WHERE UI.UserTypeCodeId = @inp_nUserTypeCodeId
					
		SELECT @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue = @out_nSQLErrCode
		RETURN @out_nReturnValue
	END CATCH
END