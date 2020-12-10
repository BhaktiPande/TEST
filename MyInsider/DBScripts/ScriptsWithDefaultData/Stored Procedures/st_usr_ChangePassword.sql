SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_ChangePassword]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_usr_ChangePassword]
GO
/*******************************************************************************************************************
Description	: To change password.

Returns		: 0, if Success.
				
Created by	: Swapnil M.
Created on	: 11-Mar-2015

Usage:
	declare @retval int 
	EXEC @retval = st_usr_ChangePassword '3','',''
	print @retval	

Modified By		Modified On	    Description
Swapnil M		17-Mar-2015		added checks for Password management with old and new password.
Swapnil M		18-Mar-2015		Added new if else condition for handling change passsword method from both change passsword page and set password apge.
Swapnil M		23-Mar-2015		Added condition while cheecking user exisst .
Raghvendra		1-July-2015		Added a condition to fetch the userinfo id from the code provided and use it to update the password.
								Also same user info id will be returned.
Raghvendra		3-July-2015		Added condition to check if the user modifying the password is active or inactive.
Raghvendra		13-July-2015	Handling the case when changing the password from user login screen. To handle the case when old password 
								not equal to new password.Added error code when old password entered by user doesnot match with that saved in DB.
Raghvendra		3-Dec-2015		Change to delete the entry from usr_UserResetPassword after the Password is changed.																
*******************************************************************************************************************/
CREATE PROCEDURE [dbo].[st_usr_ChangePassword]
	@inp_iUserInfoID		INT,
	@inp_sOldPassword		VARCHAR(255),
	@inp_sNewPassword		VARCHAR(255) , 
	@inp_sHashValue			VARCHAR(255),
	@inp_sSaltValue			NVARCHAR(200),
	@out_nUpdatedUserId		INT OUTPUT,		--The userinfo id for whom the password change has happened.
	@out_nReturnValue		INT = 0 OUTPUT,  
	@out_nSQLErrCode		INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	-- declare variables
	DECLARE @ERR_CHANGEPASSWORD		INT,
			@ERR_PASSWORDDONOTMATCH INT,
			@ERR_SAMEPASSWORD		INT,
			@ERR_USERNOTEXISTS		INT,
			@ERR_INVALIDLINK		INT,
			@sOldPassword			VARCHAR(255),
			@iUserInfoID			INT,
			@ERR_USERINACTIVE		INT,
			@ERR_OLDPASSWORDINVALID INT,
			@PASSWORDCOUNT          INT,
			@COUNT                  INT,
			@EVENTCODEID_PASSWORDCHNAGED  INT,
			@EVENT_MAPTOTYPECODEID        INT
	
	DECLARE @USERINACTIVE_CODE INT = 102002		
	-- init variables
	SELECT @ERR_CHANGEPASSWORD		= 12045,
		   @ERR_PASSWORDDONOTMATCH  = 12047,
		   @ERR_USERNOTEXISTS		= 11025,
		   @ERR_SAMEPASSWORD		= 12046,
		   @ERR_INVALIDLINK			= 11257,
		   @ERR_USERINACTIVE		= 11273,
		   @ERR_OLDPASSWORDINVALID  = 11278,
		   @EVENTCODEID_PASSWORDCHNAGED   = 153049,
		   @EVENT_MAPTOTYPECODEID         = 132019

	BEGIN try 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		
		SELECT @out_nUpdatedUserId = @inp_iUserInfoID
		
		IF (EXISTS(select A.UserInfoID from usr_Authentication A JOIN usr_UserInfo U ON U.UserInfoID = A.UserInfoID AND U.StatusCodeId = @USERINACTIVE_CODE and A.UserInfoID = @inp_iUserInfoID AND @inp_iUserInfoID <> 0))
		BEGIN
			SET @out_nReturnValue = @ERR_USERINACTIVE
			RETURN @out_nReturnValue
		END
		
		IF (NOT EXISTS(select UserInfoID from usr_Authentication where UserInfoID = @inp_iUserInfoID) AND @inp_iUserInfoID <> 0)
		BEGIN
			SET @out_nReturnValue = @ERR_USERNOTEXISTS
			RETURN @out_nReturnValue
		END		
		
		SELECT	@sOldPassword = AU.Password
		FROM	usr_Authentication AU 
		WHERE	AU.UserInfoID = @inp_iUserInfoID
		
		SELECT @PASSWORDCOUNT = CountOfPassHistory  FROM usr_PasswordConfig
		SELECT @COUNT= COUNT(*) FROM usr_PasswordHistory WHERE UserId=@inp_iUserInfoID

		IF @inp_sOldPassword <> '' OR @inp_sOldPassword<> NULL
		BEGIN
			print(1)
			IF @sOldPassword <> @inp_sOldPassword
			BEGIN
			print(11)
				SET @out_nReturnValue = @ERR_OLDPASSWORDINVALID
				RETURN @out_nReturnValue
			END
			
			-- check old password with user entered old password.
			-- if match update new password
			-- else raise error.
			IF(@PASSWORDCOUNT<>0)
			BEGIN
			IF(@sOldPassword <> @inp_sNewPassword)
			BEGIN
					IF(@sOldPassword = @inp_sOldPassword)
					BEGIN 				
						-- update password.
						UPDATE	usr_Authentication			
						SET		Password   = @inp_sNewPassword,
								SaltValue=@inp_sSaltValue,
								ModifiedBy = @inp_iUserInfoID,
								ModifiedOn = GETDATE()
						WHERE	UserInfoID = @inp_iUserInfoID
						
						--INSERT INTO PASSWORD HISTORY TABLE
							IF(@COUNT = @PASSWORDCOUNT)
							BEGIN
								WITH T AS (SELECT TOP 1 * FROM   usr_PasswordHistory WHERE UserId = @inp_iUserInfoID order by ID asc)
								DELETE FROM T 
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())
							END
							ELSE 
							BEGIN
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())
							END
					END 
					ELSE
					BEGIN 			
						SET @out_nReturnValue = @ERR_PASSWORDDONOTMATCH
						RETURN @out_nReturnValue 
					END 
			END
			ELSE
			BEGIN
					SET @out_nReturnValue = @ERR_SAMEPASSWORD
					RETURN @out_nReturnValue
			END
			END
			ELSE
			BEGIN
				UPDATE	usr_Authentication			
				SET		Password   = @inp_sNewPassword,
						SaltValue=@inp_sSaltValue,
					ModifiedBy = @inp_iUserInfoID,
					ModifiedOn = GETDATE()
				WHERE	UserInfoID = @inp_iUserInfoID
			END
		END		
		ELSE IF @inp_sOldPassword = '' OR @inp_sOldPassword IS NULL
		BEGIN 
		print(2)
				IF(NOT EXISTS(SELECT URP.UserInfoId FROM usr_UserResetPassword URP WHERE URP.HashCode = @inp_sHashValue))
				BEGIN
					SET @out_nReturnValue = @ERR_INVALIDLINK
					RETURN @out_nReturnValue	
				END
				ELSE
				BEGIN
					SELECT  @iUserInfoID = URP.UserInfoId
					FROM	usr_UserResetPassword URP
					WHERE   URP.HashCode = @inp_sHashValue
					
					SELECT @out_nUpdatedUserId = @iUserInfoID
					
					IF (EXISTS(select A.UserInfoID from usr_Authentication A JOIN usr_UserInfo U ON U.UserInfoID = A.UserInfoID AND U.StatusCodeId = @USERINACTIVE_CODE and A.UserInfoID = @out_nUpdatedUserId AND @inp_iUserInfoID <> 0))
					BEGIN
						SET @out_nReturnValue = @ERR_USERINACTIVE
						RETURN @out_nReturnValue
					END
					
					UPDATE	usr_Authentication			
					SET		Password   = @inp_sNewPassword,
							SaltValue=@inp_sSaltValue,
							ModifiedBy = @iUserInfoID
					WHERE	UserInfoID = @iUserInfoID	
					
					--INSERT INTO PASSWORD HISTORY TABLE
					IF(@PASSWORDCOUNT<>0)
					BEGIN
							IF(@COUNT = @PASSWORDCOUNT)
							BEGIN
								WITH T AS (SELECT TOP 1 * FROM   usr_PasswordHistory WHERE UserId = @inp_iUserInfoID order by ID asc)
								DELETE FROM T 
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())

							END
							ELSE 
							BEGIN
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())

							END
					END
				END
		END
		ELSE
		BEGIN 
		print(3)
				UPDATE	usr_Authentication			
				SET		Password   = @inp_sNewPassword,
						SaltValue =@inp_sSaltValue,
						ModifiedBy = @inp_iUserInfoID
				WHERE	UserInfoID = @inp_iUserInfoID
				--INSERT INTO PASSWORD HISTORY TABLE
							IF(@COUNT = @PASSWORDCOUNT)
							BEGIN
								WITH T AS (SELECT TOP 1 * FROM   usr_PasswordHistory WHERE UserId = @inp_iUserInfoID order by ID asc)
								DELETE FROM T 
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())

							END
							ELSE 
							BEGIN
								INSERT INTO usr_PasswordHistory(UserId,[Password],[SaltValue],LastUpdatedBy,LastUpdatedOn)
								VALUES(@inp_iUserInfoID,@inp_sNewPassword,@inp_sSaltValue,@inp_iUserInfoID,GETDATE())

							END	
		END
		DELETE FROM usr_UserResetPassword WHERE UserInfoID = @out_nUpdatedUserId
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END try 
	BEGIN catch
		-- Return common error if required, otherwise specific error.	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_CHANGEPASSWORD,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END catch
END
