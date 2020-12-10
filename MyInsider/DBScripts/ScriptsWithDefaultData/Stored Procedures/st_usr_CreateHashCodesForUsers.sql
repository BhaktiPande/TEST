SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_CreateHashCodesForUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_usr_CreateHashCodesForUsers]
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure will be used for inserting Hash codes for users created in bulk during mass upload

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		03-Dec-2016

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_CreateHashCodesForUsers
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_CreateHashCodesForUsers] 
	@inp_tblEmployeeHashCode EmployeeHashCode READONLY,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS

BEGIN

	DECLARE @sLoginId VARCHAR(100)
	DECLARE @sHashCode VARCHAR(max)
	DECLARE @nUserInfoId INT
	DECLARE @iUserPasswordId INT
	BEGIN TRY
		SET NOCOUNT ON;
		
		DECLARE User_Cursor CURSOR FAST_FORWARD FOR
		
		SELECT * FROM @inp_tblEmployeeHashCode

		OPEN User_Cursor 
		
		FETCH NEXT FROM User_Cursor INTO @sLoginId, @sHashCode	
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		SELECT @iUserPasswordId = MAX(UserPasswordId) FROM usr_UserResetPassword 	
	    IF(@iUserPasswordId IS NULL)
		BEGIN
			SET @iUserPasswordId = 1
		END				
		ELSE
		BEGIN
			SET @iUserPasswordId = @iUserPasswordId + 1
		END
			
		SELECT @nUserInfoId = UserInfoId FROM usr_Authentication WHERE LoginID =  @sLoginId
		IF EXISTS(SELECT * FROM usr_UserResetPassword UR JOIN usr_Authentication UA ON UR.UserInfoId = UA.UserInfoId WHERE UA.LoginID =  @sLoginId)
		BEGIN
			DELETE FROM usr_UserResetPassword WHERE UserInfoId = @nUserInfoId
		END
		
		INSERT INTO usr_UserResetPassword (UserPasswordId,UserInfoId, CreatedOn, HashCode) VALUES(@iUserPasswordId,@nUserInfoId, dbo.uf_com_GetServerDate(),@sHashCode )
		
		FETCH NEXT FROM User_Cursor INTO @sLoginId, @sHashCode
		END
		
		CLOSE User_Cursor
		DEALLOCATE User_Cursor
		
		SET @out_nReturnValue = 0
		select 1
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue = @out_nSQLErrCode
		RETURN @out_nReturnValue
	END CATCH
END