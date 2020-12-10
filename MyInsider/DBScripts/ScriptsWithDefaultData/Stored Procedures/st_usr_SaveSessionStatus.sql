
-- =============================================
-- Author		: Shubhangi Gurude
-- Create date	: 07 April 2017
-- Description	: This SP is used to Create new GUID as CookieName and set its timeout for 20 mins or extend its timeout by 20 mins. 
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SaveSessionStatus')
	DROP PROCEDURE st_usr_SaveSessionStatus
GO

CREATE PROCEDURE st_usr_SaveSessionStatus --'admin','6ED9279A-D0BA-4DE1-B323-D6FD93A9DC8A~MONDAY',0,0
	@inp_UserId				VARCHAR(20),
	@inp_CookieName			NVARCHAR(500) = NULL,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,			-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
	
   
	DECLARE @validationMsgText												VARCHAR(200)
	
	SELECT @validationMsgText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'com_lbl_14027'
	
			IF(@inp_CookieName ='CheckValidLogin')
			BEGIN
				SELECT UserInfoId as UserId,CookieName FROM usr_UserCookies WHERE UserInfoId = @inp_UserId 
			END
			ELSE IF(@inp_CookieName ='FromLogin')
			BEGIN
				SELECT UserInfoId as UserId,CookieName FROM usr_UserValidSession WHERE UserInfoId = @inp_UserId 
			END
			ELSE
			BEGIN
				
				IF NOT EXISTS (SELECT UserInfoId FROM usr_UserValidSession WHERE UserInfoId = @inp_UserId)
				BEGIN			
					--Print 'For new user'
					DELETE FROM usr_UserValidSession WHERE  UserInfoId = @inp_UserId
				
					INSERT INTO usr_UserValidSession VALUES
					(@inp_UserId, @inp_CookieName)
				END			
			
				SELECT UserInfoId as UserId,CookieName FROM usr_UserValidSession WHERE UserInfoId = @inp_UserId 

			END
			
			
	SET NOCOUNT OFF;
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  'Error while returning Cookie status'
	END CATCH
END
GO
