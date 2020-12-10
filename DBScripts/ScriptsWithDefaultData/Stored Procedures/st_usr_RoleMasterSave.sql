IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleMasterSave')
DROP PROCEDURE [dbo].[st_usr_RoleMasterSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the RoleMaster details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		16-Feb-2015
Modification History:
Modified By		Modified On		Description
Gaurishankar	13-Jul-2015		Added check for Role Name Already exists
Gaurishankar	16-Jul-2015		Fix for Bug id = 7909 the "Is Default?" field is not required for Demo so the field is hide from UI also the field value is set 0 
Raghvendra	07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_RoleMasterSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_RoleMasterSave] 
	@inp_iRoleId			INT,
	@inp_sRoleName			NVARCHAR(200),
	@inp_sDescription		NVARCHAR(510),
	@inp_iStatusCodeId		INT,
	@inp_iUserTypeCodeId	INT,
	@inp_iIsDefault			INT,
	@inp_iLoggedInUserId	INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_ROLEMASTER_SAVE INT
	DECLARE @ERR_ROLEMASTER_NOTFOUND INT
	DECLARE @ERR_CANNOTMAKENONDEFAULT INT
	DECLARE @ERR_ROLEMASTER_ROLE_NAME_EXISTS INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_ROLEMASTER_NOTFOUND = 12002,
				@ERR_ROLEMASTER_SAVE = 12008,
				@ERR_CANNOTMAKENONDEFAULT = 12026,
				@ERR_ROLEMASTER_ROLE_NAME_EXISTS = 12052 -- Role Name Already exists.
				
		IF EXISTS(SELECT RoleId FROM usr_RoleMaster 
					WHERE RoleName = @inp_sRoleName AND (@inp_iRoleId = 0 OR RoleId != @inp_iRoleId))
		BEGIN
			SET @out_nReturnValue = @ERR_ROLEMASTER_ROLE_NAME_EXISTS
			RETURN @out_nReturnValue
		END
		
		--Please comment the code SET @inp_iIsDefault = 0 WHEN IsDefault field is shown to UI
		SET @inp_iIsDefault = 0 
		
		--Save the RoleMaster details
		IF @inp_iRoleId = 0
		BEGIN
			/* The following code is commented to fix the bug id = 7909 
				the "Is Default?" field is not required for Demo so the field is hide from UI
				
			IF NOT EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId = @inp_iUserTypeCodeId AND IsDefault = 1)
			BEGIN
				SET @inp_iIsDefault = 1
			END
			
			*/
			Insert into usr_RoleMaster(
					RoleName,
					Description,
					StatusCodeId,
					--LandingPageURL,
					UserTypeCodeId,
					IsDefault,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			Values (
					@inp_sRoleName,
					@inp_sDescription,
					@inp_iStatusCodeId,
					--@inp_sLandingPageURL,
					@inp_iUserTypeCodeId,
					@inp_iIsDefault,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
					SELECT @inp_iRoleId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the RoleMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE RoleId = @inp_iRoleId))		
			BEGIN
				SET @out_nReturnValue = @ERR_ROLEMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
			END
			/* The following code is commented to fix the bug id = 7909 
				the "Is Default?" field is not required for Demo so the field is hide from UI
				
			-- Check that the IsDefault is not getting set to false
			IF @inp_iIsDefault = 0 
				AND NOT EXISTS (SELECT RoleId FROM usr_RoleMaster 
								WHERE UserTypeCodeId = @inp_iUserTypeCodeId AND RoleId <> @inp_iRoleId AND IsDefault = 1)
			BEGIN
				SET @out_nReturnValue = @ERR_CANNOTMAKENONDEFAULT
				RETURN (@out_nReturnValue)			
			END
			*/
			Update usr_RoleMaster
			Set 	RoleName = @inp_sRoleName,
					Description = @inp_sDescription,
					StatusCodeId = @inp_iStatusCodeId,
					--LandingPageURL = @inp_sLandingPageURL,
					UserTypeCodeId = @inp_iUserTypeCodeId,
					IsDefault = @inp_iIsDefault,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			Where RoleId = @inp_iRoleId	
			
		END
		
		IF @inp_iIsDefault = 1
		BEGIN
			UPDATE usr_RoleMaster SET IsDefault = 0 WHERE RoleId <> @inp_iRoleId AND UserTypeCodeId = @inp_iUserTypeCodeId
		END
		-- in case required to return for partial save case.
		Select RoleId, RoleName, Description, StatusCodeId, LandingPageURL, UserTypeCodeId
			From usr_RoleMaster
			Where RoleId = @inp_iRoleId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_ROLEMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END