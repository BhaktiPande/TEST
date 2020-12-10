
-- =============================================
-- Author		: Priyanka Wani
-- Create date	: 07 April 2017
-- Description	: This SP is used to Create new GUID as CookieName and set its timeout for 20 mins or extend its timeout by 20 mins. 
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetCookieStatus')
	DROP PROCEDURE st_usr_GetCookieStatus
GO

CREATE PROCEDURE st_usr_GetCookieStatus --'admin','6ED9279A-D0BA-4DE1-B323-D6FD93A9DC8A~MONDAY',0,0
	@inp_UserId				VARCHAR(20),
	@inp_CookieName			NVARCHAR(500) = NULL,
	@inp_isNew				BIT,
	@inp_isUpdateCookie		BIT,
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
	
	DECLARE @NewCookieName NVARCHAR(500) = CONVERT(VARCHAR(100), NEWID()) + '~' + (SELECT UPPER(DATENAME(dw,GETDATE())))
	
   
	DECLARE @validationMsgText												VARCHAR(200)
	
	SELECT @validationMsgText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'com_lbl_14027'
	
	IF (@inp_CookieName='LOGOUT')
	BEGIN
		DELETE FROM usr_UserSessions WHERE  UserName = @inp_UserId
	END 
	ELSE
	BEGIN
		IF (@inp_isNew = 1)
		BEGIN
			IF NOT EXISTS (SELECT USERNAME FROM usr_UserSessions WHERE UserName = @inp_UserId)
			BEGIN			
				--Print 'For new user'
				DELETE FROM usr_UserSessions WHERE  UserName = @inp_UserId
				
				INSERT INTO usr_UserSessions VALUES
				(@inp_UserId, @NewCookieName, (select DATEADD(MINUTE,20, GETDATE())))
			END
			
			ELSE
			BEGIN
				SET @out_sSQLErrMessage	=  @validationMsgText
				SET @out_nReturnValue=1
				RETURN 1
			END
		END
		
		ELSE		
		BEGIN
			--Print 'For existing user'
		   
			IF(@inp_isUpdateCookie=1)
			BEGIN
			UPDATE 
				usr_UserSessions 
			SET 
				CookieName = @NewCookieName,
				ExpireOn = (select DATEADD(MINUTE,20, GETDATE()))
			WHERE 
				UserName = @inp_UserId AND CookieName = @inp_CookieName
			END
			ELSE
			BEGIN
			SET @NewCookieName=@inp_CookieName
			END
		END
	END
		SELECT TOP 1 * FROM usr_UserSessions WHERE UserName = @inp_UserId AND CookieName = @NewCookieName ORDER BY EXPIREON DESC
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
