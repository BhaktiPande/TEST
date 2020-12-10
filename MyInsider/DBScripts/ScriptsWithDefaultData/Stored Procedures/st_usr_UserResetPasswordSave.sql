IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserResetPasswordSave')
DROP PROCEDURE [dbo].[st_usr_UserResetPasswordSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the UserResetPassword details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		18-Mar-2015

Modification History:
Modified By		Modified On		Description
Swapnil M		19-Mar-2015		Added method to get UserInfoId From LoginId .
Swapnil M		19-Mar-2015		removed @ERR_USERRESETPASSWORD_NOTFOUND entry.
Swapnil M		19-Mar-2015		Added Commnets, Email validation check and added select statement.
Raghvendra		03-July-2015	Added the condition to check if user is active before requesting password change.
Raghvendra		10-Jul-2015		Changed the error code sent when invalid email address provided by user when 
								requesting forgot password request.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserResetPasswordSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserResetPasswordSave] 
	@inp_iLoginId			VARCHAR(255),
	@inp_sHashCode			NVARCHAR(400),
	@inp_sEmailID			NVARCHAR(400),
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERRESETPASSWORD_SAVE		INT	
	DECLARE @ERR_USERDOESNOTEXIST			INT
	DECLARE @ERR_INCORRECTEMAILID			INT
	DECLARE @UserPasswordID					INT
	DECLARE @iUserPasswordId				INT
	DECLARE @iUserInfoID					INT
	DECLARE @sEmailID						NVARCHAR(400)
	DECLARE @ERR_USERINACTIVE		INT
	
	DECLARE @USERINACTIVE_CODE INT = 102002	
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_USERRESETPASSWORD_SAVE		= 11255,
				@ERR_USERDOESNOTEXIST			= 11272,
				@ERR_INCORRECTEMAILID			= 11272,
				@ERR_USERINACTIVE				= 11273
		
		IF (EXISTS(select A.UserInfoID from usr_Authentication A JOIN usr_UserInfo U ON U.UserInfoID = A.UserInfoID AND U.StatusCodeId = @USERINACTIVE_CODE and A.LoginId = @inp_iLoginId))
		BEGIN
			SET @out_nReturnValue = @ERR_USERINACTIVE
			RETURN @out_nReturnValue
		END
				
		--TO get UserInfoID From LoginID.
		SELECT @iUserInfoID = UserInfoId from usr_Authentication where LoginID = @inp_iLoginId
		IF(@iUserInfoID IS NULL)
		BEGIN		
			SET @out_nReturnValue = @ERR_USERDOESNOTEXIST
			RETURN @out_nReturnValue
		END		
			
		-- To get registed EmailID from usr_UserInfo table.
		SELECT @sEmailID = EmailId FROM usr_UserInfo WHERE UserInfoId = @iUserInfoID
		IF(@sEmailID <> @inp_sEmailID)
		BEGIN
			SET @out_nReturnValue = @ERR_INCORRECTEMAILID
			RETURN @out_nReturnValue
		END
		
		-- To get Running UserPasswordId from table .
		SELECT @iUserPasswordId = MAX(UserPasswordId) FROM usr_UserResetPassword 	
	    IF(@iUserPasswordId IS NULL)
			BEGIN
				SET @iUserPasswordId = 1
			END				
		ELSE
			BEGIN
				SET @iUserPasswordId = @iUserPasswordId + 1
			END
	
		IF(NOT EXISTS(SELECT UserPasswordId FROM usr_UserResetPassword WHERE UserInfoId = @iUserInfoID))
		BEGIN
			Insert into usr_UserResetPassword
					  (UserPasswordId,
						UserInfoId,
						HashCode,
						CreatedOn)
			Values    (@iUserPasswordId,
						@iUserInfoID,
						@inp_sHashCode,
						dbo.uf_com_GetServerDate() )
		END
		ELSE
		BEGIN			
			Update	usr_UserResetPassword
			Set		HashCode = @inp_sHashCode,
					CreatedOn = dbo.uf_com_GetServerDate()				
			Where	UserInfoId = @iUserInfoID 
		END		
		
		SELECT @sEmailID     as EmailID,
			   @iUserInfoID  as UserInfoID,
			   @inp_iLoginId as LoginID
			   
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERRESETPASSWORD_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END