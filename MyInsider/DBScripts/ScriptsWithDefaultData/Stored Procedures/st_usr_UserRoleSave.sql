IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserRoleSave')
DROP PROCEDURE [dbo].[st_usr_UserRoleSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the roles for a user

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		05-Mar-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserRoleSave]
	@inp_iUserInfoId		INT,
    @inp_sRoleIdList		VARCHAR(500),
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the UserInfo
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERROLE_SAVE INT = 11226 -- Error occurred while saving roles for user.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @ERR_USERTYPENOTVALIDFORROLES INT = 11227 -- User type is not valid for saving role.

	--DECLARE @nUserTypeCode_Employee INT = 101003
	--DECLARE @nUserTypeCode_NonEmployee INT = 101006
	DECLARE @nUserTypeCode_Relative INT = 101007
	--DECLARE @nRetValue INT
	DECLARE @nUserTypeCodeId INT
	DECLARE @tmpRoles TABLE(RoleId INT, IsExist INT DEFAULT 1, IsValid INT DEFAULT 1)
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		INSERT INTO @tmpRoles(RoleId)
		SELECT items FROM dbo.uf_com_Split(@inp_sRoleIdList)

		SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId
		
		UPDATE RTmp
		SET IsExist = 0
		FROM @tmpRoles RTmp LEFT JOIN usr_RoleMaster RM ON RTmp.RoleId = RM.RoleId
		WHERE RM.RoleId IS NULL

		UPDATE RTmp
		SET IsValid = 0
		FROM @tmpRoles RTmp JOIN usr_RoleMaster RM ON RTmp.RoleId = RM.RoleId
		WHERE UserTypeCodeId <> @nUserTypeCodeId
		
		--Save the UserInfo details
		-- Check that the user exists for which the relative's record is to be added
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		-- Check the type of user is Employee or non employee for which the relative's record is being added
		IF (EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId AND UserTypeCodeId = @nUserTypeCode_Relative))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERTYPENOTVALIDFORROLES
			RETURN (@out_nReturnValue)
		END
		
		DELETE UR
		FROM usr_UserRole UR LEFT JOIN @tmpRoles tRl ON UR.RoleID = tRl.RoleId
		WHERE tRl.RoleId IS NULL AND UR.UserInfoID = @inp_iUserInfoId
		
		INSERT INTO usr_UserRole(UserInfoID, RoleID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT @inp_iUserInfoId, tRoles.RoleId, @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate()
		FROM @tmpRoles tRoles LEFT JOIN usr_UserRole UR ON tRoles.RoleId = UR.RoleID AND UR.UserInfoID = @inp_iUserInfoId
		WHERE UR.RoleID IS NULL		
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERROLE_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END