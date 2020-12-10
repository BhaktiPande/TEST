
-- =============================================
-- Author		: Shubhangi Gurude
-- Create date	: 07 April 2017
-- Description	: This SP is used to Create new GUID as CookieName and set its timeout for 20 mins or extend its timeout by 20 mins. 
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SaveFormTokenStatus')
	DROP PROCEDURE st_usr_SaveFormTokenStatus
GO

CREATE PROCEDURE st_usr_SaveFormTokenStatus --'admin','6ED9279A-D0BA-4DE1-B323-D6FD93A9DC8A~MONDAY',0,0
	@inp_UserId				VARCHAR(20),
	@inp_FormId				INT,	
	@inp_TokenName			NVARCHAR(500) = NULL,
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
	
			
			IF NOT EXISTS (SELECT UserInfoId FROM usr_UserWiseFormTokenList WHERE UserInfoId = @inp_UserId and FormId=@inp_FormId and TokenName= @inp_TokenName)
			BEGIN			
				--Print 'For new user'
				DELETE FROM usr_UserWiseFormTokenList WHERE  UserInfoId = @inp_UserId and FormId=@inp_FormId 
				
				INSERT INTO usr_UserWiseFormTokenList VALUES
				(@inp_UserId,@inp_FormId, @inp_TokenName, (select DATEADD(MINUTE,20, GETDATE())))
			END		
			
		SELECT TOP 1 * FROM usr_UserWiseFormTokenList WHERE UserInfoId = @inp_UserId  and FormId=@inp_FormId ORDER BY ExpireOn DESC
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
